--!strict
--- Event script for the first Moon Flower Palace boss room, with the boss drop and awakening cutscenes, battle phase starts and map exits.

local vm = require("@lib/vm")
local camera = require("@lib/event/camera")
local character = require("@lib/event/character")
local cutscene = require("@lib/event/cutscene")
local dungeon = require("@lib/event/dungeon")
local message = require("@lib/event/message")
local object = require("@lib/event/object")
local wait = require("@lib/event/wait")

local drop_scene_max_slot: s32 = 0
local drop_scene_monica_slot: s32 = 0
local awakening_scene_max_slot: s32 = 0
local awakening_scene_monica_slot: s32 = 0

--- Placeholder hook run on map entry that does nothing.
local function on_map_loaded() end

--- Plays the cutscene in which the party faces the griffon and a boss descends in a burst of light.
local function play_griffon_summoning_cutscene()
	local playable_character: s32 = 0
	local sound_bank: s32 = 0
	local telop_block: s32 = 0
	vm.section(function()
		event.set_save_flag(716, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.show_dungeon_status_bar(0, 1.0)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		playable_character = event.get_playable_character() or playable_character
		wait.for_frame_count(4)
		event.load_music(117)
		event.load_map_sounds(7823)
		sound_bank = event.load_sound_effect_file_2(7823) or sound_bank
		event.set_scene_status_flags(1, 0, 256, 1)
		event.change_directory("event/e700/e716/")
		event.load_message_file(0, 5, "e716.txt")
		if playable_character == 0 then
			event.load_character_motion_pack(5, "e716_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if playable_character == 1 then
			event.load_character_motion_pack(5, "e716_monica.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.load_character(5, "e716_griffon.gltf", "info", 10)
		event.set_character_active(10)
		event.attach_object_handle_to_character(2, 10)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.load_character(5, "e716_boss08a.gltf", "info", 11)
		event.set_character_active(0, 11)
		event.attach_object_handle_to_character(3, 11)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.load_character(5, "e716_hikari.gltf", "info", 12)
		event.set_character_active(0, 12)
		event.attach_object_handle_to_character(5, 12)
		event.clear_object_sequence(5)
		event.set_object_sequence_object(5, 5)
		event.load_character(5, "e716_hikari1.gltf", "info", 13)
		event.set_character_active(0, 13)
		event.attach_object_handle_to_character(6, 13)
		event.clear_object_sequence(6)
		event.set_object_sequence_object(6, 6)
		event.load_character(5, "e716_rolling.gltf", "info", 14)
		event.set_character_active(0, 14)
		telop_block = event.load_event_image_4(5, "e716telop01.json", 0) or telop_block
		event.reset_event_sprite(0)
		event.set_event_sprite_type(0, 0)
		event.set_event_sprite_texture(0, "e716telop01", telop_block)
		event.set_event_sprite_color(0, 128, 128, 128, 0)
		event.set_event_sprite_texture_rect(0, 0, 0, 512, 128)
		event.set_event_sprite_size(0, 512, 128)
		event.set_event_sprite_position(0, 256, 272)
		event.set_event_sprite_alpha_blend(0, 0)
		event.set_event_sprite_draw_pass(0, 0)
		event.attach_object_handle_to_sprite(4, 0)
		event.clear_object_sequence(4)
		event.set_object_sequence_object(4, 4)
		event.change_directory("")
		if playable_character == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 8)
			event.load_equipment_model(5, 0, 4, "info", 8)
			event.load_equipment_model(5, 0, 3, "info", 8)
			event.load_equipment_model(5, 0, 2, "info", 8, 9)
			event.load_character_motion_pack(5, "event/e700/e716/e716_mints.gltf", "info", 8)
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
			event.load_character_motion_pack(5, "event/e700/e716/e716_monica.gltf", "info", 8)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 8)
			event.attach_object_handle_to_character(1, 8)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 0)
		end
		event.set_character_active(8)
		event.set_character_active(9)
		event.set_character_visible(1, 0)
		event.set_character_visible(2, 0)
		event.set_object_handle_position(0, -8.0, 40.0, -1100.0)
		event.set_object_handle_rotation(0, 0.0, 0.0, 0.0)
		event.set_object_handle_motion(0, "立ち", 4)
		event.set_object_handle_footstep_sound(0, 2)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "おこり顔")
		event.set_object_handle_texture_animation(0, 1, "おこり目パチ")
		event.set_object_handle_position(1, 8.0, 40.0, -1100.0)
		event.set_object_handle_rotation(1, 0.0, 0.0, 0.0)
		event.set_object_handle_motion(1, "立ち", 4)
		event.set_object_handle_footstep_sound(1, 2)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "おこり顔")
		event.set_object_handle_texture_animation(1, 1, "おこり目パチ")
		event.set_object_handle_position(2, 0.0, 0.0, 0.0)
		event.set_object_handle_rotation(2, 0.0, 3.14, 0.0)
		event.set_object_handle_motion(2, "立ち（後ろ）", 4)
		event.set_object_handle_footstep_sound(2, 2)
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(6.27, 44.45, -1056.3)
		event.set_camera_sequence_look_at(-5.8, 72.27, -1139.67)
		event.fade_in_screen(30)
		wait.for_frame_count(70)
		event.set_camera_sequence_position(0.0, 45.57, -821.24)
		event.set_camera_sequence_look_at(0.0, 62.17, -781.76)
		event.move_camera_sequence_eased(0.0, 45.57, -821.24, 0.0, 44.79, -764.81, 60, 2, 0.4)
		event.play_music(0)
		wait.for_frame_count(50)
		event.play_sound_effect(sound_bank, 0)
		event.set_object_sequence_motion(2, "後ろ向きから振り返り", 6)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		camera.wait_until_done()
		event.start_crossfade(30)
		event.set_camera_sequence_position(0.0, 51.5, -47.79)
		event.set_camera_sequence_look_at(0.0, 51.5, 7.22)
		object.wait_until_done(2)
		event.set_mouth_motions(2, "会話", 0, "立ち", 0)
		message.show_voiced(7160010)
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(100)
		event.add_camera_sequence_path_point(0.0, 67.68, -429.93, 0.0, 66.4, -374.92)
		event.add_camera_sequence_path_point(0.0, 53.12, -422.5, 0.0, 51.84, -367.49)
		event.add_camera_sequence_path_point(0.0, 39.11, -416.35, 0.0, 37.83, -361.34)
		event.add_camera_sequence_path_point(0.0, 22.09, -390.47, 0.0, 20.81, -335.46)
		event.start_camera_sequence_path()
		event.set_object_sequence_position(0, -9.0, 0.0, -400.0)
		event.move_object_sequence(0, -9.0, 0.0, -300.0, 100)
		event.set_object_sequence_motion(0, "歩き", 4)
		event.delay_object_sequence_motion_track(0, 100)
		event.set_object_sequence_motion(0, "立ち")
		event.set_object_sequence_position(1, 9.0, 0.0, -400.0)
		event.move_object_sequence(1, 9.0, 0.0, -300.0, 100)
		event.set_object_sequence_motion(1, "歩き", 4)
		event.delay_object_sequence_motion_track(1, 100)
		event.set_object_sequence_motion(1, "立ち")
		object.wait_until_done(1)
		camera.wait_until_done()
		event.start_crossfade(60)
		event.set_camera_sequence_position(6.0, 55.51, -39.78)
		event.set_camera_sequence_look_at(6.0, 54.23, 15.23)
		event.move_camera_sequence(-2.0, 55.51, -39.78, -2.0, 54.23, 15.23, 90)
		camera.wait_until_done()
		event.set_camera_sequence_position(-36.97, 20.61, -265.32)
		event.set_camera_sequence_look_at(7.39, 19.33, -299.35)
		event.set_object_sequence_motion(0, "グリフォン！！", 6)
		event.queue_object_sequence_next_motion(0, "グリフォン！！L", 4)
		event.delay_object_sequence_sound_track(0, 10)
		event.play_object_sequence_sound(0, sound_bank, 1)
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced(7160020)
		event.set_object_sequence_motion(1, "指差し", 6)
		event.queue_object_sequence_next_motion(1, "指差しL", 4)
		event.delay_object_sequence_sound_track(1, 10)
		event.play_object_sequence_sound(1, sound_bank, 2)
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced(7160030)
		event.start_crossfade(30)
		event.set_camera_sequence_position(-8.0, 20.0, -338.23)
		event.set_camera_sequence_look_at(-8.0, 20.0, -277.78)
		event.move_camera_sequence_eased(0.0, 20.0, -338.23, 0.0, 20.0, -277.78, 90, 2, 0.3)
		event.set_mouth_motions(2, "会話", 0, "立ち", 0)
		message.show_voiced(7160040)
		event.set_mouth_motions(2, "会話", 0, "立ち", 0)
		message.show_voiced(7160045)
		camera.wait_until_done()
		event.start_crossfade(30)
		event.set_camera_sequence_position(-8.0, 52.0, -59.19)
		event.set_camera_sequence_look_at(-8.0, 52.0, 15.23)
		event.move_camera_sequence_eased(0.0, 52.0, -59.19, 0.0, 52.0, 15.23, 90, 2, 0.3)
		event.set_mouth_motions(2, "会話", 0, "立ち", 0)
		message.show_voiced(7160050)
		camera.wait_until_done()
		event.start_crossfade(30)
		event.set_camera_sequence_position(-4.0, 56.21, -28.1)
		event.set_camera_sequence_look_at(-4.0, 56.16, 15.23)
		event.move_camera_sequence_eased(0.0, 56.21, -28.1, 0.0, 56.16, 15.23, 90, 2, 0.3)
		event.set_mouth_motions(2, "会話", 0, "立ち", 0)
		message.show_voiced(7160060)
		camera.wait_until_done()
		event.set_object_sequence_motion(2, "手広げ", 2)
		event.queue_object_sequence_next_motion(2, "手広げＬ", 4)
		event.delay_object_sequence_sound_track(2, 10)
		event.play_object_sequence_sound(2, sound_bank, 3)
		event.move_camera_sequence_eased(0.0, 30.2, -186.75, 0.0, 49.5, 15.23, 40, 0, 0.2)
		wait.for_frame_count(20)
		event.set_character_position(14, 0.0, 0.0, 0.0)
		event.set_character_position(14, 0.0, 0.0, 0.0)
		event.set_character_motion(14, "手広げＬ", 6)
		event.set_character_active(1, 14)
		camera.wait_until_done()
		event.set_camera_sequence_position(-36.48, 7.72, -377.14)
		event.set_camera_sequence_look_at(-28.24, 21.42, -338.45)
		event.set_object_sequence_motion(0, "上向く", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(0, "上向くL", 4)
		event.set_object_sequence_motion(1, "上向く", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(1, "上向くL", 4)
		event.move_object_sequence(2, 0.0, 160.0, 0.0, 60)
		event.set_object_sequence_motion(2, "回る", 6)
		event.queue_object_sequence_next_motion(2, "放つ", 6)
		event.queue_object_sequence_next_motion(2, "放つＬ", 4)
		event.set_character_active(1, 12)
		event.set_character_visible(12, 1, 1, 0.025)
		event.set_object_sequence_position(5, 0.0, 40.0, -10.0)
		event.set_object_sequence_rotation(5, 0.0, 0.0, 0.0)
		event.move_object_sequence(5, 0.0, 200.0, -10.0, 60)
		wait.for_frame_count(100)
		event.set_character_active(1, 13)
		event.set_object_sequence_position(6, 0.0, 200.0, -10.0)
		event.set_object_sequence_rotation(6, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(6, "放つＬ", 6)
		wait.for_frame_count(60)
		event.set_camera_sequence_position(-9.86, 51.69, -251.99)
		event.set_camera_sequence_look_at(1.75, 8.15, -309.3)
		event.move_camera_sequence_eased(-7.66, 45.43, -262.87, 1.75, 8.15, -309.3, 60, 2, 0.2)
		event.set_object_handle_texture_animation(0, 1, "半口")
		event.set_object_handle_texture_animation(1, 1, "半口")
		event.set_object_sequence_rotation(0, 0.0, 0.12, 0.0)
		event.set_object_sequence_motion(0, "上向くL", 4, -1.0, 1)
		event.set_object_sequence_rotation(1, 0.0, -0.12, 0.0)
		event.set_object_sequence_motion(1, "上向くL", 4, -1.0, 1)
		event.set_character_active(0, 12)
		event.set_character_active(0, 13)
		event.set_character_position(12, 0.0, 200.0, 0.0)
		event.set_character_rotation(12, 0.0, 0.0, 0.0)
		event.set_character_motion(12, "手広げＬ", 4)
		camera.wait_until_done()
		event.set_camera_sequence_position(0.0, 200.0, -340.0)
		event.set_camera_sequence_look_at(0.0, 200.0, 0.0)
		event.move_camera_sequence_eased(0.0, 200.0, -130.0, 0.0, 200.0, 0.0, 120, 2, 0.2)
		event.set_character_active(0, 10)
		event.set_character_active(1, 11)
		event.set_object_sequence_position(3, 0.0, 160.0, 0.0)
		event.set_object_sequence_rotation(3, 0.0, 3.14, 0.0)
		event.set_object_sequence_motion(3, "立ち", 4)
		wait.for_frame_count(6)
		event.play_sound_effect(sound_bank, 4)
		wait.for_frame_count(34)
		event.queue_object_sequence_next_motion(3, "舞", 6)
		event.queue_object_sequence_next_motion(3, "舞Ｌ", 4)
		object.wait_until_done(3)
		event.set_event_sprite_draw_pass(0, 1)
		event.delay_object_sequence_color_track(4, 30)
		event.set_object_sequence_color(4, 128, 128, 128, 128, 30)
		event.delay_object_sequence_color_track(4, 90)
		event.set_object_sequence_color(4, 128, 128, 128, 0, 30)
		message.show_voiced_for_stopping(7160070, -1)
		wait.for_frame_count(30)
		event.fade_out_music(30)
		event.fade_out_screen(30)
		wait.for_frame_count(30)
	end)
	event.cancel_drama_scene_skip()
	event.stop_sound_effect(sound_bank, 3)
	event.stop_sound_effect(sound_bank, 4)
	event.set_event_sprite_draw_pass(0, 0)
	event.set_scene_status_flags(1, 0, 256, 0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.set_character_visible(1, 1)
	event.set_character_visible(2, 1)
	event.delete_character_extension_packs(0)
	event.delete_character(8)
	event.delete_character(9)
	event.delete_character(10)
	event.delete_character(11)
	event.delete_character(12)
	event.delete_character(13)
	event.delete_character(14)
	event.load_message_file(0, -1)
	event.delete_event_image(0)
	event.stop_music(0)
	wait.for_frame_count(4)
	event.load_music(41)
	event.play_music(0)
	event.show_dungeon_status_bar(1, 1.0)
	event.finish_event()
end

--- Loads the party, their equipment and the boss models used by the boss drop cutscene.
local function load_boss_drop_scene_actors()
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
		drop_scene_max_slot = 0
		drop_scene_monica_slot = 8
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", drop_scene_max_slot)
		event.load_character_motion_pack(5, "event/e700/e728/e728_mints.gltf", "info", drop_scene_max_slot)
		event.attach_object_handle_to_character(0, drop_scene_max_slot)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, drop_scene_max_slot)
		event.load_character(5, "chara/c02_base.gltf", "info", drop_scene_monica_slot)
		event.load_equipment_model(5, 1, 1, "info", drop_scene_monica_slot, 17)
		event.load_equipment_model(5, 1, 0, "info", drop_scene_monica_slot, 18)
		event.load_equipment_model(5, 1, 4, "info", drop_scene_monica_slot)
		event.load_equipment_model(5, 1, 3, "info", drop_scene_monica_slot)
		event.load_equipment_model(5, 1, 2, "info", drop_scene_monica_slot, 13)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", drop_scene_monica_slot)
		event.load_character_motion_pack(5, "event/e700/e728/e728_monica.gltf", "info", drop_scene_monica_slot)
		event.attach_object_handle_to_character(1, drop_scene_monica_slot)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, drop_scene_monica_slot)
		event.set_character_active(1, 13)
	end
	if playable_character == 1 then
		drop_scene_max_slot = 8
		drop_scene_monica_slot = 0
		event.load_character(5, "chara/c01_base.gltf", "info", drop_scene_max_slot)
		event.load_equipment_model(5, 0, 1, "info", drop_scene_max_slot, 17)
		event.load_equipment_model(5, 0, 0, "info", drop_scene_max_slot, 18)
		event.load_equipment_model(5, 0, 4, "info", drop_scene_max_slot)
		event.load_equipment_model(5, 0, 3, "info", drop_scene_max_slot)
		event.load_equipment_model(5, 0, 2, "info", drop_scene_max_slot, 13)
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", drop_scene_max_slot)
		event.load_character_motion_pack(5, "event/e700/e728/e728_mints.gltf", "info", drop_scene_max_slot)
		event.attach_object_handle_to_character(0, drop_scene_max_slot)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, drop_scene_max_slot)
		event.set_character_active(1, 13)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", drop_scene_monica_slot)
		event.load_character_motion_pack(5, "event/e700/e728/e728_monica.gltf", "info", drop_scene_monica_slot)
		event.attach_object_handle_to_character(1, drop_scene_monica_slot)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, drop_scene_monica_slot)
	end
	event.load_character(5, "event/e700/e728/e728_boss10a.gltf", "info", 19)
	event.set_character_active(0, 19)
	event.attach_object_handle_to_character(11, 19)
	event.clear_object_sequence(11, 19)
	event.set_object_sequence_object(11, 11)
	event.load_character(5, "event/e700/e728/e728_particle.gltf", "info", 10)
	event.set_character_active(0, 10)
	event.set_character_active(1, 17)
	event.set_character_active(1, 18)
	event.load_message_file(0, 5, "event/e700/e728/e728.txt")
