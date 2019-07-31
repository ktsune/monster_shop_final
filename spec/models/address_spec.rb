require 'rails_helper'

RSpec.describe Address do
  describe 'Relationships' do
    it {should belong_to(:user)}
    it {should have_many(:orders)}
  end

  describe 'Validations' do
    it {should validate_presence_of :address}
    it {should validate_presence_of :city}
    it {should validate_presence_of :state}
    it { should validate_length_of :state}
    it {should validate_presence_of :zip}
    it {should validate_length_of :zip}
    it {should validate_numericality_of :zip}
  end

  describe 'As a visitor' do
    before :each do
      @user_1 = User.create!(name: 'Megan', email: 'megan_1@example.com', password: 'securepassword')
      @user_2 = User.create!(name: 'Megan', email: 'megan_2@example.com', password: 'securepassword')
      @user_1_work = Address.create!(nickname: "work", address: "123 Straw Lane", city: "Straw City", state: "CO", zip: 12345, user_id: @user_1.id)
      @user_2_work = Address.create!(nickname: "work", address: "345 Blue Lane", city: "Blue City", state: "CA", zip: 56789, user_id: @user_2.id)
      @order_1 = @user_1.orders.create!(status: "pending", address_id: @user_1_work.id)
      @order_2 = @user_2.orders.create!(status: "shipped", address_id: @user_2_work.id)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user_1)
    end

    it 'checks to see if an address has been used in a shipped order' do

      expect(@user_1_work.shipped_order?).to eq(false)
      expect(@user_2_work.shipped_order?).to eq(true)
    end
  end
end
