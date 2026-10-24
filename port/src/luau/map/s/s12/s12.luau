--!strict
-- map/s/s12/s12.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_05ce8bed = require("@lib/event/helper_05ce8bed")
local helper_1281c23c = require("@lib/event/helper_1281c23c")
local helper_47e08a85 = require("@lib/event/helper_47e08a85")
local helper_5057139e = require("@lib/event/helper_5057139e")
local helper_512cd149 = require("@lib/event/helper_512cd149")
local helper_766c5e7b = require("@lib/event/helper_766c5e7b")
local helper_b01df685 = require("@lib/event/helper_b01df685")
local helper_b6f06a8e = require("@lib/event/helper_b6f06a8e")
local helper_bad1e97b = require("@lib/event/helper_bad1e97b")
local helper_baeaba52 = require("@lib/event/helper_baeaba52")
local helper_d779bb0d = require("@lib/event/helper_d779bb0d")
local helper_e1e5862e = require("@lib/event/helper_e1e5862e")
local helper_f427c76a = require("@lib/event/helper_f427c76a")

local global0: s32 = 0
local global1: s32 = 0

--- Program 99.
local function program_99()
	print("map_init-------------------------\n")
end

--- Helper function.
local function helper_2fa44()
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.AssignStack(4)
	event.ClearStack(4)
	event.LoadChara(4, "chara/p00_31a.gltf", "info", 8)
	event.CharaActive(8)
	event.SetCharaPos(8, -300.0, 0.0, 4360.0)
	event.SetCharaRot(8, 0.0, 3.1415927, 0.0)
	event.SetCharaNo(8, 301)
end

--- Helper function.
local function helper_222fc(arg0: s32, arg1: s32, arg2: s32)
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
local function helper_23abc()
	local var0: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		print("station_id=", var0, ",train_id=", var1, ",lr_id=", var2, "\n")
		helper_222fc(var0, var1, var2)
	end
	if vm.skipping() then
		return skip(1)
	end
	var0 = event.GetCnt(1) or var0
	var1 = event.GetCnt(0) or var1
	var2 = event.GetCnt(15) or var2
	print("station_id=", var0, ",train_id=", var1, ",lr_id=", var2, "\n")
	helper_222fc(var0, var1, var2)
end

--- Helper function.
local function helper_2d620()
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
			helper_d779bb0d(20)
		end
		if at <= 2 then
			helper_b01df685(0)
		end
		if at <= 3 then
			helper_d779bb0d(10)
		end
		helper_23abc()
	end
	var0 = event.GetCnt(0) or var0
	if var0 == 0 then
		helper_23abc()
		event.CharaNormalDrive(0)
		event.CharaResetDa(0)
		event.ResetCamera(1, 0.0)
		event.SetFadeIn(30)
		return
	end
	var1 = event.GetCnt(15) or var1
	event.Initialize()
	event.EohSyncObj(1, "p01_train01")
	event.EohSetPos(1, -790.0, 0.0, 4500.0)
	event.EohSetRot(1, 0.0, -1.57, 0.0)
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	if var1 == 0 then
		event.EohSyncObj(2, "p01_train01", "s3601_12-m1")
		event.EohSyncObj(3, "p01_train01", "s3601_14-m1")
		event.EohSyncObj(4, "p01_train01", "s3601_16-m1")
		event.EohSyncObj(5, "p01_train01", "s3601_17-m")
		if var0 == 2 then
			event.EohSyncObj(2, "p01_train01", "s3601_12-m5")
			event.EohSyncObj(3, "p01_train01", "s3601_14-m3")
			event.EohSyncObj(4, "p01_train01", "s3601_16-m4")
			event.EohSyncObj(5, "p01_train01", "s3601_17-m2")
		end
		if var0 == 3 then
			event.EohSyncObj(2, "p01_train01", "s3601_12-m3")
			event.EohSyncObj(3, "p01_train01", "s3601_14-m5")
			event.EohSyncObj(4, "p01_train01", "s3601_16-m5")
			event.EohSyncObj(5, "p01_train01", "s3601_17-m4")
		end
	else
		event.EohSyncObj(2, "p01_train01", "s3601_12-m")
		event.EohSyncObj(3, "p01_train01", "s3601_14-m")
		event.EohSyncObj(4, "p01_train01", "s3601_16-m")
		event.EohSyncObj(5, "p01_train01", "s3601_17-m1")
		if var0 == 2 then
			event.EohSyncObj(2, "p01_train01", "s3601_12-m4")
			event.EohSyncObj(3, "p01_train01", "s3601_14-m2")
			event.EohSyncObj(4, "p01_train01", "s3601_16-m2")
			event.EohSyncObj(5, "p01_train01", "s3601_17-m3")
		end
		if var0 == 3 then
			event.EohSyncObj(2, "p01_train01", "s3601_12-m2")
			event.EohSyncObj(3, "p01_train01", "s3601_14-m4")
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
	helper_d779bb0d(30)
	if vm.skipping() then
		return skip(1)
	end
	event.ObjsMove(5, pos_x - 22.5, pos_y - 9.5, pos_z, 30)
	helper_d779bb0d(20)
	if vm.skipping() then
		return skip(2)
	end
	if var1 == 0 then
		event.ObjsMove(0, var5, 0.0, 4600.0, 30)
	else
		event.ObjsMove(0, var5, 0.0, 4400.0, 30)
	end
	event.ObjsSetMotion(0, "走り", 4)
	event.EohSetFootSoundId(0, 6)
	helper_b01df685(0)
	if vm.skipping() then
		return skip(3)
	end
	event.EohSetFootSoundId(0, 0)
	event.ObjsSetMotion(0, "立ち")
	helper_d779bb0d(10)
	if vm.skipping() then
		return skip(4)
	end
	event.SetFadeIn(1)
	event.EohSetRot(2, 0.0, 0.0, 0.0)
	event.EohSetRot(3, 0.0, 0.0, 0.0)
	event.EohSetRot(4, 0.0, 0.0, 0.0)
	event.EohSetPos(5, pos_x, pos_y, pos_z)
	event.EohSetRot(5, 0.0, 0.0, 0.0)
	helper_23abc()
	event.CharaNormalDrive(0)
	event.CharaResetDa(0)
	event.ResetCamera(1, 0.0)
end

