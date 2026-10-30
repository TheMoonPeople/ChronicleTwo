--!strict
-- Shared event helper used by 21 scripts, translated by tools/luau/stb2luau.

local helper_530276dc = require("@lib/event/helper_530276dc")

--- Helper function.
local function helper_ee6f9901()
	local var0: s32 = 0
	var0 = event.get_triggered_event_data_2(14) or var0
	if var0 < 100 or 1000 < var0 then
		helper_530276dc()
	end
end

return helper_ee6f9901
