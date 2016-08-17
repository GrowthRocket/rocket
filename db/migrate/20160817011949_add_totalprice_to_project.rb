class AddTotalpriceToProject < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :total_price, :integer, default: 0
  end
end
