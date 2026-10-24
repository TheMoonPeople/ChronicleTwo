--!strict
-- Shared event helper used by 20 scripts, translated by tools/luau/stb2luau.

local helper_b5a98ffa = require("@lib/event/helper_b5a98ffa")
local helper_c8484b43 = require("@lib/event/helper_c8484b43")

--- Helper function.
local function helper_deb38ea6(arg0: s32, arg1: s32)
	event.SetMesPreset(0, 0)
	helper_c8484b43(arg0, 0, 0)
	event.MesMake_2(0, "[UNI00a1]Ah, por cierto!\nQuer[UNI00ed]a charlar contigo sobre un asunto.")
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.MesMake_2(
		0,
		"Ya sabr[UNI00e1]s que estoy\nhaciendo caramelos extra[UNI00f1]os de todo\nel mundo como parte de mi investigaci[UNI00f3]n."
	)
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.MesMake_2(0, "Me han hablado de un caramelo llamado Castagnaccio.")
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.MesMake_2(0, "que se fabrica con una cosa llamada Castarna.")
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.MesMake_2(0, "He descubierto que la Castarna crece\nen el mismo tipo de [UNI00e1]rbol que las Nueces.")
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.MesMake_2(
		0,
		"Por eso pens[UNI00e9] que dar[UNI00ed]a lo mismo usar Nueces en su lugar,\npero ha pasado algo raro...\nNo quedan Nueces en toda la ciudad."
	)
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.MesMake_2(0, "Parece ser que el alcalde las ha vendido todas.\nNo s[UNI00e9] si podr[UNI00ed]as ayudarme.")
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.SetMotion(arg0, "立ち")
	event.Finish()
	event.SetQuestEtc(0, 3, 1)
end

return helper_deb38ea6
