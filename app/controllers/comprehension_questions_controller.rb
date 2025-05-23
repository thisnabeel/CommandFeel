class ComprehensionQuestionsController < ApplicationController
  before_action :set_comprehension_question, only: %i[ show update destroy ]

  # GET /comprehension_questions
  def index
    @comprehension_questions = ComprehensionQuestion.all

    render json: @comprehension_questions
  end

  # GET /comprehension_questions/1
  def show
    render json: @comprehension_question
  end

  # POST /comprehension_questions
  def create
    @comprehension_question = ComprehensionQuestion.new(comprehension_question_params)

    if @comprehension_question.save
      render json: @comprehension_question, status: :created, location: @comprehension_question
    else
      render json: @comprehension_question.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /comprehension_questions/1
  def update
    if @comprehension_question.update(comprehension_question_params)
      render json: @comprehension_question
    else
      render json: @comprehension_question.errors, status: :unprocessable_entity
    end
  end

  # DELETE /comprehension_questions/1
  def destroy
    @comprehension_question.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comprehension_question
      @comprehension_question = ComprehensionQuestion.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def comprehension_question_params
      params.require(:comprehension_question).permit(:leetcode_problem_id, :question, :answer, :question_type)
    end
end
