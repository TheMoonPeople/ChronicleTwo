--!strict
-- map/i/i01/h01/i01h01c_1.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_05970f25 = require("@lib/event/helper_05970f25")
local helper_0999bd0f = require("@lib/event/helper_0999bd0f")
local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_17069978 = require("@lib/event/helper_17069978")
local helper_1c04a0eb = require("@lib/event/helper_1c04a0eb")
local helper_1de6c61f = require("@lib/event/helper_1de6c61f")
local helper_1ef0d4b2 = require("@lib/event/helper_1ef0d4b2")
local helper_2ecccad3 = require("@lib/event/helper_2ecccad3")
local helper_2ff63eb4 = require("@lib/event/helper_2ff63eb4")
local helper_344d6cd8 = require("@lib/event/helper_344d6cd8")
local helper_3adb7568 = require("@lib/event/helper_3adb7568")
local helper_4116e6bb = require("@lib/event/helper_4116e6bb")
local helper_467e9642 = require("@lib/event/helper_467e9642")
local helper_4e93f9fc = require("@lib/event/helper_4e93f9fc")
local helper_658b1052 = require("@lib/event/helper_658b1052")
local helper_75684dd8 = require("@lib/event/helper_75684dd8")
local helper_788a73ff = require("@lib/event/helper_788a73ff")
local helper_7d54f41c = require("@lib/event/helper_7d54f41c")
local helper_7e7c045c = require("@lib/event/helper_7e7c045c")
local helper_822b22f8 = require("@lib/event/helper_822b22f8")
local helper_86e93423 = require("@lib/event/helper_86e93423")
local helper_8cd371d7 = require("@lib/event/helper_8cd371d7")
local helper_a0fc6040 = require("@lib/event/helper_a0fc6040")
local helper_a374ffdb = require("@lib/event/helper_a374ffdb")
local helper_b5a4da39 = require("@lib/event/helper_b5a4da39")
local helper_ce6820bc = require("@lib/event/helper_ce6820bc")
local helper_d529ed92 = require("@lib/event/helper_d529ed92")
local helper_e52544df = require("@lib/event/helper_e52544df")
local helper_e6cfe9e4 = require("@lib/event/helper_e6cfe9e4")
local helper_eb4a6c55 = require("@lib/event/helper_eb4a6c55")
local set_window_mode = require("@lib/event/set_window_mode")
local wait_camera = require("@lib/event/wait_camera")
local wait_frames = require("@lib/event/wait_frames")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_dc14(se_id: s32)
	local var1: any = 0
	local at: number = 0
	return vm.guard(function()
		event.mark_camera_sequence_fade_track()
		event.fade_out_camera_sequence(30, 0.0, 0.0, 0.0)
		at = 1
		wait_camera()
		event.set_camera_sequence_position(-26.93, 26.72, -145.82)
		event.set_camera_sequence_look_at(27.6, 22.54, -159.02)
		event.set_object_sequence_position(0, 16.25, -0.02, -166.37)
		event.set_object_sequence_rotation(0, 0.0, 1.16, 0.0)
		event.set_object_sequence_motion(0, "上見立ち", 4)
		event.set_object_sequence_position(2, 38.77, -0.02, -147.68)
		event.set_object_sequence_rotation(2, 0.0, -2.04, 0.0)
		event.set_object_sequence_motion(2, "立ち", 4)
		at = 2
		wait_frames(30)
		event.fade_in_camera_sequence(30, 0.0, 0.0, 0.0)
		at = 3
		wait_camera()
		event.set_object_sequence_motion(2, "会話", 6)
		event.queue_object_sequence_next_motion(2, "立ち")
		at = 4
		wait_frames(10)
		event.set_mouth_texture_animations(2, "大口パク")
		at = 5
		helper_4116e6bb(1060010)
		event.reset_mouth_texture_animations()
		event.set_message_window_mode(0, 1)
		event.set_message_bubble_tail(0, 0)
		event.open_message_window_2(0, "OK!!\nHold on a second.")
		at = 6
		var1 = helper_7e7c045c(0, -1, 8, 0, 0, 2, 0)
		event.set_message_window_mode(0, 7)
		event.set_message_bubble_tail(0, 1)
		if var1 == 0 then
			at = 7
			helper_4116e6bb(1060040)
			event.play_sound_effect(se_id, 2)
			event.set_object_sequence_motion(0, "ガッツポーズ", 6, -1.0, 1)
			event.queue_object_sequence_next_motion(0, "上見立ち", 4)
			event.set_object_sequence_motion(2, "ガッツポーズ", 6)
			event.queue_object_sequence_next_motion(2, "立ち", 0)
			event.set_mouth_texture_animations(2, "大口パク")
			at = 8
			helper_4116e6bb(1060050)
			event.reset_mouth_texture_animations()
			event.fade_out_music(30)
			event.fade_out_screen(30)
			at = 9
			wait_frames(30)
			return 1
		else
			event.set_object_sequence_motion(0, "上見会話", 6, -1.0, 1)
			event.queue_object_sequence_next_motion(0, "上見立ち", 4)
			at = 10
			wait_frames(9)
			at = 11
			helper_4116e6bb(1060020)
			event.set_object_sequence_motion(2, "会話2", 6)
			at = 12
			wait_frames(9)
			event.set_mouth_texture_animations(2, "大口パク")
			at = 13
			helper_4116e6bb(1060030)
			event.reset_mouth_texture_animations()
			return 0
		end
	end, function(received: { any })
		if at <= 9 then
			if at == 6 then
				var1 = received[1] :: number
			end
			if at <= 1 then
				wait_frames_skipping(30)
			end
			if at <= 2 then
				helper_344d6cd8()
			end
			if at <= 3 then
				wait_frames_skipping(10)
			end
			if at <= 4 then
				helper_8cd371d7(1060010)
			end
			if at <= 5 then
				var1 = helper_7d54f41c(0, -1, 8, 0, 0, 2, 0)
			end
			if at <= 6 then
				helper_8cd371d7(1060040)
			end
			if at <= 7 then
				helper_8cd371d7(1060050)
			end
			if at <= 8 then
				wait_frames_skipping(30)
			end
			return 1
		end
		if at <= 13 then
			if at <= 10 then
				helper_8cd371d7(1060020)
			end
			if at <= 11 then
				wait_frames_skipping(9)
			end
			if at <= 12 then
				helper_8cd371d7(1060030)
			end
			return 0
		end
		return nil
	end)
