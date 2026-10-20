--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_8f31f334 = require("@lib/event/helper_8f31f334")
local helper_aafd6a80 = require("@lib/event/helper_aafd6a80")

--- Helper function.
local function helper_4adb8cbe()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_aafd6a80(60)
		end
		if at <= 2 then
			helper_aafd6a80(15)
		end
		if at <= 3 then
			helper_8f31f334(0)
		end
		if at <= 4 then
			helper_aafd6a80(10)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	event.CharaActive(0, 0)
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.EohSyncObj(1, "p01_train01")
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.EohSyncObj(2, "p01_train01", "s3601_12-m1")
	event.ObjsSyncObj(2, 2)
	event.ObjsSetRot(2, 0.0, 0.0, 0.0)
	event.EohSyncObj(3, "p01_train01", "s3601_14-m6")
	event.ObjsSyncObj(3, 3)
	event.ObjsSetRot(3, 0.0, 0.0, 0.0)
	event.ObjsSetPos(1, -119.0, 0.0, -1800.0)
	event.ObjsSetRot(1, 0.0, 3.14, 0.0)
	event.CmrsInit()
	event.CmrsSetPos(-286.2, 99.77, -1363.38)
	event.CmrsSetRef(-195.75, 74.39, -1275.17)
	event.SetFadeIn(30)
	helper_aafd6a80(60)
	if vm.skipping() then
		return skip(2)
	end
	event.CharaActive(0)
	event.ObjsSetPos(0, -150.0, 35.8, -1260.0)
	event.ObjsSetRot(0, 0.0, -1.57, 0.0)
	event.ObjsRotation(2, 0.0, 0.0, 1.5707964, 30)
	event.ObjsRotation(3, 0.0, 0.0, 1.5707964, 30)
	var0 = event.GetSndId(2) or var0
	event.SndSePlay(var0, 92)
	helper_aafd6a80(15)
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsMove(0, -232.0, 35.8, -1260.0, 30)
	event.ObjsSetMotion(0, "走り", 4)
	event.EohSetFootSoundId(0, 6)
	helper_8f31f334(0)
	if vm.skipping() then
		return skip(4)
	end
	event.EohSetFootSoundId(0, 0)
	event.ObjsSetMotion(0, "立ち")
	helper_aafd6a80(10)
	if vm.skipping() then
		return skip(5)
	end
	event.SetFadeIn(1)
	event.EohSetPos(1, -119.0, 0.0, -1800.0)
	event.EohSetRot(2, 0.0, 0.0, 0.0)
	event.EohSetRot(3, 0.0, 0.0, 0.0)
	event.CharaActive(0)
	event.SetCharaPos(0, -232.0, 35.8, -1260.0)
	event.SetCharaRot(0, 0.0, 0.0, 0.0)
	event.SetMotion(0, "立ち", 4)
	event.CharaNormalDrive(0)
	event.CharaResetDa(0)
	event.ResetCamera(1, 3.14, 28.0)
	event.SetFadeIn(15)
end

return helper_4adb8cbe
