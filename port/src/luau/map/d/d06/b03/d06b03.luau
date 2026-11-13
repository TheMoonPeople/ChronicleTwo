--!strict
--- Event script for the final Moon Flower Palace boss map, with the timed boss battle start, the conversation cutscene and the game over screen.

local vm = require("@lib/vm")
local camera = require("@lib/event/camera")
local cutscene = require("@lib/event/cutscene")
local dungeon = require("@lib/event/dungeon")
local message = require("@lib/event/message")
local object = require("@lib/event/object")
local sound = require("@lib/event/sound")
local wait = require("@lib/event/wait")

local max_slot: s32 = 0
local monica_slot: s32 = 0

--- Plays the Dark Genie introduction cutscene with its sixth title telop.
local function play_dark_genie_intro_cutscene()
	local sound_bank: s32 = 0
	local playable_character: s32 = 0
	local telop_block: s32 = 0
	vm.section(function()
		event.set_save_flag(728, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.load_map_sounds(7603)
		sound_bank = event.load_sound_effect_file_2(7603) or sound_bank
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		playable_character = event.get_playable_character() or playable_character
		event.set_scene_status_flags(1, 0, 256, 1)
		event.change_directory("event/e700/e728/")
		event.load_message_file(0, 5, "e728.txt")
		if playable_character == 0 then
			event.load_character_motion_pack(5, "e728_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if playable_character == 1 then
			event.load_character_motion_pack(5, "e728_monica.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.load_character(5, "e728_dark.gltf", "info", 10)
		event.set_character_active(10)
		event.attach_object_handle_to_character(2, 10)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		telop_block = event.load_event_image_4(5, "e728telop06.json", 0) or telop_block
		event.reset_event_sprite(0)
		event.set_event_sprite_type(0, 0)
		event.set_event_sprite_texture(0, "e728telop06", telop_block)
		event.set_event_sprite_color(0, 128, 128, 128, 0)
		event.set_event_sprite_texture_rect(0, 0, 0, 512, 128)
		event.set_event_sprite_size(0, 512, 128)
		event.set_event_sprite_position(0, 256, 312)
		event.set_event_sprite_draw_pass(0, 1)
		event.attach_object_handle_to_sprite(3, 0)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.change_directory("")
		if playable_character == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 8)
			event.load_equipment_model(5, 0, 4, "info", 8)
			event.load_equipment_model(5, 0, 3, "info", 8)
			event.load_equipment_model(5, 0, 2, "info", 8, 9)
			event.load_character_motion_pack(5, "event/e700/e728/e728_mints.gltf", "info", 8)
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
			event.load_character_motion_pack(5, "event/e700/e728/e728_monica.gltf", "info", 8)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 8)
			event.attach_object_handle_to_character(1, 8)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 0)
		end
		event.set_character_active(8)
		event.set_character_active(9)
		event.set_object_handle_position(1, -1.42, 0.0, -83.64)
		event.set_object_handle_rotation(1, 0.0, -0.12, 0.0)
		event.set_object_handle_footstep_sound(1, 2)
		event.set_object_handle_position(0, -23.19, 0.0, -81.74)
		event.set_object_handle_rotation(0, 0.0, 0.26, 0.0)
		event.set_object_handle_footstep_sound(0, 2)
		event.set_object_handle_position(2, 10.04, 99.12, 177.76)
		event.set_object_handle_rotation(2, 0.0, -3.07, 0.0)
		event.set_object_handle_footstep_sound(2, 1)
		event.set_object_sequence_scale(2, 2.0, 2.0, 2.0)
		event.enable_drama_skip()
		event.set_object_sequence_motion(1, "立ち", 4)
		event.set_object_sequence_motion(0, "立ち", 4)
		event.set_object_sequence_motion(2, "立ち", 4)
		event.set_character_active(0)
		event.set_character_active(8)
		event.set_character_active(9)
		event.set_character_active(10)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-79.96, 12.55, -243.16)
		event.set_camera_sequence_look_at(-22.0, 50.18, -66.57)
		event.fade_in_screen(30)
		wait.for_frame_count(60)
		event.fade_out_music(30)
		wait.for_frame_count(30)
		event.set_camera_sequence_position(12.3, 90.7, -58.0)
		event.set_camera_sequence_look_at(8.16, 163.3, 185.9)
		event.set_object_sequence_color(3, 128, 128, 128, 128, 30)
		event.play_sound_effect(sound_bank, 0)
		event.set_object_sequence_motion(2, "乱舞", 6)
		event.queue_object_sequence_next_motion(2, "乱舞L", 4)
		object.wait_until_done(2)
		wait.for_frame_count(30)
		event.set_object_sequence_color(3, 128, 128, 128, 0, 30)
		event.fade_out_screen(30)
		wait.for_frame_count(30)
	end)
	event.cancel_drama_scene_skip()
	event.stop_music(0)
	wait.for_frame_count(4)
	event.load_music(39)
	event.play_music(0)
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
	event.delete_event_image(0)
	event.load_message_file(0, -1)
end

--- Starts the boss battle by setting midnight, placing both monsters and starting the stopwatch.
local function start_timed_boss_battle()
	local saved_time_of_day: f32 = 0
	event.initialize_event()
	vm.wait(1)
	event.stop_music(0)
	wait.for_frame_count(4)
	event.load_music(39)
	event.play_music(0)
	saved_time_of_day = event.get_scene_time_of_day() or saved_time_of_day
	event.set_save_counter(10, saved_time_of_day)
	event.set_time_of_day(24.0)
	event.set_time_of_day_advancing(0)
	event.load_dungeon_monster(621, 1)
	event.load_dungeon_monster(622, 0)
	event.place_dungeon_monster(621, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
	event.place_dungeon_monster(622, -3.84976, 5016.45, 9390.18, 1.0471976, 0.0, 0.0)
	event.control_stopwatch(3, 350, 370, 1)
	event.control_stopwatch(2, 18000)
	event.control_stopwatch_1(0)
	vm.wait(3)
	event.fade_in_screen(30)
	event.finish_event()
end

--- Loads the party and their equipment used by the conversation cutscene.
local function load_conversation_scene_actors()
	local playable_character: s32 = 0
	event.set_message_window_mode(0, 7)
	event.show_dungeon_status_bar(0, 1.0)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 2 then
		event.switch_dungeon_main_character(0)
		playable_character = 0
	end
	if playable_character == 3 then
		event.switch_dungeon_main_character(1)
		playable_character = 1
	end
	if playable_character == 0 then
		max_slot = 0
		monica_slot = 8
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", max_slot)
		event.load_character_motion_pack(5, "event/e700/e732/e732_mints.gltf", "info", max_slot)
		event.attach_object_handle_to_character(0, max_slot)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, max_slot)
		event.load_character(5, "chara/c02_base.gltf", "info", monica_slot)
		event.load_equipment_model(5, 1, 1, "info", monica_slot, 17)
		event.load_equipment_model(5, 1, 0, "info", monica_slot, 18)
		event.load_equipment_model(5, 1, 4, "info", monica_slot)
		event.load_equipment_model(5, 1, 3, "info", monica_slot)
		event.load_equipment_model(5, 1, 2, "info", monica_slot, 13)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", monica_slot)
		event.load_character_motion_pack(5, "event/e700/e732/e732_monica.gltf", "info", monica_slot)
		event.attach_object_handle_to_character(1, monica_slot)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, monica_slot)
		event.set_character_active(1, 13)
	end
	if playable_character == 1 then
		max_slot = 8
		monica_slot = 0
		event.load_character(5, "chara/c01_base.gltf", "info", max_slot)
		event.load_equipment_model(5, 0, 1, "info", max_slot, 17)
		event.load_equipment_model(5, 0, 0, "info", max_slot, 18)
		event.load_equipment_model(5, 0, 4, "info", max_slot)
		event.load_equipment_model(5, 0, 3, "info", max_slot)
		event.load_equipment_model(5, 0, 2, "info", max_slot, 13)
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", max_slot)
		event.load_character_motion_pack(5, "event/e700/e732/e732_mints.gltf", "info", max_slot)
		event.attach_object_handle_to_character(0, max_slot)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, max_slot)
		event.set_character_active(1, 13)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", monica_slot)
		event.load_character_motion_pack(5, "event/e700/e732/e732_monica.gltf", "info", monica_slot)
		event.attach_object_handle_to_character(1, monica_slot)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, monica_slot)
	end
	event.attach_object_handle_to_map_part_2(6, "p06_d06b03-0")
	event.set_object_handle_visible(6, 0)
	event.set_character_active(1, 17)
	event.set_character_active(1, 18)
	event.load_message_file(0, 5, "event/e700/e732/e732.txt")
