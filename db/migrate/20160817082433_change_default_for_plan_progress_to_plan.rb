class ChangeDefaultForPlanProgressToPlan < ActiveRecord::Migration[5.0]
  def change
    change_column_default(:plans, :plan_progress, 0)
  end
end
