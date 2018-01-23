module Api
  module V1
    class MettingRoomConfigController < ApiController
      skip_before_action :restrict_access

      def index
        @result=MettingRoomConfig.list(params[:id])
        render json: @result  
      end


    end
  end
end