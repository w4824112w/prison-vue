module Api
  module V1
    class PrisonersController < ApiController
      skip_before_action :restrict_access

      def index
        family = Family.find_by(id: params[:id])
        
        if family
          prisoner = family.prisoner
          render json: { code: 200, 
                         prisoner: { 
                           id: prisoner.id,
                           name: prisoner.name,
                           gender: prisoner.gender,
                           crimes: prisoner.crimes,
                           prisoner_number: prisoner.prisoner_number,
                           started_at: prisoner.prison_term_started_at,
                           ended_at: prisoner.prison_term_ended_at,
                           prison_area: prisoner.prison_area } 
                        }
          return
        end

        render json: { code: 404, msg: "cound not found family #{params[:id]}" }
      end

      def detail 
        @result=Prisoner.detail(params[:prisoner_id])
        render json: @result          
      end

    end
  end
end