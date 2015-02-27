Description
===========
This gem allows one to control a DirecTV Set Top Box (STB or receiver).  This works with the current implication of the "External Device" control system.  DirecTV could change or even disable this method at any time without notice.

# Requirements

+ net/http
+ json
+ External Device set to Allow on DTV Box (Menu -> Settings -> Whole-Home -> External Device - All set to 'Allow')

# Install

Use rubygems to install the dtvcontroller gem:

```
$ gem install dtvcontroller
```

# Example Usage

### Initialize:

```
irb(main):001:0> require "dtvcontroller"
=> true
irb(main):002:0> set_top_box = Dtvcontroller::SetTopBox.new("192.168.1.100")
=> #<Dtvcontroller::SetTopBox:0x000000028ab450 @ip="192.168.1.100", @base_url="http://192.168.1.100:8080">
```

### Get details on what's on with `#currently_playing`:

```
irb(main):003:0> set_top_box.currently_playing
=> "529: SEDGHD - The Lost World: Jurassic Park"
```

The output follows the format:

```
<Channel>:<Network> - <Program>: <Program Title if Available>
```

A TV show looks like this (note the episode title):

```
irb(main):004:0> set_top_box.currently_playing
=> "298: CNHD - Family Guy: Peters Tale"
```

### Change the channel with `#tune_to_channel`:

```
irb(main):005:0> set_top_box.tune_to_channel(7)
=> "OK."
```

### Channel Options:

Must be between 1-9999.

### Simulate the remote with `#send_key`:

```
irb(main):006:0> set_top_box.send_key(:chanup)
=> "OK."
```

### Remote Key Options:

+ `:power`
+ `:poweron`
+ `:poweroff`
+ `:format`
+ `:pause`
+ `:rew`
+ `:replay`
+ `:stop`
+ `:advance`
+ `:ffwd`
+ `:record`
+ `:play`
+ `:guide`
+ `:active`
+ `:list`
+ `:exit`
+ `:back`
+ `:menu`
+ `:info`
+ `:up`
+ `:down`
+ `:left`
+ `:right`
+ `:select`
+ `:red`
+ `:green`
+ `:yellow`
+ `:blue`
+ `:chanup`
+ `:chandown`
+ `:prev`
+ `:0-9`
+ `:dash`
+ `:enter`

### Get details about the unit with `#system_info`:

```
irb(main):007:0> set_top_box.system_info(:access_card_id)
=> "0123-4567-8901"
```

### System Info Options:

+ `:access_card_id`
+ `:receiver_id`
+ `:stb_software_version`
+ `:version`
