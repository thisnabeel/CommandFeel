class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :body, :user_id, :last_comment_by_id, :questionable_type, :questionable_id,
             :resolved, :resolved_at, :resolved_by_id, :unresolved, :user_display_name,
             :last_comment_by_display_name, :context_label, :created_at, :updated_at,
             :question_comments

  def unresolved
    object.unresolved?
  end

  def user_display_name
    display_name(object.user)
  end

  def last_comment_by_display_name
    display_name(object.last_comment_by)
  end

  def context_label
    object.context_label
  end

  def question_comments
    object.question_comments.includes(:user).map do |comment|
      QuestionCommentSerializer.new(comment).as_json
    end
  end

  private

  def display_name(u)
    return nil unless u

    name = [u.first_name, u.last_name].map { |p| p.to_s.strip }.reject(&:blank?).join(' ')
    name.presence || u.username.presence || u.email
  end
end
