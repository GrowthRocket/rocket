class Admin::ProjectsVerifyController < ApplicationController
  before_action :authenticate_user!
  before_action :require_is_admin
  layout "admin"

  def index
    @projects = Project.where(:verify_status == 0)
  end

  def show
    @project = Project.find(params[:id])
    @plans = @project.plans
  end

  def pass_verify
    @project = Project.find(params[:id])
    @project.approve!
    @project.verify_status = 1
    @project.save
    flash[:notice] = "已通过该项目的发布申请!"
    redirect_to :back
    # projectMailer.notify_order_placed(@project).deliver!
  end

  def reject_verify
    @project = Project.find(params[:id])
    @project.reject!
    @project.verify_status = －1
    @project.save
    flash[:notice] = "已拒绝该项目的发布申请!"
    redirect_to :back
    # projectMailer.notify_order_placed(@project).deliver!
  end

  private

  def project_verify
    params.require(:identiy_verification).permit(:verify_status, :message)
  end
end
