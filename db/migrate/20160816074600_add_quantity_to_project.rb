class AddQuantityToProject < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :quantity, :integer
  end
end
