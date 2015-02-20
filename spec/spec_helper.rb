require "dtvcontroller"
require "webmock/rspec"

system_info_json_as_string = "{\n  \"accessCardId\": \"0123-4567-8901\",\n  \"receiverId\": \"0123 4567 8901\",\n  \"status\": {\n    \"code\": 200,\n    \"commandResult\": 0,\n    \"msg\": \"OK.\",\n    \"query\": \"/info/getVersion\"\n  },\n  \"stbSoftwareVersion\": \"0x912\",\n  \"systemTime\": 1424316674,\n  \"version\": \"1.6\"\n}"

WebMock.disable_net_connect!(:allow_localhost => true)

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.before(:each) do
    stub_request(:get, /info\/getVersion/).
      to_return(:status => 200, :body => system_info_json_as_string, :headers => {})
    stub_request(:get, /1\.2\.3\.4/).to_timeout
    stub_request(:get, /4\.3\.2\.1/).to_raise(RuntimeError)
  end

end
