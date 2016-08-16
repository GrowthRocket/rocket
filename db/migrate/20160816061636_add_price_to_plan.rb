class AddPriceToPlan < ActiveRecord::Migration[5.0]
  def change
    add_column :plans, :price, :integer
  end
end
