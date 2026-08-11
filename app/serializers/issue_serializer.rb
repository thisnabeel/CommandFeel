class IssueSerializer < ActiveModel::Serializer
  attributes :id, :key, :number, :issue_type, :status, :priority, :title, :description,
             :cohort_id, :cohort_sprint_id, :parent_id, :reporter_id, :assignee_id,
             :backlog_rank, :created_at, :updated_at,
             :reporter_username, :reporter_email, :reporter_first_name, :reporter_last_name,
             :assignee_username, :assignee_email, :assignee_first_name, :assignee_last_name,
             :parent_key, :parent_title, :sprint_position, :sprint_active

  def key
    object.key
  end

  def reporter_username
    object.reporter&.username
  end

  def reporter_email
    object.reporter&.email
  end

  def reporter_first_name
    object.reporter&.first_name
  end

  def reporter_last_name
    object.reporter&.last_name
  end

  def assignee_username
    object.assignee&.username
  end

  def assignee_email
    object.assignee&.email
  end

  def assignee_first_name
    object.assignee&.first_name
  end

  def assignee_last_name
    object.assignee&.last_name
  end

  def parent_key
    object.parent&.key
  end

  def parent_title
    object.parent&.title
  end

  def sprint_position
    object.cohort_sprint&.position
  end

  def sprint_active
    object.cohort_sprint&.active
  end
end
