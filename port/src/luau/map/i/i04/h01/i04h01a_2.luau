--!strict
-- map/i/i04/h01/i04h01a_2.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_49824eab = require("@lib/event/helper_49824eab")
local helper_9918e7ce = require("@lib/event/helper_9918e7ce")

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
	helper_9918e7ce()
	if vm.skipping() then
		return skip(1)
	end
end

return script
