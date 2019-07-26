require 'rails_helper'

RSpec.describe 'User Registration' do
  describe 'As a Visitor' do
    it 'I see a link to register as a user' do
      visit root_path

      click_link 'Register'

      expect(current_path).to eq(registration_path)
    end

    it 'I can register as a user' do
      visit registration_path

      fill_in 'Name', with: 'Megan'
      fill_in 'Address', with: '123 Main St'
      fill_in 'City', with: 'Denver'
      fill_in 'State', with: 'CO'
      fill_in 'Zip', with: '80218'
      fill_in 'Email', with: 'megan@example.com'
      fill_in 'Password', with: 'securepassword'
      fill_in 'Password confirmation', with: 'securepassword'
      click_button 'Register'

      expect(current_path).to eq(profile_path)
      expect(page).to have_content('Welcome, Megan!')
      expect(page).to have_content('Home')
    end

    describe 'I can not register as a user if' do
      it 'I do not complete the registration form' do
        visit registration_path

        fill_in 'Name', with: 'Megan'
        click_button 'Register'

        expect(page).to have_button('Register')
        expect(page).to have_content("address: [\"can't be blank\"]")
        expect(page).to have_content("city: [\"can't be blank\"]")
        expect(page).to have_content("state: [\"can't be blank\"]")
        expect(page).to have_content("zip: [\"can't be blank\"]")
        expect(page).to have_content("email: [\"can't be blank\"]")
        expect(page).to have_content("password: [\"can't be blank\"]")
      end

      it 'I use a non-unique email' do
        @alex = User.create!(name: "Alex Hennel", email: "straw@gmail.com", password: "fish", role: 0)
        @alex_work = Address.create!(nickname: "work", address: "123 Straw Lane", city: "Straw City", state: "CO", zip: 12345, user_id: @alex.id)

        visit registration_path

        fill_in 'Name', with: @alex.name
        fill_in 'Address', with: @alex_work.address
        fill_in 'City', with: @alex_work.city
        fill_in 'State', with: @alex_work.state
        fill_in 'Zip', with: @alex_work.zip
        fill_in 'Email', with: @alex.email
        fill_in 'Password', with: @alex.password
        fill_in 'Password confirmation', with: @alex.password
        click_button 'Register'

        expect(page).to have_button('Register')
        expect(page).to have_content("email: [\"has already been taken\"]")
      end
    end
  end
end
