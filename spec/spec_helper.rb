Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.include FactoryGirl::Syntax::Methods
  config.include Request::JSONHelpers, type: :controller
  config.include Request::HeadersHelpers, type: :controller

  config.before(:each, type: :controller) do
    include_default_accept_headers
  end

end
