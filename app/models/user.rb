# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  is_admin               :boolean          default(FALSE)
#  user_name              :string
#  image                  :string
#  aasm_state             :string
#
# Indexes
#
#  index_users_on_aasm_state            (aasm_state)
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  after_create :create_account

  mount_uploader :image, HeadimageUploader

  def admin?
    is_admin
  end

  has_many :orders
  has_many :projects
  has_one :account
  has_many :identiy_verifications

  def generate_account
    create_account
  end

  include AASM

  aasm do
    state :user_registered, initial: true
    state :passed_verified
    state :unpassed_verified

    event :apply_for_certify do
      transitions from: :user_registered, to: :unpassed_verified
    end
    event :approve do
      transitions from: :unpassed_verified, to: :passed_verified
    end
  end

end
