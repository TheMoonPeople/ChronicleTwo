--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local close_message = require("@lib/event/close_message")

--- Helper function.
local function helper_d7885d22()
	event.set_character_active(0)
	close_message(1)
	event.finish_event()
end

return helper_d7885d22
