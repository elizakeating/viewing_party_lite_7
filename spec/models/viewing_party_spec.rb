require 'rails_helper'

RSpec.describe ViewingParty, type: :model do
  describe 'relationships' do
    it {should have_many :user_viewing_parties}
    it {should have_many(:users).through(:user_viewing_parties)}
  end

  describe 'validations' do
    it {should validate_presence_of :duration}
    it {should validate_presence_of :day}
    it {should validate_presence_of :view_time}
  end

  before :each do 
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
    movie_data_2 = {
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

  describe 'instance methods' do
    it "#host" do 
      expect(@viewing_party_1.host).to eq(@noelle)
      expect(@viewing_party_2.host).to eq(@antoine)
    end

    it "#party_guests" do 
      expect(@viewing_party_1.party_guests).to eq([@chris])
      expect(@viewing_party_2.party_guests).to eq([@noelle, @lauren])
    end
  end

  describe "instance methods that call an API" do 
    it "movie" do
  end
end