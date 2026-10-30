--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_7f487db5(arg0: s32)
	event.set_function_point_enabled("", "rev_floor", arg0)
	if arg0 == 1 then
		event.assign_memory_stack(4)
		event.clear_memory_stack(4)
		event.load_character(4, "event/d03/p00_26a.gltf", "info", 8)
		event.set_character_active(1, 8)
		event.set_character_position(8, -1594.13, 282.8, -492.73)
		event.set_character_rotation(8, 0.0, 0.89, 0.0)
		event.set_character_motion(8, "立ち", 4)
		event.set_scene_status_flags(1, 8, 8)
	else
		event.delete_character(8)
	end
end

return helper_7f487db5
