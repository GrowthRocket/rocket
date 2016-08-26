class Account::ProjectsController < ApplicationController
  before_action :authenticate_user!
  layout "user"

  authorize_resource

  def index
    @projects =
      if params[:category_id]
        current_user.projects.where(category_id: params[:category_id])
      else
        current_user.projects
      end
  end

  def new
    @project = current_user.projects.build
    @categories = Category.all
  end

  def show
    @project = current_user.projects.find(params[:id])
  end

  def edit
    @project = current_user.projects.find(params[:id])
    @categories = Category.all
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

  def apply_for_verification
    @projects = current_user.projects
    @project = current_user.projects.find(params[:id])

    if current_user.aasm_state != "passed_verified"
      flash[:alert] = "您尚未通过实名认证"
      redirect_to :back
    elsif @project.plans_count == 0
      flash[:alert] = "您尚未创建筹款方案"
      redirect_to :back
    elsif @projects.where("aasm_state = ? OR aasm_state = ?", "online", "verifying").count != 0
      flash[:alert] = "您已有在线项目或已有项目在审核中"
      redirect_to :back
    else
      @project.apply_verify!
      IdentityVerification.create!(
        verify_type: 2, user_id: current_user.id,
        title: @project.name, image: @project.image, project_id: params[:id],
        verify_status: 0, message: "apply"
      )
      flash[:notice] = "申请成功，请耐心等待..."
      redirect_to :back
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

  private

  def project_params
    params.require(:project).permit(:name, :description, :user_id, :fund_goal, :image, :plans_count, :category_id, :video)
  end
end
