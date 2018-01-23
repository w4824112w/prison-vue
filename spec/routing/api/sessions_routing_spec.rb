require 'rails_helper'

RSpec.describe "routing to login", :type => :routing do
  it "routes /api/v1/login to sessions#login for family login" do
    expect(:post => "/api/v1/login").to route_to(
      :controller => 'api/v1/sessions',
      :action => "login",
      :format => :json
    )
  end

  it "routes /api/v1/verify_code to sessions#verify_sms_code for verify sms code" do
    expect(:post => "/api/v1/verify_code").to route_to(
      :controller => 'api/v1/sessions',
      :action => "verify_sms_code",
      :format => :json
    )
  end

end