--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_50d8aa5f = require("@lib/event/helper_50d8aa5f")
local helper_6a2c2111 = require("@lib/event/helper_6a2c2111")
local helper_aafd6a80 = require("@lib/event/helper_aafd6a80")

--- Helper function.
local function helper_0af16105()
	local var6: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 8 then
			if at <= 1 then
				helper_aafd6a80(30)
			end
			if at <= 2 then
				helper_aafd6a80(30)
			end
			if at <= 3 then
				helper_aafd6a80(30)
			end
			if at <= 4 then
				helper_aafd6a80(30)
			end
			if at <= 5 then
				helper_aafd6a80(30)
			end
			if at <= 6 then
				helper_aafd6a80(30)
			end
			if at <= 7 then
				helper_aafd6a80(35)
			end
			if vm.skip_end() then
				return skip(9)
			end
			return part2()
		end
		helper_50d8aa5f()
	end
	function part2()
		event.CancelDramaScene()
		event.BgmLoadCancel()
		event.SndSeAllStop(4)
		helper_50d8aa5f()
		event.ResetCamera(0)
		event.SetFadeIn(30)
	end
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	var6 = event.SndLoadSound(7202) or var6
	event.CharaActive(0, 0)
	helper_6a2c2111()
	event.InitDramaScene()
	event.ObjsSetPos(3, 418.95, 294.2, 1072.8)
	event.ObjsSetRot(3, 0.0, -2.72, 0.0)
	event.EohSyncChrobj(20, 39, "puropera")
	event.ObjsInit(20)
	event.ObjsSyncObj(20, 20)
	event.ObjsRotation(20, 0.0, -0.08, 0.0, -1)
	event.CharaActive(1, 39)
	event.ObjsSetMotion(3, "手を上げる", 6)
	event.SndSePlay(var6, 3)
	event.SndSePlay(var6, 4)
	event.SetFadeIn(30)
	event.CmrsSetPos(255.67, 441.0, 685.71)
	event.CmrsSetRef(418.95, 461.85, 1072.8)
	helper_aafd6a80(60)
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsSetPos(-1039.68, 1120.44, 3017.49)
	event.CmrsSetRef(-375.04, 936.38, 1696.66)
	event.CharaActive(1, 40)
	event.CharaActive(1, 41)
	event.ObjsSetMotion(3, "岩を投げる", 4)
	event.SndSePlay(var6, 5)
	event.ObjsSetPos(4, 418.95, 500.0, 1072.8)
	event.ObjsJump(4, -200.0, 500.0, -1000.0, -1.2, 60)
	helper_aafd6a80(30)
	if vm.skipping() then
		return skip(2)
	end
	event.SndSePlay(var6, 6)
	event.SndSePlay(var6, 5)
	event.ObjsSetPos(5, 418.95, 500.0, 1072.8)
	event.ObjsJump(5, 200.0, 500.0, -1000.0, -1.2, 60)
	helper_aafd6a80(30)
	if vm.skipping() then
		return skip(3)
	end
	event.SndSePlay(var6, 6)
	event.SndSePlay(var6, 5)
	event.ObjsSetPos(4, 418.95, 500.0, 1072.8)
	event.ObjsJump(4, -200.0, 500.0, -1000.0, -1.2, 60)
	helper_aafd6a80(30)
	if vm.skipping() then
		return skip(4)
	end
	event.SndSePlay(var6, 6)
	event.SndSePlay(var6, 5)
	event.ObjsSetPos(5, 418.95, 500.0, 1072.8)
	event.ObjsJump(5, 200.0, 500.0, -1000.0, -1.2, 60)
	helper_aafd6a80(30)
	if vm.skipping() then
		return skip(5)
	end
	event.SndSePlay(var6, 6)
	event.SndSePlay(var6, 5)
	event.ObjsSetPos(4, 418.95, 500.0, 1072.8)
	event.ObjsJump(4, -200.0, 500.0, -1000.0, -1.2, 60)
	helper_aafd6a80(30)
	if vm.skipping() then
		return skip(6)
	end
	event.SndSePlay(var6, 6)
	event.SndSePlay(var6, 5)
	event.ObjsSetPos(5, 418.95, 500.0, 1072.8)
	event.ObjsJump(5, 200.0, 500.0, -1000.0, -1.2, 60)
	helper_aafd6a80(30)
	if vm.skipping() then
		return skip(7)
	end
	event.SndSePlay(var6, 6)
	event.SetFadeOut(30)
	helper_aafd6a80(35)
	if vm.skipping() then
		return skip(8)
	end
	return part2()
end

return helper_0af16105
