class Admin::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :require_is_admin
  layout "admin"

  def index
    @users = User.all
  end
  def new
    @user = User.new
  end
  def show
    @user = User.find(params[:id])
  end
  def edit
    @user = User.find(params[:id])
  end
  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to admin_users_path
    else
      render :new
    end
  end
  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to admin_users_path
    else
      render :edit
    end
  end
  def promote
    @user = User.find(params[:id])
    @user.is_admin = true
    @user.save
    flash[:notice] = "成功设为管理员!"
    redirect_to :back
  end


  def demote
    @user = User.find(params[:id])
    @user.is_admin = false
    @user.save
    flash[:alert]= "已降为非管理员！"
    redirect_to :back
  end
  private

  def user_params
    params.require(:user).permit(:user_name, :email)
  end
end
