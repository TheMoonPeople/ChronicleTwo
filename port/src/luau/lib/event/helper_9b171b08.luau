--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_238b5abc = require("@lib/event/helper_238b5abc")
local helper_344d6cd8 = require("@lib/event/helper_344d6cd8")
local helper_4116e6bb = require("@lib/event/helper_4116e6bb")
local helper_8cd371d7 = require("@lib/event/helper_8cd371d7")
local helper_9cbdc640 = require("@lib/event/helper_9cbdc640")
local wait_camera = require("@lib/event/wait_camera")
local wait_frames = require("@lib/event/wait_frames")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_9b171b08()
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
		wait_frames(4)
		event.load_music(191)
		event.load_map_sounds(2203)
		var0 = event.load_sound_effect_file_2(2203) or var0
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.change_directory("event/e200/e204/")
		event.load_message_file(0, 5, "e204_1.txt")
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
		block = event.load_event_image_4(5, "e204telop01_1.json", 0) or block
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
		wait_frames(65)
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
		wait_frames(10)
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
		wait_frames(40)
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
		wait_frames(30)
		event.play_sound_effect(var0, 7)
		event.set_object_sequence_texture_animation(1, 0, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "わらい顔")
		event.set_character_active(33)
		at = 21
		wait_frames(30)
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
		wait_frames(60)
		event.set_character_active(0, 37)
		event.set_character_active(0, 38)
		event.set_camera_sequence_position(251.7, 76.66, -1109.07)
		event.set_camera_sequence_look_at(237.17, 73.79, -1129.16)
		event.set_object_sequence_motion(3, "ニヤリ2", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(3, "ニヤリ2L", 4)
		event.set_object_sequence_motion(4, "ニヤリ2", 6)
		event.queue_object_sequence_next_motion(4, "ニヤリ2L", 4)
		at = 31
		wait_frames(40)
		event.stop_sound_effect(var0, 2)
		event.set_camera_sequence_position(19.44, 139.93, -287.75)
		event.set_camera_sequence_look_at(-8.51, 144.37, -325.96)
		event.play_sound_effect(var0, 5)
		event.play_sound_effect(var0, 10)
		event.set_object_sequence_motion(0, "顔を戻す", 6)
		event.queue_object_sequence_next_motion(0, "やってみる！", 6)
		event.queue_object_sequence_next_motion(0, "振り返るL", 4)
		at = 32
		wait_frames(10)
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
		wait_frames(10)
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
		wait_frames(vm.i32(70 - var3))
		event.fade_out_screen(10)
		at = 40
		wait_frames(10)
	end, function(received: { any }): boolean
		if at <= 1 then
			helper_238b5abc(1)
		end
		if at <= 2 then
			helper_344d6cd8()
		end
		if at <= 3 then
			wait_frames_skipping(65)
		end
		if at <= 4 then
			helper_238b5abc(0)
		end
		if at <= 5 then
			wait_frames_skipping(10)
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
			wait_frames_skipping(40)
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
			wait_frames_skipping(30)
		end
		if at <= 20 then
			wait_frames_skipping(30)
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
			wait_frames_skipping(60)
		end
		if at <= 30 then
			wait_frames_skipping(40)
		end
		if at <= 31 then
			wait_frames_skipping(10)
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
			wait_frames_skipping(10)
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
			wait_frames_skipping(70 - var3)
		end
		if at <= 39 then
			wait_frames_skipping(10)
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

return helper_9b171b08
