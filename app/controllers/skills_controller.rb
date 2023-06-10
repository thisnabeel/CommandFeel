class SkillsController < ApplicationController
  before_action :set_skill, only: %i[ show update destroy ]

  # GET /skills
  def index
    @skills = Skill.all.order("position ASC")

    render json: @skills
  end

  # GET /skills/1
  def show
    render json: @skill, serializer: SkillSerializer, serializer_options: { 
      abstractions: true,
      challenges: true,
      quizzes: true
    }
  end

  # POST /skills
  def create
    @skill = Skill.new(skill_params)

    if @skill.save
      render json: @skill, status: :created, location: @skill
    else
      render json: @skill.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /skills/1
  def update
    if @skill.update(skill_params)
      render json: @skill
    else
      render json: @skill.errors, status: :unprocessable_entity
    end
  end

  # DELETE /skills/1
  def destroy
    @skill.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_skill
      @skill = Skill.find_by(slug: params[:id]) || Skill.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def skill_params
      params.require(:skill).permit(:title, :image, :description, :difficulty, :position, :skill_id, :visibility, :code, :slug, :is_course)
    end
end
