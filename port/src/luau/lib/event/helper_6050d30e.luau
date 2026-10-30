--!strict
-- Shared event helper used by 10 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_6050d30e(arg0: s32)
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local flag_4: s32 = 0
	event.initialize_event()
	event.get_save_counter(3)
	event.assign_memory_stack(4)
	event.clear_memory_stack(4)
	if arg0 ~= 0 then
		event.load_character(4, "event/e200/e220/e220_noam.gltf", "info", 9)
		event.set_scene_character_number(9, 153)
		event.set_character_active(9)
		event.set_character_position(9, 2199.07, 29.83, 981.55)
		event.set_character_rotation(9, 0.0, 2.68, 0.0)
		event.set_character_motion(9, "釣り")
		flag = event.get_save_flag(28) or flag
		if flag == 0 then
			event.attach_object_handle_to_character(0, 9)
			event.set_object_handle_frame_draw_flag(0, "wine", 0)
		end
		event.change_directory("event/e200/e215/")
		event.load_character(4, "e215_wicky.gltf", "info", 11)
		event.set_scene_character_number(11, 152)
		event.set_character_active(11)
		event.set_character_position(11, 2022.78, 0.01, 1090.61)
		event.set_character_rotation(11, 0.0, 0.0, 0.0)
		event.set_character_motion(11, "寝そべってる")
		event.load_character(4, "e215_mogri.gltf", "info", 12)
		event.set_scene_character_number(12, 150)
		event.set_character_active(12)
		event.set_character_position(12, 1895.53, -3.91, 1206.14)
		event.set_character_rotation(12, 0.0, 0.0, 0.0)
		event.set_character_motion(12, "座り")
		event.change_directory("")
		event.load_character(4, "event/nanahige/p02_07a.gltf", "info", 10)
		event.set_scene_character_number(10, 155)
		event.set_character_active(10)
		event.set_character_position(10, 1824.39, 0.01, 1158.94)
		event.set_character_rotation(10, 0.0, 0.04, 0.0)
		event.set_character_motion(10, "立ち")
		event.set_character_near_fade_distance(10, 15.0)
		event.load_character(4, "event/e200/e230/e230_dokuring.gltf", "info", 13)
		event.set_character_active(0, 13)
		event.set_character_position(13, -1892.15, 3.14, 941.97)
		event.set_character_rotation(13, 3.1415927, 0.0, 0.0)
		event.set_character_scale(13, 2.0, 2.0, 2.0)
		event.copy_character(4, 13, 15)
		event.set_character_active(0, 15)
		event.set_character_position(15, -1883.07, 3.14, 938.36)
		event.set_character_rotation(15, 3.1415927, 0.0, 0.0)
		event.set_character_scale(15, 2.0, 2.0, 2.0)
		event.copy_character(4, 13, 16)
		event.set_character_active(0, 16)
		event.set_character_position(16, -1885.02, 3.14, 931.43)
		event.set_character_rotation(16, 3.1415927, 0.0, 0.0)
		event.set_character_scale(16, 2.0, 2.0, 2.0)
		event.copy_character(4, 13, 17)
		event.set_character_active(0, 17)
		event.set_character_position(17, -1896.36, 3.14, 935.12)
		event.set_character_rotation(17, 3.1415927, 0.0, 0.0)
		event.set_character_scale(17, 2.0, 2.0, 2.0)
	end
	event.load_character(4, "event/e200/e230/e230_utan.gltf", "info", 8)
	event.set_character_active(1, 8)
	flag_2 = event.get_save_flag(253) or flag_2
	if flag_2 == 0 then
		event.set_character_position(8, -1938.91, 0.4, 1036.52)
		event.set_character_rotation(8, 0.0, 2.44, 0.0)
		event.set_function_point_enabled("p01_s0501", "invent_2005-0", 1)
		event.set_function_point_enabled("p01_s0501", "invent_2005-1", 0)
		event.set_function_point_enabled("p01_s0501", "kaiwa01-0", 1)
		event.set_function_point_enabled("p01_s0501", "kaiwa03-0", 0)
		event.attach_object_handle_to_map_part_3(0, "p09_s0501", "s050119-c")
		event.set_object_handle_visible(0, 1)
		event.attach_object_handle_to_map_part_3(0, "p09_s0501", "s050120-c")
		event.set_object_handle_visible(0, 0)
	else
		event.set_character_position(8, -2202.71, 0.4, 759.61)
		event.set_character_rotation(8, 0.0, 2.16, 0.0)
		event.set_function_point_enabled("p01_s0501", "invent_2005-0", 0)
		event.set_function_point_enabled("p01_s0501", "invent_2005-1", 1)
		event.set_function_point_enabled("p01_s0501", "kaiwa01-0", 0)
		event.set_function_point_enabled("p01_s0501", "kaiwa03-0", 1)
		event.attach_object_handle_to_map_part_3(0, "p09_s0501", "s050119-c")
		event.set_object_handle_visible(0, 0)
		event.attach_object_handle_to_map_part_3(0, "p09_s0501", "s050120-c")
		event.set_object_handle_visible(0, 1)
	end
	flag_3 = event.get_save_flag(240) or flag_3
	flag_4 = event.get_save_flag(245) or flag_4
	event.attach_object_handle_to_map_part_2(0, "p08_s0501")
	if flag_3 ~= 0 and flag_4 == 0 then
		event.load_character(4, "chara/b04a.gltf", "b04a", 14)
		event.set_character_active(1, 14)
		event.set_character_position(14, -127.39, 0.0, -701.37)
		event.set_character_rotation(14, 0.0, -1.68, 0.0)
		event.set_scene_status_flags(1, 14, 256, 0)
		event.set_character_draw_distance(14, 2400.0)
		event.set_function_point_enabled("p01_s0501", "invent_2008-0", 1)
		event.set_function_point_enabled("p01_s0501", "kaiwa02-0", 1)
		event.set_object_handle_visible(0, 1)
	else
		event.set_function_point_enabled("p01_s0501", "invent_2008-0", 0)
		event.set_function_point_enabled("p01_s0501", "kaiwa02-0", 0)
		event.set_object_handle_visible(0, 0)
	end
end

return helper_6050d30e
