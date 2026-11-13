--!strict
--- Event script for the Gundor boss room, covering the horn gate, the Guiltoni awakening, growth, sword fight and explosion cutscenes, and the boss battle setup and defeat dialogue.

local vm = require("@lib/vm")
local character = require("@lib/event/character")
local cutscene = require("@lib/event/cutscene")
local dungeon = require("@lib/event/dungeon")
local menu = require("@lib/event/menu")
local message = require("@lib/event/message")
local mount_gundor_boss = require("@lib/event/mount_gundor_boss")
local wait = require("@lib/event/wait")

--- Stops the music and shows or hides the gate, tower parts and function points according to the story save flags.
local function refresh_boss_room_scene()
	local flag: s32 = 0
	local flag_2: s32 = 0
	event.stop_music(0)
	event.load_map_sounds(5683)
	flag = event.get_save_flag(526) or flag
	if flag == 1 then
		event.set_function_point_enabled("d05", "func", 0)
		event.attach_object_handle_to_map_part_3(0, "d05", "d05ba02-a")
		event.set_object_handle_visible(0, 0)
		event.attach_object_handle_to_map_part_4(0, "d05", "d05b01_1", "takil")
		event.set_object_handle_scale(0, 0.43, 1.0, 1.0)
		event.attach_object_handle_to_map_part_4(0, "d05", "d05b01_1", "takir")
		event.set_object_handle_scale(0, 0.43, 1.0, 1.0)
		event.set_function_point_enabled("p01", "invent_2023-1", 1)
	end
	flag_2 = event.get_save_flag(528) or flag_2
	if flag_2 == 0 then
		event.attach_object_handle_to_map_part_3(0, "d05", "d05ba03-a")
		event.set_object_handle_visible(0, 1)
	else
		event.set_function_point_enabled("", "e528", 0)
	end
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded and does nothing.
function script.setup() end

script.refresh_boss_room_scene = refresh_boss_room_scene
script[99] = script.refresh_boss_room_scene

--- Refreshes the room scene and places the player at the entrance.
function script.default_event()
	event.initialize_event()
	event.fade_out_screen(0)
	refresh_boss_room_scene()
	event.take_memory_card_load_state()
	vm.wait(1)
	character.place_standing_and_reset_cloth(0.0, -30.0, 1600.0, vm.f32(3.14))
	event.set_camera_look_at(0.0, 0.0, 1600.0)
	event.set_camera_position(0.0, 10.0, 1700.0)
	event.reset_follow_camera(0)
	event.fade_in_screen(15)
	event.finish_event()
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = mount_gundor_boss.play_party_anger_event

--- Tells a non-fighting character that the gate cannot be used, otherwise asks whether to leave and returns to the overworld.
function script.talk_to_exit_gate()
	local active_character: s32 = 0
	local answer: any = 0
	event.initialize_event()
	event.reset_action_character_motion(0)
	active_character = event.get_playable_character() or active_character
	if active_character == 2 or active_character == 3 then
		event.set_message_window_mode(0, 1)
		event.set_message_draw_speed(0, 1)
		if active_character == 2 then
			message.show_and_wait(0, 20, 5, 256, 208)
		else
			message.show_and_wait(0, 21, 5, 256, 208)
		end
		event.finish_event()
		return
	end
	answer = message.ask_yes_no(2, -1)
	if answer == 0 then
		event.fade_out_screen(15)
		wait.frames(15)
		event.load_event_script("d05/d05.stb", 1000)
	end
	event.finish_event()
end
script[200] = script.talk_to_exit_gate

--- Opens the menu with a fade.
function script.open_menu()
	menu.open_with_fade()
	event.finish_event()
end
script[400] = script.open_menu

