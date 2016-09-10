
class Order < ApplicationRecord
  belongs_to :user
  belongs_to :project
  belongs_to :plan

  scope :paid, -> { where(aasm_state: "paid") }

  before_create :calculate_total

  def calculate_total
    self.total_price = quantity * price
  end

  include AASM

  aasm do
    state :order_placed, initial: true
    state :paid
    state :shipping
    state :shipped
    state :order_cancelled
    state :good_returned
    state :appling_cancel_order
    state :appling_good_return

    event :make_payment do
      transitions from: :order_placed, to: :paid
    end

    event :ship do
      transitions from: :paid, to: :shipping
    end

    event :deliver do
      transitions from: :shipping, to: :shipped
    end

    event :return_good do
      transitions from: %i(shipped appling_good_return), to: :good_returned
    end

    event :cancel_order do
      transitions from: %i(order_placed paid appling_cancel_order), to: :order_cancelled
    end

    event :apply_cancel_order do
      transitions from: %i(order_placed paid), to: :appling_cancel_order
    end

    event :apply_good_return do
      transitions from: :shipped, to: :appling_good_return
    end
  end

  validates :backer_name, presence: true

  before_create :generate_token

  def generate_token
    self.token = SecureRandom.uuid
  end

  def pay!(payment_method)
    unless paid?
      update_column(:payment_method, payment_method)
      make_payment!
      # OrderMailer.notify_order_placed(self).deliver!
    end
  end
end

# == Schema Information
#
# Table name: orders
#
#  id               :integer          not null, primary key
#  total_price      :integer
#  plan_id          :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  creator_name     :string
#  backer_name      :string
#  price            :integer
#  quantity         :integer          default(1)
#  payment_method   :string
#  token            :string
#  aasm_state       :string           default("order_placed")
#  user_id          :integer
#  project_id       :integer
#  plan_description :text
#  project_name     :string
#  address          :string
#
# Indexes
#
#  index_orders_on_aasm_state  (aasm_state)
#
