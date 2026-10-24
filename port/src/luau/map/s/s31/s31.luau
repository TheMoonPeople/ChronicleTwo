--!strict
-- map/s/s31/s31.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0695b715 = require("@lib/event/helper_0695b715")
local helper_42b7a2cf = require("@lib/event/helper_42b7a2cf")
local helper_4337dd96 = require("@lib/event/helper_4337dd96")
local helper_5b643440 = require("@lib/event/helper_5b643440")
local helper_7ee99e81 = require("@lib/event/helper_7ee99e81")
local helper_8ddec556 = require("@lib/event/helper_8ddec556")
local helper_9538e344 = require("@lib/event/helper_9538e344")
local helper_b2a6ae08 = require("@lib/event/helper_b2a6ae08")
local helper_c746120b = require("@lib/event/helper_c746120b")
local helper_ec15ccd9 = require("@lib/event/helper_ec15ccd9")

--- Program 99.
local function program_99()
	print("map_init-------------------------\n")
	helper_4337dd96()
end

--- Helper function.
local function helper_2ea08()
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.AssignStack(4)
	event.ClearStack(4)
	event.LoadChara(4, "chara/p00_31a.gltf", "info", 8)
	event.CharaActive(8)
	event.SetCharaPos(8, -300.0, 0.0, 3490.0)
	event.SetCharaRot(8, 0.0, 3.1415927, 0.0)
	event.SetCharaNo(8, 301)
end

--- Helper function.
local function helper_1a9dc(arg0: s32, arg1: s32, arg2: s32)
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		print("station_id=", arg0, ",train_id=", arg1, ",lr_id=", arg2, "\n")
		var3 = -220.0
		var4 = vm.f32(35.8)
		var5 = vm.f32(-1570.4)
		var6 = vm.f32(-1.57)
		var5 = vm.f32(-1251.8)
		var5 = vm.f32(-737.4)
		var5 = vm.f32(-219.7)
		var4 = 0.0
		var3 = -120.0
		var6 = vm.f32(-1.57)
		var5 = 445.0
		var5 = 150.0
		var5 = -365.0
		var5 = -880.0
		var3 = -100.0
		var4 = 36.0
		var6 = vm.f32(-1.57)
		var5 = 303.5
		var5 = vm.f32(-9.6)
		var5 = -526.5
		var5 = vm.f32(-1042.8)
		var4 = vm.f32(29.2)
		var5 = -100.0
		var6 = vm.f32(3.1415927)
		var3 = vm.f32(-1173.2)
		var3 = vm.f32(-1472.9)
		var3 = vm.f32(-1993.4)
		var3 = -2506.0
		var4 = 0.0
		var6 = vm.f32(-2.355)
		var3 = 2586.0
		var5 = 1378.0
		var3 = 2370.0
		var5 = 1610.0
		var3 = 2037.0
		var5 = 2000.0
		var3 = 1694.0
		var5 = 2389.0
		var3 = 690.0
		var3 = vm.f32(347.8)
		var3 = vm.f32(-168.4)
		var3 = -687.5
		var4 = vm.f32(-268.4)
		var5 = 3240.0
		var6 = vm.f32(3.1415927)
		var3 = -590.0
		var3 = vm.f32(-245.2)
		var3 = vm.f32(273.3)
		var3 = vm.f32(790.2)
		var4 = 0.0
		var5 = 4400.0
		var6 = vm.f32(3.1415927)
		var3 = 590.0
		var3 = 240.0
		var3 = -270.0
		var3 = -790.0
		var4 = 0.0
		var5 = 3450.0
		var6 = vm.f32(3.1415927)
		var3 = -590.0
		var3 = vm.f32(-245.2)
		var3 = vm.f32(273.3)
		var3 = vm.f32(790.2)
		var4 = 0.0
		var5 = 4400.0
		var6 = vm.f32(3.1415927)
	end
	if vm.skipping() then
		return skip(1)
	end
	print("station_id=", arg0, ",train_id=", arg1, ",lr_id=", arg2, "\n")
	var3 = -220.0
	var4 = vm.f32(35.8)
	var5 = vm.f32(-1570.4)
	var6 = vm.f32(-1.57)
	if arg1 == 1 then
		var5 = vm.f32(-1251.8)
	end
	if arg1 == 2 then
		var5 = vm.f32(-737.4)
	end
	if arg1 == 3 then
		var5 = vm.f32(-219.7)
	end
	if arg0 == 2 then
		var4 = 0.0
		var3 = -120.0
		var6 = vm.f32(-1.57)
		var5 = 445.0
		if arg1 == 1 then
			var5 = 150.0
		end
		if arg1 == 2 then
			var5 = -365.0
		end
		if arg1 == 3 then
			var5 = -880.0
		end
	end
	if arg0 == 3 then
		var3 = -100.0
		var4 = 36.0
		var6 = vm.f32(-1.57)
		var5 = 303.5
		if arg1 == 1 then
			var5 = vm.f32(-9.6)
		end
		if arg1 == 2 then
			var5 = -526.5
		end
		if arg1 == 3 then
			var5 = vm.f32(-1042.8)
		end
	end
	if arg0 == 4 then
		var4 = vm.f32(29.2)
		var5 = -100.0
		var6 = vm.f32(3.1415927)
		var3 = vm.f32(-1173.2)
		if arg1 == 1 then
			var3 = vm.f32(-1472.9)
		end
		if arg1 == 2 then
			var3 = vm.f32(-1993.4)
		end
		if arg1 == 3 then
			var3 = -2506.0
		end
	end
	if arg0 == 5 then
		var4 = 0.0
		var6 = vm.f32(-2.355)
		var3 = 2586.0
		var5 = 1378.0
		if arg1 == 1 then
			var3 = 2370.0
			var5 = 1610.0
		end
		if arg1 == 2 then
			var3 = 2037.0
			var5 = 2000.0
		end
		if arg1 == 3 then
			var3 = 1694.0
			var5 = 2389.0
		end
	end
	if arg0 == 6 then
		var3 = 690.0
		if arg1 == 2 then
			var3 = vm.f32(347.8)
		end
		if arg1 == 2 then
			var3 = vm.f32(-168.4)
		end
		if arg1 == 3 then
			var3 = -687.5
		end
		var4 = vm.f32(-268.4)
		var5 = 3240.0
		var6 = vm.f32(3.1415927)
	end
	if arg0 == 7 then
		var3 = -590.0
		if arg1 == 1 then
			var3 = vm.f32(-245.2)
		end
		if arg1 == 2 then
			var3 = vm.f32(273.3)
		end
		if arg1 == 3 then
			var3 = vm.f32(790.2)
		end
		var4 = 0.0
		var5 = 4400.0
		var6 = vm.f32(3.1415927)
	end
	if arg0 == 8 then
		var3 = 590.0
		if arg1 == 1 then
			var3 = 240.0
		end
		if arg1 == 2 then
			var3 = -270.0
		end
		if arg1 == 3 then
			var3 = -790.0
		end
		var4 = 0.0
		var5 = 3450.0
		var6 = vm.f32(3.1415927)
	end
	if arg0 == 9 then
		var3 = -590.0
		if arg1 == 1 then
			var3 = vm.f32(-245.2)
		end
		if arg1 == 2 then
			var3 = vm.f32(273.3)
		end
		if arg1 == 3 then
			var3 = vm.f32(790.2)
		end
		var4 = 0.0
		var5 = 4400.0
		var6 = vm.f32(3.1415927)
	end
	event.SetCharaPos(0, var3, var4, var5)
	event.SetCharaRot(0, 0.0, var6, 0.0)
end

--- Helper function.
local function helper_1c19c()
	local var0: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		print("station_id=", var0, ",train_id=", var1, ",lr_id=", var2, "\n")
		helper_1a9dc(var0, var1, var2)
	end
	if vm.skipping() then
		return skip(1)
	end
	var0 = event.GetCnt(1) or var0
	var1 = event.GetCnt(0) or var1
	var2 = event.GetCnt(15) or var2
	print("station_id=", var0, ",train_id=", var1, ",lr_id=", var2, "\n")
	helper_1a9dc(var0, var1, var2)
end

