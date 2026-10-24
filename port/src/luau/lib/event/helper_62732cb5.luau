--!strict
-- Shared event helper used by 20 scripts, translated by tools/luau/stb2luau.

local helper_b5a98ffa = require("@lib/event/helper_b5a98ffa")
local helper_c8484b43 = require("@lib/event/helper_c8484b43")

--- Helper function.
local function helper_62732cb5(arg0: s32, arg1: s32)
	event.SetMesPreset(0, 0)
	helper_c8484b43(arg0, 0, 0)
	event.MesMake_2(
		0,
		"S[UNI00ed], si lo intento otra vez\ny logro terminar algo,\nquiz[UNI00e1] vuelva a creer en m[UNI00ed] misma."
	)
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.MesMake_2(
		0,
		"Pero no tengo los materiales que necesito.<page>[UNI00bf]Podr[UNI00ed]as consegu[UNI00ed]rmelos?"
	)
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.MesMake_2(0, "S[UNI00f3]lo necesito tela resistente,\nun trozo de cuero gordo y un cacho de cobre.")
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.SetMotion(arg0, "立ち")
	event.Finish()
	event.SetCnt(8, 1)
end

return helper_62732cb5
