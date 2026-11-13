--!strict
--- Event script for a Starlight Temple interior room that only resets the camera and offers villager conversation.

local cutscene = require("@lib/event/cutscene")
local message = require("@lib/event/message")

local script: { [any]: (...any) -> ...any } = {}

--- Does nothing at load time.
function script.setup() end

--- Event 99, which map data, a script or the engine runs by number.
script[99] = cutscene.noop

--- Resets the follow camera behind the player.
function script.default_event()
	event.reset_follow_camera(1, 0.0)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing, so the square button has no effect here.
function script.key_open() end

--- Event 1000, which map data, a script or the engine runs by number.
script[1000] = message.talk_to_stella_villager

return script
