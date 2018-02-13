class MailBoxesController < ApplicationController
	before_action :authenticate!

	def index
      @mail_boxes= MailBox.where('jail_id =?', params[:jail_id])
			render json: @mail_boxes
    #  respond_to do |format|
	  #  format.html
	  #  format.json { render json: @mail_boxes }
	 # end	  
	end

	def show
		@mail = MailBox.find_by(jail_id: session[:jail_id], id: params[:id])

		if @mail
		  @mail.update_attributes({status: 1}) if @mail.status == 0
		  @family = @mail.family
		  @prisoner = @family.prisoner
		  @comments = @mail.comments
			@comment = Comment.new()
			render json: { code: 200, status: 'SUCCESS', mail: @mail, family:@family, prisoner:@prisoner, comments:@comments }
	#	  render 'show' 
		  return
		end
		
		render json: { code: 404, status: 'ERROR', message: 'Can not find mail_boxe details' }	
	#	redirect_to mail_boxes_path
	end

	def check
		@mail = MailBox.find_by(jail_id: params[:jail_id], id: params[:id])
	 
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
