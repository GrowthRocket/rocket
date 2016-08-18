class ProjectsController < ApplicationController

  def index
    @projects = Project.published
  end

  def show
    @project = Project.find(params[:id])
    if @project.is_hidden?
      unless current_user.is_admin?
        redirect_to root_path
      end
    end
  end

end
