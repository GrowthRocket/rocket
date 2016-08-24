class Admin::ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_is_admin
  layout "admin"

  def index
    @projects =
      if params[:category_id]
        Project.recent.where(category_id: params[:category_id]).paginate(page: params[:page], per_page: 5)
      else
        Project.all.recent.paginate(page: params[:page], per_page: 5)
       end
  end

  def new
    @project = Project.new
  end

  def show
    @project = Project.find(params[:id])
  end

  def edit
    @project = Project.find(params[:id])
  end

  def create
    @project = Project.new(project_params)
    @project.user = current_user
    if @project.save
      redirect_to admin_projects_path
    else
      render :new
    end
  end

  def update
    @project = Project.find(params[:id])
    if @project.update(project_params)
      flash[:notice] = "项目更新成功"
      redirect_to admin_projects_path
    else
      render :edit
    end
  end

  def destroy
    @project = Project.find(params[:id])
    plans = @project.plans
    plans.destroy
    @project.destroy
    flash[:alert] = "项目删除成功"
    redirect_to :back
  end

  def publish
    @project = Project.find(params[:id])
    @project.publish!
    redirect_to :back
  end

  def offline
    @project = Project.find(params[:id])
    @project.finish!
    redirect_to :back
  end

  private

  def project_params
    params.require(:project).permit(:name, :description, :user_id, :fund_goal, :image, :is_hidden, :plans_count, :category_id)
  end
end
