class Address < ApplicationRecord

  belongs_to :user
  belongs_to :order

  validates_presence_of :address,
                        :city,
                        :state,
                        :zip 
end
