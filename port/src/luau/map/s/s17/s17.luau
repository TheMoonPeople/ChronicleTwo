--!strict
-- map/s/s17/s17.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local close_message = require("@lib/event/close_message")
local helper_0382f327 = require("@lib/event/helper_0382f327")
local helper_038a2e4d = require("@lib/event/helper_038a2e4d")
local helper_0d9fb41f = require("@lib/event/helper_0d9fb41f")
local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_1a7fd8eb = require("@lib/event/helper_1a7fd8eb")
local helper_1e55e9a8 = require("@lib/event/helper_1e55e9a8")
local helper_22878665 = require("@lib/event/helper_22878665")
local helper_22d6eddc = require("@lib/event/helper_22d6eddc")
local helper_238b5abc = require("@lib/event/helper_238b5abc")
local helper_249b75d1 = require("@lib/event/helper_249b75d1")
local helper_250612f7 = require("@lib/event/helper_250612f7")
local helper_344d6cd8 = require("@lib/event/helper_344d6cd8")
local helper_39ab7f1f = require("@lib/event/helper_39ab7f1f")
local helper_39af59c5 = require("@lib/event/helper_39af59c5")
local helper_4116e6bb = require("@lib/event/helper_4116e6bb")
local helper_42079db3 = require("@lib/event/helper_42079db3")
local helper_479dc9e9 = require("@lib/event/helper_479dc9e9")
local helper_47b9f5b8 = require("@lib/event/helper_47b9f5b8")
local helper_4b10efff = require("@lib/event/helper_4b10efff")
local helper_53ffe901 = require("@lib/event/helper_53ffe901")
local helper_5ac4b36d = require("@lib/event/helper_5ac4b36d")
local helper_6813499c = require("@lib/event/helper_6813499c")
local helper_75684dd8 = require("@lib/event/helper_75684dd8")
local helper_786b79f1 = require("@lib/event/helper_786b79f1")
local helper_79d90c82 = require("@lib/event/helper_79d90c82")
local helper_8132d034 = require("@lib/event/helper_8132d034")
local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")
local helper_8cd371d7 = require("@lib/event/helper_8cd371d7")
local helper_9cbdc640 = require("@lib/event/helper_9cbdc640")
local helper_b55f37c0 = require("@lib/event/helper_b55f37c0")
local helper_bac0e30d = require("@lib/event/helper_bac0e30d")
local helper_c2ca38b7 = require("@lib/event/helper_c2ca38b7")
local helper_cc4413ca = require("@lib/event/helper_cc4413ca")
local helper_ce85b54c = require("@lib/event/helper_ce85b54c")
local helper_d16eef1e = require("@lib/event/helper_d16eef1e")
local helper_d61bc810 = require("@lib/event/helper_d61bc810")
local helper_d793ae41 = require("@lib/event/helper_d793ae41")
local helper_d8e14c06 = require("@lib/event/helper_d8e14c06")
local helper_dff48a5c = require("@lib/event/helper_dff48a5c")
local helper_e787350a = require("@lib/event/helper_e787350a")
local helper_ee1c51d0 = require("@lib/event/helper_ee1c51d0")
local helper_f018b3c0 = require("@lib/event/helper_f018b3c0")
local helper_f29372c9 = require("@lib/event/helper_f29372c9")
local helper_fd3a2124 = require("@lib/event/helper_fd3a2124")
local open_message = require("@lib/event/open_message")
local wait_camera = require("@lib/event/wait_camera")
local wait_objects = require("@lib/event/wait_objects")

--- Event 99, which map data, a script or the engine runs by number.
local function event_99() end

