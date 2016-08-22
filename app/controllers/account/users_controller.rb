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
    # binding.pry
    if @user.update(user_params)
      redirect_to account_users_path
    else
      render :edit
    end
  end

  def show
    @user = User.find(params[:id])
   end

  private

  def user_params
    params.require(:user).permit(:user_name, :email, :image)
  end
end
