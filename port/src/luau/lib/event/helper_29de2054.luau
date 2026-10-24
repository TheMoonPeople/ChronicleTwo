--!strict
-- Shared event helper used by 20 scripts, translated by tools/luau/stb2luau.

local helper_899661d6 = require("@lib/event/helper_899661d6")

--- Helper function.
local function helper_29de2054(arg0: s32, arg1: any)
	local var2: s32 = 0
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(0, "Un d[UNI00ed]a espero poder\nsubirme al podio yo tambi[UNI00e9]n.")
	else
		event.MesMake_2(0, "Me gustar[UNI00ed]a que Fabio se interesase\npor algo m[UNI00e1]s aparte\nde la pesca.")
	end
	helper_899661d6(arg0, -1, 0, 0)
end

return helper_29de2054
