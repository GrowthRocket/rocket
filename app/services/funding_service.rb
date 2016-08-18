class FundingService
  def initialize(order, user)
    @order = order
    @project = order.project
    @plan = order.plan
    @user = user
  end

  def add!
    @project.fund_progress += @order.total_price
    if @user.orders.where(project_id: @order.project).empty?
      @project.backer_quantity += 1
    end
    @project.save

    if @user.orders.where(plan_id: @order.plan).empty?
      @plan.backer_quantity += 1
    end

    @plan.plan_progress += 1
    @plan.save
  end
end
