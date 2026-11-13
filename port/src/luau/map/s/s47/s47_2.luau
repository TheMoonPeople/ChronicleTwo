--!strict
--- Plays the Georama intro cutscenes: the gift of materials and a bigger item bag, the tree-planting arrival, and the Atla conversation.

local vm = require("@lib/vm")
local camera = require("@lib/event/camera")
local cutscene = require("@lib/event/cutscene")
local inventory = require("@lib/event/inventory")
local message = require("@lib/event/message")
local object = require("@lib/event/object")
local sindain_event = require("@lib/event/sindain_event")
local wait = require("@lib/event/wait")

local max_slot: s32 = 0
local monica_slot: s32 = 0

--- Loads Max, Monica and the gift scene's characters and motion packs into their slots.
local function load_gift_scene_cast()
	local playable_character: s32 = 0
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 0 then
		max_slot = 0
		monica_slot = 32
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", max_slot)
		event.load_character_motion_pack(5, "event/e200/e254/e254_mints.gltf", "info", max_slot)
		event.attach_object_handle_to_character(0, max_slot)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, max_slot)
		event.load_character(5, "chara/c02_base.gltf", "info", monica_slot)
		event.load_equipment_model(5, 1, 4, "info", monica_slot)
		event.load_equipment_model(5, 1, 3, "info", monica_slot)
		event.load_equipment_model(5, 1, 2, "info", monica_slot, 38)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", monica_slot)
		event.load_character_motion_pack(5, "event/e200/e254/e254_monica.gltf", "info", monica_slot)
		event.attach_object_handle_to_character(1, monica_slot)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, monica_slot)
		event.set_character_active(1, 38)
	end
	if playable_character == 1 then
		max_slot = 32
		monica_slot = 0
		event.load_character(5, "chara/c01_base.gltf", "info", max_slot)
		event.load_equipment_model(5, 0, 4, "info", max_slot)
		event.load_equipment_model(5, 0, 3, "info", max_slot)
		event.load_equipment_model(5, 0, 2, "info", max_slot, 38)
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", max_slot)
		event.load_character_motion_pack(5, "event/e200/e254/e254_mints.gltf", "info", max_slot)
		event.attach_object_handle_to_character(0, max_slot)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, max_slot)
		event.set_character_active(1, 38)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", monica_slot)
		event.load_character_motion_pack(5, "event/e200/e254/e254_monica.gltf", "info", monica_slot)
		event.attach_object_handle_to_character(1, monica_slot)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, monica_slot)
	end
	event.attach_object_handle_to_character(2, 1)
	event.set_object_handle_visible(2, 0)
	event.attach_object_handle_to_character(3, 2)
	event.set_object_handle_visible(3, 0)
	event.load_character(5, "event/e200/e254/e254_conda.gltf", "info", 36)
	event.set_character_active(0, 36)
	event.attach_object_handle_to_character(4, 36)
	event.clear_object_sequence(3)
	event.set_object_sequence_object(3, 4)
	event.load_character(5, "event/e200/e254/e254_fukuro.gltf", "info", 35)
	event.set_character_active(0, 35)
	event.attach_object_handle_to_character(5, 35)
	event.clear_object_sequence(4)
	event.set_object_sequence_object(4, 5)
	event.load_character(5, "event/e200/e254/e254_toryon.gltf", "info", 37)
	event.set_character_active(0, 37)
	event.attach_object_handle_to_character(6, 37)
	event.clear_object_sequence(5)
	event.set_object_sequence_object(5, 6)
	event.load_message_file(0, 5, "event/e200/e254/e254.txt")
end

--- Sets the Max and Monica slot variables to the values used when Monica is the playable character.
local function assign_gift_scene_slots_for_skip()
	max_slot = 0
	monica_slot = 32
	max_slot = 32
	monica_slot = 0
end

--- Restores the party and deletes the gift scene's extra characters.
local function unload_gift_scene_cast()
	local playable_character: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 0 then
		event.set_character_active(1, max_slot)
		event.set_character_active(0, monica_slot)
		event.delete_character_extension_packs(max_slot)
		event.delete_character_extension_packs(monica_slot)
		event.delete_character(monica_slot)
		event.delete_character(38)
	end
	if playable_character == 1 then
		event.set_character_active(1, monica_slot)
		event.set_character_active(0, max_slot)
		event.delete_character_extension_packs(max_slot)
		event.delete_character_extension_packs(monica_slot)
		event.delete_character(max_slot)
		event.delete_character(38)
	end
	event.attach_object_handle_to_character(2, 1)
	event.set_object_handle_visible(2, 1)
	event.attach_object_handle_to_character(3, 2)
	event.set_object_handle_visible(3, 1)
	event.delete_character(36)
	event.delete_character(35)
	event.delete_character(37)
end

