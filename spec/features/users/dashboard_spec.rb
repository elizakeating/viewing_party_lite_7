require "rails_helper"

RSpec.describe "User Dashboard Page", type: :feature do
  before(:each) do
    @user = User.create(name: "Brad", email: "bradsmith@gmail.com")
    # @viewing_party = @user.viewing_parties.create(duration: 180, day: "December 2, 2023", view_time: "7:00 pm")
  end
  describe "when I visit 'users/:id'", :vcr do
    it "I should see 'User's Name Dashboard' at the top of the page, and a button to discover movies" do
      visit "/users/#{@user.id}"

      expect(page).to have_content("Brad's Dashboard")

      expect(page).to have_button("Discover Movies")
    end

    it "When I click 'Discover Movies' button I am redirected to a discover page /users/:id/discover where the :id is the current user id" do
      visit "/users/#{@user.id}"

      click_button "Discover Movies"

      expect(current_path).to eq("/users/#{@user.id}/discover")
    end
  end

  before(:each) do
    @noelle = User.create!(name: "Noelle", email: "Queen@aol.com", id: 1)
    @chris = User.create!(name: "Chris", email: "muttonchops@yahoo.com", id: 2)
    @antoine = User.create!(name: "Antoine", email: "antoine@gmail.com", id: 3)
    @lauren = User.create!(name: "Lauren", email: "lauren@gmial.com", id: 4)
    @viewing_party_1 = ViewingParty.create!(duration: 240, day: "2021-08-01", view_time: "2021-08-01 19:00:00 UTC", movie_id: 550)
    @viewing_party_2 = ViewingParty.create!(duration: 240, day: "2021-08-01", view_time: "2021-08-01 19:00:00 UTC", movie_id: 278)
    @user_viewing_party_1 = UserViewingParty.create!(user_id: @noelle.id, viewing_party_id: @viewing_party_1.id, host: true)
    @user_viewing_party_2 = UserViewingParty.create!(user_id: @chris.id, viewing_party_id: @viewing_party_1.id, host: false)
    @user_viewing_party_3 = UserViewingParty.create!(user_id: @antoine.id, viewing_party_id: @viewing_party_2.id, host: true)
    @user_viewing_party_4 = UserViewingParty.create!(user_id: @lauren.id, viewing_party_id: @viewing_party_2.id, host: false)
    @user_viewing_party_5 = UserViewingParty.create!(user_id: @noelle.id, viewing_party_id: @viewing_party_2.id, host: false)
    movie_data_1 = {
      id: 550,
      title: "Fight Club",
      vote_average: 8.7,
      runtime: 142,
      genres: [{name: "Drama"}],
      overview: "A Movie about Fighting",
      image: "/hZkgoQYus5vegHoetLkCJzb17zJ.jpg"
    }
    @fight_club = Movie.new(movie_data_1)
    @movie_data_2 = {
      id: 278,
      title: "Shawshank Redemption",
      vote_average: 8.7,
      runtime: 156,
      genres: [{name: "Drama"}],
      overview: "A Movie about Prison",
      image: "/kXfqcdQKsToO0OUXHcrrNCHDBzO.jpg"
      }
    @shawshank = Movie.new(@movie_data_2)
  end

  describe "dashboard page displays parties I am hosting", :vcr do 
    it "displays the movie title as a link, date, time, host and guests" do
      visit "/users/#{@noelle.id}"

      expect(page).to have_content("Parties I am Hosting")

      within("#hosting_parties") do 
        within("#party-#{@viewing_party_1.id}") do
          expect(page).to have_link("Fight Club")
          expect(page).to have_content(@viewing_party_1.day)
          expect(page).to have_content(@viewing_party_1.view_time)
          expect(page).to have_content("Host: Noelle")
          expect(page).to have_content("Guests: Chris")
          expect(page).to have_css("img[src*='https://image.tmdb.org/t/p/w500/hZkgoQYus5vegHoetLkCJzb17zJ.jpg']")
        end
      end
    end
  end

  describe " dashboard page displays parties I am invited to", :vcr do 
    it "displays the movie title, date, time, and host and guests" do
      visit "/users/#{@noelle.id}"

      within("#invited_parties") do 
        within("#party-#{@viewing_party_2.id}") do
          expect(page).to have_link("Shawshank Redemption")
          expect(page).to have_content(@viewing_party_2.day)
          expect(page).to have_content(@viewing_party_2.view_time)
          expect(page).to have_content("Host: Antoine")
          expect(page).to have_css('strong', text: 'Noelle')
          expect(page).to have_css("img[src*='https://image.tmdb.org/t/p/w500/kXfqcdQKsToO0OUXHcrrNCHDBzO.jpg']")
        end
      end
    end
  end
end