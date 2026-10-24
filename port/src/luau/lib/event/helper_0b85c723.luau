--!strict
-- Shared event helper used by 20 scripts, translated by tools/luau/stb2luau.

local helper_8686a408 = require("@lib/event/helper_8686a408")

--- Helper function.
local function helper_0b85c723()
	local var0: s32 = 0
	var0 = event.GetEventData_2(14) or var0
	if var0 < 100 or 1000 < var0 then
		helper_8686a408()
	end
end

return helper_0b85c723
