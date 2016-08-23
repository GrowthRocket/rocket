
class Plan < ApplicationRecord
  validates :title, presence: true
  validates :description, presence: true
  validates :price, presence: true
  validates :price, numericality: { greater_than: 0, less_than: 1_000_000 }
  validates :plan_goal, presence: true
  validates :plan_goal, numericality: { greater_than: 0, less_than: 1_000_000 }
  belongs_to :project, counter_cache: true
  has_many :orders

  scope :recent, -> { order("created_at DESC") }
end

# == Schema Information
#
# Table name: plans
#
#  id              :integer          not null, primary key
#  title           :string
#  description     :text
#  quantity        :integer          default(1)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  price           :integer
#  project_id      :integer
#  plan_goal       :integer
#  plan_progress   :integer          default(0)
#  backer_quantity :integer          default(0)
#
