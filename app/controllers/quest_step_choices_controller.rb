class QuestStepChoicesController < ApplicationController
  before_action :set_quest_step, except: [:update]
  before_action :set_choice, only: [:show, :update, :destroy]

  def index
    @choices = @quest_step.quest_step_choices
    render json: @choices
  end

  def show
    render json: @choice
  end

  def create
    @choice = @quest_step.quest_step_choices.build(choice_params)
    
    if @choice.save
      render json: @choice, status: :created
    else
      render json: @choice.errors, status: :unprocessable_entity
    end
  end

  def update
    if @choice.update(choice_params)
      render json: @choice
    else
      render json: @choice.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @choice.destroy
    head :no_content
  end

  private

  def set_quest_step
    @quest_step = QuestStep.find(params[:quest_step_id])
  end

  def set_choice
    if @quest_step.present?
      @choice = @quest_step.quest_step_choices.find(params[:id])
    else
      @choice = QuestStepChoice.find(params[:id])
    end
  end

  def choice_params
    params.require(:quest_step_choice).permit(:body, :status, :position, :reasoning, :next_step_id)
  end
end 