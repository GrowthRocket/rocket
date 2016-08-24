class AddPlanTypeToPlan < ActiveRecord::Migration[5.0]
  def change
    add_column :plans, :plan_type, :byte, default: 1
  end
end
