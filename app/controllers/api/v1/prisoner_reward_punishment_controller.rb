module Api
  module V1
    class PrisonerRewardPunishmentController < ApiController
      skip_before_action :restrict_access

      def index 
        @result=PrisonerRewardPunishment.list(params[:prisoner_id])
        render json: @result          
      end


    end
  end
end