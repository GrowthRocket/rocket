class PayoutService
  def initialize(project, amount)
    @project = project
    @amount = amount
    @user = @project.user
  end

  def perform!
    account = @user.account
    account.profit += @amount
    account.save

    BillPayout.create(
      project_id: @project.id, amount: @amount, account_name: account.account_name,
      user_id: @user.id, bill_status: "paid", project_name: @project.name, creator_name: @user.user_name
    )
  end
end
