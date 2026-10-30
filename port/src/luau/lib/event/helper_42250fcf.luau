--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local helper_c53220da = require("@lib/event/helper_c53220da")

--- Helper function.
local function helper_42250fcf()
	local var0: s32 = 0
	var0 = event.get_triggered_event_data_2(14) or var0
	if var0 < 100 or 1000 < var0 then
		helper_c53220da()
	end
end

return helper_42250fcf
