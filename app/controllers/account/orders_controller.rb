class Account::OrdersController < ApplicationController
  before_action :authenticate_user!

  def index
    @orders = current_user.orders.all
  end

  def show
    @order = current_user.orders.find_by_token(params[:id])
  end

  def new
    plan = Plan.find(params[:plan_id])
    @order = Order.new(price: plan.price, quantity: plan.quantity, plan_id: plan.id)
  end

  def create
    @order = Order.new(order_params)
    @order.creator_name = current_user.user_name
    @order.user = current_user
    plan = Plan.find(@order.plan_id)
    @order.project_id = plan.project_id
    total_price = @order.price * @order.quantity
    @order.total_price = total_price
    if @order.save
      project = Project.find(@order.project_id)
      project.fund_progress += total_price
      project.backer_quantity += 1
      flash[:notice] = "感谢您对本项目的支持！"
      redirect_to account_order_path(@order.token)
    else
      render "new"
      # redirect_back(fallback_location: root_path)
    end
  end

  def pay_with_alipay
    @order = current_user.orders.find_by_token(params[:id])
    if @order.pay!("Alipay")
      flash[:notice] = "您已成功付款，再次感谢您的支持！"
      OrderMailer.notify_order_placed(@order).deliver!
    else
      flash[:alert] = "付款失败，请重新尝试。"
    end
    redirect_to account_order_path(@order.token)
  end

  def pay_with_wechat
    @order = current_user.orders.find_by_token(params[:id])
    if @order.pay!("WeChat")
      flash[:notice] = "您已成功付款，再次感谢您的支持！"
      OrderMailer.notify_order_placed(@order).deliver!
    else
      flash[:alert] = "付款失败，请重新尝试。"
    end
    redirect_to account_order_path(@order.token)
  end

  private

  def order_params
    params.require(:order).permit(:backer_name, :price, :quantity, :plan_id)
  end


end
