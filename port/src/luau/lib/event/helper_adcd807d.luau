--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1584c528 = require("@lib/event/helper_1584c528")
local helper_238b5abc = require("@lib/event/helper_238b5abc")
local helper_344d6cd8 = require("@lib/event/helper_344d6cd8")
local helper_4116e6bb = require("@lib/event/helper_4116e6bb")
local helper_52aadc70 = require("@lib/event/helper_52aadc70")
local helper_6b0b98a6 = require("@lib/event/helper_6b0b98a6")
local helper_8cd371d7 = require("@lib/event/helper_8cd371d7")
local wait_camera = require("@lib/event/wait_camera")
local wait_frames = require("@lib/event/wait_frames")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_adcd807d()
	local active_chr_no: s32 = 0
	local var1: s32 = 0
	local var3: s32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local vector_x: f32 = 0
	local vector_y: f32 = 0
	local vector_z: f32 = 0
	local var13: s32 = 0
	local var14: s32 = 0
	local at: number = 0
	vm.section(function()
		event.set_save_flag(312, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.show_dungeon_status_bar(0, 1.0)
		event.switch_dungeon_main_character(0)
		event.set_playable_character(0)
		active_chr_no = event.get_playable_character() or active_chr_no
		event.set_scene_status_flags(1, 0, 256, 1)
		if active_chr_no == 0 then
			var1 = 0
		else
			var1 = 13
		end
		var3 = event.load_sound_effect_file_2(3806) or var3
		helper_6b0b98a6(1)
		event.set_sphida_playing(0)
		event.load_character(4, "chara/c02_base.gltf", "info", 13)
		event.load_equipment_model(4, 1, 4, "info", 13)
		event.load_equipment_model(4, 1, 3, "info", 13)
		event.load_equipment_model(4, 1, 2, "info", 13, 14)
		event.set_scene_character_number(13, 1)
		event.load_character(4, "event/e300/e314/e314_bou.gltf", "info", 15)
		event.set_character_active(15)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.change_directory("event/e300/e312/")
		event.load_message_file(0, 5, "e312_1.txt")
		if active_chr_no == 0 then
			event.load_character_motion_pack(5, "e312_mints.gltf", "info", 0)
			event.set_character_active(0, 0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		event.load_character(5, "e312_boss.gltf", "info", 16)
		event.set_character_active(16)
		event.attach_object_handle_to_character(2, 16)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.change_directory("")
		event.load_character(5, "event/d03/p00_26a.gltf", "info", 17)
		event.set_character_active(17)
		event.attach_object_handle_to_character(3, 17)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		if active_chr_no == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 13)
			event.load_equipment_model(5, 0, 4, "info", 13)
			event.load_equipment_model(5, 0, 3, "info", 13)
			event.load_equipment_model(5, 0, 2, "info", 13, 14)
			event.load_character_motion_pack(5, "event/e300/e312/e312_mints.gltf", "info", 13)
			event.load_character_motion_pack(5, "event/dng_inout/c01d03gkey.gltf", "info", 13)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 13)
			event.attach_object_handle_to_character(0, 13)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
			event.load_character_motion_pack(5, "event/dng_inout/c02d03gkey.gltf", "info", 0)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 0)
		else
			event.load_character_motion_pack(5, "event/e300/e312/e312_monica.gltf", "info", 13)
			event.load_character_motion_pack(5, "event/dng_inout/c02d03gkey.gltf", "info", 13)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 13)
			event.attach_object_handle_to_character(1, 13)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.load_character_motion_pack(5, "event/dng_inout/c01d03gkey.gltf", "info", 0)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 0)
		end
		event.set_character_active(0, 13)
		event.set_character_active(0, 14)
		event.attach_object_handle_to_character(4, 1)
		event.attach_object_handle_to_character(5, 2)
		event.set_object_handle_visible(4, 0)
		event.set_object_handle_visible(5, 0)
		event.set_object_handle_position(0, -355.0, 30.46, 930.0)
		event.set_object_handle_rotation(0, 0.0, 3.14, 0.0)
		event.set_object_handle_motion(0, "立ち", 4)
		event.set_object_handle_footstep_sound(0, 1)
		event.set_object_handle_position(1, -338.8, 30.26, 950.0)
		event.set_object_handle_rotation(1, 0.0, 3.14, 0.0)
		event.set_object_handle_motion(1, "立ち", 4)
		event.set_object_handle_footstep_sound(1, 1)
		event.set_object_handle_position(3, -150.0, 230.0, 1600.0)
		event.set_object_handle_rotation(3, 0.0, 3.14, 0.0)
		event.set_object_handle_motion(3, "飛び", 4)
		event.play_object_sequence_sound(3, var3, 1)
		event.delay_object_sequence_sound_track(3, 34)
		event.play_object_sequence_sound(3, var3, 1)
		event.set_object_handle_position(2, -116.0, 316.0, 235.0)
		event.set_object_handle_rotation(2, 0.0, -0.36, 0.0)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "目パチ")
		event.set_object_handle_frame_draw_flag(2, "hana", 0)
		event.set_character_position(15, 0.0, 0.5, -170.0)
		event.set_character_rotation(15, 0.0, 1.57, 0.0)
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(254.65, 473.72, 1588.47)
		event.set_camera_sequence_look_at(-219.14, 62.76, 1197.82)
		event.play_sound_effect(var3, 0)
		event.fade_in_screen(30)
		var4 = -150.0
		var5 = 230.0
		var6 = 1600.0
		var7 = 0.0
		var8 = -8.0
		var9 = -10.0
		vector_x = 0.0
		vector_y = vm.f32(0.2)
		vector_z = 0.0
		var13 = 0
		while var13 < 60 do
			do
				local out1, out2, out3 = event.add_vectors(var4, var5, var6, var7, var8, var9)
				var4 = out1 or var4
				var5 = out2 or var5
				var6 = out3 or var6
			end
			do
				local out1, out2, out3 = event.add_vectors(var7, var8, var9, vector_x, vector_y, vector_z)
				var7 = out1 or var7
				var8 = out2 or var8
				var9 = out3 or var9
			end
			event.set_object_handle_position(3, var4, var5, var6)
			var13 = var13 + 1
			at = 1
			vm.wait(1)
		end
		event.set_character_active(0, 17)
		event.set_camera_sequence_position(-303.73, 9.54, 934.94)
		event.set_camera_sequence_look_at(-365.55, 6.21, 927.8)
		if active_chr_no == 0 then
			event.set_character_active(0)
		else
			event.set_character_active(13)
			event.set_character_active(14)
		end
		event.move_object_sequence(0, -355.0, 0.46, 920.0, 10)
		event.set_object_sequence_motion(0, "d03着地", 6)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		at = 2
		wait_frames(6)
		if active_chr_no == 0 then
			event.set_character_active(13)
			event.set_character_active(14)
		else
			event.set_character_active(0)
		end
		event.move_object_sequence(1, -338.5, 0.26, 940.0, 10)
		event.set_object_sequence_motion(1, "d03着地", 6)
		at = 3
		wait_frames(2)
		var14 = event.get_sound_id(1) or var14
		event.play_sound_effect(var14, 3)
		event.play_sound_effect(var14, 2)
		at = 4
		wait_frames(6)
		event.play_sound_effect(var14, 2)
		at = 5
		wait_frames(30)
		event.set_camera_sequence_position(-359.26, 22.65, 1003.22)
		event.set_camera_sequence_look_at(-344.39, 18.85, 907.9)
		event.move_camera_sequence_eased(-372.94, 22.65, 1090.93, -287.43, 73.81, 850.46, 60, 0, 1.0)
		event.set_object_sequence_motion(2, "飛び", 6)
		event.queue_object_sequence_next_motion(2, "飛びから立ち", 6)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		event.delay_object_sequence_sound_track(2, 24)
		event.play_object_sequence_sound(2, var3, 2)
		event.delay_object_sequence_sound_track(2, 34)
		event.play_object_sequence_sound(2, var3, 2)
		event.delay_object_sequence_sound_track(2, 34)
		event.play_object_sequence_sound(2, var3, 2)
		event.move_object_sequence(1, -338.5, 0.26, 920.0, 30)
		event.set_object_sequence_motion(1, "歩き", 4)
		event.delay_object_sequence_motion_track(1, 30)
		event.set_object_sequence_motion(1, "立ち")
		do
			local out1, out2, out3 = event.copy_vector(-116.0, 316.0, 235.0)
			var4 = out1 or var4
			var5 = out2 or var5
			var6 = out3 or var6
		end
		do
			local out1, out2, out3 = event.copy_vector(-1.6666666, -3.8, 5.0)
			var7 = out1 or var7
			var8 = out2 or var8
			var9 = out3 or var9
		end
		do
			local out1, out2, out3 = event.copy_vector(0.0, 0.03, 0.0)
			vector_x = out1 or vector_x
			vector_y = out2 or vector_y
			vector_z = out3 or vector_z
		end
		var13 = 0
		while var13 < 120 do
			do
				local out1, out2, out3 = event.add_vectors(var4, var5, var6, var7, var8, var9)
				var4 = out1 or var4
				var5 = out2 or var5
				var6 = out3 or var6
			end
			do
				local out1, out2, out3 = event.add_vectors(var7, var8, var9, vector_x, vector_y, vector_z)
				var7 = out1 or var7
				var8 = out2 or var8
				var9 = out3 or var9
			end
			event.set_object_handle_position(2, var4, var5, var6)
			var13 = var13 + 1
			at = 6
			vm.wait(6)
		end
		at = 7
		wait_camera()
		event.set_camera_sequence_position(-344.6, 67.67, 922.14)
		event.set_camera_sequence_look_at(-336.45, 57.21, 848.5)
		event.move_camera_sequence_eased(-344.6, 67.67, 922.14, -336.45, 87.1, 848.5, 30, 2, 1.0)
		event.play_sound_effect(var3, 3)
		event.set_object_sequence_position(2, -329.15, 98.27, 784.46)
		event.set_object_sequence_rotation(2, 0.0, -0.12, 0.0)
		event.move_object_sequence(2, -334.07, 73.0, 828.92, 20)
		event.set_object_sequence_motion(0, "上向くL", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "上向くL", 4, -1.0, 1)
		at = 8
		wait_camera()
		at = 9
		wait_frames(30)
		event.set_camera_sequence_position(-298.63, 146.76, 823.22)
		event.set_camera_sequence_look_at(-350.98, 51.79, 864.8)
		event.set_object_sequence_motion(0, "上向く会話", 6)
		event.queue_object_sequence_next_motion(0, "上向くL", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 10
		helper_4116e6bb(3120010)
		at = 11
		wait_objects(0)
		event.set_camera_sequence_position(-353.63, 9.34, 984.37)
		event.set_camera_sequence_look_at(-341.08, 50.88, 864.19)
		event.set_object_sequence_motion(2, "ん？", 2)
		event.queue_object_sequence_next_motion(2, "ん？L", 4)
		at = 12
		helper_4116e6bb(3120020)
		at = 13
		wait_objects(2)
		event.move_camera_sequence_eased(-357.36, 10.22, 1020.11, -341.08, 44.79, 864.19, 30, 0, 1.0)
		event.set_object_sequence_motion(0, "上向く会話", 6)
		event.queue_object_sequence_next_motion(0, "上向くL", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 14
		helper_4116e6bb(3120030)
		at = 15
		wait_camera()
		at = 16
		wait_objects(0)
		event.set_object_sequence_motion(2, "ん？戻り", 2)
		event.queue_object_sequence_next_motion(2, "上見る", 6)
		event.queue_object_sequence_next_motion(2, "上見るL", 4)
		at = 17
		helper_4116e6bb(3120040)
		at = 18
		wait_objects(2)
		event.set_camera_sequence_position(-329.49, 29.05, 893.39)
		event.set_camera_sequence_look_at(-347.8, 20.91, 923.24)
		at = 19
		wait_frames(60)
		event.set_camera_sequence_position(-357.36, 10.22, 1020.11)
		event.set_camera_sequence_look_at(-341.08, 44.79, 864.19)
		event.set_object_sequence_motion(2, "上見る戻り", 2)
		event.queue_object_sequence_next_motion(2, "首ふる", 6)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		at = 20
		wait_frames(10)
		event.delay_object_sequence_motion_track(0, 40)
		event.set_object_sequence_motion(0, "がっかり", 6)
		event.queue_object_sequence_next_motion(0, "がっかりL", 4)
		event.delay_object_sequence_sound_track(0, 48)
		event.play_object_sequence_sound(0, var3, 4)
		event.delay_object_sequence_motion_track(1, 40)
		event.set_object_sequence_motion(1, "がっかり", 6)
		event.queue_object_sequence_next_motion(1, "がっかりＬ", 4)
		at = 21
		helper_4116e6bb(3120045)
		at = 22
		wait_objects(2)
		at = 23
		wait_objects(0)
		at = 24
		wait_objects(1)
		event.set_camera_sequence_position(-321.89, 23.1, 893.12)
		event.set_camera_sequence_look_at(-338.41, 22.0, 915.41)
		event.set_object_sequence_motion(0, "上向くL", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "上向く会話", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(1, "上向くL", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 25
		helper_4116e6bb(3120050)
		at = 26
		wait_objects(1)
		event.set_camera_sequence_position(-304.1, 27.73, 913.73)
		event.set_camera_sequence_look_at(-351.1, 29.34, 911.38)
		event.set_object_sequence_position(2, -334.88, 22.14, 859.84)
		event.move_object_sequence_eased(2, -335.92, 5.76, 880.52, 20, 2, 0.5)
		event.set_mouth_motions(2, "会話２", 0, "立ち", 0)
		at = 27
		helper_4116e6bb(3120060)
		at = 28
		wait_objects(2)
		event.set_object_sequence_motion(2, "そっぽ向く", 6)
		event.queue_object_sequence_next_motion(2, "そっぽ向くL", 4)
		at = 29
		helper_4116e6bb(3120065)
		at = 30
		wait_objects(2)
		event.set_camera_sequence_position(-321.89, 23.1, 893.12)
		event.set_camera_sequence_look_at(-338.41, 22.0, 915.41)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 31
		helper_4116e6bb(3120070)
		event.set_camera_sequence_position(-306.68, 100.95, 835.19)
		event.set_camera_sequence_look_at(-288.49, 105.02, 752.73)
		event.set_object_sequence_position(2, -334.07, 73.0, 828.92)
		event.set_object_sequence_rotation(2, 0.0, 1.08, 0.0)
		event.set_object_sequence_motion(2, "指さす", 6)
		event.queue_object_sequence_next_motion(2, "指さすL", 4)
		event.delay_object_sequence_sound_track(2, 10)
		event.play_object_sequence_sound(2, var3, 5)
		at = 32
		helper_4116e6bb(3120080)
		at = 33
		wait_objects(2)
		event.play_sound_effect(var3, 6)
		event.move_camera_sequence_eased(-74.58, 155.23, -161.7, -56.39, 159.31, -244.16, 60, 2, 1.0)
		at = 34
		helper_4116e6bb(3120085)
		at = 35
		helper_4116e6bb(3120090)
		event.stop_sound_effect(var3, 6)
		event.set_camera_sequence_position(-338.06, 23.01, 898.47)
		event.set_camera_sequence_look_at(-338.41, 23.92, 922.33)
		event.play_sound_effect(var3, 7)
		event.set_object_sequence_motion(0, "立ち", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "会話", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 36
		helper_4116e6bb(3120100)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 37
		helper_4116e6bb(3120105)
		at = 38
		wait_objects(1)
		event.move_camera_sequence_eased(-356.43, 23.01, 899.96, -354.36, 23.92, 923.72, 20, 0, 1.0)
		event.delay_object_sequence_motion_track(0, 10)
		event.set_object_sequence_motion(0, "右向く", 6)
		event.queue_object_sequence_next_motion(0, "右向くL", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 39
		helper_4116e6bb(3120110)
		at = 40
		wait_objects(0)
		at = 41
		wait_camera()
		event.set_camera_sequence_position(-354.94, 23.0, 917.61)
		event.set_camera_sequence_look_at(-338.71, 23.0, 919.34)
		event.move_camera_sequence_eased(-365.44, 23.0, 916.48, -338.71, 23.0, 919.34, 40, 2, 1.0)
		event.set_character_active(0, var1)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 42
		helper_4116e6bb(3120120)
		at = 43
		wait_camera()
		event.play_sound_effect(var3, 8)
		event.set_object_sequence_motion(1, "左向く", 6)
		event.queue_object_sequence_next_motion(1, "左向くL", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 44
		helper_4116e6bb(3120130)
		at = 45
		wait_objects(1)
		event.set_camera_sequence_position(-326.56, 30.19, 903.79)
		event.set_camera_sequence_look_at(-350.3, 22.41, 925.37)
		event.set_object_sequence_rotation(0, 0.0, 1.7, 0.0)
		event.set_object_sequence_motion(0, "モニカ見立ち", 4, -1.0, 1)
		event.set_object_sequence_rotation(1, 0.0, -1.82, 0.0)
		event.set_object_sequence_motion(1, "立ち", 4, -1.0, 1)
		event.set_character_active(var1)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 46
		helper_4116e6bb(3120140)
		event.move_camera_sequence_eased(-305.69, 31.41, 884.81, -350.3, 12.85, 925.37, 40, 0, 1.0)
		event.set_object_sequence_motion(1, "会話", 2)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 47
		helper_4116e6bb(3120150)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 48
		helper_4116e6bb(3120155)
		at = 49
		wait_objects(1)
		event.delay_object_sequence_motion_track(0, 10)
		event.set_object_sequence_motion(0, "左上を見る", 6)
		event.queue_object_sequence_next_motion(0, "左上を見るL", 4)
		event.delay_object_sequence_motion_track(1, 18)
		event.set_object_sequence_motion(1, "右上見る", 2)
		event.queue_object_sequence_next_motion(1, "右上見るＬ", 4)
		at = 50
		helper_4116e6bb(3120160)
		at = 51
		wait_objects(0)
		at = 52
		wait_objects(1)
		event.set_camera_sequence_position(-321.16, 73.7, 923.06)
		event.set_camera_sequence_look_at(-335.4, 87.64, 848.65)
		event.set_object_sequence_position(2, -334.07, 73.0, 828.92)
		event.set_object_sequence_rotation(2, 0.0, -0.12, 0.0)
		event.set_object_sequence_motion(2, "会話", 6)
		event.queue_object_sequence_next_motion(2, "会話２", 6, 0.6)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		at = 53
		helper_4116e6bb(3120164)
		at = 54
		wait_objects(2)
		event.set_mouth_motions(2, "会話２", 0, "立ち", 0)
		at = 55
		helper_4116e6bb(3120168)
		event.set_camera_sequence_position(-305.69, 31.41, 884.81)
		event.set_camera_sequence_look_at(-350.3, 12.85, 925.37)
		event.set_mouth_texture_animations(0, "わらい口パク")
		at = 56
		helper_4116e6bb(3120170)
		event.set_object_sequence_motion(0, "左上を見る戻り", 2)
		event.queue_object_sequence_next_motion(0, "モニカ見立ち", 4)
		event.delay_object_sequence_motion_track(1, 10)
		event.set_object_sequence_motion(1, "右上見るもどり", 2)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 57
		helper_4116e6bb(3120175)
		at = 58
		wait_objects(0)
		at = 59
		wait_objects(1)
		event.set_object_sequence_motion(1, "考えるうつむき", 2)
		event.queue_object_sequence_next_motion(1, "考えるうつむきＬ", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 60
		helper_4116e6bb(3120180)
		at = 61
		wait_objects(1)
		at = 62
		wait_frames(60)
		event.set_object_sequence_motion(1, "考えから待ったへ", 2)
		event.queue_object_sequence_next_motion(1, "考えから待ったへＬ", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 63
		helper_4116e6bb(3120184)
		at = 64
		wait_objects(1)
		event.delay_object_sequence_sound_track(0, 36)
		event.play_object_sequence_sound(0, var3, 9)
		event.set_object_sequence_motion(1, "考えから待ったへもどり", 2)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.delay_object_sequence_motion_track(1, 1)
		event.set_object_sequence_motion(1, "歩き")
		at = 65
		wait_objects(1)
		event.move_object_sequence_eased(1, -325.31, 0.52, 964.6, 30, 1, 1.0)
		event.rotate_object_sequence(1, 0.0, 0.1, 0.0, 10)
		at = 66
		wait_objects(1)
		event.set_camera_sequence_position(-344.31, 18.43, 930.21)
		event.set_camera_sequence_look_at(-293.44, 28.21, 993.72)
		event.set_object_sequence_position(1, -323.37, 0.45, 957.16)
		event.set_object_sequence_rotation(1, 0.0, 1.0, 0.0)
		event.move_object_sequence(1, -250.24, 0.82, 1003.33, 60)
		event.reset_object_sequence_dynamic_animation(1)
		event.delay_object_sequence_motion_track(1, 60)
		event.set_object_sequence_motion(1, "立ち")
		event.delay_object_sequence_motion_track(1, 4)
		event.set_object_sequence_motion(1, "左向く", 6)
		event.queue_object_sequence_next_motion(1, "左向く戻り", 4)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		at = 67
		wait_objects(1)
		at = 68
		wait_frames(4)
		event.set_object_sequence_motion(1, "歩き", 4)
		event.move_object_sequence(1, -253.1, 0.75, 1044.91, 40)
		event.rotate_object_sequence(1, 0.0, -0.07, 0.0, 8)
		event.clear_object_sequence_path(1)
		event.set_object_sequence_path_frames(1, 160)
		event.add_object_sequence_path_point(1, -253.1, 0.75, 1044.91)
		event.add_object_sequence_path_point(1, -254.79, 5.38, 1089.94)
		event.add_object_sequence_path_point(1, -256.86, 18.37, 1140.0)
		event.add_object_sequence_path_point(1, -237.68, 31.31, 1196.62)
		event.add_object_sequence_path_point(1, -191.4, 36.23, 1217.18)
		event.start_object_sequence_path(1, 1)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 69
		helper_1584c528(3120188, 160)
		at = 70
		wait_objects(1)
		event.set_camera_sequence_position(-147.43, 50.34, 1206.83)
		event.set_camera_sequence_look_at(-186.15, 57.43, 1217.59)
		event.set_object_sequence_motion(1, "立ち", 4, -1.0, 1)
		event.set_mouth_texture_animations(1, "わらい口パク")
		at = 71
		helper_4116e6bb(3120190)
		event.set_object_sequence_motion(1, "走り")
		event.move_object_sequence(1, -150.87, 40.35, 1232.05, 20)
		at = 72
		wait_objects(1)
		event.set_camera_sequence_position(2.14, 80.3, 1354.88)
		event.set_camera_sequence_look_at(-0.07, 78.68, 1304.82)
		event.move_camera_sequence_eased(0.83, 65.77, 1325.2, -0.07, 67.0, 1304.82, 160, 2, 1.0)
		event.play_sound_effect(var3, 10)
		event.set_object_sequence_position(1, 11.14, 63.15, 1259.88)
		event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
		event.reset_object_sequence_dynamic_animation(1)
		event.move_object_sequence(1, 11.14, 63.15, 1292.94, 12)
		event.delay_object_sequence_rotation_track(1, 6)
		event.rotate_object_sequence(1, 0.0, -0.81, 0.0, 6)
		event.delay_object_sequence_motion_track(1, 12)
		event.set_object_sequence_motion(1, "立ち")
		event.delay_object_sequence_motion_track(1, 6)
		event.set_object_sequence_motion(1, "下を見る", 6)
		event.queue_object_sequence_next_motion(1, "下を見るL", 4)
		event.set_object_sequence_position(0, -42.37, 55.86, 1225.46)
		event.set_object_sequence_rotation(0, 0.0, 0.5, 0.0)
		event.set_object_sequence_motion(0, "走り", 4, -1.0, 1)
		event.move_object_sequence(0, -8.78, 62.88, 1292.68, 30, 1)
		event.delay_object_sequence_motion_track(0, 30)
		event.set_object_sequence_motion(0, "立ち")
		at = 73
		wait_objects(1)
		at = 74
		wait_frames(6)
		event.set_object_sequence_motion(0, "下を見る", 6)
		event.queue_object_sequence_next_motion(0, "下を見るL", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 75
		helper_1584c528(3120195, 40)
		at = 76
		wait_objects(0)
		event.set_object_sequence_motion(1, "下を見る会話", 2)
		event.queue_object_sequence_next_motion(1, "下を見るL", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 77
		helper_4116e6bb(3120200)
		at = 78
		wait_objects(1)
		at = 79
		wait_camera()
		event.stop_sound_effect(var3, 10)
		event.set_camera_sequence_position(2.14, 80.3, 1354.88)
		event.set_camera_sequence_look_at(-0.07, 78.68, 1304.82)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 80
		helper_4116e6bb(3120210)
		event.set_camera_sequence_position(-25.77, 92.07, 1321.59)
		event.set_camera_sequence_look_at(2.71, 81.81, 1288.92)
		event.set_object_sequence_rotation(1, 0.0, -0.09, 0.0)
		event.set_object_sequence_motion(1, "下を見る戻り", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(1, "右向く", 6)
		event.queue_object_sequence_next_motion(1, "右向くL", 4)
		event.set_object_sequence_rotation(0, 0.0, 0.14, 0.0)
		event.reset_object_sequence_dynamic_animation(0)
		event.delay_object_sequence_motion_track(0, 10)
		event.set_object_sequence_motion(0, "下を見る戻り", 2)
		event.queue_object_sequence_next_motion(0, "左向く", 6)
		event.queue_object_sequence_next_motion(0, "左向くL", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 81
		helper_4116e6bb(3120220)
		at = 82
		wait_objects(1)
		event.set_camera_sequence_position(2.14, 80.3, 1354.88)
		event.set_camera_sequence_look_at(-0.07, 78.68, 1304.82)
		event.set_object_sequence_motion(1, "右向く会話", 6)
		event.queue_object_sequence_next_motion(1, "右向くL", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 83
		helper_4116e6bb(3120230)
		at = 84
		wait_objects(1)
		event.fade_out_screen(30)
		at = 85
		wait_frames(30)
	end, function(received: { any }): boolean
		if at <= 1 then
			wait_frames_skipping(6)
		end
		if at <= 2 then
			wait_frames_skipping(2)
		end
		if at <= 3 then
			wait_frames_skipping(6)
		end
		if at <= 4 then
			wait_frames_skipping(30)
		end
		if at <= 5 then
			var13 = 0
			local _ = var13 < 120
			var13 = var13 + 1
		end
		if at <= 6 then
			helper_344d6cd8()
		end
		if at <= 7 then
			helper_344d6cd8()
		end
		if at <= 8 then
			wait_frames_skipping(30)
		end
		if at <= 9 then
			helper_8cd371d7(3120010)
		end
		if at <= 10 then
			helper_238b5abc(0)
		end
		if at <= 11 then
			helper_8cd371d7(3120020)
		end
		if at <= 12 then
			helper_238b5abc(2)
		end
		if at <= 13 then
			helper_8cd371d7(3120030)
		end
		if at <= 14 then
			helper_344d6cd8()
		end
		if at <= 15 then
			helper_238b5abc(0)
		end
		if at <= 16 then
			helper_8cd371d7(3120040)
		end
		if at <= 17 then
			helper_238b5abc(2)
		end
		if at <= 18 then
			wait_frames_skipping(60)
		end
		if at <= 19 then
			wait_frames_skipping(10)
		end
		if at <= 20 then
			helper_8cd371d7(3120045)
		end
		if at <= 21 then
			helper_238b5abc(2)
		end
		if at <= 22 then
			helper_238b5abc(0)
		end
		if at <= 23 then
			helper_238b5abc(1)
		end
		if at <= 24 then
			helper_8cd371d7(3120050)
		end
		if at <= 25 then
			helper_238b5abc(1)
		end
		if at <= 26 then
			helper_8cd371d7(3120060)
		end
		if at <= 27 then
			helper_238b5abc(2)
		end
		if at <= 28 then
			helper_8cd371d7(3120065)
		end
		if at <= 29 then
			helper_238b5abc(2)
		end
		if at <= 30 then
			helper_8cd371d7(3120070)
		end
		if at <= 31 then
			helper_8cd371d7(3120080)
		end
		if at <= 32 then
			helper_238b5abc(2)
		end
		if at <= 33 then
			helper_8cd371d7(3120085)
		end
		if at <= 34 then
			helper_8cd371d7(3120090)
		end
		if at <= 35 then
			helper_8cd371d7(3120100)
		end
		if at <= 36 then
			helper_8cd371d7(3120105)
		end
		if at <= 37 then
			helper_238b5abc(1)
		end
		if at <= 38 then
			helper_8cd371d7(3120110)
		end
		if at <= 39 then
			helper_238b5abc(0)
		end
		if at <= 40 then
			helper_344d6cd8()
		end
		if at <= 41 then
			helper_8cd371d7(3120120)
		end
		if at <= 42 then
			helper_344d6cd8()
		end
		if at <= 43 then
			helper_8cd371d7(3120130)
		end
		if at <= 44 then
			helper_238b5abc(1)
		end
		if at <= 45 then
			helper_8cd371d7(3120140)
		end
		if at <= 46 then
			helper_8cd371d7(3120150)
		end
		if at <= 47 then
			helper_8cd371d7(3120155)
		end
		if at <= 48 then
			helper_238b5abc(1)
		end
		if at <= 49 then
			helper_8cd371d7(3120160)
		end
		if at <= 50 then
			helper_238b5abc(0)
		end
		if at <= 51 then
			helper_238b5abc(1)
		end
		if at <= 52 then
			helper_8cd371d7(3120164)
		end
		if at <= 53 then
			helper_238b5abc(2)
		end
		if at <= 54 then
			helper_8cd371d7(3120168)
		end
		if at <= 55 then
			helper_8cd371d7(3120170)
		end
		if at <= 56 then
			helper_8cd371d7(3120175)
		end
		if at <= 57 then
			helper_238b5abc(0)
		end
		if at <= 58 then
			helper_238b5abc(1)
		end
		if at <= 59 then
			helper_8cd371d7(3120180)
		end
		if at <= 60 then
			helper_238b5abc(1)
		end
		if at <= 61 then
			wait_frames_skipping(60)
		end
		if at <= 62 then
			helper_8cd371d7(3120184)
		end
		if at <= 63 then
			helper_238b5abc(1)
		end
		if at <= 64 then
			helper_238b5abc(1)
		end
		if at <= 65 then
			helper_238b5abc(1)
		end
		if at <= 66 then
			helper_238b5abc(1)
		end
		if at <= 67 then
			wait_frames_skipping(4)
		end
		if at <= 68 then
			helper_52aadc70(3120188, 160)
		end
		if at <= 69 then
			helper_238b5abc(1)
		end
		if at <= 70 then
			helper_8cd371d7(3120190)
		end
		if at <= 71 then
			helper_238b5abc(1)
		end
		if at <= 72 then
			helper_238b5abc(1)
		end
		if at <= 73 then
			wait_frames_skipping(6)
		end
		if at <= 74 then
			helper_52aadc70(3120195, 40)
		end
		if at <= 75 then
			helper_238b5abc(0)
		end
		if at <= 76 then
			helper_8cd371d7(3120200)
		end
		if at <= 77 then
			helper_238b5abc(1)
		end
		if at <= 78 then
			helper_344d6cd8()
		end
		if at <= 79 then
			helper_8cd371d7(3120210)
		end
		if at <= 80 then
			helper_8cd371d7(3120220)
		end
		if at <= 81 then
			helper_238b5abc(1)
		end
		if at <= 82 then
			helper_8cd371d7(3120230)
		end
		if at <= 83 then
			helper_238b5abc(1)
		end
		if at <= 84 then
			wait_frames_skipping(30)
		end
		return true
	end)
	at = 86
	vm.entry(86)
	event.cancel_drama_scene_skip()
	event.stop_sound_effect(var3, 0)
	event.stop_sound_effect(var3, 6)
	event.stop_sound_effect(var3, 10)
	event.set_scene_status_flags(1, 0, 256, 0)
	event.delete_character_extension_packs(0)
	event.delete_character_extension_packs(13)
	event.delete_character(16)
	event.delete_character(17)
	event.load_message_file(0, -1)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_character_active(0)
	event.set_character_position(0, -25.0, 62.7, 1285.3)
	event.set_character_rotation(0, 0.0, 3.14, 0.0)
	event.set_character_motion(0, "立ち", 4)
	event.update_character_motion(0)
	event.reset_character_cloth_and_hair(0)
	event.set_character_active(13)
	event.set_character_position(13, 68.04, 41.85, 1180.61)
	event.set_character_rotation(13, 0.0, 3.14, 0.0)
	event.set_character_motion(13, "立ち", 4)
	event.update_character_motion(13)
	event.reset_character_cloth_and_hair(13)
	event.set_camera_look_at(-25.0, 92.7, 1285.3)
	event.set_camera_position(-25.0, 102.7, 1385.3)
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
	event.finish_event()
end

return helper_adcd807d
