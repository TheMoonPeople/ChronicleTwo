--!strict
-- Shared event helper used by 438 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_8894386e(arg0: any, arg1: any, arg2: any, arg3: any)
	vm.wait(1)
	vm.wait(2)
	event.set_message_bubble_screen_slot(arg0, 0)
	event.open_message_window_2(arg0, arg1)
	event.place_message_bubble(arg0, arg2, arg3)
end

return helper_8894386e
