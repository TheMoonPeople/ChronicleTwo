--!strict
-- map/s/s40/s40_1.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_02be4c78 = require("@lib/event/helper_02be4c78")
local helper_2c7615ec = require("@lib/event/helper_2c7615ec")
local helper_76c5a354 = require("@lib/event/helper_76c5a354")

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
			helper_02be4c78()
		end
	end
	helper_76c5a354()
	if vm.skipping() then
		return skip(1)
	end
	helper_02be4c78()
	if vm.skipping() then
		return skip(2)
	end
end

--- Program 500.
script[500] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_2c7615ec()
	if vm.skipping() then
		return skip(1)
	end
	event.BgmLoadCancel()
	event.MapJump(-1, "g03", 510)
end

return script
