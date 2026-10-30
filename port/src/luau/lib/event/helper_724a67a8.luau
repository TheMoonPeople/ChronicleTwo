--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_238b5abc = require("@lib/event/helper_238b5abc")
local helper_344d6cd8 = require("@lib/event/helper_344d6cd8")
local helper_4116e6bb = require("@lib/event/helper_4116e6bb")
local helper_4bd79732 = require("@lib/event/helper_4bd79732")
local helper_8cd371d7 = require("@lib/event/helper_8cd371d7")
local helper_ec06cf84 = require("@lib/event/helper_ec06cf84")
local wait_camera = require("@lib/event/wait_camera")
local wait_frames = require("@lib/event/wait_frames")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_724a67a8()
	local active_chr_no: s32 = 0
	local var1: s32 = 0
	local at: number = 0
	vm.section(function()
		at = 1
		vm.entry(1)
		event.set_save_flag(536, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.show_dungeon_status_bar(0, 1.0)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		active_chr_no = event.get_playable_character() or active_chr_no
		if active_chr_no == 2 then
			event.switch_dungeon_main_character(0)
			active_chr_no = 0
		end
		if active_chr_no == 3 then
			event.switch_dungeon_main_character(1)
			active_chr_no = 1
		end
		event.stop_music(0)
		at = 2
		wait_frames(4)
		event.load_music(52)
		event.load_map_sounds(5823)
		var1 = event.load_sound_effect_file_2(5823) or var1
		event.set_scene_status_flags(1, 0, 256, 1)
		event.change_directory("event/e500/e536/")
		event.load_message_file(0, 5, "e536_1.txt")
		if active_chr_no == 0 then
			event.load_character_motion_pack(5, "e536_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if active_chr_no == 1 then
			event.load_character_motion_pack(5, "e536_monica.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.load_character(5, "e536_guiltoni.gltf", "info", 10)
		event.set_character_active(0, 10)
		event.attach_object_handle_to_character(2, 10)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.load_character(5, "e536_m_guil.gltf", "p00_23a", 11)
		event.set_character_active(11)
		event.attach_object_handle_to_character(3, 11)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.load_character(5, "e536_guilbaku.gltf", "info", 12)
		event.set_character_active(0, 12)
		event.load_character(5, "e536_guilbaku1.gltf", "info", 13)
		event.set_character_active(0, 13)
		event.load_character(5, "e536_hikari.gltf", "info", 14)
		event.set_character_active(0, 14)
		event.load_character(5, "e536_hikari1.gltf", "info", 15)
		event.set_character_active(0, 15)
		event.load_character(5, "e536_guil_hikari.gltf", "info", 16)
		event.set_character_active(0, 16)
		event.attach_object_handle_to_character(6, 16)
		event.clear_object_sequence(4)
		event.set_object_sequence_object(4, 6)
		event.change_directory("")
		if active_chr_no == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 8)
			event.load_equipment_model(5, 0, 4, "info", 8)
			event.load_equipment_model(5, 0, 3, "info", 8)
			event.load_equipment_model(5, 0, 2, "info", 8, 9)
			event.load_character_motion_pack(5, "event/e500/e536/e536_mints.gltf", "info", 8)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 8)
			event.attach_object_handle_to_character(0, 8)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		else
			event.load_character(5, "chara/c02_base.gltf", "info", 8)
			event.load_equipment_model(5, 1, 4, "info", 8)
			event.load_equipment_model(5, 1, 3, "info", 8)
			event.load_equipment_model(5, 1, 2, "info", 8, 9)
			event.load_character_motion_pack(5, "event/e500/e536/e536_monica.gltf", "info", 8)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 8)
			event.attach_object_handle_to_character(1, 8)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.set_character_active(8)
		event.set_character_active(9)
		event.attach_object_handle_to_character(4, 1)
		event.attach_object_handle_to_character(5, 2)
		event.set_object_handle_visible(4, 0)
		event.set_object_handle_visible(5, 0)
		event.set_object_handle_position(0, -10.0, 0.0, 100.0)
		event.set_object_handle_rotation(0, 0.0, 3.14, 0.0)
		event.set_object_handle_motion(0, "立ち", 4)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "おこり顔")
		event.set_object_handle_texture_animation(0, 1, "おこり目パチ")
		event.set_object_handle_texture_animation(0, 1, "半口")
		event.set_object_handle_footstep_sound(0, 2)
		event.set_object_handle_position(1, 10.0, 0.0, 100.0)
		event.set_object_handle_rotation(1, 0.0, 3.14, 0.0)
		event.set_object_handle_motion(1, "立ち", 4)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "おこり顔")
		event.set_object_handle_texture_animation(1, 1, "おこり目パチ")
		event.set_object_handle_texture_animation(1, 1, "半口")
		event.set_object_handle_footstep_sound(1, 2)
		event.set_object_handle_position(2, 0.0, 0.0, -50.0)
		event.set_object_handle_rotation(2, 0.0, 1.57, 0.0)
		event.set_object_handle_motion(2, "倒れ", 4)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "くるし顔")
		event.set_object_handle_texture_animation(2, 1, "くるし目とじ")
		event.set_object_handle_position(3, 0.0, 0.0, -50.0)
		event.set_object_handle_rotation(3, 0.0, 0.0, 0.0)
		event.set_object_handle_motion(3, "グォオー", 4)
		event.set_character_position(12, 0.0, 50.0, -50.0)
		event.set_character_rotation(12, 0.0, 0.0, 0.0)
		event.set_character_position(13, 0.0, 50.0, -18.0)
		event.set_character_rotation(13, 0.0, 0.0, 0.0)
		event.enable_drama_skip()
		event.set_character_active(1, 12)
		event.set_character_motion(12, "グォオー", 6)
		event.set_character_active(1, 13)
		event.set_character_motion(13, "グォオー", 6)
		event.play_sound_effect(var1, 2)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(0.0, 150.0, 65.9)
		event.set_camera_sequence_look_at(0.0, 150.0, -23.0)
		event.move_camera_sequence_eased(0.0, 123.2, 330.45, 0.0, 123.57, -23.0, 90, 0, 0.3)
		event.fade_in_screen(30)
		at = 3
		wait_frames(80)
		event.set_character_visible(11, 0, 1, 0.1)
		at = 4
		wait_camera()
		event.set_character_active(0, 13)
		event.set_character_active(0, 12)
		event.set_camera_sequence_position(45.36, 6.79, 49.62)
		event.set_camera_sequence_look_at(-2.61, 16.71, 101.94)
		event.set_wind(10, 0.0, 0.0, 1.0)
		event.set_character_active(1, 14)
		event.set_character_position(14, 19.99, 0.0, 122.09)
		event.set_character_rotation(14, 0.0, 1.57, 0.0)
		event.set_object_sequence_motion(0, "爆発", 6)
		event.queue_object_sequence_next_motion(0, "爆発L", 4)
		event.set_object_sequence_motion(1, "爆発", 6)
		event.queue_object_sequence_next_motion(1, "爆発L", 4)
		at = 5
		wait_objects(1)
		at = 6
		wait_frames(20)
		event.set_character_active(0, 14)
		event.set_camera_sequence_position(4.04, 16.09, 159.94)
		event.set_camera_sequence_look_at(4.04, 13.4, 71.43)
		event.set_character_active(0, 11)
		event.set_character_active(1, 10)
		event.set_character_active(1, 15)
		event.set_character_position(15, 0.0, 0.0, 15.0)
		event.set_character_rotation(15, 0.0, 0.0, 0.0)
		at = 7
		wait_frames(20)
		event.set_character_visible(15, 0, 1, 0.033333335)
		event.set_wind(-1)
		at = 8
		wait_frames(20)
		event.set_object_sequence_motion(0, "爆発戻り", 6)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		event.set_object_sequence_motion(1, "もどり", 6)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		at = 9
		wait_objects(1)
		at = 10
		wait_frames(6)
		event.set_object_sequence_motion(1, "走り")
		event.delay_object_sequence_motion_track(1, 46)
		event.set_object_sequence_motion(1, "立ち")
		event.move_object_sequence(1, 10.0, 0.0, -30.0, 50)
		event.delay_object_sequence_rotation_track(1, 46)
		event.rotate_object_sequence(1, 0.0, -2.78, 0.0, 10)
		at = 11
		wait_frames(10)
		event.set_object_sequence_motion(0, "走り")
		event.delay_object_sequence_motion_track(0, 46)
		event.set_object_sequence_motion(0, "立ち")
		event.move_object_sequence(0, -10.0, 0.0, -30.0, 50)
		event.delay_object_sequence_rotation_track(0, 46)
		event.rotate_object_sequence(0, 0.0, 2.9, 0.0, 10)
		at = 12
		wait_frames(15)
		event.set_camera_sequence_position(13.0, 9.86, -79.62)
		event.set_camera_sequence_look_at(13.0, 12.67, -39.5)
		event.move_camera_sequence_eased(0.0, 9.86, -79.62, 0.0, 12.67, -39.5, 60, 2, 1.0)
		event.play_music(0)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "おこり顔")
		event.set_object_handle_texture_animation(1, 1, "おこり目パチ")
		event.set_object_sequence_position(2, 13.0, 0.0, -50.0)
		event.reset_object_sequence_dynamic_animation(2)
		at = 13
		wait_objects(1)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "おこり顔")
		event.set_object_handle_texture_animation(1, 1, "おこり目～こまり目下")
		event.play_sound_effect(var1, 3)
		event.set_object_sequence_motion(1, "しゃがみ", 6)
		event.queue_object_sequence_next_motion(1, "しゃがみL", 4)
		at = 14
		wait_objects(0)
		event.set_object_sequence_motion(0, "しゃがむ", 6)
		event.queue_object_sequence_next_motion(0, "しゃがむL", 4)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "くるし顔")
		event.set_object_handle_texture_animation(2, 1, "目とじ～目あけ")
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 15
		helper_4116e6bb(5360010)
		event.set_mouth_texture_animations(2, "くるし口パク")
		at = 16
		helper_4116e6bb(5360020)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "くるし顔")
		event.set_object_handle_texture_animation(2, 1, "目あけ～目とじ")
		event.set_object_sequence_motion(2, "ぐふっ", 2)
		event.queue_object_sequence_next_motion(2, "倒れ", 4)
		event.set_mouth_texture_animations(2, "くるし口パク")
		at = 17
		helper_4116e6bb(5360025)
		at = 18
		helper_4bd79732(5360030, -1)
		at = 19
		wait_camera()
		event.set_camera_sequence_position(16.76, 57.33, -49.41)
		event.set_camera_sequence_look_at(4.01, 12.67, -49.87)
		event.move_camera_sequence_eased(11.95, 41.94, -49.58, 4.01, 12.67, -49.87, 150, 2, 1.0)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "くるし顔")
		event.set_object_handle_texture_animation(2, 1, "くるし目～くるし目２")
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "こまり顔")
		event.set_object_handle_texture_animation(1, 1, "こまり目パチ")
		event.set_mouth_texture_animations(2, "くるし口パク")
		at = 20
		helper_4116e6bb(5360040)
		event.set_mouth_texture_animations(2, "くるし口パク")
		at = 21
		helper_4116e6bb(5360045)
		at = 22
		wait_camera()
		event.play_sound_effect(var1, 4)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "くるし顔")
		event.set_object_handle_texture_animation(2, 1, "くるし目２～通常目")
		event.set_object_handle_texture_animation(2, 1, "わらい口")
		event.set_object_sequence_motion(2, "モニカ見", 2)
		event.queue_object_sequence_next_motion(2, "モニカ見L", 4)
		at = 23
		wait_objects(2)
		at = 24
		wait_frames(60)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "こまり顔")
		event.set_object_handle_texture_animation(1, 1, "こまり目パチ")
		event.set_object_handle_texture_animation(1, 1, "口とじ～大口")
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "わらい顔")
		event.set_object_handle_texture_animation(2, 1, "ゆっくり目とじ")
		event.play_sound_effect(var1, 5)
		event.set_object_sequence_motion(2, "死に", 2)
		event.wait_object_sequence_motion_end(2)
		at = 25
		wait_objects(2)
		at = 26
		wait_frames(60)
		event.set_camera_sequence_position(-6.98, 9.03, -75.58)
		event.set_camera_sequence_look_at(0.96, 12.16, -49.21)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "こまり顔")
		event.set_object_handle_texture_animation(1, 1, "目あき～目とじ")
		event.set_mouth_texture_animations(1, "通常口パク")
		at = 27
		helper_4116e6bb(5360050)
		event.set_camera_sequence_position(-0.18, 28.97, 146.9)
		event.set_camera_sequence_look_at(9.44, 29.01, 60.59)
		event.move_camera_sequence(-2.36, 28.97, 166.44, 9.44, 29.01, 60.59, 150)
		event.play_sound_effect(var1, 6)
		event.set_character_active(1, 16)
		event.set_character_position(16, 0.0, 0.0, -50.0)
		event.set_character_rotation(16, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(4, "発動・ギル光の粒", 6)
		event.queue_object_sequence_next_motion(4, "ループ・ギル光の粒", 4)
		event.fade_out_music(150)
		at = 28
		wait_frames(30)
		event.fade_out_screen(120, 255, 255, 255)
		at = 29
		wait_frames(120)
	end, function(received: { any }): boolean
		if at <= 1 then
			local _ = active_chr_no == 2
			active_chr_no = 0
			local _ = active_chr_no == 3
			active_chr_no = 1
			wait_frames_skipping(4)
		end
		if at <= 2 then
			wait_frames_skipping(80)
		end
		if at <= 3 then
			helper_344d6cd8()
		end
		if at <= 4 then
			helper_238b5abc(1)
		end
		if at <= 5 then
			wait_frames_skipping(20)
		end
		if at <= 6 then
			wait_frames_skipping(20)
		end
		if at <= 7 then
			wait_frames_skipping(20)
		end
		if at <= 8 then
			helper_238b5abc(1)
		end
		if at <= 9 then
			wait_frames_skipping(6)
		end
		if at <= 10 then
			wait_frames_skipping(10)
		end
		if at <= 11 then
			wait_frames_skipping(15)
		end
		if at <= 12 then
			helper_238b5abc(1)
		end
		if at <= 13 then
			helper_238b5abc(0)
		end
		if at <= 14 then
			helper_8cd371d7(5360010)
		end
		if at <= 15 then
			helper_8cd371d7(5360020)
		end
		if at <= 16 then
			helper_8cd371d7(5360025)
		end
		if at <= 17 then
			helper_ec06cf84(5360030, -1)
		end
		if at <= 18 then
			helper_344d6cd8()
		end
		if at <= 19 then
			helper_8cd371d7(5360040)
		end
		if at <= 20 then
			helper_8cd371d7(5360045)
		end
		if at <= 21 then
			helper_344d6cd8()
		end
		if at <= 22 then
			helper_238b5abc(2)
		end
		if at <= 23 then
			wait_frames_skipping(60)
		end
		if at <= 24 then
			helper_238b5abc(2)
		end
		if at <= 25 then
			wait_frames_skipping(60)
		end
		if at <= 26 then
			helper_8cd371d7(5360050)
		end
		if at <= 27 then
			wait_frames_skipping(30)
		end
		if at <= 28 then
			wait_frames_skipping(120)
		end
		return true
	end)
	at = 30
	vm.entry(30)
	event.cancel_drama_scene_skip()
	event.stop_music(0)
	event.set_scene_status_flags(1, 0, 256, 0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
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
	event.delete_event_image(0)
	event.load_message_file(0, -1)
	event.show_dungeon_status_bar(1, 1.0)
	event.set_object_handle_visible(4, 1)
	event.set_object_handle_visible(5, 1)
end

return helper_724a67a8
