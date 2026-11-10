--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_58610e3d()
	event.initialize_event()
	event.set_message_window_mode(0, 0)
	event.set_character_position(0, -600.0, 0.0, -600.0)
	event.set_character_rotation(0, 0.0, -2.23, 0.0)
	event.reset_follow_camera(1, 3.14, 20.0)
	event.fade_in_screen(30)
	event.set_npc_party_status(26, 0)
	event.finish_event()
end

return helper_58610e3d
