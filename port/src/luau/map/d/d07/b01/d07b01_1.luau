--!strict
--- Event script for the Zelmite Mine boss floor, covering the blocking rock, the boss battle setup, the defeat dialogue and the ending scene.

local vm = require("@lib/vm")
local character = require("@lib/event/character")
local cutscene = require("@lib/event/cutscene")
local dungeon = require("@lib/event/dungeon")
local message = require("@lib/event/message")
local wait = require("@lib/event/wait")
local zelmite_mine_boss = require("@lib/event/zelmite_mine_boss")

--- Stops the music, loads the map sounds and removes the blocking rock once the boss has been defeated.
local function initialize_boss_room()
	local boss_defeated_flag: s32 = 0
	event.stop_music(0)
	event.load_map_sounds(8693)
	boss_defeated_flag = event.get_save_flag(820) or boss_defeated_flag
	if boss_defeated_flag == 1 then
		event.attach_object_handle_to_map_part_2(0, "p04")
		event.set_object_handle_visible(0, 0)
		event.set_function_point_enabled("p04", "func", 0)
	end
end

--- Shows the boss arena, plays the battle music and places the player and the boss monster.
local function start_boss_battle()
	event.initialize_event()
	event.fade_out_screen(0)
	event.attach_object_handle_to_map_part_2(0, "p06")
	event.set_object_handle_visible(0, 1)
	event.stop_music(0)
	wait.frames(6)
	event.load_music(40)
	event.play_music(0)
	event.load_dungeon_monster(629, 1)
	event.load_dungeon_monster(630, 0)
	event.place_dungeon_monster(629, -513.2, 9.0, -127.2, 0.0, 1.25, 0.0)
	character.place_standing(vm.f32(438.61), 0.0, vm.f32(192.19), vm.f32(-1.89))
	event.set_camera_look_at(438.61, 30.0, 192.19)
	event.set_camera_position(590.29, 39.11, 243.1)
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
	vm.wait(2)
	event.finish_event()
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded; nothing needs preparing.
function script.setup() end

script.initialize_boss_room = initialize_boss_room
script[99] = script.initialize_boss_room

--- Places the player at the floor entrance and fades in.
function script.default_event()
	initialize_boss_room()
	character.place_standing(vm.f32(972.08), vm.f32(-72.14), vm.f32(1770.23), vm.f32(-2.36))
	event.set_camera_look_at(972.08, -42.14, 1770.23)
	event.set_camera_position(1061.01, -40.06, 1860.38)
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
	event.finish_event()
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
-- Defined empty, so the engine runs this instead of its default.
--- Overrides the square-button event with nothing.
function script.key_open() end

--- Event 151, which map data, a script or the engine runs by number.
script.start_boss_battle = start_boss_battle
script[151] = script.start_boss_battle

--- Moves the camera look-at to the origin and waits until the button is pressed.
function script.reset_camera_and_wait_for_button()
	event.set_camera_look_at(0.0, 0.0, 0.0)
	vm.wait(1)
	wait.until_button_pressed(64)
end
script[152] = script.reset_camera_and_wait_for_button

--- Asks whether to return to the dungeon floors and loads them on a yes.
function script.ask_leave_boss_floor()
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
		event.fade_out_screen(30)
		wait.frames(30)
		event.load_event_script("d07/d07.stb", 1000)
	else
		event.finish_event()
	end
end
script[300] = script.ask_leave_boss_floor

