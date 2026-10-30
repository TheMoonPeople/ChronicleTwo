--!strict
-- map/s/s03/s03.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local close_message = require("@lib/event/close_message")
local helper_0382f327 = require("@lib/event/helper_0382f327")
local helper_038a2e4d = require("@lib/event/helper_038a2e4d")
local helper_1ef0d4b2 = require("@lib/event/helper_1ef0d4b2")
local helper_238b5abc = require("@lib/event/helper_238b5abc")
local helper_344d6cd8 = require("@lib/event/helper_344d6cd8")
local helper_34d64c6e = require("@lib/event/helper_34d64c6e")
local helper_4116e6bb = require("@lib/event/helper_4116e6bb")
local helper_479dc9e9 = require("@lib/event/helper_479dc9e9")
local helper_482d9cfc = require("@lib/event/helper_482d9cfc")
local helper_4a9b8bc5 = require("@lib/event/helper_4a9b8bc5")
local helper_53ffe901 = require("@lib/event/helper_53ffe901")
local helper_61e5dba6 = require("@lib/event/helper_61e5dba6")
local helper_7d54f41c = require("@lib/event/helper_7d54f41c")
local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")
local helper_8cd371d7 = require("@lib/event/helper_8cd371d7")
local helper_972d1084 = require("@lib/event/helper_972d1084")
local helper_9cbdc640 = require("@lib/event/helper_9cbdc640")
local helper_aa5b3ebe = require("@lib/event/helper_aa5b3ebe")
local helper_bac0e30d = require("@lib/event/helper_bac0e30d")
local helper_c956b4a2 = require("@lib/event/helper_c956b4a2")
local helper_d16eef1e = require("@lib/event/helper_d16eef1e")
local helper_f018b3c0 = require("@lib/event/helper_f018b3c0")
local helper_f2b0ffcb = require("@lib/event/helper_f2b0ffcb")
local open_message = require("@lib/event/open_message")
local wait_camera = require("@lib/event/wait_camera")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_df50()
	event.initialize_event()
	event.set_character_active(0, 0)
	helper_888ab2a3(10)
	event.clear_camera_sequence_path()
	event.set_camera_sequence_path_frames(300)
	event.add_camera_sequence_path_point(386.61, 91.3, 731.1, 156.48, 130.57, 372.4)
	event.add_camera_sequence_path_point(353.18, 76.38, 603.98, 123.05, 115.65, 245.28)
	event.add_camera_sequence_path_point(322.69, 63.43, 464.4, 92.55, 102.7, 105.69)
	event.add_camera_sequence_path_point(299.38, 56.75, 312.43, 69.25, 96.03, -46.28)
	event.add_camera_sequence_path_point(274.2, 47.43, 99.66, 44.07, 86.7, -259.05)
	event.add_camera_sequence_path_point(223.88, 41.06, -72.48, -6.26, 80.33, -431.18)
	event.add_camera_sequence_path_point(196.81, 37.0, -186.06, -33.32, 76.28, -544.77)
	event.start_camera_sequence_path()
	vm.wait(2)
	helper_c956b4a2(32)
	event.set_character_active(0)
end

