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
#

class Plan < ApplicationRecord
  validates :title, presence: true
  validates :description, presence: true
end
