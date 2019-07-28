class Address < ApplicationRecord

  belongs_to :user
  has_many :orders, dependent: :destroy


  validates_presence_of :address,
                        :city,
                        :state,
                        :zip
end
