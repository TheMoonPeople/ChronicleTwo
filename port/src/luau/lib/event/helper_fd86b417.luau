--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_4116e6bb = require("@lib/event/helper_4116e6bb")
local wait_frames = require("@lib/event/wait_frames")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_fd86b417(arg0: s32)
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var5: f32 = 0
	local active_chr_no: s32 = 0
	vm.section(function()
		event.set_character_motion(0, "立ち")
		event.fade_out_screen(15)
		wait_frames(15)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		do
			local out1, out2, out3 = event.get_character_position(arg0)
			var1 = out1 or var1
			var2 = out2 or var2
			var3 = out3 or var3
		end
		do
			local _, out2, _ = event.get_character_rotation(arg0)
			var5 = out2 or var5
		end
		event.set_event_world_coordinate(var1, var2, var3, var5)
		event.show_dungeon_status_bar(0, 1.0)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		active_chr_no = event.get_playable_character() or active_chr_no
		event.set_scene_status_flags(1, 0, 256, 1)
		event.change_directory("event/e400/e436/")
		event.load_message_file(0, 5, "e436_1.txt")
		if active_chr_no == 0 then
			event.load_character_motion_pack(5, "e436_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if active_chr_no == 1 then
			event.load_character_motion_pack(5, "e436_monica.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.change_directory("")
		if active_chr_no == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 16)
			event.load_equipment_model(5, 0, 4, "info", 16)
			event.load_equipment_model(5, 0, 3, "info", 16)
			event.load_equipment_model(5, 0, 2, "info", 16, 17)
			event.load_character_motion_pack(5, "event/e400/e436/e436_mints.gltf", "info", 16)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 16)
			event.attach_object_handle_to_character(0, 16)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 0)
		else
			event.load_character(5, "chara/c02_base.gltf", "info", 16)
			event.load_equipment_model(5, 1, 4, "info", 16)
			event.load_equipment_model(5, 1, 3, "info", 16)
			event.load_equipment_model(5, 1, 2, "info", 16, 17)
			event.load_character_motion_pack(5, "event/e400/e436/e436_monica.gltf", "info", 16)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 16)
			event.attach_object_handle_to_character(1, 16)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 0)
		end
		event.set_character_active(16)
		event.set_character_active(17)
		event.attach_object_handle_to_character(4, 1)
		event.attach_object_handle_to_character(5, 2)
		event.set_object_handle_visible(4, 0)
		event.set_object_handle_visible(5, 0)
		event.set_object_handle_position(0, -8.0, 0.0, 180.0)
		event.set_object_handle_rotation(0, 0.0, 3.14, 0.0)
		event.set_object_handle_motion(0, "上向くL", 4)
		event.step_object_handle_motion(0)
		event.reset_object_handle_dynamic_animation(0)
		event.set_object_handle_footstep_sound(0, 14)
		event.set_object_handle_position(1, 8.0, 0.0, 180.0)
		event.set_object_handle_rotation(1, 0.0, 3.14, 0.0)
		event.set_object_handle_motion(1, "上向くL", 4)
		event.step_object_handle_motion(1)
		event.reset_object_handle_dynamic_animation(1)
		event.set_object_handle_footstep_sound(1, 14)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(0.0, 30.0, 280.0)
		event.set_camera_sequence_look_at(0.0, 30.0, 100.0)
		event.enable_drama_skip()
		event.fade_in_screen(30)
		event.set_object_sequence_motion(1, "上向く会話", 6)
		event.queue_object_sequence_next_motion(1, "上向くL", 4)
		wait_objects(1)
		event.set_object_sequence_motion(1, "がっくり", 6)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.delay_object_sequence_motion_track(0, 10)
		event.set_object_sequence_motion(0, "上向く戻り", 6)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		helper_4116e6bb(4360030)
		wait_objects(1)
		event.set_object_sequence_motion(1, "左向く", 6)
		event.queue_object_sequence_next_motion(1, "左向くL", 4)
		event.delay_object_sequence_motion_track(0, 10)
		event.set_object_sequence_motion(0, "右向く", 6)
		event.queue_object_sequence_next_motion(0, "右向くL", 4)
		helper_4116e6bb(4360035)
		event.fade_out_screen(30)
		wait_frames(30)
	end)
	event.cancel_drama_scene_skip()
	event.clear_camera_sequence()
	event.set_character_active(0)
	event.set_scene_status_flags(1, 0, 256, 0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.delete_character_extension_packs(0)
	event.delete_character(16)
	event.delete_character(17)
	event.load_message_file(0, -1)
	if active_chr_no == 0 then
		event.set_object_sequence_position(0, 0.0, 0.0, 180.0)
	else
		event.set_object_sequence_position(1, 0.0, 0.0, 180.0)
	end
	event.set_camera_sequence_position(0.0, 30.0, 280.0)
	event.set_camera_sequence_look_at(0.0, 30.0, 180.0)
	vm.wait(7)
	event.fade_in_screen(30)
	event.finish_event()
end

return helper_fd86b417
