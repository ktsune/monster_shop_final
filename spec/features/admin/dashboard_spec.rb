require 'rails_helper'

RSpec.describe 'Admin Dashboard' do
  describe 'As an Admin' do
    before :each do
      @merchant_1 = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @merchant_2 = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @m_user = @merchant_1.users.create(name: 'Megan', email: 'megan@example.com', password: 'securepassword')
      @m_user_work = Address.create!(nickname: "work", address: "123 Straw Lane", city: "Straw City", state: "CO", zip: 12345, user_id: @m_user.id)
      @ogre = @merchant_1.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20.25, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
      @giant = @merchant_1.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
      @hippo = @merchant_2.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 1 )
      @order_1 = @m_user.orders.create!(status: "packaged", address_id: @m_user_work.id)
      @order_2 = @m_user.orders.create!(status: "pending", address_id: @m_user_work.id)
      @order_3 = @m_user.orders.create!(status: "cancelled", address_id: @m_user_work.id)
      @admin = User.create(name: 'Megan', email: 'admin@example.com', password: 'securepassword', role: :admin)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)
    end

    it 'I can see all orders' do
      visit '/admin'

      expect(page.all('.order')[0]).to have_content(@order_2.id)
      expect(page.all('.order')[1]).to have_content(@order_1.id)
      expect(page.all('.order')[2]).to have_content(@order_3.id)

      within "#order-#{@order_1.id}" do
        expect(page).to have_content(@m_user.name)
        expect(page).to have_content("#{@order_1.id}: #{@order_1.status}")
        expect(page).to have_content("Created: #{@order_1.created_at}")
        expect(page).to have_link('Ship')
      end

      within "#order-#{@order_2.id}" do
        expect(page).to have_content(@m_user.name)
        expect(page).to have_content("#{@order_2.id}: #{@order_2.status}")
        expect(page).to have_content("Created: #{@order_2.created_at}")
        expect(page).to_not have_link('Ship')
      end

      within "#order-#{@order_3.id}" do
        expect(page).to have_content(@m_user.name)
        expect(page).to have_content("#{@order_3.id}: #{@order_3.status}")
        expect(page).to have_content("Created: #{@order_3.created_at}")
        expect(page).to_not have_link('Ship')
      end
    end

    it 'I can ship an order' do
      visit '/admin'

      within "#order-#{@order_1.id}" do
        click_link('Ship')
      end

      @order_1.reload

      expect(@order_1.status).to eq('shipped')
    end

  context 'User visits profile or dashboard page as an admin' do
    it 'can only see admin dashboard' do
      admin = User.create!(name: "Larry Green", email: "green@gmail.com", password: "bear", role: 2)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)
      visit root_path
      click_link "Dashboard"

      expect(current_path).to eq(admin_dashboard_path)
      expect(page).to have_content("Admin Dashboard")

      visit merchant_dashboard_path

      expect(page).to have_content("The page you were looking for doesn't exist.")
      expect(page.status_code).to eq(404)

      visit profile_path

      expect(page).to have_content("The page you were looking for doesn't exist.")
      expect(page.status_code).to eq(404)

      visit cart_path

      expect(page).to have_content("The page you were looking for doesn't exist.")
      expect(page.status_code).to eq(404)
    end
  end

  context 'as a merchant user' do
    it 'can only see merchant dashboard, profile, cart' do
      megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      merchant = User.create!(name: "Berry Blue", email: "blue@gmail.com", password: "bear", role: 1, merchant_id: megan.id)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant)
      visit admin_dashboard_path

      expect(page).to have_content("The page you were looking for doesn't exist.")
      expect(page.status_code).to eq(404)

      visit root_path
      click_on 'Dashboard'

      expect(current_path).to eq(merchant_dashboard_path)
      expect(page).to have_content("Merchant Dashboard")

      visit profile_path

      expect(current_path).to eq(profile_path)
      expect(page).to have_content("Profile")

      visit cart_path

      expect(current_path).to eq(cart_path)
      expect(page).to have_content("My Cart")
    end
  end

  context 'as a regular user' do
    it 'can only see profile and cart' do
      user = User.create!(name: "Alex Hennel", email: "straw@gmail.com", password: "fish", role: 0)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
      visit admin_dashboard_path

      expect(page).to have_content("The page you were looking for doesn't exist.")
      expect(page.status_code).to eq(404)

      visit merchant_dashboard_path

      expect(page).to have_content("The page you were looking for doesn't exist.")
      expect(page.status_code).to eq(404)

      visit root_path
      click_link "Profile"

      expect(current_path).to eq(profile_path)
      expect(page).to have_content("Profile")

      click_link "Cart"

      expect(current_path).to eq(cart_path)
      expect(page).to have_content("My Cart")
    end
    end
  end
end
