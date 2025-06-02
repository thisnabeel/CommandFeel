class CodeComparisonsController < ApplicationController
  before_action :set_code_comparison, only: [:show, :update, :destroy, :answerable, :attach_answerable, :detach_answerable]

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
    # Get a random code comparison with its code blocks, excluding used ones
    used_ids = params[:used_ids]&.split(',')&.map(&:to_i) || []
    
    comparison = CodeComparison.includes(:code_blocks)
                             .where.not(id: used_ids)
                             .order('RANDOM()')
                             .first

    if comparison
      render json: {
        id: comparison.id,
        code_comparison_title: comparison.title,
        tags: comparison.tags,
        code_blocks: comparison.code_blocks.order(:position).map { |block| 
          { content: block.content }
        },
        answerable: comparison.answerable
      }
    else
      # If no unused comparisons exist, generate a new one
      generate_solid_comparison
    end
  end

  def generate_solid_comparison
    unless params[:prompt].present?
      render json: { error: "Prompt is required" }, status: :unprocessable_entity
      return
    end

    base_prompt = <<~PROMPT
      You are generating code examples that demonstrate different programming concepts, patterns, or anti-patterns.

      Topic: #{params[:prompt]}

      INSTRUCTIONS:
      - Create two code blocks:
        1. First block should demonstrate the problematic/incorrect approach
        2. Second block should show the improved/correct implementation
      - Use Ruby code for the examples
      - Include comments explaining the concept
      - Keep the examples concise but clear
      - Focus on real-world scenarios a developer might encounter

      OUTPUT FORMAT:
      Return strictly valid JSON in this format:

      ```json
      {
        "title": "#{params[:prompt]}",
        "code_blocks": [
          {
            "content": "# Problem code..."
          },
          {
            "content": "# Solution code..."
          }
        ]
      }
      ```

      Do NOT include any explanation outside the JSON block.
    PROMPT

    begin
      response = WizardService.ask(base_prompt)
      
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
        },
        answerable: comparison.answerable
      }
    rescue StandardError => e
      render json: { error: "Failed to generate code comparison: #{e.message}" }, status: :unprocessable_entity
    end
  end

  # GET /code_comparisons/:id/answerable
  def answerable
    if @code_comparison.answerable
      render json: {
        id: @code_comparison.answerable_id,
        type: @code_comparison.answerable_type,
        title: @code_comparison.answerable.title,
        description: @code_comparison.answerable.description
      }
    else
      head :no_content
    end
  end

  # POST /code_comparisons/:id/attach_answerable
  def attach_answerable
    answerable_type = params[:answerable_type].classify
    answerable_id = params[:answerable_id]

    # Validate answerable type
    unless ['Skill', 'Wonder'].include?(answerable_type)
      render json: { error: "Invalid answerable type" }, status: :unprocessable_entity
      return
    end

    # Find the answerable object
    begin
      answerable = answerable_type.constantize.find(answerable_id)
      @code_comparison.update!(answerable: answerable)
      
      render json: {
        id: answerable.id,
        type: answerable_type,
        title: answerable.title,
        description: answerable.description
      }
    rescue ActiveRecord::RecordNotFound
      render json: { error: "#{answerable_type} not found" }, status: :not_found
    rescue => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end

  # DELETE /code_comparisons/:id/detach_answerable
  def detach_answerable
    @code_comparison.update!(answerable: nil)
    head :no_content
  end

  private

  def set_code_comparison
    @code_comparison = CodeComparison.find(params[:id])
  end

  def code_comparison_params
    params.require(:code_comparison).permit(:title)
  end
end 