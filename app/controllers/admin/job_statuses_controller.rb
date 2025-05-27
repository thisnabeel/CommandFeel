module Admin
  class JobStatusesController < ApplicationController
    before_action :ensure_admin

    def index
      @job_statuses = JobStatus.recent
      render json: @job_statuses
    end

    def show
      @job_status = JobStatus.find(params[:id])
      render json: @job_status
    end

    private

    def ensure_admin
      unless User.is_admin?(current_user)
        render json: { error: 'Unauthorized' }, status: :unauthorized
      end
    end
  end
end 