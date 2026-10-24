--!strict
-- Shared event helper used by 20 scripts, translated by tools/luau/stb2luau.

local helper_899661d6 = require("@lib/event/helper_899661d6")

--- Helper function.
local function helper_7518fb0c(arg0: s32, arg1: any)
	local var2: s32 = 0
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(
			0,
			"Alors tu m'as vue au cirque ?\nC'[UNI00e9]tait pas mal, non ?<page>Mais ce n'est pas vraiment un\nboulot, plut[UNI00f4]t un passe-temps."
		)
	else
		event.MesMake_2(0, "Alors, t'as un scoop ? T'as\nvu des gros durs dans cette mine ?")
	end
	helper_899661d6(arg0, -1, 0, 0)
end

return helper_7518fb0c
