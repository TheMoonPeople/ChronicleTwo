--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_60979549()
	local flag: s32 = 0
	flag = event.get_save_flag(207) or flag
	if flag == 1 then
		flag = event.get_save_flag(208) or flag
		if flag == 0 then
			event.fade_out_screen(0)
			vm.wait(1)
			event.load_event_script("g01/g01b_1.stb", 501)
		end
	end
end

return helper_60979549