end

--- Assigns the Max and Monica actor slots to the layout used with Monica leading, so skipping the awakening cutscene cleans up the right actors.
local function set_awakening_skip_slots()
	local active_character: s32 = 0
	local _ = active_character == 2
	active_character = 0
	local _ = active_character == 3
	active_character = 1
	drop_scene_max_slot = 0
	drop_scene_monica_slot = 8
	drop_scene_max_slot = 8
	drop_scene_monica_slot = 0
end

--- Removes the boss drop cutscene actors and restores the party.
local function unload_boss_drop_scene()
	local playable_character: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 0 then
		event.set_character_active(1, drop_scene_max_slot)
		event.set_character_active(0, drop_scene_monica_slot)
		event.delete_character_extension_packs(drop_scene_max_slot)
		event.delete_character_extension_packs(drop_scene_monica_slot)
		event.delete_character(drop_scene_monica_slot)
		event.delete_character(13)
		event.delete_character(17)
		event.delete_character(18)
	end
	if playable_character == 1 then
		event.set_character_active(1, drop_scene_monica_slot)
		event.set_character_active(0, drop_scene_max_slot)
		event.delete_character_extension_packs(drop_scene_max_slot)
		event.delete_character_extension_packs(drop_scene_monica_slot)
		event.delete_character(drop_scene_max_slot)
		event.delete_character(13)
		event.delete_character(17)
		event.delete_character(18)
	end
	event.delete_character(19)
	event.delete_character(10)
	event.attach_object_handle_to_character(2, 1)
	event.set_object_handle_visible(2, 1)
	event.attach_object_handle_to_character(3, 2)
	event.set_object_handle_visible(3, 1)
	event.show_dungeon_status_bar(1, 1.0)
	event.finish_event()
end

