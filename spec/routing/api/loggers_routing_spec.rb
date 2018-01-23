require 'rails_helper'

RSpec.describe 'routing loggers', type: :routing do
  it 'routes /api/v1/loggers to loggers#create' do
    expect(post: '/api/v1/loggers').to route_to(
      :controller => 'api/v1/loggers',
      :action => 'create',
      :format => :json
    )
  end
end