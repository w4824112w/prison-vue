class LawsController < ApplicationController

  skip_before_action :authorize, only: [:show]

  def index
    @laws = Law.where('jail_id =?', session[:jail_id])
    
    respond_to do |format|
      format.html
      format.json { render json: @laws }
    end
  end

  def new
  	@law = Law.new
  end

  def create
  	@law = Law.new(laws_params)

  	if @law.save
  		redirect_to laws_path
      return
  	end

  	redirect_to new_law_path
  end

  def edit
  	@law = Law.find(params[:id])
  end

  def update
  	@law = Law.find(params[:id])

  	if @law.update(laws_params)
  		redirect_to laws_path
      return
  	end
  	
    redirect_to edit_law_path
  end

  def destroy
    @law = Law.find(params[:id])
    #@law.destroy
    @law.update_attributes(:sys_flag => 0)
    redirect_to laws_path
  end

  def show
    @law = Law.find_by_id(params[:id])
    render action: "show", layout: "show"
  end

  private

	def laws_params
	  params.require(:law).permit(:title, :contents, :jail_id, :image,:sys_flag)
	end

end
