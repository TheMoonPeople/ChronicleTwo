--!strict
-- map/i/i04/h05/i04h05_1.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_9c20c95c = require("@lib/event/helper_9c20c95c")
local helper_c104ed18 = require("@lib/event/helper_c104ed18")

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 100.
script[100] = helper_9c20c95c

--- Program 150.
-- Defined empty, so the engine runs this instead of its default.
script[150] = function() end

--- Program 1000.
script[1000] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_c104ed18()
	if vm.skipping() then
		return skip(1)
	end
end

return script
