class Admin::ProjectsVerifyController < AdminController
  def index
    @projects_verifying = Project.where(aasm_state: "verifying")
    @categories = Category.all
  end

  def show
    @project = Project.find(params[:id])
    @plans = @project.plans
    @identity_verification = IdentityVerification.find_by(project_id: @project.id)
  end

  def pass_verify
    @project = Project.find(params[:id])
    if @project.aasm_state == "online"
      @project.approve!
    else
      @project.admin_prove!
    end
    @project.save
    flash[:notice] = "已通过该项目的发布申请!"
    redirect_to admin_projects_path
    # projectMailer.notify_order_placed(@project).deliver!
  end

  def reject_verify
    @project = Project.find(params[:id])
    if @project.aasm_state == "online"
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
