--!strict
-- Shared event helper used by 20 scripts, translated by tools/luau/stb2luau.

local helper_4c4a0265 = require("@lib/event/helper_4c4a0265")

--- Helper function.
local function helper_5adb3a99()
	local var0: s32 = 0
	var0 = event.GetEventData_2(14) or var0
	if var0 < 100 or 1000 < var0 then
		helper_4c4a0265()
	end
end

return helper_5adb3a99
