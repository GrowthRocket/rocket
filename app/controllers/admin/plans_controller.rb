class Admin::PlansController < ApplicationController
  before_action :authenticate_user!
  before_action :require_is_admin
  layout "admin"

  def index
    @project = Project.find(params[:project_id])
    @plans = @project.plans.recent
  end

  def new
    @project = Project.find(params[:project_id])
    @plan = Plan.new
  end

  def create
    @project = Project.find(params[:project_id])
    @plan = Plan.new(plan_params)
    @plan.project = @project
    require_create_plan_judgment(@plan)
  end

  def edit
    @project = Project.find(params[:project_id])
    @plan = Plan.find(params[:id])
  end

  def update
    @project = Project.find(params[:project_id])

    @plan = Plan.find(params[:id])
    require_update_plan_judgment
  end

  private

  def plan_params
    params.require(:plan).permit(:description, :price, :plan_goal)
  end
end
