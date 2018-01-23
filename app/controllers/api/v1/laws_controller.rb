module Api
  module V1
    class LawsController < ApiController

      skip_before_action :restrict_access, :only => [:index]

      def index
        laws = Law.where(jail_id: params[:id])
        unless laws.empty?
          laws = laws.map { |law| { id: law.id, title: law.title, contents: law.contents, image: law.image_url, updated_at: law.created_at } }
        end

        render json: { code: 200, laws: laws }
      end

    end
  end
end