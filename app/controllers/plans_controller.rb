class PlansController < ApplicationController
  # before_action :check_project_status
  def index
    @project = Project.find(params[:project_id])
    @plans = @project.plans.order("price DESC")
  # scope :recent, -> { order(created_at: :desc).limit(5) }
  end

  def check_project_status
    @project = Project.find(params[:project_id])
    # if @project.aasm_state != "online"
    #   redirect_to root_path
    # end
  end
end
