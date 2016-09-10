class AddChsNameToCategory < ActiveRecord::Migration[5.0]
  def change
    add_column :categories, :chs_name, :string, default: "Simplified Chinese"
  end
end
