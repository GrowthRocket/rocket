class CreateBillPayouts < ActiveRecord::Migration[5.0]
  def change
    create_table :bill_payouts do |t|
      t.integer :project_id
      t.integer :amount
      t.string :account_name
      t.integer :user_id

      t.timestamps
    end
  end
end
