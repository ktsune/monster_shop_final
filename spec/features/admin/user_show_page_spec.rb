require 'rails_helper'

RSpec.describe 'User Show Page' do
  describe 'As an Admin' do
    before :each do
      @d_user = User.create(name: 'Brian', email: 'brian@example.com', password: 'securepassword')
      @d_user_work = Address.create!(nickname: "work", address: "123 Straw Lane", city: "Straw City", state: "CO", zip: 12345, user_id: @d_user.id)

      @admin = User.create(name: 'Sal', email: 'sal@example.com', password: 'securepassword', role: 'admin')
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)
    end

    it 'I see all info a user sees, without edit ability' do
      visit '/admin/users'

      within "#user-#{@d_user.id}" do
        click_link @d_user.name
      end

      expect(current_path).to eq("/admin/users/#{@d_user.id}")
      expect(page).to have_content(@d_user.name)
      expect(page).to have_content(@d_user.email)
      expect(page).to have_content(@d_user_work.address)
      expect(page).to have_content("#{@d_user_work.city} #{@d_user_work.state} #{@d_user_work.zip}")
      expect(page).to_not have_content(@d_user.password)
      expect(page).to_not have_link('Edit')
      expect(page).to_not have_link('Change Password')
    end
  end
end
