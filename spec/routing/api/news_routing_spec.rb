require 'rails_helper'

RSpec.describe 'routing to news', type: :routing do
  it 'routes /api/v1/jails/:id/news to news#index' do
    expect(:get => "/api/v1/jails/1/news").to route_to(
      :controller => 'api/v1/news',
      :action => 'index',
      :id => '1',
      :format => :json
    )
  end

  it 'routes /api/v1/news/:id/comments to news#comment' do
    expect(post: '/api/v1/news/1/comments').to route_to(
      :controller => 'api/v1/news',
      :action => 'comment',
      :id => '1',
      :format => :json
    )
  end
end