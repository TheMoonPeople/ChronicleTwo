--!strict
-- map/i/i01/h05/i01h05.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1ef0d4b2 = require("@lib/event/helper_1ef0d4b2")
local helper_c026e6fb = require("@lib/event/helper_c026e6fb")
local helper_ffe53b10 = require("@lib/event/helper_ffe53b10")

--- Program 100.
local function program_100()
	helper_1ef0d4b2()
	event.Initialize()
	event.SetCharaPos(0, 43.5, 0.0, 135.0)
	event.SetCharaRot(0, 0, 3.14, 0)
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

script[100] = program_100

--- Program 123.
script[123] = program_100

--- Program 200.
script[200] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_ffe53b10()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 1000.
script[1000] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_c026e6fb()
	if vm.skipping() then
		return skip(1)
	end
end

return script
