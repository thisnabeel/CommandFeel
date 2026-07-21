class OccupationSkillUserNotesController < ApplicationController
  before_action :ensure_signed_in
  before_action :set_occupation_skill, only: %i[index create]
  before_action :set_note, only: %i[update destroy]

  # GET /occupations/:occupation_id/my_notes
  # Returns occupation_skill_ids the subject user has non-empty notes for.
  # Admins may pass user_id to inspect another learner.
  def for_occupation
    subject = subject_user_for_read
    return if performed?
    return render json: { error: 'User not found' }, status: :not_found unless subject

    notes = subject.occupation_skill_user_notes
                   .joins(:occupation_skill)
                   .where(occupation_skills: { occupation_id: params[:occupation_id] })

    ids = notes.filter_map do |note|
      plain = note.body.to_s.gsub(/<[^>]*>/, '').strip
      note.occupation_skill_id if plain.present?
    end

    render json: ids
  end

  # GET /occupation_skills/:occupation_skill_id/occupation_skill_user_notes
  # Returns the current user's note for this occupation skill (or null).
  def index
    note = current_user.occupation_skill_user_notes.find_by(occupation_skill_id: @occupation_skill.id)
    if note
      render json: note, serializer: OccupationSkillUserNoteSerializer
    else
      render json: nil
    end
  end

  # POST /occupation_skills/:occupation_skill_id/occupation_skill_user_notes
  def create
    note = current_user.occupation_skill_user_notes.find_or_initialize_by(
      occupation_skill_id: @occupation_skill.id
    )
    note.body = note_params[:body]

    if note.save
      render json: note, serializer: OccupationSkillUserNoteSerializer, status: :ok
    else
      render json: note.errors, status: :unprocessable_entity
    end
  end

  # PATCH /occupation_skill_user_notes/:id
  def update
    if @note.update(note_params)
      render json: @note, serializer: OccupationSkillUserNoteSerializer
    else
      render json: @note.errors, status: :unprocessable_entity
    end
  end

  # DELETE /occupation_skill_user_notes/:id
  def destroy
    @note.destroy
    head :no_content
  end

  private

  def set_occupation_skill
    @occupation_skill = OccupationSkill.find(params[:occupation_skill_id])
  end

  def set_note
    @note = current_user.occupation_skill_user_notes.find(params[:id])
  end

  def note_params
    raw = params[:occupation_skill_user_note].present? ? params.require(:occupation_skill_user_note) : params
    raw.permit(:body)
  end

  def subject_user_for_read
    if params[:user_id].present?
      unless User.is_admin?(current_user)
        render json: { error: 'Unauthorized' }, status: :unauthorized
        return nil
      end
      return User.find_by(id: params[:user_id])
    end

    current_user
  end
end
