class ChangeAccountsDefault < ActiveRecord::Migration[5.0]
  def change
    change_column_default :accounts, :balance, default: 0
    change_column_default :accounts, :amount, default: 0
    change_column_default :accounts, :profit, default: 0
  end
end
