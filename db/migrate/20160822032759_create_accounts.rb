class CreateAccounts < ActiveRecord::Migration[5.0]
  def change
    create_table :accounts do |t|
      t.integer :balance
      t.integer :amount
      t.integer :user_id
      t.integer :profit

      t.timestamps
    end
  end
end
