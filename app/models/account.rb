class Account < ApplicationRecord
end

# == Schema Information
#
# Table name: accounts
#
#  id           :integer          not null, primary key
#  balance      :integer          default(0)
#  amount       :integer          default(0)
#  user_id      :integer
#  profit       :integer          default(0)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  account_name :string
#
