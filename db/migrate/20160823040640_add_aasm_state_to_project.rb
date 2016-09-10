class AddAasmStateToProject < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :aasm_state, :string, default: "project_created"
    add_index  :projects, :aasm_state
  end
end
