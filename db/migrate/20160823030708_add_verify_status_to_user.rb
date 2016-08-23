class AddVerifyStatusToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :aasm_state, :string
    add_index :users, :aasm_state
  end
end
