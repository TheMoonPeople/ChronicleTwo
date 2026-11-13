--!strict
--- Event script for a Moon Flower Palace approach map, covering Osmond's arrival scene, the burning scene with the beam attack and the jumps to the neighbouring maps.

local vm = require("@lib/vm")
local camera = require("@lib/event/camera")
local character = require("@lib/event/character")
local cutscene = require("@lib/event/cutscene")
local menu = require("@lib/event/menu")
local message = require("@lib/event/message")
local moon_flower_palace_event = require("@lib/event/moon_flower_palace_event")
local object = require("@lib/event/object")
local wait = require("@lib/event/wait")

local max_slot: s32 = 0
local monica_slot: s32 = 0
local burning_scene_max_slot: s32 = 0
local burning_scene_monica_slot: s32 = 0

--- Does nothing; the map needs no setup before it is entered.
local function initialize_map() end

--- Loads the player characters, Osmond, Toryon and the beam and flame effects used by the burning scene and assigns their slots by the playable character.
local function load_burning_scene_actors()
	local playable_character: s32 = 0
	event.set_message_window_mode(0, 7)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 0 then
		burning_scene_max_slot = 0
		burning_scene_monica_slot = 32
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", burning_scene_max_slot)
		event.load_character_motion_pack(5, "event/e600/e616/e616_mints.gltf", "info", burning_scene_max_slot)
		event.attach_object_handle_to_character(0, burning_scene_max_slot)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, burning_scene_max_slot)
		event.load_character(5, "chara/c02_base.gltf", "info", burning_scene_monica_slot)
		event.load_equipment_model(5, 1, 4, "info", burning_scene_monica_slot)
		event.load_equipment_model(5, 1, 3, "info", burning_scene_monica_slot)
		event.load_equipment_model(5, 1, 2, "info", burning_scene_monica_slot, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", burning_scene_monica_slot)
		event.load_character_motion_pack(5, "event/e600/e616/e616_monica.gltf", "info", burning_scene_monica_slot)
		event.attach_object_handle_to_character(1, burning_scene_monica_slot)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, burning_scene_monica_slot)
		event.set_character_active(1, 37)
	end
	if playable_character == 1 then
		burning_scene_max_slot = 32
		burning_scene_monica_slot = 0
		event.load_character(5, "chara/c01_base.gltf", "info", burning_scene_max_slot)
		event.load_equipment_model(5, 0, 4, "info", burning_scene_max_slot)
		event.load_equipment_model(5, 0, 3, "info", burning_scene_max_slot)
		event.load_equipment_model(5, 0, 2, "info", burning_scene_max_slot, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", burning_scene_max_slot)
		event.load_character_motion_pack(5, "event/e600/e616/e616_mints.gltf", "info", burning_scene_max_slot)
		event.attach_object_handle_to_character(0, burning_scene_max_slot)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, burning_scene_max_slot)
		event.set_character_active(1, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", burning_scene_monica_slot)
		event.load_character_motion_pack(5, "event/e600/e616/e616_monica.gltf", "info", burning_scene_monica_slot)
		event.attach_object_handle_to_character(1, burning_scene_monica_slot)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, burning_scene_monica_slot)
	end
	event.load_character(5, "event/e600/e616/e616_osmond.gltf", "info", 38)
	event.set_character_active(0, 38)
	event.attach_object_handle_to_character(2, 38)
	event.clear_object_sequence(2, 38)
	event.set_object_sequence_object(2, 2)
	event.load_character(5, "event/e600/e616/e616_toryon.gltf", "info", 39)
	event.set_character_active(0, 39)
	event.attach_object_handle_to_character(3, 39)
	event.clear_object_sequence(3, 39)
	event.set_object_sequence_object(3, 3)
	event.load_character(5, "event/e600/e616/e616_beam_f.gltf", "info", 40)
	event.set_character_active(0, 40)
	event.attach_object_handle_to_character(4, 40)
	event.clear_object_sequence(4, 40)
	event.set_object_sequence_object(4, 4)
	event.load_character(5, "event/e600/e616/e616_beam_h.gltf", "info", 41)
	event.set_character_active(0, 41)
	event.attach_object_handle_to_character(5, 41)
	event.clear_object_sequence(5, 41)
	event.set_object_sequence_object(5, 5)
	event.load_character(5, "event/e600/e616/e616_tama1.gltf", "info", 42)
	event.set_character_active(0, 42)
	event.attach_object_handle_to_character(6, 42)
	event.clear_object_sequence(6, 42)
	event.set_object_sequence_object(6, 6)
	event.load_character(5, "event/e600/e616/e616_ozu_moe.gltf", "info", 43)
	event.set_character_active(0, 43)
	event.load_character(5, "event/e600/e616/e616_ozu_kemuri.gltf", "info", 44)
	event.set_character_active(0, 44)
	event.initialize_effect_manager(5)
	event.load_effect_base("Ｅ６１６月花ビームＢ")
	event.create_effect_work_buffer(5)
	event.load_message_file(0, 5, "event/e600/e616/e616.txt")
