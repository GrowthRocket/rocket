class ProjectsController < ApplicationController

  def index
    @projects = Project.published
  end

  def show
    @project = Project.find(params[:id])
    orders = Order.all.where(project_id: @project.id)
    puts "-------------"
    @total_price = 0
    @progress = 0
    if !orders.nil?
      orders.each do |order|
        @total_price += order.total_price
      end
      @progress = @total_price.to_f / @project.fund_goal * 100
    end
  end

end
