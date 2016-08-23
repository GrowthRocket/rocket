class Admin::BillsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_is_admin
  before_action :get_fund_rate, :only => [:index, :payout_index, :payments_index, :show_bill_payments, :show_bill_payouts]
  layout "admin"

  def index
    @bill_payments = BillPayment.bill_payment_by_project_id(["success", "paid"])
    # @bill_payout = BillPayment.where(bill_status: "success")
  end

  def payout_index
    @bill_payouts = BillPayout.bill_payout_by_project_id(["success", "paid"])
  end

  def payments_index
    @payment_amount = BillPayment.where(bill_status: ["success", "paid"]).sum(:amount)
    @payout_amount = BillPayout.where(bill_status: "paid").sum(:amount)
  end

  def custom_fund_rate
    ENV['fund_rate'] = params[:fund_rate]
    flash[:notice] = "服务费比例修改成功"
    redirect_back(fallback_location: root_path)
  end


  def get_fund_rate
    @fund_rate = ENV['fund_rate']
  end

  def show_bill_payments
    query_type = params[:query_type]
    case query_type
    when "success_bill"
      @bill_payments = BillPayment.bill_payment_by_project_id(["success", "paid"])
    when "faild_bill"
      @bill_payments = BillPayment.bill_payment_by_project_id(["faild",""])
    when "wait_bill"
      @bill_payments = BillPayment.bill_payment_by_project_id(["wait", ""])
    else
      @bill_payments = BillPayment.bill_payment_by_project_id(["success", "paid"])
    end
    render json: @bill_payments
  end

  def show_bill_payouts
    query_type = params[:query_type]
    case query_type
    when "success_bill"
      @bill_payouts = BillPayout.bill_payout_by_project_id(["success", "paid"])
    when "faild_bill"
      @bill_payouts = BillPayout.bill_payout_by_project_id(["faild",""])
    when "wait_bill"
      @bill_payouts = BillPayout.bill_payout_by_project_id(["wait", ""])
    else
      @bill_payouts = BillPayout.bill_payout_by_project_id(["success", "paid"])
    end
    render json: @bill_payouts
  end

  def show_bill_payments_by_project
    @payments = BillPayment.success_payment_by_project(params[:id])
  end

  def payout
    @project = Project.find(params[:id])
    amount = BillPayment.where(bill_status: "success", project_id: params[:id]).sum(:amount)
    final_amount = ((100 - ENV['fund_rate'].to_f) / 100) * amount
    binding.pry
    options = {project: @project, amount: final_amount}
    if FundingService.new(options).payout!
      BillPayment.where(project_id: params[:id]).update_all(bill_status: "paid")
      flash[:notice] = "资金发放成功！"
    else
      flash[:danger] = "资金发放失败！"
    end
    redirect_back(fallback_location: root_path)
  end


end
