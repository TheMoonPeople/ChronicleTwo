--!strict
-- Shared event helper used by 18 scripts, translated by tools/luau/stb2luau.

local open_message = require("@lib/event/open_message")
local set_window_mode = require("@lib/event/set_window_mode")

--- Helper function.
local function helper_574a8dfd()
	local language_code: s32 = 0
	set_window_mode(1, 7)
	event.apply_message_window_preset(1, 2)
	language_code = event.get_language() or language_code
	if language_code == 0 then
		event.open_message_window_2(1, "(O)でストップ")
	else
		event.open_message_window_2(1, "It stops with (O) button.")
	end
	open_message(1, -1, 15, 0, 0)
end

return helper_574a8dfd
