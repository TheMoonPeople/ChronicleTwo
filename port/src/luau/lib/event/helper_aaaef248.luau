--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_aaaef248()
	event.initialize_event()
	event.set_character_position(0, -380.0, 104.0, 0.0)
	event.set_character_rotation(0, 0.0, 1.57, 0.0)
	event.set_character_motion(0, "立ち", 4)
	event.update_character_motion(0)
	event.reset_character_cloth_and_hair(0)
	event.set_camera_look_at(-380.0, 134.0, 0.0)
	event.set_camera_position(-260.0, 134.0, 0.0)
	event.fade_in_screen(30)
end

return helper_aaaef248
