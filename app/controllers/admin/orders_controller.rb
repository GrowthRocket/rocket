class Admin::OrdersController < ApplicationController
  before_action :authenticate_user!
  layout 'admin'

  def index
    @orders = current_user.orders.all
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
      flash[:notice] = "Successfully created one order."
      redirect_to admin_order_path(@order.token)
    else
      flash[:notice] = "Faild to  creat one order."
      redirect_back(fallback_location: root_path)
    end
  end

  private

  def order_params
    params.require(:order).permit(:plan_id, :backer_name, :price, :quantity)
  end
end
