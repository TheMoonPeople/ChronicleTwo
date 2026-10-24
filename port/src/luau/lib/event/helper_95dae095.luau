--!strict
-- Shared event helper used by 108 scripts, translated by tools/luau/stb2luau.

local helper_5e868d47 = require("@lib/event/helper_5e868d47")

--- Helper function.
local function helper_95dae095()
	local var0: s32 = 0
	var0 = event.GetEventData_2(14) or var0
	event.SetNpcStatus(var0, 128)
	helper_5e868d47(var0)
end

return helper_95dae095
