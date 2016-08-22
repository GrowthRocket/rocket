class ProjectsController < ApplicationController
  layout "projects"
  def index
    if params[:category_id]
      @projects = Project.published.where(category_id: params[:category_id])
    else
      @projects = Project.published
    end
  end

  def show
    @project = Project.find(params[:id])
    if @project.is_hidden?
      if !current_user
        redirect_to root_path, alert: "该项目为非公开项目。"
      else
        if current_user.is_admin == true
          flash[:warning] = '当前项目已设置为隐藏。'
        elsif @project.user == current_user
          flash[:warning] = '审核中，当前为预览模式。'
        else
          redirect_to root_path, alert: '该项目为未公开项目。'
        end
      end
    end
  end


end
