require 'rails_helper'

RSpec.describe 'User login', type: :request do
 
  describe '#create' do
    let!(:valid_user) { create(:family, phone: '13999908705', uuid: '65010419811124217') }

    it 'expect 200 when login with valid family information' do
      post '/api/v1/login', params: {session: { phone: '13999908705', uuid: '65010419811124217' }}
      expect(JSON.parse(response.body)['code']).to eq(200)
    end

    it 'expect 401 when login with invalid family information' do
      post '/api/v1/login', params: {session: { phone: '17608447120', uuid: '65010419811124217' }}
      expect(JSON.parse(response.body)['code']).to eq(401)
    end
  end

end