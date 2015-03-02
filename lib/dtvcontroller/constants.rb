module Dtvcontroller
  module Constants
    SEND_KEY_OPTIONS = [:power, :poweron, :poweroff, :format, :pause, :rew,
                        :replay, :stop, :advance, :ffwd, :record, :play,
                        :guide, :active, :list, :exit, :back, :menu, :info,
                        :up, :down, :left, :right, :select, :red, :green,
                        :yellow, :blue, :chanup, :chandown, :prev, :"0",
                        :"1", :"2", :"3", :"4", :"5", :"6", :"7", :"8", :"9",
                        :dash, :enter]

    SYSTEM_INFO_HASH = {:access_card_id => "accessCardId",
                        :receiver_id => "receiverId",
                        :stb_software_version => "stbSoftwareVersion",
                        :version => "version"}
  end
end
