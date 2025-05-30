class FeaturesController < ApplicationController
  before_action :set_feature, only: [:show, :update, :destroy, :add_dependency, :remove_dependency]

  # GET /features
  def index
    @features = Feature.includes(:wonder_features, :wonders, feature_dependencies: [:dependable])
                      .order(position: :asc)
    render json: @features
  end

  # GET /features/1
  def show
    render json: @feature
  end

  # POST /features
  def create
    @feature = Feature.new(feature_params)
    
    if @feature.save
      render json: @feature, status: :created
    else
      render json: @feature.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /features/1
  def update
    if @feature.update(feature_params)
      render json: @feature
    else
      render json: @feature.errors, status: :unprocessable_entity
    end
  end

  # DELETE /features/1
  def destroy
    @feature.destroy
    head :no_content
  end

  # POST /features/reorder
  def reorder
    Feature.transaction do
      params[:features].each do |feature_data|
        Feature.find(feature_data[:id]).update!(position: feature_data[:position])
      end
    end
    
    render json: Feature.order(position: :asc)
  rescue StandardError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  # POST /features/1/add_dependency
  def add_dependency
    @dependency = @feature.feature_dependencies.build(dependency_params)
    
    if @dependency.save
      render json: @feature
    else
      render json: @dependency.errors, status: :unprocessable_entity
    end
  end

  # DELETE /features/1/dependencies/2
  def remove_dependency
    @dependency = @feature.feature_dependencies.find(params[:dependency_id])
    @dependency.destroy
    render json: @feature
  end

  # GET /features/by_wonder/1
  def by_wonder
    @wonder = Wonder.find(params[:wonder_id])
    @features = @wonder.features.includes(:wonder_features, feature_dependencies: [:dependable])
                      .order('wonder_features.position')
    render json: @features
  end

  private

  def set_feature
    @feature = Feature.includes(:wonder_features, :wonders, feature_dependencies: [:dependable])
                     .find(params[:id])
  end

  def feature_params
    params.require(:feature).permit(:title, :description, :position, :visibility)
  end

  def dependency_params
    params.require(:dependency).permit(:dependable_type, :dependable_id, :usage, :position)
  end
end 