--- Helper function.
local function helper_2c364()
	local var0: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var4: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_b01df685(1)
		end
		if at <= 2 then
			helper_d779bb0d(10)
		end
		if at <= 3 then
			helper_d779bb0d(30)
		end
		if at <= 4 then
			helper_d779bb0d(20)
		end
		if at <= 5 then
			helper_b01df685(0)
		end
		if at <= 6 then
			helper_d779bb0d(10)
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
	event.ObjsSetPos(1, -190.0, 0.0, 4500.0)
	event.ObjsSetRot(1, 0.0, -1.57, 0.0)
	event.EohSyncObj(2, "p01_train01", "s3601_12-m")
	event.ObjsSyncObj(2, 2)
	event.ObjsSetRot(2, 0.0, 0.0, 0.0)
	event.EohSyncObj(3, "p01_train01", "s3601_14-m")
	event.ObjsSyncObj(3, 3)
	event.ObjsSetRot(3, 0.0, 0.0, 0.0)
	event.EohSyncObj(4, "p01_train01", "s3601_16-m")
	event.ObjsSyncObj(4, 4)
	event.ObjsSetRot(4, 0.0, 0.0, 0.0)
	event.EohSyncObj(5, "p01_train01", "s3601_17-m1")
	do
		local out1, out2, out3 = event.EohGetPos(5)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	event.ObjsSyncObj(5, 5)
	event.ObjsSetRot(5, 0.0, 0.0, 0.0)
	event.CmrsInit()
	event.CmrsSetPos(-1323.57, 7.45, 4810.3)
	event.CmrsSetRef(-994.3, 130.62, 4578.42)
	event.SetFadeIn(30)
	event.ObjsMove2(1, -790.0, 0.0, 4500.0, 40, 2, 1.0)
	event.SndSePlay(var0, 0)
	helper_b01df685(1)
	if vm.skipping() then
		return skip(2)
	end
	helper_d779bb0d(10)
	if vm.skipping() then
		return skip(3)
	end
	event.SetCrossfade(30)
	event.CmrsSetPos(-375.22998, 32.86, 4221.61)
	event.CmrsSetRef(-240.0, 31.8, 4350.0)
	event.EohSetPos(1, -790.0, 0.0, 4500.0)
	event.CharaActive(0)
	event.ObjsSetPos(0, -240.0, 30.0, 4480.0)
	event.ObjsSetRot(0, 0.0, 3.1415927, 0.0)
	event.ObjsRotation(2, 0.0, 0.0, -1.5707964, 30)
	event.ObjsRotation(3, 0.0, 0.0, -1.5707964, 30)
	event.ObjsRotation(4, 0.0, 0.0, 0.3926991, 30)
	event.ObjsRotation(5, 0.0, 0.0, 0.3926991, 30)
	var4 = event.GetSndId(2) or var4
	event.SndSePlay(var4, 92)
	helper_d779bb0d(30)
	if vm.skipping() then
		return skip(4)
	end
	event.ObjsMove(5, pos_x - 22.5, pos_y - 9.5, pos_z, 30)
	helper_d779bb0d(20)
	if vm.skipping() then
		return skip(5)
	end
	event.ObjsMove(0, -240.0, 0.0, 4405.0, 30)
	event.ObjsSetMotion(0, "走り", 4)
	event.EohSetFootSoundId(0, 6)
	helper_b01df685(0)
	if vm.skipping() then
		return skip(6)
	end
	event.EohSetFootSoundId(0, 0)
	event.ObjsSetMotion(0, "立ち")
	helper_d779bb0d(10)
	if vm.skipping() then
		return skip(7)
	end
	event.SetFadeIn(1)
	event.EohSetPos(1, -790.0, 0.0, 4500.0)
	event.EohSetRot(1, 0.0, -1.57, 0.0)
	event.EohSetRot(2, 0.0, 0.0, 0.0)
	event.EohSetRot(3, 0.0, 0.0, 0.0)
	event.EohSetRot(4, 0.0, 0.0, 0.0)
	event.EohSetPos(5, pos_x, pos_y, pos_z)
	event.EohSetRot(5, 0.0, 0.0, 0.0)
	event.CmrsInit()
	event.CharaActive(0)
	event.SetCharaPos(0, -240.0, 0.0, 4350.0)
	event.SetCharaRot(0, 0.0, 3.1415927, 0.0)
	event.CharaNormalDrive(0)
	event.CharaResetDa(0)
	event.ResetCamera(1, 0.0, 10.0)
end

