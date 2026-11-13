--!strict
--- Runs the Zelmite mine boss floor: the curse jet scene, the boss encounter, the curse reaction and the stairs to the next floor.

local vm = require("@lib/vm")
local character = require("@lib/event/character")
local cutscene = require("@lib/event/cutscene")
local dungeon = require("@lib/event/dungeon")
local message = require("@lib/event/message")
local wait = require("@lib/event/wait")
local zelmite_mine_s54 = require("@lib/event/zelmite_mine_s54")

--- Stops the music, loads the floor's sounds and places the door parts once the scene flag is set.
local function set_up_boss_floor()
	local curse_scene_flag: s32 = 0
	event.stop_music(0)
	event.load_map_sounds(8684)
	curse_scene_flag = event.get_save_flag(808) or curse_scene_flag
	if curse_scene_flag == 1 then
		zelmite_mine_s54.place_door_parts()
	end
end

--- Starts the boss music, loads and places the boss and puts the party at the arena entrance.
local function begin_boss_encounter()
	event.initialize_event()
	event.fade_out_screen(0)
	vm.wait(1)
	event.stop_music(0)
	wait.frames(6)
	event.load_music(107)
	event.play_music(0)
	event.load_dungeon_monster(628, 1)
	event.load_dungeon_monster(1006, 0)
	event.place_dungeon_monster(628, 0.0, 0.0, 800.0, 0.0, 3.14, 0.0)
	character.place_standing(0.0, 0.0, 300.0, 0.0)
	event.set_camera_look_at(0.0, 30.0, 300.0)
	event.set_camera_position(0.0, 40.0, 180.0)
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
	event.finish_event()
end

local script: { [any]: (...any) -> ...any } = {}

--- Does nothing at load time.
function script.setup() end

script.set_up_boss_floor = set_up_boss_floor
script[99] = script.set_up_boss_floor

--- Places the party and plays the curse jet scene before the boss encounter on the first visit.
function script.default_event()
	local curse_scene_flag: s32 = 0
	set_up_boss_floor()
	character.place_standing(0.0, 0.0, 0.0, 0.0)
	event.set_camera_look_at(0.0, 30.0, 0.0)
	event.set_camera_position(0.0, 40.0, -120.0)
	event.reset_follow_camera(0)
	curse_scene_flag = event.get_save_flag(808) or curse_scene_flag
	if curse_scene_flag == 0 then
		zelmite_mine_s54.play_curse_jet_scene()
		event.set_save_control_bits(1, 1)
		vm.wait(2)
		character.place_standing(0.0, 0.0, 300.0, 0.0)
		event.set_camera_look_at(0.0, 30.0, 300.0)
		event.set_camera_position(0.0, 40.0, 180.0)
		event.reset_follow_camera(0)
		event.load_dungeon_monster(628, 1)
		event.load_dungeon_monster(1006, 0)
		event.place_dungeon_monster(628, 0.0, 0.0, 800.0, 0.0, 3.14, 0.0)
	end
	event.fade_in_screen(30)
	event.finish_event()
end

--- Waits a frame and then waits for a button press.
function script.key_open()
	vm.wait(1)
	wait.until_button_pressed(64)
end

--- Event 151, which map data, a script or the engine runs by number.
script.begin_boss_encounter = begin_boss_encounter
script[151] = script.begin_boss_encounter

--- Asks whether to descend to the next floor and moves the party there on a yes.
function script.ask_to_go_to_next_floor()
	local playable_character: s32 = 0
	local answer: any = 0
	local stage_id: s32 = 0
	local floor: s32 = 0
	local next_floor: s32 = 0
	event.initialize_event()
	event.reset_action_character_motion(0)
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 2 or playable_character == 3 then
		event.set_message_window_mode(0, 1)
		event.set_message_draw_speed(0, 1)
		if playable_character == 2 then
			message.show_and_wait(0, 20, 5, 256, 208)
		else
			message.show_and_wait(0, 21, 5, 256, 208)
		end
		event.finish_event()
		return
	end
	event.set_message_selection_top_line(0, 0)
	event.set_message_window_mode(0, 5)
	event.set_message_draw_speed(0, 1)
	answer = message.ask_choice(0, 10, 8, 256, 208, 2, 1)
	if answer == 0 then
		event.fade_out_screen(30)
		wait.frames(30)
		stage_id = event.get_dungeon_stage_id() or stage_id
		floor = event.get_dungeon_floor() or floor
		next_floor = event.get_dungeon_next_floor(floor, 0) or next_floor
		event.set_dungeon_floor(next_floor)
		event.set_dungeon_floor_info(stage_id, floor, 5, 2)
		event.set_dungeon_floor_info(stage_id, next_floor, 5, 1)
		event.load_event_script("d07/d07.stb", 1000)
	else
		event.finish_event()
	end
