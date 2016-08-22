class Account < ApplicationRecord
end

# == Schema Information
#
# Table name: accounts
#
#  id           :integer          not null, primary key
#  balance      :integer
#  amount       :integer
#  user_id      :integer
#  profit       :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  account_name :string
#

belongs_to :user
