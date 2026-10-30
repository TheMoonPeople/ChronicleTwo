--!strict
-- Shared event helper used by 21 scripts, translated by tools/luau/stb2luau.

local helper_70e4ac93 = require("@lib/event/helper_70e4ac93")

--- Helper function.
local function helper_78597c8d(arg0: s32, arg1: any)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(
		0,
		"Na, was Gutes entdeckt?<page>W[UNI00e4]hrend du Maschinen und Ger[UNI00e4]te\nerfindest, erfinde ich\nneue Kochrezepte.<page>Ich versuche st[UNI00e4]ndig, Delikatessen\nzu schaffen, die noch\nnie jemand gegessen hat."
	)
	helper_70e4ac93(arg0, -1, 0, 0)
end

return helper_78597c8d
