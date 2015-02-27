require "dtvcontroller"
require "webmock/rspec"

system_info_json_as_string = "{\n  \"accessCardId\": \"0123-4567-8901\",\n  \"receiverId\": \"0123 4567 8901\",\n  \"status\": {\n    \"code\": 200,\n    \"commandResult\": 0,\n    \"msg\": \"OK.\",\n    \"query\": \"/info/getVersion\"\n  },\n  \"stbSoftwareVersion\": \"0x912\",\n  \"systemTime\": 1424316674,\n  \"version\": \"1.6\"\n}"

change_channel_success_json_as_string = "{\"status\": {\n  \"code\": 200,\n  \"commandResult\": 0,\n  \"msg\": \"OK.\",\n  \"query\": \"/tv/tune?major=7\"\n}}"

change_channel_fail_json_as_string = "{\"status\": {\n  \"code\": 403,\n  \"commandResult\": 1,\n  \"msg\": \"Forbidden.Invalid URL parameter(s) found.\",\n  \"query\": \"/tv/tune?major=0\"\n}}"

currently_playing_tv_json_as_string = "{\n  \"broadcastStartTime\": 1424327040,\n  \"callsign\": \"NIKeHD\",\n  \"contentStartTime\": 27579,\n  \"date\": \"20140203\",\n \"duration\": 2160,\n  \"episodeTitle\": \"Sunrise\",\n  \"expiration\": \"0\",\n  \"expiryTime\": 0,\n  \"isOffAir\": false,\n  \"isPartial\": false,\n  \"isPclocked\": 3,\n  \"isPpv\": false,\n  \"isRecording\": false,\n  \"isViewed\": true,\n  \"isVod\": false,\n \"keepUntilFull\": true,\n  \"major\": 299,\n  \"minor\": 65535,\n  \"offset\": 1055,\n  \"priority\": \"20 of 31\",\n  \"programId\": \"13083758\",\n  \"rating\": \"TV-14-D-L\",\n  \"recType\": 3,\n  \"startTime\": 1424327040,\n  \"stationId\": 3900972,\n  \"status\": {\n    \"code\": 200,\n    \"commandResult\": 0,\n    \"msg\": \"OK.\",\n    \"query\": \"/tv/getTuned\"\n  },\n  \"title\": \"How I Met Your Mother\",\n  \"uniqueId\": \"6388\"\n}"

currently_playing_movie_json_as_string = "{\n  \"callsign\": \"HBOeHD\",\n  \"date\": \"1997\",\n  \"duration\": 6300,\n  \"isOffAir\": false,\n  \"isPclocked\": 3,\n  \"isPpv\": false,\n  \"isRecording\": false,\n  \"isVod\": false,\n  \"major\": 501,\n  \"minor\": 65535,\n  \"offset\": 5294,\n  \"programId\": \"8833886\",\n  \"rating\": \"PG\",\n  \"startTime\": 1424466900,\n  \"stationId\": 2220258,\n  \"status\": {\n    \"code\": 200,\n    \"commandResult\": 0,\n    \"msg\": \"OK.\",\n    \"query\": \"/tv/getTuned\"\n  },\n  \"title\": \"Good Burger\"\n}"

send_dash_key_success_json_as_string = "{\n  \"hold\": \"keyPress\",\n  \"key\": \"dash\",\n  \"status\": {\n    \"code\": 200,\n    \"commandResult\": 0,\n    \"msg\": \"OK.\",\n    \"query\": \"/remote/processKey?key=dash\"\n  }\n}"

WebMock.disable_net_connect!(:allow_localhost => true)

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.before(:each) do
    stub_request(:get, /1\.2\.3\.4/).to_timeout
    stub_request(:get, /4\.3\.2\.1/).to_raise(RuntimeError)
    stub_request(:get, "http://192.168.1.100:8080/info/getVersion").
      to_return(:status => 200, :body => system_info_json_as_string, :headers => {})
    stub_request(:get, "http://192.168.1.100:8080/tv/tune?major=0").
      to_return(:status => 200, :body => change_channel_fail_json_as_string, :headers => {})
    stub_request(:get, "http://192.168.1.100:8080/tv/tune?major=10000").
      to_return(:status => 200, :body => change_channel_fail_json_as_string, :headers => {})
    stub_request(:get, "http://192.168.1.100:8080/tv/tune?major=7").
      to_return(:status => 200, :body => change_channel_success_json_as_string, :headers => {})
    stub_request(:get, "http://192.168.1.101:8080/tv/getTuned").
      to_return(:status => 200, :body => currently_playing_tv_json_as_string, :headers => {})
    stub_request(:get, "http://192.168.1.102:8080/tv/getTuned").
      to_return(:status => 200, :body => currently_playing_movie_json_as_string, :headers => {})
    stub_request(:get, "http://192.168.1.100:8080/remote/processKey?key=dash").
      to_return(:status => 200, :body => send_dash_key_success_json_as_string, :headers => {})
  end

end
