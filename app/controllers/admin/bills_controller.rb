class Admin::BillsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_is_admin
  layout "admin"

  def index
    @payment_amount = BillPayment.where(bill_status: "success").sum(:amount)
    @payout_amount = BillPayout.where(bill_status: "success").sum(:amount)
    @bill_payments = BillPayment.where(bill_status: "success")
    # @bill_payout = BillPayment.where(bill_status: "success")
  end

  def payout_index
    @payment_amount = BillPayment.where(bill_status: "success").sum(:amount)
    @payout_amount = BillPayout.where(bill_status: "success").sum(:amount)
    @bill_payouts = BillPayout.where(bill_status: "success")
  end

  def show_bill_payments
    query_type = params[:query_type]
    case query_type
    when "success_bill"
      @bill_payments = BillPayment.where(bill_status: "success")
    when "faild_bill"
      @bill_payments = BillPayment.where(bill_status: "faild")
    when "wait_bill"
      @bill_payments = BillPayment.where(bill_status: "wait")
    else
      @bill_payments = BillPayment.where(bill_status: "success")
    end
    render json: @bill_payments
  end

  def show_bill_payouts
    query_type = params[:query_type]
    case query_type
    when "success_bill"
      @bill_payouts = BillPayout.where(bill_status: "success")
    when "faild_bill"
      @bill_payouts = BillPayout.where(bill_status: "faild")
    when "wait_bill"
      @bill_payouts = BillPayout.where(bill_status: "wait")
    else
      @bill_payouts = BillPayout.where(bill_status: "success")
    end
    render json: @bill_payouts
  end

end
