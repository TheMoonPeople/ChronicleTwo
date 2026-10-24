--!strict
-- Shared event helper used by 20 scripts, translated by tools/luau/stb2luau.

local helper_899661d6 = require("@lib/event/helper_899661d6")

--- Helper function.
local function helper_265ae74b(arg0: s32, arg1: any)
	local var2: s32 = 0
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(
			0,
			"Tu m'as aid[UNI00e9]e, je le ferai donc\naussi, mais piti[UNI00e9], ne m'emm[UNI00e8]ne pas\ndans un endroit plein d'insectes !"
		)
	else
		event.MesMake_2(
			0,
			"Si la Voie ferr[UNI00e9]e Noirpierre\ns'[UNI00e9]tend au monde entier, j'irai\npeut-[UNI00ea]tre aussi voyager."
		)
	end
	helper_899661d6(arg0, -1, 0, 0)
end

return helper_265ae74b
