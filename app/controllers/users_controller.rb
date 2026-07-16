class UsersController < ApplicationController
  before_action :ensure_signed_in, only: %i[update_profile]

  def upload_avatar
    render json: User.find(params[:user_id]).upload_avatar(params)
  end

  def find_by_username
    render json: User.find_by(username: params[:username])
  end

  def update_profile
    if current_user.update(profile_params)
      token = request.headers['X-User-Token']
      render json: current_user.attributes.merge(
        admin: current_user.admin?,
        generated_token: token,
        name_complete: current_user.name_complete?
      )
    else
      render json: { errors: current_user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def profile_params
    params.require(:user).permit(:first_name, :last_name)
  end
end
