--!strict
-- Shared event helper used by 114 scripts, translated by tools/luau/stb2luau.

local helper_024677a1 = require("@lib/event/helper_024677a1")

--- Helper function.
local function helper_9cc4383b()
	local var0: s32 = 0
	var0 = event.get_triggered_event_data_2(14) or var0
	event.set_npc_party_status(var0, 128)
	helper_024677a1(var0)
end

return helper_9cc4383b
