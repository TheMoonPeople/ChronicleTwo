--!strict
-- Shared event helper used by 920 scripts, translated by tools/luau/stb2luau.

--- Hides a message window's cursor, closes it and resets its position.
local function close_message(window: any)
	event.set_message_selection(window, -1)
	event.close_message_window(window)
	event.set_message_bubble_screen_slot(window, 0)
end

return close_message
