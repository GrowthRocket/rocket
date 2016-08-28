class OrdersController < ApplicationController
  before_action :authenticate_user!

  def new
    @plan = Plan.find(params[:plan_id])
    if @plan.plan_type == 0
      custom_price = params[:custom_price]
      if custom_price == ""
        flash[:alert] = "请输入自定义金额"
        redirect_to new_plan_path
      else
        @plan.price = custom_price
        if @plan.save
          @order = @plan.orders.build(price: @plan.price, quantity: @plan.quantity)
        else
          render "plans/index"
        end
      end
    else
      @order = @plan.orders.build(price: @plan.price, quantity: @plan.quantity)
    end
  end

  def create
    @plan = Plan.find(params[:plan_id])
    @project = @plan.project

    @order = @plan.orders.build(order_params)
    @order.creator_name = current_user.user_name
    @order.user = current_user
    binding.pry
    @order.project = @project

    if @order.save
      @order.plan_description = @plan.description
      @order.project_name = @project.name
      @order.save
      flash[:notice] = "感谢您对本项目的支持！"
      redirect_to account_order_path(@order.token)
    else
      render "new"
      # redirect_back(fallback_location: root_path)
    end
  end

  private

  def order_params
    params.require(:order).permit(:backer_name, :price, :quantity, :plan_id)
  end
end