--- Helper function.
local function helper_25ca0()
	local var0: s32 = 0
	local var1: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var5: f32 = 0
	local var6: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_c746120b(20)
		end
		if at <= 2 then
			helper_5b643440(0)
		end
		if at <= 3 then
			helper_c746120b(10)
		end
		helper_1c19c()
	end
	event.EohSyncObj(1, "p01_train01")
	event.EohSetPos(1, 790.0, 0.0, 3600.0)
	event.EohSetRot(1, 0.0, 1.57, 0.0)
	var0 = event.GetCnt(0) or var0
	if var0 == 0 then
		helper_1c19c()
		event.CharaNormalDrive(0)
		event.CharaResetDa(0)
		event.ResetCamera(1, 0.0)
		event.SetFadeIn(30)
		return
	end
	var1 = event.GetCnt(15) or var1
	event.Initialize()
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	if var1 == 0 then
		event.EohSyncObj(2, "p01_train01", "s3601_12-m1")
		event.EohSyncObj(3, "p01_train01", "s3601_14-m6")
		event.EohSyncObj(4, "p01_train01", "s3601_16-m1")
		event.EohSyncObj(5, "p01_train01", "s3601_17-m")
		if var0 == 2 then
			event.EohSyncObj(2, "p01_train01", "s3601_12-m5")
			event.EohSyncObj(3, "p01_train01", "s3601_14-m10")
			event.EohSyncObj(4, "p01_train01", "s3601_16-m4")
			event.EohSyncObj(5, "p01_train01", "s3601_17-m2")
		end
		if var0 == 3 then
			event.EohSyncObj(2, "p01_train01", "s3601_12-m3")
			event.EohSyncObj(3, "p01_train01", "s3601_14-m8")
			event.EohSyncObj(4, "p01_train01", "s3601_16-m5")
			event.EohSyncObj(5, "p01_train01", "s3601_17-m4")
		end
	else
		event.EohSyncObj(2, "p01_train01", "s3601_12-m")
		event.EohSyncObj(3, "p01_train01", "s3601_14-m7")
		event.EohSyncObj(4, "p01_train01", "s3601_16-m")
		event.EohSyncObj(5, "p01_train01", "s3601_17-m1")
		if var0 == 2 then
			event.EohSyncObj(2, "p01_train01", "s3601_12-m4")
			event.EohSyncObj(3, "p01_train01", "s3601_14-m11")
			event.EohSyncObj(4, "p01_train01", "s3601_16-m2")
			event.EohSyncObj(5, "p01_train01", "s3601_17-m3")
		end
		if var0 == 3 then
			event.EohSyncObj(2, "p01_train01", "s3601_12-m2")
			event.EohSyncObj(3, "p01_train01", "s3601_14-m9")
			event.EohSyncObj(4, "p01_train01", "s3601_16-m3")
			event.EohSyncObj(5, "p01_train01", "s3601_17-m5")
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
	var5 = 240.0
	if var0 == 2 then
		var5 = -270.0
	end
	if var0 == 3 then
		var5 = -790.0
	end
	event.CmrsInit()
	if var1 == 0 then
		event.CmrsSetPos(var5 - vm.f32(135.23), 32.86, 3321.61)
		event.CmrsSetRef(var5, 31.8, 3450.0)
	else
		event.CmrsSetPos(var5 + vm.f32(135.23), 32.86, 3878.39)
		event.CmrsSetRef(var5, 31.8, 3750.0)
	end
	event.SetFadeIn(30)
	if var1 == 0 then
		event.ObjsSetPos(0, var5, 30.0, 3580.0)
		event.ObjsSetRot(0, 0.0, 3.1415927, 0.0)
	else
		event.ObjsSetPos(0, var5, 25.9, 3650.0)
		event.ObjsSetRot(0, 0.0, 0.0, 0.0)
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
	helper_c746120b(30)
	if vm.skipping() then
		return skip(1)
	end
	event.ObjsMove(5, pos_x + 22.5, pos_y - 9.5, pos_z, 30)
	helper_c746120b(20)
	if vm.skipping() then
		return skip(2)
	end
	if var1 == 0 then
		event.ObjsMove(0, var5, 0.0, 3500.0, 30)
	else
		event.ObjsMove(0, var5, 0.0, 3700.0, 30)
	end
	event.ObjsSetMotion(0, "走り", 4)
	event.EohSetFootSoundId(0, 6)
	helper_5b643440(0)
	if vm.skipping() then
		return skip(3)
	end
	event.EohSetFootSoundId(0, 0)
	event.ObjsSetMotion(0, "立ち")
	helper_c746120b(10)
	if vm.skipping() then
		return skip(4)
	end
	event.SetFadeIn(1)
	event.EohSetRot(2, 0.0, 0.0, 0.0)
	event.EohSetRot(3, 0.0, 0.0, 0.0)
	event.EohSetRot(4, 0.0, 0.0, 0.0)
	event.EohSetPos(5, pos_x, pos_y, pos_z)
	event.EohSetRot(5, 0.0, 0.0, 0.0)
	helper_1c19c()
	event.CharaNormalDrive(0)
	event.CharaResetDa(0)
	event.ResetCamera(1, 0.0)
end

--- Helper function.
local function helper_24a44()
	local var0: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var4: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_5b643440(1)
		end
		if at <= 2 then
			helper_c746120b(10)
		end
		if at <= 3 then
			helper_c746120b(30)
		end
		if at <= 4 then
			helper_c746120b(20)
		end
		if at <= 5 then
			helper_5b643440(0)
		end
		if at <= 6 then
			helper_c746120b(10)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	var0 = event.SndLoadSound(8, "snd2/sp/sp_019.sound.json") or var0
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.CharaActive(0, 0)
	event.EohSyncObj(1, "p01_train01")
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.ObjsSetPos(1, 190.0, 0.0, 3600.0)
	event.ObjsSetRot(1, 0.0, 1.57, 0.0)
	event.EohSyncObj(2, "p01_train01", "s3601_12-m5")
	event.ObjsSyncObj(2, 2)
	event.ObjsSetRot(2, 0.0, 0.0, 0.0)
	event.EohSyncObj(3, "p01_train01", "s3601_14-m10")
	event.ObjsSyncObj(3, 3)
	event.ObjsSetRot(3, 0.0, 0.0, 0.0)
	event.EohSyncObj(4, "p01_train01", "s3601_16-m4")
	event.ObjsSyncObj(4, 4)
	event.ObjsSetRot(4, 0.0, 0.0, 0.0)
	event.EohSyncObj(5, "p01_train01", "s3601_17-m2")
	do
		local out1, out2, out3 = event.EohGetPos(5)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	event.ObjsSyncObj(5, 5)
	event.ObjsSetRot(5, 0.0, 0.0, 0.0)
	event.CmrsInit()
	event.CmrsSetPos(1080.93, 20.56, 4488.23)
	event.CmrsSetRef(1048.27, 47.31, 4411.07)
	event.SetFadeIn(30)
	event.ObjsMove2(1, 790.0, 0.0, 3600.0, 40, 2, 1.0)
	event.SndSePlay(var0, 0)
	helper_5b643440(1)
	if vm.skipping() then
		return skip(2)
	end
	helper_c746120b(10)
	if vm.skipping() then
		return skip(3)
	end
	event.SetCrossfade(30)
	event.CmrsSetPos(-405.22998, 32.86, 3321.61)
	event.CmrsSetRef(-270.0, 31.8, 3450.0)
	event.EohSetPos(1, 790.0, 0.0, 3600.0)
	event.CharaActive(0)
	event.ObjsSetPos(0, -270.0, 30.0, 3580.0)
	event.ObjsSetRot(0, 0.0, 3.1415927, 0.0)
	event.ObjsRotation(2, 0.0, 0.0, 1.5707964, 30)
	event.ObjsRotation(3, 0.0, 0.0, 1.5707964, 30)
	event.ObjsRotation(4, 0.0, 0.0, -0.3926991, 30)
	event.ObjsRotation(5, 0.0, 0.0, -0.3926991, 30)
	var4 = event.GetSndId(2) or var4
	event.SndSePlay(var4, 92)
	helper_c746120b(30)
	if vm.skipping() then
		return skip(4)
	end
	event.ObjsMove(5, pos_x + 22.5, pos_y - 9.5, pos_z, 30)
	helper_c746120b(20)
	if vm.skipping() then
		return skip(5)
	end
	event.ObjsMove(0, -270.0, 0.0, 3505.0, 30)
	event.ObjsSetMotion(0, "走り", 4)
	event.EohSetFootSoundId(0, 6)
	helper_5b643440(0)
	if vm.skipping() then
		return skip(6)
	end
	event.EohSetFootSoundId(0, 0)
	event.ObjsSetMotion(0, "立ち")
	helper_c746120b(10)
	if vm.skipping() then
		return skip(7)
	end
	event.SetFadeIn(1)
	event.EohSetPos(1, 790.0, 0.0, 3600.0)
	event.EohSetRot(1, 0.0, 1.57, 0.0)
	event.EohSetRot(2, 0.0, 0.0, 0.0)
	event.EohSetRot(3, 0.0, 0.0, 0.0)
	event.EohSetRot(4, 0.0, 0.0, 0.0)
	event.EohSetPos(5, pos_x, pos_y, pos_z)
	event.EohSetRot(5, 0.0, 0.0, 0.0)
	event.CmrsInit()
	event.CharaActive(0)
	event.SetCharaPos(0, -270.0, 0.0, 3450.0)
	event.SetCharaRot(0, 0.0, 3.1415927, 0.0)
	event.CharaNormalDrive(0)
	event.CharaResetDa(0)
	event.ResetCamera(1, 0.0, 10.0)