--- Plays the cutscene of the boss dropping into the room in front of the party.
local function play_boss_drop_cutscene()
	local sound_bank: s32 = 0
	local saved_projection: f32 = 0
	local step: number = 0
	vm.section(function()
		step = 1
		vm.entry(1)
		event.set_save_flag(728, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.stop_music(0)
		event.load_map_sounds(7831)
		sound_bank = event.load_sound_effect_file_2(7831) or sound_bank
		load_boss_drop_scene_actors()
		saved_projection = event.get_event_projection() or saved_projection
		event.enable_drama_skip()
		event.attach_object_handle_to_character(2, 1)
		event.set_object_handle_visible(2, 0)
		event.attach_object_handle_to_character(3, 2)
		event.set_object_handle_visible(3, 0)
		event.set_character_active(0, 17)
		event.set_character_active(0, 18)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目パチ")
		event.set_character_active(1, drop_scene_max_slot)
		event.set_character_active(1, drop_scene_monica_slot)
		event.set_character_active(1, 19)
		event.set_camera_sequence_position(-67.28, 15.66, -27.15)
		event.set_camera_sequence_look_at(-7.11, 7.02, -6.4)
		event.set_object_sequence_position(11, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(11, 0.0, 3.12, 0.0)
		event.set_object_sequence_position(0, -10.0, 0.0, -90.19)
		event.set_object_sequence_rotation(0, 0.0, 0.12, 0.0)
		event.set_object_sequence_position(1, 10.0, 0.0, -90.73)
		event.set_object_sequence_rotation(1, 0.0, -0.12, 0.0)
		event.fade_in_screen(30)
		event.set_object_sequence_motion(11, "立ち4", 4)
		event.set_object_sequence_motion(0, "立ち", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "立ち", 4, -1.0, 1)
		step = 2
		wait.for_frame_count(15)
		event.play_sound_effect(sound_bank, 0)
		event.set_object_sequence_motion(11, "ドスッ", 2)
		event.queue_object_sequence_next_motion(11, "ドスッＬ", 4)
		step = 3
		wait.for_frame_count(30)
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(200)
		event.add_camera_sequence_path_point(-67.28, 15.66, -27.15, -7.11, 7.02, -6.4)
		event.add_camera_sequence_path_point(-67.28, 40.31, -27.15, -7.11, 31.68, -6.4)
		event.start_camera_sequence_path()
		step = 4
		message.show_voiced_for_stopping(7280010, -1)
		step = 5
		camera.wait_until_done()
		event.set_camera_sequence_position(0.0, 4.51, -46.14)
		event.set_camera_sequence_look_at(0.0, 30.71, -128.08)
		step = 6
		wait.for_frame_count(30)
		event.play_sound_effect(sound_bank, 1)
		event.set_character_position(10, 0.0, 0.0, 0.0)
		event.set_character_rotation(10, 0.0, 3.12, 0.0)
		event.set_character_motion(10, "ドスッＬ")
		event.set_character_active(1, 10)
		event.set_camera_sequence_position(0.0, 18.36, -103.26)
		event.set_camera_sequence_look_at(0.0, 27.17, 0.0)
		step = 7
		wait.for_frame_count(30)
		event.set_character_visible(10, 0, 1, 0.0033)
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(300)
		event.add_camera_sequence_path_point(0.0, 18.36, -103.26, 0.0, 27.17, 0.0)
		event.add_camera_sequence_path_point(0.0, 88.44, -103.26, 0.0, 97.25, 0.0)
		event.start_camera_sequence_path()
		step = 8
		camera.wait_until_done()
	end, function(received: { any }): boolean
		if step <= 1 then
			set_awakening_skip_slots()
			wait.skip_frame_count(15)
		end
		if step <= 2 then
			wait.skip_frame_count(30)
		end
		if step <= 3 then
			message.show_voiced_for_stopping_skipping(7280010, -1)
		end
		if step <= 4 then
			wait.background_load_skipping()
		end
		if step <= 5 then
			wait.skip_frame_count(30)
		end
		if step <= 6 then
			wait.skip_frame_count(30)
		end
		if step <= 7 then
			wait.background_load_skipping()
		end
		return true
	end)
	step = 9
	vm.entry(9)
	event.cancel_drama_scene_skip()
	event.fade_out_camera_sequence(60, 255.0, 255.0, 255.0)
	step = 10
	wait.for_frame_count(60)
	event.stop_port_sound_effects(4)
	event.skip_next_music_load()
	step = 11
	vm.wait(11)
	event.set_event_projection(saved_projection)
	unload_boss_drop_scene()
end

--- Fades out, plays the boss drop cutscene and moves to the s44 map.
local function exit_to_s44_after_boss_drop()
	local playable_character: s32 = 0
	local current_character: s32 = 0
	local step: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.reset_action_character_motion(0)
		event.fade_out_music(20)
		event.fade_out_screen(20)
		step = 1
		wait.for_frame_count(20)
		event.stop_all_sounds()
		step = 2
		vm.wait(2)
		playable_character = event.get_playable_character() or playable_character
		event.set_character_status(playable_character, 8, 1)
		event.clear_event_battle_monsters(-1)
		current_character = event.get_playable_character() or current_character
		if current_character == 2 then
			event.switch_dungeon_main_character(0)
		end
		if current_character == 3 then
			event.switch_dungeon_main_character(1)
		end
		step = 3
		wait.for_frame_count(30)
		step = 4
		play_boss_drop_cutscene()
		event.skip_next_music_load()
		event.load_dungeon_map("s44")
		event.load_event_script("s44/s44.stb", 510)
		return
	end, function(received: { any })
		if step <= 4 then
			if step <= 2 then
				wait.skip_frame_count(30)
			end
			if step <= 3 then
				step = 4
				play_boss_drop_cutscene()
				return vm.continue_with(function()
					event.skip_next_music_load()
					event.load_dungeon_map("s44")
					event.load_event_script("s44/s44.stb", 510)
					return
				end)
			end
			return 0
		end
		return nil
	end)
end

--- Plays the cutscene in which a boss lands, spreads its wings and releases feathers before the battle music starts.
local function play_boss_wing_spread_cutscene()
	local sound_bank: s32 = 0
	vm.section(function()
		event.initialize_event()
		event.set_save_flag(720, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.stop_music(0)
		wait.for_frame_count(4)
		event.load_music(38)
		event.load_map_sounds(7827)
		sound_bank = event.load_sound_effect_file_2(7827) or sound_bank
		event.set_character_active(0, 0)
		event.change_directory("event/e700/e720/")
		event.load_character(5, "e720_boss08a.gltf", "info", 12)
		event.set_character_active(12)
		event.attach_object_handle_to_character(2, 12)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.load_character(5, "e720_boss09a.gltf", "info", 13)
		event.set_character_active(0, 13)
		event.attach_object_handle_to_character(3, 13)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.load_character(5, "e720_eye.gltf", "info", 14)
		event.set_character_active(0, 14)
		event.load_character(5, "e720_hane.gltf", "info", 15)
		event.set_character_active(0, 15)
		event.load_character(5, "e720_hane2.gltf", "info", 16)
		event.set_character_active(0, 16)
		event.change_directory("")
		event.load_character(5, "chara/c01_base.gltf", "info", 8)
		event.load_equipment_model(5, 0, 4, "info", 8)
		event.load_equipment_model(5, 0, 3, "info", 8)
		event.load_equipment_model(5, 0, 2, "info", 8, 9)
		event.load_character_motion_pack(5, "event/e700/e720/e720_mints.gltf", "info", 8)
		event.set_character_active(8)
		event.set_character_active(9)
		event.attach_object_handle_to_character(0, 8)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.load_character(5, "chara/c02_base.gltf", "info", 10)
		event.load_equipment_model(5, 1, 4, "info", 10)
		event.load_equipment_model(5, 1, 3, "info", 10)
		event.load_equipment_model(5, 1, 2, "info", 10, 11)
		event.load_character_motion_pack(5, "event/e700/e720/e720_monica.gltf", "info", 10)
		event.set_character_active(10)
		event.set_character_active(11)
		event.attach_object_handle_to_character(1, 10)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_object_handle_position(0, -8.0, 0.0, -300.0)
		event.set_object_handle_rotation(0, 0.0, 0.0, 0.0)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "おこり顔")
		event.set_object_handle_texture_animation(0, 1, "おこり目パチ")
		event.set_object_handle_position(1, 8.0, 0.0, -300.0)
		event.set_object_handle_rotation(1, 0.0, 0.0, 0.0)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "おこり顔")
		event.set_object_handle_texture_animation(1, 1, "おこり目パチ")
		event.set_object_handle_position(2, 0.0, 0.0, 0.0)
		event.set_object_handle_rotation(2, 0.0, 3.14, 0.0)
		event.set_object_handle_footstep_sound(2, 2)
		event.set_object_handle_position(3, 0.0, 0.0, 0.0)
		event.set_object_handle_rotation(3, 0.0, 3.14, 0.0)
		event.set_character_position(14, 0.0, 54.23, -19.48)
		event.set_character_rotation(14, 0.0, 3.14, 0.0)
		event.set_character_position(15, 0.0, 0.0, 0.0)
		event.set_character_rotation(15, 0.0, 3.14, 0.0)
		event.set_character_position(16, 0.0, 0.0, -300.0)
		event.set_character_rotation(16, 0.0, -0.3, 0.0)
		event.enable_drama_skip()
		event.set_object_sequence_motion(2, "落ち立つ", 6)
		event.queue_object_sequence_next_motion(2, "落ち立つＬ", 4)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(0.0, 47.27, -59.93)
		event.set_camera_sequence_look_at(0.0, 54.56, 0.0)
		event.play_sound_effect(sound_bank, 0)
		event.fade_in_screen(30)
		wait.for_frame_count(60)
		event.play_sound_effect(sound_bank, 1)
		event.move_camera_sequence_eased(0.0, 13.39, -110.66, 0.0, 40.47, 0.0, 40, 0, 0.2)
		camera.wait_until_done()
		wait.for_frame_count(6)
		event.set_camera_sequence_position(-10.28, 38.76, -46.62)
		event.set_camera_sequence_look_at(-43.29, 78.66, 15.21)
		event.play_sound_effect(sound_bank, 2)
		event.set_object_sequence_motion(2, "羽広げ", 6)
		event.wait_object_sequence_motion_end(2)
		object.wait_until_done(2)
		event.set_camera_sequence_position(10.28, 38.76, -46.62)
		event.set_camera_sequence_look_at(43.29, 78.66, 15.21)
		event.play_sound_effect(sound_bank, 2)
		event.reset_object_sequence_motion(2)
		event.set_object_sequence_motion(2, "羽広げ", 6)
		event.wait_object_sequence_motion_end(2)
		object.wait_until_done(2)
		event.set_camera_sequence_position(0.0, 24.76, -90.76)
		event.set_camera_sequence_look_at(0.0, 52.6, 0.0)
		event.play_sound_effect(sound_bank, 3)
		event.set_object_sequence_motion(2, "掴む", 6)
		event.queue_object_sequence_next_motion(2, "掴むＬ", 4)
		object.wait_until_done(2)
		event.set_camera_sequence_position(0.0, 48.79, -25.5)
		event.set_camera_sequence_look_at(0.0, 58.19, -16.62)
		event.play_sound_effect(sound_bank, 4)
		event.set_character_active(0, 12)
		event.set_character_active(1, 13)
		event.set_character_active(1, 14)
		event.set_character_motion(14, "光る", 6)
		wait.for_frame_count(20)
		event.set_camera_sequence_position(-29.82, 47.88, -38.26)
		event.set_camera_sequence_look_at(-0.06, 56.08, -3.93)
		event.move_camera_sequence_eased(-115.99, 6.24, -137.7, -0.06, 47.97, -3.93, 40, 2, 1.0)
		event.play_sound_effect(sound_bank, 5)
		event.set_character_active(0, 14)
		event.set_character_active(1, 15)
		event.set_object_sequence_motion(3, "バサ", 6)
		event.queue_object_sequence_next_motion(3, "バサＬ", 4)
		event.set_character_motion(15, "バサ", 6)
		camera.wait_until_done()
		wait.for_frame_count(60)
		event.set_camera_sequence_position(-30.14, 11.81, -262.23)
		event.set_camera_sequence_look_at(0.94, 19.52, -298.52)
		event.set_character_active(0, 15)
		event.set_character_active(1, 16)
		event.set_character_motion(16, "舞う羽根", 6)
		wait.for_frame_count(240)
		event.set_camera_sequence_position(0.0, 34.0, -110.0)
		event.set_camera_sequence_look_at(0.0, 34.0, -20.0)
		event.play_sound_effect(sound_bank, 6)
		event.set_object_sequence_motion(3, "構え", 6)
		event.queue_object_sequence_next_motion(3, "構えＬ", 4)
		object.wait_until_done(3)
		wait.for_frame_count(40)
		event.fade_out_screen(30)
		wait.for_frame_count(30)
	end)
	event.cancel_drama_scene_skip()
	event.play_music(0)
	event.delete_character(8)
	event.delete_character(9)
	event.delete_character(10)
	event.delete_character(11)
	event.delete_character(12)
	event.delete_character(13)
	event.delete_character(14)
	event.delete_character(15)
	event.delete_character(16)
	event.load_message_file(0, -1)
	event.set_character_active(1, 0)
	event.finish_event()
end

