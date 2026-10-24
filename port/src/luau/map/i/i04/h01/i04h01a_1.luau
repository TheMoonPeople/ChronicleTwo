--!strict
-- map/i/i04/h01/i04h01a_1.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_2c2c0f16 = require("@lib/event/helper_2c2c0f16")
local helper_8108896c = require("@lib/event/helper_8108896c")

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
	helper_8108896c(0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 1000.
script[1000] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_2c2c0f16()
	if vm.skipping() then
		return skip(1)
	end
end

return script
