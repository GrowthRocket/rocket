class Account::PlansController < ApplicationController
  before_action :authenticate_user!
  layout "user"

  def index
    @project = current_user.projects.find(params[:project_id])
    @plans = @project.plans.normal.recent
  end

  def new
    @project = current_user.projects.find(params[:project_id])
    @plan = @project.plans.build
  end

  def create
    @project = current_user.projects.find(params[:project_id])
    @plan = @project.plans.build(plan_params)
    require_price_judgment_and_save(@plan)
  end

  def edit
    @project = current_user.projects.find(params[:project_id])
    @plan = @project.plans.normal.find(params[:id])
  end

  def update
    @project = current_user.projects.find(params[:project_id])
    @plan = @project.plans.find(params[:id])
    if @plan.update(plan_params)
      redirect_to account_project_plans_path, notice: "您已成功更新筹款方案。"
    else
      render :edit
    end
  end

  def destroy
    @project = current_user.projects.find(params[:project_id])
    @plan = @project.plans.normal.find(params[:id])
    @plan.destroy
    redirect_to :back, alert: "筹款方案删除成功"
  end

  private

  def plan_params
    params.require(:plan).permit(:title, :description, :price, :plan_goal)
  end
end
