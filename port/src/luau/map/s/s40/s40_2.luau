--!strict
-- map/s/s40/s40_2.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0eac9da0 = require("@lib/event/helper_0eac9da0")
local helper_45ea5155 = require("@lib/event/helper_45ea5155")
local helper_ffba0b68 = require("@lib/event/helper_ffba0b68")

--- Program 99.
local function program_99() end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

script[99] = program_99

--- Program 100.
script[100] = program_99

--- Program 150.
script[150] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_ffba0b68()
		end
	end
	helper_45ea5155()
	if vm.skipping() then
		return skip(1)
	end
	helper_ffba0b68()
	if vm.skipping() then
		return skip(2)
	end
end

--- Program 500.
script[500] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_0eac9da0()
	if vm.skipping() then
		return skip(1)
	end
	event.BgmLoadCancel()
	event.MapJump(-1, "g03", 510)
end

return script
