class AddPlanQuantityGoalToPlan < ActiveRecord::Migration[5.0]
  def change
    add_column :plans, :plan_goal, :integer
    add_column :plans, :plan_progress, :integer
  end
end
