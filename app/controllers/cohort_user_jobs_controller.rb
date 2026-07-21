class CohortUserJobsController < ApplicationController
  before_action :ensure_signed_in
  before_action :set_cohort_user, only: %i[index create]
  before_action :authorize_seat!, only: %i[index create]
  before_action :set_job, only: %i[update destroy]
  before_action :authorize_job!, only: %i[update destroy]

  # GET /cohort_users/:cohort_user_id/cohort_user_jobs
  def index
    jobs = @cohort_user.cohort_user_jobs.active.ordered
    render json: jobs, each_serializer: CohortUserJobSerializer
  end

  # POST /cohort_users/:cohort_user_id/cohort_user_jobs
  def create
    job = @cohort_user.cohort_user_jobs.new(create_params)

    if job.save
      render json: job, serializer: CohortUserJobSerializer, status: :created
    else
      render json: { errors: job.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PATCH /cohort_user_jobs/:id
  def update
    if @job.update(update_params)
      render json: @job, serializer: CohortUserJobSerializer
    else
      render json: { errors: @job.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /cohort_user_jobs/:id
  def destroy
    @job.destroy
    head :no_content
  end

  private

  def set_cohort_user
    @cohort_user = CohortUser.find(params[:cohort_user_id])
  end

  def set_job
    @job = CohortUserJob.includes(:cohort_user).find(params[:id])
  end

  def authorize_seat!
    return if @cohort_user.user_id == current_user.id || User.is_admin?(current_user)

    render json: { error: 'Unauthorized' }, status: :unauthorized
    false
  end

  def authorize_job!
    seat = @job.cohort_user
    return if seat.user_id == current_user.id || User.is_admin?(current_user)

    render json: { error: 'Unauthorized' }, status: :unauthorized
    false
  end

  def create_params
    raw = params[:cohort_user_job].present? ? params.require(:cohort_user_job) : params
    raw.permit(:title, :url, :description, :position)
  end

  def update_params
    raw = params[:cohort_user_job].present? ? params.require(:cohort_user_job) : params
    raw.permit(:title, :url, :description, :position, :archive)
  end
end
