# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Movie Results Page' do
  before(:each) do
    @user = User.create(name: 'Brad', email: 'bradsmith@gmail.com', password: 'password')
  end

  it 'I see a button to return to the discover page' do
    VCR.use_cassette('top_20_rated_movies') do
      visit "/users/#{@user.id}/discover"
      click_button 'Find Top Rated Movies'

      expect(page).to have_button('Discover Page')
      click_button 'Discover Page'

      expect(current_path).to eq("/users/#{@user.id}/discover")
    end
  end

  it 'I see the top 20 top rated movies when top movies button is pressed, their name as a link to their detail page and the vote average of the movie' do
    VCR.use_cassette('top_20_rated_movies') do
      visit "/users/#{@user.id}/discover"

      click_button 'Find Top Rated Movies'
      expect(current_path).to eq("/users/#{@user.id}/movies")

      within('#238') do
        expect(page).to have_link('The Godfather')
        expect(page).to have_content('Vote Average: 8.7')
      end

      within('#11216') do
        expect(page).to have_link('Cinema Paradiso')
        expect(page).to have_content('Vote Average: 8.5')
      end

      expect('The Godfather').to appear_before('Cinema Paradiso')

      VCR.use_cassette('nuovo_cinema_details') do
        click_link 'Cinema Paradiso'

        expect(current_path).to eq("/users/#{@user.id}/movies/11216")
      end
    end
  end

  it 'I see a maximum of 20 results basd on the keyword I searched on the discover page' do
    VCR.use_cassette('barbie_movie_search') do
      visit "/users/#{@user.id}/discover"

      fill_in 'search', with: 'barbie'
      click_button 'Find Movies'

      expect(current_path).to eq("/users/#{@user.id}/movies")

      expect(page).to have_content('Movie results for: barbie')

      within('#346698') do
        expect(page).to have_link('Barbie')
        # expect(page).to have_content('Vote Average: 7.252')
      end

      within('#34134') do
        expect(page).to have_link('Barbie in A Mermaid Tale')
        # expect(page).to have_content('Vote Average: 7.22')
      end

      expect('Barbie').to appear_before('Barbie in A Mermaid Tale')

      VCR.use_cassette('barbie_details') do
        within('#346698') do
          click_link 'Barbie'
        end

        expect(current_path).to eq("/users/#{@user.id}/movies/346698")
      end
    end
  end
end
