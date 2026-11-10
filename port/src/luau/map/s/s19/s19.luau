--!strict
-- map/s/s19/s19.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local close_message = require("@lib/event/close_message")
local helper_0382f327 = require("@lib/event/helper_0382f327")
local helper_038a2e4d = require("@lib/event/helper_038a2e4d")
local helper_238b5abc = require("@lib/event/helper_238b5abc")
local helper_2609f66b = require("@lib/event/helper_2609f66b")
local helper_26c3d54b = require("@lib/event/helper_26c3d54b")
local helper_344d6cd8 = require("@lib/event/helper_344d6cd8")
local helper_3d13e6aa = require("@lib/event/helper_3d13e6aa")
local helper_4116e6bb = require("@lib/event/helper_4116e6bb")
local helper_479dc9e9 = require("@lib/event/helper_479dc9e9")
local helper_4a9b8bc5 = require("@lib/event/helper_4a9b8bc5")
local helper_523109b8 = require("@lib/event/helper_523109b8")
local helper_53ffe901 = require("@lib/event/helper_53ffe901")
local helper_581cb30c = require("@lib/event/helper_581cb30c")
local helper_75684dd8 = require("@lib/event/helper_75684dd8")
local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")
local helper_8cd371d7 = require("@lib/event/helper_8cd371d7")
local helper_9dafbc83 = require("@lib/event/helper_9dafbc83")
local helper_a6838a9a = require("@lib/event/helper_a6838a9a")
local helper_a9eaf20e = require("@lib/event/helper_a9eaf20e")
local helper_bac0e30d = require("@lib/event/helper_bac0e30d")
local helper_c956b4a2 = require("@lib/event/helper_c956b4a2")
local helper_d16eef1e = require("@lib/event/helper_d16eef1e")
local helper_f018b3c0 = require("@lib/event/helper_f018b3c0")
local helper_f616ba9e = require("@lib/event/helper_f616ba9e")
local helper_f9968159 = require("@lib/event/helper_f9968159")
local open_message = require("@lib/event/open_message")
local wait_camera = require("@lib/event/wait_camera")
local wait_objects = require("@lib/event/wait_objects")

--- Event 99, which map data, a script or the engine runs by number.
local function event_99()
	local flag: s32 = 0
	local flag_2: s32 = 0
	local var2: s32 = 0
	event.load_map_sounds(4684)
	flag = event.get_save_flag(408) or flag
	flag_2 = event.get_save_flag(420) or flag_2
	var2 = event.get_save_data_value(2) or var2
	if flag == 1 and flag_2 == 0 and var2 == 1 then
	else
		event.stop_music(0)
		helper_888ab2a3(4)
		event.load_music(167)
		event.play_music(0)
	end
end

--- Helper function.
local function helper_11c1c()
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
		event.load_message_file(0, 5, "e408.txt")
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
			if var14 == 150 then
				close_message(0)
				event.close_voice_stream(1)
				var18 = 4080043
				event.open_voice_stream_wave(1, var18)
				var15 = 1
			end
			if var14 == 324 then
				close_message(0)
				event.close_voice_stream(1)
				var18 = 4080046
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
		helper_a6838a9a(4080090, -1)
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
		helper_888ab2a3(50)
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
		helper_888ab2a3(4)
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
		helper_888ab2a3(10)
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
		event.set_camera_sequence_position(-90.65, 28.85, 590.7)
		event.set_camera_sequence_look_at(-115.93, 29.03, 592.13)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "おこり顔")
		event.set_object_handle_texture_animation(1, 1, "おこり目パチ")
		event.set_object_sequence_motion(1, "上向くL", 4, -1.0, 1)
		event.set_mouth_texture_animations(1, "大口パク")
		at = 25
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
		at = 26
		helper_4116e6bb(4080140)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 27
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
		at = 28
		helper_888ab2a3(90)
		event.set_object_sequence_motion(2, "上見走り")
		event.move_object_sequence(2, -76.55, 0.45, 877.82, 60, 1)
		at = 29
		helper_888ab2a3(10)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 30
		helper_0382f327(4080160, 50)
		at = 31
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
		at = 32
		helper_4116e6bb(4080170)
		at = 33
		wait_objects(2)
		event.release_camera_sequence_follow_object()
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 34
		helper_4116e6bb(4080180)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 35
		helper_4116e6bb(4080185)
		at = 36
		helper_888ab2a3(10)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "おこり目～おどろき目")
		event.set_object_sequence_motion(2, "！！", 2)
		event.queue_object_sequence_next_motion(2, "上見立ち")
		at = 37
		helper_a6838a9a(4080190, -1)
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
		at = 38
		var19 = helper_f616ba9e(1)
		event.set_message_button_prompt(0, 0)
		event.open_message_window_2(0, 4080200)
		open_message(0, -1, 8, 0, 0)
		event.play_voice_stream(1)
		at = 39
		helper_888ab2a3(vm.i32(30 - var19))
		event.set_camera_sequence_position(-92.53, 6.56, 559.96)
		event.set_camera_sequence_look_at(-39.54, 19.62, 593.16)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "おこり顔")
		event.set_object_handle_texture_animation(0, 1, "おこり目パチ")
		event.set_object_handle_texture_animation(0, 1, "大口パク")
		event.set_object_sequence_motion(0, "立ち", 4)
		event.set_object_sequence_motion(0, "走り")
		event.move_object_sequence(0, -64.66, 4.79, 541.75, 14, 1)
		at = 40
		helper_888ab2a3(14)
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
		at = 41
		helper_888ab2a3(10)
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
		at = 42
		helper_888ab2a3(4)
		event.move_camera_sequence_eased(-81.01, 33.49, 535.66, -67.85, 33.31, 537.58, 12, 0, 0.4)
		at = 43
		helper_888ab2a3(3)
		event.set_object_sequence_motion(0, "タックル", 6, -1.0, 1)
		at = 44
		wait_camera()
		event.set_object_sequence_motion(3, "攻撃3", 6)
		event.move_camera_sequence_eased(-157.5, 18.3, 524.15, -141.51, 23.91, 526.12, 8, 2, 1.0)
		event.shake_camera_sequence(0.0, 6.0, 0.0, 30)
		at = 45
		helper_888ab2a3(2)
		if active_chr_no == 0 then
			event.set_character_active(0, 0)
		else
			event.set_character_active(0, 8)
			event.set_character_active(0, 9)
		end
		at = 46
		helper_0382f327(4080205, 40)
		at = 47
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
		at = 48
		helper_4116e6bb(4080210)
		event.set_object_sequence_motion(1, "走り")
		event.move_object_sequence(1, -111.4, 3.75, 698.18, 40, 1)
		event.rotate_object_sequence(1, 0.0, 0.14, 0.0, 8)
		at = 49
		helper_888ab2a3(2)
		event.set_object_sequence_motion(0, "走り")
		event.move_object_sequence(0, -146.03, 4.47, 681.95, 50, 1)
		event.rotate_object_sequence(0, 0.0, 0.1, 0.0, 8)
		at = 50
		helper_888ab2a3(8)
		event.set_object_sequence_motion(2, "走り")
		event.move_object_sequence(2, -157.24, 4.74, 682.84, 50, 1)
		event.rotate_object_sequence(2, 0.0, 0.02, 0.0, 8)
		at = 51
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
		at = 52
		helper_888ab2a3(4)
		event.set_object_sequence_position(0, -61.85, 3.51, 650.67)
		event.set_object_sequence_rotation(0, 0.0, -0.1, 0.0)
		event.move_object_sequence(0, -54.15, -4.35, 911.55, 60, 1)
		event.delay_object_sequence_motion_track(0, 60)
		event.set_object_sequence_motion(0, "立ち")
		event.delay_object_sequence_motion_track(0, 5)
		event.set_object_sequence_motion(0, "振り向く（右）", 6)
		event.queue_object_sequence_next_motion(0, "振り向く（右）L", 4)
		at = 53
		helper_888ab2a3(10)
		event.set_object_sequence_position(2, -87.61, 3.87, 655.48)
		event.set_object_sequence_rotation(2, 0.0, 0.1, 0.0)
		event.move_object_sequence(2, -87.84, 2.52, 774.78, 40, 1)
		event.delay_object_sequence_motion_track(2, 40)
		event.set_object_sequence_motion(2, "振り向く", 2)
		event.queue_object_sequence_next_motion(2, "振り向くL", 4)
		at = 54
		wait_objects(2)
		at = 55
		helper_4116e6bb(4080220)
		event.set_mouth_texture_animations(0, "大口パク")
		at = 56
		helper_4116e6bb(4080230)
		at = 57
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
		at = 58
		helper_888ab2a3(10)
		event.set_object_sequence_motion(2, "振り向く戻り", 6)
		event.queue_object_sequence_next_motion(2, "走り")
		event.delay_object_sequence_position_track(2, 20)
		event.move_object_sequence(2, -82.88, -2.14, 896.69, 40, 1)
		at = 59
		helper_888ab2a3(4)
		at = 60
		helper_888ab2a3(6)
		event.fade_out_screen(30)
		at = 61
		helper_888ab2a3(30)
	end, function(received: { any }): boolean
		if at == 38 then
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
			var18 = 4080043
			var15 = 1
			helper_d16eef1e(0)
			var18 = 4080046
			var15 = 1
			local _ = var14 < 440
			local _ = var14 < 42
			local _ = var14 == 0
			local _ = var14 == 150
			local _ = var14 == 324
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
			helper_26c3d54b(4080090, -1)
		end
		if at <= 13 then
			helper_238b5abc(0)
		end
		if at <= 14 then
			helper_038a2e4d(50)
		end
		if at <= 15 then
			helper_238b5abc(3)
		end
		if at <= 16 then
			helper_038a2e4d(4)
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
			helper_038a2e4d(10)
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
			helper_8cd371d7(4080130)
		end
		if at <= 25 then
			helper_8cd371d7(4080140)
		end
		if at <= 26 then
			helper_8cd371d7(4080150)
		end
		if at <= 27 then
			helper_038a2e4d(90)
		end
		if at <= 28 then
			helper_038a2e4d(10)
		end
		if at <= 29 then
			helper_53ffe901(4080160, 50)
		end
		if at <= 30 then
			helper_238b5abc(2)
		end
		if at <= 31 then
			helper_8cd371d7(4080170)
		end
		if at <= 32 then
			helper_238b5abc(2)
		end
		if at <= 33 then
			helper_8cd371d7(4080180)
		end
		if at <= 34 then
			helper_8cd371d7(4080185)
		end
		if at <= 35 then
			helper_038a2e4d(10)
		end
		if at <= 36 then
			helper_26c3d54b(4080190, -1)
		end
		if at <= 37 then
			var19 = helper_523109b8(1)
		end
		if at <= 38 then
			helper_f018b3c0(0, -1, 8, 0, 0)
			helper_038a2e4d(vm.i32(30 - var19))
		end
		if at <= 39 then
			helper_038a2e4d(14)
		end
		if at <= 40 then
			helper_d16eef1e(0)
			helper_038a2e4d(10)
		end
		if at <= 41 then
			helper_038a2e4d(4)
		end
		if at <= 42 then
			helper_038a2e4d(3)
		end
		if at <= 43 then
			helper_344d6cd8()
		end
		if at <= 44 then
			helper_038a2e4d(2)
		end
		if at <= 45 then
			helper_53ffe901(4080205, 40)
		end
		if at <= 46 then
			helper_344d6cd8()
		end
		if at <= 47 then
			helper_8cd371d7(4080210)
		end
		if at <= 48 then
			helper_038a2e4d(2)
		end
		if at <= 49 then
			helper_038a2e4d(8)
		end
		if at <= 50 then
			helper_238b5abc(2)
		end
		if at <= 51 then
			helper_038a2e4d(4)
		end
		if at <= 52 then
			helper_038a2e4d(10)
		end
		if at <= 53 then
			helper_238b5abc(2)
		end
		if at <= 54 then
			helper_8cd371d7(4080220)
		end
		if at <= 55 then
			helper_8cd371d7(4080230)
		end
		if at <= 56 then
			helper_238b5abc(5)
		end
		if at <= 57 then
			helper_038a2e4d(10)
		end
		if at <= 58 then
			helper_038a2e4d(4)
		end
		if at <= 59 then
			helper_038a2e4d(6)
		end
		if at <= 60 then
			helper_038a2e4d(30)
		end
		return true
	end)
	at = 62
	vm.entry(62)
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

