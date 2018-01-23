module Api
  module V1
    class PrisonerTermsController < ApiController
      skip_before_action :restrict_access
  
      def index_bak
        render json: { code: 200, 
          status: 'SUCCESS', 
          data: PrisonTerm.where(prisoner_id: params[:prisoner_id]).order(term_start: :desc)}        
      end

      def index 
        @result=PrisonTerm.detail(params[:prisoner_id])
        render json: @result          
      end

    end
  end
end