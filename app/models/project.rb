class Project < ApplicationRecord
  validates :name, presence: true

  mount_uploader :image, ImageUploader
  has_many :plans
end
