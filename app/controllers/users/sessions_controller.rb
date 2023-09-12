# frozen_string_literal: true

class Users::SessionsController < ApplicationController
  # before_action :configure_sign_in_params, only: [:create]
  # skip_before_action :verify_signed_out_user
  
  # GET /resource/sign_in
  # def new
  #   super
  # end
  def sign_up
    user = User.find_by(email: params[:user][:email]) || User.find_by(username: params[:user][:username])
    puts "User Present by: #{user.present?}"
    if user.present? && user.valid_password?(params[:user][:password])
      generated_token = user.generate_temporary_authentication_token
      render json: user.attributes.merge(
        :admin => user.admin?, 
        generated_token: generated_token, 
      )
      # user.generate_temporary_authentication_token
      # render json: user.as_json(only: [:id, :email, :authentication_token]), status: :created
    else
      user = User.create!(user_params)
      generated_token = user.generate_temporary_authentication_token
      render json: user.attributes.merge(
        :admin => user.admin?, 
        generated_token: generated_token, 
      )
    end


  end


  # POST /resource/sign_in
  def create
      user = User.find_by(email: params[:login]) || User.find_by(username: params[:login])

      if user.present? && user.valid_password?(params[:password])
        generated_token = user.generate_temporary_authentication_token
        render json: user.attributes.merge(
          :admin => user.admin?, 
          generated_token: generated_token, 
        )
        # user.generate_temporary_authentication_token
        # render json: user.as_json(only: [:id, :email, :authentication_token]), status: :created
      else
        head(:unauthorized)
      end

  end

  # DELETE /resource/sign_out
  def destroy

    if request.headers['X-User-Token'].present?
      user = User.find_by(email: request.headers['X-User-Email'])
      if !user.present?
        puts "USER IS NOT PRESENT"
        render json: []
        return
      end
      token = request.headers['X-User-Token']
      user.update(tokens: user.tokens - [token])
      render json: user.tokens
    end

  end

  private
    # Use callbacks to share common setup or constraints between actions.


    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit!
    end
end
