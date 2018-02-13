class MeetingsController < ApplicationController
	before_action :authenticate!

	def index
		@meetings = Meeting.list({ jail_id: params[:jail_id], limit: params[:limit], page: params[:page] }) 
		render json: @meetings 
		#  respond_to do |format|
	#    format.html 
	#    format.json { render json: Meeting.list({ jail_id: session[:jail_id], limit: params[:limit], page: params[:page] }) }
	#  end
  end

  def show
	  @mail_box = MailBox.find(params[:id])
	  @mail_box.update_attribute("state",1)
	  @family = Family.find_by_id(@mail_box.family_id)
	  @prisoner = Prisoner.find_by_id(@family.prisoner_id)
	  @comments =Comment.find_by_mail_box_id(@mail_box.id)
	  @comment = Comment.new()
  end

  def audit
    if params[:status] == 'PASSED'
	    DispatchWorker.perform_async(params[:id])
	    render json: { code: 200, msg: 'send to job' }
	    return
    end

	  deny_and_send_message(session[:accid], params[:remarks])
  end

  private

	def deny_and_send_message(from, remarks)
	  req = Meeting.deny(params[:id], remarks)
	  if req[:code] == 200
      SendMessageWorker.perform_async(from, req[:to], { code: 400, msg: remarks, jail: params[:jail_title] })
      render json: req
	    return
	  end

	  logger.error "deny meeting #{params[:id]} error: #{req[:error]}"
	  render json: req
  end
end