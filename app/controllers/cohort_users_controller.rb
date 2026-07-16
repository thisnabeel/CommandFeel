class CohortUsersController < ApplicationController
  before_action :ensure_signed_in, only: %i[index show apply mine]
  before_action :ensure_admin, only: %i[create update destroy]
  before_action :set_cohort_user, only: %i[show update destroy apply]

  def index
    @cohort_users = CohortUser.includes(:cohort, :user, :occupation)
    @cohort_users = @cohort_users.where(cohort_id: params[:cohort_id]) if params[:cohort_id].present?

    unless User.is_admin?(current_user)
      @cohort_users = @cohort_users.where(status: 'open')
    end

    render json: @cohort_users, each_serializer: CohortUserSerializer
  end

  def mine
    @cohort_users = current_user.cohort_users
                                .includes(:occupation, cohort: :cohort_sprints)
                                .where(status: %w[applied assigned])
                                .order(updated_at: :desc)
    render json: @cohort_users, each_serializer: CohortUserSerializer
  end

  def show
    unless User.is_admin?(current_user) || @cohort_user.open?
      return render json: { error: 'Unauthorized' }, status: :unauthorized
    end

    render json: @cohort_user, serializer: CohortUserSerializer
  end

  def create
    @cohort_user = CohortUser.new(create_params)
    @cohort_user.status = 'open'
    @cohort_user.user_id = nil

    if @cohort_user.save
      render json: @cohort_user, serializer: CohortUserSerializer, status: :created
    else
      render json: { errors: @cohort_user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    case params[:intent].to_s
    when 'clear'
      return clear_seat
    when 'accept'
      return accept_application
    when 'assign'
      return force_assign
    end

    # Default: allow changing occupation while open
    unless @cohort_user.open?
      return render json: { error: 'Occupation can only be changed on open slots' }, status: :unprocessable_entity
    end

    if @cohort_user.update(occupation_params)
      render json: @cohort_user, serializer: CohortUserSerializer
    else
      render json: { errors: @cohort_user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @cohort_user.destroy
    head :no_content
  end

  def apply
    if @cohort_user.apply!(current_user)
      seat = CohortUser.includes(:occupation, cohort: :cohort_sprints).find(@cohort_user.id)
      render json: seat, serializer: CohortUserSerializer
    else
      render json: { errors: @cohort_user.errors.full_messages }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e.record.errors.full_messages.presence || [e.message] },
           status: :unprocessable_entity
  end

  private

  def set_cohort_user
    @cohort_user = CohortUser.find(params[:id])
  end

  def create_params
    params.require(:cohort_user).permit(:cohort_id, :occupation_id)
  end

  def occupation_params
    params.require(:cohort_user).permit(:occupation_id)
  end

  def clear_seat
    @cohort_user.clear_seat!
    render json: @cohort_user, serializer: CohortUserSerializer
  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
  end

  def accept_application
    @cohort_user.accept!
    render json: @cohort_user, serializer: CohortUserSerializer
  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e.record.errors.full_messages.presence || ['Slot is not in applied status'] },
           status: :unprocessable_entity
  end

  def force_assign
    assignee = resolve_assignee
    unless assignee
      return render json: { error: 'User not found' }, status: :unprocessable_entity
    end

    @cohort_user.assign_user!(assignee)
    render json: @cohort_user, serializer: CohortUserSerializer
  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
  end

  def resolve_assignee
    raw = params.require(:cohort_user)
    if raw[:user_id].present?
      User.find_by(id: raw[:user_id])
    elsif raw[:email].present?
      email = raw[:email].to_s.strip
      User.find_by(email: email) || User.find_by('LOWER(email) = ?', email.downcase)
    end
  end
end
