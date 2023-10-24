# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Movie Details Page', type: :feature do
  before(:each) do
    @user = User.create(name: 'Brad', email: 'bradsmith@gmail.com', password: 'password')
  end

  describe "when I visit a movie's detail page '/users/:id/movies/:movie_id'" do
    it "I should see a button to create a viewing party that takes me to '/users/:id/movies/:movie_id/viewing_party/new'" do
      VCR.use_cassette('barbie_details') do
        visit "/users/#{@user.id}/movies/346698"

        expect(page).to have_button('Create Viewing Party for Barbie')

        click_button 'Create Viewing Party for Barbie'

        expect(current_path).to eq("/users/#{@user.id}/movies/346698/viewing_party/new")
      end
    end

    it 'I should see a button to return to the discover page' do
      VCR.use_cassette('barbie_details') do
        visit "/users/#{@user.id}/movies/346698"

        expect(page).to have_button('Discover Page')

        click_button 'Discover Page'

        expect(current_path).to eq("/users/#{@user.id}/discover")
      end
    end

    it 'should have the move information including the title, vote average, runtime in hours and minutes, genre(s) associated to the movie, and a summary description' do
      VCR.use_cassette('barbie_details') do
        visit "/users/#{@user.id}/movies/346698"

        expect(page).to have_content('Barbie')
        expect(page).to have_content('Runtime: 1h 54min')
        expect(page).to have_content('Genre: Comedy, Adventure, Fantasy')

        within('#summary') do
          expect(page).to have_content('Summary')
          expect(page).to have_content('Barbie and Ken are having the time of their lives in the colorful and seemingly perfect world of Barbie Land. However, when they get a chance to go to the real world, they soon discover the joys and perils of living among humans.')
        end
      end
    end

    it 'should have a list of the first 10 cast members (characters&actress/actors)' do
      VCR.use_cassette('barbie_details') do
        visit "/users/#{@user.id}/movies/346698"
        within('#cast') do
          expect(page).to have_content('Cast')
          expect(page).to have_content('Margot Robbie - Barbie')
          expect(page).to have_content('Ryan Gosling - Ken')
          expect(page).to have_content('Issa Rae - Barbie')
        end
      end
    end

    it "should have a count of total reviews, and each review's author and information" do
      VCR.use_cassette('barbie_details') do
        visit "/users/#{@user.id}/movies/346698"

        within('#review-count') do
          expect(page).to have_content('11 Reviews')
        end

        within('#reviews') do
          expect(page).to have_content("Chris Sawin - _Barbie_ reels you in with its silly humor and fantastical ideas. The war of Kens during the last half hour of the film is an all-timer because a battle full of handsome maneuvers, like showing off their naked chest and manly noogies, turns into a full on dance off between Ryan Gosling and Simu Liu.\r \r But the second half of the film leaves a thought-provoking message in your brain regarding both men and women. The Kens gaining respect little by little mirrors how women eventually earned their rights to be respected individuals — after being considered as only being useful in the kitchen or for making babies — except with the gender roles reversed and nude blobs instead of genitalia.\r \r **Full review:** https://bit.ly/beachoff\n")

          expect(page).to have_content('Thulan Perera - Barbie presents a captivating cinematic journey, deftly utilizing an iconic doll to explore intricate gender dynamics. Guided by Greta Gerwig’s direction, Margot Robbie and Ryan Gosling offer standout performances, complemented by memorable songs and stunning set designs, creating an immersive and humorous experience. This thought-provoking film seamlessly weaves a commentary on equality into its dazzling visuals and catchy tunes, harmoniously blending humour and insight. The result is an unforgettable viewing adventure that engages, entertains, and resonates long after the credits roll.')
        end
      end
    end
  end
end
