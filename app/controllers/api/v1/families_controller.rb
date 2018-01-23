#encoding = utf-8

module Api
  module V1
    class FamiliesController < ApiController
      skip_before_action :restrict_access, only: [:show]

      def balances
        balance = Family.select(:balance).find_by(id: params[:id])
        if balance
          render json: { code:200, balance: balance }
          return
        end

        render json: { code: 404 }
      end

      def meetings
        family = Family.find_by_id(params[:id])
        if family
          render json: { code: 200,  meetings: family.meetings.select(:meeting_time).where(status: 'PASSED').
            select{ |meeting| meeting.meeting_time.split(' ').first >= Date.today.to_s }.map{ |r| r.meeting_time } }
          return
        end

        render json: { code: 404, errors: 'family not found' }
      end

      def show
        family = Family.find_by(phone: params[:phone])
        if family
          render json: { code:200, family: { 
              name: family.name, 
              uuid: family.uuid,
              prisoner_number: family.prisoner.prisoner_number,
              accid: family.api_key.access_token,
              relationship: family.relationship,
              image_url: family.image_url
            } }
          return
        end
        
        render json: { code: 404 }
      end

      def drawback
        api_key = request.headers['Authorization']

        begin
          Family.drawback(api_key)
          render json: { code: 200, msg: '申请退款成功，退款将在三个工作日内完成' }
        rescue ActiveRecord::RecordInvalid => ex
          logger.error "RecordInvalid 退款失败，#{ex}"
          render json: { code: 400, errors: "#{ex}" }
        rescue ActiveRecord::RecordNotSaved => ex
          logger.error "RecordNotSaved 退款失败，#{ex}"
          render json: { code: 400, errors: "#{ex}" }
        end
      end

    end
  end
end