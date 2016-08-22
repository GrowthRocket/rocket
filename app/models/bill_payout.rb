class BillPayout < ApplicationRecord
end

# == Schema Information
#
# Table name: bill_payouts
#
#  id           :integer          not null, primary key
#  project_id   :integer
#  amount       :integer
#  account_name :string
#  user_id      :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  bill_status  :string
#  project_name :string
#  creator_name :string
#
# Indexes
#
#  index_bill_payouts_on_bill_status  (bill_status)
#
