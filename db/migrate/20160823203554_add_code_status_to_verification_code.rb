class AddCodeStatusToVerificationCode < ActiveRecord::Migration[5.0]
  def change
    add_column :verification_codes, :code_status, :boolean, default: true
  end
end
