class QuestStepsController < ApplicationController
  before_action :set_quest
  before_action :set_quest_step, only: [:show, :update, :destroy, :upload_image]

  def index
    @quest_steps = @quest.quest_steps
    render json: @quest_steps
  end

  def show
    render json: @quest_step
  end

  def create
    @quest_step = @quest.quest_steps.build(quest_step_params)

    if @quest_step.save
      @quest_step.upload_images(params) if params[:image].present? || params[:thumbnail].present?
      render json: @quest_step, status: :created
    else
      render json: @quest_step.errors, status: :unprocessable_entity
    end
  end

  def update
    if @quest_step.update(quest_step_params)
      @quest_step.upload_images(params) if params[:image].present? || params[:thumbnail].present?
      render json: @quest_step
    else
      render json: @quest_step.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @quest_step.destroy
    head :no_content
  end

  def upload_image
    file = params[:file]
    
    if file.present?
      @quest_step.upload_image(file)
      render json: { image_url: @quest_step.image_url }
    else
      render json: { error: 'No file provided' }, status: :unprocessable_entity
    end
  end

  private

  def set_quest
    @quest = Quest.find(params[:quest_id])
  end

  def set_quest_step
    @quest_step = @quest.quest_steps.find(params[:id])
  end

  def quest_step_params
    params.require(:quest_step).permit(:position, :body, :success_step_id, :failure_step_id, :quest_reward_id)
  end
end 