--- Helper function.
local function helper_1bfac()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local block: s32 = 0
	local rot_x: f32 = 0
	local rot_y: f32 = 0
	local var5: f32 = 0
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
		event.set_save_flag(416, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.show_dungeon_status_bar(0, 1.0)
		event.stop_music(0)
		at = 2
		helper_888ab2a3(6)
		event.load_music(30)
		event.load_map_sounds(4809)
		var0 = event.load_sound_effect_file_2(4809) or var0
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		active_chr_no = event.get_playable_character() or active_chr_no
		event.set_scene_status_flags(1, 0, 256, 1)
		event.change_directory("event/e400/e416/")
		event.load_message_file(0, 5, "e416.txt")
		if active_chr_no == 0 then
			event.load_character_motion_pack(5, "e416_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if active_chr_no == 1 then
			event.load_character_motion_pack(5, "e416_monica.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		block = event.load_event_image_4(5, "e416telop01.json", 0) or block
		event.reset_event_sprite(0)
		event.set_event_sprite_type(0, 0)
		event.set_event_sprite_texture(0, "e416telop01", block)
		event.set_event_sprite_color(0, 128, 128, 128, 0)
		event.set_event_sprite_texture_rect(0, 0, 0, 512, 128)
		event.set_event_sprite_size(0, 512, 128)
		event.set_event_sprite_position(0, 256, 312)
		event.set_event_sprite_alpha_blend(0, 0)
		event.set_event_sprite_draw_pass(0, 0)
		event.attach_object_handle_to_sprite(7, 0)
		event.clear_object_sequence(5)
		event.set_object_sequence_object(5, 7)
		event.change_directory("")
		event.load_character(5, "event/e400/e410/e410_shigu.gltf", "info", 10)
		event.set_character_active(10)
		event.attach_object_handle_to_character(2, 10)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.load_character(5, "event/e400/e410/mariometto_a.gltf", "info", 11)
		event.set_character_active(11)
		event.attach_character_to_frame(10, "metto_null", 11)
		if active_chr_no == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 8)
			event.load_equipment_model(5, 0, 4, "info", 8)
			event.load_equipment_model(5, 0, 3, "info", 8)
			event.load_equipment_model(5, 0, 2, "info", 8, 9)
			event.load_character_motion_pack(5, "event/e400/e416/e416_mints.gltf", "info", 8)
			event.attach_object_handle_to_character(0, 8)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		else
			event.load_character(5, "chara/c02_base.gltf", "info", 8)
			event.load_equipment_model(5, 1, 4, "info", 8)
			event.load_equipment_model(5, 1, 3, "info", 8)
			event.load_equipment_model(5, 1, 2, "info", 8, 9)
			event.load_character_motion_pack(5, "event/e400/e416/e416_monica.gltf", "info", 8)
			event.attach_object_handle_to_character(1, 8)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.set_character_active(8)
		event.set_character_active(9)
		event.attach_object_handle_to_character(5, 1)
		event.attach_object_handle_to_character(6, 2)
		event.attach_object_handle_to_map_part_3(3, "p06_s19", "s19_09-m1")
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.attach_object_handle_to_map_part_3(4, "p06_s19", "s19_10-m1")
		event.clear_object_sequence(4)
		event.set_object_sequence_object(4, 4)
		event.set_object_handle_position(0, -65.0, -38.28, 1157.0)
		event.set_object_handle_rotation(0, 0.0, 3.14, 0.0)
		event.set_object_handle_motion(0, "立ち", 4)
		event.set_object_handle_footstep_sound(0, 16)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "おこり顔")
		event.set_object_handle_texture_animation(0, 1, "おこり目パチ")
		event.set_object_handle_position(1, -85.0, -38.13, 1157.0)
		event.set_object_handle_rotation(1, 0.0, 3.14, 0.0)
		event.set_object_handle_motion(1, "立ち", 4)
		event.set_object_handle_footstep_sound(1, 16)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "おこり顔")
		event.set_object_handle_texture_animation(1, 1, "おこり目パチ")
		event.set_object_handle_position(2, -78.11, -15.13, 426.88)
		event.set_object_handle_rotation(2, 0.0, 0.0, 0.0)
		event.set_object_handle_motion(2, "威嚇", 4)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "赤目パチ")
		event.set_object_handle_visible(5, 0)
		event.set_object_handle_visible(6, 0)
		do
			local out1, out2, out3 = event.get_object_handle_rotation(3)
			rot_x = out1 or rot_x
			rot_y = out2 or rot_y
			var5 = out3 or var5
		end
		do
			local out1, out2, out3 = event.copy_vector(rot_x, rot_y, var5)
			vector_x = out1 or vector_x
			vector_y = out2 or vector_y
			vector_z = out3 or vector_z
		end
		do
			local out1, out2, out3 = event.get_object_handle_position(4)
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		var5 = vm.f32(vector_z - vm.f32(3.1415927))
		var5 = event.wrap_angle(var5) or var5
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-228.84, 94.46, 882.3)
		event.set_camera_sequence_look_at(-94.17, 38.37, 1068.72)
		event.rotate_object_sequence_eased(3, rot_x, rot_y, var5, 40, 0, 0.5)
		event.delay_object_sequence_position_track(4, 80)
		event.move_object_sequence_eased(4, pos_x, pos_y + 80.0, pos_z, 32, 1, 0.5)
		event.delay_object_sequence_position_track(0, 100)
		event.move_object_sequence(0, -65.0, -16.86, 1002.55, 40)
		event.delay_object_sequence_motion_track(0, 100)
		event.set_object_sequence_motion(0, "走り")
		event.delay_object_sequence_motion_track(0, 40)
		event.set_object_sequence_motion(0, "立ち")
		event.delay_object_sequence_position_track(1, 110)
		event.move_object_sequence(1, -85.0, -16.86, 1002.55, 40)
		event.delay_object_sequence_motion_track(1, 110)
		event.set_object_sequence_motion(1, "走り")
		event.delay_object_sequence_motion_track(1, 40)
		event.set_object_sequence_motion(1, "立ち")
		event.fade_in_screen(30)
		at = 3
		helper_888ab2a3(30)
		event.play_sound_effect(var0, 0)
		at = 4
		wait_objects(1)
		at = 5
		helper_888ab2a3(10)
		event.set_camera_sequence_position(-70.27, 35.0, 783.66)
		event.set_camera_sequence_look_at(-73.25, 38.33, 674.48)
		event.set_event_sprite_draw_pass(0, 1)
		event.set_object_sequence_color(5, 128, 128, 128, 128, 30)
		event.play_sound_effect(var0, 1)
		event.set_object_sequence_position(0, -50.18, 3.08, 671.54)
		event.set_object_sequence_rotation(0, 0.0, -2.9, 0)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_object_sequence_position(1, -96.49, 3.79, 674.91)
		event.set_object_sequence_rotation(1, 0.0, 2.78, 0.0)
		event.reset_object_sequence_dynamic_animation(1)
		event.play_music(0)
		at = 6
		helper_4116e6bb(4160010)
		event.set_event_sprite_draw_pass(0, 0)
		event.stop_sound_effect(var0, 1)
		event.set_camera_sequence_position(-29.56, 15.56, 642.62)
		event.set_camera_sequence_look_at(-64.62, 25.05, 676.95)
		event.set_object_sequence_motion(0, "間抜け立ち", 4, -1.0, 1)
		event.set_object_sequence_position(1, -78.55, 3.48, 677.41)
		event.set_object_sequence_rotation(1, 0.0, 2.3, 0.0)
		event.set_object_sequence_motion(1, "指差し", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(1, "指差し会話", 6)
		event.queue_object_sequence_next_motion(1, "指差しＬ", 4)
		event.set_mouth_texture_animations(1, "大口パク")
		at = 7
		helper_4116e6bb(4160020)
		at = 8
		wait_objects(1)
		event.set_object_sequence_motion(0, "うん！", 2)
		event.queue_object_sequence_next_motion(0, "間抜け立ち", 4)
		at = 9
		helper_888ab2a3(10)
		event.play_sound_effect(var0, 2)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 10
		helper_4116e6bb(4160030)
		at = 11
		wait_objects(0)
		event.fade_out_screen(30)
		at = 12
		helper_888ab2a3(30)
	end, function(received: { any }): boolean
		if at <= 1 then
			helper_038a2e4d(6)
		end
		if at <= 2 then
			var5 = vm.f32(vector_z - vm.f32(3.1415927))
			helper_038a2e4d(30)
		end
		if at <= 3 then
			helper_238b5abc(1)
		end
		if at <= 4 then
			helper_038a2e4d(10)
		end
		if at <= 5 then
			helper_8cd371d7(4160010)
		end
		if at <= 6 then
			helper_8cd371d7(4160020)
		end
		if at <= 7 then
			helper_238b5abc(1)
		end
		if at <= 8 then
			helper_038a2e4d(10)
		end
		if at <= 9 then
			helper_8cd371d7(4160030)
		end
		if at <= 10 then
			helper_238b5abc(0)
		end
		if at <= 11 then
			helper_038a2e4d(30)
		end
		return true
	end)
	at = 13
	vm.entry(13)
	event.cancel_drama_scene_skip()
	event.stop_sound_effect(var0, 0)
	event.stop_sound_effect(var0, 1)
	event.stop_sound_effect(var0, 2)
	event.set_event_sprite_draw_pass(0, 0)
	event.play_music(0)
	event.set_scene_status_flags(1, 0, 256, 0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.set_object_handle_motion(0, "立ち", 4)
	event.set_object_handle_motion(1, "立ち", 4)
	event.set_object_handle_rotation(3, vector_x, vector_y, vector_z)
	event.set_object_handle_position(4, pos_x, pos_y, pos_z)
	event.delete_character_extension_packs(0)
	event.delete_character(8)
	event.delete_character(9)
	event.delete_character(10)
	event.delete_character(11)
	event.delete_event_image(0)
	event.load_message_file(0, -1)
	event.show_dungeon_status_bar(1, 1.0)
	event.set_object_handle_visible(5, 1)
	event.set_object_handle_visible(6, 1)
	event.set_character_active(0)
	event.set_character_position(0, -96.2, 1.8, 851.5)
	event.set_character_rotation(0, 0.0, 3.14, 0.0)
	event.set_character_motion(0, "立ち", 4)
	event.update_character_motion(0)
	event.reset_character_cloth_and_hair(0)
	event.set_camera_look_at(-96.2, 31.8, 851.5)
	event.set_camera_position(-96.2, 41.8, 951.5)
	event.reset_follow_camera(0)
	at = 14
	vm.wait(14)
	event.load_dungeon_monster(516, 1)
	event.load_dungeon_monster(1001, 0)
	event.place_dungeon_monster(516, -78.11, -15.13, 426.88, 0.0, 0.0, 0.0)
	event.fade_in_screen(30)
	event.finish_event()
end

--- Helper function.
local function helper_199cc()
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
	local at: number = 0
	vm.section(function()
		at = 1
		vm.entry(1)
		event.set_save_flag(410, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.show_dungeon_status_bar(0, 1.0)
		event.load_map_sounds(4806)
		var0 = event.load_sound_effect_file_2(4806) or var0
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		active_chr_no = event.get_playable_character() or active_chr_no
		event.set_scene_status_flags(1, 0, 256, 1)
		event.change_directory("event/e400/e410/")
		event.load_message_file(0, 5, "e410.txt")
		if active_chr_no == 0 then
			event.load_character_motion_pack(5, "e410_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if active_chr_no == 1 then
			event.load_character_motion_pack(5, "e410_monica.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.load_character(5, "e410_shigu.gltf", "info", 10)
		event.set_character_active(10)
		event.attach_object_handle_to_character(2, 10)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.load_character(5, "mariometto_a.gltf", "info", 11)
		event.set_character_active(11)
		event.attach_character_to_frame(10, "metto_null", 11)
		event.change_directory("")
		if active_chr_no == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 8)
			event.load_equipment_model(5, 0, 4, "info", 8)
			event.load_equipment_model(5, 0, 3, "info", 8)
			event.load_equipment_model(5, 0, 2, "info", 8, 9)
			event.load_character_motion_pack(5, "event/e400/e410/e410_mints.gltf", "info", 8)
			event.attach_object_handle_to_character(0, 8)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		else
			event.load_character(5, "chara/c02_base.gltf", "info", 8)
			event.load_equipment_model(5, 1, 4, "info", 8)
			event.load_equipment_model(5, 1, 3, "info", 8)
			event.load_equipment_model(5, 1, 2, "info", 8, 9)
			event.load_character_motion_pack(5, "event/e400/e410/e410_monica.gltf", "info", 8)
			event.attach_object_handle_to_character(1, 8)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.set_character_active(8)
		event.set_character_active(9)
		event.attach_object_handle_to_character(5, 1)
		event.attach_object_handle_to_character(6, 2)
		event.attach_object_handle_to_map_part_3(3, "p06_s19", "s19_09-m1")
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.attach_object_handle_to_map_part_3(4, "p06_s19", "s19_10-m1")
		event.clear_object_sequence(4)
		event.set_object_sequence_object(4, 4)
		event.set_object_handle_position(0, -65.0, -38.28, 1157.0)
		event.set_object_handle_rotation(0, 0.0, 3.14, 0.0)
		event.set_object_handle_motion(0, "立ち", 4)
		event.set_object_handle_footstep_sound(0, 16)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(0, 1, "通常目パチ")
		event.set_object_handle_position(1, -85.0, -38.13, 1157.0)
		event.set_object_handle_rotation(1, 0.0, 3.14, 0.0)
		event.set_object_handle_motion(1, "立ち", 4)
		event.set_object_handle_footstep_sound(1, 16)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(1, 1, "通常目パチ")
		event.set_object_handle_position(2, -78.11, -15.13, 426.88)
		event.set_object_handle_rotation(2, 0.0, 0.0, 0.0)
		event.set_object_handle_motion(2, "威嚇", 4)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "赤目パチ")
		event.set_object_handle_visible(5, 0)
		event.set_object_handle_visible(6, 0)
		do
			local out1, out2, out3 = event.get_object_handle_rotation(3)
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
			local out1, out2, out3 = event.get_object_handle_position(4)
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		var4 = vm.f32(vector_z - vm.f32(3.1415927))
		var4 = event.wrap_angle(var4) or var4
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-228.84, 94.46, 882.3)
		event.set_camera_sequence_look_at(-94.17, 38.37, 1068.72)
		event.rotate_object_sequence_eased(3, rot_x, rot_y, var4, 40, 0, 0.5)
		event.delay_object_sequence_position_track(4, 80)
		event.move_object_sequence_eased(4, pos_x, pos_y + 80.0, pos_z, 32, 1, 0.5)
		event.delay_object_sequence_position_track(0, 100)
		event.move_object_sequence(0, -65.0, -16.86, 1002.55, 40)
		event.delay_object_sequence_motion_track(0, 100)
		event.set_object_sequence_motion(0, "走り")
		event.delay_object_sequence_motion_track(0, 40)
		event.set_object_sequence_motion(0, "立ち")
		event.delay_object_sequence_position_track(1, 110)
		event.move_object_sequence(1, -85.0, -16.86, 1002.55, 40)
		event.delay_object_sequence_motion_track(1, 110)
		event.set_object_sequence_motion(1, "走り")
		event.delay_object_sequence_motion_track(1, 40)
		event.set_object_sequence_motion(1, "立ち")
		event.fade_in_screen(30)
		at = 2
		helper_888ab2a3(30)
		event.play_sound_effect(var0, 0)
		at = 3
		wait_objects(1)
		at = 4
		helper_888ab2a3(6)
		event.set_camera_sequence_position(-70.27, 35.0, 783.66)
		event.set_camera_sequence_look_at(-73.25, 38.33, 674.48)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(0, 1, "こまり目パチ")
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "おこり顔")
		event.set_object_handle_texture_animation(1, 1, "おこり目パチ")
		event.play_sound_effect(var0, 1)
		event.set_object_sequence_position(0, -50.18, 3.08, 671.54)
		event.set_object_sequence_rotation(0, 0.0, -2.9, 0)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_object_sequence_position(1, -96.49, 3.79, 674.91)
		event.set_object_sequence_rotation(1, 0.0, 2.78, 0.0)
		event.reset_object_sequence_dynamic_animation(1)
		at = 5
		helper_4116e6bb(4100010)
		at = 6
		helper_4116e6bb(4100020)
		at = 7
		helper_4116e6bb(4100030)
		event.set_object_sequence_motion(1, "歩き")
		event.delay_object_sequence_motion_track(1, 60)
		event.set_object_sequence_motion(1, "立ち")
		event.move_object_sequence(1, -73.19, 2.27, 776.78, 60, 1)
		event.rotate_object_sequence(1, 0.0, 0.26, 0.0, 10)
		at = 8
		helper_888ab2a3(10)
		event.set_object_sequence_motion(0, "歩き")
		event.delay_object_sequence_motion_track(0, 50)
		event.set_object_sequence_motion(0, "立ち")
		event.move_object_sequence(0, -63.51, 2.44, 748.06, 50, 1)
		event.rotate_object_sequence(0, 0.0, -0.14, 0.0, 10)
		at = 9
		helper_888ab2a3(20)
		event.fade_out_screen(30)
		at = 10
		helper_888ab2a3(30)
	end, function(received: { any }): boolean
		if at <= 1 then
			var4 = vm.f32(vector_z - vm.f32(3.1415927))
			helper_038a2e4d(30)
		end
		if at <= 2 then
			helper_238b5abc(1)
		end
		if at <= 3 then
			helper_038a2e4d(6)
		end
		if at <= 4 then
			helper_8cd371d7(4100010)
		end
		if at <= 5 then
			helper_8cd371d7(4100020)
		end
		if at <= 6 then
			helper_8cd371d7(4100030)
		end
		if at <= 7 then
			helper_038a2e4d(10)
		end
		if at <= 8 then
			helper_038a2e4d(20)
		end
		if at <= 9 then
			helper_038a2e4d(30)
		end
		return true
	end)
	at = 11
	vm.entry(11)
	event.cancel_drama_scene_skip()
	event.stop_sound_effect(var0, 0)
	event.stop_sound_effect(var0, 1)
	event.set_scene_status_flags(1, 0, 256, 0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.set_object_handle_motion(0, "立ち", 4)
	event.set_object_handle_motion(1, "立ち", 4)
	event.set_object_handle_rotation(3, vector_x, vector_y, vector_z)
	event.set_object_handle_position(4, pos_x, pos_y, pos_z)
	event.delete_character_extension_packs(0)
	event.delete_character(8)
	event.delete_character(9)
	event.delete_character(10)
	event.delete_character(11)
	event.load_message_file(0, -1)
	event.show_dungeon_status_bar(1, 1.0)
	event.set_object_handle_visible(5, 1)
	event.set_object_handle_visible(6, 1)
	event.finish_event()
end

--- Helper function.
local function helper_105d8()
	local var0: s32 = 0
	local rot_x: f32 = 0
	local rot_y: f32 = 0
	local var3: f32 = 0
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
		event.initialize_event()
		var0 = event.load_sound_effect_file_3(8, "snd2/sp/sp_033.sound.json") or var0
		event.set_character_active(0)
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.attach_object_handle_to_map_part_3(1, "p06_s19", "s19_09-m1")
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.attach_object_handle_to_map_part_3(3, "p06_s19", "s19_10-m1")
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.attach_object_handle_to_character(4, 1)
		event.attach_object_handle_to_character(5, 2)
		event.set_object_handle_visible(4, 0)
		event.set_object_handle_visible(5, 0)
		event.set_object_handle_position(0, -75.0, -35.0, 1200.0)
		event.set_object_handle_rotation(0, 0.0, 3.1415927, 0.0)
		event.set_object_handle_motion(0, "立ち", 4)
		event.reset_object_handle_dynamic_animation(0)
		event.set_object_handle_footstep_sound(0, 7)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-127.01131, -7.1499996, 911.04)
		event.set_camera_sequence_look_at(-62.911304, 39.29, 1129.9199)
		event.mark_camera_sequence_fade_track()
		event.enable_drama_skip()
		event.fade_in_screen(30)
		event.play_sound_effect(var0, 1)
		do
			local out1, out2, out3 = event.get_object_handle_rotation(1)
			rot_x = out1 or rot_x
			rot_y = out2 or rot_y
			var3 = out3 or var3
		end
		do
			local out1, out2, out3 = event.copy_vector(rot_x, rot_y, var3)
			vector_x = out1 or vector_x
			vector_y = out2 or vector_y
			vector_z = out3 or vector_z
		end
		do
			local out1, out2, out3 = event.get_object_handle_position(3)
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		var3 = vm.f32(vector_z - vm.f32(3.1415927))
		var3 = event.wrap_angle(var3) or var3
		event.rotate_object_sequence_eased(1, rot_x, rot_y, var3, 40, 0, 0.5)
		at = 2
		wait_objects(1)
		event.move_object_sequence_eased(3, pos_x, pos_y + 80.0, pos_z, 32, 1, 0.5)
		at = 3
		helper_888ab2a3(20)
		event.set_object_sequence_motion(0, "走り")
		event.move_object_sequence(0, -75.0, -35.0, 1055.0, 30)
		event.set_object_handle_footstep_sound(0, 16)
		at = 4
		wait_objects(3)
		event.move_object_sequence_eased(3, pos_x, pos_y, pos_z, 32, 0, 0.5)
		at = 5
		wait_objects(0)
		event.set_object_sequence_motion(0, "立ち")
		event.delay_object_sequence_motion_track(0, 30)
		event.delay_object_sequence_position_track(0, 30)
		event.set_object_sequence_motion(0, "歩き")
		event.move_object_sequence(0, -75.0, -25.0, 1015.0, 40)
		event.delay_object_sequence_motion_track(0, 40)
		event.set_object_sequence_motion(0, "立ち")
		at = 6
		wait_objects(3)
		event.set_object_handle_footstep_sound(0, 0)
		event.rotate_object_sequence_eased(1, vector_x, vector_y, vector_z, 40, 0, 0.5)
		at = 7
		wait_objects(1)
	end, function(received: { any }): boolean
		if at <= 1 then
			var3 = vm.f32(vector_z - vm.f32(3.1415927))
			helper_238b5abc(1)
		end
		if at <= 2 then
			helper_038a2e4d(20)
		end
		if at <= 3 then
			helper_238b5abc(3)
		end
		if at <= 4 then
			helper_238b5abc(0)
		end
		if at <= 5 then
			helper_238b5abc(3)
		end
		if at <= 6 then
			helper_238b5abc(1)
		end
		return true
	end)
	at = 8
	vm.entry(8)
	event.cancel_drama_scene_skip()
	event.stop_sound_effect(var0, 1)
	at = 9
	vm.wait(9)
	event.set_object_handle_rotation(1, vector_x, vector_y, vector_z)
	event.set_object_handle_position(3, pos_x, pos_y, pos_z)
	event.set_object_handle_visible(4, 1)
	event.set_object_handle_visible(5, 1)
	helper_9dafbc83(-75.0, -10.0, 950.0, vm.f32(3.1415927))
	event.set_camera_position(-75.0, 50.0, 1030.0)
	event.set_camera_look_at(-75.0, 20.0, 950.0)
	event.reset_follow_camera(0)
	event.start_crossfade(30)
	event.finish_event()
