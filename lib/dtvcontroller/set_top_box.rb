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
      "SetTopBox#ver is deprecated, use '$ gem which dtvcontroller'\n2.0.0"
    end

    def currently_playing
      url = "#{base_url}tv/getTuned"
      response_hash = get_json_parsed_response_body(url)
      channel = response_hash["major"].to_s
      network = response_hash["callsign"].to_s
      program = response_hash["title"].to_s
      result = "#{channel}: #{network} - #{program}"
      if response_hash.has_key?("episodeTitle")
        result = "#{result}: #{response_hash["episodeTitle"]}"
      end
      result
    end
    alias_method :get_channel, :currently_playing

    def tune_to_channel(number)
      return "no input" if number == ""
      url = "#{base_url}tv/tune?major=#{number}"
      response_hash = get_json_parsed_response_body(url)
      response_hash["status"]["msg"]
    end
    alias_method :tune, :tune_to_channel

    def send_key_options
      SEND_KEY_OPTIONS
    end

    def send_key(key)
      raise "Unknown remote key: #{key}" unless SEND_KEY_OPTIONS.include?(key.to_sym)
      url = "#{base_url}remote/processKey?key=#{key}"
      response_hash = get_json_parsed_response_body(url)
      response_hash["status"]["msg"]
    end

    def system_info_options
      SYSTEM_INFO_HASH.keys
    end

    def system_info(item)
      value = validated_hash_lookup(item, SYSTEM_INFO_HASH)
      url = "#{base_url}info/getVersion"
      response_hash = get_json_parsed_response_body(url)
      response_hash[value]
    end
    alias_method :get_sysinfo, :system_info

    private

    def validated_hash_lookup(key, hash_to_search)
      begin
        hash_to_search.fetch(key.to_sym)
      rescue KeyError
        raise "Unrecognized system option: #{key}"
      end
    end

    # TODO add a retry with counter and decrement per Ruby Tapas #257
    def get_json_parsed_response_body(url)
      begin
        response = Net::HTTP.get(URI(url))
        JSON.parse(response)
      rescue Errno::ETIMEDOUT
        raise "Cannot connect to set top box"
      rescue Errno::EHOSTUNREACH
        raise "Unreachable host likely caused by no internet connect"
      end
    end

  end
end

