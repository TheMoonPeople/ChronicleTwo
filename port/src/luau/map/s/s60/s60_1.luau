--!strict
-- map/s/s60/s60_1.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_062c3aea = require("@lib/event/helper_062c3aea")
local helper_b0211f82 = require("@lib/event/helper_b0211f82")
local helper_b1da3dd7 = require("@lib/event/helper_b1da3dd7")

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 99.
-- Defined empty, so the engine runs this instead of its default.
script[99] = function() end

--- Program 100.
-- Defined empty, so the engine runs this instead of its default.
script[100] = function() end

--- Program 150.
script[150] = function()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_062c3aea()
			if not vm.skipping() then
				return part2()
			end
		end
	end
	function part2() end
	event.SetTime(22.0)
	event.SetTimeStepEnable(0)
	helper_b0211f82(30)
	if vm.skipping() then
		return skip(1)
	end
	helper_062c3aea()
	if vm.skipping() then
		return skip(2)
	end
	return part2()
end

--- Program 500.
script[500] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_b1da3dd7()
	if vm.skipping() then
		return skip(1)
	end
	event.SetExitFlag(1)
end

return script
