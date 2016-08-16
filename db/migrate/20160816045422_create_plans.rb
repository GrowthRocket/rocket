class CreatePlans < ActiveRecord::Migration[5.0]
  def change
    create_table :plans do |t|
      t.string :title
      t.text :description
      t.integer :quantity, default: 1
      t.timestamps
    end
  end
end
