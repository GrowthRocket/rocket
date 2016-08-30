class AddPlanTypeToPlan < ActiveRecord::Migration[5.0]
  def change
    add_column :plans, :plan_type, :integer, default: 1
  end
end
