require 'rails_helper'

RSpec.describe "routing to registration", :type => :routing do

  it "routes /api/v1/registration to registrations#registration" do
    expect(:post => "/api/v1/registrations").to route_to(
      :controller => 'api/v1/registrations',
      :action => 'create',
      :format => :json
    )
  end

  it "routes /api/v1/request_sms to  registrations#request_sms" do
    expect(:post => "/api/v1/request_sms").to route_to(
      :controller => 'api/v1/registrations',
      :action => 'request_sms',
      :format => :json
    )
  end
end