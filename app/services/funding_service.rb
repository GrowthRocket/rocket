class FundingService
  def initialize(order, user)
    @order = order
    @project = order.project
    @plan = order.plan
    @user = user
  end

  def add!
    @project.fund_progress += @order.total_price
    if @user.orders.where(id: @order).empty?
      @project.backer_quantity += 1
    end
    @project.save

    @plan.plan_progress += 1
    @plan.save
  end
end