--- Plays the scene in which materials and a bigger item bag are given and the player is told to open the Georama map.
local function play_gift_scene()
	local sound_bank: s32 = 0
	local answer: s32 = 0
	local checkpoint: number = 0
	vm.section(function()
		event.initialize_event()
		event.apply_message_window_preset(0, 0)
		event.fade_out_screen(30)
		checkpoint = 1
		wait.frames(30)
		event.load_map_sounds(2238)
		sound_bank = event.load_sound_effect_file_2(2238) or sound_bank
		load_gift_scene_cast()
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-36.27, 5.25, -87.21)
		event.set_camera_sequence_look_at(0.0, 35.12, -200.0)
		event.set_character_active(1, max_slot)
		event.set_character_active(1, monica_slot)
		event.set_character_active(1, 38)
		event.set_character_active(1, 36)
		event.set_character_active(1, 35)
		event.set_object_sequence_position(0, 9.65, 0.0, -163.16)
		event.set_object_sequence_rotation(0, 0.0, -2.66, 0.0)
		event.set_object_sequence_motion(0, "立ち", 4)
		event.set_object_sequence_position(1, 27.55, 0.0, -175.0)
		event.set_object_sequence_rotation(1, 0.0, -2.66, 0.0)
		event.set_object_sequence_motion(1, "立ち", 4)
		event.set_object_sequence_position(3, 0.0, 0.0, -200.0)
		event.set_object_sequence_rotation(3, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(3, "立ち", 4)
		event.set_object_sequence_position(4, -29.84, 0.0, -214.7)
		event.set_object_sequence_rotation(4, 0.0, -0.04, 0.0)
		event.set_object_sequence_scale(4, 1.0, 1.0, 1.0)
		event.fade_in_screen(30)
		checkpoint = 2
		wait.frames(30)
		event.set_object_sequence_motion(3, "会話2")
		event.open_message_window_2(
			0,
			"Voici un petit cadeau de notre\npart, vous en aurez besoin\npour reconstruire la for[UNI00ea]t.<page>M[UNI00ea]me avec le Charpention et les\ng[UNI00e9]opierres, rien n'est possible\nsans mat[UNI00e9]riaux !"
		)
		checkpoint = 3
		message.show(0, -1, 2, 256, 416)
		event.open_message_window_2(
			0,
			"...Oh la la, votre sac me\npara[UNI00ee]t vraiment petit, il n'y\na de place pour rien l[UNI00e0]-dedans.<page>H[UNI00e9] ben tiens ! Je vais vous\nrendre un grand service.\nOn va agrandir ce sac !"
		)
		checkpoint = 4
		message.show(0, -1, 2, 256, 416)
		event.open_message_window_2(
			0,
			"Mais je vous pr[UNI00e9]viens, je ne\nsuis pas toujours aussi gentil.<page>C'est juste que je suis d'humeur\ng[UNI00e9]n[UNI00e9]reuse aujourd'hui."
		)
		checkpoint = 5
		message.show(0, -1, 2, 256, 416)
		event.set_object_sequence_motion(3, "立ち")
		event.set_object_sequence_scale(4, 0.9, 0.9, 0.9)
		checkpoint = 6
		inventory.announce_received(210, 28)
		event.set_object_sequence_scale(4, 0.8, 0.8, 0.8)
		checkpoint = 7
		inventory.announce_received(214, 1)
		event.set_object_sequence_scale(4, 0.7, 0.7, 0.7)
		checkpoint = 8
		inventory.announce_received(216, 1)
		event.set_object_sequence_scale(4, 0.6, 0.6, 0.6)
		checkpoint = 9
		inventory.announce_received(220, 1)
		event.set_object_sequence_scale(4, 0.5, 0.5, 0.5)
		checkpoint = 10
		inventory.announce_received(224, 1)
		event.set_object_sequence_scale(4, 0.4, 0.4, 0.4)
		checkpoint = 11
		inventory.announce_received(235, 1)
		event.set_object_sequence_scale(4, 0.3, 0.3, 0.3)
		checkpoint = 12
		inventory.announce_received(231, 20)
		event.set_object_sequence_motion(3, "会話2")
		event.open_message_window_2(0, "Maintenant, il faut demander au\nCharpention de vous rejoindre.")
		checkpoint = 13
		message.show(0, -1, 2, 256, 416)
		event.set_object_sequence_motion(3, "会話")
		event.open_message_window_2(0, "Pour aller sur la carte du\nG[UNI00e9]orama, appuie sur\n[select]. Allez ! Essaie !")
		checkpoint = 14
		answer = sindain_event.ask_question_with_wait_result(0, -1, 2, 256, 416, answer)
		while answer ~= 1 do
			event.set_object_sequence_motion(3, "会話")
			event.open_message_window_2(0, "Il faut appuyer sur\n[select] !")
			checkpoint = 15
			answer = sindain_event.ask_question_with_wait_result(0, -1, 2, 256, 416, answer)
		end
		event.set_object_sequence_motion(3, "立ち")
		event.fade_out_screen(30)
		checkpoint = 16
		wait.frames(30)
		event.set_camera_sequence_position(80.99, 2.59, -80.49)
		event.set_camera_sequence_look_at(-3.12, 130.83, -201.26)
		event.set_character_active(1, 37)
		event.set_object_sequence_position(5, -236.26, 800.0, -539.2)
		event.set_object_sequence_rotation(5, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(5, "浮遊", 4)
		event.move_object_sequence_eased(5, -236.26, 63.05, -539.2, 150, 2, 1.0)
		event.attach_object_handle_to_character_frame(20, 37, "puropera")
		event.clear_object_sequence(20)
		event.set_object_sequence_object(20, 20)
		event.rotate_object_sequence(20, 0.0, -0.08, 0.0, -1)
		event.fade_in_screen(30)
		checkpoint = 17
		wait.frames(30)
		event.play_sound_effect(sound_bank, 8)
		checkpoint = 18
		wait.frames(30)
		event.move_camera_sequence(80.99, 2.59, -80.49, -3.12, 50.81, -201.26, 150)
		checkpoint = 19
		wait.frames(90)
		event.fade_out_music(30)
		event.fade_out_screen(30)
		checkpoint = 20
		wait.frames(30)
	end, function(received: { any }): boolean
		if checkpoint == 14 then
			answer = received[2] :: number
		end
		if checkpoint == 15 then
			answer = received[2] :: number
		end
		if checkpoint <= 1 then
			assign_gift_scene_slots_for_skip()
			wait.frames_skipping(30)
		end
		if checkpoint <= 2 then
			message.show_and_wait_skipping(0, -1, 2, 256, 416)
		end
		if checkpoint <= 3 then
			message.show_and_wait_skipping(0, -1, 2, 256, 416)
		end
		if checkpoint <= 4 then
			message.show_and_wait_skipping(0, -1, 2, 256, 416)
		end
		if checkpoint <= 5 then
			inventory.resume_obtained_message(210, 28)
		end
		if checkpoint <= 6 then
			inventory.resume_obtained_message(214, 1)
		end
		if checkpoint <= 7 then
			inventory.resume_obtained_message(216, 1)
		end
		if checkpoint <= 8 then
			inventory.resume_obtained_message(220, 1)
		end
		if checkpoint <= 9 then
			inventory.resume_obtained_message(224, 1)
		end
		if checkpoint <= 10 then
			inventory.resume_obtained_message(235, 1)
		end
		if checkpoint <= 11 then
			inventory.resume_obtained_message(231, 20)
		end
		if checkpoint <= 12 then
			message.show_and_wait_skipping(0, -1, 2, 256, 416)
		end
		if checkpoint <= 13 then
			answer = sindain_event.ask_question(0, -1, 2, 256, 416, answer)
		end
		if checkpoint <= 14 then
			answer = sindain_event.ask_question(0, -1, 2, 256, 416, answer)
		end
		if checkpoint <= 15 then
			local _ = answer ~= 1
			wait.frames_skipping(30)
		end
		if checkpoint <= 16 then
			wait.frames_skipping(30)
		end
		if checkpoint <= 17 then
			wait.frames_skipping(30)
		end
		if checkpoint <= 18 then
			wait.frames_skipping(90)
		end
		if checkpoint <= 19 then
			wait.frames_skipping(30)
		end
		return true
	end)
	event.cancel_drama_scene_skip()
	event.stop_sound_effect(sound_bank, 8)
	unload_gift_scene_cast()
	event.finish_event()
	event.stop_music(0)
	event.skip_next_music_load()
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
end

--- Loads Max, Monica and the tree scene's helper character into their slots.
local function load_tree_scene_cast()
	local playable_character: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 0 then
		max_slot = 0
		monica_slot = 32
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", max_slot)
		event.load_character_motion_pack(5, "event/e200/e250/e250_mints.gltf", "info", max_slot)
		event.attach_object_handle_to_character(0, max_slot)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, max_slot)
		event.load_character(5, "chara/c02_base.gltf", "info", monica_slot)
		event.load_equipment_model(5, 1, 4, "info", monica_slot)
		event.load_equipment_model(5, 1, 3, "info", monica_slot)
		event.load_equipment_model(5, 1, 2, "info", monica_slot, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", monica_slot)
		event.load_character_motion_pack(5, "event/e200/e250/e250_monica.gltf", "info", monica_slot)
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
		event.load_character_motion_pack(5, "event/e200/e250/e250_mints.gltf", "info", max_slot)
		event.attach_object_handle_to_character(0, max_slot)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, max_slot)
		event.set_character_active(1, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", monica_slot)
		event.load_character_motion_pack(5, "event/e200/e250/e250_monica.gltf", "info", monica_slot)
		event.attach_object_handle_to_character(1, monica_slot)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, monica_slot)
	end
	event.load_character(5, "event/e200/e250/e250_conda.gltf", "info", 39)
	event.attach_object_handle_to_character(5, 39)
	event.clear_object_sequence(5)
	event.set_object_sequence_object(5, 5)
	event.set_character_active(0, 39)
end

--- Prepares the message mode, map part, characters and message file for the tree-planting scene.
local function prepare_tree_scene()
	event.set_message_window_mode(0, 7)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.attach_object_handle_to_map_part_2(12, "p01_g010701")
	event.clear_object_sequence(12)
	event.set_object_sequence_object(12, 12)
	load_tree_scene_cast()
	event.load_message_file(0, 5, "event/e200/e250/e250_1.txt")
	event.assign_memory_stack(6)
	event.clear_memory_stack(6)
end

--- Restores the party and deletes the tree scene's characters.
local function unload_tree_scene_cast()
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
	sindain_event.delete_villager_characters()
	sindain_event.delete_toryon_characters()
	event.delete_character(39)
end

