class FeatureFlagsController < ApplicationController
  before_action :ensure_admin, only: %i[create update destroy]
  before_action :set_feature_flag, only: %i[show update destroy]

  def index
    render json: FeatureFlag.as_map
  end

  def show
    render json: @feature_flag, serializer: FeatureFlagSerializer
  end

  def create
    @feature_flag = FeatureFlag.new(feature_flag_params)

    if @feature_flag.save
      render json: @feature_flag, serializer: FeatureFlagSerializer, status: :created
    else
      render json: { errors: @feature_flag.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @feature_flag.update(feature_flag_params)
      render json: @feature_flag, serializer: FeatureFlagSerializer
    else
      render json: { errors: @feature_flag.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @feature_flag.destroy
    head :no_content
  end

  private

  def set_feature_flag
    @feature_flag = FeatureFlag.find_by!(key: params[:id])
  rescue ActiveRecord::RecordNotFound
    @feature_flag = FeatureFlag.find(params[:id])
  end

  def feature_flag_params
    params.require(:feature_flag).permit(:key, :enabled, :description)
  end
end
