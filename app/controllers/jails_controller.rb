class JailsController < ApplicationController
  skip_before_action :authorize, only: [:show] 

  def index
  	@jail = Jail.find_by_id(session[:jail_id])

  	respond_to do |format|
      format.html
      format.json { render json: @jail }
    end
  end

  def edit
  	@jail = Jail.find(params[:id])
  end

  def update
    @jail = Jail.find(params[:id])
    
    if @jail.update_attributes(jails_params)
      redirect_to jails_path
    else
      redirect_to edit_jail_path
    end
  end

  def show
    @jail = Jail.find(params[:id])
    render action: 'show', layout: 'show'
  end

  private

  def jails_params
    params.require(:jail).permit(:zipcode, :title, :description, :street, :district, :city, :state, :image)
  end

end
