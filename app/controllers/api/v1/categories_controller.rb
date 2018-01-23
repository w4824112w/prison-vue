module Api
  module V1
    class CategoriesController < ApiController
      
      def index
        render json: { code:200 , categories: Category.all }
      end

    end
  end
end