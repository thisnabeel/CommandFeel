class QuestionCommentsController < ApplicationController
  before_action :ensure_signed_in
  before_action :set_question

  def create
    unless can_comment?
      return render json: { error: 'Unauthorized' }, status: :unauthorized
    end

    comment = @question.question_comments.new(
      body: comment_params[:body],
      user: current_user
    )

    if comment.save
      @question.reload
      render json: @question, serializer: QuestionSerializer, status: :created
    else
      render json: { errors: comment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def comment_params
    params.require(:question_comment).permit(:body)
  end

  def can_comment?
    return true if User.is_admin?(current_user)
    return true if @question.user_id == current_user.id

    false
  end
end
