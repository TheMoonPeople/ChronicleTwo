--!strict
--- Event script for an interior of the f04 Gundorada area with only workshop villager conversation.

local workshop_villagers = require("@lib/event/english/workshop_villagers")

local script: { [any]: (...any) -> ...any } = {}

--- Does nothing when the script loads.
function script.setup() end

--- Event 99, which map data, a script or the engine runs by number.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing so the engine skips its default behavior.
function script.do_nothing() end
script[99] = script.do_nothing

--- Resets the follow camera on entry.
function script.default_event()
	event.reset_follow_camera(1, 0.0)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing so the engine skips its default behavior.
function script.key_open() end

--- Event 1000, which map data, a script or the engine runs by number.
script[1000] = workshop_villagers.talk_to_villager

return script
