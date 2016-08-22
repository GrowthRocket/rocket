class AddBillStatusToBillPayment < ActiveRecord::Migration[5.0]
  def change
    add_column :bill_payouts, :bill_status, :string
    add_index :bill_payouts, :bill_status
  end
end
