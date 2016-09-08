class Project < ApplicationRecord
  after_create :generate_custom_price_plan
  validates :name, presence: true
  validates :description, presence: true
  validates :fund_goal, numericality: { greater_than: 0, less_than: 1_000_000 }

  mount_uploader :image, ImageUploader
  has_many :plans
  has_many :posts
  belongs_to :user
  belongs_to :category


  attr_accessor :user_email

  scope :recent, -> { order("created_at DESC") }

  include AASM

  aasm do
    state :project_created, initial: true
    state :verifying
    state :online
    state :unverified
    state :offline

    event :apply_verify do
      transitions from: [:project_created, :unverified], to: :verifying
    end

    event :approve do
      transitions from: :verifying, to: :online
    end

    event :reject do
      transitions from: :verifying, to: :unverified
    end

    event :finish do
      transitions from: :online, to: :offline
    end

    event :admin_approve do
      transitions from: :project_created, to: :online
    end

    event :admin_reject do
      transitions from: :project_created, to: :unverified
    end
  end

  def generate_custom_price_plan
    @plan = plans.create!(description: "单纯地想支持Ta。", price: 1, plan_goal: 999_999, plan_type: 0, need_add: false)
  end
end

# == Schema Information
#
# Table name: projects
#
#  id              :integer          not null, primary key
#  name            :string
#  description     :text
#  user_id         :integer
#  image           :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  fund_goal       :integer
#  fund_progress   :integer          default(0)
#  backer_quantity :integer          default(0)
#  plans_count     :integer          default(0)
#  category_id     :integer
#  aasm_state      :string           default("project_created")
#  video           :string
#
# Indexes
#
#  index_projects_on_aasm_state  (aasm_state)
#
