class PhrasesController < ApplicationController
  before_action :set_phrasable, only: [:index, :create]
  before_action :set_phrase, only: [:show, :update, :destroy, :suggest_technologies]

  def index
    @phrases = @phrasable ? @phrasable.phrases : Phrase.all
    @phrases = @phrases.includes(:phrase_links).order(created_at: :desc)
    render json: @phrases, each_serializer: PhraseListSerializer
  end

  def show
    render json: @phrase, serializer: PhraseSerializer
  end

  def create
    @phrase = if @phrasable
                @phrasable.phrases.build(phrase_params)
              else
                Phrase.new(phrase_params)
              end

    if @phrase.save
      render json: @phrase, serializer: PhraseSerializer, status: :created
    else
      render json: @phrase.errors, status: :unprocessable_entity
    end
  end

  def update
    if @phrase.update(phrase_params)
      render json: @phrase, serializer: PhraseSerializer
    else
      render json: @phrase.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @phrase.destroy
    head :no_content
  end

  def suggest_technologies
    prompt = <<~PROMPT
      You are a senior software architect helping to identify technologies and technical skills that address specific technical challenges.

      Challenge/Problem Statement: "#{@phrase.body}"

      INSTRUCTIONS:
      - Analyze the problem statement and identify relevant technologies, frameworks, or architectural patterns that could address this challenge
      - For each suggestion, explain specifically how it helps solve the problem
      - Focus on modern, production-ready solutions
      - Include both specific technologies and broader architectural concepts
      - Consider scalability, reliability, and maintainability

      OUTPUT FORMAT:
      Return a valid JSON array of suggestions, each with a title and explanation:

      ```json
      {
        "suggestions": [
          {
            "title": "Technology/Pattern name",
            "explanation": "How this specifically addresses the problem",
            "category": "One of: Database, Architecture, Framework, Tool, Pattern"
          }
        ]
      }
      ```

      Provide 3-5 relevant suggestions. Make sure each explanation is specific to the problem.
      Do NOT include any text outside the JSON block.
    PROMPT

    begin
      response = WizardService.ask(prompt)
      
      # Create PhraseLinks for each suggestion
      created_links = response["suggestions"].map do |suggestion|
        @phrase.phrase_links.create!(
          title: suggestion["title"],
          explanation: suggestion["explanation"],
          category: suggestion["category"]
        )
      end

      # Return the updated phrase with all its links
      render json: @phrase, serializer: PhraseSerializer
    rescue StandardError => e
      render json: { error: "Failed to generate suggestions: #{e.message}" }, status: :unprocessable_entity
    end
  end

  def generate
    # Normalize phrasable_type
    phrasable_type = case params[:phrasable_type].to_s.downcase
                     when 'skills', 'skill'
                       'Skill'
                     when 'wonders', 'wonder'
                       'Wonder'
                     else
                       params[:phrasable_type]
                     end
    
    phrasable_id = params[:phrasable_id]
    
    # Find the phrasable object
    phrasable_class = phrasable_type.classify.constantize
    phrasable = phrasable_class.find(phrasable_id)
    
    prompt = <<~PROMPT
      You are generating a technical challenge/problem statement and its solution using a specific technology.

      Technology/Solution: #{phrasable.title}
      Type: #{phrasable_type}

      INSTRUCTIONS:
      For the problem:
      - Create a realistic problem statement that a developer might hear from product managers or other stakeholders
      - Keep it under 200 characters
      - The problem should specifically relate to what #{phrasable.title} solves

      For the explanation:
      - Explain specifically how #{phrasable.title} addresses this problem
      - Include key features or aspects that make it particularly suitable
      - Keep it concise but technical
      - Focus on the direct benefits and solutions it provides

      OUTPUT FORMAT:
      Return a valid JSON with the problem statement and explanation:

      ```json
      {
        "body": "Only one of these should ever be created.",
        "role": "Junior Developer",
        "explanation": "Technical explanation of how #{phrasable.title} solves this specific problem"
      }
      ```

      Do NOT include any text outside the JSON block.
    PROMPT

    begin
      response = WizardService.ask(prompt)
      
      @phrase = Phrase.create!(
        body: response["body"],
        role: response["role"]
      )

      # Create the phrase link connecting to the phrasable
      @phrase.phrase_links.create!(
        phrasable: phrasable,
        title: phrasable.title,
        explanation: response["explanation"],
        category: phrasable_type
      )

      render json: @phrase, serializer: PhraseSerializer, status: :created
    rescue NameError => e
      render json: { error: "Invalid phrasable_type: #{phrasable_type}" }, status: :unprocessable_entity
    rescue ActiveRecord::RecordNotFound => e
      render json: { error: "#{phrasable_type} not found with id: #{phrasable_id}" }, status: :not_found
    rescue StandardError => e
      render json: { error: "Failed to generate phrase: #{e.message}" }, status: :unprocessable_entity
    end
  end

  private

  def set_phrasable
    if params[:skill_id]
      @phrasable = Skill.find(params[:skill_id])
    elsif params[:wonder_id]
      @phrasable = Wonder.find(params[:wonder_id])
    end
  end

  def set_phrase
    @phrase = Phrase.find(params[:id])
  end

  def phrase_params
    params.require(:phrase).permit(:body, :role)
  end
end 