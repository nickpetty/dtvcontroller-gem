Description
============
This gem allows one to control a DirecTV STB (receiver).

Requirements
============

+ net/http (gem install net/http)
+ json (gem install json)
+ Whole-Home -> External Device - All set to 'Allow'

Install
=======

	gem install dtvcontroller
	
Example Usage
=============

Initialize:
-----------

	control = Dtvcontroller.new("192.168.1.100")

Get current channel: (If timeout, returns "Can't Connect")
----------------------------------------------------------

Movie Example:

	puts control.get_channel => 529: SEDGHD - The Lost World: Jurassic Park 
	
Show Example:

	puts control.get_channel => 298: CNHD - Family Guy: Peters Tale

Sending a remote key:
---------------------

	a = "ch_up" (see "Command List" for full list of commands)
	control.send_key(a) => nil (If timeout, returns "Can't Connect")

Getting information from systeminfo:
------------------------------------

	a = "accessCardId" (see "Command List" for full list of commands)
	b = control.get_sysinfo(a)
	puts b => 0918-7948-2357 (If timeout, returns "Can't Connect")