--- Plays the cutscene in which the two bosses awaken and breathe fire before the battle music starts.
local function play_boss_fire_awakening_cutscene()
	local sound_bank: s32 = 0
	vm.section(function()
		event.initialize_event()
		event.set_save_flag(724, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.stop_music(0)
		event.load_map_sounds(7830)
		sound_bank = event.load_sound_effect_file_2(7830) or sound_bank
		event.set_character_active(0, 0)
		event.change_directory("event/e700/e724/")
		event.load_character(5, "e724_boss09a.gltf", "info", 12)
		event.set_character_active(12)
		event.attach_object_handle_to_character(2, 12)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.load_character(5, "e724_boss10a.gltf", "info", 13)
		event.set_character_active(0, 13)
		event.attach_object_handle_to_character(3, 13)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.change_directory("")
		event.load_character(5, "chara/c01_base.gltf", "info", 8)
		event.load_equipment_model(5, 0, 4, "info", 8)
		event.load_equipment_model(5, 0, 3, "info", 8)
		event.load_equipment_model(5, 0, 2, "info", 8, 9)
		event.load_character_motion_pack(5, "event/e700/e724/e724_mints.gltf", "info", 8)
		event.set_character_active(0, 8)
		event.set_character_active(0, 9)
		event.attach_object_handle_to_character(0, 8)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.load_character(5, "chara/c02_base.gltf", "info", 10)
		event.load_equipment_model(5, 1, 4, "info", 10)
		event.load_equipment_model(5, 1, 3, "info", 10)
		event.load_equipment_model(5, 1, 2, "info", 10, 11)
		event.load_character_motion_pack(5, "event/e700/e724/e724_monica.gltf", "info", 10)
		event.set_character_active(0, 8)
		event.set_character_active(0, 9)
		event.set_character_active(0, 10)
		event.set_character_active(0, 11)
		event.attach_object_handle_to_character(1, 10)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.initialize_effect_manager(5)
		event.load_effect_base("グリ炎")
		event.create_effect_work_buffer(5)
		event.set_object_handle_position(0, -15.0, 0.0, -100.0)
		event.set_object_handle_rotation(0, 0.0, 0.24, 0.0)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "おこり顔")
		event.set_object_handle_texture_animation(0, 1, "おこり目パチ")
		event.set_object_handle_position(1, 15.0, 0.0, -100.0)
		event.set_object_handle_rotation(1, 0.0, -0.24, 0.0)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "おこり顔")
		event.set_object_handle_texture_animation(1, 1, "おこり目パチ")
		event.set_object_handle_position(2, 0.0, 0.0, 0.0)
		event.set_object_handle_rotation(2, 0.0, 3.14, 0.0)
		event.set_object_handle_footstep_sound(2, 2)
		event.set_object_handle_position(3, 0.0, 0.0, 0.0)
		event.set_object_handle_rotation(3, 0.0, 3.14, 0.0)
		event.enable_drama_skip()
		event.set_object_sequence_motion(2, "ドスン", 6)
		event.queue_object_sequence_next_motion(2, "ドスンＬ", 4)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(0.0, 9.34, -123.04)
		event.set_camera_sequence_look_at(0.0, 27.06, -41.89)
		event.fade_in_screen(30)
		wait.for_frame_count(4)
		event.play_sound_effect(sound_bank, 0)
		wait.for_frame_count(66)
		event.set_camera_sequence_position(-27.3, 38.14, -3.46)
		event.set_camera_sequence_look_at(2.7, 38.14, -3.48)
		event.set_character_active(0, 12)
		event.set_character_active(1, 13)
		event.set_object_sequence_motion(3, "ブルブル", 4)
		wait.for_frame_count(40)
		event.move_camera_sequence_eased(-28.75, 59.94, -54.17, -0.03, 57.31, -6.26, 40, 0, 0.1)
		event.play_sound_effect(sound_bank, 1)
		event.set_object_sequence_motion(3, "ガバッ！", 2)
		event.queue_object_sequence_next_motion(3, "ガバッ！Ｌ", 4)
		object.wait_until_done(3)
		event.move_camera_sequence_eased(-28.74, 34.61, -53.85, -0.01, 38.28, -6.24, 40, 0, 1.0)
		wait.for_frame_count(40)
		event.play_sound_effect(sound_bank, 2)
		event.create_effect_2("グリ炎", 13)
		camera.wait_until_done()
		wait.for_frame_count(20)
		event.set_camera_sequence_position(-10.62, 51.43, -49.36)
		event.set_camera_sequence_look_at(-0.01, 57.74, -6.24)
		event.set_object_sequence_motion(3, "顔向ける", 2)
		event.queue_object_sequence_next_motion(3, "顔向けるＬ", 4)
		event.delay_object_sequence_sound_track(3, 10)
		event.play_object_sequence_sound(3, sound_bank, 3)
		object.wait_until_done(3)
		event.set_camera_sequence_position(0.0, 34.11, -66.77)
		event.set_camera_sequence_look_at(0.0, 38.24, -8.51)
		event.move_camera_sequence_eased(0.0, 13.84, -155.54, 0.0, 34.07, -8.51, 40, 2, 0.2)
		event.set_character_active(1, 8)
		event.set_character_active(1, 9)
		event.set_character_active(1, 10)
		event.set_character_active(1, 11)
		event.set_object_sequence_motion(3, "構え", 2)
		event.queue_object_sequence_next_motion(3, "構えＬ", 4)
		event.delay_object_sequence_sound_track(3, 16)
		event.play_object_sequence_sound(3, sound_bank, 4)
		camera.wait_until_done()
		wait.for_frame_count(20)
		event.fade_out_screen(30)
		wait.for_frame_count(30)
	end)
	event.cancel_drama_scene_skip()
	event.stop_sound_effect(sound_bank, 0)
	event.stop_sound_effect(sound_bank, 1)
	event.stop_sound_effect(sound_bank, 2)
	event.stop_sound_effect(sound_bank, 3)
	event.stop_sound_effect(sound_bank, 4)
	event.load_music(38)
	event.play_music(0)
	event.delete_character(8)
	event.delete_character(9)
	event.delete_character(10)
	event.delete_character(11)
	event.delete_character(12)
	event.delete_character(13)
	event.load_message_file(0, -1)
	event.delete_event_image(0)
	event.clear_effect_manager()
	event.set_character_active(1, 0)
	event.finish_event()
end

--- Loads the party, the three colored forms and the smoke and lightning models used by the awakening cutscene.
local function load_boss_awakening_scene_actors()
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
		awakening_scene_max_slot = 0
		awakening_scene_monica_slot = 8
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", awakening_scene_max_slot)
		event.load_character_motion_pack(5, "event/e700/e728/e728_mints.gltf", "info", awakening_scene_max_slot)
		event.attach_object_handle_to_character(0, awakening_scene_max_slot)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, awakening_scene_max_slot)
		event.load_character(5, "chara/c02_base.gltf", "info", awakening_scene_monica_slot)
		event.load_equipment_model(5, 1, 1, "info", awakening_scene_monica_slot, 17)
		event.load_equipment_model(5, 1, 0, "info", awakening_scene_monica_slot, 18)
		event.load_equipment_model(5, 1, 4, "info", awakening_scene_monica_slot)
		event.load_equipment_model(5, 1, 3, "info", awakening_scene_monica_slot)
		event.load_equipment_model(5, 1, 2, "info", awakening_scene_monica_slot, 13)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", awakening_scene_monica_slot)
		event.load_character_motion_pack(5, "event/e700/e728/e728_monica.gltf", "info", awakening_scene_monica_slot)
		event.attach_object_handle_to_character(1, awakening_scene_monica_slot)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, awakening_scene_monica_slot)
		event.set_character_active(1, 13)
	end
	if playable_character == 1 then
		awakening_scene_max_slot = 8
		awakening_scene_monica_slot = 0
		event.load_character(5, "chara/c01_base.gltf", "info", awakening_scene_max_slot)
		event.load_equipment_model(5, 0, 1, "info", awakening_scene_max_slot, 17)
		event.load_equipment_model(5, 0, 0, "info", awakening_scene_max_slot, 18)
		event.load_equipment_model(5, 0, 4, "info", awakening_scene_max_slot)
		event.load_equipment_model(5, 0, 3, "info", awakening_scene_max_slot)
		event.load_equipment_model(5, 0, 2, "info", awakening_scene_max_slot, 13)
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", awakening_scene_max_slot)
		event.load_character_motion_pack(5, "event/e700/e728/e728_mints.gltf", "info", awakening_scene_max_slot)
		event.attach_object_handle_to_character(0, awakening_scene_max_slot)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, awakening_scene_max_slot)
		event.set_character_active(1, 13)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", awakening_scene_monica_slot)
		event.load_character_motion_pack(5, "event/e700/e728/e728_monica.gltf", "info", awakening_scene_monica_slot)
		event.attach_object_handle_to_character(1, awakening_scene_monica_slot)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, awakening_scene_monica_slot)
	end
	event.attach_object_handle_to_character(2, 1)
	event.set_object_handle_visible(2, 0)
	event.attach_object_handle_to_character(3, 2)
	event.set_object_handle_visible(3, 0)
	event.load_character(5, "event/e700/e728/e728_sun.gltf", "info", 9)
	event.set_character_active(0, 9)
	event.attach_object_handle_to_character(4, 9)
	event.clear_object_sequence(2, 9)
	event.set_object_sequence_object(2, 4)
	event.set_character_active(1, 17)
	event.set_character_active(1, 18)
	event.load_message_file(0, 5, "event/e700/e728/e728.txt")
	event.assign_memory_stack(6)
	event.clear_memory_stack(6)
	event.load_character(6, "event/e700/e728/atora_red.gltf", "atora_red", 19)
	event.set_character_active(0, 19)
	event.attach_object_handle_to_character(11, 19)
	event.clear_object_sequence(11, 19)
	event.set_object_sequence_object(11, 11)
	event.load_character(6, "event/e700/e728/atora_blue.gltf", "atora_blue", 20)
	event.set_character_active(0, 20)
	event.attach_object_handle_to_character(12, 20)
	event.clear_object_sequence(12, 20)
	event.set_object_sequence_object(12, 12)
	event.load_character(6, "event/e700/e728/atora_yellow.gltf", "a_yellow", 21)
	event.set_character_active(0, 21)
	event.attach_object_handle_to_character(13, 21)
	event.clear_object_sequence(13, 21)
	event.set_object_sequence_object(13, 13)
	event.load_character(6, "event/e700/e728/e728_dark_smoke.gltf", "info", 10)
	event.set_character_active(0, 10)
	event.attach_object_handle_to_character(5, 10)
	event.clear_object_sequence(5, 10)
	event.set_object_sequence_object(5, 5)
	event.load_character(6, "event/e700/e728/e728_desmoke2.gltf", "info", 12)
	event.set_character_active(0, 12)
	event.set_scene_character_type(12, 4)
	event.load_character(6, "event/e700/e728/e728_desmoke.gltf", "info", 11)
	event.set_character_active(0, 11)
	event.set_scene_character_type(11, 4)
	event.load_character(6, "event/e700/e728/e728_smoky_haze.gltf", "info", 22)
	event.set_character_active(0, 22)
	event.set_scene_character_type(22, 4)
	event.load_character(6, "event/e700/e728/e728_eleki.gltf", "info", 23)
	event.set_character_active(0, 23)
	event.set_scene_character_type(23, 4)
end

--- Assigns the Max and Monica actor slots to the layout used with Monica leading, so skipping the drop cutscene cleans up the right actors.
local function set_drop_scene_skip_slots()
	local active_character: s32 = 0
	local _ = active_character == 2
	active_character = 0
	local _ = active_character == 3
	active_character = 1
	awakening_scene_max_slot = 0
	awakening_scene_monica_slot = 8
	awakening_scene_max_slot = 8
	awakening_scene_monica_slot = 0
end

