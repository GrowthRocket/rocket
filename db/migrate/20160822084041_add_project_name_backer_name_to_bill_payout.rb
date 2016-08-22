class AddProjectNameBackerNameToBillPayout < ActiveRecord::Migration[5.0]
  def change
    add_column :bill_payouts, :project_name, :string
    add_column :bill_payouts, :creator_name, :string
  end
end
