--!strict
-- Shared event helper used by 20 scripts, translated by tools/luau/stb2luau.

local helper_1449e05c = require("@lib/event/helper_1449e05c")
local helper_899661d6 = require("@lib/event/helper_899661d6")

--- Helper function.
local function helper_7e02c221(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local active_chr_no: s32 = 0
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		active_chr_no = event.GetActiveChrNo() or active_chr_no
		if active_chr_no == 1 then
			helper_1449e05c(arg0, arg1)
			return
		end
		event.MesMake_2(0, "Aber geh nirgends hin,\nwo's zu gef[UNI00e4]hrlich ist.")
	else
		event.MesMake_2(0, "Endlich f[UNI00e4]hrt die Blackstone-\nBahn auf der ganzen Welt.\nDas ist so aufregend!")
	end
	helper_899661d6(arg0, -1, 0, 0)
end

return helper_7e02c221
