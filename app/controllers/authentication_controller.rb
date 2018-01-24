class AuthenticationController < ApplicationController

  def create
  #  @user = User.authenticate(params[:prison], params[:username], params[:password])
  #  if user = User.find_by(username: params[:username])
    if user = User.authenticate(params[:prison], params[:username], params[:password])
      render json: user.token
    else
      render json: {errors: ['用户名或密码错误']}, status: :unauthorized
    end
  end

end	