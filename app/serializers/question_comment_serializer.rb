class QuestionCommentSerializer < ActiveModel::Serializer
  attributes :id, :body, :question_id, :user_id, :user_display_name, :created_at, :updated_at

  def user_display_name
    u = object.user
    return 'User' unless u

    name = [u.first_name, u.last_name].map { |p| p.to_s.strip }.reject(&:blank?).join(' ')
    name.presence || u.username.presence || u.email
  end
end