end

--- Helper function.
local function helper_1ee30()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local var2: s32 = 0
	local at: number = 0
	vm.section(function()
		at = 1
		vm.entry(1)
		event.set_save_flag(420, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.show_dungeon_status_bar(0, 1.0)
		event.stop_music(0)
		event.load_map_sounds(4811)
		var0 = event.load_sound_effect_file_2(4811) or var0
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		active_chr_no = event.get_playable_character() or active_chr_no
		event.set_scene_status_flags(1, 0, 256, 1)
		event.change_directory("event/e400/e420/")
		event.load_message_file(0, 5, "e420.txt")
		if active_chr_no == 0 then
			event.load_character_motion_pack(5, "e420_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if active_chr_no == 1 then
			event.load_character_motion_pack(5, "e420_monica.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.load_character(5, "e420_paw.gltf", "info", 10)
		event.set_character_active(10)
		event.attach_object_handle_to_character(2, 10)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.load_character(5, "e420_shigu.gltf", "info", 11)
		event.set_character_active(11)
		event.attach_object_handle_to_character(3, 11)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.load_character(5, "mariometto_a.gltf", "info", 12)
		event.set_character_active(12)
		event.attach_character_to_frame(11, "metto_null", 12)
		event.attach_object_handle_to_character(6, 12)
		event.clear_object_sequence(6)
		event.set_object_sequence_object(6, 6)
		event.load_character(5, "e420_kanden.gltf", "info", 13)
		event.set_character_active(0, 13)
		event.change_directory("")
		if active_chr_no == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 8)
			event.load_equipment_model(5, 0, 4, "info", 8)
			event.load_equipment_model(5, 0, 3, "info", 8)
			event.load_equipment_model(5, 0, 2, "info", 8, 9)
			event.load_character_motion_pack(5, "event/e400/e420/e420_mints.gltf", "info", 8)
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
			event.load_character_motion_pack(5, "event/e400/e420/e420_monica.gltf", "info", 8)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 8)
			event.attach_object_handle_to_character(1, 8)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 0)
		end
		event.set_character_active(8)
		event.set_character_active(9)
		event.attach_object_handle_to_character(4, 1)
		event.attach_object_handle_to_character(5, 2)
		event.set_object_handle_position(0, -50.18, 3.08, 671.54)
		event.set_object_handle_rotation(0, 0.0, -2.9, 0.0)
		event.set_object_handle_motion(0, "上向くL", 4)
		event.set_object_handle_footstep_sound(0, 16)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "無表情")
		event.set_object_handle_texture_animation(0, 1, "通常目パチ")
		event.set_object_handle_position(1, -96.49, 3.79, 674.91)
		event.set_object_handle_rotation(1, 0.0, 2.78, 0.0)
		event.set_object_handle_motion(1, "上向くL", 4)
		event.set_object_handle_footstep_sound(1, 16)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "無表情")
		event.set_object_handle_texture_animation(1, 1, "通常目パチ")
		event.set_object_handle_position(2, -72.89, 2.34, 770.75)
		event.set_object_handle_rotation(2, 0.0, -3.02, 0.0)
		event.set_object_handle_motion(2, "立ち", 4)
		event.set_object_handle_footstep_sound(2, 16)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "おこり目パチ")
		event.set_object_handle_position(3, -78.16, -9.08, 455.31)
		event.set_object_handle_rotation(3, 0.0, 0.0, 0.0)
		event.set_object_handle_motion(3, "立ち2", 4)
		event.set_object_handle_texture_animation(3, 0)
		event.set_object_handle_texture_animation(3, 1, "赤目パチ")
		event.set_character_position(13, -78.16, -9.08, 455.31)
		event.set_character_rotation(13, 0.0, 0.0, 0.0)
		event.set_object_handle_visible(4, 0)
		event.set_object_handle_visible(5, 0)
		event.enable_drama_skip()
		event.set_camera_sequence_position(-91.15, 8.06, 663.16)
		event.set_camera_sequence_look_at(-79.05, 47.63, 524.91)
		event.set_object_sequence_motion(3, "感電", 6)
		event.queue_object_sequence_next_motion(3, "感電L", 4)
		event.fade_in_screen(30)
		event.set_message_button_prompt(0, 0)
		event.open_voice_stream_wave(1, 4200010)
		at = 2
		var2 = helper_f616ba9e(1)
		at = 3
		helper_888ab2a3(vm.i32(10 - var2))
		event.play_voice_stream(1)
		at = 4
		helper_888ab2a3(vm.i32(30 - var2))
		at = 5
		wait_objects(3)
		event.set_function_point_enabled("", "e420_lg", 1)
		event.play_sound_effect(var0, 4)
		event.set_character_active(1, 13)
		at = 6
		helper_888ab2a3(80)
		event.set_character_active(0, 13)
		event.close_voice_stream(1)
		event.set_message_button_prompt(0, 1)
		event.set_function_point_enabled("", "e420_lg", 0)
		event.set_camera_sequence_position(-39.38, 84.75, 556.88)
		event.set_camera_sequence_look_at(-82.55, -1.03, 671.45)
		event.move_object_sequence(2, -72.44, 3.87, 634.26, 40, 1)
		event.set_object_sequence_motion(2, "上見走り", 4)
		event.delay_object_sequence_motion_track(2, 40)
		event.set_object_sequence_motion(2, "上見立ち")
		at = 7
		helper_4116e6bb(4200020)
		at = 8
		wait_objects(2)
		event.set_camera_sequence_position(-81.13, -20.11, 556.35)
		event.set_camera_sequence_look_at(-83.71, 9.43, 543.03)
		event.stop_sound_effect(var0, 4)
		event.set_object_handle_texture_animation(3, 0)
		event.set_object_handle_texture_animation(3, 1, "赤目～赤目とじ")
		event.set_object_sequence_motion(3, "メット落ちる", 6)
		event.queue_object_sequence_next_motion(3, "倒れる", 6)
		event.wait_object_sequence_motion_end(3)
		event.delay_object_sequence_sound_track(3, 60)
		event.play_object_sequence_sound(3, var0, 6)
		event.move_object_sequence_eased(6, -75.71, -140.18, 221.57, 30, 1, 1.0)
		event.rotate_object_sequence_eased(6, 0.0, 0.0, 1.8, 30, 0, 1.0)
		event.delay_object_sequence_sound_track(6, 50)
		event.play_object_sequence_sound(6, var0, 5)
		event.set_object_sequence_motion(0, "立ち", 4)
		event.set_object_sequence_motion(1, "立ち", 4)
		event.set_object_sequence_motion(2, "立ち", 4)
		at = 9
		helper_888ab2a3(60)
		event.set_character_active(0, 12)
		at = 10
		wait_objects(3)
		event.set_camera_sequence_position(-266.34, 202.78, 745.86)
		event.set_camera_sequence_look_at(-86.65, 17.8, 537.9)
		event.set_camera_sequence_position(-77.85, 7.32, 623.69)
		event.set_camera_sequence_look_at(-79.23, 12.59, 599.39)
		event.shake_camera_sequence(0.0, 2.0, 0.0, 25)
		at = 11
		helper_888ab2a3(25)
		event.set_object_handle_texture_animation(3, 0)
		event.set_object_handle_texture_animation(3, 1, "苦痛目とじ")
		event.set_object_sequence_motion(3, "ぐったり", 6)
		event.set_camera_sequence_position(-266.34, 202.78, 745.86)
		event.set_camera_sequence_look_at(-86.65, 17.8, 537.9)
		at = 12
		helper_4116e6bb(4200030)
		event.move_object_sequence(2, -49.93, 4.12, 578.82, 30, 1)
		event.rotate_object_sequence(2, 0.0, 2.78, 0.0, 10)
		event.set_object_sequence_motion(2, "走り")
		event.delay_object_sequence_motion_track(2, 30)
		event.set_object_sequence_motion(2, "立ち")
		at = 13
		helper_4116e6bb(4200040)
		at = 14
		wait_objects(2)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-126.48, 23.27, 645.95)
		event.set_camera_sequence_look_at(-48.09, 21.64, 692.16)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(1, 1, "通常目パチ")
		event.set_mouth_texture_animations(1, "わらい口パク")
		at = 15
		helper_4116e6bb(4200050)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 16
		helper_4116e6bb(4200060)
		event.move_object_sequence(0, -73.29, 4.2, 606.39, 40, 1)
		event.delay_object_sequence_rotation_track(0, 30)
		event.rotate_object_sequence(0, 0.0, 2.9, 0.0, 10)
		event.set_object_sequence_motion(0, "走り")
		event.delay_object_sequence_motion_track(0, 40)
		event.set_object_sequence_motion(0, "立ち")
		at = 17
		helper_888ab2a3(8)
		event.move_object_sequence(1, -89.41, 4.65, 588.63, 40, 1)
		event.delay_object_sequence_rotation_track(1, 30)
		event.rotate_object_sequence(1, 0.0, 2.18, 0.0, 10)
		event.set_object_sequence_motion(1, "走り")
		event.delay_object_sequence_motion_track(1, 40)
		event.set_object_sequence_motion(1, "立ち")
		at = 18
		helper_888ab2a3(30)
		event.set_camera_sequence_position(-23.86, 87.25, 654.66)
		event.set_camera_sequence_look_at(-59.69, 21.64, 584.77)
		event.set_object_handle_texture_animation(3, 0)
		event.set_object_handle_texture_animation(3, 1, "半目パチ")
		at = 19
		wait_objects(1)
		at = 20
		helper_4116e6bb(4200070)
		at = 21
		helper_4116e6bb(4200080)
		at = 22
		helper_4116e6bb(4200090)
		event.set_object_sequence_motion(1, "会話", 2)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		at = 23
		helper_4116e6bb(4200100)
		event.fade_out_screen(30)
		at = 24
		helper_888ab2a3(30)
	end, function(received: { any }): boolean
		if at == 2 then
			var2 = received[1] :: number
		end
		if at <= 1 then
			var2 = helper_523109b8(1)
		end
		if at <= 2 then
			helper_038a2e4d(vm.i32(10 - var2))
		end
		if at <= 3 then
			helper_038a2e4d(vm.i32(30 - var2))
		end
		if at <= 4 then
			helper_238b5abc(3)
		end
		if at <= 5 then
			helper_038a2e4d(80)
		end
		if at <= 6 then
			helper_8cd371d7(4200020)
		end
		if at <= 7 then
			helper_238b5abc(2)
		end
		if at <= 8 then
			helper_038a2e4d(60)
		end
		if at <= 9 then
			helper_238b5abc(3)
		end
		if at <= 10 then
			helper_038a2e4d(25)
		end
		if at <= 11 then
			helper_8cd371d7(4200030)
		end
		if at <= 12 then
			helper_8cd371d7(4200040)
		end
		if at <= 13 then
			helper_238b5abc(2)
		end
		if at <= 14 then
			helper_8cd371d7(4200050)
		end
		if at <= 15 then
			helper_8cd371d7(4200060)
		end
		if at <= 16 then
			helper_038a2e4d(8)
		end
		if at <= 17 then
			helper_038a2e4d(30)
		end
		if at <= 18 then
			helper_238b5abc(1)
		end
		if at <= 19 then
			helper_8cd371d7(4200070)
		end
		if at <= 20 then
			helper_8cd371d7(4200080)
		end
		if at <= 21 then
			helper_8cd371d7(4200090)
		end
		if at <= 22 then
			helper_8cd371d7(4200100)
		end
		if at <= 23 then
			helper_038a2e4d(30)
		end
		return true
	end)
	at = 25
	vm.entry(25)
	event.cancel_drama_scene_skip()
	event.set_function_point_enabled("", "e420_lg", 0)
	event.stop_sound_effect(var0, 4)
	event.set_scene_status_flags(1, 0, 256, 0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.set_object_handle_motion(0, "立ち", 4)
	event.set_object_handle_motion(1, "立ち", 4)
	event.delete_character_extension_packs(0)
	event.delete_character(8)
	event.delete_character(9)
	event.delete_character(10)
	event.delete_character(11)
	event.delete_character(12)
	event.delete_character(13)
	event.load_message_file(0, -1)
	event.show_dungeon_status_bar(1, 1.0)
	event.set_object_handle_visible(4, 1)
	event.set_object_handle_visible(5, 1)
	event.finish_event()
end

--- Helper function.
local function helper_11850(arg0: s32)
	local var1: any = 0
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.set_character_motion(0, "立ち")
		event.set_message_selection_top_line(0, 0)
		event.set_message_window_mode(0, 5)
		event.set_message_draw_speed(0, 1)
		if arg0 == 1 then
			event.open_message_window_2(0, "次のフロアへ進みますか？")
		else
			event.open_message_window_2(0, "前のフロアへ戻りますか？")
		end
		at = 1
		var1 = helper_bac0e30d(0, -1, 8, 256, 208, 2, 1)
		if var1 == 0 then
			event.fade_out_screen(30)
			at = 2
			helper_888ab2a3(30)
			return 1
		else
			event.finish_event()
			return 0
		end
	end, function(received: { any })
		if at <= 2 then
			if at == 1 then
				var1 = received[1] :: number
			end
			if at <= 1 then
				helper_038a2e4d(30)
			end
			return 1
		end
		return nil
	end)
