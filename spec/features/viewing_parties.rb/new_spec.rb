require 'rails_helper'

RSpec.describe 'Creating a new viewing party' do
  before :each do
    @noelle = User.create!(name: "Noelle", email: "Queen@aol.com", id: 1)
    @chris = User.create!(name: "Chris", email: "muttonchops@yahoo.com", id: 2)
    @antoine = User.create!(name: "Antoine", email: "antoine@gmail.com", id: 3)
    @lauren = User.create!(name: "Lauren", email: "lauren@gmial.com", id: 4)
    movie_data = {
      id: 550,
      title: "Shawshank Redemption",
      vote_average: 8.7,
      runtime: 142,
      genres: [{name: "Drama"}],
      overview: "A Movie about prison"
    }
    @shawshank = Movie.new(movie_data)
  end
  describe "when I visit '/users/:id/movies/:movie_id/viewing_party/new'", :vcr do
    it "There's a form to create a new viewing party" do
      visit "/users/#{@noelle.id}/movies/#{@shawshank.id}/viewing_party/new"

      expect(page).to have_field(:duration)
      expect(page).to have_field(:day)
      expect(page).to have_field(:view_time)

      expect(page).to have_unchecked_field(@chris.name)
      expect(page).to have_unchecked_field(@antoine.name)
      expect(page).to have_unchecked_field(@lauren.name)
      expect(page).to_not have_unchecked_field(@noelle.name)
      expect(page).to have_button("Create Viewing Party")
    end

    it "creates a new ViewingPary and UserViewingParties for all invited members" do
      visit "/users/#{@noelle.id}/movies/#{@shawshank.id}/viewing_party/new"
      expect(ViewingParty.count).to eq(0)
      expect(UserViewingParty.count).to eq(0)

      fill_in(:duration, with: 150)
      fill_in(:day, with: "2021-08-01")
      fill_in(:view_time, with: "19:00:00 UTC")
      check(@chris.name)
      click_button("Create Viewing Party")

      expect(current_path).to eq("/users/#{@noelle.id}")

      expect(ViewingParty.count).to eq(1)
      expect(UserViewingParty.count).to eq(2)
    end

    it "does not create a new ViewingParty if duration is less than movie runtime" do
      visit "/users/#{@noelle.id}/movies/#{@shawshank.id}/viewing_party/new"

      expect(ViewingParty.count).to eq(0)

      fill_in(:duration, with: 1)
      fill_in(:day, with: "2021-08-01")
      fill_in(:view_time, with: "19:00:00 UTC")
      check(@chris.name)

      click_button("Create Viewing Party")
      expect(ViewingParty.count).to eq(0)
      expect(current_path).to eq("/users/#{@noelle.id}/movies/#{@shawshank.id}/viewing_party/new")

      expect(page).to have_content("Party duration must be longer than movie runtime")
    end
  end
end