class AddIndexToBillPayment < ActiveRecord::Migration[5.0]
  def change
    add_index :bill_payments, :bill_status
  end
end