end

--- Helper function.
local function helper_24100()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	event.reset_action_character_motion(0, 4)
	event.fade_out_screen(30)
	helper_888ab2a3(30)
	event.set_dungeon_pause_flags(1, 1)
	event.clear_event_battle_monsters(-1)
	helper_888ab2a3(30)
	event.initialize_event()
	var0 = event.load_sound_effect_file_3(5, "snd2/mon/en_360.sound.json") or var0
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.show_dungeon_status_bar(0, 1.0)
	event.load_character(5, "dungeon/monster/b07a.gltf", "b07a", 8)
	event.set_character_active(1, 8)
	event.attach_object_handle_to_character(0, 8)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.fade_in_screen(15)
	event.set_camera_position(-50.62, 42.66, 812.75)
	event.set_camera_look_at(-50.82, 71.75, 656.03)
	event.set_character_active(0, 0)
	event.play_sound_effect(var0, 24)
	event.set_object_sequence_position(0, -50.62, 4.34, 553.77)
	event.set_object_sequence_rotation(0, 0.0, 0.02, 0.0)
	event.set_object_sequence_motion(0, "死に", 6)
	event.wait_object_sequence_motion_end(0)
	wait_objects(0)
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no ~= 2 then
		event.set_camera_position(-21.21, 14.5, 728.16)
		event.set_camera_look_at(-33.94, 17.9, 751.25)
	else
		event.set_camera_position(8.06, 23.77, 675.07)
		event.set_camera_look_at(-39.51, 29.49, 761.36)
	end
	event.set_character_active(1, 0)
	event.set_character_position(0, -40.07, 1.76, 766.47)
	event.set_character_rotation(0, 0.0, -3.12, 0.0)
	event.set_character_motion(0, "立ち", 4)
	event.delete_character(8)
	event.finish_event()
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

