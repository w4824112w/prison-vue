require 'rails_helper'

RSpec.describe 'routing comments', type: :routing do
  it 'routes /api/v1/mails/:id/comments to comments#index' do
    expect(get: '/api/v1/mails/1/comments').to route_to(
      :controller => 'api/v1/comments',
      :action => 'index',
      :id => '1',
      :format => :json
    )
  end
end