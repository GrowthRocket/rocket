class ProjectsController < ApplicationController

  def index
    @projects = Project.published
  end

  def show
    @project = Project.find(params[:id])
    orders = Order.find_by_project_id(@project)
    @total_price = 0
    @progress = 0
    if !orders.nil?
      orders.each do |order|
        @total_price += order.total_price
      end
      @progress = @total_price / @project.total_price
    end
  end

end
