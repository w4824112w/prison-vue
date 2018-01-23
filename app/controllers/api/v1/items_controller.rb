module Api
  module V1
    class ItemsController < ApiController

      def index
        limits = 10
        params[:page] ||= 0

        unless params[:category_id].nil?
          render json: Item.where('jail_id =? AND category_id = ?', params[:jail_id], params[:category_id]).
            limit(limits).
            offset(params[:page].to_i * limits)
          return
        end

        render json: Item.where('jail_id = ?', params[:jail_id]).
          limit(limits).
          offset(params[:page].to_i * limits)
      end

    end

  end
end
