class IssueHistoriesController < ApplicationController
  before_action :ensure_signed_in
  before_action :set_issue
  before_action :authorize_issue!

  # GET /issues/:issue_id/issue_histories
  def index
    histories = @issue.issue_histories.includes(:user).newest_first.limit(100)
    render json: histories, each_serializer: IssueHistorySerializer
  end

  private

  def set_issue
    @issue = Issue.find(params[:issue_id])
  end

  def authorize_issue!
    return if cohort_member_or_admin?(@issue.cohort_id)

    render json: { error: 'Unauthorized' }, status: :unauthorized
    false
  end

  def cohort_member_or_admin?(cohort_id)
    return true if User.is_admin?(current_user)

    current_user.cohort_users
                .where(cohort_id: cohort_id, status: %w[applied assigned])
                .exists?
  end
end
