require "rails_helper"

RSpec.describe Api::V1::SessionsController, :type => :controller do

  describe "POST #login" do
    it "responds successfully with an HTTP 200 status code" do
      post :login
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end
  end

#   describe "POST #verify_sms_code" do
#     it "responds successfully with an HTTP 200 status code" do
#       post :verify_sms_code
#       expect(response).to be_success
#       expect(response).to have_http_status(200)
#     end
#   end

end