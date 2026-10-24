--!strict
-- map/i/i04/h05/i04h05_4.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_59517f1e = require("@lib/event/helper_59517f1e")
local helper_9c20c95c = require("@lib/event/helper_9c20c95c")

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
	helper_59517f1e()
	if vm.skipping() then
		return skip(1)
	end
end

return script
