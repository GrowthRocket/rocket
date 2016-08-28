class Account::BillsController < AccountController
  def index
    @user = current_user
    @projects = @user.projects
    @payments = BillPayment.where(bill_status: %w(success paid), project_id: @projects)
    # @payments_amount = @payments.sum(:amount)
    @account = Account.find_by_user_id(current_user.id)
  end
end
