--!strict
-- Shared event helper used by 20 scripts, translated by tools/luau/stb2luau.

local helper_899661d6 = require("@lib/event/helper_899661d6")

--- Helper function.
local function helper_44e7b6e8(arg0: s32, arg1: any)
	local var2: s32 = 0
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(
			0,
			"[UNI00bf]As[UNI00ed] que me has visto en el circo?\n[UNI00bf]Est[UNI00e1] bien, eh?<page>Para m[UNI00ed] es m[UNI00e1]s una afici[UNI00f3]n\nque un trabajo."
		)
	else
		event.MesMake_2(
			0,
			"[UNI00bf]Qu[UNI00e9] hay de los logros? [UNI00bf]Te has encontrado\ncon alg[UNI00fa]n bicho raro en la mina?"
		)
	end
	helper_899661d6(arg0, -1, 0, 0)
end

return helper_44e7b6e8