end

--- Assigns the Max and Monica actor slots to the layout used with Monica leading, so skipping the conversation cutscene cleans up the right actors.
local function set_skip_party_slots()
	local active_character: s32 = 0
	local _ = active_character == 2
	active_character = 0
	local _ = active_character == 3
	active_character = 1
	max_slot = 0
	monica_slot = 8
	max_slot = 8
	monica_slot = 0
end

--- Removes the conversation cutscene actors and restores the party.
local function unload_conversation_scene()
	local playable_character: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 0 then
		event.set_character_active(1, max_slot)
		event.set_character_active(0, monica_slot)
		event.delete_character_extension_packs(max_slot)
		event.delete_character_extension_packs(monica_slot)
		event.delete_character(monica_slot)
		event.delete_character(13)
		event.delete_character(17)
		event.delete_character(18)
	end
	if playable_character == 1 then
		event.set_character_active(1, monica_slot)
		event.set_character_active(0, max_slot)
		event.delete_character_extension_packs(max_slot)
		event.delete_character_extension_packs(monica_slot)
		event.delete_character(max_slot)
		event.delete_character(13)
		event.delete_character(17)
		event.delete_character(18)
	end
	event.set_object_handle_visible(6, 1)
	event.attach_object_handle_to_character(2, 1)
	event.set_object_handle_visible(2, 1)
	event.attach_object_handle_to_character(3, 2)
	event.set_object_handle_visible(3, 1)
	event.show_dungeon_status_bar(1, 1.0)
	event.finish_event()
	vm.wait(1)
end

