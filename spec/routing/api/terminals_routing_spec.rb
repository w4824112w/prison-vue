require 'rails_helper'

RSpec.describe 'routing terminals', type: :routing do
  it 'routes /api/v1/terminals/terminal_number/meetings to terminals#index' do
    expect(get: '/api/v1/terminals/1111/meetings').to route_to(
      :controller => 'api/v1/terminals',
      :action => 'index',
      :terminal_number => '1111',
      :format => :json
    )
  end 
end
