class AddProjectIdToPlan < ActiveRecord::Migration[5.0]
  def change
    add_column :plans, :project_id, :integer
  end
end
