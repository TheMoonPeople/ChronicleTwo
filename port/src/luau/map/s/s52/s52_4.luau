--!strict
--- Runs the Zelmite mine entrance floor: the first-visit light scene and the stairs to the next floor.

local vm = require("@lib/vm")
local character = require("@lib/event/character")
local dungeon = require("@lib/event/dungeon")
local message = require("@lib/event/message")
local wait = require("@lib/event/wait")
local zelmite_mine_s52 = require("@lib/event/zelmite_mine_s52")

--- Stops the music and loads the floor's sounds.
local function set_up_mine_sounds()
	event.stop_music(0)
	event.load_map_sounds(8800)
end

local script: { [any]: (...any) -> ...any } = {}

--- Does nothing at load time.
function script.setup() end

script.set_up_mine_sounds = set_up_mine_sounds
script[99] = script.set_up_mine_sounds

--- Places the party, adds party members and plays the light scene on the first visit.
function script.default_event()
	local light_scene_flag: s32 = 0
	set_up_mine_sounds()
	character.place_standing(0.0, 0.0, 0.0, 0.0)
	event.set_camera_look_at(0.0, 30.0, 0.0)
	event.set_camera_position(0.0, 40.0, -120.0)
	event.reset_follow_camera(0)
	light_scene_flag = event.get_save_flag(804) or light_scene_flag
	if light_scene_flag == 0 then
		event.set_party_member(1, 1)
		event.set_character_change_enabled(1, 1)
		event.set_character_change_unmasked(1, 1)
		event.set_party_member(3, 1)
		event.set_character_change_enabled(3, 1)
		event.set_character_change_unmasked(3, 1)
		zelmite_mine_s52.play_light_scene()
		character.place_standing_and_reset_cloth(0.0, 0.0, 800.0, 0.0)
		event.set_camera_look_at(0.0, 30.0, 800.0)
		event.set_camera_position(0.0, 40.0, 680.0)
		event.reset_follow_camera(0)
	end
	event.fade_in_screen(30)
	event.finish_event()
end

--- Waits a frame and then ends the event.
function script.key_open()
	event.initialize_event()
	vm.wait(1)
	event.finish_event()
end

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

--- Runs the defeat sequence with a silent message when the party is defeated.
function script.on_player_defeated()
	dungeon.run_defeat_sequence_with_message_silent(0)
end
script[1200] = script.on_player_defeated

--- Event 18040, which map data, a script or the engine runs by number.
script[18040] = zelmite_mine_s52.play_light_scene

return script
