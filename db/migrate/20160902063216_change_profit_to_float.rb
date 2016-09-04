class ChangeProfitToFloat < ActiveRecord::Migration[5.0]
  def change
    change_column :accounts, :profit, :float
  end
end
