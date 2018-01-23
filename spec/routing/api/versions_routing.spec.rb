require 'rails_helper'

RSpec.describe 'routing versions', type: :routing do
  it 'routes /api/v1/:type_id to versions#show' do
    expect(get: '/api/v1/versions/1').to route_to(
      :controller => 'api/v1/versions',
      :action => 'show',
      :type_id => '1',
      :format => :json
    )
  end
end