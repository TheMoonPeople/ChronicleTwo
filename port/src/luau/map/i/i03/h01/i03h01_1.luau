--!strict
-- map/i/i03/h01/i03h01_1.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_b8e23f58 = require("@lib/event/helper_b8e23f58")

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 100.
script[100] = function()
	event.ResetCamera(1, 0.0, 10.0)
end

--- Program 150.
-- Defined empty, so the engine runs this instead of its default.
script[150] = function() end

--- Program 200.
script[200] = function()
	print("----200----------------------------------------\n")
end

--- Program 210.
script[210] = function()
	print("----210----------------------------------------\n")
end

--- Program 1000.
script[1000] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_b8e23f58()
	if vm.skipping() then
		return skip(1)
	end
end

return script
