class OccupationsController < ApplicationController
  before_action :ensure_admin, except: %i[show]
  before_action :set_occupation, only: %i[show update destroy]

  def index
    @occupations = Occupation.all
    render json: @occupations, each_serializer: OccupationSerializer
  end

  def show
    render json: @occupation, serializer: OccupationSerializer, serializer_options: { occupation_skills: true }
  end

  def create
    @occupation = Occupation.new(occupation_params)

    if @occupation.save
      render json: @occupation, serializer: OccupationSerializer, status: :created
    else
      render json: @occupation.errors, status: :unprocessable_entity
    end
  end

  def update
    if @occupation.update(occupation_params)
      render json: @occupation, serializer: OccupationSerializer, serializer_options: { occupation_skills: true }
    else
      render json: @occupation.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @occupation.destroy
      head :no_content
    else
      render json: { errors: @occupation.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_occupation
    @occupation = Occupation.find(params[:id])
  end

  def occupation_params
    params.require(:occupation).permit(:title, :subtitle, :description, :average_salary_range)
  end
end
