class CreatePosts < ActiveRecord::Migration[5.0]
  def change
    create_table :posts do |t|
      t.text :description
      t.integer :project_id
      t.timestamps
    end
  end
end