end

--- Restores the playable character and deletes every actor loaded for the burning scene.
local function unload_burning_scene_actors()
	local playable_character: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 0 then
		event.set_character_active(1, burning_scene_max_slot)
		event.set_character_active(0, burning_scene_monica_slot)
		event.delete_character_extension_packs(burning_scene_max_slot)
		event.delete_character_extension_packs(burning_scene_monica_slot)
		event.delete_character(burning_scene_monica_slot)
		event.delete_character(37)
	end
	if playable_character == 1 then
		event.set_character_active(1, burning_scene_monica_slot)
		event.set_character_active(0, burning_scene_max_slot)
		event.delete_character_extension_packs(burning_scene_max_slot)
		event.delete_character_extension_packs(burning_scene_monica_slot)
		event.delete_character(burning_scene_max_slot)
		event.delete_character(37)
	end
	event.delete_character(38)
	event.delete_character(39)
	event.delete_character(40)
	event.delete_character(41)
	event.delete_character(42)
	event.delete_character(43)
	event.delete_character(44)
end

--- Plays the skippable scene where Osmond catches fire and runs about, the moon flower beam fires and Toryon appears while the party watches.
local function play_burning_scene()
	local sound_bank: s32 = 0
	local projection: f32 = 0
	local osmond_sequence: s32 = 0
	local resume_point: number = 0
	vm.section(function()
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		sound_bank = event.load_sound_effect_file_2(7200) or sound_bank
		load_burning_scene_actors()
		projection = event.get_event_projection() or projection
		event.enable_drama_skip()
		event.set_object_handle_footstep_sound(0, 16)
		event.set_object_handle_footstep_sound(1, 16)
		event.set_object_handle_footstep_sound(2, 16)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "おこり顔")
		event.set_object_sequence_texture_animation(1, 1, "おこり目パチ")
		event.set_character_active(0, burning_scene_max_slot)
		event.set_character_active(1, burning_scene_monica_slot)
		event.set_character_active(1, 38)
		event.set_object_sequence_motion(0, "立ち", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "何てこと", 6, -1.0, 1)
		event.call_command(466, 1, "何てことL", 4, -1.0, 1) -- retail: the handler rejects 5 arguments
		event.set_object_sequence_motion(2, "立ち（上見）", 4)
		event.set_object_sequence_position(1, 32.0, 0.0, 1400.0)
		event.set_object_sequence_rotation(1, 0.0, -0.59, 0.0)
		event.set_object_sequence_position(0, -32.0, 0.0, 1400.0)
		event.set_object_sequence_rotation(0, 0.0, 3.13, 0.0)
		event.set_object_sequence_position(2, 17.0, 0.0, 1400.0)
		event.set_object_sequence_rotation(2, 0.0, 0.01, 0.0)
		event.set_object_sequence_position(3, 418.95, 294.2, 1072.8)
		event.set_object_sequence_rotation(3, 0.0, -2.72, 0.0)
		event.set_object_sequence_position(4, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(4, 0.0, 0.0, 0.0)
		event.set_object_sequence_position(5, 17.0, 0.0, 1380.0)
		event.set_object_sequence_rotation(5, 0.0, 0.0, 0.0)
		event.set_camera_sequence_position(-9.53, 17.78, 1399.96)
		event.set_camera_sequence_look_at(36.07, 23.27, 1405.88)
		event.fade_in_screen(30)
		event.set_mouth_texture_animations(1, "通常口パク")
		resume_point = 1
		message.show_voiced(6160060)
		event.reset_mouth_texture_animations()
		event.play_sound_effect(sound_bank, 6)
		event.set_mouth_texture_animations(2, "通常口パク")
		resume_point = 2
		message.show_voiced(6160070)
		event.reset_mouth_texture_animations()
		event.play_sound_effect(sound_bank, 7)
		resume_point = 3
		wait.frames(30)
		event.play_sound_effect(sound_bank, 8)
		event.set_wind(80.0, 17.0, 0.0, 1380.0)
		event.set_character_motion(41, "ヒット", 6, -1, 1)
		event.set_character_active(1, 41)
		resume_point = 4
		wait.frames(10)
		event.play_sound_effect(sound_bank, 9)
		event.set_wind(-1)
		event.set_object_sequence_motion(2, "とびあがる", 2)
		event.queue_object_sequence_next_motion(2, "とびあがるループ", 4)
		resume_point = 5
		wait.frames(60)
		event.attach_character_to_frame(38, "hi", 43)
		event.set_character_active(1, 43)
		event.set_character_active(0, 41)
		event.set_character_motion(43, "走り（燃える）", 4, -1, 1)
		event.set_object_sequence_position(4, 913.78, 1615.71, -1455.71)
		event.set_object_sequence_position(6, 913.78, 1615.71, -1455.71)
		event.set_object_sequence_rotation(6, 0.0, -0.16, 0.0)
		event.set_object_sequence_position(5, 0.0, 0.0, 1380.0)
		event.set_character_active(1, burning_scene_max_slot)
		event.set_object_sequence_rotation(1, 0.0, 3.13, 0.0)
		event.set_object_sequence_motion(2, "走り（燃える）", 4)
		event.set_event_projection(400.0)
		event.set_camera_sequence_position(0.0, 38.21, 1638.99)
		event.set_camera_sequence_look_at(0.0, 194.92, 737.84)
		osmond_sequence = 2
		event.clear_object_sequence_path(osmond_sequence)
		event.set_object_sequence_path_frames(osmond_sequence, 240)
		event.add_object_sequence_path_point(osmond_sequence, 0.0, 0.0, 1350.0)
		event.add_object_sequence_path_point(osmond_sequence, 100.0, 0.0, 1250.0)
		event.add_object_sequence_path_point(osmond_sequence, 0.0, 0.0, 1150.0)
		event.add_object_sequence_path_point(osmond_sequence, -100.0, 0.0, 1250.0)
		event.add_object_sequence_path_point(osmond_sequence, 0.0, 0.0, 1350.0)
		event.add_object_sequence_path_point(osmond_sequence, 100.0, 0.0, 1250.0)
		event.add_object_sequence_path_point(osmond_sequence, 0.0, 0.0, 1150.0)
		event.add_object_sequence_path_point(osmond_sequence, -100.0, 0.0, 1250.0)
		event.add_object_sequence_path_point(osmond_sequence, 0.0, 0.0, 1350.0)
		event.add_object_sequence_path_point(osmond_sequence, 100.0, 0.0, 1250.0)
		event.add_object_sequence_path_point(osmond_sequence, 0.0, 0.0, 1150.0)
		event.add_object_sequence_path_point(osmond_sequence, -100.0, 0.0, 1250.0)
		event.add_object_sequence_path_point(osmond_sequence, 0.0, 0.0, 1350.0)
		event.start_object_sequence_path(osmond_sequence)
		event.set_character_active(1, 40)
		event.set_object_sequence_motion(4, "入り", 6)
		event.queue_object_sequence_next_motion(4, "溜めループ", 4)
		event.play_sound_effect(sound_bank, 3)
		resume_point = 6
		message.show_voiced_for(6160080, -1)
		resume_point = 7
		message.show_voiced_for(6160090, -1)
		resume_point = 8
		object.wait_until_done(2)
		event.set_object_sequence_motion(0, "走り")
		event.set_object_sequence_motion(1, "走り")
		event.rotate_object_sequence(2, 0.0, 0.01, 0.0, 20)
		event.rotate_object_sequence(1, 0.0, 0.01, 0.0, 20)
		event.rotate_object_sequence(0, 0.0, -0.01, 0.0, 20)
		resume_point = 9
		object.wait_until_done(2)
		event.set_character_active(1, 42)
		event.play_sound_effect(sound_bank, 4)
		event.create_effect("Ｅ６１６月花ビームＢ")
		event.set_effect_first_vector(913.78, 1615.71, -1455.71)
		event.set_effect_second_vector(0.0, -0.16, 0.0)
		event.set_object_sequence_motion(4, "発射", 6)
		event.set_object_sequence_motion(6, "弾道", 6)
		event.move_object_sequence(0, -32.0, 0.0, 1818.0, 60)
		event.move_object_sequence(1, 32.0, 0.0, 1818.0, 60)
		event.move_object_sequence(2, 0.0, 0.0, 1818.0, 60)
		resume_point = 10
		wait.frames(30)
		event.set_character_active(1, 41)
		event.set_character_motion(41, "ヒット", 6, -1, 1)
		event.play_sound_effect(sound_bank, 5)
		resume_point = 11
		wait.frames(90)
		event.set_character_active(0, 40)
		event.set_event_projection(projection)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目～おどろき目")
		event.set_object_sequence_position(0, -32.0, 0.0, 2418.0)
		event.set_camera_sequence_position(-4.69, 10.72, 2447.12)
		event.set_camera_sequence_look_at(-32.39, 22.39, 2411.64)
		event.set_object_sequence_motion(0, "左後ろ見る", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(0, "左後ろ見るL", 4)
		resume_point = 12
		message.show_voiced(6160100)
		event.stop_music(0)
		resume_point = 13
		vm.wait(13)
		resume_point = 14
		vm.wait(14)
		resume_point = 15
		vm.wait(15)
		resume_point = 16
		vm.wait(16)
		event.load_music(190)
		event.attach_object_handle_to_character_frame(20, 39, "puropera")
		event.clear_object_sequence(20)
		event.set_object_sequence_object(20, 20)
		event.rotate_object_sequence(20, 0.0, -0.08, 0.0, -1)
		event.play_music(0)
		event.play_sound_effect(sound_bank, 10)
		event.set_character_active(1, 39)
		event.set_object_sequence_motion(3, "浮遊", 4)
		event.set_camera_sequence_position(329.6, 416.23, 860.98)
		event.set_camera_sequence_look_at(418.95, 436.16, 1072.8)
		resume_point = 17
		wait.frames(60)
		event.move_camera_sequence_eased(117.44, 416.23, 937.94, 373.95, 436.16, 1038.44, 120, 0, 0.4)
		resume_point = 18
		camera.wait_until_done()
		event.move_camera_sequence_eased(-1039.68, 1120.44, 3017.49, -375.04, 936.38, 1696.66, 300, 0, 0.4)
		resume_point = 19
		camera.wait_until_done()
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目パチ")
		event.set_character_active(0, 43)
		event.detach_character_from_frame(43)
		event.attach_character_to_frame(38, "hi", 44)
		event.set_character_active(1, 44)
		event.set_character_motion(44, "立ち（煙）", 4, -1, 1)
		event.set_object_sequence_motion(1, "立ち", 4, -1.0, 1)
		event.set_object_sequence_motion(2, "立ち（煙）", 4)
		event.set_camera_sequence_position(-154.51, 10.06, 1495.9)
		event.set_camera_sequence_look_at(1.55, 150.34, 2062.42)
		event.set_object_sequence_position(1, -97.73, 0.0, 1668.0)
		event.set_object_sequence_rotation(1, 0.0, -2.63, 0.0)
		event.set_object_sequence_position(0, -148.27, 0.0, 1617.78)
		event.set_object_sequence_rotation(0, 0.0, 0.13, 0.0)
		event.set_object_sequence_position(2, -101.78, 0.0, 1761.73)
		event.set_object_sequence_rotation(2, 0.0, 0.01, 0.0)
		resume_point = 20
		message.show_voiced(6160110)
		event.set_object_sequence_motion(0, "左後ろ見る戻り", 6, -1.0, 1)
		event.fade_out_screen(30)
		resume_point = 21
		wait.frames(35)
	end, function(received: { any }): boolean
		if resume_point <= 1 then
			message.show_voiced_skipping(6160070)
		end
		if resume_point <= 2 then
			wait.frames_skipping(30)
		end
		if resume_point <= 3 then
			wait.frames_skipping(10)
		end
		if resume_point <= 4 then
			wait.frames_skipping(60)
		end
		if resume_point <= 5 then
			osmond_sequence = 2
			message.show_voiced_for_skipping(6160080, -1)
		end
		if resume_point <= 6 then
			message.show_voiced_for_skipping(6160090, -1)
		end
		if resume_point <= 7 then
			cutscene.skip_command(2)
		end
		if resume_point <= 8 then
			cutscene.skip_command(2)
		end
		if resume_point <= 9 then
			wait.frames_skipping(30)
		end
		if resume_point <= 10 then
			wait.frames_skipping(90)
		end
		if resume_point <= 11 then
			message.show_voiced_skipping(6160100)
		end
		if resume_point <= 16 then
			wait.frames_skipping(60)
		end
		if resume_point <= 17 then
			wait.background_load_skipping()
		end
		if resume_point <= 18 then
			wait.background_load_skipping()
		end
		if resume_point <= 19 then
			message.show_voiced_skipping(6160110)
		end
		if resume_point <= 20 then
			wait.frames_skipping(35)
		end
		return true
	end)
	event.cancel_drama_scene_skip()
	event.skip_next_music_load()
	event.set_wind(-1)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.clear_effect_manager()
	unload_burning_scene_actors()
	event.set_event_projection(projection)
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
end

--- Loads the player characters and Osmond for the arrival scene and assigns their slots by the playable character.
local function load_arrival_scene_actors()
	local playable_character: s32 = 0
	event.set_message_window_mode(0, 7)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 0 then
		max_slot = 0
		monica_slot = 32
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", max_slot)
		event.load_character_motion_pack(5, "event/e600/e616/e616_mints.gltf", "info", max_slot)
		event.attach_object_handle_to_character(0, max_slot)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, max_slot)
		event.load_character(5, "chara/c02_base.gltf", "info", monica_slot)
		event.load_equipment_model(5, 1, 4, "info", monica_slot)
		event.load_equipment_model(5, 1, 3, "info", monica_slot)
		event.load_equipment_model(5, 1, 2, "info", monica_slot, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", monica_slot)
		event.load_character_motion_pack(5, "event/e600/e616/e616_monica.gltf", "info", monica_slot)
		event.attach_object_handle_to_character(1, monica_slot)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, monica_slot)
		event.set_character_active(1, 37)
	end
	if playable_character == 1 then
		max_slot = 32
		monica_slot = 0
		event.load_character(5, "chara/c01_base.gltf", "info", max_slot)
		event.load_equipment_model(5, 0, 4, "info", max_slot)
		event.load_equipment_model(5, 0, 3, "info", max_slot)
		event.load_equipment_model(5, 0, 2, "info", max_slot, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", max_slot)
		event.load_character_motion_pack(5, "event/e600/e616/e616_mints.gltf", "info", max_slot)
		event.attach_object_handle_to_character(0, max_slot)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, max_slot)
		event.set_character_active(1, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", monica_slot)
		event.load_character_motion_pack(5, "event/e600/e616/e616_monica.gltf", "info", monica_slot)
		event.attach_object_handle_to_character(1, monica_slot)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, monica_slot)
	end
	event.load_character(5, "event/e600/e616/e616_osmond.gltf", "info", 38)
	event.set_character_active(0, 38)
	event.attach_object_handle_to_character(2, 38)
	event.clear_object_sequence(2, 38)
	event.set_object_sequence_object(2, 2)
	event.load_message_file(0, 5, "event/e600/e616/e616.txt")
