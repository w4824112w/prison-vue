class SuperUserController < ApplicationController
  before_action :authenticate!

  def index
	  @users = User.all
  
    render json: @users
	#  respond_to do |format|
  #    format.html
  #    format.json { render json: @users}
  #  end
  end

  def modify_index
    render 'modify'
  end  
  
  def modify
    @modify_result = User.modify(params[:zipcode], params[:user_name], params[:password], params[:new_password])
    render json: @modify_result
  end  
end
