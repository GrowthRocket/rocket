class Account::PostsController < ApplicationController
  before_action :authenticate_user!
  layout "user"

  def index
    @project = current_user.projects.find(params[:project_id])
    @posts = @project.posts.recent
  end

  def new
    @project = current_user.projects.find(params[:project_id])
    @post = @project.posts.build
  end

  def create
    @project = current_user.projects.find(params[:project_id])
    @post = @project.posts.build(post_params)
    if @project.save
      redirect_to account_project_posts_path, notice: "动态创建成功"
    else
      render :new
    end
  end

  def destroy
    @project = current_user.projects.find(params[:project_id])
    @post = @project.posts.find(params[:id])
    @post.destroy
    redirect_to :back, alert: "动态删除成功"
  end

  private

  def post_params
    params.require(:post).permit(:description)
  end
end
