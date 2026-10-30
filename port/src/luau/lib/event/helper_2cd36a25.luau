--!strict
-- Shared event helper used by 21 scripts, translated by tools/luau/stb2luau.

local helper_46eca4fc = require("@lib/event/helper_46eca4fc")

--- Helper function.
local function helper_2cd36a25()
	local var0: s32 = 0
	var0 = event.get_triggered_event_data_2(14) or var0
	if var0 < 100 or 1000 < var0 then
		helper_46eca4fc()
	end
end

return helper_2cd36a25
