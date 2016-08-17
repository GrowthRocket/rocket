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
#  project_id  :integer
#

class Plan < ApplicationRecord
  validates :title, presence: true
  validates :description, presence: true
  validates :price, presence: true
  validates :price, numericality: {greater_than: 0}
  validates :plan_goal, presence: true
  validates :plan_goal, numericality: {greater_than: 0}
  belongs_to :project
end
