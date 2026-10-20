--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_2f481f12 = require("@lib/event/helper_2f481f12")
local helper_32dba483 = require("@lib/event/helper_32dba483")
local helper_e8f4b85c = require("@lib/event/helper_e8f4b85c")

--- Helper function.
local function helper_62073482()
	local var0: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 4 then
			if at <= 1 then
				helper_e8f4b85c(0)
			end
			if at <= 2 then
				helper_e8f4b85c(1)
			end
			if at <= 3 then
				helper_2f481f12(10)
			end
			if vm.skip_end() then
				return skip(5)
			end
			return part2()
		end
		helper_32dba483(2040.0, 0.0, -680.0, 0.0)
	end
	function part2()
		event.CancelDramaScene()
		event.EohSetFootSoundId(0, 0)
		event.EohSetRot(1, 0.0, 0.0, 0.0)
		event.EohSetPos(3, 0.0, 0.0, 0.0)
		helper_32dba483(2040.0, 0.0, -680.0, 0.0)
		event.SetCameraRef(2040.0, 30.0, -680.0)
		event.SetCameraPos(2040.0, 40.0, -580.0)
		event.ResetCamera(0)
		event.SetCrossfade(30)
		event.Finish()
	end
	event.Initialize()
	event.SetStatusbarShow(0, 1.0)
	var0 = event.SndLoadSound(8, "snd2/sp/sp_041.sound.json") or var0
	event.CharaActive(0)
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.EohSyncObj(1, "p02_d04b01")
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.EohSyncObj(3, "p03_d04b01")
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 3)
	event.EohSyncChara(4, 1)
	event.EohSyncChara(5, 2)
	event.EohSetShow(4, 0)
	event.EohSetShow(5, 0)
	event.EohSetPos(0, 2040.0, 0.0, -740.0)
	event.EohSetRot(0, 0.0, 0.0, 0.0)
	event.EohSetMotion(0, "立ち", 4)
	event.EohResetDaPosition(0)
	event.EohSetFootSoundId(0, 14)
	event.SndSePlay(var0, 0)
	event.ObjsRotation2(1, 0.0, 0.0, 3.14, 40, 0, 0.5)
	event.ObjsPosDelay(2, 80)
	event.ObjsMove2(2, 0.0, 80.0, 0.0, 32, 1, 0.5)
	event.CmrsInit()
	event.CmrsSetPos(2198.81, 99.4, -537.94)
	event.CmrsSetRef(2056.98, 54.61, -679.8)
	event.InitDramaScene()
	event.SetFadeIn(30)
	helper_2f481f12(110)
	if vm.skipping() then
		return skip(1)
	end
	event.ObjsMove(0, 2040.0, 0.0, -660.0, 60)
	event.ObjsSetMotion(0, "歩き")
	event.ObjsMotionDelay(0, 60)
	event.ObjsSetMotion(0, "立ち")
	helper_e8f4b85c(0)
	if vm.skipping() then
		return skip(2)
	end
	helper_e8f4b85c(1)
	if vm.skipping() then
		return skip(3)
	end
	helper_2f481f12(10)
	if vm.skipping() then
		return skip(4)
	end
	return part2()
end

return helper_62073482
