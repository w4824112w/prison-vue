require 'rails_helper'

RSpec.describe 'routing items', type: :routing do
  it 'routes /api/v1/items to items#index' do
    expect(get: '/api/v1/items').to route_to(
      :controller => 'api/v1/items',
      :action => 'index',
      :format => :json
    )
  end
end