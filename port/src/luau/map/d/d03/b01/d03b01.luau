--!strict
--- Event scripts for the map before the Starlight Canyon boss dungeon, covering the Lin cutscenes, the georama edit hand-off and the jump to the next dungeon map.

local vm = require("@lib/vm")
local camera = require("@lib/event/camera")
local character = require("@lib/event/character")
local cutscene = require("@lib/event/cutscene")
local dungeon = require("@lib/event/dungeon")
local map = require("@lib/event/map")
local message = require("@lib/event/message")
local object = require("@lib/event/object")
local wait = require("@lib/event/wait")

local max_slot: s32 = 0
local monica_slot: s32 = 0
local event_356_max_slot: s32 = 0
local event_356_monica_slot: s32 = 0

--- Shows the continued recap text of event 356, the defeat of Gilton and the farewell to Crest, in a message window between fades.
local function show_event_356_recap()
	event.initialize_event()
	event.set_message_window_mode(0, 0)
	event.fade_in_screen(30)
	event.open_message_window_2(0, "Ｅ３５６　～ギルトーニ撃退・クレストとの別れ～(つづき)")
	message.show_and_wait(0, -1, 5, 0, 0)
	event.fade_out_screen(30)
	wait.for_frame_count(30)
	event.finish_event()
end

