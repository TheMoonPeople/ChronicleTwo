--!strict
-- map/s/s43/s43b_3.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1b215860 = require("@lib/event/helper_1b215860")
local helper_d7ebd2a3 = require("@lib/event/helper_d7ebd2a3")

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
script.default_event = helper_1b215860

--- Event 151, which map data, a script or the engine runs by number.
function script.event_151()
	local at: number = 0
	return vm.guard(function()
		at = 1
		helper_d7ebd2a3()
		at = 2
		helper_1b215860()
		return
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				at = 2
				helper_1b215860()
				return vm.continue_with(function()
					return
				end)
			end
			return 0
		end
		return nil
	end)
end

--- Event 152, which map data, a script or the engine runs by number.
function script.event_152()
	event.go_to_georama_edit(17, 153)
end

--- Event 8000, which map data, a script or the engine runs by number.
script.event_8000 = helper_1b215860

return script
