class ViewingParty < ApplicationRecord
  has_many :user_viewing_parties
  has_many :users, through: :user_viewing_parties
  validates :duration, presence: true
  validates :day, presence: true
  validates :view_time, presence: true


  def host
    users.joins(:user_viewing_parties)
        .select('users.*, user_viewing_parties.host')
        .find_by('user_viewing_parties.host = ?', true)
  end

  def party_guests
    users.joins(:user_viewing_parties)
        .select('users.*, user_viewing_parties.host')
        .where('user_viewing_parties.host = ?', false)
        .distinct
  end

  def movie
    find_movie = MovieFacade.new(movie_id)
    find_movie.movie
  end

  def movie_title
    movie.title
  end

  def movie_image
    "https://image.tmdb.org/t/p/w500#{movie.image}"
  end
end
