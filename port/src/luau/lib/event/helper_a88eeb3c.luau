--!strict
-- Shared event helper used by 20 scripts, translated by tools/luau/stb2luau.

local helper_c071228a = require("@lib/event/helper_c071228a")

--- Helper function.
local function helper_a88eeb3c()
	local var0: s32 = 0
	var0 = event.GetEventData_2(14) or var0
	if var0 < 100 or 1000 < var0 then
		helper_c071228a()
	end
end

return helper_a88eeb3c
