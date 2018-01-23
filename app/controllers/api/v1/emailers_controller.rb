module Api
  module V1
    class EmailersController < ApiController

      def sendmail
          puts '1111111111111111111111111111111'
          recipient = '2681636355@qq.com'
          subject ="测试"
          message = "<p>html邮件测试</p>"
          Emailer.contact(recipient, subject, message).deliver
          render :text=>'OK'
        end

    end
  end
end
