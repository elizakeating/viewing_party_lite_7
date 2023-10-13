class ViewingPartiesController < ApplicationController
  before_action :find_movie
  before_action :find_user, only: [:new, :create] 

  def new
  end

  def create
    if party_params[:duration].to_i < @movie.runtime
      flash[:error] = 'Party duration must be longer than movie runtime'
      redirect_to "/users/#{params[:id]}/movies/#{params[:movie_id]}/viewing_party/new"
    elsif party_params[:duration].to_i >= @movie.runtime
      party = ViewingParty.create(party_params)
  
      host_user_viewing_party = UserViewingParty.create(user_id: params[:id], viewing_party_id: party.id, host: true)
        redirect_to "/users/#{params[:id]}"

      params[:party_guests].select do |key, value|
          if value == "1"
            UserViewingParty.create(user_id: key, viewing_party_id: party.id, host: false) 
          end 
      end
    end
  end

  private

  def find_user
    @user = User.find(params[:id])
  end
  
  def find_movie
    @movie = facade.movie
  end


  def party_params
    params.permit(:movie_id, :duration, :day, :view_time)
  end

  def facade
    MovieFacade.new(params[:movie_id])
  end
end