--- Lets the player confirm and use the horn item on the gate to start the horn blowing event.
function script.examine_horn_gate()
	local active_character: s32 = 0
	local trigger_state: s32 = 0
	local confirmed: s32 = 0
	local item: s32 = 0
	event.initialize_event()
	event.reset_action_character_motion(0)
	active_character = event.get_playable_character() or active_character
	if active_character == 2 or active_character == 3 then
		event.apply_message_window_preset(0, 4)
		event.set_message_window_mode(0, 4)
		event.set_message_draw_speed(0, 1)
		if active_character == 2 then
			message.show_and_wait(0, 22, 8, 0, 0)
		else
			message.show_and_wait(0, 23, 8, 0, 0)
		end
		event.set_message_window_mode(0, 1)
		event.set_message_draw_speed(0, 0)
		event.finish_event()
		return
	end
	trigger_state = event.get_triggered_event_data_2(6) or trigger_state
	if trigger_state == 1 then
		event.initialize_event()
		event.set_message_window_mode(0, 1)
		event.set_message_draw_speed(0, 1)
		confirmed = message.ask_confirmation(0, 2507, 5, 256, 208, confirmed)
		event.set_message_window_mode(0, 7)
		event.set_message_draw_speed(0, 0)
		if confirmed == 1 then
			trigger_state = 2
		end
	end
	if trigger_state == 2 then
		event.show_dungeon_status_bar(0, 0.16666667)
		wait.frames(6)
		event.open_use_item_menu(354)
		vm.wait(5)
		item = vmhost.used_item() or item
		if item == 354 then
			event.set_function_point_enabled("d05", "func", 0)
			event.attach_object_handle_to_map_part_3(0, "d05", "d05ba02-a")
			event.set_object_handle_visible(0, 0)
			event.set_function_point_enabled("p01", "invent_2023-1", 1)
			mount_gundor_boss.play_horn_blowing_event()
			return
		elseif item <= 0 then
			event.finish_event()
		else
			character.shake_head()
		end
		event.show_dungeon_status_bar(1, 0.16666667)
		wait.frames(6)
	end
	event.finish_event()
end
script[500] = script.examine_horn_gate

--- Fades out, plays the Guiltoni awakening event, then loads the second-phase boss monster and places the player in front of it.
function script.cutscene_guiltoni_awakening()
	local progress: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.reset_action_character_motion(0)
		event.set_save_control_bits(1, 1)
		event.fade_out_screen(15)
		progress = 1
		wait.frames(15)
		event.set_function_point_enabled("", "e528", 0)
		progress = 2
		mount_gundor_boss.play_guiltoni_awakening_event()
		progress = 3
		vm.wait(3)
		event.load_dungeon_monster(512, 1)
		event.place_dungeon_monster(512, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
		character.place_standing_and_reset_cloth(0.0, 0.0, 300.0, vm.f32(3.14))
		event.set_camera_look_at(0.0, 30.0, 300.0)
		event.set_camera_position(0.0, 40.0, 400.0)
		event.reset_follow_camera(0)
		event.fade_in_screen(15)
		event.finish_event()
		return
	end, function(received: { any })
		if progress <= 3 then
			if progress <= 1 then
				progress = 2
				mount_gundor_boss.play_guiltoni_awakening_event()
				return vm.continue_with(function()
					progress = 3
					vm.wait(3)
					event.load_dungeon_monster(512, 1)
					event.place_dungeon_monster(512, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
					character.place_standing_and_reset_cloth(0.0, 0.0, 300.0, vm.f32(3.14))
					event.set_camera_look_at(0.0, 30.0, 300.0)
					event.set_camera_position(0.0, 40.0, 400.0)
					event.reset_follow_camera(0)
					event.fade_in_screen(15)
					event.finish_event()
					return
				end)
			end
			cutscene.ignore_coordinates(0.0, 0.0, 300.0, vm.f32(3.14))
			return 0
		end
		return nil
	end)
end
script[550] = script.cutscene_guiltoni_awakening

--- Resets the party, plays the Guiltoni sword fight event and loads the following map.
function script.cutscene_guiltoni_sword_fight()
	local progress: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.reset_action_character_motion(0)
		event.fade_out_screen(15)
		progress = 1
		wait.frames(15)
		event.clear_event_battle_monsters(-1)
		event.set_party_member(1, 1)
		event.set_character_change_enabled(1, 1)
		event.set_character_change_unmasked(1, 1)
		event.set_party_member(3, 1)
		event.set_character_change_enabled(3, 1)
		event.set_character_change_unmasked(3, 1)
		progress = 2
		mount_gundor_boss.play_guiltoni_sword_fight_event()
		event.skip_next_music_load()
		event.load_dungeon_map("s49")
		event.load_event_script("s49/s49.stb", 500)
		return
	end, function(received: { any })
		if progress <= 2 then
			if progress <= 1 then
				progress = 2
				mount_gundor_boss.play_guiltoni_sword_fight_event()
				return vm.continue_with(function()
					event.skip_next_music_load()
					event.load_dungeon_map("s49")
					event.load_event_script("s49/s49.stb", 500)
					return
				end)
			end
			return 0
		end
		return nil
	end)
