--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_238b5abc = require("@lib/event/helper_238b5abc")
local helper_344d6cd8 = require("@lib/event/helper_344d6cd8")
local helper_4116e6bb = require("@lib/event/helper_4116e6bb")
local helper_8cd371d7 = require("@lib/event/helper_8cd371d7")
local wait_camera = require("@lib/event/wait_camera")
local wait_frames = require("@lib/event/wait_frames")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_ee5ecb83()
	local active_chr_no: s32 = 0
	local var1: s32 = 0
	local block: s32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local at: number = 0
	vm.section(function()
		event.set_save_flag(440, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.show_dungeon_status_bar(0, 1.0)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		active_chr_no = event.get_playable_character() or active_chr_no
		event.stop_music(0)
		at = 1
		wait_frames(4)
		event.load_music(34)
		event.load_map_sounds(4826)
		var1 = event.load_sound_effect_file_2(4826) or var1
		event.set_scene_status_flags(1, 0, 256, 1)
		event.change_directory("event/e400/e440/")
		event.load_message_file(0, 5, "e440_1.txt")
		if active_chr_no == 0 then
			event.load_character_motion_pack(5, "e440_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if active_chr_no == 1 then
			event.load_character_motion_pack(5, "e440_monica.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.load_character(5, "e440_jamming.gltf", "info", 10)
		event.set_character_active(10)
		event.attach_object_handle_to_character(2, 10)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.load_character(5, "e440_sourcer.gltf", "info", 11)
		event.set_character_active(11)
		event.attach_object_handle_to_character(3, 11)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.load_character(5, "e440_seagura.gltf", "info", 12)
		event.set_character_active(12)
		event.attach_object_handle_to_character(4, 12)
		event.clear_object_sequence(4)
		event.set_object_sequence_object(4, 4)
		event.copy_character(5, 12, 13)
		event.set_character_active(13)
		event.attach_object_handle_to_character(5, 13)
		event.clear_object_sequence(5)
		event.set_object_sequence_object(5, 5)
		event.copy_character(5, 12, 14)
		event.set_character_active(14)
		event.attach_object_handle_to_character(6, 14)
		event.clear_object_sequence(6)
		event.set_object_sequence_object(6, 6)
		event.copy_character(5, 12, 15)
		event.set_character_active(15)
		event.attach_object_handle_to_character(7, 15)
		event.clear_object_sequence(7)
		event.set_object_sequence_object(7, 7)
		block = event.load_event_image_4(5, "e440telop01_1.json", 0) or block
		event.reset_event_sprite(0)
		event.set_event_sprite_type(0, 0)
		event.set_event_sprite_texture(0, "e440telop01", block)
		event.set_event_sprite_color(0, 128, 128, 128, 0)
		event.set_event_sprite_texture_rect(0, 0, 0, 512, 128)
		event.set_event_sprite_size(0, 512, 128)
		event.set_event_sprite_position(0, 256, 292)
		event.set_event_sprite_alpha_blend(0, 0)
		event.set_event_sprite_draw_pass(0, 0)
		event.attach_object_handle_to_sprite(10, 0)
		event.clear_object_sequence(8)
		event.set_object_sequence_object(8, 10)
		event.change_directory("")
		event.load_character(5, "event/e400/e440/mariometto_a.gltf", "info", 16)
		event.set_character_active(16)
		event.attach_character_to_frame(12, "mettoa_null", 16)
		event.copy_character(5, 16, 17)
		event.set_character_active(17)
		event.attach_character_to_frame(13, "mettoa_null", 17)
		event.copy_character(5, 16, 18)
		event.set_character_active(18)
		event.attach_character_to_frame(14, "mettoa_null", 18)
		event.copy_character(5, 16, 19)
		event.set_character_active(19)
		event.attach_character_to_frame(15, "mettoa_null", 19)
		if active_chr_no == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 8)
			event.load_equipment_model(5, 0, 4, "info", 8)
			event.load_equipment_model(5, 0, 3, "info", 8)
			event.load_equipment_model(5, 0, 2, "info", 8, 9)
			event.load_character_motion_pack(5, "event/e400/e440/e440_mints.gltf", "info", 8)
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
			event.load_character_motion_pack(5, "event/e400/e440/e440_monica.gltf", "info", 8)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 8)
			event.attach_object_handle_to_character(1, 8)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 0)
		end
		event.set_character_active(8)
		event.set_character_active(9)
		event.attach_object_handle_to_character(8, 1)
		event.attach_object_handle_to_character(9, 2)
		event.set_object_handle_visible(8, 0)
		event.set_object_handle_visible(9, 0)
		event.set_object_handle_position(0, 682.0, 0.0, 189.0)
		event.set_object_handle_rotation(0, 0.0, -1.57, 0.0)
		event.set_object_handle_motion(0, "立ち", 4)
		event.set_object_handle_footstep_sound(0, 14)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "おこり顔")
		event.set_object_handle_texture_animation(0, 1, "おこり目パチ")
		event.set_object_handle_texture_animation(0, 1, "大口")
		event.set_object_handle_position(1, 700.0, 0.0, 200.0)
		event.set_object_handle_rotation(1, 0.0, -1.57, 0.0)
		event.set_object_handle_motion(1, "立ち", 4)
		event.set_object_handle_footstep_sound(1, 14)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "おこり顔")
		event.set_object_handle_texture_animation(1, 1, "おこり目パチ")
		event.set_object_handle_position(2, 1381.99, 900.0, 2158.32)
		event.set_object_handle_rotation(2, 0.0, 3.0, 0.0)
		event.set_object_handle_motion(2, "立ち", 4)
		event.set_object_handle_sound_bank(2, var1)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "目パチ")
		event.set_object_handle_position(3, 1381.99, 900.0, 2158.32)
		event.set_object_handle_rotation(3, 0.0, 2.04, 0.0)
		event.set_object_handle_position(4, 132.83, 0.0, -305.18)
		event.set_object_handle_rotation(4, 0.0, 0.72, 0.0)
		event.set_object_handle_motion(4, "立ち", 4)
		event.set_object_handle_texture_animation(4, 0)
		event.set_object_handle_texture_animation(4, 1, "目赤")
		event.set_object_handle_position(5, -456.48, 0.0, 1086.61)
		event.set_object_handle_rotation(5, 0.0, 2.28, 0.0)
		event.set_object_handle_motion(5, "立ち", 4)
		event.set_object_handle_texture_animation(5, 0)
		event.set_object_handle_texture_animation(5, 1, "目赤")
		event.set_object_handle_position(6, 1347.63, 0.0, 856.01)
		event.set_object_handle_rotation(6, 0.0, -2.28, 0.0)
		event.set_object_handle_motion(6, "立ち", 4)
		event.set_object_handle_texture_animation(6, 0)
		event.set_object_handle_texture_animation(6, 1, "目赤")
		event.set_object_handle_position(7, 894.8, 0.0, -315.53)
		event.set_object_handle_rotation(7, 0.0, -0.72, 0.0)
		event.set_object_handle_motion(7, "立ち", 4)
		event.set_object_handle_texture_animation(7, 0)
		event.set_object_handle_texture_animation(7, 1, "目赤")
		event.enable_drama_skip()
		event.play_sound_effect(var1, 0)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(1793.56, 223.9, 283.1)
		event.set_camera_sequence_look_at(1848.03, 252.49, 433.57)
		event.move_camera_sequence_eased(1793.56, 403.69, 283.1, 1848.03, 478.81, 433.57, 90, 2, 1.0)
		event.fade_in_screen(30)
		at = 2
		wait_camera()
		event.set_camera_sequence_position(488.77, 606.28, -354.72)
		event.set_camera_sequence_look_at(488.77, 429.77, -146.44)
		event.move_object_sequence(0, 482.0, 0.0, 189.0, 60)
		event.set_object_sequence_motion(0, "走り", 4)
		event.delay_object_sequence_motion_track(0, 60)
		event.set_object_sequence_motion(0, "立ち")
		event.move_object_sequence(1, 486.99, 0.0, 202.8, 64)
		event.set_object_sequence_motion(1, "走り", 4)
		event.delay_object_sequence_motion_track(1, 64)
		event.set_object_sequence_motion(1, "立ち")
		at = 3
		wait_objects(1)
		event.play_sound_effect(var1, 1)
		event.move_object_sequence(4, 267.78, 0.0, -96.39, 210)
		event.set_object_sequence_motion(4, "歩き", 0)
		event.delay_object_sequence_motion_track(4, 210)
		event.set_object_sequence_motion(4, "立ち")
		event.move_object_sequence(5, 171.77, 0.0, 463.88, 230)
		event.set_object_sequence_motion(5, "歩き", 0, 0.48)
		event.delay_object_sequence_motion_track(5, 230)
		event.set_object_sequence_motion(5, "立ち")
		event.move_object_sequence(6, 773.64, 0.0, 443.16, 220)
		event.set_object_sequence_motion(6, "歩き", 0, 0.48)
		event.delay_object_sequence_motion_track(6, 220)
		event.set_object_sequence_motion(6, "立ち")
		event.move_object_sequence(7, 711.27, 0.0, -99.08, 202)
		event.set_object_sequence_motion(7, "歩き", 0)
		event.delay_object_sequence_motion_track(7, 202)
		event.set_object_sequence_motion(7, "立ち")
		at = 4
		wait_frames(160)
		event.set_camera_sequence_position(433.73, 10.85, 194.55)
		event.set_camera_sequence_look_at(494.45, 22.5, 195.7)
		event.set_object_sequence_motion(0, "あとずさり", 6)
		event.queue_object_sequence_next_motion(0, "あとずさりL", 4)
		event.set_object_sequence_motion(1, "のけぞり", 6)
		event.queue_object_sequence_next_motion(1, "のけぞりL", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 5
		helper_4116e6bb(4400010)
		at = 6
		wait_objects(1)
		event.set_object_sequence_motion(0, "指さす", 2)
		event.queue_object_sequence_next_motion(0, "指さすL", 4)
		event.delay_object_sequence_sound_track(0, 10)
		event.play_object_sequence_sound(0, var1, 2)
		event.set_mouth_texture_animations(0, "通常口パク")
		at = 7
		helper_4116e6bb(4400020)
		at = 8
		wait_objects(0)
		at = 9
		wait_objects(5)
		event.set_camera_sequence_position(482.22, 295.97, 32.59)
		event.set_camera_sequence_look_at(358.04, 280.12, 4.29)
		event.play_sound_effect(var1, 3)
		at = 10
		helper_4116e6bb(4400025)
		event.stop_sound_effect(var1, 3)
		event.set_camera_sequence_position(426.29, 336.99, 1022.57)
		event.set_camera_sequence_look_at(446.51, 249.73, 695.36)
		event.play_music(0)
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 11
		helper_4116e6bb(4400030)
		event.set_camera_sequence_position(466.23, 33.98, 224.28)
		event.set_camera_sequence_look_at(486.89, 17.34, 191.61)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "おこり顔")
		event.set_object_handle_texture_animation(0, 1, "おこり目パチ")
		event.set_object_handle_texture_animation(0, 1, "口とじ～大口")
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "おこり顔")
		event.set_object_handle_texture_animation(1, 1, "おこり目パチ")
		event.set_object_handle_texture_animation(1, 1, "口とじ～大口")
		event.set_object_sequence_motion(0, "左上を見る", 6)
		event.queue_object_sequence_next_motion(0, "左上を見るL", 4)
		event.set_object_sequence_motion(1, "左上", 6)
		event.queue_object_sequence_next_motion(1, "左上L", 4)
		at = 12
		helper_4116e6bb(4400040)
		at = 13
		wait_objects(0)
		event.set_camera_sequence_position(468.1, 89.63, 136.48)
		event.set_camera_sequence_look_at(619.55, 292.69, 882.71)
		event.move_camera_sequence_eased(604.45, 261.89, 808.35, 619.55, 286.12, 882.71, 90, 0, 1.0)
		event.play_sound_effect(var1, 4)
		event.set_object_sequence_position(0, 474.35, 0.0, 208.29)
		event.set_object_sequence_rotation(0, 0.0, 0.5, 0.0)
		event.set_object_sequence_motion(0, "上向くL", 4, -1.0, 1)
		event.set_object_sequence_position(1, 486.05, 0.0, 198.18)
		event.set_object_sequence_rotation(1, 0.0, 0.23, 0.0)
		event.set_object_sequence_motion(1, "上向くL", 4, -1.0, 1)
		event.set_object_sequence_motion(2, "演奏1", 4)
		event.move_object_sequence_eased(2, 600.0, 900.0, 850.0, 60, 2, 0.5)
		event.move_object_sequence_eased(3, 600.0, 900.0, 850.0, 60, 2, 0.5)
		var3 = 0.0
		var4 = vm.f32(-0.35)
		var5 = 0
		while var5 < 70 do
			do
				local out1, out2, out3 = event.get_object_handle_position(2)
				pos_x = out1 or pos_x
				pos_y = out2 or pos_y
				pos_z = out3 or pos_z
			end
			pos_y = vm.f32(pos_y + var3)
			if var5 < 50 then
				var3 = vm.f32(var3 + var4)
			else
				var3 = vm.f32(var3 - vm.f32(var4 * vm.f32(2.2)))
			end
			event.set_object_handle_position(2, pos_x, pos_y, pos_z)
			event.set_object_handle_position(3, pos_x, pos_y, pos_z)
			var5 = var5 + 1
			at = 14
			vm.wait(14)
		end
		event.play_sound_effect(var1, 5)
		event.set_event_sprite_draw_pass(0, 1)
		event.set_object_sequence_color(8, 128, 128, 128, 128, 30)
		event.delay_object_sequence_motion_track(2, 60)
		event.queue_object_sequence_next_motion(2, "演奏2", 6)
		event.queue_object_sequence_next_motion(2, "演奏1", 4)
		at = 15
		helper_4116e6bb(4400045)
		at = 16
		wait_objects(2)
		at = 17
		wait_camera()
		event.set_event_sprite_draw_pass(0, 0)
		event.set_camera_sequence_position(520.65, 18.19, 210.67)
		event.set_camera_sequence_look_at(478.14, 21.46, 206.21)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "おこり顔")
		event.set_object_handle_texture_animation(1, 1, "おこり目パチ")
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 18
		helper_4116e6bb(4400050)
		event.set_camera_sequence_position(640.97, 288.67, 848.2)
		event.set_camera_sequence_look_at(617.43, 290.99, 881.13)
		event.play_sound_effect(var1, 6)
		event.set_object_sequence_motion(2, "耳に手in", 6)
		event.wait_object_sequence_motion_end(2)
		at = 19
		wait_objects(2)
		event.move_camera_sequence_angle_height_distance_eased(-2.74, -19.32, 54.92, 90, 0, 1.0)
		event.set_mouth_motions(2, "耳に手（会話）", 4, "耳に手", 0)
		at = 20
		helper_4116e6bb(4400060)
		event.set_object_sequence_motion(2, "ギャーンin", 2)
		event.wait_object_sequence_motion_end(2)
		at = 21
		wait_frames(2)
		event.play_sound_effect(var1, 7)
		at = 22
		wait_objects(2)
		event.set_mouth_motions(2, "ギャーン（会話）", 4, "ギャーン", 0)
		at = 23
		helper_4116e6bb(4400063)
		at = 24
		wait_camera()
		event.set_object_sequence_motion(2, "笑うin", 2)
		event.queue_object_sequence_next_motion(2, "笑う", 4)
		at = 25
		helper_4116e6bb(4400066)
		at = 26
		wait_objects(2)
		event.set_camera_sequence_position(493.73, 43.46, 227.63)
		event.set_camera_sequence_look_at(488.06, 20.7, 202.27)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "おこり顔")
		event.set_object_handle_texture_animation(1, 1, "おこり目パチ")
		event.play_sound_effect(var1, 8)
		event.set_object_sequence_motion(1, "半歩前", 6)
		event.queue_object_sequence_next_motion(1, "半歩前L", 4)
		event.set_mouth_texture_animations(1, "大口パク")
		at = 27
		helper_4116e6bb(4400070)
		at = 28
		wait_objects(1)
		event.set_camera_sequence_position(615.36, 287.58, 855.01)
		event.set_camera_sequence_look_at(619.05, 292.49, 877.81)
		event.set_object_sequence_motion(2, "会話（演奏）", 6)
		event.queue_object_sequence_next_motion(2, "立ち（演奏）", 4)
		at = 29
		helper_4116e6bb(4400080)
		at = 30
		helper_4116e6bb(4400083)
		event.move_camera_sequence_eased(482.56, 23.28, 34.42, 619.05, 121.85, 877.81, 60, 0, 1.0)
		at = 31
		wait_camera()
		event.fade_out_screen(30)
		at = 32
		wait_frames(30)
	end, function(received: { any }): boolean
		if at <= 1 then
			helper_344d6cd8()
		end
		if at <= 2 then
			helper_238b5abc(1)
		end
		if at <= 3 then
			wait_frames_skipping(160)
		end
		if at <= 4 then
			helper_8cd371d7(4400010)
		end
		if at <= 5 then
			helper_238b5abc(1)
		end
		if at <= 6 then
			helper_8cd371d7(4400020)
		end
		if at <= 7 then
			helper_238b5abc(0)
		end
		if at <= 8 then
			helper_238b5abc(5)
		end
		if at <= 9 then
			helper_8cd371d7(4400025)
		end
		if at <= 10 then
			helper_8cd371d7(4400030)
		end
		if at <= 11 then
			helper_8cd371d7(4400040)
		end
		if at <= 12 then
			helper_238b5abc(0)
		end
		if at <= 13 then
			var3 = 0.0
			var4 = vm.f32(-0.35)
			var5 = 0
			pos_y = vm.f32(pos_y + var3)
			var3 = vm.f32(var3 + var4)
			var3 = vm.f32(var3 - vm.f32(var4 * vm.f32(2.2)))
			local _ = var5 < 70
			local _ = var5 < 50
			var5 = var5 + 1
		end
		if at <= 14 then
			helper_8cd371d7(4400045)
		end
		if at <= 15 then
			helper_238b5abc(2)
		end
		if at <= 16 then
			helper_344d6cd8()
		end
		if at <= 17 then
			helper_8cd371d7(4400050)
		end
		if at <= 18 then
			helper_238b5abc(2)
		end
		if at <= 19 then
			helper_8cd371d7(4400060)
		end
		if at <= 20 then
			wait_frames_skipping(2)
		end
		if at <= 21 then
			helper_238b5abc(2)
		end
		if at <= 22 then
			helper_8cd371d7(4400063)
		end
		if at <= 23 then
			helper_344d6cd8()
		end
		if at <= 24 then
			helper_8cd371d7(4400066)
		end
		if at <= 25 then
			helper_238b5abc(2)
		end
		if at <= 26 then
			helper_8cd371d7(4400070)
		end
		if at <= 27 then
			helper_238b5abc(1)
		end
		if at <= 28 then
			helper_8cd371d7(4400080)
		end
		if at <= 29 then
			helper_8cd371d7(4400083)
		end
		if at <= 30 then
			helper_344d6cd8()
		end
		if at <= 31 then
			wait_frames_skipping(30)
		end
		return true
	end)
	event.cancel_drama_scene_skip()
	event.stop_sound_effect(var1, 0)
	event.stop_sound_effect(var1, 3)
	event.stop_sound_effect(var1, 4)
	event.set_event_sprite_draw_pass(0, 0)
	event.play_music(0)
	event.set_scene_status_flags(1, 0, 256, 0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.show_dungeon_status_bar(1, 1.0)
	event.set_object_handle_visible(8, 1)
	event.set_object_handle_visible(9, 1)
	event.delete_character_extension_packs(0)
	event.delete_character(8)
	event.delete_character(9)
	event.delete_character(10)
	event.delete_character(11)
	event.delete_character(12)
	event.delete_character(13)
	event.delete_character(14)
	event.delete_character(15)
	event.delete_character(16)
	event.delete_character(17)
	event.delete_character(18)
	event.delete_character(19)
	event.load_message_file(0, -1)
	event.delete_event_image(0)
	event.clear_camera_sequence()
end

return helper_ee5ecb83
