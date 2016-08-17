class Admin::ProjectsController < ApplicationController
  # before_action :authenticate_user!, only: [:new, :create, :update, :edit, :destroy]
  layout 'admin'

  def index
    @projects = Project.all
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
    if @project.save
      redirect_to admin_projects_path
    else
      render :new
    end
  end

  def update
    @project = Project.find(params[:id])
    if @project.update(project_params)
      redirect_to admin_projects_path, notice: "项目更新成功"
    else
      render :edit
    end
  end

  def destroy
    @project = Project.find(params[:id])
    plans = @project.plans
    plans.destroy
    @project.destroy
    redirect_to :back, alert: "项目删除成功"
  end

  private

  def project_params
    params.require(:project).permit(:name, :description, :user_id, :total_price, :image)
  end
  #
end
