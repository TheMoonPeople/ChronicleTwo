--!strict
-- map/m/m07/m07_1.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_b0211f82 = require("@lib/event/helper_b0211f82")
local helper_fc3befb4 = require("@lib/event/helper_fc3befb4")

--- Program 151.
local function program_151()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 2 then
			helper_fc3befb4()
			if not vm.skipping() then
				return part2()
			end
		end
	end
	function part2()
		event.MapJump(-1, "s42", 500)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFadeOut(0)
	if vm.wait() then
		return skip(2)
	end
	event.SetFlag(4, 1)
	helper_fc3befb4()
	if vm.skipping() then
		return skip(3)
	end
	return part2()
end

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
	helper_fc3befb4()
	if vm.skipping() then
		return skip(1)
	end
end

script[151] = program_151

--- Program 10010.
script[10010] = function()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			program_151()
			if not vm.skipping() then
				return part2()
			end
		end
	end
	function part2() end
	event.StopBgm(0)
	event.StopEnvBgm()
	helper_b0211f82(6)
	if vm.skipping() then
		return skip(1)
	end
	program_151()
	if vm.skipping() then
		return skip(2)
	end
	return part2()
end

return script
