--!strict
--- Event script for Balance Valley Station covering arrivals, boarding trains and station conversations.

local vm = require("@lib/vm")
local balance_valley_station = require("@lib/event/balance_valley_station")
local cutscene = require("@lib/event/cutscene")
local inventory = require("@lib/event/inventory")
local menu = require("@lib/event/menu")
local message = require("@lib/event/message")
local object = require("@lib/event/object")
local partner_talk = require("@lib/event/german/partner_talk")
local party = require("@lib/event/party")
local town_prompt = require("@lib/event/german/town_prompt")
local train = require("@lib/event/train")
local wait = require("@lib/event/wait")

local mints_character: s32 = 0
local monica_character: s32 = 0

--- Loads the party, the p01_03a character, motions and messages used by the station conversation cutscene.
local function load_station_chat_scene()
	local playable_character: s32 = 0
	event.set_message_window_mode(0, 7)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 0 then
		mints_character = 0
		monica_character = 33
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", mints_character)
		event.load_character_motion_pack(5, "event/e300/e372/e372_mints.gltf", "info", mints_character)
		event.attach_object_handle_to_character(0, mints_character)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, mints_character)
		event.load_character(5, "chara/c02_base.gltf", "info", monica_character)
		event.load_equipment_model(5, 1, 4, "info", monica_character)
		event.load_equipment_model(5, 1, 3, "info", monica_character)
		event.load_equipment_model(5, 1, 2, "info", monica_character, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", monica_character)
		event.load_character_motion_pack(5, "event/e300/e372/e372_monica.gltf", "info", monica_character)
		event.attach_object_handle_to_character(1, monica_character)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, monica_character)
		event.set_character_active(1, 37)
	end
	if playable_character == 1 then
		mints_character = 32
		monica_character = 0
		event.load_character(5, "chara/c01_base.gltf", "info", mints_character)
		event.load_equipment_model(5, 0, 4, "info", mints_character)
		event.load_equipment_model(5, 0, 3, "info", mints_character)
		event.load_equipment_model(5, 0, 2, "info", mints_character, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", mints_character)
		event.load_character_motion_pack(5, "event/e300/e372/e372_mints.gltf", "info", mints_character)
		event.attach_object_handle_to_character(0, mints_character)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_active(0, mints_character)
		event.set_character_active(1, 37)
		event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", monica_character)
		event.load_character_motion_pack(5, "event/e300/e372/e372_monica.gltf", "info", monica_character)
		event.attach_object_handle_to_character(1, monica_character)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_active(0, monica_character)
	end
	event.load_character(5, "chara/p01_03a.gltf", "info", 35)
	event.attach_object_handle_to_character(2, 35)
	event.clear_object_sequence(2)
	event.set_object_sequence_object(2, 2)
	event.set_character_active(0, 35)
	event.load_message_file(0, 5, "event/e300/e372/e372_1.txt")
	event.set_scene_status_flags(1, mints_character, 256, 1)
	event.set_scene_status_flags(1, monica_character, 256, 1)
end

--- Deletes the characters loaded for the station conversation cutscene and restores the party.
local function unload_station_chat_scene()
	local playable_character: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 0 then
		event.set_character_active(1, mints_character)
		event.set_character_active(0, monica_character)
		event.delete_character_extension_packs(mints_character)
		event.delete_character(monica_character)
		event.delete_character(37)
	end
	if playable_character == 1 then
		event.set_character_active(1, monica_character)
		event.set_character_active(0, mints_character)
		event.delete_character_extension_packs(monica_character)
		event.delete_character(mints_character)
		event.delete_character(37)
	end
	event.delete_character(35)
end

--- Plays the cutscene in which the party runs to the platform and talks with the p01_03a character, then restores control.
local function play_station_chat_scene()
	vm.section(function()
		event.set_character_active(0, 24)
		event.set_save_flag(372, 1)
		event.initialize_event()
		event.attach_object_handle_to_map_part_2(20, "p01_train01")
		event.set_object_handle_position(20, 0.0, 0.0, 400.0)
		load_station_chat_scene()
		event.set_object_sequence_texture_animation(2, 0)
		event.set_object_sequence_texture_animation(2, 1, "わらい顔")
		event.set_object_sequence_texture_animation(2, 1, "通常目パチ")
		event.set_object_handle_footstep_sound(0, 2)
		event.set_object_handle_footstep_sound(1, 2)
		event.stop_music(0)
		wait.frames(4)
		event.load_music(49)
		event.play_music(0)
		event.enable_drama_skip()
		event.set_character_active(1, mints_character)
		event.set_character_active(1, monica_character)
		event.set_character_active(1, 35)
		event.set_camera_sequence_position(-940.17, 88.71, -222.08)
		event.set_camera_sequence_look_at(-788.53, 51.39, -202.38)
		event.set_object_sequence_position(0, -802.48, 0.0, -185.61)
		event.set_object_sequence_rotation(0, 0.0, 1.5, 0.0)
		event.set_object_sequence_position(1, -799.79, 0.0, -228.07)
		event.set_object_sequence_rotation(1, 0.0, 1.32, 0.0)
		event.set_object_sequence_position(2, -126.08, 36.0, -149.46)
		event.set_object_sequence_rotation(2, 0.0, -1.68, 0.0)
		event.fade_in_screen(15)
		event.set_object_sequence_motion(0, "走り", 0)
		event.set_object_sequence_motion(1, "走り", 0)
		event.move_object_sequence(0, -647.07, 0.0, -165.42, 60)
		event.move_object_sequence(1, -636.31, 0.0, -204.74, 60)
		object.wait_until_done(0)
		event.set_camera_sequence_position(-243.89, 55.02, -207.96)
		event.set_camera_sequence_look_at(-152.87, 61.42, -156.97)
		event.set_object_sequence_position(0, -207.98, 36.0, -142.65)
		event.set_object_sequence_rotation(0, 0.0, 1.62, 0.0)
		event.set_object_sequence_position(1, -209.43, 36.0, -161.14)
		event.set_object_sequence_rotation(1, 0.0, 1.56, 0.0)
		event.set_object_sequence_motion(0, "歩き", 4)
		event.set_object_sequence_motion(1, "歩き", 4)
		event.set_object_sequence_motion(2, "会話", 2)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		event.move_object_sequence(0, -155.54, 36.0, -140.71, 75)
		event.move_object_sequence(1, -153.89, 36.0, -159.09, 75)
		event.set_mouth_texture_animations(2, "口パク")
		message.show_voiced_for(3720500, 60)
		event.reset_mouth_texture_animations()
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_camera_sequence_position(-196.14, 62.27, -152.87)
		event.set_camera_sequence_look_at(-156.04, 61.42, -151.29)
		event.set_object_sequence_position(0, -155.54, 36.0, -140.71)
		event.set_object_sequence_rotation(0, 0.0, 1.62, 0.0)
		event.set_object_sequence_position(1, -153.89, 36.0, -159.09)
		event.set_object_sequence_rotation(1, 0.0, 1.56, 0.0)
		event.set_object_sequence_motion(0, "立ち", 4)
		event.set_object_sequence_motion(1, "立ち", 4, -1.0, 1)
		event.set_object_sequence_motion(2, "会話2", 2)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		event.set_mouth_texture_animations(2, "口パク")
		message.show_voiced(3720505)
		event.reset_mouth_texture_animations()
		event.fade_out_screen(30)
		wait.frames(30)
	end)
	event.cancel_drama_scene_skip()
	if mints_character == 0 then
		event.set_character_position(0, -155.54, 36.0, -140.71)
	else
		event.set_character_position(0, -153.89, 36.0, -159.09)
	end
	unload_station_chat_scene()
	event.set_character_active(1, 24)
	event.fade_in_screen(30)
end

local script: { [any]: (...any) -> ...any } = {}

--- Does nothing at load time.
function script.setup() end

--- Event 99, which map data, a script or the engine runs by number.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing.
function script.do_nothing() end
script[99] = script.do_nothing

--- Positions the party on entering the station: restores the player after a memory card load, runs in from the first map, plays the arrival cutscene or walks off the train, depending on the previous map and story flags.
function script.default_event()
	local memory_card_load_state: s32 = 0
	local previous_map: s32 = 0
	local map_type: s32 = 0
	local save_flag_283: s32 = 0
	local save_flag_300: s32 = 0
	local chapter_on_arrival: s32 = 0
	local save_counter: s32 = 0
	local chapter_on_return: s32 = 0
	local checkpoint: number = 0
	return vm.guard(function()
		balance_valley_station.initialize_station_characters()
		memory_card_load_state = event.take_memory_card_load_state() or memory_card_load_state
		if memory_card_load_state == 1 then
			event.set_character_position(0, -357.0, 0.0, -206.0)
			event.set_character_rotation(0, 0.0, -1.57, 0.0)
			event.set_character_motion(0, "立ち", 4)
			event.update_character_motion(0)
			event.reset_character_cloth_and_hair(0)
			event.reset_follow_camera(1, 3.14, 20.0)
		else
			previous_map = event.get_previous_map() or previous_map
			map_type = event.get_map_type(previous_map) or map_type
			if map_type ~= -1 then
				if previous_map == 1 then
					checkpoint = 1
					balance_valley_station.run_in_from_map_entrance()
				elseif previous_map ~= 18 and previous_map ~= 23 and previous_map ~= 120 and previous_map ~= 108 then
					save_flag_283 = event.get_save_flag(283) or save_flag_283
					save_flag_300 = event.get_save_flag(300) or save_flag_300
					if save_flag_283 == 1 and save_flag_300 == 0 then
						event.set_villager_ai_enabled(0, 24)
						event.set_villager_ai_enabled(0, 25)
						event.set_villager_ai_enabled(0, 26)
						checkpoint = 2
						balance_valley_station.play_party_arrival_scene()
						balance_valley_station.place_villagers()
						event.set_villager_ai_enabled(1, 24)
						event.set_villager_ai_enabled(1, 25)
						event.set_villager_ai_enabled(1, 26)
					else
						event.set_character_active(0, 25)
						chapter_on_arrival = event.get_chapter() or chapter_on_arrival
						if chapter_on_arrival ~= 6 and chapter_on_arrival ~= 7 then
							checkpoint = 3
							balance_valley_station.walk_off_train_skippable()
						else
							checkpoint = 4
							balance_valley_station.walk_off_train()
						end
						event.set_character_active(25)
					end
				else
					save_counter = event.get_save_counter(1) or save_counter
					if
						(previous_map == 18 or previous_map == 23 or previous_map == 120 or previous_map == 108)
						and save_counter == 3
					then
						train.place_player_at_saved_platform()
						event.fade_in_screen(15)
						event.reset_follow_camera(1, 0.0)
					else
						chapter_on_return = event.get_chapter() or chapter_on_return
						if chapter_on_return ~= 6 and chapter_on_return ~= 7 then
							checkpoint = 5
							balance_valley_station.walk_off_train_skippable()
						else
							checkpoint = 6
							balance_valley_station.walk_off_train()
						end
					end
				end
			else
				print("------  <START EVENT> OLD MAP ERR   ------\n")
			end
		end
		return
	end, function(received: { any })
		if checkpoint <= 6 then
			if checkpoint <= 1 then
				checkpoint = 2
				balance_valley_station.play_party_arrival_scene()
				return vm.continue_with(function()
					balance_valley_station.place_villagers()
					event.set_villager_ai_enabled(1, 24)
					event.set_villager_ai_enabled(1, 25)
					event.set_villager_ai_enabled(1, 26)
					return
				end)
			end
			if checkpoint <= 2 then
				cutscene.noop()
				checkpoint = 3
				balance_valley_station.walk_off_train_skippable()
				return vm.continue_with(function()
					event.set_character_active(25)
					return
				end)
			end
			if checkpoint <= 3 then
				wait.skip_short_pause()
			end
			if checkpoint <= 4 then
				train.skip_place_player_at_saved_platform()
				checkpoint = 5
				balance_valley_station.walk_off_train_skippable()
				return vm.continue_with(function()
					return
				end)
			end
			if checkpoint <= 5 then
				wait.skip_short_pause()
			end
			print("------  <START EVENT> OLD MAP ERR   ------\n")
			return 0
		end
		return nil
	end)
end

--- Waits for the square button, plays a sound effect, then waits for the button again.
function script.key_open()
	local sound_bank: s32 = 0
	event.initialize_event()
	sound_bank = event.load_sound_effect_file_2(3200) or sound_bank
	vm.wait(1)
	wait.until_button_pressed(64)
	event.play_sound_effect(sound_bank, 8)
	vm.wait(3)
	wait.until_button_pressed(64)
end

--- Asks whether to leave and boards a short train to s08 or s37, or a full train to s07 or s38, depending on the chapter and trigger data.
function script.board_train()
	local choice: s32 = 0
	local chapter: s32 = 0
	local train_kind: s32 = 0
	local checkpoint: number = 0
	return vm.guard(function()
		checkpoint = 1
		choice = town_prompt.ask_enter_or_leave()
		if choice ~= 1 then
			return
		end
		event.set_save_counter(1, 3)
		chapter = event.get_chapter() or chapter
		train_kind = event.get_triggered_event_data_2(3) or train_kind
		if train_kind <= 1 then
			if chapter ~= 6 and chapter ~= 7 then
				checkpoint = 2
				train.board_short_train()
				event.stop_music(0)
				checkpoint = 3
				vm.wait(3)
				event.jump_to_map_2(-1, "s08")
			else
				checkpoint = 4
				train.board_short_train()
				event.stop_music(0)
				checkpoint = 5
				vm.wait(5)
				event.jump_to_map_2(-1, "s37")
			end
			checkpoint = 6
			vm.wait(6)
		elseif chapter ~= 6 and chapter ~= 7 then
			checkpoint = 7
			train.board_train(0)
			event.stop_music(0)
			event.jump_to_map_2(100, "s07")
		else
			checkpoint = 8
			train.board_train_via_gangway()
			event.stop_music(0)
			event.jump_to_map_2(100, "s38")
		end
		return
	end, function(received: { any })
		if checkpoint <= 1 then
			if checkpoint == 1 then
				choice = received[1] :: number
			end
			return 0
		end
		if checkpoint <= 8 then
			if checkpoint <= 3 then
				train.board_train_skipping()
			end
			if checkpoint <= 6 then
				train.board_train_skipping_primary(0)
			end
			if checkpoint <= 7 then
				train.board_train_via_gangway_skipping()
			end
			return 0
		end
		return nil
	end)
end
script[250] = script.board_train

--- Event 400, which map data, a script or the engine runs by number.
script[400] = menu.open_with_fade

--- Asks whether to leave through the map exit and jumps to map g02 when the player does.
function script.leave_station_to_g02()
	if balance_valley_station.walk_to_map_exit() ~= 0 then
		event.jump_to_map_3(-1, "g02", 100)
	end
end
script[500] = script.leave_station_to_g02

--- Plays the cutscene in which the party runs to the platform and talks.
function script.cutscene_station_chat()
	balance_valley_station.initialize_station_characters()
	play_station_chat_scene()
end
script[501] = script.cutscene_station_chat

--- Grants the stage supplies and plays the party arrival cutscene with the villagers.
function script.cutscene_arrival_with_supplies()
	inventory.grant_stage_supplies(3)
	balance_valley_station.initialize_station_characters()
	event.set_villager_ai_enabled(0, 24)
	event.set_villager_ai_enabled(0, 25)
	event.set_villager_ai_enabled(0, 26)
	balance_valley_station.play_party_arrival_scene()
	balance_valley_station.place_villagers()
	event.set_villager_ai_enabled(1, 24)
	event.set_villager_ai_enabled(1, 25)
	event.set_villager_ai_enabled(1, 26)
end
script[502] = script.cutscene_arrival_with_supplies

--- Handles conversation with the station character chosen by the trigger data, including departing by train.
function script.talk_to_station_npc()
	local npc_id: s32 = 0
	local choice: s32 = 0
	local checkpoint: number = 0
	return vm.guard(function()
		npc_id = event.get_triggered_event_data_2(14) or npc_id
		if npc_id == 1 then
			checkpoint = 1
			choice = partner_talk.offer_leave_or_speak_with_npc_1()
			if choice == 1 then
				checkpoint = 2
				balance_valley_station.play_starbre_departure_scene()
				checkpoint = 3
				balance_valley_station.play_train_departure_scene()
				event.open_event_menu(13, 8)
				checkpoint = 4
				vm.wait(4)
				event.jump_to_map_2(-1, "s09")
			end
		end
		if npc_id == 2 then
			checkpoint = 5
			partner_talk.speak_with_npc_2()
		end
		if npc_id == 13 then
			checkpoint = 6
			partner_talk.speak_with_npc_13()
		end
		if npc_id == 301 then
			checkpoint = 7
			town_prompt.say_waiting_outside()
		end
		return
	end, function(received: { any })
		if checkpoint <= 7 then
			if checkpoint == 1 then
				choice = received[1] :: number
			end
			if checkpoint <= 1 then
				checkpoint = 2
				balance_valley_station.play_starbre_departure_scene()
				return vm.continue_with(function()
					checkpoint = 3
					balance_valley_station.play_train_departure_scene()
					event.open_event_menu(13, 8)
					checkpoint = 4
					vm.wait(4)
					event.jump_to_map_2(-1, "s09")
					if npc_id == 2 then
						checkpoint = 5
						partner_talk.speak_with_npc_2()
					end
					if npc_id == 13 then
						checkpoint = 6
						partner_talk.speak_with_npc_13()
					end
					if npc_id == 301 then
						checkpoint = 7
						town_prompt.say_waiting_outside()
					end
					return
				end)
			end
			if checkpoint <= 2 then
				checkpoint = 3
				balance_valley_station.play_train_departure_scene()
				return vm.continue_with(function()
					event.open_event_menu(13, 8)
					checkpoint = 4
					vm.wait(4)
					event.jump_to_map_2(-1, "s09")
					if npc_id == 2 then
						checkpoint = 5
						partner_talk.speak_with_npc_2()
					end
					if npc_id == 13 then
						checkpoint = 6
						partner_talk.speak_with_npc_13()
					end
					if npc_id == 301 then
						checkpoint = 7
						town_prompt.say_waiting_outside()
					end
					return
				end)
			end
			if checkpoint <= 4 then
				party.skip_talk_to_engineer()
			end
			if checkpoint <= 5 then
				party.skip_talk_to_blaster()
			end
			if checkpoint <= 6 then
				party.skip_talk_to_waiting_npc()
			end
			return 0
		end
		return nil
	end)
end
script[1000] = script.talk_to_station_npc

--- Plays the party arrival cutscene with the villagers.
function script.cutscene_party_arrival()
	balance_valley_station.initialize_station_characters()
	event.set_villager_ai_enabled(0, 24)
	event.set_villager_ai_enabled(0, 25)
	event.set_villager_ai_enabled(0, 26)
	balance_valley_station.play_party_arrival_scene()
	balance_valley_station.place_villagers()
	event.set_villager_ai_enabled(1, 24)
	event.set_villager_ai_enabled(1, 25)
	event.set_villager_ai_enabled(1, 26)
end
script[13000] = script.cutscene_party_arrival

--- Plays Starbre's departure announcement and the train leaving, then jumps to map s09.
function script.cutscene_train_departure()
	local checkpoint: number = 0
	return vm.guard(function()
		balance_valley_station.initialize_station_characters()
		checkpoint = 1
		balance_valley_station.play_starbre_departure_scene()
		checkpoint = 2
		balance_valley_station.play_train_departure_scene()
		event.open_event_menu(13, 8)
		checkpoint = 3
		vm.wait(3)
		event.jump_to_map_2(-1, "s09")
		return
	end, function(received: { any })
		if checkpoint <= 3 then
			if checkpoint <= 1 then
				checkpoint = 2
				balance_valley_station.play_train_departure_scene()
				return vm.continue_with(function()
					event.open_event_menu(13, 8)
					checkpoint = 3
					vm.wait(3)
					event.jump_to_map_2(-1, "s09")
					return
				end)
			end
			return 0
		end
		return nil
	end)
end
script[13600] = script.cutscene_train_departure

return script
