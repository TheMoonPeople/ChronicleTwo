--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1584c528 = require("@lib/event/helper_1584c528")
local helper_238b5abc = require("@lib/event/helper_238b5abc")
local helper_344d6cd8 = require("@lib/event/helper_344d6cd8")
local helper_52aadc70 = require("@lib/event/helper_52aadc70")
local helper_f7fba8ce = require("@lib/event/helper_f7fba8ce")
local helper_fbf84a80 = require("@lib/event/helper_fbf84a80")
local wait_camera = require("@lib/event/wait_camera")
local wait_frames = require("@lib/event/wait_frames")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_36bdf460()
	local var0: s32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: s32 = 0
	local var6: f32 = 0
	local rot_y: f32 = 0
	local var8: f32 = 0
	local vector_x: f32 = 0
	local vector_y: f32 = 0
	local vector_z: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local at: number = 0
	vm.section(function()
		at = 1
		vm.entry(1)
		event.set_save_flag(406, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.switch_dungeon_main_character(0)
		event.set_playable_character(0)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.stop_music(0)
		var0 = event.load_sound_effect_file_3(8, "snd2/sp/sp_033.sound.json") or var0
		do
			local out1, out2, out3, out4 = event.get_dungeon_event_point(2)
			var1 = out1 or var1
			var2 = out2 or var2
			var3 = out3 or var3
			var4 = out4 or var4
		end
		event.set_event_world_coordinate(var1, var2, var3, var4)
		event.change_directory("event/e400/e406/")
		event.load_message_file(0, 5, "e406_1.txt")
		event.change_directory("")
		event.set_character_active(0)
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		var5 = event.get_triggered_event_data_2(9) or var5
		if helper_f7fba8ce(var4, 0.0, 1.0) == 0 or helper_f7fba8ce(var4, vm.f32(3.14), 1.0) == 0 then
			event.attach_object_handle_to_map_part_3(2, var5, "d04w10_2-m")
			event.clear_object_sequence(2)
			event.set_object_sequence_object(2, 2)
			event.attach_object_handle_to_map_part_3(3, var5, "d04w10_4-m")
			event.clear_object_sequence(3)
			event.set_object_sequence_object(3, 3)
		else
			event.attach_object_handle_to_map_part_3(2, var5, "d04w10_5-m")
			event.clear_object_sequence(2)
			event.set_object_sequence_object(2, 2)
			event.attach_object_handle_to_map_part_3(3, var5, "d04w10_6-m")
			event.clear_object_sequence(3)
			event.set_object_sequence_object(3, 3)
		end
		event.attach_object_handle_to_map_part_3(1, var5, "d04w10_3-m")
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_object_handle_position(0, 0.0, 0.0, -145.0)
		event.set_object_handle_rotation(0, 0.0, 0.0, 0.0)
		event.set_object_handle_motion(0, "立ち", 4)
		event.set_object_handle_footstep_sound(0, 18)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "無表情")
		event.set_object_handle_texture_animation(0, 1, "通常目パチ")
		event.set_sound_reverb_enabled(0)
		event.enable_drama_skip()
		event.show_dungeon_status_bar(0, 1.0)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(51.16, 17.85, 158.67)
		event.set_camera_sequence_look_at(-12.94, 64.29, -60.21)
		event.fade_in_screen(30)
		event.play_sound_effect(var0, 1)
		do
			local out1, out2, out3 = event.get_object_handle_rotation(2)
			var6 = out1 or var6
			rot_y = out2 or rot_y
			var8 = out3 or var8
		end
		do
			local out1, out2, out3 = event.copy_vector(var6, rot_y, var8)
			vector_x = out1 or vector_x
			vector_y = out2 or vector_y
			vector_z = out3 or vector_z
		end
		do
			local out1, out2, out3 = event.get_object_handle_position(1)
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		if helper_f7fba8ce(var4, 0.0, 0.5) == 0 then
			var8 = vm.f32(vector_z + vm.f32(3.1415927))
			var8 = event.wrap_angle(var8) or var8
		end
		if helper_f7fba8ce(var4, vm.f32(3.14), 0.5) == 0 then
			var8 = vm.f32(vector_z - vm.f32(3.1415927))
			var8 = event.wrap_angle(var8) or var8
		end
		if helper_f7fba8ce(var4, vm.f32(1.57), 0.5) == 0 then
			var6 = vm.f32(vector_x + vm.f32(3.1415927))
			var6 = event.wrap_angle(var6) or var6
		end
		if helper_f7fba8ce(var4, vm.f32(-1.57), 0.5) == 0 then
			var6 = vm.f32(vector_x - vm.f32(3.1415927))
			var6 = event.wrap_angle(var6) or var6
		end
		event.rotate_object_sequence_eased(2, var6, rot_y, var8, 40, 0, 0.5)
		event.rotate_object_sequence_eased(3, var6, rot_y, var8, 40, 0, 0.5)
		at = 2
		wait_objects(2)
		event.move_object_sequence_eased(1, pos_x, pos_y + 80.0, pos_z, 32, 1, 0.5)
		at = 3
		wait_frames(20)
		event.set_object_sequence_motion(0, "走り")
		event.delay_object_sequence_motion_track(0, 30)
		event.set_object_sequence_motion(0, "立ち")
		event.move_object_sequence(0, 0.0, 0.0, 0.0, 30)
		at = 4
		wait_objects(1)
		event.move_object_sequence_eased(1, pos_x, pos_y, pos_z, 32, 0, 0.5)
		at = 5
		wait_objects(0)
		event.delay_object_sequence_motion_track(0, 30)
		event.set_object_sequence_motion(0, "歩き")
		event.delay_object_sequence_motion_track(0, 60)
		event.set_object_sequence_motion(0, "立ち")
		event.delay_object_sequence_position_track(0, 30)
		event.move_object_sequence(0, 0.0, 0.0, 60.0, 60)
		event.delay_camera_sequence_angle_track(30)
		event.set_camera_sequence_follow_object(0, 0.0, 22.0, 0.0, 0.37, 0.0, 33.0)
		event.move_camera_sequence_angle_height_distance_eased(3.14, 0.0, 33.0, 200, 0, 1.0)
		at = 6
		wait_objects(1)
		event.rotate_object_sequence_eased(2, vector_x, vector_y, vector_z, 40, 0, 0.5)
		event.rotate_object_sequence_eased(3, vector_x, vector_y, vector_z, 40, 0, 0.5)
		at = 7
		helper_1584c528(4060010, 400)
		at = 8
		wait_camera()
		event.release_camera_sequence_follow_object()
		event.move_camera_sequence_eased(0.06, 29.36, 27.0, 0.0, 51.38, 60.0, 60, 1, 1.0)
		at = 9
		wait_frames(60)
		event.fade_out_screen(30)
		at = 10
		wait_frames(30)
	end, function(received: { any }): boolean
		if at <= 1 then
			local _ = helper_fbf84a80(var4, 0.0, 1.0) == 0
			local _ = helper_fbf84a80(var4, vm.f32(3.14), 1.0) == 0
			local _ = helper_fbf84a80(var4, 0.0, 0.5) == 0
			var8 = vm.f32(vector_z + vm.f32(3.1415927))
			local _ = helper_fbf84a80(var4, vm.f32(3.14), 0.5) == 0
			var8 = vm.f32(vector_z - vm.f32(3.1415927))
			local _ = helper_fbf84a80(var4, vm.f32(1.57), 0.5) == 0
			var6 = vm.f32(vector_x + vm.f32(3.1415927))
			local _ = helper_fbf84a80(var4, vm.f32(-1.57), 0.5) == 0
			var6 = vm.f32(vector_x - vm.f32(3.1415927))
			helper_238b5abc(2)
		end
		if at <= 2 then
			wait_frames_skipping(20)
		end
		if at <= 3 then
			helper_238b5abc(1)
		end
		if at <= 4 then
			helper_238b5abc(0)
		end
		if at <= 5 then
			helper_238b5abc(1)
		end
		if at <= 6 then
			helper_52aadc70(4060010, 400)
		end
		if at <= 7 then
			helper_344d6cd8()
		end
		if at <= 8 then
			wait_frames_skipping(60)
		end
		if at <= 9 then
			wait_frames_skipping(30)
		end
		return true
	end)
	at = 11
	vm.entry(11)
	event.cancel_drama_scene_skip()
	event.stop_sound_effect(var0, 1)
	event.set_sound_reverb_enabled(1)
	event.load_message_file(0, -1)
	event.finish_event()
end

return helper_36bdf460
