--!strict
--- Girard house room script that handles the defeat message and villager recruitment dialogue.

local message = require("@lib/event/message")
local villager_recruitment = require("@lib/event/german/villager_recruitment")

local script: { [any]: (...any) -> ...any } = {}

--- Runs once when the script loads and needs no setup.
function script.setup() end

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing so the map's default entry behavior is suppressed.
function script.default_event() end

--- Shows the defeat message.
function script.key_open()
	message.show_defeat_message(0)
end

--- Event 1000, which map data, a script or the engine runs by number.
script[1000] = villager_recruitment.route_npc_talk

return script
