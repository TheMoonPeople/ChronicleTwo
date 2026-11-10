--!strict
-- Shared event helper used by 18 scripts, translated by tools/luau/stb2luau.

local helper_254d4079 = require("@lib/event/helper_254d4079")

--- Helper function.
local function helper_c9f06b66()
	local var0: s32 = 0
	var0 = event.get_triggered_event_data_2(14) or var0
	if var0 < 100 or 1000 < var0 then
		helper_254d4079()
	end
end

return helper_c9f06b66
