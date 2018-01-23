require 'net/smtp'
require 'mailfactory'
#require 'mail'  

class Version < ApplicationRecord

    def self.list(limit, offset)
        total = find_by_sql("SELECT COUNT(*) FROM versions;")
        versions = where('1=1').limit(limit).offset(offset)
       
        { total: total,  versions: versions }
    end

    def self.temp1()
        puts '22222222222222222222'

      #  msg = [ "Subject: Test\n", "\n", "Now is the time\n" ]  
      #  puts 'msg--'+msg.to_s
      recipient = '2681636355@qq.com'
      subject = '1331 thinkpad test hopy'
      message = 'send msg from ruby.'

      mail(:to=>recipient, :subject=>subject) do |format| 
            format.html { render :text => message } 
      end
       
      #  mail = MailFactory.new  
      #  mail.to = '2681636355@qq.com'  
      #  mail.from = '1665137606@qq.com'  
      #  mail.subject = '1331 thinkpad test hopy'  
      #  mail.text = 'send msg from ruby.\n' 

      #  smtp_port   =  25 #465 587 25  

      #  Net::SMTP.start('smtp.qq.com', 465, 'qq.com', '2681636355@qq.com', 'cqwdbxdmmcpcebcc',:login) do |smtp| 
      #      smtp.sendmail(mail.to_s, '2681636355@163.com', '1665137606@qq.com') 
      #  end 

        
        puts '66666666666666666666666'

    end



end
