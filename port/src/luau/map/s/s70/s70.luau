--!strict
--- Plays the Moon Flower Palace cutscenes in which Osmond and Toryon chase the party, and routes the map's exits.

local vm = require("@lib/vm")
local camera = require("@lib/event/camera")
local character = require("@lib/event/character")
local cutscene = require("@lib/event/cutscene")
local menu = require("@lib/event/menu")
local message = require("@lib/event/message")
local moon_flower_palace_s70 = require("@lib/event/moon_flower_palace_s70")
local object = require("@lib/event/object")
local wait = require("@lib/event/wait")

local max_slot: s32 = 0
local monica_slot: s32 = 0
local beam_scene_max_slot: s32 = 0
local beam_scene_monica_slot: s32 = 0

--- Does nothing because the map has no initialization to run.
local function do_nothing() end

--- Loads the party, Osmond, Toryon, beam and effect assets for the Toryon beam cutscene.
local function load_toryon_beam_scene_assets()
	local active_character: s32 = 0
	event.set_message_window_mode(0, 7)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	active_character = event.get_playable_character() or active_character
	if active_character == 0 then
		beam_scene_max_slot = 0
		beam_scene_monica_slot = 32
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", beam_scene_max_slot)
		event.load_character_motion_pack(5, "event/e600/e616/e616_mints.gltf", "info", beam_scene_max_slot)
		event.attach_object_handle_to_character(0, beam_scene_max_slot)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, beam_scene_max_slot)
		event.load_character(5, "chara/c02_base.gltf", "info", beam_scene_monica_slot)
		event.load_equipment_model(5, 1, 4, "info", beam_scene_monica_slot)
		event.load_equipment_model(5, 1, 3, "info", beam_scene_monica_slot)
		event.load_equipment_model(5, 1, 2, "info", beam_scene_monica_slot, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", beam_scene_monica_slot)
		event.load_character_motion_pack(5, "event/e600/e616/e616_monica.gltf", "info", beam_scene_monica_slot)
		event.attach_object_handle_to_character(1, beam_scene_monica_slot)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, beam_scene_monica_slot)
		event.set_character_active(1, 37)
	end
	if active_character == 1 then
		beam_scene_max_slot = 32
		beam_scene_monica_slot = 0
		event.load_character(5, "chara/c01_base.gltf", "info", beam_scene_max_slot)
		event.load_equipment_model(5, 0, 4, "info", beam_scene_max_slot)
		event.load_equipment_model(5, 0, 3, "info", beam_scene_max_slot)
		event.load_equipment_model(5, 0, 2, "info", beam_scene_max_slot, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", beam_scene_max_slot)
		event.load_character_motion_pack(5, "event/e600/e616/e616_mints.gltf", "info", beam_scene_max_slot)
		event.attach_object_handle_to_character(0, beam_scene_max_slot)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, beam_scene_max_slot)
		event.set_character_active(1, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", beam_scene_monica_slot)
		event.load_character_motion_pack(5, "event/e600/e616/e616_monica.gltf", "info", beam_scene_monica_slot)
		event.attach_object_handle_to_character(1, beam_scene_monica_slot)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, beam_scene_monica_slot)
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

--- Releases the characters loaded for the Toryon beam cutscene.
local function unload_toryon_beam_scene_assets()
	local active_character: s32 = 0
	active_character = event.get_playable_character() or active_character
	if active_character == 0 then
		event.set_character_active(1, beam_scene_max_slot)
		event.set_character_active(0, beam_scene_monica_slot)
		event.delete_character_extension_packs(beam_scene_max_slot)
		event.delete_character_extension_packs(beam_scene_monica_slot)
		event.delete_character(beam_scene_monica_slot)
		event.delete_character(37)
	end
	if active_character == 1 then
		event.set_character_active(1, beam_scene_monica_slot)
		event.set_character_active(0, beam_scene_max_slot)
		event.delete_character_extension_packs(beam_scene_max_slot)
		event.delete_character_extension_packs(beam_scene_monica_slot)
		event.delete_character(beam_scene_max_slot)
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

