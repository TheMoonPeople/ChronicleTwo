--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local helper_7af77120 = require("@lib/event/helper_7af77120")

--- Helper function.
local function helper_47e094a6()
	local var0: s32 = 0
	var0 = event.GetEventData_2(14) or var0
	if var0 < 100 or 1000 < var0 then
		helper_7af77120()
	end
end

return helper_47e094a6
