--!strict
--- Cave of Ancient Murals events: the Marionette encounters, the gate chamber, the Shingala game over and the exits.

local vm = require("@lib/vm")
local cave_of_ancient_murals = require("@lib/event/cave_of_ancient_murals")
local cutscene = require("@lib/event/cutscene")
local dungeon = require("@lib/event/dungeon")
local message = require("@lib/event/message")
local wait = require("@lib/event/wait")

--- Loads the cave sounds and starts the cave music unless the party is between the Marionette confrontation and the shock scene.
local function initialize_cave_audio()
	local encounter_flag: s32 = 0
	local shock_flag: s32 = 0
	local progress_value: s32 = 0
	event.load_map_sounds(4684)
	encounter_flag = event.get_save_flag(408) or encounter_flag
	shock_flag = event.get_save_flag(420) or shock_flag
	progress_value = event.get_save_data_value(2) or progress_value
	if encounter_flag == 1 and shock_flag == 0 and progress_value == 1 then
	else
		event.stop_music(0)
		wait.frames(4)
		event.load_music(167)
		event.play_music(0)
	end
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script loads.
function script.setup() end

script.initialize_cave_audio = initialize_cave_audio
script[99] = script.initialize_cave_audio

--- Chooses which cave scene to play from the progress flags.
function script.default_event()
	local cave_flag: s32 = 0
	local encounter_flag: s32 = 0
	local shock_flag: s32 = 0
	local progress_value: s32 = 0
	local step: number = 0
	return vm.guard(function()
		step = 1
		initialize_cave_audio()
		cave_flag = event.get_save_flag(400) or cave_flag
		encounter_flag = event.get_save_flag(408) or encounter_flag
		shock_flag = event.get_save_flag(420) or shock_flag
		if cave_flag == 1 then
			if encounter_flag == 0 then
				step = 2
				cave_of_ancient_murals.play_monster_encounter()
				event.go_to_georama_edit(75, 500)
				return
			end
			if shock_flag == 0 then
				progress_value = event.get_save_data_value(2) or progress_value
				if progress_value ~= 0 then
					step = 3
					cave_of_ancient_murals.set_map_part_visible(1)
					step = 4
					cave_of_ancient_murals.play_gate_chamber_arrival()
					event.set_save_control_bits(1, 1)
					return
				else
					step = 5
					cave_of_ancient_murals.play_marionette_confrontation()
					event.stop_all_sounds()
					step = 6
					wait.frames(6)
					event.load_music(18)
					event.load_map_sounds(4601)
					event.play_music(0)
					event.load_event_script("d04/d04.stb", 1000)
					return
				end
			else
				step = 7
				cave_of_ancient_murals.play_gate_opening()
			end
		else
			step = 8
			cave_of_ancient_murals.play_gate_opening()
		end
		return
	end, function(received: { any })
		if step <= 2 then
			if step <= 1 then
				step = 2
				cave_of_ancient_murals.play_monster_encounter()
				return vm.continue_with(function()
					event.go_to_georama_edit(75, 500)
					return
				end)
			end
			return 0
		end
		if step <= 4 then
			if step <= 3 then
				step = 4
				cave_of_ancient_murals.play_gate_chamber_arrival()
				return vm.continue_with(function()
					event.set_save_control_bits(1, 1)
					return
				end)
			end
			return 0
		end
		if step <= 6 then
			if step <= 5 then
				wait.frames_skipping(6)
			end
			return 0
		end
		if step <= 8 then
			if step <= 7 then
				step = 8
				cave_of_ancient_murals.play_gate_opening()
				return vm.continue_with(function()
					return
				end)
			end
			return 0
		end
		return nil
	end)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = cave_of_ancient_murals.play_monster_encounter

--- Positions the player, loads the battle monsters and places one of them for the fight.
function script.prepare_monster_battle()
	event.fade_in_screen(30)
	event.initialize_event()
	vm.wait(1)
	event.set_character_position(0, -29.1, 1.4, 787.9)
	event.set_dungeon_pause_flags(17, 0)
	event.load_dungeon_monster(516, 1)
	event.load_dungeon_monster(1001, 0)
	event.place_dungeon_monster(516, -50.0, -46.69, 202.57, 0.0, 0.0, 0.0)
	event.get_character_position(0)
	event.finish_event()