--- Plays event 348, in which the party walks with Lin and looks up before the screen fades out.
local function play_lin_look_up_scene()
	local sound_bank: s32 = 0
	local playable_character: s32 = 0
	local step: number = 0
	vm.section(function()
		step = 1
		vm.entry(1)
		event.set_save_flag(348, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.set_event_projection(524.9)
		sound_bank = event.load_sound_effect_file_2(3829) or sound_bank
		event.show_dungeon_status_bar(0, 1.0)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		playable_character = event.get_playable_character() or playable_character
		if playable_character ~= 0 or playable_character ~= 1 then
			event.switch_dungeon_main_character(0)
			event.set_playable_character(0)
			playable_character = 0
		end
		event.change_directory("event/e300/e348/")
		event.load_message_file(0, 5, "e348.txt")
		if playable_character == 0 then
			event.load_character_motion_pack(5, "e348_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if playable_character == 1 then
			event.load_character_motion_pack(5, "e348_monica.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.load_character(5, "e348_lin.gltf", "info", 11)
		event.set_character_active(11)
		event.attach_object_handle_to_character(2, 11)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.change_directory("")
		if playable_character == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 9)
			event.load_equipment_model(5, 0, 4, "info", 9)
			event.load_equipment_model(5, 0, 3, "info", 9)
			event.load_equipment_model(5, 0, 2, "info", 9, 10)
			event.load_character_motion_pack(5, "event/e300/e348/e348_mints.gltf", "info", 10)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 9)
			event.attach_object_handle_to_character(0, 9)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 0)
		else
			event.load_character(5, "chara/c02_base.gltf", "info", 9)
			event.load_equipment_model(5, 1, 4, "info", 9)
			event.load_equipment_model(5, 1, 3, "info", 9)
			event.load_equipment_model(5, 1, 2, "info", 9, 10)
			event.load_character_motion_pack(5, "event/e300/e348/e348_monica.gltf", "info", 9)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 9)
			event.attach_object_handle_to_character(1, 9)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 0)
		end
		event.set_character_active(9)
		event.set_character_active(10)
		event.attach_object_handle_to_character(3, 1)
		event.set_object_handle_visible(3, 0)
		event.attach_object_handle_to_character(4, 2)
		event.set_object_handle_visible(4, 0)
		event.set_object_handle_position(0, 1521.47, -107.28, 771.74)
		event.set_object_handle_rotation(0, 0.0, -2.88, 0.0)
		event.set_object_handle_motion(0, "歩き", 4)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(0, 1, "通常目パチ")
		event.set_object_handle_texture_animation(0, 1, "半口")
		event.set_object_handle_footstep_sound(0, 2)
		event.set_object_handle_position(1, 1505.66, -106.53, 783.49)
		event.set_object_handle_rotation(1, 0.0, 3.04, 0.0)
		event.set_object_handle_motion(1, "歩き", 4)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(1, 1, "通常目パチ")
		event.set_object_handle_texture_animation(1, 1, "半口")
		event.set_object_handle_footstep_sound(1, 2)
		event.set_object_handle_position(2, 1506.3, -108.37, 803.96)
		event.set_object_handle_rotation(2, 0.0, -3.12, 0.0)
		event.set_object_handle_motion(2, "歩き", 4)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "無表情")
		event.set_object_handle_texture_animation(2, 1, "通常目パチ")
		event.set_object_handle_texture_animation(2, 1, "半口")
		event.move_object_sequence(0, 1521.47, -107.28, 731.74, 80)
		event.move_object_sequence(1, 1505.66, -106.53, 743.49, 80)
		event.move_object_sequence(2, 1506.3, -108.37, 763.96, 80)
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(1478.0, -94.44, 748.45)
		event.set_camera_sequence_look_at(1526.09, -83.38, 795.48)
		event.move_camera_sequence(1478.0, -94.44, 708.45, 1526.09, -83.38, 755.48, 80)
		event.fade_in_screen(30)
		step = 2
		wait.for_frame_count(80)
		event.set_camera_sequence_position(1635.22, -45.35, 898.95)
		event.set_camera_sequence_look_at(1509.85, -91.47, 744.47)
		event.move_camera_sequence_eased(1635.22, -45.35, 898.95, 1509.85, 36.75, 744.47, 60, 0, 1.0)
		event.set_object_sequence_position(0, 1522.58, -104.86, 733.22)
		event.set_object_sequence_rotation(0, 0.0, -2.52, 0.0)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_object_sequence_position(1, 1508.09, -104.9, 755.07)
		event.set_object_sequence_rotation(1, 0.0, -2.76, 0.0)
		event.reset_object_sequence_dynamic_animation(1)
		event.set_object_sequence_position(2, 1536.72, -109.15, 777.79)
		event.set_object_sequence_rotation(2, 0.0, -2.68, 0.0)
		event.move_object_sequence(0, 1491.96, -99.81, 672.57, 90)
		event.move_object_sequence(1, 1473.85, -100.1, 691.32, 90)
		event.move_object_sequence(2, 1493.11, -100.84, 700.12, 90)
		step = 3
		message.show_voiced_for_stopping(3480010, 120)
		step = 4
		camera.wait_until_done()
		step = 5
		wait.for_frame_count(10)
		event.set_camera_sequence_position(1459.8, -32.33, 632.79)
		event.set_camera_sequence_look_at(1494.99, -96.61, 704.05)
		event.move_camera_sequence_eased(1475.8, -54.94, 665.2, 1494.99, -84.52, 704.05, 60, 0, 1.0)
		event.set_object_sequence_motion(0, "上向くL", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "上向くL", 4, -1.0, 1)
		event.set_object_sequence_motion(2, "上見立ち", 4)
		step = 6
		camera.wait_until_done()
		step = 7
		wait.for_frame_count(10)
		event.set_camera_sequence_position(1518.17, -76.49, 671.12)
		event.set_camera_sequence_look_at(1493.05, -78.0, 693.7)
		event.set_object_sequence_position(2, 1501.04, -100.84, 688.87)
		event.set_object_sequence_rotation(2, 0.0, -2.68, 0.0)
		event.play_sound_effect(sound_bank, 6)
		event.set_object_sequence_motion(1, "右向く", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(1, "右向くL", 4)
		step = 8
		message.show_voiced(3480020)
		event.fade_out_screen(30)
		step = 9
		wait.for_frame_count(30)
	end, function(received: { any }): boolean
		if step <= 1 then
			local _ = playable_character ~= 0
			local _ = playable_character ~= 1
			playable_character = 0
			wait.skip_frame_count(80)
		end
		if step <= 2 then
			message.show_voiced_for_stopping_skipping(3480010, 120)
		end
		if step <= 3 then
			wait.background_load_skipping()
		end
		if step <= 4 then
			wait.skip_frame_count(10)
		end
		if step <= 5 then
			wait.background_load_skipping()
		end
		if step <= 6 then
			wait.skip_frame_count(10)
		end
		if step <= 7 then
			message.show_voiced_skipping(3480020)
		end
		if step <= 8 then
			wait.skip_frame_count(30)
		end
		return true
	end)
	step = 10
	vm.entry(10)
	event.cancel_drama_scene_skip()
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.attach_object_handle_to_character(0, 1)
	event.set_object_handle_visible(0, 1)
	event.attach_object_handle_to_character(0, 2)
	event.set_object_handle_visible(0, 1)
	event.delete_character_extension_packs(0)
	event.delete_character(9)
	event.delete_character(10)
	event.delete_character(11)
	event.load_message_file(0, -1)
	event.show_dungeon_status_bar(1, 1.0)
	event.set_character_position(0, 1390.73, -76.07, 523.09)
	event.set_character_rotation(0, 0.0, -2.28, 0.0)
	event.set_character_motion(0, "立ち", 4)
	event.update_character_motion(0)
	event.reset_character_cloth_and_hair(0)
	event.reset_follow_camera(1, 3.14, 10.0)
	event.fade_in_screen(30)
	event.finish_event()
