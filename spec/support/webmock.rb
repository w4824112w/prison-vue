require 'webmock/rspec'

RSpec.configure do |config|
  WebMock.disable_net_connect!(allow_localhost: true)

  # WebMock.stub_request(:post, "https://api.netease.im/sms/verifycode.action").
  # with(:body => {"code"=> nil, "mobile"=> nil},
  #         :headers => {'Accept'=>'*/*',
  #         'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
  #         'Content-Type'=>'application/x-www-form-urlencoded', 
  #         'Host'=>'api.netease.im', 'User-Agent'=>'Ruby'}).
  # to_return(body: '{"code": 200}')
  
  WebMock.stub_request(:any, "https://api.netease.im/sms/verifycode.action").
         with(:body => {"code"=>"3333", "mobile"=>"17608447120"},
              :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Appkey'=>'87dae6933488de4bab789054a3a5c720', 'User-Agent'=>'Ruby'}).
         to_return(:status => 200, :body => '{"code": 200}', :headers => {})
end