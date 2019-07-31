require 'rails_helper'

RSpec.describe 'New Adddress' do
  describe 'As a user' do
    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @sal = Merchant.create!(name: 'Sals Salamanders', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @ogre = @megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20.25, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
      @giant = @megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
      @hippo = @brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
      @user_1 = User.create!(name: 'Megan', email: 'megan_1@example.com', password: 'securepassword')
      @user_2 = User.create!(name: 'Megan', email: 'megan_2@example.com', password: 'securepassword')
      @user_1_work = Address.create!(nickname: "work", address: "123 Straw Lane", city: "Straw City", state: "CO", zip: 12345, user_id: @user_1.id)
      @user_2_work = Address.create!(nickname: "work", address: "345 Blue Lane", city: "Blue City", state: "CA", zip: 56789, user_id: @user_2.id)
      @order_1 = @user_1.orders.create!(address_id: @user_1_work.id)
      @order_2 = @user_2.orders.create!(address_id: @user_2_work.id)
      @order_2 = @user_2.orders.create!(address_id: @user_2_work.id)
      @order_1.order_items.create!(item: @ogre, price: @ogre.price, quantity: 2)
      @order_2.order_items.create!(item: @giant, price: @hippo.price, quantity: 2)
      @order_2.order_items.create!(item: @ogre, price: @hippo.price, quantity: 2)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user_1)
      visit "/profile/addresses"
    end

    it 'I see a form to add a new address to my profile' do

      click_on "New Address"

      fill_in 'Address', with: @user_1_work.address
      fill_in 'City', with: @user_1_work.city
      fill_in 'State', with: @user_1_work.state
      fill_in 'Zip', with: @user_1_work.zip

      click_on "Submit"

      expect(current_path).to eq("/profile/addresses")
      expect(page).to have_content(@user_1_work.address)
      expect(page).to have_content(@user_1_work.city)
      expect(page).to have_content(@user_1_work.state)
      expect(page).to have_content(@user_1_work.zip)
    end

    describe 'I can not add a new address if' do
      it 'I do not complete the new address form' do
        visit "/profile/addresses"

        click_on "New Address"

        fill_in 'Address', with: @user_1_work.address
        click_button 'Submit'

        expect(page).to have_content("city: [\"can't be blank\"]")
        expect(page).to have_content("state: [\"can't be blank\", \"is the wrong length (should be 2 characters)\"]")
        expect(page).to have_content("zip: [\"can't be blank\", \"is not a number\", \"is the wrong length (should be 5 characters)\"]")
      end
    end
  end
end
