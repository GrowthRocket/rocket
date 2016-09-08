class Account::OrdersController < AccountController
  # after_action :add_payment_log, only: %i(pay_with_alipay pay_with_wechat)

  def index
    @orders = current_user.orders.select("project_id, project_name").group(:project_id, :project_name)
    # @orders = current_user.orders.select("id").where(project_id: @project_ids).distinct
    set_page_title_and_description("我支持的项目", view_context.truncate(@orders.first .nil? ? "我支持的项目" : @orders.first.project_name, :length => 100))
  end

  def show_orders_for_one_project
    # @order = current_user.orders.find(params[:id])
    # @project = @order.project
    # @plans = @project.plans

    @orders = current_user.orders.where(project_id: params[:id])

    render json: @orders
  end

  def show
    @order = current_user.orders.find_by_token(params[:id])
    set_page_title_and_description("订单", view_context.truncate(@order.project_name, :length => 100))
  end

  def pay_with_alipay
    @order = current_user.orders.find_by_token(params[:id])
    if add_payment_log("Alipay")
      flash[:notice] = "您已成功付款，感谢您的支持！"
      OrderMailer.notify_order_placed(@order).deliver!
    else
      flash[:alert] = "付款失败，请重新尝试。"
    end
    redirect_to account_order_path(@order.token)
  end

  def pay_with_wechat
    @order = current_user.orders.find_by_token(params[:id])
    if add_payment_log("WeChat")
      flash[:notice] = "您已成功付款，感谢您的支持！"
      OrderMailer.notify_order_placed(@order).deliver!
    else
      flash[:alert] = "付款失败，请重新尝试。"
    end
    redirect_to account_order_path(@order.token)
  end

  def add_payment_log(payment_method)
    FundingService.new(@order, current_user, payment_method).add_progress!
  end

  private

  def order_params
    params.require(:order).permit(:backer_name, :price, :quantity, :plan_id)
  end
end
