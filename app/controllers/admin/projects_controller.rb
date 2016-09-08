class Admin::ProjectsController < AdminController
  load_and_authorize_resource
  before_action :find_project_by_id, only: [:edit, :update, :destroy, :publish, :offline]

  def index
    @projects =
      if params[:category_id]
        Project.recent.where(category_id: params[:category_id]).includes(:category, :user).paginate(page: params[:page], per_page: 20)
      else
        Project.all.recent.includes(:category, :user).paginate(page: params[:page], per_page: 20)
      end
    @categories = Category.all
    @projects_verifying = Project.where(aasm_state: "verifying")
    set_page_title_and_description("众筹项目管理", nil)
  end

  def new
    @project = Project.new
    @categories = Category.all
    set_page_title_and_description("新建项目", nil)
  end

  # def show
  #   set_page_title_and_description("项目-#{@project.name}", nil)
  # end

  def edit
    @categories = Category.all
    set_page_title_and_description("修改项目-#{@project.name}", nil)
  end

  def create
    @project = Project.new(project_params)
    @user = User.find_by(email: params[:project][:user_email])
    if !@user.present?
      render :new
      flash[:alert] = "无此用户"
    else
      @project.user = @user
      if @project.save
        redirect_to admin_projects_path
        flash[:notice] = "项目创建成功"
      else
        render :new
      end
    end
  end

  def update
    if @project.update(project_params)
      flash[:notice] = "项目更新成功"
      redirect_to admin_projects_path
    else
      render :edit
    end
  end

  def destroy
    @plans = @project.plans
    @plans.delete
    @project.delete
    flash[:alert] = "项目删除成功"
    redirect_to :back
  end

  def publish
    @project.admin_approve!
    redirect_to :back
  end

  def offline
    @project.finish!
    redirect_to :back
  end

  protected

  def find_project_by_id
    @project = Project.find(params[:id])
  end

  private

  def project_params
    params.require(:project).permit(:name, :description, :fund_goal, :image, :plans_count, :category_id, :video, :user_email)
  end
end
