class Account::ProjectsController < ApplicationController
  before_action :authenticate_user!
  layout "user"

  def index
    if params[:category_id]
      @projects = current_user.projects.where(category_id: params[:category_id])
    else
      @projects = current_user.projects
    end

  end

  def new
    @project = current_user.projects.build
  end

  def show
    @project = current_user.projects.find(params[:id])
  end

  def edit
    @project = current_user.projects.find(params[:id])
  end

  def create
    @project = current_user.projects.build(project_params)

    if @project.save
      redirect_to account_projects_path, notice: "项目创建成功"
    else
      render :new
    end
  end

  def update
    @project = current_user.projects.find(params[:id])
    @project.is_hidden = true
    if @project.update(project_params)
      flash[:notice] = "项目更新成功"
      redirect_to account_projects_path
    else
      render :edit
    end
  end

  def destroy
    @project = current_user.projects.find(params[:id])
    plans = @project.plans
    plans.destroy
    @project.destroy
    flash[:alert] = "项目删除成功"
    redirect_to :back
  end

  def publish
    @project = current_user.projects.find(params[:id])
    @project.publish!
    redirect_to :back
  end

  def hide
    @project = current_user.projects.find(params[:id])
    @project.hide!
    redirect_to :back
  end

  private

  def project_params
    params.require(:project).permit(:name, :description, :user_id, :fund_goal, :image, :is_hidden, :plans_count, :category_id, :video)
  end
end
