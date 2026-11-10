--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_238b5abc = require("@lib/event/helper_238b5abc")
local helper_4116e6bb = require("@lib/event/helper_4116e6bb")
local helper_8cd371d7 = require("@lib/event/helper_8cd371d7")
local helper_9dafbc83 = require("@lib/event/helper_9dafbc83")
local wait_frames = require("@lib/event/wait_frames")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_0af418bf()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var5: s32 = 0
	local var6: f32 = 0
	local at: number = 0
	vm.section(function()
		event.set_save_flag(600, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.stop_music(0)
		event.load_map_sounds(7800)
		var0 = event.load_sound_effect_file_2(7800) or var0
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		active_chr_no = event.get_playable_character() or active_chr_no
		event.set_scene_status_flags(1, 0, 256, 1)
		event.change_directory("event/e600/e600/")
		event.load_message_file(0, 5, "e600_1.txt")
		if active_chr_no == 0 then
			event.load_character_motion_pack(5, "e600_mints.gltf", "info", 0)
			event.set_character_active(0, 0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if active_chr_no == 1 then
			event.load_character_motion_pack(5, "e600_monica.gltf", "info", 0)
			event.set_character_active(0, 0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.load_character(5, "e600_osmond.gltf", "info", 34)
		event.set_character_active(0, 34)
		event.attach_object_handle_to_character(2, 34)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.load_character(5, "e600_hikari.gltf", "info", 35)
		event.set_character_active(1, 35)
		event.load_character(5, "e600_nagare.gltf", "info", 36)
		event.set_character_active(1, 36)
		event.attach_object_handle_to_character(6, 36)
		event.clear_object_sequence(6)
		event.set_object_sequence_object(6, 6)
		event.change_directory("")
		if active_chr_no == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 32)
			event.load_equipment_model(5, 0, 4, "info", 32)
			event.load_equipment_model(5, 0, 3, "info", 32)
			event.load_equipment_model(5, 0, 2, "info", 32, 33)
			event.load_character_motion_pack(5, "event/e600/e600/e600_mints.gltf", "info", 32)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 32)
			event.attach_object_handle_to_character(0, 32)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 0)
		else
			event.load_character(5, "chara/c02_base.gltf", "info", 32)
			event.load_equipment_model(5, 1, 4, "info", 32)
			event.load_equipment_model(5, 1, 3, "info", 32)
			event.load_equipment_model(5, 1, 2, "info", 32, 33)
			event.load_character_motion_pack(5, "event/e600/e600/e600_monica.gltf", "info", 32)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 32)
			event.attach_object_handle_to_character(1, 32)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 0)
		end
		event.set_character_active(0, 32)
		event.set_character_active(0, 33)
		event.attach_object_handle_to_map_part_2(3, "p01_train01")
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.attach_object_handle_to_map_part_3(4, "p01_train01", "s3601_13-m1")
		event.clear_object_sequence(4)
		event.set_object_sequence_object(4, 4)
		event.attach_object_handle_to_map_part_3(5, "p01_train01", "s3601_15-m2")
		event.clear_object_sequence(5)
		event.set_object_sequence_object(5, 5)
		event.attach_object_handle_to_map_part_2(7, "p01_shadow-0")
		event.set_object_handle_position(0, 593.01, 30.8, 3553.84)
		event.set_object_handle_rotation(0, 0.0, 3.14, 0.0)
		event.set_object_handle_motion(0, "立ち", 4)
		event.set_object_handle_footstep_sound(0, 16)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "おこり顔")
		event.set_object_handle_texture_animation(0, 1, "おこり目パチ")
		event.set_object_handle_position(1, 583.22, 30.8, 3557.92)
		event.set_object_handle_rotation(1, 0.0, 3.14, 0.0)
		event.set_object_handle_motion(1, "立ち", 4)
		event.set_object_handle_footstep_sound(1, 16)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "おこり顔")
		event.set_object_handle_texture_animation(1, 1, "おこり目パチ")
		event.set_object_handle_position(2, 588.09, 30.8, 3562.57)
		event.set_object_handle_rotation(2, 0.0, 3.14, 0.0)
		event.set_object_handle_motion(2, "立ち", 4)
		event.set_object_handle_footstep_sound(2, 16)
		event.set_object_handle_position(3, -6000.0, 2400.0, 1600.0)
		event.set_object_handle_rotation(3, 0.2, 1.2, 0.0)
		event.set_object_handle_rotation(4, 0.0, 0.0, 0.0)
		event.set_object_handle_rotation(5, 0.0, 0.0, 0.0)
		event.set_object_handle_visible(7, 0)
		event.set_object_handle_position(6, -6000.0, 2480.0, 1600.0)
		event.set_object_handle_rotation(6, 0.2, 1.2, 0.0)
		event.set_object_handle_motion(6, "ループ", 4)
		event.set_character_position(35, -6000.0, 2400.0, 1600.0)
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(1067.88, 491.78, 4477.15)
		event.set_camera_sequence_look_at(432.94, 580.78, 4182.04)
		event.move_camera_sequence_eased(1067.88, 491.78, 4477.15, 858.72, 267.72, 3985.84, 90, 2, 1.0)
		event.play_sound_effect(var0, 2)
		event.play_sound_effect(var0, 3)
		event.fade_in_screen(30)
		event.rotate_object_sequence_eased(3, 0.0, 1.57, 0.0, 60, 2, 1.0)
		event.rotate_object_sequence_eased(6, 0.0, 1.57, 0.0, 60, 2, 1.0)
		var5 = 0
		while var5 < 90 do
			if var5 == 20 then
				event.set_character_visible(35, 0, 1, 0.033333335)
				event.set_character_visible(36, 0, 1, 0.033333335)
			end
			at = 1
			vm.wait(1)
			do
				local out1, out2, out3 = event.get_object_handle_position(3)
				pos_x = out1 or pos_x
				pos_y = out2 or pos_y
				pos_z = out3 or pos_z
			end
			pos_x = vm.f32(pos_x + vm.f32(vm.f32(790.0 - pos_x) / 24.0))
			pos_y = vm.f32(pos_y + vm.f32(vm.f32(0.0 - pos_y) / 16.0))
			pos_z = vm.f32(pos_z + vm.f32(vm.f32(3600.0 - pos_z) / 16.0))
			event.set_object_handle_position(3, pos_x, pos_y, pos_z)
			event.set_object_handle_position(6, pos_x, pos_y + 80.0, pos_z)
			var5 = var5 + 1
		end
		event.move_object_sequence_eased(3, 790.0, 0.0, 3600.0, 30, 2, 1.0)
		event.rotate_object_sequence(3, 0.0, 1.57, 0.0, 30)
		event.move_object_sequence_eased(6, 790.0, 0.0, 3680.0, 30, 2, 1.0)
		event.rotate_object_sequence(6, 0.0, 1.57, 0.0, 30)
		var6 = 2.0
		var5 = 0
		while var5 < 30 do
			do
				local out1, out2, out3 = event.get_object_handle_position(3)
				pos_x = out1 or pos_x
				pos_y = out2 or pos_y
				pos_z = out3 or pos_z
			end
			if vm.imod(var5, 2) == 0 then
				pos_y = vm.f32(pos_y + var6)
			else
				pos_y = vm.f32(pos_y - var6)
			end
			var6 = vm.f32(var6 - vm.f32(var6 / 30.0))
			event.set_object_handle_position(3, pos_x, pos_y, pos_z)
			var5 = var5 + 1
			at = 2
			vm.wait(2)
		end
		at = 3
		wait_objects(3)
		at = 4
		wait_frames(20)
		event.set_camera_sequence_position(407.12, 258.94, 3255.47)
		event.set_camera_sequence_look_at(609.92, 112.52, 3513.32)
		event.set_object_sequence_position(3, 790.0, 0.0, 3600.0)
		event.set_object_sequence_rotation(3, 0.0, 1.57, 0.0)
		event.set_character_active(0)
		event.set_character_active(32)
		event.set_character_active(33)
		event.set_character_active(34)
		at = 5
		wait_frames(10)
		event.play_sound_effect(var0, 4)
		event.rotate_object_sequence_eased(4, 0.0, 0.0, 1.6, 30, 0, 1.0)
		event.rotate_object_sequence_eased(5, 0.0, 0.0, 1.6, 30, 0, 1.0)
		at = 6
		wait_frames(60)
		event.jump_object_sequence(0, 616.43, 0.0, 3519.44, -0.2, 20)
		event.set_object_sequence_motion(0, "走り")
		event.delay_object_sequence_motion_track(0, 4)
		event.set_object_sequence_motion(0, "着地", 1)
		event.delay_object_sequence_motion_track(0, 10)
		event.set_object_sequence_motion(0, "着地", 2)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		at = 7
		wait_frames(10)
		event.jump_object_sequence(1, 590.55, 0.0, 3527.36, -0.2, 20)
		event.set_object_sequence_motion(1, "走り")
		event.delay_object_sequence_motion_track(1, 4)
		event.set_object_sequence_motion(1, "着地", 1)
		event.delay_object_sequence_motion_track(1, 10)
		event.set_object_sequence_motion(1, "着地", 2)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		at = 8
		wait_objects(1)
		event.set_camera_sequence_position(734.79, 34.32, 3415.62)
		event.set_camera_sequence_look_at(645.05, 7.39, 3483.16)
		event.set_object_sequence_position(0, 678.03, 0.0, 3463.04)
		event.set_object_sequence_rotation(0, 0.0, 2.18, 0.0)
		event.set_object_sequence_motion(0, "キョロキョロ歩き", 4, -1, 1)
		event.move_object_sequence(0, 732.73, 0.0, 3421.88, 90)
		event.reset_object_sequence_dynamic_animation(0)
		event.delay_object_sequence_motion_track(0, 90)
		event.set_object_sequence_motion(0, "立ち", 4)
		event.set_object_sequence_position(1, 623.2, 0.0, 3468.36)
		event.set_object_sequence_rotation(1, 0.0, 2.9, 0.0)
		event.reset_object_sequence_dynamic_animation(1)
		event.set_object_sequence_position(2, 604.19, 0.0, 3501.3)
		event.set_object_sequence_rotation(2, 0.0, 3.14, 0.0)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 9
		helper_4116e6bb(6000370)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 10
		helper_4116e6bb(6000380)
		at = 11
		wait_objects(0)
		event.set_camera_sequence_position(834.25, 32.04, 3503.77)
		event.set_camera_sequence_look_at(728.22, 120.07, 3124.24)
		event.set_object_sequence_position(0, 688.8, 11.3, 3250.37)
		event.set_object_sequence_rotation(0, 0.0, -2.26, 0.0)
		event.set_object_sequence_motion(0, "指さす", 4, -1.0, 1)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 12
		helper_4116e6bb(6000390)
		event.set_camera_sequence_position(616.62, 51.57, 3428.73)
		event.set_camera_sequence_look_at(613.93, 8.94, 3476.66)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "こまり顔")
		event.set_object_handle_texture_animation(1, 1, "こまり目パチ")
		event.set_object_sequence_motion(1, "上向くL", 4, -1, 1)
		event.set_object_sequence_rotation(1, 0.0, -2.9, 0.0)
		event.reset_object_sequence_dynamic_animation(1)
		event.set_object_sequence_motion(2, "歩き（上見）")
		event.move_object_sequence(2, 603.8, 0.0, 3472.38, 60)
		event.delay_object_sequence_motion_track(2, 60)
		event.set_object_sequence_motion(2, "立ち（上見）")
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 13
		helper_4116e6bb(6000400)
		at = 14
		helper_4116e6bb(6000410)
		event.set_camera_sequence_position(0.0, 995.95, 3461.49)
		event.set_camera_sequence_look_at(0.0, 846.5, 1987.55)
		event.move_camera_sequence_eased(0.0, 25.08, 3461.49, 0.0, 392.85, 1987.55, 120, 0, 1.0)
		event.set_object_handle_footstep_sound(0, 2)
		event.set_object_handle_footstep_sound(1, 2)
		event.set_object_handle_footstep_sound(2, 2)
		event.set_object_sequence_position(0, -12.0, 0.0, 3300.0)
		event.set_object_sequence_rotation(0, 0.0, 3.14, 0.0)
		event.set_object_sequence_position(1, 12.0, 0.0, 3300.0)
		event.set_object_sequence_rotation(1, 0.0, 3.14, 0.0)
		event.set_object_sequence_position(2, 0.0, 0.0, 3320.0)
		event.set_object_sequence_rotation(2, 0.0, 3.14, 0.0)
		at = 15
		wait_frames(200)
		event.move_object_sequence(0, -12.0, 14.0, 3000.0, 160, 1)
		event.set_object_sequence_motion(0, "歩き")
		event.move_object_sequence(1, 12.0, 14.0, 3000.0, 160, 1)
		event.set_object_sequence_motion(1, "歩き")
		event.move_object_sequence(2, 0.0, 9.0, 3020.0, 160, 1)
		event.set_object_sequence_motion(2, "歩き")
		at = 16
		wait_objects(0)
		event.set_camera_sequence_position(35.49, 35.66, 2985.73)
		event.set_camera_sequence_look_at(5.9, 35.78, 3001.23)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "おこり顔")
		event.set_object_handle_texture_animation(1, 1, "おこり目パチ")
		event.set_object_sequence_motion(0, "上向くL", 4, -1, 1)
		event.set_object_sequence_motion(1, "上向くL", 4, -1, 1)
		event.set_object_sequence_motion(2, "立ち（上見）", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 17
		helper_4116e6bb(6000420)
		event.set_camera_sequence_position(-25.58, 61.54, 2959.33)
		event.set_camera_sequence_look_at(-12.23, 37.86, 2998.16)
		event.move_camera_sequence_eased(-18.54, 50.73, 2979.81, -12.23, 37.86, 2998.16, 60, 2, 1.0)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 18
		helper_4116e6bb(6000430)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 19
		helper_4116e6bb(6000435)
		event.set_camera_sequence_position(0.0, 6.31, 3126.74)
		event.set_camera_sequence_look_at(0.0, 59.43, 2999.73)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 20
		helper_4116e6bb(6000440)
		event.set_object_sequence_motion(0, "振り返る", 6)
		event.queue_object_sequence_next_motion(0, "振り返るL", 4)
		event.delay_object_sequence_sound_track(0, 10)
		event.play_object_sequence_sound(0, var0, 5)
		event.delay_object_sequence_motion_track(1, 4)
		event.set_object_sequence_motion(1, "上見から振り返り", 6)
		event.queue_object_sequence_next_motion(1, "上見から振り返りL", 4)
		at = 21
		helper_4116e6bb(6000450)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 22
		helper_4116e6bb(6000460)
		event.fade_out_screen(30)
		at = 23
		wait_frames(30)
	end, function(received: { any }): boolean
		if at <= 1 then
			pos_x = vm.f32(pos_x + vm.f32(vm.f32(790.0 - pos_x) / 24.0))
			pos_y = vm.f32(pos_y + vm.f32(vm.f32(0.0 - pos_y) / 16.0))
			pos_z = vm.f32(pos_z + vm.f32(vm.f32(3600.0 - pos_z) / 16.0))
			local _ = var5 < 90
			local _ = var5 == 20
			var5 = var5 + 1
			var6 = 2.0
			var5 = 0
			pos_y = vm.f32(pos_y + var6)
			pos_y = vm.f32(pos_y - var6)
			var6 = vm.f32(var6 - vm.f32(var6 / 30.0))
			local _ = var5 < 30
			local _ = vm.imod(var5, 2) == 0
			var5 = var5 + 1
		end
		if at <= 2 then
			helper_238b5abc(3)
		end
		if at <= 3 then
			wait_frames_skipping(20)
		end
		if at <= 4 then
			wait_frames_skipping(10)
		end
		if at <= 5 then
			wait_frames_skipping(60)
		end
		if at <= 6 then
			wait_frames_skipping(10)
		end
		if at <= 7 then
			helper_238b5abc(1)
		end
		if at <= 8 then
			helper_8cd371d7(6000370)
		end
		if at <= 9 then
			helper_8cd371d7(6000380)
		end
		if at <= 10 then
			helper_238b5abc(0)
		end
		if at <= 11 then
			helper_8cd371d7(6000390)
		end
		if at <= 12 then
			helper_8cd371d7(6000400)
		end
		if at <= 13 then
			helper_8cd371d7(6000410)
		end
		if at <= 14 then
			wait_frames_skipping(200)
		end
		if at <= 15 then
			helper_238b5abc(0)
		end
		if at <= 16 then
			helper_8cd371d7(6000420)
		end
		if at <= 17 then
			helper_8cd371d7(6000430)
		end
		if at <= 18 then
			helper_8cd371d7(6000435)
		end
		if at <= 19 then
			helper_8cd371d7(6000440)
		end
		if at <= 20 then
			helper_8cd371d7(6000450)
		end
		if at <= 21 then
			helper_8cd371d7(6000460)
		end
		if at <= 22 then
			wait_frames_skipping(30)
		end
		return true
	end)
	event.cancel_drama_scene_skip()
	event.set_object_handle_visible(7, 1)
	event.set_character_active(0)
	event.set_character_active(32)
	event.set_character_active(33)
	event.set_scene_status_flags(1, 0, 256, 0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.set_object_handle_position(3, 790.0, 0.0, 3600.0)
	event.set_object_handle_rotation(3, 0.0, 1.57, 0.0)
	event.set_object_handle_rotation(4, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(5, 0.0, 0.0, 0.0)
	event.set_character_active(0)
	event.delete_character_extension_packs(0)
	event.delete_character(32)
	event.delete_character(33)
	event.delete_character(34)
	event.delete_character(35)
	event.delete_character(36)
	event.load_message_file(0, -1)
	helper_9dafbc83(0.0, vm.f32(3.9), 3200.0, vm.f32(3.14))
	event.reset_follow_camera(1, 3.14, 10)
	event.fade_in_screen(30)
end

return helper_0af418bf
