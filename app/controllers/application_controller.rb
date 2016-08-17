class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_sign_up_params, if: :devise_controller?

  def require_is_admin
    if !current_user.admin?
      flash[:alert] = "You are not admin"
      redirect_to root_path
    end
  end

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute,:user_name])
  end
end
