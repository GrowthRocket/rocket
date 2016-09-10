class RemoveColumnFromProject < ActiveRecord::Migration[5.0]
  def change
    remove_column :projects, :is_hidden, :boolean, default: true
  end
end
