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
    require_create_plan_judgment(@plan)
  end

  def edit
    @project = current_user.projects.find(params[:project_id])
    @plan = @project.plans.normal.find(params[:id])
  end

  def update
    @project = current_user.projects.find(params[:project_id])
    @plan = @project.plans.find(params[:id])
    require_update_plan_judgment(@plan, plan_params)
  end

  private

  def plan_params
    params.require(:plan).permit(:description, :price, :plan_goal)
  end
end