end

--- Restores the playable character and deletes the actors loaded for the arrival scene.
local function unload_arrival_scene_actors()
	local playable_character: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 0 then
		event.set_character_active(1, max_slot)
		event.set_character_active(0, monica_slot)
		event.delete_character_extension_packs(max_slot)
		event.delete_character_extension_packs(monica_slot)
		event.delete_character(monica_slot)
		event.delete_character(37)
	end
	if playable_character == 1 then
		event.set_character_active(1, monica_slot)
		event.set_character_active(0, max_slot)
		event.delete_character_extension_packs(max_slot)
		event.delete_character_extension_packs(monica_slot)
		event.delete_character(max_slot)
		event.delete_character(37)
	end
	event.delete_character(38)
end

--- Plays the skippable scene where Osmond runs up out of breath to the party and talks to them.
local function play_osmond_arrival_scene()
	local sound_bank: s32 = 0
	vm.section(function()
		event.set_save_flag(616, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.stop_music(0)
		event.load_music(166)
		event.play_music(0)
		sound_bank = event.load_sound_effect_file_2(7200) or sound_bank
		load_arrival_scene_actors()
		event.enable_drama_skip()
		event.set_object_handle_footstep_sound(0, 16)
		event.set_object_handle_footstep_sound(1, 16)
		event.set_object_handle_footstep_sound(2, 16)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "無表情")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "無表情")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_character_active(1, max_slot)
		event.set_character_active(1, monica_slot)
		event.set_character_active(1, 38)
		event.set_camera_sequence_position(0.0, 20.12, 505.57)
		event.set_camera_sequence_look_at(0.0, 30.0, 1531.66)
		event.set_object_sequence_motion(0, "歩き", 4, -1.0, 1)
		event.delay_object_sequence_motion_track(0, 180)
		event.set_object_sequence_motion(0, "立ち", 4)
		event.set_object_sequence_motion(1, "歩き", 4, -1.0, 1)
		event.delay_object_sequence_motion_track(1, 180)
		event.set_object_sequence_motion(1, "立ち", 4)
		event.set_object_sequence_motion(2, "走り")
		event.delay_object_sequence_motion_track(2, 200)
		event.set_object_sequence_motion(2, "とまる", 4)
		event.set_object_sequence_position(1, 16.0, 0.0, 621.38)
		event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
		event.set_object_sequence_position(0, -16.0, 0.0, 621.38)
		event.set_object_sequence_rotation(0, 0.0, 0.0, 0.0)
		event.set_object_sequence_position(2, 0.0, 0.0, 2232.39)
		event.set_object_sequence_rotation(2, 0.0, 3.13, 0.0)
		event.fade_in_screen(30)
		event.clear_object_sequence_path(2)
		event.set_object_sequence_path_frames(2, 200)
		event.add_object_sequence_path_point(2, 0.0, 0.0, 2232.39)
		event.add_object_sequence_path_point(2, 0.0, 0.0, 527.58)
		event.start_object_sequence_path(2)
		event.clear_object_sequence_path(0)
		event.set_object_sequence_path_frames(0, 180)
		event.add_object_sequence_path_point(0, -16.0, 0.0, 621.38)
		event.add_object_sequence_path_point(0, -16.0, 0.0, 730.69)
		event.start_object_sequence_path(0)
		event.clear_object_sequence_path(1)
		event.set_object_sequence_path_frames(1, 180)
		event.add_object_sequence_path_point(1, 16.0, 0.0, 621.38)
		event.add_object_sequence_path_point(1, 16.0, 0.0, 730.69)
		event.start_object_sequence_path(1)
		message.show_voiced(6160010)
		object.wait_until_done(2)
		event.set_object_sequence_rotation(1, 0.0, 3.13, 0.0)
		event.set_object_sequence_rotation(0, 0.0, 3.13, 0.0)
		wait.frames(15)
		event.play_sound_effect(sound_bank, 1)
		event.rotate_object_sequence(2, 0.0, 0.01, 0.0, 30)
		object.wait_until_done(2)
		wait.frames(30)
		event.set_object_sequence_motion(2, "走り")
		event.clear_object_sequence_path(2)
		event.set_object_sequence_path_frames(2, 60)
		event.add_object_sequence_path_point(2, 0.0, 0.0, 527.58)
		event.add_object_sequence_path_point(2, 0.0, 0.0, 700.0)
		event.start_object_sequence_path(2)
		object.wait_until_done(2)
		event.set_object_sequence_motion(0, "下見立ち", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "下見立ち", 4, -1.0, 1)
		event.set_object_sequence_motion(2, "ぜいぜい", 4)
		event.set_object_sequence_rotation(1, 0.0, -2.55, 0.0)
		event.set_object_sequence_rotation(0, 0.0, 2.89, 0.0)
		event.set_camera_sequence_position(-38.64, 38.38, 652.69)
		event.set_camera_sequence_look_at(-1.85, 14.77, 711.67)
		wait.frames(30)
		event.set_object_sequence_motion(0, "下見会話", 2)
		event.queue_object_sequence_next_motion(0, "下見立ち")
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced(6160020)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(2, "ぜいぜい（見上げ）in", 2)
		event.queue_object_sequence_next_motion(2, "ぜいぜい（見上げ）", 4)
		message.show_voiced(6160030)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "無表情")
		event.set_object_sequence_texture_animation(1, 1, "通常目～おこり目")
		event.set_object_sequence_motion(1, "キョロキョロ")
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced(6160040)
		event.reset_mouth_texture_animations()
		wait.frames(15)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目パチ")
		event.set_camera_sequence_position(-28.76, 13.15, 706.38)
		event.set_camera_sequence_look_at(-17.78, 21.48, 726.14)
		event.set_object_sequence_motion(0, "上見る", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(0, "上見るL")
		event.set_mouth_texture_animations(0, "通常口パク")
		message.show_voiced(6160050)
		event.reset_mouth_texture_animations()
		wait.frames(30)
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(200)
		event.add_camera_sequence_path_point(616.77, 208.31, 1155.4, 646.89, 231.29, 968.2)
		event.add_camera_sequence_path_point(-272.08, 208.31, 1012.37, -241.96, 231.29, 825.17)
		event.start_camera_sequence_path()
		event.start_crossfade(30)
		wait.frames(200)
		event.fade_out_screen(30)
		wait.frames(35)
	end)
	event.cancel_drama_scene_skip()
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.skip_next_music_load()
	event.stop_port_sound_effects(4)
	unload_arrival_scene_actors()
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded and does nothing.
function script.setup() end

