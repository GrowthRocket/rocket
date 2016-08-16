class Admin::ProjectsController < ApplicationController
  # before_action :authenticate_user!, only: [:new, :create, :update, :edit, :destroy]

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
      redirect_to projects_path
    else
      render :new
    end
  end

  def update
    @project = Project.find(params[:id])
    if @project.update(project_params)
      redirect_to projects_path, notice: "Update successfully"
    else
      render :edit
    end
  end

  def destroy
    @project = Project.find(params[:id])
    @project.destroy
    redirect_to projects_path, alert: "Project deleted!"
  end

  private

  def project_params
    params.require(:project).permit(:name, :description, :user_id, :image)
  end
  #
end
