--!strict
--- Event script for the Defending Wind Chamber boss room, handling the boss intro, the lapis reward and the gate to the next dungeon.

local vm = require("@lib/vm")
local character = require("@lib/event/character")
local defending_wind_chamber = require("@lib/event/defending_wind_chamber")
local dungeon = require("@lib/event/dungeon")
local message = require("@lib/event/message")
local object = require("@lib/event/object")
local wait = require("@lib/event/wait")

--- Stops the music, loads the room sounds and hides the rapis point once the boss is beaten.
local function init_map()
	local flag: s32 = 0
	event.stop_music(0)
	event.load_map_sounds(3694)
	flag = event.get_save_flag(628) or flag
	if flag == 1 then
		object.hide_rapis_point()
	end
end

local script: { [any]: (...any) -> ...any } = {}

--- Does nothing when the script loads.
function script.setup() end

script.init_map = init_map
script[99] = script.init_map

--- Sets up the boss room on entry, starting the boss intro when the boss is alive, and places the player.
function script.default_event()
	local flag: s32 = 0
	event.initialize_event()
	init_map()
	flag = event.get_save_flag(628) or flag
	if flag == 0 then
		defending_wind_chamber.play_boss_intro()
		event.set_function_point_enabled("", "rapis", 0)
		event.load_dungeon_monster(611, 1)
		event.place_dungeon_monster(611, 0.0, 0.0, -800.0, 0.0, 0.0, 0.0)
	end
	event.set_save_control_bits(1, if flag == 0 then 1 else 0)
	character.place_standing_and_reset_cloth(0.0, 0.0, 850.0, vm.f32(3.14))
	event.set_camera_look_at(0.0, 30.0, 850.0)
	event.set_camera_position(0.0, 40.0, 970.0)
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
	event.finish_event()
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = defending_wind_chamber.play_boss_intro

--- Asks whether to enter the dungeon once the boss is beaten, or refuses when the gem is not yet held.
function script.examine_dungeon_gate()
	local active_character: s32 = 0
	local flag: s32 = 0
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
	flag = event.get_save_flag(628) or flag
	if flag == 0 then
		event.set_message_window_mode(0, 1)
		event.set_message_draw_speed(0, 1)
		event.open_message_window_2(0, "Du hast den Edelstein\nnoch nicht!")
		message.show_and_wait(0, -1, 5, 256, 208)
		event.finish_event()
		return
	end
	answer = message.ask_yes_no(2, -1)
	if answer == 0 then
		event.fade_out_screen(15)
		wait.frames(15)
		event.clear_event_battle_monsters(-1)
		event.load_event_script("d03/d03.stb", 1000)
	end
	event.finish_event()
end
script[200] = script.examine_dungeon_gate

--- Gives the lapis, records the floor result and plays the acquisition scene.
function script.pick_up_lapis()
	local active_character: s32 = 0
	local stage_id: s32 = 0
	local dungeon_floor: s32 = 0
	local resume_step: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.reset_action_character_motion(0)
		active_character = event.get_playable_character() or active_character
		if active_character == 2 or active_character == 3 then
			event.set_message_window_mode(0, 1)
			event.set_message_draw_speed(0, 1)
			if active_character == 2 then
				resume_step = 1
				message.show_and_wait(0, 22, 5, 256, 208)
			else
				resume_step = 2
				message.show_and_wait(0, 23, 5, 256, 208)
			end
			event.finish_event()
			return
		end
		event.add_inventory_item(367, 1)
		event.fade_out_screen(10)
		resume_step = 3
		wait.frames(10)
		stage_id = event.get_dungeon_stage_id() or stage_id
		dungeon_floor = event.get_dungeon_floor() or dungeon_floor
		event.set_dungeon_floor_info(stage_id, dungeon_floor, 5, 2)
		resume_step = 4
		defending_wind_chamber.play_lapis_acquired()
		event.set_save_control_bits(1, 0)
		event.fade_in_screen(10)
		event.finish_event()
		return
	end, function(received: { any })
		if resume_step <= 2 then
			if resume_step <= 1 then
				message.show_and_wait_skipping(0, 23, 5, 256, 208)
			end
			return 0
		end
		if resume_step <= 4 then
			if resume_step <= 3 then
				resume_step = 4
				defending_wind_chamber.play_lapis_acquired()
				return vm.continue_with(function()
					event.set_save_control_bits(1, 0)
					event.fade_in_screen(10)
					event.finish_event()
					return
				end)
			end
			return 0
		end
		return nil
	end)
end
script[500] = script.pick_up_lapis

--- Runs the defeat sequence when the party is defeated.
function script.on_party_defeated()
	dungeon.run_defeat_sequence_with_message_silent(0)
end
script[1200] = script.on_party_defeated

--- Enables the rapis point and starts the victory music when the floor is cleared.
function script.floor_clear()
	event.initialize_event()
	event.reset_action_character_motion(0)
	event.clear_event_battle_monsters(-1)
	event.set_function_point_enabled("", "rapis", 1)
	event.start_background_file_loads_1("snd2/bgm/bg_193.sound.json")
	wait.background_load()
	event.load_music_pack(193)
	event.play_music(0)
	event.finish_event()
end

--- Loads and places the boss and starts the battle music.
function script.start_boss_battle()
	event.initialize_event()
	vm.wait(1)
	event.load_dungeon_monster(611, 1)
	event.place_dungeon_monster(611, 0.0, 0.0, -800.0, 0.0, 0.0, 0.0)
	event.set_dungeon_pause_flags(16384, 1)
	event.stop_music(0)
	wait.frames(4)
	event.load_music(190)
	event.play_music(0)
	event.fade_in_screen(30)
	event.finish_event()
end
script[26020] = script.start_boss_battle

return script
