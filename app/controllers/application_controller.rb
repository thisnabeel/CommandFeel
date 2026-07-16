class ApplicationController < ActionController::API
  def current_user
    return @current_user if defined?(@current_user)

    email = request.headers['X-User-Email']
    token = request.headers['X-User-Token']
    @current_user = nil

    return nil if email.blank? || token.blank?

    user = User.find_by(email: email)
    return nil unless user
    return nil unless user.tokens.present? && user.tokens.include?(token)

    @current_user = user
  end

  def ensure_admin
    unless User.is_admin?(current_user)
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end

  def ensure_signed_in
    unless current_user
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end
end
