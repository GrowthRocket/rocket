class AddAccountNameToAccount < ActiveRecord::Migration[5.0]
  def change
    add_column :accounts, :account_name, :string
  end
end
