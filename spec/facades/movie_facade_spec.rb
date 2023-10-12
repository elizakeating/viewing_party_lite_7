require 'rails_helper'

RSpec.describe MovieFacade do
  before :each do 
    @facade = MovieFacade.new(238)
  end
  describe "initialize", :vcr do 
    it "exists" do

      expect(@facade).to be_a(MovieFacade)
    end
  end

  describe "instance methods that make API calls", :vcr do
    it "#cast_members" do
      expect(@facade.cast_members).to be_an(Array)
      expect(@facade.cast_members.first).to be_a(CastMember)
      expect(@facade.cast_members.count).to eq(10)
    end

    it "#movie" do
      expect(@facade.movie).to be_a(Movie)
      expect(@facade.movie.title).to eq("The Godfather")
    end

    it "#reviews" do
      expect(@facade.reviews).to be_an(Array)
      expect(@facade.reviews.first).to be_a(Review)
    end
  end
end