--- Helper function.
local function helper_12890()
	local var0: s32 = 0
	local var1: s32 = 0
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 9 then
			if at <= 1 then
				helper_d779bb0d(210)
			end
			if at <= 2 then
				helper_d779bb0d(30)
			end
			if at <= 3 then
				helper_b01df685(2)
			end
			if at <= 4 then
				helper_512cd149(6480100)
			end
			if at <= 5 then
				helper_b01df685(2)
			end
			if at <= 6 then
				helper_512cd149(6480110)
			end
			if at <= 7 then
				helper_b01df685(1)
			end
			if at <= 8 then
				helper_d779bb0d(30)
			end
			if vm.skip_end() then
				return skip(10)
			end
			return part2()
		end
		if at <= 10 then
			helper_d779bb0d(4)
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SndSeStop(var0, 4)
		event.StopBgm(0)
		helper_d779bb0d(4)
		if vm.skipping() then
			return skip(11)
		end
		var3 = event.GetDefBgmNo(72) or var3
		event.LoadBgm(var3)
		event.PlayBgm(0)
		event.CharaActive(1, var1)
		event.EohSetPos(3, -790, 0.0, 4500)
		event.EohSetRot(3, 0.0, -1.57, 0.0)
		event.EohSetRot(4, 0.0, 0.0, 0.0)
		event.EohSetRot(5, 0.0, 0.0, 0.0)
		event.EohSetRot(6, 0.0, 0.0, 0.0)
		event.EohSetRot(7, 0.0, 0.0, 0.0)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.EohSetFootSoundId(2, 0)
		event.SpriteSetDraw(0, 0)
		event.DelExtMotion(0)
		event.DeleteChara(33)
		event.DeleteChara(34)
		event.DeleteChara(35)
		event.LoadMes(0, -1)
	end
	event.SetFlag(648, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.LoadSound(7815)
	var0 = event.SndLoadSound(7815) or var0
	event.SndSePlay(var0, 0)
	event.SndSeStop(var0, 0)
	var1 = event.SearchCharaNo(301) or var1
	event.CharaActive(0, var1)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.ChangeDir("event/e600/e648/")
	event.LoadMes(0, 5, "e648.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e648_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e648_monica.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.LoadChara(5, "e648_osmond.gltf", "info", 35)
	event.CharaActive(35)
	event.EohSyncChara(2, 35)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.EohSyncObj(3, "p01_train01")
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.EohSyncObj(4, "p01_train01", "s3601_12-m")
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.EohSyncObj(5, "p01_train01", "s3601_14-m")
	event.ObjsSyncObj(5, 5)
	event.ObjsSetRot(5, 0.0, 0.0, 0.0)
	event.EohSyncObj(6, "p01_train01", "s3601_16-m")
	event.ObjsSyncObj(6, 6)
	event.ObjsSetRot(6, 0.0, 0.0, 0.0)
	event.EohSyncObj(7, "p01_train01", "s3601_17-m1")
	event.ObjsSyncObj(7, 7)
	event.ObjsSetRot(7, 0.0, 0.0, 0.0)
	event.ChangeDir("")
	if active_chr_no == 1 then
		event.LoadChara(5, "chara/c01_base.gltf", "info", 33)
		event.LoadEquip(5, 0, 4, "info", 33)
		event.LoadEquip(5, 0, 3, "info", 33)
		event.LoadEquip(5, 0, 2, "info", 33, 34)
		event.LoadMotion(5, "event/e600/e648/e648_mints.gltf", "info", 33)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 33)
		event.EohSyncChara(0, 33)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 0)
	else
		event.LoadChara(5, "chara/c02_base.gltf", "info", 33)
		event.LoadEquip(5, 1, 4, "info", 33)
		event.LoadEquip(5, 1, 3, "info", 33)
		event.LoadEquip(5, 1, 2, "info", 33, 34)
		event.LoadMotion(5, "event/e600/e648/e648_monica.gltf", "info", 33)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 33)
		event.EohSyncChara(1, 33)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 0)
	end
	event.CharaActive(33)
	event.CharaActive(34)
	event.EohSetPos(0, 3.38, -9.6, -127.86)
	event.EohSetRot(0, 0.0, 0.03, 0.0)
	event.EohSetMotion(0, "立ち", 4)
	event.EohSetFootSoundId(0, 1)
	event.EohSetPos(1, 19.72, -9.6, -146.14)
	event.EohSetRot(1, 0.0, -0.81, 0.0)
	event.EohSetMotion(1, "立ち", 4)
	event.EohSetFootSoundId(1, 1)
	event.EohSetPos(2, 0.11, -2.82, -96.44)
	event.EohSetRot(2, 0.0, 0.0, 0.0)
	event.EohSetMotion(2, "立ち", 4)
	event.EohSetFootSoundId(2, 1)
	event.EohSetPos(3, 10497.4, 4263.4, 16022.1)
	event.EohSetRot(3, 0.17453292, -2.268928, 0.0)
	event.EohSetRot(4, 0.0, 0.0, 0.0)
	event.EohSetRot(5, 0.0, 0.0, 0.0)
	event.EohSetRot(6, 0.0, 0.0, 0.0)
	event.InitDramaScene()
	event.CmrsInit()
	event.CmrsSetPos(8906.16, 4062.09, 15480.96)
	event.CmrsSetRef(9213.43, 4103.76, 15508.46)
	event.CharaActive(0)
	event.CharaActive(33)
	event.CharaActive(34)
	event.CharaActive(35)
	event.SetFadeIn(30)
	event.ObjsMove(3, -738.8, 0.0, 4490.7, 300)
	event.ObjsRotation(3, 0.0, -2.286, 0.3, 300)
	event.SndSePlay(var0, 4)
	event.CmrsMove(8070.99, 3228.35, 15847.63, 7999.18, 3244.28, 15637.48, 90)
	helper_d779bb0d(120)
	if vm.skipping() then
		return skip(1)
	end
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.CmrsSetPos(-1639.57, 7.86, 5016.61)
	event.CmrsSetRef(-1218.91, 101.0, 4719.94)
	event.ObjsSetPos(3, 1200.0, 237.6, 4500)
	event.ObjsSetRot(3, 0.0, -1.57, 0.0)
	event.ObjsMove(3, -400, 0.0, 4500, 60)
	event.ObjsMove2(3, -990, 0.0, 4500, 90, 2, 0.8)
	helper_d779bb0d(210)
	if vm.skipping() then
		return skip(2)
	end
	event.SetFadeOut(30)
	helper_d779bb0d(30)
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsSetPos(3, -790, 0.0, 4500)
	event.SetFadeIn(30)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おこり顔")
	event.ObjsTexAnime(0, 1, "おこり目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "おこり顔")
	event.ObjsTexAnime(1, 1, "おこり目パチ")
	event.ObjsSetPos(0, -266.3, 0.0, 4342.88)
	event.ObjsSetRot(0, 0.0, -3.13, 0.0)
	event.ObjsSetPos(1, -263.45, 0.0, 4372.15)
	event.ObjsSetRot(1, 0.0, -3.13, 0.0)
	event.ObjsSetPos(2, -241.85, 11.82, 4430.23)
	event.ObjsSetRot(2, 0.0, 3.03, 0.0)
	event.CmrsSetPos(-336.6, 39.36, 4198.84)
	event.CmrsSetRef(-239.26, 60.64, 4423.35)
	event.ObjsSetRot(4, 0.0, 0.0, -1.5707964)
	event.ObjsSetRot(5, 0.0, 0.0, -1.5707964)
	event.ObjsSetRot(6, 0.0, 0.0, 0.3926991)
	event.ObjsSetRot(7, 0.0, 0.0, 0.3926991)
	event.ObjsSetMotion(0, "歩き")
	event.ObjsMove(0, -249.34, 0.0, 4318.43, 60)
	event.ObjsMotionDelay(0, 60)
	event.ObjsSetMotion(0, "立ち")
	event.ObjsSetMotion(1, "歩き")
	event.ObjsMove(1, -277.96, 0.0, 4332.42, 60)
	event.ObjsMotionDelay(1, 60)
	event.ObjsSetMotion(1, "立ち")
	event.ObjsSetMotion(2, "歩き")
	event.ObjsMove(2, -253.46, 0.0, 4397.34, 30)
	event.ObjsMove(2, -252.88, 0.0, 4367.79, 30)
	event.ObjsMotionDelay(2, 60)
	event.ObjsSetMotion(2, "立ち")
	helper_b01df685(2)
	if vm.skipping() then
		return skip(4)
	end
	event.CmrsSetPos(-130.69, 136.99, 4468.57)
	event.CmrsSetRef(-261.31, 3.53, 4336.64)
	event.ObjsSetPos(0, -235.2, 0.0, 4329.41)
	event.ObjsSetRot(0, 0.0, -0.09, 0.0)
	event.ObjsSetPos(1, -276.84, 0.0, 4326.87)
	event.ObjsSetRot(1, 0.0, 0.39, 0.0)
	event.ObjsSetPos(2, -254.29, 0.0, 4359.67)
	event.ObjsSetRot(2, 0.0, 3.03, 0.0)
	event.ObjsSetMotion(0, "オズ見立ち", 4)
	event.ObjsSetMotion(1, "オズ見", 4)
	event.ObjsSetMotion(2, "立ち（上見）", 6)
	event.ObjsNextMotion(2, "会話（上見）", 6)
	event.ObjsNextMotion(2, "立ち（上見）", 4)
	helper_512cd149(6480100)
	if vm.skipping() then
		return skip(5)
	end
	helper_b01df685(2)
	if vm.skipping() then
		return skip(6)
	end
	event.ObjsSetMotion(0, "オズ見うなづき", 6)
	event.ObjsNextMotion(0, "オズ見立ち", 6)
	event.ObjsSetMotion(1, "オズ見うなずき", 6)
	event.ObjsNextMotion(1, "オズ見", 6)
	helper_512cd149(6480110)
	if vm.skipping() then
		return skip(7)
	end
	helper_b01df685(1)
	if vm.skipping() then
		return skip(8)
	end
	event.SetFadeOut(30)
	helper_d779bb0d(30)
	if vm.skipping() then
		return skip(9)
	end
	return part2()
end

--- Helper function.
local function helper_2f7a8()
	local var0: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_d779bb0d(20)
		end
		return 1
	end
	event.Initialize()
	event.SetMotion(0, "立ち")
	event.SetMesQuestionGyou(0, 0)
	event.SetMesWindowMode(0, 5)
	event.SetMesDrawspeed(0, 1)
	var0 = helper_f427c76a(5, 4)
	if vm.skipping() then
		return skip(1)
	end
	if var0 == 0 then
		event.SetFadeOut(20)
		helper_d779bb0d(20)
		if vm.skipping() then
			return skip(2)
		end
		return 1
	end
	return 0
end

--- Helper function.
local function helper_24400()
	local var0: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_e1e5862e(0, 1)
			return 0
		end
		if at <= 3 then
			helper_d779bb0d(15)
		end
		return 0
	end
	event.SetMotion(0, "立ち")
	event.Initialize()
	helper_e1e5862e(0, 4)
	event.MesMake_2(0, "中に入る\n出発する")
	var0 = helper_766c5e7b(0, -1, 5, 256, 208, 2, 0)
	if vm.skipping() then
		return skip(1)
	end
	if var0 == -1 then
		helper_e1e5862e(0, 1)
		return 0
	end
	if var0 == 1 then
		event.SetFadeOut(15)
		helper_d779bb0d(15)
		if vm.skipping() then
			return skip(2)
		end
		event.GotoMenu(19, 0)
		if vm.wait() then
			return skip(3)
		end
		event.SetFadeIn(15)
		helper_d779bb0d(15)
		if vm.skipping() then
			return skip(4)
		end
		return 0
	end
	return 1
end

--- Helper function.
local function helper_1a378()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var6: f32 = 0
	local var7: s32 = 0
	local var8: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_d779bb0d(20)
		end
		if at <= 2 then
			helper_d779bb0d(18)
		end
		if at <= 3 then
			helper_d779bb0d(12)
		end
		if at <= 4 then
			helper_d779bb0d(30)
		end
		if at <= 5 then
			helper_d779bb0d(10)
		end
		if at <= 6 then
			helper_d779bb0d(20)
		end
		if at <= 7 then
			helper_d779bb0d(18)
		end
		if at <= 8 then
			helper_d779bb0d(12)
		end
		if at <= 9 then
			helper_d779bb0d(30)
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
		helper_d779bb0d(10)
		if vm.skipping() then
			return skip(1)
		end
		event.ObjsRotation(1, 0.0, -4.9415927, 0.0, 30)
		event.ObjsRotation(2, 0.0, -4.9415927, 0.0, 30)
		event.ObjsRotation(3, 0.0, -4.9415927, 0.0, 30)
		helper_d779bb0d(20)
		if vm.skipping() then
			return skip(2)
		end
		event.ObjsSetMotion(0, "歩き")
		event.ObjsMove(0, -29.1, 1.38, -0.82, 30)
		event.ObjsMove(0, -50.41, 1.38, 0.05, 30)
		event.EohSetFootSoundId(0, 6)
		helper_d779bb0d(18)
		if vm.skipping() then
			return skip(3)
		end
		event.EohSetFootSoundId(0, 3)
		helper_d779bb0d(12)
		if vm.skipping() then
			return skip(4)
		end
		event.SetFadeOut(30)
		helper_d779bb0d(30)
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
		helper_d779bb0d(10)
		if vm.skipping() then
			return skip(6)
		end
		event.ObjsRotation(1, 0.0, -1.8, 0.0, 30)
		event.ObjsRotation(2, 0.0, -1.8, 0.0, 30)
		event.ObjsRotation(3, 0.0, -1.8, 0.0, 30)
		helper_d779bb0d(20)
		if vm.skipping() then
			return skip(7)
		end
		event.ObjsSetMotion(0, "歩き")
		event.ObjsMove(0, 29.1, 1.38, 0.82, 30)
		event.ObjsMove(0, 50.41, 1.38, -0.05, 30)
		event.EohSetFootSoundId(0, 6)
		helper_d779bb0d(18)
		if vm.skipping() then
			return skip(8)
		end
		event.EohSetFootSoundId(0, 3)
		helper_d779bb0d(12)
		if vm.skipping() then
			return skip(9)
		end
		event.SetFadeOut(30)
		helper_d779bb0d(30)
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
local function helper_1ea78()
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
			helper_d779bb0d(10)
		end
		if at <= 2 then
			helper_d779bb0d(20)
		end
		if at <= 3 then
			helper_d779bb0d(30)
		end
		if at <= 4 then
			helper_d779bb0d(20)
		end
		if at <= 5 then
			helper_d779bb0d(10)
		end
		if at <= 6 then
			helper_d779bb0d(20)
		end
		if at <= 7 then
			helper_d779bb0d(30)
		end
		if at <= 8 then
			helper_d779bb0d(20)
		end
		if at <= 9 then
			helper_d779bb0d(10)
		end
		if at <= 10 then
			var16 = 0
			print("てつのあしおと\n")
			var16 = 6
			print("いしのあしおと\n")
			var16 = 2
			helper_d779bb0d(30)
		end
		if at <= 11 then
			helper_d779bb0d(30)
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
	helper_d779bb0d(10)
	if vm.skipping() then
		return skip(2)
	end
	if vm.imod(var5, 2) ~= 1 then
		event.ObjsRotation(2, 0.0, 0.0, 1.5707964, 30)
		event.ObjsRotation(3, 0.0, 0.0, 1.5707964, 30)
		if now_map_no == 83 or now_map_no == 54 or now_map_no == 34 then
			helper_d779bb0d(20)
			if vm.skipping() then
				return skip(3)
			end
		else
			event.ObjsRotation(4, 0.0, 0.0, -0.3926991, 30)
			event.ObjsRotation(5, 0.0, 0.0, -0.3926991, 30)
			helper_d779bb0d(30)
			if vm.skipping() then
				return skip(4)
			end
			if now_map_no == 103 then
				event.ObjsMove(5, pos_x + 45.0, pos_y - 19.0, pos_z, 30)
				helper_d779bb0d(20)
				if vm.skipping() then
					return skip(5)
				end
			else
				event.ObjsMove(5, pos_x + 20.0, pos_y - 8.0, pos_z, 20)
				helper_d779bb0d(10)
				if vm.skipping() then
					return skip(6)
				end
			end
		end
	else
		event.ObjsRotation(2, 0.0, 0.0, -1.5707964, 30)
		event.ObjsRotation(3, 0.0, 0.0, -1.5707964, 30)
		if now_map_no == 83 or now_map_no == 54 or now_map_no == 34 then
			helper_d779bb0d(20)
			if vm.skipping() then
				return skip(7)
			end
		else
			event.ObjsRotation(4, 0.0, 0.0, 0.3926991, 30)
			event.ObjsRotation(5, 0.0, 0.0, 0.3926991, 30)
			helper_d779bb0d(30)
			if vm.skipping() then
				return skip(8)
			end
			if now_map_no == 103 then
				event.ObjsMove(5, pos_x - 45.0, pos_y - 19.0, pos_z, 30)
				helper_d779bb0d(20)
				if vm.skipping() then
					return skip(9)
				end
			else
				event.ObjsMove(5, pos_x - 20.0, pos_y - 8.0, pos_z, 20)
				helper_d779bb0d(10)
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
	helper_d779bb0d(30)
	if vm.skipping() then
		return skip(11)
	end
	event.SetFadeOut(30)
	helper_d779bb0d(30)
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
local function helper_1594c()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			helper_d779bb0d(10)
		end
	end
	event.Initialize()
	event.SetMotion(0, "立ち")
	event.SetFadeOut(10)
	helper_d779bb0d(10)
	if vm.skipping() then
		return skip(1)
	end
	event.GotoMenu(7)
	if vm.wait() then
		return skip(2)
	end
	event.SetFadeIn(10)
	helper_d779bb0d(10)
	if vm.skipping() then
		return skip(3)
	end
end

--- Helper function.
local function helper_e2dc()
	local active_chr_no: s32 = 0
	event.SetMesWindowMode(0, 7)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		global0 = 0
		global1 = 32
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.LoadMotion(5, "event/e600/e616/e616_mints.gltf", "info", global0)
		event.EohSyncChara(0, global0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global0)
		event.LoadChara(5, "chara/c02_base.gltf", "info", global1)
		event.LoadEquip(5, 1, 4, "info", global1)
		event.LoadEquip(5, 1, 3, "info", global1)
		event.LoadEquip(5, 1, 2, "info", global1, 37)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.LoadMotion(5, "event/e600/e616/e616_monica.gltf", "info", global1)
		event.EohSyncChara(1, global1)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global1)
		event.CharaActive(1, 37)
	end
	if active_chr_no == 1 then
		global0 = 32
		global1 = 0
		event.LoadChara(5, "chara/c01_base.gltf", "info", global0)
		event.LoadEquip(5, 0, 4, "info", global0)
		event.LoadEquip(5, 0, 3, "info", global0)
		event.LoadEquip(5, 0, 2, "info", global0, 37)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.LoadMotion(5, "event/e600/e616/e616_mints.gltf", "info", global0)
		event.EohSyncChara(0, global0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global0)
		event.CharaActive(1, 37)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.LoadMotion(5, "event/e600/e616/e616_monica.gltf", "info", global1)
		event.EohSyncChara(1, global1)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global1)
	end
	event.LoadChara(5, "event/e600/e616/e616_osmond.gltf", "info", 38)
	event.CharaActive(0, 38)
	event.EohSyncChara(2, 38)
	event.ObjsInit(2, 38)
	event.ObjsSyncObj(2, 2)
	event.LoadChara(5, "event/e600/e616/e616_toryon.gltf", "info", 39)
	event.CharaActive(0, 39)
	event.EohSyncChara(3, 39)
	event.ObjsInit(3, 39)
	event.ObjsSyncObj(3, 3)
	event.LoadChara(5, "event/e600/e616/e616_beam_f.gltf", "info", 40)
	event.CharaActive(0, 40)
	event.EohSyncChara(8, 40)
	event.ObjsInit(8, 40)
	event.ObjsSyncObj(8, 8)
	event.LoadChara(5, "event/e600/e616/e616_beam_h.gltf", "info", 41)
	event.CharaActive(0, 41)
	event.EohSyncChara(9, 41)
	event.ObjsInit(9, 41)
	event.ObjsSyncObj(9, 9)
	event.LoadChara(5, "event/e600/e616/e616_tama1.gltf", "info", 42)
	event.CharaActive(0, 42)
	event.EohSyncChara(10, 42)
	event.ObjsInit(10, 42)
	event.ObjsSyncObj(10, 10)
	event.EsmInitialize(5)
	event.EsmLoadBase("Ｅ６１６月花ビームＢ")
	event.EsmInitFix(5)
	event.LoadChara(5, "event/e600/e616/e616_iwa.gltf", "info", 43)
	event.CharaActive(0, 43)
	event.EohSyncChara(11, 43)
	event.ObjsInit(11, 43)
	event.ObjsSyncObj(11, 11)
	event.CopyChara(5, 43, 44)
	event.CharaActive(0, 44)
	event.EohSyncChara(12, 44)
	event.ObjsInit(12, 44)
	event.ObjsSyncObj(12, 12)
	event.EohSyncObj(4, "p01_train01")
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.EohSyncObj(14, "p01_shadow-0")
	event.EohSyncObj(5, "p01_train01", "s3601_12-m1")
	event.ObjsInit(5)
	event.ObjsSyncObj(5, 5)
	event.EohSyncObj(6, "p01_train01", "s3601_14-m1")
	event.ObjsSyncObj(6, 6)
	event.ObjsSetRot(6, 0.0, 0.0, 0.0)
	event.EohSyncObj(7, "p01_train01", "s3601_16-m1")
	event.ObjsSyncObj(7, 7)
	event.ObjsSetRot(7, 0.0, 0.0, 0.0)
	event.EohSyncObj(13, "p01_train01", "s3601_17-m")
	event.ObjsSyncObj(13, 13)
	event.ObjsSetRot(13, 0.0, 0.0, 0.0)
	event.LoadMes(0, 5, "event/e600/e616/e616.txt")
