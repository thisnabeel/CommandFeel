class WondersController < ApplicationController
  before_action :set_wonder, only: [:show, :update, :destroy, :generate_quiz, :generate_challenge, :generate_abstraction]

  # GET /wonders
  def index
    @wonders = Wonder.all
    render json: @wonders
  end

  # GET /wonders/1
  def show
    render json: @wonder
  end

  # POST /wonders
  def create
    @wonder = Wonder.new(wonder_params)

    if @wonder.save
      render json: @wonder, status: :created
    else
      render json: @wonder.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /wonders/1
  def update
    if @wonder.update(wonder_params)
      render json: @wonder
    else
      render json: @wonder.errors, status: :unprocessable_entity
    end
  end

  # DELETE /wonders/1
  def destroy
    @wonder.destroy
    head :no_content
  end

  def generate_quiz
    quiz = @wonder.generate_quiz(params.permit(:category, :prompt, :quiz_set_id))
    render json: quiz
  end

  def generate_challenge
    challenge = @wonder.generate_challenge
    render json: challenge
  end

  def generate_abstraction
    abstraction = @wonder.generate_abstraction
    render json: abstraction
  end

  def arcade
    quiz_sets = QuizSet.includes(quiz_setable: {}, quizzes: :quiz_choices)
                      .where(title: "Asks")
    
    response = quiz_sets.map do |quiz_set|
      {
        wonder: quiz_set.quiz_setable,
        quizzes: quiz_set.quizzes.map { |quiz| 
          quiz.as_json(include: :quiz_choices)
        }
      }
    end

    render json: response
  end

  def generate_arcade
    prompt = <<~PROMPT
      You are generating content for a system design learning arcade game.

      INSTRUCTIONS:
      - Create a digital product scenario
      - Generate 4-6 system design requirements
      - For each requirement, provide 4 tool options with reasoning
      - At least one option must be correct for each requirement

      OUTPUT:
      Return valid JSON in this format:
      {
        "product_title": "Name of Digital Product",
        "requirements": [
          {
            "ask": "What tool would best handle [specific requirement]?",
            "options": [
              {
                "title": "Tool Name",
                "correct": true/false,
                "reasoning": "Why this tool is/isn't suitable"
              }
            ]
          }
        ]
      }

      Do NOT include any explanation outside the JSON block.
    PROMPT

    response = ChatGpt.send(prompt)
    
    # Parse the JSON from the content field
    json_content = response["answer"].match(/```json\n(.*?)\n```/m)[1]
    data = JSON.parse(json_content)
    
    ActiveRecord::Base.transaction do
      # Create the wonder from the product title
      wonder = Wonder.create!(
        title: data["product_title"],
        description: "System design arcade game for #{data["product_title"]}",
        difficulty: 1,
        visibility: true
      )

      # Create a quiz set for the requirements
      quiz_set = wonder.quiz_sets.create!(
        title: "Asks",
        position: 1
      )

      # Create quizzes for each requirement
      data["requirements"].each_with_index do |requirement, index|
        quiz = wonder.quizzes.create!(
          question: requirement["ask"],
          position: index + 1,
          quiz_set_id: quiz_set.id,
          quizable_type: "Wonder",
          quizable_id: wonder.id
        )

        # Create choices for each option
        requirement["options"].each do |option|
          QuizChoice.create!(
            quiz_id: quiz.id,
            body: option["title"],
            correct: option["correct"],
            reasoning: option["reasoning"]
          )
        end
      end

      render json: wonder
    end
  rescue JSON::ParserError => e
    Rails.logger.error("Failed to parse ChatGPT response: #{e.message}")
    render json: { error: "Failed to parse response" }, status: :unprocessable_entity
  rescue StandardError => e
    Rails.logger.error("Error in generate_arcade: #{e.message}")
    render json: { error: e.message }, status: :unprocessable_entity
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_wonder
      @wonder = Wonder.find_by!(slug: params[:id]) || Wonder.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def wonder_params
      params.require(:wonder).permit(:title, :image, :description, :difficulty, :position, 
                                   :wonder_id, :visibility, :code, :slug, :is_course)
    end
end
