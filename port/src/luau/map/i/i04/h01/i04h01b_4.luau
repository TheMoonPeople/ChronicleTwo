--!strict
-- map/i/i04/h01/i04h01b_4.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1ef0d4b2 = require("@lib/event/helper_1ef0d4b2")
local helper_88b282b5 = require("@lib/event/helper_88b282b5")

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 100.
script[100] = function()
	helper_1ef0d4b2()
	event.ResetCamera(1, 0.0)
end

--- Program 150.
script[150] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_88b282b5()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 151.
script[151] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_88b282b5()
	if vm.skipping() then
		return skip(1)
	end
	event.GotoDng(0, -1, 1000)
end

--- Program 11010.
script[11010] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_88b282b5()
	if vm.skipping() then
		return skip(1)
	end
end

return script
