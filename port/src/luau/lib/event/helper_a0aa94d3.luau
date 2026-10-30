--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_a0aa94d3()
	local flag: s32 = 0
	flag = event.get_save_flag(207) or flag
	if flag == 0 then
		vm.wait(1)
		event.load_event_script("s02/s02b_1.stb", 501)
		return
	end
end

return helper_a0aa94d3