script.event_99 = event_99

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local var3: s32 = 0
	local at: number = 0
	return vm.guard(function()
		at = 1
		event_99()
		flag = event.get_save_flag(400) or flag
		flag_2 = event.get_save_flag(408) or flag_2
		flag_3 = event.get_save_flag(420) or flag_3
		if flag == 1 then
			if flag_2 == 0 then
				at = 2
				helper_11c1c()
				event.go_to_georama_edit(75, 500)
				return
			end
			if flag_3 == 0 then
				var3 = event.get_save_data_value(2) or var3
				if var3 ~= 0 then
					at = 3
					helper_3d13e6aa(1)
					at = 4
					helper_1bfac()
					event.set_save_control_bits(1, 1)
					return
				else
					at = 5
					helper_199cc()
					event.stop_all_sounds()
					at = 6
					helper_888ab2a3(6)
					event.load_music(18)
					event.load_map_sounds(4601)
					event.play_music(0)
					event.load_event_script("d04/d04.stb", 1000)
					return
				end
			else
				at = 7
				helper_105d8()
			end
		else
			at = 8
			helper_105d8()
		end
		return
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				at = 2
				helper_11c1c()
				return vm.continue_with(function()
					event.go_to_georama_edit(75, 500)
					return
				end)
			end
			return 0
		end
		if at <= 4 then
			if at <= 3 then
				at = 4
				helper_1bfac()
				return vm.continue_with(function()
					event.set_save_control_bits(1, 1)
					return
				end)
			end
			return 0
		end
		if at <= 6 then
			if at <= 5 then
				helper_038a2e4d(6)
			end
			return 0
		end
		if at <= 8 then
			if at <= 7 then
				at = 8
				helper_105d8()
				return vm.continue_with(function()
					return
				end)
			end
			return 0
		end
		return nil
	end)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = helper_11c1c

