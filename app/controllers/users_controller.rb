# frozen_string_literal: true

class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
  end

  def new; end

  def create
    user = user_params
    user[:email] = user[:email].downcase
    user[:name] = user[:name].downcase
    new_user = User.new(user)
    if new_user.save
      redirect_to root_path
    elsif !new_user.save
      flash[:error] = new_user.errors.full_messages.to_sentence
      redirect_to '/register/new'
    end
  end

  def login_form

  end

  def login
    user = User.find_by(email: params[:email])&.authenticate(params[:password])
    if user
      flash[:success] = "Welcome, #{user.name}!"
      session[:user_id] = user[:id]
      redirect_to user_path(user)
    else
      flash[:error] = "Credentials are incorrect"
      redirect_to login_path
    end
  end

  def logout
    session.clear
    redirect_to root_path
  end

  private

  def user_params
    params.permit(:name, :email, :password, :password_confirmation )
  end
end
