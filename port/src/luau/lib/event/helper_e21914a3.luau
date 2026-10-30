--!strict
-- Shared event helper used by 21 scripts, translated by tools/luau/stb2luau.

local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_c8484b43 = require("@lib/event/helper_c8484b43")

--- Helper function.
local function helper_e21914a3(arg0: s32, arg1: s32)
	event.apply_message_window_preset(0, 0)
	helper_c8484b43(arg0, 0, 0)
	event.open_message_window_2(0, "[UNI00a1]Ah, por cierto!\nQuer[UNI00ed]a charlar contigo sobre un asunto.")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(
		0,
		"Ya sabr[UNI00e1]s que estoy\nhaciendo caramelos extra[UNI00f1]os de todo\nel mundo como parte de mi investigaci[UNI00f3]n."
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(0, "Me han hablado de un caramelo llamado Castagnaccio.")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(0, "que se fabrica con una cosa llamada Castarna.")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(0, "He descubierto que la Castarna crece\nen el mismo tipo de [UNI00e1]rbol que las Nueces.")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(
		0,
		"Por eso pens[UNI00e9] que dar[UNI00ed]a lo mismo usar Nueces en su lugar,\npero ha pasado algo raro...\nNo quedan Nueces en toda la ciudad."
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(0, "Parece ser que el alcalde las ha vendido todas.\nNo s[UNI00e9] si podr[UNI00ed]as ayudarme.")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.set_character_motion(arg0, "立ち")
	event.finish_event()
	event.set_quest_request(0, 3, 1)
end

return helper_e21914a3
