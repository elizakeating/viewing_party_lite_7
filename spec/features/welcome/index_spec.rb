# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Welcome Page' do
  before :each do
    @noelle = User.create!(name: 'Noelle', email: 'Queen@aol.com', password: 'password')
    @chris = User.create!(name: 'Chris', email: 'muttonchops@yahoo.com', password: 'password')
  end

  describe "When I visit '/'" do
    it 'displays the welcome page with all users, and button to register' do
      visit root_path

      expect(page).to have_content('Viewing Party')
      expect(page).to have_button('Create New User')
      expect(page).to have_content(@noelle.name)
      expect(page).to have_content(@chris.name)
    end

    it "I see a link to log in " do
      visit root_path

      expect(page).to have_link('Log In')
      click_link 'Log In'
      expect(current_path).to eq(login_form_path)
    end
  end
end
