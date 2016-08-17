class PlansController < ApplicationController
  def index
    @project = Project.find(params[:id])
    @plans = @project.plans
  end

  def show
    @plan = Plan.find(params[:id])
  end
end
