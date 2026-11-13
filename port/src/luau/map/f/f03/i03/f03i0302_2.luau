--!strict
--- Event script for the second Luna lab interior, with its story scene and exit door.

local vm = require("@lib/vm")
local character = require("@lib/event/character")
local cutscene = require("@lib/event/cutscene")
local field_town_f03_interior_i03 = require("@lib/event/field_town_f03_interior_i03")
local luna_lab_villagers = require("@lib/event/french/luna_lab_villagers")
local wait = require("@lib/event/wait")

local script: { [any]: (...any) -> ...any } = {}

--- Does nothing at load time.
function script.setup() end

--- Plays event 428 when due and otherwise places the player at the entrance.
function script.default_event()
	local story_flag_400: s32 = 0
	local event_428_done_flag: s32 = 0
	cutscene.noop()
	story_flag_400 = event.get_save_flag(400) or story_flag_400
	if story_flag_400 == 1 then
		event_428_done_flag = event.get_save_flag(428) or event_428_done_flag
		if event_428_done_flag == 0 then
			event.add_inventory_item(373)
			field_town_f03_interior_i03.play_event_428()
			return
		end
	end
	character.place_standing_and_reset_cloth(62.0, vm.f32(69.1), -197.0, vm.f32(1.57))
	event.reset_follow_camera(1, 3.14, 10)
	event.fade_in_screen(30)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = field_town_f03_interior_i03.play_event_428

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

--- Event 1000, which map data, a script or the engine runs by number.
script[1000] = luna_lab_villagers.talk_to_villager

--- Replays event 428.
function script.replay_event_428()
	cutscene.noop()
	field_town_f03_interior_i03.play_event_428()
end
script[14280] = script.replay_event_428

return script
