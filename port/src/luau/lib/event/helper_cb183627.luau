--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local helper_d4581b6b = require("@lib/event/helper_d4581b6b")

--- Helper function.
local function helper_cb183627()
	local var0: s32 = 0
	local var1: s32 = 0
	var0 = event.get_quest_request_status(0, 18) or var0
	if var0 == 1 then
		var1 = event.get_save_counter(11) or var1
		if var1 == 0 then
			helper_d4581b6b()
		end
	end
end

return helper_cb183627
