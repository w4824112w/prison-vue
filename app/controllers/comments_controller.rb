class CommentsController < ApplicationController

	def create
	  @mail = MailBox.find(params[:mail_box_id])
	  @comment = @mail.comments.create(comment_params)

	  redirect_to mail_box_path(@mail)
	end

	private

	def comment_params 
		params.require(:comment).permit(:contents, :mail_box_id, :family_id, :user_id)
	end
	
end
