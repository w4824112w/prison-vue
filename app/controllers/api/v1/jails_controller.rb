module Api
  module V1
    class JailsController < ApiController
      skip_before_action :restrict_access

      def index
        query_string = "'%#{params[:title]}%'"
        render json: { jails: Jail.select('id, title').where("title like #{query_string}") }
      end

    end
  end
end 