--- Plays the cutscene in which Toryon's moon flower beam hits Osmond and the party runs away.
local function play_toryon_beam_scene()
	local sound_bank: s32 = 0
	local projection: f32 = 0
	local path_object_index: s32 = 0
	local step: number = 0
	vm.section(function()
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.load_map_sounds(7200)
		sound_bank = event.load_sound_effect_file_2(7200) or sound_bank
		load_toryon_beam_scene_assets()
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
		event.set_character_active(0, beam_scene_max_slot)
		event.set_character_active(1, beam_scene_monica_slot)
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
		step = 1
		message.show_voiced(6160060)
		event.reset_mouth_texture_animations()
		event.play_sound_effect(sound_bank, 6)
		event.set_mouth_texture_animations(2, "通常口パク")
		step = 2
		message.show_voiced(6160070)
		event.reset_mouth_texture_animations()
		event.play_sound_effect(sound_bank, 7)
		step = 3
		wait.for_frame_count(30)
		event.play_sound_effect(sound_bank, 8)
		event.set_wind(80.0, 17.0, 0.0, 1380.0)
		event.set_character_motion(41, "ヒット", 6, -1, 1)
		event.set_character_active(1, 41)
		step = 4
		wait.for_frame_count(10)
		event.play_sound_effect(sound_bank, 9)
		event.set_wind(-1)
		event.set_object_sequence_motion(1, "後ろ爆発", 6)
		event.queue_object_sequence_next_motion(1, "後ろ爆発L", 4)
		event.set_object_sequence_motion(2, "とびあがる", 2)
		event.queue_object_sequence_next_motion(2, "とびあがるループ", 4)
		step = 5
		wait.for_frame_count(60)
		event.attach_character_to_frame(38, "hi", 43)
		event.set_character_active(1, 43)
		event.set_character_active(0, 41)
		event.set_character_motion(43, "走り（燃える）", 4, -1, 1)
		event.set_object_sequence_position(4, 913.78, 1615.71, -1455.71)
		event.set_object_sequence_position(6, 913.78, 1615.71, -1455.71)
		event.set_object_sequence_rotation(6, 0.0, -0.16, 0.0)
		event.set_object_sequence_position(5, 0.0, 0.0, 1380.0)
		event.set_character_active(1, beam_scene_max_slot)
		event.set_object_sequence_rotation(1, 0.0, 3.13, 0.0)
		event.set_object_sequence_motion(2, "走り（燃える）", 4)
		event.set_event_projection(400.0)
		event.set_camera_sequence_position(0.0, 38.21, 1638.99)
		event.set_camera_sequence_look_at(0.0, 194.92, 737.84)
		path_object_index = 2
		event.clear_object_sequence_path(path_object_index)
		event.set_object_sequence_path_frames(path_object_index, 240)
		event.add_object_sequence_path_point(path_object_index, 0.0, 0.0, 1350.0)
		event.add_object_sequence_path_point(path_object_index, 100.0, 0.0, 1250.0)
		event.add_object_sequence_path_point(path_object_index, 0.0, 0.0, 1150.0)
		event.add_object_sequence_path_point(path_object_index, -100.0, 0.0, 1250.0)
		event.add_object_sequence_path_point(path_object_index, 0.0, 0.0, 1350.0)
		event.add_object_sequence_path_point(path_object_index, 100.0, 0.0, 1250.0)
		event.add_object_sequence_path_point(path_object_index, 0.0, 0.0, 1150.0)
		event.add_object_sequence_path_point(path_object_index, -100.0, 0.0, 1250.0)
		event.add_object_sequence_path_point(path_object_index, 0.0, 0.0, 1350.0)
		event.add_object_sequence_path_point(path_object_index, 100.0, 0.0, 1250.0)
		event.add_object_sequence_path_point(path_object_index, 0.0, 0.0, 1150.0)
		event.add_object_sequence_path_point(path_object_index, -100.0, 0.0, 1250.0)
		event.add_object_sequence_path_point(path_object_index, 0.0, 0.0, 1350.0)
		event.start_object_sequence_path(path_object_index)
		event.set_character_active(1, 40)
		event.set_object_sequence_motion(4, "入り", 6)
		event.queue_object_sequence_next_motion(4, "溜めループ", 4)
		event.play_sound_effect(sound_bank, 3)
		step = 6
		message.show_voiced_for_stopping(6160080, -1)
		step = 7
		message.show_voiced_for_stopping(6160090, -1)
		step = 8
		object.wait_until_done(2)
		event.set_object_sequence_motion(0, "走り")
		event.set_object_sequence_motion(1, "走り")
		event.rotate_object_sequence(2, 0.0, 0.01, 0.0, 20)
		event.rotate_object_sequence(1, 0.0, 0.01, 0.0, 20)
		event.rotate_object_sequence(0, 0.0, -0.01, 0.0, 20)
		step = 9
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
		step = 10
		wait.for_frame_count(30)
		event.set_character_active(1, 41)
		event.set_character_motion(41, "ヒット", 6, -1, 1)
		event.play_sound_effect(sound_bank, 5)
		step = 11
		wait.for_frame_count(90)
		event.set_character_active(0, 40)
		event.set_event_projection(projection)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目～おどろき目")
		event.set_object_sequence_position(0, -32.0, 0.0, 2418.0)
		event.play_sound_effect(sound_bank, 10)
		event.set_camera_sequence_position(-4.22, 16.51, 2448.91)
		event.set_camera_sequence_look_at(-30.91, 22.39, 2407.0)
		event.set_object_sequence_motion(0, "左後ろ見る", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(0, "左後ろ見るL", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		step = 12
		message.show_voiced(6160100)
		event.reset_mouth_texture_animations()
		event.stop_music(0)
		step = 13
		vm.wait(13)
		step = 14
		vm.wait(14)
		step = 15
		vm.wait(15)
		step = 16
		vm.wait(16)
		event.load_music(190)
		event.attach_object_handle_to_character_frame(20, 39, "puropera")
		event.clear_object_sequence(20)
		event.set_object_sequence_object(20, 20)
		event.rotate_object_sequence(20, 0.0, -0.08, 0.0, -1)
		event.play_music(0)
		event.set_character_active(1, 39)
		event.set_object_sequence_motion(3, "浮遊", 4)
		event.set_camera_sequence_position(329.6, 416.23, 860.98)
		event.set_camera_sequence_look_at(418.95, 436.16, 1072.8)
		step = 17
		wait.for_frame_count(60)
		event.move_camera_sequence_eased(117.44, 416.23, 937.94, 373.95, 436.16, 1038.44, 90, 0, 0.4)
		step = 18
		camera.wait_until_done()
		event.move_camera_sequence_eased(-325.06, 685.54, 1733.22, 87.51, 627.46, 1290.16, 150, 0, 0.4)
		step = 19
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
		event.set_object_sequence_motion(1, "走り", 4)
		event.set_camera_sequence_position(-154.51, 10.06, 1495.9)
		event.set_camera_sequence_look_at(1.55, 150.34, 2062.42)
		event.set_object_sequence_position(1, -81.32, 0.0, 1615.39)
		event.set_object_sequence_rotation(1, 0.0, -0.59, 0.0)
		event.set_object_sequence_position(0, -148.27, 0.0, 1617.78)
		event.set_object_sequence_rotation(0, 0.0, 0.13, 0.0)
		event.set_object_sequence_position(2, -101.78, 0.0, 1761.73)
		event.set_object_sequence_rotation(2, 0.0, 0.01, 0.0)
		event.move_object_sequence(1, -98.54, 0.0, 1658.48, 20)
		event.delay_object_sequence_rotation_track(1, 20)
		event.rotate_object_sequence(1, 0.0, -2.63, 0.0, 10)
		event.delay_object_sequence_motion_track(1, 40)
		event.set_object_sequence_motion(1, "立ち")
		event.queue_object_sequence_next_motion(1, "会話", 2)
		event.queue_object_sequence_next_motion(1, "立ち")
		step = 20
		message.show_voiced(6160110)
		event.set_object_sequence_motion(0, "左後ろ見る戻り", 6, -1.0, 1)
		event.fade_out_screen(30)
		step = 21
		wait.for_frame_count(35)
	end, function(received: { any }): boolean
		if step <= 1 then
			message.show_voiced_skipping(6160070)
		end
		if step <= 2 then
			wait.skip_frame_count(30)
		end
		if step <= 3 then
			wait.skip_frame_count(10)
		end
		if step <= 4 then
			wait.skip_frame_count(60)
		end
		if step <= 5 then
			path_object_index = 2
			message.show_voiced_for_stopping_skipping(6160080, -1)
		end
		if step <= 6 then
			message.show_voiced_for_stopping_skipping(6160090, -1)
		end
		if step <= 7 then
			cutscene.skip_command(2)
		end
		if step <= 8 then
			cutscene.skip_command(2)
		end
		if step <= 9 then
			wait.skip_frame_count(30)
		end
		if step <= 10 then
			wait.skip_frame_count(90)
		end
		if step <= 11 then
			message.show_voiced_skipping(6160100)
		end
		if step <= 16 then
			wait.skip_frame_count(60)
		end
		if step <= 17 then
			wait.background_load_skipping()
		end
		if step <= 18 then
			wait.background_load_skipping()
		end
		if step <= 19 then
			message.show_voiced_skipping(6160110)
		end
		if step <= 20 then
			wait.skip_frame_count(35)
		end
		return true
	end)
	event.cancel_drama_scene_skip()
	event.skip_next_music_load()
	event.set_wind(-1)
	event.stop_sound_effect(sound_bank, 10)
	event.stop_port_sound_effects(4)
	event.stop_all_sound_effects()
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.clear_effect_manager()
	step = 22
	vm.wait(22)
	unload_toryon_beam_scene_assets()
	event.set_event_projection(projection)
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
end

--- Loads the party and Osmond assets for the Osmond arrival cutscene.
local function load_osmond_arrival_scene_assets()
	local active_character: s32 = 0
	event.set_message_window_mode(0, 7)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	active_character = event.get_playable_character() or active_character
	if active_character == 0 then
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
	if active_character == 1 then
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

--- Assigns the Monica-active layout to the Max and Monica character slots.
local function assign_monica_active_slots()
	max_slot = 0
	monica_slot = 32
	max_slot = 32
	monica_slot = 0
end

--- Releases the characters loaded for the Osmond arrival cutscene and ends the event.
local function unload_osmond_arrival_scene_assets()
	local active_character: s32 = 0
	active_character = event.get_playable_character() or active_character
	if active_character == 0 then
		event.set_character_active(1, max_slot)
		event.set_character_active(0, monica_slot)
		event.delete_character_extension_packs(max_slot)
		event.delete_character_extension_packs(monica_slot)
		event.delete_character(monica_slot)
		event.delete_character(37)
	end
	if active_character == 1 then
		event.set_character_active(1, monica_slot)
		event.set_character_active(0, max_slot)
		event.delete_character_extension_packs(max_slot)
		event.delete_character_extension_packs(monica_slot)
		event.delete_character(max_slot)
		event.delete_character(37)
	end
	event.set_scene_status_flags(1, 0, 256, 0)
	event.delete_character(38)
	event.finish_event()
	vm.wait(1)
end

--- Plays the cutscene in which Osmond runs up to the party out of breath.
local function play_osmond_arrival_scene()
	local sound_bank: s32 = 0
	local step: number = 0
	vm.section(function()
		step = 1
		vm.entry(1)
		event.set_save_flag(616, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.load_map_sounds(7200)
		sound_bank = event.load_sound_effect_file_2(7200) or sound_bank
		load_osmond_arrival_scene_assets()
		event.enable_drama_skip()
		event.set_scene_status_flags(1, 0, 256, 1)
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
		step = 2
		message.show_voiced(6160010)
		step = 3
		object.wait_until_done(2)
		event.set_object_sequence_rotation(1, 0.0, 3.13, 0.0)
		event.set_object_sequence_rotation(0, 0.0, 3.13, 0.0)
		step = 4
		wait.for_frame_count(15)
		event.play_sound_effect(sound_bank, 1)
		event.rotate_object_sequence(2, 0.0, 0.01, 0.0, 30)
		step = 5
		object.wait_until_done(2)
		step = 6
		wait.for_frame_count(30)
		event.set_object_sequence_motion(2, "走り")
		event.clear_object_sequence_path(2)
		event.set_object_sequence_path_frames(2, 60)
		event.add_object_sequence_path_point(2, 0.0, 0.0, 527.58)
		event.add_object_sequence_path_point(2, 0.0, 0.0, 700.0)
		event.start_object_sequence_path(2)
		step = 7
		object.wait_until_done(2)
		event.set_object_sequence_motion(0, "下見立ち", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "下見立ち", 4, -1.0, 1)
		event.set_object_sequence_motion(2, "ぜいぜい", 4)
		event.set_object_sequence_rotation(1, 0.0, -2.55, 0.0)
		event.set_object_sequence_rotation(0, 0.0, 2.89, 0.0)
		event.set_camera_sequence_position(-38.64, 38.38, 652.69)
		event.set_camera_sequence_look_at(-1.85, 14.77, 711.67)
		step = 8
		wait.for_frame_count(30)
		event.set_object_sequence_motion(0, "下見会話", 2)
		event.queue_object_sequence_next_motion(0, "下見立ち")
		event.set_mouth_texture_animations(0, "通常口パク")
		step = 9
		message.show_voiced(6160020)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(2, "ぜいぜい（見上げ）in", 2)
		event.queue_object_sequence_next_motion(2, "ぜいぜい（見上げ）", 4)
		step = 10
		message.show_voiced(6160030)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "無表情")
		event.set_object_sequence_texture_animation(1, 1, "通常目～おこり目")
		event.set_object_sequence_motion(1, "キョロキョロ")
		event.set_mouth_texture_animations(1, "通常口パク")
		step = 11
		message.show_voiced(6160040)
		event.reset_mouth_texture_animations()
		step = 12
		wait.for_frame_count(15)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目パチ")
		event.set_camera_sequence_position(-28.76, 13.15, 706.38)
		event.set_camera_sequence_look_at(-17.78, 21.48, 726.14)
		event.set_object_sequence_motion(0, "上見る", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(0, "上見るL")
		event.set_mouth_texture_animations(0, "通常口パク")
		step = 13
		message.show_voiced(6160050)
		event.reset_mouth_texture_animations()
		step = 14
		wait.for_frame_count(30)
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(200)
		event.add_camera_sequence_path_point(616.77, 208.31, 1155.4, 646.89, 231.29, 968.2)
		event.add_camera_sequence_path_point(-272.08, 208.31, 1012.37, -241.96, 231.29, 825.17)
		event.start_camera_sequence_path()
		event.start_crossfade(30)
		step = 15
		wait.for_frame_count(200)
		event.fade_out_screen(30)
		step = 16
		wait.for_frame_count(35)
	end, function(received: { any }): boolean
		if step <= 1 then
			assign_monica_active_slots()
			message.show_voiced_skipping(6160010)
		end
		if step <= 2 then
			cutscene.skip_command(2)
		end
		if step <= 3 then
			wait.skip_frame_count(15)
		end
		if step <= 4 then
			cutscene.skip_command(2)
		end
		if step <= 5 then
			wait.skip_frame_count(30)
		end
		if step <= 6 then
			cutscene.skip_command(2)
		end
		if step <= 7 then
			wait.skip_frame_count(30)
		end
		if step <= 8 then
			message.show_voiced_skipping(6160020)
		end
		if step <= 9 then
			message.show_voiced_skipping(6160030)
		end
		if step <= 10 then
			message.show_voiced_skipping(6160040)
		end
		if step <= 11 then
			wait.skip_frame_count(15)
		end
		if step <= 12 then
			message.show_voiced_skipping(6160050)
		end
		if step <= 13 then
			wait.skip_frame_count(30)
		end
		if step <= 14 then
			wait.skip_frame_count(200)
		end
		if step <= 15 then
			wait.skip_frame_count(35)
		end
		return true
	end)
	step = 17
	vm.entry(17)
	event.cancel_drama_scene_skip()
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	event.skip_next_music_load()
	event.stop_port_sound_effects(4)
	step = 18
	vm.wait(18)
	step = 19
	unload_osmond_arrival_scene_assets()
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
end

--- Plays the cutscene in which the rock thrower hurls rocks at the party.
local function play_rock_throwing_scene()
	local sound_bank: s32 = 0
	vm.section(function()
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.load_map_sounds(7202)
		sound_bank = event.load_sound_effect_file_2(7202) or sound_bank
		event.set_character_active(0, 0)
		moon_flower_palace_s70.load_rock_throw_actors()
		event.enable_drama_skip()
		event.set_object_sequence_position(3, 418.95, 294.2, 1072.8)
		event.set_object_sequence_rotation(3, 0.0, -2.72, 0.0)
		event.attach_object_handle_to_character_frame(20, 39, "puropera")
		event.clear_object_sequence(20)
		event.set_object_sequence_object(20, 20)
		event.rotate_object_sequence(20, 0.0, -0.08, 0.0, -1)
		event.set_character_active(1, 39)
		event.set_object_sequence_motion(3, "手を上げる", 6)
		event.play_sound_effect(sound_bank, 3)
		event.play_sound_effect(sound_bank, 4)
		event.fade_in_screen(30)
		event.set_camera_sequence_position(255.67, 441.0, 685.71)
		event.set_camera_sequence_look_at(418.95, 461.85, 1072.8)
		wait.for_frame_count(60)
		event.set_object_sequence_position(6, 88.84, 1037.6, -32.69)
		event.set_object_sequence_position(7, 258.39, 922.4, -447.25)
		event.set_camera_sequence_position(-1039.68, 1120.44, 3017.49)
		event.set_camera_sequence_look_at(-375.04, 936.38, 1696.66)
		event.set_character_active(1, 40)
		event.set_character_active(1, 41)
		event.set_object_sequence_motion(3, "岩を投げる", 4)
		event.play_sound_effect(sound_bank, 5)
		event.set_object_sequence_position(4, 418.95, 500.0, 1072.8)
		event.jump_object_sequence(4, -200.0, 500.0, -1000.0, -1.2, 60)
		wait.for_frame_count(30)
		event.set_character_active(1, 42)
		event.set_character_motion(42, "ヒット", 6, -1.0, 1)
		event.play_sound_effect(sound_bank, 6)
		event.play_sound_effect(sound_bank, 5)
		event.set_object_sequence_position(5, 418.95, 500.0, 1072.8)
		event.jump_object_sequence(5, 200.0, 500.0, -1000.0, -1.2, 60)
		wait.for_frame_count(30)
		event.set_character_active(1, 43)
		event.set_character_motion(43, "ヒット", 6, -1.0, 1)
		event.play_sound_effect(sound_bank, 6)
		event.play_sound_effect(sound_bank, 5)
		event.set_object_sequence_position(4, 418.95, 500.0, 1072.8)
		event.jump_object_sequence(4, -200.0, 500.0, -1000.0, -1.2, 60)
		wait.for_frame_count(30)
		event.set_character_active(1, 42)
		event.set_character_motion(42, "ヒット", 6, -1.0, 1)
		event.play_sound_effect(sound_bank, 6)
		event.play_sound_effect(sound_bank, 5)
		event.set_object_sequence_position(5, 418.95, 500.0, 1072.8)
		event.jump_object_sequence(5, 200.0, 500.0, -1000.0, -1.2, 60)
		wait.for_frame_count(30)
		event.set_character_active(1, 43)
		event.set_character_motion(43, "ヒット", 6, -1.0, 1)
		event.play_sound_effect(sound_bank, 6)
		event.play_sound_effect(sound_bank, 5)
		event.set_object_sequence_position(4, 418.95, 500.0, 1072.8)
		event.jump_object_sequence(4, -200.0, 500.0, -1000.0, -1.2, 60)
		wait.for_frame_count(30)
		event.set_character_active(1, 42)
		event.set_character_motion(42, "ヒット", 6, -1.0, 1)
		event.play_sound_effect(sound_bank, 6)
		event.play_sound_effect(sound_bank, 5)
		event.set_object_sequence_position(5, 418.95, 500.0, 1072.8)
		event.jump_object_sequence(5, 200.0, 500.0, -1000.0, -1.2, 60)
		wait.for_frame_count(30)
		event.set_character_active(1, 43)
		event.set_character_motion(43, "ヒット", 6, -1.0, 1)
		event.play_sound_effect(sound_bank, 6)
		event.fade_out_screen(30)
		wait.for_frame_count(35)
	end)
	event.cancel_drama_scene_skip()
	event.skip_next_music_load()
	event.stop_all_sound_effects()
	event.stop_sound_effect(sound_bank, 3)
	vm.wait(9)
	moon_flower_palace_s70.delete_rock_throw_actors()
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded and does nothing.
function script.setup() end

script.do_nothing = do_nothing
script[99] = script.do_nothing

--- Places the player at the map entrance, restarting the music after a memory card load.
function script.default_event()
	local memory_card_load_state: s32 = 0
	do_nothing()
	event.set_save_control_bits(1, 1)
	memory_card_load_state = event.take_memory_card_load_state() or memory_card_load_state
	if memory_card_load_state == 1 then
		event.stop_music(0)
		wait.for_frame_count(4)
		event.load_music(166)
		event.play_music(0)
		character.place_standing_and_reset_cloth(50.0, vm.f32(140.7), -800.0, 0.0)
	else
		character.place_standing_and_reset_cloth(0.0, vm.f32(140.7), -900.0, 0.0)
	end
	event.reset_follow_camera(1, 0.0, 10.0)
	event.fade_in_screen(30)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = play_toryon_beam_scene

--- Opens the menu with the town save data value set.
function script.open_menu_in_town()
	event.set_save_data_value(3, 1)
	menu.open_type_7()
	event.set_save_data_value(3, 0)
end
script[400] = script.open_menu_in_town

--- Fades out, plays the Osmond arrival cutscene and jumps to map s32.
function script.cutscene_osmond_arrival_then_go_to_s32()
	local step: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.set_character_motion(0, "立ち")
		event.fade_out_screen(30)
		step = 1
		wait.for_frame_count(30)
		event.set_save_control_bits(1, 0)
		event.set_save_flag(616, 1)
		step = 2
		play_osmond_arrival_scene()
		event.jump_to_map_3(-1, "s32", 500)
		step = 3
		vm.wait(3)
		return
	end, function(received: { any })
		if step <= 3 then
			if step <= 1 then
				step = 2
				play_osmond_arrival_scene()
				return vm.continue_with(function()
					event.jump_to_map_3(-1, "s32", 500)
					step = 3
					vm.wait(3)
					return
				end)
			end
			return 0
		end
		return nil
	end)
end
script[520] = script.cutscene_osmond_arrival_then_go_to_s32

--- Plays the Toryon beam cutscene and jumps to map s26.
function script.cutscene_toryon_beam_then_go_to_s26()
	play_toryon_beam_scene()
	event.jump_to_map_3(-1, "s26", 550)
	vm.wait(2)
end
script[530] = script.cutscene_toryon_beam_then_go_to_s26

--- Plays the rock throwing cutscene and jumps to map s71.
function script.cutscene_rock_throwing_then_go_to_s71()
	play_rock_throwing_scene()
	event.jump_to_map_3(-1, "s71", 590)
	vm.wait(2)
end
script[532] = script.cutscene_rock_throwing_then_go_to_s71

--- Plays the Osmond arrival cutscene and jumps to map s32 without fading first.
function script.cutscene_osmond_arrival_then_go_to_s32_directly()
	play_osmond_arrival_scene()
	event.jump_to_map_3(-1, "s32", 500)
	vm.wait(2)
end
script[16160] = script.cutscene_osmond_arrival_then_go_to_s32_directly

return script
