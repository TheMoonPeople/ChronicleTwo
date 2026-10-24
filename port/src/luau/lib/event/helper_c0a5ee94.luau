--!strict
-- Shared event helper used by 20 scripts, translated by tools/luau/stb2luau.

local helper_0b7b515e = require("@lib/event/helper_0b7b515e")

--- Helper function.
local function helper_c0a5ee94()
	local var0: s32 = 0
	var0 = event.GetEventData_2(14) or var0
	if var0 < 100 or 1000 < var0 then
		helper_0b7b515e()
	end
end

return helper_c0a5ee94
