class TradeOffsController < ApplicationController
  before_action :set_trade_off, only: %i[ show update destroy ]

  # GET /trade_offs
  def index
    @trade_offs = TradeOff.all

    render json: @trade_offs, each_serializer: TradeOffSerializer
  end

  def prompt
      trade_off = TradeOff.find(params[:id])
      res = ChatGpt.send(params[:prompt])
      res.each do |item|
        aspect = TradeOffAspect.create(title: item["aspect"], trade_off_id: trade_off.id)
        item["contenders"].each do |k,v|
          puts "KEY IS"
          puts "#{k}"
          toc = TradeOffContender.find_by(title: k)
          TradeOffAspectContender.create(
            body: v, 
            trade_off_contender_id: toc.id, 
            trade_off_aspect_id: aspect.id,
          )
        end
      end
      render json: trade_off, serializer: TradeOffSerializer, aspects: true
  end

  def make
    @trade_off = TradeOff.create(title: params[:topics].map{|skill| skill["title"]}.join(" vs. "))
    params[:topics].each_with_index do |skill, index|
      TradeOffContender.create(title: skill["title"],trade_off_id: @trade_off.id, skill_id: skill["id"], position: index + 1)
    end

    render json: @trade_off, serializer: TradeOffSerializer
  end

  # GET /trade_offs/1
  def show
    render json: @trade_off, serializer: TradeOffSerializer, aspects: true
  end

  # POST /trade_offs
  def create
    @trade_off = TradeOff.new(trade_off_params)

    if @trade_off.save
      render json: @trade_off, status: :created, location: @trade_off
    else
      render json: @trade_off.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /trade_offs/1
  def update
    if @trade_off.update(trade_off_params)
      render json: @trade_off
    else
      render json: @trade_off.errors, status: :unprocessable_entity
    end
  end

  # DELETE /trade_offs/1
  def destroy
    @trade_off.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_trade_off
      @trade_off = TradeOff.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def trade_off_params
      params.require(:trade_off).permit(:title, :position, :header, :trade_off_id)
    end
end
