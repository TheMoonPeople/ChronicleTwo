--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local open_message = require("@lib/event/open_message")

--- Helper function.
local function helper_25d46bcc()
	event.set_message_window_mode(1, 7)
	event.apply_message_window_preset(1, 2)
	event.open_message_window_2(1, "(O)でストップ")
	open_message(1, -1, 15, 0, 0)
end

return helper_25d46bcc
