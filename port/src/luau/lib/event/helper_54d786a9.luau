--!strict
-- Shared event helper used by 20 scripts, translated by tools/luau/stb2luau.

local helper_899661d6 = require("@lib/event/helper_899661d6")

--- Helper function.
local function helper_54d786a9(arg0: s32, arg1: any)
	local var2: s32 = 0
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(
			0,
			"[UNI00bf]El libro que compr[UNI00e9]?\nEn realidad todav[UNI00ed]a no lo he le[UNI00ed]do.<page>Me bastaba\nel hecho de tenerlo."
		)
	else
		event.MesMake_2(
			0,
			"La Mina de Zelmite es un lugar terror[UNI00ed]fico.\nNo se puede bajar\nla guardia ni un momento."
		)
	end
	helper_899661d6(arg0, -1, 0, 0)
end

return helper_54d786a9
