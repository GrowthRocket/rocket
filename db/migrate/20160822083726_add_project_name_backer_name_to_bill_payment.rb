class AddProjectNameBackerNameToBillPayment < ActiveRecord::Migration[5.0]
  def change
    add_column :bill_payments, :project_name, :string
    add_column :bill_payments, :backer_name, :string
  end
end
