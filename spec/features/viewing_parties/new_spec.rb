# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'New Viewing Party Page' do
  before(:each) do
    @user = User.create(name: 'Brad', email: 'bradsmith@gmail.com', password: 'password')
    @user_2 = User.create(name: 'Noelle', email: 'loml@gmail.com', password: 'password')
    @user_3 = User.create(name: 'Antoine', email: 'antoine@gmail.com', password: 'password')
  end

  describe "when I visit the new viewing party page '/users/:id/movies/:movie_id/viewing_party/new'" do
    it 'I should see the name of the movie' do
      VCR.use_cassette('barbie_details') do
        visit "/users/#{@user.id}/movies/346698/viewing_party/new"

        expect(page).to have_content('Create a viewing Party for: Barbie')
      end
    end

    it 'I should see a form with a duration of party, a field to select a date, a field to select a time, checkboxes next to each exisiting user in the system, and a button to create the party that redirects back to the user dashboard',
       :vcr do
      visit "/users/#{@user.id}/movies/346698/viewing_party/new"

      expect(page).to have_field(:duration, with: '114')
      expect(page).to have_field(:day, with: Date.today)
      expect(page).to have_field(:view_time)

      expect(page).to have_content('Invite Other Users')
      expect(page).to have_unchecked_field(@user_2.name.to_s)
      expect(page).to have_unchecked_field(@user_3.name.to_s)
      expect(page).to_not have_unchecked_field(@user.name.to_s)

      expect(page).to have_button('Create Party')

      fill_in(:view_time, with: '12:00:00 UTC')
      fill_in(:day, with: '2023-12-15')
      check @user_2.name.to_s, allow_label_click: true

      click_button('Create Party')

      expect(current_path).to eq("/users/#{@user.id}")
    end

    it 'should not allow you to make a party if the duration is less than the runtime of the movie' do
      VCR.use_cassette('barbie_details_new') do
        visit "/users/#{@user.id}/movies/346698/viewing_party/new"

        expect(page).to have_field(:duration, with: '114')
        expect(page).to have_field(:day, with: Date.today)
        expect(page).to have_field(:view_time)

        expect(page).to have_content('Invite Other Users')
        expect(page).to have_unchecked_field(@user_2.name.to_s)
        expect(page).to have_unchecked_field(@user_3.name.to_s)
        expect(page).to_not have_unchecked_field(@user.name.to_s)

        expect(page).to have_button('Create Party')

        fill_in(:duration, with: '110')
        fill_in(:view_time, with: '12:00:00 UTC')
        fill_in(:day, with: '2023-12-15')
        check @user_2.name.to_s, allow_label_click: true

        click_button('Create Party')

        expect(current_path).to eq("/users/#{@user.id}/movies/346698/viewing_party/new")

        expect(page).to have_content('Viewing party duration can not be less than the run time of the movie. Please try again.')
      end
    end
  end
end
