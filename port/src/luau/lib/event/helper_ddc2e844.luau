--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_75f3e820 = require("@lib/event/helper_75f3e820")
local helper_af6b904c = require("@lib/event/helper_af6b904c")

--- Helper function.
local function helper_ddc2e844()
	local var0: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_af6b904c(0)
			end
			if at <= 2 then
				helper_75f3e820(10)
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
	helper_75f3e820(60)
	if vm.skipping() then
		return skip(1)
	end
	event.SndSePlay(var0, 2)
	helper_af6b904c(0)
	if vm.skipping() then
		return skip(2)
	end
	event.SetFadeOut(10)
	helper_75f3e820(10)
	if vm.skipping() then
		return skip(3)
	end
	return part2()
end

return helper_ddc2e844
