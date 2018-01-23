class UserMailer < ApplicationMailer
    default from: '2681636355@qq.com'

    def send_email
      #  mail to: '1665137606@qq.com', subject: '邮件发送测试'
        mail(to: '1665137606@qq.com', subject: "Welcome to My Awesome Site")
    end

end
