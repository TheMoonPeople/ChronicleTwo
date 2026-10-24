--!strict
-- map/i/i04/h01/i04h01a_5.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_49824eab = require("@lib/event/helper_49824eab")
local helper_a31e6d5f = require("@lib/event/helper_a31e6d5f")

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 100.
-- Defined empty, so the engine runs this instead of its default.
script[100] = function() end

--- Program 150.
script[150] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_49824eab(0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 1000.
script[1000] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_a31e6d5f()
	if vm.skipping() then
		return skip(1)
	end
end

return script