--- Helper function.
local function helper_259a4()
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
		helper_fd3a2124(1)
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
		event.load_message_file(0, 5, "e312.txt")
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
		helper_888ab2a3(6)
		if active_chr_no == 0 then
			event.set_character_active(13)
			event.set_character_active(14)
		else
			event.set_character_active(0)
		end
		event.move_object_sequence(1, -338.5, 0.26, 940.0, 10)
		event.set_object_sequence_motion(1, "d03着地", 6)
		at = 3
		helper_888ab2a3(2)
		var14 = event.get_sound_id(1) or var14
		event.play_sound_effect(var14, 3)
		event.play_sound_effect(var14, 2)
		at = 4
		helper_888ab2a3(6)
		event.play_sound_effect(var14, 2)
		at = 5
		helper_888ab2a3(30)
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
		helper_888ab2a3(30)
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
		helper_888ab2a3(60)
		event.set_camera_sequence_position(-357.36, 10.22, 1020.11)
		event.set_camera_sequence_look_at(-341.08, 44.79, 864.19)
		event.set_object_sequence_motion(2, "上見る戻り", 2)
		event.queue_object_sequence_next_motion(2, "首ふる", 6)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		at = 20
		helper_888ab2a3(10)
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
		helper_888ab2a3(60)
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
		helper_888ab2a3(4)
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
		helper_0382f327(3120188, 160)
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
		helper_888ab2a3(6)
		event.set_object_sequence_motion(0, "下を見る", 6)
		event.queue_object_sequence_next_motion(0, "下を見るL", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 75
		helper_0382f327(3120195, 40)
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
		helper_888ab2a3(30)
	end, function(received: { any }): boolean
		if at <= 1 then
			helper_038a2e4d(6)
		end
		if at <= 2 then
			helper_038a2e4d(2)
		end
		if at <= 3 then
			helper_038a2e4d(6)
		end
		if at <= 4 then
			helper_038a2e4d(30)
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
			helper_038a2e4d(30)
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
			helper_038a2e4d(60)
		end
		if at <= 19 then
			helper_038a2e4d(10)
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
			helper_038a2e4d(60)
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
			helper_038a2e4d(4)
		end
		if at <= 68 then
			helper_53ffe901(3120188, 160)
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
			helper_038a2e4d(6)
		end
		if at <= 74 then
			helper_53ffe901(3120195, 40)
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
			helper_038a2e4d(30)
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

--- Helper function.
local function helper_10fb8()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local x_2: f32 = 0
	local y_2: f32 = 0
	local z_2: f32 = 0
	local operand_x: f32 = 0
	local operand_y: f32 = 0
	local operand_z: f32 = 0
	local var11: s32 = 0
	local var12: s32 = 0
	local at: number = 0
	vm.section(function()
		at = 1
		vm.entry(1)
		event.initialize_event()
		event.show_dungeon_status_bar(0, 1.0)
		var0 = event.load_sound_effect_file_2(3803) or var0
		active_chr_no = event.get_playable_character() or active_chr_no
		event.assign_memory_stack(4)
		event.clear_memory_stack(4)
		event.load_character(4, "event/d03/p00_26a.gltf", "info", 8)
		event.set_character_active(8)
		event.attach_object_handle_to_character(1, 8)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		if active_chr_no == 0 then
			event.load_character_motion_pack(5, "event/dng_inout/c01d03gkey.gltf", "info", 0)
		else
			event.load_character_motion_pack(5, "event/dng_inout/c02d03gkey.gltf", "info", 0)
		end
		event.set_character_active(0, 0)
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.attach_object_handle_to_character(2, 1)
		event.attach_object_handle_to_character(3, 2)
		event.set_object_handle_visible(2, 0)
		event.set_object_handle_visible(3, 0)
		event.set_object_handle_position(0, -230.0, 62.1, 1210.0)
		event.set_object_handle_rotation(0, 0.0, 3.14, 0.0)
		event.set_object_handle_motion(0, "立ち", 4)
		event.set_object_handle_position(1, -150.0, 230.0, 1600.0)
		event.set_object_handle_rotation(1, 0.0, 3.14, 0.0)
		event.set_object_handle_motion(1, "飛び", 4)
		event.play_object_sequence_sound(1, var0, 1)
		event.delay_object_sequence_sound_track(1, 34)
		event.play_object_sequence_sound(1, var0, 1)
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(254.65, 473.72, 1588.47)
		event.set_camera_sequence_look_at(-219.14, 62.76, 1197.82)
		event.play_sound_effect(var0, 0)
		event.fade_in_screen(30)
		x = -150.0
		y = 230.0
		z = 1600.0
		x_2 = 0.0
		y_2 = -8.0
		z_2 = -10.0
		operand_x = 0.0
		operand_y = vm.f32(0.2)
		operand_z = 0.0
		var11 = 0
		while var11 < 60 do
			do
				local out1, out2, out3 = event.add_vectors(x, y, z, x_2, y_2, z_2)
				x = out1 or x
				y = out2 or y
				z = out3 or z
			end
			do
				local out1, out2, out3 = event.add_vectors(x_2, y_2, z_2, operand_x, operand_y, operand_z)
				x_2 = out1 or x_2
				y_2 = out2 or y_2
				z_2 = out3 or z_2
			end
			event.set_object_handle_position(1, x, y, z)
			var11 = var11 + 1
			at = 2
			vm.wait(2)
		end
		event.set_character_active(0, 8)
		event.set_camera_sequence_position(-195.61, 36.44, 1206.2)
		event.set_camera_sequence_look_at(-227.63, 40.13, 1199.12)
		event.set_character_active(1, 0)
		event.move_object_sequence(0, -230.0, 32.1, 1200.0, 10)
		event.set_object_sequence_motion(0, "d03着地", 6)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		at = 3
		helper_888ab2a3(8)
		var12 = event.get_sound_id(1) or var12
		event.play_sound_effect(var12, 3)
		event.play_sound_effect(var12, 2)
		at = 4
		wait_objects(0)
		event.fade_out_screen(30)
		at = 5
		helper_888ab2a3(30)
	end, function(received: { any }): boolean
		if at <= 1 then
			x = -150.0
			y = 230.0
			z = 1600.0
			x_2 = 0.0
			y_2 = -8.0
			z_2 = -10.0
			operand_x = 0.0
			operand_y = vm.f32(0.2)
			operand_z = 0.0
			var11 = 0
			local _ = var11 < 60
			var11 = var11 + 1
		end
		if at <= 2 then
			helper_038a2e4d(8)
		end
		if at <= 3 then
			helper_238b5abc(0)
		end
		if at <= 4 then
			helper_038a2e4d(30)
		end
		return true
	end)
	at = 6
	vm.entry(6)
	event.cancel_drama_scene_skip()
	event.stop_sound_effect(var0, 0)
	event.delete_character_extension_packs(0)
	event.show_dungeon_status_bar(1, 1.0)
	event.set_object_handle_visible(2, 1)
	event.set_object_handle_visible(3, 1)
	event.set_character_active(1, 0)
	event.set_character_active(1, 8)
	event.set_character_position(8, -316.71, 71.94, 806.78)
	event.set_character_rotation(8, 0.0, 2.06, 0.0)
	event.set_character_motion(8, "立ち", 4)
	event.set_character_position(0, -230.0, 32.1, 1200.0)
	event.set_character_rotation(0, 0.0, 3.14, 0.0)
	event.set_character_motion(0, "立ち", 4)
	event.set_camera_look_at(-230.0, 62.1, 1200.0)
	event.set_camera_position(-230.0, 72.1, 1300.0)
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
	event.finish_event()
end

--- Helper function.
local function helper_21eb8()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local x_2: f32 = 0
	local y_2: f32 = 0
	local z_2: f32 = 0
	local operand_x: f32 = 0
	local operand_y: f32 = 0
	local operand_z: f32 = 0
	local var11: s32 = 0
	local var12: s32 = 0
	vm.section(function()
		event.set_save_flag(308, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.show_dungeon_status_bar(0, 1.0)
		var0 = event.load_sound_effect_file_2(3803) or var0
		active_chr_no = event.get_playable_character() or active_chr_no
		event.change_directory("event/e300/e308/")
		event.load_message_file(0, 5, "e308.txt")
		if active_chr_no == 0 then
			event.load_character_motion_pack(5, "e308_mints.gltf", "info", 0)
			event.set_character_active(0, 0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if active_chr_no == 1 then
			event.load_character_motion_pack(5, "e308_monica.gltf", "info", 0)
			event.set_character_active(0, 0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.load_character(5, "p00_24a.gltf", "info", 10)
		event.set_character_active(10)
		event.attach_object_handle_to_character(2, 10)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.set_scene_status_flags(1, 10, 8, 1)
		event.change_directory("")
		event.load_character(5, "event/d03/p00_26a.gltf", "info", 11)
		event.set_character_active(11)
		event.attach_object_handle_to_character(3, 11)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.set_scene_status_flags(1, 11, 8, 1)
		if active_chr_no == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 13)
			event.load_equipment_model(5, 0, 4, "info", 13)
			event.load_equipment_model(5, 0, 3, "info", 13)
			event.load_equipment_model(5, 0, 2, "info", 13, 14)
			event.load_character_motion_pack(5, "event/e300/e308/e308_mints.gltf", "info", 13)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 13)
			event.load_character_motion_pack(5, "event/dng_inout/c01d03gkey.gltf", "info", 13)
			event.attach_object_handle_to_character(0, 13)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 0)
			event.load_character_motion_pack(5, "event/dng_inout/c02d03gkey.gltf", "info", 0)
		else
			event.load_character(5, "chara/c02_base.gltf", "info", 13)
			event.load_equipment_model(5, 1, 4, "info", 13)
			event.load_equipment_model(5, 1, 3, "info", 13)
			event.load_equipment_model(5, 1, 2, "info", 13, 14)
			event.load_character_motion_pack(5, "event/e300/e308/e308_monica.gltf", "info", 13)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 13)
			event.load_character_motion_pack(5, "event/dng_inout/c02d03gkey.gltf", "info", 13)
			event.attach_object_handle_to_character(1, 13)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 0)
			event.load_character_motion_pack(5, "event/dng_inout/c01d03gkey.gltf", "info", 0)
		end
		event.set_character_active(0, 13)
		event.set_character_active(0, 14)
		event.attach_object_handle_to_character(4, 1)
		event.attach_object_handle_to_character(5, 2)
		event.set_object_handle_visible(4, 0)
		event.set_object_handle_visible(5, 0)
		event.set_object_handle_position(0, -230.0, 62.1, 1210.0)
		event.set_object_handle_rotation(0, 0.0, 3.14, 0.0)
		event.set_object_handle_motion(0, "立ち", 4)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(0, 1, "通常目パチ")
		event.set_object_handle_footstep_sound(0, 1)
		event.set_object_handle_position(1, -213.0, 65.619995, 1230.0)
		event.set_object_handle_rotation(1, 0.0, 3.14, 0.0)
		event.set_object_handle_motion(1, "立ち", 4)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(1, 1, "通常目パチ")
		event.set_object_handle_footstep_sound(1, 1)
		event.set_object_handle_position(3, -150.0, 230.0, 1600.0)
		event.set_object_handle_rotation(3, 0.0, 3.14, 0.0)
		event.set_object_handle_motion(3, "飛び", 4)
		event.set_object_handle_position(2, 0.0, 0.0, 0.0)
		event.set_object_handle_motion(2, "立ち", 4)
		event.set_object_handle_sound_bank(2, var0)
		event.set_object_handle_frame_draw_flag(2, "hana", 0)
		event.play_object_sequence_sound(3, var0, 1)
		event.delay_object_sequence_sound_track(3, 34)
		event.play_object_sequence_sound(3, var0, 1)
		event.clear_object_sequence_path(2)
		event.set_object_sequence_path_frames(2, 360)
		event.add_object_sequence_path_point(2, -193.32, 507.72, 144.75)
		event.add_object_sequence_path_point(2, -159.98, 507.72, 220.59)
		event.add_object_sequence_path_point(2, -76.06, 507.72, 268.34)
		event.add_object_sequence_path_point(2, 23.46, 507.72, 253.28)
		event.add_object_sequence_path_point(2, 92.64, 507.72, 174.56)
		event.add_object_sequence_path_point(2, 93.49, 507.72, 66.28)
		event.add_object_sequence_path_point(2, 1.5, 507.72, -7.07)
		event.add_object_sequence_path_point(2, -107.74, 507.72, -27.82)
		event.add_object_sequence_path_point(2, -212.55, 507.72, 43.02)
		event.add_object_sequence_path_point(2, -280.2, 507.72, 145.95)
		event.add_object_sequence_path_point(2, -261.4, 507.72, 250.13)
		event.add_object_sequence_path_point(2, -177.44, 507.72, 302.03)
		event.add_object_sequence_path_point(2, -77.76, 507.72, 299.29)
		event.add_object_sequence_path_point(2, -8.21, 507.72, 209.44)
		event.add_object_sequence_path_point(2, 14.08, 507.72, 94.42)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(254.65, 473.72, 1588.47)
		event.set_camera_sequence_look_at(-219.14, 62.76, 1197.82)
		event.play_sound_effect(var0, 0)
		event.fade_in_screen(30)
		x = -150.0
		y = 230.0
		z = 1600.0
		x_2 = 0.0
		y_2 = -8.0
		z_2 = -10.0
		operand_x = 0.0
		operand_y = vm.f32(0.2)
		operand_z = 0.0
		var11 = 0
		while var11 < 60 do
			do
				local out1, out2, out3 = event.add_vectors(x, y, z, x_2, y_2, z_2)
				x = out1 or x
				y = out2 or y
				z = out3 or z
			end
			do
				local out1, out2, out3 = event.add_vectors(x_2, y_2, z_2, operand_x, operand_y, operand_z)
				x_2 = out1 or x_2
				y_2 = out2 or y_2
				z_2 = out3 or z_2
			end
			event.set_object_handle_position(3, x, y, z)
			var11 = var11 + 1
			vm.wait(1)
		end
		event.set_character_active(0, 11)
		event.set_camera_sequence_position(-184.07, 43.54, 1216.07)
		event.set_camera_sequence_look_at(-236.95, 39.04, 1208.54)
		if active_chr_no == 0 then
			event.set_character_active(0)
		else
			event.set_character_active(13)
			event.set_character_active(14)
		end
		event.move_object_sequence(0, -230.0, 32.1, 1200.0, 10)
		event.set_object_sequence_motion(0, "d03着地", 6)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		helper_888ab2a3(6)
		if active_chr_no == 0 then
			event.set_character_active(13)
			event.set_character_active(14)
		else
			event.set_character_active(0)
		end
		event.move_object_sequence(1, -213.0, 35.19, 1220.0, 10)
		event.set_object_sequence_motion(1, "d03着地", 6)
		helper_888ab2a3(2)
		var12 = event.get_sound_id(1) or var12
		event.play_sound_effect(var12, 3)
		event.play_sound_effect(var12, 2)
		helper_888ab2a3(6)
		event.play_sound_effect(var12, 2)
		helper_888ab2a3(30)
		event.set_camera_sequence_position(-220.28, 65.74, 1289.9)
		event.set_camera_sequence_look_at(-220.42, 54.04, 1203.57)
		event.move_camera_sequence_eased(-220.21, 65.74, 1327.83, -182.37, 80.44, 1173.66, 60, 0, 1.0)
		event.move_object_sequence(1, -213.0, 33.37, 1200.0, 30)
		event.set_object_sequence_motion(1, "歩き", 4)
		event.delay_object_sequence_motion_track(1, 30)
		event.set_object_sequence_motion(1, "立ち")
		wait_camera()
		event.set_camera_sequence_position(-202.75, 44.94, 1163.67)
		event.set_camera_sequence_look_at(-225.81, 55.17, 1208.79)
		event.set_object_sequence_motion(0, "右向く", 6)
		event.queue_object_sequence_next_motion(0, "右向くL", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		helper_4116e6bb(3080010)
		wait_objects(0)
		event.set_object_sequence_texture_animation(1, 1, "通常目～こまり目とじ")
		event.delay_object_sequence_texture_animation_track(1, 30)
		event.set_object_sequence_texture_animation(1, 1, "こまり目とじ～目あけ")
		event.delay_object_sequence_texture_animation_track(1, 30)
		event.set_object_sequence_texture_animation(1, 0, "こまり目とじ～目あけ")
		event.set_object_sequence_motion(1, "会話", 6)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.delay_object_sequence_sound_track(1, 1)
		event.play_object_sequence_sound(1, var0, 3)
		event.set_mouth_texture_animations(1, "通常口パク")
		helper_4116e6bb(3080020)
		wait_objects(1)
		event.set_camera_sequence_position(-218.98, 55.74, 1263.48)
		event.set_camera_sequence_look_at(-222.62, 51.36, 1199.73)
		event.set_object_sequence_motion(0, "立ち", 4, -1.0, 1)
		event.set_mouth_texture_animations(0, "通常口パク")
		helper_4116e6bb(3080030)
		event.move_camera_sequence_eased(-218.17, 55.74, 1293.84, -219.13, 76.78, 1199.61, 60, 0, 1.0)
		event.set_object_sequence_motion(0, "上向く", 6)
		event.queue_object_sequence_next_motion(0, "上向くL", 4)
		event.delay_object_sequence_motion_track(1, 14)
		event.set_object_sequence_motion(1, "上向く", 6)
		event.queue_object_sequence_next_motion(1, "上向くL", 4)
		event.set_object_sequence_motion(2, "飛び", 4)
		event.start_object_sequence_path(2)
		event.play_object_sequence_sound(2, var0, 1)
		event.delay_object_sequence_sound_track(2, 34)
		event.play_object_sequence_sound(2, var0, 1)
		event.delay_object_sequence_sound_track(2, 34)
		event.play_object_sequence_sound(2, var0, 1)
		event.delay_object_sequence_sound_track(2, 34)
		event.play_object_sequence_sound(2, var0, 1)
		event.delay_object_sequence_sound_track(2, 34)
		event.play_object_sequence_sound(2, var0, 1)
		event.delay_object_sequence_sound_track(2, 34)
		event.play_object_sequence_sound(2, var0, 1)
		event.delay_object_sequence_sound_track(2, 34)
		event.play_object_sequence_sound(2, var0, 1)
		event.delay_object_sequence_sound_track(2, 34)
		event.play_object_sequence_sound(2, var0, 1)
		event.delay_object_sequence_sound_track(2, 34)
		event.play_object_sequence_sound(2, var0, 1)
		event.delay_object_sequence_sound_track(2, 34)
		event.play_object_sequence_sound(2, var0, 1)
		event.delay_object_sequence_sound_track(2, 34)
		event.play_object_sequence_sound(2, var0, 1)
		event.delay_object_sequence_sound_track(2, 34)
		event.play_object_sequence_sound(2, var0, 1)
		event.set_mouth_texture_animations(0, "通常口パク")
		helper_0382f327(3080035, 180)
		wait_camera()
		event.fade_out_screen(30)
		helper_888ab2a3(30)
	end)
	event.cancel_drama_scene_skip()
	event.stop_sound_effect(var0, 0)
	event.set_character_active(0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.delete_character_extension_packs(0)
	event.delete_character(13)
	event.delete_character(14)
	event.delete_character(10)
	event.delete_character(11)
	event.load_message_file(0, -1)
	event.show_dungeon_status_bar(1, 1.0)
	event.set_object_handle_visible(4, 1)
	event.set_object_handle_visible(5, 1)
	event.finish_event()
end

--- Helper function.
local function helper_431a4()
	local stage_id: s32 = 0
	local var1: s32 = 0
	local argc: s32 = 0
	stage_id = event.get_dungeon_stage_id() or stage_id
	var1 = event.get_dungeon_floor() or var1
	argc = event.get_dungeon_next_floor(var1, 0) or argc
	event.set_dungeon_floor(argc)
	event.set_dungeon_floor_info(stage_id, var1, 5, 2)
	event.set_dungeon_floor_info(stage_id, argc, 5, 1)
	event.delete_character(8)
	event.delete_character(9)
	event.delete_character(10)
	event.delete_character(11)
	event.delete_character(13)
	event.delete_character(14)
	event.delete_character(15)
	event.initialize_sphida()
	event.set_dungeon_pause_flags(8192, 0)
	event.reset_action_character_motion(0)
	event.set_save_control_bits(1, 0)
	event.set_character_change_unmasked(0, 1)
	event.set_character_change_unmasked(2, 1)
	event.set_character_change_unmasked(1, 1)
	event.set_character_change_unmasked(3, 1)
	event.stop_music(0)
	event.stop_environment_music()
	event.stop_map_object_sounds()
	helper_888ab2a3(6)
	event.load_music(17)
	event.load_map_sounds(3601)
	event.play_music(0)
	event.load_event_script("d03/d03.stb", 1000)
end

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
local function default_event()
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local at: number = 0
	return vm.guard(function()
		flag = event.get_save_flag(300) or flag
		flag_2 = event.get_save_flag(320) or flag_2
		flag_3 = event.get_save_flag(317) or flag_3
		if flag == 1 then
			if flag_2 == 1 then
				if flag_3 == 0 then
					at = 1
					helper_259a4()
					event.clear_local_event_counters()
					event.set_dungeon_pause_flags(8192, 1)
					event.set_character_change_unmasked(0, 1)
					event.set_character_change_unmasked(2, 0)
					event.set_character_change_unmasked(1, 0)
					event.set_character_change_unmasked(3, 0)
					event.set_save_control_bits(1, 1)
				else
					at = 2
					helper_10fb8()
					event.set_function_point_enabled("", "exit", 1)
					event.set_function_point_enabled("", "talk", 0)
					event.attach_object_handle_to_map_part_3(0, "p01_s17", "s17_02-a0_1")
					event.set_object_handle_visible(0, 0)
					event.attach_object_handle_to_map_part_3(0, "p01_s17", "s17_02-c0_1")
					event.set_object_handle_visible(0, 0)
					event.set_function_point_enabled("p01_s17", "invent_30001-0", 0)
					event.set_function_point_enabled("", "branch", 0)
					return
				end
			else
				helper_21eb8()
				at = 4
				helper_431a4()
				return
			end
		else
			event.initialize_event()
			event.set_character_position(0, 0.0, 62.57, 1305.0)
			event.set_character_rotation(0, 0.0, 3.14, 0.0)
			event.set_camera_position(-0.16, 110.89, 1405.0)
			event.set_camera_look_at(0.0, 92.57, 1305.0)
			event.reset_follow_camera(0)
			event.fade_in_screen(30)
			event.finish_event()
		end
		return
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				at = 2
				helper_10fb8()
				return vm.continue_with(function()
					event.set_function_point_enabled("", "exit", 1)
					event.set_function_point_enabled("", "talk", 0)
					event.attach_object_handle_to_map_part_3(0, "p01_s17", "s17_02-a0_1")
					event.set_object_handle_visible(0, 0)
					event.attach_object_handle_to_map_part_3(0, "p01_s17", "s17_02-c0_1")
					event.set_object_handle_visible(0, 0)
					event.set_function_point_enabled("p01_s17", "invent_30001-0", 0)
					event.set_function_point_enabled("", "branch", 0)
					return
				end)
			end
			return 0
		end
		if at <= 4 then
			return 0
		end
		return nil
	end)
end

--- Helper function.
local function helper_2f2d0()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local block: s32 = 0
	local debug_flag: s32 = 0
	local var6: any = 0
	local at: number = 0
	vm.section(function()
		at = 1
		vm.entry(1)
		event.set_save_flag(314, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.switch_dungeon_main_character(0)
		event.set_playable_character(0)
		var0 = event.load_sound_effect_file_2(3809) or var0
		active_chr_no = event.get_playable_character() or active_chr_no
		event.set_scene_status_flags(1, 0, 256, 1)
		if active_chr_no == 0 then
		else
		end
		event.change_directory("event/e300/e314/")
		event.unlock_memory_stack(4)
		event.load_message_file(0, 4, "e314.txt")
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		if active_chr_no == 0 then
			event.load_character_motion_pack(5, "e314_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		block = event.load_event_image_4(5, "e314.json", 1) or block
		event.reset_event_sprite(0)
		event.set_event_sprite_type(0, 0)
		event.set_event_sprite_texture(0, "e31401", block)
		event.set_event_sprite_color(0, 128, 128, 128, 0)
		event.set_event_sprite_texture_rect(0, 0, 0, 512, 448)
		event.set_event_sprite_size(0, 512, 448)
		event.set_event_sprite_position(0, 256, 224)
		event.set_event_sprite_draw_pass(0, 1)
		event.attach_object_handle_to_sprite(2, 0)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.reset_event_sprite(1)
		event.set_event_sprite_type(1, 0)
		event.set_event_sprite_texture(1, "e31402", block)
		event.set_event_sprite_color(1, 128, 128, 128, 0)
		event.set_event_sprite_texture_rect(1, 0, 0, 512, 448)
		event.set_event_sprite_size(1, 512, 448)
		event.set_event_sprite_position(1, 256, 224)
		event.set_event_sprite_draw_pass(1, 1)
		event.attach_object_handle_to_sprite(3, 1)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.reset_event_sprite(2)
		event.set_event_sprite_type(2, 0)
		event.set_event_sprite_texture(2, "e31403", block)
		event.set_event_sprite_color(2, 128, 128, 128, 0)
		event.set_event_sprite_texture_rect(2, 0, 0, 512, 448)
		event.set_event_sprite_size(2, 512, 448)
		event.set_event_sprite_position(2, 256, 224)
		event.set_event_sprite_draw_pass(2, 1)
		event.attach_object_handle_to_sprite(4, 2)
		event.clear_object_sequence(4)
		event.set_object_sequence_object(4, 4)
		event.change_directory("")
		if active_chr_no == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 13)
			event.load_equipment_model(5, 0, 4, "info", 13)
			event.load_equipment_model(5, 0, 3, "info", 13)
			event.load_equipment_model(5, 0, 2, "info", 13, 14)
			event.load_character_motion_pack(5, "event/e300/e314/e314_mints.gltf", "info", 13)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 13)
			event.attach_object_handle_to_character(0, 13)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 0)
		else
			event.load_character_motion_pack(5, "event/e300/e314/e314_monica.gltf", "info", 13)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 13)
			event.attach_object_handle_to_character(1, 13)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 0)
		end
		event.set_character_active(13)
		event.set_character_active(14)
		event.set_object_handle_position(0, 10.0, 40.79, 1150.0)
		event.set_object_handle_rotation(0, 0.0, -1.57, 0.0)
		event.set_object_handle_motion(0, "立ち", 4)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(0, 1, "通常目パチ")
		event.set_object_handle_footstep_sound(0, 1)
		event.set_object_handle_position(1, -10.0, 40.79, 1150.0)
		event.set_object_handle_rotation(1, 0.0, 1.57, 0.0)
		event.set_object_handle_motion(1, "立ち", 4)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(1, 1, "通常目パチ")
		event.set_object_handle_footstep_sound(1, 1)
		debug_flag = event.get_debug_flag() or debug_flag
		if debug_flag ~= 0 then
			event.enable_drama_skip()
		end
		event.clear_camera_sequence()
		event.set_camera_sequence_position(0.0, 62.86, 1089.96)
		event.set_camera_sequence_look_at(0.0, 52.74, 1185.03)
		event.fade_in_screen(30)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 2
		helper_4116e6bb(3140010)
		event.set_object_sequence_motion(1, "歩き")
		event.move_object_sequence(1, -10.0, 40.79, 1200.0, 40, 1)
		event.rotate_object_sequence(1, 0.0, 0.0, 0.0, 10)
		at = 3
		helper_888ab2a3(10)
		event.set_object_sequence_motion(0, "歩き")
		event.move_object_sequence(0, 10.0, 40.79, 1180.0, 30, 1)
		event.rotate_object_sequence(0, 0.0, 0.0, 0.0, 10)
		event.fade_out_screen(30)
		at = 4
		helper_888ab2a3(30)
		at = 5
		wait_objects(0)
		while true do
			event.fade_in_screen(30)
			event.set_message_window_mode(0, 7)
			event.set_object_sequence_motion(1, "歩き")
			event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
			event.reset_object_sequence_dynamic_animation(1)
			event.set_object_sequence_motion(0, "立ち", 4)
			event.set_character_active(0, 0)
			at = 6
			helper_b55f37c0(var0)
			at = 7
			vm.wait(7)
			event.set_message_window_mode(0, 1)
			event.set_message_bubble_tail(0, 0)
			event.open_message_window_2(0, 9000010)
			open_message(0, -1, 5, 0, 0)
			at = 8
			var6 = helper_39af59c5(0, 2, 0, 1)
			event.set_message_bubble_screen_slot(0, 0)
			if var6 == 1 then
				at = 9
				vm.wait(9)
				break
			else
				event.fade_out_screen(30)
				at = 10
				helper_888ab2a3(30)
			end
		end
		event.set_message_window_mode(0, 7)
		event.set_object_sequence_motion(1, "がっつ", 2)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.delay_object_sequence_sound_track(1, 10)
		event.play_object_sequence_sound(1, var0, 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 11
		helper_4116e6bb(3140160)
		event.fade_out_screen(30)
		at = 12
		helper_888ab2a3(30)
	end, function(received: { any }): boolean
		if at == 8 then
			var6 = received[1] :: number
		end
		if at <= 1 then
			helper_8cd371d7(3140010)
		end
		if at <= 2 then
			helper_038a2e4d(10)
		end
		if at <= 3 then
			helper_038a2e4d(30)
		end
		if at <= 4 then
			helper_238b5abc(0)
		end
		if at <= 5 then
			helper_4b10efff(var0)
		end
		if at <= 7 then
			helper_f018b3c0(0, -1, 5, 0, 0)
			var6 = helper_d793ae41(0, 2, 0, 1)
		end
		if at <= 9 then
			helper_038a2e4d(30)
		end
		if at <= 10 then
			helper_8cd371d7(3140160)
		end
		if at <= 11 then
			helper_038a2e4d(30)
		end
		return true
	end)
	at = 13
	vm.entry(13)
	event.cancel_drama_scene_skip()
	event.set_scene_status_flags(1, 0, 256, 0)
	event.delete_character_extension_packs(0)
	event.delete_character_extension_packs(13)
	event.delete_event_image(1)
	event.load_message_file(0, -1)
	event.set_sphida_playing(1)
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
	event.finish_event()
end

--- Helper function.
local function helper_43e18()
	event.initialize_event()
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.set_message_draw_speed(0, 1)
	event.open_message_window_2(
		0,
		"「ショットの流れ」\n１・左スティックの上、下、左、右で打ち出す方向を決める。\n２・(O)ボタンを押して、スイング開始。\n３・(O)ボタンを押して、パワー決定。\n４・(O)ボタンを押して、インパクト。"
	)
	helper_75684dd8(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"「インパクトゾーン」\nパワーゲージの下にある赤いバーがインパクトゾーンです。\nインパクトゾーンの真中でインパクトすると、パワーが\nスフィアにうまく伝わり、ナイスショットとなります。"
	)
	helper_75684dd8(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"インパクトゾーンを外れた場所でインパクトすると、\nミスショットとなり、どこに飛ぶか分かりません。"
	)
	helper_75684dd8(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"「打点の変更」\nインパクトの時に、左スティックを任意の方向に\n倒していると、スフィアの打点を変えられます。\n打点の変更による影響は、次のとおりです。"
	)
	helper_75684dd8(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"上・トップスピンがかかり、転がりやすくなる。\n下・バックスピンがかかり、止まりやすくなる。\n左・スライスがかかり、右に曲がる。\n右・フックがかかり、左に曲がる。"
	)
	helper_75684dd8(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"スフィアが運悪く届かない場所に入り込んでしまったら\n(#)ボタンでスフィアを足元へ移動できます。"
	)
	helper_75684dd8(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"[(!)]メインメニューの『ヘルプ』に\n   「スフィーダ」の項目が追加された。"
	)
	helper_75684dd8(0, -1, 8, 0, 0)
end

--- Helper function.
local function helper_2d65c()
	event.initialize_event()
	event.set_message_window_mode(0, 1)
	event.open_message_window_2(
		0,
		"その辺で手ごろな棒でも見つけてきて。\nそしたら、やり方教えてあげるから。"
	)
	helper_8132d034(13, 9000000)
	event.finish_event()
end

