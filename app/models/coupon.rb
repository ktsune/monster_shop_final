class Coupon < ApplicationRecord
  belongs_to :merchant

  validates_presence_of :name
  validates_presence_of :enabled
  validates_presence_of :value
end
