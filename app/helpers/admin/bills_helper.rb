module Admin::BillsHelper
  def render_fund_rate(fund_rate)
    fund_rate + "%"
  end

  def render_service_charge(amount, fund_rate)
     "¥" + number_with_precision(((100 - fund_rate.to_f) / 100 * amount ), :precision => 2).to_s
  end

  def render_amount(amount)
    "¥" + amount.to_s
  end


  def render_bill_status(bill_status)
    case bill_status
    when "success"
      content_tag(:span, "待打款", class: "label label-warning")
    when "paid"
      content_tag(:span, "已打款", class: "label label-success")
    when "faild"
      content_tag(:span, "失败", class: "label label-danger")
    when "wait"
      content_tag(:span, "待核对", class: "label label-info")
    end
  end
end
