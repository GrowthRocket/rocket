class Devise::Users::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]
  before_action :check_geetest, only: [:create]
  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  def create
    if @geetest
      super
    else
      flash[:alert] = "请先滑动滑块"
      redirect_to new_user_registration_path
    end
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    resource_updated = update_resource(resource, account_update_params)
    yield resource if block_given?
    if resource_updated
      if is_flashing_format?
        flash_key =
          update_needs_confirmation?(resource, prev_unconfirmed_email) ?
                   :update_needs_confirmation : :updated
        set_flash_message :notice, flash_key
      end
      bypass_sign_in resource, scope: resource_name
      respond_with resource, location: after_update_path_for(resource)
    else
      puts "-------"
      clean_up_passwords resource
      flash[:alert] = "请重新输入密码"
      redirect_to change_password_account_user_path(resource)
    end
    #
    # if resource.save
    #   binding.pry
    #   flash[:alert] = "修改成功"
    #   redirect_to account_users_path
    # else
    #   redirect_to change_password_account_user
    # end
    # super
  end

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
