require 'rails_helper'

RSpec.describe 'Login Page' do 
  describe "When I visit '/login'" do 
    it "I see a formm to log in" do 
      user  = User.create(name: "Antoine", email: "antoine@gmail.com", password: "password")
      visit login_form_path

      fill_in :email, with: 'antoine@gmail.com'
      fill_in :password, with: 'password'
      click_button "Log In"

      expect(current_path).to eq(user_path(user))
      expect(page).to have_content("Welcome, #{user.name}!")
    end

    it "gives an error message if the password is incorrect" do 
      user  = User.create(name: "Antoine", email: "antoine@gmail.com", password: "password")
      visit login_form_path

      fill_in :email, with: 'antoine@gmail.com'
      fill_in :password, with: 'notpassword'
      click_button "Log In"

      expect(current_path).to eq(login_form_path)
      expect(page).to have_content("Credentials are incorrect")
    end

    it "shows which user is currently logged in on the welcome page" do 
      user  = User.create(name: "Antoine", email: "antoine@gmail.com", password: "password")
      visit login_form_path

      fill_in :email, with: 'antoine@gmail.com'
      fill_in :password, with: 'password'
      click_button "Log In"

      visit root_path
      expect(page).to have_content("currently logged in as #{user.email}")
    end
  end

  it "has a link that you can log out and it ends your session" do 
    user  = User.create(name: "Antoine", email: "antoine@gmail.com", password: "password")
    visit login_form_path

    fill_in :email, with: 'antoine@gmail.com'
    fill_in :password, with: 'password'
    click_button "Log In"

    visit root_path

    expect(page).to have_link("Log out")
    click_link("Log out")

    expect(current_path).to eq(root_path)
    expect(page).to_not have_link("Log out")
    expect(page).to have_link("Log In")
  end
end