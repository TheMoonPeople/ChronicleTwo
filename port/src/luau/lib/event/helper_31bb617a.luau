--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_31bb617a()
	local flag: s32 = 0
	local var1: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local flag_4: s32 = 0
	local flag_5: s32 = 0
	flag = event.get_save_flag(500) or flag
	if flag ~= 0 then
		var1 = event.get_quest_request_status(0, 5) or var1
		if var1 ~= 2 then
			event.assign_memory_stack(4)
			event.clear_memory_stack(4)
			event.load_character(4, "event/e400/e438/e438_paw.gltf", "info", 8)
			event.set_character_active(1, 8)
			event.set_character_position(8, -37.0, 0.0, 111.25)
			event.set_character_rotation(8, 0.0, -0.97, 0.0)
			event.set_character_motion(8, "立ち", 4)
			event.set_scene_character_number(8, 9)
		end
		event.set_function_point_enabled("", "event_400", 0)
		event.attach_object_handle_to_map_part_3(0, "p01_s2701", "s2701_03-a0")
		event.set_object_handle_visible(0, 0)
		event.attach_object_handle_to_map_part_3(0, "p01_s2701", "s2701_02-c0")
		event.set_object_handle_visible(0, 0)
		return
	end
	flag_2 = event.get_save_flag(408) or flag_2
	flag_3 = event.get_save_flag(420) or flag_3
	flag_4 = event.get_save_flag(438) or flag_4
	flag_5 = event.get_save_flag(444) or flag_5
	event.set_function_point_enabled("", "event_400", 0)
	event.attach_object_handle_to_map_part_3(0, "p01_s2701", "s2701_03-a0")
	event.set_object_handle_visible(0, 0)
	event.attach_object_handle_to_map_part_3(0, "p01_s2701", "s2701_02-c0")
	event.set_object_handle_visible(0, 0)
	if flag_2 == 1 then
		event.assign_memory_stack(4)
		event.clear_memory_stack(4)
		event.load_character(4, "event/e400/e438/e438_paw.gltf", "info", 8)
		event.set_character_active(1, 8)
		event.set_character_position(8, -37.0, 0.0, 111.25)
		event.set_character_rotation(8, 0.0, -0.97, 0.0)
		event.set_character_motion(8, "立ち", 4)
		event.set_scene_character_number(8, 9)
		if flag_3 == 1 and flag_5 == 0 then
			event.load_character(4, "event/e400/e438/e438_shigu.gltf", "info", 9)
			event.set_character_active(1, 9)
			event.set_character_position(9, -86.0, 0.0, 34.0)
			event.set_character_rotation(9, 0.0, 2.52, 0.0)
			event.set_character_motion(9, "座り", 4)
			event.set_character_texture_animation(9, 0)
			if flag_4 == 0 then
				event.set_character_texture_animation(9, 1, "目とじ")
			else
				event.attach_object_handle_to_character(0, 9)
				event.set_object_handle_frame_visible(0, "grid1", 0)
				event.set_character_texture_animation(9, 1, "通常目パチ")
			end
			event.attach_object_handle_to_map_part_3(0, "p01_s2701", "s2701_03-a0")
			event.set_object_handle_position(0, -86.0, 0.0, 34.0)
			event.set_object_handle_rotation(0, 0.0, 2.52, 0.0)
			event.set_object_handle_visible(0, 1)
			event.attach_object_handle_to_map_part_3(0, "p01_s2701", "s2701_02-c0")
			event.set_object_handle_position(0, -86.0, 0.0, 34.0)
			event.set_object_handle_rotation(0, 0.0, 2.52, 0.0)
			event.set_object_handle_visible(0, 1)
			event.set_function_point_enabled("", "event_400", 1)
		end
	end
end

return helper_31bb617a