--- Plays the voiced conversation in which the party looks up at the sky and then fades out.
local function play_looking_up_conversation_cutscene()
	local saved_projection: f32 = 0
	local step: number = 0
	vm.section(function()
		event.set_save_flag(732, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.stop_music(0)
		step = 1
		wait.for_frame_count(4)
		event.load_music(53)
		event.play_music(0)
		event.load_map_sounds(7841)
		load_conversation_scene_actors()
		saved_projection = event.get_event_projection() or saved_projection
		event.enable_drama_skip()
		event.attach_object_handle_to_character(2, 1)
		event.set_object_handle_visible(2, 0)
		event.attach_object_handle_to_character(3, 2)
		event.set_object_handle_visible(3, 0)
		event.set_character_active(0, 17)
		event.set_character_active(0, 18)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_character_active(1, max_slot)
		event.set_character_active(1, monica_slot)
		event.set_camera_sequence_position(281.98, 20.1, 298.37)
		event.set_camera_sequence_look_at(1436.08, 1324.63, 1446.43)
		event.set_object_sequence_motion(0, "上向くL", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "上向くL", 4, -1.0, 1)
		event.set_object_sequence_position(0, 457.63, 0.0, 460.14)
		event.set_object_sequence_rotation(0, 0.0, 0.72, 0.0)
		event.set_object_sequence_position(1, 443.3, 0.0, 472.44)
		event.set_object_sequence_rotation(1, 0.0, 0.72, 0.0)
		event.fade_in_screen(30)
		step = 2
		wait.for_frame_count(15)
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(200)
		event.add_camera_sequence_path_point(281.98, 20.1, 298.37, 1436.08, 1324.63, 1446.43)
		event.add_camera_sequence_path_point(281.98, 20.1, 298.37, 1436.08, 215.39, 1446.43)
		event.start_camera_sequence_path()
		step = 3
		camera.wait_until_done()
		step = 4
		wait.for_frame_count(30)
		event.set_camera_sequence_position(520.35, 27.62, 447.72)
		event.set_camera_sequence_look_at(443.3, 23.28, 472.44)
		event.set_mouth_texture_animations(1, "通常口パク")
		step = 5
		message.show_voiced_for_stopping(7320210, -1)
		event.reset_mouth_texture_animations()
		step = 6
		wait.for_frame_count(30)
		event.set_mouth_texture_animations(1, "通常口パク")
		step = 7
		message.show_voiced_for_stopping(7320215, -1)
		event.reset_mouth_texture_animations()
		step = 8
		wait.for_frame_count(30)
		event.set_mouth_texture_animations(1, "通常口パク")
		step = 9
		message.show_voiced_for_stopping(7320220, -1)
		event.reset_mouth_texture_animations()
		step = 10
		wait.for_frame_count(30)
		event.set_camera_sequence_position(422.7, -0.4, 438.35)
		event.set_camera_sequence_look_at(1436.08, 1232.78, 1446.43)
		event.set_mouth_texture_animations(0, "通常口パク")
		step = 11
		message.show_voiced_for_stopping(7320230, -1)
		event.reset_mouth_texture_animations()
		step = 12
		wait.for_frame_count(30)
		event.set_mouth_texture_animations(0, "通常口パク")
		step = 13
		message.show_voiced_for_stopping(7320240, -1)
		event.reset_mouth_texture_animations()
		step = 14
		wait.for_frame_count(30)
		event.set_object_sequence_motion(0, "上→右", 6)
		event.queue_object_sequence_next_motion(0, "右向くL", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		step = 15
		message.show_voiced_for_stopping(7320250, -1)
		event.reset_mouth_texture_animations()
		step = 16
		object.wait_until_done(0)
		step = 17
		wait.for_frame_count(30)
		event.set_event_projection(saved_projection)
		event.set_camera_sequence_position(520.35, 27.62, 447.72)
		event.set_camera_sequence_look_at(443.3, 23.28, 472.44)
		event.set_mouth_texture_animations(0, "通常口パク")
		step = 18
		message.show_voiced_for_stopping(7320255, -1)
		event.reset_mouth_texture_animations()
		step = 19
		wait.for_frame_count(15)
		event.set_object_sequence_motion(1, "上から左", 6)
		event.queue_object_sequence_next_motion(1, "左向くL", 4)
		event.delay_object_sequence_motion_track(1, 60)
		event.set_object_sequence_motion(1, "詩人ね", 6)
		event.queue_object_sequence_next_motion(1, "詩人ねL", 4)
		event.set_mouth_texture_animations(1, "わらい口パク")
		step = 20
		message.show_voiced_for_stopping(7320260, -1)
		event.reset_mouth_texture_animations()
		step = 21
		object.wait_until_done(0)
		step = 22
		object.wait_until_done(1)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "前向き～下向き")
		event.set_object_sequence_motion(0, "そうかな", 6)
		event.queue_object_sequence_next_motion(0, "そうかなL", 4)
		event.set_mouth_texture_animations(0, "わらい口パク")
		step = 23
		message.show_voiced_for_stopping(7320270, -1)
		event.reset_mouth_texture_animations()
		step = 24
		object.wait_until_done(0)
		step = 25
		wait.for_frame_count(30)
		event.set_event_projection(saved_projection)
		event.set_object_sequence_motion(0, "上向くL", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "上向くL", 4, -1.0, 1)
		event.set_camera_sequence_position(281.98, 20.1, 298.37)
		event.set_camera_sequence_look_at(1436.08, 215.39, 1446.43)
		step = 26
		message.show_voiced_for_stopping(7320280, -1)
		step = 27
		wait.for_frame_count(30)
		step = 28
		message.show_voiced_for_stopping(7320285, -1)
		step = 29
		wait.for_frame_count(30)
		step = 30
		message.show_voiced_for_stopping(7320290, -1)
		step = 31
		wait.for_frame_count(30)
		step = 32
		message.show_voiced_for_stopping(7320295, -1)
		event.move_camera_sequence_eased(281.98, 20.1, 298.37, 1436.08, 1963.82, 1446.43, 300, 0, 1.0)
		step = 33
		wait.for_frame_count(30)
		step = 34
		message.show_voiced_for_stopping(7320300, -1)
		step = 35
		wait.for_frame_count(30)
		step = 36
		message.show_voiced_for_stopping(7320310, -1)
		step = 37
		camera.wait_until_done()
		step = 38
		message.show_voiced_for_stopping(7320320, -1)
		step = 39
		wait.for_frame_count(30)
		step = 40
		message.show_voiced_for_stopping(7320330, -1)
		step = 41
		wait.for_frame_count(30)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_camera_sequence_position(539.13, 94.76, 524.34)
		event.set_camera_sequence_look_at(457.63, 10.5, 460.14)
		event.move_camera_sequence_eased(484.6, 41.24, 479.15, 471.35, 30.37, 469.8, 300, 2, 1.0)
		event.start_crossfade(30)
		step = 42
		message.show_voiced_for_stopping(7320340, -1)
		step = 43
		wait.for_frame_count(30)
		step = 44
		message.show_voiced_for_stopping(7320350, -1)
		step = 45
		wait.for_frame_count(30)
		step = 46
		message.show_voiced_for_stopping(7320360, -1)
		step = 47
		camera.wait_until_done()
		step = 48
		wait.for_frame_count(30)
		event.set_object_sequence_motion(0, "帽子取る", 6)
		event.queue_object_sequence_next_motion(0, "帽子取るL", 4)
		step = 49
		message.show_voiced_for_stopping(7320370, -1)
		step = 50
		object.wait_until_done(0)
		event.set_object_sequence_motion(0, "ぶるぶる", 6)
		event.queue_object_sequence_next_motion(0, "帽子取るL", 4)
		step = 51
		message.show_voiced_for_stopping(7320380, -1)
		step = 52
		object.wait_until_done(0)
		event.set_event_projection(182.9)
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(240)
		event.add_camera_sequence_path_point(422.7, 30.65, 438.35, 1436.08, 349.8, 1446.43)
		event.add_camera_sequence_path_point(353.73, 30.65, 369.74, 1436.08, 349.8, 1446.43)
		event.start_camera_sequence_path()
		step = 53
		wait.for_frame_count(180)
		event.fade_out_music(60)
		event.fade_out_screen(60)
		step = 54
		wait.for_frame_count(60)
		event.stop_music(0)
	end, function(received: { any }): boolean
		if step <= 1 then
			set_skip_party_slots()
			wait.skip_frame_count(15)
		end
		if step <= 2 then
			wait.background_load_skipping()
		end
		if step <= 3 then
			wait.skip_frame_count(30)
		end
		if step <= 4 then
			message.show_voiced_for_stopping_skipping(7320210, -1)
		end
		if step <= 5 then
			wait.skip_frame_count(30)
		end
		if step <= 6 then
			message.show_voiced_for_stopping_skipping(7320215, -1)
		end
		if step <= 7 then
			wait.skip_frame_count(30)
		end
		if step <= 8 then
			message.show_voiced_for_stopping_skipping(7320220, -1)
		end
		if step <= 9 then
			wait.skip_frame_count(30)
		end
		if step <= 10 then
			message.show_voiced_for_stopping_skipping(7320230, -1)
		end
		if step <= 11 then
			wait.skip_frame_count(30)
		end
		if step <= 12 then
			message.show_voiced_for_stopping_skipping(7320240, -1)
		end
		if step <= 13 then
			wait.skip_frame_count(30)
		end
		if step <= 14 then
			message.show_voiced_for_stopping_skipping(7320250, -1)
		end
		if step <= 15 then
			cutscene.skip_command(0)
		end
		if step <= 16 then
			wait.skip_frame_count(30)
		end
		if step <= 17 then
			message.show_voiced_for_stopping_skipping(7320255, -1)
		end
		if step <= 18 then
			wait.skip_frame_count(15)
		end
		if step <= 19 then
			message.show_voiced_for_stopping_skipping(7320260, -1)
		end
		if step <= 20 then
			cutscene.skip_command(0)
		end
		if step <= 21 then
			cutscene.skip_command(1)
		end
		if step <= 22 then
			message.show_voiced_for_stopping_skipping(7320270, -1)
		end
		if step <= 23 then
			cutscene.skip_command(0)
		end
		if step <= 24 then
			wait.skip_frame_count(30)
		end
		if step <= 25 then
			message.show_voiced_for_stopping_skipping(7320280, -1)
		end
		if step <= 26 then
			wait.skip_frame_count(30)
		end
		if step <= 27 then
			message.show_voiced_for_stopping_skipping(7320285, -1)
		end
		if step <= 28 then
			wait.skip_frame_count(30)
		end
		if step <= 29 then
			message.show_voiced_for_stopping_skipping(7320290, -1)
		end
		if step <= 30 then
			wait.skip_frame_count(30)
		end
		if step <= 31 then
			message.show_voiced_for_stopping_skipping(7320295, -1)
		end
		if step <= 32 then
			wait.skip_frame_count(30)
		end
		if step <= 33 then
			message.show_voiced_for_stopping_skipping(7320300, -1)
		end
		if step <= 34 then
			wait.skip_frame_count(30)
		end
		if step <= 35 then
			message.show_voiced_for_stopping_skipping(7320310, -1)
		end
		if step <= 36 then
			wait.background_load_skipping()
		end
		if step <= 37 then
			message.show_voiced_for_stopping_skipping(7320320, -1)
		end
		if step <= 38 then
			wait.skip_frame_count(30)
		end
		if step <= 39 then
			message.show_voiced_for_stopping_skipping(7320330, -1)
		end
		if step <= 40 then
			wait.skip_frame_count(30)
		end
		if step <= 41 then
			message.show_voiced_for_stopping_skipping(7320340, -1)
		end
		if step <= 42 then
			wait.skip_frame_count(30)
		end
		if step <= 43 then
			message.show_voiced_for_stopping_skipping(7320350, -1)
		end
		if step <= 44 then
			wait.skip_frame_count(30)
		end
		if step <= 45 then
			message.show_voiced_for_stopping_skipping(7320360, -1)
		end
		if step <= 46 then
			wait.background_load_skipping()
		end
		if step <= 47 then
			wait.skip_frame_count(30)
		end
		if step <= 48 then
			message.show_voiced_for_stopping_skipping(7320370, -1)
		end
		if step <= 49 then
			cutscene.skip_command(0)
		end
		if step <= 50 then
			message.show_voiced_for_stopping_skipping(7320380, -1)
		end
		if step <= 51 then
			cutscene.skip_command(0)
		end
		if step <= 52 then
			wait.skip_frame_count(180)
		end
		if step <= 53 then
			wait.skip_frame_count(60)
		end
		return true
	end)
	event.cancel_drama_scene_skip()
	event.set_event_projection(saved_projection)
	step = 55
	unload_conversation_scene()
end

--- Plays the long voiced cutscene in which the Dark Genie taunts the party, strikes with magic and the battle music begins.
local function play_dark_genie_dialogue_cutscene()
	local sound_bank: s32 = 0
	local playable_character: s32 = 0
	local active_music_number: s32 = 0
	vm.section(function()
		event.set_save_flag(728, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.load_map_sounds(7835)
		sound_bank = event.load_sound_effect_file_2(7835) or sound_bank
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		playable_character = event.get_playable_character() or playable_character
		event.set_scene_status_flags(1, 0, 256, 1)
		event.change_directory("event/e700/e728/")
		event.load_message_file(0, 5, "e728.txt")
		if playable_character == 0 then
			event.load_character_motion_pack(5, "e728_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if playable_character == 1 then
			event.load_character_motion_pack(5, "e728_monica.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.load_character(5, "e728_dark.gltf", "info", 10)
		event.set_character_active(10)
		event.attach_object_handle_to_character(2, 10)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.load_character(5, "e728_sun.gltf", "info", 11)
		event.set_character_active(11)
		event.attach_object_handle_to_character(3, 11)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.load_character(5, "e728_magic_h.gltf", "info", 12)
		event.set_character_active(12)
		event.attach_object_handle_to_character(4, 12)
		event.clear_object_sequence(4)
		event.set_object_sequence_object(4, 4)
		event.load_character(5, "e728_magic_l.gltf", "info", 13)
		event.set_character_active(13)
		event.attach_object_handle_to_character(5, 13)
		event.clear_object_sequence(5)
		event.set_object_sequence_object(5, 5)
		event.load_character(5, "e728_DEhikari.gltf", "info", 14)
		event.set_character_active(14)
		event.attach_object_handle_to_character(7, 14)
		event.clear_object_sequence(7)
		event.set_object_sequence_object(7, 7)
		event.load_character(5, "e728_san_hit.gltf", "info", 15)
		event.set_character_active(15)
		event.attach_object_handle_to_character(8, 15)
		event.clear_object_sequence(8)
		event.set_object_sequence_object(8, 8)
		event.change_directory("")
		if playable_character == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 8)
			event.load_equipment_model(5, 0, 4, "info", 8)
			event.load_equipment_model(5, 0, 3, "info", 8)
			event.load_equipment_model(5, 0, 2, "info", 8, 9)
			event.load_character_motion_pack(5, "event/e700/e728/e728_mints.gltf", "info", 8)
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
			event.load_character_motion_pack(5, "event/e700/e728/e728_monica.gltf", "info", 8)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 8)
			event.attach_object_handle_to_character(1, 8)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 0)
		end
		event.set_character_active(8)
		event.set_character_active(9)
		event.attach_object_handle_to_map_part_2(6, "p06_d06b03-0")
		event.clear_object_sequence(6)
		event.set_object_sequence_object(6, 6)
		event.set_object_sequence_scale(6, 0.7, 0.7, 0.7)
		event.set_object_handle_position(1, -1.42, 0.0, -83.64)
		event.set_object_handle_rotation(1, 0.0, -0.12, 0.0)
		event.set_object_handle_footstep_sound(1, 2)
		event.set_object_handle_position(0, -23.19, 0.0, -81.74)
		event.set_object_handle_rotation(0, 0.0, 0.26, 0.0)
		event.set_object_handle_footstep_sound(0, 2)
		event.set_object_handle_position(2, -12.34, 0.0, 42.31)
		event.set_object_handle_rotation(2, 0.0, -3.07, 0.0)
		event.set_object_handle_footstep_sound(2, 1)
		event.set_object_sequence_scale(2, 2.0, 2.0, 2.0)
		event.attach_character_to_frame(10, "tama", 14)
		event.set_object_handle_position(3, 452.27, -10000, 254.12)
		event.set_object_handle_rotation(3, 0.0, -0.1, 0.0)
		event.set_object_handle_footstep_sound(3, 1)
		event.set_object_handle_position(8, 452.27, -10000, 254.12)
		event.set_object_handle_rotation(8, 0.0, -0.1, 0.0)
		event.set_object_handle_visible(6, 0)
		event.set_object_handle_visible(8, 0)
		event.enable_drama_skip()
		event.set_object_sequence_motion(1, "立ち", 4)
		event.set_object_sequence_motion(0, "立ち", 4)
		event.set_object_sequence_motion(2, "立ち", 4)
		event.set_object_sequence_motion(3, "立ち", 4)
		event.reset_object_sequence_dynamic_animation(3)
		event.set_character_active(0)
		event.set_character_active(8)
		event.set_character_active(9)
		event.set_character_active(10)
		event.set_character_active(11)
		event.set_character_active(0, 12)
		event.set_character_active(0, 13)
		event.set_event_projection(360.9)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(6.95, 33.33, -38.64)
		event.set_camera_sequence_look_at(2.96, 21.19, 34.24)
		event.fade_in_screen(30)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目パチ")
		wait.for_frame_count(30)
		event.move_camera_sequence_eased(6.95, 33.33, -38.64, -16.79, 86.78, 30.71, 120, 2, 1.0)
		message.show_voiced_for_stopping(7280160, 540)
		event.set_event_projection(524.9)
		event.set_camera_sequence_position(-17.25, 2.73, -179.23)
		event.set_camera_sequence_look_at(-11.0, 60.16, -36.27)
		event.play_sound_effect(sound_bank, 0)
		event.set_object_sequence_motion(2, "手を上げる", 6)
		event.queue_object_sequence_next_motion(2, "手を上げるL", 4)
		object.wait_until_done(2)
		event.delay_object_sequence_motion_track(2, 180)
		event.set_object_sequence_motion(2, "死に絶えるのだ", 6)
		event.queue_object_sequence_next_motion(2, "死に絶えるのだL", 4)
		event.delay_object_sequence_sound_track(2, 180)
		event.play_object_sequence_sound(2, sound_bank, 1)
		event.open_voice_stream_wave(1, 7280163)
		sound.wait_voice_stream_ready(1)
		event.open_message_window_2(0, 7280163)
		message.open(0, -1, 8, 0, 0)
		event.play_voice_stream(1)
		wait.for_frame_count(180)
		event.start_crossfade(30)
		event.set_camera_sequence_position(1.58, 101.91, -60.95)
		event.set_camera_sequence_look_at(-17.89, 92.73, 25.56)
		message.wait_voice_stopping_for(0, -1)
		message.close(0)
		event.close_voice_stream(1)
		object.wait_until_done(2)
		event.set_camera_sequence_position(-37.44, 9.97, -30.69)
		event.set_camera_sequence_look_at(1007.77, 434.9, -2136.35)
		event.shake_camera_sequence_vertically(0.0, 3.3, 0.0, 60)
		event.play_sound_effect(sound_bank, 2)
		event.set_object_handle_visible(6, 1)
		wait.for_frame_count(60)
		event.set_object_sequence_motion(0, "上向く", 6)
		event.queue_object_sequence_next_motion(0, "上向くL", 4)
		event.set_object_sequence_motion(1, "上向く", 6)
		event.queue_object_sequence_next_motion(1, "上向くL", 4)
		wait.for_frame_count(30)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目～おどろき目")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目～おどろき目")
		event.set_object_sequence_texture_animation(1, 1, "口とじ～大口")
		event.set_object_sequence_texture_animation(0, 1, "口とじ～大口")
		message.show_voiced_for_stopping(7280165, 90)
		event.set_camera_sequence_position(-5.51, 54.41, -260.22)
		event.set_camera_sequence_look_at(-13.59, 43.11, -47.5)
		event.set_object_sequence_motion(2, "立ち", 4)
		event.set_object_sequence_scale(6, 1.0, 1.0, 1.0, 180)
		event.set_object_sequence_motion(2, "振り返る", 6)
		event.queue_object_sequence_next_motion(2, "上見立ち", 4)
		wait.for_frame_count(60)
		event.move_camera_sequence_eased(-5.51, 375.83, -260.22, -4.47, 459.86, -47.34, 120, 0, 1.0)
		camera.wait_until_done()
		event.set_camera_sequence_position(-44.01, 88.99, -11.02)
		event.set_camera_sequence_look_at(-13.6, 22.3, -75.12)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目パチ")
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced_for_stopping(7280170, 150)
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced_for_stopping(7280180, 120)
		event.move_camera_sequence_eased(-88.64, 165.69, 144.36, -18.85, 102.29, 59.43, 120, 0, 0.5)
		event.stop_sound_effect(sound_bank, 2)
		event.play_sound_effect(sound_bank, 3)
		wait.for_frame_count(30)
		message.show_voiced_for_stopping(7280190, 500)
		camera.wait_until_done()
		event.set_camera_sequence_position(-14.82, 6.49, -265.28)
		event.set_camera_sequence_look_at(-12.4, 63.83, -45.92)
		event.set_object_sequence_position(2, -10.86, 37.42, 79.41)
		event.reset_object_sequence_dynamic_animation(2)
		wait.for_frame_count(30)
		event.set_object_sequence_motion(2, "振り返る2", 6)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		message.show_voiced_for_stopping(7280200, 210)
		object.wait_until_done(2)
		event.play_sound_effect(sound_bank, 4)
		event.set_object_sequence_motion(2, "闇世界の王", 6)
		event.queue_object_sequence_next_motion(2, "闇世界の王L", 4)
		event.delay_object_sequence_sound_track(2, 30)
		event.play_object_sequence_sound(2, sound_bank, 5)
		message.show_voiced_for_stopping(7280210, 480)
		object.wait_until_done(2)
		event.set_camera_sequence_position(-45.16, 123.78, 11.64)
		event.set_camera_sequence_look_at(-7.21, 140.87, 80.61)
		event.stop_music(0)
		event.set_character_active(13)
		event.set_object_sequence_position(5, -9.83, 0.0, -376.53)
		event.set_object_sequence_motion(5, "魔法かまえ")
		event.set_object_sequence_motion(3, "魔法かまえ", 4)
		event.set_object_sequence_position(3, -9.83, 0.0, -376.53)
		event.reset_object_sequence_dynamic_animation(3)
		event.set_object_sequence_position(8, -9.83, 0.0, -376.53)
		event.set_object_sequence_motion(2, "フハハハハ", 4)
		message.show_voiced_for_stopping(7280220, 210)
		event.play_sound_effect(sound_bank, 6)
		event.set_character_active(12)
		event.set_object_sequence_position(4, -16.64, 87.63, 60.46)
		event.set_object_sequence_rotation(4, 0.0, -3.07, 0.0)
		event.set_object_sequence_motion(4, "魔法あたる", 6)
		event.set_object_sequence_motion(2, "魔法あたる", 6)
		event.queue_object_sequence_next_motion(2, "立ち")
		object.wait_until_done(2)
		event.stop_sound_effect(sound_bank, 3)
		event.set_camera_sequence_position(-12.59, 20.81, -29.79)
		event.set_camera_sequence_look_at(-11.75, 19.91, -100.77)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目パチ")
		event.set_object_sequence_texture_animation(1, 1, "半口")
		event.play_sound_effect(sound_bank, 7)
		event.set_object_sequence_motion(0, "後ろ見る", 6)
		event.queue_object_sequence_next_motion(0, "後ろ見るL", 4)
		event.set_object_sequence_motion(1, "後ろ見", 6)
		event.queue_object_sequence_next_motion(1, "後ろ見L", 4)
		object.wait_until_done(1)
		wait.for_frame_count(60)
		event.set_camera_sequence_position(-0.53, 9.74, -325.24)
		event.set_camera_sequence_look_at(-10.06, 15.31, -377.35)
		event.set_object_sequence_texture_animation(3, 0)
		event.play_sound_effect(sound_bank, 8)
		event.set_object_sequence_texture_animation(3, 1, "つかれ目パチ")
		wait.for_frame_count(60)
		event.stop_sound_effect(sound_bank, 8)
		event.set_camera_sequence_position(8.44, 122.24, -79.64)
		event.set_camera_sequence_look_at(17.47, 121.82, 84.02)
		event.set_character_active(0, 13)
		event.move_camera_sequence(-31.27, 122.24, -88.16, -24.72, 121.82, 75.61, 420)
		message.show_voiced_for_stopping(7280230, 420)
		camera.wait_until_done()
		event.set_camera_sequence_position(-143.28, 120.11, -54.02)
		event.set_camera_sequence_look_at(-4.2, 126.33, 56.81)
		event.play_sound_effect(sound_bank, 9)
		event.set_object_sequence_motion(2, "杖投げる", 6)
		wait.for_frame_count(60)
		event.set_camera_sequence_position(-63.01, 36.02, -308.06)
		event.set_camera_sequence_look_at(6.33, 11.27, -369.11)
		event.set_character_model_lighting(10, 0)
		event.set_character_model_color(10, 128.0, 128.0, 128.0, 128.0)
		event.reset_object_sequence_motion(2)
		event.set_object_sequence_motion(2, "杖投げる", 6)
		event.set_object_sequence_scale(2, 0.5, 1.0, 1.0)
		event.set_object_sequence_position(2, 6.23, -0.75, -116.64)
		event.reset_object_sequence_dynamic_animation(2)
		event.delay_object_sequence_sound_track(3, 45)
		event.play_object_sequence_sound(3, sound_bank, 10)
		event.delay_object_sequence_motion_track(3, 45)
		event.set_object_sequence_motion(3, "刺さる", 6)
		event.queue_object_sequence_next_motion(3, "刺さるL", 4)
		wait.for_frame_count(45)
		event.set_object_handle_visible(8, 1)
		event.set_object_sequence_motion(8, "刺さる", 6)
		wait.for_frame_count(5)
		message.show_voiced_for_stopping(7280235, 90)
		event.set_camera_sequence_position(-13.1, 29.49, -152.47)
		event.set_camera_sequence_look_at(-13.69, 6.9, -67.55)
		event.set_object_handle_visible(8, 0)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おどろき顔")
		event.set_object_sequence_texture_animation(0, 1, "おどろき目パチ")
		event.set_object_sequence_texture_animation(0, 1, "口とじ～大口")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おどろき顔")
		event.set_object_sequence_texture_animation(1, 1, "おどろき目パチ")
		event.set_object_sequence_texture_animation(1, 1, "大口")
		event.set_object_sequence_scale(2, 2.0, 2.0, 2.0)
		event.set_object_sequence_position(2, -10.86, 37.42, 79.41)
		event.reset_object_sequence_dynamic_animation(2)
		event.set_object_sequence_position(1, -1.96, 0.0, -78.42)
		event.set_object_sequence_rotation(1, 0.0, -0.48, 0.0)
		event.reset_object_sequence_dynamic_animation(1)
		wait.for_frame_count(90)
		event.set_camera_sequence_position(-139.53, 12.92, -295.36)
		event.set_camera_sequence_look_at(-5.92, 14.31, -385.02)
		event.set_object_sequence_scale(2, 1.0, 1.0, 1.0)
		event.set_object_sequence_position(2, 4.32, 1.63, -115.01)
		event.reset_object_sequence_dynamic_animation(2)
		event.move_object_sequence(2, 4.32, 25.63, -115.01, 120)
		event.move_object_sequence(3, -9.83, 25.0, -376.53, 120)
		object.wait_until_done(3)
		wait.for_frame_count(30)
		event.set_camera_sequence_position(-10.74, 103.97, -46.08)
		event.set_camera_sequence_look_at(-10.95, 122.33, 62.77)
		event.set_character_model_lighting(10, 1)
		event.set_object_sequence_scale(2, 2.0, 2.0, 2.0)
		event.set_object_sequence_position(2, -10.86, 37.42, 79.41)
		event.reset_object_sequence_dynamic_animation(2)
		event.play_sound_effect(sound_bank, 11)
		event.set_object_sequence_motion(2, "カモーン", 6)
		event.queue_object_sequence_next_motion(2, "カモーンL", 4)
		wait.for_frame_count(90)
		event.set_camera_sequence_position(-139.53, 12.92, -295.36)
		event.set_camera_sequence_look_at(-5.92, 14.31, -385.02)
		event.set_character_model_lighting(10, 0)
		event.set_character_model_color(10, 128.0, 128.0, 128.0, 128.0)
		event.set_object_sequence_motion(1, "立ち", 4)
		event.set_object_sequence_motion(0, "立ち", 4)
		event.set_object_sequence_scale(2, 1.0, 1.0, 1.0)
		event.set_object_sequence_position(2, 4.32, 25.63, -115.01)
		event.reset_object_sequence_dynamic_animation(2)
		event.move_object_sequence(2, 13.34, 42.27, -29.33, 10)
		event.play_sound_effect(sound_bank, 12)
		event.delay_object_sequence_motion_track(3, 10)
		event.set_object_sequence_motion(3, "落ちる", 6)
		event.queue_object_sequence_next_motion(3, "落ちるL", 4)
		event.move_object_sequence(3, -9.83, 0.0, -376.53, 30)
		wait.for_frame_count(60)
		event.set_character_model_lighting(10, 1)
		event.set_camera_sequence_position(8.05, 9.57, -432.58)
		event.set_camera_sequence_look_at(-4.2, 9.01, -384.9)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目パチ")
		event.set_object_sequence_texture_animation(0, 1, "半口")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目パチ")
		event.set_object_sequence_texture_animation(1, 1, "半口")
		event.set_object_sequence_motion(2, "立ち", 4)
		event.set_object_sequence_scale(2, 2.0, 2.0, 2.0)
		event.set_object_sequence_position(2, -10.86, 37.42, 79.41)
		event.reset_object_sequence_dynamic_animation(2)
		event.set_object_sequence_position(0, -27.05, 0.0, -181.8)
		event.set_object_sequence_rotation(0, 0.0, 3.06, 0.0)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_object_sequence_position(1, 7.3, 0.0, -200.98)
		event.set_object_sequence_rotation(1, 0.0, 3.04, 0.0)
		event.reset_object_sequence_dynamic_animation(1)
		event.set_object_sequence_motion(0, "走り", 4)
		event.move_object_sequence(0, -25.77, 0.0, -317.97, 120)
		event.rotate_object_sequence(0, 0.0, 2.94, 0.0, 120)
		event.set_object_sequence_motion(1, "走り", 4)
		event.move_object_sequence(1, 4.82, 0.0, -318.77, 120)
		event.rotate_object_sequence(1, 0.0, -3.0, 0.0, 120)
		wait.for_frame_count(100)
		event.set_camera_sequence_position(-31.52, 44.28, -338.11)
		event.set_camera_sequence_look_at(-5.77, 5.41, -388.31)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_sequence_position(0, -24.38, 0.0, -382.48)
		event.set_object_sequence_rotation(0, 0.0, 2.22, 0.0)
		event.reset_object_sequence_dynamic_animation(0)
		event.reset_object_sequence_motion(0)
		event.set_object_sequence_motion(0, "立ち", 4)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_object_sequence_position(1, 10.7, 0.0, -369.54)
		event.set_object_sequence_rotation(1, 0.0, -2.64, 0.0)
		event.reset_object_sequence_dynamic_animation(1)
		event.reset_object_sequence_motion(1)
		event.set_object_sequence_motion(1, "立ち", 4)
		wait.for_frame_count(30)
		event.set_object_sequence_texture_animation(3, 0)
		event.set_object_sequence_texture_animation(3, 1, "目とじ２～くるし目")
		event.set_object_sequence_motion(0, "しゃがむ", 6)
		event.queue_object_sequence_next_motion(0, "しゃがむL", 4)
		event.delay_object_sequence_motion_track(1, 15)
		event.set_object_sequence_motion(1, "しゃがみ", 6)
		event.queue_object_sequence_next_motion(1, "しゃがみL", 4)
		event.set_object_sequence_motion(3, "ユリス見る", 6)
		event.queue_object_sequence_next_motion(3, "ユリス見るL", 4)
		wait.for_frame_count(60)
		message.show_voiced_for_stopping(7280240, 90)
		message.show_voiced_for_stopping(7280245, 300)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "かなし顔")
		event.set_object_sequence_texture_animation(0, 1, "かなし目パチ")
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "かなし顔")
		event.set_object_sequence_texture_animation(0, 1, "かなし目～おこり目")
		event.set_object_sequence_texture_animation(0, 1, "歯くいしばり")
		event.set_camera_sequence_position(-6.87, 5.41, -405.85)
		event.set_camera_sequence_look_at(-26.19, 16.97, -379.68)
		event.set_object_sequence_motion(3, "落ちるL", 6)
		event.set_object_sequence_position(1, 10.32, 0.0, -384.63)
		event.reset_object_sequence_dynamic_animation(1)
		wait.for_frame_count(90)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目パチ")
		event.load_music(37)
		event.play_music(0)
		wait.for_frame_count(30)
		event.play_sound_effect(sound_bank, 13)
		event.set_object_sequence_motion(0, "しゃがむ戻り", 6)
		event.rotate_object_sequence(0, 0.0, 0.18, 0.0, 20)
		event.delay_object_sequence_motion_track(0, 20)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		event.set_object_sequence_motion(1, "おきあがり", 6)
		event.rotate_object_sequence(1, 0.0, -0.24, 0.0, 20)
		event.delay_object_sequence_motion_track(1, 20)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目パチ")
		event.set_camera_sequence_position(-11.62, 15.51, -310.99)
		event.set_camera_sequence_look_at(-10.21, 16.97, -375.48)
		wait.for_frame_count(30)
		wait.for_frame_count(90)
		event.set_camera_sequence_position(21.35, 75.0, -74.7)
		event.set_camera_sequence_look_at(-18.07, 133.59, 68.07)
		event.set_object_sequence_position(0, -17.05, 0.0, -260.83)
		event.set_object_sequence_rotation(0, 0.0, 0.3, 0.0)
		event.reset_object_sequence_dynamic_animation(0)
		event.set_object_sequence_position(1, 20.43, 0.0, -290.0)
		event.set_object_sequence_rotation(1, 0.0, 0.12, 0.0)
		event.reset_object_sequence_dynamic_animation(1)
		event.move_camera_sequence_eased(71.01, 5.64, -395.51, -82.14, 81.58, 45.26, 120, 2, 1.0)
		camera.wait_until_done()
		wait.for_frame_count(30)
		event.set_camera_sequence_position(-14.25, 113.8, -124.29)
		event.set_camera_sequence_look_at(-12.74, 114.05, 57.05)
		event.set_object_sequence_motion(2, "杖構える", 6)
		event.queue_object_sequence_next_motion(2, "杖構えるL", 4)
		event.delay_object_sequence_sound_track(2, 30)
		event.play_object_sequence_sound(2, sound_bank, 14)
		wait.for_frame_count(30)
		event.set_motion_blur(100)
		event.shake_camera_sequence_vertically(0.0, 8.5, 5.5, 150)
		wait.for_frame_count(90)
		event.fade_out_screen(20, 255, 255, 255)
		wait.for_frame_count(31)
	end)
	event.cancel_drama_scene_skip()
	event.set_motion_blur(0)
	event.stop_sound_effect(sound_bank, 2)
	event.stop_sound_effect(sound_bank, 3)
	event.stop_sound_effect(sound_bank, 8)
	active_music_number = event.get_active_music_number() or active_music_number
	if active_music_number ~= 37 then
		event.stop_music(0)
		wait.for_frame_count(4)
		event.load_music(37)
		event.play_music(0)
	end
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
	event.delete_character(13)
	event.delete_character(14)
	event.delete_character(15)
	event.load_message_file(0, -1)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded and does nothing.
