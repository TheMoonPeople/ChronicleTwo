--!strict
-- Shared event helper used by 18 scripts, translated by tools/luau/stb2luau.

local open_message = require("@lib/event/open_message")
local set_window_mode = require("@lib/event/set_window_mode")

--- Helper function.
local function helper_cf085f53()
	set_window_mode(1, 7)
	event.apply_message_window_preset(1, 2)
	event.open_message_window_2(1, "Se para con el bot[UNI00f3]n (O).")
	open_message(1, -1, 15, 0, 0)
end

return helper_cf085f53
