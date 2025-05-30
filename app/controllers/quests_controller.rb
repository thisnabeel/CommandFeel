class QuestsController < ApplicationController
  before_action :set_skill, except: [:show, :quest_wizard, :popular]
  before_action :set_quest, only: [:show, :update, :destroy, :quest_wizard]

  def index
    @quests = @skill.quests
    render json: @quests
  end

  def show
    # If we're not in a nested route, find the quest directly
    @quest ||= Quest.find(params[:id]) if @quest.nil?
    render json: @quest
  end

  def create
    @quest = @skill.quests.build(quest_params)

    if @quest.save
      render json: @quest, status: :created
    else
      render json: @quest.errors, status: :unprocessable_entity
    end
  end

  def update
    if @quest.update(quest_params)
      render json: @quest
    else
      render json: @quest.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @quest.destroy
    head :no_content
  end

  def popular
    render json: Quest.popular(20)
  end

  def quest_wizard
    prompt = <<~PROMPT
      You are generating JSON content for a computer science gamified quiz platform.

      Theme: #{@quest.title}
      Level: #{params[:level]}
      Skill Focus: #{@quest.questable.title}
      Concept: #{@quest.description}

      #{if params[:abstraction].present?
        "Abstraction: #{params[:abstraction]}"
      end}

      INSTRUCTIONS:
      - Generate a sequence of quiz steps (5–7 items).
      - Each step must have a `body` field (a teaching explanation or a multiple choice question).
      - Don't use the word 'imagine' in the body of the step.
      #{if params[:abstraction].present?
        "- Make sure to use the theme of the provided analogy/abstraction and be non-techie friendly"
      end}
      - For teaching steps, use `"choices": []`.
      - For quiz questions, include 2–4 `choices`, each with:
          - "body": String
          - "status": Boolean (true if correct)
          - "reasoning": String (why it is correct/incorrect at this level)

      OUTPUT:
      Strictly return valid JSON, formatted like this:

      ```json
      [
        {
          "body": "Example question?",
          "choices": [
            { "body": "Option A", "status": true, "reasoning": "..." },
            { "body": "Option B", "status": false, "reasoning": "..." }
          ]
        },
        {
          "body": "Concept explanation step here.",
          "choices": []
        }
      ]
      ```

      Do NOT include any explanation outside the JSON block.
    PROMPT

    response = ChatGpt.send(prompt)
    
    # Parse the JSON from the content field - it's in the answer field and between ```json markers
    json_content = response["answer"].match(/```json\n(.*?)\n```/m)[1]
    steps_data = JSON.parse(json_content)
    
    # Create quest steps and their choices from the response
    created_steps = []
    
    ActiveRecord::Base.transaction do
      # First, remove any existing steps and their choices
      @quest.quest_steps.destroy_all
      
      steps_data.each_with_index do |step_data, step_index|
        # Create the quest step
        quest_step = @quest.quest_steps.create!(
          body: step_data["body"],
          position: step_index + 1
        )
        
        # Create the choices for this step
        step_data["choices"].each_with_index do |choice_data, choice_index|
          quest_step.quest_step_choices.create!(
            body: choice_data["body"],
            status: choice_data["status"],
            reasoning: choice_data["reasoning"],
            position: choice_index + 1
          )
        end
        
        # Link the previous step to this one as its success_step
        if step_index > 0
          created_steps.last.update!(success_step_id: quest_step.id)
        end
        
        created_steps << quest_step
      end
    end

    # Return the created steps with their choices using our serializer
    render json: created_steps, each_serializer: QuestStepSerializer
  rescue JSON::ParserError => e
    render json: { error: "Failed to parse ChatGPT response: #{e.message}" }, status: :unprocessable_entity
  rescue StandardError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  private

  def set_skill
    @skill = Skill.find(params[:skill_id])
  end

  def set_quest
    if params[:skill_id].present?
      @quest = @skill.quests.find(params[:id])
    else
      @quest = Quest.find(params[:id])
    end
  end

  def quest_params
    params.require(:quest).permit(:title, :description, :position, :image_url, :difficulty)
  end
end 