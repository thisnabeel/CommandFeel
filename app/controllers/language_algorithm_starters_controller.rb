class LanguageAlgorithmStartersController < ApplicationController
  before_action :set_language_algorithm_starter, only: %i[ show update destroy ]

  # GET /language_algorithm_starters
  def index
    @language_algorithm_starters = LanguageAlgorithmStarter.all

    render json: @language_algorithm_starters, each_serializer: LanguageAlgorithmStarterSerializer
  end

  def finder
    @language_algorithm_starter = LanguageAlgorithmStarter.find_by(programming_language_id: params[:language_id], algorithm_id: params[:algorithm_id])
    render json: @language_algorithm_starter
  end

  # GET /language_algorithm_starters/1
  def show
    render json: @language_algorithm_starter
  end

  # POST /language_algorithm_starters
  def create
    
    @language_algorithm_starter = LanguageAlgorithmStarter.find_or_create_by(
      programming_language_id: language_algorithm_starter_params[:programming_language_id], 
      algorithm_id: language_algorithm_starter_params[:algorithm_id]
    )

    if @language_algorithm_starter.update(language_algorithm_starter_params)
      render json: @language_algorithm_starter, status: :created, location: @language_algorithm_starter
    else
      render json: @language_algorithm_starter.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /language_algorithm_starters/1
  def update
    if @language_algorithm_starter.update(language_algorithm_starter_params)
      render json: @language_algorithm_starter
    else
      render json: @language_algorithm_starter.errors, status: :unprocessable_entity
    end
  end

  # DELETE /language_algorithm_starters/1
  def destroy
    @language_algorithm_starter.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_language_algorithm_starter
      @language_algorithm_starter = LanguageAlgorithmStarter.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def language_algorithm_starter_params
      params.require(:language_algorithm_starter).permit!
    end
end
