class AddCountryCodeToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :country_code, :string, default: "+86"
  end
end
