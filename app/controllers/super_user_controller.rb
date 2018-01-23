class SuperUserController < ApplicationController

  def index
	  @users = User.all
	
	  respond_to do |format|
      format.html
      format.json { render json: @users}
    end
  end

  def modify_index
    render 'modify'
  end  
  
  def modify
    @modify_result = User.modify(session[:zipcode], session[:user_name], params[:password], params[:new_password])
    render json: @modify_result
  end  
end
