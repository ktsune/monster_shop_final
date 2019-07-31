require 'rails_helper'

describe 'As a Merchant' do
  before :each do
    @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, enabled: true)
    @brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218, enabled: false)
    @giant = @megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
    @hippo = @brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: false, inventory: 3 )
    @hippo_coupon = @brian.coupons.create!(name: 'Mega Saver', value: 5.00, merchant_id: @brian.id, enabled: true)
    @giant_coupon = @megan.coupons.create!(name: 'Giant Discount', value: 10.00, merchant_id: @megan.id, enabled: true)
    @m_user = @brian.users.create(name: 'Megan', email: 'megan@example.com', password: 'securepassword')
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@m_user)
  end

  it 'I can create a coupon' do
    visit "/merchants/#{@brian.id}/coupons"

    fill_in 'Name', with: @hippo_coupon.name
    fill_in 'Value', with: @hippo_coupon.value
    fill_in 'Enabled', with: @hippo_coupon.enabled
    click_on "Add Coupon"

    expect(current_path).to eq("/merchants/#{@brian.id}/coupons")
    expect(page).to have_content(@hippo_coupon.name)
    expect(page).to have_content("You have added a coupon!")
  end
end