end

--- Helper function.
local function helper_dee4()
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		event.CharaActive(1, global0)
		event.CharaActive(0, global1)
		event.DelExtMotion(global0)
		event.DelExtMotion(global1)
		event.DeleteChara(global1)
		event.DeleteChara(37)
	end
	if active_chr_no == 1 then
		event.CharaActive(1, global1)
		event.CharaActive(0, global0)
		event.DelExtMotion(global0)
		event.DelExtMotion(global1)
		event.DeleteChara(global0)
		event.DeleteChara(37)
	end
	event.DeleteChara(38)
	event.DeleteChara(39)
	event.DeleteChara(40)
	event.DeleteChara(41)
	event.DeleteChara(42)
	event.DeleteChara(43)
	event.DeleteChara(44)
	event.Finish()
	if vm.wait() then
		return skip(2)
	end
end

--- Helper function.
local function helper_fba0()
	local var6: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var10: s32 = 0
	local var11: f32 = 0
	local var12: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	local var15: f32 = 0
	local var16: f32 = 0
	local var17: f32 = 0
	local var18: f32 = 0
	local var19: f32 = 0
	local var20: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 19 then
			if at <= 1 then
				helper_d779bb0d(30)
			end
			if at <= 2 then
				helper_d779bb0d(10)
			end
			if at <= 3 then
				helper_d779bb0d(20)
			end
			if at <= 4 then
				helper_d779bb0d(30)
			end
			if at <= 5 then
				helper_d779bb0d(30)
			end
			if at <= 6 then
				helper_d779bb0d(30)
			end
			if at <= 7 then
				helper_d779bb0d(30)
			end
			if at <= 8 then
				helper_d779bb0d(20)
			end
			if at <= 9 then
				var10 = 2
				helper_d779bb0d(10)
			end
			if at <= 10 then
				var10 = 0
				helper_d779bb0d(10)
			end
			if at <= 11 then
				var10 = 1
				helper_b01df685(1)
			end
			if at <= 12 then
				helper_d779bb0d(10)
			end
			if at <= 13 then
				helper_1281c23c()
			end
			if at <= 14 then
				helper_d779bb0d(30)
			end
			if at <= 15 then
				helper_d779bb0d(60)
			end
			if at <= 16 then
				helper_d779bb0d(30)
			end
			if at <= 17 then
				helper_b01df685(4)
			end
			if at <= 18 then
				var11 = 790.0
				var12 = 0.0
				var13 = vm.f32(0.26666668)
				var14 = 50.0
				var15 = 0.0
				var16 = vm.f32(0.1)
				var17 = 4500.0
				var18 = 0.0
				var19 = 0.0
				var20 = 0
				var11 = vm.f32(var11 + var12)
				var12 = vm.f32(var12 + var13)
				var14 = vm.f32(var14 + var15)
				var15 = vm.f32(var15 + var16)
				var17 = vm.f32(var17 + var18)
				var18 = vm.f32(var18 + var19)
				var20 = var20 + 1
			end
			if vm.skip_end() then
				return skip(20)
			end
			return part2()
		end
		if at <= 20 then
			helper_d779bb0d(35)
		end
		if at <= 22 then
			helper_dee4()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.FadeOutBgm(30)
		event.SetFadeOut(30)
		helper_d779bb0d(35)
		if vm.skipping() then
			return skip(21)
		end
		event.StopBgm(0)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.SndSeAllStop(4)
		event.EsmClear()
		if vm.wait() then
			return skip(22)
		end
		helper_dee4()
		if vm.skipping() then
			return skip(23)
		end
		event.ResetCamera(0)
		event.SetFadeIn(30)
	end
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	var6 = event.SndLoadSound(7202) or var6
	helper_e2dc()
	event.InitDramaScene()
	event.EohSetFootSoundId(0, 16)
	event.EohSetFootSoundId(1, 16)
	event.EohSetFootSoundId(2, 16)
	event.EohSyncChrobj(20, 39, "puropera")
	event.ObjsInit(20)
	event.ObjsSyncObj(20, 20)
	event.ObjsRotation(20, 0.0, -0.08, 0.0, -1)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "デフォルト顔")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.CharaActive(1, global0)
	event.CharaActive(1, global1)
	event.CharaActive(1, 38)
	event.CharaActive(1, 39)
	event.ObjsSetPos(4, 790.0, 0.0, 4500.0)
	event.ObjsSetRot(4, 0.0, 1.57, 0.0)
	event.EohSetRot(5, 0.0, 0.0, 0.0)
	event.ObjsSetPos(8, 913.78, 1815.71, -1455.71)
	event.ObjsSetPos(10, 913.78, 1815.71, -1455.71)
	event.ObjsSetRot(10, 0.0, -0.04, 0.0)
	event.ObjsSetPos(9, 347.12, 200.0, 1407.85)
	event.CharaActive(1, 40)
	event.ObjsSetMotion(8, "入り", 6)
	event.ObjsNextMotion(8, "溜めループ", 4)
	event.CmrsSetPos(740.39, 361.22, 3768.25)
	event.CmrsSetRef(58.72, 398.27, 1944.66)
	event.ObjsSetMotion(0, "走り", 4, -1.0, 1)
	event.ObjsSetMotion(1, "走り", 4, -1.0, 1)
	event.ObjsSetMotion(2, "走り")
	event.ObjsSetPos(3, 607.53, 453.56, -239.32)
	event.ObjsSetRot(3, 0.0, -2.56, 0.0)
	event.ObjsInitPas(2)
	event.ObjsSetPasFrm(2, 120)
	event.ObjsAddPas(2, 0.0, 173.54, 2717.0)
	event.ObjsAddPas(2, 0.0, 59.11, 3144.44)
	event.ObjsStartPas(2, 1)
	event.ObjsInitPas(1)
	event.ObjsSetPasFrm(1, 140)
	event.ObjsAddPas(1, 25.0, 189.22, 2617.0)
	event.ObjsAddPas(1, 25.0, 49.45, 3179.82)
	event.ObjsStartPas(1, 1)
	event.ObjsInitPas(0)
	event.ObjsSetPasFrm(0, 130)
	event.ObjsAddPas(0, -25.0, 184.27, 2667.0)
	event.ObjsAddPas(0, -25.75, 51.4, 3172.67)
	event.ObjsStartPas(0, 1)
	event.ObjsSetMotion(3, "岩を投げる", 4)
	event.CharaActive(1, 43)
	event.CharaActive(1, 44)
	event.SetFadeIn(30)
	event.ObjsSetPos(11, 395.57, 1007.08, -157.89)
	event.ObjsJump(11, -200.0, 700.0, -1000.0, -1.2, 60)
	helper_d779bb0d(30)
	if vm.skipping() then
		return skip(1)
	end
	event.ObjsSetPos(12, 395.57, 1007.08, -157.89)
	event.ObjsJump(12, 200.0, 700.0, -1000.0, -1.2, 60)
	helper_d779bb0d(30)
	if vm.skipping() then
		return skip(2)
	end
	event.CharaActive(1, 42)
	event.ObjsSetMotion(8, "発射", 6)
	event.ObjsSetMotion(10, "弾道", 6)
	event.EsmCreate("Ｅ６１６月花ビームＢ")
	event.EsmSetVect1(913.78, 1815.71, -1455.71)
	event.EsmSetVect2(0.0, -0.04, 0.0)
	event.ObjsSetPos(11, 395.57, 1007.08, -157.89)
	event.ObjsJump(11, -200.0, 700.0, -1000.0, -1.2, 60)
	helper_d779bb0d(10)
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsMove(3, 395.57, 707.08, -157.89, 10)
	event.ObjsSetPos(12, 395.57, 1007.08, -157.89)
	event.ObjsJump(12, 200.0, 700.0, -1000.0, -1.2, 60)
	helper_d779bb0d(20)
	if vm.skipping() then
		return skip(4)
	end
	event.CharaActive(1, 41)
	event.SetMotion(41, "ヒット", 6, -1, 1)
	helper_d779bb0d(30)
	if vm.skipping() then
		return skip(5)
	end
	event.ObjsSetPos(11, 395.57, 1007.08, -157.89)
	event.ObjsJump(11, -200.0, 700.0, -1000.0, -1.2, 60)
	helper_d779bb0d(30)
	if vm.skipping() then
		return skip(6)
	end
	event.ObjsSetPos(12, 395.57, 1007.08, -157.89)
	event.ObjsJump(12, 200.0, 700.0, -1000.0, -1.2, 60)
	helper_d779bb0d(30)
	if vm.skipping() then
		return skip(7)
	end
	event.CmrsSetPos(368.47, 250.27, 3796.05)
	event.CmrsSetRef(296.74, 109.55, 4410.1)
	event.SndSePlay(var6, 7)
	do
		local out1, out2, out3 = event.EohGetPos(13)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	event.ObjsRotation(5, 0.0, 0.0, 1.5707964, 30)
	event.ObjsRotation(6, 0.0, 0.0, 1.5707964, 30)
	event.ObjsRotation(7, 0.0, 0.0, -0.3926991, 30)
	event.ObjsRotation(13, 0.0, 0.0, -0.3926991, 30)
	helper_d779bb0d(30)
	if vm.skipping() then
		return skip(8)
	end
	event.ObjsMove(13, pos_x + 45.0, pos_y - 19.0, pos_z, 30)
	helper_d779bb0d(20)
	if vm.skipping() then
		return skip(9)
	end
	var10 = 2
	event.ObjsInitPas(var10)
	event.ObjsSetPasFrm(var10, 120)
	event.ObjsAddPas(var10, 272.66, 0.0, 4119.88)
	event.ObjsAddPas(var10, 249.45, 0.0, 4367.87)
	event.ObjsAddPas(var10, 241.61, 14.02, 4435.0)
	event.ObjsAddPas(var10, 234.87, 28.2, 4492.6)
	event.ObjsStartPas(var10)
	helper_d779bb0d(10)
	if vm.skipping() then
		return skip(10)
	end
	var10 = 0
	event.ObjsInitPas(var10)
	event.ObjsSetPasFrm(var10, 120)
	event.ObjsAddPas(var10, 272.66, 0.0, 4119.88)
	event.ObjsAddPas(var10, 249.45, 0.0, 4367.87)
	event.ObjsAddPas(var10, 241.61, 14.02, 4435.0)
	event.ObjsAddPas(var10, 234.87, 28.2, 4492.6)
	event.ObjsStartPas(var10)
	helper_d779bb0d(10)
	if vm.skipping() then
		return skip(11)
	end
	var10 = 1
	event.ObjsInitPas(var10)
	event.ObjsSetPasFrm(var10, 120)
	event.ObjsAddPas(var10, 272.66, 0.0, 4119.88)
	event.ObjsAddPas(var10, 249.45, 0.0, 4367.87)
	event.ObjsAddPas(var10, 241.61, 14.02, 4435.0)
	event.ObjsAddPas(var10, 234.87, 28.2, 4492.6)
	event.ObjsStartPas(var10)
	helper_b01df685(1)
	if vm.skipping() then
		return skip(12)
	end
	event.CharaActive(0, global0)
	event.CharaActive(0, global1)
	event.CharaActive(0, 38)
	helper_d779bb0d(10)
	if vm.skipping() then
		return skip(13)
	end
	event.CmrsInitPas()
	event.CmrsSetPasFrm(200)
	event.CmrsAddPas(368.47, 250.27, 3796.05, 296.74, 109.55, 4410.1)
	event.CmrsAddPas(368.47, 250.27, 3796.05, 693.41, 109.55, 4324.2)
	event.CmrsStartPas()
	helper_1281c23c()
	if vm.skipping() then
		return skip(14)
	end
	helper_d779bb0d(30)
	if vm.skipping() then
		return skip(15)
	end
	event.EohSetShow(14, 0)
	event.CmrsSetPos(306.21, 234.45, 6861.67)
	event.CmrsSetRef(234.87, 296.89, 4492.6)
	event.SndSePlay(var6, 8)
	helper_d779bb0d(60)
	if vm.skipping() then
		return skip(16)
	end
	event.ObjsSetMotion(3, "浮遊", 4)
	event.ObjsRotation2(3, -0.209, 1.57, 0.0, 60, 0, 0.4)
	event.ObjsMove(3, 8374.23, 2944.08, 3500.0, 360)
	helper_d779bb0d(30)
	if vm.skipping() then
		return skip(17)
	end
	event.SndSePlay(var6, 9)
	event.ObjsMove2(4, 790.0, 50.0, 4500.0, 60, 0, 1.0)
	event.CmrsMoveRef(790.0, 100.0, 4500.0, 60)
	helper_b01df685(4)
	if vm.skipping() then
		return skip(18)
	end
	event.ObjsRotation2(4, -0.209, 1.57, 0.0, 120, 0, 0.4)
	var11 = 790.0
	var12 = 0.0
	var13 = vm.f32(0.26666668)
	var14 = 50.0
	var15 = 0.0
	var16 = vm.f32(0.1)
	var17 = 4500.0
	var18 = 0.0
	var19 = 0.0
	var20 = 0
	while var20 < 240 do
		event.ObjsSetPos(4, var11, var14, var17)
		event.CmrsSetRef(var11, var14 + 50.0, var17)
		var11 = vm.f32(var11 + var12)
		var12 = vm.f32(var12 + var13)
		var14 = vm.f32(var14 + var15)
		var15 = vm.f32(var15 + var16)
		var17 = vm.f32(var17 + var18)
		var18 = vm.f32(var18 + var19)
		var20 = var20 + 1
		if vm.wait() then
			return skip(19)
		end
	end
	return part2()
