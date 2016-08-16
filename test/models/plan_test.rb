# == Schema Information
#
# Table name: plans
#
#  id          :integer          not null, primary key
#  title       :string
#  description :text
#  quantity    :integer          default(1)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  price       :integer
#

require 'test_helper'

class PlanTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
