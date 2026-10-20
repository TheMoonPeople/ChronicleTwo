--!strict
-- map/i/i04/h01/i04h01c_3.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1ef0d4b2 = require("@lib/event/helper_1ef0d4b2")
local helper_8108896c = require("@lib/event/helper_8108896c")
local helper_b210bd18 = require("@lib/event/helper_b210bd18")

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 100.
script[100] = helper_1ef0d4b2

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
	helper_b210bd18()
	if vm.skipping() then
		return skip(1)
	end
end

return script
