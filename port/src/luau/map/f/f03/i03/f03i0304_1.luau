--!strict
--- Event script for the fourth Luna lab interior, which only has an entrance and an exit door.

local vm = require("@lib/vm")
local character = require("@lib/event/character")
local cutscene = require("@lib/event/cutscene")
local luna_lab_villagers = require("@lib/event/english/luna_lab_villagers")
local wait = require("@lib/event/wait")

local script: { [any]: (...any) -> ...any } = {}

--- Does nothing at load time.
function script.setup() end

--- Fades in and places the player at the entrance.
function script.default_event()
	cutscene.noop()
	cutscene.noop()
	event.fade_in_screen(20)
	character.place_standing(vm.f32(87.9), vm.f32(69.1), -196.5, vm.f32(1.55))
	event.reset_follow_camera(1, 3.14)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing, so the square button has no effect here.
function script.key_open() end

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

return script
