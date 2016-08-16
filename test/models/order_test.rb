# == Schema Information
#
# Table name: orders
#
#  id           :integer          not null, primary key
#  total_price  :integer
#  plan_id      :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  creator_name :string
#  backer_name  :string
#  price        :integer
#  quantity     :integer
#

require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
