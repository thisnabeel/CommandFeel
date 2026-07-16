class OccupationSkillsController < ApplicationController
  before_action :ensure_admin, except: %i[index show]
  before_action :set_occupation, only: %i[index create]
  before_action :set_occupation_skill, only: %i[show update destroy]

  def index
    @occupation_skills = @occupation.occupation_skills.includes(:skill).order(:position)
    render json: @occupation_skills, each_serializer: OccupationSkillSerializer
  end

  def show
    render json: @occupation_skill, serializer: OccupationSkillSerializer
  end

  def create
    @occupation_skill = @occupation.occupation_skills.new(occupation_skill_params)

    if @occupation_skill.save
      @occupation_skill = OccupationSkill.includes(:skill).find(@occupation_skill.id)
      render json: @occupation_skill, serializer: OccupationSkillSerializer, status: :created
    else
      render json: @occupation_skill.errors, status: :unprocessable_entity
    end
  end

  def update
    if @occupation_skill.update(occupation_skill_params)
      @occupation_skill = OccupationSkill.includes(:skill).find(@occupation_skill.id)
      render json: @occupation_skill, serializer: OccupationSkillSerializer
    else
      render json: @occupation_skill.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @occupation_skill.destroy
    head :no_content
  end

  private

  def set_occupation
    @occupation = Occupation.find(params[:occupation_id])
  end

  def set_occupation_skill
    @occupation_skill = OccupationSkill.find(params[:id])
  end

  def occupation_skill_params
    params.require(:occupation_skill).permit(
      :skill_id, :occupation_skill_id, :position, :title, :description, :video_url
    ).tap do |p|
      # Only nil out blank values that were actually sent — missing keys must stay untouched
      # or update() will clear skill_id / occupation_skill_id (denest / unlink bugs).
      p[:skill_id] = nil if p.key?(:skill_id) && p[:skill_id].blank?
      p[:occupation_skill_id] = nil if p.key?(:occupation_skill_id) && p[:occupation_skill_id].blank?
    end
  end
end
