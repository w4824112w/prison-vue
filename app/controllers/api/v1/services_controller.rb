module Api
  module V1
    class ServicesController < ApiController

      def index
        family = Family.joins(:api_key).where('api_keys.access_token = ?', params[:access_token]).first
        render json: {code: 200, prisoner: Prisoner.find(family.prisoner_id)}
      end

    end
  end
end
