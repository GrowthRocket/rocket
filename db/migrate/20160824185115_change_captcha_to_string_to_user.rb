class ChangeCaptchaToStringToUser < ActiveRecord::Migration[5.0]
  def change
    change_column :users, :captcha, :string
  end
end
