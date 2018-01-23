#encoding = utf-8

module Api
  module V1
    class RegistrationsController < ApiController
      skip_before_action :restrict_access

      def create
        registration = Registration.new(registration_params) 
        
        registrations = Registration.find_by_sql("select * from registrations where phone=#{registration.phone} and status in('PENDING','PASSED');")
        if registrations.size>0
          render json: { code: 400, msg: '提交申请失败,请稍后再试', errors: 'PENDING is allow only one' }
          return
        end  
      #  if Registration.find_by_phone_and_status(registration.phone, 'PENDING')
      #    render json: { code: 400, msg: '提交申请失败,请稍后再试', errors: 'PENDING is allow only one' }
      #     return
      #  end

        if registration.save
          render json: { code: 200, msg: '申请已提交,请等待审核' }
          return
        end

        render json: { code: 400, msg: '提交申请失败,请稍后再试', errors: registration.errors }
      end

      # 请求验证码，该方法将要被放入backgroud job
      def request_sms
        get_code(params[:registration][:phone]) do |res| 
          logger.info "SMS #{params[:registration][:phone]} #{res}"
          render json: res 
        end
      end

      private

      def registration_params
        json_params = ActionController::Parameters.new(JSON.parse(request.body.read))
        json_params.require(:registration).permit(:id,
                                                  :jail_id,
                                                  :name,
                                                  :uuid, 
                                                  :prisoner_number, 
                                                  :phone,
                                                  :relationship, 
                                                  :gender,
                                                  :remarks,
                                                  :status,
                                                  :created_at,
                                                  :updated_at, 
                                                  :uuid_images_attributes => :image_data)
      end
    end
  end
end
