class Address < ApplicationRecord

  belongs_to :user
  has_many :orders, dependent: :destroy


  validates_presence_of :address,
                        :city,
                        :state,
                        :zip

  def shipped_order?
    self.orders.where(status: "shipped").any?
  end
end
