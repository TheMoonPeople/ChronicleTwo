--!strict
-- map/s/s44/s44_1.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_748ffd54 = require("@lib/event/helper_748ffd54")
local helper_89ef6e20 = require("@lib/event/helper_89ef6e20")
local helper_ec82b1f6 = require("@lib/event/helper_ec82b1f6")
local helper_f0093e4d = require("@lib/event/helper_f0093e4d")
local helper_f10dcb85 = require("@lib/event/helper_f10dcb85")

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 150.
script[150] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			helper_748ffd54(64)
		end
	end
	event.Initialize()
	if vm.wait() then
		return skip(1)
	end
	event.CmrsSetPos(31.07, 49.02, 53.789978)
	event.CmrsSetRef(-33.5, 41.8, 200.70001)
	if vm.wait() then
		return skip(2)
	end
	helper_748ffd54(64)
	if vm.skipping() then
		return skip(3)
	end
	event.EsmClear()
	event.Finish()
end

--- Program 500.
script[500] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_ec82b1f6()
	if vm.skipping() then
		return skip(1)
	end
	event.MapJump(-1, "d06b03", 510)
end

--- Program 510.
script[510] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_f10dcb85()
	if vm.skipping() then
		return skip(1)
	end
	event.BgmLoadCancel()
	event.SoundLoadCancel()
	if vm.wait() then
		return skip(2)
	end
	event.LoadDungeonMapFile("d06b01")
	event.LoadScript("d06b01/d06b01.stb", 512)
end

--- Program 550.
script[550] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_89ef6e20()
	if vm.skipping() then
		return skip(1)
	end
	event.MapJump(-1, "g05", 550)
	if vm.wait() then
		return skip(2)
	end
end

--- Program 560.
script[560] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_f0093e4d()
	if vm.skipping() then
		return skip(1)
	end
	event.MapJump(-1, "g05", 560)
	if vm.wait() then
		return skip(2)
	end
end

--- Program 570.
script[570] = function()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_f0093e4d()
			if not vm.skipping() then
				return part2()
			end
		end
	end
	function part2()
		event.MapJump(-1, "g05", 560)
		if vm.wait() then
			return skip(3)
		end
	end
	helper_89ef6e20()
	if vm.skipping() then
		return skip(1)
	end
	helper_f0093e4d()
	if vm.skipping() then
		return skip(2)
	end
	return part2()
end

--- Program 17440.
script[17440] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_89ef6e20()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 17480.
script[17480] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_f0093e4d()
	if vm.skipping() then
		return skip(1)
	end
	event.MapJump(-1, "g05", 560)
	if vm.wait() then
		return skip(2)
	end
end

return script