end

--- Helper function.
local function helper_10ba0()
	local var0: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	local projection: f32 = 0
	local at: number = 0
	return vm.guard(function()
		vm.section(function()
			at = 1
			vm.entry(1)
			event.set_save_flag(106, 1)
			event.initialize_event()
			event.set_message_window_mode(0, 7)
			var2 = event.load_sound_effect_file_2(1231) or var2
			event.assign_memory_stack(5)
			event.clear_memory_stack(5)
			do
				local out1, out2, out3 = event.get_camera_position()
				pos_x = out1 or pos_x
				pos_y = out2 or pos_y
				pos_z = out3 or pos_z
			end
			do
				local out1, out2, out3 = event.get_camera_look_at()
				pos_x_2 = out1 or pos_x_2
				pos_y_2 = out2 or pos_y_2
				pos_z_2 = out3 or pos_z_2
			end
			event.load_character_motion_pack(5, "event/e100/e106/e106_mints.gltf", "info", 0)
			event.set_character_active(1, 0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
			event.load_character(5, "event/e100/e106/e106_starbre.gltf", "info", 34)
			event.attach_object_handle_to_character(2, 34)
			event.clear_object_sequence(2)
			event.set_object_sequence_object(2, 2)
			event.set_character_active(1, 34)
			event.load_character(5, "event/e100/e106/e106_steve.gltf", "info", 35)
			event.set_character_active(1, 35)
			event.attach_object_handle_to_character(3, 35)
			event.clear_object_sequence(3)
			event.set_object_sequence_object(3, 3)
			event.set_object_handle_sound_bank(3, var2)
			event.attach_object_handle_to_map_part_3(10, "p04_i01h01", "i01h01_05-m1")
			event.attach_object_handle_to_map_part_3(11, "p04_i01h01", "i01h01_05-m3")
			event.attach_object_handle_to_map_part_3(12, "p01_i01h01", "i01h01_21-m0")
			event.clear_object_sequence(12)
			event.set_object_sequence_object(12, 12)
			event.attach_object_handle_to_map_part_3(13, "p01_i01h01", "i01h01_21-m1")
			event.clear_object_sequence(13)
			event.set_object_sequence_object(13, 13)
			event.load_message_file(0, 5, "event/e100/e106/e106_1.txt")
			event.stop_music(0)
			event.set_object_sequence_texture_animation(0, 0)
			event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
			event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
			event.set_object_sequence_texture_animation(2, 0)
			event.set_object_sequence_texture_animation(2, 1, "デフォルト顔")
			event.set_object_sequence_texture_animation(2, 1, "通常目パチ")
			at = 2
			var0 = helper_dc14(var2)
			if var0 == 1 then
				event.delete_character_extension_packs(0)
				event.load_character_motion_pack(5, "event/e100/e106/e106_mints2.gltf", "info", 0)
				var1 = event.is_object_handle_frame_visible(3, "light") or var1
				event.set_object_handle_frame_visible(3, "light", 0)
				projection = event.get_event_projection() or projection
				event.enable_drama_skip()
				at = 3
				helper_467e9642(var1, var2)
				at = 4
				helper_a0fc6040(var2)
				at = 5
				helper_05970f25(var2)
				event.set_object_handle_sound_bank(3, var2)
				at = 6
				helper_a374ffdb(var2)
			end
			event.fade_out_screen(30)
			at = 7
			wait_frames(30)
		end, function(received: { any }): boolean
			if at == 2 then
				var0 = received[1] :: number
			end
			if at <= 1 then
				var0 = helper_822b22f8(var2)
			end
			if at <= 2 then
				helper_e6cfe9e4(var1, var2)
			end
			if at <= 3 then
				helper_3adb7568(var2)
			end
			if at <= 4 then
				helper_eb4a6c55(var2)
			end
			if at <= 5 then
				helper_1de6c61f(var2)
			end
			if at <= 6 then
				wait_frames_skipping(30)
			end
			return true
		end)
		at = 8
		vm.entry(8)
		event.cancel_drama_scene_skip()
		event.stop_sound_effect(var2, 6)
		event.set_event_projection(projection)
		event.set_camera_position(pos_x, pos_y, pos_z)
		event.set_camera_look_at(pos_x_2, pos_y_2, pos_z_2)
		event.set_object_handle_visible(10, 1)
		event.set_object_handle_visible(11, 1)
		event.set_character_motion(0, "立ち", 4)
		event.set_character_active(1, 0)
		event.delete_character_extension_packs(0)
		event.delete_character(34)
		event.delete_character(35)
		if var0 ~= 1 then
			event.play_music(0)
		end
		event.fade_in_screen(30)
		return var0
	end, function(received: { any })
		if at <= 8 then
			return var0
		end
		return nil
	end)
end

--- Helper function.
local function helper_12348(se_id: s32)
	event.set_camera_sequence_position(-119.36, 26.55, -129.41)
	event.set_camera_sequence_look_at(-121.06, 12.13, -226.83)
	event.set_object_sequence_position(0, -119.53, -12.53, -229.18)
	event.set_object_sequence_rotation(0, 0.0, 0.0, 0.0)
	event.set_object_sequence_motion(0, "立ち（スティーブ）", 4)
	event.set_object_sequence_position(1, -119.53, -12.53, -229.18)
	event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
	event.set_object_sequence_motion(1, "立ち（スティーブ）", 4)
	wait_frames(50)
	event.stop_sound_effect(se_id, 0)
	event.play_sound_effect(se_id, 5)
	event.reset_object_sequence_motion(0)
	event.reset_object_sequence_motion(1)
	wait_frames(30)
	event.mark_camera_sequence_fade_track()
	event.fade_out_camera_sequence(50, 0.0, 0.0, 0.0)
	wait_camera()
	event.set_camera_sequence_position(-107.26, 10.75, -131.0)
	event.set_camera_sequence_look_at(-110.45, 11.92, -193.48)
	event.set_character_position(0, -91.97, -12.53, -211.57)
	event.set_character_rotation(0, 0.0, -2.4, 0.0)
	event.set_object_sequence_motion(0, "立ち", 4)
	event.set_character_position(33, -119.53, -12.53, -229.18)
	event.set_character_rotation(33, 0.0, 0.0, 0.0)
	event.reset_object_sequence_motion(1)
	event.set_object_handle_frame_visible(1, "light--c0appz0n1", 0)
	wait_objects(0)
	wait_objects(1)
	event.mark_camera_sequence_fade_track()
	event.fade_in_camera_sequence(100, 0.0, 0.0, 0.0)
	wait_camera()
	event.set_message_window_mode(0, 8)
	event.open_message_window_2(0, "[(!)]To fight Flotsam again, access\n   Steve with the (O) button.")
	helper_75684dd8(0, -1, 8, 0, 0)
	event.set_message_window_mode(0, 7)
end

--- Helper function.
local function helper_12c94()
	local var0: s32 = 0
	local var1: s32 = 0
	local projection: f32 = 0
	vm.section(function()
		event.set_save_flag(108, 1)
		event.initialize_event()
		event.enable_drama_skip()
		event.set_message_window_mode(0, 7)
		var0 = event.load_sound_effect_file_2(1822) or var0
		var1 = event.load_sound_effect_file_3(7, "snd2/chara/ch_040.sound.json") or var1
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		projection = event.get_event_projection() or projection
		event.get_camera_position()
		event.get_camera_look_at()
		event.load_character_motion_pack(5, "event/e100/e108/e108_mints.gltf", "info", 0)
		event.set_character_active(1, 0)
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_position(0, 0.0, 50.0, 0.0)
		event.set_character_rotation(0, 0.0, 0.0, 0.0)
		event.load_character(5, "event/e100/e108/e108_steve.gltf", "info", 33)
		event.set_character_active(1, 33)
		event.attach_object_handle_to_character(1, 33)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_position(33, 0.0, 50.0, 0.0)
		event.set_character_rotation(33, 0.0, 0.0, 0.0)
		event.set_object_handle_sound_bank(1, var1)
		event.attach_object_handle_to_map_part_3(10, "p04_i01h01", "i01h01_05-m1")
		event.attach_object_handle_to_map_part_3(11, "p04_i01h01", "i01h01_05-m3")
		event.attach_object_handle_to_map_part_3(12, "p01_i01h01", "i01h01_21-m0")
		event.clear_object_sequence(12)
		event.set_object_sequence_object(12, 12)
		event.attach_object_handle_to_map_part_3(13, "p01_i01h01", "i01h01_21-m1")
		event.clear_object_sequence(13)
		event.set_object_sequence_object(13, 13)
		event.attach_object_handle_to_map_part_3(14, "p07_i01h01", "i01h01_08-m0")
		event.clear_object_sequence(14)
		event.set_object_sequence_object(14, 14)
		event.attach_object_handle_to_map_part_3(15, "p07_i01h01", "i01h01_08-m1")
		event.clear_object_sequence(15)
		event.set_object_sequence_object(15, 15)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目パチ")
		helper_2ecccad3(var0)
		helper_12348(var0)
		event.fade_out_screen(30)
		wait_frames(30)
	end)
	event.cancel_drama_scene_skip()
	event.stop_sound_effect(var0, 0)
	event.clear_object_sequence(0)
	event.clear_object_sequence(12)
	event.clear_object_sequence(13)
	event.set_save_flag(56, 0)
	event.set_event_projection(projection)
	event.set_camera_position(-119.36, 26.55, -129.41)
	event.set_camera_look_at(-121.06, 12.13, -226.83)
	event.set_character_position(0, -98.38, -12.53, -200.14)
	event.set_character_rotation(0, 0.0, -2.88, 0.0)
	event.set_object_handle_rotation(12, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(13, 0.0, 0.0, 0.0)
	vm.wait(4)
	event.set_object_handle_visible(10, 1)
	event.set_object_handle_visible(11, 1)
	event.set_object_handle_visible(14, 1)
	event.set_object_handle_visible(15, 1)
	event.delete_character_extension_packs(0)
	event.delete_character(33)
	event.delete_character(34)
	event.delete_character(35)
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
end

--- Helper function.
local function helper_13bc8(arg0: any)
	local var1: any = 0
	local var2: s32 = 0
	local at: number = 0
	return vm.guard(function()
		event.set_camera_sequence_position(-138.16, 13.17, -131.29)
		event.set_camera_sequence_look_at(-115.98, 11.22, -208.05)
		event.set_character_active(1, 0)
		event.set_object_sequence_position(0, -98.38, -12.53, -200.14)
		event.set_object_sequence_rotation(0, 0.0, -2.88, 0.0)
		event.set_character_active(1, 33)
		event.set_object_sequence_position(1, -119.53, -12.53, -229.18)
		event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
		event.reset_object_sequence_motion(1)
		event.set_object_handle_visible(10, 0)
		event.set_object_handle_visible(11, 0)
		event.set_object_sequence_motion(0, "立ち", 4, -1.0, 1)
		var2 = event.get_message_window_frame(0) or var2
		event.set_message_window_mode(0, 1)
		event.set_message_bubble_tail(0, 0)
		event.open_message_window_2(0, "Yeah! Let me at Flotsam again!\nI'm not quite ready yet.")
		at = 1
		var1 = helper_7e7c045c(0, -1, 8, 0, 0, 2, 0)
		event.set_message_window_mode(0, var2)
		if var1 == 0 then
			event.mark_camera_sequence_fade_track()
			event.fade_out_camera_sequence(50, 0.0, 0.0, 0.0)
			at = 2
			wait_frames(30)
			at = 3
			wait_camera()
			at = 4
			vm.wait(4)
			return 1
		end
		return 0
	end, function(received: { any })
		if at <= 4 then
			if at == 1 then
				var1 = received[1] :: number
			end
			if at <= 1 then
				wait_frames_skipping(30)
			end
			if at <= 2 then
				helper_344d6cd8()
			end
			return 1
		end
		return nil
	end)
end

--- Helper function.
local function helper_15328()
	local var0: s32 = 0
	local projection: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	local var8: s32 = 0
	local at: number = 0
	return vm.guard(function()
		vm.section(function()
			event.set_character_active(0, 24)
			event.set_save_flag(108, 1)
			event.initialize_event()
			event.set_message_window_mode(0, 7)
			event.load_map_sounds(1237)
			var0 = event.load_sound_effect_file_2(1237) or var0
			event.assign_memory_stack(5)
			event.clear_memory_stack(5)
			projection = event.get_event_projection() or projection
			do
				local out1, out2, out3 = event.get_camera_position()
				pos_x = out1 or pos_x
				pos_y = out2 or pos_y
				pos_z = out3 or pos_z
			end
			do
				local out1, out2, out3 = event.get_camera_look_at()
				pos_x_2 = out1 or pos_x_2
				pos_y_2 = out2 or pos_y_2
				pos_z_2 = out3 or pos_z_2
			end
			event.clear_camera_sequence()
			event.set_camera_position(6.02, 94.24, 399.23)
			event.set_camera_look_at(-4.96, 118.28, 117.71)
			event.load_character_motion_pack(5, "event/e100/e108/e108_mints.gltf", "info", 0)
			event.set_character_active(1, 0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
			event.set_character_position(0, 0.0, 50.0, 0.0)
			event.set_character_rotation(0, 0.0, 0.0, 0.0)
			event.load_character(5, "event/e100/e108/e108_steve.gltf", "info", 33)
			event.set_character_active(1, 33)
			event.attach_object_handle_to_character(1, 33)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.set_character_position(33, 0.0, 50.0, 0.0)
			event.set_character_rotation(33, 0.0, 0.0, 0.0)
			event.set_object_handle_sound_bank(1, var0)
			event.attach_object_handle_to_map_part_3(10, "p04_i01h01", "i01h01_05-m1")
			event.attach_object_handle_to_map_part_3(11, "p04_i01h01", "i01h01_05-m3")
			event.attach_object_handle_to_map_part_3(12, "p01_i01h01", "i01h01_21-m0")
			event.clear_object_sequence(12)
			event.set_object_sequence_object(12, 12)
			event.set_object_sequence_rotation(12, 0.0, 0.0, 0.0)
			event.attach_object_handle_to_map_part_3(13, "p01_i01h01", "i01h01_21-m1")
			event.clear_object_sequence(13)
			event.set_object_sequence_object(13, 13)
			event.set_object_sequence_rotation(13, 0.0, 0.0, 0.0)
			event.attach_object_handle_to_map_part_3(14, "p07_i01h01", "i01h01_08-m0")
			event.clear_object_sequence(14)
			event.set_object_sequence_object(14, 14)
			event.attach_object_handle_to_map_part_3(15, "p07_i01h01", "i01h01_08-m1")
			event.clear_object_sequence(15)
			event.set_object_sequence_object(15, 15)
			event.set_object_sequence_texture_animation(0, 0)
			event.set_object_sequence_texture_animation(0, 1, "おこり顔")
			event.set_object_sequence_texture_animation(0, 1, "おこり目パチ")
			at = 1
			var8 = helper_13bc8(var0)
			if var8 == 1 then
				event.enable_drama_skip()
				at = 2
				helper_b5a4da39(var0)
				at = 3
				helper_ce6820bc(var0)
				event.set_save_flag(56, 1)
			else
				event.set_save_flag(56, 0)
			end
			event.fade_out_screen(30)
			at = 4
			wait_frames(30)
		end, function(received: { any }): boolean
			if at == 1 then
				var8 = received[1] :: number
			end
			if at <= 1 then
				helper_2ff63eb4(var0)
			end
			if at <= 2 then
				helper_17069978(var0)
			end
			if at <= 3 then
				wait_frames_skipping(30)
			end
			return true
		end)
		at = 5
		vm.entry(5)
		event.cancel_drama_scene_skip()
		event.stop_sound_effect(var0, 1)
		event.set_object_handle_visible(10, 1)
		event.set_object_handle_visible(11, 1)
		event.get_event_projection(projection)
		event.get_camera_position(pos_x, pos_y, pos_z)
		event.get_camera_look_at(pos_x_2, pos_y_2, pos_z_2)
		at = 6
		vm.wait(6)
		event.delete_character_extension_packs(0)
		event.delete_character(33)
		event.fade_in_screen(30)
		return var8
	end, function(received: { any })
		if at <= 6 then
			return var8
		end
		return nil
	end)
end

--- Helper function.
local function helper_c3b0(arg0: s32, arg1: any)
	local flag: s32 = 0
	local var3: s32 = 0
	local player_chara: s32 = 0
	local var5: any = 0
	local argc: s32 = 0
	local argc_2: s32 = 0
	local argc_3: s32 = 0
	event.set_character_motion(0, "立ち", 0)
	wait_frames(9)
	flag = event.get_save_flag(7) or flag
	if flag == 1 then
		event.set_villager_ai_enabled(0, 24)
		set_window_mode(0, 1)
		helper_4e93f9fc(arg0, 0, 0)
		player_chara = event.get_player_character_slot() or player_chara
		event.open_message_window_2(0, "So, how's Steve doing?")
		helper_0ffc2526(0, -1, arg0, player_chara, 0)
		event.set_character_motion(arg0, "立ち")
		event.set_message_bubble_tail(0, 0)
		event.set_message_selection_top_line(0, 0)
		event.set_message_window_option(0, 0, 1)
		event.open_message_window_2(0, "Refuel\nUpgrade the Core")
		var5 = helper_7e7c045c(0, -1, 5, 256, 208, 2, 0)
		event.set_message_window_option(0, 0, 0)
		event.set_message_bubble_tail(0, 1)
		if var5 == 0 then
			event.set_save_data_value(2)
			event.open_message_window_2(0, "There! All fixed!")
			helper_0ffc2526(0, -1, arg0, player_chara, 0)
		end
		if var5 == 1 then
			event.fade_out_screen(25)
			wait_frames(30)
			event.open_event_menu(6, 23)
			vm.wait(7)
			event.fade_in_screen(25)
		end
		event.set_villager_ai_enabled(1, 24)
		return
	end
	flag = event.get_save_flag(107) or flag
	if flag == 1 then
		event.set_villager_ai_enabled(0, 24)
		event.open_message_window_2(0, "Giving up over a little thing like\nthis? Never give up, I say!")
		helper_1c04a0eb(arg0, -1, 0, 0)
		event.set_villager_ai_enabled(1, 24)
		return
	end
	flag = event.get_save_flag(20) or flag
	if flag == 1 then
		vm.wait(9)
		event.load_event_script("i01h01/i01h01c_1.stb", 500)
		return
	end
	var3 = event.get_item_count(165) or var3
	if var3 > 0 then
		event.set_save_flag(20, 1)
		vm.wait(10)
		event.load_event_script("i01h01/i01h01b_1.stb", 520)
		return
	end
	argc = event.get_item_count(224) or argc
	argc_2 = event.get_item_count(245) or argc_2
	argc_3 = event.get_item_count(227) or argc_3
	var3 = event.is_invention_created(165) or var3
	if argc >= 20 and argc_2 >= 1 and argc_3 >= 2 and var3 ~= -1 then
		vm.wait(11)
		event.load_event_script("i01h01/i01h01b_1.stb", 520)
		return
	end
	flag = event.get_save_flag(19) or flag
	if flag == 1 then
		event.set_villager_ai_enabled(0, 24)
		event.open_message_window_2(
			0,
			"You go out, and the place right in\nfront with the pumpkin sign is the\nItem Shop.<page>You need 20 Scraps of Metal,\n2 Hunks of Copper and 1 Thick Hide.\nGet over there and buy 'em!"
		)
		helper_1c04a0eb(arg0, -1, 0, 0)
		event.set_villager_ai_enabled(1, 24)
		return
	end
	var3 = event.is_invention_created(165) or var3
	if var3 ~= -1 then
		vm.wait(13)
		event.load_event_script("i01h01/i01h01b_1.stb", 520)
		return
	end
	var3 = event.has_invention_ideas(165) or var3
	if var3 == 1 then
		vm.wait(14)
		event.load_event_script("i01h01/i01h01b_1.stb", 520)
		return
	end
	flag = event.get_save_flag(17) or flag
	if flag == 1 then
		vm.wait(15)
		event.load_event_script("i01h01/i01h01b_1.stb", 510)
		return
	end
	flag = event.get_save_flag(105) or flag
	if flag == 0 then
		event.open_message_window_2(0, "Max, you can't just skip work, you\nhear me?")
		helper_1c04a0eb(arg0, -1, 0, 0)
		return
	end
	event.set_villager_ai_enabled(0, 24)
	event.open_message_window_2(0, "You gotta try on your own\nfirst, lad.")
	helper_1c04a0eb(arg0, -1, 0, 0)
	event.open_message_window_2(0, "I'll give you a hint if you get\nstuck, alright?")
	helper_1c04a0eb(arg0, -1, 0, 0)
	event.open_message_window_2(0, "Now, get a move on!")
	helper_1c04a0eb(arg0, -1, 0, 0)
	event.set_villager_ai_enabled(1, 24)
end

--- Helper function.
local function helper_d8c0()
	local var0: s32 = 0
	local var1: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	event.set_message_window_mode(0, 1)
	var0 = event.get_triggered_event_data_2(13) or var0
	var1 = event.get_triggered_event_data_2(14) or var1
	print("[talk_chara]", var1, "\n")
	print("[talk_chara_id]", var1, "\n")
	if var1 == 1 then
		helper_c3b0(var0, var1)
	end
	if var1 == -1 then
		flag = event.get_save_flag(6) or flag
		flag_2 = event.get_save_flag(7) or flag_2
		if flag == 1 and flag_2 == 0 then
			vm.wait(2)
			event.load_event_script("i01h01/i01h01c_1.stb", 520)
		end
	end
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Event 151, which map data, a script or the engine runs by number.
function script.event_151()
	local var0: s32 = 0
	local argc: s32 = 0
	local at: number = 0
	return vm.guard(function()
		event.fade_out_screen(10)
		at = 1
		wait_frames(10)
		helper_86e93423()
		at = 2
		var0 = helper_10ba0()
		if var0 == 1 then
			event.add_inventory_item(135, 1)
			event.add_inventory_item(145, 1)
			event.add_inventory_item(155, 1)
			event.add_inventory_item(165, 1)
			at = 3
			vm.wait(3)
			argc = event.get_item_count(246) or argc
			if argc == 0 then
				event.add_inventory_item(246, 1)
			end
			event.set_party_member(2, 1)
			event.set_character_change_enabled(2, 1)
			event.set_character_change_unmasked(2, 1)
			event.set_character_change_unmasked(0, 1)
			event.set_save_flag(25, 1)
			event.fade_out_screen(30)
			at = 4
			wait_frames(30)
			event.fade_in_screen(30)
		else
			helper_658b1052()
			event.set_character_position(0, 16.25, -0.02, -166.37)
			event.set_character_rotation(0, 0.0, 1.16, 0.0)
			event.set_character_motion(0, "立ち")
			event.set_character_position(24, 38.77, -0.02, -147.68)
			event.set_character_rotation(24, 0.0, -2.04, 0.0)
			event.set_character_motion(24, "立ち")
			at = 5
			vm.wait(5)
			event.load_event_script("i01h01/i01h01_1.stb", -1)
		end
		return
	end, function(received: { any })
		if at <= 5 then
			if at == 2 then
				var0 = received[1] :: number
			end
			if at <= 1 then
				helper_1ef0d4b2()
				at = 2
				var0 = helper_10ba0()
				return vm.continue_with(function()
					if var0 == 1 then
						event.add_inventory_item(135, 1)
						event.add_inventory_item(145, 1)
						event.add_inventory_item(155, 1)
						event.add_inventory_item(165, 1)
						at = 3
						vm.wait(3)
						argc = event.get_item_count(246) or argc
						if argc == 0 then
							event.add_inventory_item(246, 1)
						end
						event.set_party_member(2, 1)
						event.set_character_change_enabled(2, 1)
						event.set_character_change_unmasked(2, 1)
						event.set_character_change_unmasked(0, 1)
						event.set_save_flag(25, 1)
						event.fade_out_screen(30)
						at = 4
						wait_frames(30)
						event.fade_in_screen(30)
					else
						helper_658b1052()
						event.set_character_position(0, 16.25, -0.02, -166.37)
						event.set_character_rotation(0, 0.0, 1.16, 0.0)
						event.set_character_motion(0, "立ち")
						event.set_character_position(24, 38.77, -0.02, -147.68)
						event.set_character_rotation(24, 0.0, -2.04, 0.0)
						event.set_character_motion(24, "立ち")
						at = 5
						vm.wait(5)
						event.load_event_script("i01h01/i01h01_1.stb", -1)
					end
					return
				end)
			end
			if at <= 3 then
				wait_frames_skipping(30)
			end
			if at <= 4 then
				helper_1ef0d4b2()
			end
			return 0
		end
		return nil
	end)
end

--- Event 200, which map data, a script or the engine runs by number.
script.event_200 = helper_0999bd0f

--- Event 500, which map data, a script or the engine runs by number.
function script.event_500()
	local var0: s32 = 0
	local argc: s32 = 0
	local at: number = 0
	return vm.guard(function()
		event.fade_out_screen(10)
		at = 1
		wait_frames(10)
		helper_86e93423()
		at = 2
		var0 = helper_10ba0()
		if var0 == 1 then
			argc = event.get_item_count(246) or argc
			if argc <= 0 then
				event.add_inventory_item(135, 1)
				event.add_inventory_item(145, 1)
				event.add_inventory_item(155, 1)
				event.add_inventory_item(165, 1)
				at = 3
				vm.wait(3)
				event.add_inventory_item(246, 1)
			end
			event.set_party_member(2, 1)
			event.set_character_change_enabled(2, 1)
			event.set_character_change_unmasked(2, 1)
			event.set_character_change_unmasked(0, 1)
			event.set_save_flag(25, 1)
			event.fade_out_screen(30)
			at = 4
			wait_frames(30)
			at = 5
			helper_d529ed92()
			event.skip_next_music_load()
			event.go_to_dungeon(0, 4, 520)
			at = 6
			vm.wait(6)
			return
		else
			helper_658b1052()
			event.set_character_position(0, 16.25, -0.02, -166.37)
			event.set_character_rotation(0, 0.0, 1.16, 0.0)
			event.set_character_motion(0, "立ち")
			event.set_character_position(24, 38.77, -0.02, -147.68)
			event.set_character_rotation(24, 0.0, -2.04, 0.0)
			event.set_character_motion(24, "立ち")
			at = 7
			vm.wait(7)
			event.load_event_script("i01h01/i01h01_1.stb", -1)
		end
		return
	end, function(received: { any })
		if at <= 6 then
			if at == 2 then
				var0 = received[1] :: number
			end
			if at <= 1 then
				helper_1ef0d4b2()
				at = 2
				var0 = helper_10ba0()
				return vm.continue_with(function()
					if var0 == 1 then
						argc = event.get_item_count(246) or argc
						if argc <= 0 then
							event.add_inventory_item(135, 1)
							event.add_inventory_item(145, 1)
							event.add_inventory_item(155, 1)
							event.add_inventory_item(165, 1)
							at = 3
							vm.wait(3)
							event.add_inventory_item(246, 1)
						end
						event.set_party_member(2, 1)
						event.set_character_change_enabled(2, 1)
						event.set_character_change_unmasked(2, 1)
						event.set_character_change_unmasked(0, 1)
						event.set_save_flag(25, 1)
						event.fade_out_screen(30)
						at = 4
						wait_frames(30)
						at = 5
						helper_d529ed92()
						event.skip_next_music_load()
						event.go_to_dungeon(0, 4, 520)
						at = 6
						vm.wait(6)
						return
					else
						helper_658b1052()
						event.set_character_position(0, 16.25, -0.02, -166.37)
						event.set_character_rotation(0, 0.0, 1.16, 0.0)
						event.set_character_motion(0, "立ち")
						event.set_character_position(24, 38.77, -0.02, -147.68)
						event.set_character_rotation(24, 0.0, -2.04, 0.0)
						event.set_character_motion(24, "立ち")
						at = 7
						vm.wait(7)
						event.load_event_script("i01h01/i01h01_1.stb", -1)
					end
					return
				end)
			end
			if at <= 3 then
				wait_frames_skipping(30)
			end
			if at <= 4 then
				helper_e52544df()
			end
			return 0
		end
		if at <= 7 then
			return 0
		end
		return nil
	end)
end

--- Event 510, which map data, a script or the engine runs by number.
function script.event_510()
	helper_86e93423()
	event.set_character_active(0, 26)
	event.set_character_active(0, 25)
	helper_12c94()
	event.set_character_active(1, 25)
	event.initialize_event()
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
	event.set_character_active(1, 25)
	event.set_character_active(1, 26)
	event.attach_character_to_frame(25, "back", 26)
	event.set_party_member(2, 0)
	event.set_function_point_enabled("", "fc_event_e108c", 1)
	wait_frames(30)
	vm.wait(3)
	event.load_event_script("i01h01/i01h01_1.stb", -1)
end

--- Event 520, which map data, a script or the engine runs by number.
function script.event_520()
	local var0: s32 = 0
	helper_86e93423()
	event.set_character_active(0, 25)
	event.set_character_active(0, 26)
	var0 = helper_15328()
	if var0 == 1 then
		event.set_save_flag(25, 1)
		event.set_party_member(2, 1)
		event.skip_next_music_load()
		event.go_to_dungeon(0, 4, 520)
	else
		event.set_save_flag(29, 1)
		event.set_character_active(1, 25)
		event.set_character_active(1, 26)
		event.set_function_point_enabled("", "fc_event_e108c", 1)
		vm.wait(2)
		event.load_event_script("i01h01/i01h01_1.stb", -1)
		return
	end
end

--- Event 1000, which map data, a script or the engine runs by number.
function script.event_1000()
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		at = 1
		vm.wait(1)
		at = 2
		helper_d8c0()
		return
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				helper_788a73ff()
			end
			return 0
		end
		return nil
	end)
end

return script
