--!strict
--- Event script for Osmond's lab interior, with its story scenes and exit door.

local vm = require("@lib/vm")
local character = require("@lib/event/character")
local field_town_f03_interior_i03 = require("@lib/event/field_town_f03_interior_i03")
local luna_lab_villagers = require("@lib/event/french/luna_lab_villagers")
local wait = require("@lib/event/wait")

local script: { [any]: (...any) -> ...any } = {}

--- Does nothing at load time.
function script.setup() end

--- Plays the Osmond scene due for the story flags and otherwise places the player at the entrance.
function script.default_event()
	local story_flag_400: s32 = 0
	local osmond_awake_flag: s32 = 0
	local event_414_done_flag: s32 = 0
	local event_412_done_flag: s32 = 0
	field_town_f03_interior_i03.setup_map()
	story_flag_400 = event.get_save_flag(400) or story_flag_400
	osmond_awake_flag = event.get_save_flag(408) or osmond_awake_flag
	if story_flag_400 == 1 then
		if osmond_awake_flag == 0 then
			event_414_done_flag = event.get_save_flag(414) or event_414_done_flag
			if event_414_done_flag == 0 then
				field_town_f03_interior_i03.play_event_414()
				return
			end
		else
			event_412_done_flag = event.get_save_flag(412) or event_412_done_flag
			if event_412_done_flag == 0 then
				event.add_inventory_item(360)
				field_town_f03_interior_i03.play_event_412()
				return
			end
		end
	end
	character.place_standing_and_reset_cloth(0.0, vm.f32(69.1), -200.0, vm.f32(-1.57))
	event.reset_follow_camera(1, 3.14, 10)
	event.fade_in_screen(30)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = field_town_f03_interior_i03.play_event_412

--- Faces the door, fades out and jumps back to the f03 town map.
function script.leave_to_town()
	local sound_effect_id: s32 = 0
	character.turn_player_to_rotation(vm.f32(3.1415927))
	event.set_character_motion(0, "立ち")
	sound_effect_id = event.get_sound_id(2) or sound_effect_id
	event.play_sound_effect(sound_effect_id, 94)
	event.fade_out_screen(30)
	wait.frames(30)
	event.jump_to_map_2(-1, "f03")
	vm.wait(3)
end
script[400] = script.leave_to_town

--- Gives the party an item and plays event 468.
function script.give_item_and_play_event_468()
	field_town_f03_interior_i03.setup_map()
	event.add_inventory_item(154)
	field_town_f03_interior_i03.play_event_468()
end
script[504] = script.give_item_and_play_event_468

--- Event 1000, which map data, a script or the engine runs by number.
script[1000] = luna_lab_villagers.talk_to_villager

--- Marks Osmond awake and replays event 412.
function script.replay_event_412()
	event.set_save_flag(408, 1)
	field_town_f03_interior_i03.setup_map()
	field_town_f03_interior_i03.play_event_412()
end
script[14120] = script.replay_event_412

--- Marks Osmond asleep and replays event 414.
function script.replay_event_414()
	event.set_save_flag(408, 0)
	field_town_f03_interior_i03.setup_map()
	field_town_f03_interior_i03.play_event_414()
end
script[14140] = script.replay_event_414

--- Replays event 468.
function script.replay_event_468()
	field_town_f03_interior_i03.setup_map()
	field_town_f03_interior_i03.play_event_468()
end
script[14680] = script.replay_event_468

return script
