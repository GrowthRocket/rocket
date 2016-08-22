require 'test_helper'

class BillPayoutTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
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
#
