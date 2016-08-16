class CreateOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :orders do |t|
      t.integer :total_price
      t.integer :plan_id

      t.timestamps
    end
  end
end
