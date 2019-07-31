class Coupon < ApplicationRecord
  belongs_to :merchant

  validates_presence_of :name
  validates_presence_of :enabled
  validates_presence_of :value

  def find_by_name(name)
    # binding.pry
    Coupon.where(name: name)
  end
end
