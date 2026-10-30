--!strict
-- Shared event helper used by 877 scripts, translated by tools/luau/stb2luau.

--- Builds a message window's text and places it; returns what MesMake returns.
local function open_message(window: any, text: any, position: any, x: any, y: any)
	local var5: s32 = 0
	var5 = event.open_message_window_3(window, text) or var5
	event.set_message_bubble_screen_slot(window, position)
	event.place_message_bubble(window, x, y, x, y)
	return var5
end

return open_message
