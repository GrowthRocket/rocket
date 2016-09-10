class AddPlanDescriptionProjectNameToOrder < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :plan_description, :text
    add_column :orders, :project_name, :string
  end
end
