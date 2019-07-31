require 'rails_helper'

RSpec.describe Coupon do
  describe 'Relationships' do
    it {should belong_to(:merchant)}
  end

  describe 'Validations' do
    it {should validate_presence_of :name}
    it {should validate_presence_of :enabled}
    it {should validate_presence_of :value}
  end
end
