--!strict
-- Shared event helper used by 12 scripts, translated by tools/luau/stb2luau.

local helper_59c8e763 = require("@lib/event/helper_59c8e763")

--- Helper function.
local function helper_473930cd()
	local var0: s32 = 0
	var0 = event.get_triggered_event_data_2(14) or var0
	event.set_npc_party_status(var0, 128)
	helper_59c8e763(var0)
end

return helper_473930cd
