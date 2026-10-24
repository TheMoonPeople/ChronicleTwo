--!strict
-- map/s/s35/s35_2.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_366230b5 = require("@lib/event/helper_366230b5")
local helper_6c2bab62 = require("@lib/event/helper_6c2bab62")

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 150.
-- Defined empty, so the engine runs this instead of its default.
script[150] = function() end

--- Program 500.
script[500] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_6c2bab62()
	if vm.skipping() then
		return skip(1)
	end
	event.LoadDungeonMapFile("d06e01")
	event.LoadScript("d06e01/d06e01.stb", 506)
	if vm.wait() then
		return skip(2)
	end
end

--- Program 502.
script[502] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_366230b5()
	if vm.skipping() then
		return skip(1)
	end
	event.LoadDungeonMapFile("d06e01")
	event.LoadScript("d06e01/d06e01.stb", 508)
	if vm.wait() then
		return skip(2)
	end
end

return script
