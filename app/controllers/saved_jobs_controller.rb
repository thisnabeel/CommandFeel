class SavedJobsController < ApplicationController
  before_action :set_saved_job, only: %i[ show update destroy find_skills]

  # GET /saved_jobs
  def index
    @saved_jobs = SavedJob.all

    render json: @saved_jobs
  end

  # GET /saved_jobs/1
  def show
    render json: @saved_job
  end
  
  def find_skills
    render json: @saved_job.find_skills
  end

  def by_user
    user = User.includes(:saved_jobs).find(params[:id])
    grouped_statuses = user.saved_jobs.group_by { |el| el.stage }
    serialized_statuses = {}

    grouped_statuses.each do |status, statuses|
      serialized_statuses[status] = statuses.map { |el| SavedJobSerializer.new(el) }
    end

    render json: serialized_statuses
  end
  # POST /saved_jobs
  def create
    @saved_job = SavedJob.new(saved_job_params)

    if @saved_job.save
      render json: @saved_job, status: :created, location: @saved_job
    else
      render json: @saved_job.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /saved_jobs/1
  def update
    if @saved_job.update(saved_job_params)
      render json: @saved_job
    else
      render json: @saved_job.errors, status: :unprocessable_entity
    end
  end

  # DELETE /saved_jobs/1
  def destroy
    @saved_job.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_saved_job
      @saved_job = SavedJob.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def saved_job_params
      params.require(:saved_job).permit(:title, :company, :position, :jd_link, :jd, :stage, :skills, :user_id)
    end
end