end

--- Loads the playable characters, Lin, the map part and the message file that event 356 uses.
local function load_event_356_actors()
	local playable_character: s32 = 0
	event.set_message_window_mode(0, 7)
	event.show_dungeon_status_bar(0, 1.0)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 0 then
		event_356_max_slot = 0
		event_356_monica_slot = 8
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", event_356_max_slot)
		event.load_character_motion_pack(5, "event/e300/e356/e356_mints.gltf", "info", event_356_max_slot)
		event.attach_object_handle_to_character(0, event_356_max_slot)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, event_356_max_slot)
		event.load_character(5, "chara/c02_base.gltf", "info", event_356_monica_slot)
		event.load_equipment_model(5, 1, 1, "info", event_356_monica_slot, 17)
		event.load_equipment_model(5, 1, 0, "info", event_356_monica_slot, 18)
		event.load_equipment_model(5, 1, 4, "info", event_356_monica_slot)
		event.load_equipment_model(5, 1, 3, "info", event_356_monica_slot)
		event.load_equipment_model(5, 1, 2, "info", event_356_monica_slot, 12)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", event_356_monica_slot)
		event.load_character_motion_pack(5, "event/e300/e356/e356_monica.gltf", "info", event_356_monica_slot)
		event.attach_object_handle_to_character(1, event_356_monica_slot)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, event_356_monica_slot)
		event.set_character_active(1, 12)
		event.set_character_active(0, 17)
		event.set_character_active(0, 18)
	end
	if playable_character == 1 then
		event_356_max_slot = 8
		event_356_monica_slot = 0
		event.load_character(5, "chara/c01_base.gltf", "info", event_356_max_slot)
		event.load_equipment_model(5, 0, 1, "info", event_356_max_slot, 17)
		event.load_equipment_model(5, 0, 0, "info", event_356_max_slot, 18)
		event.load_equipment_model(5, 0, 4, "info", event_356_max_slot)
		event.load_equipment_model(5, 0, 3, "info", event_356_max_slot)
		event.load_equipment_model(5, 0, 2, "info", event_356_max_slot, 12)
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", event_356_max_slot)
		event.load_character_motion_pack(5, "event/e300/e356/e356_mints.gltf", "info", event_356_max_slot)
		event.attach_object_handle_to_character(0, event_356_max_slot)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, event_356_max_slot)
		event.set_character_active(1, 12)
		event.set_character_active(0, 17)
		event.set_character_active(0, 18)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", event_356_monica_slot)
		event.load_character_motion_pack(5, "event/e300/e356/e356_monica.gltf", "info", event_356_monica_slot)
		event.attach_object_handle_to_character(1, event_356_monica_slot)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, event_356_monica_slot)
	end
	event.attach_object_handle_to_character(2, 1)
	event.set_object_handle_visible(2, 0)
	event.attach_object_handle_to_character(3, 2)
	event.set_object_handle_visible(3, 0)
	event.load_character(5, "event/e300/e356/e356_lin.gltf", "info", 9)
	event.set_character_active(0, 9)
	event.attach_object_handle_to_character(4, 9)
	event.clear_object_sequence(2, 9)
	event.set_object_sequence_object(2, 4)
	event.attach_object_handle_to_map_part_2(9, "p06_d03b01")
	event.clear_object_sequence(9)
	event.set_object_sequence_object(9, 9)
	event.set_object_handle_visible(9, 0)
	event.load_message_file(0, 5, "event/e300/e356/e356.txt")
end

