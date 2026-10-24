--!strict
-- Shared event helper used by 17 scripts, translated by tools/luau/stb2luau.

local helper_d9872bff = require("@lib/event/helper_d9872bff")

--- Helper function.
local function helper_a22c9355()
	local var0: s32 = 0
	var0 = event.GetEventData_2(14) or var0
	if var0 < 100 or 1000 < var0 then
		helper_d9872bff()
	end
end

return helper_a22c9355
