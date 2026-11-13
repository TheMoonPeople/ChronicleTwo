--!strict
--- Fishing Town house interior script that handles villager dialogue.

local villager_dialogue = require("@lib/event/english/villager_dialogue")

local script: { [any]: (...any) -> ...any } = {}

--- Runs once when the script loads and needs no setup.
function script.setup() end

--- Resets the follow camera when the interior is entered.
function script.default_event()
	event.reset_follow_camera(1, 0.0, 10.0)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing so the square-button hook is suppressed.
function script.key_open() end

--- Prints a debug marker for event 200.
function script.print_event_200_marker()
	print("----200----------------------------------------\n")
end
script[200] = script.print_event_200_marker

--- Prints a debug marker for event 210.
function script.print_event_210_marker()
	print("----210----------------------------------------\n")
end
script[210] = script.print_event_210_marker

--- Event 1000, which map data, a script or the engine runs by number.
script[1000] = villager_dialogue.talk_to_triggered_villager

return script
