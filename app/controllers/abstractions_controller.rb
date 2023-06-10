class AbstractionsController < ApplicationController
  before_action :set_abstraction, only: %i[ show update destroy ]

  # GET /abstractions
  def index
    @abstractions = Abstraction.all

    render json: @abstractions
  end

  # GET /abstractions/1
  def show
    render json: @abstraction
  end

  # POST /abstractions
  def create
    @abstraction = Abstraction.new(abstraction_params)

    if @abstraction.save
      render json: @abstraction, status: :created, location: @abstraction
    else
      render json: @abstraction.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /abstractions/1
  def update
    if @abstraction.update(abstraction_params)
      render json: @abstraction
    else
      render json: @abstraction.errors, status: :unprocessable_entity
    end
  end

  # DELETE /abstractions/1
  def destroy
    @abstraction.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_abstraction
      @abstraction = Abstraction.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def abstraction_params
      params.require(:abstraction).permit(:abstractable_id, :abstractable_type, :article, :last_edited_by, :preview, :position, :source_url, :body)
    end
end
