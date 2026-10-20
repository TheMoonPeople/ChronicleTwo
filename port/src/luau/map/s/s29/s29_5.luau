--!strict
-- map/s/s29/s29_5.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_8b9954d9 = require("@lib/event/helper_8b9954d9")

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 100.
script[100] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	if vm.wait() then
		return skip(1)
	end
	event.SetCharaPos(0, 0.0, 2721.0, -500.0)
	event.SetCharaRot(0, 0.0, 3.14, 0.0)
	event.ResetCamera(1, 3.14, 10.0)
	event.SetFadeIn(30)
end

--- Program 150.
script[150] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_8b9954d9()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 600.
script[600] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_8b9954d9()
	if vm.skipping() then
		return skip(1)
	end
	event.BgmLoadCancel()
	event.MapJump(-1, "s30", 605)
end

return script