--- Deletes the actors loaded for event 356, restores the status bar and finishes the event.
local function unload_event_356_actors()
	local playable_character: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 0 then
		event.set_character_active(1, event_356_max_slot)
		event.set_character_active(0, event_356_monica_slot)
		event.delete_character_extension_packs(event_356_max_slot)
		event.delete_character_extension_packs(event_356_monica_slot)
		event.delete_character(event_356_monica_slot)
		event.delete_character(12)
		event.delete_character(17)
		event.delete_character(18)
	end
	if playable_character == 1 then
		event.set_character_active(1, event_356_monica_slot)
		event.set_character_active(0, event_356_max_slot)
		event.delete_character_extension_packs(event_356_max_slot)
		event.delete_character_extension_packs(event_356_monica_slot)
		event.delete_character(event_356_max_slot)
		event.delete_character(12)
		event.delete_character(17)
		event.delete_character(18)
	end
	event.delete_character(9)
	event.set_scene_status_flags(1, 0, 256, 0)
	event.attach_object_handle_to_character(2, 1)
	event.set_object_handle_visible(2, 1)
	event.attach_object_handle_to_character(3, 2)
	event.set_object_handle_visible(3, 1)
	event.set_object_handle_visible(9, 0)
	event.show_dungeon_status_bar(1, 1.0)
	event.finish_event()
end