end
script[560] = script.cutscene_guiltoni_sword_fight

--- Plays the Guiltoni growth event and sets up the room with the grown boss.
function script.cutscene_guiltoni_growth()
	event.clear_event_running_flag()
	mount_gundor_boss.play_guiltoni_growth_event()
	event.set_function_point_enabled("", "e528", 0)
	event.set_function_point_enabled("d05", "func", 0)
	event.set_function_point_enabled("p01", "invent_2023-1", 1)
	event.attach_object_handle_to_map_part_3(0, "d05", "d05ba03-a")
	event.set_object_handle_visible(0, 1)
	event.attach_object_handle_to_map_part_4(0, "d05", "d05b01_1", "takil")
	event.set_object_handle_translation(0, -330.0, 0.0, 200.0)
	event.attach_object_handle_to_map_part_4(0, "d05", "d05b01_1", "takir")
	event.set_object_handle_translation(0, 330.0, 0.0, 200.0)
	event.load_dungeon_monster(511, 1)
	event.place_dungeon_monster(511, 0.0, 0.0, -200.0, 0.0, 0.0, 0.0)
	event.set_character_position(0, 0.0, 0.0, 300.0)
	event.set_character_rotation(0, 0.0, 3.14, 0.0)
	event.set_character_motion(0, "立ち", 4)
	event.set_camera_position(0.0, 40.0, 420.0)
	event.set_camera_look_at(0.0, 30.0, 300.0)
	event.reset_follow_camera(0)
	event.fade_in_screen(15)
	event.finish_event()
end
script[561] = script.cutscene_guiltoni_growth

--- Fades out the music and screen, plays the Guiltoni explosion event and loads the following map.
function script.cutscene_guiltoni_explosion()
	local progress: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.reset_action_character_motion(0)
		event.fade_out_music(0)
		event.fade_out_screen(15)
		progress = 1
		wait.frames(15)
		event.stop_music(0)
		event.clear_event_battle_monsters(-1)
		progress = 2
		mount_gundor_boss.play_guiltoni_explosion_event()
		event.set_dungeon_floor_info(4, 22, 5, 2)
		event.skip_next_music_load()
		event.load_dungeon_map("s49")
		event.load_event_script("s49/s49.stb", 510)
		return
	end, function(received: { any })
		if progress <= 2 then
			if progress <= 1 then
				progress = 2
				mount_gundor_boss.play_guiltoni_explosion_event()
				return vm.continue_with(function()
					event.set_dungeon_floor_info(4, 22, 5, 2)
					event.skip_next_music_load()
					event.load_dungeon_map("s49")
					event.load_event_script("s49/s49.stb", 510)
					return
				end)
			end
			return 0
		end
		return nil
	end)
end
script[570] = script.cutscene_guiltoni_explosion

