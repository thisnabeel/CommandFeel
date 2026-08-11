class IssueHistorySerializer < ActiveModel::Serializer
  attributes :id, :issue_id, :user_id, :event, :changes, :created_at, :updated_at,
             :user_username, :user_email, :user_first_name, :user_last_name, :user_display_name

  def changes
    object.change_set || []
  end

  def user_username
    object.user&.username
  end

  def user_email
    object.user&.email
  end

  def user_first_name
    object.user&.first_name
  end

  def user_last_name
    object.user&.last_name
  end

  def user_display_name
    user = object.user
    return 'Someone' unless user

    name = [user.first_name, user.last_name].map { |p| p.to_s.strip }.reject(&:blank?).join(' ')
    return name if name.present?
    return user.username if user.username.present?

    user.email.to_s.split('@').first.presence || user.email || 'Someone'
  end
end
