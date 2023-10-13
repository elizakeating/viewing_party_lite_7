class MoviesController < ApplicationController
  def index
  end

  def search
    conn = Faraday.new(url: "https://api.themoviedb.org") do |faraday|
      faraday.params["api_key"] = Rails.application.credentials.tmdb[:key]
    end

    if params[:q] == "top20rated"
      response = conn.get("/3/movie/top_rated")

      json = JSON.parse(response.body, symbolize_names: true)
      @movies = json[:results][0..19]
    else
      response = conn.get("3/search/movie?query=#{params[:q]}")

      json = JSON.parse(response.body, symbolize_names: true)
      @movies = json[:results][0..19]
    end
  end
  
  def show
    @movie = facade.movie
    # require 'pry';binding.pry
    @cast_members = facade.cast_members
    @reviews = facade.reviews
  end

  private 

  def facade
    MovieFacade.new(params[:movie_id])
  end
end