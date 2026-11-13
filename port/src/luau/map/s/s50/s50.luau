--!strict
--- Runs the secret room on its dungeon floor: the research note, the vase puzzle, the door to the next floor and the sun scene.

local vm = require("@lib/vm")
local camera = require("@lib/event/camera")
local character = require("@lib/event/character")
local cutscene = require("@lib/event/cutscene")
local dungeon = require("@lib/event/dungeon")
local message = require("@lib/event/message")
local object = require("@lib/event/object")
local wait = require("@lib/event/wait")

--- Stops the music, loads the room sounds, opens the revealed passage when its save flag is set and hides the other characters.
local function set_up_secret_room()
	local passage_revealed_flag: s32 = 0
	event.stop_music(0)
	event.load_map_sounds(7686)
	passage_revealed_flag = event.get_save_flag(708) or passage_revealed_flag
	if passage_revealed_flag == 1 then
		event.set_function_point_enabled("", "e708", 0)
		event.attach_object_handle_to_map_part_2(0, "p06s50")
		event.set_object_handle_visible(0, 1)
		event.attach_object_handle_to_map_part_2(0, "p04s50")
		event.set_object_handle_rotation(0, 0.0, -1.22, 0.0)
		event.attach_object_handle_to_map_part_2(1, "p05s50")
		event.set_object_handle_rotation(1, 0.0, 1.22, 0.0)
	end
	event.set_dungeon_pause_flags(8192, 1)
	event.set_character_change_unmasked(2, 0)
	event.set_character_change_unmasked(3, 0)
	event.set_save_control_bits(1, 1)
	event.set_character_visible(1, 0)
	event.set_character_visible(2, 0)
end

--- Asks the player to confirm leaving the room and fades out on a yes, or refuses with a spoken line for the guest characters.
local function confirm_leaving_room(question_message: s32)
	local active_chr_no: s32 = 0
	local answer: any = 0
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.set_character_motion(0, "立ち")
		active_chr_no = event.get_playable_character() or active_chr_no
		if active_chr_no == 2 or active_chr_no == 3 then
			event.set_message_window_mode(0, 1)
			event.set_message_draw_speed(0, 1)
			if active_chr_no == 2 then
				at = 1
				message.show_and_wait(0, 20, 5, 256, 208)
			else
				at = 2
				message.show_and_wait(0, 21, 5, 256, 208)
			end
			event.finish_event()
			return 0
		end
		at = 3
		answer = message.ask_yes_no(question_message, -1)
		if answer == 0 then
			event.fade_out_screen(30)
			at = 4
			wait.for_frame_count(30)
			event.finish_event()
			return 1
		end
		event.finish_event()
		return 0
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				message.show_and_wait_skipping(0, 21, 5, 256, 208)
			end
			return 0
		end
		if at <= 4 then
			if at == 3 then
				answer = received[1] :: number
			end
			if at <= 3 then
				wait.skip_frame_count(30)
			end
			return 1
		end
		return nil
	end)
end

