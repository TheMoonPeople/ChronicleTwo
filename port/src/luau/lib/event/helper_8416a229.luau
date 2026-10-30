--!strict
-- Shared event helper used by 21 scripts, translated by tools/luau/stb2luau.

local helper_70e4ac93 = require("@lib/event/helper_70e4ac93")

--- Helper function.
local function helper_8416a229(arg0: s32, arg1: any)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(
		0,
		"[UNI00bf]Has hecho alg[UNI00fa]n gran descubrimiento?<page>Mientras t[UNI00fa] descubres\nm[UNI00e1]quinas y chismes,\nyo invento platos.<page>Todos los d[UNI00ed]as investigo para\npreparar comida que nadie haya\nprobado a[UNI00fa]n."
	)
	helper_70e4ac93(arg0, -1, 0, 0)
end

return helper_8416a229
