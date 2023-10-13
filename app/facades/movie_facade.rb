class MovieFacade
  def initialize(movie)
    @movie = movie
  end

  def cast_members
    json = service.get_cast_members(@movie)
  
    movie_cast = json[:cast].map do |cast_data|
      CastMember.new(cast_data)
    end.first(10)
  end 

  def movie
    json = service.get_movie(@movie)
    
    movie = Movie.new(json)
  end

  def reviews
    json = service.get_reviews(@movie)
    movie_reviews = json[:results].map do |review_data|
      Review.new(review_data)
    end
  end

  private
  
  def service
    MovieService.new
  end
end