--- Helper function.
local function helper_fe3c()
	local var0: s32 = 0
	local block: s32 = 0
	local angle: f32 = 0
	local var3: s32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local pos_z: f32 = 0
	local var8: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z_2: f32 = 0
	local var12: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	local at: number = 0
	vm.section(function()
		event.fade_out_screen(0)
		event.set_save_flag(204, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.stop_music(0)
		at = 1
		helper_888ab2a3(4)
		event.load_music(191)
		event.load_map_sounds(2203)
		var0 = event.load_sound_effect_file_2(2203) or var0
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.change_directory("event/e200/e204/")
		event.load_message_file(0, 5, "e204.txt")
		event.load_character_motion_pack(5, "e204_mints.gltf", "info", 0)
		event.set_character_active(0, 0)
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.load_character(5, "e204_starbre.gltf", "info", 32)
		event.set_character_active(0, 32)
		event.attach_object_handle_to_character(1, 32)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.load_character(5, "bomb.gltf", "info", 33)
		event.set_character_active(0, 33)
		event.attach_character_to_frame(32, "bomb", 33)
		event.load_character(5, "e204_buggy.gltf", "info", 34)
		event.set_character_active(0, 34)
		event.attach_object_handle_to_character(3, 34)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.load_character(5, "e204_polcurse.gltf", "info", 35)
		event.set_character_active(0, 35)
		event.attach_object_handle_to_character(4, 35)
		event.clear_object_sequence(4)
		event.set_object_sequence_object(4, 4)
		event.attach_character_to_frame(34, "polcurse_chair", 35)
		event.load_character(5, "e204_macho.gltf", "info", 36)
		event.set_character_active(0, 36)
		event.attach_character_to_frame(34, "macho_chair", 36)
		event.load_character(5, "gun_fire.gltf", "info", 37)
		event.set_character_active(0, 37)
		event.attach_character_to_frame(34, "dcol00", 37)
		event.load_character(5, "gun_hit.gltf", "info", 38)
		event.set_character_active(0, 38)
		event.attach_object_handle_to_character(9, 38)
		event.clear_object_sequence(8)
		event.set_object_sequence_object(8, 9)
		block = event.load_event_image_4(5, "e204telop01.json", 0) or block
		event.reset_event_sprite(0)
		event.set_event_sprite_type(0, 0)
		event.set_event_sprite_texture(0, "e204telop01", block)
		event.set_event_sprite_color(0, 128, 128, 128, 0)
		event.set_event_sprite_texture_rect(0, 0, 0, 512, 128)
		event.set_event_sprite_size(0, 512, 128)
		event.set_event_sprite_position(0, 256, 312)
		event.set_event_sprite_alpha_blend(0, 0)
		event.set_event_sprite_draw_pass(0, 0)
		event.attach_object_handle_to_sprite(10, 0)
		event.clear_object_sequence(9)
		event.set_object_sequence_object(9, 10)
		event.change_directory("")
		event.initialize_effect_manager(5, 1)
		event.load_effect_base("バギー砂煙")
		event.create_effect_work_buffer(5)
		event.attach_object_handle_to_map_part_4(5, "p01_s03t", "s03t01-m", "door01-")
		event.clear_object_sequence(5)
		event.set_object_sequence_object(5, 5)
		event.set_object_sequence_position(0, 0.0, 133.53, -321.16)
		event.set_object_sequence_rotation(0, 0.0, 3.14, 0.0)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目パチ")
		event.set_object_handle_footstep_sound(0, 6)
		event.set_object_sequence_position(1, 0.0, 114.0, -303.0)
		event.set_object_sequence_rotation(1, 0.0, 3.14, 0.0)
		event.set_object_sequence_motion(1, "屋根つかまり立ち", 4)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_object_sequence_position(3, 240.0, 0.0, -1200.0)
		event.set_object_sequence_motion(3, "走行", 4)
		event.set_object_sequence_motion(4, "走行", 4)
		event.set_object_sequence_texture_animation(4, 0)
		event.set_object_sequence_texture_animation(4, 0, "ニヤリ口")
		event.set_object_sequence_texture_animation(4, 1, "わらい口パク")
		event.set_object_sequence_position(8, 76.0, 68.0, -1100.0)
		event.set_object_sequence_rotation(8, 0.0, 1.57, 0.0)
		event.create_effect_2("バギー砂煙", 34)
		event.open_voice_stream_wave(1, 2040010)
		at = 2
		helper_9cbdc640(1)
		event.clear_camera_sequence()
		event.enable_drama_skip()
		event.play_sound_effect(var0, 0)
		event.set_camera_sequence_position(380.6, 127.31, 601.72)
		event.set_camera_sequence_look_at(243.08, 107.4, 438.53)
		event.move_camera_sequence(325.48, 121.86, 412.81, 208.11, 101.95, 231.83, 90)
		event.fade_in_screen(30)
		at = 3
		wait_camera()
		event.set_camera_sequence_position(-160.48, 189.72, -401.22)
		event.set_camera_sequence_look_at(-1.58, 128.85, -292.36)
		event.set_character_active(0)
		event.set_object_sequence_motion(0, "屋根に登る", 6)
		event.queue_object_sequence_next_motion(0, "屋根に登るL", 4)
		event.play_sound_effect(var0, 1)
		event.set_function_point_enabled("p01_s03t", "door", 1)
		at = 4
		helper_888ab2a3(65)
		event.set_function_point_enabled("p01_s03t", "door", 0)
		event.set_camera_sequence_position(0.0, 155.31, -427.57)
		event.set_camera_sequence_look_at(0.0, 151.56, -332.61)
		at = 5
		wait_objects(0)
		event.set_camera_sequence_position(-9.82, 215.27, -230.06)
		event.set_camera_sequence_look_at(42.69, 136.67, -377.81)
		event.set_character_active(35)
		event.set_character_active(34)
		event.set_character_active(36)
		event.move_object_sequence(3, 266.0, 0.0, -800.0, 40)
		at = 6
		helper_888ab2a3(10)
		event.set_object_sequence_motion(0, "下を見る", 6)
		event.queue_object_sequence_next_motion(0, "下を見るL", 4)
		event.play_music(0)
		at = 7
		wait_objects(3)
		event.set_object_sequence_rotation(5, 0.0, 0.0, 0.0)
		event.set_camera_sequence_position(240.0, 70.33, -441.97)
		event.set_camera_sequence_look_at(240.0, 35.77, -608.94)
		event.play_voice_stream(1)
		event.play_sound_effect(var0, 2)
		event.play_sound_effect(var0, 3)
		event.add_object_sequence_position_offset(3, 0.0, 0.0, 5.0, 40)
		event.rotate_object_sequence_eased(3, 0.0, -0.46, 0.0, 6, 0, 1.0)
		event.rotate_object_sequence_eased(3, 0.0, 0.46, 0.0, 10, 0, 1.0)
		event.rotate_object_sequence_eased(3, 0.0, 0.0, 0.0, 10, 0, 1.0)
		angle = 0.0
		var3 = 0
		while var3 < 40 do
			do
				local out1, out2, out3 = event.get_character_position(34)
				var4 = out1 or var4
				var5 = out2 or var5
				var6 = out3 or var6
			end
			var4 = vm.f32(vm.f32(vm.sin(angle) * 30.0) + 240.0)
			event.set_character_position(34, var4, var5, var6)
			angle = vm.f32(angle + vm.f32(0.15707964))
			angle = event.wrap_angle(angle) or angle
			var3 = var3 + 1
			at = 8
			vm.wait(8)
		end
		event.set_camera_sequence_position(235.72, 76.51, -605.47)
		event.set_camera_sequence_look_at(235.07, 76.26, -631.38)
		event.set_object_sequence_motion(4, "走行2", 4)
		event.set_object_sequence_motion(3, "走行2", 4)
		at = 9
		wait_objects(3)
		event.set_object_sequence_motion(4, "ニヤリ", 2)
		event.queue_object_sequence_next_motion(4, "ニヤリL", 4)
		at = 10
		helper_888ab2a3(40)
		event.set_camera_sequence_position(210.48, 75.88, -1380.83)
		event.set_camera_sequence_look_at(212.75, 63.09, -1231.67)
		event.move_camera_sequence(210.48, 75.88, -1380.83, 168.48, 63.09, -1255.36, 60)
		event.set_character_active(1, 38)
		event.reset_object_sequence_motion(8)
		event.set_object_sequence_motion(8, "連射", 4)
		pos_z = -1000.0
		var8 = 0
		while var8 < 4 do
			pos_z = vm.f32(pos_z - 20.0)
			event.set_object_sequence_position(8, 76.0, 60.0, pos_z)
			event.delay_object_sequence_position_track(8, 5)
			var8 = var8 + 1
		end
		var8 = 0
		while var8 < 4 do
			pos_z = vm.f32(pos_z + 20.0)
			event.set_object_sequence_position(8, 76.0, 60.0, pos_z)
			event.delay_object_sequence_position_track(8, 5)
			var8 = var8 + 1
		end
		var8 = 0
		while var8 < 4 do
			pos_z = vm.f32(pos_z - 20.0)
			event.set_object_sequence_position(8, 76.0, 60.0, pos_z)
			event.delay_object_sequence_position_track(8, 5)
			var8 = var8 + 1
		end
		event.play_sound_effect(var0, 4)
		event.set_character_active(1, 37)
		event.set_object_sequence_position(3, 240.0, 0.0, -1100.0)
		event.set_object_sequence_rotation(3, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(3, "攻撃", 4, -1.0, 1)
		event.set_object_sequence_motion(4, "攻撃", 4)
		at = 11
		wait_camera()
		event.set_character_active(0, 38)
		event.set_camera_sequence_position(369.35, 68.75, -1068.56)
		event.set_camera_sequence_look_at(281.32, 69.68, -1068.4)
		event.move_camera_sequence(369.27, 68.75, -1111.17, 281.24, 69.68, -1111.0, 90)
		event.set_object_sequence_motion(3, "ノリノリ", 4, -1.0, 1)
		event.set_object_sequence_motion(4, "ノリノリ", 4)
		at = 12
		wait_camera()
		event.stop_sound_effect(var0, 2)
		event.set_character_active(0, 37)
		event.close_voice_stream(1)
		event.set_object_sequence_texture_animation(4, 0, "わらい口パク")
		event.set_object_sequence_texture_animation(4, 1, "ニヤリ口")
		event.set_camera_sequence_position(3.09, 138.1, -353.16)
		event.set_camera_sequence_look_at(2.77, 152.0, -320.76)
		event.play_sound_effect(var0, 5)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 13
		helper_4116e6bb(2040020)
		event.set_object_sequence_texture_animation(0, 0, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "きづく顔")
		at = 14
		helper_4116e6bb(2040030)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 0, "きづく顔")
		event.set_camera_sequence_position(11.47, 169.65, -362.8)
		event.set_camera_sequence_look_at(-5.1, 143.73, -320.45)
		event.play_sound_effect(var0, 6)
		event.set_character_active(32)
		event.set_object_sequence_position(0, 0.0, 133.53, -348.54)
		event.set_object_sequence_motion(0, "振り返る", 6, 1)
		event.queue_object_sequence_next_motion(0, "振り返るL", 4)
		at = 15
		wait_objects(0)
		event.set_object_sequence_motion(1, "つかまり会話", 2)
		event.queue_object_sequence_next_motion(1, "屋根つかまり立ち", 4)
		event.set_mouth_texture_animations(1, "大口パク")
		at = 16
		helper_4116e6bb(2040040)
		at = 17
		wait_objects(1)
		event.set_object_sequence_motion(0, "振り返る会話", 2)
		event.queue_object_sequence_next_motion(0, "振り返るL", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 18
		helper_4116e6bb(2040050)
		at = 19
		wait_objects(0)
		event.set_camera_sequence_position(0.0, 135.98, -348.92)
		event.set_camera_sequence_look_at(0.0, 139.71, -310.0)
		event.set_object_sequence_position(0, 0.0, 0.0, -348.54)
		event.set_object_sequence_motion(1, "爆弾を取る", 6)
		event.queue_object_sequence_next_motion(1, "屋根つかまり立ち", 4)
		at = 20
		helper_888ab2a3(30)
		event.play_sound_effect(var0, 7)
		event.set_object_sequence_texture_animation(1, 0, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "わらい顔")
		event.set_character_active(33)
		at = 21
		helper_888ab2a3(30)
		do
			local out1, out2, out3 = event.get_object_handle_frame_position(1, "bomb")
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z_2 = out3 or pos_z_2
		end
		event.detach_character_from_frame(33)
		event.set_character_position(33, pos_x, pos_y, pos_z_2)
		event.set_character_rotation(33, 0.0, 3.14, 0.0)
		event.play_sound_effect(var0, 8)
		at = 22
		wait_objects(1)
		event.set_mouth_texture_animations(1, "わらい口パク")
		at = 23
		helper_4116e6bb(2040060)
		event.set_camera_sequence_position(60.12, 164.95, -266.6)
		event.set_camera_sequence_look_at(-4.48, 133.95, -322.74)
		event.set_object_sequence_position(0, 0.0, 133.53, -348.54)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_object_sequence_motion(0, "振り返る会話", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(0, "振り返るL", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 24
		helper_4116e6bb(2040070)
		at = 25
		wait_objects(0)
		event.set_object_sequence_motion(1, "つかまり会話", 2)
		event.queue_object_sequence_next_motion(1, "屋根つかまり立ち", 4)
		event.set_mouth_texture_animations(1, "わらい口パク")
		at = 26
		helper_4116e6bb(2040080)
		event.set_mouth_texture_animations(1, "わらい口パク")
		at = 27
		helper_4116e6bb(2040085)
		at = 28
		wait_objects(1)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 29
		helper_4116e6bb(2040090)
		event.stop_sound_effect(var0, 5)
		event.set_camera_sequence_position(265.45, 83.77, -902.43)
		event.set_camera_sequence_look_at(166.76, 61.63, -1102.39)
		event.play_sound_effect(var0, 2)
		event.play_sound_effect(var0, 9)
		event.set_character_active(1, 38)
		pos_z = -1000.0
		var8 = 0
		while var8 < 4 do
			pos_z = vm.f32(pos_z - 20.0)
			event.set_object_sequence_position(8, 76.0, 60.0, pos_z)
			event.delay_object_sequence_position_track(8, 5)
			var8 = var8 + 1
		end
		var8 = 0
		while var8 < 4 do
			pos_z = vm.f32(pos_z + 20.0)
			event.set_object_sequence_position(8, 76.0, 60.0, pos_z)
			event.delay_object_sequence_position_track(8, 5)
			var8 = var8 + 1
		end
		var8 = 0
		while var8 < 4 do
			pos_z = vm.f32(pos_z - 20.0)
			event.set_object_sequence_position(8, 76.0, 60.0, pos_z)
			event.delay_object_sequence_position_track(8, 5)
			var8 = var8 + 1
		end
		event.set_character_active(1, 37)
		event.set_object_sequence_motion(3, "攻撃", 4, -1.0, 1)
		event.set_object_sequence_motion(4, "攻撃", 4)
		at = 30
		helper_888ab2a3(60)
		event.set_character_active(0, 37)
		event.set_character_active(0, 38)
		event.set_camera_sequence_position(251.7, 76.66, -1109.07)
		event.set_camera_sequence_look_at(237.17, 73.79, -1129.16)
		event.set_object_sequence_motion(3, "ニヤリ2", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(3, "ニヤリ2L", 4)
		event.set_object_sequence_motion(4, "ニヤリ2", 6)
		event.queue_object_sequence_next_motion(4, "ニヤリ2L", 4)
		at = 31
		helper_888ab2a3(40)
		event.stop_sound_effect(var0, 2)
		event.set_camera_sequence_position(19.44, 139.93, -287.75)
		event.set_camera_sequence_look_at(-8.51, 144.37, -325.96)
		event.play_sound_effect(var0, 5)
		event.play_sound_effect(var0, 10)
		event.set_object_sequence_motion(0, "顔を戻す", 6)
		event.queue_object_sequence_next_motion(0, "やってみる！", 6)
		event.queue_object_sequence_next_motion(0, "振り返るL", 4)
		at = 32
		helper_888ab2a3(10)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 33
		helper_4116e6bb(2040100)
		at = 34
		wait_objects(0)
		event.set_object_sequence_motion(1, "つかまり会話", 2)
		event.queue_object_sequence_next_motion(1, "屋根つかまり立ち", 4)
		at = 35
		helper_4116e6bb(2040110)
		at = 36
		wait_objects(1)
		event.stop_sound_effect(var0, 5)
		event.stop_sound_effect(var0, 10)
		event.set_camera_sequence_position(240.0, 37.39, -800.0)
		event.set_camera_sequence_look_at(240.0, 42.12, -900.0)
		event.move_object_sequence(3, 240.0, 0.0, -860.0, 90)
		event.set_character_active(1, 37)
		event.play_sound_effect(var0, 2)
		event.play_sound_effect(var0, 11)
		event.play_sound_effect(var0, 12)
		event.set_object_sequence_motion(3, "攻撃戻り", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(3, "走行2", 4)
		event.set_object_sequence_motion(4, "攻撃戻り", 6)
		event.queue_object_sequence_next_motion(4, "走行2", 4)
		at = 37
		helper_888ab2a3(10)
		event.set_character_active(0, 37)
		event.set_event_sprite_draw_pass(0, 1)
		event.set_object_sequence_color(9, 128, 128, 128, 128, 30)
		var3 = 0
		var12 = 6.0
		var13 = 0.0
		var14 = vm.f32(0.01)
		while true do
			var12 = vm.f32(var12 - var13)
			var13 = vm.f32(var13 + var14)
			if var12 < 1.0 then
				event.set_object_sequence_scale(9, 1.0, 1.0, 1.0)
				break
			else
				event.set_object_sequence_scale(9, var12, var12, var12)
				var3 = vm.i32(var3 + 1)
				at = 38
				vm.wait(38)
			end
		end
		at = 39
		helper_888ab2a3(vm.i32(70 - var3))
		event.fade_out_screen(10)
		at = 40
		helper_888ab2a3(10)
	end, function(received: { any }): boolean
		if at <= 1 then
			helper_238b5abc(1)
		end
		if at <= 2 then
			helper_344d6cd8()
		end
		if at <= 3 then
			helper_038a2e4d(65)
		end
		if at <= 4 then
			helper_238b5abc(0)
		end
		if at <= 5 then
			helper_038a2e4d(10)
		end
		if at <= 6 then
			helper_238b5abc(3)
		end
		if at <= 7 then
			angle = 0.0
			var3 = 0
			var4 = vm.f32(vm.f32(vm.sin(angle) * 30.0) + 240.0)
			angle = vm.f32(angle + vm.f32(0.15707964))
			local _ = var3 < 40
			var3 = var3 + 1
		end
		if at <= 8 then
			helper_238b5abc(3)
		end
		if at <= 9 then
			helper_038a2e4d(40)
		end
		if at <= 10 then
			pos_z = -1000.0
			var8 = 0
			pos_z = vm.f32(pos_z - 20.0)
			local _ = var8 < 4
			var8 = var8 + 1
			var8 = 0
			pos_z = vm.f32(pos_z + 20.0)
			local _ = var8 < 4
			var8 = var8 + 1
			var8 = 0
			pos_z = vm.f32(pos_z - 20.0)
			local _ = var8 < 4
			var8 = var8 + 1
			helper_344d6cd8()
		end
		if at <= 11 then
			helper_344d6cd8()
		end
		if at <= 12 then
			helper_8cd371d7(2040020)
		end
		if at <= 13 then
			helper_8cd371d7(2040030)
		end
		if at <= 14 then
			helper_238b5abc(0)
		end
		if at <= 15 then
			helper_8cd371d7(2040040)
		end
		if at <= 16 then
			helper_238b5abc(1)
		end
		if at <= 17 then
			helper_8cd371d7(2040050)
		end
		if at <= 18 then
			helper_238b5abc(0)
		end
		if at <= 19 then
			helper_038a2e4d(30)
		end
		if at <= 20 then
			helper_038a2e4d(30)
		end
		if at <= 21 then
			helper_238b5abc(1)
		end
		if at <= 22 then
			helper_8cd371d7(2040060)
		end
		if at <= 23 then
			helper_8cd371d7(2040070)
		end
		if at <= 24 then
			helper_238b5abc(0)
		end
		if at <= 25 then
			helper_8cd371d7(2040080)
		end
		if at <= 26 then
			helper_8cd371d7(2040085)
		end
		if at <= 27 then
			helper_238b5abc(1)
		end
		if at <= 28 then
			helper_8cd371d7(2040090)
		end
		if at <= 29 then
			pos_z = -1000.0
			var8 = 0
			pos_z = vm.f32(pos_z - 20.0)
			local _ = var8 < 4
			var8 = var8 + 1
			var8 = 0
			pos_z = vm.f32(pos_z + 20.0)
			local _ = var8 < 4
			var8 = var8 + 1
			var8 = 0
			pos_z = vm.f32(pos_z - 20.0)
			local _ = var8 < 4
			var8 = var8 + 1
			helper_038a2e4d(60)
		end
		if at <= 30 then
			helper_038a2e4d(40)
		end
		if at <= 31 then
			helper_038a2e4d(10)
		end
		if at <= 32 then
			helper_8cd371d7(2040100)
		end
		if at <= 33 then
			helper_238b5abc(0)
		end
		if at <= 34 then
			helper_8cd371d7(2040110)
		end
		if at <= 35 then
			helper_238b5abc(1)
		end
		if at <= 36 then
			helper_038a2e4d(10)
		end
		if at <= 37 then
			var3 = 0
			var12 = 6.0
			var13 = 0.0
			var14 = vm.f32(0.01)
			var12 = vm.f32(var12 - var13)
			var13 = vm.f32(var13 + var14)
			var3 = var3 + 1
		end
		if at <= 38 then
			helper_038a2e4d(70 - var3)
		end
		if at <= 39 then
			helper_038a2e4d(10)
		end
		return true
	end)
	event.cancel_drama_scene_skip()
	event.play_music(0)
	event.stop_sound_effect(var0, 2)
	event.stop_sound_effect(var0, 4)
	event.stop_sound_effect(var0, 5)
	event.stop_sound_effect(var0, 9)
	event.stop_sound_effect(var0, 10)
	event.set_event_sprite_draw_pass(0, 0)
	event.set_function_point_enabled("p01_s03t", "door", 0)
	event.set_object_handle_rotation(5, 0.0, 0.0, 0.0)
	event.delete_character_extension_packs(0)
	event.delete_character(32)
	event.delete_character(33)
	event.delete_character(34)
	event.delete_character(35)
	event.delete_character(36)
	event.delete_character(37)
	event.delete_character(38)
	event.delete_event_image(0)
	event.clear_effect_manager()
	event.load_message_file(0, -1)
	event.set_character_active(0)
end

--- Helper function.
local function helper_16efc()
	local var0: s32 = 0
	local result: s32 = 0
	local var2: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local at: number = 0
	vm.section(function()
		event.set_save_flag(206, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.set_event_projection(524.9)
		event.stop_music(0)
		at = 1
		helper_888ab2a3(4)
		event.load_music(30)
		event.load_map_sounds(2209)
		var0 = event.load_sound_effect_file_2(2209) or var0
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.change_directory("event/e200/e206/")
		event.load_message_file(0, 5, "e206.txt")
		event.load_character_motion_pack(5, "e206_mints.gltf", "info", 0)
		event.set_character_active(0)
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.load_character(5, "p00_08a.gltf", "info", 33)
		event.set_character_active(0, 33)
		event.attach_object_handle_to_character(2, 33)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.load_character(5, "e206_starbre.gltf", "info", 34)
		event.set_character_active(34)
		event.attach_object_handle_to_character(3, 34)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.load_character(5, "e206_polcurse.gltf", "info", 35)
		event.set_character_active(0, 35)
		event.attach_object_handle_to_character(4, 35)
		event.clear_object_sequence(4)
		event.set_object_sequence_object(4, 4)
		event.load_character(5, "e206_h_polcurse.gltf", "info", 36)
		event.set_character_active(0, 36)
		event.attach_object_handle_to_character(5, 36)
		event.clear_object_sequence(5)
		event.set_object_sequence_object(5, 5)
		event.load_character(5, "b01a_buggy.gltf", "b01a_buggy", 37)
		event.set_character_active(37)
		event.attach_object_handle_to_character(6, 37)
		event.clear_object_sequence(6)
		event.set_object_sequence_object(6, 6)
		event.load_character(5, "b01a_macho.gltf", "b01a_macho", 38)
		event.set_character_active(38)
		event.attach_character_to_frame(37, "macho_chair", 38)
		event.load_character(5, "e206_bbaku.gltf", "info", 42)
		event.load_character(5, "e206_bfire.gltf", "info", 43)
		event.load_character(5, "e206_cloth.gltf", "info", 44)
		event.load_character(5, "e206_dfire.gltf", "info", 45)
		event.load_character(5, "e206_dfire.gltf", "info", 46)
		event.load_character(5, "e206_dfire_f.gltf", "info", 47)
		event.load_character(5, "e206_dfire_f.gltf", "info", 48)
		event.load_character(5, "e206_hikari.gltf", "info", 49)
		event.load_character(5, "e206_dynagiri.gltf", "info", 50)
		event.attach_object_handle_to_character(7, 50)
		event.clear_object_sequence(7)
		event.set_object_sequence_object(7, 7)
		event.load_character(5, "e206_hyakugiri.gltf", "info", 51)
		event.load_character(5, "e206_pbaku.gltf", "info", 52)
		event.set_character_active(0, 52)
		event.load_character(5, "e206_polcurse00.gltf", "info", 53)
		event.set_character_active(1, 53)
		event.change_directory("")
		event.load_character(5, "chara/c02_base.gltf", "info", 32)
		event.load_equipment_model(5, 1, 4, "info", 32)
		event.load_equipment_model(5, 1, 3, "info", 32)
		event.load_equipment_model(5, 1, 2, "info", 32, 39)
		event.load_equipment_model(5, 1, 1, "info", 32, 40)
		event.load_equipment_model(5, 1, 0, "info", 32, 41)
		event.load_character_motion_pack(5, "event/e200/e206/e206_monica.gltf", "info", 32)
		event.set_character_active(0, 32)
		event.set_character_active(0, 39)
		event.set_character_active(0, 40)
		event.set_character_active(0, 41)
		event.attach_object_handle_to_character(1, 32)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.initialize_effect_manager(5)
		event.load_effect_base("EVモニカ魔法－火")
		event.load_effect_base("EVモニカ魔法－火ヒット")
		event.load_effect_base("モニカ魔法－溜め")
		event.create_effect_work_buffer(5, 6000)
		event.set_object_sequence_position(0, 8.0, 134.45, -334.0)
		event.set_object_sequence_rotation(0, 0.0, 3.14, 0.0)
		event.set_object_sequence_motion(0, "びびる", 6, -1.0, 1)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "おこり顔")
		event.set_object_handle_texture_animation(0, 1, "半口")
		event.set_object_sequence_position(3, -8.0, 114.0, -303.0)
		event.set_object_sequence_rotation(3, 0.0, 3.14, 0.0)
		event.set_object_sequence_motion(3, "屋根つかまり立ち", 4)
		event.set_object_handle_texture_animation(3, 0)
		event.set_object_handle_texture_animation(3, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(3, 1, "通常目パチ")
		event.set_object_sequence_position(4, 220.0, 0.0, -580.0)
		event.set_object_sequence_motion(4, "じたばた", 4)
		event.set_object_handle_texture_animation(4, 0)
		event.set_object_handle_texture_animation(4, 1, "おこり顔")
		event.set_object_handle_texture_animation(4, 1, "おこり目パチ")
		event.set_object_handle_texture_animation(5, 0)
		event.set_object_handle_texture_animation(5, 1, "激怒わらい顔2")
		event.set_object_handle_texture_animation(5, 1, "激怒目パチ")
		event.set_object_handle_sound_bank(5, var0)
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_position(6, 220.0, 0.0, -580.0)
		event.set_object_sequence_motion(6, "走行", 4)
		event.set_character_active(0, 42)
		event.set_character_position(42, 225.0, 34.0, -486.0)
		event.set_character_active(43)
		event.set_character_position(43, 220.0, 0.0, -580.0)
		event.set_character_active(0, 44)
		event.set_character_position(44, 0.0, 139.18, -620.0)
		event.attach_character_to_frame(36, "f1", 45)
		event.set_character_position(45, 0.0, 0.0, 0.0)
		event.attach_character_to_frame(36, "f2", 46)
		event.set_character_position(46, 0.0, 0.0, 0.0)
		event.attach_character_to_frame(36, "f1", 47)
		event.set_character_position(47, 0.0, 2.0, 0.0)
		event.attach_character_to_frame(36, "f2", 48)
		event.set_character_position(48, 0.0, 2.0, 0.0)
		event.set_character_active(0, 49)
		event.set_character_position(49, 0.0, 139.18, -712.0)
		event.set_character_position(50, 0.0, 139.18, -460.0)
		event.set_character_rotation(50, 0.0, 3.14, 0.0)
		event.set_character_position(51, 0.0, 139.18, -490.0)
		event.set_character_rotation(51, 0.0, 0.0, 0.0)
		event.set_character_position(53, 220.0, 0.0, -580.0)
		event.set_character_rotation(53, 0.0, 0.0, 0.0)
		event.set_character_motion(53, "じたばた", 4)
		event.enable_drama_skip()
		event.set_wind(10, 0.0, 0.0, -1.0)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(361.41, 48.91, -580.59)
		event.set_camera_sequence_look_at(233.41, 52.06, -580.59)
		event.play_sound_effect(var0, 2)
		event.play_sound_effect(var0, 3)
		event.fade_in_screen(30)
		event.set_mouth_texture_animations(4, "おこり顔口パク")
		at = 2
		helper_4116e6bb(2060010)
		event.set_mouth_texture_animations(4, "おこり顔口パク")
		at = 3
		helper_4116e6bb(2060013)
		event.open_voice_stream_wave(1, 2060015)
		at = 4
		helper_9cbdc640(1)
		event.set_camera_sequence_position(220.0, 60.0, -420.0)
		event.set_camera_sequence_look_at(220.0, 60.0, -580.0)
		event.stop_sound_effect(var0, 2)
		event.stop_sound_effect(var0, 3)
		event.play_sound_effect(var0, 4)
		event.set_character_active(0, 53)
		event.set_character_active(1, 35)
		event.move_camera_sequence_eased(256.05, 60.0, -351.07, 160.79, 130.27, -549.21, 30, 2, 1.0)
		event.set_object_sequence_motion(4, "ふっとび", 6)
		event.move_object_sequence(4, 14.0, 0.0, -610.0, 50)
		event.set_object_sequence_motion(6, "左側でダメージ", 6)
		event.queue_object_sequence_next_motion(6, "右側でダメージ", 6)
		event.move_object_sequence_eased(6, 220.0, 0.0, -1000.0, 40, 1, 1.0)
		event.set_character_active(0, 43)
		event.set_character_active(42)
		event.set_character_motion(42, "ｴﾌｪｸﾄ_バギー爆発", 6)
		event.play_voice_stream(1)
		at = 5
		helper_888ab2a3(50)
		event.set_character_active(0, 38)
		event.set_character_active(0, 37)
		event.set_camera_sequence_position(0.0, 167.16, -367.46)
		event.set_camera_sequence_look_at(0.0, 129.42, -609.2)
		event.set_object_sequence_position(4, 0.0, 139.18, -620.0)
		event.set_object_sequence_motion(4, "どさっと落ちた", 6)
		at = 6
		helper_888ab2a3(8)
		event.play_sound_effect(var0, 5)
		at = 7
		helper_888ab2a3(34)
		event.close_voice_stream(1)
		event.set_camera_sequence_position(19.88, 150.6, -361.7)
		event.set_camera_sequence_look_at(8.1, 156.22, -333.48)
		event.set_object_handle_texture_animation(0, 1, "まばたき目パチ")
		event.open_voice_stream_wave(1, 2060017)
		at = 8
		helper_888ab2a3(40)
		at = 9
		helper_9cbdc640(1)
		event.set_camera_sequence_position(60.03, 148.42, -606.42)
		event.set_camera_sequence_look_at(0.0, 151.12, -606.2)
		event.move_camera_sequence(60.03, 148.42, -614.42, 0.0, 151.12, -614.2, 48)
		event.play_voice_stream(1)
		event.play_sound_effect(var0, 7)
		event.set_object_sequence_motion(4, "起きあがり", 6)
		at = 10
		helper_888ab2a3(48)
		event.close_voice_stream(1)
		event.set_camera_sequence_position(0.0, 161.43, -576.15)
		event.set_camera_sequence_look_at(0.0, 167.01, -624.67)
		event.play_sound_effect(var0, 8)
		event.set_object_handle_texture_animation(4, 0)
		event.set_object_handle_texture_animation(4, 1, "激怒顔")
		event.set_object_handle_texture_animation(4, 1, "激怒目パチ")
		event.set_object_sequence_motion(4, "顔上げ", 6)
		event.queue_object_sequence_next_motion(4, "ワナワナ", 4)
		at = 11
		helper_4116e6bb(2060020)
		event.set_camera_sequence_position(10.4, 144.62, -387.58)
		event.set_camera_sequence_look_at(8.88, 150.2, -322.21)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "おこり目パチ")
		event.set_object_sequence_motion(0, "びびる", 6, -1.0, 1)
		event.set_mouth_texture_animations(0, "通常口パク", "半口")
		at = 12
		helper_4116e6bb(2060030)
		event.set_camera_sequence_position(0.0, 156.37, -537.41)
		event.set_camera_sequence_look_at(0.0, 159.13, -624.67)
		event.set_object_handle_texture_animation(4, 0)
		event.set_object_handle_texture_animation(4, 1, "激怒わらい顔")
		event.set_object_handle_texture_animation(4, 1, "激怒目パチ")
		event.set_object_sequence_motion(4, "脱ぎ構え", 6)
		at = 13
		helper_888ab2a3(14)
		event.play_sound_effect(var0, 9)
		at = 14
		helper_888ab2a3(20)
		event.set_camera_sequence_position(49.82, 158.45, -577.41)
		event.set_camera_sequence_look_at(28.49, 183.1, -641.57)
		event.play_sound_effect(var0, 10)
		event.set_character_active(0, 35)
		event.set_character_active(36)
		event.set_object_sequence_position(5, 0.0, 139.18, -620.0)
		event.set_object_sequence_motion(5, "脱ぐ", 6)
		event.queue_object_sequence_next_motion(5, "脱ぐＬ", 4)
		event.set_character_active(44)
		event.set_character_motion(44, "ｴﾌｪｸﾄ_脱衣", 6)
		at = 15
		helper_888ab2a3(16)
		event.move_camera_sequence_eased(49.82, 158.45, -577.41, 1.0, 162.91, -620.29, 20, 0, 0.4)
		at = 16
		wait_camera()
		event.play_music(0)
		at = 17
		helper_888ab2a3(4)
		event.set_character_active(0, 44)
		event.start_crossfade(30)
		event.set_camera_sequence_position(0.0, 153.08, -533.86)
		event.set_camera_sequence_look_at(0.0, 158.5, -620.41)
		at = 18
		helper_888ab2a3(70)
		event.set_camera_sequence_position(-16.28, 155.87, -380.81)
		event.set_camera_sequence_look_at(12.48, 144.4, -292.95)
		event.set_object_handle_texture_animation(0, 1, "前向き～左向き")
		event.set_object_sequence_motion(3, "つかまり会話", 6)
		event.queue_object_sequence_next_motion(3, "屋根つかまり立ち", 4)
		event.set_object_sequence_motion(0, "振り向く", 6)
		event.queue_object_sequence_next_motion(0, "振り向くL", 4)
		event.set_mouth_texture_animations(3, "通常口パク", "大口")
		at = 19
		helper_4116e6bb(2060040)
		event.set_object_handle_texture_animation(0, 1, "左向き～前向き")
		event.set_object_handle_texture_animation(0, 1, "半口～大口")
		event.set_object_sequence_motion(0, "振り向く戻り", 6)
		event.queue_object_sequence_next_motion(0, "びびる", 4)
		at = 20
		helper_4116e6bb(2060050)
		event.start_crossfade(30)
		event.set_object_handle_texture_animation(5, 0)
		event.set_object_handle_texture_animation(5, 1, "激怒わらい顔")
		event.set_object_handle_texture_animation(5, 1, "激怒目パチ")
		event.set_camera_sequence_follow_object(5, 0.0, 23.0, 0.0, 0.0, 9.8, 80.0)
		event.move_camera_sequence_angle_height_distance_eased(0.0, 9.8, 40.0, 160, 2, 1.0)
		event.set_object_sequence_position(5, 0.0, 139.18, -800.0)
		event.set_object_sequence_motion(5, "脱ぎ歩き", 4)
		event.move_object_sequence(5, 0.0, 139.18, -570.0, 270)
		event.set_mouth_texture_animations(5, "激怒わらい口パク")
		at = 21
		helper_0382f327(2060060, 270)
		event.set_object_sequence_motion(5, "さあさあＬ")
		event.set_object_sequence_motion_blend_step(5, 0.1)
		event.delay_object_sequence_motion_track(5, 140)
		event.set_object_sequence_motion(5, "ごらあ", 2)
		event.queue_object_sequence_next_motion(5, "ごらあＬ", 4)
		event.set_mouth_texture_animations(5, "激怒わらい口パク")
		at = 22
		helper_0382f327(2060070, 270)
		at = 23
		wait_objects(5)
		event.release_camera_sequence_follow_object()
		event.set_object_sequence_motion(5, "後ろに気がつく", 5)
		event.set_camera_sequence_position(17.47, 148.06, -359.89)
		event.set_camera_sequence_look_at(7.59, 155.6, -333.8)
		event.play_sound_effect(var0, 11)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "おこり顔")
		event.set_object_handle_texture_animation(0, 1, "おこり目～ひき目")
		event.set_object_sequence_motion(0, "ひく", 6)
		event.queue_object_sequence_next_motion(0, "ひくL", 4)
		event.set_mouth_texture_animations(0, "ひき口パク")
		at = 24
		helper_4116e6bb(2060080)
		event.start_background_file_loads_1("snd2/bgm/bg_104.sound.json")
		at = 25
		helper_479dc9e9()
		event.set_camera_sequence_follow_object(5, 0.0, 23.0, 0.0, 0.0, 9.8, 38.0)
		event.fade_out_music(30)
		event.play_sound_effect(var0, 12)
		event.set_object_sequence_position(5, 0.0, 139.18, -468.0)
		event.move_object_sequence(5, 0.0, 139.18, -450.0, 30)
		event.set_object_sequence_motion(5, "後ろに気がつく", 6)
		event.queue_object_sequence_next_motion(5, "後ろに気がつくＬ", 4)
		event.delay_object_sequence_texture_animation_track(5, 26)
		event.set_object_sequence_texture_animation(5, 0)
		event.set_object_sequence_texture_animation(5, 1, "きづく顔")
		at = 26
		helper_4116e6bb(2060090)
		at = 27
		wait_objects(5)
		event.stop_music(0)
		at = 28
		helper_888ab2a3(4)
		event.load_music_pack(104)
		event.play_music(0)
		event.release_camera_sequence_follow_object()
		event.set_character_active(33)
		event.set_object_sequence_position(2, 0.0, 139.18, -712.0)
		event.set_object_sequence_motion(5, "振りかえり", 6)
		event.queue_object_sequence_next_motion(5, "振りかえりＬ", 4)
		event.move_camera_sequence_eased(0.0, 198.49, -396.69, 0.0, 175.46, -468.0, 20, 0, 0.4)
		at = 29
		wait_camera()
		at = 30
		helper_888ab2a3(20)
		event.set_camera_sequence_position(-0.0, 161.25, -679.19)
		event.set_camera_sequence_look_at(-0.0, 158.97, -713.45)
		event.set_mouth_texture_animations(2, "口パク")
		at = 31
		helper_4116e6bb(2060100)
		event.set_camera_sequence_position(0.0, 166.31, -519.59)
		event.set_camera_sequence_look_at(0.0, 164.03, -473.3)
		event.set_object_handle_texture_animation(5, 0)
		event.set_object_handle_texture_animation(5, 1, "激怒顔")
		event.set_object_handle_texture_animation(5, 1, "激怒目パチ")
		event.set_object_sequence_rotation(5, 0.0, 3.14, 0.0)
		event.set_object_sequence_motion(5, "会話", 6)
		event.queue_object_sequence_next_motion(5, "会話用立ち", 4)
		event.set_mouth_texture_animations(5, "激怒口パク")
		at = 32
		helper_4116e6bb(2060110)
		event.set_object_handle_texture_animation(5, 0)
		event.set_object_handle_texture_animation(5, 1, "激怒わらい顔2")
		event.set_object_handle_texture_animation(5, 1, "激怒目パチ")
		event.set_mouth_texture_animations(5, "激怒わらい口パク")
		at = 33
		helper_4116e6bb(2060120)
		event.set_mouth_texture_animations(5, "激怒口パク")
		at = 34
		helper_4116e6bb(2060125)
		at = 35
		wait_objects(5)
		event.play_sound_effect(var0, 13)
		event.set_object_sequence_motion(5, "爆弾取り出し", 6)
		event.queue_object_sequence_next_motion(5, "火付け", 6)
		event.wait_object_sequence_motion_end(5)
		at = 36
		helper_888ab2a3(24)
		event.play_sound_effect(var0, 14)
		event.set_object_handle_texture_animation(5, 1, "火ふき口")
		event.set_character_active(48)
		event.set_character_motion(48, "ｴﾌｪｸﾄ_ﾀﾞｲﾅﾏｲﾄ着火", 6)
		at = 37
		helper_888ab2a3(8)
		event.set_character_active(46)
		event.set_character_motion(46, "ｴﾌｪｸﾄ_ﾀﾞｲﾅﾏｲﾄ炎", 4)
		at = 38
		helper_888ab2a3(8)
		event.play_sound_effect(var0, 14)
		event.set_object_handle_texture_animation(5, 0, "火ふき口")
		event.set_object_handle_texture_animation(5, 1, "火ふき口")
		event.set_character_active(47)
		event.set_character_motion(47, "ｴﾌｪｸﾄ_ﾀﾞｲﾅﾏｲﾄ着火", 6)
		at = 39
		helper_888ab2a3(8)
		event.set_character_active(45)
		event.set_character_motion(45, "ｴﾌｪｸﾄ_ﾀﾞｲﾅﾏｲﾄ炎", 4)
		at = 40
		wait_objects(5)
		event.play_sound_effect(var0, 15)
		event.set_character_active(0, 47)
		event.set_character_active(0, 48)
		event.set_object_sequence_motion(5, "爆弾歩き")
		event.move_object_sequence(5, 0.0, 139.18, -490.0, 220)
		event.set_object_handle_texture_animation(5, 0, "火ふき口")
		event.set_mouth_texture_animations(5, "激怒わらい口パク")
		at = 41
		helper_0382f327(2060130, 210)
		event.stop_sound_effect(var0, 15)
		event.set_object_sequence_motion(5, "構え2", 4)
		event.set_camera_sequence_position(23.2, 152.06, -685.78)
		event.set_camera_sequence_look_at(-0.59, 157.87, -710.51)
		at = 42
		helper_888ab2a3(40)
		event.set_camera_sequence_position(0.49, 160.57, -693.45)
		event.set_camera_sequence_look_at(-0.32, 160.57, -710.52)
		event.fade_out_music(30)
		at = 43
		helper_888ab2a3(10)
		event.play_sound_effect(var0, 16)
		at = 44
		helper_888ab2a3(10)
		event.set_character_active(49)
		event.set_character_motion(49, "光る", 6)
		event.init_screen_raster_effect(0.0, 0.0, 0.15707964)
		event.start_screen_raster_effect(60.0, 0.3926991, -1.0, 50)
		at = 45
		helper_888ab2a3(20)
		event.stop_music(0)
		at = 46
		helper_888ab2a3(30)
		event.start_background_file_loads_1("snd2/bgm/bg_190.sound.json")
		at = 47
		helper_479dc9e9()
		event.set_camera_sequence_position(0.0, 162.13, -550.88)
		event.set_camera_sequence_look_at(0.0, 160.57, -488.42)
		event.set_object_handle_texture_animation(5, 0)
		event.set_object_handle_texture_animation(5, 1, "おこり顔")
		event.set_object_handle_texture_animation(5, 1, "おこり目パチ")
		event.stop_screen_raster_effect(0.0, 0.0, 0.0, 0)
		event.load_music_pack(190)
		event.play_music(0)
		event.set_mouth_texture_animations(5, "おこり口パク")
		at = 48
		helper_4116e6bb(2060140)
		event.set_camera_sequence_position(21.57, 145.5, -694.43)
		event.set_camera_sequence_look_at(0.0, 145.5, -710.52)
		event.move_camera_sequence(21.57, 150.5, -694.43, 0.0, 150.5, -710.52, 48)
		event.play_sound_effect(var0, 17)
		event.set_character_motion(49, "消える", 6)
		event.init_screen_raster_effect(60.0, 0.3926991, 0.15707964)
		event.start_screen_raster_effect(-1.0, -1.0, -1.0, 0)
		event.stop_screen_raster_effect(0.0, -1.0, -1.0, 40)
		event.set_character_active(0, 33)
		event.set_character_active(32)
		event.set_character_active(39)
		event.set_character_active(40)
		event.set_character_active(41)
		event.set_object_sequence_position(1, 0.0, 139.18, -712.0)
		event.set_object_sequence_motion(1, "立ち", 4, -1.0, 1)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(1, 1, "目とじ")
		at = 49
		helper_888ab2a3(48)
		event.set_camera_sequence_position(16.18, 155.0, -733.35)
		event.set_camera_sequence_look_at(0.0, 155.0, -714.81)
		event.move_camera_sequence(16.18, 160.0, -733.35, 0.0, 160.0, -714.81, 48)
		event.play_sound_effect(var0, 18)
		event.set_object_sequence_motion(1, "髪の毛バサッ", 6)
		event.queue_object_sequence_next_motion(1, "髪の毛バサッＬ", 4)
		at = 50
		helper_888ab2a3(48)
		event.set_character_active(0, 49)
		event.set_camera_sequence_position(0.0, 160.11, -684.49)
		event.set_camera_sequence_look_at(0.0, 160.11, -710.52)
		event.play_sound_effect(var0, 19)
		event.set_object_sequence_motion(1, "うつむき～構え", 6)
		event.queue_object_sequence_next_motion(1, "構えＬ", 4)
		event.delay_object_sequence_texture_animation_track(1, 20)
		event.set_object_sequence_texture_animation(1, 1, "目とじ～目あき")
		event.delay_object_sequence_texture_animation_track(1, 20)
		event.set_object_sequence_texture_animation(1, 1, "目にらみ目")
		event.set_object_sequence_texture_animation(1, 1, "口とじ～にらみ口")
		at = 51
		helper_888ab2a3(40)
		event.play_sound_effect(var0, 22)
		event.stop_sound_effect(var0, 16)
		at = 52
		helper_888ab2a3(20)
		event.set_camera_sequence_position(22.15, 166.63, -756.1)
		event.set_camera_sequence_look_at(1.09, 150.66, -651.12)
		event.set_object_sequence_position(5, 0.0, 139.18, -460.0)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "おこり顔")
		event.set_object_handle_texture_animation(1, 1, "おこり目パチ")
		event.set_object_handle_texture_animation(5, 0)
		event.set_object_handle_texture_animation(5, 1, "おどろき顔")
		event.set_object_handle_texture_animation(5, 1, "おこり目パチ")
		event.set_mouth_texture_animations(5, "おこり口パク")
		at = 53
		helper_4116e6bb(2060150)
		event.set_object_sequence_motion(1, "ジャンプ", 2)
		at = 54
		helper_888ab2a3(4)
		event.play_sound_effect(var0, 23)
		at = 55
		helper_888ab2a3(8)
		event.set_camera_sequence_position(74.99, 148.72, -384.25)
		event.set_camera_sequence_look_at(-4.53, 162.4, -478.25)
		event.move_camera_sequence_eased(44.68, 149.84, -420.08, -4.53, 162.4, -478.25, 90, 2, 0.4)
		event.set_object_sequence_position(1, 0.0, 139.18, -490.0)
		event.set_object_sequence_motion(1, "斬り一連", 6, -1.0, 1)
		event.delay_object_sequence_sound_track(1, 13)
		event.play_object_sequence_sound(1, var0, 25)
		event.delay_object_sequence_sound_track(1, 14)
		event.play_object_sequence_sound(1, var0, 25)
		event.delay_object_sequence_sound_track(1, 7)
		event.play_object_sequence_sound(1, var0, 25)
		event.delay_object_sequence_sound_track(1, 13)
		event.play_object_sequence_sound(1, var0, 25)
		event.delay_object_sequence_sound_track(1, 11)
		event.play_object_sequence_sound(1, var0, 25)
		event.delay_object_sequence_sound_track(1, 19)
		event.play_object_sequence_sound(1, var0, 25)
		event.delay_object_sequence_sound_track(1, 12)
		event.play_object_sequence_sound(1, var0, 25)
		event.delay_object_sequence_sound_track(1, 7)
		event.play_object_sequence_sound(1, var0, 25)
		event.delay_object_sequence_position_track(5, 13)
		event.move_object_sequence(5, 0.0, 139.78, -460.0, 1)
		event.move_object_sequence(5, 0.0, 139.18, -460.0, 1)
		event.move_object_sequence(5, 0.0, 139.57999, -460.0, 1)
		event.move_object_sequence(5, 0.0, 139.18, -460.0, 1)
		event.delay_object_sequence_position_track(5, 10)
		event.move_object_sequence(5, 0.0, 139.78, -460.0, 1)
		event.move_object_sequence(5, 0.0, 139.18, -460.0, 1)
		event.move_object_sequence(5, 0.0, 139.57999, -460.0, 1)
		event.move_object_sequence(5, 0.0, 139.18, -460.0, 1)
		event.delay_object_sequence_position_track(5, 3)
		event.move_object_sequence(5, 0.0, 139.78, -460.0, 1)
		event.move_object_sequence(5, 0.0, 139.18, -460.0, 1)
		event.move_object_sequence(5, 0.0, 139.57999, -460.0, 1)
		event.move_object_sequence(5, 0.0, 139.18, -460.0, 1)
		event.delay_object_sequence_position_track(5, 9)
		event.move_object_sequence(5, 0.0, 139.78, -460.0, 1)
		event.move_object_sequence(5, 0.0, 139.18, -460.0, 1)
		event.move_object_sequence(5, 0.0, 139.57999, -460.0, 1)
		event.move_object_sequence(5, 0.0, 139.18, -460.0, 1)
		event.delay_object_sequence_position_track(5, 7)
		event.move_object_sequence(5, 0.0, 139.78, -460.0, 1)
		event.move_object_sequence(5, 0.0, 139.18, -460.0, 1)
		event.move_object_sequence(5, 0.0, 139.57999, -460.0, 1)
		event.move_object_sequence(5, 0.0, 139.18, -460.0, 1)
		event.delay_object_sequence_position_track(5, 15)
		event.move_object_sequence(5, 0.0, 139.78, -460.0, 1)
		event.move_object_sequence(5, 0.0, 139.18, -460.0, 1)
		event.move_object_sequence(5, 0.0, 139.57999, -460.0, 1)
		event.move_object_sequence(5, 0.0, 139.18, -460.0, 1)
		event.delay_object_sequence_position_track(5, 8)
		event.move_object_sequence(5, 0.0, 139.78, -460.0, 1)
		event.move_object_sequence(5, 0.0, 139.18, -460.0, 1)
		event.move_object_sequence(5, 0.0, 139.57999, -460.0, 1)
		event.move_object_sequence(5, 0.0, 139.18, -460.0, 1)
		event.delay_object_sequence_position_track(5, 3)
		event.move_object_sequence(5, 0.0, 139.78, -460.0, 1)
		event.move_object_sequence(5, 0.0, 139.18, -460.0, 1)
		event.move_object_sequence(5, 0.0, 139.57999, -460.0, 1)
		event.move_object_sequence(5, 0.0, 139.18, -460.0, 1)
		event.delay_object_sequence_position_track(7, 13)
		event.move_object_sequence(7, 0.0, 139.78, -460.0, 1)
		event.move_object_sequence(7, 0.0, 139.18, -460.0, 1)
		event.move_object_sequence(7, 0.0, 139.57999, -460.0, 1)
		event.move_object_sequence(7, 0.0, 139.18, -460.0, 1)
		event.delay_object_sequence_position_track(7, 10)
		event.move_object_sequence(7, 0.0, 139.78, -460.0, 1)
		event.move_object_sequence(7, 0.0, 139.18, -460.0, 1)
		event.move_object_sequence(7, 0.0, 139.57999, -460.0, 1)
		event.move_object_sequence(7, 0.0, 139.18, -460.0, 1)
		event.delay_object_sequence_position_track(7, 3)
		event.move_object_sequence(7, 0.0, 139.78, -460.0, 1)
		event.move_object_sequence(7, 0.0, 139.18, -460.0, 1)
		event.move_object_sequence(7, 0.0, 139.57999, -460.0, 1)
		event.move_object_sequence(7, 0.0, 139.18, -460.0, 1)
		event.delay_object_sequence_position_track(7, 9)
		event.move_object_sequence(7, 0.0, 139.78, -460.0, 1)
		event.move_object_sequence(7, 0.0, 139.18, -460.0, 1)
		event.move_object_sequence(7, 0.0, 139.57999, -460.0, 1)
		event.move_object_sequence(7, 0.0, 139.18, -460.0, 1)
		event.delay_object_sequence_position_track(7, 7)
		event.move_object_sequence(7, 0.0, 139.78, -460.0, 1)
		event.move_object_sequence(7, 0.0, 139.18, -460.0, 1)
		event.move_object_sequence(7, 0.0, 139.57999, -460.0, 1)
		event.move_object_sequence(7, 0.0, 139.18, -460.0, 1)
		event.delay_object_sequence_position_track(7, 15)
		event.move_object_sequence(7, 0.0, 139.78, -460.0, 1)
		event.move_object_sequence(7, 0.0, 139.18, -460.0, 1)
		event.move_object_sequence(7, 0.0, 139.57999, -460.0, 1)
		event.move_object_sequence(7, 0.0, 139.18, -460.0, 1)
		event.delay_object_sequence_position_track(7, 8)
		event.move_object_sequence(7, 0.0, 139.78, -460.0, 1)
		event.move_object_sequence(7, 0.0, 139.18, -460.0, 1)
		event.move_object_sequence(7, 0.0, 139.57999, -460.0, 1)
		event.move_object_sequence(7, 0.0, 139.18, -460.0, 1)
		event.delay_object_sequence_position_track(7, 3)
		event.move_object_sequence(7, 0.0, 139.78, -460.0, 1)
		event.move_object_sequence(7, 0.0, 139.18, -460.0, 1)
		event.move_object_sequence(7, 0.0, 139.57999, -460.0, 1)
		event.move_object_sequence(7, 0.0, 139.18, -460.0, 1)
		event.set_object_handle_frame_draw_flag(5, "dm01", 0)
		event.set_object_handle_frame_draw_flag(5, "dm02", 0)
		event.set_object_handle_frame_draw_flag(5, "dm03", 0)
		event.set_object_handle_frame_draw_flag(5, "dm04", 0)
		event.set_object_handle_frame_draw_flag(5, "dm05", 0)
		event.set_object_handle_frame_draw_flag(5, "dm06", 0)
		event.set_object_handle_frame_draw_flag(5, "dm07", 0)
		event.set_object_handle_frame_draw_flag(5, "dm08", 0)
		event.set_character_active(0, 45)
		event.set_character_active(0, 46)
		event.set_character_active(50)
		event.set_character_motion(50, "構え2", 6)
		event.set_character_active(51)
		event.set_character_motion(51, "百烈斬り", 6)
		at = 56
		helper_888ab2a3(108)
		event.play_sound_effect(var0, 26)
		event.set_object_sequence_motion(5, "構え2から上向く", 2)
		event.queue_object_sequence_next_motion(5, "構え2から上向くＬ", 4)
		at = 57
		helper_888ab2a3(20)
		event.set_character_active(0, 50)
		event.set_character_active(0, 51)
		event.set_camera_sequence_position(17.12, 167.45, -472.74)
		event.set_camera_sequence_look_at(2.04, 165.02, -453.77)
		event.set_object_sequence_position(1, 0.0, 242.0, -432.79)
		event.set_object_sequence_rotation(1, 0.0, 3.14, 0.0)
		event.set_object_sequence_motion(1, "着地2", 1, -1.0, 1)
		event.delay_object_sequence_position_track(1, 14)
		event.set_object_sequence_position(1, 0.0, 142.0, -432.79)
		event.delay_object_sequence_motion_track(1, 14)
		event.set_object_sequence_motion(1, "着地2", 6)
		event.wait_object_sequence_motion_end(1)
		event.set_mouth_texture_animations(5, "おこり口パク")
		at = 58
		helper_0382f327(2060160, 30)
		at = 59
		wait_objects(1)
		event.set_camera_sequence_position(37.04, 163.18, -414.0)
		event.set_camera_sequence_look_at(-0.44, 155.57, -479.81)
		event.set_object_sequence_position(1, 0.0, 139.18, -466.39)
		event.set_object_sequence_position(5, 0.0, 139.18, -482.06)
		event.set_object_sequence_motion(1, "着地から蹴り", 6, -1.0, 1)
		at = 60
		helper_888ab2a3(10)
		event.play_sound_effect(var0, 27)
		event.set_object_sequence_motion(5, "蹴られ", 6)
		event.move_object_sequence(5, 0.0, 139.18, -582.06, 20)
		at = 61
		helper_888ab2a3(20)
		event.set_camera_sequence_position(102.08, 207.93, -668.58)
		event.set_camera_sequence_look_at(0.9, 248.52, -781.38)
		event.set_object_sequence_motion(5, "回転", 4)
		event.set_object_sequence_position(5, 0.0, 170.0, -700.0)
		event.jump_object_sequence(5, 0.0, 270.0, -810.0, -0.2, 30)
		at = 62
		helper_888ab2a3(30)
		event.set_camera_sequence_position(31.63, 178.14, -506.91)
		event.set_camera_sequence_look_at(-4.76, 161.36, -465.13)
		event.set_object_sequence_motion(1, "魔法構えＬ", 4, -1.0, 1)
		at = 63
		helper_888ab2a3(2)
		do
			local out1, out2, out3 = event.get_object_handle_frame_position(1, "item")
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		var2 = 0
		while var2 < 2 do
			event.play_sound_effect(var0, 28)
			event.reset_object_sequence_motion(1)
			event.set_object_sequence_motion(1, "魔法発射", 6)
			result = event.create_effect_3("モニカ魔法－溜め", 32) or result
			event.set_effect_first_vector(pos_x, pos_y, pos_z)
			event.set_effect_second_vector(128, 64, 64)
			event.create_effect_2("EVモニカ魔法－火", 32)
			event.set_effect_first_vector(pos_x, pos_y, pos_z)
			event.set_effect_target(36)
			at = 64
			vm.wait(64)
			event.finish_effect(32, result)
			at = 65
			helper_888ab2a3(12)
			var2 = var2 + 1
		end
		event.set_camera_sequence_position(2.63, 168.94, -402.89)
		event.set_camera_sequence_look_at(2.53, 174.18, -467.22)
		var2 = 0
		while var2 < 2 do
			event.play_sound_effect(var0, 28)
			event.reset_object_sequence_motion(1)
			event.set_object_sequence_motion(1, "魔法発射", 6)
			result = event.create_effect_3("モニカ魔法－溜め", 32) or result
			event.set_effect_first_vector(pos_x, pos_y, pos_z)
			event.set_effect_second_vector(128, 64, 64)
			event.create_effect_2("EVモニカ魔法－火", 32)
			event.set_effect_first_vector(pos_x, pos_y, pos_z)
			event.set_effect_target(36)
			at = 66
			vm.wait(66)
			event.finish_effect(32, result)
			at = 67
			helper_888ab2a3(12)
			event.play_sound_effect(var0, 29)
			var2 = var2 + 1
		end
		at = 68
		helper_888ab2a3(20)
		event.play_sound_effect(var0, 29)
		event.set_character_active(1, 52)
		event.set_character_position(52, 0.0, 270.0, -810.0)
		event.set_character_rotation(52, 0.0, 0.0, 0.0)
		event.set_character_motion(52, "ｴﾌｪｸﾄ_ポルカス爆発", 6)
		at = 69
		helper_888ab2a3(20)
		event.set_camera_sequence_position(384.95, 97.71, -2219.0)
		event.set_camera_sequence_look_at(49.63, 140.83, -1923.14)
		event.play_sound_effect(var0, 30)
		event.move_camera_sequence(384.95, 97.71, -2219.0, -38.17, 25.4, -2159.44, 80)
		event.set_character_position(52, 0.0, 260.0, -1700.0)
		event.set_character_rotation(52, 0.0, 0.0, 0.0)
		event.set_object_sequence_position(5, 0.0, 0.0, -1700.0)
		event.set_object_sequence_rotation(5, 0.0, 1.57, 0.0)
		event.move_object_sequence_eased(5, 0.0, 0.0, -2200.0, 40, 2, 1.0)
		event.set_object_sequence_motion(5, "バウンド", 6)
		at = 70
		helper_888ab2a3(48)
		event.play_sound_effect(var0, 31)
		at = 71
		helper_888ab2a3(32)
		event.set_camera_sequence_position(-63.62, 7.53, -2200.15)
		event.set_camera_sequence_look_at(-100.22, 4.78, -2200.62)
		event.set_object_sequence_position(5, -100.0, 0.0, -2200.0)
		event.set_object_sequence_motion(5, "落ちるアップ用", 6)
		event.set_object_handle_texture_animation(5, 0)
		event.set_object_handle_texture_animation(5, 1, "激怒顔")
		event.set_object_handle_texture_animation(5, 1, "激怒目パチ")
		helper_34d64c6e(0)
		at = 72
		helper_888ab2a3(40)
		event.start_background_file_loads_1("snd2/bgm/bg_112.sound.json")
		at = 73
		helper_479dc9e9()
		event.set_camera_sequence_position(0.0, 163.99, -340.4)
		event.set_camera_sequence_look_at(0.0, 161.92, -451.52)
		event.fade_out_music(40)
		helper_34d64c6e(1)
		event.play_sound_effect(var0, 32)
		event.set_object_sequence_motion(1, "魔法構え～立ち", 6)
		event.queue_object_sequence_next_motion(1, "振りかえり", 6)
		event.queue_object_sequence_next_motion(1, "振りかえりＬ", 4)
		at = 74
		helper_888ab2a3(30)
		event.start_crossfade(60)
		event.play_sound_effect(var0, 33)
		event.set_camera_sequence_position(-3.0, 160.0, -430.4)
		event.set_camera_sequence_look_at(-3.0, 160.0, -467.48)
		event.delay_object_sequence_texture_animation_track(1, 20)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目～通常目")
		event.set_object_sequence_texture_animation(1, 1, "にらみ口～口とじ")
		at = 75
		helper_888ab2a3(10)
		event.stop_music(0)
		at = 76
		helper_888ab2a3(10)
		event.load_music_pack(112)
		event.play_music(0)
		at = 77
		helper_888ab2a3(40)
		event.set_camera_sequence_position(21.75, 147.46, -348.38)
		event.set_camera_sequence_look_at(-0.97, 155.45, -337.06)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "おこり顔")
		event.set_object_handle_texture_animation(0, 1, "おどろき目パチ")
		event.set_object_sequence_position(0, 0.0, 134.45, -334.0)
		event.set_object_sequence_motion(0, "立ち", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "立ち", 4, -1.0, 1)
		event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
		at = 78
		helper_888ab2a3(40)
		event.start_crossfade(60)
		event.set_camera_sequence_look_at(0.0, 154.0, -400.0)
		event.set_camera_sequence_angle_height_distance(1.11, 18.0, 175.0)
		event.move_camera_sequence_angle_height_distance(2.03, 18.0, 175.0, 160)
		at = 79
		helper_0382f327(2060170, 120)
		event.open_voice_stream_wave(1, 2060180)
		at = 80
		helper_9cbdc640(1)
		event.play_voice_stream(1)
		event.open_message_window_2(0, 2060180)
		open_message(0, -1, 8, 0, 0)
		at = 81
		wait_camera()
		event.start_crossfade(30)
		event.set_camera_sequence_follow_object(1, 0.0, 23.0, 0.0, 0.57, 0.0, 30.0)
		event.move_camera_sequence_angle_height_distance_eased(1.57, 0.0, 30.0, 90, 2, 0.3)
		at = 82
		helper_61e5dba6(0, 120)
		close_message(0)
		event.close_voice_stream(1)
		at = 83
		wait_camera()
		event.release_camera_sequence_follow_object()
		event.start_crossfade(30)
		event.set_camera_sequence_follow_object(0, 0.0, 20.0, 0.0, -2.0, 0.0, 30.0)
		event.move_camera_sequence_angle_height_distance_eased(3.14, 0.0, 30.0, 90, 2, 1.0)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(0, 1, "通常目パチ")
		at = 84
		helper_0382f327(2060190, 140)
		at = 85
		wait_camera()
		event.release_camera_sequence_follow_object()
		event.fade_out_music(30)
		event.fade_out_screen(30)
		at = 86
		helper_888ab2a3(30)
	end, function(received: { any }): boolean
		if at <= 1 then
			helper_8cd371d7(2060010)
		end
		if at <= 2 then
			helper_8cd371d7(2060013)
		end
		if at <= 3 then
			helper_238b5abc(1)
		end
		if at <= 4 then
			helper_038a2e4d(50)
		end
		if at <= 5 then
			helper_038a2e4d(8)
		end
		if at <= 6 then
			helper_038a2e4d(34)
		end
		if at <= 7 then
			helper_038a2e4d(40)
		end
		if at <= 8 then
			helper_238b5abc(1)
		end
		if at <= 9 then
			helper_038a2e4d(48)
		end
		if at <= 10 then
			helper_8cd371d7(2060020)
		end
		if at <= 11 then
			helper_8cd371d7(2060030)
		end
		if at <= 12 then
			helper_038a2e4d(14)
		end
		if at <= 13 then
			helper_038a2e4d(20)
		end
		if at <= 14 then
			helper_038a2e4d(16)
		end
		if at <= 15 then
			helper_344d6cd8()
		end
		if at <= 16 then
			helper_038a2e4d(4)
		end
		if at <= 17 then
			helper_038a2e4d(70)
		end
		if at <= 18 then
			helper_8cd371d7(2060040)
		end
		if at <= 19 then
			helper_8cd371d7(2060050)
		end
		if at <= 20 then
			helper_53ffe901(2060060, 270)
		end
		if at <= 21 then
			helper_53ffe901(2060070, 270)
		end
		if at <= 22 then
			helper_238b5abc(5)
		end
		if at <= 23 then
			helper_8cd371d7(2060080)
		end
		if at <= 24 then
			helper_344d6cd8()
		end
		if at <= 25 then
			helper_8cd371d7(2060090)
		end
		if at <= 26 then
			helper_238b5abc(5)
		end
		if at <= 27 then
			helper_038a2e4d(4)
		end
		if at <= 28 then
			helper_344d6cd8()
		end
		if at <= 29 then
			helper_038a2e4d(20)
		end
		if at <= 30 then
			helper_8cd371d7(2060100)
		end
		if at <= 31 then
			helper_8cd371d7(2060110)
		end
		if at <= 32 then
			helper_8cd371d7(2060120)
		end
		if at <= 33 then
			helper_8cd371d7(2060125)
		end
		if at <= 34 then
			helper_238b5abc(5)
		end
		if at <= 35 then
			helper_038a2e4d(24)
		end
		if at <= 36 then
			helper_038a2e4d(8)
		end
		if at <= 37 then
			helper_038a2e4d(8)
		end
		if at <= 38 then
			helper_038a2e4d(8)
		end
		if at <= 39 then
			helper_238b5abc(5)
		end
		if at <= 40 then
			helper_53ffe901(2060130, 210)
		end
		if at <= 41 then
			helper_038a2e4d(40)
		end
		if at <= 42 then
			helper_038a2e4d(10)
		end
		if at <= 43 then
			helper_038a2e4d(10)
		end
		if at <= 44 then
			helper_038a2e4d(20)
		end
		if at <= 45 then
			helper_038a2e4d(30)
		end
		if at <= 46 then
			helper_344d6cd8()
		end
		if at <= 47 then
			helper_8cd371d7(2060140)
		end
		if at <= 48 then
			helper_038a2e4d(48)
		end
		if at <= 49 then
			helper_038a2e4d(48)
		end
		if at <= 50 then
			helper_038a2e4d(40)
		end
		if at <= 51 then
			helper_038a2e4d(20)
		end
		if at <= 52 then
			helper_8cd371d7(2060150)
		end
		if at <= 53 then
			helper_038a2e4d(4)
		end
		if at <= 54 then
			helper_038a2e4d(8)
		end
		if at <= 55 then
			helper_038a2e4d(108)
		end
		if at <= 56 then
			helper_038a2e4d(20)
		end
		if at <= 57 then
			helper_53ffe901(2060160, 30)
		end
		if at <= 58 then
			helper_238b5abc(1)
		end
		if at <= 59 then
			helper_038a2e4d(10)
		end
		if at <= 60 then
			helper_038a2e4d(20)
		end
		if at <= 61 then
			helper_038a2e4d(30)
		end
		if at <= 62 then
			helper_038a2e4d(2)
		end
		if at <= 63 then
			var2 = 0
		end
		if at <= 64 then
			helper_038a2e4d(12)
		end
		if at <= 65 then
			local _ = var2 < 2
			var2 = var2 + 1
			var2 = 0
		end
		if at <= 66 then
			helper_038a2e4d(12)
		end
		if at <= 67 then
			local _ = var2 < 2
			var2 = var2 + 1
			helper_038a2e4d(20)
		end
		if at <= 68 then
			helper_038a2e4d(20)
		end
		if at <= 69 then
			helper_038a2e4d(48)
		end
		if at <= 70 then
			helper_038a2e4d(32)
		end
		if at <= 71 then
			helper_4a9b8bc5(0)
			helper_038a2e4d(40)
		end
		if at <= 72 then
			helper_344d6cd8()
		end
		if at <= 73 then
			helper_4a9b8bc5(1)
			helper_038a2e4d(30)
		end
		if at <= 74 then
			helper_038a2e4d(10)
		end
		if at <= 75 then
			helper_038a2e4d(10)
		end
		if at <= 76 then
			helper_038a2e4d(40)
		end
		if at <= 77 then
			helper_038a2e4d(40)
		end
		if at <= 78 then
			helper_53ffe901(2060170, 120)
		end
		if at <= 79 then
			helper_238b5abc(1)
		end
		if at <= 80 then
			helper_f018b3c0(0, -1, 8, 0, 0)
			helper_344d6cd8()
		end
		if at <= 81 then
			helper_972d1084(0, 120)
		end
		if at <= 82 then
			helper_d16eef1e(0)
			helper_344d6cd8()
		end
		if at <= 83 then
			helper_53ffe901(2060190, 140)
		end
		if at <= 84 then
			helper_344d6cd8()
		end
		if at <= 85 then
			helper_038a2e4d(30)
		end
		return true
	end)
	event.cancel_drama_scene_skip()
	event.set_wind(0)
	event.stop_music(0)
	event.stop_sound_effect(var0, 2)
	event.stop_sound_effect(var0, 3)
	event.stop_sound_effect(var0, 15)
	event.stop_sound_effect(var0, 16)
	event.stop_screen_raster_effect(0.0, 0.0, 0.0, 0)
	event.delete_character_extension_packs(0)
	event.delete_character(32)
	event.delete_character(33)
	event.delete_character(34)
	event.delete_character(35)
	event.delete_character(36)
	event.delete_character(37)
	event.delete_character(38)
	event.delete_character(39)
	event.delete_character(40)
	event.delete_character(41)
	event.delete_character(42)
	event.delete_character(43)
	event.delete_character(44)
	event.delete_character(45)
	event.delete_character(46)
	event.delete_character(47)
	event.delete_character(48)
	event.delete_character(49)
	event.delete_character(50)
	event.delete_character(51)
	event.delete_character(52)
	event.delete_character(53)
	event.load_message_file(0, -1)
	event.clear_effect_manager()
	event.set_character_active(0)
	helper_34d64c6e(1)
	event.stop_music(0)
end

--- Helper function.
local function helper_15f44()
	local var0: s32 = 0
	local var1: any = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local at: number = 0
	return vm.guard(function()
		event.set_save_flag(205, 1)
		event.initialize_event()
		event.load_map_sounds(2206)
		var0 = event.load_sound_effect_file_2(2206) or var0
		helper_482d9cfc()
		event.stop_music(0)
		at = 1
		vm.wait(1)
		event.set_character_active(0, 0)
		event.set_character_active(1, 32)
		event.set_character_active(1, 33)
		event.set_character_active(1, 34)
		event.set_character_active(1, 35)
		event.set_character_active(1, 36)
		event.play_sound_effect(var0, 5)
		event.set_character_position(36, 102.27, 0.0, -305.63)
		event.set_character_rotation(36, 0.0, 0.0, 0.0)
		event.set_character_position(35, 44.05, 0.0, 60.82)
		event.set_character_scale(35, 2.0, 2.0, 2.0)
		event.reset_event_sprite(0)
		event.set_event_sprite_type(0, 0)
		event.set_event_sprite_position(0, 256, 208)
		event.set_event_sprite_size(0, 512, 416)
		event.set_event_sprite_color(0, 0, 0, 0, 0)
		event.set_event_sprite_draw_pass(0, 1)
		event.attach_object_handle_to_sprite(11, 0)
		event.clear_object_sequence(11)
		event.set_object_sequence_object(11, 11)
		event.play_sound_effect(var0, 1)
		event.attach_object_handle_to_map_part_2(10, "p01_s03t")
		event.clear_object_sequence(10)
		event.set_object_sequence_object(10, 10)
		do
			local out1, out2, out3 = event.get_object_handle_position(10)
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		event.set_object_sequence_rotation(10, 0.0, 0.0, 0.0)
		event.move_object_sequence(10, 0.0, 51.92, 0.0, 60)
		event.rotate_object_sequence(10, 0.0, 0.0, -0.785, 60)
		event.set_camera_sequence_position(67.41, 107.89, 704.3)
		event.set_camera_sequence_look_at(59.64, 108.51, 271.98)
		event.move_camera_sequence_eased(58.28, 107.89, 196.59, 57.34, 108.51, 144.64, 50, 1, 0.4)
		at = 2
		helper_888ab2a3(45)
		event.set_object_sequence_color(11, 0, 0, 0, 255, 30)
		at = 3
		helper_888ab2a3(30)
		event.set_map_piece_character_motion("p01_s03t", "kikan-m", "停止")
		event.clear_effect_manager()
		helper_f2b0ffcb()
		event.set_object_sequence_position(10, pos_x, pos_y, pos_z)
		event.set_object_sequence_rotation(10, 0.0, 0.0, 0.0)
		event.stop_all_sounds()
		at = 4
		helper_888ab2a3(4)
		event.load_music(60)
		event.play_music(1)
		event.set_message_window_mode(0, 8)
		event.open_message_window_2(0, "もう一度戦う\nタイトルに戻る")
		at = 5
		var1 = helper_bac0e30d(0, -1, 8, 0, 0, 2, 0)
		event.set_character_active(1, 0)
		event.fade_out_screen(0)
		event.set_event_sprite_draw_pass(0, 0)
		return var1
	end, function(received: { any })
		if at <= 5 then
			if at == 5 then
				var1 = received[1] :: number
			end
			if at <= 1 then
				helper_038a2e4d(45)
			end
			if at <= 2 then
				helper_038a2e4d(30)
			end
			if at <= 3 then
				helper_1ef0d4b2()
				helper_038a2e4d(4)
			end
			if at <= 4 then
				var1 = helper_7d54f41c(0, -1, 8, 0, 0, 2, 0)
			end
			return var1
		end
		return nil
	end)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Event 99, which map data, a script or the engine runs by number.
script.event_99 = helper_1ef0d4b2

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	event.set_map_piece_character_motion("p01_s03t", "kikan-m", "機関")
	event.set_character_position(0, 0.0, 140.0, -420.0)
	event.set_character_rotation(0, 0.0, 3.14, 0.0)
	event.set_camera_position(0.0, 200.0, -260.0)
	event.set_camera_look_at(0.0, 170.0, -420.0)
	event.reset_follow_camera(0)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
function script.key_open()
	helper_888ab2a3(30)
	helper_df50()
end

--- Event 501, which map data, a script or the engine runs by number.
function script.event_501()
	event.set_map_piece_character_motion("p01_s03t", "kikan-m", "機関")
	helper_fe3c()
	event.fade_in_screen(15)
	event.start_sub_game(3)
end

--- Event 502, which map data, a script or the engine runs by number.
function script.event_502()
	event.skip_next_music_load()
	event.jump_to_map_3(-1, "s08", 502)
	vm.wait(1)
end

--- Event 503, which map data, a script or the engine runs by number.
function script.event_503()
	event.set_map_piece_character_motion("p01_s03t", "kikan-m", "機関")
	helper_16efc()
	event.skip_next_music_play()
	event.jump_to_map_2(-1, "s02")
	vm.wait(2)
end

--- Event 512, which map data, a script or the engine runs by number.
function script.event_512()
	local var0: any = 0
	var0 = helper_15f44()
	helper_aa5b3ebe(var0)
end

--- Event 12040, which map data, a script or the engine runs by number.
function script.event_12040()
	helper_fe3c()
	event.fade_in_screen(15)
	event.start_sub_game(3)
end

--- Event 12050, which map data, a script or the engine runs by number.
function script.event_12050()
	local var0: any = 0
	var0 = helper_15f44()
	helper_aa5b3ebe(var0)
end

--- Event 12060, which map data, a script or the engine runs by number.
script.event_12060 = helper_16efc

--- Event 22010, which map data, a script or the engine runs by number.
function script.event_22010()
	vm.wait(1)
	event.set_character_position(0, 0.0, 140.0, -420.0)
	event.set_character_rotation(0, 0.0, 3.14, 0.0)
	event.start_sub_game(3)
end

return script
