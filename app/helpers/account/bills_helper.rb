module Account::BillsHelper
  def render_payment_plan_description(description)
    truncate(sanitize(description), escape: false, length: 50)
  end
end
