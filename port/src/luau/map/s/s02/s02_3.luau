--!strict
--- Event script for the Sindain station map s02, with arrival handling, train boarding and the Carpenterion forest cutscene.

local vm = require("@lib/vm")
local menu = require("@lib/event/menu")
local message = require("@lib/event/message")
local partner_talk = require("@lib/event/german/partner_talk")
local party = require("@lib/event/party")
local sindain_station = require("@lib/event/sindain_station")
local town_prompt = require("@lib/event/german/town_prompt")
local train = require("@lib/event/train")
local wait = require("@lib/event/wait")

local max_slot: s32 = 0
local monica_slot: s32 = 0

--- Loads the partner characters and the Conda character for the Geostone cutscene according to the active character.
local function load_cutscene_characters()
	local active_character: s32 = 0
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	active_character = event.get_playable_character() or active_character
	if active_character == 0 then
		max_slot = 0
		monica_slot = 32
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", max_slot)
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
	if active_character == 1 then
		max_slot = 32
		monica_slot = 0
		event.load_character(5, "chara/c01_base.gltf", "info", max_slot)
		event.load_equipment_model(5, 0, 4, "info", max_slot)
		event.load_equipment_model(5, 0, 3, "info", max_slot)
		event.load_equipment_model(5, 0, 2, "info", max_slot, 38)
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", max_slot)
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
	event.clear_object_sequence(3, 36)
	event.set_object_sequence_object(3, 4)
	event.load_message_file(0, 5, "event/e200/e254/e254.txt")
end

--- Assigns the cutscene slots as if Monica were the active character.
local function set_monica_as_player_slots()
	max_slot = 0
	monica_slot = 32
	max_slot = 32
	monica_slot = 0
end

--- Deletes the cutscene characters and restores the party handles.
local function unload_cutscene_characters()
	local active_character: s32 = 0
	active_character = event.get_playable_character() or active_character
	if active_character == 0 then
		event.set_character_active(1, max_slot)
		event.set_character_active(0, monica_slot)
		event.delete_character_extension_packs(monica_slot)
		event.delete_character(monica_slot)
		event.delete_character(38)
	end
	if active_character == 1 then
		event.set_character_active(1, monica_slot)
		event.set_character_active(0, max_slot)
		event.delete_character_extension_packs(monica_slot)
		event.delete_character(max_slot)
		event.delete_character(38)
	end
	event.attach_object_handle_to_character(2, 1)
	event.set_object_handle_visible(2, 1)
	event.attach_object_handle_to_character(3, 2)
	event.set_object_handle_visible(3, 1)
	event.delete_character(36)
end

