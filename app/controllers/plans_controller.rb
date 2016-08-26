class PlansController < ApplicationController
  # before_action :check_project_status
  def index
    @project = Project.find(params[:project_id])
    @plans = @project.plans
  end

  def check_project_status
    @project = Project.find(params[:project_id])
    # if @project.aasm_state != "online"
    #   redirect_to root_path
    # end
  end

end
