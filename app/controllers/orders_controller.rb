class OrdersController < ApplicationController
  before_action :authenticate_user!

  def new
    @plan = Plan.find(params[:plan_id])
    @order = @plan.orders.build(price: @plan.price, quantity: @plan.quantity)
  end

  def create
    @plan = Plan.find(params[:plan_id])
    @project = @plan.project

    @order = @plan.orders.build(order_params)
    @order.creator_name = current_user.user_name
    @order.user = current_user

    @order.project = @project

    if @order.save

      FundingService.new(@order, current_user).add!

      flash[:notice] = "感谢您对本项目的支持！"
      redirect_to account_order_path(@order.token)
    else
      render 'new'
      # redirect_back(fallback_location: root_path)
    end
  end

  private

  def order_params
    params.require(:order).permit(:backer_name, :price, :quantity, :plan_id)
  end
end
