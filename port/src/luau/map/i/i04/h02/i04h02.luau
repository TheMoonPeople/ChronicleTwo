--!strict
-- map/i/i04/h02/i04h02.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_cb183627 = require("@lib/event/helper_cb183627")
local helper_ec68643c = require("@lib/event/helper_ec68643c")

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 100.
script[100] = helper_cb183627

--- Program 150.
-- Defined empty, so the engine runs this instead of its default.
script[150] = function() end

--- Program 1000.
script[1000] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_ec68643c()
	if vm.skipping() then
		return skip(1)
	end
end

return script
