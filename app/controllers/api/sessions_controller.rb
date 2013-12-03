class API::SessionsController < ApplicationController
  def create
    user = User.find_by(email_address: params[:username])
    if user && user.authenticate(params[:password])
      log_in user.id
      render json: { username: user.email_address }, status: 200
    elsif user
      render nothing: true, status: 401
    else
      user = User.create!(email_address: params[:username], password: params[:password])
      log_in user.id
      render json: { username: params[:username] }, status: 201
    end
  end

  private

  def log_in(id)
    session[:user_id] = id
  end

  def log_out
    session.delete(:user_id)
  end
end
