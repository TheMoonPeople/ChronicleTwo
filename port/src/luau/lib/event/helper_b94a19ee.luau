--!strict
-- Shared event helper used by 21 scripts, translated by tools/luau/stb2luau.

local helper_70e4ac93 = require("@lib/event/helper_70e4ac93")

--- Helper function.
local function helper_b94a19ee(arg0: s32, arg1: any)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(
		0,
		"[UNI00c8] fondamentale negli affari\navere la fiducia dei tuoi clienti.<page>Non devi mai darla\nper scontata!"
	)
	helper_70e4ac93(arg0, -1, 0, 0)
end

return helper_b94a19ee
