# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ViewingParty, type: :model do
  describe 'relationships' do
    it { should have_many :user_viewing_parties }
    it { should have_many(:users).through(:user_viewing_parties) }
  end

  describe 'validations' do
    it { should validate_presence_of :duration }
    it { should validate_presence_of :day }
    it { should validate_presence_of :view_time }
    it { should validate_presence_of :movie_id }
  end

  before(:each) do
    @user = User.create(name: 'Brad', email: 'bradsmith@gmail.com', password: 'password')
    @user_2 = User.create(name: 'Noelle', email: 'loml@gmail.com', password: 'password')
    @user_3 = User.create(name: 'Antoine', email: 'antoine@gmail.com', password: 'password')
    @viewing_party = ViewingParty.new(duration: '150', day: '2023-12-15', view_time: '19:00', movie_id: 346_698)
    UserViewingParty.create(user: @user, viewing_party: @viewing_party, host: true)
    UserViewingParty.create(user: @user_2, viewing_party: @viewing_party, host: false)
    UserViewingParty.create(user: @user_3, viewing_party: @viewing_party, host: false)
  end
  describe 'instance methods', :vcr do
    describe '#find_movie' do
      it 'should find the movie object based on the movie id' do
        movie = @viewing_party.find_movie

        expect(movie).to be_a(Movie)
        expect(movie.backdrop_path).to be_a(String)
        expect(movie.genres).to be_a(Array)
        expect(movie.id).to be_a(Integer)
        expect(movie.overview).to be_a(String)
        expect(movie.runtime).to be_a(Integer)
        expect(movie.title).to be_a(String)
        expect(movie.vote_average).to be_a(Float)
      end
    end

    describe '#find_host' do
      it 'should return me when user is host' do
        expect(@viewing_party.find_host(@user)).to eq('Me')
      end

      it 'should return name of host when user is not host' do
        expect(@viewing_party.find_host(@user_2)).to eq(@user.name)
      end
    end

    describe '#party_guests' do
      it 'returns party guests that are not the host' do
        expect(@viewing_party.party_guests).to eq([@user_2, @user_3])
      end
    end
  end
end
