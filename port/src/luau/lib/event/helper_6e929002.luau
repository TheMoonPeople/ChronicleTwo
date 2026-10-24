--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local helper_125385ee = require("@lib/event/helper_125385ee")
local helper_907fd9a8 = require("@lib/event/helper_907fd9a8")

--- Helper function.
local function helper_6e929002()
	local var0: s32 = 0
	local flag: s32 = 0
	var0 = event.GetEventData_2(13) or var0
	helper_125385ee(0, 1)
	flag = event.GetFlag(648) or flag
	if flag == 0 then
		event.MesMake_2(0, "Ich warte hier auf dich.\nHoffentlich geht alles gut.")
	else
		event.MesMake_2(0, "Ich warte hier.\nSchnapp ihn dir.")
	end
	helper_907fd9a8(var0, -1, 0, 0)
end

return helper_6e929002
