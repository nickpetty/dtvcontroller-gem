require "dtvcontroller"
require "webmock/rspec"

system_info_json_as_string = <<-eos
  {
   "accessCardId": "0123-4567-8901",
   "receiverId": "0123 4567 8901",
   "status": {
    "code": 200,
    "commandResult": 0,
    "msg": "OK.",
    "query": "/info/getVersion"
   },
   "stbSoftwareVersion": "0x912",
   "systemTime": 1424316674,
   "version": "1.6"
  }
eos

change_channel_success_json_as_string = <<-eos
  {
   "status": {
    "code": 200,
    "commandResult": 0,
    "msg": "OK.",
    "query": "/tv/tune?major=7"
   }
  }
eos

change_channel_fail_json_as_string = <<-eos
  {
   "status": {
    "code": 403,
    "commandResult": 1,
    "msg": "Forbidden.Invalid URL parameter(s) found.",
    "query": "/tv/tune?major=0"
   }
  }
eos

currently_playing_tv_json_as_string = <<-eos
  {
   "broadcastStartTime": 1424327040,
   "callsign": "NIKeHD",
   "contentStartTime": 27579,
   "date": "20140203",
   "duration": 2160,
   "episodeTitle": "Sunrise",
   "expiration": 0,
   "expiryTime": 0,
   "isOffAir": false,
   "isPartial": false,
   "isPclocked": 3,
   "isPpv": false,
   "isRecording": false,
   "isViewed": true,
   "isVod": false,
   "keepUntilFull": true,
   "major": 299,
   "minor": 65535,
   "offset": 1055,
   "priority": "20 of 31",
   "programId": 13083758,
   "rating": "TV-14-D-L",
   "recType": 3,
   "startTime": 1424327040,
   "stationId": 3900972,
   "status": {
    "code": 200,
    "commandResult": 0,
    "msg": "OK.",
    "query": "/tv/getTuned"
   },
   "title": "How I Met Your Mother",
   "uniqueId": 6388
  }
eos

currently_playing_movie_json_as_string = <<-eos
  {
   "callsign": "HBOeHD",
   "date": 1997,
   "duration": 6300,
   "isOffAir": false,
   "isPclocked": 3,
   "isPpv": false,
   "isRecording": false,
   "isVod": false,
   "major": 501,
   "minor": 65535,
   "offset": 5294,
   "programId": "8833886",
   "rating": "PG",
   "startTime": 1424466900,
   "stationId": 2220258,
   "status": {
    "code": 200,
    "commandResult": 0,
    "msg": "OK.",
    "query": "/tv/getTuned"
   },
   "title": "Good Burger"
  }
eos

send_dash_key_success_json_as_string = <<-eos
  {
   "hold": "keyPress",
   "key": "dash",
   "status": {
    "code": 200,
    "commandResult": 0,
    "msg": "OK.",
    "query": "/remote/processKey?key=dash"
   }
  }
eos

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
