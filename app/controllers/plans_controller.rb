class PlansController < ApplicationController
  def index
    @project = Project.find(params[:project_id])
    @plans = @project.plans
  end
end
