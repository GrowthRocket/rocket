class Account::PlansController < ApplicationController
  before_action :authenticate_user!
  before_action :find_project
  layout "user"

  authorize_resource

  def index
    @plans = @project.plans.normal.recent
  end

  def new
    @plan = @project.plans.build
  end

  def create
    @plan = @project.plans.build(plan_params)
    require_create_plan_judgment(@plan)
  end

  def edit
    @plan = @project.plans.normal.find(params[:id])
  end

  def update
    @plan = @project.plans.find(params[:id])
    require_update_plan_judgment(@plan, plan_params)
  end

  private

  def find_project
    @project = Project.find(params[:project_id])
  end

  def plan_params
    params.require(:plan).permit(:description, :price, :plan_goal)
  end
end
