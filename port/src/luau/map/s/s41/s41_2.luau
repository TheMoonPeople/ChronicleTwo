--!strict
-- map/s/s41/s41_2.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_72db0427 = require("@lib/event/helper_72db0427")

--- Program 99.
local function program_99() end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

script[99] = program_99

--- Program 100.
script[100] = program_99

--- Program 150.
-- Defined empty, so the engine runs this instead of its default.
script[150] = function() end

--- Program 501.
script[501] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_72db0427()
	if vm.skipping() then
		return skip(1)
	end
	event.MapJump(-1, "g04", 510)
	if vm.wait() then
		return skip(2)
	end
end

--- Program 15040.
script[15040] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_72db0427()
	if vm.skipping() then
		return skip(1)
	end
	event.MapJump(-1, "g04", 510)
	if vm.wait() then
		return skip(2)
	end
end

return script
