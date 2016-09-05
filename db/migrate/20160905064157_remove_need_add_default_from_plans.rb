class RemoveNeedAddDefaultFromPlans < ActiveRecord::Migration[5.0]
  def change
    change_column_default("plans", "need_add", nil)
  end
end
