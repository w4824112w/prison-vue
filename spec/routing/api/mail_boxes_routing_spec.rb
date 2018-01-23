require 'rails_helper'

RSpec.describe 'routing mail_box' do
  it 'routes /api/v1/mails to mail_boxes#create for create a message' do
    expect(post: '/api/v1/mails').to route_to(
      :controller => 'api/v1/mail_boxes',
      :action => 'create',
      :format => :json
    )
  end

  it 'routes /api/v1/families/:id/mails to mail_boxes#index for getting mails for specify family' do
    expect(get: '/api/v1/families/1/mails').to route_to(
      :controller => 'api/v1/mail_boxes',
      :action => 'index',
      :id => '1',
      :format => :json
    )
  end
end
