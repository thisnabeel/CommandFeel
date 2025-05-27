class WondersController < ApplicationController
  before_action :set_wonder, only: [:show, :update, :destroy, :generate_quiz, :generate_challenge, :generate_abstraction]
  # skip_before_action :verify_authenticity_token, if: -> { action_name == 'generate_arcade' && caller_locations(1,1)[0].label == 'perform' }

  # GET /wonders
  def index
    @wonders = Wonder.select(:id, :title, :slug, :wonder_id).all
    render json: @wonders.as_json(only: [:id, :title, :slug, :wonder_id])
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
    render json: { message: "Wonder deleted successfully" }
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

    render json: response.shuffle
  end

  def generate_arcade
    prompt = <<~PROMPT
      You are generating content for a system design learning arcade game.

      INSTRUCTIONS:
      Part 1 - Tool Selection:
      - Create a digital product scenario
      - Generate 4-6 system design requirements
      - For each requirement, provide 4 tool options with reasoning
      - At least one option must be correct for each requirement

      Part 2 - Engineering Suggestions Review:
      - Generate 3-4 questionable engineering suggestions for the same product
      - Each suggestion should follow the format: "A fellow engineer suggests using [tool/approach] for [specific use case]. What's the problem with that?"
      - Provide 4 options for each suggestion, with one correct answer explaining the core issue
      - Other options should be plausible but incorrect

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
        ],
        "suggestions": [
          {
            "ask": "A fellow engineer suggests using [tool] for [use case]. What's the problem with that?",
            "options": [
              {
                "title": "Problem description",
                "correct": true/false,
                "reasoning": "Explanation of why this is/isn't the core issue"
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

      # Create quiz set for tool requirements
      asks_quiz_set = wonder.quiz_sets.create!(
        title: "Asks",
        position: 1
      )

      # Create quizzes for each requirement
      data["requirements"].each_with_index do |requirement, index|
        quiz = wonder.quizzes.create!(
          question: requirement["ask"],
          position: index + 1,
          quiz_set_id: asks_quiz_set.id,
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

      # Create quiz set for suggestions review
      suggestions_quiz_set = wonder.quiz_sets.create!(
        title: "Suggestions Review",
        position: 2
      )

      # Create quizzes for each suggestion
      data["suggestions"].each_with_index do |suggestion, index|
        quiz = wonder.quizzes.create!(
          question: suggestion["ask"],
          position: index + 1,
          quiz_set_id: suggestions_quiz_set.id,
          quizable_type: "Wonder",
          quizable_id: wonder.id
        )

        # Create choices for each option
        suggestion["options"].each do |option|
          QuizChoice.create!(
            quiz_id: quiz.id,
            body: option["title"],
            correct: option["correct"],
            reasoning: option["reasoning"]
          )
        end
      end

      if caller_locations(1,1)[0].label == 'perform'
        wonder
      else
        render json: wonder
      end
    end
  rescue JSON::ParserError => e
    error_msg = "Failed to parse ChatGPT response: #{e.message}"
    if caller_locations(1,1)[0].label == 'perform'
      raise error_msg
    else
      render json: { error: error_msg }, status: :unprocessable_entity
    end
  rescue StandardError => e
    if caller_locations(1,1)[0].label == 'perform'
      raise e
    else
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_wonder
      @wonder = Wonder.find_by(slug: params[:id]) || Wonder.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def wonder_params
      params.require(:wonder).permit(:title, :image, :description, :difficulty, :position, 
                                   :wonder_id, :visibility, :code, :slug, :is_course)
    end
end
