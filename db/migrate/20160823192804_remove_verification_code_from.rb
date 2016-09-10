class RemoveVerificationCodeFrom < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :verification_code
  end
end
