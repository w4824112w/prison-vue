require 'rails_helper'

RSpec.describe 'routing feedbacks', type: :routing do
  it 'routes /api/v1/feedbacks to feedbacks#create' do
    expect(post: '/api/v1/feedbacks').to route_to(
      :controller => 'api/v1/feedbacks',
      :action => 'create',
      :format => :json
    )
  end
end