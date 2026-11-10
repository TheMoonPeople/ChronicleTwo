--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_238b5abc = require("@lib/event/helper_238b5abc")
local helper_344d6cd8 = require("@lib/event/helper_344d6cd8")
local wait_camera = require("@lib/event/wait_camera")
local wait_frames = require("@lib/event/wait_frames")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_3306dbdc()
	local var0: s32 = 0
	local var2: s32 = 0
	local pos_z: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local pos_y: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local pos_x: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local at: number = 0
	vm.section(function()
		event.set_save_flag(600, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.stop_music(0)
		at = 1
		wait_frames(4)
		event.load_music(115)
		event.load_map_sounds(4525)
		var0 = event.load_sound_effect_file_2(4525) or var0
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.get_playable_character()
		event.set_character_active(0, 0)
		event.change_directory("event/e600/e600/")
		event.load_character(5, "e600_mizusibuki.gltf", "info", 32)
		event.set_character_active(0, 32)
		event.attach_object_handle_to_character(15, 32)
		event.clear_object_sequence(15)
		event.set_object_sequence_object(15, 15)
		event.load_character(5, "e600_nagare.gltf", "info", 33)
		event.set_character_active(0, 33)
		event.attach_object_handle_to_character(16, 33)
		event.clear_object_sequence(16)
		event.set_object_sequence_object(16, 16)
		event.load_character(5, "e600_hikari.gltf", "info", 34)
		event.set_character_active(0, 34)
		event.change_directory("")
		event.attach_object_handle_to_map_part_2(0, "p01_train01")
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.attach_object_handle_to_map_part_2(1, "p15_f0301-1")
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.attach_object_handle_to_map_part_2(2, "p15_f0301")
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.attach_object_handle_to_map_part_2(3, "p22_f0301")
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.attach_object_handle_to_map_part_2(4, "p23_f0301")
		event.clear_object_sequence(4)
		event.set_object_sequence_object(4, 4)
		event.attach_object_handle_to_map_part_2(5, "p24_f0301")
		event.clear_object_sequence(5)
		event.set_object_sequence_object(5, 5)
		event.attach_object_handle_to_map_part_3(6, "p01_train01", "s3601_10-m")
		event.clear_object_sequence(6)
		event.set_object_sequence_object(6, 6)
		event.attach_object_handle_to_map_part_3(7, "p01_train01", "s3601_10-m1")
		event.clear_object_sequence(7)
		event.set_object_sequence_object(7, 7)
		event.attach_object_handle_to_map_part_3(8, "p01_train01", "s3601_10-m2")
		event.clear_object_sequence(8)
		event.set_object_sequence_object(8, 8)
		event.attach_object_handle_to_map_part_3(9, "p01_train01", "s3601_11-m")
		event.clear_object_sequence(9)
		event.set_object_sequence_object(9, 9)
		event.attach_object_handle_to_map_part_3(10, "p01_train01", "s3601_11-m1")
		event.clear_object_sequence(10)
		event.set_object_sequence_object(10, 10)
		event.attach_object_handle_to_map_part_3(11, "p18_f0301", "f030407-m")
		event.clear_object_sequence(11)
		event.set_object_sequence_object(11, 11)
		event.attach_object_handle_to_map_part_3(12, "p19_f0301", "f030408-m")
		event.clear_object_sequence(12)
		event.set_object_sequence_object(12, 12)
		event.attach_object_handle_to_map_part_3(13, "p20_f0301", "f030409-m")
		event.clear_object_sequence(13)
		event.set_object_sequence_object(13, 13)
		event.attach_object_handle_to_map_part_3(14, "p21_f0301", "f030410-m")
		event.clear_object_sequence(14)
		event.set_object_sequence_object(14, 14)
		event.attach_object_handle_to_map_part_2(17, "p25_f0301")
		event.clear_object_sequence(17)
		event.set_object_sequence_object(17, 17)
		event.attach_object_handle_to_map_part_2(18, "p26_f0301")
		event.clear_object_sequence(18)
		event.set_object_sequence_object(18, 18)
		event.attach_object_handle_to_map_part_2(19, "p27_f0301")
		event.clear_object_sequence(19)
		event.set_object_sequence_object(19, 19)
		event.set_object_handle_position(0, 0.0, 70.0, -1860.0)
		event.set_object_handle_rotation(0, 0.0, 3.14, 0.0)
		event.set_object_handle_position(1, 0.0, 0.0, 0.0)
		event.set_object_handle_rotation(1, 0.0, 0.0, 0.0)
		event.set_object_handle_position(2, 0.0, 0.0, 0.0)
		event.set_object_handle_rotation(2, 0.0, 0.0, 0.0)
		event.set_object_handle_position(3, 0.0, -100.0, 0.0)
		event.set_object_handle_rotation(3, 0.0, 0.0, 0.0)
		event.set_object_handle_position(4, 0.0, -400.0, 0.0)
		event.set_object_handle_rotation(4, 0.0, 0.0, 0.0)
		event.set_object_handle_position(5, 0.0, -700.0, 0.0)
		event.set_object_handle_rotation(5, 0.0, 0.0, 0.0)
		event.set_object_handle_rotation(11, 0.0, 2.3561945, 0.0)
		event.set_object_handle_rotation(12, 0.0, -0.7853982, 0.0)
		event.set_object_handle_rotation(13, 0.0, 0.7853982, 0.0)
		event.set_object_handle_rotation(14, 0.0, -2.3561945, 0.0)
		event.set_object_handle_visible(17, 1)
		event.set_object_handle_position(17, 0.0, -100.0, 0.0)
		event.set_object_handle_rotation(17, 0.0, 0.0, 0.0)
		event.set_object_handle_visible(18, 1)
		event.set_object_handle_position(18, 0.0, -400.0, 0.0)
		event.set_object_handle_rotation(18, 0.0, 0.0, 0.0)
		event.set_object_handle_visible(19, 1)
		event.set_object_handle_position(19, 0.0, -700.0, 0.0)
		event.set_object_handle_rotation(19, 0.0, 0.0, 0.0)
		event.set_object_handle_position(15, 0.0, 7.0, -1860.0)
		event.set_object_handle_rotation(15, 0.0, 3.14, 0.0)
		event.set_object_handle_position(16, 0.0, 150.0, -1800.0)
		event.set_object_handle_rotation(16, 0.0, 3.14, 0.0)
		event.set_character_position(34, 2566.79, 5880.98, -32029.89)
		event.rotate_object_sequence_eased(11, -0.4, 2.3561945, 0.0, 120, 0, 1.0)
		event.rotate_object_sequence_eased(12, -0.4, -0.7853982, 0.0, 120, 0, 1.0)
		event.rotate_object_sequence_eased(13, -0.4, 0.7853982, 0.0, 120, 0, 1.0)
		event.rotate_object_sequence_eased(14, -0.4, -2.3561945, 0.0, 120, 0, 1.0)
		event.clear_camera_sequence()
		event.set_camera_sequence_look_at(0.0, 200.0, -1600.0)
		event.set_camera_sequence_angle_height_distance(2.6, 800.0, 3000.0)
		event.move_camera_sequence_angle_height_distance_eased(-2.6, 800.0, 3000.0, 120, 0, 1.0)
		event.fade_in_screen(30)
		at = 2
		wait_frames(14)
		event.play_music(0)
		at = 3
		wait_frames(66)
		event.play_sound_effect(var0, 0)
		event.rotate_object_sequence_eased(1, 0.0, 0.08, 0.0, 160, 0, 1.0)
		event.rotate_object_sequence_eased(2, 0.0, -0.08, 0.0, 160, 0, 1.0)
		at = 4
		wait_camera()
		event.set_camera_sequence_position(213.43, 452.11, -5638.41)
		event.set_camera_sequence_look_at(206.97, 452.67, -5520.54)
		event.move_camera_sequence_eased(269.87, 930.16, -6906.42, 250.2, 895.98, -6763.9, 360, 0, 1.0)
		at = 5
		wait_objects(2)
		event.play_sound_effect(var0, 1)
		event.move_object_sequence_eased(3, 0.0, 0.0, 0.0, 100, 2, 1.0)
		event.delay_object_sequence_sound_track(3, 140.0)
		event.play_object_sequence_sound(3, var0, 3)
		event.move_object_sequence_eased(5, 0.0, 0.0, 0.0, 360, 2, 1.0)
		event.delay_object_sequence_sound_track(5, 520.0)
		event.play_object_sequence_sound(5, var0, 3)
		event.move_object_sequence_eased(17, 0.0, 0.0, 0.0, 100, 2, 1.0)
		event.move_object_sequence_eased(19, 0.0, 0.0, 0.0, 360, 2, 1.0)
		at = 6
		wait_frames(40)
		event.move_object_sequence_eased(4, 0.0, 0.0, 0.0, 200, 2, 1.0)
		event.move_object_sequence_eased(18, 0.0, 0.0, 0.0, 200, 2, 1.0)
		event.delay_object_sequence_sound_track(4, 280.0)
		event.play_object_sequence_sound(4, var0, 3)
		at = 7
		wait_objects(5)
		at = 8
		wait_camera()
		event.set_camera_sequence_position(427.74, 105.92, -3207.97)
		event.set_camera_sequence_look_at(380.62, 117.95, -3117.35)
		event.play_sound_effect(var0, 4)
		event.set_object_sequence_position(3, 0.0, 0.0, 0.0)
		event.set_object_sequence_position(4, 0.0, 0.0, 0.0)
		event.set_object_sequence_position(5, 0.0, 0.0, 0.0)
		event.set_object_handle_visible(17, 0)
		event.set_object_handle_visible(18, 0)
		event.set_object_handle_visible(19, 0)
		at = 9
		wait_frames(30)
		event.play_sound_effect(var0, 5)
		event.move_object_sequence_eased(0, 0.0, 70.0, -2600.0, 120, 1, 1.0)
		event.move_object_sequence_eased(15, 0.0, 70.0, -2600.0, 120, 1, 1.0)
		event.rotate_object_sequence_eased(6, 3.1, 0.0, 0.0, 60, 1, 1.0)
		event.rotate_object_sequence_eased(7, 3.1, 0.0, 0.0, 60, 1, 1.0)
		event.rotate_object_sequence_eased(8, 3.1, 0.0, 0.0, 60, 1, 1.0)
		event.rotate_object_sequence_eased(9, 3.1, 0.0, 0.0, 60, 1, 1.0)
		event.rotate_object_sequence_eased(10, 3.1, 0.0, 0.0, 60, 1, 1.0)
		event.rotate_object_sequence(6, 0.1, 0.0, 0.0, -1)
		event.rotate_object_sequence(7, 0.1, 0.0, 0.0, -1)
		event.rotate_object_sequence(8, 0.1, 0.0, 0.0, -1)
		event.rotate_object_sequence(9, 0.1, 0.0, 0.0, -1)
		event.rotate_object_sequence(10, 0.1, 0.0, 0.0, -1)
		at = 10
		wait_frames(70)
		event.set_character_active(1, 32)
		event.set_character_visible(32, 1, 1, 0.011111111)
		at = 11
		wait_objects(0)
		event.set_camera_sequence_position(493.85, 133.35, -3161.95)
		event.set_camera_sequence_look_at(192.71, 140.7, -3161.9)
		var2 = 0
		pos_z = -2600.0
		var4 = -16.0
		var5 = vm.f32(-0.6)
		while var2 < 60 do
			event.set_object_sequence_position(0, 0.0, 70.0, pos_z)
			event.set_object_sequence_position(15, 0.0, 70.0, pos_z)
			pos_z = vm.f32(pos_z + var4)
			var4 = vm.f32(var4 + var5)
			var2 = var2 + 1
			at = 12
			vm.wait(12)
		end
		at = 13
		wait_objects(0)
		event.set_camera_sequence_position(-1162.38, 1222.12, -7192.96)
		event.set_camera_sequence_look_at(-630.41, 849.9, -6224.85)
		event.set_object_sequence_rotation(0, -0.209, 3.14, 0.0)
		event.set_object_sequence_rotation(15, -0.209, 3.14, 0.0)
		pos_y = 460.0
		var7 = 12.5
		var8 = 0.5
		pos_z = -5500.0
		var4 = -62.5
		var5 = -2.5
		var2 = 0
		while var2 < 20 do
			event.set_object_sequence_position(0, 0.0, pos_y, pos_z)
			event.set_object_sequence_position(15, 0.0, pos_y, pos_z)
			pos_y = vm.f32(pos_y + var7)
			var7 = vm.f32(var7 + var8)
			pos_z = vm.f32(pos_z + var4)
			var4 = vm.f32(var4 + var5)
			var2 = var2 + 1
			at = 14
			vm.wait(14)
		end
		event.set_camera_sequence_position(-563.64, 740.88, -4153.64)
		event.set_camera_sequence_look_at(-529.67, 727.31, -4239.53)
		event.move_camera_sequence_eased(-563.64, 740.88, -4153.64, -539.68, 756.14, -4327.6, 90, 2, 1.0)
		event.rotate_object_sequence_eased(0, -0.209, 2.8, 0.0, 120, 0, 0.4)
		event.set_character_active(0, 32)
		event.set_character_active(1, 33)
		event.set_object_sequence_rotation(16, -0.209, 3.14, 0.0)
		event.rotate_object_sequence_eased(16, -0.209, 2.8, 0.0, 120, 0, 0.4)
		event.set_object_sequence_motion(16, "ループ入り", 6)
		event.queue_object_sequence_next_motion(16, "ループ", 4)
		pos_x = 0.0
		var10 = 0.0
		var11 = vm.f32(0.6)
		pos_y = 655.0
		var7 = 40.0
		var8 = vm.f32(0.33333334)
		pos_z = -6300.0
		var4 = -200.0
		var5 = vm.f32(-1.6666666)
		var2 = 0
		while var2 < 110 do
			if var2 == 30 then
				event.set_character_active(1, 34)
				event.set_character_visible(34, 1, 1, 0.016666668)
			end
			event.set_object_sequence_position(0, pos_x, pos_y, pos_z)
			event.set_object_sequence_position(16, pos_x, pos_y + 80.0, pos_z)
			pos_x = vm.f32(pos_x + var10)
			var10 = vm.f32(var10 + var11)
			pos_y = vm.f32(pos_y + var7)
			var7 = vm.f32(var7 + var8)
			pos_z = vm.f32(pos_z + var4)
			var4 = vm.f32(var4 + var5)
			var2 = var2 + 1
			at = 15
			vm.wait(15)
		end
		event.fade_out_screen(10)
		at = 16
		wait_frames(10)
	end, function(received: { any }): boolean
		if at <= 1 then
			wait_frames_skipping(14)
		end
		if at <= 2 then
			wait_frames_skipping(66)
		end
		if at <= 3 then
			helper_344d6cd8()
		end
		if at <= 4 then
			helper_238b5abc(2)
		end
		if at <= 5 then
			wait_frames_skipping(40)
		end
		if at <= 6 then
			helper_238b5abc(5)
		end
		if at <= 7 then
			helper_344d6cd8()
		end
		if at <= 8 then
			wait_frames_skipping(30)
		end
		if at <= 9 then
			wait_frames_skipping(70)
		end
		if at <= 10 then
			helper_238b5abc(0)
		end
		if at <= 11 then
			var2 = 0
			pos_z = -2600.0
			var4 = -16.0
			var5 = vm.f32(-0.6)
			pos_z = vm.f32(pos_z + var4)
			var4 = vm.f32(var4 + var5)
			local _ = var2 < 60
			var2 = var2 + 1
		end
		if at <= 12 then
			helper_238b5abc(0)
		end
		if at <= 13 then
			pos_y = 460.0
			var7 = 12.5
			var8 = 0.5
			pos_z = -5500.0
			var4 = -62.5
			var5 = -2.5
			var2 = 0
			pos_y = vm.f32(pos_y + var7)
			var7 = vm.f32(var7 + var8)
			pos_z = vm.f32(pos_z + var4)
			var4 = vm.f32(var4 + var5)
			local _ = var2 < 20
			var2 = var2 + 1
		end
		if at <= 14 then
			pos_x = 0.0
			var10 = 0.0
			var11 = vm.f32(0.6)
			pos_y = 655.0
			var7 = 40.0
			var8 = vm.f32(0.33333334)
			pos_z = -6300.0
			var4 = -200.0
			var5 = vm.f32(-1.6666666)
			var2 = 0
			pos_x = vm.f32(pos_x + var10)
			var10 = vm.f32(var10 + var11)
			pos_y = vm.f32(pos_y + var7)
			var7 = vm.f32(var7 + var8)
			pos_z = vm.f32(pos_z + var4)
			var4 = vm.f32(var4 + var5)
			local _ = var2 < 110
			local _ = var2 == 30
			var2 = var2 + 1
		end
		if at <= 15 then
			wait_frames_skipping(10)
		end
		return true
	end)
	event.cancel_drama_scene_skip()
	event.stop_sound_effect(var0, 1)
	event.set_character_active(0)
	event.delete_character(32)
	event.delete_character(33)
	event.delete_character(34)
end

return helper_3306dbdc
