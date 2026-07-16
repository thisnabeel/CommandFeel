class CohortSprintsController < ApplicationController
  before_action :ensure_signed_in, only: %i[index show]
  before_action :ensure_admin, only: %i[create update destroy activate]
  before_action :set_cohort, only: %i[index create]
  before_action :set_cohort_sprint, only: %i[show update destroy activate]

  def index
    sprints = (@cohort || Cohort.find(params[:cohort_id])).cohort_sprints.ordered
    render json: sprints, each_serializer: CohortSprintSerializer
  end

  def show
    render json: @cohort_sprint, serializer: CohortSprintSerializer
  end

  def create
    next_position = (@cohort.cohort_sprints.maximum(:position) || 0) + 1
    @cohort_sprint = @cohort.cohort_sprints.new(create_params)
    @cohort_sprint.position ||= next_position
    @cohort_sprint.active = true if @cohort.cohort_sprints.empty?

    if @cohort_sprint.save
      render json: @cohort_sprint, serializer: CohortSprintSerializer, status: :created
    else
      render json: { errors: @cohort_sprint.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @cohort_sprint.update(update_params)
      render json: @cohort_sprint, serializer: CohortSprintSerializer
    else
      render json: { errors: @cohort_sprint.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def activate
    @cohort_sprint.activate!
    render json: @cohort_sprint.cohort.cohort_sprints.ordered, each_serializer: CohortSprintSerializer
  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
  end

  def destroy
    if @cohort_sprint.cohort.cohort_sprints.count <= 1
      return render json: { error: 'Cohort must keep at least one sprint' }, status: :unprocessable_entity
    end

    @cohort_sprint.destroy!
    render json: @cohort_sprint.cohort.cohort_sprints.ordered, each_serializer: CohortSprintSerializer
  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
  end

  private

  def set_cohort
    @cohort = Cohort.find(params[:cohort_id])
  end

  def set_cohort_sprint
    @cohort_sprint = CohortSprint.find(params[:id])
  end

  def create_params
    params.require(:cohort_sprint).permit(:position, :goal, :active)
  end

  def update_params
    params.require(:cohort_sprint).permit(:position, :goal)
  end
end
