--!strict
--- Runs the destroyed lighthouse map: the star hourglass hint and use, the Lin approach scene and the exit.

local vm = require("@lib/vm")
local camera = require("@lib/event/camera")
local character = require("@lib/event/character")
local cutscene = require("@lib/event/cutscene")
local destroyed_lighthouse = require("@lib/event/destroyed_lighthouse")
local dungeon = require("@lib/event/dungeon")
local map = require("@lib/event/map")
local message = require("@lib/event/message")
local object = require("@lib/event/object")
local wait = require("@lib/event/wait")

local max_slot: s32 = 0
local monica_slot: s32 = 0

--- Starts the map music and sounds and disables the function points whose scenes have been seen.
local function set_up_lighthouse_map()
	local music_number: s32 = 0
	local lin_scene_flag: s32 = 0
	local hourglass_scene_flag: s32 = 0
	music_number = event.get_active_music_number() or music_number
	if music_number ~= 17 then
		event.stop_music(0)
		wait.frames(6)
		event.load_music(17)
	end
	event.play_music(0)
	event.load_map_sounds(3682)
	lin_scene_flag = event.get_save_flag(348) or lin_scene_flag
	if lin_scene_flag == 1 then
		event.set_function_point_enabled("", "e348", 0)
		event.attach_object_handle_to_map_part_2(0, "p07_d03b01")
		event.set_object_handle_visible(0, 0)
	end
	hourglass_scene_flag = event.get_save_flag(352) or hourglass_scene_flag
	if hourglass_scene_flag == 1 then
		event.set_function_point_enabled("", "event", 0)
	end
end

--- Explains how to travel back to the past, or asks whether to go when the star hourglass is owned.
local function ask_to_travel_to_past()
	local hourglass_count: s32 = 0
	local answer: s32 = 0
	local checkpoint: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.set_character_motion(0, "立ち")
		event.apply_message_window_preset(0, 0)
		event.set_message_bubble_tail(0, 0)
		hourglass_count = event.get_item_count(371) or hourglass_count
		if hourglass_count <= 0 then
			event.open_message_window_2(
				0,
				"If we could get back to the past from here,\nwe should be able to save Crest!\nBut how in the world do we do that?"
			)
			checkpoint = 1
			message.show_and_wait(0, -1, 5, 256, 208)
			event.apply_message_window_preset(0, 4)
			event.set_message_window_mode(0, 4)
			event.open_message_window_2(
				0,
				"[(!)]Is there really a way to travel back to\nthe past? Maybe if you had some sort or\nspecial device or something..."
			)
			checkpoint = 2
			message.show_and_wait(0, -1, 8, 0, 0)
			event.open_message_window_2(
				0,
				"[(!)]That reminds me. Supposedly there's an\nequipment shop at Stella Temple that\ndeals in rare articles and goods.<page>Who knows, maybe you could find\nsomething useful there."
			)
			checkpoint = 3
			message.show_and_wait(0, -1, 8, 0, 0)
		else
			event.open_message_window_2(
				0,
				"We should be able to help out Crest\nnow! Let's head back to the past!\n(Press (#) to open Menu)"
			)
			checkpoint = 4
			answer = message.ask_confirmation(0, -1, 5, 256, 208, answer)
			if answer == 1 then
				event.set_message_bubble_tail(0, 1)
				return 1
			end
		end
		event.apply_message_window_preset(0, 0)
		event.set_message_bubble_tail(0, 1)
		return 0
	end, function(received: { any })
		if checkpoint <= 4 then
			if checkpoint == 4 then
				answer = received[2] :: number
			end
			if checkpoint <= 1 then
				message.show_and_wait_skipping(0, -1, 8, 0, 0)
			end
			if checkpoint <= 2 then
				message.show_and_wait_skipping(0, -1, 8, 0, 0)
			end
			if checkpoint <= 3 then
				answer = message.show_and_ask(0, -1, 5, 256, 208, answer)
			end
			return 1
		end
		return nil
	end)
end

--- Loads Max, Monica and the hourglass scene's characters and models.
local function load_hourglass_scene_cast()
	local playable_character: s32 = 0
	event.set_message_window_mode(0, 7)
	event.show_dungeon_status_bar(0, 1.0)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	playable_character = event.get_playable_character() or playable_character
	print("GET_ACTIVE_CHR_NO-------", playable_character, "\n")
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
	event.load_character(5, "event/e300/e352/e352_tokei_h.gltf", "info", 19)
	event.set_character_active(0, 19)
	event.load_character(5, "event/e300/e352/e352_monica_tokei.gltf", "info", 13)
	event.set_character_active(0, 13)
	event.load_character(5, "event/e300/e352/e352_sdokei.gltf", "info", 20)
	event.set_character_active(0, 20)
	event.load_character(5, "event/e300/e352/e352_mabu.gltf", "info", 21)
	event.set_character_active(0, 21)
	event.load_character(5, "event/e300/e352/e352_hikari.gltf", "info", 22)
	event.set_character_active(0, 22)
	event.set_scene_character_type(22, 4)
	event.load_message_file(0, 5, "event/e300/e352/e352_1.txt")
