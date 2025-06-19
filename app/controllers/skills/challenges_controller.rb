module Skills
  class ChallengesController < ApplicationController
    before_action :set_skill

    # GET /skills/:skill_id/challenges
    def index
      @challenges = @skill.challenges.order(:position)
      render json: @challenges, each_serializer: ChallengeSerializer
    end

    private

    def set_skill
      @skill = Skill.find(params[:skill_id])
    end
  end
end 