class WondersController < ApplicationController
  before_action :set_wonder, only: [:show, :update, :destroy, :generate_quiz, :generate_challenge, :generate_abstraction]

  # GET /wonders
  def index
    @wonders = Wonder.all
    render json: @wonders
  end

  # GET /wonders/1
  def show
    render json: @wonder
  end

  # POST /wonders
  def create
    @wonder = Wonder.new(wonder_params)

    if @wonder.save
      render json: @wonder, status: :created
    else
      render json: @wonder.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /wonders/1
  def update
    if @wonder.update(wonder_params)
      render json: @wonder
    else
      render json: @wonder.errors, status: :unprocessable_entity
    end
  end

  # DELETE /wonders/1
  def destroy
    @wonder.destroy
    head :no_content
  end

  def generate_quiz
    quiz = @wonder.generate_quiz(params.permit(:category, :prompt, :quiz_set_id))
    render json: quiz
  end

  def generate_challenge
    challenge = @wonder.generate_challenge
    render json: challenge
  end

  def generate_abstraction
    abstraction = @wonder.generate_abstraction
    render json: abstraction
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_wonder
      @wonder = Wonder.find_by!(slug: params[:id]) || Wonder.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def wonder_params
      params.require(:wonder).permit(:title, :image, :description, :difficulty, :position, 
                                   :wonder_id, :visibility, :code, :slug, :is_course)
    end
end
