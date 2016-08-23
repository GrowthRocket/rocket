class Account::BillsController < ApplicationController
  layout "user"
  def index
    @user = current_user
    @projects = @user.projects
    @payments = BillPayment.where(bill_status: %w(success paid), project_id: @projects)
    @payments_amount = @payments.sum(:amount)
  end
end
