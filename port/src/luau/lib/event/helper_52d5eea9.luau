--!strict
-- Shared event helper used by 21 scripts, translated by tools/luau/stb2luau.

local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_c8484b43 = require("@lib/event/helper_c8484b43")

--- Helper function.
local function helper_52d5eea9(arg0: s32, arg1: s32)
	local var2: s32 = 0
	event.apply_message_window_preset(0, 0)
	helper_c8484b43(arg0, 0, 0)
	var2 = event.get_chapter() or var2
	if var2 ~= 8 then
		event.open_message_window_2(
			0,
			"L'[UNI00e9]clat d'une [UNI00e9]p[UNI00e9]e forg[UNI00e9]e\npar un ma[UNI00ee]tre est magnifique.<page>[UNI00c0] couper le souffle."
		)
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.open_message_window_2(
			0,
			"Je n'arrive pas [UNI00e0] comprendre\ncomment on peut [UNI00ea]tre heureux [UNI00e0]\npolir des cailloux."
		)
	else
		event.open_message_window_2(0, "Alors, t'as un scoop ? T'as\nvu des gros durs dans cette mine ?")
	end
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.set_character_motion(arg0, "立ち")
	event.finish_event()
end

return helper_52d5eea9
