--!strict
-- Shared event helper used by 21 scripts, translated by tools/luau/stb2luau.

local helper_70e4ac93 = require("@lib/event/helper_70e4ac93")

--- Helper function.
local function helper_d3953a20(arg0: s32, arg1: any)
	local var2: s32 = 0
	event.apply_message_window_preset(0, 0)
	var2 = event.get_chapter() or var2
	if var2 ~= 8 then
		event.open_message_window_2(
			0,
			"Um, [UNI00e7]a peut attendre bien s[UNI00fb]r,\nmais un jour, j'aimerais que tu\nm'expliques ta technique de p[UNI00ea]che."
		)
	else
		event.open_message_window_2(
			0,
			"J'ai h[UNI00e2]te de d[UNI00e9]couvrir les nouveaux\nhauts-lieux de la p[UNI00ea]che qu'a [UNI00e0]\noffrir le monde. [UNI00c7]a sera trop top."
		)
	end
	helper_70e4ac93(arg0, -1, 0, 0)
end

return helper_d3953a20
