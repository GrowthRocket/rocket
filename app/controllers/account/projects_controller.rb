class Account::ProjectsController < AccountController
  authorize_resource

  def index
    @projects = current_user.projects

    if params[:category_id]
      @projects = current_user.projects.where(category_id: params[:category_id])
    end
  end

  def new
    @project = current_user.projects.build
    @categories = Category.all
    session.delete(:project_id)
  end

  def show
    @project = current_user.projects.find(params[:id])
  end

  def edit
    @project = current_user.projects.find(params[:id])
    @flowType = "edit"
    session[:project_id] = @project.id
    @categories = Category.all
  end

  def create
    user_name = params[:project][:user][:user_name]
    if user_name.blank?
      render json: {status: "n", message: "请输入姓名"}
      return
    else
      if user_name.length > 8
        render json: {status: "n", message: "姓名最长为8个汉字"}
        return
      end
    end
    if current_project.nil?
      @project = current_user.projects.build(project_params)
      if @project.save
        current_user.update_column(:user_name, user_name)
        session[:project_id] = @project.id
        render json: {status: "y", project_id: @project.id}
      else
        @errors = @project.errors
        render json: {status: "n", errors: @errors}
      end
    else
      @project = current_project
      if @project.update(project_params)
        user_name = params[:project][:user][:user_name]
        current_user.update_column(:user_name, user_name)
        render json: {status: "r"}
      else
        @errors = @project.errors
        render json: {status: "n", errors: @errors}
      end
    end
  end

  def update
    @project = current_user.projects.find(params[:id])
    if @project.update(project_params)
      flash[:notice] = "项目更新成功"
      redirect_to account_projects_path
    else
      render :edit
    end
  end

  # def destroy
  #   @project = current_user.projects.find(params[:id])
  #   plans = @project.plans
  #   plans.destroy
  #   @project.destroy
  #   flash[:alert] = "项目删除成功"
  #   redirect_to :back
  # end

  def apply_for_verification
    @projects = current_user.projects
    @project = current_user.projects.find(params[:id])

    if check_project_apply_valid
      @project.apply_verify!
      IdentityVerification.create!(
        verify_type: 2, user_id: current_user.id,
        title: @project.name, image: @project.image, project_id: params[:id],
        verify_status: 0, message: "apply"
      )
      flash[:notice] = "申请成功，请耐心等待..."

    end
    redirect_to :back
  end

  def apply_for_verification_new
    @projects = current_user.projects
    @project = current_user.projects.find(params[:id])

    message = check_project_apply_valid_new
    if message[:status] == "y"
      @project.apply_verify!
      IdentityVerification.create!(
        verify_type: 2, user_id: current_user.id,
        title: @project.name, image: @project.image, project_id: params[:id],
        verify_status: 0, message: "apply"
      )
      message[:message] = "申请成功，请耐心等待..."
      render json: message
    else
      render json: message
    end
  end

  def offline
    @project = current_user.projects.find(params[:id])
    @project.finish!
    redirect_to :back
  end

  def reject_message
    @identity_verification = IdentityVerification.find_by(project_id: params[:id])
  end

  def current_project
     @current_project ||= find_project
  end

  private

  def find_project
    project = Project.find_by(id: session[:project_id])

    unless project.blank?
      session[:project_id] = project.id
    end

    project
  end

  def check_project_apply_valid
    # binding.pry
    unless current_user.passed_verified?
      flash[:alert] = "为了保证项目的真实性，请到我的资料页验证手机号。"
      return false
    end

    if @project.plans_count < 2
      flash[:alert] = "您尚未创建筹款回报"
      return false
    end

    if @projects.where("aasm_state = ? OR aasm_state = ?", "online", "verifying").count.nonzero?
      flash[:alert] = "您已有在线项目或已有项目在审核中"
      return false
    end
    true
  end

  def check_project_apply_valid_new
    info = {}
    info[:status] = "y"
    unless current_user.passed_verified?
      info[:status] = "verifyID"
      info[:message] = "当前项目已经自动保存。您尚未通过实名认证，通过实名认证后即可申请上线。"
      return info
    end

    if @project.plans_count == 0
      info[:status] = "e"
      info[:message] = "您尚未创建筹款方案"
      return info
    end

    if @projects.where("aasm_state = ? OR aasm_state = ?", "online", "verifying").count != 0
      info[:status] = "e"
      info[:message] = "当前项目已经自动保存。但您已有在线项目或已有项目在审核中（一次只能上线一个项目）"
      return info
    end
    return info
  end

  def project_params
    params.require(:project).permit(:name, :description, :user_id, :fund_goal, :image, :plans_count, :category_id, :video)
  end
end
