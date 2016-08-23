class Account::OrdersController < ApplicationController
  before_action :authenticate_user!
  after_action :add_payment_log, :only => [:pay_with_alipay, :pay_with_wechat]
  layout "user"

  def index
    @orders = current_user.orders.all.group(:project_id)
  end

  def show_orders_for_one_project
    @order = current_user.orders.find(params[:id])
    @project = @order.project
    # @plans = @project.plans

    @orders = current_user.orders.where(project_id: @project.id)

    render json: @orders
  end

  def show
    @order = current_user.orders.find_by_token(params[:id])
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

  def add_payment_log
    options = {order: @order, user: current_user}
    FundingService.new(options).add_progress!
  end

  private

  def order_params
    params.require(:order).permit(:backer_name, :price, :quantity, :plan_id)
  end
end
