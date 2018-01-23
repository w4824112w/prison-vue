require 'rails_helper'

RSpec.describe 'routing prisoners', type: :routing do
  it 'routes /api/v1/families/:id/prisoners to prisoners#index' do
    expect(get: '/api/v1/families/1/prisoners').to route_to(
      :controller => 'api/v1/prisoners',
      :action => 'index',
      :id => '1',
      :format => :json
    )
  end
end
