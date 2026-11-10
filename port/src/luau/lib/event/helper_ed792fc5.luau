--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_ed792fc5(arg0: any)
	local var1: s32 = 0
	var1 = event.get_message_window_state(arg0) or var1
	while var1 == 0 or var1 == 1 do
		vm.wait(1)
		var1 = event.get_message_window_state(arg0) or var1
	end
end

return helper_ed792fc5
