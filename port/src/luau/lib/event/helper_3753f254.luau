--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0382f327 = require("@lib/event/helper_0382f327")
local helper_038a2e4d = require("@lib/event/helper_038a2e4d")
local helper_238b5abc = require("@lib/event/helper_238b5abc")
local helper_2f9e90af = require("@lib/event/helper_2f9e90af")
local helper_344d6cd8 = require("@lib/event/helper_344d6cd8")
local helper_4116e6bb = require("@lib/event/helper_4116e6bb")
local helper_46754465 = require("@lib/event/helper_46754465")
local helper_53ffe901 = require("@lib/event/helper_53ffe901")
local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")
local helper_8cd371d7 = require("@lib/event/helper_8cd371d7")
local helper_b581d4ec = require("@lib/event/helper_b581d4ec")
local helper_d9e95704 = require("@lib/event/helper_d9e95704")
local wait_camera = require("@lib/event/wait_camera")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_3753f254()
	local projection: f32 = 0
	local projection_2: f32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local var5: s32 = 0
	local var6: f32 = 0
	local projection_3: f32 = 0
	local var9: s32 = 0
	local var10: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local at: number = 0
	vm.section(function()
		at = 1
		vm.entry(1)
		event.set_save_flag(104, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.show_dungeon_status_bar(0, 1.0)
		var4 = event.load_sound_effect_file_3(4, 1813) or var4
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		projection = event.get_event_projection() or projection
		event.load_character_motion_pack(5, "event/e100/e104/e104_mints.gltf", "info", 0)
		event.set_character_active(1, 0)
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.load_character(5, "event/e100/e104/e104_ste_sta.gltf", "info", 8)
		event.set_character_active(0, 8)
		event.attach_object_handle_to_character(1, 8)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_object_handle_sound_bank(1, var4)
		event.load_character(5, "event/e100/e104/e104_erephant.gltf", "info", 9)
		event.set_character_active(0, 9)
		event.attach_object_handle_to_character(2, 9)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.set_object_handle_sound_bank(2, var4)
		event.load_character(5, "event/e100/e104/e104_polcurse.gltf", "info", 10)
		event.set_character_active(0, 10)
		event.attach_object_handle_to_character(3, 10)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.load_character(5, "event/e100/e104/e104_iwa.gltf", "info", 11)
		event.set_character_active(0, 11)
		event.attach_object_handle_to_character(4, 11)
		event.clear_object_sequence(4)
		event.set_object_sequence_object(4, 4)
		event.load_character(5, "event/e100/e104/e104_iwakudake.gltf", "info", 12)
		event.set_character_active(0, 12)
		event.attach_object_handle_to_character(7, 12)
		event.clear_object_sequence(7)
		event.set_object_sequence_object(7, 7)
		event.set_object_sequence_position(7, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(7, 0.0, 0.0, 0.0)
		event.load_character(5, "event/e100/e104/e104_naguru.gltf", "info", 14)
		event.set_character_active(0, 14)
		event.attach_object_handle_to_character(8, 14)
		event.clear_object_sequence(8)
		event.set_object_sequence_object(8, 8)
		event.set_object_sequence_position(8, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(8, 0.0, 0.0, 0.0)
		event.load_character(5, "event/e100/e104/e104_naguru_hyaku.gltf", "info", 15)
		event.set_character_active(0, 15)
		event.attach_object_handle_to_character(9, 15)
		event.clear_object_sequence(9)
		event.set_object_sequence_object(9, 9)
		event.set_object_sequence_position(9, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(9, 0.0, 0.0, 0.0)
		event.load_character(5, "event/e100/e104/e104_naguru_upper.gltf", "info", 16)
		event.set_character_active(0, 16)
		event.attach_object_handle_to_character(10, 16)
		event.clear_object_sequence(10)
		event.set_object_sequence_object(10, 10)
		event.set_object_sequence_position(10, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(10, 0.0, 0.0, 0.0)
		event.load_character(5, "event/e100/e104/e104_smoke.gltf", "info", 17)
		event.set_character_active(0, 17)
		event.attach_object_handle_to_character(11, 17)
		event.clear_object_sequence(11)
		event.set_object_sequence_object(11, 11)
		event.set_object_sequence_position(11, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(11, 0.0, 0.0, 0.0)
		event.load_character(5, "event/e100/e104/e104_overheat.gltf", "info", 18)
		event.set_character_active(0, 18)
		event.attach_object_handle_to_character(12, 18)
		event.clear_object_sequence(12)
		event.set_object_sequence_object(12, 12)
		event.set_object_sequence_position(12, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(12, 0.0, 0.0, 0.0)
		event.set_object_handle_sound_bank(3, var4)
		event.load_message_file(0, 5, "event/e100/e104/e104.txt")
		event.initialize_effect_manager(5, 1)
		event.load_effect_base("e110ポル回転キラ")
		event.create_effect_work_buffer(5)
		event.stop_music(0)
		at = 2
		helper_888ab2a3(4)
		event.load_music(193)
		event.set_scene_status_flags(1, 0, 256, 1)
		event.enable_drama_skip()
		event.set_character_active(1, 0)
		event.set_object_handle_visible(0, 1)
		event.attach_object_handle_to_character(10, 1)
		event.attach_object_handle_to_character(11, 2)
		event.attach_object_handle_to_character(12, 3)
		event.set_object_handle_visible(10, 1)
		event.set_object_handle_visible(11, 1)
		event.set_object_handle_visible(12, 1)
		event.set_camera_sequence_position(-20.33, 70.25, 59.65)
		event.set_camera_sequence_look_at(102.39, 53.16, 234.79)
		event.set_object_sequence_position(0, 1.77, 50.0, 89.12)
		event.set_object_sequence_rotation(0, 0.0, -3.0, 0.0)
		event.fade_in_screen(30)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目パチ")
		event.set_object_sequence_motion(0, "だめだL", 4, -1.0, 1)
		at = 3
		helper_888ab2a3(15)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 4
		helper_4116e6bb(1040010)
		event.reset_mouth_texture_animations()
		event.set_character_active(1, 9)
		event.set_camera_sequence_position(2.83, 72.97, 182.21)
		event.set_camera_sequence_look_at(1.93, 81.57, -215.48)
		event.set_object_sequence_position(2, 3.65, 50.0, -40.62)
		event.set_object_sequence_rotation(2, 0.0, -0.03, 0.0)
		event.set_object_sequence_scale(2, 1.2, 1.2, 1.2)
		projection_2 = event.get_event_projection() or projection_2
		event.set_object_sequence_motion(2, "歩き")
		at = 5
		vm.wait(5)
		var10 = 40
		var9 = 1
		var6 = vm.f32(vm.fdiv(vm.f32(vm.f32(867.9) - projection_2), var10))
		while var9 < var10 do
			projection_3 = vm.f32(var6 * var9)
			projection_3 = vm.f32(projection_2 + projection_3)
			event.set_event_projection(projection_3)
			at = 6
			vm.wait(6)
			var9 = var9 + 1
		end
		event.set_event_projection(projection_2)
		event.set_character_active(1, 10)
		event.set_camera_sequence_position(62.56, 161.62, 59.5)
		event.set_camera_sequence_look_at(3.61, 179.88, 37.58)
		event.set_object_sequence_position(3, 1.97, 159.88, 33.85)
		event.set_object_sequence_rotation(3, 0.0, 0.04, 0.0)
		event.set_object_sequence_motion(2, "立ち", 4)
		event.set_object_sequence_texture_animation(3, 0)
		event.set_object_sequence_texture_animation(3, 1, "おこりわらい顔")
		event.set_object_sequence_texture_animation(3, 1, "おこり目パチ")
		event.set_object_sequence_motion(3, "浮遊", 4, -1.0, 1)
		at = 7
		helper_888ab2a3(15)
		event.set_mouth_texture_animations(3, "わらい口パク")
		at = 8
		helper_4116e6bb(1040020)
		event.reset_mouth_texture_animations()
		event.set_camera_sequence_position(15.68, 76.92, 110.24)
		event.set_camera_sequence_look_at(5.46, 70.74, 129.29)
		event.set_object_sequence_position(0, 6.33, 49.45, 128.85)
		event.set_object_sequence_rotation(0, 0.0, 2.44, 0.0)
		event.set_object_sequence_texture_animation(0, 1, "くいしばり")
		event.set_object_sequence_motion(0, "だめだL", 4, -1.0, 1)
		at = 9
		helper_888ab2a3(15)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 10
		helper_4116e6bb(1040030)
		event.reset_mouth_texture_animations()
		event.set_camera_sequence_position(-97.35, 80.94, 117.92)
		event.set_camera_sequence_look_at(-40.6, 80.11, 79.05)
		event.set_object_sequence_position(0, 4.49, 50.0, 81.42)
		event.set_object_sequence_rotation(0, 0.0, 2.89, 0.0)
		event.set_object_sequence_position(2, -5.42, 50.0, -60.99)
		event.set_object_sequence_scale(2, 1.2, 1.2, 1.2)
		event.set_object_sequence_motion(0, "だめだL", 4, -1.0, 1)
		event.set_object_sequence_motion(2, "歩き", 4, -1.0, 1)
		event.move_object_sequence(2, -0.37, 50.0, -5.7, 50)
		event.rotate_object_sequence(2, 0.0, -0.03, 0.0, 20)
		at = 11
		helper_46754465(50, var5)
		event.set_character_active(0, 9)
		event.set_camera_sequence_position(15.68, 76.92, 110.24)
		event.set_camera_sequence_look_at(5.46, 70.74, 129.29)
		event.set_object_sequence_position(0, 6.33, 49.45, 128.85)
		event.set_object_sequence_rotation(0, 0.0, 2.44, 0.0)
		event.set_object_sequence_texture_animation(0, 1, "くいしばり")
		event.set_object_sequence_motion(0, "だめだL", 4, -1.0, 1)
		at = 12
		helper_888ab2a3(15)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 13
		helper_4116e6bb(1040040)
		event.reset_mouth_texture_animations()
		event.set_character_active(1, 9)
		event.set_camera_sequence_position(2.83, 72.48, 182.21)
		event.set_camera_sequence_look_at(1.93, 128.72, -215.48)
		event.set_object_sequence_position(0, 3.24, 50.0, 118.73)
		event.set_object_sequence_rotation(0, 0.0, -3.0, 0.0)
		event.set_object_sequence_position(2, 3.84, 50.0, 41.34)
		event.set_object_sequence_motion(0, "だめだL", 4, -1.0, 1)
		event.set_object_sequence_motion(2, "立ち", 4)
		event.set_object_sequence_motion(2, "ふりかぶる", 6)
		event.wait_object_sequence_motion_end(2)
		event.play_sound_effect(var4, 1)
		at = 14
		wait_objects(2)
		event.set_character_active(1, 12)
		event.set_character_active(1, 11)
		event.set_object_sequence_position(4, -61.22, 96.72, 70.37)
		event.set_object_sequence_rotation(4, 0.0, 0.0, 0.0)
		event.set_object_sequence_position(7, -61.22, 96.72, 70.37)
		event.set_object_sequence_rotation(7, 0.0, 1.72, 0.0)
		event.set_object_sequence_motion(7, "岩", 4)
		event.set_character_active(0, 11)
		event.jump_object_sequence(7, -17.07, 99.51, 70.08, -0.4, 3)
		at = 15
		wait_objects(7)
		event.set_object_sequence_motion(2, "岩があたる", 6)
		event.wait_object_sequence_motion_end(2)
		event.play_sound_effect(var4, 2)
		event.set_object_sequence_motion(7, "砕ける岩", 0)
		at = 16
		helper_888ab2a3(28)
		event.set_character_active(0, 12)
		at = 17
		wait_objects(2)
		event.set_object_sequence_position(0, 2.81, 50.0, 110.3)
		event.set_object_sequence_rotation(0, 0.0, -3.0, 0.0)
		event.set_character_active(0, 9)
		event.set_camera_sequence_position(-17.42, 72.3, 95.02)
		event.set_camera_sequence_look_at(8.94, 73.07, 115.98)
		event.set_character_texture_animation(0, 0, "怒り目")
		event.set_character_texture_animation(0, 0, "怒り口")
		event.set_object_sequence_texture_animation(0, 1, "振り向き顔")
		event.set_object_sequence_motion(0, "左を見る", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(0, "左を見るL")
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 18
		helper_0382f327(1040050, 12)
		event.reset_mouth_texture_animations()
		event.set_camera_sequence_position(-36.29, 169.1, 79.75)
		event.set_camera_sequence_look_at(1.07, 187.01, 33.65)
		event.set_object_sequence_texture_animation(3, 1, "おどろき口")
		event.play_sound_effect(var4, 3)
		event.set_object_sequence_motion(3, "驚く", 6)
		event.queue_object_sequence_next_motion(3, "驚くL")
		event.set_mouth_texture_animations(3, "わらい口パク")
		at = 19
		helper_0382f327(1040060, 25)
		event.reset_mouth_texture_animations()
		event.set_character_active(1, 8)
		event.set_camera_sequence_position(-472.64, 157.68, -14.51)
		event.set_camera_sequence_look_at(-374.9, 159.09, -138.37)
		event.set_object_sequence_position(1, -698.91, 120.39, -1.62)
		event.set_object_sequence_rotation(1, 0.0, 1.6, 0.0)
		event.set_object_sequence_scale(1, 1.2, 1.2, 1.2)
		event.play_music(1)
		event.move_camera_sequence(-489.82, 157.68, 2.84, -669.99, 159.09, 0.82, 14)
		event.set_object_sequence_motion(1, "岩抱えL", 4)
		at = 20
		wait_camera()
		at = 21
		helper_888ab2a3(30)
		event.set_camera_sequence_position(-649.06, 178.83, 1.06)
		event.set_camera_sequence_look_at(-739.64, 160.75, -2.5)
		event.play_sound_effect(var4, 4)
		event.set_mouth_texture_animations(1, "口パク")
		at = 22
		helper_4116e6bb(1040070)
		event.reset_mouth_texture_animations()
		event.set_character_active(0, 9)
		event.set_camera_sequence_position(-16.05, 82.67, 94.68)
		event.set_camera_sequence_look_at(0.78, 74.43, 106.59)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.play_sound_effect(var4, 5)
		event.attach_object_handle_to_character(5, 1)
		event.set_object_handle_visible(5, 0)
		event.attach_object_handle_to_character(6, 2)
		event.set_object_handle_visible(6, 0)
		event.set_object_sequence_motion(0, "すごいよ", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(0, "すごいよL")
		at = 23
		helper_888ab2a3(3)
		event.set_mouth_texture_animations(0, "わらい口パク")
		at = 24
		helper_4116e6bb(1040080)
		event.reset_mouth_texture_animations()
		event.set_character_active(1, 9)
		event.set_camera_sequence_position(-595.13, 165.27, -0.58)
		event.set_camera_sequence_look_at(-680.32, 162.11, -0.34)
		event.set_object_sequence_motion(1, "構え", 4)
		event.set_mouth_texture_animations(1, "口パク")
		at = 25
		helper_4116e6bb(1040090)
		event.reset_mouth_texture_animations()
		event.stop_sound_effect(var4, 4)
		event.play_sound_effect(var4, 6)
		event.set_camera_sequence_position(-487.31, 136.74, -141.75)
		event.set_camera_sequence_look_at(-782.31, 197.24, 86.51)
		event.set_object_sequence_motion(1, "ジャンプ", 6, 0.4)
		event.queue_object_sequence_next_motion(1, "ジャンプL")
		at = 26
		helper_888ab2a3(3)
		event.jump_object_sequence(1, -410.14, 169.27, 125.29, -0.35, 33)
		var3 = 1
		while var3 < 33 do
			do
				local out1, out2, out3 = event.get_object_handle_position(1)
				pos_x = out1 or pos_x
				pos_y = out2 or pos_y
				pos_z = out3 or pos_z
			end
			event.set_camera_sequence_look_at(pos_x, pos_y + 60.0, pos_z)
			at = 27
			vm.wait(27)
			var3 = var3 + 1
		end
		event.set_character_active(1, 9)
		event.clear_camera_sequence()
		event.set_character_active(0, 0)
		event.set_character_active(0, 10)
		event.set_camera_sequence_position(123.01, 102.6, 37.52)
		event.set_camera_sequence_look_at(-195.66, 44.82, 141.63)
		event.set_object_sequence_position(1, 73.03, 63.16, 18.93)
		event.set_object_sequence_rotation(1, 0.0, -0.56, 0.0)
		event.set_object_sequence_position(2, -8.8, 50.0, 120.29)
		event.set_object_sequence_rotation(2, 0.0, 3.13, 0.0)
		event.set_object_sequence_scale(2, 1.2, 1.2, 1.2)
		event.set_object_sequence_position(1, 3.84, 50.0, 41.34)
		event.set_object_sequence_rotation(1, 0.0, -0.03, 0.0)
		event.set_object_sequence_position(2, 3.84, 50.0, 41.34)
		event.set_object_sequence_rotation(2, 0.0, -0.03, 0.0)
		event.set_character_active(1, 14)
		event.set_object_sequence_position(8, 73.03, 63.16, 18.93)
		event.set_object_sequence_rotation(8, 0.0, -0.56, 0.0)
		event.set_object_sequence_motion(8, "エフェクト_殴る", 6)
		event.set_object_sequence_motion(1, "殴る", 6)
		event.set_object_sequence_motion(2, "殴る", 6)
		event.wait_object_sequence_motion_end(1)
		event.wait_object_sequence_motion_end(2)
		event.play_sound_effect(var4, 7)
		event.play_sound_effect(var4, 8)
		at = 28
		wait_objects(1)
		at = 29
		wait_objects(2)
		event.set_character_active(0, 14)
		event.set_character_active(1, 8)
		event.set_character_active(1, 9)
		event.set_camera_sequence_position(-96.23, 106.65, 44.67)
		event.set_camera_sequence_look_at(-84.09, 104.44, 47.57)
		event.set_object_sequence_position(1, 3.84, 50.0, 41.34)
		event.set_object_sequence_rotation(1, 0.0, -0.03, 0.0)
		event.set_object_sequence_position(2, 3.84, 50.0, 41.34)
		event.set_object_sequence_rotation(2, 0.0, -0.03, 0.0)
		event.set_object_sequence_scale(2, 1.0, 1.0, 1.0)
		event.set_character_active(1, 15)
		event.set_object_sequence_position(9, 3.84, 50.0, 41.34)
		event.set_object_sequence_rotation(9, 0.0, -0.03, 0.0)
		event.set_object_sequence_motion(9, "エフェクト_百烈拳", 6)
		event.set_object_sequence_motion(1, "百烈拳", 6)
		event.set_object_sequence_motion(2, "百烈拳", 6)
		event.queue_object_sequence_next_motion(1, "アッパー", 6)
		event.queue_object_sequence_next_motion(2, "アッパー", 6)
		event.wait_object_sequence_motion_end(1)
		event.wait_object_sequence_motion_end(2)
		event.delay_camera_sequence_position_track(50)
		event.set_camera_sequence_position(-84.59, 72.69, -23.68)
		event.set_camera_sequence_look_at(65.91, 125.55, 145.6)
		event.delay_camera_sequence_position_track(49)
		event.set_camera_sequence_position(49.52, 88.47, 17.44)
		event.set_camera_sequence_look_at(1.9, 49.55, 248.07)
		var3 = 0
		while var3 < 75 do
			at = 30
			vm.wait(30)
			if var3 < 55 then
				if vm.imod(var3, 4) == 0 then
					event.play_sound_effect(var4, 7)
					event.play_sound_effect(var4, 8)
				end
			end
			if var3 == 57 then
				event.play_sound_effect(var4, 9)
			end
			var3 = var3 + 1
		end
		event.set_character_active(0, 15)
		event.set_character_active(1, 16)
		event.set_character_position(16, 3.84, 50.0, 41.34)
		event.set_character_rotation(16, 0.0, -0.03, 0.0)
		event.set_character_motion(16, "エフェクト_アッパー", 6)
		at = 31
		wait_objects(1)
		at = 32
		wait_objects(2)
		at = 33
		wait_camera()
		event.set_character_active(0, 16)
		event.set_object_sequence_scale(2, 1.2, 1.2, 1.2)
		event.set_character_active(1, 8)
		event.set_character_active(0, 9)
		event.set_camera_sequence_position(2.43, 89.98, -21.91)
		event.set_camera_sequence_look_at(3.78, 84.72, 87.51)
		event.set_object_sequence_position(1, 2.05, 50.0, 102.48)
		event.set_object_sequence_rotation(1, 0.0, 3.13, 0.0)
		event.set_character_active(1, 17)
		event.set_object_sequence_position(11, 2.05, 50.0, 102.48)
		event.set_character_position(17, 2.05, 50.0, 102.48)
		event.set_character_rotation(17, 0.0, 3.13, 0.0)
		event.set_object_sequence_motion(11, "エフェクト_湯気", 4)
		event.set_object_sequence_motion(1, "どうじゃ！", 4)
		at = 34
		helper_888ab2a3(15)
		event.play_sound_effect(var4, 10)
		event.set_mouth_texture_animations(1, "口パク")
		at = 35
		helper_4116e6bb(1040100)
		event.reset_mouth_texture_animations()
		event.set_character_active(0, 17)
		event.set_character_active(1, 0)
		event.set_camera_sequence_position(-45.51, 69.87, 128.53)
		event.set_camera_sequence_look_at(-45.74, 88.49, 287.42)
		event.set_object_sequence_position(0, -45.61, 50.0, 154.61)
		event.set_object_sequence_rotation(0, 0.0, 2.53, 0.0)
		event.stop_sound_effect(var4, 10)
		event.play_sound_effect(var4, 11)
		event.set_object_sequence_motion(0, "すごいよ", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(0, "すごいよL")
		at = 36
		helper_888ab2a3(3)
		event.set_mouth_texture_animations(0, "わらい口パク")
		at = 37
		helper_4116e6bb(1040110)
		event.reset_mouth_texture_animations()
		event.set_character_active(1, 10)
		event.set_camera_sequence_position(2.48, 180.08, 53.9)
		event.set_camera_sequence_look_at(-2.43, 189.74, -146.57)
		event.set_object_sequence_position(3, -6.54, 165.12, -24.91)
		event.set_object_sequence_rotation(3, 0.0, 0.37, 0.0)
		event.set_object_sequence_texture_animation(3, 0)
		event.set_object_sequence_texture_animation(3, 1, "わらい顔")
		event.set_object_sequence_texture_animation(3, 1, "通常目パチ")
		event.set_object_sequence_motion(3, "光をためるL", 4)
		event.set_object_sequence_motion(3, "光をためるL")
		at = 38
		wait_objects(3)
		event.set_mouth_texture_animations(3, "わらい口パク")
		at = 39
		helper_4116e6bb(1040120)
		event.reset_mouth_texture_animations()
		event.set_camera_sequence_position(2.48, 211.26, 53.9)
		event.set_camera_sequence_look_at(-2.43, 150.53, -146.57)
		event.set_object_sequence_motion(3, "光を放つ", 6)
		event.wait_object_sequence_motion_end(3)
		at = 40
		wait_objects(3)
		event.play_sound_effect(var4, 12)
		event.set_character_active(0, 0)
		event.set_character_active(0, 8)
		event.set_character_active(1, 9)
		event.set_camera_sequence_position(-117.37, 146.51, -35.46)
		event.set_camera_sequence_look_at(103.37, 9.39, 23.71)
		event.set_object_sequence_position(2, -18.78, 50.0, -55.26)
		event.set_object_sequence_rotation(2, 0.0, 0.09, 0.0)
		event.create_effect_2("e110ポル回転キラ", 9)
		event.set_effect_first_vector(160.0, 140.0, 160.0)
		event.set_object_sequence_position(2, 0.86, 50.0, -22.64)
		event.set_object_sequence_rotation(2, 0.0, -0.87, 0.0)
		event.set_object_sequence_motion(2, "復活", 6)
		at = 41
		helper_888ab2a3(100)
		event.play_sound_effect(var4, 13)
		event.set_camera_sequence_position(-87.08, 95.61, 51.87)
		event.set_camera_sequence_look_at(83.1, 98.77, -93.27)
		event.set_object_sequence_motion(2, "ブルブル", 6)
		event.queue_object_sequence_next_motion(2, "立ち", 0)
		at = 42
		helper_888ab2a3(50)
		event.play_sound_effect(var4, 14)
		event.set_camera_sequence_position(-79.4, 118.39, 76.29)
		event.set_camera_sequence_look_at(-11.32, 84.25, -20.1)
		event.set_object_sequence_position(2, -10.22, 50.0, -0.34)
		event.set_object_sequence_rotation(2, 0.0, -0.87, 0.0)
		at = 43
		vm.wait(43)
		at = 44
		helper_888ab2a3(30)
		event.set_character_active(1, 8)
		event.set_character_active(0, 9)
		event.set_camera_sequence_position(-14.86, 110.63, -24.65)
		event.set_camera_sequence_look_at(-30.63, 87.29, 63.28)
		event.set_object_sequence_position(1, -33.56, 49.19, 71.0)
		event.set_object_sequence_rotation(1, 0.0, 2.93, 0.0)
		event.set_object_sequence_motion(1, "構え", 4)
		event.play_sound_effect(var4, 15)
		event.set_mouth_texture_animations(1, "口パク")
		at = 45
		helper_4116e6bb(1040130)
		event.reset_mouth_texture_animations()
		event.set_object_handle_frame_visible(3, "cyl2", 0)
		event.set_camera_sequence_position(29.47, 85.69, 10.08)
		event.set_camera_sequence_look_at(-135.3, 106.15, 168.51)
		event.play_sound_effect(var4, 16)
		event.play_sound_effect(var4, 17)
		event.play_sound_effect(var4, 18)
		event.set_object_sequence_motion(1, "手をまわす", 6)
		event.queue_object_sequence_next_motion(1, "手をまわすL")
		at = 46
		wait_objects(1)
		at = 47
		wait_camera()
		event.set_mouth_texture_animations(1, "口パク")
		at = 48
		helper_4116e6bb(1040140)
		event.reset_mouth_texture_animations()
		event.set_character_active(1, 18)
		event.set_character_position(18, -33.56, 49.19, 71.0)
		event.set_character_rotation(18, 0.0, 2.93, 0.0)
		event.set_character_scale(18, 1.2, 1.2, 1.2)
		event.set_object_sequence_motion(12, "オーバーヒート\t", 4)
		event.fade_out_music(30)
		event.stop_sound_effect(var4, 15)
		event.play_sound_effect(var4, 19)
		event.set_object_sequence_motion(1, "ガコン", 6)
		event.queue_object_sequence_next_motion(1, "ガコンL")
		at = 49
		wait_objects(1)
		event.play_sound_effect(var4, 20)
		event.set_mouth_texture_animations(1, "口パク")
		at = 50
		helper_4116e6bb(1040150)
		event.reset_mouth_texture_animations()
		event.set_character_active(0, 18)
		event.set_character_active(1, 0)
		event.set_camera_sequence_position(-84.61, 67.09, 17.57)
		event.set_camera_sequence_look_at(46.83, 120.54, 229.76)
		event.set_object_sequence_position(0, -51.32, 49.7, 99.35)
		event.set_object_sequence_rotation(0, 0.0, 1.48, 0.0)
		event.set_character_position(0, -51.32, 49.7, 99.35)
		event.set_character_rotation(0, 0.0, 1.48, 0.0)
		event.set_object_sequence_position(1, -18.48, 49.19, 89.15)
		event.set_object_sequence_rotation(1, 0.0, -2.87, 0.0)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "無表情")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_motion(0, "上見立ち", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "ガコンL", 4)
		event.set_object_sequence_motion(0, "上見会話", 2)
		event.queue_object_sequence_next_motion(0, "上見立ち")
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 51
		helper_4116e6bb(1040160)
		event.reset_mouth_texture_animations()
		at = 52
		helper_4116e6bb(1040170)
		event.set_object_sequence_motion(1, "ミンツを見る", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(1, "ミンツを見るL")
		at = 53
		wait_objects(1)
		event.set_mouth_texture_animations(1, "口パク")
		at = 54
		helper_4116e6bb(1040171)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(1, "口パク")
		at = 55
		helper_4116e6bb(1040172)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(1, "口パク")
		at = 56
		helper_4116e6bb(1040180)
		event.reset_mouth_texture_animations()
		event.set_camera_sequence_position(-26.67, 89.04, 100.9)
		event.set_camera_sequence_look_at(-181.84, -8.6, 101.99)
		event.set_object_sequence_motion(0, "上見立ち", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "ガコンL", 4)
		event.set_object_sequence_motion(0, "上見会話", 2)
		event.queue_object_sequence_next_motion(0, "上見立ち")
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 57
		helper_4116e6bb(1040190)
		event.reset_mouth_texture_animations()
		event.set_camera_sequence_position(3.1, 137.71, 121.7)
		event.set_camera_sequence_look_at(-96.45, -19.65, 33.14)
		event.set_object_sequence_position(0, -52.15, 49.3, 100.27)
		event.set_object_sequence_rotation(0, 0.0, 1.6, 0.0)
		event.set_object_sequence_motion(0, "上見立ち", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "ガコンL", 4)
		event.set_mouth_texture_animations(1, "口パク")
		at = 58
		helper_4116e6bb(1040200)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(1, "ミンツを見る戻り", 6)
		event.play_sound_effect(var4, 21)
		at = 59
		helper_888ab2a3(15)
		event.stop_sound_effect(var4, 20)
		event.set_mouth_texture_animations(1, "口パク")
		at = 60
		helper_4116e6bb(1040201)
		event.reset_mouth_texture_animations()
		at = 61
		wait_objects(1)
		event.set_camera_sequence_position(-35.68, 98.0, 30.68)
		event.set_camera_sequence_look_at(10.9, 100.95, 171.17)
		event.set_object_sequence_position(0, -18.48, 49.19, 89.15)
		event.set_object_sequence_rotation(0, 0.0, -2.87, 0.0)
		event.set_object_sequence_scale(0, 1.2, 1.2, 1.2)
		event.set_object_sequence_position(1, -18.48, 49.19, 89.15)
		event.set_object_sequence_rotation(1, 0.0, -2.87, 0.0)
		event.play_sound_effect(var4, 15)
		event.play_sound_effect(var4, 22)
		event.set_object_sequence_motion(0, "スティーブに乗る", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(0, "スティーブに乗るL")
		at = 62
		wait_objects(0)
		at = 63
		helper_888ab2a3(15)
		event.set_character_active(0, 8)
		event.set_character_active(0, 0)
		event.set_character_active(1, 9)
		event.set_character_active(1, 10)
		event.set_camera_sequence_position(-155.09, 107.3, 7.35)
		event.set_camera_sequence_look_at(-110.59, 116.9, -6.56)
		event.set_object_sequence_position(2, -21.45, 49.19, 21.76)
		event.set_object_sequence_rotation(2, 0.0, -1.87, 0.0)
		event.set_object_sequence_scale(2, 1.2, 1.2, 1.2)
		event.set_object_sequence_position(3, -69.17, 111.79, -20.32)
		event.set_object_sequence_rotation(3, 0.0, -1.75, 0.0)
		event.set_object_sequence_motion(3, "浮遊", 4)
		event.set_mouth_texture_animations(3, "わらい口パク")
		at = 64
		helper_4116e6bb(1040210)
		event.reset_mouth_texture_animations()
		event.play_sound_effect(var4, 23)
		event.set_object_sequence_motion(3, "殺っておしまい", 6)
		event.queue_object_sequence_next_motion(3, "殺っておしまいL")
		event.set_mouth_texture_animations(3, "わらい口パク")
		at = 65
		helper_4116e6bb(1040211)
		event.reset_mouth_texture_animations()
		at = 66
		wait_objects(3)
		event.set_character_active(0, 10)
		event.set_camera_sequence_position(-166.8, 110.8, 7.81)
		event.set_camera_sequence_look_at(-73.91, 78.74, 3.61)
		event.set_object_sequence_position(2, -20.92, 49.19, 0.18)
		event.set_object_sequence_rotation(2, 0.0, -1.51, 0.0)
		projection_2 = event.get_event_projection() or projection_2
		event.set_object_sequence_motion(2, "突進", 4)
		event.shake_camera_sequence(0.0, 1.0, 0.0, 60)
		event.move_camera_sequence(-524.07, 92.61, 14.81, -374.2, 78.74, 8.04, 60)
		event.move_object_sequence(2, -408.03, 50.0, 7.63, 60)
		at = 67
		helper_d9e95704(projection_2, vm.f32(524.9), 60, var5)
		event.set_event_projection(projection_2)
		event.set_character_active(1, 0)
		event.set_character_active(1, 8)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-289.45, 186.74, -103.76)
		event.set_camera_sequence_look_at(-436.94, 140.81, -26.0)
		event.set_object_sequence_position(0, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(0, 0.0, 0.0, 0.0)
		event.set_object_sequence_scale(0, 1.0, 1.0, 1.0)
		event.attach_character_to_frame(8, "mints", 0)
		event.set_object_sequence_position(1, -504.42, 50.21, 25.83)
		event.set_object_sequence_rotation(1, 0.0, 1.48, 0.0)
		event.set_object_sequence_scale(1, 1.0, 1.0, 1.0)
		event.set_object_sequence_position(2, -316.2, 45.22, 44.35)
		event.set_object_sequence_rotation(2, 0.0, -1.56, 0.0)
		event.set_object_sequence_motion(0, "スティーブに乗るL", 4)
		event.set_object_sequence_motion(1, "立ち", 4)
		event.set_object_sequence_motion(2, "突進", 4)
		event.delay_object_sequence_motion_track(2, 10)
		event.set_object_sequence_motion(2, "立ち")
		event.move_object_sequence(2, -366.82, 45.22, 14.07, 15)
		event.set_object_sequence_motion(1, "バックジャンプ", 6, 0.4)
		event.play_sound_effect(var4, 24)
		event.jump_object_sequence(1, -744.89, 134.13, 0.74, -0.35, 33)
		at = 68
		wait_objects(2)
		at = 69
		wait_objects(1)
		event.set_camera_sequence_position(-640.55, 176.56, -6.9)
		event.set_camera_sequence_look_at(-739.25, 169.31, -1.66)
		event.set_object_sequence_position(1, -734.79, 134.97, -2.3)
		event.set_object_sequence_rotation(1, 0.0, 1.64, 0.0)
		event.set_object_sequence_motion(0, "スティーブに乗るL", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "立ち", 4)
		at = 70
		helper_888ab2a3(15)
		event.set_object_sequence_motion(1, "さらばじゃ", 2)
		event.play_sound_effect(var4, 25)
		event.set_mouth_texture_animations(1, "口パク")
		at = 71
		helper_4116e6bb(1040220)
		event.reset_mouth_texture_animations()
		event.play_sound_effect(var4, 26)
		event.set_object_sequence_motion(1, "歩き", 4)
		event.rotate_object_sequence(1, 0.0, -1.6, 0.0, 30)
		at = 72
		wait_objects(1)
		event.move_object_sequence(1, -937.66, 134.97, -0.71, 60)
		at = 73
		wait_objects(1)
		event.set_character_active(1, 10)
		event.set_camera_sequence_position(-326.4, 171.06, 5.03)
		event.set_camera_sequence_look_at(87.54, 136.02, -63.19)
		event.set_object_sequence_position(2, -343.04, 49.6, -15.01)
		event.set_object_sequence_rotation(2, 0.0, 0.12, 0.0)
		event.set_object_sequence_position(3, -286.2, 134.97, -1.83)
		event.set_object_sequence_rotation(3, 0.0, -1.72, 0.0)
		event.set_object_sequence_motion(1, "立ち", 4)
		event.stop_sound_effect(var4, 15)
		event.set_object_sequence_motion(2, "立ち", 4)
		event.set_object_sequence_motion(3, "あらあら", 4)
		event.set_mouth_texture_animations(3, "わらい口パク")
		at = 74
		helper_4116e6bb(1040230)
		event.reset_mouth_texture_animations()
		at = 75
		wait_objects(3)
		event.set_camera_sequence_position(-584.1, 136.54, 9.53)
		event.set_camera_sequence_look_at(87.54, 80.4, -63.19)
		event.set_object_sequence_position(3, -344.47, 145.98, -65.24)
		event.set_object_sequence_rotation(3, 0.0, -1.36, 0.0)
		event.set_object_sequence_motion(2, "立ち", 4)
		event.play_sound_effect(var4, 27)
		event.mark_camera_sequence_fade_track()
		event.delay_camera_sequence_fade_track(18)
		event.fade_out_camera_sequence(100, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(2, "パオーン", 6)
		at = 76
		wait_objects(2)
		at = 77
		wait_camera()
	end, function(received: { any }): boolean
		if at <= 1 then
			helper_038a2e4d(4)
		end
		if at <= 2 then
			helper_038a2e4d(15)
		end
		if at <= 3 then
			helper_8cd371d7(1040010)
		end
		if at <= 5 then
			var10 = 40
			var9 = 1
			var6 = vm.f32(vm.fdiv(vm.f32(vm.f32(867.9) - projection_2), var10))
			projection_3 = vm.f32(var6 * var9)
			projection_3 = vm.f32(projection_2 + projection_3)
		end
		if at <= 6 then
			local _ = var9 < var10
			var9 = var9 + 1
			helper_038a2e4d(15)
		end
		if at <= 7 then
			helper_8cd371d7(1040020)
		end
		if at <= 8 then
			helper_038a2e4d(15)
		end
		if at <= 9 then
			helper_8cd371d7(1040030)
		end
		if at <= 10 then
			helper_b581d4ec(50, var5)
		end
		if at <= 11 then
			helper_038a2e4d(15)
		end
		if at <= 12 then
			helper_8cd371d7(1040040)
		end
		if at <= 13 then
			helper_238b5abc(2)
		end
		if at <= 14 then
			helper_238b5abc(7)
		end
		if at <= 15 then
			helper_038a2e4d(28)
		end
		if at <= 16 then
			helper_238b5abc(2)
		end
		if at <= 17 then
			helper_53ffe901(1040050, 12)
		end
		if at <= 18 then
			helper_53ffe901(1040060, 25)
		end
		if at <= 19 then
			helper_344d6cd8()
		end
		if at <= 20 then
			helper_038a2e4d(30)
		end
		if at <= 21 then
			helper_8cd371d7(1040070)
		end
		if at <= 22 then
			helper_038a2e4d(3)
		end
		if at <= 23 then
			helper_8cd371d7(1040080)
		end
		if at <= 24 then
			helper_8cd371d7(1040090)
		end
		if at <= 25 then
			helper_038a2e4d(3)
		end
		if at <= 26 then
			var3 = 1
		end
		if at <= 27 then
			local _ = var3 < 33
			var3 = var3 + 1
			helper_238b5abc(1)
		end
		if at <= 28 then
			helper_238b5abc(2)
		end
		if at <= 29 then
			var3 = 0
		end
		if at <= 30 then
			local _ = var3 < 75
			local _ = var3 < 55
			local _ = vm.imod(var3, 4) == 0
			local _ = var3 == 57
			var3 = var3 + 1
			helper_238b5abc(1)
		end
		if at <= 31 then
			helper_238b5abc(2)
		end
		if at <= 32 then
			helper_344d6cd8()
		end
		if at <= 33 then
			helper_038a2e4d(15)
		end
		if at <= 34 then
			helper_8cd371d7(1040100)
		end
		if at <= 35 then
			helper_038a2e4d(3)
		end
		if at <= 36 then
			helper_8cd371d7(1040110)
		end
		if at <= 37 then
			helper_238b5abc(3)
		end
		if at <= 38 then
			helper_8cd371d7(1040120)
		end
		if at <= 39 then
			helper_238b5abc(3)
		end
		if at <= 40 then
			helper_038a2e4d(100)
		end
		if at <= 41 then
			helper_038a2e4d(50)
		end
		if at <= 43 then
			helper_038a2e4d(30)
		end
		if at <= 44 then
			helper_8cd371d7(1040130)
		end
		if at <= 45 then
			helper_238b5abc(1)
		end
		if at <= 46 then
			helper_344d6cd8()
		end
		if at <= 47 then
			helper_8cd371d7(1040140)
		end
		if at <= 48 then
			helper_238b5abc(1)
		end
		if at <= 49 then
			helper_8cd371d7(1040150)
		end
		if at <= 50 then
			helper_8cd371d7(1040160)
		end
		if at <= 51 then
			helper_8cd371d7(1040170)
		end
		if at <= 52 then
			helper_238b5abc(1)
		end
		if at <= 53 then
			helper_8cd371d7(1040171)
		end
		if at <= 54 then
			helper_8cd371d7(1040172)
		end
		if at <= 55 then
			helper_8cd371d7(1040180)
		end
		if at <= 56 then
			helper_8cd371d7(1040190)
		end
		if at <= 57 then
			helper_8cd371d7(1040200)
		end
		if at <= 58 then
			helper_038a2e4d(15)
		end
		if at <= 59 then
			helper_8cd371d7(1040201)
		end
		if at <= 60 then
			helper_238b5abc(1)
		end
		if at <= 61 then
			helper_238b5abc(0)
		end
		if at <= 62 then
			helper_038a2e4d(15)
		end
		if at <= 63 then
			helper_8cd371d7(1040210)
		end
		if at <= 64 then
			helper_8cd371d7(1040211)
		end
		if at <= 65 then
			helper_238b5abc(3)
		end
		if at <= 66 then
			helper_2f9e90af(projection_2, vm.f32(524.9), 60, var5)
		end
		if at <= 67 then
			helper_238b5abc(2)
		end
		if at <= 68 then
			helper_238b5abc(1)
		end
		if at <= 69 then
			helper_038a2e4d(15)
		end
		if at <= 70 then
			helper_8cd371d7(1040220)
		end
		if at <= 71 then
			helper_238b5abc(1)
		end
		if at <= 72 then
			helper_238b5abc(1)
		end
		if at <= 73 then
			helper_8cd371d7(1040230)
		end
		if at <= 74 then
			helper_238b5abc(3)
		end
		if at <= 75 then
			helper_238b5abc(2)
		end
		if at <= 76 then
			helper_344d6cd8()
		end
		return true
	end)
	at = 78
	vm.entry(78)
	event.cancel_drama_scene_skip()
	event.stop_music(0)
	at = 79
	helper_888ab2a3(4)
	event.clear_effect_manager()
	event.stop_sound_effect(var4, 4)
	event.stop_sound_effect(var4, 10)
	event.stop_sound_effect(var4, 15)
	event.stop_sound_effect(var4, 20)
	event.stop_sound_effect(var4, 28)
	event.set_character_scale(0, 1.0, 1.0, 1.0)
	event.set_event_projection(projection)
	event.delete_character_extension_packs(0)
	event.delete_character(8)
	event.delete_character(9)
	event.delete_character(10)
	event.delete_character(11)
	event.delete_character(12)
	event.delete_character(14)
	event.delete_character(15)
	event.delete_character(16)
	event.delete_character(17)
	event.delete_character(18)
end

return helper_3753f254
