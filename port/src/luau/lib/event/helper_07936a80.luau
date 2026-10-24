--!strict
-- Shared event helper used by 20 scripts, translated by tools/luau/stb2luau.

local helper_8f5252f6 = require("@lib/event/helper_8f5252f6")
local helper_b5a98ffa = require("@lib/event/helper_b5a98ffa")

--- Helper function.
local function helper_07936a80(arg0: s32, arg1: s32)
	local var2: any = 0
	event.SetMesShippo(0, 0)
	event.SetMesQuestionGyou(0, 0)
	event.SetMesEtc(0, 0, 1)
	event.MesMake_2(0, "Claro, d[UNI00e9]jame probar.\nNo me apetece.")
	var2 = helper_8f5252f6(0, -1, 5, 256, 208, 2, 1)
	event.SetMesShippo(0, 1)
	event.SetMesEtc(0, 0, 0)
	if var2 ~= 0 then
		event.MesMake_2(
			0,
			"Vale...<page>Bueno, si quieres volver a probar m[UNI00e1]s tarde,\nd[UNI00ed]melo. Te esperar[UNI00e9]."
		)
		helper_b5a98ffa(0, -1, arg0, arg1, 0)
		event.SetMotion(arg0, "立ち")
		event.Finish()
		event.SetCnt(7, 0)
		return
	end
	event.MesMake_2(0, "[UNI00a1]Preparado, listo,\nya!")
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.Finish()
	event.Stopwatch(3, 32, 364, 0)
	event.Stopwatch_1(0)
	event.SetCnt(7, 1)
end

return helper_07936a80
