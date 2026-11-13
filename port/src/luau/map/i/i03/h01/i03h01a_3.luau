--!strict
--- Fishing Town house interior script that plays the house cutscenes and sends the player on to the dungeon or the next map.

local vm = require("@lib/vm")
local cutscene = require("@lib/event/cutscene")
local fishing_town_house_h01 = require("@lib/event/fishing_town_house_h01")
local map = require("@lib/event/map")
local villager_dialogue = require("@lib/event/german/villager_dialogue")

local script: { [any]: (...any) -> ...any } = {}

--- Runs once when the script loads and needs no setup.
function script.setup() end

--- Resets the follow camera when the interior is entered.
function script.default_event()
	cutscene.noop()
	event.reset_follow_camera(1)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing so the square-button hook is suppressed.
function script.key_open() end

--- Event 151, which map data, a script or the engine runs by number.
script[151] = fishing_town_house_h01.play_e109a_cutscene

--- Event 152, which map data, a script or the engine runs by number.
script[152] = fishing_town_house_h01.play_e109b_cutscene

--- Event 200, which map data, a script or the engine runs by number.
script[200] = map.enter_door_waiting_frames

--- Plays the first house cutscene and enters the dungeon.
function script.play_first_scene_then_enter_dungeon()
	fishing_town_house_h01.play_e109a_cutscene()
	event.go_to_dungeon(0, -1, 1000)
end
script[500] = script.play_first_scene_then_enter_dungeon

--- Plays the second house cutscene and jumps to the Train Town house map.
function script.play_second_scene_then_enter_train_house()
	fishing_town_house_h01.play_e109b_cutscene()
	event.skip_next_music_load()
	event.jump_to_map_3(-1, "i02h01", 500)
end
script[510] = script.play_second_scene_then_enter_train_house

--- Event 1000, which map data, a script or the engine runs by number.
script[1000] = villager_dialogue.talk_to_triggered_villager

--- Event 11091, which map data, a script or the engine runs by number.
script[11091] = fishing_town_house_h01.play_e109a_cutscene

--- Plays the second house cutscene with character slot 8 hidden and jumps to the Train Town house map.
function script.play_second_scene_with_character_8_hidden()
	event.set_character_active(0, 8)
	fishing_town_house_h01.play_e109b_cutscene()
	event.set_character_active(1, 8)
	event.skip_next_music_load()
	event.jump_to_map_3(-1, "i02h01", 500)
	vm.wait(2)
end
script[11092] = script.play_second_scene_with_character_8_hidden

return script
