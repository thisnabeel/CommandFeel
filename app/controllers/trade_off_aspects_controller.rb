class TradeOffAspectsController < ApplicationController
  before_action :set_trade_off_aspect, only: %i[ show update destroy ]

  # GET /trade_off_aspects
  def index
    @trade_off_aspects = TradeOffAspect.all

    render json: @trade_off_aspects
  end

  # GET /trade_off_aspects/1
  def show
    render json: @trade_off_aspect
  end

  # POST /trade_off_aspects
  def create
    @trade_off_aspect = TradeOffAspect.new(trade_off_aspect_params)

    if @trade_off_aspect.save
      render json: @trade_off_aspect, status: :created, location: @trade_off_aspect
    else
      render json: @trade_off_aspect.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /trade_off_aspects/1
  def update
    if @trade_off_aspect.update(trade_off_aspect_params)
      render json: @trade_off_aspect
    else
      render json: @trade_off_aspect.errors, status: :unprocessable_entity
    end
  end

  # DELETE /trade_off_aspects/1
  def destroy
    @trade_off_aspect.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_trade_off_aspect
      @trade_off_aspect = TradeOffAspect.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def trade_off_aspect_params
      params.require(:trade_off_aspect).permit(:title, :description, :position, :trade_off_id)
    end
end
