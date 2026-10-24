--!strict
-- map/s/s49/s49_1.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_4b6e5068 = require("@lib/event/helper_4b6e5068")
local helper_b0211f82 = require("@lib/event/helper_b0211f82")
local helper_fcb847d6 = require("@lib/event/helper_fcb847d6")

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 100.
script[100] = function()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_4b6e5068()
			if not vm.skipping() then
				return part2()
			end
		end
	end
	function part2() end
	helper_b0211f82(30)
	if vm.skipping() then
		return skip(1)
	end
	helper_4b6e5068()
	if vm.skipping() then
		return skip(2)
	end
	return part2()
end

--- Program 150.
script[150] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_4b6e5068()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 500.
script[500] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_4b6e5068()
	if vm.skipping() then
		return skip(1)
	end
	event.BgmLoadCancel()
	event.LoadDungeonMapFile("d05b01")
	event.LoadScript("d05b01/d05b01.stb", 561)
end

--- Program 510.
script[510] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_fcb847d6()
	if vm.skipping() then
		return skip(1)
	end
	event.BgmLoadCancel()
	event.LoadDungeonMapFile("d05b01")
	event.LoadScript("d05b01/d05b01.stb", 571)
end

return script
