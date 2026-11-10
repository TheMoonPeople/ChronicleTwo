--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local set_window_mode = require("@lib/event/set_window_mode")
local show_message = require("@lib/event/show_message")

--- Helper function.
local function helper_f6e6d413()
	event.apply_message_window_preset(1, 4)
	set_window_mode(1, 4)
	event.get_fishing_tournament_info_2(0, 1)
	show_message(1, -1, 8, 0, 0)
end

return helper_f6e6d413