--- Removes the awakening cutscene actors and restores the party.
local function unload_boss_awakening_scene()
	local playable_character: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 0 then
		event.set_character_active(1, awakening_scene_max_slot)
		event.set_character_active(0, awakening_scene_monica_slot)
		event.delete_character_extension_packs(awakening_scene_max_slot)
		event.delete_character_extension_packs(awakening_scene_monica_slot)
		event.delete_character(awakening_scene_monica_slot)
		event.delete_character(13)
		event.delete_character(17)
		event.delete_character(18)
	end
	if playable_character == 1 then
		event.set_character_active(1, awakening_scene_monica_slot)
		event.set_character_active(0, awakening_scene_max_slot)
		event.delete_character_extension_packs(awakening_scene_max_slot)
		event.delete_character_extension_packs(awakening_scene_monica_slot)
		event.delete_character(awakening_scene_max_slot)
		event.delete_character(13)
		event.delete_character(17)
		event.delete_character(18)
	end
	event.delete_character(9)
	event.delete_character(10)
	event.delete_character(11)
	event.delete_character(12)
	event.delete_character(22)
	event.delete_character(23)
	event.delete_character(19)
	event.delete_character(20)
	event.delete_character(21)
	event.set_scene_status_flags(1, 0, 256, 0)
	event.delete_event_image(0)
	event.attach_object_handle_to_character(2, 1)
	event.set_object_handle_visible(2, 1)
	event.attach_object_handle_to_character(3, 2)
	event.set_object_handle_visible(3, 1)
	event.show_dungeon_status_bar(1, 1.0)
	vm.wait(1)
	event.finish_event()
end

