class Account::BillsController < AccountController
  def index
    @user = current_user
    @projects = @user.projects
    # binding.pry
    @payments = BillPayment.where(bill_status: %w(success paid), project_id: @projects)
    # @amount = BillPayment.where(bill_status: %w(success paid), user_id: @user.id).sum(:amount)
    # binding.pry
    # @bill_payouts = BillPayout.where(bill_status: "paid", project_id: @projects)
    # @payments_amount = @payments.sum(:amount)
    @account = Account.find_by_user_id(current_user.id)
    set_page_title_and_description("我的项目收入", view_context.truncate(@user.email, :length => 100))
  end
end
