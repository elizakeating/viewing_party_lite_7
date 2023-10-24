# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Discover Movies Page' do
  before(:each) do
    @user = User.create(name: 'Brad', email: 'bradsmith@gmail.com', password: 'password')
    visit "/users/#{@user.id}/discover"
  end

  describe "when I visit '/users/:id/discover'" do
    it 'should see a button to discover top rated movies that routes to `/users.:id/movies?q=top%20rated' do
      VCR.use_cassette('top_20_rated_movies') do
        expect(page).to have_content('Discover Movies')

        expect(page).to have_button 'Find Top Rated Movies'

        click_button 'Find Top Rated Movies'
        expect(current_path).to eq("/users/#{@user.id}/movies")
      end
    end

    it "should see a text field to enter keyword(s) to search by movie title and a button to submit that takes you to '/users/:user_id/movies?q=keyword" do
      VCR.use_cassette('barbie_movie_search') do
        expect(page).to have_field 'search'

        expect(page).to have_button 'Find Movies'

        fill_in 'search', with: 'barbie'
        click_button 'Find Movies'

        expect(current_path).to eq("/users/#{@user.id}/movies")
      end
    end
  end
end
