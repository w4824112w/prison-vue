require 'net/smtp'
class Emailer < ApplicationRecord
    default from: 'gkyt123@163.com'
    
    def contact(recipient, subject, message)
        puts '22222222222222222222'
        mail(:to=>recipient, :subject=>subject) do |format|
            format.html { render :text => message }
        end
    end

end