end
script[151] = script.prepare_monster_battle

--- Waits for the confirm button.
function script.wait_for_confirm_button()
	vm.wait(1)
	wait.until_button_pressed(64)
end
script[152] = script.wait_for_confirm_button

--- Clears the battle monsters and fades in to the Marionette shock scene.
function script.fade_into_marionette_shock()
	local step: number = 0
	return vm.guard(function()
		event.set_dungeon_pause_flags(1, 1)
		event.fade_out_screen(0)
		event.set_dungeon_pause_flags(16, 1)
		step = 1
		wait.frames(30)
		event.fade_in_screen(30)
		event.clear_event_battle_monsters(-1)
		step = 2
		cave_of_ancient_murals.play_marionette_shock()
		return
	end, function(received: { any })
		if step <= 2 then
			if step <= 1 then
				step = 2
				cave_of_ancient_murals.play_marionette_shock()
				return vm.continue_with(function()
					return
				end)
			end
			return 0
		end
		return nil
	end)
end
script[153] = script.fade_into_marionette_shock

--- Aims the camera at a fixed point and waits for the confirm button.
function script.aim_camera_and_wait_for_confirm()
	event.set_camera_look_at(-33.22, 3.88, 763.5)
	vm.wait(1)
	wait.until_button_pressed(64)
end
script[154] = script.aim_camera_and_wait_for_confirm

--- Event 155, which map data, a script or the engine runs by number.
script[155] = cave_of_ancient_murals.play_gate_chamber_arrival

--- Waits for the confirm button.
function script.wait_for_confirm_press()
	vm.wait(1)
	wait.until_button_pressed(64)
end
script[160] = script.wait_for_confirm_press

--- Reminds the player to feed the fish to Shingala while that fight is active, otherwise leaves the cave to the dungeon after confirming.
function script.leave_cave()
	local is_shingala_fight_active: s32 = 0
	local active_character: s32 = 0
	event.initialize_event()
	is_shingala_fight_active = event.has_save_control_bits(1) or is_shingala_fight_active
	if is_shingala_fight_active == 1 then
		event.set_dungeon_pause_flags(9, 1)
		event.reset_action_character_motion(0)
		event.set_message_window_mode(0, 1)
		event.set_message_bubble_tail(0, 0)
		event.open_message_window_2(0, "Il faut donner ce poisson\n[UNI00e0] Shingala, et vite !")
		message.show_and_wait(0, -1, 5, 0, 0)
		event.set_dungeon_pause_flags(9, 0)
		return
	end
	active_character = event.get_playable_character() or active_character
	if active_character == 2 then
		event.set_character_motion(0, "立ち")
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
	if cave_of_ancient_murals.confirm_exit(0) ~= 0 then
		event.load_event_script("d04/d04.stb", 1000)
	end
end
script[200] = script.leave_cave

--- Reminds the player to feed the fish to Shingala while that fight is active, otherwise advances to the next floor and leaves the cave after confirming.
function script.leave_cave_to_next_floor()
	local is_shingala_fight_active: s32 = 0
	local active_character: s32 = 0
	local stage_id: s32 = 0
	local current_floor: s32 = 0
	local next_floor: s32 = 0
	event.initialize_event()
	is_shingala_fight_active = event.has_save_control_bits(1) or is_shingala_fight_active
	if is_shingala_fight_active == 1 then
		event.set_dungeon_pause_flags(9, 1)
		event.reset_action_character_motion(0)
		event.set_message_window_mode(0, 1)
		event.set_message_bubble_tail(0, 0)
		event.open_message_window_2(0, "Il faut donner ce poisson\n[UNI00e0] Shingala, et vite !")
		message.show_and_wait(0, -1, 5, 0, 0)
		event.set_dungeon_pause_flags(9, 0)
		return
	end
	active_character = event.get_playable_character() or active_character
	if active_character == 2 then
		event.set_character_motion(0, "立ち")
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
	if cave_of_ancient_murals.confirm_exit(1) ~= 0 then
		stage_id = event.get_dungeon_stage_id() or stage_id
		current_floor = event.get_dungeon_floor() or current_floor
		next_floor = event.get_dungeon_next_floor(current_floor, 0) or next_floor
		event.set_dungeon_floor(next_floor)
		event.set_dungeon_floor_info(stage_id, current_floor, 5, 2)
		event.set_dungeon_floor_info(stage_id, next_floor, 5, 1)
		event.stop_music(0)
		event.stop_environment_music()
		event.stop_map_object_sounds()
		wait.frames(6)
		event.load_music(18)
		event.load_map_sounds(4601)
		event.play_music(0)
		event.load_event_script("d04/d04.stb", 1000)
	end
