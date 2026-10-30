--!strict
-- Shared event helper used by 12 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_658b1052()
	event.initialize_event()
	event.set_message_window_mode(0, 1)
	event.set_villager_ai_enabled(1, 24)
	event.set_character_active(1, 0)
	event.set_character_active(1, 24)
	event.reset_follow_camera(1)
	event.fade_in_screen(30)
end

return helper_658b1052
