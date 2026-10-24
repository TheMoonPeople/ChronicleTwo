--!strict
-- map/i/i01/h06/i01h06.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_048fc858 = require("@lib/event/helper_048fc858")
local helper_1ef0d4b2 = require("@lib/event/helper_1ef0d4b2")
local helper_ec68643c = require("@lib/event/helper_ec68643c")

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
	helper_048fc858()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 1000.
script[1000] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_ec68643c()
	if vm.skipping() then
		return skip(1)
	end
end

return script
