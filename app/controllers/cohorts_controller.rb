class CohortsController < ApplicationController
  before_action :ensure_signed_in, only: %i[index show update_description]
  before_action :ensure_admin, only: %i[create update destroy enter_as_admin]
  before_action :set_cohort, only: %i[show update destroy enter_as_admin update_description]

  def index
    @cohorts = Cohort.includes(:cohort_sprints).order(start_date: :desc)
    render json: @cohorts, each_serializer: CohortSerializer
  end

  def show
    render json: @cohort, serializer: CohortSerializer
  end

  # POST /cohorts/:id/enter_as_admin
  # Ensures the admin has an assigned seat so they can open the learner dashboard.
  def enter_as_admin
    seat = current_user.cohort_users
                       .includes(:occupation, cohort: :cohort_sprints)
                       .find_by(cohort_id: @cohort.id)

    if seat
      seat.update!(status: 'assigned') if seat.applied?
      return render json: seat, serializer: CohortUserSerializer
    end

    occupation_id = @cohort.cohort_users.order(:id).pick(:occupation_id)
    unless occupation_id
      return render json: {
        error: 'Add an occupation slot before opening the dashboard'
      }, status: :unprocessable_entity
    end

    seat = CohortUser.create!(
      cohort: @cohort,
      user: current_user,
      occupation_id: occupation_id,
      status: 'assigned'
    )

    seat = CohortUser.includes(:occupation, cohort: :cohort_sprints).find(seat.id)
    render json: seat, serializer: CohortUserSerializer, status: :created
  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
  end

  def create
    @cohort = Cohort.new(cohort_params)
    @cohort.seed_sprints_count = seed_count_param

    if @cohort.save
      render json: @cohort, serializer: CohortSerializer, status: :created
    else
      render json: @cohort.errors, status: :unprocessable_entity
    end
  end

  def update
    if @cohort.update(cohort_params)
      render json: @cohort, serializer: CohortSerializer
    else
      render json: @cohort.errors, status: :unprocessable_entity
    end
  end

  # PATCH /cohorts/:id/update_description
  # Assigned cohort members (and admins) can edit the shared project description.
  def update_description
    unless can_edit_cohort_description?
      return render json: { error: 'Unauthorized' }, status: :unauthorized
    end

    description = if params[:cohort].present?
                    params.require(:cohort).permit(:description)[:description]
                  else
                    params[:description]
                  end

    if @cohort.update(description: description)
      render json: @cohort, serializer: CohortSerializer
    else
      render json: { errors: @cohort.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @cohort.destroy
    head :no_content
  end

  private

  def set_cohort
    @cohort = Cohort.includes(:cohort_sprints).find(params[:id])
  end

  def can_edit_cohort_description?
    return true if User.is_admin?(current_user)

    current_user.cohort_users
                .where(cohort_id: @cohort.id, status: 'assigned')
                .exists?
  end

  def cohort_params
    params.require(:cohort).permit(
      :start_date, :end_date, :title, :subtitle, :video_url, :description
    )
  end

  def seed_count_param
    raw = params.dig(:cohort, :seed_sprints_count).presence ||
          params.dig(:cohort, :sprints_count).presence ||
          6
    [[raw.to_i, 1].max, 24].min
  end
end