--- Event 151, which map data, a script or the engine runs by number.
function script.event_151()
	event.fade_in_screen(30)
	event.initialize_event()
	vm.wait(1)
	event.set_character_position(0, -29.1, 1.4, 787.9)
	event.set_dungeon_pause_flags(17, 0)
	event.load_dungeon_monster(516, 1)
	event.load_dungeon_monster(1001, 0)
	event.place_dungeon_monster(516, -50.0, -46.69, 202.57, 0.0, 0.0, 0.0)
	event.get_character_position(0)
	event.finish_event()
end

--- Event 152, which map data, a script or the engine runs by number.
function script.event_152()
	vm.wait(1)
	helper_c956b4a2(32)
end

--- Event 153, which map data, a script or the engine runs by number.
function script.event_153()
	local at: number = 0
	return vm.guard(function()
		event.set_dungeon_pause_flags(1, 1)
		event.fade_out_screen(0)
		event.set_dungeon_pause_flags(16, 1)
		at = 1
		helper_888ab2a3(30)
		event.fade_in_screen(30)
		event.clear_event_battle_monsters(-1)
		at = 2
		helper_1ee30()
		return
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				at = 2
				helper_1ee30()
				return vm.continue_with(function()
					return
				end)
			end
			return 0
		end
		return nil
	end)
