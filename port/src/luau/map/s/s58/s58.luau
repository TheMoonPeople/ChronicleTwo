--!strict
-- map/s/s58/s58.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_8001137a = require("@lib/event/helper_8001137a")
local helper_c5d439e6 = require("@lib/event/helper_c5d439e6")

--- Helper function.
local function helper_b8ac()
	local var0: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_8001137a(0)
			end
			if at <= 2 then
				helper_c5d439e6(10)
			end
			if vm.skip_end() then
				return skip(4)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.ScrEffStopRaster(0.0, 0.0, 0.0, 0)
		event.CharaActive(0)
		event.SetSavedataEtc(0, 8)
		event.SeAllStop()
		event.SndInReverb(0)
		event.GotoDrawChapter(6)
		if vm.wait() then
			return skip(5)
		end
		event.SndInReverb(1)
		event.SetFadeOut(0)
	end
	event.SetFlag(600, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.LoadSound(4527)
	var0 = event.SndLoadSound(4527) or var0
	event.AssignStack(5)
	event.ClearStack(5)
	event.GetActiveChrNo()
	event.CharaActive(0, 0)
	event.EohSyncObj(0, "p01_train01")
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.EohSyncObj(1, "s58_2")
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.EohSetPos(0, 0.0, -120.0, -20000.0)
	event.EohSetPos(1, 0.0, 0.0, -20000.0)
	event.ScrEffInitRaster(0.0, 0.0, 0.0)
	event.ScrEffStartRaster(4.0, 0.15707964, 0.10471976, 0)
	event.ObjsMove(0, 0.0, -120.0, 2800.0, 120)
	event.ObjsMove(1, 0.0, 0.0, 2800.0, 120)
	event.CmrsInit()
	event.CmrsSetPos(146.6, -71.67, 641.16)
	event.CmrsSetRef(119.77, -62.2, 581.41)
	event.SetFadeIn(30)
	helper_c5d439e6(60)
	if vm.skipping() then
		return skip(1)
	end
	event.SndSePlay(var0, 2)
	helper_8001137a(0)
	if vm.skipping() then
		return skip(2)
	end
	event.SetFadeOut(10)
	helper_c5d439e6(10)
	if vm.skipping() then
		return skip(3)
	end
	return part2()
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 150.
script[150] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_b8ac()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 500.
script[500] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_b8ac()
	if vm.skipping() then
		return skip(1)
	end
	event.BgmLoadCancel()
	event.MapJump(-1, "s31", 500)
	if vm.wait() then
		return skip(2)
	end
end

return script