function script.setup() end

--- Event 99, which map data, a script or the engine runs by number.
-- Defined empty, so the engine runs this instead of its default.
--- Placeholder hook run on map entry that does nothing.
function script.on_map_loaded() end
script[99] = script.on_map_loaded

--- Plays the boss intro cutscene and starts the timed battle when the boss flag is set, then places the party and fades in.
function script.default_event()
	local boss_flag: s32 = 0
	local playable_character: s32 = 0
	event.initialize_event()
	boss_flag = event.get_save_flag(728) or boss_flag
	if boss_flag == 1 then
		playable_character = event.get_playable_character() or playable_character
		if playable_character == 2 then
			event.switch_dungeon_main_character(0)
		end
		if playable_character == 3 then
			event.switch_dungeon_main_character(1)
		end
		event.show_dungeon_status_bar(0, 1.0)
		play_dark_genie_intro_cutscene()
		event.show_dungeon_status_bar(1, 1.0)
		event.load_dungeon_monster(621, 1)
		event.load_dungeon_monster(622, 0)
		event.place_dungeon_monster(621, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
		event.place_dungeon_monster(622, -3.84976, 5016.45, 9390.18, 1.0471976, 0.0, 0.0)
		event.control_stopwatch(3, 350, 370, 1)
		event.control_stopwatch(2, 18000)
		event.control_stopwatch_1(0)
	end
	event.set_character_position(0, 0.0, 0.0, -400.0)
	event.set_character_rotation(0, 0.0, 0.0, 0.0)
	event.set_camera_look_at(0.0, 30.0, -400.0)
	event.set_camera_position(0.0, 40.0, -520.0)
	event.reset_follow_camera(0)
	vm.wait(2)
	event.fade_in_screen(30)
	event.finish_event()
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing.
function script.key_open() end

--- Event 151, which map data, a script or the engine runs by number.
script.start_timed_boss_battle = start_timed_boss_battle
script[151] = script.start_timed_boss_battle

--- Fades out after the boss is defeated, records the floor as cleared and opens the georama editor.
function script.start_georama_edit_after_boss()
	local playable_character: s32 = 0
	local current_character: s32 = 0
	print(">>>>>>>>>>>>>>>>>RUN 500\n")
	event.initialize_event()
	event.reset_action_character_motion(0)
	event.fade_out_screen(20)
	wait.for_frame_count(20)
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 0 then
		event.set_character_status(0, 8, 1)
	end
	if playable_character == 1 then
		event.set_character_status(1, 8, 1)
	end
	event.clear_event_battle_monsters(-1)
	event.set_dungeon_floor_info(5, 27, 5, 2)
	current_character = event.get_playable_character() or current_character
	if current_character == 2 then
		event.switch_dungeon_main_character(0)
	end
	if current_character == 3 then
		event.switch_dungeon_main_character(1)
	end
	event.go_to_georama_edit(180, 500)
end
script[500] = script.start_georama_edit_after_boss

--- Plays the conversation cutscene, stores a save value and moves to the s66 map.
function script.cutscene_looking_up_then_exit_to_s66()
	play_looking_up_conversation_cutscene()
	event.set_save_data_value(0, 10)
	vm.wait(2)
	event.jump_to_map_3(-1, "s66", 520)
end
script[510] = script.cutscene_looking_up_then_exit_to_s66

--- Plays the dark genie dialogue cutscene and returns to the second boss map.
function script.cutscene_dark_genie_dialogue()
	event.show_dungeon_status_bar(0, 1.0)
	event.set_character_visible(1, 0)
	event.set_character_visible(2, 0)
	play_dark_genie_dialogue_cutscene()
	event.skip_next_music_load()
	vm.wait(2)
	event.load_dungeon_map("d06b02")
	event.load_event_script("d06b02/d06b02.stb", 100)
end
script[550] = script.cutscene_dark_genie_dialogue

--- Handles the party being defeated, with a random voiced line while the boss flag is set.
function script.on_party_defeated()
	local boss_flag: s32 = 0
	local conversation_flag: s32 = 0
	local roll: s32 = 0
	local step: number = 0
	return vm.guard(function()
		boss_flag = event.get_save_flag(728) or boss_flag
		conversation_flag = event.get_save_flag(732) or conversation_flag
		if boss_flag ~= 0 and conversation_flag == 0 then
			roll = event.get_random_number_int(100) or roll
			if roll < 50 then
				step = 1
				dungeon.handle_defeat_voiced(0, 8570060)
			else
				step = 2
				dungeon.handle_defeat_voiced(0, 8570070)
			end
			return
		end
		step = 3
		dungeon.handle_defeat_silent(0)
		return
	end, function(received: { any })
		if step <= 2 then
			if step <= 1 then
				dungeon.skip_defeat_sequence_voiced(0, 8570070)
			end
			return 0
		end
		if step <= 3 then
			return 0
		end
		return nil
	end)
end
script[1200] = script.on_party_defeated

--- Shows the game over screen and either revives the party or exits the scene.
function script.show_game_over_screen()
	local should_revive: s32 = 0
	local game_over_sound_bank: s32 = 0
	local battle_sound_bank: s32 = 0
	local battle_sound_status: s32 = 0
	local battle_music_volume: s32 = 0
	local playable_character: s32 = 0
	local game_over_image_block: s32 = 0
	local debug_flag: s32 = 0
	local saved_music_number: s32 = 0
	local is_boss_floor: s32 = 0
	event.initialize_event()
	event.set_dungeon_pause_flags(15, 1)
	should_revive = 0
	event.initialize_event()
	game_over_sound_bank = event.load_sound_effect_file_3(8, "snd2/sp/sp_052.sound.json") or game_over_sound_bank
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.set_dungeon_pause_flags(16384, 1)
	event.play_sound_effect(game_over_sound_bank, 0)
	event.reset_event_sprite(0)
	event.set_event_sprite_type(0, 0)
	event.set_event_sprite_position(0, 256, 208)
	event.set_event_sprite_size(0, 512, 416)
	event.set_event_sprite_color(0, 128, 128, 128, 0)
	event.set_event_sprite_draw_pass(0, 0)
	event.attach_object_handle_to_sprite(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_event_sprite_draw_pass(0, 1)
	event.set_object_sequence_color(0, 128, 128, 128, 128, 90)
	wait.for_frame_count(90)
	event.save_music_status(-1)
	battle_sound_bank = event.get_event_sound_bank(4) or battle_sound_bank
	battle_sound_status = event.get_sound_effect_status(battle_sound_bank, 0) or battle_sound_status
	battle_music_volume = event.get_battle_music_volume() or battle_music_volume
	event.stop_sound_effect(battle_sound_bank, 0)
	event.stop_music(0)
	playable_character = event.get_playable_character() or playable_character
	event.start_background_file_loads_2("snd2/bgm/bg_060.sound.json", "textures/dungeon/image/gameover.json")
	wait.for_frame_count(30)
	wait.background_load()
	event.load_music_pack(60)
	event.play_music(0)
	wait.for_frame_count(30)
	event.set_dungeon_pause_flags(1, 1)
	event.reset_dungeon_collision_primitives()
	game_over_image_block = event.load_event_image_4(5, "textures/dungeon/image/gameover.json", 0) or game_over_image_block
	event.reset_event_sprite(1)
	event.set_event_sprite_type(1, 0)
	event.set_event_sprite_texture(1, "gameover1", game_over_image_block)
	event.set_event_sprite_color(1, 128, 128, 128, 128)
	event.set_event_sprite_texture_rect(1, 0, 0, 576, 128)
	event.set_event_sprite_size(1, 576, 128)
	event.set_event_sprite_position(1, -320, 208)
	event.set_event_sprite_draw_pass(1, 1)
	event.attach_object_handle_to_sprite(1, 1)
	event.clear_object_sequence(1)
	event.set_object_sequence_object(1, 1)
	event.move_object_sequence(1, 288, 208, 0.0, 20)
	wait.for_frame_count(30)
	event.reset_event_sprite(2)
	event.set_event_sprite_type(2, 0)
	event.set_event_sprite_texture(2, "gameover1", game_over_image_block)
	event.set_event_sprite_color(2, 128, 128, 128, 0)
	event.set_event_sprite_texture_rect(2, 0, 128, 576, 64)
	event.set_event_sprite_size(2, 576, 64)
	event.set_event_sprite_position(2, 256, 208)
	event.set_event_sprite_draw_pass(2, 1)
	event.attach_object_handle_to_sprite(2, 2)
	event.clear_object_sequence(2)
	event.set_object_sequence_object(2, 2)
	event.set_object_sequence_color(2, 128, 128, 128, 128, 120)
	wait.for_frame_count(120)
	while true do
		if wait.get_button_state(0) ~= 0 then
			break
		else
			vm.wait(7)
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
		wait.for_frame_count(30)
		if playable_character == 2 then
			event.clear_effect_manager()
		end
		event.stop_music(0)
		event.set_event_sprite_draw_pass(0, 0)
		event.set_event_sprite_draw_pass(1, 0)
		event.delete_event_image(0)
		if should_revive == 1 then
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
	wait.for_frame_count(4)
	saved_music_number = event.get_saved_music_number() or saved_music_number
	event.load_music(saved_music_number)
	event.restore_music_status(-1)
	event.set_event_sprite_draw_pass(0, 0)
	event.set_event_sprite_draw_pass(1, 0)
	event.delete_event_image(0)
	is_boss_floor = event.is_dungeon_boss_floor() or is_boss_floor
	if is_boss_floor ~= 1 then
		if battle_sound_status == 1 then
			event.play_sound_effect(battle_sound_bank, 0)
			event.set_sound_effect_volume(battle_sound_bank, 0, battle_music_volume)
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
script[1201] = script.show_game_over_screen

--- Event 27070, which map data, a script or the engine runs by number.
script[27070] = script.start_timed_boss_battle

return script
