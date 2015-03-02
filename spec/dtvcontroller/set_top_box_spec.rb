require "spec_helper"

module Dtvcontroller
  describe SetTopBox do
    describe "#initialize" do
      it "has an ip address string representation" do
        set_top_box = Dtvcontroller::SetTopBox.new("192.168.1.100")

        expect(set_top_box.ip).to eq("192.168.1.100")
      end

      it "has a base url" do
        set_top_box = Dtvcontroller::SetTopBox.new("192.168.1.100")

        expect(set_top_box.base_url).to eq("http://192.168.1.100:8080/")
      end
    end

    describe "#ver" do
      it "returns a deprecation warning and '2.0.0'" do
        set_top_box = Dtvcontroller::SetTopBox.new("192.168.1.100")

        expect(set_top_box.ver).to eq("SetTopBox#ver is deprecated, use '$ gem which dtvcontroller'\n2.0.0")
      end
    end

    describe "#send_key_options" do
      it "returns an array of symobols with choices" do
        options = [:power,
                   :poweron,
                   :poweroff,
                   :format,
                   :pause,
                   :rew,
                   :replay,
                   :stop,
                   :advance,
                   :ffwd,
                   :record,
                   :play,
                   :guide,
                   :active,
                   :list,
                   :exit,
                   :back,
                   :menu,
                   :info,
                   :up,
                   :down,
                   :left,
                   :right,
                   :select,
                   :red,
                   :green,
                   :yellow,
                   :blue,
                   :chanup,
                   :chandown,
                   :prev,
                   :"0",
                   :"1",
                   :"2",
                   :"3",
                   :"4",
                   :"5",
                   :"6",
                   :"7",
                   :"8",
                   :"9",
                   :dash,
                   :enter]
        set_top_box = Dtvcontroller::SetTopBox.new("192.168.1.100")

        expect(set_top_box.send_key_options).to eq(options)
      end
    end

    describe "#system_info_options" do
      it "lists the system info options" do
        options = [:access_card_id,
                   :receiver_id,
                   :stb_software_version,
                   :version]
        set_top_box = Dtvcontroller::SetTopBox.new("192.168.1.100")

        expect(set_top_box.system_info_options).to eq(options)
      end
    end

    describe "#system_info" do
      it "returns the access card id" do
        access_card_id = "0123-4567-8901"
        set_top_box = Dtvcontroller::SetTopBox.new("192.168.1.100")

        expect(set_top_box.system_info(:access_card_id)).to eq(access_card_id)
      end

      it "returns the receiver id" do
        receiver_id = "0123 4567 8901"
        set_top_box = Dtvcontroller::SetTopBox.new("192.168.1.100")

        expect(set_top_box.system_info(:receiver_id)).to eq(receiver_id)
      end

      it "returns the set top box software version" do
        stb_software_version = "0x912"
        set_top_box = Dtvcontroller::SetTopBox.new("192.168.1.100")

        expect(set_top_box.system_info(:stb_software_version)).to eq(stb_software_version)
      end

      it "returns the version" do
        version = "1.6"
        set_top_box = Dtvcontroller::SetTopBox.new("192.168.1.100")

        expect(set_top_box.system_info(:version)).to eq(version)
      end

      it "returns the access card id when given a string (not a symbol)" do
        access_card_id = "0123-4567-8901"
        set_top_box = Dtvcontroller::SetTopBox.new("192.168.1.100")

        expect(set_top_box.system_info("access_card_id")).to eq(access_card_id)
      end

      it "raises a RuntimeError on a bad input parameter" do
        set_top_box = Dtvcontroller::SetTopBox.new("192.168.1.100")

        expect { set_top_box.system_info(:not_a_key) }.to raise_error(RuntimeError)
      end

      # special IP address 1.2.3.4 triggers the Webmock timeout
      it "raises a RuntimeError on a timeout" do
        set_top_box = Dtvcontroller::SetTopBox.new("1.2.3.4")

        expect { set_top_box.system_info(:version) }.to raise_error(RuntimeError)
      end

      # special IP address 4.3.2.1 triggers the Webmock runtime error
      it "raises a RuntimeError on a failed connection" do
        set_top_box = Dtvcontroller::SetTopBox.new("4.3.2.1")

        expect { set_top_box.system_info(:version) }.to raise_error(RuntimeError)
      end
    end

    describe "#get_sysinfo" do
      it "aliases to #system_info" do
        set_top_box = Dtvcontroller::SetTopBox.new("192.168.1.100")
        system_info_method = set_top_box.method(:system_info)
        get_sysinfo_method = set_top_box.method(:get_sysinfo)

        expect(system_info_method).to eq(get_sysinfo_method)
      end
    end

    describe "#tune_to_channel" do
      it "changes the channel given a number from 1-65536" do
        set_top_box = Dtvcontroller::SetTopBox.new("192.168.1.100")

        expect(set_top_box.tune_to_channel(7)).to eq("OK.")
      end

      it "returns the 'Forbidden' message given channel 0" do
        failure_string = "Forbidden.Invalid URL parameter(s) found."
        set_top_box = Dtvcontroller::SetTopBox.new("192.168.1.100")

        expect(set_top_box.tune_to_channel(0)).to eq(failure_string)
      end

      it "returns the 'Forbidden' message given channel 10000" do
        failure_string = "Forbidden.Invalid URL parameter(s) found."
        set_top_box = Dtvcontroller::SetTopBox.new("192.168.1.100")

        expect(set_top_box.tune_to_channel(10000)).to eq(failure_string)
      end

      it "returns the 'no input' message given a blank channel" do
        set_top_box = Dtvcontroller::SetTopBox.new("192.168.1.100")

        expect(set_top_box.tune_to_channel("")).to eq("no input")
      end

      # special IP address 1.2.3.4 triggers the Webmock timeout
      it "raises a RuntimeError on a timeout" do
        set_top_box = Dtvcontroller::SetTopBox.new("1.2.3.4")

        expect { set_top_box.tune_to_channel(7) }.to raise_error(RuntimeError)
      end

      # special IP address 4.3.2.1 triggers the Webmock runtime error
      it "raises a RuntimeError on a failed connection" do
        set_top_box = Dtvcontroller::SetTopBox.new("4.3.2.1")

        expect { set_top_box.tune_to_channel(7) }.to raise_error(RuntimeError)
      end
    end

    describe "#tune" do
      it "aliases to #tune_to_channel" do
        set_top_box = Dtvcontroller::SetTopBox.new("192.168.1.100")
        tune_method = set_top_box.method(:tune)
        tune_to_channel_method = set_top_box.method(:tune_to_channel)

        expect(tune_method).to eq(tune_to_channel_method)
      end
    end

    describe "#get_currently_playing" do
      # Use 192.168.1.101 for a TV episode
      it "returns major and callsign and title and episode title for a tv show" do
        tv_response = "299: NIKeHD - How I Met Your Mother: Sunrise"
        set_top_box = Dtvcontroller::SetTopBox.new("192.168.1.101")

        expect(set_top_box.currently_playing).to eq(tv_response)
      end

      # Use 192.168.1.102 for a movie
      it "returns major and callsign and title for a movie" do
        movie_response = "501: HBOeHD - Good Burger"
        set_top_box = Dtvcontroller::SetTopBox.new("192.168.1.102")

        expect(set_top_box.currently_playing).to eq(movie_response)
      end

      # special IP address 1.2.3.4 triggers the Webmock timeout
      it "raises a RuntimeError on a timeout" do
        set_top_box = Dtvcontroller::SetTopBox.new("1.2.3.4")

        expect { set_top_box.currently_playing }.to raise_error(RuntimeError)
      end

      # special IP address 4.3.2.1 triggers the Webmock runtime error
      it "raises a RuntimeError on a failed connection" do
        set_top_box = Dtvcontroller::SetTopBox.new("4.3.2.1")

        expect { set_top_box.currently_playing }.to raise_error(RuntimeError)
      end
    end

    describe "#get_channel" do
      it "aliases to #currently_playing" do
        set_top_box = Dtvcontroller::SetTopBox.new("192.168.1.100")
        system_info_method = set_top_box.method(:get_channel)
        get_sysinfo_method = set_top_box.method(:currently_playing)

        expect(system_info_method).to eq(get_sysinfo_method)
      end
    end

    describe "#send_key" do
      it "sends the dash key" do
        set_top_box = Dtvcontroller::SetTopBox.new("192.168.1.100")

        expect(set_top_box.send_key(:dash)).to eq("OK.")
      end

      it "sends the dash key given a string (not a symbol)" do
        set_top_box = Dtvcontroller::SetTopBox.new("192.168.1.100")

        expect(set_top_box.send_key("dash")).to eq("OK.")
      end

      it "raises a RuntimeError on a bad input parameter" do
        set_top_box = Dtvcontroller::SetTopBox.new("192.168.1.100")

        expect { set_top_box.send_key(:not_a_key) }.to raise_error(RuntimeError)
      end

      # special IP address 1.2.3.4 triggers the Webmock timeout
      it "raises a RuntimeError on a timeout" do
        set_top_box = Dtvcontroller::SetTopBox.new("1.2.3.4")

        expect { set_top_box.send_key(:dash) }.to raise_error(RuntimeError)
      end

      # special IP address 4.3.2.1 triggers the Webmock runtime error
      it "raises a RuntimeError on a failed connection" do
        set_top_box = Dtvcontroller::SetTopBox.new("4.3.2.1")

        expect { set_top_box.send_key(:dash) }.to raise_error(RuntimeError)
      end
    end

  end
end