end

--- Helper function.
local function helper_8d30(arg0: s32, arg1: any, arg2: any)
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var10: f32 = 0
	local var13: f32 = 0
	local var15: f32 = 0
	local var16: f32 = 0
	local offset_x: f32 = 0
	local offset_y: f32 = 0
	local offset_z: f32 = 0
	local middle_x: f32 = 0
	local var21: f32 = 0
	local middle_z: f32 = 0
	local var27: f32 = 0
	local var28: f32 = 0
	local angle: f32 = 0
	local var30: f32 = 0
	local var31: f32 = 0
	local angle_2: f32 = 0
	local var33: f32 = 0
	local var34: f32 = 0
	local var35: f32 = 0
	local var36: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	do
		local out1, out2, out3 = event.GetCharaPos(arg0)
		var3 = out1 or var3
		var4 = out2 or var4
		var5 = out3 or var5
	end
	do
		local _, out2, _ = event.GetCharaRot(arg0)
		var10 = out2 or var10
	end
	do
		local out1, out2, out3 = event.GetCharaPos(arg1)
		var6 = out1 or var6
		var7 = out2 or var7
		var8 = out3 or var8
	end
	do
		local _, out2, _ = event.GetCharaRot(arg1)
		var13 = out2 or var13
	end
	var15 = event.GetRotLookPos(var6 - var3, var8 - var5) or var15
	var16 = event.GetRotLookPos(var3 - var6, var5 - var8) or var16
	if arg2 ~= 0 then
		do
			local out1, out2, out3, out4, out5, out6 = event.SetTalkCamera(var3, var4, var5, var6, var7, var8, var15)
			offset_x = out1 or offset_x
			offset_y = out2 or offset_y
			offset_z = out3 or offset_z
			middle_x = out4 or middle_x
			var21 = out5 or var21
			middle_z = out6 or middle_z
		end
		event.SetCameraPos(offset_x, offset_y, offset_z)
		event.SetCameraRef(middle_x, var21, middle_z)
		event.SetCrossfade(10)
	end
	var27 = var10
	var28 = var15
	angle = vm.f32(var28 - var27)
	angle = event.AngleLimit(angle) or angle
	var30 = var13
	var31 = var16
	angle_2 = vm.f32(var31 - var30)
	angle_2 = event.AngleLimit(angle_2) or angle_2
	if -0.5 < angle and angle < 0.5 then
		event.SetMotion(arg0, "立ち")
	else
		event.SetMotion(arg0, "歩き")
	end
	if -0.5 < angle_2 and angle_2 < 0.5 then
	else
		event.SetMotion(arg1, "歩き")
	end
	var33 = 0.0
	var34 = vm.f32(helper_baeaba52(helper_05ce8bed(angle), helper_05ce8bed(angle_2)) * 8.0)
	while var33 < var34 do
		var35 = helper_bad1e97b(0.0, angle, var33, var34)
		var35 = vm.f32(var35 + var27)
		event.SetCharaRot(arg0, 0.0, var35, 0.0)
		var36 = helper_bad1e97b(0.0, angle_2, var33, var34)
		var36 = vm.f32(var36 + var30)
		event.SetCharaRot(arg1, 0.0, var36, 0.0)
		var33 = vm.f32(var33 + 1.0)
		if vm.wait() then
			return skip(1)
		end
	end
	event.SetCharaRot(arg0, 0.0, var15, 0.0)
	event.SetMotion(arg0, "立ち")
	event.SetCharaRot(arg1, 0.0, var16, 0.0)
	event.SetMotion(arg1, "会話")
