--!strict
--- Pump room floor script covering the elephant ambush, the Polcurse escape and the Ridepod tutorial cutscene.

local vm = require("@lib/vm")
local channel_pump_room = require("@lib/event/channel_pump_room")
local cutscene = require("@lib/event/cutscene")
local dungeon = require("@lib/event/dungeon")
local message = require("@lib/event/message")
local wait = require("@lib/event/wait")

--- Blocks the floor exit while the party is busy, or asks whether to move to the next floor and loads it.
local function edit_analyze_changed()
	local flag: s32 = 0
	local previous_window_mode: s32 = 0
	local has_party_member: s32 = 0
	local active_chr_no: s32 = 0
	local answer: any = 0
	local stage_id: s32 = 0
	local floor: s32 = 0
	local next_floor: s32 = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	event.reset_action_character_motion(0)
	flag = event.get_save_flag(7) or flag
	if flag == 0 then
		event.initialize_event()
		event.set_dungeon_pause_flags(1, 1)
		has_party_member = event.set_party_member(2) or has_party_member
		if has_party_member ~= 0 then
			previous_window_mode = event.get_message_window_frame(0) or previous_window_mode
			event.set_message_window_mode(0, 1)
			event.set_message_bubble_tail(0, 0)
			event.open_message_window_2(0, "There's no time for that now!")
			message.show_and_wait(0, -1, 5, 0, 0)
			event.set_message_window_mode(0, previous_window_mode)
			vm.wait(2)
			event.set_dungeon_pause_flags(1, 0)
			event.finish_event()
			return
		else
			event.set_character_motion(0, "立ち")
			previous_window_mode = event.get_message_window_frame(0) or previous_window_mode
			event.set_message_window_mode(0, 1)
			event.set_message_bubble_tail(0, 0)
			flag = event.get_save_flag(104) or flag
			if flag == 1 then
				event.open_message_window_2(0, "The door just won't open.\nLet's go back up for now.")
			else
				event.open_message_window_2(0, "There's no time for that now!")
			end
			message.show_and_wait(0, -1, 5, 0, 0)
			event.set_message_window_mode(0, previous_window_mode)
			vm.wait(4)
			event.set_dungeon_pause_flags(1, 0)
			event.finish_event()
			return
		end
	end
	event.initialize_event()
	event.set_character_motion(0, "立ち")
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 2 then
		event.set_message_window_mode(0, 1)
		event.set_message_bubble_tail(0, 0)
		event.open_message_window_2(0, "It doesn't look like you can move\nforward unless you get off the\nRide Pod.")
		message.show_and_wait(0, -1, 8, 256, 208)
		event.finish_event()
		return
	end
	if active_chr_no == 3 then
		event.set_message_window_mode(0, 1)
		event.set_message_bubble_tail(0, 0)
		message.show_and_wait(0, 21, 8, 256, 208)
		event.finish_event()
		return
	end
	event.set_message_window_mode(0, 5)
	event.set_message_draw_speed(0, 1)
	answer = message.ask_yes_no(1, -1)
	if answer == 0 then
		event.set_save_control_bits(1, 0)
		stage_id = event.get_dungeon_stage_id() or stage_id
		floor = event.get_dungeon_floor() or floor
		next_floor = event.get_dungeon_next_floor(floor, 0) or next_floor
		event.set_dungeon_floor(next_floor)
		event.set_dungeon_floor_info(stage_id, floor, 5, 2)
		event.set_dungeon_floor_info(stage_id, next_floor, 5, 1)
		event.fade_out_screen(30)
		wait.frames(30)
		flag = event.get_save_flag(8) or flag
		if flag == 0 then
			event.stop_music(0)
			event.set_save_flag(8, 1)
			event.skip_next_music_load()
			event.go_to_georama_edit(12, 540)
			vm.wait(9)
			return
		end
		event.skip_next_music_load()
		event.go_to_dungeon(0, 5, 1000)
		vm.wait(10)
	end
	event.finish_event()
