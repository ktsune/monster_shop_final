class Address < ApplicationRecord

  belongs_to :user
  has_many :orders, dependent: :destroy


  validates_presence_of :address, :city
  validates :state, presence: true, length: { is: 2 }
  validates :zip, presence: true, numericality: true, length: { is: 5}

  def shipped_order?
    self.orders.where(status: "shipped").any?
  end
end
