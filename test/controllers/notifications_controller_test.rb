# == Schema Information
#
# Table name: notifications
#
#  id              :integer          not null, primary key
#  recipient_id    :integer
#  actor_id        :integer
#  read_at         :datetime
#  action          :string
#  notifiable_id   :integer
#  notifiable_type :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'test_helper'

class NotificationsControllerTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
end
