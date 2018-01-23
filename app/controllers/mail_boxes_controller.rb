class MailBoxesController < ApplicationController

	def index
      @mail_boxes= MailBox.where('jail_id =?', session[:jail_id])
     
      respond_to do |format|
	    format.html
	    format.json { render json: @mail_boxes }
	  end	  
	end

	def show
		@mail = MailBox.find_by(jail_id: session[:jail_id], id: params[:id])

		if @mail
		  @mail.update_attributes({status: 1}) if @mail.status == 0
		  @family = @mail.family
		  @prisoner = @family.prisoner
		  @comments = @mail.comments
		  @comment = Comment.new()
		  render 'show' 
		  return
		end
		
		redirect_to mail_boxes_path
	end

	def check
		@mail = MailBox.find_by(jail_id: session[:jail_id], id: params[:id])
	 
		if @mail
			@mail.update_attributes({status: 1}) if @mail.status == 0
			@family = @mail.family
		  @prisoner = @family.prisoner
		  @comments = @mail.comments
			render json: { code: 200, status: 'SUCCESS', mail: @mail, family:@family, prisoner:@prisoner, comments:@comments }
		  return
		end

		render json: { code: 404, status: 'ERROR', message: 'Can not find mail_boxe details' }		
end


end
