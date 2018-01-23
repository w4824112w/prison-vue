module Api
    module V1
        class PrisonerOrdersController < ApiController
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
                            prison_area: prisoner.prison_area,  
                            prisoner_orders: family.prisoner_orders}
                        }
            return
        end

        render json: { code: 404, msg: "cound not found family #{params[:id]}" }
       end
    
      end
    end
end
