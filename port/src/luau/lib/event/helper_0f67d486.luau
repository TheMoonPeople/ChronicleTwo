--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local close_message = require("@lib/event/close_message")
local helper_0e75aa9e = require("@lib/event/helper_0e75aa9e")
local helper_1584c528 = require("@lib/event/helper_1584c528")
local helper_238b5abc = require("@lib/event/helper_238b5abc")
local helper_2f8c501c = require("@lib/event/helper_2f8c501c")
local helper_344d6cd8 = require("@lib/event/helper_344d6cd8")
local helper_4116e6bb = require("@lib/event/helper_4116e6bb")
local helper_479dc9e9 = require("@lib/event/helper_479dc9e9")
local helper_523109b8 = require("@lib/event/helper_523109b8")
local helper_52aadc70 = require("@lib/event/helper_52aadc70")
local helper_8cd371d7 = require("@lib/event/helper_8cd371d7")
local helper_d16eef1e = require("@lib/event/helper_d16eef1e")
local helper_f018b3c0 = require("@lib/event/helper_f018b3c0")
local helper_f616ba9e = require("@lib/event/helper_f616ba9e")
local open_message = require("@lib/event/open_message")
local wait_camera = require("@lib/event/wait_camera")
local wait_frames = require("@lib/event/wait_frames")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_0f67d486()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local rot_x: f32 = 0
	local rot_y: f32 = 0
	local var4: f32 = 0
	local vector_x: f32 = 0
	local vector_y: f32 = 0
	local vector_z: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local pos_x_2: f32 = 0
	local var12: f32 = 0
	local var13: f32 = 0
	local var14: s32 = 0
	local var15: s32 = 0
	local var16: s32 = 0
	local stream_open_state: s32 = 0
	local var18: s32 = 0
	local var19: s32 = 0
	local at: number = 0
	vm.section(function()
		at = 1
		vm.entry(1)
		event.set_save_flag(408, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.show_dungeon_status_bar(0, 1.0)
		event.load_map_sounds(4803)
		var0 = event.load_sound_effect_file_2(4803) or var0
		event.play_sound_effect(var0, 11)
		at = 2
		vm.wait(2)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		active_chr_no = event.get_playable_character() or active_chr_no
		event.set_scene_status_flags(1, 0, 256, 1)
		event.change_directory("event/e400/e408/")
		event.load_message_file(0, 5, "e408_1.txt")
		if active_chr_no == 0 then
			event.load_character_motion_pack(5, "e408_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if active_chr_no == 1 then
			event.load_character_motion_pack(5, "e408_monica.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.load_character(5, "e408_paw.gltf", "info", 10)
		event.set_character_active(0, 10)
		event.attach_object_handle_to_character(2, 10)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.load_character(5, "e408_shigu.gltf", "info", 11)
		event.set_character_active(0, 11)
		event.attach_object_handle_to_character(3, 11)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.load_character(5, "mariometto_a.gltf", "info", 12)
		event.set_character_active(0, 12)
		event.attach_character_to_frame(11, "metto_null", 12)
		event.load_character(5, "e408_mizusibuki.gltf", "info", 13)
		event.set_character_active(0, 13)
		event.set_scene_character_type(13, 4)
		event.change_directory("")
		if active_chr_no == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 8)
			event.load_equipment_model(5, 0, 4, "info", 8)
			event.load_equipment_model(5, 0, 3, "info", 8)
			event.load_equipment_model(5, 0, 2, "info", 8, 9)
			event.load_character_motion_pack(5, "event/e400/e408/e408_mints.gltf", "info", 8)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 8)
			event.attach_object_handle_to_character(0, 8)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 0)
		else
			event.load_character(5, "chara/c02_base.gltf", "info", 8)
			event.load_equipment_model(5, 1, 4, "info", 8)
			event.load_equipment_model(5, 1, 3, "info", 8)
			event.load_equipment_model(5, 1, 2, "info", 8, 9)
			event.load_character_motion_pack(5, "event/e400/e408/e408_monica.gltf", "info", 8)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 8)
			event.attach_object_handle_to_character(1, 8)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 0)
		end
		event.set_character_active(8)
		event.set_character_active(9)
		event.attach_object_handle_to_character(6, 1)
		event.attach_object_handle_to_character(7, 2)
		event.attach_object_handle_to_map_part_3(4, "p06_s19", "s19_09-m1")
		event.clear_object_sequence(4)
		event.set_object_sequence_object(4, 4)
		event.attach_object_handle_to_map_part_3(5, "p06_s19", "s19_10-m1")
		event.clear_object_sequence(5)
		event.set_object_sequence_object(5, 5)
		event.set_object_handle_position(0, -70.0, 5.18, 610.0)
		event.set_object_handle_rotation(0, 0.0, 3.14, 0.0)
		event.set_object_handle_footstep_sound(0, 16)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "無表情")
		event.set_object_handle_texture_animation(0, 1, "通常目パチ")
		event.set_object_handle_position(1, -85.0, 5.18, 620.0)
		event.set_object_handle_rotation(1, 0.0, 3.14, 0.0)
		event.set_object_handle_footstep_sound(1, 16)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(1, 1, "通常目パチ")
		event.set_object_handle_position(2, -76.0, -38.33, 1157.0)
		event.set_object_handle_rotation(2, 0.0, 3.14, 0.0)
		event.set_object_handle_footstep_sound(2, 16)
		event.set_object_handle_position(3, -68.33, -4.68, 302.5)
		event.set_object_handle_rotation(3, 0.0, 0.0, 0.0)
		event.set_object_handle_motion(3, "出現", 5)
		event.set_object_handle_texture_animation(3, 0)
		event.set_object_handle_texture_animation(3, 1, "赤目パチ")
		event.set_character_position(13, -72.26, 0.0, 371.59)
		event.set_character_rotation(13, 0.0, -0.12, 0.0)
		event.set_object_handle_visible(6, 0)
		event.set_object_handle_visible(7, 0)
		do
			local out1, out2, out3 = event.get_object_handle_rotation(4)
			rot_x = out1 or rot_x
			rot_y = out2 or rot_y
			var4 = out3 or var4
		end
		do
			local out1, out2, out3 = event.copy_vector(rot_x, rot_y, var4)
			vector_x = out1 or vector_x
			vector_y = out2 or vector_y
			vector_z = out3 or vector_z
		end
		do
			local out1, out2, out3 = event.get_object_handle_position(5)
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		var4 = vm.f32(vector_z - vm.f32(3.1415927))
		var4 = event.wrap_angle(var4) or var4
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-78.09, 35.57, 471.0)
		event.set_camera_sequence_look_at(-77.73, 22.13, 561.51)
		event.move_object_sequence(0, -70.0, 4.89, 540.0, 60, 1)
		event.set_object_sequence_motion(0, "歩き", 4)
		event.delay_object_sequence_motion_track(0, 60)
		event.set_object_sequence_motion(0, "立ち")
		event.move_object_sequence(1, -85.0, 5.18, 540.0, 70, 1)
		event.set_object_sequence_motion(1, "歩き", 4)
		event.delay_object_sequence_motion_track(1, 70)
		event.set_object_sequence_motion(1, "立ち")
		event.fade_in_screen(30)
		at = 3
		wait_objects(1)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 4
		helper_4116e6bb(4080010)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 5
		helper_4116e6bb(4080020)
		event.set_camera_sequence_position(-80.97, 22.27, 518.15)
		event.set_camera_sequence_look_at(-69.62, 27.4, 537.26)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 6
		helper_4116e6bb(4080030)
		event.set_message_button_prompt(0, 0)
		pos_x_2 = -140.0
		var12 = vm.f32(1.9)
		var13 = vm.f32(-0.044)
		event.set_camera_sequence_position(-86.24, 243.02, 628.3)
		event.set_camera_sequence_look_at(pos_x_2, 253.78, 519.17)
		var15 = 0
		var16 = 0
		var14 = 0
		while var14 < 440 do
			event.set_camera_sequence_look_at(pos_x_2, 253.78, 519.17)
			pos_x_2 = vm.f32(pos_x_2 + var12)
			if var14 < 42 then
				var12 = vm.f32(var12 + var13)
			end
			if var15 == 1 then
				stream_open_state = event.get_voice_stream_open_state() or stream_open_state
				if stream_open_state == 0 then
					var15 = 0
					var16 = 1
					event.ready_voice_stream(1)
				end
			end
			if var16 == 1 then
				stream_open_state = event.get_voice_stream_open_state() or stream_open_state
				if stream_open_state == 0 then
					var16 = 0
					event.open_message_window_2(0, var18)
					open_message(0, -1, 8, 0, 0)
					event.play_voice_stream(1)
				end
			end
			if var14 == 0 then
				var18 = 4080040
				event.open_voice_stream_wave(1, var18)
				var15 = 1
			end
			if var14 == 180 then
				close_message(0)
				event.close_voice_stream(1)
				var18 = 4080045
				event.open_voice_stream_wave(1, var18)
				var15 = 1
			end
			var14 = var14 + 1
			at = 7
			vm.wait(7)
		end
		close_message(0)
		event.close_voice_stream(1)
		event.set_message_button_prompt(0, 1)
		event.set_camera_sequence_position(-71.52, 55.19, 769.57)
		event.set_camera_sequence_look_at(-78.08, 79.65, 504.61)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 8
		helper_4116e6bb(4080050)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 9
		helper_4116e6bb(4080060)
		event.set_object_sequence_motion(0, "左向く", 6)
		event.queue_object_sequence_next_motion(0, "左向くL", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 10
		helper_4116e6bb(4080070)
		at = 11
		wait_objects(0)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 12
		helper_4116e6bb(4080080)
		at = 13
		helper_4116e6bb(4080090)
		event.set_object_sequence_motion(0, "左向く戻り", 6)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		at = 14
		wait_objects(0)
		event.set_character_active(11)
		event.set_character_active(12)
		event.set_object_sequence_motion(3, "出現", 6)
		event.queue_object_sequence_next_motion(3, "出現L", 4)
		event.set_character_active(1, 13)
		event.set_character_motion(13, "出現", 6)
		event.play_sound_effect(var0, 2)
		at = 15
		wait_frames(50)
		event.set_camera_sequence_position(-79.56, 83.32, 667.05)
		event.set_camera_sequence_look_at(-76.25, 31.32, 465.62)
		event.set_object_sequence_motion(0, "驚く", 6)
		event.queue_object_sequence_next_motion(0, "驚くL", 4)
		event.set_object_sequence_motion(1, "びっくりから上見", 6)
		event.queue_object_sequence_next_motion(1, "上向くL", 4)
		at = 16
		wait_objects(3)
		event.stop_music(0)
		event.start_background_file_loads_1("snd2/bgm/bg_191.sound.json")
		at = 17
		wait_frames(4)
		at = 18
		helper_479dc9e9()
		event.load_music_pack(191)
		event.play_music(0)
		event.set_camera_sequence_position(-82.34, 24.64, 525.1)
		event.set_camera_sequence_look_at(-68.49, 28.0, 544.23)
		event.set_character_active(0, 13)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "おこり顔")
		event.set_object_handle_texture_animation(0, 1, "おこり目パチ")
		event.set_mouth_texture_animations(0, "大口パク")
		at = 19
		helper_4116e6bb(4080100)
		event.set_camera_sequence_position(-73.64, 31.85, 524.1)
		event.set_camera_sequence_look_at(-86.33, 28.93, 539.68)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "おこり顔")
		event.set_object_handle_texture_animation(1, 1, "おこり目パチ")
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 20
		helper_4116e6bb(4080110)
		event.set_camera_sequence_position(-80.48, 94.7, 723.29)
		event.set_camera_sequence_look_at(-76.25, 38.16, 465.62)
		event.set_object_sequence_position(3, -78.11, -15.13, 426.88)
		event.set_object_sequence_motion(3, "攻撃", 6)
		event.queue_object_sequence_next_motion(3, "立ち2", 4)
		at = 21
		wait_frames(10)
		event.play_sound_effect(var0, 3)
		event.move_object_sequence(0, -44.9, 3.81, 599.34, 20)
		event.rotate_object_sequence(0, 0.0, 0.38, 0.0, 8)
		event.delay_object_sequence_rotation_track(0, 4)
		event.rotate_object_sequence(0, 0.0, -2.98, 0.0, 8)
		event.set_object_sequence_motion(0, "走り")
		event.delay_object_sequence_motion_track(0, 20)
		event.set_object_sequence_motion(0, "立ち")
		event.move_object_sequence(1, -112.34, 5.0, 594.97, 20)
		event.rotate_object_sequence(1, 0.0, -0.5, 0.0, 8)
		event.delay_object_sequence_rotation_track(1, 4)
		event.rotate_object_sequence(1, 0.0, 2.78, 0.0, 8)
		event.set_object_sequence_motion(1, "走り")
		event.delay_object_sequence_motion_track(1, 20)
		event.set_object_sequence_motion(1, "立ち")
		at = 22
		wait_objects(0)
		at = 23
		wait_objects(3)
		event.set_camera_sequence_position(-62.07, 18.74, 574.92)
		event.set_camera_sequence_look_at(-42.47, 24.02, 598.1)
		event.play_sound_effect(var0, 4)
		event.set_object_sequence_motion(0, "やめろ", 6)
		event.queue_object_sequence_next_motion(0, "驚くL", 4)
		event.set_mouth_texture_animations(0, "大口パク")
		at = 24
		helper_4116e6bb(4080120)
		at = 25
		wait_objects(0)
		event.set_camera_sequence_position(-90.65, 28.85, 590.7)
		event.set_camera_sequence_look_at(-115.93, 29.03, 592.13)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "おこり顔")
		event.set_object_handle_texture_animation(1, 1, "おこり目パチ")
		event.set_object_sequence_motion(1, "上向くL", 4, -1.0, 1)
		event.set_mouth_texture_animations(1, "大口パク")
		at = 26
		helper_4116e6bb(4080130)
		event.set_camera_sequence_position(-72.77, 80.75, 769.84)
		event.set_camera_sequence_look_at(-77.4, 43.66, 562.84)
		event.play_sound_effect(var0, 5)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "おこり顔")
		event.set_object_handle_texture_animation(1, 1, "おこり目パチ")
		event.set_object_sequence_motion(3, "威嚇", 6)
		event.queue_object_sequence_next_motion(3, "立ち2", 4)
		event.set_mouth_texture_animations(0, "大口パク")
		at = 27
		helper_4116e6bb(4080140)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 28
		helper_4116e6bb(4080150)
		event.stop_sound_effect(var0, 5)
		event.set_camera_sequence_position(-76.95, 45.52, 498.09)
		event.set_camera_sequence_look_at(-76.43, 15.43, 706.96)
		event.play_sound_effect(var0, 6)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "おこり顔")
		event.set_object_handle_texture_animation(0, 1, "おこり目～通常目")
		event.set_character_active(10)
		event.rotate_object_sequence_eased(4, rot_x, rot_y, var4, 40, 0, 0.5)
		event.delay_object_sequence_rotation_track(4, 168)
		event.rotate_object_sequence_eased(4, vector_x, vector_y, vector_z, 40, 0, 0.5)
		event.delay_object_sequence_position_track(5, 80)
		event.move_object_sequence_eased(5, pos_x, pos_y + 80.0, pos_z, 32, 1, 0.5)
		event.delay_object_sequence_position_track(5, 40)
		event.move_object_sequence_eased(5, pos_x, pos_y, pos_z, 32, 0, 0.5)
		event.set_object_sequence_motion(0, "立ち", 6)
		event.delay_object_sequence_motion_track(0, 4)
		event.set_object_sequence_motion(0, "振り向く（左）", 6)
		event.queue_object_sequence_next_motion(0, "振り向く（左）L", 4)
		event.set_object_sequence_motion(1, "立ち", 6)
		event.delay_object_sequence_motion_track(1, 10)
		event.set_object_sequence_motion(1, "振り向き", 6)
		event.queue_object_sequence_next_motion(1, "振り向きＬ", 4)
		at = 29
		wait_frames(90)
		event.set_object_sequence_motion(2, "上見走り")
		event.move_object_sequence(2, -76.55, 0.45, 877.82, 60, 1)
		at = 30
		wait_frames(10)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 31
		helper_1584c528(4080160, 50)
		at = 32
		wait_objects(2)
		event.set_camera_sequence_follow_object(2, 0.0, 18.3, -4.0, -2.0, -0.57, 24.0)
		event.set_object_sequence_position(2, -76.0, 1.92, 813.28)
		event.move_object_sequence(2, -78.0, 4.89, 551.73, 120, 1)
		event.delay_object_sequence_motion_track(2, 120)
		event.set_object_sequence_motion(2, "上見立ち")
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "おこり目")
		event.set_object_sequence_motion(0, "驚くL", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "上向くL", 4, -1.0, 1)
		at = 33
		helper_4116e6bb(4080170)
		at = 34
		wait_objects(2)
		event.release_camera_sequence_follow_object()
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 35
		helper_4116e6bb(4080180)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 36
		helper_4116e6bb(4080185)
		at = 37
		wait_frames(10)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "おこり目～おどろき目")
		event.set_object_sequence_motion(2, "！！", 2)
		event.queue_object_sequence_next_motion(2, "上見立ち")
		at = 38
		helper_0e75aa9e(4080190, -1, 0)
		event.set_camera_sequence_position(-73.07, -10.65, 595.6)
		event.set_camera_sequence_look_at(-87.35, 69.1, 460.59)
		event.play_sound_effect(var0, 7)
		event.set_character_active(0, 10)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "おこり目")
		event.set_object_sequence_motion(3, "攻撃", 6)
		event.delay_object_sequence_motion_track(3, 30)
		event.set_object_sequence_motion(3, "攻撃", 1)
		event.set_mouth_texture_animations(0, "通常口パク")
		event.open_voice_stream_wave(1, 4080200)
		at = 39
		var19 = helper_f616ba9e(1)
		event.set_message_button_prompt(0, 0)
		event.open_message_window_2(0, 4080200)
		open_message(0, -1, 8, 0, 0)
		event.play_voice_stream(1)
		at = 40
		wait_frames(vm.i32(30 - var19))
		event.set_camera_sequence_position(-92.53, 6.56, 559.96)
		event.set_camera_sequence_look_at(-39.54, 19.62, 593.16)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "おこり顔")
		event.set_object_handle_texture_animation(0, 1, "おこり目パチ")
		event.set_object_handle_texture_animation(0, 1, "大口パク")
		event.set_object_sequence_motion(0, "立ち", 4)
		event.set_object_sequence_motion(0, "走り")
		event.move_object_sequence(0, -64.66, 4.79, 541.75, 14, 1)
		at = 41
		wait_frames(14)
		close_message(0)
		event.close_voice_stream(1)
		event.set_message_button_prompt(0, 1)
		event.set_camera_sequence_position(-77.13, 11.5, 549.0)
		event.set_camera_sequence_look_at(-117.01, 21.86, 587.27)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "おこり顔")
		event.set_object_handle_texture_animation(1, 1, "おこり目パチ")
		event.set_object_handle_texture_animation(1, 1, "大口")
		event.set_object_sequence_motion(1, "上見びっくり", 6)
		event.queue_object_sequence_next_motion(1, "上向くL", 4)
		at = 42
		wait_frames(10)
		event.set_camera_sequence_position(-81.01, 33.49, 535.66)
		event.set_camera_sequence_look_at(-86.5, 39.49, 520.89)
		event.play_sound_effect(var0, 8)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "おこり顔")
		event.set_object_handle_texture_animation(0, 1, "おこり目パチ")
		event.set_object_handle_texture_animation(0, 1, "大口")
		event.set_object_sequence_motion(3, "攻撃2", 6)
		event.delay_object_sequence_motion_track(3, 10)
		event.set_object_sequence_motion(3, "攻撃", 1)
		event.set_object_sequence_position(0, -8.54, 2.83, 545.17)
		event.set_object_sequence_rotation(0, 0.0, -1.7, 0.0)
		at = 43
		wait_frames(4)
		event.move_camera_sequence_eased(-81.01, 33.49, 535.66, -67.85, 33.31, 537.58, 12, 0, 0.4)
		at = 44
		wait_frames(3)
		event.set_object_sequence_motion(0, "タックル", 6, -1.0, 1)
		at = 45
		wait_camera()
		event.set_object_sequence_motion(3, "攻撃3", 6)
		event.move_camera_sequence_eased(-157.5, 18.3, 524.15, -141.51, 23.91, 526.12, 8, 2, 1.0)
		event.shake_camera_sequence(0.0, 6.0, 0.0, 30)
		at = 46
		wait_frames(2)
		if active_chr_no == 0 then
			event.set_character_active(0, 0)
		else
			event.set_character_active(0, 8)
			event.set_character_active(0, 9)
		end
		at = 47
		helper_1584c528(4080205, 40)
		at = 48
		wait_camera()
		event.set_camera_sequence_position(-154.32, 107.18, 768.06)
		event.set_camera_sequence_look_at(-95.44, 20.24, 463.89)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "おこり顔")
		event.set_object_handle_texture_animation(0, 1, "おこり目パチ")
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "おこり顔")
		event.set_object_handle_texture_animation(1, 1, "おこり目パチ")
		if active_chr_no == 0 then
			event.set_character_active(0)
		else
			event.set_character_active(8)
			event.set_character_active(9)
		end
		event.set_character_active(10)
		event.set_object_sequence_position(0, -144.47, 6.3, 567.45)
		event.set_object_sequence_rotation(0, 0.0, 2.02, 0.0)
		event.set_object_sequence_motion(0, "立ちあがる", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		event.set_object_sequence_motion(1, "立ち", 4, -1.0, 1)
		event.set_object_sequence_position(2, -168.07, 3.48, 508.64)
		event.set_object_sequence_rotation(2, 0.0, 1.22, 0.0)
		event.reset_object_sequence_motion(2)
		event.set_object_sequence_motion(2, "立ちあがる", 6)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		event.set_object_sequence_position(3, -50.57, -15.41, 428.09)
		event.set_object_sequence_rotation(3, 0.0, -0.36, 0.0)
		event.set_object_sequence_motion(3, "立ち2", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 49
		helper_4116e6bb(4080210)
		event.set_object_sequence_motion(1, "走り")
		event.move_object_sequence(1, -111.4, 3.75, 698.18, 40, 1)
		event.rotate_object_sequence(1, 0.0, 0.14, 0.0, 8)
		at = 50
		wait_frames(2)
		event.set_object_sequence_motion(0, "走り")
		event.move_object_sequence(0, -146.03, 4.47, 681.95, 50, 1)
		event.rotate_object_sequence(0, 0.0, 0.1, 0.0, 8)
		at = 51
		wait_frames(8)
		event.set_object_sequence_motion(2, "走り")
		event.move_object_sequence(2, -157.24, 4.74, 682.84, 50, 1)
		event.rotate_object_sequence(2, 0.0, 0.02, 0.0, 8)
		at = 52
		wait_objects(2)
		event.set_camera_sequence_position(-76.59, 45.52, 642.13)
		event.set_camera_sequence_look_at(-76.07, 15.43, 850.71)
		event.fade_out_music(60)
		event.move_object_sequence(1, -85.95, -25.91, 1068.48, 80, 1)
		event.delay_object_sequence_motion_track(1, 80)
		event.set_object_sequence_motion(1, "立ち")
		event.delay_object_sequence_rotation_track(1, 72)
		event.rotate_object_sequence(1, 0.0, 3.02, 0.0, 8)
		event.delay_object_sequence_rotation_track(4, 90)
		event.rotate_object_sequence_eased(4, rot_x, rot_y, var4, 40, 0, 0.5)
		event.delay_object_sequence_position_track(5, 130)
		event.move_object_sequence_eased(5, pos_x, pos_y + 80.0, pos_z, 32, 1, 0.5)
		event.delay_object_sequence_sound_track(5, 90)
		event.play_object_sequence_sound(5, var0, 9)
		at = 53
		wait_frames(4)
		event.set_object_sequence_position(0, -61.85, 3.51, 650.67)
		event.set_object_sequence_rotation(0, 0.0, -0.1, 0.0)
		event.move_object_sequence(0, -54.15, -4.35, 911.55, 60, 1)
		event.delay_object_sequence_motion_track(0, 60)
		event.set_object_sequence_motion(0, "立ち")
		event.delay_object_sequence_motion_track(0, 5)
		event.set_object_sequence_motion(0, "振り向く（右）", 6)
		event.queue_object_sequence_next_motion(0, "振り向く（右）L", 4)
		at = 54
		wait_frames(10)
		event.set_object_sequence_position(2, -87.61, 3.87, 655.48)
		event.set_object_sequence_rotation(2, 0.0, 0.1, 0.0)
		event.move_object_sequence(2, -87.84, 2.52, 774.78, 40, 1)
		event.delay_object_sequence_motion_track(2, 40)
		event.set_object_sequence_motion(2, "振り向く", 2)
		event.queue_object_sequence_next_motion(2, "振り向くL", 4)
		at = 55
		wait_objects(2)
		at = 56
		helper_4116e6bb(4080220)
		event.set_mouth_texture_animations(0, "大口パク")
		at = 57
		helper_4116e6bb(4080230)
		at = 58
		wait_objects(5)
		event.set_object_sequence_motion(1, "走り")
		event.delay_object_sequence_motion_track(1, 50)
		event.set_object_sequence_motion(1, "立ち")
		event.move_object_sequence(1, -19.76, -41.08, 1213.94, 50)
		event.rotate_object_sequence(1, 0.0, 0.26, 0.0, 6)
		event.set_object_sequence_motion(0, "振り向く（右）戻り", 6)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		event.delay_object_sequence_motion_track(0, 1)
		event.set_object_sequence_motion(0, "走り")
		event.delay_object_sequence_position_track(0, 18)
		event.move_object_sequence(0, -66.76, -20.35, 1068.29, 40, 1)
		at = 59
		wait_frames(10)
		event.set_object_sequence_motion(2, "振り向く戻り", 6)
		event.queue_object_sequence_next_motion(2, "走り")
		event.delay_object_sequence_position_track(2, 20)
		event.move_object_sequence(2, -82.88, -2.14, 896.69, 40, 1)
		at = 60
		wait_frames(4)
		at = 61
		wait_frames(6)
		event.fade_out_screen(30)
		at = 62
		wait_frames(30)
	end, function(received: { any }): boolean
		if at == 39 then
			var19 = received[1] :: number
		end
		if at <= 2 then
			var4 = vm.f32(vector_z - vm.f32(3.1415927))
			helper_238b5abc(1)
		end
		if at <= 3 then
			helper_8cd371d7(4080010)
		end
		if at <= 4 then
			helper_8cd371d7(4080020)
		end
		if at <= 5 then
			helper_8cd371d7(4080030)
		end
		if at <= 6 then
			pos_x_2 = -140.0
			var12 = vm.f32(1.9)
			var13 = vm.f32(-0.044)
			var15 = 0
			var16 = 0
			var14 = 0
			pos_x_2 = vm.f32(pos_x_2 + var12)
			var12 = vm.f32(var12 + var13)
			local _ = var15 == 1
			var15 = 0
			var16 = 1
			local _ = var16 == 1
			var16 = 0
			helper_f018b3c0(0, -1, 8, 0, 0)
			var18 = 4080040
			var15 = 1
			helper_d16eef1e(0)
			var18 = 4080045
			var15 = 1
			local _ = var14 < 440
			local _ = var14 < 42
			local _ = var14 == 0
			local _ = var14 == 180
			var14 = var14 + 1
		end
		if at <= 7 then
			helper_d16eef1e(0)
			helper_8cd371d7(4080050)
		end
		if at <= 8 then
			helper_8cd371d7(4080060)
		end
		if at <= 9 then
			helper_8cd371d7(4080070)
		end
		if at <= 10 then
			helper_238b5abc(0)
		end
		if at <= 11 then
			helper_8cd371d7(4080080)
		end
		if at <= 12 then
			helper_8cd371d7(4080090)
		end
		if at <= 13 then
			helper_238b5abc(0)
		end
		if at <= 14 then
			wait_frames_skipping(50)
		end
		if at <= 15 then
			helper_238b5abc(3)
		end
		if at <= 16 then
			wait_frames_skipping(4)
		end
		if at <= 17 then
			helper_344d6cd8()
		end
		if at <= 18 then
			helper_8cd371d7(4080100)
		end
		if at <= 19 then
			helper_8cd371d7(4080110)
		end
		if at <= 20 then
			wait_frames_skipping(10)
		end
		if at <= 21 then
			helper_238b5abc(0)
		end
		if at <= 22 then
			helper_238b5abc(3)
		end
		if at <= 23 then
			helper_8cd371d7(4080120)
		end
		if at <= 24 then
			helper_238b5abc(0)
		end
		if at <= 25 then
			helper_8cd371d7(4080130)
		end
		if at <= 26 then
			helper_8cd371d7(4080140)
		end
		if at <= 27 then
			helper_8cd371d7(4080150)
		end
		if at <= 28 then
			wait_frames_skipping(90)
		end
		if at <= 29 then
			wait_frames_skipping(10)
		end
		if at <= 30 then
			helper_52aadc70(4080160, 50)
		end
		if at <= 31 then
			helper_238b5abc(2)
		end
		if at <= 32 then
			helper_8cd371d7(4080170)
		end
		if at <= 33 then
			helper_238b5abc(2)
		end
		if at <= 34 then
			helper_8cd371d7(4080180)
		end
		if at <= 35 then
			helper_8cd371d7(4080185)
		end
		if at <= 36 then
			wait_frames_skipping(10)
		end
		if at <= 37 then
			helper_2f8c501c(4080190, -1, 0)
		end
		if at <= 38 then
			var19 = helper_523109b8(1)
		end
		if at <= 39 then
			helper_f018b3c0(0, -1, 8, 0, 0)
			wait_frames_skipping(vm.i32(30 - var19))
		end
		if at <= 40 then
			wait_frames_skipping(14)
		end
		if at <= 41 then
			helper_d16eef1e(0)
			wait_frames_skipping(10)
		end
		if at <= 42 then
			wait_frames_skipping(4)
		end
		if at <= 43 then
			wait_frames_skipping(3)
		end
		if at <= 44 then
			helper_344d6cd8()
		end
		if at <= 45 then
			wait_frames_skipping(2)
		end
		if at <= 46 then
			helper_52aadc70(4080205, 40)
		end
		if at <= 47 then
			helper_344d6cd8()
		end
		if at <= 48 then
			helper_8cd371d7(4080210)
		end
		if at <= 49 then
			wait_frames_skipping(2)
		end
		if at <= 50 then
			wait_frames_skipping(8)
		end
		if at <= 51 then
			helper_238b5abc(2)
		end
		if at <= 52 then
			wait_frames_skipping(4)
		end
		if at <= 53 then
			wait_frames_skipping(10)
		end
		if at <= 54 then
			helper_238b5abc(2)
		end
		if at <= 55 then
			helper_8cd371d7(4080220)
		end
		if at <= 56 then
			helper_8cd371d7(4080230)
		end
		if at <= 57 then
			helper_238b5abc(5)
		end
		if at <= 58 then
			wait_frames_skipping(10)
		end
		if at <= 59 then
			wait_frames_skipping(4)
		end
		if at <= 60 then
			wait_frames_skipping(6)
		end
		if at <= 61 then
			wait_frames_skipping(30)
		end
		return true
	end)
	at = 63
	vm.entry(63)
	event.cancel_drama_scene_skip()
	event.stop_sound_effect(var0, 2)
	event.stop_sound_effect(var0, 5)
	event.stop_sound_effect(var0, 6)
	event.stop_sound_effect(var0, 8)
	event.stop_sound_effect(var0, 9)
	event.stop_sound_effect(var0, 11)
	event.stop_music(0)
	event.set_scene_status_flags(1, 0, 256, 0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.set_object_handle_motion(0, "立ち", 4)
	event.set_object_handle_motion(1, "立ち", 4)
	event.set_object_handle_rotation(4, vector_x, vector_y, vector_z)
	event.set_object_handle_position(5, pos_x, pos_y, pos_z)
	event.delete_character_extension_packs(0)
	event.delete_character(8)
	event.delete_character(9)
	event.delete_character(10)
	event.delete_character(11)
	event.delete_character(12)
	event.delete_character(13)
	event.load_message_file(0, -1)
	event.show_dungeon_status_bar(1, 1.0)
	event.set_object_handle_visible(6, 1)
	event.set_object_handle_visible(7, 1)
	event.skip_next_music_load()
	event.finish_event()
end

return helper_0f67d486