end
script[300] = script.ask_to_go_to_next_floor

--- Fades out, plays the curse reaction scene and returns the party to the arena with the door parts placed.
function script.cutscene_curse_reaction()
	local playable_character: s32 = 0
	local checkpoint: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.reset_action_character_motion(0)
		event.fade_out_music(20)
		event.fade_out_screen(20)
		checkpoint = 1
		wait.frames(20)
		event.stop_music(0)
		event.clear_event_battle_monsters(-1)
		playable_character = event.get_playable_character() or playable_character
		if playable_character == 2 then
			event.switch_dungeon_main_character(0)
		end
		if playable_character == 3 then
			event.switch_dungeon_main_character(1)
		end
		checkpoint = 2
		zelmite_mine_s54.play_curse_reaction_scene()
		event.set_save_control_bits(1, 0)
		zelmite_mine_s54.place_door_parts()
		character.place_standing(0.0, 0.0, 700.0, 0.0)
		event.set_camera_look_at(0.0, 30.0, 700.0)
		event.set_camera_position(0.0, 40.0, 580.0)
		event.reset_follow_camera(0)
		event.fade_in_screen(30)
		event.finish_event()
		return
	end, function(received: { any })
		if checkpoint <= 2 then
			if checkpoint <= 1 then
				checkpoint = 2
				zelmite_mine_s54.play_curse_reaction_scene()
				return vm.continue_with(function()
					event.set_save_control_bits(1, 0)
					zelmite_mine_s54.place_door_parts()
					character.place_standing(0.0, 0.0, 700.0, 0.0)
					event.set_camera_look_at(0.0, 30.0, 700.0)
					event.set_camera_position(0.0, 40.0, 580.0)
					event.reset_follow_camera(0)
					event.fade_in_screen(30)
					event.finish_event()
					return
				end)
			end
			zelmite_mine_s54.offset_door_angles()
			cutscene.ignore_coordinates(0.0, 0.0, 700.0, 0.0)
			return 0
		end
		return nil
	end)
end
script[500] = script.cutscene_curse_reaction

--- Runs a voiced or silent defeat sequence depending on the scene flags.
function script.on_player_defeated()
	local curse_scene_flag: s32 = 0
	local second_scene_flag: s32 = 0
	local random_roll: s32 = 0
	local checkpoint: number = 0
	return vm.guard(function()
		curse_scene_flag = event.get_save_flag(808) or curse_scene_flag
		second_scene_flag = event.get_save_flag(812) or second_scene_flag
		if curse_scene_flag ~= 0 and second_scene_flag == 0 then
			random_roll = 0
			random_roll = event.get_random_number_int(100) or random_roll
			if random_roll < 50 then
				checkpoint = 1
				dungeon.handle_defeat_with_dialogue_voiced(0, 8590060)
			else
				checkpoint = 2
				dungeon.handle_defeat_with_dialogue_voiced(0, 8590070)
			end
			return
		end
		checkpoint = 3
		dungeon.handle_defeat_with_dialogue_silent(0)
		return
	end, function(received: { any })
		if checkpoint <= 2 then
			if checkpoint <= 1 then
				dungeon.skip_defeat_dialogue_sequence_voiced(0, 8590070)
			end
			return 0
		end
		if checkpoint <= 3 then
			return 0
		end
		return nil
	end)
end
script[1200] = script.on_player_defeated

--- Sets up the floor and plays the curse jet scene.
function script.replay_curse_jet_scene()
	set_up_boss_floor()
	zelmite_mine_s54.play_curse_jet_scene()
end
script[18080] = script.replay_curse_jet_scene

--- Sets up the floor and plays the curse reaction scene.
function script.replay_curse_reaction_scene()
	set_up_boss_floor()
	zelmite_mine_s54.play_curse_reaction_scene()
end
script[18120] = script.replay_curse_reaction_scene

script[28010] = script.begin_boss_encounter

return script
