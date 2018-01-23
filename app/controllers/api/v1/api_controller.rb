require "#{Rails.root}/lib/yunxin"

module Api
  module V1
    class ApiController < ActionController::API
      include YunXin
      before_action :restrict_access
      respond_to :json

      private

      def restrict_access
        api_key = ApiKey.find_by_access_token(request.headers['Authorization'])
        head :unauthorized unless api_key
      end

    end
  end
end