--- Helper function.
local function helper_31830()
	local var0: s32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var8: f32 = 0
	local var11: f32 = 0
	local yaw: f32 = 0
	local yaw_2: f32 = 0
	local var15: any = 0
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		var0 = 13
		event.set_message_window_mode(0, 1)
		event.set_message_bubble_tail(0, 1)
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_handle_footstep_sound(0, 1)
		event.attach_object_handle_to_character(1, var0)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_object_handle_footstep_sound(1, 1)
		do
			local out1, out2, out3 = event.get_character_position(0)
			var1 = out1 or var1
			var2 = out2 or var2
			var3 = out3 or var3
		end
		do
			local _, out2, _ = event.get_character_rotation(0)
			var8 = out2 or var8
		end
		do
			local out1, out2, out3 = event.get_character_position(var0)
			var4 = out1 or var4
			var5 = out2 or var5
			var6 = out3 or var6
		end
		do
			local _, out2, _ = event.get_character_rotation(var0)
			var11 = out2 or var11
		end
		yaw = event.get_direction_angle(var1, var2, var3, var4, var5, var6) or yaw
		yaw_2 = event.get_direction_angle(var4, var5, var6, var1, var2, var3) or yaw_2
		var15 = event.compare_angles(var8, yaw, 0.1) or var15
		if var15 ~= 0 then
			event.rotate_object_sequence(0, 0.0, yaw, 0.0, 10)
			event.set_object_sequence_motion(0, "歩き")
			event.delay_object_sequence_motion_track(0, 10)
		end
		event.set_object_sequence_motion(0, "立ち")
		var15 = event.compare_angles(var11, yaw_2, 0.1) or var15
		if var15 ~= 0 then
			event.rotate_object_sequence(1, 0.0, yaw_2, 0.0, 10)
			event.set_object_sequence_motion(1, "歩き")
			event.delay_object_sequence_motion_track(1, 10)
		end
		event.set_object_sequence_motion(1, "立ち")
		at = 1
		helper_888ab2a3(20)
		event.set_mouth_motions(1, "会話", 0, "立ち", 0)
		event.open_message_window_2(0, "え？\nもしかして、あきらめるの？")
		at = 2
		helper_0ffc2526(0, -1, var0, 0, 0)
		event.set_message_bubble_tail(0, 0)
		event.open_message_window_2(0, "はい\nいいえ")
		open_message(0, -1, 5, 0, 0)
		at = 3
		var15 = helper_39af59c5(0, 2, 1, 0)
		event.set_message_bubble_screen_slot(0, 0)
		event.set_message_bubble_tail(0, 1)
		if var15 == 0 then
			event.fade_out_screen(30)
			at = 4
			helper_888ab2a3(30)
			return 1
		else
			event.open_message_window_2(0, "そうよね。\nがんばって、ユリス！")
			at = 5
			helper_0ffc2526(0, -1, var0, 0, 0)
		end
		var15 = event.compare_angles(var11, yaw_2, 0.1) or var15
		if var15 ~= 0 then
			event.rotate_object_sequence(1, 0.0, var11, 0.0, 10)
			event.set_object_sequence_motion(1, "歩き")
			event.delay_object_sequence_motion_track(1, 10)
		end
		event.set_object_sequence_motion(1, "立ち")
		at = 6
		wait_objects(1)
		return 0
	end, function(received: { any })
		if at <= 4 then
			if at == 3 then
				var15 = received[1] :: number
			end
			if at <= 1 then
				helper_249b75d1(0, -1, var0, 0, 0)
			end
			if at <= 2 then
				helper_f018b3c0(0, -1, 5, 0, 0)
				var15 = helper_d793ae41(0, 2, 1, 0)
			end
			if at <= 3 then
				local _ = var15 ~= 0
				local _ = var15 ~= 0
				helper_038a2e4d(30)
			end
			return 1
		end
		if at <= 6 then
			if at <= 5 then
				helper_238b5abc(1)
			end
			return 0
		end
		return nil
	end)
end

--- Helper function.
local function helper_33434(se_id: s32)
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local var12: f32 = 0
	local var13: s32 = 0
	local var14: f32 = 0
	local var15: f32 = 0
	local var16: f32 = 0
	local var17: f32 = 0
	local var18: f32 = 0
	local var19: f32 = 0
	local var20: s32 = 0
	local var21: f32 = 0
	local var22: f32 = 0
	local var23: f32 = 0
	local var24: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var28: f32 = 0
	local var29: f32 = 0
	local var30: s32 = 0
	local var31: f32 = 0
	local var32: f32 = 0
	local var33: f32 = 0
	local var34: f32 = 0
	local var35: f32 = 0
	local var36: f32 = 0
	local var37: f32 = 0
	local var38: f32 = 0
	local var39: f32 = 0
	local var40: f32 = 0
	local var41: f32 = 0
	local var42: s32 = 0
	local var43: s32 = 0
	local kind: s32 = 0
	local pin_col: s32 = 0
	local ball_col: s32 = 0
	local var47: s32 = 0
	local var48: f32 = 0
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local var52: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	local yaw: f32 = 0
	var5 = vm.f32(-6.051593)
	var5 = event.wrap_angle(var5) or var5
	event.set_camera_control_enabled(1)
	event.set_camera_look_at(-11.1, 88.729996, 1309.96)
	var1 = vm.f32(vm.f32(vm.sin(var5) * 100.0) + vm.f32(-11.1))
	var2 = vm.f32(93.729996)
	var3 = vm.f32(vm.f32(vm.cos(var5) * 100.0) + vm.f32(1309.96))
	event.set_camera_position(var1, var2, var3)
	var5 = vm.f32(-2.91)
	var1 = 0.0
	var2 = vm.f32(65.57)
	var3 = vm.f32(1305.04)
	var12 = -1.0
	do
		local out1, out2, out3 = event.zero_vector()
		var14 = out1 or var14
		var15 = out2 or var15
		var16 = out3 or var16
	end
	do
		local out1, out2, out3 = event.copy_vector(var1, var2, var3)
		var17 = out1 or var17
		var18 = out2 or var18
		var19 = out3 or var19
	end
	var20 = 0
	event.play_sound_effect(se_id, 12)
	var11 = vm.f32(41.8)
	var10 = vm.f32(0.218166)
	var11 = vm.f32(var11 - vm.f32(var11 * var10))
	var21 = vm.f32(vm.sin(var5) * vm.f32(var11 * vm.cos(var10)))
	var22 = vm.f32(var11 * vm.sin(var10))
	var23 = vm.f32(vm.cos(var5) * vm.f32(var11 * vm.cos(var10)))
	var15 = vm.f32(vm.f32(var15 * vm.f32(3.1415927)) / 2.0)
	var16 = vm.f32(vm.f32(vm.f32(-var23 * var12) * var14) * vm.f32(0.4))
	var14 = vm.f32(vm.f32(vm.f32(-var21 * var12) * var14) * vm.f32(0.4))
	do
		local out1, out2, out3 = event.get_sphida_pin_position()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	var28 = 180.0
	var29 = -50.0
	var30 = 0
	var13 = 0
	var43 = 0
	var47 = 0
	while true do
		if var2 >= var28 then
			var21 = vm.f32(var21 * vm.f32(0.999))
			var22 = vm.f32(var22 + vm.f32(vm.f32(-0.0098) * (var47 + 1)))
			var23 = vm.f32(var23 * vm.f32(0.999))
		else
			var42 = event.get_segment_collision_9(12, var1, var2, var3, var1, vm.f32(var2 - 3.0) - vm.f32(0.01), var3, 0)
				or var42
			if var13 == 1 and var42 >= 0 then
				var21 = vm.f32(var21 * vm.f32(0.94))
				var22 = vm.f32(var22 + vm.f32(vm.f32(-0.00045) * (var47 + 1)))
				var23 = vm.f32(var23 * vm.f32(0.94))
				var21 = vm.f32(var21 + var14)
				var23 = vm.f32(var23 + var16)
				var14 = vm.f32(var14 * vm.f32(0.8))
				var16 = vm.f32(var16 * vm.f32(0.8))
			else
				var21 = vm.f32(var21 * vm.f32(0.999))
				var22 = vm.f32(var22 + vm.f32(vm.f32(-0.0045) * (var47 + 1)))
				var23 = vm.f32(var23 * vm.f32(0.999))
			end
		end
		do
			local out1, out2, out3 = event.add_vectors(var1, var2, var3, var21, var22, var23)
			var1 = out1 or var1
			var2 = out2 or var2
			var3 = out3 or var3
		end
		if var15 ~= 0.0 then
			var10 = event.get_direction_angle(var17, var18, var19, var1, var2, var3) or var10
			var10 = vm.f32(var10 + var15)
			var10 = event.wrap_angle(var10) or var10
			var21 = vm.f32(var21 + vm.f32(vm.f32(vm.sin(var10) / 10.0) * var12))
			var23 = vm.f32(var23 + vm.f32(vm.f32(vm.cos(var10) / 10.0) * var12))
		end
		var41 = event.get_vector_length(var14, 0.0, var16) or var41
		if var41 > vm.f32(0.01) then
			var24 = event.get_vector_length(var14, 0.0, var16) or var24
			var10 = event.get_direction_angle(var17, var18, var19, var17 + var14, var18, var19 + var16) or var10
			do
				local out1, out2, out3 = event.get_character_rotation(8)
				var4 = out1 or var4
				var5 = out2 or var5
				var6 = out3 or var6
			end
			event.set_character_rotation(8, var4, var10, var6)
			event.offset_character_rotation(8, var24 * 12.0, 0.0, 0.0)
			event.set_character_rotation(9, var4, var10, var6)
			event.offset_character_rotation(9, var24 * 12.0, 0.0, 0.0)
		else
			var24 = event.get_vector_length(var21, 0.0, var23) or var24
			var10 = event.get_direction_angle(var17, var18, var19, var1, var2, var3) or var10
			do
				local out1, out2, out3 = event.get_character_rotation(8)
				var4 = out1 or var4
				var5 = out2 or var5
				var6 = out3 or var6
			end
			event.set_character_rotation(8, var4, var10, var6)
			event.offset_character_rotation(8, var24 / 10.0, 0.0, 0.0)
			event.set_character_rotation(9, var4, var10, var6)
			event.offset_character_rotation(9, var24 / 10.0, 0.0, 0.0)
		end
		var24 = event.get_vector_length(var21, var22, var23) or var24
		var40 = var24
		var10 = event.get_direction_angle(var17, var18, var19, var1, var2, var3) or var10
		var37 = vm.f32(vm.sin(vm.f32(var10 - vm.f32(1.5707964))) * 3.0)
		var39 = vm.f32(vm.cos(vm.f32(var10 - vm.f32(1.5707964))) * 3.0)
		event.add_sword_afterimage_point(
			var1 - var37,
			var2,
			var3 - var39,
			vm.f32(var1 + var37) + var37,
			var2,
			vm.f32(var3 + var39) + var39
		)
		do
			local out1, out2, out3 = event.copy_vector(var21, var22, var23)
			var37 = out1 or var37
			var38 = out2 or var38
			var39 = out3 or var39
		end
		do
			local out1, out2, out3 = event.normalize_vector(var37, var38, var39)
			var37 = out1 or var37
			var38 = out2 or var38
			var39 = out3 or var39
		end
		do
			local out1, out2, out3 = event.scale_vector(var37, var38, var39, 3.0)
			var37 = out1 or var37
			var38 = out2 or var38
			var39 = out3 or var39
		end
		do
			local out1, out2, out3, out4, out5 =
				event.get_segment_collision_13(0, var17, var18, var19, var1 + var37, var2 + var38, var3 + var39, 0)
			var31 = out1 or var31
			var32 = out2 or var32
			var33 = out3 or var33
			var42 = out4 or var42
			kind = out5 or kind
		end
		if var42 >= 0 and kind == 1 then
			event.create_effect("足水パシャ")
			event.set_effect_first_vector(var31, var32, var33)
			if var43 <= 0 then
				event.play_sound_effect(se_id, 11)
				var43 = 20
			end
		end
		do
			local out1, out2, out3, out4, out5, out6, out7 =
				event.get_segment_collision_15(12, var17, var18, var19, var1 + var37, var2 + var38, var3 + var39, 1)
			var31 = out1 or var31
			var32 = out2 or var32
			var33 = out3 or var33
			var34 = out4 or var34
			var35 = out5 or var35
			var36 = out6 or var36
			var42 = out7 or var42
		end
		while var42 >= 0 do
			var15 = 0.0
			if var24 > 8.0 then
				helper_79d90c82()
			end
			if var43 <= 0 then
				event.play_sound_effect(se_id, 6)
				var43 = 20
			end
			do
				local out1, out2, out3 = event.copy_vector(-var21, -var22, -var23)
				var21 = out1 or var21
				var22 = out2 or var22
				var23 = out3 or var23
			end
			do
				local out1, out2, out3 = event.normalize_vector(var21, var22, var23)
				var21 = out1 or var21
				var22 = out2 or var22
				var23 = out3 or var23
			end
			do
				local out1, out2, out3 = event.scale_vector(var21, var22, var23, 3.0)
				var21 = out1 or var21
				var22 = out2 or var22
				var23 = out3 or var23
			end
			do
				local out1, out2, out3 = event.add_vectors(var31, var32, var33, var21, var22, var23)
				var31 = out1 or var31
				var32 = out2 or var32
				var33 = out3 or var33
			end
			do
				local out1, out2, out3 = event.subtract_vectors(var17, var18, var19, var31, var32, var33)
				var17 = out1 or var17
				var18 = out2 or var18
				var19 = out3 or var19
			end
			var41 = event.get_vector_length(var17, var18, var19) or var41
			var41 = vm.f32(var40 - var41)
			if var41 <= 0.0 then
				break
			else
				var40 = var41
				do
					local out1, out2, out3 = event.copy_vector(-var21, -var22, -var23)
					var21 = out1 or var21
					var22 = out2 or var22
					var23 = out3 or var23
				end
				if var22 < 0.0 and var35 > 0.0 then
					var21 = vm.f32(var14 * 2.0)
					var22 = 0.0
					var23 = vm.f32(var16 * 2.0)
					var14 = vm.f32(var14 * vm.f32(0.2))
					var16 = vm.f32(var16 * vm.f32(0.2))
				else
					if
						var21 < 0.0 and var34 > 0.0
						or var21 > 0.0 and var34 < 0.0
						or var23 < 0.0 and var36 > 0.0
						or var23 > 0.0 and var36 < 0.0
					then
						var14 = 0.0
						var16 = 0.0
					end
					var21 = 0.0
					var22 = 0.0
					var23 = 0.0
				end
				var21 = vm.f32(vm.f32(vm.f32(var34 * var24) * vm.f32(0.9)) + var21)
				var22 = vm.f32(vm.f32(vm.f32(var35 * var24) * vm.f32(0.58)) + var22)
				var23 = vm.f32(vm.f32(vm.f32(var36 * var24) * vm.f32(0.9)) + var23)
				do
					local out1, out2, out3 = event.copy_vector(var31, var32, var33)
					var17 = out1 or var17
					var18 = out2 or var18
					var19 = out3 or var19
				end
				do
					local out1, out2, out3 = event.copy_vector(var21, var22, var23)
					var37 = out1 or var37
					var38 = out2 or var38
					var39 = out3 or var39
				end
				do
					local out1, out2, out3 = event.normalize_vector(var37, var38, var39)
					var37 = out1 or var37
					var38 = out2 or var38
					var39 = out3 or var39
				end
				do
					local out1, out2, out3 = event.scale_vector(var37, var38, var39, 3.0)
					var37 = out1 or var37
					var38 = out2 or var38
					var39 = out3 or var39
				end
				do
					local out1, out2, out3 = event.scale_vector(var34, var35, var36, var41)
					var34 = out1 or var34
					var35 = out2 or var35
					var36 = out3 or var36
				end
				do
					local out1, out2, out3 = event.copy_vector(var31, var32, var33)
					var1 = out1 or var1
					var2 = out2 or var2
					var3 = out3 or var3
				end
				do
					local out1, out2, out3 = event.add_vectors(var1, var2, var3, var34, var35, var36)
					var1 = out1 or var1
					var2 = out2 or var2
					var3 = out3 or var3
				end
				do
					local out1, out2, out3, out4, out5, out6, out7 = event.get_segment_collision_15(
						12,
						var17,
						var18,
						var19,
						var1 + var37,
						var2 + var38,
						var3 + var39,
						1
					)
					var31 = out1 or var31
					var32 = out2 or var32
					var33 = out3 or var33
					var34 = out4 or var34
					var35 = out5 or var35
					var36 = out6 or var36
					var42 = out7 or var42
				end
			end
		end
		do
			local out1, out2, out3, out4, out5, out6, out7, out8 =
				event.get_segment_collision_16(12, var1, var2, var3, var1, var2 - 3.0, var3, 1)
			var31 = out1 or var31
			var32 = out2 or var32
			var33 = out3 or var33
			var34 = out4 or var34
			var35 = out5 or var35
			var36 = out6 or var36
			var42 = out7 or var42
			kind = out8 or kind
		end
		if var42 >= 0 then
			var15 = 0.0
			var2 = vm.f32(var32 + 3.0)
			var41 = event.get_vector_length(var21, 0.0, var23) or var41
			if var41 < vm.f32(2.4) or var22 >= -1.0 and var22 <= 0.0 then
				var22 = 0.0
				var13 = 1
			else
				var21 = vm.f32(var21 * vm.f32(0.9))
				var22 = -vm.f32(var22 * vm.f32(0.58))
				var23 = vm.f32(var23 * vm.f32(0.9))
				var21 = vm.f32(var21 + vm.f32(var14 * 2.0))
				var23 = vm.f32(var23 + vm.f32(var16 * 2.0))
				var14 = vm.f32(var14 * vm.f32(0.2))
				var16 = vm.f32(var16 * vm.f32(0.2))
				if var24 > 8.0 then
					helper_79d90c82()
				end
				if var43 <= 0 then
					event.play_sound_effect(se_id, 5)
					var43 = 20
				end
			end
			var41 = event.get_vector_length(var14, 0.0, var16) or var41
			if var22 == 0.0 and var24 < vm.f32(1.6) and var41 < vm.f32(0.4) then
				if not (kind == 6) then
					break
				end
				var30 = 1
				break
			end
		end
		if var2 < -500.0 then
			var30 = 1
			break
		elseif var47 >= 300 then
			var30 = 1
			break
		else
			pin_col = event.get_sphida_pin_color() or pin_col
			ball_col = event.get_sphida_ball_color() or ball_col
			var48 = 1.0
			x = vm.f32(pos_x - var1)
			y = vm.f32(pos_y - var2)
			z = vm.f32(pos_z - var3)
			var48 = event.get_vector_length(x, y, z) or var48
			if ball_col ~= pin_col then
				var52 = event.get_point_to_segment_distance(var17, var18, var19, var1, var2, var3, pos_x, pos_y, pos_z) or var52
				if var52 >= 0.0 and var52 <= 30.0 then
					var20 = 1
					break
				end
				if var48 ~= 0.0 then
					if var48 <= 120.0 then
						do
							local out1, out2, out3 = event.scale_vector(x, y, z, vm.fdiv(vm.f32(0.6), var48))
							x = out1 or x
							y = out2 or y
							z = out3 or z
						end
						do
							local out1, out2, out3 = event.add_vectors(var1, var2, var3, x, y, z)
							var1 = out1 or var1
							var2 = out2 or var2
							var3 = out3 or var3
						end
						do
							local out1, out2, out3 = event.add_vectors(var21, var22, var23, x, y, z)
							var21 = out1 or var21
							var22 = out2 or var22
							var23 = out3 or var23
						end
					end
				else
					var20 = 1
					break
				end
			elseif var48 ~= 0.0 then
				if var48 <= 60.0 then
					do
						local out1, out2, out3 = event.scale_vector(x, y, z, vm.fdiv(1.0, var48))
						x = out1 or x
						y = out2 or y
						z = out3 or z
					end
					do
						local out1, out2, out3 = event.subtract_vectors(var1, var2, var3, x, y, z)
						var1 = out1 or var1
						var2 = out2 or var2
						var3 = out3 or var3
					end
					do
						local out1, out2, out3 = event.subtract_vectors(var21, var22, var23, x, y, z)
						var21 = out1 or var21
						var22 = out2 or var22
						var23 = out3 or var23
					end
				end
			end
			event.set_character_position(8, var1, var2, var3)
			event.set_character_position(9, var1, var2, var3)
			do
				local out1, out2, out3 = event.copy_vector(var1, var2, var3)
				var17 = out1 or var17
				var18 = out2 or var18
				var19 = out3 or var19
			end
			if var2 <= var29 then
				event.set_follow_camera_following(0)
				if var30 >= 30 then
					if var30 >= 50 then
						break
					end
				else
					event.set_camera_look_at(var1, var2, var3)
				end
				var30 = var30 + 1
			elseif var47 >= 20 then
				event.set_camera_control_enabled(0)
				event.set_follow_camera_following(1)
				event.set_camera_speed(6.0)
				event.set_follow_camera_offset(0.0, 0.0, 0.0)
				do
					local out1, out2, out3 = event.get_camera_position()
					pos_x_2 = out1 or pos_x_2
					pos_y_2 = out2 or pos_y_2
					pos_z_2 = out3 or pos_z_2
				end
				event.set_follow_camera_height(30.0)
				event.set_follow_camera_distance(200.0)
				yaw = event.get_direction_angle(
					vm.f32(var1 + var21) + var21,
					vm.f32(var2 + var22) + var22,
					vm.f32(var3 + var23) + var23,
					pos_x_2,
					pos_y_2,
					pos_z_2
				) or yaw
				event.set_follow_camera_angle(yaw)
				event.set_follow_camera_target_alternate(
					vm.f32(var1 + var21) + var21,
					vm.f32(var2 + var22) + var22,
					vm.f32(var3 + var23) + var23
				)
				event.step_follow_camera(1)
			end
			event.set_sphida_ball_position(var1, var2, var3)
			vm.wait(1)
			if var43 > 0 then
				var43 = var43 - 1
			end
			var47 = var47 + 1
		end
	end
	if var20 ~= 1 then
		helper_888ab2a3(30)
	end
	event.set_character_position(8, var1, var2, var3)
	event.set_character_position(9, var1, var2, var3)
	vm.wait(3)
	event.set_character_active(0, 8)
	event.set_character_active(0, 9)
	event.set_character_active(1, 12)
	event.set_character_position(12, pos_x, pos_y, pos_z)
	event.set_character_motion(12, "発動", 6)
	event.play_sound_effect(se_id, 17)
	var47 = 0
	while var47 < 2 do
		event.set_camera_control_enabled(0)
		event.set_follow_camera_following(1)
		event.set_follow_camera_target_alternate(pos_x, pos_y, pos_z)
		event.set_camera_speed(12.0)
		event.set_follow_camera_offset(0.0, 0.0, 0.0)
		event.set_follow_camera_height(0.0)
		event.set_follow_camera_distance(100.0)
		event.step_follow_camera(1)
		var47 = var47 + 1
		vm.wait(4)
	end
	event.set_character_active(0, 10)
	do
		local out1, out2, out3 = event.get_sphida_pin_position()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	var47 = 0
	while var47 < 100 do
		event.set_camera_control_enabled(0)
		event.set_follow_camera_following(1)
		event.set_follow_camera_target_alternate(pos_x, pos_y, pos_z)
		event.set_camera_speed(12.0)
		event.set_follow_camera_offset(0.0, 0.0, 0.0)
		event.set_follow_camera_height(0.0)
		event.set_follow_camera_distance(100.0)
		event.step_follow_camera(1)
		var47 = var47 + 1
		vm.wait(5)
	end
	event.set_character_active(0, 11)
	helper_888ab2a3(54)
	event.set_camera_control_enabled(1)
	event.set_follow_camera_following(0)
