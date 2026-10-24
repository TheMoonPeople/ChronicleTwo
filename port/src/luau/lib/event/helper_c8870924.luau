--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_038a2e4d = require("@lib/event/helper_038a2e4d")
local helper_0958ca60 = require("@lib/event/helper_0958ca60")
local helper_238b5abc = require("@lib/event/helper_238b5abc")
local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")
local helper_946c0402 = require("@lib/event/helper_946c0402")
local helper_d7295df9 = require("@lib/event/helper_d7295df9")

--- Helper function.
local function helper_c8870924()
	local var0: s32 = 0
	local var1: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var5: f32 = 0
	local var6: s32 = 0
	local at: number = 0
	return vm.guard(function()
		var0 = event.GetCnt(0) or var0
		if var0 == 0 then
			helper_946c0402()
			event.CharaNormalDrive(0)
			event.CharaResetDa(0)
			event.ResetCamera(1, 0.0)
			event.SetFadeIn(30)
			return
		end
		var1 = event.GetCnt(15) or var1
		event.Initialize()
		event.EohSyncObj_2(1, "p01_train01")
		event.EohSetPos(1, -790.0, 0.0, 4500.0)
		event.EohSetRot(1, 0.0, -1.57, 0.0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		if var1 == 0 then
			event.EohSyncObj_3(2, "p01_train01", "s3601_12-m1")
			event.EohSyncObj_3(3, "p01_train01", "s3601_14-m1")
			event.EohSyncObj_3(4, "p01_train01", "s3601_16-m1")
			event.EohSyncObj_3(5, "p01_train01", "s3601_17-m")
			if var0 == 2 then
				event.EohSyncObj_3(2, "p01_train01", "s3601_12-m5")
				event.EohSyncObj_3(3, "p01_train01", "s3601_14-m3")
				event.EohSyncObj_3(4, "p01_train01", "s3601_16-m4")
				event.EohSyncObj_3(5, "p01_train01", "s3601_17-m2")
			end
			if var0 == 3 then
				event.EohSyncObj_3(2, "p01_train01", "s3601_12-m3")
				event.EohSyncObj_3(3, "p01_train01", "s3601_14-m5")
				event.EohSyncObj_3(4, "p01_train01", "s3601_16-m5")
				event.EohSyncObj_3(5, "p01_train01", "s3601_17-m4")
			end
		else
			event.EohSyncObj_3(2, "p01_train01", "s3601_12-m")
			event.EohSyncObj_3(3, "p01_train01", "s3601_14-m")
			event.EohSyncObj_3(4, "p01_train01", "s3601_16-m")
			event.EohSyncObj_3(5, "p01_train01", "s3601_17-m1")
			if var0 == 2 then
				event.EohSyncObj_3(2, "p01_train01", "s3601_12-m4")
				event.EohSyncObj_3(3, "p01_train01", "s3601_14-m2")
				event.EohSyncObj_3(4, "p01_train01", "s3601_16-m2")
				event.EohSyncObj_3(5, "p01_train01", "s3601_17-m3")
			end
			if var0 == 3 then
				event.EohSyncObj_3(2, "p01_train01", "s3601_12-m2")
				event.EohSyncObj_3(3, "p01_train01", "s3601_14-m4")
				event.EohSyncObj_3(4, "p01_train01", "s3601_16-m3")
				event.EohSyncObj_3(5, "p01_train01", "s3601_17-m5")
			end
		end
		event.ObjsSyncObj(2, 2)
		event.ObjsSetRot(2, 0.0, 0.0, 0.0)
		event.ObjsSyncObj(3, 3)
		event.ObjsSetRot(3, 0.0, 0.0, 0.0)
		event.ObjsSyncObj(4, 4)
		event.ObjsSetRot(4, 0.0, 0.0, 0.0)
		do
			local out1, out2, out3 = event.EohGetPos(5)
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		event.ObjsSyncObj(5, 5)
		event.ObjsSetRot(5, 0.0, 0.0, 0.0)
		var5 = -240.0
		if var0 == 2 then
			var5 = 270.0
		end
		if var0 == 3 then
			var5 = 790.0
		end
		event.CmrsInit()
		if var1 == 0 then
			event.CmrsSetPos(var5 + vm.f32(135.23), 32.86, 4778.39)
			event.CmrsSetRef(var5, 31.8, 4650.0)
		else
			event.CmrsSetPos(var5 - vm.f32(135.23), 32.86, 4221.61)
			event.CmrsSetRef(var5, 31.8, 4350.0)
		end
		event.SetFadeIn(30)
		if var1 == 0 then
			event.ObjsSetPos(0, var5, 25.9, 4550.0)
			event.ObjsSetRot(0, 0.0, 0.0, 0.0)
		else
			event.ObjsSetPos(0, var5, 30.0, 4480.0)
			event.ObjsSetRot(0, 0.0, 3.1415927, 0.0)
		end
		if var1 == 0 then
			event.ObjsRotation(2, 0.0, 0.0, 1.5707964, 30)
			event.ObjsRotation(3, 0.0, 0.0, 1.5707964, 30)
			event.ObjsRotation(4, 0.0, 0.0, -0.3926991, 30)
			event.ObjsRotation(5, 0.0, 0.0, -0.3926991, 30)
		else
			event.ObjsRotation(2, 0.0, 0.0, -1.5707964, 30)
			event.ObjsRotation(3, 0.0, 0.0, -1.5707964, 30)
			event.ObjsRotation(4, 0.0, 0.0, 0.3926991, 30)
			event.ObjsRotation(5, 0.0, 0.0, 0.3926991, 30)
		end
		var6 = event.GetSndId(2) or var6
		event.SndSePlay(var6, 92)
		at = 1
		helper_888ab2a3(30)
		event.ObjsMove(5, pos_x - 22.5, pos_y - 9.5, pos_z, 30)
		at = 2
		helper_888ab2a3(20)
		if var1 == 0 then
			event.ObjsMove(0, var5, 0.0, 4600.0, 30)
		else
			event.ObjsMove(0, var5, 0.0, 4400.0, 30)
		end
		event.ObjsSetMotion(0, "走り", 4)
		event.EohSetFootSoundId(0, 6)
		at = 3
		helper_0958ca60(0)
		event.EohSetFootSoundId(0, 0)
		event.ObjsSetMotion(0, "立ち")
		at = 4
		helper_888ab2a3(10)
		event.SetFadeIn(1)
		event.EohSetRot(2, 0.0, 0.0, 0.0)
		event.EohSetRot(3, 0.0, 0.0, 0.0)
		event.EohSetRot(4, 0.0, 0.0, 0.0)
		event.EohSetPos(5, pos_x, pos_y, pos_z)
		event.EohSetRot(5, 0.0, 0.0, 0.0)
		helper_946c0402()
		event.CharaNormalDrive(0)
		event.CharaResetDa(0)
		event.ResetCamera(1, 0.0)
		return
	end, function(received: { any })
		if at <= 4 then
			if at <= 1 then
				helper_038a2e4d(20)
			end
			if at <= 2 then
				helper_238b5abc(0)
			end
			if at <= 3 then
				helper_038a2e4d(10)
			end
			helper_d7295df9()
			return 0
		end
		return nil
	end)
end

return helper_c8870924
