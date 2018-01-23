module Api
  module V1
    class SessionsController < ApiController
      skip_before_action :restrict_access

      def login
        render json: Family.login(params[:session][:phone], params[:session][:uuid])
      end

      def verify_sms_code
        render json: verify_code(params[:session][:phone], params[:session][:code])
      end
    end
  end
end
