class AddPlanDescriptionToBillPayment < ActiveRecord::Migration[5.0]
  def change
    add_column :bill_payments, :plan_description, :text
  end
end
