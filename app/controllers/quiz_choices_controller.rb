class QuizChoicesController < ApplicationController
  before_action :set_quiz_choice, only: %i[ show update destroy ]

  # GET /quiz_choices
  def index
    @quiz_choices = QuizChoice.all

    render json: @quiz_choices
  end

  # GET /quiz_choices/1
  def show
    render json: @quiz_choice
  end

  # POST /quiz_choices
  def create
    @quiz_choice = QuizChoice.new(quiz_choice_params)

    if @quiz_choice.save
      render json: @quiz_choice, status: :created, location: @quiz_choice
    else
      render json: @quiz_choice.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /quiz_choices/1
  def update
    if @quiz_choice.update(quiz_choice_params)
      render json: @quiz_choice
    else
      render json: @quiz_choice.errors, status: :unprocessable_entity
    end
  end

  # DELETE /quiz_choices/1
  def destroy
    @quiz_choice.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_quiz_choice
      @quiz_choice = QuizChoice.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def quiz_choice_params
      params.require(:quiz_choice).permit(:quiz_id, :position, :correct, :body)
    end
end
