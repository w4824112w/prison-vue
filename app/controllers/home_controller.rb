class HomeController < ApplicationController
  skip_before_action :authorize
  
  layout 'login'
end
