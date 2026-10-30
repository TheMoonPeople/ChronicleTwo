--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_6082cadd()
	event.initialize_event()
	event.set_camera_look_at(225.0, 30.0, 280.0)
	event.set_camera_position(225.0, 30.0, 160.0)
	event.set_character_position(0, 225.0, 0.0, 280.0)
	event.set_character_rotation(0, 0.0, -3.14, 0.0)
	event.set_character_motion(0, "立ち", 4)
	event.update_character_motion(0)
	event.reset_character_cloth_and_hair(0)
end

return helper_6082cadd
