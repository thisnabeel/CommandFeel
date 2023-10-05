class ProofsController < ApplicationController
  before_action :set_proof, only: %i[ show update destroy ]

  # GET /proofs
  def index
    @proofs = Proof.all

    render json: @proofs
  end

  def by_user
  end
  
  def by_challenge
    proofs = Challenge.find(params[:challenge_id]).proofs.order("updated_at ASC")
    render json: proofs
  end

  def find
    params[:challenge_id] ? challenge = Challenge.find(params[:challenge_id]) : challenge = nil
    params[:user_id] ? user = User.find(params[:user_id]) : user = nil

    proofs = if challenge.present?
              user.present? ? challenge.proofs.where(user_id: params[:user_id]) : challenge.proofs
            elsif user.present?
              user.proofs
            end


    render json: proofs, each_serializer: ProofSerializer
  end

  # GET /proofs/1
  def show
    render json: @proof
  end

  # POST /proofs
  def create
    @proof = Proof.new(proof_params)

    
    if @proof.save!

        ProofLink.create(
          url: params[:proof_link][:url], 
          proof_id: @proof.id, 
          user_id: params[:user_id]
        )

      render json: @proof, serializer: ProofSerializer, status: :created, location: @proof
    else
      render json: @proof.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /proofs/1
  def update
    if @proof.update(proof_params)
      render json: @proof
    else
      render json: @proof.errors, status: :unprocessable_entity
    end
  end

  # DELETE /proofs/1
  def destroy
    @proof.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_proof
      @proof = Proof.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def proof_params
      params.require(:proof).permit(:user_id, :challenge_id, :title, :description)
    end
end
