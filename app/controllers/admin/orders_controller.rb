class Admin::OrdersController < ApplicationController
  before_action :authenticate_user!
  layout 'admin'

  def index
    @orders = Order.all
  end

  def show
    @order = Order.find_by_token(params[:id])
  end

  def new
    @order = Order.new()
  end

  def create
    @order = Order.new(order_params)
    @order.creator_name = current_user.email
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

  private

  def order_params
    params.require(:order).permit(:plan_id, :backer_name, :price, :quantity)
  end
end
