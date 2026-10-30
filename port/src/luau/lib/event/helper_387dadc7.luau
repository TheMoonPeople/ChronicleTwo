--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_387dadc7()
	local argc: s32 = 0
	event.assign_memory_stack(4)
	event.clear_memory_stack(4)
	event.load_character(4, "event/opening/p1/p1_starbre.gltf", "info", 9)
	event.set_character_active(9)
	event.set_character_position(9, 17.27, 56.69, 102.98)
	event.set_character_rotation(9, 0.0, 2.2, 0.0)
	event.set_character_motion(9, "座りL", 4)
	argc = event.get_owned_item_count(382) or argc
	if argc >= 1 then
		event.set_function_point_enabled("", "item1", 0)
	end
	argc = event.get_owned_item_count(386) or argc
	if argc >= 1 then
		event.set_function_point_enabled("", "item2", 0)
		event.attach_object_handle_to_map_part_2(0, "memo")
		event.set_object_handle_visible(0, 0)
	end
end

return helper_387dadc7
