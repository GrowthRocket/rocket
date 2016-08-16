class RemoveColFromProject < ActiveRecord::Migration[5.0]
  def change
    remove_column :projects, :quantity, :integer
  end
end