--- Plays the cutscene of the boss awakening and the party being dragged in.
local function play_boss_awakening_cutscene()
	local sound_bank: s32 = 0
	local saved_projection: f32 = 0
	local playable_character: s32 = 0
	local telop_image_block: s32 = 0
	local step: number = 0
	vm.section(function()
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.stop_music(0)
		step = 1
		vm.wait(1)
		step = 2
		vm.wait(2)
		step = 3
		vm.wait(3)
		step = 4
		vm.wait(4)
		event.load_music(33)
		event.load_map_sounds(7833)
		sound_bank = event.load_sound_effect_file_2(7833) or sound_bank
		load_boss_awakening_scene_actors()
		event.set_scene_status_flags(1, 0, 256, 1)
		saved_projection = event.get_event_projection() or saved_projection
		event.enable_drama_skip()
		event.set_object_handle_footstep_sound(0, 2)
		event.set_object_handle_footstep_sound(1, 2)
		event.attach_object_handle_to_character(2, 1)
		event.set_object_handle_visible(2, 0)
		event.attach_object_handle_to_character(3, 2)
		event.set_object_handle_visible(3, 0)
		event.set_character_active(0, 17)
		event.set_character_active(0, 18)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目パチ")
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "目とじ")
		event.set_character_active(1, awakening_scene_max_slot)
		event.set_character_active(1, awakening_scene_monica_slot)
		event.set_character_active(1, 9)
		event.set_character_active(1, 19)
		event.set_character_active(1, 20)
		event.set_character_active(1, 21)
		event.set_camera_sequence_position(-32.56, 15.66, -127.35)
		event.set_camera_sequence_look_at(3.81, 7.02, -6.74)
		event.set_object_sequence_motion(0, "かまえるL", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "構えるL", 4, -1.0, 1)
		event.set_object_sequence_motion(2, "倒れ", 4)
		event.set_object_sequence_motion(13, "ループ", 4)
		event.set_object_sequence_position(5, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(5, 0.0, 3.12, 0.0)
		event.set_object_sequence_position(2, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(2, 0.0, 3.12, 0.0)
		event.set_object_sequence_position(0, -10.0, 0.0, -120.19)
		event.set_object_sequence_rotation(0, 0.0, 0.12, 0.0)
		event.set_object_sequence_position(1, 10.0, 0.0, -120.73)
		event.set_object_sequence_rotation(1, 0.0, -0.12, 0.0)
		event.set_object_sequence_position(11, -13.5, 2.0, -18.9)
		event.set_object_sequence_position(12, 14.39, 2.0, -20.63)
		event.set_object_sequence_position(13, 0.92, 2.0, -40.58)
		event.set_character_position(11, 0.0, 0.0, 0.0)
		event.set_character_rotation(11, 0.0, 3.12, 0.0)
		event.fade_in_camera_sequence(60, 255.0, 255.0, 255.0)
		step = 5
		wait.for_frame_count(60)
		event.set_camera_sequence_position(-32.93, 11.56, -74.72)
		event.set_camera_sequence_look_at(2.53, 23.99, -128.27)
		step = 6
		wait.for_frame_count(60)
		event.play_sound_effect(sound_bank, 0)
		event.play_music(0)
		event.set_camera_sequence_position(-9.32, 6.57, -86.8)
		event.set_camera_sequence_look_at(-1.8, 11.05, -21.29)
		event.set_character_motion(11, "倒れ")
		event.set_character_active(1, 11)
		step = 7
		wait.for_frame_count(60)
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(120)
		event.add_camera_sequence_path_point(-9.32, 6.57, -86.8, -1.8, 11.05, -21.29)
		event.add_camera_sequence_path_point(-9.32, 74.82, -86.8, -1.8, 79.3, -21.29)
		event.start_camera_sequence_path()
		step = 8
		camera.wait_until_done()
		event.stop_sound_effect(sound_bank, 0)
		event.set_camera_sequence_position(0.0, 39.3, -81.55)
		event.set_camera_sequence_look_at(0.0, 43.79, 47.97)
		event.start_crossfade(30)
		event.set_character_position(12, 0.0, 0.0, 0.0)
		event.set_character_rotation(12, 0.0, 0.0, 0.0)
		event.attach_character_to_frame(10, "tama", 12)
		event.set_character_active(0, 11)
		event.set_character_active(1, 12)
		event.set_character_active(1, 10)
		event.set_object_sequence_motion(5, "頭出る", 2)
		event.queue_object_sequence_next_motion(5, "頭出るL", 4)
		event.set_character_motion(12, "煙", 4)
		step = 9
		wait.for_frame_count(60)
		step = 10
		message.show_voiced_for_stopping(7280130, -1)
		step = 11
		wait.for_frame_count(15)
		event.play_sound_effect(sound_bank, 1)
		event.set_object_sequence_position(5, -9.28, 0.0, 92.69)
		event.set_object_sequence_rotation(5, 0.0, 3.12, 0.0)
		event.set_camera_sequence_position(2.87, 91.44, 141.96)
		event.set_camera_sequence_look_at(-29.58, -87.11, -60.47)
		event.set_object_sequence_motion(5, "手出る", 2)
		event.queue_object_sequence_next_motion(5, "手出るL", 4)
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(60)
		event.add_camera_sequence_path_point(-2.01, 89.39, 130.66, -44.03, -87.11, -58.36)
		event.add_camera_sequence_path_point(11.99, 89.39, 127.55, -30.02, -87.11, -61.48)
		event.start_camera_sequence_path()
		step = 12
		camera.wait_until_done()
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目パチ")
		event.set_object_sequence_texture_animation(0, 1, "半口")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目パチ")
		event.set_object_sequence_texture_animation(1, 1, "口とじ～大口")
		event.set_camera_sequence_position(-13.15, 15.34, -65.86)
		event.set_camera_sequence_look_at(-0.08, 23.99, -128.89)
		step = 13
		wait.for_frame_count(30)
		event.set_object_sequence_position(5, 4.78, 0.0, 53.85)
		event.set_object_sequence_rotation(5, 0.0, 3.12, 0.0)
		event.set_camera_sequence_position(-57.13, 39.76, -179.68)
		event.set_camera_sequence_look_at(-1.0, 27.1, -92.85)
		event.play_sound_effect(sound_bank, 2)
		event.set_object_sequence_motion(5, "手を上げる", 2)
		event.queue_object_sequence_next_motion(5, "手を上げるL", 4)
		step = 14
		object.wait_until_done(5)
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(30)
		event.add_camera_sequence_path_point(-9.42, 77.41, 0.77, 18.74, 30.15, 60.29)
		event.add_camera_sequence_path_point(-9.42, 110.88, 0.77, 18.74, 63.62, 60.29)
		event.start_camera_sequence_path()
		event.play_sound_effect(sound_bank, 2)
		event.set_object_sequence_motion(5, "手を上げる", 6)
		event.queue_object_sequence_next_motion(5, "手を上げるL", 4)
		step = 15
		object.wait_until_done(5)
		step = 16
		camera.wait_until_done()
		event.set_event_projection(2000.0)
		event.set_object_sequence_position(5, -1.85, 0.0, 111.08)
		event.set_object_sequence_rotation(5, 0.0, 3.12, 0.0)
		event.set_camera_sequence_position(-65.42, 178.12, 284.97)
		event.set_camera_sequence_look_at(1.97, 9.98, -1.2)
		event.set_object_sequence_motion(5, "刺す", 6)
		event.set_object_sequence_motion_time(5, 7.3)
		event.set_object_sequence_motion_step(5, 0.0)
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(30)
		event.add_camera_sequence_path_point(-93.52, 235.35, 238.15, 10.9, 0.71, 16.2)
		event.add_camera_sequence_path_point(-51.36, 154.32, 132.67, 1.44, 0.71, -4.66)
		event.start_camera_sequence_path()
		step = 17
		camera.wait_until_done()
		event.set_event_projection(saved_projection)
		event.set_object_sequence_position(0, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(0, 0.0, 3.12, 0.0)
		event.set_object_sequence_position(2, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(2, 0.0, 3.12, 0.0)
		event.set_camera_sequence_position(-4.32, 54.48, 94.69)
		event.set_camera_sequence_look_at(14.36, 29.4, 225.15)
		event.set_object_sequence_motion_time(5, 0.0)
		event.set_object_sequence_motion_step(5, 0.2)
		event.set_object_sequence_motion(0, "助ける", 6)
		event.queue_object_sequence_next_motion(0, "助けるL", 4)
		event.set_object_sequence_motion(2, "助ける", 6)
		event.queue_object_sequence_next_motion(2, "助けるL", 4)
		step = 18
		wait.for_frame_count(20)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目パチ")
		event.set_object_sequence_motion(5, "手を上げるL", 4)
		event.set_object_sequence_position(5, 2.97, 0.0, 29.69)
		event.set_object_sequence_rotation(5, 0.0, 3.12, 0.0)
		event.set_camera_sequence_position(-6.23, 29.14, -137.75)
		event.set_camera_sequence_look_at(7.05, 22.23, 28.01)
		event.set_object_sequence_motion(5, "刺す", 6)
		event.queue_object_sequence_next_motion(5, "刺すL", 4)
		event.play_sound_effect(sound_bank, 3)
		step = 19
		wait.for_frame_count(15)
		event.set_character_active(1, 23)
		event.set_character_position(23, 0.0, 0.0, 0.0)
		event.set_character_rotation(23, 0.0, 0.0, 0.0)
		event.set_character_motion(23, "暗黒エレキ", 6, -1, 1)
		event.shake_camera_sequence(0.0, 0.6, 0.0, 30)
		step = 20
		camera.wait_until_done()
		step = 21
		wait.for_frame_count(30)
		event.set_object_sequence_position(2, 35.51, 0.0, -10.86)
		event.set_object_sequence_rotation(2, 0.0, 1.68, 0.0)
		event.set_object_sequence_position(0, 35.51, 0.0, -10.86)
		event.set_object_sequence_rotation(0, 0.0, 1.68, 0.0)
		event.set_object_sequence_motion(0, "抱え", 4)
		event.set_object_sequence_motion(2, "抱え", 4)
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "目とじ～目あき")
		event.set_character_active(0, 23)
		event.set_object_sequence_motion(5, "刺すL", 4)
		event.set_object_sequence_position(2, 200.0, 0.0, 0.0)
		event.set_object_sequence_rotation(2, 0.0, -1.44, 0.0)
		event.set_object_sequence_position(0, 200.0, 0.0, 0.0)
		event.set_object_sequence_rotation(0, 0.0, -1.44, 0.0)
		event.set_camera_sequence_position(130.67, 16.54, 1.06)
		event.set_camera_sequence_look_at(202.0, 15.78, 1.22)
		step = 22
		message.show_voiced_for_stopping(7280140, 30)
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "通常目パチ")
		event.set_object_sequence_motion(0, "寝かせる", 2)
		event.queue_object_sequence_next_motion(0, "寝かせるL", 4)
		event.set_object_sequence_motion(2, "寝かせる", 2)
		event.queue_object_sequence_next_motion(2, "寝かせるL", 4)
		step = 23
		object.wait_until_done(2)
		step = 24
		object.wait_until_done(0)
		step = 25
		wait.for_frame_count(15)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "前向き～下向き")
		event.set_object_sequence_motion(0, "うなづく", 2)
		event.queue_object_sequence_next_motion(0, "寝かせるL", 4)
		step = 26
		object.wait_until_done(0)
		event.play_sound_effect(sound_bank, 4)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "下向き～前向き")
		event.play_sound_effect(sound_bank, 5)
		event.set_object_sequence_motion(0, "立つ", 2)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		step = 27
		object.wait_until_done(0)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目パチ")
		event.set_object_sequence_position(5, 2.97, 0.0, 29.69)
		event.set_object_sequence_rotation(5, 0.0, 1.8, 0.0)
		event.set_object_sequence_position(0, 81.45, 0.0, 21.84)
		event.set_object_sequence_rotation(0, 0.0, -1.44, 0.0)
		playable_character = event.get_playable_character() or playable_character
		if playable_character == 1 then
			event.set_character_active(1, 17)
			event.set_character_active(1, 18)
		else
			event.attach_object_handle_to_character(2, 1)
			event.set_object_handle_visible(2, 1)
			event.attach_object_handle_to_character(3, 2)
			event.set_object_handle_visible(3, 1)
		end
		event.play_sound_effect(sound_bank, 6)
		event.set_object_sequence_motion(0, "かまえる", 6)
		event.queue_object_sequence_next_motion(0, "かまえるL", 4)
		event.set_camera_sequence_position(166.63, 38.2, -13.18)
		event.set_camera_sequence_look_at(70.91, 29.78, 10.61)
		step = 28
		message.show_voiced_for_stopping(7280150, -1)
		event.fade_out_music(60)
		step = 29
		wait.for_frame_count(60)
		event.stop_music(0)
		step = 30
		vm.wait(30)
		step = 31
		vm.wait(31)
		step = 32
		vm.wait(32)
		step = 33
		vm.wait(33)
		event.load_music(167)
		event.play_music(0)
		event.set_object_sequence_position(5, 2.97, 0.0, 29.69)
		event.set_object_sequence_rotation(5, 0.0, 3.12, 0.0)
		event.set_object_sequence_position(0, -10.0, 0.0, -120.19)
		event.set_object_sequence_rotation(0, 0.0, 0.12, 0.0)
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(60)
		event.add_camera_sequence_path_point(0.1, 17.53, -95.17, 5.91, 10.61, 34.67)
		event.add_camera_sequence_path_point(-1.18, 22.61, -123.61, 5.91, 32.94, 34.67)
		event.start_camera_sequence_path()
		event.play_sound_effect(sound_bank, 7)
		event.set_object_sequence_motion(5, "杖かざす", 6)
		event.queue_object_sequence_next_motion(5, "杖かざすL", 4)
		event.move_object_sequence_eased(11, -22.49, 36.0, -50.18, 40, 0, 1.0)
		event.move_object_sequence_eased(12, 14.15, 32.65, -67.78, 40, 0, 1.0)
		event.move_object_sequence_eased(13, -7.3, 24.54, -54.27, 40, 0, 1.0)
		step = 34
		wait.for_frame_count(90)
		event.set_camera_sequence_position(14.08, 134.04, -46.86)
		event.set_camera_sequence_look_at(3.49, 46.6, 27.57)
		event.attach_character_to_frame(22, "red", 19)
		event.attach_character_to_frame(22, "blue", 20)
		event.attach_character_to_frame(22, "yellow", 21)
		event.set_object_sequence_position(11, 0.0, 0.0, 0.0)
		event.set_object_sequence_position(12, 0.0, 0.0, 0.0)
		event.set_object_sequence_position(13, 0.0, 0.0, 0.0)
		event.set_character_active(0, 12)
		event.set_character_position(22, 2.97, 0.0, 29.69)
		event.set_character_rotation(22, 0.0, 3.12, 0.0)
		event.set_character_active(1, 22)
		event.set_character_motion(22, "ブルブル", 2, -1, 1)
		step = 35
		wait.for_frame_count(30)
		event.set_object_sequence_motion(5, "ブルブル", 4)
		event.set_character_active(0, 19)
		event.set_character_active(0, 20)
		event.set_character_active(0, 21)
		step = 36
		wait.for_frame_count(90)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目パチ")
		event.set_object_sequence_texture_animation(0, 1, "半口")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目パチ")
		event.set_object_sequence_texture_animation(1, 1, "半口")
		event.set_camera_sequence_position(-34.37, 35.47, -57.39)
		event.set_camera_sequence_look_at(-2.38, 20.71, -112.3)
		event.set_object_sequence_motion(1, "おどろき", 2, -1.0, 1)
		event.queue_object_sequence_next_motion(1, "おどろきL", 4)
		event.set_object_sequence_motion(0, "驚く", 2, -1.0, 1)
		event.queue_object_sequence_next_motion(0, "驚くL", 4)
		event.set_character_active(0, 10)
		event.set_character_active(0, 22)
		step = 37
		wait.for_frame_count(60)
		event.delete_character(10)
		event.delete_character(11)
		event.delete_character(12)
		event.delete_character(22)
		event.delete_character(19)
		event.delete_character(20)
		event.delete_character(21)
		event.clear_memory_stack(6)
		event.load_character(6, "event/e700/e728/e728_dark.gltf", "info", 10)
		event.set_character_active(0, 10)
		event.attach_object_handle_to_character(15, 10)
		event.clear_object_sequence(15, 10)
		event.set_object_sequence_object(15, 15)
		event.load_character(6, "event/e700/e728/e728_power.gltf", "info", 11)
		event.set_character_active(0, 11)
		event.set_scene_character_type(11, 4)
		event.load_character(6, "event/e700/e728/e728_deeye.gltf", "info", 12)
		event.set_character_active(0, 12)
		event.set_scene_character_type(12, 4)
		event.load_character(6, "event/e700/e728/e728_gokou.gltf", "info", 22)
		event.set_character_active(0, 22)
		event.attach_object_handle_to_character(9, 22)
		event.clear_object_sequence(9, 22)
		event.set_object_sequence_object(9, 9)
		event.set_scene_character_type(22, 4)
		event.load_character(6, "event/e700/e728/b11a_hikari_blue.gltf", "info", 23)
		event.set_character_active(0, 23)
		event.set_scene_character_type(23, 4)
		event.load_character(6, "event/e700/e728/e728_gokou2.gltf", "info", 19)
		event.set_character_active(0, 19)
		event.set_scene_character_type(19, 4)
		event.load_character(6, "event/e700/e728/e728_deobi_y.gltf", "info", 20)
		event.set_character_active(0, 20)
		event.attach_object_handle_to_character(8, 20)
		event.clear_object_sequence(8, 20)
		event.set_object_sequence_object(8, 8)
		event.load_character(6, "event/e700/e728/e728_deobi_m.gltf", "info", 21)
		event.set_character_active(0, 21)
		event.attach_object_handle_to_character(7, 21)
		event.clear_object_sequence(7, 21)
		event.set_object_sequence_object(7, 7)
		telop_image_block = event.load_event_image_4(6, "textures/event/e700/e728/e728telop06.json", 0) or telop_image_block
		event.reset_event_sprite(4)
		event.set_event_sprite_type(4, 0)
		event.set_event_sprite_texture(4, "e728telop06", telop_image_block)
		event.set_event_sprite_texture_rect(4, 0, 0, 512, 128)
		event.set_event_sprite_size(4, 512, 128)
		event.set_event_sprite_position(4, 320, 334)
		event.set_event_sprite_color(4, 128, 128, 128, 0)
		event.set_event_sprite_scale(4, 1.0, 1.0)
		event.set_event_sprite_draw_pass(4, 0)
		event.attach_object_handle_to_sprite(14, 4)
		event.clear_object_sequence(14)
		event.set_object_sequence_object(14, 14)
		event.attach_character_to_frame(10, "tama", 23)
		event.set_character_active(1, 23)
		event.set_character_active(1, 10)
		event.set_object_sequence_position(15, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(15, 0.0, 3.12, 0.0)
		event.set_object_sequence_motion(15, "立ち", 6)
		event.set_character_active(0, awakening_scene_max_slot)
		if playable_character == 1 then
			event.set_character_active(0, 17)
			event.set_character_active(0, 18)
		else
			event.attach_object_handle_to_character(2, 1)
			event.set_object_handle_visible(2, 0)
			event.attach_object_handle_to_character(3, 2)
			event.set_object_handle_visible(3, 0)
		end
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(120)
		event.add_camera_sequence_path_point(-10.71, 26.07, -68.91, 0.0, 43.32, 0.0)
		event.add_camera_sequence_path_point(-18.68, 7.34, -120.21, 0.0, 43.32, 0.0)
		event.start_camera_sequence_path()
		event.set_event_sprite_draw_pass(4, 1)
		event.set_object_sequence_color(14, 128, 128, 128, 128, 30)
		step = 38
		camera.wait_until_done()
		event.set_object_sequence_color(14, 128, 128, 128, 0, 30)
		event.set_character_position(11, 0.0, 36.79, 0.0)
		event.set_character_rotation(11, 0.0, 3.12, 0.0)
		event.set_character_active(1, 11)
		event.play_sound_effect(sound_bank, 8)
		event.set_object_sequence_motion(15, "手を広げる", 6)
		event.queue_object_sequence_next_motion(15, "手を広げるL", 4)
		step = 39
		wait.for_frame_count(60)
		event.set_character_motion(11, "手を広げるL", 4, -1, 1)
		step = 40
		wait.for_frame_count(90)
		event.set_character_position(12, 0.0, 54.76, 0.0)
		event.set_character_rotation(12, 0.0, 3.12, 0.0)
		event.set_character_active(1, 12)
		event.play_sound_effect(sound_bank, 9)
		event.set_character_motion(12, "光る", 2, -1, 1)
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(120)
		event.add_camera_sequence_path_point(3.2, 65.86, -18.65, 0.0, 49.46, 0.0)
		event.add_camera_sequence_path_point(-6.36, 65.86, -20.29, -9.56, 49.46, -1.64)
		event.start_camera_sequence_path()
		event.start_crossfade(30)
		step = 41
		camera.wait_until_done()
		event.stop_sound_effect(sound_bank, 8)
		event.set_character_active(0, 12)
		event.set_character_active(0, 11)
		event.set_object_sequence_position(0, -15.0, 0.0, -120.19)
		event.set_object_sequence_rotation(0, 0.0, 0.12, 0.0)
		event.set_object_sequence_position(1, 15.0, 0.0, -120.73)
		event.set_object_sequence_rotation(1, 0.0, -0.12, 0.0)
		event.set_character_position(21, 15.0, 0.0, -120.73)
		event.set_character_rotation(21, 0.0, -0.12, 0.0)
		event.set_event_projection(1400.0)
		event.set_camera_sequence_position(0.56, 50.63, -367.73)
		event.set_camera_sequence_look_at(0.5, 17.72, -1.34)
		event.move_camera_sequence(0.58, 50.63, -514.46, 0.5, 17.72, -1.34, 60)
		event.set_character_active(1, awakening_scene_max_slot)
		event.play_sound_effect(sound_bank, 10)
		event.set_character_position(22, 0.0, 35.0, 240.0)
		event.set_character_rotation(22, 0.0, 3.12, 0.0)
		event.set_character_active(1, 22)
		event.set_object_sequence_motion(15, "後光", 6)
		event.queue_object_sequence_next_motion(15, "後光L", 4)
		event.set_object_sequence_motion(9, "後光", 6)
		event.queue_object_sequence_next_motion(9, "後光L", 4)
		event.set_object_sequence_motion(1, "まぶしい", 2, -1.0, 1)
		event.queue_object_sequence_next_motion(1, "まぶしいL", 4)
		event.set_object_sequence_motion(0, "まぶしい", 2, -1.0, 1)
		event.queue_object_sequence_next_motion(0, "まぶしいL", 4)
		step = 42
		camera.wait_until_done()
		event.attach_character_to_frame(awakening_scene_max_slot, "ground", 20)
		event.set_character_position(19, -40.51, 35.0, -103.49)
		event.set_character_rotation(19, 0.0, -1.2, 0.0)
		event.set_camera_sequence_position(-119.45, 31.61, -18.57)
		event.set_camera_sequence_look_at(-14.55, 16.86, -108.78)
		event.start_crossfade(30)
		event.set_character_active(1, 19)
		event.set_character_motion(19, "後光2", 4, -1, 1)
		step = 43
		wait.for_frame_count(60)
		event.set_character_active(1, 21)
		event.set_character_active(1, 20)
		event.play_sound_effect(sound_bank, 11)
		event.set_object_sequence_motion(1, "まきつき", 6)
		event.queue_object_sequence_next_motion(1, "ひっぱられ", 6)
		event.set_object_sequence_motion(0, "まきつく", 6)
		event.queue_object_sequence_next_motion(0, "引きずり込まれる", 6)
		event.set_object_sequence_motion(7, "まきつきL", 6)
		event.queue_object_sequence_next_motion(7, "ひっぱられ", 6)
		event.set_object_sequence_motion(8, "まきつくL", 6)
		event.queue_object_sequence_next_motion(8, "引きずり込まれる", 6)
		step = 44
		wait.for_frame_count(60)
	end, function(received: { any }): boolean
		if step <= 4 then
			set_drop_scene_skip_slots()
			wait.skip_frame_count(60)
		end
		if step <= 5 then
			wait.skip_frame_count(60)
		end
		if step <= 6 then
			wait.skip_frame_count(60)
		end
		if step <= 7 then
			wait.background_load_skipping()
		end
		if step <= 8 then
			wait.skip_frame_count(60)
		end
		if step <= 9 then
			message.show_voiced_for_stopping_skipping(7280130, -1)
		end
		if step <= 10 then
			wait.skip_frame_count(15)
		end
		if step <= 11 then
			wait.background_load_skipping()
		end
		if step <= 12 then
			wait.skip_frame_count(30)
		end
		if step <= 13 then
			cutscene.skip_command(5)
		end
		if step <= 14 then
			cutscene.skip_command(5)
		end
		if step <= 15 then
			wait.background_load_skipping()
		end
		if step <= 16 then
			wait.background_load_skipping()
		end
		if step <= 17 then
			wait.skip_frame_count(20)
		end
		if step <= 18 then
			wait.skip_frame_count(15)
		end
		if step <= 19 then
			wait.background_load_skipping()
		end
		if step <= 20 then
			wait.skip_frame_count(30)
		end
		if step <= 21 then
			message.show_voiced_for_stopping_skipping(7280140, 30)
		end
		if step <= 22 then
			cutscene.skip_command(2)
		end
		if step <= 23 then
			cutscene.skip_command(0)
		end
		if step <= 24 then
			wait.skip_frame_count(15)
		end
		if step <= 25 then
			cutscene.skip_command(0)
		end
		if step <= 26 then
			cutscene.skip_command(0)
		end
		if step <= 27 then
			message.show_voiced_for_stopping_skipping(7280150, -1)
		end
		if step <= 28 then
			wait.skip_frame_count(60)
		end
		if step <= 33 then
			wait.skip_frame_count(90)
		end
		if step <= 34 then
			wait.skip_frame_count(30)
		end
		if step <= 35 then
			wait.skip_frame_count(90)
		end
		if step <= 36 then
			wait.skip_frame_count(60)
		end
		if step <= 37 then
			wait.background_load_skipping()
		end
		if step <= 38 then
			wait.skip_frame_count(60)
		end
		if step <= 39 then
			wait.skip_frame_count(90)
		end
		if step <= 40 then
			wait.background_load_skipping()
		end
		if step <= 41 then
			wait.background_load_skipping()
		end
		if step <= 42 then
			wait.skip_frame_count(60)
		end
		if step <= 43 then
			wait.skip_frame_count(60)
		end
		return true
	end)
	event.cancel_drama_scene_skip()
	event.fade_out_camera_sequence(60, 255.0, 255.0, 255.0)
	step = 45
	wait.for_frame_count(65)
	event.set_event_projection(saved_projection)
	event.skip_next_music_load()
	event.stop_port_sound_effects(4)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	step = 46
	vm.wait(46)
	step = 47
	unload_boss_awakening_scene()
	step = 48
	vm.wait(48)
	event.reset_follow_camera(0)