--- Plays the skippable cutscene in which the party returns with Geostones and is told to rebuild the forest.
local function play_carpenterion_forest_cutscene()
	local stage: number = 0
	vm.section(function()
		event.set_save_flag(254, 1)
		event.initialize_event()
		event.fade_out_screen(30)
		stage = 1
		wait.frames(30)
		event.stop_music(0)
		stage = 2
		wait.frames(4)
		event.load_music(49)
		load_cutscene_characters()
		message.set_window_mode(0, 1)
		event.enable_drama_skip()
		event.play_music(0)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-585.93, 175.94, -940.12)
		event.set_camera_sequence_look_at(-702.67, 128.67, -892.92)
		event.move_camera_sequence(-565.48, 108.18, -866.56, -690.38, 73.25, -848.03, 165)
		event.set_character_active(1, max_slot)
		event.set_character_active(1, monica_slot)
		event.set_character_active(1, 38)
		event.set_character_active(1, 36)
		event.set_scene_status_flags(1, max_slot, 8, 1)
		event.set_scene_status_flags(1, monica_slot, 8, 1)
		event.set_object_sequence_position(0, -1285.55, 14.1, -942.2)
		event.set_object_sequence_motion(0, "走り", 4)
		event.turn_object_sequence_toward(0, -749.29, 0.0, -826.86, 1)
		event.move_object_sequence(0, -749.29, 0.0, -826.86, 165, 1)
		event.set_object_handle_footstep_sound(0, 1)
		event.fade_in_screen(30)
		stage = 3
		wait.frames(30)
		event.set_object_sequence_position(1, -1285.55, 14.1, -942.2)
		event.set_object_sequence_motion(1, "走り", 4)
		event.turn_object_sequence_toward(1, -767.89, 0.0, -768.84, 1)
		event.move_object_sequence(1, -767.89, 0.0, -768.84, 135, 1)
		event.set_object_handle_footstep_sound(1, 1)
		stage = 4
		wait.frames(135)
		event.set_object_handle_footstep_sound(0, -1)
		event.set_object_handle_footstep_sound(1, -1)
		event.set_scene_status_flags(1, max_slot, 8, 0)
		event.set_scene_status_flags(1, monica_slot, 8, 0)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-350.28, 3.09, -880.0)
		event.set_camera_sequence_look_at(-237.75, 35.02, -880.0)
		event.set_object_sequence_position(3, -246.0, 0.0, -880.0)
		event.set_object_sequence_rotation(3, 0.0, -1.57, 0.0)
		event.set_object_sequence_motion(3, "おーい", 4)
		event.open_message_window_2(0, "Hallooo!")
		stage = 5
		message.show(0, -1, 2, 256, 416)
		event.set_camera_sequence_position(-269.42, 43.82, -641.43)
		event.set_camera_sequence_look_at(-355.67, 8.13, -699.39)
		event.set_object_sequence_position(0, -424.81, 0.0, -640.72)
		event.turn_object_sequence_toward(0, -354.91, 0.0, -694.75, 1)
		event.set_object_sequence_motion(0, "走り", 4)
		event.set_object_handle_footstep_sound(0, 1)
		event.set_object_sequence_position(1, -399.05, 0.0, -634.81)
		event.turn_object_sequence_toward(1, -359.19, 0.0, -671.7, 1)
		event.set_object_sequence_motion(1, "歩き", 4)
		event.set_object_handle_footstep_sound(1, 1)
		event.set_object_sequence_position(3, -321.61, 0.0, -694.6)
		event.set_object_sequence_rotation(3, 0.0, -1.61, 0.0)
		event.set_object_sequence_motion(3, "立ち", 4)
		event.move_object_sequence(0, -354.91, 0.0, -694.75, 45)
		event.delay_object_sequence_rotation_track(0, 45)
		event.rotate_object_sequence(0, 0.0, 1.16, 0.0, 5)
		event.delay_object_sequence_motion_track(0, 50)
		event.set_object_sequence_motion(0, "立ち")
		stage = 6
		wait.frames(15)
		event.move_object_sequence(1, -359.19, 0.0, -671.7, 60)
		event.delay_object_sequence_rotation_track(1, 60)
		event.rotate_object_sequence(1, 0.0, 1.87, 0.0, 5)
		event.delay_object_sequence_motion_track(1, 65)
		event.set_object_sequence_motion(1, "立ち")
		event.set_object_sequence_motion(3, "会話2")
		event.open_message_window_2(
			0,
			"Oh, ihr habt ein paar Geosteine\ngefunden.<page>Bauen wir den Wald mit\ndem Schreinerium wieder auf!"
		)
		stage = 7
		message.show(0, -1, 7, 341, 208)
		event.open_message_window_2(0, "Kommt mit.")
		stage = 8
		message.show(0, -1, 8, 341, 208)
		event.set_object_handle_footstep_sound(4, 1)
		event.set_object_sequence_motion(3, "歩き２")
		event.turn_object_sequence_toward(3, -306.48, 0.0, -624.02, 45)
		stage = 9
		wait.frames(45)
		event.move_object_sequence(3, -306.48, 0.0, -624.02, 90)
		stage = 10
		wait.frames(45)
		event.set_object_sequence_motion(0, "走り")
		event.turn_object_sequence_toward(0, -305.78, 0.0, -632.54, 8)
		stage = 11
		wait.frames(8)
		event.move_object_sequence(0, -305.78, 0.0, -632.54, 45)
		stage = 12
		wait.frames(22)
		event.set_object_sequence_motion(1, "歩き")
		event.turn_object_sequence_toward(1, -351.88, 0.0, -630.2, 30)
		stage = 13
		wait.frames(30)
		event.move_object_sequence(1, -351.88, 0.0, -630.2, 45)
		stage = 14
		wait.frames(30)
		event.fade_out_screen(30)
		stage = 15
		wait.frames(30)
	end, function(received: { any }): boolean
		if stage <= 1 then
			wait.frames_skipping(4)
		end
		if stage <= 2 then
			set_monica_as_player_slots()
			message.set_window_mode_stub(0, 1)
			wait.frames_skipping(30)
		end
		if stage <= 3 then
			wait.frames_skipping(135)
		end
		if stage <= 4 then
			message.show_and_close(0, -1, 2, 256, 416)
		end
		if stage <= 5 then
			wait.frames_skipping(15)
		end
		if stage <= 6 then
			message.show_and_close(0, -1, 7, 341, 208)
		end
		if stage <= 7 then
			message.show_and_close(0, -1, 8, 341, 208)
		end
		if stage <= 8 then
			wait.frames_skipping(45)
		end
		if stage <= 9 then
			wait.frames_skipping(45)
		end
		if stage <= 10 then
			wait.frames_skipping(8)
		end
		if stage <= 11 then
			wait.frames_skipping(22)
		end
		if stage <= 12 then
			wait.frames_skipping(30)
		end
		if stage <= 13 then
			wait.frames_skipping(30)
		end
		if stage <= 14 then
			wait.frames_skipping(30)
		end
		return true
	end)
	event.cancel_drama_scene_skip()
	event.set_scene_status_flags(1, max_slot, 8, 0)
	event.set_scene_status_flags(1, monica_slot, 8, 0)
	unload_cutscene_characters()
	event.finish_event()
	event.skip_next_music_load()
