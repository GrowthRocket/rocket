class Account::UsersController < ApplicationController
  before_action :authenticate_user!
  def index
    @users = User.all
  end
  def new
    @user = User.new
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
  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to admin_users_path
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:user_name, :email)
  end
end