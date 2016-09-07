class PlansController < ApplicationController
  # before_action :check_project_status
  load_and_authorize_resource

  def index
    @project = Project.includes(:user).find(params[:project_id])
    @plans = @project.plans.price
    authorize! :read, @plans.first
    set_page_title_and_description("#{@project.name}-回报列表", view_context.truncate(@plan.description, :length => 100))
  end

  def check_project_status
    @project = Project.find(params[:project_id])
    # if @project.aasm_state != "online"
    #   redirect_to root_path
    # end
  end
end
