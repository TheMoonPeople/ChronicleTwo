--!strict
-- map/f/f02/i06/f02i06_5.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1156829a = require("@lib/event/helper_1156829a")
local helper_1ef0d4b2 = require("@lib/event/helper_1ef0d4b2")

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 99.
script[99] = helper_1ef0d4b2

--- Program 100.
script[100] = function()
	event.ResetCamera(1, 0.0)
end

--- Program 150.
-- Defined empty, so the engine runs this instead of its default.
script[150] = function() end

--- Program 1000.
script[1000] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_1156829a()
	if vm.skipping() then
		return skip(1)
	end
end

return script
