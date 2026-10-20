--!strict
-- map/i/i03/h02/i03h02b_4.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_b9c0b815 = require("@lib/event/helper_b9c0b815")
local helper_f8120853 = require("@lib/event/helper_f8120853")

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 150.
script[150] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_f8120853()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 151.
script[151] = function()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_f8120853()
			if not vm.skipping() then
				return part2()
			end
		end
	end
	function part2()
		event.MapJump(-1, "m06", 153)
	end
	helper_b9c0b815()
	if vm.skipping() then
		return skip(1)
	end
	helper_f8120853()
	if vm.skipping() then
		return skip(2)
	end
	return part2()
end

return script
