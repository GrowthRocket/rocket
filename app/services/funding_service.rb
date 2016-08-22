class FundingService
  def initialize(order, user)
    @order = order
    @project = order.project
    @plan = order.plan
    @user = user
  end

  # TODO 需要加锁、加事务
  def add!
    @project.fund_progress += @order.total_price
    # @user.orders.where("orders_count = ? AND locked = ?", params[:orders], false)
    if @user.orders.where(project_id: @order.project, aasm_state: "paid").empty?
      @project.backer_quantity += 1
    end
    @project.save

    if @user.orders.where(plan_id: @order.plan, aasm_state: "paid").empty?
      @plan.backer_quantity += 1
    else
      @user.orders.where(plan_id: @order.plan)
    end

    @plan.plan_progress += 1
    @plan.save

    BillPayment.create(order_id: @order.id, channel_id: 0,
    amount: @order.total_price, user_id: @user.id, backer_name: @order.backer_name, project_id: @project.id, project_name: @project.name
    plan_id: @plan.id, bill_status: "success", payment_method: @order.payment_method)

    @account = @user.account
    @account.amount += @order.total_price
    @account.save

  end
end
