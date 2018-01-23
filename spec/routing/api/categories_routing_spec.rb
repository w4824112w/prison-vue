require 'rails_helper'

RSpec.describe 'routing categories', type: :routing do
  it 'routes /api/v1/categories to categories#index' do
    expect(get: '/api/v1/categories').to route_to(
      :controller => 'api/v1/categories',
      :action => 'index',
      :format => :json
    )
  end
end