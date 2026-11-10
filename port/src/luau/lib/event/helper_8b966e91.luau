--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_5fb66cb1 = require("@lib/event/helper_5fb66cb1")
local helper_75684dd8 = require("@lib/event/helper_75684dd8")
local helper_c292fa16 = require("@lib/event/helper_c292fa16")
local helper_ce85b54c = require("@lib/event/helper_ce85b54c")
local helper_d355d559 = require("@lib/event/helper_d355d559")
local wait_frames = require("@lib/event/wait_frames")

--- Helper function.
local function helper_8b966e91()
	local flag: s32 = 0
	local argc: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local item: s32 = 0
	local var5: s32 = 0
	local world_coord_pos: f32 = 0
	local world_coord_pos_2: f32 = 0
	local world_coord_pos_3: f32 = 0
	local world_coord_rot: f32 = 0
	local var10: s32 = 0
	event.initialize_event()
	helper_ce85b54c()
	event.set_dungeon_pause_flags(1, 1)
	flag = event.get_save_flag(616) or flag
	if flag == 0 then
		event.set_message_window_mode(0, 4)
		event.set_message_bubble_tail(0, 0)
		helper_75684dd8(0, 9, 8, 0, 0)
		event.set_dungeon_pause_flags(1, 0)
		event.finish_event()
		return
	end
	argc = event.get_local_event_flag(4) or argc
	if argc == 0 then
		var2 = event.get_triggered_event_data_2(6) or var2
		if var2 == 1 then
			event.set_message_window_mode(0, 1)
			event.set_message_bubble_tail(0, 0)
			var3 = helper_c292fa16(0, 8, 5, 256, 208, var3)
			event.set_message_window_mode(0, 1)
			event.set_message_bubble_tail(0, 1)
			if var3 == 1 then
				var2 = 2
			end
		end
		if var2 == 2 then
			event.show_dungeon_status_bar(0, 0.16666667)
			wait_frames(6)
			event.open_item_select_menu(0, 362)
			vm.wait(4)
			item = vmhost.used_item() or item
			if item == 362 then
				event.set_local_event_flag(4, 1)
				var5 = event.get_triggered_event_data_2(9) or var5
				event.attach_object_handle_to_map_part_3(0, var5, "star-m0")
				event.set_object_handle_visible(0, 0)
				event.attach_object_handle_to_map_part_3(0, var5, "d05wa13-a")
				event.set_object_handle_visible(0, 0)
				event.set_function_point_enabled(var5, "star", 0)
				world_coord_pos, world_coord_pos_2, world_coord_pos_3, world_coord_rot =
					helper_d355d559(world_coord_pos, world_coord_pos_2, world_coord_pos_3, world_coord_rot)
				event.set_event_world_coordinate(world_coord_pos, world_coord_pos_2, world_coord_pos_3, world_coord_rot)
				event.assign_memory_stack(5)
				event.clear_memory_stack(5)
				event.attach_object_handle_to_character(0, 0)
				event.clear_object_sequence(0)
				event.set_object_sequence_object(0, 0)
				event.turn_object_sequence_toward(0, 0.0, 0.0, 0.0, 0)
				event.load_character(5, "event/dng/key_star.gltf", "star", 12)
				event.set_character_active(12)
				event.attach_object_handle_to_character(1, 12)
				event.set_object_sequence_object(1, 1)
				event.set_object_handle_position(1, 0.0, 0.0, 160.0)
				event.set_object_handle_rotation(1, 0.0, 0.0, 0.0)
				event.set_object_handle_scale(1, 20.0, 20.0, 20.0)
				var10 = event.load_sound_effect_file_3(8, "snd2/sp/sp_014.sound.json") or var10
				event.play_sound_effect(var10, 0)
				event.set_object_sequence_scale(1, 20.0, 0.0, 20.0, 60)
				event.set_camera_sequence_position(-31.46, 57.29, 350.67)
				event.set_camera_sequence_look_at(4.66, 31.72, 192.41)
				event.set_character_visible(12, 0, 1, 0.02)
				wait_frames(60)
				event.delete_character(12)
			elseif item <= 0 then
				event.finish_event()
			else
				helper_5fb66cb1()
			end
		end
		event.show_dungeon_status_bar(1, 0.16666667)
		wait_frames(6)
	end
	event.set_dungeon_pause_flags(1, 0)
	event.finish_event()
end

return helper_8b966e91