end

--- Helper function.
local function helper_2d750()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 15 then
			if at <= 1 then
				helper_5b643440(0)
			end
			if at <= 2 then
				helper_c746120b(60)
			end
			if at <= 3 then
				helper_5b643440(0)
			end
			if at <= 4 then
				helper_c746120b(10)
			end
			if at <= 5 then
				helper_9538e344(7240010, 180)
			end
			if at <= 6 then
				helper_9538e344(7240020, 180)
			end
			if at <= 7 then
				helper_9538e344(7240030, 160)
			end
			if at <= 8 then
				helper_9538e344(7240035, 140)
			end
			if at <= 9 then
				helper_9538e344(7240040, 180)
			end
			if at <= 10 then
				helper_42b7a2cf(7240050)
			end
			if at <= 11 then
				helper_b2a6ae08()
			end
			if at <= 12 then
				helper_42b7a2cf(7240060)
			end
			if at <= 13 then
				helper_9538e344(7240070, 120)
			end
			if at <= 14 then
				helper_c746120b(30)
			end
			if vm.skip_end() then
				return skip(16)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.CmrsInit()
		event.CharaActive(1, 0)
		event.StopBgm(0)
		event.DeleteChara(8)
		event.DeleteChara(9)
		event.LoadMes(0, -1)
		event.BgmLoadCancel()
		event.Finish()
	end
	event.SetFlag(724, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.CharaActive(0, 0)
	event.AssignStack(5)
	event.ClearStack(5)
	event.StopBgm(0)
	helper_c746120b(6)
	if vm.skipping() then
		return skip(1)
	end
	event.LoadBgm(113)
	event.PlayBgm(0)
	event.LoadSound(7829)
	event.ChangeDir("event/e700/e724/")
	event.LoadMes(0, 5, "e724.txt")
	event.LoadChara(5, "e724_sun.gltf", "info", 8)
	event.CharaActive(8)
	event.EohSyncChara(0, 8)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.EohSyncObj(1, "p01_train01")
	event.EohSyncObj(2, "p01_shadow-0")
	event.ChangeDir("")
	event.LoadChara(5, "event/e700/e704/kaisou_waku.gltf", "info", 9)
	event.CharaActive(1, 9)
	event.EohSetPos(0, 0.0, 0.0, 3500.0)
	event.EohSetRot(0, 0.0, 0.0, 0.0)
	event.EohSetFootSoundId(0, 16)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "呆然目パチ")
	event.EohSetShow(1, 0)
	event.EohSetShow(2, 0)
	event.CharaActive(0, 122)
	event.CharaActive(0, 123)
	event.InitDramaScene()
	event.ObjsMove(0, 0.0, 0.0, 3600.0, 120)
	event.ObjsSetMotion(0, "しょんぼり歩き", 4)
	event.CmrsInit()
	event.CmrsSetPos(0.0, 13.49, 3735.45)
	event.CmrsSetRef(0.0, 32.22, 3509.35)
	event.CmrsCharaAttach(9, 610.7, -1)
	event.SetFadeIn(30)
	helper_5b643440(0)
	if vm.skipping() then
		return skip(2)
	end
	event.CmrsSetPos(59.11, 9.92, 3492.87)
	event.CmrsSetRef(0.0, 17.92, 3578.09)
	event.ObjsMove(0, 0.0, 0.0, 3650.0, 80)
	event.ObjsMotionDelay(0, 80)
	event.ObjsSetMotion(0, "しょんぼり立ち")
	helper_c746120b(60)
	if vm.skipping() then
		return skip(3)
	end
	event.CmrsSetPos(60.0, 16.0, 3650.0)
	event.CmrsSetRef(0.0, 16.0, 3650.0)
	helper_5b643440(0)
	if vm.skipping() then
		return skip(4)
	end
	helper_c746120b(10)
	if vm.skipping() then
		return skip(5)
	end
	event.CmrsMoveAhd2(3.14, 0.0, 60.0, 800, 0, 0.1)
	event.ObjsSetMotion(0, "顔を上に上げる", 2)
	event.ObjsNextMotion(0, "顔を上に上げるＬ", 4)
	helper_9538e344(7240010, 180)
	if vm.skipping() then
		return skip(6)
	end
	helper_9538e344(7240020, 180)
	if vm.skipping() then
		return skip(7)
	end
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "目あき～目とじ")
	event.ObjsSetMotion(0, "顔を上から下", 2)
	event.ObjsNextMotion(0, "顔を上から下Ｌ", 4)
	helper_9538e344(7240030, 160)
	if vm.skipping() then
		return skip(8)
	end
	helper_9538e344(7240035, 140)
	if vm.skipping() then
		return skip(9)
	end
	helper_9538e344(7240040, 180)
	if vm.skipping() then
		return skip(10)
	end
	helper_42b7a2cf(7240050)
	if vm.skipping() then
		return skip(11)
	end
	helper_b2a6ae08()
	if vm.skipping() then
		return skip(12)
	end
	event.CmrsSetPos(0.0, 33.0, 3690.0)
	event.CmrsSetRef(0.0, 13.5, 3650.0)
	helper_42b7a2cf(7240060)
	if vm.skipping() then
		return skip(13)
	end
	event.CmrsMove2(0.0, 433.0, 4490.0, 0.0, 13.5, 3650.0, 150, 1, 0.2)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "目とじ～目あき")
	event.ObjsSetMotion(0, "空を見上げる", 2)
	event.ObjsNextMotion(0, "空を見上げるＬ", 4)
	helper_9538e344(7240070, 120)
	if vm.skipping() then
		return skip(14)
	end
	event.FadeOutBgm(30)
	event.SetFadeOut(30)
	helper_c746120b(30)
	if vm.skipping() then
		return skip(15)
	end
	return part2()
end

--- Helper function.
local function helper_ba58(arg0: s32, arg1: s32)
	local var2: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		return var2
	end
	event.SetMesQuestionGyou(1, 0)
	event.SetMesWindowMode(1, 5)
	event.SetMesDrawspeed(1, 1)
	event.SetMesItemDirect(1, 1, vm.i32(arg1 + 20000))
	var2 = helper_0695b715(1, vm.i32(arg0 + 70), 8, 256, 208, 2, 1)
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesDrawspeed(1, 0)
	return var2
end

--- Helper function.
local function helper_27e1c()
	local var0: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_c746120b(20)
		end
		return 1
	end
	event.Initialize()
	event.SetMotion(0, "立ち")
	event.SetMesQuestionGyou(0, 0)
	event.SetMesWindowMode(0, 5)
	event.SetMesDrawspeed(0, 1)
	var0 = helper_ba58(3, -1)
	if vm.skipping() then
		return skip(1)
	end
	if var0 == 0 then
		event.SetFadeOut(20)
		helper_c746120b(20)
		if vm.skipping() then
			return skip(2)
		end
		return 1
	end
	return 0
end

--- Helper function.
local function helper_1cae0()
	local var0: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_7ee99e81(0, 1)
			return 0
		end
		if at <= 3 then
			helper_c746120b(15)
		end
		return 0
	end
	event.SetMotion(0, "立ち")
	event.Initialize()
	helper_7ee99e81(0, 4)
	event.MesMake_2(0, "中に入る\n出発する")
	var0 = helper_0695b715(0, -1, 5, 256, 208, 2, 0)
	if vm.skipping() then
		return skip(1)
	end
	if var0 == -1 then
		helper_7ee99e81(0, 1)
		return 0
	end
	if var0 == 1 then
		event.SetFadeOut(15)
		helper_c746120b(15)
		if vm.skipping() then
			return skip(2)
		end
		event.GotoMenu(19, 0)
		if vm.wait() then
			return skip(3)
		end
		event.SetFadeIn(15)
		helper_c746120b(15)
		if vm.skipping() then
			return skip(4)
		end
		return 0
	end
	return 1
end

