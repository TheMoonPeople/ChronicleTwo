--!strict
-- Shared event helper used by 20 scripts, translated by tools/luau/stb2luau.

local helper_899661d6 = require("@lib/event/helper_899661d6")

--- Helper function.
local function helper_cb9bf720(arg0: s32, arg1: any)
	local var2: s32 = 0
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(
			0,
			"Le livre que j'ai achet[UNI00e9] ?\nEn fait, je ne l'ai pas encore lu.<page>Le poss[UNI00e9]der suffit [UNI00e0] mon\nbonheur."
		)
	else
		event.MesMake_2(0, "La Mine de zelmite est un endroit\nterrifiant. Reste toujours sur\ntes gardes.")
	end
	helper_899661d6(arg0, -1, 0, 0)
end

return helper_cb9bf720