end

--- Reassigns the party slot variables to the same values the cutscene loader sets when the scene is skipped.
local function assign_party_slots_for_skip()
	local playable_character: s32 = 0
	print("GET_ACTIVE_CHR_NO-------", playable_character, "\n")
	max_slot = 0
	monica_slot = 8
	max_slot = 8
	monica_slot = 0
end

--- Restores the party, deletes the hourglass scene's characters and ends the event.
local function unload_hourglass_scene_cast()
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
	event.delete_character(19)
	event.delete_character(13)
	event.delete_character(20)
	event.delete_character(21)
	event.delete_character(22)
	event.attach_object_handle_to_character(2, 1)
	event.set_object_handle_visible(2, 1)
	event.attach_object_handle_to_character(3, 2)
	event.set_object_handle_visible(3, 1)
	event.show_dungeon_status_bar(1, 1.0)
	event.finish_event()
	vm.wait(1)
end

--- Plays the scene in which the star hourglass is placed and glows, then whites out.
local function play_star_hourglass_scene()
	local sound_bank: s32 = 0
	local checkpoint: number = 0
	vm.section(function()
		checkpoint = 1
		vm.entry(1)
		event.set_save_flag(352, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.set_motion_blur(0)
		event.stop_music(0)
		checkpoint = 2
		vm.wait(2)
		checkpoint = 3
		vm.wait(3)
		checkpoint = 4
		vm.wait(4)
		checkpoint = 5
		vm.wait(5)
		event.load_map_sounds(3831)
		sound_bank = event.load_sound_effect_file_2(3831) or sound_bank
		load_hourglass_scene_cast()
		event.enable_drama_skip()
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
		event.set_character_active(1, max_slot)
		event.set_character_active(1, monica_slot)
		event.set_character_active(1, 9)
		event.set_camera_sequence_position(496.47, 169.37, -809.35)
		event.set_camera_sequence_look_at(508.77, 169.14, -850.82)
		event.set_object_sequence_position(2, 543.2, 144.04, -840.61)
		event.set_object_sequence_rotation(2, 0.0, -1.99, 0.0)
		event.set_object_sequence_position(0, 538.49, 145.86, -872.44)
		event.set_object_sequence_rotation(0, 0.0, 0.0, 0.0)
		event.set_object_sequence_position(1, 567.83, 142.65, -858.12)
		event.set_object_sequence_rotation(1, 0.0, -0.92, 0.0)
		event.move_camera_sequence_eased(530.44, 169.37, -799.27, 542.75, 169.14, -840.74, 120, 2, 1.0)
		event.fade_in_screen(30)
		checkpoint = 6
		camera.wait_until_done()
		checkpoint = 7
		wait.frames(30)
		event.set_object_sequence_motion(1, "会話", 6)
		event.queue_object_sequence_next_motion(1, "立ち", 4)
		event.set_mouth_texture_animations(1, "通常口パク")
		checkpoint = 8
		message.show_voiced(3520010)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_motion(2, "うなづく", 6)
		event.queue_object_sequence_next_motion(2, "上見立ち", 4)
		event.set_mouth_texture_animations(4, "通常口パク")
		checkpoint = 9
		message.show_voiced(3520020)
		event.reset_mouth_texture_animations()
		checkpoint = 10
		object.wait_until_done(2)
		event.attach_character_to_frame(monica_slot, "sword_hand", 13)
		event.set_character_active(1, 13)
		event.set_object_sequence_position(1, 519.39, 147.4, -861.34)
		event.set_object_sequence_rotation(1, 0.0, -0.2, 0.0)
		event.set_object_sequence_rotation(0, 0.0, -0.6, 0.0)
		event.set_object_sequence_motion(2, "下見立ち", 4)
		event.play_sound_effect(sound_bank, 0)
		event.set_object_sequence_motion(1, "置く～下見", 6)
		event.queue_object_sequence_next_motion(1, "下見", 4)
		event.set_camera_sequence_position(485.69, 161.28, -803.81)
		event.set_camera_sequence_look_at(535.39, 163.79, -859.0)
		checkpoint = 11
		wait.frames(27)
		event.play_sound_effect(sound_bank, 1)
		event.detach_character_from_frame(13)
		event.set_character_active(0, 13)
		event.set_character_active(1, 19)
		event.set_character_position(19, 516.77, 149.74, -850.63)
		checkpoint = 12
		wait.frames(60)
		event.set_camera_sequence_position(499.2, 155.53, -839.73)
		event.set_camera_sequence_look_at(516.77, 149.74, -850.63)
		checkpoint = 13
		wait.frames(60)
		event.set_character_active(1, 20)
		event.set_character_position(20, 516.77, 149.74, -850.63)
		event.set_character_motion(20, "砂時計光る", 2, -1, 1)
		event.play_sound_effect(sound_bank, 2)
		checkpoint = 14
		wait.frames(60)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "無表情")
		event.set_object_sequence_texture_animation(0, 1, "目とじ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "無表情")
		event.set_object_sequence_texture_animation(1, 1, "目とじ")
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "無表情")
		event.set_object_sequence_texture_animation(2, 1, "目とじ")
		event.set_object_sequence_texture_animation(2, 1, "半口")
		event.set_object_sequence_motion(2, "まぶしい", 6)
		event.set_object_sequence_motion(0, "まぶしい", 6)
		event.set_object_sequence_motion(1, "まぶしい", 6)
		event.queue_object_sequence_next_motion(2, "まぶしいＬ", 4)
		event.queue_object_sequence_next_motion(0, "まぶしいＬ", 4)
		event.queue_object_sequence_next_motion(1, "まぶしいＬ", 4)
		event.set_object_sequence_position(0, 539.17, 145.1, -856.52)
		event.set_object_sequence_rotation(0, 0.0, -1.99, 0.0)
		event.set_object_sequence_position(1, 538.92, 143.03, -823.0)
		event.set_object_sequence_rotation(1, 0.0, -2.24, 0.0)
		event.set_camera_sequence_position(494.78, 152.75, -815.47)
		event.set_camera_sequence_look_at(543.94, 165.9, -843.48)
		checkpoint = 15
		wait.frames(30)
		event.set_character_active(1, 21)
		event.set_character_position(21, 547.24, 149.74, -859.21)
		event.set_character_motion(21, "まぶしい", 2, -1, 1)
		checkpoint = 16
		wait.frames(60)
		event.set_character_active(0, 21)
		event.set_camera_sequence_position(1717.19, 225.79, 121.59)
		event.set_camera_sequence_look_at(543.94, 165.9, -843.48)
		event.play_sound_effect(sound_bank, 3)
		event.set_character_active(1, 22)
		event.set_character_position(22, 516.77, 149.74, -850.63)
		event.set_character_motion(22, "光る光る", 2, -1, 1)
		checkpoint = 17
		wait.frames(75)
		event.init_screen_raster_effect(0.0, 0.0, 0.15707964)
		event.start_screen_raster_effect(60.0, 0.3926991, -1.0, 60)
		checkpoint = 18
		wait.frames(75)
	end, function(received: { any }): boolean
		if checkpoint <= 5 then
			assign_party_slots_for_skip()
			wait.background_load_skipping()
		end
		if checkpoint <= 6 then
			wait.frames_skipping(30)
		end
		if checkpoint <= 7 then
			message.show_voiced_skipping(3520010)
		end
		if checkpoint <= 8 then
			message.show_voiced_skipping(3520020)
		end
		if checkpoint <= 9 then
			cutscene.skip_command(2)
		end
		if checkpoint <= 10 then
			wait.frames_skipping(27)
		end
		if checkpoint <= 11 then
			wait.frames_skipping(60)
		end
		if checkpoint <= 12 then
			wait.frames_skipping(60)
		end
		if checkpoint <= 13 then
			wait.frames_skipping(60)
		end
		if checkpoint <= 14 then
			wait.frames_skipping(30)
		end
		if checkpoint <= 15 then
			wait.frames_skipping(60)
		end
		if checkpoint <= 16 then
			wait.frames_skipping(75)
		end
		if checkpoint <= 17 then
			wait.frames_skipping(75)
		end
		return true
	end)
	checkpoint = 19
	vm.entry(19)
	event.cancel_drama_scene_skip()
	event.fade_out_camera_sequence(30, 255.0, 255.0, 255.0)
	checkpoint = 20
	wait.frames(30)
	event.stop_screen_raster_effect(0.0, 0.0, 0.0, 0)
	event.stop_port_sound_effects(4)
	event.skip_next_music_load()
	checkpoint = 21
	vm.wait(21)
	checkpoint = 22
	unload_hourglass_scene_cast()
