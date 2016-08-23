require "geetest_ruby_sdk"
class Devise::Users::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  def create
    # in your controller action

    challenge = params[:geetest_challenge] || ""
    validate = params[:geetest_validate] || ""
    seccode = params[:geetest_seccode] || ""

    # 将私钥传入，要注册的
    sdk = GeetestSDK.new(ENV["gee_test_key"])
    if sdk.validate(challenge, validate, seccode)
      super
    else
      flash[:alert] = "请滑动滑块进行验证"
      redirect_to :back
      # render :new
    end
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  #  def configure_sign_up_params
  #    devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute,:user_name])
  #  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