end

--- Plays the voiced pre-battle dialogue cutscene in which the winged griffon boss speaks to the party.
local function play_griffon_dialogue_cutscene()
	local sound_bank: s32 = 0
	local playable_character: s32 = 0
	vm.section(function()
		event.set_save_flag(640, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.stop_music(0)
		wait.for_frame_count(4)
		event.load_music(33)
		event.play_music(0)
		event.load_map_sounds(6208)
		sound_bank = event.load_sound_effect_file_2(6208) or sound_bank
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		playable_character = event.get_playable_character() or playable_character
		event.set_scene_status_flags(1, 0, 256, 1)
		event.change_directory("event/e600/e640/")
		event.load_message_file(0, 5, "e640.txt")
		if playable_character == 0 then
			event.load_character_motion_pack(5, "e640_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if playable_character == 1 then
			event.load_character_motion_pack(5, "e640_monica.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.load_character(5, "e640_griffon.gltf", "info", 34)
		event.set_character_active(34)
		event.attach_object_handle_to_character(2, 34)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.load_character(5, "e640_grigokou.gltf", "info", 35)
		event.set_character_active(35)
		event.attach_object_handle_to_character(3, 35)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.change_directory("")
		if playable_character == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 32)
			event.load_equipment_model(5, 0, 4, "info", 32)
			event.load_equipment_model(5, 0, 3, "info", 32)
			event.load_equipment_model(5, 0, 2, "info", 32, 33)
			event.load_character_motion_pack(5, "event/e600/e640/e640_mints.gltf", "info", 32)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 32)
			event.attach_object_handle_to_character(0, 32)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 0)
		else
			event.load_character(5, "chara/c02_base.gltf", "info", 32)
			event.load_equipment_model(5, 1, 4, "info", 32)
			event.load_equipment_model(5, 1, 3, "info", 32)
			event.load_equipment_model(5, 1, 2, "info", 32, 33)
			event.load_character_motion_pack(5, "event/e600/e640/e640_monica.gltf", "info", 32)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 32)
			event.attach_object_handle_to_character(1, 32)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 0)
		end
		event.set_character_active(32)
		event.set_character_active(33)
		event.set_object_handle_position(0, 0.0, 0.0, 0.0)
		event.set_object_handle_rotation(0, 0.0, 3.14, 0.0)
		event.set_object_handle_footstep_sound(0, 2)
		event.set_object_handle_position(1, 0.0, 0.0, 0.0)
		event.set_object_handle_rotation(1, 0.0, 3.14, 0.0)
		event.set_object_handle_footstep_sound(1, 2)
		event.set_object_handle_position(2, -12.69, 210.91, 31.92)
		event.set_object_handle_rotation(2, 0.0, 0.0, 0.0)
		event.set_object_handle_footstep_sound(2, 2)
		event.set_object_handle_position(3, -12.69, 210.91, 31.92)
		event.set_object_handle_rotation(3, 0.0, 0.0, 0.0)
		event.enable_drama_skip()
		event.set_character_active(0, 35)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-16.84, 208.3, 357.29)
		event.set_camera_sequence_look_at(-12.28, 234.47, 95.52)
		event.fade_in_screen(30)
		event.set_motion_blur(100)
		event.move_camera_sequence_eased(-13.43, 263.98, 96.05, -12.81, 265.44, 61.96, 60, 2, 1.0)
		camera.wait_until_done()
		event.start_crossfade(30)
		event.set_motion_blur(0)
		event.move_camera_sequence_eased(-13.21, 262.59, 85.71, -12.24, 265.7, 32.15, 300, 2, 1.0)
		event.set_object_sequence_motion(2, "会話翼閉じ")
		event.delay_object_sequence_motion_track(2, 60)
		event.queue_object_sequence_next_motion(2, "立ち翼閉じ", 4)
		message.show_voiced_for_stopping(6400090, -1)
		object.wait_until_done(2)
		wait.for_frame_count(20)
		event.set_object_sequence_motion(2, "会話翼閉じ")
		message.show_voiced_for_stopping(6400095, -1)
		event.queue_object_sequence_next_motion(2, "立ち翼閉じ", 4)
		object.wait_until_done(2)
		wait.for_frame_count(30)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(17.28, 279.9, 82.24)
		event.set_camera_sequence_look_at(-12.04, 265.49, 33.59)
		object.wait_until_done(2)
		event.set_object_sequence_motion(2, "会話翼閉じ")
		event.delay_object_sequence_motion_track(2, 120)
		event.queue_object_sequence_next_motion(2, "広げ", 6)
		event.queue_object_sequence_next_motion(2, "広げＬ", 4)
		event.delay_camera_sequence_position_track(110)
		event.set_camera_sequence_position(-12.04, 271.55, 72.44)
		event.set_camera_sequence_look_at(-12.55, 264.36, 33.58)
		event.move_camera_sequence_eased(-13.58, 244.64, 142.02, -12.47, 253.04, 34.41, 60, 0, 0.5)
		event.delay_object_sequence_sound_track(2, 110)
		event.play_object_sequence_sound(2, sound_bank, 0)
		event.delay_object_sequence_motion_track(2, 110)
		message.show_voiced_for_stopping(6400100, -1)
		event.set_character_active(35)
		event.set_character_visible(35, 1, 1, 0.033333335)
		wait.for_frame_count(60)
		event.set_object_sequence_motion(2, "コントロール", 6)
		event.queue_object_sequence_next_motion(2, "コントロールＬ", 4)
		object.wait_until_done(2)
		event.fade_out_screen(30)
		wait.for_frame_count(30)
	end)
	event.cancel_drama_scene_skip()
	event.stop_sound_effect(sound_bank, 0)
	event.stop_sound_effect(sound_bank, 1)
	event.set_motion_blur(0)
	event.skip_next_music_load()
	event.set_character_active(0)
	event.set_character_active(32)
	event.set_character_active(33)
	event.set_scene_status_flags(1, 0, 256, 0)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.delete_character_extension_packs(0)
	event.delete_character(32)
	event.delete_character(33)
	event.delete_character(34)
	event.delete_character(35)
	event.load_message_file(0, -1)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded and does nothing.