end

local script: { [any]: (...any) -> ...any } = {}

--- Does nothing at load time.
function script.setup() end

script.set_up_lighthouse_map = set_up_lighthouse_map
script[99] = script.set_up_lighthouse_map

--- Starts the map music and sounds and walks the party in at the entrance.
function script.default_event()
	set_up_lighthouse_map()
	cutscene.walk_in_at_entrance_variant()
end

--- Waits a frame and then waits for a button press.
function script.key_open()
	event.initialize_event()
	vm.wait(1)
	wait.until_button_pressed(64)
	event.finish_event()
end

--- Handles the spot where the star hourglass is used to travel to the past.
function script.examine_past_travel_spot()
	local interaction_stage: s32 = 0
	local item: s32 = 0
	local checkpoint: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.set_character_motion(0, "立ち")
		interaction_stage = event.get_triggered_event_data_2(6) or interaction_stage
		if interaction_stage == 1 then
			checkpoint = 1
			if ask_to_travel_to_past() ~= 0 then
				interaction_stage = 2
			end
		end
		if interaction_stage == 2 then
			event.show_dungeon_status_bar(0, 0.16666667)
			checkpoint = 2
			wait.frames(6)
			event.open_use_item_menu(371)
			checkpoint = 3
			vm.wait(3)
			item = vmhost.used_item() or item
			if item == 371 then
				event.set_function_point_enabled("", "event", 0)
				event.fade_out_screen(20)
				checkpoint = 4
				wait.frames(20)
				event.switch_dungeon_main_character(0)
				checkpoint = 5
				play_star_hourglass_scene()
				event.load_dungeon_map("d03b02")
				event.load_event_script("d03b02/d03b02.stb", 502)
				return
			elseif item > 0 then
				checkpoint = 6
				character.shake_head_at_camera()
			end
			event.show_dungeon_status_bar(1, 0.16666667)
		end
		checkpoint = 7
		wait.frames(6)
		event.finish_event()
		return
	end, function(received: { any })
		if checkpoint <= 5 then
			if checkpoint == 1 then
				local _ = received[1] :: number
			end
			if checkpoint <= 1 then
				local _ = interaction_stage == 1
				interaction_stage = 2
				wait.frames_skipping(6)
			end
			if checkpoint <= 3 then
				wait.frames_skipping(20)
			end
			if checkpoint <= 4 then
				checkpoint = 5
				play_star_hourglass_scene()
				return vm.continue_with(function()
					event.load_dungeon_map("d03b02")
					event.load_event_script("d03b02/d03b02.stb", 502)
					return
				end)
			end
			return 0
		end
		if checkpoint <= 7 then
			if checkpoint <= 6 then
				wait.frames_skipping(6)
			end
			return 0
		end
		return nil
	end)