end
script[201] = script.leave_cave_to_next_floor

--- Ends the Shingala fight and plays the Marionette shock scene before moving on.
function script.cutscene_marionette_shock_after_battle()
	local step: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.fade_out_screen(0)
		step = 1
		vm.wait(1)
		step = 2
		vm.wait(2)
		event.clear_event_battle_monsters(-1)
		event.set_save_data_value(4)
		event.set_save_control_bits(1, 0)
		step = 3
		cave_of_ancient_murals.set_map_part_visible(0)
		step = 4
		cave_of_ancient_murals.play_marionette_shock()
		event.skip_next_music_load()
		event.go_to_georama_edit(75, 100)
		step = 5
		vm.wait(5)
		return
	end, function(received: { any })
		if step <= 5 then
			if step <= 2 then
				cutscene.ignore_value(0)
			end
			if step <= 3 then
				step = 4
				cave_of_ancient_murals.play_marionette_shock()
				return vm.continue_with(function()
					event.skip_next_music_load()
					event.go_to_georama_edit(75, 100)
					step = 5
					vm.wait(5)
					return
				end)
			end
			return 0
		end
		return nil
	end)
end
script[500] = script.cutscene_marionette_shock_after_battle

--- Shows the Shingala defeat message and game over screen, returning whether to continue.
function script.show_shingala_game_over()
	local can_continue: s32 = 0
	local sound_effect_bank: s32 = 0
	local sound_effect_status: s32 = 0
	local battle_music_volume: s32 = 0
	local active_character: s32 = 0
	local image_block: s32 = 0
	local debug_flag: s32 = 0
	local saved_music_number: s32 = 0
	local is_boss_floor: s32 = 0
	cave_of_ancient_murals.play_boss_death()
	event.set_dungeon_pause_flags(1, 0)
	can_continue = 0
	event.initialize_event()
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.set_dungeon_pause_flags(16384, 1)
	event.save_music_status(-1)
	sound_effect_bank = event.get_event_sound_bank(4) or sound_effect_bank
	sound_effect_status = event.get_sound_effect_status(sound_effect_bank, 0) or sound_effect_status
	battle_music_volume = event.get_battle_music_volume() or battle_music_volume
	event.stop_sound_effect(sound_effect_bank, 0)
	event.stop_music(0)
	active_character = event.get_playable_character() or active_character
	event.start_background_file_loads_2("snd2/bgm/bg_060.sound.json", "textures/dungeon/image/gameover/gameover_1.json")
	wait.frames(30)
	wait.background_load()
	event.load_music_pack(60)
	event.play_music(0)
	wait.frames(30)
	event.set_dungeon_pause_flags(1, 1)
	event.reset_dungeon_collision_primitives()
	event.set_message_window_mode(0, 8)
	event.open_message_window_2(0, "Oh, non ! Shingala est mort... Et\nil devait nous aider [UNI00e0] restaurer le\nfutur...")
	message.show_and_wait(0, -1, 8, 0, 0)
	image_block = event.load_event_image_4(5, "textures/dungeon/image/gameover/gameover_1.json", 0) or image_block
	event.reset_event_sprite(0)
	event.set_event_sprite_type(0, 0)
	event.set_event_sprite_texture(0, "gameover1", image_block)
	event.set_event_sprite_color(0, 128, 128, 128, 128)
	event.set_event_sprite_texture_rect(0, 0, 0, 576, 128)
	event.set_event_sprite_size(0, 576, 128)
	event.set_event_sprite_position(0, -320, 208)
	event.set_event_sprite_draw_pass(0, 1)
	event.attach_object_handle_to_sprite(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.move_object_sequence(0, 288, 208, 0.0, 20)
	wait.frames(30)
	event.reset_event_sprite(1)
	event.set_event_sprite_type(1, 0)
	event.set_event_sprite_texture(1, "gameover1", image_block)
	event.set_event_sprite_color(1, 128, 128, 128, 0)
	event.set_event_sprite_texture_rect(1, 0, 128, 576, 64)
	event.set_event_sprite_size(1, 576, 64)
	event.set_event_sprite_position(1, 256, 208)
	event.set_event_sprite_draw_pass(1, 1)
	event.attach_object_handle_to_sprite(1, 1)
	event.clear_object_sequence(1)
	event.set_object_sequence_object(1, 1)
	event.set_object_sequence_color(1, 128, 128, 128, 128, 120)
	wait.frames(120)
	while true do
		if wait.get_button_state(0) ~= 0 then
			break
		else
			vm.wait(8)
		end
	end
	debug_flag = event.get_debug_flag() or debug_flag
	debug_flag = 0
	if debug_flag == 1 then
		event.run_dungeon_debug_command(0)
		event.reset_action_character_motion(0, 4)
	else
		event.fade_out_music(30)
		event.fade_out_screen(30)
		wait.frames(30)
		if active_character == 2 then
			event.clear_effect_manager()
		end
		event.stop_music(0)
		event.set_event_sprite_draw_pass(0, 0)
		event.set_event_sprite_draw_pass(1, 0)
		event.delete_event_image(0)
		if can_continue == 1 then
			event.add_hp_by_rate(1.0, 0)
			event.add_battle_weapon_durability(0, 999)
			event.add_battle_weapon_durability(1, 999)
			event.run_dungeon_event(-1)
			event.clear_event_battle_monsters(-1)
			event.set_dungeon_pause_flags(1, 0)
			event.finish_event()
			return 1
		else
			event.set_scene_exit_flag(1)
			event.finish_event()
			return 0
		end
	end
	event.stop_music(0)
	wait.frames(4)
	saved_music_number = event.get_saved_music_number() or saved_music_number
	event.load_music(saved_music_number)
	event.restore_music_status(-1)
	event.set_event_sprite_draw_pass(0, 0)
	event.set_event_sprite_draw_pass(1, 0)
	event.delete_event_image(0)
	is_boss_floor = event.is_dungeon_boss_floor() or is_boss_floor
	if is_boss_floor ~= 1 then
		if sound_effect_status == 1 then
			event.play_sound_effect(sound_effect_bank, 0)
			event.set_sound_effect_volume(sound_effect_bank, 0, battle_music_volume)
		end
	end
	event.set_camera_control_enabled(1)
	event.show_dungeon_status_bar(1, 1.0)
	if debug_flag ~= 1 then
		event.fade_in_screen(30)
	end
	event.set_dungeon_pause_flags(16385, 0)
	event.finish_event()
	return 0
end
script[510] = script.show_shingala_game_over

--- Shows the hint about throwing the Electric Fish into Shingala's mouth.
function script.show_shingala_hint()
	event.initialize_event()
	event.set_dungeon_pause_flags(3, 1)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.set_message_draw_speed(0, 1)
	event.open_message_window_2(
		0,
		"[(!)]Si tu frappes Shingala, il va\n   s'[UNI00e9]nerver et se pr[UNI00e9]cipiter sur toi.\n   Il aura la gueule grande ouverte et l[UNI00e0],<page>   tu auras l'occasion d'y jeter\n   le poisson [UNI00e9]lectris[UNI00e9] !"
	)
	message.show_and_wait(0, -1, 5, 0, 0)
	event.set_message_window_mode(0, 1)
	event.set_message_draw_speed(0, 0)
	event.set_dungeon_pause_flags(3, 0)
	event.finish_event()
end
script[550] = script.show_shingala_hint

--- Plays a randomly chosen voiced defeat dialogue while the Shingala fight is under way, otherwise the silent one.
function script.on_defeat()
	local gate_arrival_flag: s32 = 0
	local shock_flag: s32 = 0
	local random_roll: s32 = 0
	local step: number = 0
	return vm.guard(function()
		gate_arrival_flag = event.get_save_flag(416) or gate_arrival_flag
		shock_flag = event.get_save_flag(420) or shock_flag
		if gate_arrival_flag ~= 0 and shock_flag == 0 then
			random_roll = event.get_random_number_int(100) or random_roll
			if random_roll < 50 then
				step = 1
				dungeon.handle_defeat_with_dialogue_voiced(0, 8610060)
			else
				step = 2
				dungeon.handle_defeat_with_dialogue_voiced(0, 8610070)
			end
			return
		end
		step = 3
		dungeon.handle_defeat_with_dialogue_silent(0)
		return
	end, function(received: { any })
		if step <= 2 then
			if step <= 1 then
				dungeon.skip_defeat_dialogue_sequence_voiced(0, 8610070)
			end
			return 0
		end
		if step <= 3 then
			return 0
		end
		return nil
	end)
end
script[1200] = script.on_defeat

--- Sets the progress flags and plays the monster encounter scene.
function script.cutscene_monster_encounter()
	local step: number = 0
	return vm.guard(function()
		event.fade_out_screen(0)
		event.set_save_flag(400, 1)
		event.set_save_flag(402, 1)
		event.set_save_flag(404, 1)
		event.set_save_flag(406, 1)
		event.set_save_flag(408, 0)
		step = 1
		initialize_cave_audio()
		step = 2
		cave_of_ancient_murals.play_monster_encounter()
		event.clear_event_running_flag()
		event.go_to_georama_edit(75, 500)
		return
	end, function(received: { any })
		if step <= 2 then
			if step <= 1 then
				step = 2
				cave_of_ancient_murals.play_monster_encounter()
				return vm.continue_with(function()
					event.clear_event_running_flag()
					event.go_to_georama_edit(75, 500)
					return
				end)
			end
			return 0
		end
		return nil
	end)
end
script[14080] = script.cutscene_monster_encounter

--- Sets the progress flags and plays the Marionette confrontation.
function script.cutscene_marionette_confrontation()
	local step: number = 0
	return vm.guard(function()
		event.set_save_flag(400, 1)
		event.set_save_flag(402, 1)
		event.set_save_flag(404, 1)
		event.set_save_flag(406, 1)
		event.set_save_flag(408, 1)
		event.set_save_flag(410, 0)
		step = 1
		initialize_cave_audio()
		step = 2
		cave_of_ancient_murals.play_marionette_confrontation()
		return
	end, function(received: { any })
		if step <= 2 then
			if step <= 1 then
				step = 2
				cave_of_ancient_murals.play_marionette_confrontation()
				return vm.continue_with(function()
					return
				end)
			end
			return 0
		end
		return nil
	end)
end
script[14100] = script.cutscene_marionette_confrontation

--- Sets the progress flags and plays the gate chamber arrival.
function script.cutscene_gate_chamber_arrival()
	local step: number = 0
	return vm.guard(function()
		step = 1
		initialize_cave_audio()
		event.set_save_flag(400, 1)
		event.set_save_flag(402, 1)
		event.set_save_flag(404, 1)
		event.set_save_flag(406, 1)
		event.set_save_flag(408, 1)
		step = 2
		cave_of_ancient_murals.play_gate_chamber_arrival()
		return
	end, function(received: { any })
		if step <= 2 then
			if step <= 1 then
				step = 2
				cave_of_ancient_murals.play_gate_chamber_arrival()
				return vm.continue_with(function()
					return
				end)
			end
			return 0
		end
		return nil
	end)
end
script[14160] = script.cutscene_gate_chamber_arrival

--- Sets the progress flags and plays the Marionette shock scene.
function script.cutscene_marionette_shock()
	local step: number = 0
	return vm.guard(function()
		event.set_save_flag(400, 1)
		event.set_save_flag(402, 1)
		event.set_save_flag(404, 1)
		event.set_save_flag(406, 1)
		event.set_save_flag(408, 1)
		event.set_save_flag(416, 1)
		step = 1
		initialize_cave_audio()
		step = 2
		cave_of_ancient_murals.play_marionette_shock()
		event.clear_event_running_flag()
		event.skip_next_music_load()
		event.go_to_georama_edit(75, 100)
		step = 3
		vm.wait(3)
		return
	end, function(received: { any })
		if step <= 3 then
			if step <= 1 then
				step = 2
				cave_of_ancient_murals.play_marionette_shock()
				return vm.continue_with(function()
					event.clear_event_running_flag()
					event.skip_next_music_load()
					event.go_to_georama_edit(75, 100)
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
script[14200] = script.cutscene_marionette_shock

return script
