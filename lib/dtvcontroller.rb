#####################################
#  Example Usage: 
#		control = Dtvcontroller.new("192.168.1.100")
#		
#		Getting current channel:
#			puts control.get_channel => "529: SEDGHD - The Lost World: Jurassic Park"
#		
#		Tuning to a certain channel:
#			a = "206"
#			control.tune(a) => "" *if 'msg' is not 'OK.' 'msg' will be RETURNED
#		
#		Sending a remote key:
#			a = "ch_up"
#			control.send_key(a) => ""
#		
#		Getting information from systeminfo
#			a = "accessCardId"
#			b = control.get_sysinfo(a)
#			puts b => "0918 9292 1846"
#
#	If connection fails because of timeout 
#	for any method, "Can't Connect." will be RETURNED.
#######################################

require 'net/http'
require 'json'

class Dtvcontroller

	def initialize(n)
		@ip = n
	end
	
	def ver
		puts "1"
	end
	
	def get_channel
	uri = URI('http://' + @ip + ':8080/tv/getTuned')

		begin
			result = Net::HTTP.get(uri)
			response = JSON.parse(result)

			if response["episodeTitle"] == nil # Not allow programs have an 'episodetitle'.  However, from my experience, all have a 'title' at the least.
				return response["major"].to_s + ': ' + response["callsign"] + ' - ' + response["title"] # Callsign is the channel 'name'
			else
				return response["major"].to_s + ': ' + response["callsign"] + ' - ' + response["title"] + ': ' + response["episodeTitle"]
			end

		rescue Errno::ETIMEDOUT => e
			return "Can't Connect"
		end
	end

	def tune(chan)
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
	
	#key-list: power, poweron, poweroff, format, pause, rew, replay, stop, advance, ffwd, record, play, guide, active, list, exit, back, menu, info, up, down, left, right, select, red, green, yellow, blue, ch_up, ch_dn, prev, 0-9, dash(or '-'), enter
	def send_key(key)
		uri = URI("http://" + @ip + ":8080/remote/processKey?key=" + key)
		begin
			Net::HTTP.get(uri)
		rescue Errno::ETIMEDOUT => e
			return "Can't Connect"
		end
	end
	
	#possible requests: accessCardId, receiverId, stbSoftwareVersion, version
	def get_sysinfo(request)
		uri = URI("http://" + @ip + ":8080/info/getVersion")
		a = Net::HTTP.get(uri)
		result = JSON.parse(a)
		parse = result[request]
		return parse
	end
	
end
