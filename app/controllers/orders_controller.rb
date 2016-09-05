class OrdersController < ApplicationController
  before_action :authenticate_user!

  def new
    @plan = Plan.find(params[:plan_id])
    @order = @plan.orders.build(price: @plan.price, quantity: @plan.quantity)
  end

  # TODO: 实现创建订单并修改状态。
  def create
    payment_method = case params[:commit]
    when "微信支付"
      "WeChat"
    when "支付宝支付"
      "Alipay"
    end
    assemble_order
    unless deal_need_add?
      flash[:alert] = "请填写接收回报的地址"
      render "new"
      return
    end
    if @order.save
      @order.plan_description = @plan.description
      @order.project_name = @project.name
      @order.save
      if FundingService.new(@order, current_user, payment_method).add_progress!
        flash[:notice] = "您已成功付款，感谢您的支持！"
        OrderMailer.notify_order_placed(@order).deliver!
      else
        flash[:alert] = "付款失败，请重新尝试。"
      end
      redirect_to account_order_path(@order.token)
    else
      render "new"
    end
  end

  protected

  def deal_need_add?
    if @plan.need_add
      if @order.address.blank?
        false
      else
        true
      end
    else
      true
    end
  end

  def assemble_order
    @plan = Plan.find(params[:plan_id])
    @project = @plan.project
    @order = @plan.orders.build(order_params)
    @order.creator_name = @project.user.user_name
    @order.backer_name = current_user.user_name.blank? ? current_user.email : current_user.user_name
    @order.user = current_user
    @order.project = @project
  end

  private

  def order_params
    params.require(:order).permit(:price, :quantity, :plan_id, :address)
  end
end
