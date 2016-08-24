class AddPhoneNumberToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :phone_number, :integer
    add_column :users, :captcha, :integer
  end
end
