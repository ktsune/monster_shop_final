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

  it 'finds a coupon by name' do
    @brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
    @hippo_coupon = @brian.coupons.create!(name: 'Mega Saver', value: 5.00, merchant_id: @brian.id, enabled: true)

    expect(@hippo_coupon.find_by_name(@hippo_coupon.name)).to eq([@hippo_coupon])
  end
end
