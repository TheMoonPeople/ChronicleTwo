--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0382f327 = require("@lib/event/helper_0382f327")
local helper_038a2e4d = require("@lib/event/helper_038a2e4d")
local helper_048ef29b = require("@lib/event/helper_048ef29b")
local helper_238b5abc = require("@lib/event/helper_238b5abc")
local helper_344d6cd8 = require("@lib/event/helper_344d6cd8")
local helper_4027021e = require("@lib/event/helper_4027021e")
local helper_4116e6bb = require("@lib/event/helper_4116e6bb")
local helper_42529d71 = require("@lib/event/helper_42529d71")
local helper_517ab114 = require("@lib/event/helper_517ab114")
local helper_53ffe901 = require("@lib/event/helper_53ffe901")
local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")
local helper_8a8cc5be = require("@lib/event/helper_8a8cc5be")
local helper_8cd371d7 = require("@lib/event/helper_8cd371d7")
local helper_8e5b8087 = require("@lib/event/helper_8e5b8087")
local helper_9cbdc640 = require("@lib/event/helper_9cbdc640")
local wait_camera = require("@lib/event/wait_camera")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_ceda7a53()
	local var2: s32 = 0
	local var3: s32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local block: s32 = 0
	local at: number = 0
	vm.section(function()
		event.set_save_flag(103, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.show_dungeon_status_bar(0, 1.0)
		event.load_map_sounds(1810)
		var3 = event.load_sound_effect_file_2(1810) or var3
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.clear_camera_sequence()
		event.load_message_file(0, 5, "event/e100/e103/e103.txt")
		event.load_character_motion_pack(5, "event/e100/e103/e103_mints.gltf", "info", 0)
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_sequence_position(0, 0.0, 50.0, 0.0)
		event.set_object_sequence_rotation(0, 0.0, 50.0, 0.0)
		event.attach_object_handle_to_character(5, 1)
		event.set_object_handle_visible(5, 0)
		event.attach_object_handle_to_character(6, 2)
		event.set_object_handle_visible(6, 0)
		event.load_character(5, "event/e100/e103/e103_polcurse.gltf", "info", 9)
		event.set_character_position(9, -4.99, 134.6, -43.13)
		event.set_character_active(0, 9)
		event.attach_object_handle_to_character(2, 9)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.set_object_sequence_position(2, 0.0, 50.0, 0.0)
		event.set_object_sequence_rotation(2, 0.0, 50.0, 0.0)
		event.load_character(5, "event/e100/e103/e103_erephant.gltf", "info", 8)
		event.set_character_position(8, 0.0, 50.0, 0.0)
		event.set_character_active(0, 8)
		event.attach_object_handle_to_character(1, 8)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_object_sequence_position(1, 0.0, 50.0, 0.0)
		event.set_object_sequence_rotation(1, 0.0, 50.0, 0.0)
		event.load_character(5, "event/helpreceiver/helpreceiver.gltf", "info", 10)
		event.set_character_active(0, 10)
		event.attach_character_to_frame(0, "ef00", 10)
		event.attach_object_handle_to_map_part_3(4, "p08_s06", "s06_08-m1")
		event.clear_object_sequence(4)
		event.set_object_sequence_object(4, 4)
		do
			local out1, out2, out3 = event.get_object_handle_position(4)
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		event.fade_out_screen(0)
		event.stop_music(0)
		at = 1
		helper_888ab2a3(4)
		event.load_music(107)
		event.set_object_handle_footstep_sound(0, 3)
		block = event.load_event_image_4(5, "textures/event/e100/e107/e107telop01.json", 0) or block
		event.reset_event_sprite(0)
		event.set_event_sprite_type(0, 0)
		event.set_event_sprite_texture(0, "e107telop01", block)
		event.set_event_sprite_texture_rect(0, 0, 0, 512, 128)
		event.set_event_sprite_size(0, 512, 128)
		event.set_event_sprite_position(0, 320, 334)
		event.set_event_sprite_color(0, 128, 128, 128, 0)
		event.set_event_sprite_scale(0, 1.0, 1.0)
		event.set_event_sprite_draw_pass(0, 0)
		event.attach_object_handle_to_sprite(10, 0)
		event.clear_object_sequence(10)
		event.set_object_sequence_object(10, 10)
		event.enable_drama_skip()
		event.set_character_active(1, 0)
		event.set_camera_sequence_position(150.75, 339.49, 988.43)
		event.set_camera_sequence_look_at(14.77, 282.74, 1151.7)
		event.set_object_sequence_position(0, 9.04, 262.0, 1196.55)
		event.set_object_sequence_rotation(0, 0.0, 3.14, 0.0)
		event.fade_in_screen(30)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "ポカーン顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "下見顔")
		event.set_object_sequence_texture_animation(2, 1, "目パチ")
		event.set_object_sequence_motion(0, "立ち", 4, -1.0, 1)
		event.move_object_sequence(4, 2.90684, 412.375, 1188.04, 30)
		at = 2
		wait_objects(4)
		event.set_object_sequence_motion(0, "歩き")
		event.delay_object_sequence_motion_track(0, 50)
		event.set_object_sequence_motion(0, "立ち")
		event.move_object_sequence(0, 13.2, 262.0, 1143.62, 50)
		at = 3
		wait_objects(0)
		event.play_sound_effect(var3, 27)
		event.jump_object_sequence(4, 2.90684, 312.375, 1188.04, -0.2, 10)
		event.jump_object_sequence(4, 2.90684, 312.375, 1188.04, -0.2, 8)
		event.jump_object_sequence(4, 2.90684, 312.375, 1188.04, -0.2, 5)
		at = 4
		helper_888ab2a3(40)
		event.set_camera_sequence_position(-23.49, 275.36, 1099.63)
		event.set_camera_sequence_look_at(-3.07, 281.91, 1122.03)
		event.set_object_sequence_position(0, -2.57, 262.0, 1128.46)
		event.set_object_sequence_rotation(0, 0.0, 3.14, 0.0)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 5
		helper_0382f327(1030010, 30)
		event.reset_mouth_texture_animations()
		event.open_voice_stream_wave(1, 1030015)
		at = 6
		helper_9cbdc640(1)
		event.play_voice_stream(1)
		event.set_object_sequence_motion(0, "上を見る", 6, 0.07, 1)
		event.delay_object_sequence_motion_track(0, 42)
		event.reset_object_sequence_motion(0)
		event.set_object_sequence_motion(0, "上を見るL", 0, -1.0)
		event.move_camera_sequence_eased(-104.82, 278.13, 1040.91, -24.27, 291.72, 1075.2, 90, 2, 0.4)
		at = 7
		wait_objects(0)
		event.close_voice_stream(1)
		at = 8
		wait_camera()
		event.set_camera_sequence_position(-2.2, 288.45, 1166.72)
		event.set_camera_sequence_look_at(-2.58, 285.44, 1130.54)
		event.set_object_sequence_motion(0, "歩き", 4, -1.0, 1)
		event.move_object_sequence(0, -2.98, 262.0, 1102.83, 60)
		event.move_camera_sequence_eased(-1.51, 288.45, 1196.6, -2.58, 285.44, 1130.54, 60, 2, 0.4)
		at = 9
		helper_888ab2a3(60)
		event.set_character_active(1, 10)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "無表情")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.move_object_sequence(0, -25.96, 262.0, 1001.65, 90)
		event.set_camera_sequence_follow_object(0, 0.0, 20.0, 0.0, 1.67, 0.85, 38.91)
		event.set_object_sequence_motion(0, "レシーバーを取り出す(歩き中)", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(0, "レシーバー歩き", 4)
		event.play_sound_effect(var3, 0)
		at = 10
		helper_8e5b8087(0, vm.f32(0.45), -1.0, 30)
		event.play_sound_effect(var3, 1)
		at = 11
		helper_888ab2a3(10)
		event.delay_object_sequence_motion_track(0, 50)
		event.set_object_sequence_motion(0, "レシーバー立ち", 0, -1.0, 1)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 12
		helper_4116e6bb(1030020)
		event.reset_mouth_texture_animations()
		at = 13
		wait_objects(0)
		event.release_camera_sequence_follow_object()
		event.set_camera_sequence_position(-25.76, 295.42, 1049.41)
		event.set_camera_sequence_look_at(-24.18, 286.8, 1002.8)
		at = 14
		helper_4116e6bb(1030030)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 15
		helper_4116e6bb(1030031)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 16
		helper_4116e6bb(1030040)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(0, "レシーバーをなおす", 2)
		event.wait_object_sequence_motion_end(0)
		at = 17
		helper_8e5b8087(0, vm.f32(0.275), -1.0, 30)
		event.play_sound_effect(var3, 2)
		at = 18
		helper_8e5b8087(0, vm.f32(0.6), -1.0, 30)
		event.play_sound_effect(var3, 3)
		at = 19
		wait_objects(0)
		event.detach_character_from_frame(10)
		event.set_camera_sequence_position(-8.24, 302.09, 593.73)
		event.set_camera_sequence_look_at(18.03, 282.04, 991.15)
		event.set_object_sequence_position(0, 18.03, 262.04, 991.15)
		event.set_object_sequence_motion(0, "走り", 4, -1.0, 1)
		event.clear_object_sequence_path(0)
		event.set_object_sequence_path_frames(0, 180)
		event.add_object_sequence_path_point(0, 18.03, 262.04, 991.15)
		event.add_object_sequence_path_point(0, 35.05, 262.04, 991.16)
		event.add_object_sequence_path_point(0, 63.63, 262.04, 998.35)
		event.add_object_sequence_path_point(0, 106.4, 262.04, 1000.0)
		event.add_object_sequence_path_point(0, 141.73, 262.04, 990.16)
		event.add_object_sequence_path_point(0, 155.42, 262.04, 953.13)
		event.add_object_sequence_path_point(0, 152.72, 262.04, 922.35)
		event.add_object_sequence_path_point(0, 131.69, 262.04, 909.25)
		event.add_object_sequence_path_point(0, 116.83, 262.04, 907.18)
		event.add_object_sequence_path_point(0, 65.0, 247.21, 908.16)
		event.add_object_sequence_path_point(0, -16.98, 216.58, 908.0)
		event.add_object_sequence_path_point(0, -72.6, 197.65, 908.51)
		event.add_object_sequence_path_point(0, -145.02, 171.37, 906.89)
		event.start_object_sequence_path(0)
		event.mark_camera_sequence_fade_track()
		event.delay_camera_sequence_fade_track(150)
		event.fade_out_camera_sequence(30, 0.0, 0.0, 0.0)
		at = 20
		vm.wait(20)
		var2 = 0
		while var2 < 180 do
			if var2 == 50 then
				event.set_object_handle_footstep_sound(0, 6)
			end
			do
				local out1, out2, out3 = event.get_character_position(0)
				var4 = out1 or var4
				var5 = out2 or var5
				var6 = out3 or var6
			end
			event.set_camera_sequence_look_at(var4, var5 + 20.0, var6)
			at = 21
			vm.wait(21)
			var2 = var2 + 1
		end
		event.set_object_handle_footstep_sound(0, 2)
		event.fade_in_screen(30)
		event.set_camera_sequence_position(-12.28, 87.78, 633.3)
		event.set_camera_sequence_look_at(-12.36, 76.05, 565.41)
		event.set_object_sequence_position(0, -12.17, 50.0, 540.63)
		event.set_object_sequence_rotation(0, 0.0, 3.14, 0.0)
		event.set_object_sequence_motion(0, "キョロキョロ歩き", 4, -1.0, 1)
		event.move_object_sequence(0, -12.27, 50.0, 462.63, 60)
		var2 = 0
		while var2 < 60 do
			do
				local out1, out2, out3 = event.get_character_position(0)
				var4 = out1 or var4
				var5 = out2 or var5
				var6 = out3 or var6
			end
			event.set_camera_sequence_look_at(var4, var5 + 20, var6)
			if var2 == 40 then
				event.play_sound_effect(var3, 4)
			end
			at = 22
			vm.wait(22)
			var2 = var2 + 1
		end
		event.set_camera_sequence_position(10.57, 80.17, 211.98)
		event.set_camera_sequence_look_at(-4.39, 74.32, 228.85)
		event.set_object_sequence_position(0, -5.05, 50.0, 232.5)
		event.set_object_sequence_rotation(0, 0.0, 3.14, 0.0)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "ポカーン顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_motion(0, "上を見る", 4, 0.07, 1)
		at = 23
		helper_888ab2a3(15)
		event.set_camera_sequence_position(-3.08, 61.16, 277.13)
		event.set_camera_sequence_look_at(-4.35, 72.53, 230.25)
		event.set_object_sequence_position(0, -5.05, 50.0, 232.5)
		event.set_object_sequence_rotation(0, 0.0, 3.14, 0.0)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "ポカーン顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目パチ")
		event.move_camera_sequence_eased(-3.08, 61.16, 277.13, -4.35, 103.53, 230.25, 30, 0, 0.2)
		at = 24
		helper_888ab2a3(36)
		event.set_character_active(1, 8)
		event.set_camera_sequence_position(-4.16, 185.18, 12.13)
		event.set_camera_sequence_look_at(-2.93, 793.4, -5.89)
		event.set_object_sequence_position(1, 0.0, 704.73, 0.0)
		event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(1, "落下中", 4)
		event.move_object_sequence(1, 0.0, 30.0, 0.0, 20)
		event.move_camera_sequence(-4.82, 50.61, 21.76, -2.93, 793.4, -5.89, 20)
		at = 25
		helper_888ab2a3(14)
		event.set_camera_sequence_position(28.38, 59.5, 119.0)
		event.set_camera_sequence_look_at(15.11, 66.61, 96.74)
		event.set_object_sequence_position(0, -3.97, 50.0, 82.73)
		event.set_object_sequence_rotation(0, 0.0, -3.14, 0.0)
		event.set_object_sequence_position(1, 0.0, 95.0, 0.0)
		event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
		event.move_object_sequence(1, 0.0, 50.0, 0.0, 6)
		event.set_object_sequence_motion(0, "象着地", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(0, "象着地L")
		event.set_object_sequence_motion(1, "着地", 6)
		event.delay_camera_sequence_shake_track(6)
		event.shake_camera_sequence(0.0, 1.5, 0.0, 24)
		at = 26
		helper_888ab2a3(6)
		event.play_music(0)
		at = 27
		helper_888ab2a3(48)
		event.set_camera_sequence_position(8.34, 76.37, 68.31)
		event.set_camera_sequence_look_at(-3.92, 73.89, 83.97)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "びっくり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目パチ")
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 28
		helper_4116e6bb(1030050)
		event.reset_mouth_texture_animations()
		event.set_camera_sequence_position(8.61, 67.77, 124.88)
		event.set_camera_sequence_look_at(1.17, 71.56, 84.8)
		event.set_object_sequence_rotation(0, 0.0, 2.9, 0.0)
		event.move_camera_sequence_eased(8.61, 67.77, 124.88, 1.17, 77.23, 84.8, 44, 2, 0.4)
		event.set_object_sequence_motion(1, "パオーン", 6)
		event.queue_object_sequence_next_motion(1, "立ち", 0)
		at = 29
		helper_888ab2a3(15)
		event.play_sound_effect(var3, 5)
		at = 30
		helper_888ab2a3(37)
		event.shake_camera_sequence(0.0, 1.3, 0.0, 24)
		at = 31
		helper_888ab2a3(42)
		event.set_character_active(1, 9)
		event.set_camera_sequence_position(91.06, 185.9, -66.26)
		event.set_camera_sequence_look_at(-6.23, 91.91, 17.07)
		event.set_object_sequence_position(0, -6.67, 50.0, 84.81)
		event.set_object_sequence_rotation(0, 0.0, 2.9, 0.0)
		event.set_object_sequence_position(2, -4.73, 162.38, -24.57)
		event.set_object_sequence_rotation(2, 0.0, -0.12, 0.0)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目パチ")
		event.set_object_sequence_motion(2, "浮遊", 4)
		event.move_object_sequence_eased(2, -4.73, 106.52, -24.57, 60, 2, 0.3)
		event.play_sound_effect(var3, 6)
		at = 32
		wait_objects(2)
		event.set_object_sequence_rotation(0, 0.0, 3.02, 0.0)
		event.set_camera_sequence_position(19.38, 59.94, 120.28)
		event.set_camera_sequence_look_at(1.66, 79.89, 71.18)
		event.set_object_sequence_position(2, 11.92, 134.55, -43.71)
		event.set_object_sequence_rotation(2, 0.0, -0.24, 0.0)
		event.set_object_sequence_motion(0, "上を見るL", 6, -1.0, 1)
		event.set_mouth_texture_animations(2, "口パク1")
		at = 33
		helper_4116e6bb(1030060)
		event.reset_mouth_texture_animations()
		event.set_camera_sequence_position(-5.96, 89.53, 73.98)
		event.set_camera_sequence_look_at(-6.81, 73.86, 87.67)
		event.set_object_sequence_motion(0, "ポルカスを見る", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(0, "ポルカスを見るL")
		event.play_sound_effect(var3, 7)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 34
		helper_4116e6bb(1030070)
		event.reset_mouth_texture_animations()
		event.set_camera_sequence_position(8.07, 126.01, 28.15)
		event.set_camera_sequence_look_at(8.5, 154.76, -34.87)
		at = 35
		helper_888ab2a3(15)
		event.set_mouth_texture_animations(2, "口パク1")
		at = 36
		helper_4116e6bb(1030080)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(2, "口パク1")
		at = 37
		helper_4116e6bb(1030081)
		event.reset_mouth_texture_animations()
		event.set_camera_sequence_position(16.03, 156.16, -10.64)
		event.set_camera_sequence_look_at(10.22, 165.33, -37.84)
		event.set_mouth_texture_animations(2, "口パク1")
		at = 38
		helper_4116e6bb(1030090)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(2, "口パク1")
		at = 39
		helper_4116e6bb(1030100)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(2, "口パク1")
		at = 40
		helper_4116e6bb(1030101)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_texture_animation(2, 1, "目とじ")
		event.set_object_sequence_motion(2, "うつむく", 6)
		event.queue_object_sequence_next_motion(2, "うつむくL", 0)
		at = 41
		helper_888ab2a3(9)
		event.set_mouth_texture_animations(2, "口パク1")
		at = 42
		helper_4116e6bb(1030110)
		event.reset_mouth_texture_animations()
		event.set_camera_sequence_position(-5.1, 89.1, 58.36)
		event.set_camera_sequence_look_at(-6.56, 75.02, 78.7)
		event.play_sound_effect(var3, 8)
		event.set_object_sequence_motion(0, "なんだって！", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(0, "なんだって！L", 0)
		at = 43
		helper_888ab2a3(10)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 44
		helper_4116e6bb(1030120)
		event.reset_mouth_texture_animations()
		event.set_camera_sequence_position(4.77, 158.81, -12.71)
		event.set_camera_sequence_look_at(14.01, 169.3, -54.18)
		event.set_object_sequence_texture_animation(2, 1, "目こらし")
		event.set_object_sequence_motion(2, "ウフフフ", 4)
		event.set_mouth_texture_animations(2, "口パク1")
		at = 45
		helper_4116e6bb(1030130)
		event.reset_mouth_texture_animations()
		event.set_camera_sequence_position(30.18, 182.63, -12.61)
		event.set_camera_sequence_look_at(-15.36, 101.5, 68.2)
		event.set_object_sequence_position(0, -6.39, 50.0, 102.82)
		event.set_object_sequence_rotation(0, 0.0, 3.14, 0.0)
		event.set_object_sequence_position(2, -1.72, 117.17, 22.1)
		event.set_object_sequence_rotation(2, 0.0, 0.12, 0.0)
		event.set_object_sequence_motion(2, "浮遊", 4)
		event.play_sound_effect(var3, 9)
		event.set_mouth_texture_animations(2, "口パク1")
		at = 46
		helper_4116e6bb(1030140)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_rotation(0, 0.0, 3.02, 0.0)
		event.set_object_sequence_position(2, 3.77, 134.08, 27.37)
		event.set_object_sequence_rotation(2, 0.0, -0.12, 0.0)
		event.set_camera_sequence_position(9.35, 66.39, 80.83)
		event.set_camera_sequence_look_at(-6.04, 71.48, 99.69)
		event.set_object_sequence_motion(0, "考える", 6)
		event.queue_object_sequence_next_motion(0, "考えるL", 0)
		at = 47
		helper_888ab2a3(15)
		at = 48
		helper_4116e6bb(1030150)
		event.set_camera_sequence_position(1.44, 167.15, 61.09)
		event.set_camera_sequence_look_at(3.34, 165.04, 30.8)
		event.set_object_sequence_motion(2, "腹を突き出す", 4)
		event.delay_object_sequence_motion_track(2, 40)
		event.set_object_sequence_motion(2, "浮遊", 4)
		event.set_mouth_texture_animations(2, "口パク1")
		at = 49
		helper_4116e6bb(1030160)
		event.reset_mouth_texture_animations()
		event.set_camera_sequence_position(-21.79, 178.71, -1.18)
		event.set_camera_sequence_look_at(0.55, 132.61, 42.24)
		event.set_object_sequence_position(2, 2.65, 122.38, 24.68)
		event.set_object_sequence_rotation(2, 0.0, -0.36, 0.0)
		event.play_sound_effect(var3, 10)
		event.set_object_sequence_motion(0, "おことわりだよ", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(0, "おことわりだよL", 0)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 50
		helper_4116e6bb(1030170)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_position(2, 3.77, 134.08, 27.37)
		event.set_object_sequence_rotation(2, 0.0, -0.12, 0.0)
		event.set_camera_sequence_position(-13.53, 78.7, 80.84)
		event.set_camera_sequence_look_at(-6.17, 72.32, 101.95)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 51
		helper_4116e6bb(1030180)
		event.reset_mouth_texture_animations()
		event.set_camera_sequence_position(1.35, 150.19, 59.87)
		event.set_camera_sequence_look_at(3.64, 164.72, 27.05)
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "おこり顔")
		event.set_object_sequence_texture_animation(2, 1, "おこり目パチ")
		event.set_object_sequence_motion(2, "プルプル", 4)
		event.set_mouth_texture_animations(2, "おこり口パク")
		at = 52
		helper_4116e6bb(1030190)
		event.reset_mouth_texture_animations()
		event.set_object_handle_visible(5, 1)
		event.set_object_handle_visible(6, 1)
		at = 53
		helper_42529d71(var3)
		at = 54
		helper_517ab114(var3)
		event.set_object_sequence_color(10, 128.0, 128.0, 128.0, 0.0, 15)
		event.fade_out_screen(30)
		at = 55
		helper_888ab2a3(30)
	end, function(received: { any }): boolean
		if at <= 1 then
			helper_238b5abc(4)
		end
		if at <= 2 then
			helper_238b5abc(0)
		end
		if at <= 3 then
			helper_038a2e4d(40)
		end
		if at <= 4 then
			helper_53ffe901(1030010, 30)
		end
		if at <= 5 then
			helper_238b5abc(1)
		end
		if at <= 6 then
			helper_238b5abc(0)
		end
		if at <= 7 then
			helper_344d6cd8()
		end
		if at <= 8 then
			helper_038a2e4d(60)
		end
		if at <= 9 then
			helper_048ef29b(0, vm.f32(0.45), -1.0, 30)
		end
		if at <= 10 then
			helper_038a2e4d(10)
		end
		if at <= 11 then
			helper_8cd371d7(1030020)
		end
		if at <= 12 then
			helper_238b5abc(0)
		end
		if at <= 13 then
			helper_8cd371d7(1030030)
		end
		if at <= 14 then
			helper_8cd371d7(1030031)
		end
		if at <= 15 then
			helper_8cd371d7(1030040)
		end
		if at <= 16 then
			helper_048ef29b(0, vm.f32(0.275), -1.0, 30)
		end
		if at <= 17 then
			helper_048ef29b(0, vm.f32(0.6), -1.0, 30)
		end
		if at <= 18 then
			helper_238b5abc(0)
		end
		if at <= 20 then
			var2 = 0
		end
		if at <= 21 then
			local _ = var2 < 180
			local _ = var2 == 50
			var2 = var2 + 1
			var2 = 0
		end
		if at <= 22 then
			local _ = var2 < 60
			local _ = var2 == 40
			var2 = var2 + 1
			helper_038a2e4d(15)
		end
		if at <= 23 then
			helper_038a2e4d(36)
		end
		if at <= 24 then
			helper_038a2e4d(14)
		end
		if at <= 25 then
			helper_038a2e4d(6)
		end
		if at <= 26 then
			helper_038a2e4d(48)
		end
		if at <= 27 then
			helper_8cd371d7(1030050)
		end
		if at <= 28 then
			helper_038a2e4d(15)
		end
		if at <= 29 then
			helper_038a2e4d(37)
		end
		if at <= 30 then
			helper_038a2e4d(42)
		end
		if at <= 31 then
			helper_238b5abc(2)
		end
		if at <= 32 then
			helper_8cd371d7(1030060)
		end
		if at <= 33 then
			helper_8cd371d7(1030070)
		end
		if at <= 34 then
			helper_038a2e4d(15)
		end
		if at <= 35 then
			helper_8cd371d7(1030080)
		end
		if at <= 36 then
			helper_8cd371d7(1030081)
		end
		if at <= 37 then
			helper_8cd371d7(1030090)
		end
		if at <= 38 then
			helper_8cd371d7(1030100)
		end
		if at <= 39 then
			helper_8cd371d7(1030101)
		end
		if at <= 40 then
			helper_038a2e4d(9)
		end
		if at <= 41 then
			helper_8cd371d7(1030110)
		end
		if at <= 42 then
			helper_038a2e4d(10)
		end
		if at <= 43 then
			helper_8cd371d7(1030120)
		end
		if at <= 44 then
			helper_8cd371d7(1030130)
		end
		if at <= 45 then
			helper_8cd371d7(1030140)
		end
		if at <= 46 then
			helper_038a2e4d(15)
		end
		if at <= 47 then
			helper_8cd371d7(1030150)
		end
		if at <= 48 then
			helper_8cd371d7(1030160)
		end
		if at <= 49 then
			helper_8cd371d7(1030170)
		end
		if at <= 50 then
			helper_8cd371d7(1030180)
		end
		if at <= 51 then
			helper_8cd371d7(1030190)
		end
		if at <= 52 then
			helper_4027021e(var3)
		end
		if at <= 53 then
			helper_8a8cc5be(var3)
		end
		if at <= 54 then
			helper_038a2e4d(30)
		end
		return true
	end)
	event.cancel_drama_scene_skip()
	event.reset_dungeon_timer()
	event.set_object_handle_footstep_sound(0, 0)
	event.attach_object_handle_to_map_part_3(4, "p08_s06", "s06_08-m1")
	event.clear_object_sequence(4)
	event.set_object_sequence_object(4, 4)
	event.set_object_sequence_position(4, pos_x, pos_y, pos_z)
	at = 56
	vm.wait(56)
	event.attach_object_handle_to_character(5, 1)
	event.set_object_handle_visible(5, 1)
	event.attach_object_handle_to_character(6, 2)
	event.set_object_handle_visible(6, 1)
	event.delete_character_extension_packs(0)
	event.delete_character(9)
	event.delete_character(8)
	event.delete_character(10)
	event.stop_music(0)
	at = 57
	helper_888ab2a3(4)
	event.load_music(195)
	event.play_music(0)
	event.fade_in_screen(15)
	event.set_camera_position(-1.66, 76.3, 205.77)
	event.set_camera_look_at(-0.37, 74.98, 151.36)
	event.set_character_position(0, 0.0, 50.0, 138.0)
	event.set_character_rotation(0, 0.0, 3.02, 0.0)
	event.reset_follow_camera(0)
	event.set_event_sprite_draw_pass(0, 0)
	event.delete_event_image(0)
	event.show_dungeon_status_bar(1)
	event.place_dungeon_monster(614, 0.0, 50.0, 0.0, 0.0, 0.0, 0.0)
	event.finish_event()
end

return helper_ceda7a53
