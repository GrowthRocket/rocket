class AddVideoToProject < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :video, :string
  end
end