end

local script: { [any]: (...any) -> ...any } = {}

--- Does nothing at load time.
function script.setup() end

--- Initializes the station and places the player at the start position with a fade-in.
function script.place_player_at_station()
	event.initialize_event()
	sindain_station.initialize_map()
	event.set_camera_position(-368.0, 50.0, 62.1)
	event.set_camera_look_at(-368.0, 30.0, -57.9)
	event.set_character_position(0, -368.0, 0.0, -57.9)
	event.set_character_rotation(0, 0.0, 0.0, 0.0)
	event.fade_in_screen(15)
end
script[99] = script.place_player_at_station

--- Places the player on entry according to the previous map, playing the arrival cutscene when needed.
function script.default_event()
	local forest_cutscene_ready_flag: s32 = 0
	local forest_cutscene_done_flag: s32 = 0
	local memory_card_loaded: s32 = 0
	local old_map_no: s32 = 0
	local old_map_type: s32 = 0
	local train_state: s32 = 0
	local chapter: s32 = 0
	local stage: number = 0
	return vm.guard(function()
		event.initialize_event()
		sindain_station.initialize_map()
		print("start_event--------------------------------------------\n")
		forest_cutscene_ready_flag = event.get_save_flag(31) or forest_cutscene_ready_flag
		forest_cutscene_done_flag = event.get_save_flag(254) or forest_cutscene_done_flag
		if forest_cutscene_ready_flag ~= 0 and forest_cutscene_done_flag == 0 then
			play_carpenterion_forest_cutscene()
			event.jump_to_map_3(-1, "s47", 505)
			return
		end
		memory_card_loaded = event.take_memory_card_load_state() or memory_card_loaded
		if memory_card_loaded == 1 then
			event.set_character_position(0, -750.0, 0.0, -75.0)
			event.set_character_rotation(0, 0.0, 1.57, 0.0)
			event.set_character_motion(0, "立ち", 4)
			event.update_character_motion(0)
			event.reset_character_cloth_and_hair(0)
			event.reset_follow_camera(1, 0.0, 20.0)
		else
			old_map_no = event.get_previous_map() or old_map_no
			old_map_type = event.get_map_type(old_map_no) or old_map_type
			if old_map_type ~= -1 then
				if old_map_type == 7 or old_map_type == 8 then
					stage = 2
					sindain_station.walk_player_back_from_menu()
					event.set_character_motion(0, "立ち")
					return
				else
					if old_map_no == 53 then
						stage = 3
						sindain_station.start_first_visit_event()
						return
					end
					if old_map_no == 0 then
						stage = 4
						sindain_station.run_player_in_with_fade()
					else
						train_state = event.get_save_counter(1) or train_state
						if
							(old_map_no == 18 or old_map_no == 23 or old_map_no == 120 or old_map_no == 108)
							and train_state == 2
						then
							train.place_player_at_saved_platform()
							event.fade_in_screen(15)
							event.reset_follow_camera(1, 0.0)
						else
							chapter = event.get_chapter() or chapter
							if chapter ~= 6 and chapter ~= 7 then
								stage = 5
								sindain_station.play_train_arrival_cutscene()
							else
								stage = 6
								sindain_station.play_train_arrival_quick()
							end
						end
					end
				end
			end
			event.set_character_motion(0, "立ち")
		end
		return
	end, function(received: { any })
		if stage <= 2 then
			return 0
		end
		if stage <= 3 then
			return 0
		end
		if stage <= 6 then
			if stage <= 4 then
				train.skip_place_player_at_saved_platform()
				stage = 5
				sindain_station.play_train_arrival_cutscene()
				return vm.continue_with(function()
					event.set_character_motion(0, "立ち")
					return
				end)
			end
			if stage <= 5 then
				sindain_station.skip_train_arrival_quick()
			end
			return 0
		end
		return nil
	end)
