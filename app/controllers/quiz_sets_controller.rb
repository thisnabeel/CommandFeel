class QuizSetsController < ApplicationController
  before_action :set_quiz_set, only: %i[ show update destroy ]

  # GET /quiz_sets
  def index
    @quiz_sets = QuizSet.all

    render json: @quiz_sets
  end

  # GET /quiz_sets/1
  def show
    render json: @quiz_set
  end

  # POST /quiz_sets
  def create
    @quiz_set = QuizSet.new(quiz_set_params)

    if @quiz_set.save
      render json: @quiz_set, serializer: QuizSetSerializer, status: :created, location: @quiz_set
    else
      render json: @quiz_set.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /quiz_sets/1
  def update
    if @quiz_set.update(quiz_set_params)
      render json: @quiz_set
    else
      render json: @quiz_set.errors, status: :unprocessable_entity
    end
  end

  # DELETE /quiz_sets/1
  def destroy
    @quiz_set.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_quiz_set
      @quiz_set = QuizSet.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def quiz_set_params
      params.require(:quiz_set).permit(:quiz_setable_id, :quiz_setable_type, :position, :title, :description, :pop_quizable)
    end
end
