--!strict
-- Shared event helper used by 21 scripts, translated by tools/luau/stb2luau.

local helper_70e4ac93 = require("@lib/event/helper_70e4ac93")

--- Helper function.
local function helper_f526c22d(arg0: s32, arg1: any)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(
		0,
		"Pourquoi la lune me manque-t-elle<page>tant ? Je me demande si je ne\nviendrais pas de l[UNI00e0]-bas des fois..."
	)
	helper_70e4ac93(arg0, -1, 0, 0)
end

return helper_f526c22d
