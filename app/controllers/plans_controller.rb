class PlansController < ApplicationController
  # before_action :check_project_status
  load_and_authorize_resource

  def index
    @project = Project.includes(:user).find(params[:project_id])
    @plans = @project.plans.price
    authorize! :read, @plans.first
  end

  def check_project_status
    @project = Project.find(params[:project_id])
    # if @project.aasm_state != "online"
    #   redirect_to root_path
    # end
  end
end
