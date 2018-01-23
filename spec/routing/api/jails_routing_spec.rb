require 'rails_helper'

RSpec.describe "routing to jail index", :type => :routing do
  it "routes /api/v1/jails/:title to jails#index for getting jail'id" do
    expect(:get => "/api/v1/jails/jail_name").to route_to(
      :controller => 'api/v1/jails',
      :action => "index",
      :title => "jail_name",
      :format => :json
    )
  end
end