end

--- Helper function.
local function helper_a264(arg0: any, arg1: any, arg2: any)
	local rot_y: f32 = 0
	local player_chara: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		return rot_y
	end
	if arg2 ~= 0 then
		event.EohSyncChara(0, arg0)
		do
			local _, out2, _ = event.EohGetRot(0)
			rot_y = out2 or rot_y
		end
	end
	player_chara = event.GetControlChrid() or player_chara
	helper_8d30(player_chara, arg0, arg1)
	if vm.skipping() then
		return skip(1)
	end
	return rot_y
end

--- Helper function.
local function helper_a524(arg0: s32, arg1: s32, arg2: s32, arg3: s32)
	local var4: f32 = 0
	local player_chara: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_5057139e(0, arg1, arg0, player_chara, 0)
		end
		if at <= 2 then
			helper_b6f06a8e(arg0, var4, arg2, arg3)
		end
	end
	var4 = helper_a264(arg0, arg2, arg3)
	if vm.skipping() then
		return skip(1)
	end
	player_chara = event.GetControlChrid() or player_chara
	helper_5057139e(0, arg1, arg0, player_chara, 0)
	if vm.skipping() then
		return skip(2)
	end
	helper_b6f06a8e(arg0, var4, arg2, arg3)
	if vm.skipping() then
		return skip(3)
	end
