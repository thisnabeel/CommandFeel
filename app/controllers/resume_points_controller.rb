class ResumePointsController < ApplicationController
  before_action :set_challenge
  before_action :set_resume_point, only: [:show, :update, :destroy]

  # GET /challenges/:challenge_id/resume_points
  def index
    @resume_points = @challenge.resume_points.order(:position)
    render json: @resume_points, each_serializer: ResumePointSerializer
  end

  # GET /challenges/:challenge_id/resume_points/:id
  def show
    render json: @resume_point, serializer: ResumePointSerializer
  end

  # POST /challenges/:challenge_id/resume_points
  def create
    @resume_point = @challenge.resume_points.build(resume_point_params)

    if @resume_point.save
      render json: @resume_point, serializer: ResumePointSerializer, status: :created
    else
      render json: @resume_point.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /challenges/:challenge_id/resume_points/:id
  def update
    if @resume_point.update(resume_point_params)
      render json: @resume_point, serializer: ResumePointSerializer
    else
      render json: @resume_point.errors, status: :unprocessable_entity
    end
  end

  # DELETE /challenges/:challenge_id/resume_points/:id
  def destroy
    @resume_point.destroy
    head :no_content
  end

  # GET /challenges/:challenge_id/resume_points/wizard
  def wizard
    prompt = <<~PROMPT
      You are generating resume bullet points for a software development challenge.

      Challenge Details:
      Title: #{@challenge.title}
      Description: #{@challenge.body}

      INSTRUCTIONS:
      - Generate 3 strong resume bullet points that highlight the key achievements and skills demonstrated in this challenge
      - Each bullet point should:
        * Start with a strong action verb
        * Include specific technical details
        * Quantify achievements where possible
        * Focus on impact and results
      - Keep each bullet point concise but impactful
      - Focus on technical skills and problem-solving abilities

      OUTPUT FORMAT:
      Return strictly valid JSON in this format:

      ```json
      {
        "resume_points": [
          {
            "body": "First bullet point..."
          },
          {
            "body": "Second bullet point..."
          },
          {
            "body": "Third bullet point..."
          }
        ]
      }
      ```

      Do NOT include any explanation outside the JSON block.
    PROMPT

    begin
      response = WizardService.ask(prompt)
      
      # Create the resume points
      resume_points = response["resume_points"].map.with_index do |point, index|
        @challenge.resume_points.create!(
          body: point["body"],
          position: index + 1
        )
      end

      render json: resume_points, each_serializer: ResumePointSerializer, status: :created
    rescue StandardError => e
      render json: { error: "Failed to generate resume points: #{e.message}" }, status: :unprocessable_entity
    end
  end

  private

  def set_challenge
    @challenge = Challenge.find(params[:challenge_id])
  end

  def set_resume_point
    @resume_point = @challenge.resume_points.find(params[:id])
  end

  def resume_point_params
    params.require(:resume_point).permit(:body, :position)
  end
end 