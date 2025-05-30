class InfrastructurePatternsController < ApplicationController
  before_action :set_infrastructure_pattern, only: [:show, :update, :destroy, :add_dependency, :remove_dependency]

  # GET /infrastructure_patterns
  def index
    @infrastructure_patterns = InfrastructurePattern
      .select(:id, :title, :description)
      .order(position: :asc)
    
    render json: @infrastructure_patterns, 
           each_serializer: InfrastructurePatternListSerializer
  end

  # GET /infrastructure_patterns/1
  def show
    render json: @infrastructure_pattern,
           serializer: InfrastructurePatternSerializer,
           include_associations: true
  end

  # POST /infrastructure_patterns
  def create
    @infrastructure_pattern = InfrastructurePattern.new(infrastructure_pattern_params)
    
    if @infrastructure_pattern.save
      render json: @infrastructure_pattern, status: :created
    else
      render json: @infrastructure_pattern.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /infrastructure_patterns/1
  def update
    if @infrastructure_pattern.update(infrastructure_pattern_params)
      render json: @infrastructure_pattern
    else
      render json: @infrastructure_pattern.errors, status: :unprocessable_entity
    end
  end

  # DELETE /infrastructure_patterns/1
  def destroy
    @infrastructure_pattern.destroy
    head :no_content
  end

  # POST /infrastructure_patterns/reorder
  def reorder
    InfrastructurePattern.transaction do
      params[:infrastructure_patterns].each do |pattern_data|
        InfrastructurePattern.find(pattern_data[:id]).update!(position: pattern_data[:position])
      end
    end
    
    render json: InfrastructurePattern.order(position: :asc)
  rescue StandardError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  # POST /infrastructure_patterns/1/add_dependency
  def add_dependency
    @dependency = @infrastructure_pattern.infrastructure_pattern_dependencies.build(dependency_params)
    
    if @dependency.save
      render json: @infrastructure_pattern
    else
      render json: @dependency.errors, status: :unprocessable_entity
    end
  end

  # DELETE /infrastructure_patterns/1/dependencies/2
  def remove_dependency
    @dependency = @infrastructure_pattern.infrastructure_pattern_dependencies.find(params[:dependency_id])
    @dependency.destroy
    render json: @infrastructure_pattern
  end

  # GET /infrastructure_patterns/by_wonder/1
  def by_wonder
    @wonder = Wonder.find(params[:wonder_id])
    @infrastructure_patterns = @wonder.infrastructure_patterns
                                    .includes(:wonder_infrastructure_patterns, infrastructure_pattern_dependencies: [:dependable])
                                    .order('wonder_infrastructure_patterns.position')
    render json: @infrastructure_patterns
  end

  def generate_patterns
    patterns = InfrastructurePattern.generate_patterns
    render json: patterns
  rescue StandardError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  private

  def set_infrastructure_pattern
    @infrastructure_pattern = InfrastructurePattern.find(params[:id])
  end

  def infrastructure_pattern_params
    params.require(:infrastructure_pattern).permit(:title, :description, :position, :visibility)
  end

  def dependency_params
    params.require(:dependency).permit(:dependable_type, :dependable_id, :usage, :position)
  end
end 