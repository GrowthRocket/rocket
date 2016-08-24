class CreateVerificationCodes < ActiveRecord::Migration[5.0]
  def change
    create_table :verification_codes do |t|
      t.string :phone_number
      t.string :verification_code

      t.timestamps
    end
  end
end