--- Plays the night cutscene in which Lin and the party talk, then cleans up and restores the time of day.
local function play_event_356_scene()
	local sound_bank: s32 = 0
	local saved_time_of_day: f32 = 0
	vm.section(function()
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.set_motion_blur(0)
		event.stop_music(0)
		event.load_map_sounds(3847)
		sound_bank = event.load_sound_effect_file_2(3847) or sound_bank
		load_event_356_actors()
		event.set_scene_status_flags(1, 0, 256, 1)
		saved_time_of_day = event.get_scene_time_of_day() or saved_time_of_day
		event.enable_drama_skip()
		event.set_time_of_day(21.0)
		event.set_time_of_day_advancing(0)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "無表情")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "無表情")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "無表情")
		event.set_object_sequence_texture_animation(2, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(2, 1, "半口")
		event.set_object_sequence_motion(0, "立ち", 4)
		event.set_object_sequence_motion(1, "立ち", 4)
		event.set_object_sequence_motion(2, "立ち", 4)
		event.set_character_active(1, event_356_max_slot)
		event.set_character_active(1, event_356_monica_slot)
		event.set_character_active(1, 9)
		event.set_object_sequence_position(2, 543.2, 144.04, -840.61)
		event.set_object_sequence_rotation(2, 0.0, 1.17, 0.0)
		event.set_object_sequence_position(1, 569.2, 139.28, -817.83)
		event.set_object_sequence_rotation(1, 0.0, -2.4, 0.0)
		event.set_object_sequence_position(0, 574.57, 140.74, -836.69)
		event.set_object_sequence_rotation(0, 0.0, -1.64, 0.0)
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(200)
		event.add_camera_sequence_path_point(698.5, 198.36, -687.33, 415.41, 488.3, -904.7)
		event.add_camera_sequence_path_point(698.5, 198.36, -687.33, 415.41, 183.45, -904.7)
		event.start_camera_sequence_path()
		event.fade_in_screen(30)
		wait.for_frame_count(230)
		event.set_camera_sequence_position(515.1, 182.78, -800.37)
		event.set_camera_sequence_look_at(557.38, 155.79, -834.03)
		event.set_object_sequence_motion(0, "下向く", 6)
		event.queue_object_sequence_next_motion(0, "下向くL", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced(3560340)
		event.reset_mouth_texture_animations()
		wait.for_frame_count(60)
		event.set_object_sequence_motion(1, "顔そむけ", 6)
		event.queue_object_sequence_next_motion(1, "顔そむけＬ", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced(3560350)
		event.reset_mouth_texture_animations()
		event.load_music(59)
		event.play_music(0)
		event.set_object_sequence_motion(1, "立ち", 4)
		event.set_object_sequence_motion(0, "立ち", 4)
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(150)
		event.add_camera_sequence_path_point(580.92, 168.28, -803.2, 557.45, 170.23, -863.66)
		event.add_camera_sequence_path_point(561.82, 168.28, -795.79, 538.36, 170.23, -856.24)
		event.start_camera_sequence_path()
		event.set_object_sequence_motion(2, "ううん", 6)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		event.set_mouth_texture_animations(4, "通常口パク")
		message.show_voiced(3560360)
		event.reset_mouth_texture_animations()
		object.wait_until_done(2)
		camera.wait_until_done()
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(150)
		event.add_camera_sequence_path_point(531.29, 159.38, -832.46, 583.97, 163.32, -843.63)
		event.add_camera_sequence_path_point(535.18, 159.38, -814.11, 587.86, 163.32, -825.29)
		event.start_camera_sequence_path()
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced(3560370)
		event.reset_mouth_texture_animations()
		camera.wait_until_done()
		event.set_camera_sequence_position(501.31, 169.51, -797.49)
		event.set_camera_sequence_look_at(551.47, 171.45, -833.25)
		event.play_sound_effect(sound_bank, 34)
		event.set_object_sequence_motion(2, "振り向く", 6)
		event.queue_object_sequence_next_motion(2, "振り向くL", 4)
		event.set_mouth_texture_animations(4, "通常口パク")
		message.show_voiced(3560380)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(2, "上向く", 6)
		event.queue_object_sequence_next_motion(2, "上向くL", 4)
		event.set_mouth_texture_animations(4, "通常口パク")
		message.show_voiced(3560385)
		event.reset_mouth_texture_animations()
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(200)
		event.add_camera_sequence_path_point(521.48, 197.33, -852.11, 539.71, 166.13, -844.52)
		event.add_camera_sequence_path_point(511.07, 215.78, -856.44, 539.71, 166.13, -844.52)
		event.start_camera_sequence_path()
		event.set_mouth_texture_animations(4, "通常口パク")
		message.show_voiced(3560390)
		event.reset_mouth_texture_animations()
		camera.wait_until_done()
		event.set_camera_sequence_position(501.31, 169.51, -797.49)
		event.set_camera_sequence_look_at(551.47, 171.45, -833.25)
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced_for_stopping(3560400, -1)
		event.reset_mouth_texture_animations()
		event.play_sound_effect(sound_bank, 35)
		event.set_object_sequence_motion(2, "向きかえる", 6)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		wait.for_frame_count(30)
		event.set_mouth_texture_animations(4, "通常口パク")
		message.show_voiced(3560410)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(4, "通常口パク")
		message.show_voiced(3560420)
		event.reset_mouth_texture_animations()
		event.play_sound_effect(sound_bank, 36)
		event.set_object_sequence_motion(1, "うなづく", 6)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced(3560430)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced(3560440)
		event.reset_mouth_texture_animations()
		wait.for_frame_count(60)
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(200)
		event.add_camera_sequence_path_point(698.5, 198.36, -687.33, 415.41, 183.45, -904.7)
		event.add_camera_sequence_path_point(698.5, 198.36, -687.33, 415.41, 488.3, -904.7)
		event.start_camera_sequence_path()
		wait.for_frame_count(170)
	end)
	event.cancel_drama_scene_skip()
	event.fade_out_screen(30)
	wait.for_frame_count(30)
	event.set_time_of_day(saved_time_of_day)
	event.set_time_of_day_advancing(1)
	event.stop_port_sound_effects(4)
	event.skip_next_music_load()
	vm.wait(23)
	unload_event_356_actors()
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
end

--- Loads the playable characters, Lin, the map part and the message file that event 352 uses.
local function load_event_352_actors()
	local playable_character: s32 = 0
	event.set_message_window_mode(0, 7)
	event.show_dungeon_status_bar(0, 1.0)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 0 then
		max_slot = 0
		monica_slot = 8
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", max_slot)
		event.load_character_motion_pack(5, "event/e300/e352/e352_mints.gltf", "info", max_slot)
		event.attach_object_handle_to_character(0, max_slot)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, max_slot)
		event.load_character(5, "chara/c02_base.gltf", "info", monica_slot)
		event.load_equipment_model(5, 1, 1, "info", monica_slot, 17)
		event.load_equipment_model(5, 1, 0, "info", monica_slot, 18)
		event.load_equipment_model(5, 1, 4, "info", monica_slot)
		event.load_equipment_model(5, 1, 3, "info", monica_slot)
		event.load_equipment_model(5, 1, 2, "info", monica_slot, 12)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", monica_slot)
		event.load_character_motion_pack(5, "event/e300/e352/e352_monica1.gltf", "info", monica_slot)
		event.attach_object_handle_to_character(1, monica_slot)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, monica_slot)
		event.set_character_active(1, 12)
		event.set_character_active(0, 17)
		event.set_character_active(0, 18)
	end
	if playable_character == 1 then
		max_slot = 8
		monica_slot = 0
		event.load_character(5, "chara/c01_base.gltf", "info", max_slot)
		event.load_equipment_model(5, 0, 1, "info", max_slot, 17)
		event.load_equipment_model(5, 0, 0, "info", max_slot, 18)
		event.load_equipment_model(5, 0, 4, "info", max_slot)
		event.load_equipment_model(5, 0, 3, "info", max_slot)
		event.load_equipment_model(5, 0, 2, "info", max_slot, 12)
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", max_slot)
		event.load_character_motion_pack(5, "event/e300/e352/e352_mints.gltf", "info", max_slot)
		event.attach_object_handle_to_character(0, max_slot)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, max_slot)
		event.set_character_active(1, 12)
		event.set_character_active(0, 17)
		event.set_character_active(0, 18)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", monica_slot)
		event.load_character_motion_pack(5, "event/e300/e352/e352_monica1.gltf", "info", monica_slot)
		event.attach_object_handle_to_character(1, monica_slot)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, monica_slot)
	end
	event.attach_object_handle_to_character(2, 1)
	event.set_object_handle_visible(2, 0)
	event.attach_object_handle_to_character(3, 2)
	event.set_object_handle_visible(3, 0)
	event.load_character(5, "event/e300/e352/e352_lin.gltf", "info", 9)
	event.set_character_active(0, 9)
	event.attach_object_handle_to_character(4, 9)
	event.clear_object_sequence(2, 9)
	event.set_object_sequence_object(2, 4)
	event.attach_object_handle_to_map_part_2(9, "p06_d03b01")
	event.clear_object_sequence(9)
	event.set_object_sequence_object(9, 9)
	event.set_object_handle_visible(9, 1)
	event.load_message_file(0, 5, "event/e300/e352/e352.txt")
