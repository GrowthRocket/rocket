class Account::OrderController < ApplicationController
  before_action :authenticate_user!

  def show
    @order = current_user.orders.find_by_token(params[:id])
    render "admin/orders/show"
  end

  def pay_with_alipay
    puts "#{params[:id]}-------------"
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
end
