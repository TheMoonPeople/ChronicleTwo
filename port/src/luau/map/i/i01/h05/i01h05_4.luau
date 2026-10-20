--!strict
-- map/i/i01/h05/i01h05_4.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1e8f7ae6 = require("@lib/event/helper_1e8f7ae6")
local helper_1ef0d4b2 = require("@lib/event/helper_1ef0d4b2")
local helper_6b76a271 = require("@lib/event/helper_6b76a271")

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
	helper_6b76a271()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 1000.
script[1000] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_1e8f7ae6()
	if vm.skipping() then
		return skip(1)
	end
end

return script
