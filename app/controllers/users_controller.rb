class UsersController < ApplicationController
    def upload_avatar
        render json: User.find(params[:user_id]).upload_avatar(params)
    end

    def find_by_username
        render json: User.find_by(username: params[:username])
    end
end