class HomeController < ApplicationController
#  skip_before_action :authorize
  
#  layout 'login'

before_action :authenticate!
end
