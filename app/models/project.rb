class Project < ApplicationRecord
  validates :name, presence: true
  validates :fund_goal, numericality: { greater_than: 0, less_than: 1_000_000 }

  mount_uploader :image, ImageUploader
  has_many :plans
  belongs_to :user
  belongs_to :category

  scope :published, -> { where(is_hidden: false) }

  scope :recent, -> { order("created_at DESC") }

  def publish!
    self.is_hidden = false
    save
  end

  def hide!
    self.is_hidden = true
    save
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
#  is_hidden       :boolean          default(TRUE)
#  fund_progress   :integer          default(0)
#  backer_quantity :integer          default(0)
#  plans_count     :integer          default(0)
#  category_id     :integer
#
