class AddMoreDetailsToProject < ActiveRecord::Migration[5.0]
  def change
    rename_column :projects, :total_price, :fund_goal
    add_column :projects, :is_hidden, :boolean, default: true
    add_column :projects, :fund_progress, :integer
    add_column :projects, :backer_quantity, :integer, default: 0
  end
end
