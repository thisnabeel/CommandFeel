class EvidenceBulletsController < ApplicationController
  before_action :ensure_signed_in
  before_action :set_bullet, only: %i[update destroy]
  before_action :authorize_bullet!, only: %i[update destroy]

  # PATCH /evidence_bullets/:id
  def update
    if @bullet.update(bullet_params)
      render json: @bullet, serializer: EvidenceBulletSerializer
    else
      render json: { errors: @bullet.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /evidence_bullets/:id
  def destroy
    @bullet.destroy
    head :no_content
  end

  private

  def set_bullet
    @bullet = EvidenceBullet.includes(occupation_skill_evidence: :user).find(params[:id])
  end

  def authorize_bullet!
    evidence = @bullet.occupation_skill_evidence
    return if evidence.user_id == current_user.id || User.is_admin?(current_user)

    render json: { error: 'Unauthorized' }, status: :unauthorized
    false
  end

  def bullet_params
    raw = params[:evidence_bullet].present? ? params.require(:evidence_bullet) : params
    raw.permit(:body, :position)
  end
end
