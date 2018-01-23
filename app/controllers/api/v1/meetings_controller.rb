#encoding = utf-8

module Api
  module V1
    class MeetingsController < ApiController
      skip_before_action :restrict_access, only: [ :cancel ]

      def index
        jail = Jail.find_by(id: params[:id])
        
        if jail
          render json: Meeting.list({ jail: params[:id], status: params[:status], application_date: params[:application_date] })
          return
        end

        render json: { code: 404, error: "can not found jail ##{params[:id]}" }
      end

      def create
        render json: Meeting.application(meeting_params)
      end

      # 取消视频会见
      def cancel
        meeting = Meeting.find_by(id: params[:id])

        if meeting
          if params[:remarks] == '本次会见结束' 
            status = 'FINISHED'
          else
            status = 'CANCELED'
          end

          if meeting.update_attributes({status: status, remarks: params[:remarks]})
            logger.info "meeting #{params[:id]} was canceled, beacause of #{params[:remarks]}"
            render json: { code: 200 }
            return
          end

          logger.error "cancel meeting #{params[:id]} occurs error #{meeting.errors.messages}"
          render json: { code: 500, errors: 'Internal error' }
          return
        end

        logger.error "could not found meeting #{params[:id]}"
        render json: { code: 404, errors: "could not found meeting #{params[:id]}" }
      end

      private

      def meeting_params
        json_params = ActionController::Parameters.new(JSON.parse(request.body.read))
        json_params.require(:meeting).permit(:application_date, :family_id)
      end
      
    end
  end
end