--!strict
-- map/s/s43/s43b_1.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_8159f6f6 = require("@lib/event/helper_8159f6f6")
local helper_a756f03a = require("@lib/event/helper_a756f03a")

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 100.
script[100] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_a756f03a()
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
			helper_a756f03a()
			if not vm.skipping() then
				return part2()
			end
		end
	end
	function part2() end
	helper_8159f6f6()
	if vm.skipping() then
		return skip(1)
	end
	helper_a756f03a()
	if vm.skipping() then
		return skip(2)
	end
	return part2()
end

--- Program 152.
script[152] = function()
	event.GotoEdit(17, 153)
end

--- Program 8000.
script[8000] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_a756f03a()
	if vm.skipping() then
		return skip(1)
	end
end

return script