--- Plays the party anger event and opens the georama editor.
function script.cutscene_party_anger_then_georama()
	event.set_save_control_bits(1, 0)
	event.clear_event_running_flag()
	mount_gundor_boss.play_party_anger_event()
	event.go_to_georama_edit(3, 500)
end
script[571] = script.cutscene_party_anger_then_georama

--- Starts the battle music and places the first-phase boss monster.
function script.start_first_boss_battle()
	event.initialize_event()
	vm.wait(1)
	event.stop_music(0)
	wait.frames(4)
	event.load_music(35)
	event.play_music(0)
	event.set_function_point_enabled("d05", "func", 0)
	event.set_function_point_enabled("", "e528", 0)
	event.load_dungeon_monster(511, 1)
	event.place_dungeon_monster(511, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
	event.finish_event()
end
script[600] = script.start_first_boss_battle

--- Plays a random defeat dialogue chosen by the story progress flags.
function script.on_party_defeated()
	local roll: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local progress: number = 0
	return vm.guard(function()
		flag = event.get_save_flag(532) or flag
		flag_2 = event.get_save_flag(536) or flag_2
		if flag ~= 0 and flag_2 == 0 then
			roll = 0
			roll = event.get_random_number_int(100) or roll
			if roll < 50 then
				progress = 1
				dungeon.handle_defeat_with_dialogue_voiced(0, 8540060)
			else
				progress = 2
				dungeon.handle_defeat_with_dialogue_voiced(0, 8540070)
			end
			return
		end
		flag_3 = event.get_save_flag(528) or flag_3
		if flag_3 ~= 0 and flag == 0 then
			roll = 0
			roll = event.get_random_number_int(100) or roll
			if roll < 50 then
				progress = 3
				dungeon.handle_defeat_with_dialogue_voiced(0, 8530100)
			else
				progress = 4
				dungeon.handle_defeat_with_dialogue_voiced(0, 8530110)
			end
			return
		end
		progress = 5
		dungeon.handle_defeat_with_dialogue_silent(0)
		return
	end, function(received: { any })
		if progress <= 2 then
			if progress <= 1 then
				dungeon.skip_defeat_dialogue_sequence_voiced(0, 8540070)
			end
			return 0
		end
		if progress <= 4 then
			if progress <= 3 then
				dungeon.skip_defeat_dialogue_sequence_voiced(0, 8530110)
			end
			return 0
		end
		if progress <= 5 then
			return 0
		end
		return nil
	end)
end
script[1200] = script.on_party_defeated

--- Stops the music and plays the horn blowing event.
function script.skip_horn_blowing()
	event.stop_music(0)
	mount_gundor_boss.play_horn_blowing_event()
end
script[15260] = script.skip_horn_blowing

--- Event 15280, which map data, a script or the engine runs by number.
script[15280] = mount_gundor_boss.play_guiltoni_awakening_event

--- Plays the Guiltoni sword fight event and loads the following map.
function script.skip_guiltoni_sword_fight()
	mount_gundor_boss.play_guiltoni_sword_fight_event()
	event.skip_next_music_load()
	event.load_dungeon_map("s49")
	event.load_event_script("s49/s49.stb", 500)
end
script[15320] = script.skip_guiltoni_sword_fight

--- Plays the Guiltoni explosion event and loads the following map.
function script.skip_guiltoni_explosion()
	mount_gundor_boss.play_guiltoni_explosion_event()
	event.skip_next_music_load()
	event.load_dungeon_map("s49")
	event.load_event_script("s49/s49.stb", 510)
end
script[15360] = script.skip_guiltoni_explosion

--- Starts the second battle music and places the second-phase boss monster.
function script.start_second_boss_battle()
	event.initialize_event()
	vm.wait(1)
	event.stop_music(0)
	wait.frames(4)
	event.load_music(190)
	event.play_music(0)
	event.set_function_point_enabled("", "e528", 0)
	event.load_dungeon_monster(512, 1)
	event.place_dungeon_monster(512, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
	event.finish_event()
end
script[25020] = script.start_second_boss_battle

return script
