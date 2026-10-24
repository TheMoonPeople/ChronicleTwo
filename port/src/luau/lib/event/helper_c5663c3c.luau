--!strict
-- Shared event helper used by 20 scripts, translated by tools/luau/stb2luau.

local helper_b5a98ffa = require("@lib/event/helper_b5a98ffa")
local helper_c8484b43 = require("@lib/event/helper_c8484b43")

--- Helper function.
local function helper_c5663c3c(arg0: s32, arg1: s32)
	event.SetMesPreset(0, 0)
	helper_c8484b43(arg0, 0, 0)
	event.MesMake_2(
		0,
		"Oui, si j'essaie [UNI00e0] nouveau et je\ntermine quelque chose, peut-[UNI00ea]tre\nretrouverai-je confiance en moi."
	)
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.MesMake_2(
		0,
		"Mais j'ai pas les mat[UNI00e9]riaux<page>n[UNI00e9]cessaires. Pourrais-tu te les\nprocurer pour moi ?"
	)
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.MesMake_2(0, "Il me faut du tissu r[UNI00e9]sistant,\ndu cuir [UNI00e9]pais et un morceau\nde cuivre.")
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.SetMotion(arg0, "立ち")
	event.Finish()
	event.SetCnt(8, 1)
end

return helper_c5663c3c
