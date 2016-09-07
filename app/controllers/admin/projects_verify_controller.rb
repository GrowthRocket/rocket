class Admin::ProjectsVerifyController < AdminController
  load_and_authorize_resource :project
  def index
    @projects_verifying = Project.where(aasm_state: "verifying").includes(:category, :user)
    # @categories = Category.all
    set_page_title_and_description("待审核项目", nil)
  end

  def show
    @project = Project.includes(:plans).find(params[:id])
    # @plans = @project.plans
    @identity_verification = IdentityVerification.find_by(project_id: @project.id)
    authorize! :read, @project
    set_page_title_and_description("审核-#{@project.name}", nil)
  end

  def pass_verify
    @project = Project.find(params[:id])
    if @project.online?
      @project.approve!
    else
      @project.admin_approve!
    end
    @project.save
    flash[:notice] = "已通过该项目的发布申请!"
    redirect_to admin_projects_path
    # projectMailer.notify_order_placed(@project).deliver!
  end

  def reject_verify
    @project = Project.find(params[:id])
    if @project.online
      @project.reject!
    else
      @project.admin_reject!
    end
    @project.save
    flash[:notice] = "已拒绝该项目的发布申请!"
    @identity_verification = IdentityVerification.find_by(project_id: params[:id])
    message = params[:message]
    @identity_verification.update(verify_status: -1, message: message)
    redirect_to admin_projects_path
    # projectMailer.notify_order_placed(@project).deliver!
  end

  private

  def project_verify
    params.require(:identiy_verification).permit(:verify_status, :message)
  end
end
