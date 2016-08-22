class CreateBillPayments < ActiveRecord::Migration[5.0]
  def change
    create_table :bill_payments do |t|
      t.string :order_id
      t.string :channel_id
      t.integer :amount
      t.integer :user_id
      t.integer :project_id
      t.integer :plan_id
      t.string :bill_status
      t.string :payment_method

      t.timestamps
    end
  end
end
