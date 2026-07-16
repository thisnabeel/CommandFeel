class SkillHistoriesController < ApplicationController
  before_action :set_skill, only: %i[index create]
  before_action :set_skill_history, only: %i[show update destroy]

  def index
    render json: @skill.skill_histories.order(created_at: :desc),
           each_serializer: SkillHistorySerializer
  end

  def show
    render json: @skill_history, serializer: SkillHistorySerializer
  end

  def create
    @skill_history = @skill.skill_histories.build(skill_history_params)
    @skill_history.body = '' if @skill_history.body.nil?

    if @skill_history.save
      render json: @skill_history, serializer: SkillHistorySerializer, status: :created
    else
      render json: @skill_history.errors, status: :unprocessable_entity
    end
  end

  def update
    if @skill_history.update(skill_history_params)
      render json: @skill_history, serializer: SkillHistorySerializer
    else
      render json: @skill_history.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @skill_history.destroy
    head :no_content
  end

  private

  def set_skill
    @skill = Skill.find(params[:skill_id])
  end

  def set_skill_history
    @skill_history = SkillHistory.find(params[:id])
  end

  def skill_history_params
    raw = params[:skill_history].present? ? params.require(:skill_history) : params
    raw.permit(:body, :skill_id)
  end
end
