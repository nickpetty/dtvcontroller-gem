require "net/http"
require "json"
require_relative "constants"

module Dtvcontroller
  class SetTopBox
    include Constants
    attr_reader :ip, :base_url

    def initialize(ip_address)
      @ip = ip_address.to_s
      @base_url = "http://#{ip}:8080/"
    end

    def ver
      "Dtvcontroller::SetTopBox#ver is deprecated, use '$ gem which dtvcontroller'\n2.0.1"
    end

    def get_channel
    uri = URI('http://' + @ip + ':8080/tv/getTuned')

      begin
        result = Net::HTTP.get(uri)
        response = JSON.parse(result)

        if response["episodeTitle"] == nil # Not all programs have an 'episodetitle'.  However, from my experience, all have a 'title' at the least.
          return response["major"].to_s + ': ' + response["callsign"] + ' - ' + response["title"] # Callsign is the channel 'name'
        else
          return response["major"].to_s + ': ' + response["callsign"] + ' - ' + response["title"] + ': ' + response["episodeTitle"]
        end

      rescue Errno::ETIMEDOUT => e
        return "Can't Connect"
      end
    end

    def tune_to_channel(number)
      uri = URI("#{base_url}tv/tune?major=#{number}")
      begin
        response = Net::HTTP.get(uri)
        result = JSON.parse(response)
        msg = result["status"]["msg"]
      rescue Errno::ETIMEDOUT
        raise Chickens
      end
    end

    def tune(channel)
      if chan == ''
        return 'no input'
      else
        uri = URI('http://' + @ip + ':8080/tv/tune?major=' + chan)

        begin
          result = Net::HTTP.get(uri)
          response = JSON.parse(result)
          parse = response["status"]
          message = parse["msg"]
          if message != "OK."
            return message
          end

        rescue Errno::ETIMEDOUT => e
          return "Can't Connect"
        end
      end
    end

    def send_key_options
      SEND_KEY_OPTIONS
    end

    def send_key(key)
      uri = URI("http://" + @ip + ":8080/remote/processKey?key=" + key)
      begin
        Net::HTTP.get(uri)
      rescue Errno::ETIMEDOUT => e
        return "Can't Connect"
      end
    end

    def system_info_options
      SYSTEM_INFO_HASH.keys
    end

    def system_info(item)
      value = validated_lookup(item, SYSTEM_INFO_HASH)
      url = "#{base_url}info/getVersion"
      response_hash = get_json_parsed_response_body(url)
      response_hash[value]
    end
    alias_method :get_sysinfo, :system_info

    private

    def validated_lookup(key, hash_to_search)
      begin
        hash_to_search.fetch(key.to_sym)
      rescue KeyError
        raise "Unrecognized key (#{key}) in hash (#{hash_to_search})"
      end
    end

    # TODO add a retry with counter and decrement Ruby Tapas #257
    def get_json_parsed_response_body(url)
      begin
        response = Net::HTTP.get(URI(url))
        JSON.parse(response)
      rescue Errno::ETIMEDOUT
        return "Cannot connect to set top box"
      rescue Errno::EHOSTUNREACH
        return "Unreachable host likely caused by no internet connect"
      end
    end

  end
end

