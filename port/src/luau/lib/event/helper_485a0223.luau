--!strict
-- Shared event helper used by 20 scripts, translated by tools/luau/stb2luau.

local helper_899661d6 = require("@lib/event/helper_899661d6")

--- Helper function.
local function helper_485a0223(arg0: s32, arg1: any)
	local var2: s32 = 0
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(
			0,
			"Non mi piace vedere una donna\ncon una spada in mano.<page>Le donne migliori sono aggraziate.\nPrendi Adel, per esempio."
		)
	else
		event.MesMake_2(0, "Se posso aiutarti in qualche\nmodo, non esitare a chiedere.")
	end
	helper_899661d6(arg0, -1, 0, 0)
end

return helper_485a0223
