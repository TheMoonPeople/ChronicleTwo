--!strict
--- Event script for the Palm Brinks town map, covering entry placement, house doors, the dungeon gate, the fishing contest prompt and story cutscenes.

local vm = require("@lib/vm")
local character = require("@lib/event/character")
local cutscene = require("@lib/event/cutscene")
local menu = require("@lib/event/menu")
local message = require("@lib/event/message")
local palm_brinks_town = require("@lib/event/palm_brinks_town")
local villager_dialogue = require("@lib/event/german/villager_dialogue")
local wait = require("@lib/event/wait")

--- Shows the system-style message window with the message the map already holds.
local function show_system_message()
	event.set_character_motion(0, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	message.show(0, -1, 8, 0, 0)
	event.set_message_window_mode(0, 1)
end

--- Asks whether to enter the contest and either runs the player off to it or walks back, returning 1 when the player goes.
local function confirm_fishing_contest_entry()
	local contest_type: s32 = 0
	local choice: any = 0
	local start_x: f32 = 0
	local start_y: f32 = 0
	local current_y: f32 = 0
	local current_z: f32 = 0
	local stage: number = 0
	return vm.guard(function()
		print("00000000000000000000000000\n")
		event.initialize_event()
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_motion(0, "立ち", 4)
		event.set_message_window_mode(0, 5)
		contest_type = event.get_menu_value_2(1) or contest_type
		if contest_type == 1 then
			event.open_message_window_2(0, "Zum Angelturnier gehen?")
		else
			event.open_message_window_2(0, "Zum Flossen-Fieber gehen?")
		end
		print("11111111111111111111111111111111\n")
		stage = 1
		choice = message.ask_choice_signed(0, -1, 8, 256, 208, 2, 1)
		if choice == 0 then
			event.set_camera_sequence_position(1332.56, 67.86, 1494.1)
			event.set_camera_sequence_look_at(1508.0, 12.6, 1425.04)
			event.move_camera_sequence_eased(1332.56, 97.86, 1494.1, 1508.0, 42.6, 1425.04, 48, 2, 0.4)
			event.set_object_sequence_motion(0, "走り", 4, -1.0, 1)
			do
				local out1, out2, _ = event.get_character_position(0)
				start_x = out1 or start_x
				start_y = out2 or start_y
			end
			event.set_object_sequence_position(0, start_x, start_y, 1415.0)
			event.set_object_sequence_rotation(0, 0.0, 1.57, 0.0)
			event.move_object_sequence(0, 1800.0, start_y, 1415.0, 90)
			stage = 2
			wait.frames(15)
			event.fade_out_screen(30)
			stage = 3
			wait.frames(30)
			return 1
		end
		event.set_object_sequence_motion(0, "歩き", 4, -1.0, 1)
		event.rotate_object_sequence(0, 0.0, -1.57, 0.0, 15)
		stage = 4
		wait.frames(15)
		do
			local _, out2, out3 = event.get_character_position(0)
			current_y = out2 or current_y
			current_z = out3 or current_z
		end
		event.move_object_sequence(0, 1480.0, current_y, current_z, 45)
		stage = 5
		wait.frames(45)
		event.set_object_sequence_motion(0, "立ち", 4, -1.0, 1)
		return 0
	end, function(received: { any })
		if stage <= 3 then
			if stage == 1 then
				choice = received[1] :: number
			end
			if stage <= 1 then
				wait.frames_skipping(15)
			end
			if stage <= 2 then
				wait.frames_skipping(30)
			end
			return 1
		end
		if stage <= 5 then
			if stage <= 4 then
				wait.frames_skipping(45)
			end
			return 0
		end
		return nil
	end)
end

--- Shows the note from Ferdinand about the cancelled party when the matching quest request is active.
local function show_party_cancelled_note()
	local request_status: s32 = 0
	local note_counter: s32 = 0
	request_status = event.get_quest_request_status(0, 8) or request_status
	if request_status == 1 then
		note_counter = event.get_save_counter(12) or note_counter
		if 0 < note_counter then
			if note_counter == 1 then
				event.set_save_counter(12, 2)
			end
			character.turn_to_rotation(0, vm.f32(-1.57))
			message.set_window_mode(0, 1)
			event.open_message_window_2(
				0,
				'Hier steht etwas:<page>"Die Party f[UNI00e4]llt leider aus,\n weil der K[UNI00e4]se zu fl[UNI00fc]ssig ist.\n                          Ferdinand"'
			)
			message.show(0, -1, 5, 256, 208)
			event.request_town_edit_event(1)
			vm.wait(3)
		end
	end
end

--- Plays the dawn cutscene, repositions the player and enters the interior i01h01.
local function cutscene_dawn_then_enter_house()
	event.set_function_point_enabled("p01_e01g01-0", "invent_36-0", 1)
	palm_brinks_town.play_dawn_cutscene()
	event.set_camera_position(345.12, 84.74, -31.95)
	event.set_camera_look_at(351.66, 70.52, 137.18)
	event.set_character_position(0, 350.13, 52.0, 148.02)
	event.set_character_rotation(0, 0.0, -3.12, 0.0)
	event.skip_next_music_play()
	vm.wait(2)
	event.go_to_interior_map(-1, "i01h01", 500, 1)
	vm.wait(3)
end

local script: { [any]: (...any) -> ...any } = {}

--- Does nothing at load time.
function script.setup() end

--- Event 99, which map data, a script or the engine runs by number.
script[99] = palm_brinks_town.refresh_bridge_state

--- Places the player and restores music according to how the map was entered, and plays the chapter eight opening after a load when its flags are set.
function script.default_event()
	local memory_card_loaded: s32 = 0
	local cutscene_ready_flag: s32 = 0
	local cutscene_done_flag: s32 = 0
	local default_music_number: s32 = 0
	local exit_index: s32 = 0
	local required_flag: s32 = 0
	local blocking_flag: s32 = 0
	local music_switched_flag: s32 = 0
	local active_music_number: s32 = 0
	local old_map_no: s32 = 0
	local old_map_type: s32 = 0
	local needs_default_spawn: s32 = 0
	local spawn_override_flag: s32 = 0
	local previous_interior_map_no: s32 = 0
	palm_brinks_town.refresh_bridge_state()
	memory_card_loaded = event.take_memory_card_load_state() or memory_card_loaded
	if memory_card_loaded == 1 then
		cutscene_ready_flag = event.get_save_flag(736) or cutscene_ready_flag
		cutscene_done_flag = event.get_save_flag(800) or cutscene_done_flag
		if cutscene_ready_flag == 1 and cutscene_done_flag == 0 then
			event.fade_out_screen(0)
			palm_brinks_town.play_e800_cutscene()
			event.set_save_data_value(0, 10)
			event.stop_all_sounds()
			event.set_sound_reverb_enabled(0)
			event.show_chapter_title(8)
			vm.wait(2)
			event.set_sound_reverb_enabled(1)
			event.load_map_sounds(1000)
			default_music_number = event.get_default_music_number(10) or default_music_number
			event.load_music(default_music_number)
			event.play_music(0)
			event.set_music_volume_follows_time_of_day(1)
			event.set_character_position(0, 1640.0, -48.8, -1700.0)
			event.set_character_rotation(0, 0.0, 0.0, 0.0)
			event.reset_follow_camera(1, 0.0, 10.0)
			event.fade_in_screen(30)
			return
		end
		exit_index = event.get_save_counter(4) or exit_index
		if exit_index == 0 then
			event.set_character_position(0, 560.0, 4.1, 120.0)
			event.set_character_rotation(0, 0.0, 3.14, 0.0)
		end
		if exit_index == 1 then
			event.set_character_position(0, 2095.0, 0.0, 2100.0)
			event.set_character_rotation(0, 0.0, 0.0, 0.0)
		end
		if exit_index == 2 then
			event.set_character_position(0, -4260.0, 350.0, 2810.0)
			event.set_character_rotation(0, 0.0, 2.86, 0.0)
		end
		if exit_index == 3 then
			event.set_character_position(0, -3770.0, 359.4, -1640.0)
			event.set_character_rotation(0, 0.0, 1.57, 0.0)
		end
		event.set_character_motion(0, "立ち", 4)
		event.update_character_motion(0)
		event.reset_character_cloth_and_hair(0)
		event.reset_follow_camera(1, 0.0, 20.0)
	else
		required_flag = event.get_save_flag(105) or required_flag
		blocking_flag = event.get_save_flag(109) or blocking_flag
		music_switched_flag = event.get_save_flag(56) or music_switched_flag
		if required_flag ~= 0 and blocking_flag == 0 and music_switched_flag == 0 then
			event.get_active_music_number(active_music_number)
			event.get_music_master_volume()
			if active_music_number ~= 10 then
				event.fade_out_screen(0)
				event.load_map_sounds(1000)
				active_music_number = event.get_default_music_number(10) or active_music_number
				event.stop_music(0)
				wait.frames(4)
				event.load_music(active_music_number)
				event.play_music(0)
				event.set_save_flag(56, 1)
				event.set_music_volume_follows_time_of_day(1)
				event.fade_in_screen(30)
			end
		end
		old_map_no = event.get_previous_map() or old_map_no
		old_map_type = event.get_map_type(old_map_no) or old_map_type
		if old_map_type ~= -1 then
			if old_map_type == 7 or old_map_type == 8 then
				character.place_standing_and_reset_cloth(vm.f32(-4197.9), 350.0, 2835.5, vm.f32(3.14))
				event.reset_follow_camera(1, 0.0, 10.0)
			else
				needs_default_spawn = 1
				spawn_override_flag = event.get_save_flag(40) or spawn_override_flag
				if spawn_override_flag == 1 then
					if old_map_no == 34 then
						needs_default_spawn = 0
						event.set_character_position(0, 1645.1, -41.3, -1812.6)
						event.set_character_rotation(0, 0.0, -0.09, 0.0)
						event.reset_follow_camera(1)
					end
					if old_map_no == 22 then
						needs_default_spawn = 0
						palm_brinks_town.place_player_at_entrance_a()
					end
				end
				previous_interior_map_no = event.get_previous_interior_map() or previous_interior_map_no
				if 0 <= previous_interior_map_no then
					needs_default_spawn = 0
				elseif old_map_no == 121 then
					needs_default_spawn = 0
					event.set_character_position(0, 1450.0, 0.0, 1420.0)
					event.set_character_rotation(0, 0.0, -1.57, 0.0)
					event.reset_follow_camera(1, 3.1415927)
				end
				if needs_default_spawn ~= 0 then
					palm_brinks_town.place_player_at_entrance_b()
				end
			end
		end
	end
	event.set_save_flag(40, 0)
	event.fade_in_screen(30)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = palm_brinks_town.start_night_walk_scene

--- Enters the interior i01h01, or shows the system message while the story progress value is 100.
function script.enter_house_i01h01()
	local story_progress: s32 = 0
	story_progress = event.get_save_data_value(0) or story_progress
	if story_progress == 100 then
		show_system_message()
		event.request_town_edit_event(1)
		vm.wait(2)
		return
	end
	event.set_character_rotation(0, 0.0, 0.0, 0.0)
	vm.wait(3)
	event.go_to_interior_map(-1, "i01h01", 100, 1)
	vm.wait(4)
end
script[200] = script.enter_house_i01h01

--- Asks to enter the contest and jumps to map s45 when accepted.
function script.enter_fishing_contest()
	local stage: number = 0
	return vm.guard(function()
		print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaa\n")
		stage = 1
		if confirm_fishing_contest_entry() ~= 0 then
			print("bbbbbbbbbbbbbbbbbbbbbbbbbbb\n")
			event.fade_out_screen(0)
			stage = 2
			vm.wait(2)
			event.jump_to_map_2(-1, "s45")
			return
		end
		print("ccccccccccccccccccccccccccc\n")
		return
	end, function(received: { any })
		if stage <= 2 then
			if stage == 1 then
				local _ = received[1] :: number
			end
			if stage <= 1 then
				print("bbbbbbbbbbbbbbbbbbbbbbbbbbb\n")
			end
			return 0
		end
		return nil
	end)
end
script[201] = script.enter_fishing_contest

--- Jumps to the interior i02h01, or shows the system message while the story progress value is 100.
function script.enter_house_i02h01()
	local story_progress: s32 = 0
	story_progress = event.get_save_data_value(0) or story_progress
	if story_progress == 100 then
		show_system_message()
		event.request_town_edit_event(1)
		vm.wait(2)
		return
	end
	event.jump_to_map_2(-1, "i02h01")
	vm.wait(3)
end
script[204] = script.enter_house_i02h01

--- Shows the system message while the story progress value is 100, otherwise does nothing.
function script.examine_door_210()
	local story_progress: s32 = 0
	story_progress = event.get_save_data_value(0) or story_progress
	if story_progress == 100 then
		show_system_message()
		event.request_town_edit_event(1)
		vm.wait(2)
	end
end
script[210] = script.examine_door_210

--- Event 211, which map data, a script or the engine runs by number.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing.
function script.ignore_event_211() end
script[211] = script.ignore_event_211

--- Event 212, which map data, a script or the engine runs by number.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing.
function script.ignore_event_212() end
script[212] = script.ignore_event_212

--- Event 213, which map data, a script or the engine runs by number.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing.
function script.ignore_event_213() end
script[213] = script.ignore_event_213

--- Shows the system message while the story progress value is 100, otherwise does nothing.
function script.examine_door_214()
	local story_progress: s32 = 0
	story_progress = event.get_save_data_value(0) or story_progress
	if story_progress == 100 then
		show_system_message()
		event.request_town_edit_event(1)
		vm.wait(2)
	end
end
script[214] = script.examine_door_214

--- Shows the system message while the story progress value is 100, otherwise does nothing.
function script.examine_door_215()
	local story_progress: s32 = 0
	story_progress = event.get_save_data_value(0) or story_progress
	if story_progress == 100 then
		show_system_message()
		event.request_town_edit_event(1)
		vm.wait(2)
	end
end
script[215] = script.examine_door_215

--- Shows the system message while the story progress value is 100, otherwise does nothing.
function script.examine_door_216()
	local story_progress: s32 = 0
	story_progress = event.get_save_data_value(0) or story_progress
	if story_progress == 100 then
		show_system_message()
		event.request_town_edit_event(1)
		vm.wait(2)
	end
end
script[216] = script.examine_door_216

--- Event 217, which map data, a script or the engine runs by number.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing.
function script.ignore_event_217() end
script[217] = script.ignore_event_217

--- Shows the system message while the story progress value is 100, otherwise does nothing.
function script.examine_door_218()
	local story_progress: s32 = 0
	story_progress = event.get_save_data_value(0) or story_progress
	if story_progress == 100 then
		show_system_message()
		event.request_town_edit_event(1)
		vm.wait(2)
	end
end
script[218] = script.examine_door_218

--- Shows the system message while the story progress value is 100, otherwise does nothing.
function script.examine_door_219()
	local story_progress: s32 = 0
	story_progress = event.get_save_data_value(0) or story_progress
	if story_progress == 100 then
		show_system_message()
		event.request_town_edit_event(1)
		vm.wait(2)
	end
end
script[219] = script.examine_door_219

--- Shows the system message while the story progress value is 100, otherwise does nothing.
function script.examine_door_220()
	local story_progress: s32 = 0
	story_progress = event.get_save_data_value(0) or story_progress
	if story_progress == 100 then
		show_system_message()
		event.request_town_edit_event(1)
		vm.wait(2)
	end
end
script[220] = script.examine_door_220

--- Shows the system message while the story progress value is 100, otherwise does nothing.
function script.examine_door_221()
	local story_progress: s32 = 0
	story_progress = event.get_save_data_value(0) or story_progress
	if story_progress == 100 then
		show_system_message()
		event.request_town_edit_event(1)
		vm.wait(2)
	end
end
script[221] = script.examine_door_221

--- Shows the system message while the story progress value is 100, otherwise reads the party-cancelled note.
function script.examine_party_cancelled_note()
	local story_progress: s32 = 0
	story_progress = event.get_save_data_value(0) or story_progress
	if story_progress == 100 then
		show_system_message()
		event.request_town_edit_event(1)
		vm.wait(2)
	else
		show_party_cancelled_note()
	end
end
script[222] = script.examine_party_cancelled_note

--- Shows the system message while the story progress value is 100 and skips the next music load when the e305 flags are set.
function script.examine_door_223()
	local story_progress: s32 = 0
	local cutscene_ready_flag: s32 = 0
	local cutscene_done_flag: s32 = 0
	story_progress = event.get_save_data_value(0) or story_progress
	if story_progress == 100 then
		show_system_message()
		event.request_town_edit_event(1)
		vm.wait(2)
	end
	cutscene_ready_flag = event.get_save_flag(304) or cutscene_ready_flag
	cutscene_done_flag = event.get_save_flag(305) or cutscene_done_flag
	if cutscene_ready_flag == 1 and cutscene_done_flag == 0 then
		event.skip_next_music_load()
	end
end
script[223] = script.examine_door_223

script.show_system_message = show_system_message
script[248] = script.show_system_message

--- Confirms entry, opens the dungeon floor menu and starts the chosen dungeon floor.
function script.enter_dungeon_gate()
	local unlocked_flag: s32 = 0
	local floor: s32 = 0
	unlocked_flag = event.get_save_flag(800) or unlocked_flag
	if unlocked_flag == 0 then
		return
	end
	if palm_brinks_town.confirm_dungeon_entry_160() ~= 0 then
		event.set_dungeon_stage_id(6)
		event.open_event_menu(3, 6)
		vm.wait(2)
		do
			local _, _, out3, _ = event.get_menu_results_4()
			floor = out3 or floor
		end
		if floor == 0 then
			event.fade_in_screen(30)
			return
		else
			if floor == 37 then
				event.skip_next_music_load()
			end
			event.go_to_dungeon(6, floor, 1010)
		end
	end
end
script[290] = script.enter_dungeon_gate

--- Stores the exit the player took and opens the event menu.
function script.open_menu_at_exit()
	local exit_index: s32 = 0
	exit_index = event.get_triggered_event_data_2(15) or exit_index
	event.set_save_counter(4, exit_index)
	menu.open_with_fade()
end
script[400] = script.open_menu_at_exit

--- Shows the remark about boarding the train without permission, or the Blinkhorn reminder on the first visit.
function script.examine_train_without_permission()
	local active_character: s32 = 0
	local quest_counter: s32 = 0
	event.set_character_motion(0, "立ち")
	event.set_message_window_mode(0, 1)
	event.set_message_bubble_tail(0, 0)
	active_character = event.get_playable_character() or active_character
	quest_counter = event.get_save_counter(7) or quest_counter
	if active_character == 0 and quest_counter == 1 then
		event.set_save_counter(7, 2)
		event.open_message_window_2(0, "Gut! Jetzt schnell zu\nSheriff Blinkhorn.")
	else
		event.open_message_window_2(0, "Ob ich wohl [UNI00c4]rger kriege, wenn\nich ohne Erlaubnis weitergehe?")
	end
	message.show(0, -1, 5, 256, 208)
	event.set_message_bubble_tail(0, 1)
end
script[401] = script.examine_train_without_permission

--- Confirms entry and jumps to the dungeon map d01e01.
function script.enter_dungeon_d01e01()
	if palm_brinks_town.confirm_dungeon_entry_55() ~= 0 then
		event.jump_to_map_3(-1, "d01e01", 100)
	end
end
script[510] = script.enter_dungeon_d01e01

script.cutscene_dawn_then_enter_house = cutscene_dawn_then_enter_house
script[530] = script.cutscene_dawn_then_enter_house

--- Fades out, repositions the player and re-enters the interior i01h01 after losing to the elephant.
function script.on_lost_to_elephant()
	local stage: number = 0
	return vm.guard(function()
		event.fade_out_screen(0)
		event.set_camera_position(345.12, 84.74, -31.95)
		event.set_camera_look_at(351.66, 70.52, 137.18)
		event.set_character_position(0, 350.13, 52.0, 148.02)
		event.set_character_rotation(0, 0.0, -3.12, 0.0)
		print("ぞうにまけた---------------------\n")
		stage = 1
		vm.wait(1)
		event.go_to_interior_map(-1, "i01h01", 510, 1)
		stage = 2
		vm.wait(2)
		print("じゃんぷ------------------\n")
		return
	end, function(received: { any })
		if stage <= 2 then
			print("じゃんぷ------------------\n")
			return 0
		end
		return nil
	end)
end
script[531] = script.on_lost_to_elephant

--- Plays the Starbre walk cutscene and jumps to the interior i03h01a without reloading the music.
function script.cutscene_starbre_walk_keep_music()
	palm_brinks_town.play_starbre_walk_cutscene()
	event.skip_villager_loading()
	event.skip_next_music_load()
	event.jump_to_map_3(-1, "i03h01a", 500)
	vm.wait(2)
end
script[540] = script.cutscene_starbre_walk_keep_music

--- Has the two guards warn the player away from the restricted area and moves the player back unless the story progress value is 100.
function script.talk_to_gate_guards()
	local story_progress: s32 = 0
	local first_guard_slot: s32 = 0
	local second_guard_slot: s32 = 0
	story_progress = event.get_save_data_value(0) or story_progress
	if story_progress == 100 then
		return
	end
	event.set_camera_position(1300.0, 50.0, 763.0)
	event.set_camera_look_at(1300.0, 30.0, 968.18)
	event.set_character_motion(0, "立ち")
	first_guard_slot = event.find_scene_character_slot(50) or first_guard_slot
	second_guard_slot = vm.i32(first_guard_slot + 1)
	event.set_villager_ai_enabled(0, second_guard_slot)
	event.set_villager_ai_enabled(0, first_guard_slot)
	event.open_message_window_2(0, "Hey! Ab hier\nist abgesperrt.")
	cutscene.talk_to_character(first_guard_slot, -1, 0, 0)
	event.open_message_window_2(0, "Wenn du wei[UNI00df]t, was gut f[UNI00fc]r\ndich ist, kehrst du um.")
	cutscene.talk_to_character(second_guard_slot, -1, 0, 0)
	event.fade_out_screen(20)
	wait.frames(20)
	event.set_character_position(0, 1302, 0, 951)
	event.set_character_rotation(0, 0, 3.14, 0)
	event.set_villager_ai_enabled(1, second_guard_slot)
	event.set_villager_ai_enabled(1, first_guard_slot)
	event.fade_in_screen(20)
end
script[550] = script.talk_to_gate_guards

--- Event 560, which map data, a script or the engine runs by number.
script[560] = palm_brinks_town.refresh_bridge_state

--- Talks to the triggered villager unless the story progress value is 100.
function script.talk_to_villager()
	local story_progress: s32 = 0
	story_progress = event.get_save_data_value(0) or story_progress
	if story_progress == 100 then
		return
	end
	villager_dialogue.talk_to_triggered_villager()
end
script[1000] = script.talk_to_villager

--- Event 11051, which map data, a script or the engine runs by number.
script[11051] = script.cutscene_dawn_then_enter_house

--- Resets save flag 105 and the story progress value and re-enters the interior i01h01 to replay the Steve scene.
function script.reenter_i01h01_11052()
	event.set_save_flag(105, 0)
	event.set_save_data_value(0, 3)
	vm.wait(1)
	event.go_to_interior_map(-1, "i01h01", 11052, 1)
	vm.wait(2)
end
script[11052] = script.reenter_i01h01_11052

--- Resets save flag 105 and the story progress value and re-enters the interior i01h01 to replay the Steve scene.
function script.reenter_i01h01_11053()
	event.set_save_flag(105, 0)
	event.set_save_data_value(0, 3)
	vm.wait(1)
	event.go_to_interior_map(-1, "i01h01", 11053, 1)
	vm.wait(2)
end
script[11053] = script.reenter_i01h01_11053

--- Sets story flags and re-enters the interior i01h01 to replay the Steve scene.
function script.reenter_i01h01_11060()
	event.set_save_flag(103, 1)
	event.set_save_flag(106, 0)
	event.set_save_flag(107, 0)
	event.set_save_data_value(0, 3)
	vm.wait(1)
	event.go_to_interior_map(-1, "i01h01", 11060, 1)
	vm.wait(2)
end
script[11060] = script.reenter_i01h01_11060

--- Plays the Starbre walk cutscene and jumps to the interior i03h01a.
function script.cutscene_starbre_walk_then_enter_house()
	palm_brinks_town.play_starbre_walk_cutscene()
	event.skip_villager_loading()
	vm.wait(2)
	event.jump_to_map_3(-1, "i03h01a", 500)
	vm.wait(3)
end
script[11091] = script.cutscene_starbre_walk_then_enter_house

--- Plays the chapter eight opening and restarts the town music at the new spawn.
function script.cutscene_chapter_eight_start()
	palm_brinks_town.play_e800_cutscene()
	event.set_save_data_value(0, 10)
	event.stop_all_sounds()
	event.set_sound_reverb_enabled(0)
	event.show_chapter_title(8)
	vm.wait(2)
	event.set_sound_reverb_enabled(1)
	event.load_music(0)
	event.load_map_sounds(1000)
	event.play_music(0)
	event.set_character_position(0, 1640.0, -48.8, -1700.0)
	event.set_character_rotation(0, 0.0, 0.0, 0.0)
	event.reset_follow_camera(1, 0.0, 10.0)
	event.fade_in_screen(30)
end
script[18000] = script.cutscene_chapter_eight_start

return script