end

--- Shows a debug message window with an inserted string.
function script.key_open()
	event.set_message_inserted_string(0, 16, "なかみ")
	event.open_message_window_2(0, "ここから[文字列１６]ここまで")
	message.show(0, -1, 5, 0, 0)
end

--- Waits for a button press.
function script.wait_for_button()
	vm.wait(1)
	wait.until_button_pressed(64)
end
script[151] = script.wait_for_button

--- Confirms leaving and jumps to map g01.
function script.exit_to_g01()
	local exit_state_flag: s32 = 0
	if sindain_station.confirm_exit_to_map() ~= 0 then
		event.fade_out_screen(0)
		vm.wait(2)
		exit_state_flag = event.get_save_flag(208) or exit_state_flag
		if exit_state_flag == 0 then
			event.skip_next_music_play()
		end
		event.jump_to_map_2(-1, "g01")
		return
	end
end
script[209] = script.exit_to_g01

--- Confirms leaving and opens the dungeon floor selection.
function script.exit_to_dungeon()
	if sindain_station.confirm_exit_to_dungeon() ~= 0 then
		sindain_station.select_dungeon_floor()
	end
end
script[210] = script.exit_to_dungeon

--- Asks whether to board and boards the train for the destination chosen by the trigger.
function script.board_train()
	local answer: s32 = 0
	local chapter: s32 = 0
	local destination_kind: s32 = 0
	local stage: number = 0
	return vm.guard(function()
		stage = 1
		answer = town_prompt.ask_enter_or_leave()
		if answer ~= 1 then
			return
		end
		event.set_save_counter(1, 2)
		chapter = event.get_chapter() or chapter
		destination_kind = event.get_triggered_event_data_2(3) or destination_kind
		if destination_kind <= 1 then
			if chapter ~= 6 and chapter ~= 7 then
				stage = 2
				train.board_short_train()
				event.stop_music(0)
				stage = 3
				vm.wait(3)
				event.jump_to_map_2(-1, "s08")
			else
				stage = 4
				train.board_short_train()
				event.stop_music(0)
				stage = 5
				vm.wait(5)
				event.jump_to_map_2(-1, "s37")
			end
			stage = 6
			vm.wait(6)
		elseif chapter ~= 6 and chapter ~= 7 then
			stage = 7
			train.board_train(1)
			event.stop_music(0)
			event.jump_to_map_2(100, "s07")
		else
			stage = 8
			train.board_train_via_gangway()
			event.stop_music(0)
			event.jump_to_map_2(100, "s38")
		end
		return
	end, function(received: { any })
		if stage <= 1 then
			if stage == 1 then
				answer = received[1] :: number
			end
			return 0
		end
		if stage <= 8 then
			if stage <= 3 then
				train.board_train_skipping()
			end
			if stage <= 6 then
				train.board_train_skipping_primary(1)
			end
			if stage <= 7 then
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

--- Event 499, which map data, a script or the engine runs by number.
script[499] = sindain_station.play_train_arrival_cutscene

--- Fades out and loads the companion cutscene that forms the party and gives five of item 352.
function script.cutscene_form_party()
	event.initialize_event()
	event.fade_out_screen(0)
	vm.wait(1)
	event.load_event_script("s02/s02b_1.stb", 501)
end
script[501] = script.cutscene_form_party

--- Loads the companion cutscene that gives item 370.
function script.cutscene_receive_item_370()
	event.initialize_event()
	vm.wait(1)
	event.load_event_script("s02/s02b_1.stb", 502)
end
script[502] = script.cutscene_receive_item_370

--- Loads the companion cutscene that plays the station event 280 scene.
function script.cutscene_station_event_280()
	event.initialize_event()
	vm.wait(1)
	event.load_event_script("s02/s02b_1.stb", 503)
end
script[503] = script.cutscene_station_event_280

--- Initializes the station and runs the player in with a fade.
function script.run_player_into_station()
	event.initialize_event()
	sindain_station.initialize_map()
	sindain_station.run_player_in_with_fade()
	event.set_character_motion(0, "立ち")
end
script[504] = script.run_player_into_station

--- Handles the triggered station characters, offering to depart for the train.
function script.talk_to_station_npc()
	local npc_kind: s32 = 0
	local answer: s32 = 0
	local stage: number = 0
	return vm.guard(function()
		npc_kind = event.get_triggered_event_data_2(14) or npc_kind
		if npc_kind == 1 then
			stage = 1
			answer = partner_talk.offer_leave_or_speak_with_npc_1()
			if answer == 1 then
				stage = 2
				sindain_station.play_departure_announcement()
				stage = 3
				sindain_station.play_train_departure_cutscene()
				event.open_event_menu(13, 4)
				stage = 4
				vm.wait(4)
				event.jump_to_map_2(-1, "s04")
			end
		end
		if npc_kind == 2 then
			stage = 5
			partner_talk.speak_with_npc_2()
		end
		if npc_kind == 13 then
			stage = 6
			partner_talk.speak_with_npc_13()
		end
		if npc_kind == 301 then
			stage = 7
			town_prompt.say_waiting_outside()
		end
		return
	end, function(received: { any })
		if stage <= 7 then
			if stage == 1 then
				answer = received[1] :: number
			end
			if stage <= 1 then
				stage = 2
				sindain_station.play_departure_announcement()
				return vm.continue_with(function()
					stage = 3
					sindain_station.play_train_departure_cutscene()
					event.open_event_menu(13, 4)
					stage = 4
					vm.wait(4)
					event.jump_to_map_2(-1, "s04")
					if npc_kind == 2 then
						stage = 5
						partner_talk.speak_with_npc_2()
					end
					if npc_kind == 13 then
						stage = 6
						partner_talk.speak_with_npc_13()
					end
					if npc_kind == 301 then
						stage = 7
						town_prompt.say_waiting_outside()
					end
					return
				end)
			end
			if stage <= 2 then
				stage = 3
				sindain_station.play_train_departure_cutscene()
				return vm.continue_with(function()
					event.open_event_menu(13, 4)
					stage = 4
					vm.wait(4)
					event.jump_to_map_2(-1, "s04")
					if npc_kind == 2 then
						stage = 5
						partner_talk.speak_with_npc_2()
					end
					if npc_kind == 13 then
						stage = 6
						partner_talk.speak_with_npc_13()
					end
					if npc_kind == 301 then
						stage = 7
						town_prompt.say_waiting_outside()
					end
					return
				end)
			end
			if stage <= 4 then
				party.skip_talk_to_engineer()
			end
			if stage <= 5 then
				party.skip_talk_to_blaster()
			end
			if stage <= 6 then
				party.skip_talk_to_waiting_npc()
			end
			return 0
		end
		return nil
	end)
end
script[1000] = script.talk_to_station_npc

--- Fades out and loads the companion cutscene that forms the party and gives five of item 352.
function script.replay_form_party()
	event.initialize_event()
	event.fade_out_screen(0)
	vm.wait(1)
	event.load_event_script("s02/s02b_1.stb", 501)
end
script[12070] = script.replay_form_party

--- Sets the dungeon floor info, plays the forest cutscene and jumps to map s47.
function script.cutscene_carpenterion_then_s47()
	event.set_dungeon_floor_info(1, 7, 5, 256)
	play_carpenterion_forest_cutscene()
	event.jump_to_map_3(-1, "s47", 505)
end
script[12541] = script.cutscene_carpenterion_then_s47

--- Plays the departure announcement and cutscene and jumps to map s04.
function script.cutscene_train_departure()
	local stage: number = 0
	return vm.guard(function()
		stage = 1
		sindain_station.play_departure_announcement()
		stage = 2
		sindain_station.play_train_departure_cutscene()
		event.open_event_menu(13, 4)
		stage = 3
		vm.wait(3)
		event.jump_to_map_2(-1, "s04")
		return
	end, function(received: { any })
		if stage <= 3 then
			if stage <= 1 then
				stage = 2
				sindain_station.play_train_departure_cutscene()
				return vm.continue_with(function()
					event.open_event_menu(13, 4)
					stage = 3
					vm.wait(3)
					event.jump_to_map_2(-1, "s04")
					return
				end)
			end
			return 0
		end
		return nil
	end)
end
script[12830] = script.cutscene_train_departure

return script
