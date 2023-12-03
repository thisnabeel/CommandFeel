class TradeOffAspectContendersController < ApplicationController
  before_action :set_trade_off_aspect_contender, only: %i[ show update destroy ]

  # GET /trade_off_aspect_contenders
  def index
    @trade_off_aspect_contenders = TradeOffAspectContender.all

    render json: @trade_off_aspect_contenders
  end

  # GET /trade_off_aspect_contenders/1
  def show
    render json: @trade_off_aspect_contender
  end

  # POST /trade_off_aspect_contenders
  def create
    @trade_off_aspect_contender = TradeOffAspectContender.new(trade_off_aspect_contender_params)

    if @trade_off_aspect_contender.save
      render json: @trade_off_aspect_contender, status: :created, location: @trade_off_aspect_contender
    else
      render json: @trade_off_aspect_contender.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /trade_off_aspect_contenders/1
  def update
    if @trade_off_aspect_contender.update(trade_off_aspect_contender_params)
      render json: @trade_off_aspect_contender
    else
      render json: @trade_off_aspect_contender.errors, status: :unprocessable_entity
    end
  end

  # DELETE /trade_off_aspect_contenders/1
  def destroy
    @trade_off_aspect_contender.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_trade_off_aspect_contender
      @trade_off_aspect_contender = TradeOffAspectContender.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def trade_off_aspect_contender_params
      params.require(:trade_off_aspect_contender).permit(:trade_off_contender_id, :trade_off_aspect_id, :body)
    end
end
