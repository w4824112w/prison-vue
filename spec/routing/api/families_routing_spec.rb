require 'rails_helper'

RSpec.describe 'routing families', type: :routing do
  it 'routes /api/v1/families/:id/balance to families#balances' do
    expect(get: '/api/v1/families/1/balances').to route_to(
      :controller => 'api/v1/families',
      :action => 'balances',
      :id => '1',
      :format => :json
    )
  end

  it 'routes /api/v1/drawbacks to families#drawbacks' do
    expect(post: '/api/v1/drawbacks').to route_to(
      :controller => 'api/v1/families',
      :action => 'drawback',
      :format => :json
    )
  end

  it 'routes /api/vi/families/:phone to families#show' do
    expect(get: '/api/v1/families/777-888-999').to route_to(
      :controller => 'api/v1/families',
      :action => 'show',
      :phone => '777-888-999',
      :format => :json
    )
  end

  it 'routes /api/v1/families/:id/meetings to families#meetings' do
    expect(get: '/api/v1/families/1/meetings').to route_to(
      :controller => 'api/v1/families',
      :action => 'meetings',
      :id => '1',
      :format => :json
    )
  end
end