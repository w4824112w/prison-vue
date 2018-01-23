require 'rails_helper'

RSpec.describe 'routing to meetings', type: :routing do
  it 'routes /api/v1/meetings to meetings#create for application a meeting' do
    expect(post: '/api/v1/meetings').to route_to(
      :controller => 'api/v1/meetings',
      :action => 'create',
      :format => :json
    )
  end

  it 'routes /api/v1/meetings/:id to meetings#cancel for cancel a meeting' do
    expect(patch: '/api/v1/meetings/1').to route_to(
      :controller => 'api/v1/meetings',
      :action => 'cancel',
      :id => '1',
      :format => :json
    )
  end

end