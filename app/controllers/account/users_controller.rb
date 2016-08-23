class Account::UsersController < ApplicationController
  before_action :authenticate_user!
  layout "user"

  def index
    @user = current_user
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to account_users_path
    else
      render :edit
    end
  end

  def show
    @user = User.find(params[:id])
   end

  def apply_for_certify
  @user = User.find(params[:id])
  @user.apply_for_certify!
  if @user.aasm_state == "passed_verify"
    flash[:notice] = "您已通过实名认证！"
    redirect_to :back
  else
    flash[:notice] = "您已提交申请实名认证！"
    redirect_to :back
  end
end

  private

  def user_params
    params.require(:user).permit(:user_name, :email, :image)
  end
end
