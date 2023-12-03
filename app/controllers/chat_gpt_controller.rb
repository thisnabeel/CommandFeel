class ChatGptController < ApplicationController

    def prompt
        res = ChatGpt.send(params[:prompt])
        render json: res
    end
end