end

--- Event 154, which map data, a script or the engine runs by number.
function script.event_154()
	event.set_camera_look_at(-33.22, 3.88, 763.5)
	vm.wait(1)
	helper_c956b4a2(32)
end

--- Event 155, which map data, a script or the engine runs by number.
script.event_155 = helper_1bfac

--- Event 160, which map data, a script or the engine runs by number.
function script.event_160()
	vm.wait(1)
	helper_c956b4a2(32)
end

--- Event 200, which map data, a script or the engine runs by number.
function script.event_200()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	event.initialize_event()
	var0 = event.has_save_control_bits(1) or var0
	if var0 == 1 then
		event.set_dungeon_pause_flags(9, 1)
		event.reset_action_character_motion(0)
		event.set_message_window_mode(0, 1)
		event.set_message_bubble_tail(0, 0)
		event.open_message_window_2(0, "この魚をシグーに食べさせないと！！")
		helper_75684dd8(0, -1, 5, 0, 0)
		event.set_dungeon_pause_flags(9, 0)
		return
	end
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 2 then
		event.set_character_motion(0, "立ち")
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
	if helper_11850(0) ~= 0 then
		event.load_event_script("d04/d04.stb", 1000)
	end
end

--- Event 201, which map data, a script or the engine runs by number.
function script.event_201()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local stage_id: s32 = 0
	local var3: s32 = 0
	local argc: s32 = 0
	event.initialize_event()
	var0 = event.has_save_control_bits(1) or var0
	if var0 == 1 then
		event.set_dungeon_pause_flags(9, 1)
		event.reset_action_character_motion(0)
		event.set_message_window_mode(0, 1)
		event.set_message_bubble_tail(0, 0)
		event.open_message_window_2(0, "この魚をシグーに食べさせないと！！")
		helper_75684dd8(0, -1, 5, 0, 0)
		event.set_dungeon_pause_flags(9, 0)
		return
	end
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 2 then
		event.set_character_motion(0, "立ち")
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
	if helper_11850(1) ~= 0 then
		stage_id = event.get_dungeon_stage_id() or stage_id
		var3 = event.get_dungeon_floor() or var3
		argc = event.get_dungeon_next_floor(var3, 0) or argc
		event.set_dungeon_floor(argc)
		event.set_dungeon_floor_info(stage_id, var3, 5, 2)
		event.set_dungeon_floor_info(stage_id, argc, 5, 1)
		event.stop_music(0)
		event.stop_environment_music()
		event.stop_map_object_sounds()
		helper_888ab2a3(6)
		event.load_music(18)
		event.load_map_sounds(4601)
		event.play_music(0)
		event.load_event_script("d04/d04.stb", 1000)
	end
end

--- Event 500, which map data, a script or the engine runs by number.
function script.event_500()
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.fade_out_screen(0)
		at = 1
		vm.wait(1)
		at = 2
		vm.wait(2)
		event.clear_event_battle_monsters(-1)
		event.set_save_data_value(4)
		event.set_save_control_bits(1, 0)
		at = 3
		helper_3d13e6aa(0)
		at = 4
		helper_1ee30()
		event.skip_next_music_load()
		event.go_to_georama_edit(75, 100)
		at = 5
		vm.wait(5)
		return
	end, function(received: { any })
		if at <= 5 then
			if at <= 2 then
				helper_4a9b8bc5(0)
			end
			if at <= 3 then
				at = 4
				helper_1ee30()
				return vm.continue_with(function()
					event.skip_next_music_load()
					event.go_to_georama_edit(75, 100)
					at = 5
					vm.wait(5)
					return
				end)
			end
			return 0
		end
		return nil
	end)
end

