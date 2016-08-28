class FundingService
  # def initialize(order, user, project)
  def initialize(options)
    @order = options[:order] unless options[:order].nil?
    @project = @order.project unless options[:order].nil?
    @plan = @order.plan unless options[:order].nil?
    @user = options[:user] unless options[:user].nil?
    @project = options[:project] unless options[:project].nil?
    @amount = options[:amount] unless options[:amount].nil?
    @payment_method = options[:payment_method] unless options[:payment_method].nil?
  end

  # TODO: 需要加锁、加事务
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
    @order.pay!(@payment_method)
    BillPayment.create(
      order_id: @order.id, channel_id: 0,
      amount: @order.total_price, user_id: @user.id, backer_name: @order.backer_name, project_id: @project.id, project_name: @project.name,
      plan_id: @plan.id, bill_status: "success", payment_method: @order.payment_method,
      plan_description: @plan.description
    )

    @account = @user.account
    @account.amount += @order.total_price
    @account.save
  end

  def payout!
    user = @project.user
    account = user.account
    account.profit += @amount
    account.save

    BillPayout.create(project_id: @project.id, amount: @amount, account_name: account.account_name,
    user_id: user.id, bill_status: "paid", project_name: @project.name, creator_name: user.user_name)
  end

  def add_progress!
    add!
    send_notification!
  end

  def send_notification!
    Notification.create(recipient: @project.user, actor: @user, action: "fund", notifiable: @order)
  end
end
