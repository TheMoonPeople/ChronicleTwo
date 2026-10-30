--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local close_message = require("@lib/event/close_message")
local helper_c45eb7de = require("@lib/event/helper_c45eb7de")

--- Helper function.
local function helper_c2ea93a9(arg0: s32, arg1: any, arg2: any, arg3: s32, arg4: any)
	local var5: s32 = 0
	vm.wait(1)
	vm.wait(2)
	event.set_message_bubble_screen_slot(arg0, 0)
	event.open_message_window_2(arg0, arg1)
	event.place_message_bubble(arg0, arg2, arg3)
	do
		local _: any
		_, var5 = helper_c45eb7de(arg0, 0, var5)
	end
	close_message(arg0)
end

return helper_c2ea93a9