--- Event 510, which map data, a script or the engine runs by number.
function script.event_510()
	local var0: s32 = 0
	local var1: s32 = 0
	local argc: s32 = 0
	local battle_bgm_vol: s32 = 0
	local active_chr_no: s32 = 0
	local block: s32 = 0
	local debug_flag: s32 = 0
	local load_no: s32 = 0
	local boss_map: s32 = 0
	helper_24100()
	event.set_dungeon_pause_flags(1, 0)
	var0 = 0
	event.initialize_event()
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.set_dungeon_pause_flags(16384, 1)
	event.save_music_status(-1)
	var1 = event.get_event_sound_bank(4) or var1
	argc = event.get_sound_effect_status(var1, 0) or argc
	battle_bgm_vol = event.get_battle_music_volume() or battle_bgm_vol
	event.stop_sound_effect(var1, 0)
	event.stop_music(0)
	active_chr_no = event.get_playable_character() or active_chr_no
	event.start_background_file_loads_2("snd2/bgm/bg_060.sound.json", "textures/dungeon/image/gameover.json")
	helper_888ab2a3(30)
	helper_479dc9e9()
	event.load_music_pack(60)
	event.play_music(0)
	helper_888ab2a3(30)
	event.set_dungeon_pause_flags(1, 1)
	event.reset_dungeon_collision_primitives()
	event.set_message_window_mode(0, 8)
	event.open_message_window_2(
		0,
		"シグーを殺してしまった・・・\n未来を元に戻すには、シグーの力が\n必要だったのに・・・"
	)
	helper_75684dd8(0, -1, 8, 0, 0)
	block = event.load_event_image_4(5, "textures/dungeon/image/gameover.json", 0) or block
	event.reset_event_sprite(0)
	event.set_event_sprite_type(0, 0)
	event.set_event_sprite_texture(0, "gameover1", block)
	event.set_event_sprite_color(0, 128, 128, 128, 128)
	event.set_event_sprite_texture_rect(0, 0, 0, 576, 128)
	event.set_event_sprite_size(0, 576, 128)
	event.set_event_sprite_position(0, -320, 208)
	event.set_event_sprite_draw_pass(0, 1)
	event.attach_object_handle_to_sprite(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.move_object_sequence(0, 288, 208, 0.0, 20)
	helper_888ab2a3(30)
	event.reset_event_sprite(1)
	event.set_event_sprite_type(1, 0)
	event.set_event_sprite_texture(1, "gameover1", block)
	event.set_event_sprite_color(1, 128, 128, 128, 0)
	event.set_event_sprite_texture_rect(1, 0, 128, 576, 64)
	event.set_event_sprite_size(1, 576, 64)
	event.set_event_sprite_position(1, 256, 208)
	event.set_event_sprite_draw_pass(1, 1)
	event.attach_object_handle_to_sprite(1, 1)
	event.clear_object_sequence(1)
	event.set_object_sequence_object(1, 1)
	event.set_object_sequence_color(1, 128, 128, 128, 128, 120)
	helper_888ab2a3(120)
	while true do
		if helper_581cb30c(0) ~= 0 then
			break
		else
			vm.wait(8)
		end
	end
	debug_flag = event.get_debug_flag() or debug_flag
	debug_flag = 0
	if debug_flag == 1 then
		event.run_dungeon_debug_command(0)
		event.reset_action_character_motion(0, 4)
	else
		event.fade_out_music(30)
		event.fade_out_screen(30)
		helper_888ab2a3(30)
		if active_chr_no == 2 then
			event.clear_effect_manager()
		end
		event.stop_music(0)
		event.set_event_sprite_draw_pass(0, 0)
		event.set_event_sprite_draw_pass(1, 0)
		event.delete_event_image(0)
		if var0 == 1 then
			event.add_hp_by_rate(1.0, 0)
			event.add_battle_weapon_durability(0, 999)
			event.add_battle_weapon_durability(1, 999)
			event.run_dungeon_event(-1)
			event.clear_event_battle_monsters(-1)
			event.set_dungeon_pause_flags(1, 0)
			event.finish_event()
			return 1
		else
			event.set_scene_exit_flag(1)
			event.finish_event()
			return 0
		end
	end
	event.stop_music(0)
	helper_888ab2a3(4)
	load_no = event.get_saved_music_number() or load_no
	event.load_music(load_no)
	event.restore_music_status(-1)
	event.set_event_sprite_draw_pass(0, 0)
	event.set_event_sprite_draw_pass(1, 0)
	event.delete_event_image(0)
	boss_map = event.is_dungeon_boss_floor() or boss_map
	if boss_map ~= 1 then
		if argc == 1 then
			event.play_sound_effect(var1, 0)
			event.set_sound_effect_volume(var1, 0, battle_bgm_vol)
		end
	end
	event.set_camera_control_enabled(1)
	event.show_dungeon_status_bar(1, 1.0)
	if debug_flag ~= 1 then
		event.fade_in_screen(30)
	end
	event.set_dungeon_pause_flags(16385, 0)
	event.finish_event()
	return 0
end

--- Event 550, which map data, a script or the engine runs by number.
function script.event_550()
	event.initialize_event()
	event.set_character_motion(0, "だめだめ")
	event.set_dungeon_pause_flags(3, 1)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.set_message_draw_speed(0, 1)
	event.open_message_window_2(
		0,
		"[(!)]シグーにダメージを与えると\n   怒ってこちらを威嚇して来ます。<page>   その時、大きく口を開けているので、\n   電気の魚を投げ入れるチャンスです！"
	)
	helper_75684dd8(0, -1, 5, 0, 0)
	event.set_message_window_mode(0, 1)
	event.set_message_draw_speed(0, 0)
	event.set_dungeon_pause_flags(3, 0)
	event.set_character_motion(0, "立ち")
	event.finish_event()
end

--- Event 1200, which map data, a script or the engine runs by number.
function script.event_1200()
	local flag: s32 = 0
	local flag_2: s32 = 0
	local var2: s32 = 0
	local at: number = 0
	return vm.guard(function()
		flag = event.get_save_flag(416) or flag
		flag_2 = event.get_save_flag(420) or flag_2
		if flag ~= 0 and flag_2 == 0 then
			var2 = vm.float_bits(event.get_random_number(100)) or var2
			if var2 < 50 then
				at = 1
				helper_a9eaf20e(0, 8610060)
			else
				at = 2
				helper_a9eaf20e(0, 8610070)
			end
			return
		end
		at = 3
		helper_f9968159(0)
		return
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				helper_2609f66b(0, 8610070)
			end
			return 0
		end
		if at <= 3 then
			return 0
		end
		return nil
	end)
end

--- Event 14080, which map data, a script or the engine runs by number.
function script.event_14080()
	local at: number = 0
	return vm.guard(function()
		event.fade_out_screen(0)
		event.set_save_flag(400, 1)
		event.set_save_flag(402, 1)
		event.set_save_flag(404, 1)
		event.set_save_flag(406, 1)
		event.set_save_flag(408, 0)
		at = 1
		event_99()
		at = 2
		helper_11c1c()
		event.clear_event_running_flag()
		event.go_to_georama_edit(75, 500)
		return
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				at = 2
				helper_11c1c()
				return vm.continue_with(function()
					event.clear_event_running_flag()
					event.go_to_georama_edit(75, 500)
					return
				end)
			end
			return 0
		end
		return nil
	end)
end

--- Event 14100, which map data, a script or the engine runs by number.
function script.event_14100()
	local at: number = 0
	return vm.guard(function()
		event.set_save_flag(400, 1)
		event.set_save_flag(402, 1)
		event.set_save_flag(404, 1)
		event.set_save_flag(406, 1)
		event.set_save_flag(408, 1)
		event.set_save_flag(410, 0)
		at = 1
		event_99()
		at = 2
		helper_199cc()
		return
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				at = 2
				helper_199cc()
				return vm.continue_with(function()
					return
				end)
			end
			return 0
		end
		return nil
	end)
end

--- Event 14160, which map data, a script or the engine runs by number.
function script.event_14160()
	local at: number = 0
	return vm.guard(function()
		at = 1
		event_99()
		event.set_save_flag(400, 1)
		event.set_save_flag(402, 1)
		event.set_save_flag(404, 1)
		event.set_save_flag(406, 1)
		event.set_save_flag(408, 1)
		at = 2
		helper_1bfac()
		return
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				at = 2
				helper_1bfac()
				return vm.continue_with(function()
					return
				end)
			end
			return 0
		end
		return nil
	end)
end

--- Event 14200, which map data, a script or the engine runs by number.
function script.event_14200()
	local at: number = 0
	return vm.guard(function()
		event.set_save_flag(400, 1)
		event.set_save_flag(402, 1)
		event.set_save_flag(404, 1)
		event.set_save_flag(406, 1)
		event.set_save_flag(408, 1)
		event.set_save_flag(416, 1)
		at = 1
		event_99()
		at = 2
		helper_1ee30()
		event.clear_event_running_flag()
		event.skip_next_music_load()
		event.go_to_georama_edit(75, 100)
		at = 3
		vm.wait(3)
		return
	end, function(received: { any })
		if at <= 3 then
			if at <= 1 then
				at = 2
				helper_1ee30()
				return vm.continue_with(function()
					event.clear_event_running_flag()
					event.skip_next_music_load()
					event.go_to_georama_edit(75, 100)
					at = 3
					vm.wait(3)
					return
				end)
			end
			return 0
		end
		return nil
	end)
end

return script
