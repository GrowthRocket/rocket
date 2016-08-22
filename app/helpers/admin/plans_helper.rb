module Admin::PlansHelper
  def render_plan_description(plan)
    truncate(simple_format(plan.description), escape: false, length: 20)
  end
end
