--!strict
-- map/i/i01/h06/i01h06_5.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_11b7b824 = require("@lib/event/helper_11b7b824")
local helper_14c603be = require("@lib/event/helper_14c603be")
local helper_1ef0d4b2 = require("@lib/event/helper_1ef0d4b2")

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 100.
script[100] = function()
	helper_1ef0d4b2()
	event.SetCharaPos(0, 0.0, 9.0, 171.0)
	event.SetCharaRot(0, 0, 3.14, 0)
end

--- Program 200.
script[200] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_14c603be()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 1000.
script[1000] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_11b7b824()
	if vm.skipping() then
		return skip(1)
	end
end

return script