end

--- Assigns both character slots for each playable character in turn, leaving the second assignment, when the cutscene is skipped before loading finishes.
local function reassign_event_352_slots()
	max_slot = 0
	monica_slot = 8
	max_slot = 8
	monica_slot = 0
end

--- Deletes the actors loaded for event 352, finishes the event and loads the boss dungeon map and its event script.
local function unload_event_352_and_enter_boss_dungeon()
	local playable_character: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 0 then
		event.set_character_active(1, max_slot)
		event.set_character_active(0, monica_slot)
		event.delete_character_extension_packs(max_slot)
		event.delete_character_extension_packs(monica_slot)
		event.delete_character(monica_slot)
		event.delete_character(12)
		event.delete_character(17)
		event.delete_character(18)
	end
	if playable_character == 1 then
		event.set_character_active(1, monica_slot)
		event.set_character_active(0, max_slot)
		event.delete_character_extension_packs(max_slot)
		event.delete_character_extension_packs(monica_slot)
		event.delete_character(max_slot)
		event.delete_character(12)
		event.delete_character(17)
		event.delete_character(18)
	end
	event.delete_character(9)
	event.attach_object_handle_to_character(2, 1)
	event.set_object_handle_visible(2, 1)
	event.attach_object_handle_to_character(3, 2)
	event.set_object_handle_visible(3, 1)
	event.set_object_handle_visible(9, 0)
	event.show_dungeon_status_bar(1, 1.0)
	event.finish_event()
	vm.wait(1)
	event.load_dungeon_map("d03b02")
	event.load_event_script("d03b02/d03b02.stb", 503)
end

