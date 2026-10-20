--!strict
-- map/i/i03/h02/i03h02_2.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_051a08db = require("@lib/event/helper_051a08db")
local helper_3af2f24e = require("@lib/event/helper_3af2f24e")

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 100.
-- Defined empty, so the engine runs this instead of its default.
script[100] = function() end

--- Program 151.
script[151] = function()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_3af2f24e()
			if not vm.skipping() then
				return part2()
			end
		end
	end
	function part2()
		event.LoadScript("i03h02/i03h02_2.stb", 151)
	end
	helper_051a08db()
	if vm.skipping() then
		return skip(1)
	end
	helper_3af2f24e()
	if vm.skipping() then
		return skip(2)
	end
	return part2()
end

return script
