--!strict
-- Shared event helper used by 20 scripts, translated by tools/luau/stb2luau.

local helper_899661d6 = require("@lib/event/helper_899661d6")

--- Helper function.
local function helper_cf8cd98b(arg0: s32, arg1: any)
	local var2: s32 = 0
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(0, "[UNI00bf]Qu[UNI00e9] tal te queda?<page>[UNI00a1]No me mientas!")
	else
		event.MesMake_2(0, "Rezar[UNI00e9] por ti...")
	end
	helper_899661d6(arg0, -1, 0, 0)
end

return helper_cf8cd98b
