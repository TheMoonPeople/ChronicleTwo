--!strict
-- Shared event helper used by 21 scripts, translated by tools/luau/stb2luau.

local helper_70e4ac93 = require("@lib/event/helper_70e4ac93")

--- Helper function.
local function helper_129a468b(arg0: s32, arg1: any)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(
		0,
		"Lo m[UNI00e1]s importante en los negocios\nes contar con la confianza de los clientes.<page>Es algo que nunca\nse puede descuidar."
	)
	helper_70e4ac93(arg0, -1, 0, 0)
end

return helper_129a468b
