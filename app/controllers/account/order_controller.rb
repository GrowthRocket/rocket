class Account::OrderController < ApplicationController
  before_action :authenticate_user!

  def index
    @orders = current_user.orders.all
  end

  def show
    @order = current_user.orders.find_by_token(params[:id])
    render "admin/orders/show"
  end

  def new
    plan = Plan.find(params[:plan_id])
    @order = Order.new(price: plan.price, quantity: plan.quantity)
  end

  def create
    @order = Order.new(order_params)
    @order.creator_name = current_user.email
    @order.user = current_user
    @order.total_price = @order.price * @order.quantity
    if @order.save
      flash[:notice] = "Successfully created one order."
      redirect_to admin_order_path(@order.token)
    else
      flash[:notice] = "Faild to  creat one order."
      redirect_back(fallback_location: root_path)
    end
  end

  def pay_with_alipay
    order = current_user.orders.find_by_token(params[:id])
    if order.pay!("Alipay")
      flash[:notice] = "Pay Successfully."
    else
      flash[:alert] = "Pay Faild"
    end
    redirect_to account_order_path(order.token)
  end

  def pay_with_wechat
    order = current_user.orders.find_by_token(params[:id])
    if order.pay!("WeChat")
      flash[:notice] = "Pay Successfully."
    else
      flash[:alert] = "Pay Faild"
    end
    redirect_to account_order_path(order.token)
  end

  private

  def order_params
    params.require(:order).permit(:plan_id, :backer_name, :price, :quantity)
  end


end
