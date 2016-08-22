class Account::PlansController < ApplicationController
  before_action :authenticate_user!
  layout "user"

  def index
    @project = Project.find(params[:project_id])
    @plans = @project.plans
  end

  def new
    @project = Project.find(params[:project_id])
    @plan = Plan.new
  end

  def create
    @project = current_user.projects.find(params[:project_id])
    @plan = Plan.new(plan_params)
    @plan.project = @project
    require_price_judgment_and_save(@plan)
  end

  def edit
    @project = current_user.projects.find(params[:project_id])
    @plan = Plan.find(params[:id])
  end

  def update
    @project = current_user.projects.find(params[:project_id])

    @plan = Plan.find(params[:id])
    if @plan.update(plan_params)
      flash[:notice] = "您已成功更新筹款方案。"
      redirect_to account_project_plans_path
    else
      render :edit
    end
  end

  def destroy
    @plan = Plan.find(params[:id])
    @plan.destroy
    flash[:alert] = "筹款方案删除成功"
    redirect_to :back
  end

  private

  def plan_params
    params.require(:plan).permit(:title, :description, :price, :plan_goal)
  end
end
