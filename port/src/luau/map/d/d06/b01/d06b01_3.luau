--!strict
--- Event script for the first Moon Flower Palace boss room, with the boss drop and awakening cutscenes, battle phase starts and map exits.

local vm = require("@lib/vm")
local camera = require("@lib/event/camera")
local character = require("@lib/event/character")
local cutscene = require("@lib/event/cutscene")
local dungeon = require("@lib/event/dungeon")
local message = require("@lib/event/message")
local moon_flower_palace_boss_1 = require("@lib/event/moon_flower_palace_boss_1")
local object = require("@lib/event/object")
local wait = require("@lib/event/wait")

local drop_scene_max_slot: s32 = 0
local drop_scene_monica_slot: s32 = 0
local awakening_scene_max_slot: s32 = 0
local awakening_scene_monica_slot: s32 = 0

--- Placeholder hook run on map entry that does nothing.
local function on_map_loaded() end

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
	event.load_message_file(0, 5, "event/e700/e728/e728_1.txt")
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
		wait.frames(15)
		event.play_sound_effect(sound_bank, 0)
		event.set_object_sequence_motion(11, "ドスッ", 2)
		event.queue_object_sequence_next_motion(11, "ドスッＬ", 4)
		step = 3
		wait.frames(30)
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(200)
		event.add_camera_sequence_path_point(-67.28, 15.66, -27.15, -7.11, 7.02, -6.4)
		event.add_camera_sequence_path_point(-67.28, 40.31, -27.15, -7.11, 31.68, -6.4)
		event.start_camera_sequence_path()
		step = 4
		message.show_voiced_for(7280010, -1)
		step = 5
		camera.wait_until_done()
		event.set_camera_sequence_position(0.0, 4.51, -46.14)
		event.set_camera_sequence_look_at(0.0, 30.71, -128.08)
		step = 6
		wait.frames(30)
		event.play_sound_effect(sound_bank, 1)
		event.set_character_position(10, 0.0, 0.0, 0.0)
		event.set_character_rotation(10, 0.0, 3.12, 0.0)
		event.set_character_motion(10, "ドスッＬ")
		event.set_character_active(1, 10)
		event.set_camera_sequence_position(0.0, 18.36, -103.26)
		event.set_camera_sequence_look_at(0.0, 27.17, 0.0)
		step = 7
		wait.frames(30)
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
			wait.frames_skipping(15)
		end
		if step <= 2 then
			wait.frames_skipping(30)
		end
		if step <= 3 then
			message.show_voiced_for_skipping(7280010, -1)
		end
		if step <= 4 then
			wait.background_load_skipping()
		end
		if step <= 5 then
			wait.frames_skipping(30)
		end
		if step <= 6 then
			wait.frames_skipping(30)
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
	wait.frames(60)
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
		wait.frames(20)
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
		wait.frames(30)
		step = 4
		play_boss_drop_cutscene()
		event.skip_next_music_load()
		event.load_dungeon_map("s44")
		event.load_event_script("s44/s44.stb", 510)
		return
	end, function(received: { any })
		if step <= 4 then
			if step <= 2 then
				wait.frames_skipping(30)
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
	event.load_message_file(0, 5, "event/e700/e728/e728_1.txt")
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
	event.load_character(6, "event/e700/e728/e728_dark_smoke.gltf", "info", 10, 1)
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
		wait.frames(60)
		event.set_camera_sequence_position(-32.93, 11.56, -74.72)
		event.set_camera_sequence_look_at(2.53, 23.99, -128.27)
		step = 6
		wait.frames(60)
		event.play_sound_effect(sound_bank, 0)
		event.play_music(0)
		event.set_camera_sequence_position(-9.32, 6.57, -86.8)
		event.set_camera_sequence_look_at(-1.8, 11.05, -21.29)
		event.set_character_motion(11, "倒れ")
		event.set_character_active(1, 11)
		step = 7
		wait.frames(60)
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
		wait.frames(60)
		step = 10
		message.show_voiced_for(7280130, -1)
		step = 11
		wait.frames(15)
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
		wait.frames(30)
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
		wait.frames(20)
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
		wait.frames(15)
		event.set_character_active(1, 23)
		event.set_character_position(23, 0.0, 0.0, 0.0)
		event.set_character_rotation(23, 0.0, 0.0, 0.0)
		event.set_character_motion(23, "暗黒エレキ", 6, -1, 1)
		event.shake_camera_sequence(0.0, 0.6, 0.0, 30)
		step = 20
		camera.wait_until_done()
		step = 21
		wait.frames(30)
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
		message.show_voiced_for(7280140, 30)
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
		wait.frames(15)
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
		message.show_voiced_for(7280150, -1)
		event.fade_out_music(60)
		step = 29
		wait.frames(60)
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
		wait.frames(90)
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
		wait.frames(30)
		event.set_object_sequence_motion(5, "ブルブル", 4)
		event.set_character_active(0, 19)
		event.set_character_active(0, 20)
		event.set_character_active(0, 21)
		step = 36
		wait.frames(90)
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
		wait.frames(60)
		event.delete_character(10)
		event.delete_character(11)
		event.delete_character(12)
		event.delete_character(22)
		event.delete_character(19)
		event.delete_character(20)
		event.delete_character(21)
		event.clear_memory_stack(6)
		event.load_character(6, "event/e700/e728/e728_dark.gltf", "info", 10, 1)
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
		telop_image_block = event.load_event_image_4(6, "textures/event/e700/e728/e728telop06_1.json", 0) or telop_image_block
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
		wait.frames(60)
		event.set_character_motion(11, "手を広げるL", 4, -1, 1)
		step = 40
		wait.frames(90)
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
		wait.frames(60)
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
		wait.frames(60)
	end, function(received: { any }): boolean
		if step <= 4 then
			set_drop_scene_skip_slots()
			wait.frames_skipping(60)
		end
		if step <= 5 then
			wait.frames_skipping(60)
		end
		if step <= 6 then
			wait.frames_skipping(60)
		end
		if step <= 7 then
			wait.background_load_skipping()
		end
		if step <= 8 then
			wait.frames_skipping(60)
		end
		if step <= 9 then
			message.show_voiced_for_skipping(7280130, -1)
		end
		if step <= 10 then
			wait.frames_skipping(15)
		end
		if step <= 11 then
			wait.background_load_skipping()
		end
		if step <= 12 then
			wait.frames_skipping(30)
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
			wait.frames_skipping(20)
		end
		if step <= 18 then
			wait.frames_skipping(15)
		end
		if step <= 19 then
			wait.background_load_skipping()
		end
		if step <= 20 then
			wait.frames_skipping(30)
		end
		if step <= 21 then
			message.show_voiced_for_skipping(7280140, 30)
		end
		if step <= 22 then
			cutscene.skip_command(2)
		end
		if step <= 23 then
			cutscene.skip_command(0)
		end
		if step <= 24 then
			wait.frames_skipping(15)
		end
		if step <= 25 then
			cutscene.skip_command(0)
		end
		if step <= 26 then
			cutscene.skip_command(0)
		end
		if step <= 27 then
			message.show_voiced_for_skipping(7280150, -1)
		end
		if step <= 28 then
			wait.frames_skipping(60)
		end
		if step <= 33 then
			wait.frames_skipping(90)
		end
		if step <= 34 then
			wait.frames_skipping(30)
		end
		if step <= 35 then
			wait.frames_skipping(90)
		end
		if step <= 36 then
			wait.frames_skipping(60)
		end
		if step <= 37 then
			wait.background_load_skipping()
		end
		if step <= 38 then
			wait.frames_skipping(60)
		end
		if step <= 39 then
			wait.frames_skipping(90)
		end
		if step <= 40 then
			wait.background_load_skipping()
		end
		if step <= 41 then
			wait.background_load_skipping()
		end
		if step <= 42 then
			wait.frames_skipping(60)
		end
		if step <= 43 then
			wait.frames_skipping(60)
		end
		return true
	end)
	event.cancel_drama_scene_skip()
	event.fade_out_camera_sequence(60, 255.0, 255.0, 255.0)
	step = 45
	wait.frames(65)
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
		moon_flower_palace_boss_1.play_griffon_summoning_cutscene()
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
	wait.until_button_pressed(64)
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
		wait.frames(4)
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
				wait.frames_skipping(4)
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
	wait.frames(30)
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
	wait.frames(30)
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
	wait.frames(10)
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
	wait.frames(10)
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
	moon_flower_palace_boss_1.play_boss_wing_spread_cutscene()
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
	moon_flower_palace_boss_1.play_boss_awakening_cutscene()
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
		wait.frames(4)
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
	moon_flower_palace_boss_1.play_griffon_dialogue_cutscene()
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
				dungeon.handle_defeat_with_dialogue_voiced(0, 8560060)
			else
				step = 2
				dungeon.handle_defeat_with_dialogue_voiced(0, 8560070)
			end
			return
		end
		step = 3
		dungeon.handle_defeat_with_dialogue_silent(0)
		return
	end, function(received: { any })
		if step <= 2 then
			if step <= 1 then
				dungeon.skip_defeat_dialogue_sequence_voiced(0, 8560070)
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
script[17160] = moon_flower_palace_boss_1.play_griffon_summoning_cutscene

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
