--!strict
-- Shared event helper used by 645 scripts, translated by tools/luau/stb2luau.

--- Sets a message window's mode.
local function set_window_mode(window: s32, mode: s32)
	event.set_message_window_mode(window, mode)
end

return set_window_mode
