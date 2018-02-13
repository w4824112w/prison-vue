class CommentsController < ApplicationController
	before_action :authenticate!

	def create
	  @mail = MailBox.find(params[:mail_box_id])
	  @comment = @mail.comments.create(comment_params)
		render json: { code: 200, status: 'SUCCESS', comment: @comment }
	 # redirect_to mail_box_path(@mail)
	end

	private

	def comment_params 
		params.permit(:contents, :mail_box_id, :family_id, :user_id)
	end
	
end
