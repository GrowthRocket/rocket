class Admin::OrdersController < AdminController
  def index
    @orders = Order.all
  end

  def show
    @order = Order.find_by_token(params[:id])
  end

  def new
    plan = Plan.find(params[:plan_id])
    @order = Order.new(price: plan.price, quantity: plan.quantity, project_id: plan.project_id)
  end

  def create
    @order = Order.new(order_params)
    @order.creator_name = current_user.user_name
    @order.user = current_user
    plan = Plan.find(@order.plan_id)
    @order.project_id = plan.project_id
    @order.total_price = @order.price * @order.quantity
    if @order.save!
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
