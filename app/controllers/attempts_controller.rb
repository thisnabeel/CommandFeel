class AttemptsController < ApplicationController
  before_action :set_attempt, only: %i[ show update destroy ]

  # GET /attempts
  def index
    @attempts = Attempt.all

    render json: @attempts
  end

  # GET /attempts/1
  def show
    render json: @attempt
  end

  # POST /attempts
  def create
    @attempt = Attempt.new(attempt_params)

    if @attempt.save
      render json: @attempt, status: :created, location: @attempt
    else
      render json: @attempt.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /attempts/1
  def update
    if @attempt.update(attempt_params)
      render json: @attempt
    else
      render json: @attempt.errors, status: :unprocessable_entity
    end
  end

  def by_user
    render json: User.find(params[:user_id]).attempts.where(
      passing: true, 
      algorithm_id: params[:algorithm_id]
    )
  end

  # DELETE /attempts/1
  def destroy
    @attempt.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_attempt
      @attempt = Attempt.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def attempt_params
      params.require(:attempt).permit(:algorithm_id, :programming_language_id, :user_id, :error_message, :passing)
    end
end
