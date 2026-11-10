--!strict
-- Shared event helper used by 21 scripts, translated by tools/luau/stb2luau.

local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_c8484b43 = require("@lib/event/helper_c8484b43")

--- Helper function.
local function helper_3cccfb27(arg0: s32, arg1: s32)
	event.apply_message_window_preset(0, 0)
	helper_c8484b43(arg0, 0, 0)
	event.open_message_window_2(
		0,
		"Salut, Max.\nExcuse-moi, mais je suis\nun peu pris pour l'instant.<page>Je suis en train de r[UNI00e9]cup[UNI00e9]rer des\nmat[UNI00e9]riaux importants qui aideront [UNI00e0]\npr[UNI00e9]server la s[UNI00e9]curit[UNI00e9] de la ville."
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(0, "Si [UNI00e7]a n'est pas urgent,\n[UNI00e7]a peut attendre jusqu'[UNI00e0] demain ?")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.set_character_motion(arg0, "立ち")
	event.finish_event()
end

return helper_3cccfb27