--- Helper function.
local function helper_12920()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var6: f32 = 0
	local var7: s32 = 0
	local var8: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_c746120b(20)
		end
		if at <= 2 then
			helper_c746120b(18)
		end
		if at <= 3 then
			helper_c746120b(12)
		end
		if at <= 4 then
			helper_c746120b(30)
		end
		if at <= 5 then
			helper_c746120b(10)
		end
		if at <= 6 then
			helper_c746120b(20)
		end
		if at <= 7 then
			helper_c746120b(18)
		end
		if at <= 8 then
			helper_c746120b(12)
		end
		if at <= 9 then
			helper_c746120b(30)
		end
	end
	event.Initialize()
	var8 = event.GetSndId(1) or var8
	var7 = event.GetEventData_2(3) or var7
	event.GetEventData_2(4)
	event.Ext(1035, 8, var0, var1, var2, var6) -- retail: the handler rejects 5 arguments
	event.SetWorldCoord(var0, var1, var2, var6)
	if vm.imod(var7, 2) ~= 1 then
		var6 = vm.f32(-3.1415927)
	end
	if var7 == 0 then
		event.EohSyncObj(1, "p01_train01", "train11-m0")
		event.EohSyncObj(2, "p01_train01", "train12-m0")
		event.EohSyncObj(3, "p01_train01", "train12-m2")
		event.SetCnt(0, 0)
	end
	if var7 == 1 then
		event.EohSyncObj(1, "p01_train01", "train11-m1")
		event.EohSyncObj(2, "p01_train01", "train12-m1")
		event.EohSyncObj(3, "p01_train01", "train12-m3")
		event.SetCnt(0, 0)
	end
	var8 = event.GetSndId(2) or var8
	event.SndSePlay(var8, 66)
	if vm.imod(var7, 2) ~= 1 then
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.ObjsSetPos(0, -14.25, 1.38, 0.55)
		event.ObjsSetRot(0, 0.0, -1.5, 0.0)
		event.ObjsSetMotion(0, "立ち", 4)
		event.ObjsResetDaPosition(0)
		event.ObjsSyncObj(1, 1)
		event.ObjsSetRot(1, 0.0, 0.0, 0.0)
		event.ObjsSyncObj(2, 2)
		event.ObjsSetRot(2, 0.0, 0.0, 0.0)
		event.ObjsSyncObj(3, 3)
		event.ObjsSetRot(3, 0.0, 0.0, 0.0)
		event.CmrsInit()
		event.CmrsSetPos(124.87, 22.53, -74.18)
		event.CmrsSetRef(-3.0, 27.21, 0.18)
		helper_c746120b(10)
		if vm.skipping() then
			return skip(1)
		end
		event.ObjsRotation(1, 0.0, -4.9415927, 0.0, 30)
		event.ObjsRotation(2, 0.0, -4.9415927, 0.0, 30)
		event.ObjsRotation(3, 0.0, -4.9415927, 0.0, 30)
		helper_c746120b(20)
		if vm.skipping() then
			return skip(2)
		end
		event.ObjsSetMotion(0, "歩き")
		event.ObjsMove(0, -29.1, 1.38, -0.82, 30)
		event.ObjsMove(0, -50.41, 1.38, 0.05, 30)
		event.EohSetFootSoundId(0, 6)
		helper_c746120b(18)
		if vm.skipping() then
			return skip(3)
		end
		event.EohSetFootSoundId(0, 3)
		helper_c746120b(12)
		if vm.skipping() then
			return skip(4)
		end
		event.SetFadeOut(30)
		helper_c746120b(30)
		if vm.skipping() then
			return skip(5)
		end
		event.EohSetMotion(0, "歩き", 4)
	else
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.ObjsSetPos(0, 14.25, 1.38, -0.55)
		event.ObjsSetRot(0, 0.0, -4.641593, 0.0)
		event.ObjsSetMotion(0, "立ち", 4)
		event.ObjsResetDaPosition(0)
		event.ObjsSyncObj(1, 1)
		event.ObjsSetRot(1, 0.0, 0.0, 0.0)
		event.ObjsSyncObj(2, 2)
		event.ObjsSetRot(2, 0.0, 0.0, 0.0)
		event.ObjsSyncObj(3, 3)
		event.ObjsSetRot(3, 0.0, 0.0, 0.0)
		event.CmrsInit()
		event.CmrsSetPos(-124.87, 22.53, 74.18)
		event.CmrsSetRef(3.0, 27.21, -0.18)
		helper_c746120b(10)
		if vm.skipping() then
			return skip(6)
		end
		event.ObjsRotation(1, 0.0, -1.8, 0.0, 30)
		event.ObjsRotation(2, 0.0, -1.8, 0.0, 30)
		event.ObjsRotation(3, 0.0, -1.8, 0.0, 30)
		helper_c746120b(20)
		if vm.skipping() then
			return skip(7)
		end
		event.ObjsSetMotion(0, "歩き")
		event.ObjsMove(0, 29.1, 1.38, 0.82, 30)
		event.ObjsMove(0, 50.41, 1.38, -0.05, 30)
		event.EohSetFootSoundId(0, 6)
		helper_c746120b(18)
		if vm.skipping() then
			return skip(8)
		end
		event.EohSetFootSoundId(0, 3)
		helper_c746120b(12)
		if vm.skipping() then
			return skip(9)
		end
		event.SetFadeOut(30)
		helper_c746120b(30)
		if vm.skipping() then
			return skip(10)
		end
		event.EohSetMotion(0, "歩き", 4)
	end
	event.SetMotion(0, "立ち", 4)
	if vm.imod(var7, 2) ~= 1 then
		event.SetCharaPos(0, 47.2, 25.3, -65.0)
		event.SetCharaRot(0, 0.0, -1.57, 0.0)
	else
		event.SetCharaPos(0, -47.2, 25.3, -65.0)
		event.SetCharaRot(0, 0.0, 1.57, 0.0)
	end
	event.EohSetFootSoundId(0, 0)
	event.SetFadeIn(15)
end

