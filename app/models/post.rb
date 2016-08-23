class Post < ApplicationRecord
  belongs_to :project
  validates :description, presence: true
  scope :recent, -> { order("created_at DESC") }
end

# == Schema Information
#
# Table name: posts
#
#  id          :integer          not null, primary key
#  description :text
#  project_id  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
