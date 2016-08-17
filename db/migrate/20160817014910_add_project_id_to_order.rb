class AddProjectIdToOrder < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :project_id, :integer
  end
end
