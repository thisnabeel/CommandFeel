class QuestionsController < ApplicationController
  before_action :ensure_signed_in
  before_action :set_question, only: %i[show resolve]
  before_action :set_occupation_skill, only: %i[for_occupation_skill]

  # GET /occupations/:occupation_id/unresolved_question_counts
  # Returns { occupation_skill_id => count }.
  # Learners: own unresolved questions.
  # Admins: unresolved cohort-learner skill questions where admin is not last commenter.
  def unresolved_counts_for_occupation
    skill_ids = OccupationSkill.where(occupation_id: params[:occupation_id]).pluck(:id)
    scope = Question.unresolved.where(questionable_type: 'OccupationSkill', questionable_id: skill_ids)

    if User.is_admin?(current_user)
      scope = scope.where.not(user_id: current_user.id)
                   .where('last_comment_by_id IS DISTINCT FROM ?', current_user.id)
    else
      # Needs attention: unresolved and someone else last commented.
      scope = scope.where(user: current_user)
                   .where.not(last_comment_by_id: nil)
                   .where.not(last_comment_by_id: current_user.id)
    end

    counts = scope.group(:questionable_id).count
    render json: counts.transform_keys(&:to_s)
  end

  # GET /questions/mine?cohort_user_id=
  def mine
    seat = current_user.cohort_users.find(params[:cohort_user_id])
    skill_ids = OccupationSkill.where(occupation_id: seat.occupation_id).pluck(:id)

    questions = Question
                .includes(:user, :last_comment_by, :question_comments, :questionable)
                .where(user: current_user)
                .where(
                  '(questionable_type = ? AND questionable_id = ?) OR (questionable_type = ? AND questionable_id IN (?))',
                  'CohortUser', seat.id,
                  'OccupationSkill', skill_ids.presence || [0]
                )
                .newest_first

    render json: questions, each_serializer: QuestionSerializer
  end

  # GET /questions/cohort_unresolved?cohort_id=
  # Admin inbox: unresolved cohort members' questions where this admin is not last commenter.
  def cohort_unresolved
    unless User.is_admin?(current_user)
      return render json: { error: 'Unauthorized' }, status: :unauthorized
    end

    cohort = Cohort.find(params[:cohort_id])
    seats = cohort.cohort_users.where(status: %w[applied assigned]).where.not(user_id: nil)
    seat_ids = seats.pluck(:id)
    user_ids = seats.pluck(:user_id).uniq - [current_user.id]
    occupation_ids = cohort.cohort_users.where.not(occupation_id: nil).distinct.pluck(:occupation_id)
    skill_ids = OccupationSkill.where(occupation_id: occupation_ids).pluck(:id)

    questions = Question
                .unresolved
                .includes(:user, :last_comment_by, :question_comments, :questionable)
                .where(user_id: user_ids.presence || [0])
                .where(
                  '(questionable_type = ? AND questionable_id IN (?)) OR (questionable_type = ? AND questionable_id IN (?))',
                  'CohortUser', seat_ids.presence || [0],
                  'OccupationSkill', skill_ids.presence || [0]
                )
                .where('last_comment_by_id IS DISTINCT FROM ?', current_user.id)
                .newest_first

    render json: questions, each_serializer: QuestionSerializer
  end

  # GET /occupation_skills/:occupation_skill_id/questions
  def for_occupation_skill
    scope = @occupation_skill.questions.includes(:user, :last_comment_by, :question_comments)
    scope = scope.where(user: current_user) unless User.is_admin?(current_user)

    render json: scope.newest_first, each_serializer: QuestionSerializer
  end

  def show
    unless can_view_question?(@question)
      return render json: { error: 'Unauthorized' }, status: :unauthorized
    end

    render json: @question, serializer: QuestionSerializer
  end

  # POST /questions/:id/resolve
  def resolve
    unless can_resolve_question?(@question)
      return render json: { error: 'Unauthorized' }, status: :unauthorized
    end

    @question.resolve!(by: current_user)
    render json: @question, serializer: QuestionSerializer
  end

  def create
    questionable = find_questionable!
    unless can_ask_on?(questionable)
      return render json: { error: 'Unauthorized' }, status: :unauthorized
    end

    question = current_user.questions.new(
      body: question_params[:body],
      questionable: questionable
    )

    if question.save
      render json: question, serializer: QuestionSerializer, status: :created
    else
      render json: { errors: question.errors.full_messages }, status: :unprocessable_entity
    end
  rescue ArgumentError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  private

  def set_question
    @question = Question.includes(:user, :last_comment_by, question_comments: :user).find(params[:id])
  end

  def set_occupation_skill
    @occupation_skill = OccupationSkill.find(params[:occupation_skill_id])
  end

  def question_params
    params.require(:question).permit(:body, :questionable_type, :questionable_id)
  end

  def find_questionable!
    type = question_params[:questionable_type].to_s
    unless Question::QUESTIONABLE_TYPES.include?(type)
      raise ArgumentError, 'Invalid questionable type'
    end

    type.constantize.find(question_params[:questionable_id])
  end

  def can_ask_on?(questionable)
    return true if User.is_admin?(current_user)

    case questionable
    when CohortUser
      questionable.user_id == current_user.id && %w[applied assigned].include?(questionable.status)
    when OccupationSkill
      current_user.cohort_users
                  .where(status: %w[applied assigned], occupation_id: questionable.occupation_id)
                  .exists?
    else
      false
    end
  end

  def can_view_question?(question)
    return true if User.is_admin?(current_user)
    return true if question.user_id == current_user.id

    false
  end

  def can_resolve_question?(question)
    return true if User.is_admin?(current_user)
    return true if question.user_id == current_user.id

    false
  end
end