script.initialize_map = initialize_map
script[99] = script.initialize_map

--- Places the player at the map entrance, depending on whether a save was just loaded from the memory card, and fades in.
function script.default_event()
	local memory_card_loaded: s32 = 0
	initialize_map()
	event.set_save_control_bits(1, 1)
	memory_card_loaded = event.take_memory_card_load_state() or memory_card_loaded
	if memory_card_loaded == 1 then
		character.place_standing_and_reset_cloth(50.0, vm.f32(140.7), -800.0, 0.0)
	else
		character.place_standing_and_reset_cloth(0.0, vm.f32(140.7), -900.0, 0.0)
	end
	event.reset_follow_camera(1, 0.0, 10.0)
	event.fade_in_screen(30)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = play_burning_scene

--- Event 400, which map data, a script or the engine runs by number.
script[400] = menu.open_with_fade

--- Fades out, clears the save control bits, sets the scene flag and jumps to the map s70.
function script.leave_for_s70()
	event.initialize_event()
	event.set_character_motion(0, "立ち")
	event.fade_out_screen(30)
	wait.frames(30)
	event.set_save_control_bits(1, 0)
	event.set_save_flag(616, 1)
	event.jump_to_map_3(-1, "s70", 520)
	vm.wait(2)
end
script[520] = script.leave_for_s70

