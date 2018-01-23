require 'rails_helper'

RSpec.describe 'routing orders', type: :routing do

  it 'routes /api/v1/orders to orders#create' do
    expect(post: '/api/v1/orders').to route_to(
      :controller => 'api/v1/orders',
      :action => 'create',
      :format => :json
    )
  end

  it 'routes /api/v1/payment_status to orders#update_order_status' do
    expect(patch: '/api/v1/payment_status').to route_to(
      :controller => 'api/v1/orders',
      :action => 'update_order_status',
      :format => :json
    )
  end

  it 'routes /api/v1/prepay to orders#prepay' do
    expect(post: '/api/v1/prepay').to route_to(
      :controller => 'api/v1/orders',
      :action => 'prepay',
      :format => :json
    )
  end

end
