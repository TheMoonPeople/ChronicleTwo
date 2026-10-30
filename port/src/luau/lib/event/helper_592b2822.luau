--!strict
-- Shared event helper used by 21 scripts, translated by tools/luau/stb2luau.

local helper_60ae61ab = require("@lib/event/helper_60ae61ab")

--- Helper function.
local function helper_592b2822()
	local var0: s32 = 0
	var0 = event.get_triggered_event_data_2(14) or var0
	if var0 < 100 or 1000 < var0 then
		helper_60ae61ab()
	end
end

return helper_592b2822
