class ProofLinksController < ApplicationController
  before_action :set_proof_link, only: %i[ show update destroy ]

  # GET /proof_links
  def index
    @proof_links = ProofLink.all

    render json: @proof_links
  end

  # GET /proof_links/1
  def show
    render json: @proof_link
  end

  # POST /proof_links
  def create
    @proof_link = ProofLink.new(proof_link_params)

    if @proof_link.save
      render json: @proof_link, status: :created, location: @proof_link
    else
      render json: @proof_link.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /proof_links/1
  def update
    if @proof_link.update(proof_link_params)
      render json: @proof_link
    else
      render json: @proof_link.errors, status: :unprocessable_entity
    end
  end

  # DELETE /proof_links/1
  def destroy
    @proof_link.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_proof_link
      @proof_link = ProofLink.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def proof_link_params
      params.require(:proof_link).permit(:proof_id, :url, :title, :description, :user_id)
    end
end
