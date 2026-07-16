class QuestionComment < ApplicationRecord
  belongs_to :question, inverse_of: :question_comments
  belongs_to :user

  validates :body, presence: true

  after_create :touch_question_last_comment_by

  private

  def touch_question_last_comment_by
    question.update!(
      last_comment_by: user,
      resolved: false,
      resolved_at: nil,
      resolved_by_id: nil
    )
  end
end
