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
      it "returns a deprecation warning and '2.0.1'" do
        set_top_box = Dtvcontroller::SetTopBox.new("192.168.1.100")

        expect(set_top_box.ver).to eq("Dtvcontroller::SetTopBox#ver is deprecated, use '$ gem which dtvcontroller'\n2.0.1")
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

  end
end
