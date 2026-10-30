--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_56b874f1()
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local flag_4: s32 = 0
	local now_party_chara_id: s32 = 0
	flag = event.get_save_flag(304) or flag
	flag_2 = event.get_save_flag(306) or flag_2
	flag_3 = event.get_save_flag(324) or flag_3
	flag_4 = event.get_save_flag(330) or flag_4
	event.set_function_point_enabled("", "syumai", 0)
	event.set_function_point_enabled("", "event_550", 0)
	event.assign_memory_stack(4)
	event.clear_memory_stack(4)
	if flag_4 == 1 then
		event.load_character(4, "chara/p00_25a.gltf", "info", 24)
		event.set_character_active(24)
		event.set_character_position(24, -16.0, 22.0, -139.0)
		event.set_character_rotation(24, 0.0, 0.0, 0.0)
		event.set_character_motion(24, "立ち", 4)
		event.set_scene_character_number(24, 250)
		event.register_villager_in_place(24, 250, 4)
	else
		if flag_3 == 1 and flag_4 == 0 then
			event.set_function_point_enabled("", "syumai", 1)
			event.load_character(4, "chara/p00_25a.gltf", "info", 24)
			event.set_scene_character_number(24, 250)
			event.change_directory("event/e300/e330/")
			event.load_character(4, "e330_lin.gltf", "info", 25)
			event.load_character(4, "e330_bed.gltf", "info", 26)
			event.change_directory("")
		else
			now_party_chara_id = event.get_party_npc() or now_party_chara_id
			if flag == 1 and flag_2 == 0 and now_party_chara_id == 6 then
			else
				event.load_character(4, "chara/p00_25a.gltf", "info", 24)
				event.set_scene_character_number(24, 250)
				event.change_directory("event/e300/e304/")
				event.load_character(4, "e304_lin.gltf", "info", 25)
				event.load_character(4, "e304_bed.gltf", "info", 26)
				event.change_directory("")
				event.set_function_point_enabled("", "event_550", 1)
			end
		end
		event.set_character_active(24)
		event.set_character_position(24, -16.0, 22.0, -139.0)
		event.set_character_rotation(24, 0.0, 0.0, 0.0)
		event.set_character_motion(24, "立ち", 4)
		event.register_villager_in_place(24, 250, 4)
		event.set_villager_ai_enabled(1, 24)
		event.set_character_active(25)
		event.set_character_position(25, 35.0, 16.0, -125.0)
		event.set_character_rotation(25, -1.57, 1.57, 0.0)
		event.set_character_motion(25, "寝てる", 4)
		event.attach_object_handle_to_character(0, 25)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "苦しい顔")
		event.set_character_active(26)
		event.set_character_position(26, 28.0, 0.0, -125.0)
		event.set_character_rotation(26, 0.0, 0.0, 0.0)
		event.set_character_motion(26, "寝てる", 4)
		event.attach_object_handle_to_map_part_3(0, "p01_g02i02", "g02i02_02-m0")
		event.set_object_handle_visible(0, 0)
	end
end

return helper_56b874f1
