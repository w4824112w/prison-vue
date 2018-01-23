module Api
  module V1
    class VersionsController < ApiController
      skip_before_action :restrict_access

      def show
        version = Version.where(type_id: params[:type_id]).order('created_at desc').last
        
      #  puts '1111111111111111111111111111111'
      #  recipient = '2681636355@qq.com'
      #  subject ="测试"
      #  message = "<p>html邮件测试</p>"

       # UserMailer.send_email.deliver_now

        render json: { code:200, 
          version_code: version.version_code, 
          version_number: version.version_number, 
          description: version.description,
          download: version.download,
          is_force: version.is_force }
          

      end

    end
  end
end
