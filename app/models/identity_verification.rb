class IdentityVerification < ApplicationRecord
  validates :message, presence: true
end

# == Schema Information
#
# Table name: identity_verifications
#
#  id            :integer          not null, primary key
#  verify_type   :integer
#  user_id       :integer
#  title         :string
#  image         :string
#  verify_status :integer
#  message       :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  project_id    :integer
#