--- Plays the scene in which the villagers run off, Toryon plants trees and the party descends through the opened entrance.
local function play_tree_planting_scene()
	local map_part_x: f32 = 0
	local map_part_y: f32 = 0
	local map_part_z: f32 = 0
	local map_part_rotation_y: f32 = 0
	local index: s32 = 0
	local sound_bank: s32 = 0
	local tree_x: f32 = 0
	local tree_z: f32 = 0
	local checkpoint: number = 0
	vm.section(function()
		event.set_save_flag(250, 1)
		event.initialize_event()
		event.load_map_sounds(2229)
		sound_bank = event.load_sound_effect_file_2(2229) or sound_bank
		prepare_tree_scene()
		do
			local out1, out2, out3 = event.get_object_handle_position(12)
			map_part_x = out1 or map_part_x
			map_part_y = out2 or map_part_y
			map_part_z = out3 or map_part_z
		end
		do
			local _, out2, _ = event.get_object_handle_rotation(12)
			map_part_rotation_y = out2 or map_part_rotation_y
		end
		event.set_event_world_coordinate(map_part_x, map_part_y, map_part_z, map_part_rotation_y)
		event.set_object_handle_sound_bank(0, sound_bank)
		sindain_event.load_villager_characters()
		event.stop_music(1)
		event.stop_music(0)
		checkpoint = 1
		wait.frames(4)
		event.load_music(193)
		event.start_background_file_loads_4(
			"event/e200/e250/e250_toryon.gltf",
			"event/lm/e250r/e250_tree.gltf",
			"event/e200/e250/e250_konoha.gltf",
			"event/e200/e250/shuchusen.gltf"
		)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.attach_object_handle_to_map_part_2(13, "p01_a1301-4")
		event.set_object_handle_visible(13, 0)
		event.enable_drama_skip()
		event.set_character_active(1, max_slot)
		event.set_character_active(1, monica_slot)
		event.set_character_active(1, 34)
		event.set_character_active(1, 38)
		event.set_character_active(1, 39)
		event.set_character_active(1, 41)
		event.set_character_active(1, 40)
		event.set_character_active(1, 35)
		event.set_character_active(1, 36)
		event.set_camera_sequence_position(113.09, 252.02, 174.44)
		event.set_camera_sequence_look_at(-869.33, -1297.8, -411.75)
		event.fade_in_screen(30)
		event.move_camera_sequence_eased(113.09, 65.59, 174.44, -1546.66, 23.97, -658.2, 230, 2, 0.4)
		event.set_object_sequence_position(0, -14.3, 35.67, 60.81)
		event.set_object_sequence_rotation(0, 0.0, -1.47, 0.0)
		event.set_object_sequence_position(1, -14.3, 35.67, 70.35)
		event.set_object_sequence_rotation(1, 0.0, -1.68, 0.0)
		event.set_object_sequence_position(5, -14.299988, 35.67, 53.670013)
		event.set_object_sequence_rotation(5, 0.0, -1.56, 0.0)
		event.set_object_sequence_position(8, -14.299988, 35.67, 53.670013)
		event.set_object_sequence_rotation(8, 0.0, -1.44, 0.0)
		event.set_object_sequence_position(7, -14.299988, 35.67, 70.350006)
		event.set_object_sequence_rotation(7, 0.0, -1.2, 0.0)
		event.set_object_sequence_position(2, -14.299988, 35.67, 70.350006)
		event.set_object_sequence_rotation(2, 0.0, -1.56, 0.0)
		event.set_object_sequence_position(3, -14.299988, 35.67, 70.350006)
		event.set_object_sequence_rotation(3, 0.0, -1.56, 0.0)
		event.set_object_sequence_position(4, -14.299988, 35.67, 53.670013)
		event.set_object_sequence_rotation(4, 0.0, -1.68, 0.0)
		event.set_object_sequence_position(6, -14.299988, 35.67, 70.350006)
		event.set_object_sequence_rotation(6, 0.0, -1.2, 0.0)
		event.set_object_handle_footstep_sound(0, 3)
		event.set_object_handle_footstep_sound(1, 3)
		event.set_object_sequence_motion(0, "立ち", -1, 4)
		event.delay_object_sequence_motion_track(0, 90)
		event.set_object_sequence_motion(0, "歩き", 4, -1.0, 1)
		event.delay_object_sequence_motion_track(0, 75)
		event.set_object_sequence_motion(0, "立ち", 0)
		event.rotate_object_sequence(0, 0.0, -1.49, 0.0, 165)
		event.delay_object_sequence_position_track(0, 75)
		event.clear_object_sequence_path(0)
		event.set_object_sequence_path_frames(0, 90)
		event.add_object_sequence_path_point(0, -14.3, 35.67, 53.67)
		event.add_object_sequence_path_point(0, -26.37, 35.67, 57.03)
		event.add_object_sequence_path_point(0, -72.16, 14.0, 64.22)
		event.add_object_sequence_path_point(0, -88.64, 14.0, 64.27)
		event.start_object_sequence_path(0)
		event.set_object_sequence_motion(1, "立ち", -1, 4)
		event.delay_object_sequence_motion_track(1, 90)
		event.set_object_sequence_motion(1, "歩き", 4, -1.0, 1)
		event.delay_object_sequence_motion_track(1, 90)
		event.set_object_sequence_motion(1, "立ち", 0)
		event.rotate_object_sequence(1, 0.0, -1.64, 0.0, 180)
		event.delay_object_sequence_position_track(1, 90)
		event.clear_object_sequence_path(1)
		event.set_object_sequence_path_frames(1, 90)
		event.add_object_sequence_path_point(1, -14.3, 35.67, 70.35)
		event.add_object_sequence_path_point(1, -27.29, 35.67, 70.35)
		event.add_object_sequence_path_point(1, -68.45, 15.54, 70.63)
		event.add_object_sequence_path_point(1, -87.24, 14.0, 87.83)
		event.start_object_sequence_path(1)
		index = 0
		while index < 7 do
			event.set_object_sequence_motion(2 + index, "走り", 4)
			event.set_object_handle_footstep_sound(5 + index, 1)
			index = index + 1
		end
		event.clear_object_sequence_path(2)
		event.set_object_sequence_path_frames(2, 15)
		event.add_object_sequence_path_point(2, -14.31, 35.67, 70.35)
		event.add_object_sequence_path_point(2, -28.37, 35.67, 70.35)
		event.add_object_sequence_path_point(2, -70.8, 14.0, 66.4)
		event.add_object_sequence_path_point(2, -99.73, 13.49, 63.63)
		event.add_object_sequence_path_point(2, -115.19, 8.79, 62.15)
		event.add_object_sequence_path_point(2, -136.2, 0.0, 60.14)
		event.start_object_sequence_path(2)
		event.move_object_sequence(2, -1411.86, -0.0, -148.97, 195)
		event.delay_object_sequence_position_track(3, 10)
		event.clear_object_sequence_path(3)
		event.set_object_sequence_path_frames(3, 15)
		event.add_object_sequence_path_point(3, -14.31, 35.67, 70.35)
		event.add_object_sequence_path_point(3, -28.37, 35.67, 70.35)
		event.add_object_sequence_path_point(3, -70.8, 14.0, 66.4)
		event.add_object_sequence_path_point(3, -99.73, 13.49, 63.63)
		event.add_object_sequence_path_point(3, -115.19, 8.79, 62.15)
		event.add_object_sequence_path_point(3, -136.2, 0.0, 60.14)
		event.start_object_sequence_path(3)
		event.move_object_sequence(3, -1411.86, -0.0, -148.97, 195)
		event.delay_object_sequence_position_track(4, 20)
		event.clear_object_sequence_path(4)
		event.set_object_sequence_path_frames(4, 15)
		event.add_object_sequence_path_point(4, -16.96, 35.67, 57.27)
		event.add_object_sequence_path_point(4, -30.65, 35.67, 58.87)
		event.add_object_sequence_path_point(4, -74.26, 14.0, 63.97)
		event.add_object_sequence_path_point(4, -97.55, 14.0, 66.69)
		event.add_object_sequence_path_point(4, -113.48, 8.85, 69.63)
		event.add_object_sequence_path_point(4, -128.87, 1.8, 71.43)
		event.start_object_sequence_path(4)
		event.move_object_sequence(4, -1370.73, -0.0, -123.06, 195)
		event.delay_object_sequence_position_track(6, 30)
		event.clear_object_sequence_path(6)
		event.set_object_sequence_path_frames(6, 15)
		event.add_object_sequence_path_point(6, -15.82, 35.67, 62.54)
		event.add_object_sequence_path_point(6, -29.9, 35.67, 63.43)
		event.add_object_sequence_path_point(6, -68.92, 15.16, 65.92)
		event.add_object_sequence_path_point(6, -95.99, 14.0, 67.64)
		event.add_object_sequence_path_point(6, -112.97, 8.96, 68.73)
		event.add_object_sequence_path_point(6, -133.66, 0.0, 70.05)
		event.start_object_sequence_path(6)
		event.move_object_sequence(6, -1317.43, -0.0, -99.53, 195)
		event.delay_object_sequence_position_track(5, 40)
		event.clear_object_sequence_path(5)
		event.set_object_sequence_path_frames(5, 15)
		event.add_object_sequence_path_point(5, -14.3, 35.67, 53.67)
		event.add_object_sequence_path_point(5, -30.28, 35.67, 53.76)
		event.add_object_sequence_path_point(5, -61.37, 21.67, 59.67)
		event.add_object_sequence_path_point(5, -100.52, 12.96, 59.88)
		event.add_object_sequence_path_point(5, -117.29, 7.96, 59.97)
		event.add_object_sequence_path_point(5, -135.22, 0.0, 60.07)
		event.start_object_sequence_path(5)
		event.move_object_sequence(5, -1333.23, -0.0, -138.83, 195)
		event.delay_object_sequence_position_track(7, 50)
		event.clear_object_sequence_path(7)
		event.set_object_sequence_path_frames(7, 15)
		event.add_object_sequence_path_point(7, -14.3, 35.67, 65.19)
		event.add_object_sequence_path_point(7, -27.94, 35.67, 66.4)
		event.add_object_sequence_path_point(7, -68.78, 15.27, 70.03)
		event.add_object_sequence_path_point(7, -92.62, 14.0, 72.15)
		event.add_object_sequence_path_point(7, -111.92, 9.26, 73.86)
		event.add_object_sequence_path_point(7, -134.81, 0.0, 75.89)
		event.start_object_sequence_path(7)
		event.move_object_sequence(7, -1316.98, -0.0, -190.07, 195)
		event.delay_object_sequence_position_track(8, 60)
		event.clear_object_sequence_path(8)
		event.set_object_sequence_path_frames(8, 15)
		event.add_object_sequence_path_point(8, -14.3, 35.67, 66.92)
		event.add_object_sequence_path_point(8, -28.53, 35.67, 65.18)
		event.add_object_sequence_path_point(8, -75.65, 14.0, 64.98)
		event.add_object_sequence_path_point(8, -99.2, 14.0, 70.35)
		event.add_object_sequence_path_point(8, -120.92, 5.79, 62.69)
		event.add_object_sequence_path_point(8, -133.21, 0.0, 60.52)
		event.start_object_sequence_path(8)
		event.move_object_sequence(8, -1299.13, -0.0, -155.72, 195)
		event.delay_object_sequence_motion_track(3, 210)
		event.set_object_sequence_motion(3, "ふみきり", 6)
		event.queue_object_sequence_next_motion(3, "空中", 0)
		event.delay_object_sequence_motion_track(4, 220)
		event.set_object_sequence_motion(4, "ふみきり", 6)
		event.queue_object_sequence_next_motion(4, "空中", 0)
		event.delay_object_sequence_motion_track(6, 230)
		event.set_object_sequence_motion(6, "ふみきり", 6)
		event.queue_object_sequence_next_motion(6, "空中", 0)
		event.delay_object_sequence_motion_track(5, 240)
		event.set_object_sequence_motion(5, "ふみきり", 6)
		event.queue_object_sequence_next_motion(5, "空中", 0)
		event.delay_object_sequence_motion_track(8, 250)
		event.set_object_sequence_motion(8, "ふみきり", 6)
		event.queue_object_sequence_next_motion(8, "空中", 0)
		event.delay_object_sequence_motion_track(7, 260)
		event.set_object_sequence_motion(7, "ふみきり", 6)
		event.queue_object_sequence_next_motion(7, "空中", 0)
		event.delay_object_sequence_motion_track(2, 270)
		event.set_object_sequence_motion(2, "ふみきり", 6)
		event.queue_object_sequence_next_motion(2, "空中", 0)
		event.jump_object_sequence(5, -1998.62, -0.0, -102.27, -0.25, 60)
		event.delay_object_sequence_position_track(8, 0)
		event.jump_object_sequence(8, -1953.56, -0.0, -154.54, -0.25, 60)
		event.delay_object_sequence_position_track(7, 0)
		event.jump_object_sequence(7, -1920.26, -0.0, -167.95, -0.25, 60)
		event.delay_object_sequence_position_track(2, 0)
		event.jump_object_sequence(2, -1980.06, -0.86, -200.42, -0.25, 60)
		event.delay_object_sequence_position_track(3, 0)
		event.jump_object_sequence(3, -1901.42, -0.0, -212.85, -0.25, 60)
		event.delay_object_sequence_position_track(4, 0)
		event.jump_object_sequence(4, -1909.43, -0.0, -100.82, -0.25, 60)
		event.delay_object_sequence_position_track(6, 0)
		event.jump_object_sequence(6, -1963.98, -0.0, -28.93, -0.25, 60)
		checkpoint = 2
		wait.frames(75)
		event.play_sound_effect(sound_bank, 14)
		checkpoint = 3
		wait.frames(255)
		sindain_event.delete_villager_characters()
		checkpoint = 4
		vm.wait(4)
		event.clear_memory_stack(6)
		checkpoint = 5
		wait.background_load()
		sindain_event.load_toryon_with_sound_bank(sound_bank)
		checkpoint = 6
		vm.wait(6)
		event.set_character_active(1, max_slot)
		event.set_character_active(1, monica_slot)
		event.set_camera_sequence_position(-130.74, 32.47, 120.8)
		event.set_camera_sequence_look_at(-102.69, 36.9, 82.53)
		event.reset_object_sequence_dynamic_animation(1)
		event.set_mouth_texture_animations(1, "通常口パク")
		checkpoint = 7
		message.show_voiced(2500180)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(0, "首をかしげる", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		checkpoint = 8
		wait.frames(5)
		event.set_mouth_texture_animations(0, "通常口パク")
		checkpoint = 9
		message.show_voiced(2500190)
		event.reset_mouth_texture_animations()
		checkpoint = 10
		object.wait_until_done(0)
		event.play_sound_effect(sound_bank, 15)
		checkpoint = 11
		wait.frames(3)
		event.set_mouth_texture_animations(1, "通常口パク")
		checkpoint = 12
		message.show_voiced(2500200)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(0, "指さす", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(0, "指さすL", 0)
		event.set_mouth_texture_animations(0, "通常口パク")
		checkpoint = 13
		message.show_voiced(2500210)
		event.reset_mouth_texture_animations()
		checkpoint = 14
		object.wait_until_done(0)
		event.play_music(1)
		event.set_character_active(1, 42)
		event.set_character_active(1, 46)
		event.set_character_position(46, map_part_x - vm.f32(1780.39), map_part_y + vm.f32(773.93), map_part_z + vm.f32(82.37))
		event.set_character_rotation(46, 0.0, map_part_rotation_y + vm.f32(0.36), 0.0)
		event.reset_object_sequence_motion(14)
		event.delay_object_sequence_motion_track(14, 30)
		event.set_object_sequence_motion(14, "木の葉散る", 6)
		event.attach_object_handle_to_character_frame(20, 42, "puropera")
		event.clear_object_sequence(20)
		event.set_object_sequence_object(20, 20)
		event.rotate_object_sequence(20, 0.0, -0.08, 0.0, -1)
		event.set_camera_sequence_position(-1120.67, 799.61, 245.65)
		event.set_camera_sequence_look_at(-1205.48, 813.47, 219.34)
		event.set_object_sequence_position(9, -1983.37, 365.71, 26.93)
		event.set_object_sequence_rotation(9, 0.0, 1.85, 0.0)
		event.play_sound_effect(sound_bank, 16)
		event.move_object_sequence_eased(9, -1983.37, 942.49, 26.93, 60, 0, 0.4)
		checkpoint = 15
		object.wait_until_done(9)
		checkpoint = 16
		wait.frames(80)
		event.set_character_active(0, 46)
		event.move_camera_sequence_eased(206.33, 67.63, 392.02, 17.65, 209.62, 96.0, 120, 0, 0.4)
		event.move_object_sequence_eased(9, -203.42, 128.16, -69.67, 120, 0, 0.4)
		event.rotate_object_sequence_eased(9, 0.0, 1.13, 0.0, 120, 0, 0.4)
		checkpoint = 17
		camera.wait_until_done()
		event.set_character_active(0, 42)
		event.set_camera_sequence_position(-256.13, 70.1, 44.86)
		event.set_camera_sequence_look_at(-237.13, 29.77, 17.22)
		event.set_object_sequence_position(0, -241.0, 0.0, 2.23)
		event.set_object_sequence_rotation(0, 0.0, -0.41, 0.0)
		event.set_object_sequence_position(1, -215.63, 0.0, 10.45)
		event.set_object_sequence_rotation(1, 0.0, -0.68, 0.0)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "うれし顔")
		event.set_object_sequence_texture_animation(0, 1, "目キラキラ")
		event.set_object_sequence_motion(0, "上見立ち", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "上向くL", 4, -1.0, 1)
		event.set_mouth_texture_animations(1, "通常口パク")
		checkpoint = 18
		message.show_voiced_for(2500220, 90)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(0, "うれし口～大口")
		checkpoint = 19
		message.show_voiced_for(2500230, 60)
		event.reset_mouth_texture_animations()
		event.set_character_active(1, 42)
		event.set_character_active(1, 43)
		event.set_character_active(1, 44)
		event.set_camera_sequence_position(-147.0, 30.77, -328.58)
		event.set_camera_sequence_look_at(-178.12, 65.41, -171.95)
		event.set_object_sequence_position(0, -249.75, 0.0, 7.65)
		event.set_object_sequence_rotation(0, 0.0, -0.41, 0.0)
		event.set_object_sequence_position(1, -193.44, 0.0, 6.3)
		event.set_object_sequence_rotation(1, 0.0, -0.68, 0.0)
		event.set_object_sequence_position(9, -335.13, 0.0, 295.03)
		event.set_object_sequence_rotation(9, 0.0, 2.81, 0.0)
		event.set_character_rotation(43, 0.0, 3.1415927, 0.0)
		event.set_character_rotation(44, 0.0, 3.1415927, 0.0)
		event.set_object_sequence_motion(9, "木持ち浮遊", 4)
		checkpoint = 20
		wait.frames(30)
		event.set_object_sequence_motion(9, "右の木を植える", 6)
		event.queue_object_sequence_next_motion(9, "右の木を植えるL", 4)
		checkpoint = 21
		wait.frames(8)
		event.set_object_sequence_motion(0, "右へよける", 6)
		event.set_object_sequence_motion(1, "上向きから驚き", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(1, "上向きから驚きＬ", 0)
		checkpoint = 22
		wait.frames(10)
		event.shake_camera_sequence(0.0, 4.0, 0.0, 20)
		checkpoint = 23
		wait.frames(5)
		do
			local out1, _, out3 = event.get_object_handle_frame_position(9, "R_tree")
			tree_x = out1 or tree_x
			tree_z = out3 or tree_z
		end
		event.detach_character_from_frame(43)
		event.set_object_sequence_position(10, tree_x, 0.0, tree_z)
		event.set_object_sequence_motion(10, "ぷるん", 6)
		checkpoint = 24
		object.wait_until_done(10)
		checkpoint = 25
		message.show_voiced_for(2500235, -1)
		checkpoint = 26
		object.wait_until_done(9)
		event.set_character_active(0, 43)
		event.set_character_active(1, 45)
		event.set_object_sequence_position(13, 1200.0, -300.0, 12000.0)
		event.set_camera_sequence_position(-260.7, 41.9, 24.51)
		event.set_camera_sequence_look_at(-254.62, 30.24, 15.15)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "おこり顔")
		event.set_object_sequence_texture_animation(0, 1, "おこり目パチ")
		event.set_object_sequence_motion(0, "前を見る", 6, 0.6)
		event.queue_object_sequence_next_motion(0, "前を見るL", 4)
		event.delay_object_sequence_position_track(13, 15)
		event.delay_object_sequence_motion_track(13, 15)
		event.set_object_sequence_position(13, -235.28, -5.32, -11.39)
		event.set_object_sequence_rotation(13, 0.0, 0.12, 0.0)
		event.set_object_sequence_motion(13, "回転", 4)
		event.set_mouth_texture_animations(0, "大口パク")
		checkpoint = 27
		message.show_voiced_for(2500240, 25)
		event.reset_mouth_texture_animations()
		event.set_character_active(1, 43)
		event.set_character_active(1, 44)
		event.set_character_active(0, 45)
		event.set_camera_sequence_position(-147.0, 30.77, -328.58)
		event.set_camera_sequence_look_at(-178.12, 65.41, -171.95)
		event.set_object_sequence_position(0, -310.86, 0.0, -37.43)
		event.set_object_sequence_rotation(0, 0.0, -0.41, 0.0)
		event.set_object_sequence_position(9, -407.63, 0.0, 280.62)
		event.set_object_sequence_rotation(9, 0.0, 2.81, 0.0)
		event.set_object_sequence_motion(9, "左の木を植える", 6)
		event.queue_object_sequence_next_motion(9, "左の木を植えるL", 4)
		checkpoint = 28
		wait.frames(8)
		event.set_object_sequence_motion(0, "左へよける", 6)
		checkpoint = 29
		wait.frames(10)
		event.shake_camera_sequence(0.0, 4.0, 0.0, 20)
		checkpoint = 30
		wait.frames(5)
		do
			local out1, _, out3 = event.get_object_handle_frame_position(9, "L_tree")
			tree_x = out1 or tree_x
			tree_z = out3 or tree_z
		end
		event.detach_character_from_frame(44)
		event.set_object_sequence_position(11, tree_x, 0.0, tree_z)
		event.set_object_sequence_motion(11, "ぷるん", 6)
		checkpoint = 31
		object.wait_until_done(9)
		checkpoint = 32
		wait.frames(30)
		event.set_character_active(1, monica_slot)
		event.set_character_active(0, 42)
		event.set_camera_sequence_position(-315.45, 23.19, 14.98)
		event.set_camera_sequence_look_at(-271.54, 21.8, 7.43)
		event.set_object_sequence_position(0, -276.1, 0.0, -7.52)
		event.set_object_sequence_rotation(0, 0.0, -0.41, 0.0)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(0, 1, "うれし半口")
		event.set_object_sequence_motion(0, "よけたあと", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "上向きから驚きＬ", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		checkpoint = 33
		message.show_voiced(2500250)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_texture_animation(0, 1, "目キラキラ")
		event.set_object_sequence_motion(0, "すごいよ", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(0, "すごいよL", 4)
		event.set_mouth_texture_animations(0, "わらい口パク")
		checkpoint = 34
		message.show_voiced(2500260)
		event.reset_mouth_texture_animations()
		event.set_character_active(1, 42)
		event.set_character_active(0, 43)
		event.set_character_active(0, 44)
		event.set_camera_sequence_position(-366.92, 245.56, -135.81)
		event.set_camera_sequence_look_at(-333.13, 279.7, -11.5)
		event.set_object_sequence_position(0, -183.8, 0.0, 277.38)
		event.set_object_sequence_rotation(0, 0.0, -0.6, 0.0)
		event.set_object_sequence_position(1, -161.6, 0.0, 288.11)
		event.set_object_sequence_rotation(1, 0.0, -0.72, 0.0)
		event.set_object_sequence_position(9, -306.32, 272.97, 403.99)
		event.set_object_sequence_rotation(9, 0.0, 3.14, 0.0)
		event.play_sound_effect(sound_bank, 19)
		event.set_object_sequence_motion(0, "上向くL", 4)
		event.set_object_sequence_motion(1, "上向くL", 4)
		event.set_object_sequence_motion(5, "立ち", 4)
		event.set_object_sequence_motion(9, "浮遊", 4)
		event.move_camera_sequence_eased(-366.92, 245.56, -135.81, -333.13, 217.63, -11.5, 60, 2, 0.2)
		event.move_object_sequence_eased(9, -306.32, 83.84, 403.99, 60, 2, 0.2)
		checkpoint = 35
		wait.frames(72)
		event.set_character_active(1, 39)
		event.set_object_handle_shadow_enabled(0, 0)
		event.set_object_handle_shadow_enabled(1, 0)
		event.set_object_handle_shadow_enabled(5, 0)
		event.set_object_sequence_position(5, -314.51, 136.42, 395.63)
		event.set_object_sequence_rotation(5, 0.0, 3.04, 0.0)
		event.fade_out_music(60)
		event.set_object_sequence_motion(9, "浮遊", 2)
		event.wait_object_sequence_motion_end(9)
		checkpoint = 36
		object.wait_until_done(9)
		event.play_sound_effect(sound_bank, 20)
		event.set_object_sequence_motion(9, "入り口開く", 6)
		event.queue_object_sequence_next_motion(9, "入り口開くL", 4)
		event.move_object_sequence(5, -314.51, 12.03, 395.63, 66)
		checkpoint = 37
		wait.frames(67)
		event.set_camera_sequence_position(-272.42, 14.88, 304.99)
		event.set_camera_sequence_look_at(-302.58, 33.94, 399.83)
		event.set_object_sequence_position(0, -281.71, 0.0, 363.1)
		event.set_object_sequence_rotation(0, 0.0, -0.84, 0.0)
		event.set_object_sequence_position(1, -268.51, 0.0, 369.08)
		event.set_object_sequence_rotation(1, 0.0, -1.2, 0.0)
		event.set_object_sequence_position(5, -315.44, 12.03, 391.74)
		event.set_object_sequence_rotation(5, 0.0, 2.32, 0.0)
		event.set_object_handle_footstep_sound(0, 1)
		event.set_object_handle_footstep_sound(1, 1)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_motion(0, "上向くL", 4)
		event.set_object_sequence_motion(1, "上向くL", 4, -1.0, 1)
		event.set_object_sequence_motion(5, "会話", 6)
		event.queue_object_sequence_next_motion(5, "立ち", 0)
		checkpoint = 38
		message.show_voiced(2500270)
		event.set_object_sequence_motion(0, "上→すごいよ", 6)
		event.queue_object_sequence_next_motion(0, "すごいよL", 0)
		event.set_mouth_texture_animations(0, "わらい口パク")
		checkpoint = 39
		message.show_voiced(2500280)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(0, "すごいよ戻り", 6)
		event.queue_object_sequence_next_motion(0, "上向くL", 4)
		event.set_object_sequence_motion(5, "会話2", 6)
		event.queue_object_sequence_next_motion(5, "立ち", 0)
		checkpoint = 40
		message.show_voiced(2500290)
		event.set_object_sequence_motion(0, "上向く戻り", 6)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		event.set_object_sequence_motion(1, "上向く戻り", 6)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		checkpoint = 41
		object.wait_until_done(0)
		checkpoint = 42
		wait.frames(3)
		event.set_object_sequence_motion(0, "歩き", 0)
		event.set_object_sequence_motion(1, "歩き", 0)
		event.rotate_object_sequence(0, 0.0, 0.12, 0.0, 6)
		event.rotate_object_sequence(1, 0.0, -0.24, 0.0, 6)
		checkpoint = 43
		wait.frames(6)
		event.set_object_sequence_motion(0, "走り", 4)
		event.set_object_sequence_motion(1, "走り", 4)
		event.clear_object_sequence_path(0)
		event.set_object_sequence_path_frames(0, 45)
		event.add_object_sequence_path_point(0, -285.87, 0.0, 357.41)
		event.add_object_sequence_path_point(0, -257.04, 0.0, 389.98)
		event.add_object_sequence_path_point(0, -274.42, 0.0, 429.26)
		event.start_object_sequence_path(0)
		event.clear_object_sequence_path(1)
		event.set_object_sequence_path_frames(1, 45)
		event.add_object_sequence_path_point(1, -266.64, 0.0, 363.55)
		event.add_object_sequence_path_point(1, -264.8, 0.0, 426.42)
		event.add_object_sequence_path_point(1, -300.44, 0.0, 458.67)
		event.start_object_sequence_path(1)
		checkpoint = 44
		wait.frames(30)
		event.clear_object_sequence_path(0)
		event.clear_object_sequence_path(1)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_camera_sequence_position(-312.83, 198.18, 285.67)
		event.set_camera_sequence_look_at(-304.45, 164.0, 318.5)
		event.set_object_sequence_position(0, -294.8, 16.560001, 393.65)
		event.set_object_sequence_rotation(0, 0.0, 2.44, 0.0)
		event.set_object_sequence_position(1, -289.64, 16.560001, 408.11)
		event.set_object_sequence_rotation(1, 0.0, 2.35, 0.0)
		event.set_object_sequence_position(5, -310.53, 16.560001, 383.79)
		event.set_object_sequence_rotation(5, 0.0, 2.68, 0.0)
		event.set_object_sequence_motion(0, "立ち", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "立ち", 4, -1.0, 1)
		checkpoint = 45
		wait.frames(30)
		event.play_sound_effect(sound_bank, 21)
		event.set_object_sequence_motion(9, "閉まる", 6, -1.0, 1)
		event.move_object_sequence(0, -294.8, 150.42, 393.65, 68)
		event.move_object_sequence(1, -289.64, 150.42, 408.11, 68)
		event.move_object_sequence(5, -310.53, 150.42, 383.79, 68)
		checkpoint = 46
		wait.frames(38)
		event.fade_out_screen(30)
		checkpoint = 47
		wait.frames(30)
	end, function(received: { any }): boolean
		if checkpoint <= 1 then
			index = 0
			local _ = index < 7
			index = index + 1
			wait.frames_skipping(75)
		end
		if checkpoint <= 2 then
			wait.frames_skipping(255)
		end
		if checkpoint <= 3 then
			cutscene.noop()
		end
		if checkpoint <= 4 then
			wait.background_load_skipping()
		end
		if checkpoint <= 5 then
			sindain_event.pass_sound_bank(sound_bank)
		end
		if checkpoint <= 6 then
			message.show_voiced_skipping(2500180)
		end
		if checkpoint <= 7 then
			wait.frames_skipping(5)
		end
		if checkpoint <= 8 then
			message.show_voiced_skipping(2500190)
		end
		if checkpoint <= 9 then
			cutscene.skip_command(0)
		end
		if checkpoint <= 10 then
			wait.frames_skipping(3)
		end
		if checkpoint <= 11 then
			message.show_voiced_skipping(2500200)
		end
		if checkpoint <= 12 then
			message.show_voiced_skipping(2500210)
		end
		if checkpoint <= 13 then
			cutscene.skip_command(0)
		end
		if checkpoint <= 14 then
			cutscene.skip_command(9)
		end
		if checkpoint <= 15 then
			wait.frames_skipping(80)
		end
		if checkpoint <= 16 then
			wait.background_load_skipping()
		end
		if checkpoint <= 17 then
			message.show_voiced_for_skipping(2500220, 90)
		end
		if checkpoint <= 18 then
			message.show_voiced_for_skipping(2500230, 60)
		end
		if checkpoint <= 19 then
			wait.frames_skipping(30)
		end
		if checkpoint <= 20 then
			wait.frames_skipping(8)
		end
		if checkpoint <= 21 then
			wait.frames_skipping(10)
		end
		if checkpoint <= 22 then
			wait.frames_skipping(5)
		end
		if checkpoint <= 23 then
			cutscene.skip_command(10)
		end
		if checkpoint <= 24 then
			message.show_voiced_for_skipping(2500235, -1)
		end
		if checkpoint <= 25 then
			cutscene.skip_command(9)
		end
		if checkpoint <= 26 then
			message.show_voiced_for_skipping(2500240, 25)
		end
		if checkpoint <= 27 then
			wait.frames_skipping(8)
		end
		if checkpoint <= 28 then
			wait.frames_skipping(10)
		end
		if checkpoint <= 29 then
			wait.frames_skipping(5)
		end
		if checkpoint <= 30 then
			cutscene.skip_command(9)
		end
		if checkpoint <= 31 then
			wait.frames_skipping(30)
		end
		if checkpoint <= 32 then
			message.show_voiced_skipping(2500250)
		end
		if checkpoint <= 33 then
			message.show_voiced_skipping(2500260)
		end
		if checkpoint <= 34 then
			wait.frames_skipping(72)
		end
		if checkpoint <= 35 then
			cutscene.skip_command(9)
		end
		if checkpoint <= 36 then
			wait.frames_skipping(67)
		end
		if checkpoint <= 37 then
			message.show_voiced_skipping(2500270)
		end
		if checkpoint <= 38 then
			message.show_voiced_skipping(2500280)
		end
		if checkpoint <= 39 then
			message.show_voiced_skipping(2500290)
		end
		if checkpoint <= 40 then
			cutscene.skip_command(0)
		end
		if checkpoint <= 41 then
			wait.frames_skipping(3)
		end
		if checkpoint <= 42 then
			wait.frames_skipping(6)
		end
		if checkpoint <= 43 then
			wait.frames_skipping(30)
		end
		if checkpoint <= 44 then
			wait.frames_skipping(30)
		end
		if checkpoint <= 45 then
			wait.frames_skipping(38)
		end
		if checkpoint <= 46 then
			wait.frames_skipping(30)
		end
		return true
	end)
	checkpoint = 48
	vm.entry(48)
	event.cancel_drama_scene_skip()
	event.stop_music(1)
	event.stop_music(0)
	event.stop_sound_effect(sound_bank, 15)
	event.set_object_handle_shadow_enabled(0, 1)
	event.set_object_handle_shadow_enabled(1, 1)
	event.set_object_handle_shadow_enabled(5, 1)
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_footstep_sound(1, 0)
	index = 0
	while index < 7 do
		event.set_object_sequence_motion(2 + index, "走り", 4)
		event.set_object_handle_footstep_sound(5 + index, 0)
		index = index + 1
	end
	unload_tree_scene_cast()
	event.set_object_handle_visible(13, 1)
	event.initialize_event()
end

--- Loads Max, Monica, the still image sprite and the message file for the Atla conversation scene.
local function load_atla_scene_cast()
	local playable_character: s32 = 0
	local block: s32 = 0
	event.set_message_window_mode(0, 7)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 0 then
		max_slot = 0
		monica_slot = 32
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", max_slot)
		event.load_character_motion_pack(5, "event/e200/e250/e250_mints.gltf", "info", max_slot)
		event.attach_object_handle_to_character(0, max_slot)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, max_slot)
		event.load_character(5, "chara/c02_base.gltf", "info", monica_slot)
		event.load_equipment_model(5, 1, 4, "info", monica_slot)
		event.load_equipment_model(5, 1, 3, "info", monica_slot)
		event.load_equipment_model(5, 1, 2, "info", monica_slot, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", monica_slot)
		event.load_character_motion_pack(5, "event/e200/e250/e250_monica.gltf", "info", monica_slot)
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
		event.load_character_motion_pack(5, "event/e200/e250/e250_mints.gltf", "info", max_slot)
		event.attach_object_handle_to_character(0, max_slot)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, max_slot)
		event.set_character_active(1, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", monica_slot)
		event.load_character_motion_pack(5, "event/e200/e250/e250_monica.gltf", "info", monica_slot)
		event.attach_object_handle_to_character(1, monica_slot)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, monica_slot)
	end
	block = event.load_event_image_4(5, "textures/event/e200/e250/e250_2d.json", 0) or block
	event.reset_event_sprite(0)
	event.set_event_sprite_type(0, 0)
	event.set_event_sprite_texture(0, "e250_cut25", block)
	event.set_event_sprite_color(0, 128, 128, 128, 0)
	event.set_event_sprite_texture_rect(0, 0, 0, 512, 448)
	event.set_event_sprite_size(0, 512, 448)
	event.set_event_sprite_position(0, 256, 208)
	event.set_event_sprite_draw_pass(0, 0)
	event.attach_object_handle_to_sprite(2, 0)
	event.clear_object_sequence(2)
	event.set_object_sequence_object(2, 2)
	event.load_message_file(0, 5, "event/e200/e250/e250_1.txt")
end

--- Sets the Max and Monica slot variables to the values used when Monica is the playable character.
local function assign_atla_scene_slots_for_skip()
	max_slot = 0
	monica_slot = 32
	max_slot = 32
	monica_slot = 0
end

--- Restores the party and removes the Atla scene's still image.
local function unload_atla_scene_cast()
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
	event.set_event_sprite_draw_pass(0, 0)
	event.delete_event_image(0)
end

--- Plays the conversation in which Atla is held up and discussed, with a still image shown part way through.
local function play_atla_conversation_scene()
	local sound_bank: s32 = 0
	local character_x: f32 = 0
	local character_y: f32 = 0
	local character_z: f32 = 0
	local checkpoint: number = 0
	vm.section(function()
		event.fade_out_screen(0)
		checkpoint = 1
		vm.wait(1)
		event.set_save_flag(250, 1)
		event.initialize_event()
		sound_bank = event.load_sound_effect_file_2(2234) or sound_bank
		load_atla_scene_cast()
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		event.set_character_active(1, 120)
		event.set_character_active(1, 121)
		event.enable_drama_skip()
		event.play_sound_effect(sound_bank, 22)
		event.set_character_active(1, max_slot)
		event.set_character_active(1, monica_slot)
		do
			local out1, out2, out3 = event.get_character_position(0)
			character_x = out1 or character_x
			character_y = out2 or character_y
			character_z = out3 or character_z
		end
		event.set_character_position(max_slot, character_x, character_y, character_z)
		event.set_character_position(monica_slot, character_x, character_y, character_z)
		event.fade_in_screen(30)
		event.set_camera_sequence_position(-772.48, 31.27, -965.22)
		event.set_camera_sequence_look_at(-701.0, 38.37, -1042.75)
		event.set_object_sequence_position(0, -647.25, -0.0, -1047.89)
		event.set_object_sequence_rotation(0, 0.0, -2.11, 0.0)
		event.set_object_sequence_position(1, -654.69, -0.0, -1072.52)
		event.set_object_sequence_rotation(1, 0.0, -1.2, 0.0)
		checkpoint = 2
		vm.wait(2)
		event.fade_in_screen(30)
		event.set_mouth_texture_animations(1, "わらい口パク")
		checkpoint = 3
		message.show_voiced(2500500)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(0, "通常口パク")
		checkpoint = 4
		message.show_voiced(2500510)
		event.reset_mouth_texture_animations()
		event.set_character_active(0, monica_slot)
		event.set_camera_sequence_position(-701.14, 38.12, -985.84)
		event.set_camera_sequence_look_at(-699.63, 28.19, -1037.85)
		event.move_camera_sequence_eased(-701.14, 38.12, -985.84, -699.63, 51.5, -1037.85, 90, 2, 0.4)
		event.set_mouth_texture_animations(1, "わらい口パク")
		checkpoint = 5
		message.show_voiced(2500520)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(1, "わらい口パク")
		checkpoint = 6
		message.show_voiced(2500525)
		event.reset_mouth_texture_animations()
		checkpoint = 7
		object.wait_until_done(1)
		checkpoint = 8
		camera.wait_until_done()
		event.set_character_active(1, monica_slot)
		event.set_character_active(0, 120)
		event.set_character_active(0, 121)
		event.set_camera_sequence_position(-697.66, 20.36, -1062.26)
		event.set_camera_sequence_look_at(-643.59, 17.44, -1071.09)
		event.set_object_sequence_position(0, -639.63, -0.0, -1057.59)
		event.set_object_sequence_rotation(0, 0.0, -1.75, 0.0)
		event.set_object_sequence_position(1, -646.9, -0.0, -1083.44)
		event.set_object_sequence_rotation(1, 0.0, -0.84, 0.0)
		event.set_object_sequence_motion(1, "左向くL", 4, -1.0, 1)
		event.set_character_cloth_animation_enabled(max_slot, 0)
		event.set_object_sequence_motion(0, "アトラを持つ", 6)
		event.queue_object_sequence_next_motion(0, "アトラを持つL", 0)
		event.set_mouth_texture_animations(0, "通常口パク")
		checkpoint = 9
		message.show_voiced(2500530)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(1, "左向く会話", 6)
		event.queue_object_sequence_next_motion(1, "左向くL", 0)
		event.set_mouth_texture_animations(1, "わらい口パク")
		checkpoint = 10
		message.show_voiced(2500540)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(1, "わらい口パク")
		checkpoint = 11
		message.show_voiced(2500545)
		event.reset_mouth_texture_animations()
		event.set_event_sprite_draw_pass(0, 1)
		event.set_object_sequence_color(2, 128.0, 128.0, 128.0, 128.0, 10)
		checkpoint = 12
		message.show_voiced(2500550)
		checkpoint = 13
		message.show_voiced(2500555)
		checkpoint = 14
		message.show_voiced(2500560)
		event.set_event_sprite_draw_pass(0, 0)
		event.set_character_active(1, 120)
		event.set_character_active(1, 121)
		event.set_character_cloth_animation_enabled(max_slot, 1)
		event.set_camera_sequence_position(-799.13, 98.14, -1023.59)
		event.set_camera_sequence_look_at(-641.21, 13.62, -1089.99)
		event.set_object_sequence_position(0, -647.09, -0.0, -1050.31)
		event.set_object_sequence_rotation(0, 0.0, -1.75, 0.0)
		event.set_object_sequence_position(1, -643.59, -0.0, -1073.29)
		event.set_object_sequence_rotation(1, 0.0, -1.56, 0.0)
		event.set_object_sequence_motion(0, "上向くL", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "上向くL", 4, -1.0, 1)
		event.set_mouth_texture_animations(1, "わらい口パク")
		checkpoint = 15
		message.show_voiced(2500570)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(0, "上→右見", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(0, "右向くL", 4)
		event.set_mouth_texture_animations(0, "通常口パク")
		checkpoint = 16
		message.show_voiced(2500580)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(0, "通常口パク")
		checkpoint = 17
		message.show_voiced(2500585)
		event.reset_mouth_texture_animations()
		event.set_character_active(0, 120)
		event.set_character_active(0, 121)
		event.set_character_active(0, max_slot)
		event.set_camera_sequence_position(-675.55, 30.55, -1072.9)
		event.set_camera_sequence_look_at(-648.05, 22.05, -1072.56)
		event.play_sound_effect(sound_bank, 23)
		event.set_object_sequence_motion(1, "アトラ見る", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(1, "アトラ見るL", 0)
		checkpoint = 18
		wait.frames(27)
		event.set_mouth_texture_animations(1, "通常口パク")
		checkpoint = 19
		message.show_voiced(2500590)
		event.reset_mouth_texture_animations()
		event.set_mouth_texture_animations(1, "通常口パク")
		checkpoint = 20
		message.show_voiced(2500595)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(1, "アトラ見から立ちに", 2)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		checkpoint = 21
		message.show_voiced(2500600)
		event.set_character_active(1, max_slot)
		event.set_character_active(0, monica_slot)
		event.set_camera_sequence_position(-675.37, 33.53, -1088.87)
		event.set_camera_sequence_look_at(-659.31, 20.57, -1054.58)
		event.set_object_sequence_position(0, -661.43, -0.0, -1055.96)
		event.set_object_sequence_rotation(0, 0.0, 3.04, 0.0)
		event.set_object_sequence_motion(0, "モニカ見立ち", 4)
		checkpoint = 22
		message.show_voiced(2500610)
		event.set_character_active(1, 120)
		event.set_character_active(1, 121)
		event.set_character_active(1, monica_slot)
		event.set_camera_sequence_position(-757.19, 37.47, -1029.97)
		event.set_camera_sequence_look_at(-663.0, 20.57, -1070.18)
		event.set_object_sequence_position(0, -642.21, -0.0, -1050.46)
		event.set_object_sequence_rotation(0, 0.0, -2.04, 0.0)
		event.set_object_sequence_position(1, -653.99, -0.0, -1067.84)
		event.set_object_sequence_rotation(1, 0.0, -0.36, 0.0)
		event.set_object_sequence_motion(1, "右回り180度回転ＰＧ", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.rotate_object_sequence(1, 0.0, -2.28, 0.0, 30)
		checkpoint = 23
		message.show_voiced(2500620)
		checkpoint = 24
		message.show_voiced(2500630)
		event.set_character_cloth_animation_enabled(max_slot, 0)
		event.play_sound_effect(sound_bank, 24)
		event.set_object_sequence_motion(0, "アトラを持つ", 6)
		event.queue_object_sequence_next_motion(0, "アトラを持つL", 0)
		checkpoint = 25
		message.show_voiced(2500640)
		checkpoint = 26
		object.wait_until_done(0)
		checkpoint = 27
		wait.frames(30)
		event.set_object_sequence_motion(1, "右回り180度回転ＰＧ", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.rotate_object_sequence(1, 0.0, 0.24, 0.0, 30)
		checkpoint = 28
		wait.frames(30)
		checkpoint = 29
		message.show_voiced(2500650)
		checkpoint = 30
		message.show_voiced(2500655)
		event.set_object_sequence_motion(1, "アトラを持つ戻り", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		checkpoint = 31
		wait.frames(15)
		event.play_sound_effect(sound_bank, 25)
		event.set_object_sequence_motion(0, "うなづく", 6, -1.0, 1)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		checkpoint = 32
		message.show_voiced(2500660)
		event.fade_out_screen(30)
		checkpoint = 33
		wait.frames(30)
	end, function(received: { any }): boolean
		if checkpoint <= 1 then
			assign_atla_scene_slots_for_skip()
		end
		if checkpoint <= 2 then
			message.show_voiced_skipping(2500500)
		end
		if checkpoint <= 3 then
			message.show_voiced_skipping(2500510)
		end
		if checkpoint <= 4 then
			message.show_voiced_skipping(2500520)
		end
		if checkpoint <= 5 then
			message.show_voiced_skipping(2500525)
		end
		if checkpoint <= 6 then
			cutscene.skip_command(1)
		end
		if checkpoint <= 7 then
			wait.background_load_skipping()
		end
		if checkpoint <= 8 then
			message.show_voiced_skipping(2500530)
		end
		if checkpoint <= 9 then
			message.show_voiced_skipping(2500540)
		end
		if checkpoint <= 10 then
			message.show_voiced_skipping(2500545)
		end
		if checkpoint <= 11 then
			message.show_voiced_skipping(2500550)
		end
		if checkpoint <= 12 then
			message.show_voiced_skipping(2500555)
		end
		if checkpoint <= 13 then
			message.show_voiced_skipping(2500560)
		end
		if checkpoint <= 14 then
			message.show_voiced_skipping(2500570)
		end
		if checkpoint <= 15 then
			message.show_voiced_skipping(2500580)
		end
		if checkpoint <= 16 then
			message.show_voiced_skipping(2500585)
		end
		if checkpoint <= 17 then
			wait.frames_skipping(27)
		end
		if checkpoint <= 18 then
			message.show_voiced_skipping(2500590)
		end
		if checkpoint <= 19 then
			message.show_voiced_skipping(2500595)
		end
		if checkpoint <= 20 then
			message.show_voiced_skipping(2500600)
		end
		if checkpoint <= 21 then
			message.show_voiced_skipping(2500610)
		end
		if checkpoint <= 22 then
			message.show_voiced_skipping(2500620)
		end
		if checkpoint <= 23 then
			message.show_voiced_skipping(2500630)
		end
		if checkpoint <= 24 then
			message.show_voiced_skipping(2500640)
		end
		if checkpoint <= 25 then
			cutscene.skip_command(0)
		end
		if checkpoint <= 26 then
			wait.frames_skipping(30)
		end
		if checkpoint <= 27 then
			wait.frames_skipping(30)
		end
		if checkpoint <= 28 then
			message.show_voiced_skipping(2500650)
		end
		if checkpoint <= 29 then
			message.show_voiced_skipping(2500655)
		end
		if checkpoint <= 30 then
			wait.frames_skipping(15)
		end
		if checkpoint <= 31 then
			message.show_voiced_skipping(2500660)
		end
		if checkpoint <= 32 then
			wait.frames_skipping(30)
		end
		return true
	end)
	event.cancel_drama_scene_skip()
	event.stop_sound_effect(sound_bank, 22)
	unload_atla_scene_cast()
	event.fade_in_screen(30)
end

local script: { [any]: (...any) -> ...any } = {}

--- Does nothing at load time.
function script.setup() end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = play_gift_scene

--- Plays the tree-planting scene and moves on to the next map.
function script.cutscene_plant_trees()
	play_tree_planting_scene()
	event.skip_next_music_load()
	event.jump_to_map_3(-1, "s26", 501)
	vm.wait(2)
end
script[501] = script.cutscene_plant_trees

--- Plays the Atla conversation and moves on to the next map.
function script.cutscene_atla_conversation()
	play_atla_conversation_scene()
	event.jump_to_map_2(-1, "g01")
end
script[502] = script.cutscene_atla_conversation

--- Plays the gift scene and moves on to the next map.
function script.cutscene_gift_materials()
	play_gift_scene()
	event.jump_to_map_3(-1, "s26", 502)
	vm.wait(2)
end
script[505] = script.cutscene_gift_materials

--- Plays the tree-planting scene with debug prints, then fades in.
function script.preview_tree_planting_scene()
	local checkpoint: number = 0
	return vm.guard(function()
		checkpoint = 1
		play_tree_planting_scene()
		print("KITA###########################\n")
		event.fade_in_screen(30)
		print("KITA2222222###########################\n")
		return
	end, function(received: { any })
		if checkpoint <= 1 then
			print("KITA###########################\n")
			print("KITA2222222###########################\n")
			return 0
		end
		return nil
	end)
end
script[600] = script.preview_tree_planting_scene

return script