--- Plays the scene where Andrea and the sun appear and sets the save flag that reveals the passage.
local function play_andrea_sun_scene()
	local first_sound_handle: s32 = 0
	local active_chr_no: s32 = 0
	local second_sound_handle: s32 = 0
	vm.section(function()
		vm.entry(1)
		event.set_save_flag(708, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.stop_music(0)
		wait.for_frame_count(4)
		event.load_music(113)
		event.play_music(0)
		event.load_map_sounds(7818)
		first_sound_handle = event.load_sound_effect_file_2(7818) or first_sound_handle
		event.play_sound_effect(first_sound_handle, 0)
		event.stop_sound_effect(first_sound_handle, 0)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		active_chr_no = event.get_playable_character() or active_chr_no
		event.set_scene_status_flags(1, 0, 256, 1)
		event.change_directory("event/e700/e708/")
		event.load_message_file(0, 5, "e708.txt")
		if active_chr_no == 0 then
			event.load_character_motion_pack(5, "e708_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if active_chr_no == 1 then
			event.load_character_motion_pack(5, "e708_monica.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.load_character(5, "e708_andrea.gltf", "info", 10)
		event.set_character_active(10)
		event.attach_object_handle_to_character(2, 10)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.load_character(5, "e708_sun.gltf", "info", 11)
		event.set_character_active(11)
		event.attach_object_handle_to_character(3, 11)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.load_character(5, "kaisou_waku.gltf", "info", 12)
		event.set_character_active(0, 12)
		event.attach_object_handle_to_character(7, 12)
		event.clear_object_sequence(7)
		event.set_object_sequence_object(7, 7)
		event.change_directory("")
		if active_chr_no == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 8)
			event.load_equipment_model(5, 0, 4, "info", 8)
			event.load_equipment_model(5, 0, 3, "info", 8)
			event.load_equipment_model(5, 0, 2, "info", 8, 9)
			event.load_character_motion_pack(5, "event/e700/e708/e708_mints.gltf", "info", 8)
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
			event.load_character_motion_pack(5, "event/e700/e708/e708_monica.gltf", "info", 8)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 8)
			event.attach_object_handle_to_character(1, 8)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 0)
		end
		event.set_character_active(8)
		event.set_character_active(9)
		event.attach_object_handle_to_map_part_2(4, "p04s50")
		event.clear_object_sequence(4)
		event.set_object_sequence_object(4, 4)
		event.attach_object_handle_to_map_part_2(5, "p05s50")
		event.clear_object_sequence(5)
		event.set_object_sequence_object(5, 5)
		event.attach_object_handle_to_map_part_2(6, "p06s50")
		event.clear_object_sequence(6)
		event.set_object_sequence_object(6, 6)
		event.set_object_handle_position(0, 9.54, 0.8, 502.98)
		event.set_object_handle_rotation(0, 0.0, 3.14, 0.0)
		event.set_object_handle_footstep_sound(0, 2)
		event.set_object_handle_position(1, -11.6, 0.8, 505.27)
		event.set_object_handle_rotation(1, 0.0, 3.02, 0.0)
		event.set_object_handle_footstep_sound(1, 2)
		event.set_object_handle_position(2, -17.67, -2.8, 1.78)
		event.set_object_handle_rotation(2, 0.0, 1.58, 0.0)
		event.set_object_handle_position(3, -21.32, -2.8, -26.09)
		event.set_object_handle_rotation(3, 0.0, -0.1, 0.0)
		event.set_object_handle_footstep_sound(3, 2)
		event.set_object_handle_rotation(4, 0.0, 0.0, 0.0)
		event.set_object_handle_rotation(5, 0.0, 0.0, 0.0)
		event.set_object_handle_rotation(6, 0.0, -1.57, 0.0)
		event.set_object_handle_visible(6, 1)
		event.enable_drama_skip()
		event.set_object_sequence_motion(1, "立ち", 4)
		event.set_object_sequence_motion(0, "立ち", 4)
		event.set_object_sequence_motion(2, "花いけ立ち", 4)
		event.set_object_sequence_motion(3, "立ち", 4)
		event.reset_object_sequence_dynamic_animation(3)
		event.set_character_active(0)
		event.set_character_active(8)
		event.set_character_active(9)
		event.set_character_active(10)
		event.set_character_active(11)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-89.69, 118.46, -108.66)
		event.set_camera_sequence_look_at(-1.67, 30.09, -7.9)
		event.set_character_active(12)
		event.set_scene_character_type(12, 4)
		event.keep_character_in_front_of_camera_sequence(12, 600.7, -1)
		event.play_sound_effect(first_sound_handle, 1)
		event.fade_in_screen(30)
		wait.for_frame_count(30)
		event.set_object_sequence_motion(2, "花いけから立ち", 6)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		wait.for_frame_count(30)
		event.set_object_sequence_texture_animation(3, 0)
		event.set_object_sequence_texture_animation(3, 1, "こまり目パチ")
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(2, 1, "通常目パチ")
		event.set_camera_sequence_position(29.44, 24.13, 17.48)
		event.set_camera_sequence_look_at(-22.52, 17.78, -11.7)
		message.show_voiced_for_stopping(7080010, -1)
		wait.for_frame_count(30)
		event.delay_object_sequence_texture_animation_track(2, 10)
		event.set_object_sequence_texture_animation(2, 1, "わらい口パク")
		event.delay_object_sequence_texture_animation_track(2, 60)
		event.set_object_sequence_texture_animation(2, 0, "わらい口パク")
		message.show_voiced_for_stopping(7080020, 60)
		wait.for_frame_count(60)
		event.set_object_sequence_texture_animation(3, 0)
		event.set_object_sequence_texture_animation(3, 1, "目あき～目とじ")
		event.set_object_sequence_motion(3, "うつむく", 6)
		event.queue_object_sequence_next_motion(3, "うつむくＬ", 4)
		message.show_voiced_for_stopping(7080030, -1)
		wait.for_frame_count(30)
		event.set_object_sequence_motion(3, "うつむき会話", 4)
		event.delay_object_sequence_motion_track(3, 120)
		event.queue_object_sequence_next_motion(3, "うつむくＬ", 4)
		message.show_voiced_for_stopping(7080035, -1)
		wait.for_frame_count(30)
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(2, 1, "目あき～目とじ")
		event.delay_object_sequence_texture_animation_track(2, 20)
		event.set_object_sequence_texture_animation(2, 1, "わらい口パク")
		event.delay_object_sequence_texture_animation_track(2, 60)
		event.set_object_sequence_texture_animation(2, 0, "わらい口パク")
		message.show_voiced_for_stopping(7080040, -1)
		wait.for_frame_count(30)
		event.set_object_sequence_motion(3, "うつむく戻り", 6)
		event.queue_object_sequence_next_motion(3, "立ち", 4)
		event.set_object_sequence_texture_animation(3, 0)
		event.set_object_sequence_texture_animation(3, 1, "目とじ～目あき")
		message.show_voiced_for_stopping(7080050, 60)
		wait.for_frame_count(30)
		event.set_camera_sequence_position(-48.47, 12.55, -42.34)
		event.set_camera_sequence_look_at(-10.84, 19.04, -6.38)
		event.set_object_sequence_motion(2, "振り向く", 6)
		event.queue_object_sequence_next_motion(2, "振り向くＬ", 4)
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(2, 1, "目とじ～目あき")
		event.delay_object_sequence_texture_animation_track(2, 10)
		event.set_object_sequence_texture_animation(2, 1, "わらい口パク")
		event.delay_object_sequence_texture_animation_track(2, 60)
		event.set_object_sequence_texture_animation(2, 0, "わらい口パク")
		message.show_voiced_for_stopping(7080060, -1)
		wait.for_frame_count(30)
		object.wait_until_done(2)
		event.set_camera_sequence_position(-23.78, 29.48, -7.12)
		event.set_camera_sequence_look_at(-20.7, 6.84, -39.22)
		wait.for_frame_count(45)
		event.set_object_sequence_motion(3, "会話", 6)
		event.queue_object_sequence_next_motion(3, "立ち", 4)
		event.set_object_sequence_texture_animation(3, 0)
		event.set_object_sequence_texture_animation(3, 1, "通常目パチ")
		message.show_voiced_for_stopping(7080070, -1)
		wait.for_frame_count(30)
		event.set_camera_sequence_position(-48.47, 12.55, -42.34)
		event.set_camera_sequence_look_at(-10.84, 19.04, -6.38)
		event.set_object_sequence_motion(3, "正面向き立ち")
		event.play_sound_effect(first_sound_handle, 2)
		event.set_object_sequence_motion(2, "立ちからしゃがむ", 6)
		event.queue_object_sequence_next_motion(2, "しゃがむ会話", 6)
		wait.for_frame_count(20)
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(2, 1, "通常目パチ")
		event.delay_object_sequence_texture_animation_track(2, 10)
		event.set_object_sequence_texture_animation(2, 1, "わらい口パク")
		event.delay_object_sequence_texture_animation_track(2, 180)
		event.set_object_sequence_texture_animation(2, 0, "わらい口パク")
		message.show_voiced_for_stopping(7080080, -1)
		wait.for_frame_count(30)
		object.wait_until_done(2)
		event.set_object_sequence_motion(2, "しゃがみから立ち", 6)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		event.play_sound_effect(first_sound_handle, 3)
		event.set_camera_sequence_position(-20.65, 17.48, -24.48)
		event.set_camera_sequence_look_at(-16.7, 25.56, 1.9)
		event.set_object_sequence_motion(3, "立ち", 4)
		object.wait_until_done(2)
		wait.for_frame_count(20)
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(2, 1, "目あき～目とじ")
		event.delay_object_sequence_texture_animation_track(2, 10)
		event.set_object_sequence_texture_animation(2, 1, "わらい口パク")
		event.delay_object_sequence_texture_animation_track(2, 150)
		event.set_object_sequence_texture_animation(2, 0, "わらい口パク")
		message.show_voiced_for_stopping(7080090, -1)
		event.set_object_sequence_motion(2, "ちょっと上向く", 6)
		event.queue_object_sequence_next_motion(2, "ちょっと上向くＬ", 4)
		wait.for_frame_count(20)
		event.delay_object_sequence_texture_animation_track(2, 10)
		event.set_object_sequence_texture_animation(2, 1, "わらい口パク")
		event.delay_object_sequence_texture_animation_track(2, 210)
		event.set_object_sequence_texture_animation(2, 0, "わらい口パク")
		message.show_voiced_for_stopping(7080100, -1)
		wait.for_frame_count(30)
		event.set_camera_sequence_position(-23.78, 29.48, -7.12)
		event.set_camera_sequence_look_at(-20.7, 6.84, -39.22)
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(2, 1, "目とじ～目あき")
		event.set_mouth_texture_animations(2, "わらい口パク")
		wait.for_frame_count(20)
		message.show_voiced_for_stopping(7080110, 60)
		event.set_camera_sequence_position(-20.65, 17.48, -24.48)
		event.set_camera_sequence_look_at(-16.7, 25.56, 1.9)
		event.set_object_sequence_motion(2, "左見る", 6)
		event.queue_object_sequence_next_motion(2, "左見るＬ", 4)
		wait.for_frame_count(20)
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(2, 1, "通常目パチ")
		event.delay_object_sequence_texture_animation_track(2, 10)
		event.set_object_sequence_texture_animation(2, 1, "わらい口パク")
		event.delay_object_sequence_texture_animation_track(2, 90)
		event.set_object_sequence_texture_animation(2, 0, "わらい口パク")
		message.show_voiced_for_stopping(7080120, -1)
		wait.for_frame_count(30)
		message.show_voiced_for_stopping(7080130, 60)
		event.set_object_sequence_motion(2, "左見るから立ち", 6)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(2, 1, "目あき～目とじ")
		event.delay_object_sequence_texture_animation_track(2, 10)
		event.set_object_sequence_texture_animation(2, 1, "わらい口パク")
		event.delay_object_sequence_texture_animation_track(2, 120)
		event.set_object_sequence_texture_animation(2, 0, "わらい口パク")
		message.show_voiced_for_stopping(7080140, -1)
		wait.for_frame_count(20)
		event.delay_object_sequence_texture_animation_track(2, 10)
		event.set_object_sequence_texture_animation(2, 1, "わらい口パク")
		event.delay_object_sequence_texture_animation_track(2, 90)
		event.set_object_sequence_texture_animation(2, 0, "わらい口パク")
		message.show_voiced_for_stopping(7080150, -1)
		object.wait_until_done(2)
		wait.for_frame_count(30)
		event.set_object_sequence_motion(2, "身体ごと向く", 6)
		event.queue_object_sequence_next_motion(2, "身体ごと向くＬ", 4)
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(2, 1, "目とじ～目あき")
		event.delay_object_sequence_texture_animation_track(2, 10)
		event.set_object_sequence_texture_animation(2, 1, "わらい口パク")
		event.delay_object_sequence_texture_animation_track(2, 90)
		event.set_object_sequence_texture_animation(2, 0, "わらい口パク")
		message.show_voiced_for_stopping(7080160, -1)
		wait.for_frame_count(20)
		event.delay_object_sequence_texture_animation_track(2, 10)
		event.set_object_sequence_texture_animation(2, 1, "わらい口パク")
		event.delay_object_sequence_texture_animation_track(2, 120)
		event.set_object_sequence_texture_animation(2, 0, "わらい口パク")
		message.show_voiced_for_stopping(7080165, -1)
		object.wait_until_done(2)
		wait.for_frame_count(20)
		event.set_camera_sequence_position(-23.78, 29.48, -7.12)
		event.set_camera_sequence_look_at(-20.7, 6.84, -39.22)
		wait.for_frame_count(20)
		message.show_voiced_for_stopping(7080170, 60)
		wait.for_frame_count(30)
		event.fade_out_music(30)
		event.play_sound_effect(first_sound_handle, 1)
		event.fade_out_screen(30, 255, 255, 255)
		wait.for_frame_count(15)
		event.set_character_active(0, 12)
		event.set_object_sequence_position(1, -8.49, -1.96, 108.26)
		event.set_object_sequence_position(0, 10.48, -1.96, 111.88)
		event.set_object_sequence_motion(1, "立ち", 4)
		event.set_object_sequence_motion(0, "立ち", 4)
		wait.for_frame_count(15)
		event.stop_sound_effect(first_sound_handle, 1)
		event.load_map_sounds(7819)
		second_sound_handle = event.load_sound_effect_file_2(7819) or second_sound_handle
		event.fade_in_screen(30)
		event.set_object_sequence_position(2, -8.49, -1000.0, 108.26)
		event.set_object_sequence_position(3, 10.48, -1000.0, 111.88)
		event.set_camera_sequence_position(-14.02, 13.72, 63.77)
		event.set_camera_sequence_look_at(7.42, 21.78, 134.93)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おどろき顔")
		event.set_object_sequence_texture_animation(0, 1, "まばたき目パチ")
		event.set_object_sequence_texture_animation(0, 1, "半口")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おどろき顔")
		event.set_object_sequence_texture_animation(1, 1, "おどろき目パチ")
		event.set_object_sequence_texture_animation(1, 1, "半口")
		wait.for_frame_count(60)
		event.set_camera_sequence_position(0.05, 16.14, 284.86)
		event.set_camera_sequence_look_at(1.57, 67.05, -251.65)
		event.play_sound_effect(second_sound_handle, 4)
		event.rotate_object_sequence_eased(4, 0.0, -1.22, 0.0, 60, 1, 0.7)
		event.rotate_object_sequence_eased(5, 0.0, 1.22, 0.0, 60, 1, 0.7)
		wait.for_frame_count(90)
		event.fade_out_screen(30)
		wait.for_frame_count(30)
	end)
	vm.entry(57)
	event.cancel_drama_scene_skip()
	event.stop_music(0)
	event.set_object_handle_rotation(6, 0.0, 0.0, 0.0)
	event.set_object_handle_rotation(4, 0.0, -1.22, 0.0)
	event.set_object_handle_rotation(5, 0.0, 1.22, 0.0)
	event.set_character_active(0)
	event.set_character_active(8)
	event.set_character_active(9)
	event.set_scene_status_flags(1, 0, 256, 0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.delete_character_extension_packs(0)
	event.delete_character(8)
	event.delete_character(9)
	event.delete_character(10)
	event.delete_character(11)
	event.delete_character(12)
	event.load_message_file(0, -1)
end

local script: { [any]: (...any) -> ...any } = {}

--- Does nothing at load time.
function script.setup() end

--- Shows Max's idea search or Monica's monster research note after reading the book.
function script.show_research_note()
	local playable_character: s32 = 0
	event.set_character_motion(0, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.set_message_draw_speed(0, 1)
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 0 then
		event.open_message_window_2(
			0,
			"―ユリスの発明ネタ調査―\nユリスは本を読んで\n　●武器\n　●月の柱\n　●鹿のツノ\nの３つによって何かが発明できると直感した！"
		)
	else
		event.open_message_window_2(
			0,
			"―モニカのモンスター調査―\nモニカはそこに記されている内容から\n『ダイヤ』は\n『ダイヤモンド』に目がないことを知った。"
		)
	end
	message.show_and_wait(0, -1, 8, 0, 0)
end
script[0] = script.show_research_note

script.set_up_secret_room = set_up_secret_room
script[99] = script.set_up_secret_room

--- Sets up the room, places the character and camera in front of the door and fades in.
function script.default_event()
	set_up_secret_room()
	character.place_standing_and_reset_cloth(0.0, 0.0, 200.0, vm.f32(3.14))
	event.set_camera_look_at(0.0, 30.0, 200.0)
	event.set_camera_position(0.0, 40.0, 320.0)
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
	event.finish_event()
end

--- Resets the event and shakes the camera briefly.
function script.key_open()
	event.initialize_event()
	event.clear_camera_sequence()
	event.shake_camera_sequence(0.0, 1.0, 0.0, 16)
	camera.wait_until_done()
end

--- Leaves the room for the dungeon when the scene confirmation succeeds.
function script.leave_room_to_dungeon()
	if confirm_leaving_room(2) ~= 0 then
		event.set_character_visible(1, 1)
		event.set_character_visible(2, 1)
		event.set_dungeon_pause_flags(8192, 0)
		event.reset_action_character_motion(0)
		event.set_character_change_unmasked(2, 1)
		event.set_character_change_unmasked(3, 1)
		event.set_save_control_bits(1, 0)
		event.load_event_script("d06/d06.stb", 1000)
	end
end
script[200] = script.leave_room_to_dungeon

--- Descends to the next floor through the door once the passage is revealed, or says the door is shut.
function script.enter_door_to_next_floor()
	local passage_revealed_flag: s32 = 0
	local stage_id: s32 = 0
	local floor: s32 = 0
	local next_floor: s32 = 0
	passage_revealed_flag = event.get_save_flag(708) or passage_revealed_flag
	if passage_revealed_flag == 1 then
		if confirm_leaving_room(1) ~= 0 then
			stage_id = event.get_dungeon_stage_id() or stage_id
			floor = event.get_dungeon_floor() or floor
			next_floor = event.get_dungeon_next_floor(floor, 0) or next_floor
			event.set_dungeon_floor(next_floor)
			event.set_dungeon_floor_info(stage_id, floor, 5, 2)
			event.set_dungeon_floor_info(stage_id, next_floor, 5, 1)
			event.set_character_visible(1, 1)
			event.set_character_visible(2, 1)
			event.set_dungeon_pause_flags(8192, 0)
			event.reset_action_character_motion(0)
			event.set_character_change_unmasked(2, 1)
			event.set_character_change_unmasked(3, 1)
			event.set_save_control_bits(1, 0)
			event.load_event_script("d06/d06.stb", 1000)
		end
	else
		event.set_message_window_mode(0, 1)
		event.set_message_bubble_tail(0, 0)
		event.set_character_motion(0, "立ち")
		event.open_message_window_2(
			0,
			"　　　扉はかたく閉ざされている。\nこの部屋には何か秘密が在るのだろうか？"
		)
		message.show_and_wait(0, -1, 5, 0, 0)
	end
end
script[210] = script.enter_door_to_next_floor

--- Handles the strange flower vase, using the item menu and playing the sun scene when the right item is used.
function script.examine_flower_vase()
	local playable_character: s32 = 0
	local interaction_stage: s32 = 0
	local item: s32 = 0
	local answer: s32 = 0
	local checkpoint: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.set_character_motion(0, "立ち")
		playable_character = event.get_playable_character() or playable_character
		if playable_character == 2 or playable_character == 3 then
			event.set_message_window_mode(0, 1)
			event.set_message_draw_speed(0, 1)
			if playable_character == 2 then
				checkpoint = 1
				message.show_and_wait(0, 22, 5, 256, 208)
			else
				checkpoint = 2
				message.show_and_wait(0, 23, 5, 256, 208)
			end
			event.finish_event()
			return
		end
		interaction_stage = event.get_triggered_event_data_2(6) or interaction_stage
		if interaction_stage == 1 then
			event.set_message_window_mode(0, 1)
			event.set_message_bubble_tail(0, 0)
			event.open_message_window_2(0, "不思議な花びんがある。\n（(#)ボタンでメニューを開く）")
			checkpoint = 3
			answer = message.ask_confirmation(0, -1, 5, 256, 208, answer)
			if answer == 1 then
				interaction_stage = 2
			end
		end
		if interaction_stage == 2 then
			event.open_use_item_menu(374)
			checkpoint = 4
			vm.wait(4)
			item = vmhost.used_item() or item
			if item > 0 then
				if item == 374 then
					event.show_dungeon_status_bar(0, 1.0)
					event.attach_object_handle_to_map_part_2(0, "p06s50")
					event.set_object_handle_visible(0, 1)
					event.set_function_point_enabled("", "e708", 0)
					event.set_function_point_enabled("", "next_floor", 1)
					event.fade_out_screen(3, 255, 255, 255)
					checkpoint = 5
					wait.for_frame_count(3)
					event.fade_in_screen(8)
					checkpoint = 6
					wait.for_frame_count(10)
					event.fade_out_screen(3, 255, 255, 255)
					checkpoint = 7
					wait.for_frame_count(3)
					event.fade_in_screen(8)
					checkpoint = 8
					wait.for_frame_count(20)
					event.fade_out_screen(30, 255, 255, 255)
					checkpoint = 9
					wait.for_frame_count(30)
					checkpoint = 10
					play_andrea_sun_scene()
					character.place_standing_and_reset_cloth(30.0, vm.f32(-2.8), -80.0, vm.f32(3.14))
					event.set_camera_look_at(30.0, 27.2, -80.0)
					event.set_camera_position(30.0, 37.2, 40.0)
					event.reset_follow_camera(0)
					event.fade_in_screen(10)
					event.finish_event()
					return
				else
					checkpoint = 11
					character.shake_head()
				end
			end
		end
		return
	end, function(received: { any })
		if checkpoint <= 2 then
			if checkpoint <= 1 then
				message.show_and_wait_skipping(0, 23, 5, 256, 208)
			end
			return 0
		end
		if checkpoint <= 10 then
			if checkpoint == 3 then
				answer = received[2] :: number
			end
			if checkpoint <= 3 then
				local _ = interaction_stage == 1
				interaction_stage = 2
			end
			if checkpoint <= 4 then
				wait.skip_frame_count(3)
			end
			if checkpoint <= 5 then
				wait.skip_frame_count(10)
			end
			if checkpoint <= 6 then
				wait.skip_frame_count(3)
			end
			if checkpoint <= 7 then
				wait.skip_frame_count(20)
			end
			if checkpoint <= 8 then
				wait.skip_frame_count(30)
			end
			if checkpoint <= 9 then
				checkpoint = 10
				play_andrea_sun_scene()
				return vm.continue_with(function()
					character.place_standing_and_reset_cloth(30.0, vm.f32(-2.8), -80.0, vm.f32(3.14))
					event.set_camera_look_at(30.0, 27.2, -80.0)
					event.set_camera_position(30.0, 37.2, 40.0)
					event.reset_follow_camera(0)
					event.fade_in_screen(10)
					event.finish_event()
					return
				end)
			end
			cutscene.ignore_coordinates(30.0, vm.f32(-2.8), -80.0, vm.f32(3.14))
			return 0
		end
		if checkpoint <= 11 then
			return 0
		end
		return nil
	end)
end
script[500] = script.examine_flower_vase

--- Runs the defeat sequence with a silent message when the party is defeated.
function script.on_player_defeated()
	dungeon.run_defeat_sequence_silent(0)
end
script[1200] = script.on_player_defeated

--- Hides the party characters and plays the Andrea sun scene.
function script.cutscene_andrea_sun()
	event.set_character_visible(1, 0)
	event.set_character_visible(2, 0)
	event.show_dungeon_status_bar(0, 1.0)
	play_andrea_sun_scene()
end
script[17080] = script.cutscene_andrea_sun

return script
