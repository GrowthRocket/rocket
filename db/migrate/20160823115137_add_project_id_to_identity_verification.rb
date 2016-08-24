class AddProjectIdToIdentityVerification < ActiveRecord::Migration[5.0]
  def change
    add_column :identity_verifications, :project_id, :integer
  end
end
