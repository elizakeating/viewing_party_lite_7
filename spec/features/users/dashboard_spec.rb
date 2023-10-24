# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User Dashboard Page', type: :feature do
  before(:each) do
    @user = User.create(name: 'Brad', email: 'bradsmith@gmail.com', password: 'password')
    @user_2 = User.create(name: 'Noelle', email: 'loml@gmail.com', password: 'password')
    @user_3 = User.create(name: 'Antoine', email: 'antoine@gmail.com', password: 'password')
    @user_4 = User.create(name: 'Eliza', email: 'eliza@gmail.com', password: 'password')

    visit "/users/#{@user.id}/movies/346698/viewing_party/new"

    fill_in(:duration, with: '150')
    fill_in(:view_time, with: '12:00:00 UTC')
    fill_in(:day, with: '2023-12-15')
    check @user_2.name.to_s
    check @user_4.name.to_s

    click_button('Create Party')
  end
  describe "when I visit 'users/:id'", :vcr do
    it "I should see 'User's Name Dashboard' at the top of the page, a button to discover movies, and a section that lists viewing parties" do
      expect(page).to have_content("Brad's Dashboard")

      expect(page).to have_button('Discover Movies')

      within('#hosted') do
        within("##{@user.viewing_parties.first.id}") do
          expect(page).to have_css("img[src*='https://image.tmdb.org/t/p/w500/ctMserH8g2SeOAnCw5gFjdQF8mo.jpg']")
          expect(page).to have_link('Barbie')
          expect(page).to have_content('Day: 2023-12-15')
          expect(page).to have_content('Time: 12:00')
          expect(page).to have_content('Host: Me')
          expect(page).to have_content('Guests:')
          within('#guests') do
            expect(page).to have_content('Noelle')
            expect(page).to have_content('Eliza')
            expect(page).to_not have_content('Brad')
          end
        end
      end

      click_link('Barbie')
      expect(current_path).to eq("/users/#{@user.id}/movies/346698")
    end

    it 'if not host, should see hosts name, and should see my name in bold' do
      visit "/users/#{@user_2.id}"

      expect(page).to have_content("Noelle's Dashboard")

      expect(page).to have_button('Discover Movies')

      within('#invited') do
        within("##{@user.viewing_parties.first.id}") do
          expect(page).to have_link('Barbie')
          expect(page).to have_content('Day: 2023-12-15')
          expect(page).to have_content('Time: 12:00')
          expect(page).to have_content('Host: Brad')
          expect(page).to have_content('Guests:')
          within('#guests') do
            expect(page).to have_css('b', text: 'Noelle')
            expect(page).to have_content('Eliza')
            expect(page).to_not have_content('Brad')
          end
        end
      end
    end

    it "When I click 'Discover Movies' button I am redirected to a discover page /users/:id/discover where the :id is the current user id" do
      click_button 'Discover Movies'

      expect(current_path).to eq("/users/#{@user.id}/discover")
    end
  end
end
