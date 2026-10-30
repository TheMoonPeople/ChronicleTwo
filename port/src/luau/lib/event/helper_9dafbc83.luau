--!strict
-- Shared event helper used by 216 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_9dafbc83(pos_x: f32, pos_y: f32, pos_z: f32, rot_y: f32)
	event.set_character_position(0, pos_x, pos_y, pos_z)
	event.set_character_rotation(0, 0.0, rot_y, 0.0)
	event.set_character_motion(0, "立ち", 4)
	event.update_character_motion(0)
	event.reset_character_cloth_and_hair(0)
end

return helper_9dafbc83