--- Plays the burning scene and then jumps to the map s26.
function script.play_burning_scene_then_leave_for_s26()
	play_burning_scene()
	event.jump_to_map_3(-1, "s26", 550)
	vm.wait(2)
end
script[530] = script.play_burning_scene_then_leave_for_s26

--- Plays the rock-throwing cutscene and then jumps to the map s12.
function script.cutscene_rock_throwing()
	cutscene.play_rock_throwing_2()
	event.jump_to_map_3(-1, "s12", 590)
	vm.wait(2)
end
script[532] = script.cutscene_rock_throwing

--- Plays Andrea's appearance scene and then jumps to the map g05 without reloading the music or map sounds.
function script.cutscene_andrea_appearance_then_leave_for_g05()
	moon_flower_palace_event.play_andrea_appearance_scene()
	event.skip_next_music_load()
	event.skip_next_map_sound_load()
	event.jump_to_map_3(-1, "g05", 500)
	vm.wait(2)
end
script[550] = script.cutscene_andrea_appearance_then_leave_for_g05

--- Plays Osmond's arrival scene and then jumps to the map s32.
function script.play_osmond_arrival_then_leave_for_s32()
	play_osmond_arrival_scene()
	event.jump_to_map_3(-1, "s32", 500)
	vm.wait(2)
end
script[16160] = script.play_osmond_arrival_then_leave_for_s32

--- Plays Andrea's appearance scene and then jumps to the map g05 without reloading the music.
function script.cutscene_andrea_appearance_keep_music()
	moon_flower_palace_event.play_andrea_appearance_scene()
	event.skip_next_music_load()
	event.jump_to_map_3(-1, "g05", 500)
	vm.wait(2)
end
script[17000] = script.cutscene_andrea_appearance_keep_music

return script