--- Examines the rock in the way, lets the player use the buggy item on it and starts the boss battle when it works.
function script.examine_blocking_rock()
	local active_character: s32 = 0
	local interaction_state: s32 = 0
	local confirmed: s32 = 0
	local used_item: s32 = 0
	local resume_point: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.reset_action_character_motion(0)
		active_character = event.get_playable_character() or active_character
		if active_character == 2 or active_character == 3 then
			event.set_message_window_mode(0, 1)
			event.set_message_draw_speed(0, 1)
			if active_character == 2 then
				resume_point = 1
				message.show_and_wait(0, 20, 5, 256, 208)
			else
				resume_point = 2
				message.show_and_wait(0, 21, 5, 256, 208)
			end
			event.finish_event()
			return
		end
		event.reset_action_character_motion(0)
		interaction_state = event.get_triggered_event_data_2(6) or interaction_state
		if interaction_state == 1 then
			event.set_message_window_mode(0, 1)
			event.set_message_bubble_tail(0, 0)
			event.set_message_draw_speed(0, 1)
			event.open_message_window_2(0, "Hay una roca en el camino.\n(Usa (#) para abrir el men[UNI00fa].)")
			resume_point = 3
			confirmed = message.ask_confirmation(0, -1, 5, 256, 208, confirmed)
			event.set_message_bubble_tail(0, 1)
			event.set_message_draw_speed(0, 0)
			if confirmed == 1 then
				interaction_state = 2
			end
		end
		if interaction_state == 2 then
			event.show_dungeon_status_bar(0, 0.16666667)
			resume_point = 4
			wait.frames(6)
			event.open_use_item_menu(173)
			resume_point = 5
			vm.wait(5)
			used_item = vmhost.used_item() or used_item
			if used_item == 173 then
				event.fade_out_music(20)
				event.fade_out_screen(20)
				resume_point = 6
				wait.frames(20)
				event.set_function_point_enabled("p04", "func", 0)
				resume_point = 7
				zelmite_mine_boss.play_buggy_explosion_scene()
				resume_point = 8
				vm.wait(8)
				event.initialize_event()
				event.attach_object_handle_to_map_part_2(0, "p05")
				event.set_object_handle_visible(0, 1)
				event.attach_object_handle_to_map_part_2(1, "p06")
				event.set_object_handle_visible(1, 1)
				event.set_save_control_bits(1, 1)
				event.load_dungeon_monster(629, 1)
				event.load_dungeon_monster(630, 0)
				event.place_dungeon_monster(629, -513.2, 9.0, -127.2, 0.0, 1.25, 0.0)
				character.place_standing(vm.f32(438.61), 0.0, vm.f32(192.19), vm.f32(-1.89))
				event.set_camera_look_at(438.61, 30.0, 192.19)
				event.set_camera_position(590.29, 39.11, 243.1)
				event.reset_follow_camera(0)
				event.fade_in_screen(30)
				event.finish_event()
			elseif used_item <= 0 then
			else
				resume_point = 9
				character.shake_head()
			end
			event.show_dungeon_status_bar(1, 0.16666667)
			resume_point = 10
			wait.frames(6)
		end
		event.set_dungeon_pause_flags(1, 0)
		event.finish_event()
		return
	end, function(received: { any })
		if resume_point <= 2 then
			if resume_point <= 1 then
				message.show_and_wait_skipping(0, 21, 5, 256, 208)
			end
			return 0
		end
		if resume_point <= 10 then
			if resume_point == 3 then
				confirmed = received[2] :: number
			end
			if resume_point <= 3 then
				local _ = interaction_state == 1
				interaction_state = 2
				wait.frames_skipping(6)
			end
			if resume_point <= 5 then
				wait.frames_skipping(20)
			end
			if resume_point <= 6 then
				resume_point = 7
				zelmite_mine_boss.play_buggy_explosion_scene()
				return vm.continue_with(function()
					resume_point = 8
					vm.wait(8)
					event.initialize_event()
					event.attach_object_handle_to_map_part_2(0, "p05")
					event.set_object_handle_visible(0, 1)
					event.attach_object_handle_to_map_part_2(1, "p06")
					event.set_object_handle_visible(1, 1)
					event.set_save_control_bits(1, 1)
					event.load_dungeon_monster(629, 1)
					event.load_dungeon_monster(630, 0)
					event.place_dungeon_monster(629, -513.2, 9.0, -127.2, 0.0, 1.25, 0.0)
					character.place_standing(vm.f32(438.61), 0.0, vm.f32(192.19), vm.f32(-1.89))
					event.set_camera_look_at(438.61, 30.0, 192.19)
					event.set_camera_position(590.29, 39.11, 243.1)
					event.reset_follow_camera(0)
					event.fade_in_screen(30)
					event.finish_event()
					event.show_dungeon_status_bar(1, 0.16666667)
					resume_point = 10
					wait.frames(6)
					event.set_dungeon_pause_flags(1, 0)
					event.finish_event()
					return
				end)
			end
			if resume_point <= 8 then
				cutscene.ignore_coordinates(vm.f32(438.61), 0.0, vm.f32(192.19), vm.f32(-1.89))
				character.resume_shake_head()
			end
			if resume_point <= 9 then
				wait.frames_skipping(6)
			end
			return 0
		end
		return nil
	end)
