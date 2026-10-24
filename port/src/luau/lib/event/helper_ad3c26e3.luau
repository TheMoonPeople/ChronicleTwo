--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local helper_125385ee = require("@lib/event/helper_125385ee")
local helper_907fd9a8 = require("@lib/event/helper_907fd9a8")

--- Helper function.
local function helper_ad3c26e3()
	local var0: s32 = 0
	local flag: s32 = 0
	var0 = event.GetEventData_2(13) or var0
	helper_125385ee(0, 1)
	flag = event.GetFlag(648) or flag
	if flag == 0 then
		event.MesMake_2(0, "Te esperar[UNI00e9] aqu[UNI00ed].\nEspero que salga todo bien.")
	else
		event.MesMake_2(0, "Esperar[UNI00e9] aqu[UNI00ed].\nEnc[UNI00e1]rgate de [UNI00e9]l.")
	end
	helper_907fd9a8(var0, -1, 0, 0)
end

return helper_ad3c26e3
