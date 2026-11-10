--!strict
-- Shared event helper used by 10 scripts, translated by tools/luau/stb2luau.

local close_message = require("@lib/event/close_message")

--- Helper function.
local function helper_61258276()
	event.set_character_active(0)
	event.set_message_window_option(1, 4, -1, -1, -1, -1)
	event.set_message_window_option(1, 9, -1, -1)
	close_message(1)
	event.finish_event()
end

return helper_61258276
