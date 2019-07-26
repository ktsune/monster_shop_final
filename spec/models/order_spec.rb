require 'rails_helper'

RSpec.describe Order do
  describe 'relationships' do
    it {should have_many :order_items}
    it {should have_many(:items).through(:order_items)}
    it {should belong_to :user}
    it {should belong_to :address}
  end

  describe 'instance methods' do
    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @ogre = @megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20.25, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
      @giant = @megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
      @hippo = @brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )

      @alex = User.create!(name: "Alex Hennel", email: "straw@gmail.com", password: "fish", role: 0)
      @berry = User.create!(name: "Berry Blue", email: "blue@gmail.com", password: "bear", role: 1, merchant_id: @megan.id)
      @jeff = User.create!(name: "Jeff Casimir", email: "jeff@gmail.com", password: "jeff", role: 2)

      @alex_work = Address.create!(nickname: "work", address: "123 Straw Lane", city: "Straw City", state: "CO", zip: 12345, user_id: @alex.id)
      @berry_home = Address.create!(nickname: "home", address: "345 Blue Lane", city: "Blue City", state: "CA", zip: 56789, user_id: @berry.id)
      @jeff_home = Address.create!(nickname: "home", address: "345 Blue Lane", city: "Blue City", state: "CA", zip: 56789, user_id: @jeff.id)

      @order_1 = @alex.orders.create!(address_id: @alex_work.id, status: "packaged")
      @order_2 = @berry.orders.create!(address_id: @berry_home.id, status: "pending")

      @order_item_1 = @order_1.order_items.create!(item: @ogre, price: @ogre.price, quantity: 5, fulfilled: true)
      @order_item_2 = @order_2.order_items.create!(item: @hippo, price: @hippo.price, quantity: 2, fulfilled: true)
      @order_item_3 = @order_2.order_items.create!(item: @ogre, price: @ogre.price, quantity: 2, fulfilled: false)
    end

    it '.grand_total' do
      expect(@order_1.grand_total).to eq(101.25)
      expect(@order_2.grand_total).to eq(140.5)
    end

    it '.count_of_items' do
      expect(@order_1.count_of_items).to eq(5)
      expect(@order_2.count_of_items).to eq(4)
    end

    it '.cancel' do
      @order_2.cancel

      @order_2.reload

      expect(@order_2.status).to eq('cancelled')
      @order_2.order_items.each do |order_item|
        expect(order_item.fulfilled).to eq(false)
        expect(order_item.item.inventory).to eq(5)
      end
    end

    it '.merchant_subtotal()' do
      expect(@order_2.merchant_subtotal(@megan.id)).to eq(40.5)
      expect(@order_2.merchant_subtotal(@brian.id)).to eq(100)
    end

    it '.merchant_quantity()' do
      expect(@order_2.merchant_quantity(@megan.id)).to eq(2)
      expect(@order_2.merchant_quantity(@brian.id)).to eq(2)
    end

    it '.is_packaged?' do
      @order_1.is_packaged?
      @order_2.is_packaged?

      @order_1.reload
      @order_2.reload

      expect(@order_1.status).to eq('packaged')
      expect(@order_2.status).to eq('pending')
    end
  end

  describe 'class methods' do
    before :each do
      @alex = User.create!(name: "Alex Hennel", email: "straw@gmail.com", password: "fish", role: 0)
      @alex_work = Address.create!(nickname: "work", address: "123 Straw Lane", city: "Straw City", state: "CO", zip: 12345, user_id: @alex.id)

      @order_1 = @alex.orders.create!(status: 1, address_id: @alex_work.id)
      @order_2 = @alex.orders.create!(status: 0, address_id: @alex_work.id)
      @order_3 = @alex.orders.create!(status: 3, address_id: @alex_work.id)
      @order_4 = @alex.orders.create!(status: 2, address_id: @alex_work.id)
    end

    it '.by_status' do
      expect(Order.by_status).to eq([@order_2, @order_1, @order_4, @order_3])
    end
  end
end
