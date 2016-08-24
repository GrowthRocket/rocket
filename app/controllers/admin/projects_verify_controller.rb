class Admin::ProjectsVerifyController < ApplicationController
  before_action :authenticate_user!
  before_action :require_is_admin
  layout "admin"

  def index
    @projects = Project.where(aasm_state: "verifying")
  end

  def show
    @project = Project.find(params[:id])
    @plans = @project.plans
    @identity_verification = IdentityVerification.find_by(project_id: @project.id)
  end

  def pass_verify
    @project = Project.find(params[:id])
    @project.approve!
    @project.aasm_state = "online"
    @project.save
    flash[:notice] = "已通过该项目的发布申请!"
    redirect_to :back
    # projectMailer.notify_order_placed(@project).deliver!
  end

  def reject_verify
    @project = Project.find(params[:id])
    @project.reject!


    @project.aasm_state = "unverified"
    @project.save
    flash[:notice] = "已拒绝该项目的发布申请!"
    @identity_verification = IdentityVerification.find_by(project_id: params[:id])

    @identity_verification.update(verify_status: -1)
    redirect_to :back
    # projectMailer.notify_order_placed(@project).deliver!
  end

  private

  def project_verify
    params.require(:identiy_verification).permit(:verify_status, :message)
  end
end