end

--- Shows the Ridepod tutorial messages over the cutscene's closing shot.
local function show_ridepod_tutorial(sound_bank: any)
	local previous_window_mode: s32 = 0
	event.set_camera_sequence_position(-276.53, 81.94, 10.07)
	event.set_camera_sequence_look_at(31.75, 72.44, -9.51)
	event.set_object_sequence_position(0, -165.91, 50.0, 2.54)
	event.set_object_sequence_rotation(0, 0.0, 1.65, 0.0)
	event.set_object_sequence_motion(0, "立ち（スティーブ）", 4)
	event.set_object_sequence_position(1, -165.91, 50.0, 2.54)
	event.set_object_sequence_rotation(1, 0.0, 1.65, 0.0)
	event.set_object_sequence_motion(1, "立ち（スティーブ）", 4)
	wait.frames(30)
	previous_window_mode = event.get_message_window_frame() or previous_window_mode
	event.set_message_window_mode(0, 8)
	event.open_message_window_2(
		0,
		"[(!)]You can use the Ridepod with the\n   Ridepod command under Character\n   on the Main Menu.<page>When you want to get off, choose\nMax under Character."
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.open_message_window_2(0, "[(!)]You can get Cedric to refuel the\n   Ridepod for you.")
	message.show_and_wait(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"[(!)]And as the Ridepod builds up\n   EXP, you can get Cedric to\n   upgrade the Ridepod's Core.<page>The Core's Capacity for equipping\nmore parts will then increase."
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"[(!)]Raise the Core's Capacity and try\n   installing various parts to make\n   your own, unique Ridepod!"
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.set_message_window_mode(0, previous_window_mode)
end

--- Plays the cutscene after the elephant is beaten and hands control back to the player riding the Ridepod.
local function play_elephant_defeat_cutscene()
	local sound_bank: s32 = 0
	vm.section(function()
		vm.entry(1)
		event.set_save_flag(108, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.show_dungeon_status_bar(0, 1.0)
		sound_bank = event.load_sound_effect_file_2(1819) or sound_bank
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.clear_camera_sequence()
		event.set_camera_position(6.02, 94.24, 399.23)
		event.set_camera_look_at(-4.96, 118.28, 117.71)
		event.load_character_motion_pack(5, "event/e100/e108/e108_mints.gltf", "info", 0)
		event.set_character_active(1, 0)
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_position(0, 0.0, 50.0, 0.0)
		event.set_character_rotation(0, 0.0, 0.0, 0.0)
		event.load_character(5, "event/e100/e108/e108_steve.gltf", "info", 9)
		event.set_character_active(1, 9)
		event.attach_object_handle_to_character(1, 9)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_character_position(9, 0.0, 50.0, 0.0)
		event.set_character_rotation(9, 0.0, 0.0, 0.0)
		event.load_character(5, "event/e100/e108/e108_erephant.gltf", "info", 10)
		event.set_character_active(0, 10)
		event.attach_object_handle_to_character(2, 10)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.set_character_position(10, 0.0, 50.0, 0.0)
		event.set_character_rotation(10, 0.0, 0.0, 0.0)
		event.load_character(5, "event/e100/e108/e108_polcurse.gltf", "info", 11)
		event.set_character_active(0, 11)
		event.attach_object_handle_to_character(3, 11)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.set_character_position(9, 0.0, 50.0, 0.0)
		event.set_character_rotation(9, 0.0, 0.0, 0.0)
		event.attach_object_handle_to_character(10, 1)
		event.set_object_handle_visible(10, 0)
		event.attach_object_handle_to_character(11, 2)
		event.set_object_handle_visible(11, 0)
		event.load_message_file(0, 5, "event/e100/e108/e108a_1.txt")
		event.stop_music(0)
		event.enable_drama_skip()
		channel_pump_room.play_elephant_death(sound_bank)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(3, 0)
		event.set_object_sequence_texture_animation(3, 1, "おこり顔")
		event.set_object_sequence_texture_animation(3, 1, "通常目パチ")
		channel_pump_room.play_victory_pose_shot(sound_bank)
		channel_pump_room.play_victory_pose(sound_bank)
		channel_pump_room.play_polcurse_flyaway(sound_bank)
		channel_pump_room.play_party_look_up(sound_bank)
		show_ridepod_tutorial(sound_bank)
		event.fade_out_screen(30)
		wait.frames(30)
	end)
	vm.entry(9)
	event.cancel_drama_scene_skip()
	event.stop_sound_effect(sound_bank, 0)
	event.stop_sound_effect(sound_bank, 2)
	event.set_character_active(1, 0)
	event.attach_object_handle_to_character(10, 1)
	event.set_object_handle_visible(10, 0)
	event.attach_object_handle_to_character(11, 2)
	event.set_object_handle_visible(11, 0)
	event.delete_character_extension_packs(0)
	event.delete_character(9)
	event.delete_character(10)
	event.delete_character(11)
	event.set_camera_position(-276.53, 81.94, 10.07)
	event.set_camera_look_at(31.75, 72.44, -9.51)
	event.reset_follow_camera(0)
	event.switch_dungeon_main_character(2)
	event.set_playable_character(2)
	event.set_character_position(0, -167.59, 50.0, 2.86)
	event.set_character_rotation(0, 0.0, 1.77, 0.0)
	event.show_dungeon_status_bar(1)
	event.stop_music(0)
	wait.frames(4)
	event.load_music(15)
	event.play_music(0)
	event.reset_follow_camera(1, 0.0, 20.0)
	event.fade_in_screen(30)
	vm.wait(11)
	event.finish_event()
end

local script: { [any]: (...any) -> ...any } = {}

--- Does nothing for this map.
function script.setup() end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = channel_pump_room.play_entrance_event

--- Places the player at the room entrance and waits for a button press.
function script.hold_player_at_entrance()
	event.set_character_position(0, -240.84, 50.0, -5.32)
	event.set_character_rotation(0, 0.0, 1.6, 0.0)
	vm.wait(1)
	wait.until_button_pressed(64)
end
script[151] = script.hold_player_at_entrance

--- Event 300, which map data, a script or the engine runs by number.
script[300] = edit_analyze_changed

script.edit_analyze_changed = edit_analyze_changed

--- Sets up the room by story progress and loads the matching cutscene or entrance event.
function script.enter_pump_room()
	local flag: s32 = 0
	local flag_2: s32 = 0
	local has_party_member: s32 = 0
	channel_pump_room.load_map_sounds()
	flag = event.get_save_flag(7) or flag
	if flag == 0 then
		flag = event.get_save_flag(106) or flag
		flag_2 = event.get_save_flag(104) or flag_2
		has_party_member = event.set_party_member(2) or has_party_member
		if (if flag == 1 then has_party_member else 0) ~= 0 or flag_2 == 0 then
			event.set_save_control_bits(1, 1)
			channel_pump_room.setup_map_part_handles(1)
		end
	end
	event.set_function_point_enabled("", "dun_out", 0)
	flag = event.get_save_flag(7) or flag
	if flag == 1 then
		event.set_function_point_enabled("p01_s06", "doa1", 0)
		event.set_function_point_enabled("p01_s06", "doa0", 1)
		flag = event.get_save_flag(109) or flag
		if flag ~= 0 then
			event.set_function_point_enabled("", "dun_out", 1)
		end
	else
		event.set_function_point_enabled("p01_s06", "doa1", 0)
		event.set_function_point_enabled("p01_s06", "doa0", 1)
		has_party_member = event.set_party_member(2) or has_party_member
		if has_party_member == 0 then
			flag = event.get_save_flag(105) or flag
			if flag == 1 then
				event.set_function_point_enabled("", "dun_out", 1)
			end
		else
			event.set_function_point_enabled("", "dun_out", 0)
		end
	end
	event.initialize_event()
	event.fade_out_screen(0)
	vm.wait(1)
	flag = event.get_save_flag(103) or flag
	if flag == 0 then
		channel_pump_room.setup_map_part_handles(1)
		event.load_event_script("s06/s06b_1.stb", 500)
		return
	else
		has_party_member = event.set_party_member(2) or has_party_member
		if has_party_member ~= 0 then
			flag = event.get_save_flag(25) or flag
			if flag == 1 then
				event.set_save_flag(5, 0)
				flag = event.get_save_flag(6) or flag
				if flag == 0 then
					event.fade_out_screen(0)
					event.set_save_flag(6, 1)
					event.load_event_script("s06/s06b_1.stb", 510)
					return
				else
					flag = event.get_save_flag(7) or flag
					if flag == 0 then
						event.fade_out_screen(0)
						event.load_event_script("s06/s06b_1.stb", 520)
						return
					else
						channel_pump_room.play_entrance_event()
					end
				end
			else
				channel_pump_room.play_entrance_event()
			end
		else
			event.set_save_flag(5, 0)
			flag = event.get_save_flag(7) or flag
			if flag == 1 then
				channel_pump_room.play_entrance_event()
			else
				has_party_member = event.set_party_member(2) or has_party_member
				if has_party_member == 0 then
					flag = event.get_save_flag(105) or flag
					if flag == 1 then
						channel_pump_room.play_entrance_event()
					end
				else
					event.load_dungeon_monster(601, 1)
					channel_pump_room.play_entrance_event()
					event.initialize_event()
					event.place_dungeon_monster(601, -36.31, 50.0, 1.24, 0.0, 0.0, 0.0)
					event.finish_event()
				end
			end
		end
	end
	event.fade_in_screen(30)
	event.finish_event()
end
script[500] = script.enter_pump_room

--- Loads the second room script.
function script.enter_room_c()
	event.initialize_event()
	event.load_event_script("s06/s06c_1.stb", 500)
	vm.wait(1)
end
script[501] = script.enter_room_c

--- Plays the elephant defeat cutscene and clears the battle monsters.
function script.on_elephant_defeated()
	local resume_step: number = 0
	return vm.guard(function()
		event.fade_out_screen(30)
		resume_step = 1
		wait.frames(30)
		event.initialize_event()
		event.set_save_flag(7, 1)
		event.switch_dungeon_main_character(0)
		event.set_playable_character(0)
		channel_pump_room.setup_map_part_handles(0)
		event.set_dungeon_pause_flags(17, 1)
		resume_step = 2
		play_elephant_defeat_cutscene()
		event.clear_event_battle_monsters(-1)
		return
	end, function(received: { any })
		if resume_step <= 2 then
			if resume_step <= 1 then
				cutscene.ignore_value(0)
				resume_step = 2
				play_elephant_defeat_cutscene()
				return vm.continue_with(function()
					event.clear_event_battle_monsters(-1)
					return
				end)
			end
			return 0
		end
		return nil
	end)
end
script[502] = script.on_elephant_defeated

--- Restores the party, plays the Polcurse escape and goes to the Georama.
function script.cutscene_polcurse_escape()
	local resume_step: number = 0
	return vm.guard(function()
		event.set_save_control_bits(1, 0)
		channel_pump_room.setup_map_part_handles(0)
		event.fade_out_screen(30)
		resume_step = 1
		wait.frames(30)
		event.add_hp_by_rate(1.0, 0)
		event.switch_dungeon_main_character(0)
		event.set_playable_character(0)
		event.set_dungeon_pause_flags(17, 1)
		resume_step = 2
		channel_pump_room.play_polcurse_escape_event()
		event.skip_next_music_load()
		event.go_to_georama_edit(10, 531)
		resume_step = 3
		vm.wait(3)
		return
	end, function(received: { any })
		if resume_step <= 3 then
			if resume_step <= 1 then
				resume_step = 2
				channel_pump_room.play_polcurse_escape_event()
				return vm.continue_with(function()
					event.skip_next_music_load()
					event.go_to_georama_edit(10, 531)
					resume_step = 3
					vm.wait(3)
					return
				end)
			end
			return 0
		end
		return nil
	end)
end
script[503] = script.cutscene_polcurse_escape

--- Fades out and plays the elephant ambush cutscene.
function script.cutscene_elephant_ambush()
	event.fade_out_screen(0)
	channel_pump_room.play_elephant_ambush_event_variant()
end
script[504] = script.cutscene_elephant_ambush

--- Loads the second room script after a short wait.
function script.load_room_c()
	event.load_event_script("s06/06c_1.stb", 500)
	vm.wait(1)
end
script[505] = script.load_room_c

--- Loads the second room script after a short wait, like event 505.
function script.load_room_c_again()
	event.load_event_script("s06/06c_1.stb", 500)
	vm.wait(1)
end
script[506] = script.load_room_c_again

--- Sets the elephant-encounter flag and loads the elephant landing cutscene.
function script.cutscene_elephant_landing()
	event.fade_out_screen(0)
	event.set_save_flag(6, 1)
	event.load_event_script("s06/s06b_1.stb", 510)
	vm.wait(1)
end
script[507] = script.cutscene_elephant_landing

--- Asks whether to leave for the dungeon, or explains why the party cannot while riding the Ridepod.
function script.examine_dungeon_exit()
	local active_chr_no: s32 = 0
	local answer: any = 0
	event.initialize_event()
	event.reset_action_character_motion(0)
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 2 or active_chr_no == 3 then
		event.initialize_event()
		event.set_message_window_mode(0, 1)
		event.set_message_draw_speed(0, 1)
		if active_chr_no == 2 then
			message.show_and_wait(0, 20, 5, 256, 208)
		else
			message.show_and_wait(0, 21, 5, 256, 208)
		end
		event.set_message_draw_speed(0, 0)
		event.set_dungeon_pause_flags(1, 0)
		event.finish_event()
		return
	end
	event.set_message_window_mode(0, 5)
	answer = message.ask_yes_no(2, -1)
	if answer == 0 then
		event.fade_out_screen(30)
		wait.frames(30)
		event.set_save_control_bits(1, 0)
		event.load_event_script("d01/d01.stb", 1000)
		return
	end
	event.finish_event()
end
script[600] = script.examine_dungeon_exit

--- Loads the second room script's opening cutscene.
function script.cutscene_pump_room_opening()
	vm.wait(1)
	channel_pump_room.setup_map_part_handles(1)
	event.load_event_script("s06/s06c_1.stb", 600)
end
script[601] = script.cutscene_pump_room_opening

--- Goes to the Georama edit screen.
function script.start_georama_edit()
	event.go_to_georama_edit(12, 540)
	vm.wait(1)
end
script[630] = script.start_georama_edit

--- Runs the defeat sequence, or loads the Polcurse escape cutscene when the party falls while riding the Ridepod before the elephant is beaten.
function script.on_party_defeated()
	local active_chr_no: s32 = 0
	local flag: s32 = 0
	local resume_step: number = 0
	return vm.guard(function()
		active_chr_no = event.get_playable_character() or active_chr_no
		if active_chr_no == 2 then
			flag = event.get_save_flag(7) or flag
			if flag == 0 then
				event.set_save_flag(6, 1)
				resume_step = 1
				vm.wait(1)
				event.load_event_script("s06/s06.stb", 503)
			else
				resume_step = 2
				dungeon.run_defeat_sequence_with_message_silent(0)
			end
		else
			resume_step = 3
			dungeon.run_defeat_sequence_with_message_silent(0)
		end
		return
	end, function(received: { any })
		if resume_step <= 3 then
			if resume_step <= 1 then
				dungeon.skip_defeat_dialogue_sequence_silent(0)
			end
			if resume_step <= 2 then
				dungeon.skip_defeat_dialogue_sequence_silent(0)
			end
			return 0
		end
		return nil
	end)
end
script[1200] = script.on_party_defeated

--- Clears the arrival flag and reloads the first room script's arrival cutscene.
function script.replay_arrival()
	event.set_save_flag(103, 0)
	vm.wait(1)
	event.load_event_script("s06/s06b_1.stb", 500)
end
script[11030] = script.replay_arrival

--- Reloads the second room script.
function script.restart_room_c()
	vm.wait(1)
	event.load_event_script("s06/s06c_1.stb", 500)
end
script[11040] = script.restart_room_c

--- Sets the replay flag and loads the elephant landing cutscene.
function script.replay_elephant_landing()
	event.set_save_flag(107, 1)
	vm.wait(1)
	event.load_event_script("s06/s06b_1.stb", 510)
end
script[11070] = script.replay_elephant_landing

--- Replays the elephant defeat cutscene and sets the cleared flag.
function script.replay_elephant_defeat()
	local resume_step: number = 0
	return vm.guard(function()
		event.set_dungeon_pause_flags(1, 1)
		event.fade_out_screen(15)
		resume_step = 1
		wait.frames(15)
		event.switch_dungeon_main_character(0)
		event.set_playable_character(0)
		event.set_dungeon_pause_flags(17, 1)
		resume_step = 2
		play_elephant_defeat_cutscene()
		event.set_save_flag(7, 1)
		return
	end, function(received: { any })
		if resume_step <= 2 then
			if resume_step <= 1 then
				resume_step = 2
				play_elephant_defeat_cutscene()
				return vm.continue_with(function()
					event.set_save_flag(7, 1)
					return
				end)
			end
			return 0
		end
		return nil
	end)
end
script[11081] = script.replay_elephant_defeat

--- Restores the party, replays the Polcurse escape and goes to the Georama.
function script.replay_polcurse_escape()
	local resume_step: number = 0
	return vm.guard(function()
		event.set_save_control_bits(1, 0)
		event.fade_out_screen(30)
		resume_step = 1
		wait.frames(30)
		event.add_hp_by_rate(1.0, 0)
		event.switch_dungeon_main_character(0)
		event.set_playable_character(0)
		event.set_dungeon_pause_flags(17, 1)
		resume_step = 2
		channel_pump_room.play_polcurse_escape_event()
		event.skip_next_music_load()
		event.go_to_georama_edit(10, 531)
		resume_step = 3
		vm.wait(3)
		return
	end, function(received: { any })
		if resume_step <= 3 then
			if resume_step <= 1 then
				resume_step = 2
				channel_pump_room.play_polcurse_escape_event()
				return vm.continue_with(function()
					event.skip_next_music_load()
					event.go_to_georama_edit(10, 531)
					resume_step = 3
					vm.wait(3)
					return
				end)
			end
			return 0
		end
		return nil
	end)
end
script[11082] = script.replay_polcurse_escape

--- Restarts the elephant fight with the player and elephant placed again.
function script.restart_elephant_fight()
	event.initialize_event()
	vm.wait(1)
	event.stop_music(0)
	wait.frames(4)
	event.load_music(190)
	event.play_music(0)
	event.fade_in_screen(30)
	event.set_character_position(0, 0.0, 50.0, 100.0)
	event.set_character_rotation(0, 0.0, 3.1415927, 0.0)
	channel_pump_room.setup_map_part_handles(1)
	event.load_dungeon_monster(601, 1)
	event.place_dungeon_monster(601, 10.66, 50.0, -0.04, 0.0, -1.5707964, 0.0)
	event.finish_event()
	event.reset_follow_camera(1, 0.0, 20.0)
end
script[21010] = script.restart_elephant_fight

return script
