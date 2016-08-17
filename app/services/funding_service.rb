class FundingService
  def initialize(order)
    @order = order
    @project = order.project
    @plan = order.plan
  end

  def add!
    @project.fund_progress += @order.total_price
    @project.backer_quantity += 1
    @project.save

    @plan.plan_progress += 1
    @plan.save
  end
end
