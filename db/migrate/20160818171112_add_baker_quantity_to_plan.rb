class AddBakerQuantityToPlan < ActiveRecord::Migration[5.0]
  def change
    add_column :plans, :backer_quantity, :integer, default: 0
  end
end
