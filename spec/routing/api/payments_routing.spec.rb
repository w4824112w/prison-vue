require 'rails_helper'

RSpec.describe 'routing payments', type: :routing do

  it 'routes /api/v1/payment to payments#create' do
    expect(post: '/api/v1/payment').to route_to(
      :controller => 'api/v1/payments',
      :action => 'create',
      :format => :json
    )
  end

  it 'routes /api/v1/weixin to payments#weixin' do
    expect(post: '/api/v1/weixin').to route_to(
      :controller => 'api/v1/payments',
      :action => 'weixin',
      :format => 'xml'
    )
  end

end
