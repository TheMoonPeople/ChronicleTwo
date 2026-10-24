--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local helper_6992f518 = require("@lib/event/helper_6992f518")

--- Helper function.
local function helper_9a932dc0()
	event.CharaActive(0)
	event.SetMesEtc(1, 4, -1, -1, -1, -1)
	event.SetMesEtc(1, 9, -1, -1)
	helper_6992f518(1)
	event.Finish()
end

return helper_9a932dc0
