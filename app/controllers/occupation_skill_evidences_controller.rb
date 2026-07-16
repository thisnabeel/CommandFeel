class OccupationSkillEvidencesController < ApplicationController
  before_action :ensure_signed_in
  before_action :set_occupation_skill, only: %i[index create]
  before_action :set_evidence, only: %i[update destroy resume_bullet]

  # GET /occupation_skills/:occupation_skill_id/occupation_skill_evidences
  def index
    scope = @occupation_skill.occupation_skill_evidences.includes(:user).newest_first
    scope = scope.where(user: current_user) unless User.is_admin?(current_user)

    render json: scope, each_serializer: OccupationSkillEvidenceSerializer
  end

  # GET /occupations/:occupation_id/my_approved_evidences
  # Returns occupation_skill_ids where the current user has approved evidence.
  def approved_for_occupation
    ids = current_user.occupation_skill_evidences
                      .joins(:occupation_skill)
                      .where(approved: true, occupation_skills: { occupation_id: params[:occupation_id] })
                      .distinct
                      .pluck(:occupation_skill_id)

    render json: ids
  end

  # GET /occupation_skill_evidences/mine_approved?occupation_id=&cohort_id=
  # Learner resume-bullets inbox: own approved evidences with skill/cohort context.
  def mine_approved
    scope = current_user.occupation_skill_evidences
                        .includes(
                          :cohort,
                          :evidence_bullets,
                          occupation_skill: [:skill, :occupation, { occupation_skill: :skill }]
                        )
                        .where(approved: true)
                        .newest_first

    if params[:occupation_id].present?
      scope = scope.joins(:occupation_skill)
                   .where(occupation_skills: { occupation_id: params[:occupation_id] })
    end

    if params[:cohort_id].present?
      scope = scope.where('cohort_id IS NULL OR cohort_id = ?', params[:cohort_id])
    end

    render json: scope, each_serializer: OccupationSkillEvidenceSerializer
  end

  # GET /occupation_skill_evidences/pending?cohort_id=
  # Admin inbox: unapproved evidence for skills under the cohort's occupations.
  def pending
    unless User.is_admin?(current_user)
      return render json: { error: 'Unauthorized' }, status: :unauthorized
    end

    cohort = Cohort.find(params[:cohort_id])
    occupation_ids = cohort.cohort_users.where.not(occupation_id: nil).distinct.pluck(:occupation_id)
    skill_ids = OccupationSkill.where(occupation_id: occupation_ids).pluck(:id)

    evidences = OccupationSkillEvidence
                .includes(:user, :cohort, occupation_skill: [:skill, :occupation])
                .where(approved: false, occupation_skill_id: skill_ids.presence || [0])
                .where('cohort_id IS NULL OR cohort_id = ?', cohort.id)
                .newest_first

    render json: evidences, each_serializer: OccupationSkillEvidenceSerializer
  end

  # POST /occupation_skill_evidences/:id/resume_bullet
  # Generate one resume bullet from approved evidence + skill/cohort/occupation context.
  def resume_bullet
    unless @evidence.user_id == current_user.id || User.is_admin?(current_user)
      return render json: { error: 'Unauthorized' }, status: :unauthorized
    end

    unless @evidence.approved?
      return render json: { error: 'Evidence must be approved first' }, status: :unprocessable_entity
    end

    os = @evidence.occupation_skill
    cohort = @evidence.cohort
    occupation_title = params[:occupation_title].presence || os&.occupation&.title
    cohort_title = params[:cohort_title].presence || cohort&.title
    cohort_subtitle = params[:cohort_subtitle].presence || cohort&.subtitle
    cohort_description = params[:cohort_description].presence || cohort&.description
    date_range = if cohort&.start_date || cohort&.end_date
                   [cohort.start_date, cohort.end_date].compact.map(&:to_s).join(' – ')
                 end

    prompt = <<~PROMPT
      You are writing a single strong LinkedIn / resume bullet point for a professional in training.

      TARGET ROLE / OCCUPATION:
      #{occupation_title.presence || 'Not specified'}

      PROGRAM / COHORT:
      Title: #{cohort_title.presence || 'Not specified'}
      Subtitle: #{cohort_subtitle.presence || 'N/A'}
      Description: #{cohort_description.presence || 'N/A'}
      Dates: #{date_range.presence || 'N/A'}

      SKILL CONTEXT:
      Skill name: #{os&.display_title.presence || 'Skill'}
      Skill breadcrumb (full path in occupation skill tree): #{os&.breadcrumb.presence || os&.display_title}

      APPROVED EVIDENCE (what the learner actually did / demonstrated):
      #{@evidence.body}

      MENTOR / ADMIN COMMENT ON THIS EVIDENCE:
      #{@evidence.comment.presence || 'None'}

      INSTRUCTIONS:
      - Write exactly ONE resume bullet point
      - Start with a strong action verb
      - Ground the bullet in the evidence body and mentor comment — do not invent tools or metrics not implied by the context
      - Weave in the skill naturally (use the leaf skill name; the breadcrumb is for disambiguation)
      - Prefer impact, ownership, and clarity over buzzwords
      - Keep it to one concise sentence (or two short clauses), resume-ready
      - Do not wrap in quotes or add a leading bullet character

      OUTPUT FORMAT:
      Return strictly valid JSON:
      { "bullet": "Your resume bullet here..." }
    PROMPT

    begin
      response = WizardService.ask(prompt)
      bullet_text = response.is_a?(Hash) ? (response['bullet'] || response[:bullet]).to_s.strip : ''
      if bullet_text.blank?
        return render json: { error: 'Empty generation result' }, status: :unprocessable_entity
      end

      bullet = @evidence.evidence_bullets.create!(body: bullet_text)
      render json: bullet, serializer: EvidenceBulletSerializer, status: :created
    rescue StandardError => e
      render json: { error: "Failed to generate resume bullet: #{e.message}" }, status: :unprocessable_entity
    end
  end

  # POST /occupation_skills/:occupation_skill_id/occupation_skill_evidences
  def create
    evidence = current_user.occupation_skill_evidences.new(
      body: evidence_params[:body],
      occupation_skill: @occupation_skill,
      cohort_id: evidence_params[:cohort_id].presence,
      approved: false,
      comment: nil
    )

    if evidence.save
      render json: evidence, serializer: OccupationSkillEvidenceSerializer, status: :created
    else
      render json: { errors: evidence.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PATCH /occupation_skill_evidences/:id
  def update
    if User.is_admin?(current_user)
      return admin_update
    end

    unless @evidence.user_id == current_user.id
      return render json: { error: 'Unauthorized' }, status: :unauthorized
    end

    body = author_params[:body]
    if body.nil?
      return render json: { error: 'Nothing to update' }, status: :unprocessable_entity
    end

    attrs = { body: body }
    if @evidence.approved? || @evidence.comment.present?
      attrs[:approved] = false
      attrs[:comment] = nil
    end

    if @evidence.update(attrs)
      render json: @evidence, serializer: OccupationSkillEvidenceSerializer
    else
      render json: { errors: @evidence.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /occupation_skill_evidences/:id
  def destroy
    unless User.is_admin?(current_user) || @evidence.user_id == current_user.id
      return render json: { error: 'Unauthorized' }, status: :unauthorized
    end

    if !User.is_admin?(current_user) && @evidence.approved?
      return render json: { error: 'Cannot delete approved evidence' }, status: :unprocessable_entity
    end

    @evidence.destroy
    head :no_content
  end

  private

  def admin_update
    attrs = {}
    attrs[:approved] = ActiveModel::Type::Boolean.new.cast(admin_params[:approved]) if admin_params.key?(:approved)
    attrs[:comment] = admin_params[:comment] if admin_params.key?(:comment)
    attrs[:body] = admin_params[:body] if admin_params.key?(:body)

    if @evidence.update(attrs)
      render json: @evidence, serializer: OccupationSkillEvidenceSerializer
    else
      render json: { errors: @evidence.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def set_occupation_skill
    @occupation_skill = OccupationSkill.find(params[:occupation_skill_id])
  end

  def set_evidence
    @evidence = OccupationSkillEvidence
                .includes(:user, :cohort, occupation_skill: [:skill, :occupation, { occupation_skill: :skill }])
                .find(params[:id])
  end

  def evidence_params
    raw = params[:occupation_skill_evidence].present? ? params.require(:occupation_skill_evidence) : params
    raw.permit(:body, :cohort_id)
  end

  def author_params
    raw = params[:occupation_skill_evidence].present? ? params.require(:occupation_skill_evidence) : params
    raw.permit(:body)
  end

  def admin_params
    raw = params[:occupation_skill_evidence].present? ? params.require(:occupation_skill_evidence) : params
    raw.permit(:body, :approved, :comment)
  end
end