end

--- Helper function.
local function helper_3b604()
	local var0: s32 = 0
	local var1: s32 = 0
	vm.section(function()
		vm.entry(1)
		event.set_save_flag(315, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.stop_music(0)
		helper_888ab2a3(4)
		event.load_music(57)
		event.play_music(0)
		var0 = event.load_sound_effect_file_2(3811) or var0
		var1 = event.load_sound_effect_file_3(5, "snd2/mon/en_900.sound.json") or var1
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.show_dungeon_status_bar(0, 1.0)
		event.get_playable_character()
		event.change_directory("event/e300/e315/")
		event.load_message_file(0, 5, "e315.txt")
		event.load_character_motion_pack(5, "e315_mints.gltf", "info", 0)
		event.set_character_active(0)
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.change_directory("")
		event.load_character(5, "dungeon/sphida/gool_end.gltf", "info", 12)
		event.set_character_active(0, 12)
		event.delete_character_extension_packs(13)
		event.load_character_motion_pack(5, "event/e300/e312/e312_monica.gltf", "info", 13)
		event.load_character_motion_pack(5, "event/e300/e315/e315_monica.gltf", "info", 13)
		event.attach_object_handle_to_character(1, 13)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.create_sword_afterimage(5, 64, 16)
		event.set_sword_afterimage_color(128, 128, 128, 80, 128, 128, 128, 80)
		event.set_object_handle_position(0, -92.27, 48.63, 1283.9)
		event.set_object_handle_rotation(0, 0.0, 1.34, 0.0)
		event.set_object_handle_motion(0, "立ち", 4)
		event.set_character_active(0, 15)
		event.set_character_position(15, 0.0, 0.0, 0.0)
		event.set_character_rotation(15, 0.0, 0.0, 0.0)
		event.attach_character_to_frame(13, "sword_hand", 15)
		event.set_object_handle_position(1, 68.04, 41.85, 1180.61)
		event.set_object_handle_rotation(1, 0.0, 3.14, 0.0)
		event.set_object_handle_motion(1, "立ち", 4)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(1, 1, "通常目パチ")
		event.update_character_motion(13)
		event.reset_character_cloth_and_hair(13)
		event.set_sphida_ball_position(0.0, 65.57, 1305.04)
		event.set_sphida_ball_color(0)
		event.set_character_position(8, 0.0, 65.57, 1305.04)
		event.set_character_active(0, 8)
		event.set_character_position(9, 0.0, 65.57, 1305.04)
		event.set_character_active(1, 9)
		event.set_character_active(0, 0)
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(67.57, 63.38, 1149.74)
		event.set_camera_sequence_look_at(67.85, 63.66, 1179.99)
		event.fade_in_screen(30)
		helper_888ab2a3(30)
		event.play_sound_effect(var0, 0)
		event.set_object_sequence_motion(1, "貸しなさい", 2)
		event.queue_object_sequence_next_motion(1, "貸しなさいＬ", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		helper_4116e6bb(3150010)
		wait_objects(1)
		event.fade_out_screen(30)
		helper_888ab2a3(30)
		event.set_camera_sequence_position(65.27, 79.39, 1297.35)
		event.set_camera_sequence_look_at(6.16, 79.67, 1305.48)
		event.set_character_active(1, 0)
		event.set_object_handle_position(0, -92.27, 48.63, 1283.9)
		event.set_object_handle_rotation(0, 0.0, 1.34, 0.0)
		event.set_object_handle_motion(0, "立ち", 4)
		event.update_character_motion(0)
		event.reset_character_cloth_and_hair(0)
		event.detach_character_from_frame(15)
		event.set_character_active(1, 15)
		event.set_character_position(15, 0.0, 0.0, 0.0)
		event.set_character_rotation(15, 0.0, 0.0, 0.0)
		event.attach_character_to_frame(13, "sword_hand", 15)
		event.set_object_handle_position(1, -11.1, 63.73, 1309.96)
		event.set_object_handle_rotation(1, 0.0, 1.8, 0.0)
		event.set_object_handle_motion(1, "かまえゴルフＬ", 4)
		event.update_character_motion(13)
		event.reset_character_cloth_and_hair(13)
		event.fade_in_screen(30)
		helper_888ab2a3(30)
		event.set_mouth_texture_animations(1, "通常口パク")
		helper_4116e6bb(3150020)
		event.set_object_sequence_motion(1, "前方確認", 2)
		event.queue_object_sequence_next_motion(1, "ショット", 6)
		event.delay_object_sequence_sound_track(1, 10)
		event.play_object_sequence_sound(1, var0, 1)
		event.delay_object_sequence_sound_track(1, 44)
		event.play_object_sequence_sound(1, var0, 2)
		event.delay_object_sequence_sound_track(1, 42)
		event.play_object_sequence_sound(1, var0, 3)
		wait_objects(1)
		helper_888ab2a3(24)
		helper_33434(var1)
		event.set_camera_sequence_position(-88.57, 74.62, 1267.26)
		event.set_camera_sequence_look_at(20.74, 79.67, 1276.18)
		event.set_object_sequence_position(0, -18.67, 62.68, 1288.34)
		event.set_object_sequence_rotation(0, 0.0, -2.66, 0.0)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_object_sequence_position(1, -1.4, 62.34, 1267.0)
		event.set_object_sequence_rotation(1, 0.0, -2.68, 0.0)
		event.set_object_sequence_motion(1, "立ち", 4, -1.0, 1)
		event.set_mouth_texture_animations(1, "通常口パク")
		helper_4116e6bb(3150030)
		event.play_sound_effect(var0, 5)
		event.set_object_sequence_motion(0, "すごいや", 6)
		event.queue_object_sequence_next_motion(0, "すごいやL", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		helper_4116e6bb(3150040)
		wait_objects(0)
		event.fade_out_music(30)
		event.fade_out_screen(30)
		helper_888ab2a3(30)
	end)
	vm.entry(16)
	event.cancel_drama_scene_skip()
	event.stop_music(0)
	event.delete_character_extension_packs(0)
	event.delete_character_extension_packs(13)
	event.set_character_active(0, 8)
	event.set_character_active(0, 9)
	event.set_character_active(0, 10)
	event.set_character_active(0, 11)
	event.set_character_active(0, 12)
	event.detach_character_from_frame(15)
	event.set_character_active(0, 15)
	event.delete_character(12)
	event.load_message_file(0, -1)
	event.finish_event()
end

--- Helper function.
local function helper_3e1dc(arg0: s32)
	local var1: s32 = 0
	local var2: s32 = 0
	local active_chr_no: s32 = 0
	local argc: s32 = 0
	vm.section(function()
		vm.entry(1)
		event.set_save_flag(317, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.stop_music(0)
		helper_888ab2a3(4)
		event.load_music(193)
		event.play_music(1)
		var1 = event.load_sound_effect_file_3(8, "snd2/sp/sp_006.sound.json") or var1
		var2 = event.load_sound_effect_file_2(3817) or var2
		active_chr_no = event.get_playable_character() or active_chr_no
		event.change_directory("event/e300/e317/")
		event.load_message_file(0, 5, "e317.txt")
		if active_chr_no == 0 then
			event.load_character_motion_pack(5, "e317_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		event.load_character(5, "e317_boss.gltf", "info", 15)
		event.set_character_active(15)
		event.attach_object_handle_to_character(2, 15)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.load_character(5, "e317_hana.gltf", "info", 16)
		event.set_character_active(0, 16)
		event.attach_object_handle_to_character(3, 16)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.attach_character_to_frame(0, "item", 16)
		event.change_directory("")
		event.load_item_model(5, arg0, "info", 17)
		event.set_character_active(0, 17)
		event.attach_object_handle_to_character(4, 17)
		event.clear_object_sequence(4)
		event.set_object_sequence_object(4, 4)
		event.load_character(5, "event/itemget_ev/itemget_ev.gltf", "info", 18)
		event.set_character_active(0, 18)
		if active_chr_no == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 13)
			event.load_equipment_model(5, 0, 4, "info", 13)
			event.load_equipment_model(5, 0, 3, "info", 13)
			event.load_equipment_model(5, 0, 2, "info", 13, 14)
			event.load_character_motion_pack(5, "event/e300/e317/e317_mints.gltf", "info", 13)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 13)
			event.attach_object_handle_to_character(0, 13)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
			event.load_character_motion_pack(5, "event/e300/e317/e317_monica.gltf", "info", 0)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 0)
		else
			event.delete_character_extension_packs(13)
			event.load_character_motion_pack(5, "event/e300/e317/e317_monica.gltf", "info", 13)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 13)
			event.attach_object_handle_to_character(1, 13)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 0)
		end
		event.set_character_active(13)
		event.set_character_active(14)
		event.attach_object_handle_to_character(5, 1)
		event.attach_object_handle_to_character(6, 2)
		event.set_object_handle_visible(5, 0)
		event.set_object_handle_visible(6, 0)
		event.set_object_handle_position(0, 10.0, 62.79, 1296.0)
		event.set_object_handle_rotation(0, 0.0, 3.14, 0.0)
		event.set_object_handle_motion(0, "立ち", 4)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(0, 1, "通常目パチ")
		event.set_object_handle_footstep_sound(0, 1)
		event.set_object_handle_position(1, -10.0, 62.79, 1296.0)
		event.set_object_handle_rotation(1, 0.0, 3.14, 0.0)
		event.set_object_handle_motion(1, "立ち", 4)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(1, 1, "通常目パチ")
		event.set_object_handle_footstep_sound(1, 1)
		event.set_object_handle_position(2, -323.0, 73.0, 801.25)
		event.set_object_handle_rotation(2, 0.0, 2.88, 0.0)
		event.set_object_handle_motion(2, "立ち", 4)
		event.set_object_handle_shadow_enabled(2, 0)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "目パチ")
		event.set_object_handle_sound_bank(2, var2)
		event.set_object_handle_frame_draw_flag(2, "hana", 0)
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-270.99, 155.56, 855.04)
		event.set_camera_sequence_look_at(-317.48, 77.29, 790.97)
		event.fade_in_screen(30)
		event.set_mouth_motions(2, "会話２", 0, "立ち", 0)
		helper_4116e6bb(3170010)
		event.play_sound_effect(var2, 0)
		event.set_object_sequence_motion(2, "立ちから飛び", 2)
		event.queue_object_sequence_next_motion(2, "飛び", 4)
		event.delay_object_sequence_position_track(2, 30)
		event.move_object_sequence_eased(2, -292.12, 88.0, 718.16, 40, 1, 1.0)
		wait_objects(2)
		event.set_camera_sequence_position(-173.05, 197.62, 491.25)
		event.set_camera_sequence_look_at(-157.61, 198.62, 397.99)
		event.set_object_sequence_position(2, -257.58, 157.22, 483.43)
		event.move_object_sequence(2, -13.74, 178.47, -571.1, 180)
		helper_888ab2a3(30)
		event.move_camera_sequence_eased(8.44, 86.91, 1369.12, -11.91, 107.25, 1150.24, 120, 0, 0.2)
		wait_camera()
		helper_888ab2a3(30)
		event.set_camera_sequence_position(-30.54, 63.5, 1250.05)
		event.set_camera_sequence_look_at(1.85, 81.24, 1299.33)
		event.play_sound_effect(var2, 2)
		event.set_object_sequence_motion(0, "左向く", 6)
		event.queue_object_sequence_next_motion(0, "左向くL", 4)
		event.set_object_sequence_motion(1, "右向く", 6)
		event.queue_object_sequence_next_motion(1, "右向くL", 4)
		wait_objects(1)
		wait_objects(0)
		helper_888ab2a3(40)
		event.set_object_sequence_motion(0, "左向く戻り", 6)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		event.set_object_sequence_motion(1, "右向く戻り", 6)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		helper_888ab2a3(10)
		event.set_camera_sequence_position(8.44, 86.91, 1369.12)
		event.set_camera_sequence_look_at(-11.91, 107.25, 1150.24)
		event.clear_object_sequence_path(2)
		event.set_object_sequence_path_frames(2, 140)
		event.add_object_sequence_path_point(2, -99.87, 325.67, -377.78)
		event.add_object_sequence_path_point(2, -86.48, 290.88, -92.22)
		event.add_object_sequence_path_point(2, -74.49, 270.46, 99.58)
		event.add_object_sequence_path_point(2, -80.07, 258.98, 356.49)
		event.add_object_sequence_path_point(2, -108.42, 224.24, 515.31)
		event.add_object_sequence_path_point(2, -190.47, 156.03, 662.8)
		event.start_object_sequence_path(2)
		helper_888ab2a3(38)
		event.move_object_sequence(1, -145.57, 26.27, 1125.27, 100, 1)
		event.rotate_object_sequence(1, 0.0, -2.54, 0.0, 10)
		event.set_object_sequence_motion(1, "走り")
		helper_888ab2a3(14)
		event.move_object_sequence(0, -115.45, 30.53, 1131.91, 86, 1)
		event.rotate_object_sequence(0, 0.0, -2.54, 0.0, 10)
		event.set_object_sequence_motion(0, "走り")
		wait_objects(1)
		wait_objects(0)
		wait_objects(2)
		event.start_crossfade(30)
		event.set_camera_sequence_position(-368.06, 55.78, 1062.51)
		event.set_camera_sequence_look_at(-342.12, 43.19, 881.2)
		event.play_sound_effect(var2, 3)
		event.set_object_sequence_motion(2, "飛びから立ち", 6)
		event.set_object_sequence_motion_time(2, 40)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		event.set_object_sequence_position(2, -329.15, 98.27, 784.46)
		event.set_object_sequence_rotation(2, 0.0, -0.12, 0.0)
		event.move_object_sequence(2, -334.07, 73.0, 828.92, 30)
		event.set_object_sequence_position(1, -323.44, 0.56, 979.56)
		event.set_object_sequence_rotation(1, 0.0, -2.9, 0.0)
		event.move_object_sequence(1, -338.5, 0.26, 920.0, 40, 1)
		event.delay_object_sequence_rotation_track(1, 30)
		event.rotate_object_sequence(1, 0.0, -3.02, 0.0, 10)
		event.delay_object_sequence_motion_track(1, 40)
		event.set_object_sequence_motion(1, "立ち")
		event.delay_object_sequence_motion_track(1, 1)
		event.set_object_sequence_motion(1, "上向く", 6)
		event.queue_object_sequence_next_motion(1, "上向くL", 4)
		helper_888ab2a3(10)
		event.set_object_sequence_position(0, -346.15, 0.78, 1002.45)
		event.set_object_sequence_rotation(0, 0.0, 2.9, 0.0)
		event.move_object_sequence(0, -355.0, 0.46, 920.0, 40, 1)
		event.delay_object_sequence_rotation_track(0, 30)
		event.rotate_object_sequence(0, 0.0, 2.78, 0.0, 10)
		event.delay_object_sequence_motion_track(0, 40)
		event.set_object_sequence_motion(0, "立ち")
		event.delay_object_sequence_motion_track(0, 1)
		event.set_object_sequence_motion(0, "上向く", 6)
		event.queue_object_sequence_next_motion(0, "上向くL", 4)
		wait_objects(1)
		wait_objects(0)
		wait_objects(2)
		event.move_camera_sequence_angle_height_distance_eased(0.63, 12.59, 190.82, 120, 0, 0.4)
		event.set_object_sequence_motion(2, "会話", 2)
		event.queue_object_sequence_next_motion(2, "会話２", 6, 0.6)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		helper_4116e6bb(3170020)
		wait_objects(2)
		wait_camera()
		event.set_object_handle_frame_draw_flag(2, "hana", 1)
		event.set_object_sequence_motion(2, "頭を下げる", 2)
		event.queue_object_sequence_next_motion(2, "頭を下げるL", 4)
		helper_4116e6bb(3170025)
		wait_objects(2)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(0, 1, "通常目～おどろき目")
		event.set_object_handle_texture_animation(0, 1, "口とじ～大口")
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(1, 1, "通常目～おどろき目")
		event.set_object_handle_texture_animation(1, 1, "口とじ～大口")
		event.set_object_sequence_motion(0, "あーっ！", 6)
		event.queue_object_sequence_next_motion(0, "あーっ！L", 4)
		event.set_object_sequence_motion(1, "上向き指差し", 6)
		event.queue_object_sequence_next_motion(1, "上向き指差しＬ", 4)
		helper_4116e6bb(3170030)
		wait_objects(1)
		wait_objects(0)
		helper_4116e6bb(3170040)
		event.set_camera_sequence_position(-354.86, 5.98, 980.21)
		event.set_camera_sequence_look_at(-340.74, 53.89, 881.38)
		event.move_camera_sequence_eased(-312.11, 124.5, 846.08, -346.32, 77.26, 868.46, 30, 0, 1.0)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(0, 1, "通常目パチ")
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(1, 1, "通常目パチ")
		event.set_mouth_texture_animations(0, "通常口パク")
		helper_4116e6bb(3170050)
		wait_camera()
		event.pause_music()
		event.set_character_active(1, 18)
		event.set_character_position(18, -336.95, 92.55, 866.22)
		event.set_character_rotation(18, 0.6, -0.84, 0.0)
		event.set_character_motion(18, "発動", 6)
		helper_888ab2a3(2)
		event.play_sound_effect(var1, 0)
		helper_888ab2a3(120)
		event.play_sound_effect(var2, 7)
		helper_e787350a(363, 1)
		event.fade_out_screen(30)
		helper_888ab2a3(30)
		event.play_music(1)
		event.set_character_active(0, 18)
		event.set_camera_sequence_position(-265.62, 162.13, 816.12)
		event.set_camera_sequence_look_at(-337.34, 74.97, 859.33)
		event.fade_in_screen(30)
		event.set_object_handle_frame_draw_flag(2, "hana", 0)
		event.set_character_active(1, 16)
		event.set_object_sequence_motion(2, "立ち", 4)
		event.set_object_sequence_motion(0, "花持ち立ち", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "上向くL", 4, -1.0, 1)
		helper_888ab2a3(30)
		event.set_object_sequence_motion(2, "会話", 2)
		event.queue_object_sequence_next_motion(2, "会話２", 6)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		helper_4116e6bb(3170060)
		wait_objects(2)
		event.set_camera_sequence_position(-362.47, 38.8, 1063.3)
		event.set_camera_sequence_look_at(-337.46, 47.14, 861.71)
		event.set_mouth_motions(2, "会話２", 0, "立ち", 0)
		helper_4116e6bb(3170065)
		event.set_object_sequence_motion(2, "会話", 2)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		helper_4116e6bb(3170070)
		event.set_mouth_texture_animations(0, "通常口パク")
		helper_4116e6bb(3170075)
		event.set_mouth_motions(2, "会話２", 0, "立ち", 0)
		helper_4116e6bb(3170080)
		wait_objects(2)
		event.play_sound_effect(var2, 4)
		event.set_object_sequence_motion(2, "立ちから飛び", 2)
		event.queue_object_sequence_next_motion(2, "飛び", 4)
		event.delay_object_sequence_position_track(2, 30)
		event.move_object_sequence_eased(2, -334.07, 133.0, 828.92, 30, 1, 1.0)
		wait_objects(2)
		helper_4116e6bb(3170090)
		helper_4116e6bb(3170095)
		event.play_sound_effect(var2, 5)
		event.set_character_active(17)
		event.set_object_sequence_position(4, -334.07, 133.0, 828.92)
		event.set_object_sequence_rotation(4, 0.0, -1.57, 0.0)
		event.jump_object_sequence(4, -343.64, 25.73, 905.48, -0.2, 30)
		wait_objects(4)
		event.set_camera_sequence_position(-342.47, 55.33, 881.22)
		event.set_camera_sequence_look_at(-346.84, 21.58, 917.8)
		event.play_sound_effect(var2, 6)
		event.set_character_active(0, 16)
		event.attach_character_to_frame(0, "ef00", 17)
		event.set_object_sequence_position(4, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(4, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(0, "クラブゲット", 6)
		event.queue_object_sequence_next_motion(0, "クラブゲットL", 4)
		wait_objects(0)
		event.pause_music()
		event.set_object_sequence_motion(2, "飛び", 1)
		event.set_character_active(1, 18)
		event.set_character_position(18, -351.31, 30.76, 917.09)
		event.set_character_rotation(18, 0.4, -0.12, 0.0)
		event.set_character_motion(18, "発動", 6, -1.0, 1)
		helper_888ab2a3(2)
		event.play_sound_effect(var1, 0)
		helper_888ab2a3(120)
		event.play_sound_effect(var2, 7)
		argc = event.get_system_sound_id() or argc
		event.play_sound_effect(argc, 18)
		event.set_message_window_mode(0, 4)
		if arg0 == 10 then
			event.open_message_window_2(0, 9000020)
			helper_75684dd8(0, -1, 8, 0, 0)
		else
			event.open_message_window_2(0, 9000010)
			helper_75684dd8(0, -1, 8, 0, 0)
		end
		event.set_message_window_mode(0, 7)
		event.play_music(1)
		event.set_character_active(0, 18)
		event.set_object_sequence_motion(2, "飛び", 4)
		event.set_camera_sequence_position(-366.74, 221.09, 968.17)
		event.set_camera_sequence_look_at(-335.68, 196.88, 838.07)
		event.play_sound_effect(var2, 8)
		event.set_object_sequence_rotation(2, 0.0, 2.86, 0.0)
		event.move_object_sequence(2, -211.7, 150.58, 316.36, 120)
		helper_0d9fb41f(3170100, 90)
		event.fade_out_music(30)
		event.fade_out_screen(30)
		helper_888ab2a3(30)
	end)
	vm.entry(55)
	event.cancel_drama_scene_skip()
	event.stop_sound_effect(var1, 0)
	event.stop_music(0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_visible(5, 1)
	event.set_object_handle_visible(6, 1)
	event.delete_character_extension_packs(0)
	event.delete_character(13)
	event.delete_character(14)
	event.delete_character(15)
	event.delete_character(16)
	event.delete_character(17)
	event.delete_character(18)
	event.load_message_file(0, -1)
	helper_d61bc810(0)
	event.finish_event()
end

--- Helper function.
local function helper_25000000(arg0: s32, arg1: any)
	helper_038a2e4d(20)
	helper_249b75d1(0, -1, arg0, 0, 0)
	helper_038a2e4d(11)
end

--- Helper function.
local function helper_24f00000()
	helper_25000000(13, 9000000)
end

--- Helper function.
local function helper_25100000()
	local var0: s32 = 0
	local var15: s32 = 0
	var0 = 13
	helper_038a2e4d(20)
	helper_249b75d1(0, -1, var0, 0, 0)
	helper_f018b3c0(0, -1, 5, 0, 0)
	local _ = var15 ~= 0
	local _ = var15 ~= 0
	var15 = helper_d793ae41(0, 2, 1, 0)
	helper_038a2e4d(30)
	return 1
end

--- Helper function.
local function helper_24c00000()
	helper_038a2e4d(6)
end

--- Helper function.
local function helper_182c4()
	local active_chr_no: s32 = 0
	local var1: s32 = 0
	local at: number = 0
	return vm.guard(function()
		active_chr_no = event.get_playable_character() or active_chr_no
		if active_chr_no ~= 0 then
			event.set_message_window_mode(0, 4)
			at = 1
			helper_75684dd8(0, 2000, 8, 0, 0)
			return 1
		end
		var1 = event.get_equipped_item(0, 0) or var1
		if var1 ~= 9 and var1 ~= 10 and var1 ~= 11 and var1 ~= 12 and var1 ~= 13 and var1 ~= 14 then
			event.set_message_window_mode(0, 4)
			event.open_message_window_2(0, "『手ごろな枝』を装備してください。")
			at = 2
			helper_75684dd8(0, -1, 8, 0, 0)
			return 1
		end
		event.set_message_window_mode(0, 1)
		event.set_sphida_club(var1)
		event.disable_pad_auto_repeat()
		return 0
	end, function(received: { any })
		if at <= 1 then
			return 1
		end
		if at <= 2 then
			return 1
		end
		return nil
	end)
end

--- Helper function.
local function helper_1991c(arg0: s32)
	local count: s32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local at: number = 0
	return vm.guard(function()
		event.set_sphida_status_panel_visible(0)
		event.delete_character(12)
		event.delete_event_image(1)
		event.clear_effect_manager()
		event.delete_character_extension_packs(0)
		event.set_character_motion(0, "立ち", 4)
		event.update_character_motion(0)
		event.reset_character_cloth_and_hair(0)
		event.set_character_active(1, 13)
		event.set_character_active(1, 14)
		event.attach_object_handle_to_character(0, 1)
		event.set_object_handle_visible(0, 0)
		event.attach_object_handle_to_character(0, 2)
		event.set_object_handle_visible(0, 0)
		event.set_camera_control_enabled(1)
		event.delete_sword_afterimage()
		event.show_dungeon_status_bar(0, 1.0)
		if arg0 ~= 1 then
			event.start_crossfade(15)
		end
		count = event.get_sphida_par() or count
		if arg0 == 0 and count <= 0 then
			do
				local out1, out2, out3 = event.get_previous_camera_next_position()
				position_x = out1 or position_x
				position_y = out2 or position_y
				position_z = out3 or position_z
			end
			event.set_camera_position(position_x, position_y, position_z)
			do
				local out1, out2, out3 = event.get_previous_camera_next_look_at()
				position_x = out1 or position_x
				position_y = out2 or position_y
				position_z = out3 or position_z
			end
			event.set_camera_look_at(position_x, position_y, position_z)
			event.set_message_window_mode(0, 4)
			at = 1
			helper_75684dd8(0, 2003, 8, 0, 0)
			event.fade_out_screen(30)
			at = 2
			helper_888ab2a3(30)
			arg0 = 2
			event.reset_follow_camera(0)
		end
		event.run_dungeon_event(-1)
		event.clear_event_running_flag()
		event.finish_event()
		return arg0
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				helper_038a2e4d(30)
			end
			local _ = arg0 ~= 1
			local _ = arg0 == 0
			arg0 = 2
			return arg0
		end
		return nil
	end)
end

--- Helper function.
local function helper_23400000(arg0: s32)
	helper_ee1c51d0(0, 2003, 8, 0, 0)
	helper_038a2e4d(30)
	local _ = arg0 ~= 1
	local _ = arg0 == 0
	arg0 = 2
	return arg0
end

--- Helper function.
local function helper_1ab10()
	local tex_bank: s32 = 0
	local var1: s32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var11: f32 = 0
	local var12: f32 = 0
	local var13: f32 = 0
	local level: s32 = 0
	local var15: f32 = 0
	local var16: f32 = 0
	local var17: f32 = 0
	local var18: f32 = 0
	local var19: f32 = 0
	local var20: f32 = 0
	local var21: s32 = 0
	local var22: f32 = 0
	local var23: f32 = 0
	local var24: f32 = 0
	local var25: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	local var29: s32 = 0
	local var30: f32 = 0
	local var31: f32 = 0
	local var32: f32 = 0
	local var33: f32 = 0
	local var34: f32 = 0
	local var35: f32 = 0
	local var36: f32 = 0
	local var37: f32 = 0
	local var38: f32 = 0
	local var39: f32 = 0
	local var40: f32 = 0
	local var41: s32 = 0
	local var42: s32 = 0
	local var43: s32 = 0
	local var44: s32 = 0
	local var45: s32 = 0
	local var46: s32 = 0
	local var47: f32 = 0
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local var51: f32 = 0
	local pos_x_3: f32 = 0
	local pos_y_3: f32 = 0
	local pos_z_3: f32 = 0
	local yaw: f32 = 0
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.set_character_motion(0, "立ち")
		at = 1
		if helper_182c4() ~= 0 then
			event.finish_event()
			return 0
		end
		event.show_dungeon_status_bar(0, 1.0)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.start_background_file_loads_4(
			"dungeon/sphida/c01_golf.gltf",
			"dungeon/chara/c01b_miss.gltf",
			"dungeon/sphida/gool_end.gltf",
			"dungeon/sphida/mizu_eff.gltf"
		)
		at = 2
		vm.wait(2)
		at = 3
		helper_479dc9e9()
		event.load_character_motion_pack(5, "dungeon/sphida/c01_golf.gltf", "info", 0)
		event.load_character_motion_pack(5, "dungeon/chara/c01b_miss.gltf", "info", 0)
		tex_bank = event.get_sphida_texture_bank() or tex_bank
		event.load_character(5, "dungeon/sphida/gool_end.gltf", "info", 12)
		event.set_character_active(0, 12)
		var1 = event.load_sound_effect_file_3(5, "snd2/mon/en_900.sound.json") or var1
		event.create_sword_afterimage(5, 64, 16)
		event.set_sword_afterimage_color(128, 128, 128, 80, 128, 128, 128, 80)
		event.initialize_effect_manager(5, 1)
		event.load_effect_base_pack("足水パシャ", "dungeon/sphida/mizu_eff.gltf")
		event.create_effect_work_buffer(5)
		event.attach_object_handle_to_character(0, 1)
		event.set_object_handle_visible(0, 1)
		event.attach_object_handle_to_character(0, 2)
		event.set_object_handle_visible(0, 0)
		event.set_character_active(0, 13)
		event.set_character_active(0, 14)
		event.start_crossfade(15)
		event.reset_sphida_power_gauge()
		do
			local out1, out2, out3 = event.get_sphida_ball_position()
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		var2, var3, var4, var6 = helper_cc4413ca(var2, var3, var4, var6)
		helper_1a7fd8eb(var6)
		event.set_sphida_status_panel_visible(1)
		var11 = 12.5
		event.set_sphida_carry_angle(vm.f32(var11 * vm.f32(3.1415927)) / 180.0)
		var12, var13, level = helper_39ab7f1f(var12, var13, level)
		event.set_sphida_power_gauge_safe_level(level)
		do
			local out1, out2, out3 = event.zero_vector()
			var15 = out1 or var15
			var16 = out2 or var16
			var17 = out3 or var17
		end
		while true do
			event.set_sphida_minimap_scroll_enabled(0)
			event.set_sphida_minimap_shot_line_visible(0)
			at = 4
			local t0: s32
			t0, var6, var11 = helper_47b9f5b8(var6, var11, tex_bank)
			if t0 ~= 0 then
				event.set_sphida_minimap_scroll_enabled(0)
				event.set_sphida_minimap_shot_line_visible(0)
				event.set_sphida_ball_position(pos_x, pos_y, pos_z)
				event.set_character_position(8, pos_x, pos_y, pos_z)
				event.set_character_position(9, pos_x, pos_y, pos_z)
				at = 5
				return helper_1991c(0)
			end
			event.set_sphida_minimap_scroll_enabled(0)
			event.set_sphida_minimap_shot_line_visible(0)
			at = 6
			local t1: s32
			t1, var12, var6, var16, var15, level = helper_22878665(var12, tex_bank, var6, var16, var15, var1, level)
			if t1 == 0 then
				break
			else
				at = 7
				vm.wait(7)
			end
		end
		do
			local out1, out2, out3 = event.copy_vector(var2, var3, var4)
			var18 = out1 or var18
			var19 = out2 or var19
			var20 = out3 or var20
		end
		var21 = 0
		if level ~= 1 and level ~= -1 and level ~= 4 then
			event.set_event_sprite_type(0, 1)
			event.set_event_sprite_draw_pass(0, 1)
			event.set_event_sprite_size(0, 10.8, 11.6)
			event.set_event_sprite_position(0, var2, var3 + 30.0, var4)
			event.set_event_sprite_color(0, 128, 128, 128, 0)
			if level == 0 then
				event.set_event_sprite_texture_rect(0, 78, 198, 54, 58)
			end
			if level == 2 or level == -2 then
				event.set_event_sprite_texture_rect(0, 186, 190, 70, 66)
			end
			if level == 3 or level == -3 then
				event.set_event_sprite_texture_rect(0, 132, 198, 54, 58)
			end
			event.attach_object_handle_to_sprite(18, 0)
			event.clear_object_sequence(18)
			event.set_object_sequence_object(18, 18)
			event.set_object_sequence_color(18, 128, 128, 128, 128, 4)
			event.delay_object_sequence_color_track(18, 20)
			event.set_object_sequence_color(18, 128, 128, 128, 0, 6)
			at = 8
			helper_888ab2a3(10)
		end
		if var12 <= vm.f32(0.3) then
			event.set_character_motion(0, "小ショット", 2)
			at = 9
			helper_888ab2a3(25)
			if level ~= 4 then
				event.play_sound_effect(var1, 3)
			end
		elseif var12 <= vm.f32(0.6) then
			event.set_character_motion(0, "中ショット", 2)
			at = 10
			helper_888ab2a3(34)
			event.play_sound_effect(var1, 2)
		else
			event.set_character_motion(0, "大ショット", 2)
			at = 11
			helper_888ab2a3(39)
			if level == 0 then
				event.play_sound_effect(var1, 12)
			else
				event.play_sound_effect(var1, 1)
			end
		end
		if level == 4 then
			at = 12
			helper_888ab2a3(50)
			helper_c2ca38b7(var1)
			event.set_sphida_ball_position(pos_x, pos_y, pos_z)
			event.set_character_position(8, pos_x, pos_y, pos_z)
			event.set_character_position(9, pos_x, pos_y, pos_z)
			at = 13
			return helper_1991c(0)
		end
		if level == 0 then
			event.set_event_sprite_type(1, 0)
			event.set_event_sprite_draw_pass(1, 1)
			event.set_event_sprite_position(1, 256, 278)
			event.set_event_sprite_texture_rect(1, 246, 104, 266, 42)
			event.set_event_sprite_size(1, 266, 42)
			event.set_event_sprite_color(1, 128, 128, 128, 0)
			event.set_event_sprite_scale(1, 10, 10, 10)
			event.attach_object_handle_to_sprite(19, 1)
			event.clear_object_sequence(19)
			event.set_object_sequence_object(19, 19)
			event.jump_object_sequence(19, 256, 138, 0, 3.6, 20)
			event.set_object_sequence_scale(19, 1, 1, 1, 18)
			event.set_object_sequence_color(19, 128, 128, 128, 128, 12)
			event.delay_object_sequence_color_track(19, 30)
			event.set_object_sequence_color(19, 128, 128, 128, 0, 6)
		end
		var12 = helper_dff48a5c(var12)
		var11 = vm.f32(vm.f32(var11 * vm.f32(3.1415927)) / 180.0)
		var12 = vm.f32(var12 - vm.f32(var12 * var11))
		var22 = vm.f32(vm.sin(var6) * vm.f32(var12 * vm.cos(var11)))
		var23 = vm.f32(var12 * vm.sin(var11))
		var24 = vm.f32(vm.cos(var6) * vm.f32(var12 * vm.cos(var11)))
		var16 = vm.f32(vm.f32(var16 * vm.f32(3.1415927)) / 2.0)
		var17 = vm.f32(vm.f32(vm.f32(-var24 * var13) * var15) * vm.f32(0.4))
		var15 = vm.f32(vm.f32(vm.f32(-var22 * var13) * var15) * vm.f32(0.4))
		do
			local out1, out2, out3 = event.get_sphida_pin_position()
			pos_x_2 = out1 or pos_x_2
			pos_y_2 = out2 or pos_y_2
			pos_z_2 = out3 or pos_z_2
		end
		var29 = 0
		level = 0
		var42 = 0
		var46 = 0
		while true do
			if var3 >= 180.0 then
				var22 = vm.f32(var22 * vm.f32(0.999))
				var23 = vm.f32(var23 + vm.f32(vm.f32(-0.0098) * (var46 + 1)))
				var24 = vm.f32(var24 * vm.f32(0.999))
			else
				var41 = event.get_segment_collision_9(
					12,
					var2,
					var3,
					var4,
					var2,
					vm.f32(var3 - 3.0) - vm.f32(0.01),
					var4,
					0
				) or var41
				if level == 1 and var41 >= 0 then
					var22 = vm.f32(var22 * vm.f32(0.94))
					var23 = vm.f32(var23 + vm.f32(vm.f32(-0.00045) * (var46 + 1)))
					var24 = vm.f32(var24 * vm.f32(0.94))
					var22 = vm.f32(var22 + var15)
					var24 = vm.f32(var24 + var17)
					var15 = vm.f32(var15 * vm.f32(0.8))
					var17 = vm.f32(var17 * vm.f32(0.8))
				else
					var22 = vm.f32(var22 * vm.f32(0.999))
					var23 = vm.f32(var23 + vm.f32(vm.f32(-0.0045) * (var46 + 1)))
					var24 = vm.f32(var24 * vm.f32(0.999))
				end
			end
			do
				local out1, out2, out3 = event.add_vectors(var2, var3, var4, var22, var23, var24)
				var2 = out1 or var2
				var3 = out2 or var3
				var4 = out3 or var4
			end
			if var16 ~= 0.0 then
				var11 = event.get_direction_angle(var18, var19, var20, var2, var3, var4) or var11
				var11 = vm.f32(var11 + var16)
				var11 = event.wrap_angle(var11) or var11
				var22 = vm.f32(var22 + vm.f32(vm.f32(vm.sin(var11) / 10.0) * var13))
				var24 = vm.f32(var24 + vm.f32(vm.f32(vm.cos(var11) / 10.0) * var13))
			end
			var40 = event.get_vector_length(var15, 0.0, var17) or var40
			if var40 > vm.f32(0.01) then
				var25 = event.get_vector_length(var15, 0.0, var17) or var25
				var11 = event.get_direction_angle(var18, var19, var20, var18 + var15, var19, var20 + var17) or var11
				do
					local out1, out2, out3 = event.get_character_rotation(8)
					var5 = out1 or var5
					var6 = out2 or var6
					var7 = out3 or var7
				end
				event.set_character_rotation(8, var5, var11, var7)
				event.offset_character_rotation(8, var25 * 12.0, 0.0, 0.0)
				event.set_character_rotation(9, var5, var11, var7)
				event.offset_character_rotation(9, var25 * 12.0, 0.0, 0.0)
			else
				var25 = event.get_vector_length(var22, 0.0, var24) or var25
				var11 = event.get_direction_angle(var18, var19, var20, var2, var3, var4) or var11
				do
					local out1, out2, out3 = event.get_character_rotation(8)
					var5 = out1 or var5
					var6 = out2 or var6
					var7 = out3 or var7
				end
				event.set_character_rotation(8, var5, var11, var7)
				event.offset_character_rotation(8, var25 / 10.0, 0.0, 0.0)
				event.set_character_rotation(9, var5, var11, var7)
				event.offset_character_rotation(9, var25 / 10.0, 0.0, 0.0)
			end
			var25 = event.get_vector_length(var22, var23, var24) or var25
			var39 = var25
			var11 = event.get_direction_angle(var18, var19, var20, var2, var3, var4) or var11
			var36 = vm.f32(vm.sin(vm.f32(var11 - vm.f32(1.5707964))) * 3.0)
			var38 = vm.f32(vm.cos(vm.f32(var11 - vm.f32(1.5707964))) * 3.0)
			event.add_sword_afterimage_point(
				var2 - var36,
				var3,
				var4 - var38,
				vm.f32(var2 + var36) + var36,
				var3,
				vm.f32(var4 + var38) + var38
			)
			do
				local out1, out2, out3 = event.copy_vector(var22, var23, var24)
				var36 = out1 or var36
				var37 = out2 or var37
				var38 = out3 or var38
			end
			do
				local out1, out2, out3 = event.normalize_vector(var36, var37, var38)
				var36 = out1 or var36
				var37 = out2 or var37
				var38 = out3 or var38
			end
			do
				local out1, out2, out3 = event.scale_vector(var36, var37, var38, 3.0)
				var36 = out1 or var36
				var37 = out2 or var37
				var38 = out3 or var38
			end
			do
				local out1, out2, out3, out4, out5 =
					event.get_segment_collision_13(0, var18, var19, var20, var2 + var36, var3 + var37, var4 + var38, 0)
				var30 = out1 or var30
				var31 = out2 or var31
				var32 = out3 or var32
				var41 = out4 or var41
				var43 = out5 or var43
			end
			if var41 >= 0 and (var43 == 1 or var43 == 7) then
				event.create_effect("足水パシャ")
				event.set_effect_first_vector(var30, var31, var32)
				if var42 <= 0 then
					event.play_sound_effect(var1, 11)
					var42 = 20
				end
			end
			do
				local out1, out2, out3, out4, out5, out6, out7 =
					event.get_segment_collision_15(12, var18, var19, var20, var2 + var36, var3 + var37, var4 + var38, 1)
				var30 = out1 or var30
				var31 = out2 or var31
				var32 = out3 or var32
				var33 = out4 or var33
				var34 = out5 or var34
				var35 = out6 or var35
				var41 = out7 or var41
			end
			if var41 < 0 then
				if var3 >= 400.0 and var23 > 0.0 then
					do
						local out1, out2, out3 = event.copy_vector(var2, var3, var4)
						var30 = out1 or var30
						var31 = out2 or var31
						var32 = out3 or var32
					end
					do
						local out1, out2, out3 = event.copy_vector(var22, -var23, var24)
						var33 = out1 or var33
						var34 = out2 or var34
						var35 = out3 or var35
					end
					do
						local out1, out2, out3 = event.normalize_vector(var33, var34, var35)
						var33 = out1 or var33
						var34 = out2 or var34
						var35 = out3 or var35
					end
					var41 = 1
				end
			end
			while var41 >= 0 do
				var16 = 0.0
				if var25 > 8.0 then
					helper_79d90c82()
				end
				if var42 <= 0 then
					event.play_sound_effect(var1, 6)
					var42 = 10
				end
				do
					local out1, out2, out3 = event.copy_vector(-var22, -var23, -var24)
					var22 = out1 or var22
					var23 = out2 or var23
					var24 = out3 or var24
				end
				do
					local out1, out2, out3 = event.normalize_vector(var22, var23, var24)
					var22 = out1 or var22
					var23 = out2 or var23
					var24 = out3 or var24
				end
				do
					local out1, out2, out3 = event.scale_vector(var22, var23, var24, 3.0)
					var22 = out1 or var22
					var23 = out2 or var23
					var24 = out3 or var24
				end
				do
					local out1, out2, out3 = event.add_vectors(var30, var31, var32, var22, var23, var24)
					var30 = out1 or var30
					var31 = out2 or var31
					var32 = out3 or var32
				end
				do
					local out1, out2, out3 = event.subtract_vectors(var18, var19, var20, var30, var31, var32)
					var18 = out1 or var18
					var19 = out2 or var19
					var20 = out3 or var20
				end
				var40 = event.get_vector_length(var18, var19, var20) or var40
				var40 = vm.f32(var39 - var40)
				if var40 <= 0.0 then
					break
				else
					var39 = var40
					do
						local out1, out2, out3 = event.copy_vector(-var22, -var23, -var24)
						var22 = out1 or var22
						var23 = out2 or var23
						var24 = out3 or var24
					end
					if var23 < 0.0 and var34 > 0.0 then
						var22 = vm.f32(var15 * 2.0)
						var23 = 0.0
						var24 = vm.f32(var17 * 2.0)
						var15 = vm.f32(var15 * vm.f32(0.2))
						var17 = vm.f32(var17 * vm.f32(0.2))
					else
						if
							var22 < 0.0 and var33 > 0.0
							or var22 > 0.0 and var33 < 0.0
							or var24 < 0.0 and var35 > 0.0
							or var24 > 0.0 and var35 < 0.0
						then
							var15 = 0.0
							var17 = 0.0
						end
						var22 = 0.0
						var23 = 0.0
						var24 = 0.0
					end
					var22 = vm.f32(vm.f32(vm.f32(var33 * var25) * vm.f32(0.9)) + var22)
					var23 = vm.f32(vm.f32(vm.f32(var34 * var25) * vm.f32(0.58)) + var23)
					var24 = vm.f32(vm.f32(vm.f32(var35 * var25) * vm.f32(0.9)) + var24)
					do
						local out1, out2, out3 = event.copy_vector(var30, var31, var32)
						var18 = out1 or var18
						var19 = out2 or var19
						var20 = out3 or var20
					end
					do
						local out1, out2, out3 = event.copy_vector(var22, var23, var24)
						var36 = out1 or var36
						var37 = out2 or var37
						var38 = out3 or var38
					end
					do
						local out1, out2, out3 = event.normalize_vector(var36, var37, var38)
						var36 = out1 or var36
						var37 = out2 or var37
						var38 = out3 or var38
					end
					do
						local out1, out2, out3 = event.scale_vector(var36, var37, var38, 3.0)
						var36 = out1 or var36
						var37 = out2 or var37
						var38 = out3 or var38
					end
					do
						local out1, out2, out3 = event.scale_vector(var33, var34, var35, var40)
						var33 = out1 or var33
						var34 = out2 or var34
						var35 = out3 or var35
					end
					do
						local out1, out2, out3 = event.copy_vector(var30, var31, var32)
						var2 = out1 or var2
						var3 = out2 or var3
						var4 = out3 or var4
					end
					do
						local out1, out2, out3 = event.add_vectors(var2, var3, var4, var33, var34, var35)
						var2 = out1 or var2
						var3 = out2 or var3
						var4 = out3 or var4
					end
					do
						local out1, out2, out3, out4, out5, out6, out7 = event.get_segment_collision_15(
							12,
							var18,
							var19,
							var20,
							var2 + var36,
							var3 + var37,
							var4 + var38,
							1
						)
						var30 = out1 or var30
						var31 = out2 or var31
						var32 = out3 or var32
						var33 = out4 or var33
						var34 = out5 or var34
						var35 = out6 or var35
						var41 = out7 or var41
					end
				end
			end
			do
				local out1, out2, out3, out4, out5, out6, out7, out8 =
					event.get_segment_collision_16(12, var2, var3, var4, var2, var3 - 3.0, var4, 1)
				var30 = out1 or var30
				var31 = out2 or var31
				var32 = out3 or var32
				var33 = out4 or var33
				var34 = out5 or var34
				var35 = out6 or var35
				var41 = out7 or var41
				var43 = out8 or var43
			end
			if var41 >= 0 then
				var16 = 0.0
				var3 = vm.f32(var31 + 3.0)
				var40 = event.get_vector_length(var22, 0.0, var24) or var40
				if var40 < vm.f32(2.4) or var23 >= -1.0 and var23 <= 0.0 then
					var23 = 0.0
					level = 1
				else
					var22 = vm.f32(var22 * vm.f32(0.9))
					var23 = -vm.f32(var23 * vm.f32(0.58))
					var24 = vm.f32(var24 * vm.f32(0.9))
					var22 = vm.f32(var22 + vm.f32(var15 * 2.0))
					var24 = vm.f32(var24 + vm.f32(var17 * 2.0))
					var15 = vm.f32(var15 * vm.f32(0.2))
					var17 = vm.f32(var17 * vm.f32(0.2))
					if var25 > 8.0 then
						helper_79d90c82()
					end
					if var42 <= 0 then
						event.play_sound_effect(var1, 5)
						var42 = 10
					end
				end
				var40 = event.get_vector_length(var15, 0.0, var17) or var40
				if var23 == 0.0 and var25 < vm.f32(1.6) and var40 < vm.f32(0.4) then
					if not (var43 == 6) then
						break
					end
					var29 = 1
					break
				end
			end
			if var3 < -500.0 then
				var29 = 1
				break
			elseif var46 >= 300 then
				var29 = 1
				break
			else
				var44 = event.get_sphida_pin_color() or var44
				var45 = event.get_sphida_ball_color() or var45
				x = vm.f32(pos_x_2 - var2)
				y = vm.f32(pos_y_2 - var3)
				z = vm.f32(pos_z_2 - var4)
				var47 = event.get_vector_length(x, y, z) or var47
				if var45 ~= var44 then
					var51 = event.get_point_to_segment_distance(var18, var19, var20, var2, var3, var4, pos_x_2, pos_y_2, pos_z_2)
						or var51
					if var51 >= 0.0 and var51 <= 30.0 then
						var21 = 1
						break
					end
					if var47 ~= 0.0 then
						if var47 <= 120.0 then
							do
								local out1, out2, out3 = event.scale_vector(x, y, z, vm.fdiv(vm.f32(0.6), var47))
								x = out1 or x
								y = out2 or y
								z = out3 or z
							end
							do
								local out1, out2, out3 = event.add_vectors(var2, var3, var4, x, y, z)
								var2 = out1 or var2
								var3 = out2 or var3
								var4 = out3 or var4
							end
							do
								local out1, out2, out3 = event.add_vectors(var22, var23, var24, x, y, z)
								var22 = out1 or var22
								var23 = out2 or var23
								var24 = out3 or var24
							end
						end
					else
						var21 = 1
						break
					end
				elseif var47 ~= 0.0 then
					if var47 <= 60.0 then
						do
							local out1, out2, out3 = event.scale_vector(x, y, z, vm.fdiv(1.0, var47))
							x = out1 or x
							y = out2 or y
							z = out3 or z
						end
						do
							local out1, out2, out3 = event.subtract_vectors(var2, var3, var4, x, y, z)
							var2 = out1 or var2
							var3 = out2 or var3
							var4 = out3 or var4
						end
						do
							local out1, out2, out3 = event.subtract_vectors(var22, var23, var24, x, y, z)
							var22 = out1 or var22
							var23 = out2 or var23
							var24 = out3 or var24
						end
					end
				end
				event.set_character_position(8, var2, var3, var4)
				event.set_character_position(9, var2, var3, var4)
				do
					local out1, out2, out3 = event.copy_vector(var2, var3, var4)
					var18 = out1 or var18
					var19 = out2 or var19
					var20 = out3 or var20
				end
				if var3 <= -70.0 then
					event.set_follow_camera_following(0)
					if var29 >= 30 then
						if var29 >= 50 then
							break
						end
					else
						event.set_camera_look_at(var2, var3, var4)
					end
					var29 = var29 + 1
				elseif var46 >= 20 then
					event.set_camera_control_range(20.0, 30.0, 60.0, 200.0)
					event.set_camera_speed(8.0)
					event.set_follow_camera_offset(0.0, 0.0, 0.0)
					event.set_follow_camera_target(
						vm.f32(var2 + var22) + var22,
						vm.f32(var3 + var23) + var23,
						vm.f32(var4 + var24) + var24
					)
					do
						local out1, out2, out3 = event.get_camera_position()
						pos_x_3 = out1 or pos_x_3
						pos_y_3 = out2 or pos_y_3
						pos_z_3 = out3 or pos_z_3
					end
					yaw = event.get_direction_angle(
						vm.f32(var2 + var22) + var22,
						vm.f32(var3 + var23) + var23,
						vm.f32(var4 + var24) + var24,
						pos_x_3,
						pos_y_3,
						pos_z_3
					) or yaw
					event.set_camera_control_rotation(yaw)
					event.move_camera_control_with_pad(8)
					event.step_camera_control()
				end
				event.set_sphida_ball_position(var2, var3, var4)
				at = 14
				vm.wait(14)
				if var42 > 0 then
					var42 = var42 - 1
				end
				if var12 > 0.0 then
					var12 = vm.f32(var12 - 1.0)
				end
				var46 = var46 + 1
			end
		end
		event.set_character_position(8, var2, var3, var4)
		event.set_character_position(9, var2, var3, var4)
		at = 15
		vm.wait(15)
		event.set_sphida_status_panel_visible(0)
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		if var29 == 0 then
			event.set_sphida_ball_position(var2, var3, var4)
			if var21 == 1 then
				event.set_character_active(0, 0)
				event.set_character_active(0, 8)
				event.set_character_active(0, 9)
				event.set_character_active(1, 12)
				event.set_character_position(12, pos_x_2, pos_y_2, pos_z_2)
				event.set_character_motion(12, "発動", 6)
				event.play_sound_effect(var1, 17)
				var46 = 0
				while var46 < 2 do
					event.set_camera_control_enabled(0)
					event.set_follow_camera_following(1)
					event.set_follow_camera_target_alternate(pos_x_2, pos_y_2, pos_z_2)
					event.set_camera_speed(12.0)
					event.set_follow_camera_offset(0.0, 0.0, 0.0)
					event.set_follow_camera_height(0.0)
					event.set_follow_camera_distance(100.0)
					event.step_follow_camera(1)
					var46 = var46 + 1
					at = 16
					vm.wait(16)
				end
				event.set_character_active(0, 10)
				do
					local out1, out2, out3 = event.get_sphida_pin_position()
					pos_x_2 = out1 or pos_x_2
					pos_y_2 = out2 or pos_y_2
					pos_z_2 = out3 or pos_z_2
				end
				var46 = 0
				while var46 < 100 do
					event.set_camera_control_enabled(0)
					event.set_follow_camera_following(1)
					event.set_follow_camera_target_alternate(pos_x_2, pos_y_2, pos_z_2)
					event.set_camera_speed(12.0)
					event.set_follow_camera_offset(0.0, 0.0, 0.0)
					event.set_follow_camera_height(0.0)
					event.set_follow_camera_distance(100.0)
					event.step_follow_camera(1)
					var46 = var46 + 1
					at = 17
					vm.wait(17)
				end
				event.set_character_active(0, 11)
				var44 = event.get_dungeon_stage_id() or var44
				var45 = event.get_dungeon_floor() or var45
				var41 = event.get_dungeon_floor_info(var44, var45, 4) or var41
				do
					local out1, out2 = event.get_sphida_prize(var41)
					var42 = out1 or var42
					var43 = out2 or var43
				end
				var41 = vm.i32(var41 + 1)
				event.set_dungeon_floor_info(var44, var45, 4, var41)
				at = 18
				helper_888ab2a3(54)
				at = 19
				helper_888ab2a3(30)
				event.delete_character(8)
				event.delete_character(9)
				event.delete_character(10)
				event.delete_character(11)
				event.set_sphida_playing(0)
				event.fade_out_screen(30)
				at = 20
				helper_888ab2a3(30)
				event.play_music(0)
				event.release_camera_sequence_follow_object()
				event.set_event_sprite_draw_pass(0, 0)
			end
		else
			event.play_sound_effect(var1, 18)
			event.set_follow_camera_following(0)
			event.set_camera_control_enabled(0)
			event.clear_camera_sequence()
			event.set_camera_sequence_follow_object(0, 0.0, 15.0, 0.0, 0.0, 0.0, 80.0, "", 1)
			event.set_object_sequence_motion(0, "だめだめ", 6)
			event.set_object_sequence_normal_drive(0)
			event.queue_object_sequence_next_motion(0, "立ち", 4)
			event.reset_object_sequence_dynamic_animation(0)
			event.reset_event_sprite(0)
			event.set_event_sprite_type(0, 0)
			event.set_event_sprite_texture(0, "sphida_bar", tex_bank)
			event.set_event_sprite_texture_rect(0, 334, 54, 178, 34)
			event.set_event_sprite_position(0, 256, -25)
			event.set_event_sprite_size(0, 160, 50)
			event.set_event_sprite_color(0, 128, 128, 128, 128)
			event.set_event_sprite_draw_pass(0, 1)
			event.attach_object_handle_to_sprite(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.jump_object_sequence(1, 256.0, 208.0, 0.0, 1.2, 16)
			event.jump_object_sequence(1, 256.0, 208.0, 0.0, 2.0, 12)
			event.jump_object_sequence(1, 256.0, 208.0, 0.0, 1.5, 8)
			at = 21
			wait_objects(0)
			at = 22
			helper_888ab2a3(20)
			event.set_event_sprite_draw_pass(0, 0)
			event.set_sphida_ball_position(pos_x, pos_y, pos_z)
			event.set_character_position(8, pos_x, pos_y, pos_z)
			event.set_character_position(9, pos_x, pos_y, pos_z)
			event.release_camera_sequence_follow_object()
		end
		if var21 == 1 then
			helper_c2ca38b7(-1)
		else
			helper_c2ca38b7(var1)
		end
		at = 23
		return helper_1991c(var21)
	end, function(received: { any })
		if at <= 1 then
			if at == 1 then
				local _ = received[1] :: number
				local _ = received[1] :: number
			end
			return 0
		end
		if at <= 5 then
			if at == 4 then
				local _ = received[1] :: number
				var6 = received[2] :: number
				var11 = received[3] :: number
			end
			if at <= 2 then
				helper_344d6cd8()
			end
			if at <= 3 then
				var2, var3, var4, var6 = helper_250612f7(var2, var3, var4, var6)
				helper_6813499c(var6)
				var11 = 12.5
				var12, var13, level = helper_22d6eddc(var12, var13, level)
				do
					local _: any
					_, var6, var11 = helper_f29372c9(var6, var11, tex_bank)
				end
			end
			return helper_23400000(0)
		end
		if at <= 13 then
			if at == 6 then
				local _ = received[1] :: number
				var12 = received[2] :: number
				var6 = received[3] :: number
				var16 = received[4] :: number
				var15 = received[5] :: number
				level = received[6] :: number
			end
			if at <= 7 then
				var21 = 0
				helper_038a2e4d(10)
			end
			if at <= 8 then
				helper_038a2e4d(25)
			end
			if at <= 9 then
				helper_038a2e4d(34)
			end
			if at <= 10 then
				helper_038a2e4d(39)
			end
			if at <= 11 then
				helper_038a2e4d(50)
			end
			if at <= 12 then
				helper_1e55e9a8(var1)
			end
			return helper_23400000(0)
		end
		if at <= 23 then
			if at <= 14 then
				local _ = var42 > 0
				var42 = var42 - 1
				local _ = var12 > 0.0
				var12 = vm.f32(var12 - 1.0)
				local _ = var46 >= 300
				local _ = var46 >= 20
				var46 = var46 + 1
			end
			if at <= 15 then
				var46 = 0
				local _ = var46 < 2
				var46 = var46 + 1
			end
			if at <= 16 then
				var46 = 0
				local _ = var46 < 100
				var46 = var46 + 1
			end
			if at <= 17 then
				local _ = var41 >= 0
				local _ = var41 >= 0
				var41 = var41 + 1
				helper_038a2e4d(54)
			end
			if at <= 18 then
				helper_038a2e4d(30)
			end
			if at <= 19 then
				helper_038a2e4d(30)
			end
			if at <= 20 then
				helper_238b5abc(0)
			end
			if at <= 21 then
				helper_038a2e4d(20)
			end
			if at <= 22 then
				helper_1e55e9a8(-1)
				helper_1e55e9a8(var1)
			end
			return helper_23400000(var21)
		end
		return nil
	end)
end

--- Helper function.
local function helper_3d2f8()
	local var0: s32 = 0
	vm.section(function()
		vm.entry(1)
		event.set_save_flag(316, 1)
		event.set_camera_position(-88.57, 74.62, 1267.26)
		event.set_camera_look_at(20.74, 79.67, 1276.18)
		event.stop_music(0)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		var0 = event.load_sound_effect_file_3(8, "snd2/sp/sp_000.sound.json") or var0
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.show_dungeon_status_bar(0, 1.0)
		event.get_playable_character()
		event.load_message_file(0, 5, "event/e300/e316/e316.txt")
		event.load_character_motion_pack(5, "dungeon/sphida/c01_golf.gltf", "info", 0)
		event.load_character_motion_pack(5, "event/e300/e316/e316_mints.gltf", "info", 0)
		event.set_character_active(0)
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.delete_character_extension_packs(13)
		event.load_character_motion_pack(5, "event/e300/e316/e316_monica.gltf", "info", 13)
		event.attach_object_handle_to_character(1, 13)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_object_handle_position(0, -1.4, 62.34, 1267.0)
		event.set_object_handle_rotation(0, 0.0, -2.68, 0.0)
		event.set_object_handle_motion(0, "立ち", 4)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(0, 1, "通常目パチ")
		event.set_object_handle_position(1, -18.67, 62.68, 1288.34)
		event.set_object_handle_rotation(1, 0.0, -2.66, 0.0)
		event.set_object_handle_motion(1, "立ち", 4)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(1, 1, "通常目パチ")
		event.update_character_motion(13)
		event.reset_character_cloth_and_hair(13)
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-0.23, 74.74, 1183.98)
		event.set_camera_sequence_look_at(-6.52, 79.67, 1277.87)
		event.move_camera_sequence_eased(-1.7, 74.74, 1206.03, -6.52, 79.67, 1277.87, 90, 2, 0.3)
		event.play_sound_effect(var0, 0)
		event.fade_in_screen(30)
		event.set_object_sequence_motion(0, "カップインポーズ", 6)
		event.queue_object_sequence_next_motion(0, "カップインポーズL", 4)
		helper_888ab2a3(90)
		event.set_mouth_texture_animations(0, "わらい口パク")
		helper_4116e6bb(3160010)
		wait_objects(0)
		event.set_mouth_texture_animations(1, "わらい口パク")
		helper_4116e6bb(3160020)
		event.fade_out_screen(30)
		helper_888ab2a3(30)
	end)
	vm.entry(7)
	event.cancel_drama_scene_skip()
	event.stop_sound_effect(var0, 0)
	event.delete_character_extension_packs(0)
	event.delete_character_extension_packs(13)
	event.set_character_active(0, 8)
	event.set_character_active(0, 9)
	event.set_character_active(0, 10)
	event.set_character_active(0, 11)
	event.set_character_active(0, 12)
	event.detach_character_from_frame(15)
	event.set_character_active(0, 15)
	event.load_message_file(0, -1)
	event.finish_event()
end

--- Helper function.
local function helper_3827c()
	local active_chr_no: s32 = 0
	local var1: s32 = 0
	vm.section(function()
		event.set_save_flag(315, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.stop_music(0)
		helper_888ab2a3(4)
		event.load_music(57)
		event.play_music(0)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.show_dungeon_status_bar(0, 1.0)
		active_chr_no = event.get_playable_character() or active_chr_no
		event.change_directory("event/e300/e315/")
		event.load_message_file(0, 5, "e315.txt")
		if active_chr_no == 0 then
			event.load_character_motion_pack(5, "e315_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		event.change_directory("")
		if active_chr_no == 1 then
		else
			event.delete_character_extension_packs(13)
			event.load_character_motion_pack(5, "event/e300/e312/e312_monica.gltf", "info", 13)
			event.load_character_motion_pack(5, "event/e300/e315/e315_monica.gltf", "info", 13)
			event.attach_object_handle_to_character(1, 13)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.load_character_motion_pack(5, "dungeon/sphida/c01_golf.gltf", "info", 0)
		end
		event.load_character(5, "dungeon/sphida/gool_end.gltf", "info", 12)
		event.set_character_active(0, 12)
		var1 = event.load_sound_effect_file_3(5, "snd2/mon/en_900.sound.json") or var1
		event.create_sword_afterimage(5, 64, 16)
		event.set_sword_afterimage_color(128, 128, 128, 80, 128, 128, 128, 80)
		event.set_object_handle_position(0, 0.0, 62.57, 1305.04)
		event.set_object_handle_rotation(0, 0.0, 1.57, 0.0)
		event.set_object_handle_motion(0, "かまえ", 4)
		event.set_character_active(1, 15)
		event.set_character_position(15, 0.0, 0.0, 0.0)
		event.set_character_rotation(15, 0.0, 0.0, 0.0)
		event.attach_character_to_frame(0, "ef00", 15)
		event.set_object_handle_position(1, 10.18, 60.14, 1220.36)
		event.set_object_handle_rotation(1, 0.0, -0.12, 0.0)
		event.set_object_handle_motion(1, "歩き", 4)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(1, 1, "通常目パチ")
		event.update_character_motion(13)
		event.reset_character_cloth_and_hair(13)
		event.set_sphida_ball_position(0.0, 65.57, 1305.04)
		event.set_sphida_ball_color(0)
		event.set_character_position(8, 0.0, 65.57, 1305.04)
		event.set_character_active(0, 8)
		event.set_character_position(9, 0.0, 65.57, 1305.04)
		event.set_character_active(1, 9)
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(33.53, 98.1, 1193.52)
		event.set_camera_sequence_look_at(-0.29, 79.67, 1298.18)
		event.fade_in_screen(30)
		event.move_object_sequence(1, 5.22, 62.06, 1250.05, 30)
		event.delay_object_sequence_motion_track(1, 30)
		event.set_object_sequence_motion(1, "立ち")
		wait_objects(1)
		helper_888ab2a3(10)
		event.set_camera_sequence_position(1.79, 84.97, 1287.12)
		event.set_camera_sequence_look_at(5.49, 82.83, 1251.39)
		event.set_object_sequence_motion(1, "貸しなさい", 2)
		event.queue_object_sequence_next_motion(1, "貸しなさいＬ", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		helper_4116e6bb(3150010)
		wait_objects(1)
		event.set_camera_sequence_position(65.27, 79.39, 1297.35)
		event.set_camera_sequence_look_at(6.16, 79.67, 1305.48)
		event.set_object_handle_position(0, -92.27, 48.63, 1283.9)
		event.set_object_handle_rotation(0, 0.0, 1.34, 0.0)
		event.set_object_handle_motion(0, "立ち", 4)
		event.update_character_motion(0)
		event.reset_character_cloth_and_hair(0)
		event.detach_character_from_frame(15)
		event.set_character_active(1, 15)
		event.set_character_position(15, 0.0, 0.0, 0.0)
		event.set_character_rotation(15, 0.0, 0.0, 0.0)
		event.attach_character_to_frame(13, "sword_hand", 15)
		event.set_object_handle_position(1, -11.1, 63.73, 1309.96)
		event.set_object_handle_rotation(1, 0.0, 1.8, 0.0)
		event.set_object_handle_motion(1, "かまえゴルフＬ", 4)
		event.update_character_motion(13)
		event.reset_character_cloth_and_hair(13)
		event.set_mouth_texture_animations(1, "通常口パク")
		helper_4116e6bb(3150020)
		event.set_object_sequence_motion(1, "前方確認", 2)
		event.queue_object_sequence_next_motion(1, "ショット", 6)
		wait_objects(1)
		helper_888ab2a3(24)
		helper_33434(var1)
		event.set_camera_sequence_position(-88.57, 74.62, 1267.26)
		event.set_camera_sequence_look_at(20.74, 79.67, 1276.18)
		event.set_object_sequence_position(0, -18.67, 62.68, 1288.34)
		event.set_object_sequence_rotation(0, 0.0, -2.66, 0.0)
		event.reset_object_sequence_dynamic_animation(0, 0.0, -2.66, 0.0)
		event.set_object_sequence_position(1, -1.4, 62.34, 1267.0)
		event.set_object_sequence_rotation(1, 0.0, -2.68, 0.0)
		event.call_command(454, 1, "立ち", 4, -1.0, 1) -- retail: the handler rejects 5 arguments
		event.set_object_sequence_motion(1, "立ち", 4, -1.0, 1)
		event.set_mouth_texture_animations(1, "通常口パク")
		helper_4116e6bb(3150030)
		event.set_object_sequence_motion(0, "すごいや", 6)
		event.queue_object_sequence_next_motion(0, "すごいやL", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		helper_4116e6bb(3150040)
		wait_objects(0)
		event.fade_out_music(30)
		event.fade_out_screen(30)
		helper_888ab2a3(30)
	end)
	vm.entry(14)
	event.cancel_drama_scene_skip()
	event.stop_music(0)
	event.delete_character_extension_packs(0)
	event.delete_character_extension_packs(13)
	event.set_character_active(0, 8)
	event.set_character_active(0, 9)
	event.set_character_active(0, 10)
	event.set_character_active(0, 11)
	event.set_character_active(0, 12)
	event.detach_character_from_frame(15)
	event.set_character_active(0, 15)
	event.delete_character(12)
	event.load_message_file(0, -1)
	event.finish_event()
end

--- Helper function.
local function helper_326a4()
	local var0: s32 = 0
	local var1: any = 0
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		var0 = event.load_sound_effect_file_2(3809) or var0
		event.set_character_active(0, 0)
		event.load_character_motion_pack(5, "dungeon/chara/c02a_miss.gltf", "info", 13)
		event.load_character_motion_pack(5, "event/e300/e315/e315_monica.gltf", "info", 13)
		event.attach_object_handle_to_character(1, 13)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(1, 1, "通常目パチ")
		event.clear_camera_sequence()
		event.set_camera_sequence_position(67.57, 63.38, 1149.74)
		event.set_camera_sequence_look_at(67.85, 63.66, 1179.99)
		event.fade_in_screen(30)
		at = 1
		helper_888ab2a3(30)
		event.play_sound_effect(var0, 5)
		event.set_object_sequence_motion(1, "だめだめ", 2)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		event.open_voice_stream_wave(1, 3140170)
		at = 2
		helper_9cbdc640(1)
		event.open_message_window_2(0, "残念、失敗よ。\nもう一度挑戦する？")
		open_message(0, -1, 8, 0, 0)
		event.play_voice_stream(1)
		at = 3
		helper_5ac4b36d(0)
		close_message(0)
		event.close_voice_stream(1)
		event.set_message_bubble_screen_slot(0, 0)
		event.reset_mouth_texture_animations()
		event.set_message_window_mode(0, 1)
		event.set_message_bubble_tail(0, 0)
		event.open_message_window_2(0, "はい\nいいえ")
		open_message(0, -1, 5, 0, 0)
		at = 4
		var1 = helper_39af59c5(0, 2, 0, 1)
		event.set_message_bubble_screen_slot(0, 0)
		event.set_message_window_mode(0, 7)
		event.set_message_bubble_tail(0, 1)
		if var1 == 0 then
			event.delete_character_extension_packs(13)
			event.set_character_active(1, 0)
			return 1
		else
			event.set_object_sequence_motion(1, "貸しなさい", 2)
			event.queue_object_sequence_next_motion(1, "貸しなさいＬ", 4)
			event.set_mouth_texture_animations(1, "通常口パク")
			event.open_voice_stream_wave(1, 3150010)
			at = 5
			helper_9cbdc640(1)
			event.open_message_window_2(0, "もう、ユリスへたくそなんだから。\n私に貸してみて。")
			open_message(0, -1, 8, 0, 0)
			event.play_voice_stream(1)
			at = 6
			helper_5ac4b36d(0)
			close_message(0)
			event.close_voice_stream(1)
			event.set_message_bubble_screen_slot(0, 0)
			event.reset_mouth_texture_animations()
			at = 7
			wait_objects(1)
			event.fade_out_screen(30)
			at = 8
			helper_888ab2a3(30)
			event.set_character_active(1, 0)
			event.delete_character_extension_packs(13)
			return 0
		end
	end, function(received: { any })
		if at <= 4 then
			if at == 4 then
				var1 = received[1] :: number
			end
			if at <= 1 then
				helper_238b5abc(1)
			end
			if at <= 2 then
				helper_f018b3c0(0, -1, 8, 0, 0)
				helper_42079db3(0)
			end
			if at <= 3 then
				helper_d16eef1e(0)
				helper_f018b3c0(0, -1, 5, 0, 0)
				var1 = helper_d793ae41(0, 2, 0, 1)
			end
			return 1
		end
		if at <= 8 then
			if at <= 5 then
				helper_f018b3c0(0, -1, 8, 0, 0)
				helper_42079db3(0)
			end
			if at <= 6 then
				helper_d16eef1e(0)
				helper_238b5abc(1)
			end
			if at <= 7 then
				helper_038a2e4d(30)
			end
			return 0
		end
		return nil
	end)
end

--- Helper function.
local function helper_39fa0()
	local active_chr_no: s32 = 0
	local var1: s32 = 0
	vm.section(function()
		vm.entry(1)
		event.set_save_flag(315, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.stop_music(0)
		helper_888ab2a3(4)
		event.load_music(57)
		event.play_music(0)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.show_dungeon_status_bar(0, 1.0)
		active_chr_no = event.get_playable_character() or active_chr_no
		event.change_directory("event/e300/e315/")
		event.load_message_file(0, 5, "e315.txt")
		if active_chr_no == 0 then
			event.load_character_motion_pack(5, "e315_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		event.change_directory("")
		if active_chr_no == 1 then
		else
			event.delete_character_extension_packs(13)
			event.load_character_motion_pack(5, "event/e300/e312/e312_monica.gltf", "info", 13)
			event.load_character_motion_pack(5, "event/e300/e315/e315_monica.gltf", "info", 13)
			event.attach_object_handle_to_character(1, 13)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.load_character(5, "dungeon/sphida/gool_end.gltf", "info", 12)
		event.set_character_active(0, 12)
		var1 = event.load_sound_effect_file_3(5, "snd2/mon/en_900.sound.json") or var1
		event.create_sword_afterimage(5, 64, 16)
		event.set_sword_afterimage_color(128, 128, 128, 80, 128, 128, 128, 80)
		event.set_object_handle_position(0, -92.27, 48.63, 1283.9)
		event.set_object_handle_rotation(0, 0.0, 1.34, 0.0)
		event.set_object_handle_motion(0, "立ち", 4)
		event.set_character_active(1, 15)
		event.set_character_position(15, 0.0, 0.0, 0.0)
		event.set_character_rotation(15, 0.0, 0.0, 0.0)
		event.attach_character_to_frame(13, "sword_hand", 15)
		event.set_object_handle_position(1, -11.1, 63.73, 1309.96)
		event.set_object_handle_rotation(1, 0.0, 1.8, 0.0)
		event.set_object_handle_motion(1, "かまえゴルフＬ", 4)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(1, 1, "通常目パチ")
		event.update_character_motion(13)
		event.reset_character_cloth_and_hair(13)
		event.set_sphida_ball_position(0.0, 65.57, 1305.04)
		event.set_sphida_ball_color(0)
		event.set_character_position(8, 0.0, 65.57, 1305.04)
		event.set_character_active(0, 8)
		event.set_character_position(9, 0.0, 65.57, 1305.04)
		event.set_character_active(1, 9)
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(65.27, 79.39, 1297.35)
		event.set_camera_sequence_look_at(6.16, 79.67, 1305.48)
		event.fade_in_screen(30)
		helper_888ab2a3(30)
		event.set_mouth_texture_animations(1, "通常口パク")
		helper_4116e6bb(3150020)
		event.set_object_sequence_motion(1, "前方確認", 2)
		event.queue_object_sequence_next_motion(1, "ショット", 6)
		wait_objects(1)
		helper_888ab2a3(24)
		helper_33434(var1)
		event.set_camera_sequence_position(-88.57, 74.62, 1267.26)
		event.set_camera_sequence_look_at(20.74, 79.67, 1276.18)
		event.set_object_sequence_position(0, -18.67, 62.68, 1288.34)
		event.set_object_sequence_rotation(0, 0.0, -2.66, 0.0)
		event.reset_object_sequence_dynamic_animation(0, 0.0, -2.66, 0.0)
		event.set_object_sequence_position(1, -1.4, 62.34, 1267.0)
		event.set_object_sequence_rotation(1, 0.0, -2.68, 0.0)
		event.call_command(454, 1, "立ち", 4, -1.0, 1) -- retail: the handler rejects 5 arguments
		event.set_object_sequence_motion(1, "立ち", 4, -1.0, 1)
		event.set_mouth_texture_animations(1, "通常口パク")
		helper_4116e6bb(3150030)
		event.set_object_sequence_motion(0, "すごいや", 6)
		event.queue_object_sequence_next_motion(0, "すごいやL", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		helper_4116e6bb(3150040)
		wait_objects(0)
		event.fade_out_music(30)
		event.fade_out_screen(30)
		helper_888ab2a3(30)
	end)
	vm.entry(12)
	event.cancel_drama_scene_skip()
	event.stop_music(0)
	event.delete_character_extension_packs(0)
	event.delete_character_extension_packs(13)
	event.set_character_active(0, 8)
	event.set_character_active(0, 9)
	event.set_character_active(0, 10)
	event.set_character_active(0, 11)
	event.set_character_active(0, 12)
	event.detach_character_from_frame(15)
	event.set_character_active(0, 15)
	event.delete_character(12)
	event.load_message_file(0, -1)
	event.finish_event()
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

script.event_99 = event_99

script.default_event = default_event

--- The event the town walk runs when the square button is pressed, after reloading the map script.
function script.key_open()
	event.initialize_event()
	helper_fd3a2124(1)
	vm.wait(1)
	event.finish_event()
end

--- Event 500, which map data, a script or the engine runs by number.
function script.event_500()
	local flag: s32 = 0
	local argc: s32 = 0
	local at: number = 0
	return vm.guard(function()
		flag = event.get_save_flag(314) or flag
		if flag == 0 then
			argc = event.get_owned_item_count(9) or argc
			if argc >= 1 then
				event.set_character_motion(0, "立ち")
				event.fade_out_screen(30)
				at = 1
				helper_888ab2a3(30)
				at = 2
				helper_2f2d0()
				event.fade_in_screen(30)
				at = 3
				helper_888ab2a3(30)
				at = 4
				helper_43e18()
			else
				at = 5
				helper_2d65c()
			end
		elseif (function()
			at = 6
			return helper_31830()
		end)() ~= 0 then
			at = 7
			helper_3b604()
			event.add_inventory_item(10)
			event.add_inventory_item(363)
			at = 8
			helper_3e1dc(10)
			at = 9
			helper_431a4()
			return
		end
		at = 10
		vm.wait(10)
		event.finish_event()
		return
	end, function(received: { any })
		if at <= 9 then
			if at == 6 then
				local _ = received[1] :: number
			end
			if at <= 1 then
				at = 2
				helper_2f2d0()
				return vm.continue_with(function()
					event.fade_in_screen(30)
					at = 3
					helper_888ab2a3(30)
					at = 4
					helper_43e18()
					at = 10
					vm.wait(10)
					event.finish_event()
					return
				end)
			end
			if at <= 2 then
				helper_038a2e4d(30)
			end
			if at <= 3 then
				helper_d8e14c06()
			end
			if at <= 4 then
				helper_24f00000()
			end
			if at <= 5 then
				local _ = helper_25100000()
			end
			if at <= 6 then
				at = 7
				helper_3b604()
				return vm.continue_with(function()
					event.add_inventory_item(10)
					event.add_inventory_item(363)
					at = 8
					helper_3e1dc(10)
					at = 9
					helper_431a4()
					return
				end)
			end
			if at <= 7 then
				at = 8
				helper_3e1dc(10)
				return vm.continue_with(function()
					at = 9
					helper_431a4()
					return
				end)
			end
			if at <= 8 then
				helper_24c00000()
			end
			return 0
		end
		if at <= 10 then
			return 0
		end
		return nil
	end)
end

--- Event 510, which map data, a script or the engine runs by number.
function script.event_510()
	event.initialize_event()
	vm.wait(1)
	event.set_character_motion(0, "立ち")
	event.set_function_point_enabled("", "branch", 0)
	event.add_inventory_item(9)
	helper_e787350a(9, 1)
	event.set_character_active(0, 15)
	helper_d61bc810(1)
	event.finish_event()
end

--- Event 520, which map data, a script or the engine runs by number.
function script.event_520()
	local active_chr_no: s32 = 0
	local var1: any = 0
	event.initialize_event()
	vm.wait(1)
	event.reset_action_character_motion(0)
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 2 or active_chr_no == 3 then
		event.set_message_window_mode(0, 1)
		event.set_message_draw_speed(0, 1)
		if active_chr_no == 2 then
			helper_75684dd8(0, 20, 5, 256, 208)
		else
			helper_75684dd8(0, 21, 5, 256, 208)
		end
		event.finish_event()
		return
	end
	event.set_message_selection_top_line(0, 0)
	event.set_message_window_mode(0, 5)
	event.set_message_draw_speed(0, 1)
	var1 = helper_bac0e30d(0, 10, 8, 256, 208, 2, 1)
	event.set_message_window_mode(0, 1)
	event.set_message_draw_speed(0, 0)
	if var1 == 0 then
		event.fade_out_screen(30)
		helper_888ab2a3(30)
		helper_431a4()
		return
	end
	event.finish_event()
end

--- Event 1200, which map data, a script or the engine runs by number.
function script.event_1200()
	helper_786b79f1(0)
end

--- The Sphida event run when the player stands at the ball and presses the action button.
function script.sphida_shot()
	local var0: s32 = 0
	local argc: s32 = 0
	local at: number = 0
	return vm.guard(function()
		at = 1
		var0 = helper_1ab10()
		if var0 == 1 then
			at = 2
			helper_3d2f8()
			event.add_inventory_item(11)
			event.add_inventory_item(363)
			at = 3
			helper_3e1dc(11)
			at = 4
			helper_431a4()
			return
		end
		if var0 == 2 then
			argc = event.get_local_event_counter(0) or argc
			argc = vm.i32(argc + 1)
			event.set_local_event_counter(0, argc)
			if argc >= 10 then
				at = 5
				helper_3827c()
				event.add_inventory_item(10)
				event.add_inventory_item(363)
				at = 6
				helper_3e1dc(10)
				at = 7
				helper_431a4()
				return
			elseif (function()
				at = 8
				return helper_326a4()
			end)() == 0 then
				at = 9
				helper_39fa0()
				event.add_inventory_item(10)
				event.add_inventory_item(363)
				at = 10
				helper_3e1dc(10)
				at = 11
				helper_431a4()
				return
			else
				event.set_character_active(0)
				event.set_character_position(0, -25.0, 62.7, 1285.3)
				event.set_character_rotation(0, 0.0, 3.14, 0.0)
				event.set_character_motion(0, "立ち", 4)
				event.update_character_motion(0)
				event.reset_character_cloth_and_hair(0)
				event.set_sphida_playing(1)
				event.set_sphida_par(3)
				event.set_sphida_ball_position(0.0, 65.57, 1305.04)
				event.set_sphida_ball_color(0)
				event.set_sphida_last_challenge(0)
				event.set_character_position(8, 0.0, 65.57, 1305.04)
				event.set_character_active(0, 8)
				event.set_character_position(9, 0.0, 65.57, 1305.04)
				event.set_character_active(1, 9)
				event.set_camera_look_at(-25.0, 92.7, 1285.3)
				event.set_camera_position(-25.0, 102.7, 1385.3)
				event.reset_follow_camera(0)
				event.finish_event()
			end
		end
		return
	end, function(received: { any })
		if at <= 4 then
			if at == 1 then
				var0 = received[1] :: number
			end
			if at <= 1 then
				at = 2
				helper_3d2f8()
				return vm.continue_with(function()
					event.add_inventory_item(11)
					event.add_inventory_item(363)
					at = 3
					helper_3e1dc(11)
					at = 4
					helper_431a4()
					return
				end)
			end
			if at <= 2 then
				at = 3
				helper_3e1dc(11)
				return vm.continue_with(function()
					at = 4
					helper_431a4()
					return
				end)
			end
			if at <= 3 then
				helper_24c00000()
			end
			return 0
		end
		if at <= 7 then
			if at <= 5 then
				at = 6
				helper_3e1dc(10)
				return vm.continue_with(function()
					at = 7
					helper_431a4()
					return
				end)
			end
			if at <= 6 then
				helper_24c00000()
			end
			return 0
		end
		if at <= 11 then
			if at <= 8 then
				at = 9
				helper_39fa0()
				return vm.continue_with(function()
					event.add_inventory_item(10)
					event.add_inventory_item(363)
					at = 10
					helper_3e1dc(10)
					at = 11
					helper_431a4()
					return
				end)
			end
			if at <= 9 then
				at = 10
				helper_3e1dc(10)
				return vm.continue_with(function()
					at = 11
					helper_431a4()
					return
				end)
			end
			if at <= 10 then
				helper_24c00000()
			end
			return 0
		end
		return nil
	end)
end

--- The Sphida event run when the menu button is pressed near the ball.
function script.sphida_near_ball()
	local var0: any = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local debug_flag: s32 = 0
	event.initialize_event()
	event.set_character_motion(0, "立ち")
	event.set_message_window_mode(0, 5)
	event.set_message_selection_top_line(0, 0)
	var0 = helper_bac0e30d(0, 2004, 8, 256, 208, 2, 0)
	if var0 == 0 then
		do
			local out1, out2, out3 = event.get_character_position(0)
			var1 = out1 or var1
			var2 = out2 or var2
			var3 = out3 or var3
		end
		event.set_sphida_ball_position(var1, var2 + 3.0, var3)
		event.set_character_position(8, var1, var2 + 3.0, var3)
		event.set_character_position(9, var1, var2 + 3.0, var3)
		debug_flag = event.get_debug_flag() or debug_flag
		if debug_flag == 0 then
			helper_c2ca38b7(-1)
		end
		event.start_crossfade(15)
	end
	vm.wait(2)
	event.finish_event()
end

--- The Sphida event run when the menu button is pressed near the ball with fewer than two shots of par left.
function script.sphida_near_ball_last()
	local var0: any = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	event.initialize_event()
	helper_ce85b54c()
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(0, "スフィアを足元へ移動できるのは\nこれが最後になります。")
	helper_75684dd8(0, -1, 8, 0, 0)
	event.set_message_window_mode(0, 5)
	event.set_message_selection_top_line(0, 0)
	event.open_message_window_2(0, "スフィアを足元へ移動しますか？")
	var0 = helper_bac0e30d(0, -1, 8, 0, 0, 2, 1)
	if var0 == 0 then
		do
			local out1, out2, out3 = event.get_character_position(0)
			var1 = out1 or var1
			var2 = out2 or var2
			var3 = out3 or var3
		end
		event.set_sphida_ball_position(var1, var2 + 3.0, var3)
		event.set_character_position(8, var1, var2 + 3.0, var3)
		event.set_character_position(9, var1, var2 + 3.0, var3)
		event.set_sphida_last_challenge(1)
		event.start_crossfade(15)
	end
	vm.wait(3)
	event.finish_event()
end

--- Event 13080, which map data, a script or the engine runs by number.
function script.event_13080()
	event_99()
	event.set_save_flag(300, 1)
	event.set_save_flag(320, 0)
	default_event()
end

--- Event 13120, which map data, a script or the engine runs by number.
function script.event_13120()
	event_99()
	event.set_save_flag(300, 1)
	event.set_save_flag(320, 1)
	event.set_save_flag(312, 0)
	event.set_save_flag(314, 0)
	event.set_save_flag(315, 0)
	event.set_save_flag(316, 0)
	event.set_save_flag(317, 0)
	default_event()
end

--- Event 13170, which map data, a script or the engine runs by number.
function script.event_13170()
	event_99()
	event.show_dungeon_status_bar(0, 1.0)
	event.assign_memory_stack(4)
	event.clear_memory_stack(4)
	event.load_character(4, "chara/c02_base.gltf", "info", 13)
	event.load_equipment_model(4, 1, 4, "info", 13)
	event.load_equipment_model(4, 1, 3, "info", 13)
	event.load_equipment_model(4, 1, 2, "info", 13, 14)
	helper_3e1dc(10)
end

return script