end
script[500] = script.examine_past_travel_spot

--- Hides the lighthouse part, fades out and plays the Lin approach scene.
function script.cutscene_lin_approach()
	local checkpoint: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.set_function_point_enabled("", "e348", 0)
		event.attach_object_handle_to_map_part_2(0, "p07_d03b01")
		event.set_object_handle_visible(0, 0)
		character.set_idle_motion()
		event.fade_out_music(30)
		event.fade_out_screen(30)
		checkpoint = 1
		wait.frames(30)
		checkpoint = 2
		destroyed_lighthouse.play_lin_approach_scene()
		return
	end, function(received: { any })
		if checkpoint <= 2 then
			if checkpoint <= 1 then
				checkpoint = 2
				destroyed_lighthouse.play_lin_approach_scene()
				return vm.continue_with(function()
					return
				end)
			end
			return 0
		end
		return nil
	end)
end
script[502] = script.cutscene_lin_approach

--- Asks to leave the area and loads dungeon d03 on a yes.
function script.leave_lighthouse()
	if map.confirm_leave_area_variant() ~= 0 then
		event.load_event_script("d03/d03.stb", 1000)
	end
end
script[510] = script.leave_lighthouse

--- Runs the defeat sequence with a silent message when the party is defeated.
function script.on_player_defeated()
	dungeon.run_defeat_sequence_with_message_silent(0)
end
script[1200] = script.on_player_defeated

--- Event 13480, which map data, a script or the engine runs by number.
script[13480] = destroyed_lighthouse.play_lin_approach_scene

--- Plays the star hourglass scene and loads dungeon d03b02.
function script.replay_star_hourglass_scene()
	event.switch_dungeon_main_character(0)
	play_star_hourglass_scene()
	event.load_dungeon_map("d03b02")
	event.load_event_script("d03b02/d03b02.stb", 502)
end
script[13520] = script.replay_star_hourglass_scene

return script
