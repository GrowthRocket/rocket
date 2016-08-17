class Account::OrderController < ApplicationController
  before_action :authenticate_user!

  def index
    @orders = current_user.orders.all
  end

  def show
    @order = current_user.orders.find_by_token(params[:id])
  end

  def new
    plan = Plan.find(params[:plan_id])
    @order = Order.new(price: plan.price, quantity: plan.quantity, project_id: plan.project_id)
  end

  def create
    @order = Order.new(order_params)
    @order.creator_name = current_user.name
    @order.user = current_user
    @order.total_price = @order.price * @order.quantity
    if @order.save
      flash[:notice] = "感谢您对本项目的支持！"
      redirect_to account_order_path(@order.token)
    else
      flash[:notice] = "创建订单失败，请再次尝试。"
      redirect_back(fallback_location: root_path)
    end
  end

  def pay_with_alipay
    order = current_user.orders.find_by_token(params[:id])
    if order.pay!("Alipay")
      flash[:notice] = "您已成功付款，再次感谢您的支持！"
    else
      flash[:alert] = "付款失败，请重新尝试。"
    end
    redirect_to account_order_path(order.token)
  end

  def pay_with_wechat
    order = current_user.orders.find_by_token(params[:id])
    if order.pay!("WeChat")
      flash[:notice] = "您已成功付款，再次感谢您的支持！"
    else
      flash[:alert] = "付款失败，请重新尝试。"
    end
    redirect_to account_order_path(order.token)
  end

  private

  def order_params
    params.require(:order).permit(:plan_id, :backer_name, :price, :quantity, :project_id)
  end


end