--- Plays the cutscene in which the party talks and runs off, with skip handling, then enters the next dungeon map.
local function play_event_352_scene()
	local sound_bank: s32 = 0
	local saved_time_of_day: f32 = 0
	local skip_step: number = 0
	vm.section(function()
		event.set_save_flag(352, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.set_motion_blur(0)
		event.stop_music(0)
		skip_step = 1
		vm.wait(1)
		skip_step = 2
		vm.wait(2)
		skip_step = 3
		vm.wait(3)
		skip_step = 4
		vm.wait(4)
		event.load_map_sounds(3836)
		sound_bank = event.load_sound_effect_file_2(3836) or sound_bank
		load_event_352_actors()
		saved_time_of_day = event.get_scene_time_of_day() or saved_time_of_day
		event.enable_drama_skip()
		event.set_time_of_day(18.0)
		event.set_time_of_day_advancing(0)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "無表情")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "無表情")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "無表情")
		event.set_object_sequence_texture_animation(2, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(2, 1, "半口")
		event.set_object_sequence_motion(0, "立ち", 4)
		event.set_object_sequence_motion(1, "立ち", 4)
		event.set_object_sequence_motion(2, "上見立ち", 4)
		event.set_object_handle_footstep_sound(0, 2)
		event.set_object_handle_footstep_sound(1, 2)
		event.set_character_active(1, max_slot)
		event.set_character_active(1, monica_slot)
		event.set_character_active(1, 9)
		event.set_camera_sequence_position(752.46, 293.85, -635.82)
		event.set_camera_sequence_look_at(463.46, 169.14, -865.91)
		event.set_object_sequence_position(2, 543.2, 144.04, -840.61)
		event.set_object_sequence_rotation(2, 0.0, -1.99, 0.0)
		event.set_object_sequence_position(0, 553.04, 141.0, -816.53)
		event.set_object_sequence_rotation(0, 0.0, -2.4, 0.0)
		event.set_object_sequence_position(1, 564.98, 142.65, -851.46)
		event.set_object_sequence_rotation(1, 0.0, -1.64, 0.0)
		event.play_sound_effect(sound_bank, 0)
		event.fade_in_screen(30)
		skip_step = 5
		wait.for_frame_count(230)
		event.set_camera_sequence_position(485.46, 185.48, -900.58)
		event.set_camera_sequence_look_at(556.75, 169.14, -889.42)
		event.move_camera_sequence_eased(477.74, 185.48, -851.26, 549.03, 169.14, -840.1, 120, 2, 1.0)
		skip_step = 6
		camera.wait_until_done()
		event.delay_object_sequence_sound_track(1, 60)
		event.play_object_sequence_sound(1, sound_bank, 1)
		event.delay_object_sequence_motion_track(1, 60)
		event.set_object_sequence_motion(1, "左向く", 6)
		event.queue_object_sequence_next_motion(1, "左向くＬ", 4)
		event.delay_object_sequence_motion_track(0, 60)
		event.set_object_sequence_motion(0, "右向く", 6)
		event.queue_object_sequence_next_motion(0, "右向くＬ", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		skip_step = 7
		message.show_voiced(3520170)
		event.reset_mouth_texture_animations()
		skip_step = 8
		object.wait_until_done(1)
		skip_step = 9
		object.wait_until_done(0)
		event.set_object_sequence_motion(0, "右向くうなづき", 6)
		event.queue_object_sequence_next_motion(0, "右向くL", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		skip_step = 10
		message.show_voiced(3520180)
		event.reset_mouth_texture_animations()
		skip_step = 11
		object.wait_until_done(0)
		event.set_object_sequence_motion(0, "右向く戻り", 6)
		event.set_object_sequence_motion(1, "左向く戻り", 6)
		event.rotate_object_sequence(0, 0.0, -2.04, 0.0, 10)
		event.rotate_object_sequence(1, 0.0, -2.0, 0.0, 10)
		event.set_object_sequence_motion(0, "走り")
		event.set_object_sequence_motion(1, "走り", 0, -1.0, 1)
		event.move_object_sequence(0, 492.39, 147.92, -843.54, 40, 1)
		event.move_object_sequence(1, 498.64, 148.11, -878.52, 40, 1)
		skip_step = 12
		object.wait_until_done(0)
		skip_step = 13
		object.wait_until_done(1)
		event.move_camera_sequence(516.37, 181.42, -848.28, 565.24, 159.44, -832.68, 120)
		skip_step = 14
		camera.wait_until_done()
		event.set_camera_sequence_position(802.37, 193.9, -653.74)
		event.set_camera_sequence_look_at(562.44, 177.39, -814.42)
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(120)
		event.add_camera_sequence_path_point(802.37, 193.9, -653.74, 562.44, 177.39, -814.42)
		event.add_camera_sequence_path_point(802.37, 323.65, -653.74, 562.44, 307.14, -814.42)
		event.start_camera_sequence_path()
		event.move_object_sequence(0, 315.33, 250.34, -928.08, 150, 1)
		event.move_object_sequence(1, 324.09, 250.34, -964.29, 150, 1)
		skip_step = 15
		camera.wait_until_done()
	end, function(received: { any }): boolean
		if skip_step <= 4 then
			reassign_event_352_slots()
			wait.skip_frame_count(230)
		end
		if skip_step <= 5 then
			wait.background_load_skipping()
		end
		if skip_step <= 6 then
			message.show_voiced_skipping(3520170)
		end
		if skip_step <= 7 then
			cutscene.skip_command(1)
		end
		if skip_step <= 8 then
			cutscene.skip_command(0)
		end
		if skip_step <= 9 then
			message.show_voiced_skipping(3520180)
		end
		if skip_step <= 10 then
			cutscene.skip_command(0)
		end
		if skip_step <= 11 then
			cutscene.skip_command(0)
		end
		if skip_step <= 12 then
			cutscene.skip_command(1)
		end
		if skip_step <= 13 then
			wait.background_load_skipping()
		end
		if skip_step <= 14 then
			wait.background_load_skipping()
		end
		return true
	end)
	event.cancel_drama_scene_skip()
	event.fade_out_screen(30)
	skip_step = 16
	wait.for_frame_count(30)
	event.set_time_of_day(saved_time_of_day)
	event.set_time_of_day_advancing(1)
	event.stop_port_sound_effects(4)
	skip_step = 17
	vm.wait(17)
	event.skip_next_map_sound_load()
	event.skip_next_music_load()
	skip_step = 18
	unload_event_352_and_enter_boss_dungeon()
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded and does nothing.
function script.setup() end

--- Event 99, which map data, a script or the engine runs by number.
script[99] = map.disable_completed_function_points

--- Disables completed function points and walks the player in at the map entrance.
function script.default_event()
	map.disable_completed_function_points()
	cutscene.walk_in_at_entrance()
end

--- Waits a frame and then for the button press that opens the key menu.
function script.key_open()
	vm.wait(1)
	wait.until_button_pressed(32)
end

--- Event 500, which map data, a script or the engine runs by number.
-- Defined empty, so the engine runs this instead of its default.
--- Intentionally empty so the engine runs nothing for this event.
function script.do_nothing() end
script[500] = script.do_nothing

--- Shows the event 356 recap and opens the georama editor.
function script.show_event_356_recap_then_edit_georama()
	show_event_356_recap()
	event.go_to_georama_edit(1, 502)
end
script[501] = script.show_event_356_recap_then_edit_georama

--- Fades out and plays the scene in which Lin looks up.
function script.cutscene_lin_looks_up()
	local resume_step: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.set_function_point_enabled("", "e348", 0)
		character.set_idle_motion()
		event.fade_out_screen(30)
		resume_step = 1
		wait.for_frame_count(30)
		resume_step = 2
		play_lin_look_up_scene()
		return
	end, function(received: { any })
		if resume_step <= 2 then
			if resume_step <= 1 then
				resume_step = 2
				play_lin_look_up_scene()
				return vm.continue_with(function()
					return
				end)
			end
			return 0
		end
		return nil
	end)
end
script[502] = script.cutscene_lin_looks_up

--- Plays the night cutscene and then jumps to the next map.
function script.cutscene_night_talk_then_leave()
	play_event_356_scene()
	event.jump_to_map_3(-1, "g02", 502)
end
script[503] = script.cutscene_night_talk_then_leave

--- Event 504, which map data, a script or the engine runs by number.
script.play_event_352_scene = play_event_352_scene
script[504] = script.play_event_352_scene

--- Asks whether to leave the area and returns to the d03 area map when confirmed.
function script.confirm_leave_area()
	if map.confirm_leave_area() ~= 0 then
		event.load_event_script("d03/d03.stb", 1000)
	end
end
script[510] = script.confirm_leave_area

--- Runs the defeat sequence with a silent message.
function script.on_defeat()
	dungeon.run_defeat_sequence_silent(0)
end
script[1200] = script.on_defeat

--- Event 13480, which map data, a script or the engine runs by number.
script.play_lin_look_up_scene = play_lin_look_up_scene
script[13480] = script.play_lin_look_up_scene

return script
