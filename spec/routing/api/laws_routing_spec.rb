require 'rails_helper'

RSpec.describe "routing to laws", :type => :routing do

  it "routes /api/v1/jails/:id/laws to laws#index" do
    expect(:get => "/api/v1/jails/1/laws").to route_to(
      :controller => 'api/v1/laws',
      :action => 'index',
      :id => '1',
      :format => :json
    )
  end
end