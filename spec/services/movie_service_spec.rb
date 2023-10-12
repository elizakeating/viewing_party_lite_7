require 'rails_helper'

RSpec.describe MovieService do 
  describe "instance methods" do
    it "#get_movie" , :vcr do
      service = MovieService.new
      movie = service.get_movie(238)

      expect(movie).to be_a(Hash)
      
      expect(movie).to have_key(:title)
      expect(movie[:title]).to be_a(String)
      
      expect(movie).to have_key(:vote_average)
      expect(movie[:vote_average]).to be_a(Float)

      expect(movie).to have_key(:runtime)
      expect(movie[:runtime]).to be_a(Integer)

      expect(movie).to have_key(:genres)
      expect(movie[:genres]).to be_a(Array)

      expect(movie).to have_key(:overview)
      expect(movie[:overview]).to be_a(String)
    end

    it "#get_cast_members", :vcr do
      service = MovieService.new
      cast_members = service.get_cast_members(238)

      expect(cast_members).to be_a(Hash)

      expect(cast_members).to have_key(:cast)
      expect(cast_members[:cast]).to be_a(Array)

      expect(cast_members[:cast].first).to have_key(:name)
      expect(cast_members[:cast].first[:name]).to be_a(String)

      expect(cast_members[:cast].first).to have_key(:character)
      expect(cast_members[:cast].first[:character]).to be_a(String)
    end

    it "#get_reviews", :vcr do
      service = MovieService.new
      reviews = service.get_reviews(238)

      expect(reviews).to be_a(Hash)

      expect(reviews).to have_key(:results)
      expect(reviews[:results]).to be_a(Array)

      expect(reviews[:results].first).to have_key(:author)
      expect(reviews[:results].first[:author]).to be_a(String)
      
      expect(reviews[:results].first).to have_key(:content)
      expect(reviews[:results].first[:content]).to be_a(String)
    end
  end
end