--!strict
-- Shared event helper used by 12 scripts, translated by tools/luau/stb2luau.

local helper_b74f3920 = require("@lib/event/helper_b74f3920")

--- Helper function.
local function helper_6982de90()
	local var0: s32 = 0
	var0 = event.GetEventData_2(14) or var0
	event.SetNpcStatus(var0, 128)
	helper_b74f3920(var0)
end

return helper_6982de90
