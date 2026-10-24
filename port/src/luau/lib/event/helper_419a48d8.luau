--!strict
-- Shared event helper used by 20 scripts, translated by tools/luau/stb2luau.

local helper_8f8958d0 = require("@lib/event/helper_8f8958d0")

--- Helper function.
local function helper_419a48d8()
	local var0: s32 = 0
	var0 = event.GetEventData_2(14) or var0
	if var0 < 100 or 1000 < var0 then
		helper_8f8958d0()
	end
end

return helper_419a48d8