--- Helper function.
local function helper_17020()
	local now_map_no: s32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: s32 = 0
	local var8: f32 = 0
	local var9: s32 = 0
	local var10: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var14: f32 = 0
	local var15: f32 = 0
	local var16: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			print("train_id=", var5, "----------------\n")
			print("fpos[0]=", string.format("%f", var1), "---------------\n")
			print("fpos[1]=", string.format("%f", var2), "---------------\n")
			print("fpos[2]=", string.format("%f", var3), "---------------\n")
			var8 = vm.f32(1.5707964)
			var8 = vm.f32(-1.5707964)
			var8 = vm.f32(1.5707964)
			var8 = vm.f32(-1.5707964)
			var8 = vm.f32(1.5707964)
			var8 = vm.f32(-1.5707964)
			var8 = vm.f32(3.1415927)
			var8 = vm.f32(2.3561945)
			var8 = vm.f32(1.5707964)
			var9 = 0
			var9 = 1
			var14 = 0.0
			var15 = 46.0
			var14 = vm.f32(35.8)
			var14 = vm.f32(-7.86)
			var14 = 36.0
			var14 = vm.f32(29.22)
			var14 = -6.0
			var14 = vm.f32(-13.87)
			var15 = 30.0
			var14 = vm.f32(0.09)
			var15 = 30.0
			var14 = vm.f32(0.09)
			var15 = 30.0
			var14 = vm.f32(0.09)
			helper_c746120b(10)
		end
		if at <= 2 then
			helper_c746120b(20)
		end
		if at <= 3 then
			helper_c746120b(30)
		end
		if at <= 4 then
			helper_c746120b(20)
		end
		if at <= 5 then
			helper_c746120b(10)
		end
		if at <= 6 then
			helper_c746120b(20)
		end
		if at <= 7 then
			helper_c746120b(30)
		end
		if at <= 8 then
			helper_c746120b(20)
		end
		if at <= 9 then
			helper_c746120b(10)
		end
		if at <= 10 then
			var16 = 0
			print("てつのあしおと\n")
			var16 = 6
			print("いしのあしおと\n")
			var16 = 2
			helper_c746120b(30)
		end
		if at <= 11 then
			helper_c746120b(30)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	now_map_no = event.GetNowMapNo() or now_map_no
	event.Initialize()
	event.GetSndId(1)
	var5 = event.GetEventData_2(3) or var5
	event.GetEventData_2(4)
	event.Ext(1035, 8, var1, var2, var3, var4) -- retail: the handler rejects 5 arguments
	print("train_id=", var5, "----------------\n")
	print("fpos[0]=", string.format("%f", var1), "---------------\n")
	print("fpos[1]=", string.format("%f", var2), "---------------\n")
	print("fpos[2]=", string.format("%f", var3), "---------------\n")
	if var3 < 4500.0 then
		var8 = vm.f32(1.5707964)
	else
		var8 = vm.f32(-1.5707964)
	end
	if now_map_no == 76 then
		if var3 < 3600.0 then
			var8 = vm.f32(1.5707964)
		else
			var8 = vm.f32(-1.5707964)
		end
	end
	if now_map_no == 72 then
		if var3 < 4500.0 then
			var8 = vm.f32(1.5707964)
		else
			var8 = vm.f32(-1.5707964)
		end
	end
	if now_map_no == 34 or now_map_no == 16 or now_map_no == 54 then
		var8 = vm.f32(3.1415927)
	end
	if now_map_no == 87 then
		var8 = vm.f32(2.3561945)
	end
	if now_map_no == 83 or now_map_no == 103 then
		var8 = vm.f32(1.5707964)
	end
	event.SetWorldCoord(var1, var2, var3, var8)
	var9 = 0
	if now_map_no == 34 or now_map_no == 54 or now_map_no == 87 or now_map_no == 103 or now_map_no == 76 then
		var9 = 1
	end
	if var5 == 4 then
		event.EohSyncObj(2, "p01_train01", "s3601_12-m1")
		if var9 == 0 then
			event.EohSyncObj(3, "p01_train01", "s3601_14-m1")
		else
			event.EohSyncObj(3, "p01_train01", "s3601_14-m6")
		end
		event.EohSyncObj(4, "p01_train01", "s3601_16-m1")
		event.EohSyncObj(5, "p01_train01", "s3601_17-m")
		event.SetCnt(0, 1)
	end
	if var5 == 5 then
		event.EohSyncObj(2, "p01_train01", "s3601_12-m")
		if var9 == 0 then
			event.EohSyncObj(3, "p01_train01", "s3601_14-m")
		else
			event.EohSyncObj(3, "p01_train01", "s3601_14-m7")
		end
		event.EohSyncObj(4, "p01_train01", "s3601_16-m")
		event.EohSyncObj(5, "p01_train01", "s3601_17-m1")
		event.SetCnt(0, 1)
	end
	if var5 == 2 then
		event.EohSyncObj(2, "p01_train01", "s3601_12-m5")
		if var9 == 0 then
			event.EohSyncObj(3, "p01_train01", "s3601_14-m3")
		else
			event.EohSyncObj(3, "p01_train01", "s3601_14-m10")
		end
		event.EohSyncObj(4, "p01_train01", "s3601_16-m4")
		event.EohSyncObj(5, "p01_train01", "s3601_17-m2")
		event.SetCnt(0, 2)
	end
	if var5 == 3 then
		event.EohSyncObj(2, "p01_train01", "s3601_12-m4")
		if var9 == 0 then
			event.EohSyncObj(3, "p01_train01", "s3601_14-m2")
		else
			event.EohSyncObj(3, "p01_train01", "s3601_14-m11")
		end
		event.EohSyncObj(4, "p01_train01", "s3601_16-m2")
		event.EohSyncObj(5, "p01_train01", "s3601_17-m3")
		event.SetCnt(0, 2)
	end
	if var5 == 6 then
		event.EohSyncObj(2, "p01_train01", "s3601_12-m3")
		if var9 == 0 then
			event.EohSyncObj(3, "p01_train01", "s3601_14-m5")
		else
			event.EohSyncObj(3, "p01_train01", "s3601_14-m8")
		end
		event.EohSyncObj(4, "p01_train01", "s3601_16-m5")
		event.EohSyncObj(5, "p01_train01", "s3601_17-m4")
		event.SetCnt(0, 3)
	end
	if var5 == 7 then
		event.EohSyncObj(2, "p01_train01", "s3601_12-m2")
		if var9 == 0 then
			event.EohSyncObj(3, "p01_train01", "s3601_14-m4")
		else
			event.EohSyncObj(3, "p01_train01", "s3601_14-m9")
		end
		event.EohSyncObj(4, "p01_train01", "s3601_16-m3")
		event.EohSyncObj(5, "p01_train01", "s3601_17-m5")
		event.SetCnt(0, 3)
	end
	var10 = event.GetSndId(2) or var10
	event.SndSePlay(var10, 92)
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
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
	event.CmrsInit()
	var14 = 0.0
	var15 = 46.0
	if now_map_no == 34 then
		var14 = vm.f32(35.8)
	end
	if now_map_no == 16 then
		var14 = vm.f32(-7.86)
	end
	if now_map_no == 54 then
		var14 = 36.0
	end
	if now_map_no == 83 then
		var14 = vm.f32(29.22)
	end
	if now_map_no == 87 then
		var14 = -6.0
	end
	if now_map_no == 103 then
		var14 = vm.f32(-13.87)
	end
	if now_map_no == 72 then
		var15 = 30.0
		var14 = vm.f32(0.09)
	end
	if now_map_no == 76 then
		var15 = 30.0
		var14 = vm.f32(0.09)
	end
	if now_map_no == 155 then
		var15 = 30.0
		var14 = vm.f32(0.09)
	end
	event.ObjsSetPos(0, var15, var14, 0.0)
	event.ObjsSetRot(0, 0.0, -1.5707964, 0.0)
	event.ObjsSetMotion(0, "立ち", 4)
	event.ObjsResetDaPosition(0)
	event.CmrsSetPos(148.0, 23.45, -118.4)
	event.CmrsSetRef(5.11, 26.65, 8.6)
	if now_map_no == 34 or now_map_no == 54 then
		event.CmrsSetPos(106.46, 47.9, -133.32)
		event.CmrsSetRef(5.11, 77.95, 8.6)
	end
	if now_map_no == 83 then
		event.CmrsSetPos(148.0, 35.52, -118.4)
		event.CmrsSetRef(5.11, 77.95, 8.6)
	end
	helper_c746120b(10)
	if vm.skipping() then
		return skip(2)
	end
	if vm.imod(var5, 2) ~= 1 then
		event.ObjsRotation(2, 0.0, 0.0, 1.5707964, 30)
		event.ObjsRotation(3, 0.0, 0.0, 1.5707964, 30)
		if now_map_no == 83 or now_map_no == 54 or now_map_no == 34 then
			helper_c746120b(20)
			if vm.skipping() then
				return skip(3)
			end
		else
			event.ObjsRotation(4, 0.0, 0.0, -0.3926991, 30)
			event.ObjsRotation(5, 0.0, 0.0, -0.3926991, 30)
			helper_c746120b(30)
			if vm.skipping() then
				return skip(4)
			end
			if now_map_no == 103 then
				event.ObjsMove(5, pos_x + 45.0, pos_y - 19.0, pos_z, 30)
				helper_c746120b(20)
				if vm.skipping() then
					return skip(5)
				end
			else
				event.ObjsMove(5, pos_x + 20.0, pos_y - 8.0, pos_z, 20)
				helper_c746120b(10)
				if vm.skipping() then
					return skip(6)
				end
			end
		end
	else
		event.ObjsRotation(2, 0.0, 0.0, -1.5707964, 30)
		event.ObjsRotation(3, 0.0, 0.0, -1.5707964, 30)
		if now_map_no == 83 or now_map_no == 54 or now_map_no == 34 then
			helper_c746120b(20)
			if vm.skipping() then
				return skip(7)
			end
		else
			event.ObjsRotation(4, 0.0, 0.0, 0.3926991, 30)
			event.ObjsRotation(5, 0.0, 0.0, 0.3926991, 30)
			helper_c746120b(30)
			if vm.skipping() then
				return skip(8)
			end
			if now_map_no == 103 then
				event.ObjsMove(5, pos_x - 45.0, pos_y - 19.0, pos_z, 30)
				helper_c746120b(20)
				if vm.skipping() then
					return skip(9)
				end
			else
				event.ObjsMove(5, pos_x - 20.0, pos_y - 8.0, pos_z, 20)
				helper_c746120b(10)
				if vm.skipping() then
					return skip(10)
				end
			end
		end
	end
	event.ObjsSetMotion(0, "走り")
	event.ObjsMove(0, -50.0, 30.0, 0.0, 45)
	var16 = 0
	if
		now_map_no == 16
		or now_map_no == 83
		or now_map_no == 87
		or now_map_no == 103
		or now_map_no == 72
		or now_map_no == 76
		or now_map_no == 155
	then
		print("てつのあしおと\n")
		var16 = 6
	end
	if now_map_no == 34 or now_map_no == 54 then
		print("いしのあしおと\n")
		var16 = 2
	end
	event.EohSetFootSoundId(0, var16)
	helper_c746120b(30)
	if vm.skipping() then
		return skip(11)
	end
	event.SetFadeOut(30)
	helper_c746120b(30)
	if vm.skipping() then
		return skip(12)
	end
	event.EohSetFootSoundId(0, 0)
	event.EohSetMotion(0, "立ち", 4)
	if vm.imod(var5, 2) ~= 1 then
		event.SetCharaPos(0, 50.0, -14.0, 0.0)
		event.SetCharaRot(0, 0.0, -1.57, 0.0)
	else
		event.SetCharaPos(0, -50.0, -14.0, 0.0)
		event.SetCharaRot(0, 0.0, 1.57, 0.0)
	end
end

--- Helper function.
local function helper_def4()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			helper_c746120b(10)
		end
	end
	event.Initialize()
	event.SetMotion(0, "立ち")
	event.SetFadeOut(10)
	helper_c746120b(10)
	if vm.skipping() then
		return skip(1)
	end
	event.GotoMenu(7)
	if vm.wait() then
		return skip(2)
	end
	event.SetFadeIn(10)
	helper_c746120b(10)
	if vm.skipping() then
		return skip(3)
	end
