class ChangeDefaultForAccount < ActiveRecord::Migration[5.0]
  def change
    change_column_default :accounts, :balance, 0
    change_column_default :accounts, :amount, 0
    change_column_default :accounts, :profit, 0
  end
end
