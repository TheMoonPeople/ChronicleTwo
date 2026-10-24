--!strict
-- Shared event helper used by 20 scripts, translated by tools/luau/stb2luau.

local helper_899661d6 = require("@lib/event/helper_899661d6")

--- Helper function.
local function helper_5ad564b3(arg0: s32, arg1: any)
	local var2: s32 = 0
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(0, "Tu m'as donn[UNI00e9] cette photo de la\nlune. Tu es g[UNI00e9]n[UNI00e9]reux.")
	else
		event.MesMake_2(
			0,
			"Si la voie ferr[UNI00e9]e Noirpierre couvre\nle monde entier, on va d[UNI00e9]couvrir\ndes tas de super nouveaux endroits."
		)
	end
	helper_899661d6(arg0, -1, 0, 0)
end

return helper_5ad564b3
