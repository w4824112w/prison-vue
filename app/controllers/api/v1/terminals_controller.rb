module Api
  module V1
    class TerminalsController < ApiController
      skip_before_action :restrict_access, only: [:index,:detail]

      def index
        render json: Terminal.meeting_list(params[:terminal_number], params[:application_date])
      end

      def detail
        @result=Terminal.detail(params[:terminal_number])
        render json: @result        
      end

    end
  end
end