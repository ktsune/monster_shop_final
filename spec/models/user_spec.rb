require 'rails_helper'

RSpec.describe User do
  describe 'Relationships' do
    it {should belong_to(:merchant).optional}
    it {should have_many :orders}
  end

  describe 'Validations' do
    it {should validate_presence_of :name}
    it {should validate_presence_of :email}
    it {should validate_uniqueness_of :email}
  end

  describe User do
      describe 'roles' do
        it 'can be created as a admin user' do
          user = User.create(email: 'joe', password: 'combat', role: 2)

          expect(user.role).to eq('admin')
          expect(user.admin?).to be_truthy
        end

        it 'can be created as merchant user' do
          user = User.create(email: 'joe', password: 'combat', role: 1)

          expect(user.role).to eq('merchant_admin')
          expect(user.merchant_admin?).to be_truthy
        end

        it 'can be created as a default user' do
          user = User.create(email: 'sammy', password: 'pass')

          expect(user.role).to eq('default')
          expect(user.default?).to be_truthy
        end
      end
    end
  end
