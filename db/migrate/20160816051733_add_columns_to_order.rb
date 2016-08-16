class AddColumnsToOrder < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :creator_name, :string
    add_column :orders, :backer_name, :string
  end
end
