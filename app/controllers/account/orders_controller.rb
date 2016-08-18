class Account::OrdersController < ApplicationController
  before_action :authenticate_user!
  layout 'user'

  def index
    @orders = current_user.orders.all.group(:project_id)
  end

  def show_orders_for_one_project
    @order = current_user.orders.find(params[:id])
    @project = Project.find(@order.project.id)
    @plans = @project.plans
    orders = []
    unless @plans.nil?
      @plans.each do |plan|
        unless plan.orders.nil?
          plan.orders.each do |order|
            puts "#{order.inspect}"
            orders.push(order)
          end
        end
      end
    end
    render json: orders
  end

  def show
    @order = current_user.orders.find_by_token(params[:id])
  end

  def pay_with_alipay
    @order = current_user.orders.find_by_token(params[:id])
    if @order.pay!('Alipay')
      flash[:notice] = "您已成功付款，再次感谢您的支持！"
      OrderMailer.notify_order_placed(@order).deliver!
    else
      flash[:alert] = "付款失败，请重新尝试。"
    end
    redirect_to account_order_path(@order.token)
  end

  def pay_with_wechat
    @order = current_user.orders.find_by_token(params[:id])
    if @order.pay!('WeChat')
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
