class CreateProjects < ActiveRecord::Migration[5.0]
  def change
    create_table :projects do |t|
      t.string :name
      t.text :description
      t.integer :user_id
      t.string :image

      t.timestamps
    end
  end
end
