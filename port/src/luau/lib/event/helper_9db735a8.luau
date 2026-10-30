--!strict
-- Shared event helper used by 21 scripts, translated by tools/luau/stb2luau.

local helper_2d355657 = require("@lib/event/helper_2d355657")

--- Helper function.
local function helper_9db735a8()
	local var0: s32 = 0
	var0 = event.get_triggered_event_data_2(14) or var0
	if var0 < 100 or 1000 < var0 then
		helper_2d355657()
	end
end

return helper_9db735a8