end

--- Helper function.
local function helper_2c11c()
	local var0: s32 = 0
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	var0 = event.GetEventData_2(13) or var0
	helper_e1e5862e(0, 1)
	flag = event.GetFlag(648) or flag
	if flag == 0 then
		event.MesMake_2(0, "オレはここで待ってる。\n幸運を祈ってるぜ！")
	else
		event.MesMake_2(0, "オレはここで待ってるぜ。\n絶対、グリフォンを倒せよ。")
	end
	helper_a524(var0, -1, 0, 0)
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
			helper_23abc()
			print("333--------------------------------------------\n")
			helper_2c364()
		end
		helper_2fa44()
		print("444--------------------------------------------\n")
		print("555--------------------------------------------\n")
		print("999--------------------------------------------\n")
	end
	event.Initialize()
	program_99()
	print("start_event--------------------------------------------\n")
	mc_load = event.CheckMcLoad() or mc_load
	if mc_load == 1 then
		helper_2fa44()
		helper_47e08a85(70.0, vm.f32(0.6), 3440.0, vm.f32(3.14))
		event.ResetCamera(1, 3.14, 10.0)
		event.SetFadeIn(30)
	else
		print("000--------------------------------------------\n")
		old_map_no = event.GetOldMapNo() or old_map_no
		var2 = event.GetMapType(old_map_no) or var2
		if var2 ~= -1 then
			print("111--------------------------------------------\n")
			var3 = event.GetCnt(1) or var3
			if (old_map_no == 18 or old_map_no == 23 or old_map_no == 120 or old_map_no == 108) and var3 == 7 then
				print("222--------------------------------------------\n")
				helper_2fa44()
				helper_2d620()
				if vm.skipping() then
					return skip(1)
				end
				helper_23abc()
				event.SetFadeIn(15)
				event.ResetCamera(1, 0.0)
			else
				print("333--------------------------------------------\n")
				helper_2c364()
				if vm.skipping() then
					return skip(2)
				end
				helper_2fa44()
			end
			print("444--------------------------------------------\n")
		end
		print("555--------------------------------------------\n")
		event.SetMotion(0, "立ち")
	end
	print("999--------------------------------------------\n")
