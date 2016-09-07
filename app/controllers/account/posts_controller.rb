class Account::PostsController < AccountController
  before_action :find_project

  load_and_authorize_resource

  def index
    @posts = @project.posts.recent.paginate(page: params[:page], per_page: 5)
    authorize! :read, @posts.first
    set_page_title_and_description("管理动态", view_context.truncate(@project.name, :length => 100))
  end

  def new
    @post = @project.posts.build
    set_page_title_and_description("发布动态", view_context.truncate(@project.name, :length => 100))
  end

  def create
    @post = @project.posts.build(post_params)
    if @project.save
      redirect_to account_project_posts_path, notice: "动态创建成功"
    else
      render :new
    end
  end

  def destroy
    @post = @project.posts.find(params[:id])
    @post.destroy
    redirect_to :back, alert: "动态删除成功"
  end

  private

  def find_project
    @project = current_user.projects.find(params[:project_id])
  end

  def post_params
    params.require(:post).permit(:description)
  end
end
