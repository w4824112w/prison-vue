require "rails_helper"

RSpec.describe Api::V1::RegistrationsController, :type => :controller do

  describe "POST #registration" do
    it "responds successfully with an HTTP 200 status code but create failed with invalid prisoner number" do
      post :create, params: { registration: FactoryGirl.attributes_for(:registration) }
      expect(response).to be_success
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)["code"]).to eq(500)
    end

    it "responds successfully with an HTTP 200 status and code 200 by created successfully" do
      prisoner = FactoryGirl.create :prisoner
      registration = FactoryGirl.build :registration, jail: prisoner.jail, prisoner_number: prisoner.prisoner_number
      post :create, params: { registration: registration }
      expect(response).to be_success
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)["code"]).to eq(200)
      expect(JSON.parse(response.body)["msg"]).to eq('申请已提交,请等待审核')
    end
  end

  # describe "PATCH #audit" do

  #   let!(:prisoner)     { FactoryGirl.create(:prisoner) }
  #   let!(:registration) { FactoryGirl.create(:registration, jail: prisoner.jail, prisoner_number: prisoner.prisoner_number) }
  #   let!(:images)       { FactoryGirl.create_list(:uuid_image, 3, registration: registration) }
    

  #   context 'reject a registration' do
  #     it "responds successfully with an HTTP 200 and code 401 and an array contains 禁闭中" do
  #       post :audit, params: { id: 1, status: 'DENIED', remarks: '禁闭中' }
  #       expect(response).to be_success
  #       expect(response).to have_http_status(200)
  #       puts response.body
  #       expect(JSON.parse(response.body)["code"]).to eq(200)
  #       expect(JSON.parse(response.body)["msg"]).to eq('Denied meeting id: 1 success')
  #     end
  #   end

  #   context 'agree a registration' do
  #     it "responds successfully with an HTTP 200 and code 200 by successfully agree a registration" do
  #       post :audit, params: { id: registration.id, status: 'PASSED' }
  #       expect(response).to be_success
  #       expect(response).to have_http_status(200)
  #       expect(response.body).to eq('{"code":200,"msg":"create success"}')
  #     end

  #     it "responds successfully with an HTTP 200 and code 404 and an array contains registration not found" do
  #       post :audit, params: { id: 100, status: 'PASSED' }
  #       expect(response).to be_success
  #       expect(response).to have_http_status(200)
  #       expect(response.body).to eq('{"code":404,"msg":"registration not found"}')
  #     end
  #   end

  # end

end