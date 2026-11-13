--!strict
--- Girard House town house interior script that handles the defeat message.

local cutscene = require("@lib/event/cutscene")
local message = require("@lib/event/message")

local script: { [any]: (...any) -> ...any } = {}

--- Runs once when the script loads and needs no setup.
function script.setup() end

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
script.default_event = cutscene.noop

--- Shows the defeat message.
function script.key_open()
	message.show_defeat_message(0)
end

return script
