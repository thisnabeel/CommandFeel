class QuizzesController < ApplicationController
  before_action :set_quiz, only: %i[ show update destroy ]

  # GET /quizzes
  def index
    @quizzes = Quiz.all.shuffle

    render json: @quizzes
  end

  # GET /quizzes/1
  def show
    render json: @quiz
  end

  def batch_test
    render json: Quiz.batch_test(params[:skills])
  end

  def generate_choices
    render json: Quiz.find(params[:quiz_id]).generate_choices(params[:style])
  end

  # POST /quizzes
  def create
    @quiz = Quiz.new(quiz_params)

    if @quiz.save
      render json: @quiz, status: :created, location: @quiz
    else
      render json: @quiz.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /quizzes/1
  def update
    if @quiz.update(quiz_params)
      render json: @quiz
    else
      render json: @quiz.errors, status: :unprocessable_entity
    end
  end

  # DELETE /quizzes/1
  def destroy
    @quiz.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_quiz
      @quiz = Quiz.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def quiz_params
      params.require(:quiz).permit(:quizable_type, :quizable_id, :jeopardy, :question, :position, :quiz_set_id)
    end
end
