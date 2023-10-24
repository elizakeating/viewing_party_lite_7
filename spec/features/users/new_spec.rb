# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'New User Page' do
  describe "When I visit 'regirstration/new'" do
    it 'has a form to create a new user' do
      visit '/register/new'

      expect(page).to have_field(:name)
      expect(page).to have_field(:email)
      expect(page).to have_button('Register')
    end

    it 'creates a new user using the new user form' do
      visit '/register/new'

      expect(User.all.count).to eq(0)

      fill_in(:name, with: 'Bob')
      fill_in(:email, with: 'bob@bob.com')
      fill_in(:password, with: 'password')
      fill_in(:password_confirmation, with: 'password')
      click_button('Register')

      expect(current_path).to eq(root_path)
      expect(page).to have_content('bob')

      expect(User.all.count).to eq(1)
    end

    it 'will not allow a duplicate email to be created in the form' do
      visit '/register/new'

      fill_in(:name, with: 'Bob')
      fill_in(:email, with: 'bob@bob.com')
      fill_in(:password, with: 'password')
      fill_in(:password_confirmation, with: 'password')
      click_button('Register')

      expect(current_path).to eq(root_path)
      expect(page).to have_content('bob')

      click_button('Create New User')
      expect(current_path).to eq('/register/new')

      fill_in(:name, with: 'Not Bob')
      fill_in(:email, with: 'bob@bob.com')
      click_button('Register')

      expect(current_path).to eq('/register/new')
      expect(page).to have_content('Email has already been taken')
    end
  end
end
