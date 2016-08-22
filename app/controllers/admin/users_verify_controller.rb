class Admin::UsersVerifyController < ApplicationController
  before_action :authenticate_user!
  before_action :require_is_admin
  layout 'admin'

  def index
    @users = User.where(:verify_status == 0)
  end

  def show
    @user = User.find(params[:id])
  end

  def pass_verify
    @user = User.find(params[:id])
    @user.verify_status = 1
    @user.save
    flashp[:notice] = "已通过该用户的实名认证申请!"
    redirect_to :back
  end


  def reject_verify
    @user = User.find(params[:id])
    @user.verify_status = －1
    @user.save
    flashp[:notice] = "已通过该用户的实名认证申请!"
    redirect_to :back
  end

  private

  def user_verify
    params.require(:user).permit(:verify_status, :message)
  end
end