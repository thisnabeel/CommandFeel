class CodeComparisonsController < ApplicationController
  before_action :set_code_comparison, only: [:show, :update, :destroy]

  def index
    @code_comparisons = CodeComparison.includes(:code_blocks).all
    render json: @code_comparisons
  end

  def show
    render json: @code_comparison
  end

  def create
    @code_comparison = CodeComparison.new(code_comparison_params)

    if @code_comparison.save
      render json: @code_comparison, status: :created
    else
      render json: @code_comparison.errors, status: :unprocessable_entity
    end
  end

  def update
    if @code_comparison.update(code_comparison_params)
      render json: @code_comparison
    else
      render json: @code_comparison.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @code_comparison.destroy
    head :no_content
  end

  def arcade
    # Get a random code comparison with its code blocks
    comparison = CodeComparison.includes(:code_blocks).order('RANDOM()').first

    if comparison
      render json: {
        code_comparison_title: comparison.title,
        tags: comparison.tags,
        code_blocks: comparison.code_blocks.order(:position).map { |block| 
          { content: block.content }
        }
      }
    else
      # If no comparisons exist, generate a new one
      generate_solid_comparison
    end
  end

  def generate_solid_comparison
    prompt = <<~PROMPT
      You are generating code examples that demonstrate SOLID principles in software engineering.

      INSTRUCTIONS:
      - Choose one SOLID principle randomly
      - Create two code blocks:
        1. First block should demonstrate code that violates the principle
        2. Second block should show the corrected version that follows the principle
      - Use Ruby code for the examples
      - Keep the examples concise but clear
      - Focus on real-world scenarios a developer might encounter

      OUTPUT FORMAT:
      Return strictly valid JSON in this format:

      ```json
      {
        "title": "Name of the SOLID Principle",
        "code_blocks": [
          {
            "content": "# Code that violates the principle..."
          },
          {
            "content": "# Code that follows the principle..."
          }
        ]
      }
      ```

      Do NOT include any explanation outside the JSON block.
    PROMPT

    begin
      response = WizardService.ask(prompt)
      
      # Create the code comparison
      comparison = CodeComparison.create!(
        title: response["title"]
      )

      # Create the code blocks
      response["code_blocks"].each_with_index do |block, index|
        comparison.code_blocks.create!(
          content: block["content"],
          position: index + 1
        )
      end

      render json: {
        code_comparison_title: comparison.title,
        code_blocks: comparison.code_blocks.order(:position).map { |block| 
          { content: block.content }
        }
      }
    rescue StandardError => e
      render json: { error: "Failed to generate code comparison: #{e.message}" }, status: :unprocessable_entity
    end
  end

  private

  def set_code_comparison
    @code_comparison = CodeComparison.find(params[:id])
  end

  def code_comparison_params
    params.require(:code_comparison).permit(:title)
  end
end 