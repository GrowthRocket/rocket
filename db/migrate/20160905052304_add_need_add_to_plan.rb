class AddNeedAddToPlan < ActiveRecord::Migration[5.0]
  def change
    add_column :plans, :need_add, :boolean, default: false
  end
end
