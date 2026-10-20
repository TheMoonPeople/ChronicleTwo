--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_aafd6a80 = require("@lib/event/helper_aafd6a80")

--- Helper function.
local function helper_b436078b()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_aafd6a80(20)
		end
		if at <= 2 then
			helper_aafd6a80(10)
		end
		if at <= 3 then
			helper_aafd6a80(10)
		end
	end
	event.Initialize()
	event.EohSyncChara(0, 0)
	event.EohSetFootSoundId(0, 6)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.CharaActive(0, 0)
	event.ObjsSetPos(0, -150.0, 35.8, -1260.0)
	event.ObjsSetRot(0, 0.0, -1.57, 0.0)
	event.EohSyncObj(1, "p01_train01")
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.ObjsSetPos(1, -119.0, 0.0, -2000.0)
	event.ObjsSetRot(1, 0.0, 3.14, 0.0)
	event.EohSyncObj(2, "p01_train01", "train08-m0")
	event.EohSyncObj(3, "p01_train01", "train08-m1")
	event.EohSyncObj(4, "p01_train01", "train10-m0")
	event.EohSyncObj(5, "p01_train01", "train10-m1")
	event.EohSyncObj(6, "p01_train01", "train10-m12")
	event.EohSyncObj(7, "p01_train01", "train10-m13")
	event.ObjsSyncObj(2, 2)
	event.ObjsSetRot(2, 0.0, 0.0, 0.0)
	event.ObjsSyncObj(3, 3)
	event.ObjsSetRot(3, 0.0, 0.0, 0.0)
	event.ObjsSyncObj(4, 4)
	event.ObjsSetRot(4, 0.0, 0.0, 0.0)
	event.ObjsSyncObj(5, 5)
	event.ObjsSetRot(5, 0.0, 0.0, 0.0)
	event.ObjsSyncObj(6, 6)
	event.ObjsSetRot(6, 0.0, 0.0, 0.0)
	event.ObjsSyncObj(7, 7)
	event.ObjsSetRot(7, 0.0, 0.0, 0.0)
	var0 = event.GetSndId(2) or var0
	event.SndSePlay(var0, 66)
	event.CmrsSetPos(-286.2, 99.77, -1363.38)
	event.CmrsSetRef(-195.75, 74.39, -1275.17)
	event.ObjsSetPos(1, -119.0, 0.0, -1800.0)
	event.SetFadeIn(30)
	event.CharaActive(0)
	event.ObjsRotation(2, 0.0, 1.5, 0.0, 30)
	event.ObjsRotation(3, 0.0, -1.5, 0.0, 30)
	event.ObjsRotation(4, 0.0, 1.5, 0.0, 30)
	event.ObjsRotation(5, 0.0, -1.5, 0.0, 30)
	event.ObjsRotation(6, 0.0, 1.5, 0.0, 30)
	event.ObjsRotation(7, 0.0, -1.5, 0.0, 30)
	helper_aafd6a80(20)
	if vm.skipping() then
		return skip(1)
	end
	event.ObjsSetMotion(0, "走り")
	event.ObjsMove(0, -232.0, 35.8, -1260.0, 30)
	helper_aafd6a80(20)
	if vm.skipping() then
		return skip(2)
	end
	event.EohSetFootSoundId(0, 2)
	helper_aafd6a80(10)
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsSetMotion(0, "立ち")
	helper_aafd6a80(10)
	if vm.skipping() then
		return skip(4)
	end
	event.CharaActive(0)
	event.SetCharaPos(0, -232.0, 35.8, -1260.0)
	event.SetCharaRot(0, 0.0, 0.0, 0.0)
	event.SetMotion(0, "立ち", 4)
	event.CharaNormalDrive(0)
	event.CharaResetDa(0)
	event.EohSetPos(1, -119.0, 0.0, -1800.0)
	event.EohSetRot(2, 0.0, 0.0, 0.0)
	event.EohSetRot(3, 0.0, 0.0, 0.0)
	event.EohSetRot(4, 0.0, 0.0, 0.0)
	event.EohSetRot(5, 0.0, 0.0, 0.0)
	event.EohSetRot(6, 0.0, 0.0, 0.0)
	event.EohSetRot(7, 0.0, 0.0, 0.0)
	event.EohSetFootSoundId(0, 0)
	event.ResetCamera(1, 3.14, 28.0)
end

return helper_b436078b
