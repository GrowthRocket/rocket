class ChangeColumnDefault < ActiveRecord::Migration[5.0]
  def change
    change_column_default(:projects, :fund_goal, nil)
    change_column_default(:projects, :fund_progress, 0)
  end
end
