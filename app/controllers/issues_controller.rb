class IssuesController < ApplicationController
  before_action :ensure_signed_in
  before_action :set_cohort, only: %i[index create]
  before_action :authorize_cohort!, only: %i[index create]
  before_action :set_issue, only: %i[show update destroy]
  before_action :authorize_issue!, only: %i[show update destroy]
  before_action :authorize_reorder!, only: %i[reorder]

  # GET /cohorts/:cohort_id/issues
  def index
    issues = @cohort.issues.includes(:reporter, :assignee, :parent, :cohort_sprint, :cohort)

    case params[:view].to_s
    when 'backlog'
      issues = issues.in_backlog.ordered_backlog
    when 'board'
      active = @cohort.active_sprint
      issues = if active
                 issues.in_sprint(active.id).order(:status, :backlog_rank, :number)
               else
                 issues.none
               end
    else
      if params[:sprint_id].present?
        if params[:sprint_id].to_s == 'null' || params[:sprint_id].to_s == 'backlog'
          issues = issues.in_backlog
        else
          issues = issues.in_sprint(params[:sprint_id])
        end
      end
      issues = issues.ordered_backlog
    end

    render json: issues, each_serializer: IssueSerializer
  end

  # POST /cohorts/:cohort_id/issues
  def create
    issue = nil
    Issue.transaction do
      issue = @cohort.issues.new(create_params)
      issue.reporter = current_user
      issue.history_actor = current_user
      issue.save!
    end

    issue = Issue.includes(:reporter, :assignee, :parent, :cohort_sprint, :cohort).find(issue.id)
    render json: issue, serializer: IssueSerializer, status: :created
  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
  end

  # GET /issues/:id
  def show
    render json: @issue, serializer: IssueSerializer
  end

  # PATCH /issues/:id
  def update
    @issue.history_actor = current_user
    if @issue.update(update_params)
      @issue = Issue.includes(:reporter, :assignee, :parent, :cohort_sprint, :cohort).find(@issue.id)
      render json: @issue, serializer: IssueSerializer
    else
      render json: { errors: @issue.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /issues/:id
  def destroy
    @issue.destroy
    head :no_content
  end

  # PATCH /issues/reorder
  # Body: { cohort_id, ordered_ids: [1,2,3] } — sets backlog_rank in order
  def reorder
    cohort = Cohort.find(params[:cohort_id])
    unless cohort_member_or_admin?(cohort.id)
      return render json: { error: 'Unauthorized' }, status: :unauthorized
    end

    ordered_ids = Array(params[:ordered_ids]).map(&:to_i).uniq
    issues = cohort.issues.where(id: ordered_ids).index_by(&:id)

    Issue.transaction do
      ordered_ids.each_with_index do |id, index|
        issue = issues[id]
        next unless issue

        issue.update_columns(backlog_rank: (index + 1) * 1000, updated_at: Time.current)
      end
    end

    result = cohort.issues.where(id: ordered_ids).includes(:reporter, :assignee, :parent, :cohort_sprint, :cohort)
                   .ordered_backlog
    render json: result, each_serializer: IssueSerializer
  end

  private

  def set_cohort
    @cohort = Cohort.includes(:cohort_sprints).find(params[:cohort_id])
  end

  def set_issue
    @issue = Issue.includes(:reporter, :assignee, :parent, :cohort_sprint, :cohort).find(params[:id])
  end

  def authorize_cohort!
    return if cohort_member_or_admin?(@cohort.id)

    render json: { error: 'Unauthorized' }, status: :unauthorized
    false
  end

  def authorize_issue!
    return if cohort_member_or_admin?(@issue.cohort_id)

    render json: { error: 'Unauthorized' }, status: :unauthorized
    false
  end

  def authorize_reorder!
    # checked inside action with cohort_id
  end

  def cohort_member_or_admin?(cohort_id)
    return true if User.is_admin?(current_user)

    current_user.cohort_users
                .where(cohort_id: cohort_id, status: %w[applied assigned])
                .exists?
  end

  def create_params
    raw = params[:issue].present? ? params.require(:issue) : params
    raw.permit(
      :title, :description, :issue_type, :status, :priority,
      :cohort_sprint_id, :parent_id, :assignee_id, :backlog_rank
    )
  end

  def update_params
    raw = params[:issue].present? ? params.require(:issue) : params
    permitted = raw.permit(
      :title, :description, :issue_type, :status, :priority,
      :cohort_sprint_id, :parent_id, :assignee_id, :backlog_rank
    )

    # Allow clearing sprint / assignee / parent with null
    if raw.key?(:cohort_sprint_id) && raw[:cohort_sprint_id].blank?
      permitted[:cohort_sprint_id] = nil
    end
    if raw.key?(:assignee_id) && raw[:assignee_id].blank?
      permitted[:assignee_id] = nil
    end
    if raw.key?(:parent_id) && raw[:parent_id].blank?
      permitted[:parent_id] = nil
    end

    permitted
  end
end