function script.setup() end

script.on_map_loaded = on_map_loaded
script[99] = script.on_map_loaded

--- Starts the boss battle with its summoning cutscene when the boss flag is set, then fades in.
function script.default_event()
	local summoning_flag: s32 = 0
	on_map_loaded()
	summoning_flag = event.get_save_flag(58) or summoning_flag
	if summoning_flag == 1 then
		play_griffon_summoning_cutscene()
		event.set_save_control_bits(1, 1)
		character.place_standing_and_reset_cloth(0.0, 0.0, -200.0, 0.0)
		event.set_camera_look_at(0.0, 30.0, -200.0)
		event.set_camera_position(0.0, 40.0, -320.0)
		event.reset_follow_camera(0)
		vm.wait(2)
		event.load_dungeon_monster(615, 1)
		event.load_dungeon_monster(618, 0)
		event.load_dungeon_monster(619, 0)
		event.load_dungeon_monster(620, 0)
		event.place_dungeon_monster(615, 0.0, 50.0, 0.0, 0.0, 3.14, 0.0)
	end
	event.fade_in_screen(30)
	event.finish_event()
end

--- Waits for the square button press.
function script.key_open()
	vm.wait(1)
	wait.until_button_pressed(32)
end

--- Fades in, starts the battle music and spawns the first phase boss.
function script.start_boss_battle()
	local step: number = 0
	return vm.guard(function()
		event.initialize_event()
		step = 1
		vm.wait(1)
		event.fade_in_screen(30)
		event.stop_music(0)
		step = 2
		wait.for_frame_count(4)
		event.load_music(41)
		event.play_music(0)
		event.load_dungeon_monster(615, 1)
		event.load_dungeon_monster(618, 0)
		event.load_dungeon_monster(619, 0)
		event.load_dungeon_monster(620, 0)
		event.place_dungeon_monster(615, 0.0, 50.0, 0.0, 0.0, 0.0, 0.0)
		print("Autoset---------------------------------------\n")
		step = 3
		vm.wait(3)
		event.finish_event()
		return
	end, function(received: { any })
		if step <= 3 then
			if step <= 1 then
				wait.skip_frame_count(4)
			end
			if step <= 2 then
				print("Autoset---------------------------------------\n")
			end
			return 0
		end
		return nil
	end)
end
script[151] = script.start_boss_battle

--- Fades through the first mid-battle flashback and spawns the second phase boss.
function script.start_boss_phase_2_after_flashback()
	event.initialize_event()
	vm.wait(1)
	event.fade_out_screen(30)
	wait.for_frame_count(30)
	event.set_dungeon_pause_flags(15, 1)
	event.clear_event_battle_monsters(-1)
	event.fade_in_screen(30)
	vm.wait(3)
	event.open_message_window_2(0, "e720 戦闘中回想１")
	message.show_and_wait(0, -1, 8, 0, 0)
	event.set_dungeon_pause_flags(15, 0)
	event.load_dungeon_monster(616, 1)
	event.place_dungeon_monster(616, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
	vm.wait(5)
	event.finish_event()
end
script[152] = script.start_boss_phase_2_after_flashback

--- Fades through the second mid-battle flashback and spawns the third phase boss.
function script.start_boss_phase_3_after_flashback()
	event.initialize_event()
	vm.wait(1)
	event.fade_out_screen(30)
	wait.for_frame_count(30)
	event.set_dungeon_pause_flags(15, 1)
	event.clear_event_battle_monsters(-1)
	event.fade_in_screen(30)
	vm.wait(3)
	event.open_message_window_2(0, "e724 戦闘中回想２")
	message.show_and_wait(0, -1, 8, 0, 0)
	event.set_dungeon_pause_flags(15, 0)
	event.load_dungeon_monster(617, 1)
	event.place_dungeon_monster(617, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
	vm.wait(5)
	event.finish_event()
end
script[153] = script.start_boss_phase_3_after_flashback

--- Moves to the second boss map.
function script.exit_to_d06b02()
	event.load_dungeon_map("d06b02")
	event.load_event_script("d06/d06b02.stb", 100)
end
script[154] = script.exit_to_d06b02

--- Event 155, which map data, a script or the engine runs by number.
script.exit_to_s44_after_boss_drop = exit_to_s44_after_boss_drop
script[155] = script.exit_to_s44_after_boss_drop

--- Adds a fixed set of seventeen items to the inventory.
function script.give_item_set()
	event.initialize_event()
	vm.wait(1)
	event.add_inventory_item(20, 1)
	event.add_inventory_item(21, 1)
	event.add_inventory_item(39, 1)
	event.add_inventory_item(40, 1)
	event.add_inventory_item(34, 1)
	event.add_inventory_item(79, 1)
	event.add_inventory_item(81, 1)
	event.add_inventory_item(60, 1)
	event.add_inventory_item(83, 1)
	event.add_inventory_item(78, 1)
	event.add_inventory_item(57, 1)
	event.add_inventory_item(89, 1)
	event.add_inventory_item(88, 1)
	event.add_inventory_item(101, 1)
	event.add_inventory_item(102, 1)
	event.add_inventory_item(109, 1)
	event.add_inventory_item(108, 1)
	vm.wait(2)
	event.finish_event()
end
script[160] = script.give_item_set

--- Fades out, hides the party and moves to the s64 map.
function script.exit_to_s64()
	event.initialize_event()
	event.reset_action_character_motion(0)
	event.fade_out_screen(10)
	wait.for_frame_count(10)
	event.set_character_visible(1, 0)
	event.set_character_visible(2, 0)
	event.show_dungeon_status_bar(0, 1.0)
	event.clear_event_battle_monsters(-1)
	event.skip_next_music_load()
	event.skip_next_map_sound_load()
	event.load_dungeon_map("s64")
	event.load_event_script("s64/s64.stb", 500)
end
script[500] = script.exit_to_s64

--- Fades out, hides the party and moves to the s31 map.
function script.exit_to_s31()
	event.initialize_event()
	event.reset_action_character_motion(0)
	event.fade_out_screen(10)
	wait.for_frame_count(10)
	event.set_character_visible(1, 0)
	event.set_character_visible(2, 0)
	event.show_dungeon_status_bar(0, 1.0)
	event.clear_event_battle_monsters(-1)
	event.skip_next_music_load()
	event.load_dungeon_map("s31")
	event.load_event_script("s31/s31.stb", 520)
end
script[501] = script.exit_to_s31

script[502] = script.exit_to_s44_after_boss_drop

--- Plays the wing spread cutscene, places the party and spawns the second phase boss.
function script.start_boss_phase_2_after_wing_spread()
	play_boss_wing_spread_cutscene()
	character.place_standing_and_reset_cloth(0.0, 0.0, -200.0, 0.0)
	event.set_camera_look_at(0.0, 30.0, -200.0)
	event.set_camera_position(0.0, 40.0, -320.0)
	event.reset_follow_camera(0)
	event.set_character_visible(1, 1)
	event.set_character_visible(2, 1)
	event.show_dungeon_status_bar(1, 1.0)
	vm.wait(2)
	event.load_dungeon_monster(616, 1)
	event.place_dungeon_monster(616, 0.0, 0.0, 150.0, 0.0, 3.14, 0.0)
	event.fade_in_screen(30)
	event.finish_event()
end
script[510] = script.start_boss_phase_2_after_wing_spread

--- Plays the awakening cutscene, places the party and spawns the third phase boss.
function script.start_boss_phase_3_after_awakening()
	play_boss_fire_awakening_cutscene()
	character.place_standing_and_reset_cloth(0.0, 0.0, -200.0, 0.0)
	event.set_camera_look_at(0.0, 30.0, -150.0)
	event.set_camera_position(0.0, 40.0, -270.0)
	event.reset_follow_camera(0)
	event.set_character_visible(1, 1)
	event.set_character_visible(2, 1)
	event.show_dungeon_status_bar(1, 1.0)
	vm.wait(2)
	event.load_dungeon_monster(617, 1)
	event.place_dungeon_monster(617, 0.0, 0.0, 150.0, 0.0, 3.14, 0.0)
	event.fade_in_screen(30)
	event.finish_event()
end
script[511] = script.start_boss_phase_3_after_awakening

--- Plays the awakening cutscene, ensures the boss music is playing and moves to the d06b03 map.
function script.exit_to_d06b03_after_awakening()
	local music_number: s32 = 0
	play_boss_awakening_cutscene()
	music_number = event.get_active_music_number() or music_number
	if music_number ~= 167 then
		event.stop_music(0)
		wait.for_frame_count(4)
		event.load_music(167)
		event.play_music(0)
	end
	event.skip_next_music_load()
	event.load_dungeon_map("d06b03")
	event.load_event_script("d06b03/d06b03.stb", 550)
end
script[512] = script.exit_to_d06b03_after_awakening

--- Plays the griffon dialogue cutscene and moves to the s32 map.
function script.cutscene_griffon_dialogue()
	play_griffon_dialogue_cutscene()
	event.jump_to_map_3(-1, "s32", 600)
	vm.wait(2)
end
script[600] = script.cutscene_griffon_dialogue

--- Handles the party being defeated, with a random voiced line while the boss flag is set.
function script.on_party_defeated()
	local battle_flag: s32 = 0
	local drop_cutscene_flag: s32 = 0
	local roll: s32 = 0
	local step: number = 0
	return vm.guard(function()
		battle_flag = event.get_save_flag(716) or battle_flag
		drop_cutscene_flag = event.get_save_flag(728) or drop_cutscene_flag
		if battle_flag ~= 0 and drop_cutscene_flag == 0 then
			roll = event.get_random_number_int(100) or roll
			if roll < 50 then
				step = 1
				dungeon.handle_defeat_voiced(0, 8560060)
			else
				step = 2
				dungeon.handle_defeat_voiced(0, 8560070)
			end
			return
		end
		step = 3
		dungeon.handle_defeat_silent(0)
		return
	end, function(received: { any })
		if step <= 2 then
			if step <= 1 then
				dungeon.skip_defeat_sequence_voiced(0, 8560070)
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

--- Event 17160, which map data, a script or the engine runs by number.
script.play_griffon_summoning_cutscene = play_griffon_summoning_cutscene
script[17160] = script.play_griffon_summoning_cutscene

--- Hides the party and moves to the s64 map.
function script.jump_to_s64()
	event.set_character_visible(1, 0)
	event.set_character_visible(2, 0)
	event.show_dungeon_status_bar(0, 1.0)
	event.load_dungeon_map("s64")
	event.load_event_script("s64/s64.stb", 500)
	vm.wait(1)
end
script[17200] = script.jump_to_s64

--- Hides the party and moves to the s31 map.
function script.jump_to_s31()
	event.set_character_visible(1, 0)
	event.set_character_visible(2, 0)
	event.show_dungeon_status_bar(0, 1.0)
	event.load_dungeon_map("s31")
	event.load_event_script("s31/s31.stb", 520)
	vm.wait(1)
end
script[17240] = script.jump_to_s31

--- Plays the boss drop cutscene and moves to the s44 map.
function script.cutscene_boss_drop_then_exit_to_s44()
	play_boss_drop_cutscene()
	event.load_dungeon_map("s44")
	event.load_event_script("s44/s44.stb", 510)
end
script[17280] = script.cutscene_boss_drop_then_exit_to_s44

return script