end
script[500] = script.examine_blocking_rock

--- Clears the battle, hides the arena and plays the boss defeat, shrink and ending scenes.
function script.cutscene_boss_defeated_ending()
	local active_character: s32 = 0
	local resume_point: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.reset_action_character_motion(0)
		event.fade_out_music(20)
		event.fade_out_screen(20)
		resume_point = 1
		wait.frames(20)
		event.clear_event_battle_monsters(-1)
		active_character = event.get_playable_character() or active_character
		if active_character == 2 then
			event.switch_dungeon_main_character(0)
		end
		if active_character == 3 then
			event.switch_dungeon_main_character(1)
		end
		event.attach_object_handle_to_map_part_2(0, "p05")
		event.set_object_handle_visible(0, 0)
		event.attach_object_handle_to_map_part_2(1, "p06")
		event.set_object_handle_visible(1, 0)
		event.set_save_control_bits(1, 0)
		resume_point = 2
		zelmite_mine_boss.play_majin_shrink_scene()
		resume_point = 3
		zelmite_mine_boss.play_ending_movie()
		event.set_scene_exit_flag(1)
		return
	end, function(received: { any })
		if resume_point <= 3 then
			if resume_point <= 1 then
				resume_point = 2
				zelmite_mine_boss.play_majin_shrink_scene()
				return vm.continue_with(function()
					resume_point = 3
					zelmite_mine_boss.play_ending_movie()
					event.set_scene_exit_flag(1)
					return
				end)
			end
			if resume_point <= 2 then
				zelmite_mine_boss.wait_after_ending()
			end
			return 0
		end
		return nil
	end)
end
script[510] = script.cutscene_boss_defeated_ending

--- Picks the defeat dialogue by progress flags and a random roll.
function script.on_defeat_dialogue()
	local progress_flag: s32 = 0
	local boss_defeated_flag: s32 = 0
	local random_roll: s32 = 0
	local resume_point: number = 0
	return vm.guard(function()
		progress_flag = event.get_save_flag(816) or progress_flag
		boss_defeated_flag = event.get_save_flag(820) or boss_defeated_flag
		if progress_flag ~= 0 and boss_defeated_flag == 0 then
			random_roll = 0
			random_roll = event.get_random_number_int(100) or random_roll
			if random_roll < 50 then
				resume_point = 1
				dungeon.handle_defeat_with_dialogue_voiced(0, 8600060)
			else
				resume_point = 2
				dungeon.handle_defeat_with_dialogue_voiced(0, 8600070)
			end
			return
		end
		resume_point = 3
		dungeon.handle_defeat_with_dialogue_silent(0)
		return
	end, function(received: { any })
		if resume_point <= 2 then
			if resume_point <= 1 then
				dungeon.skip_defeat_dialogue_sequence_voiced(0, 8600070)
			end
			return 0
		end
		if resume_point <= 3 then
			return 0
		end
		return nil
	end)
end
script[1200] = script.on_defeat_dialogue

--- Event 18160, which map data, a script or the engine runs by number.
script[18160] = zelmite_mine_boss.play_buggy_explosion_scene

--- Plays the majin shrink scene, the ending movie and then ends the scene.
function script.cutscene_majin_shrink_and_ending()
	local resume_point: number = 0
	return vm.guard(function()
		resume_point = 1
		zelmite_mine_boss.play_majin_shrink_scene()
		resume_point = 2
		zelmite_mine_boss.play_ending_movie()
		event.set_scene_exit_flag(1)
		return
	end, function(received: { any })
		if resume_point <= 2 then
			if resume_point <= 1 then
				zelmite_mine_boss.wait_after_ending()
			end
			return 0
		end
		return nil
	end)
end
script[18200] = script.cutscene_majin_shrink_and_ending

script[28020] = script.start_boss_battle

return script
