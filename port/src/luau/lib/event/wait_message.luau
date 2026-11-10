--!strict
-- Shared event helper used by 573 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Waits while a message window opens or prints its text.
local function wait_message(window: s32)
	local var1: s32 = 0
	var1 = event.get_message_window_state(window) or var1
	while var1 == 0 or var1 == 1 do
		vm.wait(1)
		var1 = event.get_message_window_state(window) or var1
	end
end

return wait_message
