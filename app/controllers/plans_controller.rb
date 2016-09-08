class PlansController < ApplicationController
  load_and_authorize_resource

  def index
    binding.pry
    @project = Project.includes(:user).find(params[:project_id])
    @plans = @project.plans.price
    authorize! :read, @plans.first
    set_page_title_and_description("#{@project.name}-回报列表", view_context.truncate(@plans.first.description, :length => 100))
  end
end