end

--- Program 150.
script[150] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_12890()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 200.
script[200] = function()
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	local t0 = helper_2f7a8()
	if vm.skipping() then
		return skip(1)
	end
	if t0 ~= 0 then
		flag = event.GetFlag(700) or flag
		if flag == 0 then
			event.BgmLoadCancel()
			event.MapJump(-1, "s68", 550)
			if vm.wait() then
				return skip(2)
			end
		else
			event.MapJump(-1, "g05")
			if vm.wait() then
				return skip(3)
			end
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
			helper_1ea78()
		end
	end
	var0 = helper_24400()
	if vm.skipping() then
		return skip(1)
	end
	if var0 ~= 1 then
		return
	end
	event.SetCnt(1, 7)
	var1 = event.GetEventData_2(3) or var1
	if var1 <= 1 then
		helper_1a378()
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
		helper_1ea78()
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
	helper_1594c()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 500.
script[500] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		helper_2fa44()
		helper_47e08a85(vm.f32(-249.34), 0.0, vm.f32(4318.43), vm.f32(3.14))
	end
	helper_12890()
	if vm.skipping() then
		return skip(1)
	end
	helper_2fa44()
	event.CharaActive(0)
	helper_47e08a85(vm.f32(-249.34), 0.0, vm.f32(4318.43), vm.f32(3.14))
	event.ResetCamera(1, 0.0, 10.0)
	event.SetFadeIn(30)
end

--- Program 590.
script[590] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_fba0()
	if vm.skipping() then
		return skip(1)
	end
	event.MapJump(-1, "s11", 502)
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
		helper_2c11c()
		if vm.skipping() then
			return skip(1)
		end
	end
end

return script
