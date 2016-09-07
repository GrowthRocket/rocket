class Admin::UsersController < AdminController
  def index
    @users = User.all
    set_page_title_and_description("用户管理", nil)
  end

  def new
    @user = User.new
    set_page_title_and_description("新建用户", nil)
  end

  def show
    @user = User.find(params[:id])
    set_page_title_and_description("用户-#{@user.email}", nil)
  end

  def edit
    @user = User.find(params[:id])
    set_page_title_and_description("编辑用户信息", nil)

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
    flash[:notice] = "已将该用户权限提升为管理员!"
    redirect_to :back
  end

  def demote
    @user = User.find(params[:id])
    @user.is_admin = false
    @user.save
    flash[:alert] = "已将该用户权限降为普通用户！"
    redirect_to :back
  end

  private

  def user_params
    params.require(:user).permit(:user_name, :email)
  end
end