end

--- Helper function.
local function helper_28068()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var5: s32 = 0
	local var6: f32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 23 then
			if at <= 1 then
				pos_x = vm.f32(pos_x + vm.f32(vm.f32(790.0 - pos_x) / 24.0))
				pos_y = vm.f32(pos_y + vm.f32(vm.f32(0.0 - pos_y) / 16.0))
				pos_z = vm.f32(pos_z + vm.f32(vm.f32(3600.0 - pos_z) / 16.0))
				var5 = var5 + 1
				var6 = 2.0
				var5 = 0
				pos_y = vm.f32(pos_y + var6)
				pos_y = vm.f32(pos_y - var6)
				var6 = vm.f32(var6 - vm.f32(var6 / 30.0))
				var5 = var5 + 1
			end
			if at <= 2 then
				helper_5b643440(3)
			end
			if at <= 3 then
				helper_c746120b(20)
			end
			if at <= 4 then
				helper_c746120b(10)
			end
			if at <= 5 then
				helper_c746120b(60)
			end
			if at <= 6 then
				helper_c746120b(10)
			end
			if at <= 7 then
				helper_5b643440(1)
			end
			if at <= 8 then
				helper_42b7a2cf(6000370)
			end
			if at <= 9 then
				helper_42b7a2cf(6000380)
			end
			if at <= 10 then
				helper_5b643440(0)
			end
			if at <= 11 then
				helper_42b7a2cf(6000390)
			end
			if at <= 12 then
				helper_42b7a2cf(6000400)
			end
			if at <= 13 then
				helper_42b7a2cf(6000410)
			end
			if at <= 14 then
				helper_c746120b(200)
			end
			if at <= 15 then
				helper_5b643440(0)
			end
			if at <= 16 then
				helper_42b7a2cf(6000420)
			end
			if at <= 17 then
				helper_42b7a2cf(6000430)
			end
			if at <= 18 then
				helper_42b7a2cf(6000435)
			end
			if at <= 19 then
				helper_42b7a2cf(6000440)
			end
			if at <= 20 then
				helper_42b7a2cf(6000450)
			end
			if at <= 21 then
				helper_42b7a2cf(6000460)
			end
			if at <= 22 then
				helper_c746120b(30)
			end
			if vm.skip_end() then
				return skip(24)
			end
			return part2()
		end
		helper_ec15ccd9(0.0, vm.f32(3.9), 3200.0, vm.f32(3.14))
	end
	function part2()
		event.CancelDramaScene()
		event.EohSetShow(7, 1)
		event.CharaActive(0)
		event.CharaActive(32)
		event.CharaActive(33)
		event.SetStatus(1, 0, 256, 0)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.EohSetPos(3, 790.0, 0.0, 3600.0)
		event.EohSetRot(3, 0.0, 1.57, 0.0)
		event.EohSetRot(4, 0.0, 0.0, 0.0)
		event.EohSetRot(5, 0.0, 0.0, 0.0)
		event.CharaActive(0)
		event.DelExtMotion(0)
		event.DeleteChara(32)
		event.DeleteChara(33)
		event.DeleteChara(34)
		event.DeleteChara(35)
		event.DeleteChara(36)
		event.LoadMes(0, -1)
		helper_ec15ccd9(0.0, vm.f32(3.9), 3200.0, vm.f32(3.14))
		event.ResetCamera(1, 3.14, 10)
		event.SetFadeIn(30)
	end
	event.SetFlag(600, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.StopBgm(0)
	event.LoadSound(7800)
	var0 = event.SndLoadSound(7800) or var0
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.SetStatus(1, 0, 256, 1)
	event.ChangeDir("event/e600/e600/")
	event.LoadMes(0, 5, "e600.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e600_mints.gltf", "info", 0)
		event.CharaActive(0, 0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e600_monica.gltf", "info", 0)
		event.CharaActive(0, 0)
		event.EohSyncChara(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.LoadChara(5, "e600_osmond.gltf", "info", 34)
	event.CharaActive(0, 34)
	event.EohSyncChara(2, 34)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.LoadChara(5, "e600_hikari.gltf", "info", 35)
	event.CharaActive(1, 35)
	event.LoadChara(5, "e600_nagare.gltf", "info", 36)
	event.CharaActive(1, 36)
	event.EohSyncChara(6, 36)
	event.ObjsInit(6)
	event.ObjsSyncObj(6, 6)
	event.ChangeDir("")
	if active_chr_no == 1 then
		event.LoadChara(5, "chara/c01_base.gltf", "info", 32)
		event.LoadEquip(5, 0, 4, "info", 32)
		event.LoadEquip(5, 0, 3, "info", 32)
		event.LoadEquip(5, 0, 2, "info", 32, 33)
		event.LoadMotion(5, "event/e600/e600/e600_mints.gltf", "info", 32)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 32)
		event.EohSyncChara(0, 32)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 0)
	else
		event.LoadChara(5, "chara/c02_base.gltf", "info", 32)
		event.LoadEquip(5, 1, 4, "info", 32)
		event.LoadEquip(5, 1, 3, "info", 32)
		event.LoadEquip(5, 1, 2, "info", 32, 33)
		event.LoadMotion(5, "event/e600/e600/e600_monica.gltf", "info", 32)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 32)
		event.EohSyncChara(1, 32)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 0)
	end
	event.CharaActive(0, 32)
	event.CharaActive(0, 33)
	event.EohSyncObj(3, "p01_train01")
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.EohSyncObj(4, "p01_train01", "s3601_13-m1")
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.EohSyncObj(5, "p01_train01", "s3601_15-m2")
	event.ObjsInit(5)
	event.ObjsSyncObj(5, 5)
	event.EohSyncObj(7, "p01_shadow-0")
	event.EohSetPos(0, 593.01, 30.8, 3553.84)
	event.EohSetRot(0, 0.0, 3.14, 0.0)
	event.EohSetMotion(0, "立ち", 4)
	event.EohSetFootSoundId(0, 16)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "おこり顔")
	event.EohSetTexAnim(0, 1, "おこり目パチ")
	event.EohSetPos(1, 583.22, 30.8, 3557.92)
	event.EohSetRot(1, 0.0, 3.14, 0.0)
	event.EohSetMotion(1, "立ち", 4)
	event.EohSetFootSoundId(1, 16)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "おこり顔")
	event.EohSetTexAnim(1, 1, "おこり目パチ")
	event.EohSetPos(2, 588.09, 30.8, 3562.57)
	event.EohSetRot(2, 0.0, 3.14, 0.0)
	event.EohSetMotion(2, "立ち", 4)
	event.EohSetFootSoundId(2, 16)
	event.EohSetPos(3, -6000.0, 2400.0, 1600.0)
	event.EohSetRot(3, 0.2, 1.2, 0.0)
	event.EohSetRot(4, 0.0, 0.0, 0.0)
	event.EohSetRot(5, 0.0, 0.0, 0.0)
	event.EohSetShow(7, 0)
	event.EohSetPos(6, -6000.0, 2480.0, 1600.0)
	event.EohSetRot(6, 0.2, 1.2, 0.0)
	event.EohSetMotion(6, "ループ", 4)
	event.SetCharaPos(35, -6000.0, 2400.0, 1600.0)
	event.InitDramaScene()
	event.CmrsInit()
	event.CmrsSetPos(1067.88, 491.78, 4477.15)
	event.CmrsSetRef(432.94, 580.78, 4182.04)
	event.CmrsMove2(1067.88, 491.78, 4477.15, 858.72, 267.72, 3985.84, 90, 2, 1.0)
	event.SndSePlay(var0, 2)
	event.SndSePlay(var0, 3)
	event.SetFadeIn(30)
	event.ObjsRotation2(3, 0.0, 1.57, 0.0, 60, 2, 1.0)
	event.ObjsRotation2(6, 0.0, 1.57, 0.0, 60, 2, 1.0)
	var5 = 0
	while var5 < 90 do
		if var5 == 20 then
			event.SetCharaShow(35, 0, 1, 0.033333335)
			event.SetCharaShow(36, 0, 1, 0.033333335)
		end
		if vm.wait() then
			return skip(1)
		end
		do
			local out1, out2, out3 = event.EohGetPos(3)
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		pos_x = vm.f32(pos_x + vm.f32(vm.f32(790.0 - pos_x) / 24.0))
		pos_y = vm.f32(pos_y + vm.f32(vm.f32(0.0 - pos_y) / 16.0))
		pos_z = vm.f32(pos_z + vm.f32(vm.f32(3600.0 - pos_z) / 16.0))
		event.EohSetPos(3, pos_x, pos_y, pos_z)
		event.EohSetPos(6, pos_x, pos_y + 80.0, pos_z)
		var5 = var5 + 1
	end
	event.ObjsMove2(3, 790.0, 0.0, 3600.0, 30, 2, 1.0)
	event.ObjsRotation(3, 0.0, 1.57, 0.0, 30)
	event.ObjsMove2(6, 790.0, 0.0, 3680.0, 30, 2, 1.0)
	event.ObjsRotation(6, 0.0, 1.57, 0.0, 30)
	var6 = 2.0
	var5 = 0
	while var5 < 30 do
		do
			local out1, out2, out3 = event.EohGetPos(3)
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		if vm.imod(var5, 2) == 0 then
			pos_y = vm.f32(pos_y + var6)
		else
			pos_y = vm.f32(pos_y - var6)
		end
		var6 = vm.f32(var6 - vm.f32(var6 / 30.0))
		event.EohSetPos(3, pos_x, pos_y, pos_z)
		var5 = var5 + 1
		if vm.wait() then
			return skip(2)
		end
	end
	helper_5b643440(3)
	if vm.skipping() then
		return skip(3)
	end
	helper_c746120b(20)
	if vm.skipping() then
		return skip(4)
	end
	event.CmrsSetPos(407.12, 258.94, 3255.47)
	event.CmrsSetRef(609.92, 112.52, 3513.32)
	event.ObjsSetPos(3, 790.0, 0.0, 3600.0)
	event.ObjsSetRot(3, 0.0, 1.57, 0.0)
	event.CharaActive(0)
	event.CharaActive(32)
	event.CharaActive(33)
	event.CharaActive(34)
	helper_c746120b(10)
	if vm.skipping() then
		return skip(5)
	end
	event.SndSePlay(var0, 4)
	event.ObjsRotation2(4, 0.0, 0.0, 1.6, 30, 0, 1.0)
	event.ObjsRotation2(5, 0.0, 0.0, 1.6, 30, 0, 1.0)
	helper_c746120b(60)
	if vm.skipping() then
		return skip(6)
	end
	event.ObjsJump(0, 616.43, 0.0, 3519.44, -0.2, 20)
	event.ObjsSetMotion(0, "走り")
	event.ObjsMotionDelay(0, 4)
	event.ObjsSetMotion(0, "着地", 1)
	event.ObjsMotionDelay(0, 10)
	event.ObjsSetMotion(0, "着地", 2)
	event.ObjsNextMotion(0, "立ち", 4)
	helper_c746120b(10)
	if vm.skipping() then
		return skip(7)
	end
	event.ObjsJump(1, 590.55, 0.0, 3527.36, -0.2, 20)
	event.ObjsSetMotion(1, "走り")
	event.ObjsMotionDelay(1, 4)
	event.ObjsSetMotion(1, "着地", 1)
	event.ObjsMotionDelay(1, 10)
	event.ObjsSetMotion(1, "着地", 2)
	event.ObjsNextMotion(1, "立ち", 4)
	helper_5b643440(1)
	if vm.skipping() then
		return skip(8)
	end
	event.CmrsSetPos(734.79, 34.32, 3415.62)
	event.CmrsSetRef(645.05, 7.39, 3483.16)
	event.ObjsSetPos(0, 678.03, 0.0, 3463.04)
	event.ObjsSetRot(0, 0.0, 2.18, 0.0)
	event.ObjsSetMotion(0, "キョロキョロ歩き", 4, -1, 1)
	event.ObjsMove(0, 732.73, 0.0, 3421.88, 90)
	event.ObjsResetDaPosition(0)
	event.ObjsMotionDelay(0, 90)
	event.ObjsSetMotion(0, "立ち", 4)
	event.ObjsSetPos(1, 623.2, 0.0, 3468.36)
	event.ObjsSetRot(1, 0.0, 2.9, 0.0)
	event.ObjsResetDaPosition(1)
	event.ObjsSetPos(2, 604.19, 0.0, 3501.3)
	event.ObjsSetRot(2, 0.0, 3.14, 0.0)
	event.SetPakuAnim(0, "通常口パク")
	helper_42b7a2cf(6000370)
	if vm.skipping() then
		return skip(9)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_42b7a2cf(6000380)
	if vm.skipping() then
		return skip(10)
	end
	helper_5b643440(0)
	if vm.skipping() then
		return skip(11)
	end
	event.CmrsSetPos(834.25, 32.04, 3503.77)
	event.CmrsSetRef(728.22, 120.07, 3124.24)
	event.ObjsSetPos(0, 688.8, 11.3, 3250.37)
	event.ObjsSetRot(0, 0.0, -2.26, 0.0)
	event.ObjsSetMotion(0, "指さす", 4, -1.0, 1)
	event.SetPakuAnim(0, "通常口パク")
	helper_42b7a2cf(6000390)
	if vm.skipping() then
		return skip(12)
	end
	event.CmrsSetPos(616.62, 51.57, 3428.73)
	event.CmrsSetRef(613.93, 8.94, 3476.66)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "こまり顔")
	event.EohSetTexAnim(1, 1, "こまり目パチ")
	event.ObjsSetMotion(1, "上向くL", 4, -1, 1)
	event.ObjsSetRot(1, 0.0, -2.9, 0.0)
	event.ObjsResetDaPosition(1)
	event.ObjsSetMotion(2, "歩き（上見）")
	event.ObjsMove(2, 603.8, 0.0, 3472.38, 60)
	event.ObjsMotionDelay(2, 60)
	event.ObjsSetMotion(2, "立ち（上見）")
	event.SetPakuAnim(1, "通常口パク")
	helper_42b7a2cf(6000400)
	if vm.skipping() then
		return skip(13)
	end
	helper_42b7a2cf(6000410)
	if vm.skipping() then
		return skip(14)
	end
	event.CmrsSetPos(0.0, 995.95, 3461.49)
	event.CmrsSetRef(0.0, 846.5, 1987.55)
	event.CmrsMove2(0.0, 25.08, 3461.49, 0.0, 392.85, 1987.55, 120, 0, 1.0)
	event.EohSetFootSoundId(0, 2)
	event.EohSetFootSoundId(1, 2)
	event.EohSetFootSoundId(2, 2)
	event.ObjsSetPos(0, -12.0, 0.0, 3300.0)
	event.ObjsSetRot(0, 0.0, 3.14, 0.0)
	event.ObjsSetPos(1, 12.0, 0.0, 3300.0)
	event.ObjsSetRot(1, 0.0, 3.14, 0.0)
	event.ObjsSetPos(2, 0.0, 0.0, 3320.0)
	event.ObjsSetRot(2, 0.0, 3.14, 0.0)
	helper_c746120b(200)
	if vm.skipping() then
		return skip(15)
	end
	event.ObjsMove(0, -12.0, 14.0, 3000.0, 160, 1)
	event.ObjsSetMotion(0, "歩き")
	event.ObjsMove(1, 12.0, 14.0, 3000.0, 160, 1)
	event.ObjsSetMotion(1, "歩き")
	event.ObjsMove(2, 0.0, 9.0, 3020.0, 160, 1)
	event.ObjsSetMotion(2, "歩き")
	helper_5b643440(0)
	if vm.skipping() then
		return skip(16)
	end
	event.CmrsSetPos(35.49, 35.66, 2985.73)
	event.CmrsSetRef(5.9, 35.78, 3001.23)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "おこり顔")
	event.EohSetTexAnim(1, 1, "おこり目パチ")
	event.ObjsSetMotion(0, "上向くL", 4, -1, 1)
	event.ObjsSetMotion(1, "上向くL", 4, -1, 1)
	event.ObjsSetMotion(2, "立ち（上見）", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_42b7a2cf(6000420)
	if vm.skipping() then
		return skip(17)
	end
	event.CmrsSetPos(-25.58, 61.54, 2959.33)
	event.CmrsSetRef(-12.23, 37.86, 2998.16)
	event.CmrsMove2(-18.54, 50.73, 2979.81, -12.23, 37.86, 2998.16, 60, 2, 1.0)
	event.SetPakuAnim(0, "通常口パク")
	helper_42b7a2cf(6000430)
	if vm.skipping() then
		return skip(18)
	end
	event.SetPakuAnim(0, "通常口パク")
	helper_42b7a2cf(6000435)
	if vm.skipping() then
		return skip(19)
	end
	event.CmrsSetPos(0.0, 6.31, 3126.74)
	event.CmrsSetRef(0.0, 59.43, 2999.73)
	event.SetPakuAnim(1, "通常口パク")
	helper_42b7a2cf(6000440)
	if vm.skipping() then
		return skip(20)
	end
	event.ObjsSetMotion(0, "振り返る", 6)
	event.ObjsNextMotion(0, "振り返るL", 4)
	event.ObjsSeDelay(0, 10)
	event.ObjsSePlay(0, var0, 5)
	event.ObjsMotionDelay(1, 4)
	event.ObjsSetMotion(1, "上見から振り返り", 6)
	event.ObjsNextMotion(1, "上見から振り返りL", 4)
	helper_42b7a2cf(6000450)
	if vm.skipping() then
		return skip(21)
	end
	event.SetPakuAnim(0, "通常口パク")
	helper_42b7a2cf(6000460)
	if vm.skipping() then
		return skip(22)
	end
	event.SetFadeOut(30)
	helper_c746120b(30)
	if vm.skipping() then
		return skip(23)
	end
	return part2()
end

--- Helper function.
local function helper_2c8a8()
	local var0: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 5 then
			if at <= 1 then
				helper_c746120b(30)
			end
			if at <= 2 then
				helper_c746120b(20)
			end
			if at <= 3 then
				helper_c746120b(15)
			end
			if at <= 4 then
				helper_c746120b(30)
			end
			if vm.skip_end() then
				return skip(6)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SndSeStop(var0, 0)
		event.BgmLoadCancel()
		event.CmrsInit()
		event.CharaActive(1, 0)
		event.DelImg(0)
		event.EsmClear()
	end
	event.SetFlag(612, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.StopBgm(0)
	helper_c746120b(4)
	if vm.skipping() then
		return skip(1)
	end
	event.LoadBgm(166)
	event.PlayBgm(0)
	event.LoadSound(7811)
	var0 = event.SndLoadSound(7811) or var0
	event.AssignStack(5)
	event.ClearStack(5)
	event.GetActiveChrNo()
	event.CharaActive(0, 0)
	event.EohSyncObj(4, "p01_toge-0")
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.EohSyncObj(5, "p01_toge-1")
	event.ObjsInit(5)
	event.ObjsSyncObj(5, 5)
	event.EsmInitialize(5)
	event.EsmLoadBase("e612砂煙")
	event.EsmInitFix(5)
	event.EohSetPos(4, 674.4, -314.4, 2807.93)
	event.EohSetRot(4, 0.0, 0.0, 0.0)
	event.EohSetShow(4, 1)
	event.EohSetPos(5, -998.0, -343.6, 2925.65)
	event.EohSetRot(5, 0.0, 0.0, 0.0)
	event.EohSetShow(5, 1)
	event.InitDramaScene()
	event.CmrsInit()
	event.CmrsSetPos(1225.24, 296.8, 2174.0)
	event.CmrsSetRef(1176.18, 319.43, 2038.46)
	event.CmrsQuake(0.0, 2.4, 0.2, -1)
	event.SndSePlay(var0, 0)
	event.SetFadeIn(30)
	helper_c746120b(30)
	if vm.skipping() then
		return skip(2)
	end
	event.EsmCreate("e612砂煙")
	event.EsmSetVect1(674.4, 40.0, 2807.93)
	event.EsmSetVect2(20.0, 20.0, 20.0)
	event.EsmCreate("e612砂煙")
	event.EsmSetVect1(861.02, 134.12, 2949.14)
	event.EsmSetVect2(20.0, 20.0, 20.0)
	event.EsmCreate("e612砂煙")
	event.EsmSetVect1(643.56, 119.57, 2978.62)
	event.EsmSetVect2(20.0, 20.0, 20.0)
	event.CmrsSetPos(936.44, 592.45, 3336.76)
	event.CmrsSetRef(714.95, 229.99, 2890.91)
	event.SndSePlay(var0, 1)
	event.ObjsMove(4, 674.4, 40.0, 2807.93, 10)
	helper_c746120b(20)
	if vm.skipping() then
		return skip(3)
	end
	event.CmrsSetPos(-1432.81, 435.38, 3449.66)
	event.CmrsSetRef(-1123.85, 241.13, 3144.02)
	event.EsmCreate("e612砂煙")
	event.EsmSetVect1(-1252.94, 0.8, 3245.52)
	event.EsmSetVect2(20.0, 20.0, 20.0)
	event.EsmCreate("e612砂煙")
	event.EsmSetVect1(-1008.78, 0.4, 3092.24)
	event.EsmSetVect2(20.0, 20.0, 20.0)
	event.EsmCreate("e612砂煙")
	event.EsmSetVect1(-1174.3, 0.78, 2981.77)
	event.EsmSetVect2(20.0, 20.0, 20.0)
	event.SndSePlay(var0, 1)
	event.ObjsMove(5, -998.0, 9.62, 2925.65, 10)
	helper_c746120b(15)
	if vm.skipping() then
		return skip(4)
	end
	event.SetFadeOut(30)
	helper_c746120b(30)
	if vm.skipping() then
		return skip(5)
	end
	return part2()
end

--- Helper function.
local function helper_247fc()
	local var0: s32 = 0
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	var0 = event.GetEventData_2(13) or var0
	helper_7ee99e81(0, 1)
	flag = event.GetFlag(648) or flag
	if flag == 0 then
		event.MesMake_2(0, "オレはここで待ってる。\n幸運を祈ってるぜ！")
	else
		event.MesMake_2(0, "オレはここで待ってるぜ。\n絶対、グリフォンを倒せよ。")
	end
	helper_8ddec556(var0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

script[99] = program_99

--- Program 100.
script[100] = function()
	local mc_load: s32 = 0
	local old_map_no: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_1c19c()
			helper_24a44()
		end
		helper_2ea08()
	end
	event.Initialize()
	program_99()
	print("start_event--------------------------------------------\n")
	mc_load = event.CheckMcLoad() or mc_load
	if mc_load == 1 then
		helper_2ea08()
		helper_ec15ccd9(vm.f32(94.2), vm.f32(34.8), vm.f32(2842.4), 0.0)
		event.ResetCamera(1, 0.0, 20.0)
		event.SetFadeIn(30)
	else
		old_map_no = event.GetOldMapNo() or old_map_no
		var2 = event.GetMapType(old_map_no) or var2
		if var2 ~= -1 then
			if old_map_no == 77 then
				helper_2ea08()
				helper_ec15ccd9(0.0, 80.0, 2560.0, 0.0)
				event.ResetCamera(1, 0.0, 20.0)
				event.SetFadeIn(30)
			else
				var3 = event.GetCnt(1) or var3
				if (old_map_no == 18 or old_map_no == 23 or old_map_no == 120 or old_map_no == 108) and var3 == 8 then
					helper_2ea08()
					helper_25ca0()
					if vm.skipping() then
						return skip(1)
					end
					helper_1c19c()
					event.SetFadeIn(15)
					event.ResetCamera(1, 0.0)
				else
					helper_24a44()
					if vm.skipping() then
						return skip(2)
					end
					helper_2ea08()
				end
			end
		end
		event.SetMotion(0, "立ち")
	end
end

--- Program 150.
script[150] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_2d750()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 200.
script[200] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	local t0 = helper_27e1c()
	if vm.skipping() then
		return skip(1)
	end
	if t0 ~= 0 then
		event.MapJump(-1, "s33")
		if vm.wait() then
			return skip(2)
		end
	end
end

--- Program 250.
script[250] = function()
	local var0: s32 = 0
	local var1: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
		if at <= 4 then
			helper_17020()
		end
	end
	var0 = helper_1cae0()
	if vm.skipping() then
		return skip(1)
	end
	if var0 ~= 1 then
		return
	end
	event.SetCnt(1, 8)
	var1 = event.GetEventData_2(3) or var1
	if var1 <= 1 then
		helper_12920()
		if vm.skipping() then
			return skip(2)
		end
		event.StopBgm(0)
		if vm.wait() then
			return skip(3)
		end
		event.MapJump(-1, "s37")
		if vm.wait() then
			return skip(4)
		end
	else
		helper_17020()
		if vm.skipping() then
			return skip(5)
		end
		event.StopBgm(0)
		event.MapJump(100, "s38")
	end
end

--- Program 400.
script[400] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_def4()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 499.
script[499] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_24a44()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 500.
script[500] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		helper_2ea08()
	end
	helper_4337dd96()
	helper_28068()
	if vm.skipping() then
		return skip(1)
	end
	helper_2ea08()
end

--- Program 510.
script[510] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_2c8a8()
	if vm.skipping() then
		return skip(1)
	end
	event.LoadDungeonMapFile("s35")
	event.LoadScript("s35/s35.stb", 500)
	if vm.wait() then
		return skip(2)
	end
end

--- Program 520.
script[520] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_2d750()
	if vm.skipping() then
		return skip(1)
	end
	event.LoadDungeonMapFile("d06b01")
	event.LoadScript("d06b01/d06b01.stb", 511)
	if vm.wait() then
		return skip(2)
	end
end

--- Program 1000.
script[1000] = function()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	var0 = event.GetEventData_2(13) or var0
	if var0 == 8 then
		helper_247fc()
		if vm.skipping() then
			return skip(1)
		end
	end
end

return script
