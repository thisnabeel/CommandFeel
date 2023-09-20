class UserQuizStatusesController < ApplicationController
  before_action :set_user_quiz_status, only: %i[ show update destroy ]

  # GET /user_quiz_statuses
  def index
    @user_quiz_statuses = UserQuizStatus.all

    render json: @user_quiz_statuses
  end

  # GET /user_quiz_statuses/1
  def show
    render json: @user_quiz_status
  end

  # POST /user_quiz_statuses
  def create
    @user_quiz_status = UserQuizStatus.find_or_create_by(user_id: user_quiz_status_params[:user_id], quiz_id: user_quiz_status_params[:quiz_id])

    if @user_quiz_status.update(user_quiz_status_params)
      render json: @user_quiz_status, status: :created, location: @user_quiz_status
    else
      render json: @user_quiz_status.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /user_quiz_statuses/1
  def update
    if @user_quiz_status.update(user_quiz_status_params)
      render json: @user_quiz_status
    else
      render json: @user_quiz_status.errors, status: :unprocessable_entity
    end
  end

  # DELETE /user_quiz_statuses/1
  def destroy
    @user_quiz_status.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_quiz_status
      @user_quiz_status = UserQuizStatus.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_quiz_status_params
      params.require(:user_quiz_status).permit(:user_id, :quiz_id, :status)
    end
end
