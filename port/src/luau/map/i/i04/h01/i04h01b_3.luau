--!strict
--- Girard house dining room script that plays the dinner argument scene.

local cutscene = require("@lib/event/cutscene")
local i04_girard_house = require("@lib/event/i04_girard_house")

local script: { [any]: (...any) -> ...any } = {}

--- Runs once when the script loads and needs no setup.
function script.setup() end

--- Resets the follow camera when the room is entered.
function script.default_event()
	cutscene.noop()
	event.reset_follow_camera(1, 0.0)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = i04_girard_house.play_dinner_argument_scene

--- Plays the dinner argument scene and enters the dungeon.
function script.cutscene_dinner_argument_then_enter_dungeon()
	i04_girard_house.play_dinner_argument_scene()
	event.go_to_dungeon(0, -1, 1000)
end
script[151] = script.cutscene_dinner_argument_then_enter_dungeon

--- Event 11010, which map data, a script or the engine runs by number.
script[11010] = i04_girard_house.play_dinner_argument_scene

return script
