--!strict
-- map/s/s09/s09.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1d96573f = require("@lib/event/helper_1d96573f")
local helper_38448da1 = require("@lib/event/helper_38448da1")
local helper_3c8e2192 = require("@lib/event/helper_3c8e2192")
local helper_3dd465f9 = require("@lib/event/helper_3dd465f9")
local helper_3f1a4e47 = require("@lib/event/helper_3f1a4e47")
local helper_650bfa16 = require("@lib/event/helper_650bfa16")
local helper_69bc591b = require("@lib/event/helper_69bc591b")
local helper_8d58a537 = require("@lib/event/helper_8d58a537")
local helper_b7c85616 = require("@lib/event/helper_b7c85616")
local helper_e304888c = require("@lib/event/helper_e304888c")
local helper_eb838ef8 = require("@lib/event/helper_eb838ef8")
local helper_f96a9d1b = require("@lib/event/helper_f96a9d1b")
local helper_fc624989 = require("@lib/event/helper_fc624989")
local helper_ff0edc1d = require("@lib/event/helper_ff0edc1d")

local global0: s32 = 0
local global1: s32 = 0

--- Helper function.
local function helper_f828()
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.EohSyncObj(0, "p01_train01", "train02-a0")
	event.EohSetShow(0, 0)
	event.EohSyncObj(0, "p01_train01", "train02-a1")
	event.EohSetShow(0, 0)
	event.EohSyncObj(0, "p01_train01", "train02-a2")
	event.EohSetShow(0, 0)
	event.EohSyncObj(0, "p01_train01", "train02-a3")
	event.EohSetShow(0, 0)
	event.EohSyncObj(0, "p01_train01", "train02-a4")
	event.EohSetShow(0, 0)
	event.EohSyncObj(0, "p01_train01", "train02-a5")
	event.EohSetShow(0, 0)
end

--- Helper function.
local function helper_25b30()
	helper_69bc591b()
	helper_f828()
	helper_3f1a4e47()
end

--- Helper function.
local function helper_25bd4()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.EohSetFootSoundId(0, 3)
	event.SetCharaPos(0, -1918.94, 29.4, -453.91)
	event.SetCharaRot(0, 0.0, 0.0, 0.0)
	event.SetMotion(0, "走り", 4)
	event.SetCameraPos(-2033.1, 114.91, -255.29)
	event.SetFadeIn(30)
	event.ObjsMove(0, -1918.94, 29.22, -379.73, 30)
	var3 = 0
	while var3 < 30 do
		do
			local out1, out2, out3 = event.GetCharaPos(0)
			var0 = out1 or var0
			var1 = out2 or var1
			var2 = out3 or var2
		end
		var1 = vm.f32(var1 + 30.0)
		event.SetCameraRef(var0, var1, var2)
		var3 = var3 + 1
		if vm.wait() then
			return skip(1)
		end
	end
end

--- Helper function.
local function helper_1a860(arg0: s32, arg1: s32, arg2: s32)
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
local function helper_1c020()
	local var0: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		print("station_id=", var0, ",train_id=", var1, ",lr_id=", var2, "\n")
		helper_1a860(var0, var1, var2)
	end
	if vm.skipping() then
		return skip(1)
	end
	var0 = event.GetCnt(1) or var0
	var1 = event.GetCnt(0) or var1
	var2 = event.GetCnt(15) or var2
	print("station_id=", var0, ",train_id=", var1, ",lr_id=", var2, "\n")
	helper_1a860(var0, var1, var2)
end

--- Helper function.
local function helper_2a10c()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 23 then
			if at <= 1 then
				helper_650bfa16(2)
			end
			if at <= 2 then
				helper_ff0edc1d(20)
			end
			if at <= 3 then
				helper_ff0edc1d(30)
			end
			if at <= 4 then
				helper_ff0edc1d(10)
			end
			if at <= 5 then
				helper_ff0edc1d(20)
			end
			if at <= 6 then
				helper_ff0edc1d(10)
			end
			if at <= 7 then
				helper_ff0edc1d(20)
			end
			if at <= 8 then
				helper_1d96573f(4000010)
			end
			if at <= 9 then
				helper_650bfa16(1)
			end
			if at <= 10 then
				helper_1d96573f(4000020)
			end
			if at <= 11 then
				helper_650bfa16(0)
			end
			if at <= 12 then
				helper_1d96573f(4000030)
			end
			if at <= 13 then
				helper_1d96573f(4000040)
			end
			if at <= 14 then
				helper_1d96573f(4000050)
			end
			if at <= 15 then
				helper_1d96573f(4000060)
			end
			if at <= 16 then
				helper_1d96573f(4000070)
			end
			if at <= 17 then
				helper_1d96573f(4000080)
			end
			if at <= 18 then
				helper_650bfa16(1)
			end
			if at <= 19 then
				helper_1d96573f(4000085)
			end
			if at <= 20 then
				helper_ff0edc1d(6)
			end
			if at <= 21 then
				helper_650bfa16(0)
			end
			if at <= 22 then
				helper_ff0edc1d(30)
			end
			if vm.skip_end() then
				return skip(24)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SetMpcharaMotion("p01_train01", "kikan-m0", "停止")
		event.SndSeStop(var0, 4)
		event.SndSeStop(var0, 5)
		event.EohSetPos(2, -912.1, 0.0, 0.0)
		event.EohSetRot(2, 0.0, 1.57, 0.0)
		event.EohSetRot(3, 0.0, 0.0, 0.0)
		event.EohSetRot(4, 0.0, 0.0, 0.0)
		event.EohSetRot(5, 0.0, 0.0, 0.0)
		event.EohSetRot(6, 0.0, 0.0, 0.0)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.DelExtMotion(0)
		event.DeleteChara(32)
		event.DeleteChara(33)
		event.LoadMes(0, -1)
		event.CharaActive(8)
		event.SetCharaPos(8, -2030.0, 30.0, -100.0)
		event.SetCharaRot(8, 0.0, 3.14, 0.0)
		event.SetAi(1, 8)
		event.CharaActive(9)
		event.SetCharaPos(9, -1098.0, 29.2, -100.0)
		event.SetCharaRot(9, 0.0, -1.57, 0.0)
		event.SetAi(1, 9)
		event.CharaActive(10)
		event.SetCharaPos(10, -707.6, -10.0, -172.5)
		event.SetCharaRot(10, 0.0, 0.0, 0.0)
		event.SetAi(1, 10)
		event.CharaActive(0)
		event.SetCharaPos(0, -1880.1, 29.2, -299.0)
		event.SetCharaRot(0, 0.0, 3.14, 0.0)
		event.CharaNormalDrive(0)
		event.CharaResetDa(0)
		event.ResetCamera(1, 3.1415927, 10.0)
		event.SetFadeIn(30)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFlag(400, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	var0 = event.SndLoadSound(4200) or var0
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.ChangeDir("event/e400/e400/")
	event.LoadMes(0, 5, "e400.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e400_mints.gltf", "info", 0)
		event.CharaActive(0, 0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e400_monica.gltf", "info", 0)
		event.CharaActive(0, 0)
		event.EohSyncChara(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.ChangeDir("")
	if active_chr_no == 1 then
		event.LoadChara(5, "chara/c01_base.gltf", "info", 32)
		event.LoadEquip(5, 0, 4, "info", 32)
		event.LoadEquip(5, 0, 3, "info", 32)
		event.LoadEquip(5, 0, 2, "info", 32, 33)
		event.LoadMotion(5, "event/e400/e400/e400_mints.gltf", "info", 32)
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
		event.LoadMotion(5, "event/e400/e400/e400_monica.gltf", "info", 32)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 32)
		event.EohSyncChara(1, 32)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 0)
	end
	event.CharaActive(0, 32)
	event.CharaActive(0, 33)
	event.SetAi(0, 8)
	event.CharaActive(0, 8)
	event.EohSyncChara(7, 8)
	event.ObjsInit(7)
	event.ObjsSyncObj(7, 7)
	event.SetAi(0, 9)
	event.CharaActive(0, 9)
	event.EohSyncChara(8, 9)
	event.ObjsInit(8)
	event.ObjsSyncObj(8, 8)
	event.SetAi(0, 10)
	event.CharaActive(0, 10)
	event.EohSyncChara(9, 10)
	event.ObjsInit(9)
	event.ObjsSyncObj(9, 9)
	event.EohSyncObj(2, "p01_train01")
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.EohSyncObj(3, "p01_train01", "train08-m0")
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.EohSyncObj(4, "p01_train01", "train08-m1")
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.EohSyncObj(5, "p01_train01", "train10-m0")
	event.ObjsInit(5)
	event.ObjsSyncObj(5, 5)
	event.EohSyncObj(6, "p01_train01", "train10-m1")
	event.ObjsInit(6)
	event.ObjsSyncObj(6, 6)
	event.EsmInitialize(5)
	event.EsmLoadBase("列車煙")
	event.EsmInitFix(5)
	event.EsmCreate("列車煙")
	event.EsmSetValue(0, 2)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "デフォルト顔")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "デフォルト顔")
	event.EohSetTexAnim(1, 1, "通常目パチ")
	event.EohSetTexAnim(7, 0)
	event.EohSetTexAnim(7, 1, "デフォルト顔")
	event.EohSetTexAnim(7, 1, "通常目パチ")
	event.EohSetPos(0, -1494.0, 42.31, -35.0)
	event.EohSetRot(0, 0.0, 3.14, 0.0)
	event.EohSetMotion(0, "立ち", 4)
	event.EohSetFootSoundId(0, 6)
	event.EohSetPos(1, -1478.0, 42.31, -35.0)
	event.EohSetRot(1, 0.0, 3.14, 0.0)
	event.EohSetMotion(1, "立ち", 4)
	event.EohSetFootSoundId(1, 6)
	event.EohSetPos(7, -1485.0, 45.34, -9.42)
	event.EohSetRot(7, 0.0, 3.14, 0.0)
	event.EohSetMotion(7, "立ち", 4)
	event.EohSetPos(2, -2312.1, 0.0, 0.0)
	event.EohSetRot(2, 0.0, 1.57, 0.0)
	event.EohSetRot(3, 0.0, 0.0, 0.0)
	event.EohSetRot(4, 0.0, 0.0, 0.0)
	event.EohSetRot(5, 0.0, 0.0, 0.0)
	event.EohSetRot(6, 0.0, 0.0, 0.0)
	event.SetMpcharaMotion("p01_train01", "kikan-m0", "機関")
	event.InitDramaScene()
	event.CmrsInit()
	event.CmrsSetPos(-1481.05, 64.34, -282.56)
	event.CmrsSetRef(-1949.42, 59.22, -91.09)
	event.CmrsMove2(-1481.05, 64.34, -282.56, -1473.02, 59.22, -83.94, 80, 2, 1.0)
	event.ObjsMove2(2, -912.1, 0.0, 0.0, 80, 2, 1.0)
	event.SndSePlay(var0, 4)
	event.SndSePlay(var0, 5)
	event.SetFadeIn(30)
	helper_650bfa16(2)
	if vm.skipping() then
		return skip(2)
	end
	helper_ff0edc1d(20)
	if vm.skipping() then
		return skip(3)
	end
	event.SndSePlay(var0, 6)
	event.CharaActive(0)
	event.CharaActive(32)
	event.CharaActive(33)
	event.CharaActive(8)
	event.ObjsRotation(3, 0.0, 1.5, 0.0, 30)
	event.ObjsRotation(4, 0.0, -1.5, 0.0, 30)
	event.ObjsRotation(5, 0.0, 1.5, 0.0, 30)
	event.ObjsRotation(6, 0.0, -1.5, 0.0, 30)
	helper_ff0edc1d(30)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMpcharaMotion("p01_train01", "kikan-m0", "停止")
	event.ObjsSetMotion(0, "歩き")
	event.ObjsMotionDelay(0, 60)
	event.ObjsSetMotion(0, "立ち")
	event.ObjsMove(0, -1493.51, 29.22, -100.0, 60)
	helper_ff0edc1d(10)
	if vm.skipping() then
		return skip(5)
	end
	event.ObjsSetMotion(1, "歩き")
	event.ObjsMove(1, -1478.51, 29.22, -90.0, 50)
	helper_ff0edc1d(20)
	if vm.skipping() then
		return skip(6)
	end
	event.EohSetFootSoundId(0, 3)
	helper_ff0edc1d(10)
	if vm.skipping() then
		return skip(7)
	end
	event.EohSetFootSoundId(1, 3)
	helper_ff0edc1d(20)
	if vm.skipping() then
		return skip(8)
	end
	event.EsmClear()
	event.CmrsSetPos(-1510.53, 52.11, -162.67)
	event.CmrsSetRef(-1480.38, 51.06, -136.4)
	event.ObjsTexaDelay(1, 30)
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "デフォルト顔")
	event.ObjsTexAnime(1, 1, "目あき～目とじ")
	event.ObjsMove(1, -1478.51, 29.22, -145.0, 50)
	event.ObjsSetMotion(1, "潮歩き", 4)
	event.ObjsMotionDelay(1, 50)
	event.ObjsSetMotion(1, "潮立ち")
	event.SetPakuAnim(1, "わらい口パク")
	helper_1d96573f(4000010)
	if vm.skipping() then
		return skip(9)
	end
	helper_650bfa16(1)
	if vm.skipping() then
		return skip(10)
	end
	event.ObjsMove(0, -1493.51, 29.22, -135.0, 50)
	event.ObjsSetMotion(0, "歩き")
	event.ObjsMotionDelay(0, 50)
	event.ObjsSetMotion(0, "立ち")
	event.SetPakuAnim(0, "通常口パク")
	helper_1d96573f(4000020)
	if vm.skipping() then
		return skip(11)
	end
	helper_650bfa16(0)
	if vm.skipping() then
		return skip(12)
	end
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "目とじ～目あき")
	event.ObjsTexaDelay(1, 30)
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.ObjsSetMotion(1, "潮立ちから右", 6)
	event.ObjsNextMotion(1, "左向くL", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_1d96573f(4000030)
	if vm.skipping() then
		return skip(13)
	end
	event.SetPakuAnim(0, "通常口パク")
	helper_1d96573f(4000040)
	if vm.skipping() then
		return skip(14)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_1d96573f(4000050)
	if vm.skipping() then
		return skip(15)
	end
	event.CmrsSetPos(-1482.95, 61.09, -180.61)
	event.CmrsSetRef(-1483.79, 47.79, -128.26)
	event.ObjsSetPos(7, -1483.61, 29.22, -91.35)
	event.SndSePlay(var0, 7)
	event.ObjsSetMotion(1, "ふりかえり", 6)
	event.ObjsNextMotion(1, "ふりかえりＬ", 4)
	event.ObjsSetMotion(0, "振り返り", 6)
	event.ObjsNextMotion(0, "振り返りL", 4)
	event.SetPakuAnim(7, "口パク")
	helper_1d96573f(4000060)
	if vm.skipping() then
		return skip(16)
	end
	event.CmrsSetPos(-1563.93, 73.34, -118.52)
	event.CmrsSetRef(-1483.1, 54.11, -118.91)
	event.CharaActive(9)
	event.CharaActive(10)
	event.SetCharaPos(9, -625.34, 29.22, -99.11)
	event.SetCharaPos(10, -627.43, 29.22, -126.82)
	event.ObjsSetPos(7, -1489.0, 29.22, -98.62)
	event.ObjsSetRot(7, 0.0, 1.58, 0.0)
	event.ObjsSetPos(0, -1496.36, 29.22, -129.63)
	event.ObjsSetRot(0, 0.0, 1.46, 0.0)
	event.ObjsSetMotion(0, "立ち", 6, -1.0, 1)
	event.ObjsSetPos(1, -1478.51, 29.22, -145.0)
	event.ObjsSetRot(1, 0.0, 0.98, 0.0)
	event.ObjsSetMotion(1, "立ち", 6, -1.0, 1)
	helper_1d96573f(4000070)
	if vm.skipping() then
		return skip(17)
	end
	event.ObjsSetMotion(1, "手振り", 6)
	event.ObjsNextMotion(1, "手振りＬ", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_1d96573f(4000080)
	if vm.skipping() then
		return skip(18)
	end
	helper_650bfa16(1)
	if vm.skipping() then
		return skip(19)
	end
	event.CmrsSetPos(-1522.27, 54.57, -147.64)
	event.CmrsSetRef(-1483.82, 49.34, -134.4)
	event.CharaActive(0, 9)
	event.CharaActive(0, 10)
	event.CharaActive(0, 8)
	event.ObjsSetRot(0, 0.0, 1.82, 0.0)
	event.ObjsResetDaPosition(0)
	event.ObjsSetMotion(1, "手振りから左", 6)
	event.ObjsNextMotion(1, "右向くL", 4)
	event.SetPakuAnim(1, "わらい口パク")
	helper_1d96573f(4000085)
	if vm.skipping() then
		return skip(20)
	end
	event.ObjsSetMotion(0, "うなづく", 6)
	event.ObjsNextMotion(0, "立ち", 4)
	helper_ff0edc1d(6)
	if vm.skipping() then
		return skip(21)
	end
	event.SndSePlay(var0, 8)
	helper_650bfa16(0)
	if vm.skipping() then
		return skip(22)
	end
	event.SetFadeOut(30)
	helper_ff0edc1d(30)
	if vm.skipping() then
		return skip(23)
	end
	return part2()
end

--- Helper function.
local function helper_27d90()
	local flag: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 7 then
			if at <= 1 then
				helper_650bfa16(1)
			end
			if at <= 2 then
				helper_ff0edc1d(10)
			end
			if at <= 3 then
				helper_ff0edc1d(15)
			end
			if at <= 4 then
				helper_ff0edc1d(10)
			end
			if at <= 5 then
				helper_650bfa16(0)
			end
			if at <= 6 then
				helper_ff0edc1d(10)
			end
			if vm.skip_end() then
				return skip(8)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.EsmClear()
		event.SetFadeIn(1)
		event.SetMpcharaMotion("p01_train01", "kikan-m0", "停止")
		event.EohSetPos(1, -912.1, 0.0, 0.0)
		event.EohSetRot(2, 0.0, 0.0, 0.0)
		event.EohSetRot(3, 0.0, 0.0, 0.0)
		event.EohSetRot(4, 0.0, 0.0, 0.0)
		event.EohSetRot(5, 0.0, 0.0, 0.0)
		event.CmrsInit()
		event.EohSetShow(6, 1)
		event.CharaActive(0)
		event.SetCharaPos(0, -1460.3, 29.22, -123.59)
		event.SetCharaRot(0, 0.0, -1.57, 0.0)
		event.CharaNormalDrive(0)
		event.CharaResetDa(0)
		event.CharaActive(1, 8)
		if flag == 0 then
			event.CharaActive(1, 9)
			event.CharaActive(1, 10)
		end
		event.ResetCamera(1, 3.14, 10.0)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	flag = event.GetFlag(448) or flag
	event.CharaActive(0, 8)
	if flag == 0 then
		event.CharaActive(0, 9)
		event.CharaActive(0, 10)
	end
	var1 = event.SndLoadSound(8, "snd2/sp/sp_018.sound.json") or var1
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.CharaActive(0, 0)
	event.EohSyncObj(1, "p01_train01")
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.ObjsSetPos(1, -1512.1, 0.0, 0.0)
	event.ObjsSetRot(1, 0.0, 1.57, 0.0)
	event.SetMpcharaMotion("p01_train01", "kikan-m0", "機関")
	event.EohSyncObj(6, "p01_shadow")
	event.EohSetShow(6, 0)
	event.EohSyncObj(2, "p01_train01", "train08-m0")
	event.ObjsSyncObj(2, 2)
	event.ObjsSetRot(2, 0.0, 0.0, 0.0)
	event.EohSyncObj(3, "p01_train01", "train08-m1")
	event.ObjsSyncObj(3, 3)
	event.ObjsSetRot(3, 0.0, 0.0, 0.0)
	event.EohSyncObj(4, "p01_train01", "train10-m0")
	event.ObjsSyncObj(4, 4)
	event.ObjsSetRot(4, 0.0, 0.0, 0.0)
	event.EohSyncObj(5, "p01_train01", "train10-m1")
	event.ObjsSyncObj(5, 5)
	event.ObjsSetRot(5, 0.0, 0.0, 0.0)
	event.AssignStack(5)
	event.ClearStack(5)
	event.EsmInitialize(5)
	event.EsmLoadBase("列車煙")
	event.EsmInitFix(5)
	event.EohSyncObj(8, "p01_train01")
	event.EsmCreate("列車煙")
	event.EsmSetValue(0, 8)
	event.SndSePlay(var1, 0)
	event.EohSetFootSoundId(0, 6)
	event.CmrsInit()
	event.CmrsSetPos(-363.94, 121.88, -75.09)
	event.CmrsSetRef(-643.14, 118.87, -58.01)
	event.SetFadeIn(30)
	event.ObjsMove2(1, -912.1, 0.0, 0.0, 40, 2, 1.0)
	helper_650bfa16(1)
	if vm.skipping() then
		return skip(2)
	end
	helper_ff0edc1d(10)
	if vm.skipping() then
		return skip(3)
	end
	event.SetCrossfade(30)
	event.CmrsSetPos(-1664.28, 105.75, -222.05)
	event.CmrsSetRef(-1452.28, 75.37, -85.42)
	var2 = event.GetSndId(2) or var2
	event.SndSePlay(var2, 66)
	event.EohSetPos(1, -912.1, 0.0, 0.0)
	event.CharaActive(0)
	event.ObjsSetPos(0, -1460.3, 33.0, -45.39)
	event.ObjsSetRot(0, 0.0, 3.14, 0.0)
	event.ObjsRotation(2, 0.0, 1.5, 0.0, 30)
	event.ObjsRotation(3, 0.0, -1.5, 0.0, 30)
	event.ObjsRotation(4, 0.0, 1.5, 0.0, 30)
	event.ObjsRotation(5, 0.0, -1.5, 0.0, 30)
	helper_ff0edc1d(15)
	if vm.skipping() then
		return skip(4)
	end
	event.ObjsMove(0, -1460.3, 29.22, -123.59, 30)
	event.ObjsSetMotion(0, "走り", 4)
	helper_ff0edc1d(10)
	if vm.skipping() then
		return skip(5)
	end
	event.EohSetFootSoundId(0, 3)
	helper_650bfa16(0)
	if vm.skipping() then
		return skip(6)
	end
	event.ObjsSetMotion(0, "立ち")
	helper_ff0edc1d(10)
	if vm.skipping() then
		return skip(7)
	end
	return part2()
end

--- Helper function.
local function helper_26da0()
	local var0: s32 = 0
	local flag: s32 = 0
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_650bfa16(1)
		end
		if at <= 2 then
			helper_ff0edc1d(10)
		end
		if at <= 3 then
			helper_ff0edc1d(15)
		end
		if at <= 4 then
			helper_650bfa16(0)
		end
		if at <= 5 then
			helper_ff0edc1d(10)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	var0 = event.SndLoadSound(8, "snd2/sp/sp_019.sound.json") or var0
	flag = event.GetFlag(448) or flag
	event.CharaActive(0, 8)
	if flag == 0 then
		event.CharaActive(0, 9)
		event.CharaActive(0, 10)
	end
	event.CharaActive(0, 0)
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.EohSyncObj(1, "p01_train01")
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.EohSyncObj(4, "p01_shadow")
	event.EohSetShow(4, 0)
	event.EohSyncObj(2, "p01_train01", "s3601_12-m1")
	event.ObjsSyncObj(2, 2)
	event.ObjsSetRot(2, 0.0, 0.0, 0.0)
	event.EohSyncObj(3, "p01_train01", "s3601_14-m1")
	event.ObjsSyncObj(3, 3)
	event.ObjsSetRot(3, 0.0, 0.0, 0.0)
	event.ObjsSetPos(1, -1512.1, 0.0, 0.0)
	event.ObjsSetRot(1, 0.0, 1.57, 0.0)
	event.ObjsMove2(1, -912.1, 0.0, 0.0, 40, 2, 1.0)
	event.CmrsInit()
	event.CmrsSetPos(-363.94, 121.88, -75.09)
	event.CmrsSetRef(-643.14, 118.87, -58.01)
	event.SetFadeIn(30)
	event.SndSePlay(var0, 0)
	helper_650bfa16(1)
	if vm.skipping() then
		return skip(2)
	end
	helper_ff0edc1d(10)
	if vm.skipping() then
		return skip(3)
	end
	event.SetCrossfade(30)
	event.CmrsSetPos(-1664.28, 105.75, -222.05)
	event.CmrsSetRef(-1452.28, 75.37, -85.42)
	event.EohSetPos(1, -912.1, 0.0, 0.0)
	event.CharaActive(0)
	event.ObjsSetPos(0, -1460.3, 33.0, -45.39)
	event.ObjsSetRot(0, 0.0, 3.14, 0.0)
	event.ObjsRotation(2, 0.0, 0.0, 1.5707964, 30)
	event.ObjsRotation(3, 0.0, 0.0, 1.5707964, 30)
	var2 = event.GetSndId(2) or var2
	event.SndSePlay(var2, 92)
	helper_ff0edc1d(15)
	if vm.skipping() then
		return skip(4)
	end
	event.ObjsMove(0, -1460.3, 29.22, -123.59, 30)
	event.ObjsSetMotion(0, "走り", 4)
	event.EohSetFootSoundId(0, 3)
	helper_650bfa16(0)
	if vm.skipping() then
		return skip(5)
	end
	event.EohSetFootSoundId(0, 0)
	event.ObjsSetMotion(0, "立ち")
	helper_ff0edc1d(10)
	if vm.skipping() then
		return skip(6)
	end
	event.SetFadeIn(1)
	event.EohSetPos(1, -912.1, 0.0, 0.0)
	event.EohSetRot(2, 0.0, 0.0, 0.0)
	event.EohSetRot(3, 0.0, 0.0, 0.0)
	event.EohSetShow(4, 1)
	event.CharaActive(1, 8)
	if flag == 0 then
		event.CharaActive(1, 9)
		event.CharaActive(1, 10)
	end
	event.CharaActive(0)
	event.SetCharaPos(0, -1460.3, 29.22, -123.59)
	event.SetCharaRot(0, 0.0, -1.57, 0.0)
	event.CharaNormalDrive(0)
	event.CharaResetDa(0)
	event.ResetCamera(1, 3.1415927, 10.0)
	event.SetFadeIn(15)
end

--- Helper function.
local function helper_260d8()
	local var0: any = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_ff0edc1d(30)
			end
			if at <= 2 then
				helper_ff0edc1d(30)
			end
			return 1
		end
		return 0
	end
	event.Initialize()
	event.SetMotion(0, "立ち")
	event.SetMesQuestionGyou(0, 0)
	event.SetMesWindowMode(0, 5)
	event.SetMesDrawspeed(0, 1)
	event.MesMake_2(0, "『ベニーティオ』に移動しますか？")
	var0 = helper_8d58a537(0, -1, 8, 256, 208, 2, 1)
	if vm.skipping() then
		return skip(1)
	end
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	if var0 == 0 then
		event.CmrsSetPos(-1925.42, 97.53, -285.93)
		event.CmrsSetRef(-1921.75, 57.81, -472.01)
		event.ObjsSetPos(0, -1910.95, 21.58, -466.12)
		event.ObjsSetMotion(0, "走り", 4, -1.0, 1)
		event.ObjsInitPas(0)
		event.ObjsSetPasFrm(0, 60)
		event.ObjsAddPas(0, -1910.95, 21.58, -466.12)
		event.ObjsAddPas(0, -1907.45, 17.42, -496.67)
		event.ObjsAddPas(0, -1898.74, 13.2, -528.24)
		event.ObjsAddPas(0, -1878.93, 9.61, -555.9)
		event.ObjsAddPas(0, -1854.68, 5.12, -580.59)
		event.ObjsAddPas(0, -1828.07, 1.46, -591.28)
		event.ObjsStartPas(0)
		helper_ff0edc1d(30)
		if vm.skipping() then
			return skip(2)
		end
		event.SetFadeOut(30)
		helper_ff0edc1d(30)
		if vm.skipping() then
			return skip(3)
		end
		return 1
	else
		do
			local out1, out2, out3 = event.GetCharaPos(0)
			var1 = out1 or var1
			var2 = out2 or var2
			var3 = out3 or var3
		end
		var4 = vm.f32(vm.f32(vm.sin(0.0) * 30.0) + var1)
		var5 = 0.0
		var6 = vm.f32(vm.f32(vm.cos(0.0) * 30.0) + var3)
		event.ObjsMove(0, var4, var5, var6, 30, 1)
		event.ObjsReference(0, var4, var5, var6, 10)
		event.ObjsSetMotion(0, "歩き")
		var7 = 0
		while var7 < 30 do
			do
				local out1, out2, out3 = event.GetCharaPos(0)
				var1 = out1 or var1
				var2 = out2 or var2
				var3 = out3 or var3
			end
			var2 = vm.f32(var2 + 30.0)
			event.SetCameraRef(var1, var2, var3)
			var7 = var7 + 1
			if vm.wait() then
				return skip(4)
			end
		end
	end
	return 0
end

--- Helper function.
local function helper_1c964()
	local var0: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_b7c85616(0, 1)
			return 0
		end
		if at <= 3 then
			helper_ff0edc1d(15)
		end
		return 0
	end
	event.SetMotion(0, "立ち")
	event.Initialize()
	helper_b7c85616(0, 4)
	event.MesMake_2(0, "中に入る\n出発する")
	var0 = helper_8d58a537(0, -1, 5, 256, 208, 2, 0)
	if vm.skipping() then
		return skip(1)
	end
	if var0 == -1 then
		helper_b7c85616(0, 1)
		return 0
	end
	if var0 == 1 then
		event.SetFadeOut(15)
		helper_ff0edc1d(15)
		if vm.skipping() then
			return skip(2)
		end
		event.GotoMenu(19, 0)
		if vm.wait() then
			return skip(3)
		end
		event.SetFadeIn(15)
		helper_ff0edc1d(15)
		if vm.skipping() then
			return skip(4)
		end
		return 0
	end
	return 1
end

--- Helper function.
local function helper_127a4()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var6: f32 = 0
	local var7: s32 = 0
	local var8: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var6 = vm.f32(-3.1415927)
			helper_ff0edc1d(10)
		end
		if at <= 2 then
			helper_ff0edc1d(20)
		end
		if at <= 3 then
			helper_ff0edc1d(18)
		end
		if at <= 4 then
			helper_ff0edc1d(12)
		end
		if at <= 5 then
			helper_ff0edc1d(30)
		end
		if at <= 6 then
			helper_ff0edc1d(10)
		end
		if at <= 7 then
			helper_ff0edc1d(20)
		end
		if at <= 8 then
			helper_ff0edc1d(18)
		end
		if at <= 9 then
			helper_ff0edc1d(12)
		end
		if at <= 10 then
			helper_ff0edc1d(30)
		end
	end
	if vm.skipping() then
		return skip(1)
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
		helper_ff0edc1d(10)
		if vm.skipping() then
			return skip(2)
		end
		event.ObjsRotation(1, 0.0, -4.9415927, 0.0, 30)
		event.ObjsRotation(2, 0.0, -4.9415927, 0.0, 30)
		event.ObjsRotation(3, 0.0, -4.9415927, 0.0, 30)
		helper_ff0edc1d(20)
		if vm.skipping() then
			return skip(3)
		end
		event.ObjsSetMotion(0, "歩き")
		event.ObjsMove(0, -29.1, 1.38, -0.82, 30)
		event.ObjsMove(0, -50.41, 1.38, 0.05, 30)
		event.EohSetFootSoundId(0, 6)
		helper_ff0edc1d(18)
		if vm.skipping() then
			return skip(4)
		end
		event.EohSetFootSoundId(0, 3)
		helper_ff0edc1d(12)
		if vm.skipping() then
			return skip(5)
		end
		event.SetFadeOut(30)
		helper_ff0edc1d(30)
		if vm.skipping() then
			return skip(6)
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
		helper_ff0edc1d(10)
		if vm.skipping() then
			return skip(7)
		end
		event.ObjsRotation(1, 0.0, -1.8, 0.0, 30)
		event.ObjsRotation(2, 0.0, -1.8, 0.0, 30)
		event.ObjsRotation(3, 0.0, -1.8, 0.0, 30)
		helper_ff0edc1d(20)
		if vm.skipping() then
			return skip(8)
		end
		event.ObjsSetMotion(0, "歩き")
		event.ObjsMove(0, 29.1, 1.38, 0.82, 30)
		event.ObjsMove(0, 50.41, 1.38, -0.05, 30)
		event.EohSetFootSoundId(0, 6)
		helper_ff0edc1d(18)
		if vm.skipping() then
			return skip(9)
		end
		event.EohSetFootSoundId(0, 3)
		helper_ff0edc1d(12)
		if vm.skipping() then
			return skip(10)
		end
		event.SetFadeOut(30)
		helper_ff0edc1d(30)
		if vm.skipping() then
			return skip(11)
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
local function helper_13ef4(arg0: s32)
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var11: s32 = 0
	local var14: s32 = 0
	local now_map_no: s32 = 0
	local var16: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			print("train_id=", var11, "----------------\n")
			print("fpos[0]=", string.format("%f", var1), "---------------\n")
			print("fpos[1]=", string.format("%f", var2), "---------------\n")
			print("fpos[2]=", string.format("%f", var3), "---------------\n")
			print("train_id=", var11, "---------------\n")
			var4 = vm.f32(5.51)
			var5 = vm.f32(19.05)
			var6 = vm.f32(19.05)
			var14 = 6
			var4 = 19.75
			var5 = 19.75
			var6 = 19.75
			var14 = 2
			var4 = vm.f32(14.049999)
			var5 = vm.f32(17.05)
			var6 = vm.f32(22.05)
			var14 = 3
			var4 = vm.f32(20.55)
			var5 = vm.f32(20.55)
			var6 = vm.f32(22.05)
			var14 = 2
			var7 = vm.f32(-3.1415927)
			helper_ff0edc1d(10)
		end
		if at <= 2 then
			helper_ff0edc1d(20)
		end
		if at <= 3 then
			helper_ff0edc1d(18)
		end
		if at <= 4 then
			helper_ff0edc1d(12)
		end
		if at <= 5 then
			helper_ff0edc1d(30)
		end
		if at <= 6 then
			helper_ff0edc1d(10)
		end
		if at <= 7 then
			helper_ff0edc1d(20)
		end
		if at <= 8 then
			helper_ff0edc1d(18)
		end
		if at <= 9 then
			helper_ff0edc1d(12)
		end
		if at <= 10 then
			helper_ff0edc1d(30)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	event.GetSndId(1)
	var11 = event.GetEventData_2(3) or var11
	event.GetEventData_2(4)
	event.Ext(1035, 8, var1, var2, var3, var7) -- retail: the handler rejects 5 arguments
	print("train_id=", var11, "----------------\n")
	print("fpos[0]=", string.format("%f", var1), "---------------\n")
	print("fpos[1]=", string.format("%f", var2), "---------------\n")
	print("fpos[2]=", string.format("%f", var3), "---------------\n")
	print("train_id=", var11, "---------------\n")
	event.SetWorldCoord(var1, var2, var3, var7)
	event.EohSyncObj(0, "p01_train01")
	do
		local out1, out2, out3 = event.EohGetPos(0)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	if arg0 ~= 0 then
		var4 = vm.f32(5.51)
		var5 = vm.f32(19.05)
		var6 = vm.f32(19.05)
		var14 = 6
	else
		var4 = 19.75
		var5 = 19.75
		var6 = 19.75
		var14 = 2
		now_map_no = event.GetNowMapNo() or now_map_no
		if now_map_no == 83 then
			var4 = vm.f32(14.049999)
			var5 = vm.f32(17.05)
			var6 = vm.f32(22.05)
			event.EohSetPos(0, pos_x, pos_y - 2.0, pos_z)
			var14 = 3
		end
		if now_map_no == 54 then
			var4 = vm.f32(20.55)
			var5 = vm.f32(20.55)
			var6 = vm.f32(22.05)
			var14 = 2
		end
	end
	if vm.imod(var11, 2) ~= 1 then
		var7 = vm.f32(-3.1415927)
	end
	if var11 == 2 then
		event.EohSyncObj(1, "p01_train01", "train08-m0")
		event.EohSyncObj(2, "p01_train01", "train08-m1")
		event.EohSyncObj(3, "p01_train01", "train10-m0")
		event.EohSyncObj(4, "p01_train01", "train10-m1")
		event.EohSyncObj(5, "p01_train01", "train10-m12")
		event.EohSyncObj(6, "p01_train01", "train10-m13")
		event.SetCnt(0, 1)
	end
	if var11 == 3 then
		event.EohSyncObj(1, "p01_train01", "train08-m2")
		event.EohSyncObj(2, "p01_train01", "train08-m3")
		event.EohSyncObj(3, "p01_train01", "train10-m3")
		event.EohSyncObj(4, "p01_train01", "train10-m2")
		event.EohSyncObj(5, "p01_train01", "train10-m15")
		event.EohSyncObj(6, "p01_train01", "train10-m14")
		event.SetCnt(0, 1)
	end
	if var11 == 4 then
		event.EohSyncObj(1, "p01_train01", "train08-m4")
		event.EohSyncObj(2, "p01_train01", "train08-m5")
		event.EohSyncObj(3, "p01_train01", "train10-m4")
		event.EohSyncObj(4, "p01_train01", "train10-m5")
		event.EohSyncObj(5, "p01_train01", "train10-m16")
		event.EohSyncObj(6, "p01_train01", "train10-m17")
		event.SetCnt(0, 2)
	end
	if var11 == 5 then
		event.EohSyncObj(1, "p01_train01", "train08-m6")
		event.EohSyncObj(2, "p01_train01", "train08-m7")
		event.EohSyncObj(3, "p01_train01", "train10-m6")
		event.EohSyncObj(4, "p01_train01", "train10-m7")
		event.EohSyncObj(5, "p01_train01", "train10-m18")
		event.EohSyncObj(6, "p01_train01", "train10-m19")
		event.SetCnt(0, 2)
	end
	if var11 == 6 then
		event.EohSyncObj(1, "p01_train01", "train08-m8")
		event.EohSyncObj(2, "p01_train01", "train08-m9")
		event.EohSyncObj(3, "p01_train01", "train10-m8")
		event.EohSyncObj(4, "p01_train01", "train10-m9")
		event.EohSyncObj(5, "p01_train01", "train10-m20")
		event.EohSyncObj(6, "p01_train01", "train10-m21")
		event.SetCnt(0, 3)
	end
	if var11 == 7 then
		event.EohSyncObj(1, "p01_train01", "train08-m10")
		event.EohSyncObj(2, "p01_train01", "train08-m11")
		event.EohSyncObj(3, "p01_train01", "train10-m10")
		event.EohSyncObj(4, "p01_train01", "train10-m11")
		event.EohSyncObj(5, "p01_train01", "train10-m22")
		event.EohSyncObj(6, "p01_train01", "train10-m23")
		event.SetCnt(0, 3)
	end
	var16 = event.GetSndId(2) or var16
	event.SndSePlay(var16, 66)
	if vm.imod(var11, 2) ~= 1 then
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.ObjsSetPos(0, 12.08, var4, 0.42)
		event.ObjsSetRot(0, 0.0, -1.5015928, 0.0)
		event.ObjsSetMotion(0, "立ち", 4)
		event.ObjsResetDaPosition(0)
		event.ObjsSyncObj(1, 1)
		event.ObjsSetRot(1, 0.0, 0.0, 0.0)
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
		event.CmrsInit()
		event.CmrsSetPos(124.87, 46.06, -74.18)
		event.CmrsSetRef(-3.0, 50.74, 0.18)
		helper_ff0edc1d(10)
		if vm.skipping() then
			return skip(2)
		end
		event.ObjsRotation(1, 0.0, 1.5, 0.0, 30)
		event.ObjsRotation(2, 0.0, -1.5, 0.0, 30)
		event.ObjsRotation(3, 0.0, 1.5, 0.0, 30)
		event.ObjsRotation(4, 0.0, -1.5, 0.0, 30)
		event.ObjsRotation(5, 0.0, 1.5, 0.0, 30)
		event.ObjsRotation(6, 0.0, -1.5, 0.0, 30)
		helper_ff0edc1d(20)
		if vm.skipping() then
			return skip(3)
		end
		event.ObjsSetMotion(0, "歩き")
		event.ObjsMove(0, -5.04, var5, 0.84, 30)
		event.ObjsMove(0, -33.49, var6, -0.56, 30)
		event.EohSetFootSoundId(0, var14)
		helper_ff0edc1d(18)
		if vm.skipping() then
			return skip(4)
		end
		event.EohSetFootSoundId(0, 4)
		helper_ff0edc1d(12)
		if vm.skipping() then
			return skip(5)
		end
		event.SetFadeOut(30)
		helper_ff0edc1d(30)
		if vm.skipping() then
			return skip(6)
		end
		event.EohSetMotion(0, "立ち", 4)
	else
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.ObjsSetPos(0, -12.08, var4, -0.42)
		event.ObjsSetRot(0, 0.0, 1.64, 0.0)
		event.ObjsSetMotion(0, "立ち", 4)
		event.ObjsResetDaPosition(0)
		event.ObjsSyncObj(1, 1)
		event.ObjsSetRot(1, 0.0, 0.0, 0.0)
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
		event.CmrsInit()
		event.CmrsSetPos(-124.87, 46.06, 74.18)
		event.CmrsSetRef(3.0, 50.74, -0.18)
		helper_ff0edc1d(10)
		if vm.skipping() then
			return skip(7)
		end
		event.ObjsRotation(1, 0.0, -1.5, 0.0, 30)
		event.ObjsRotation(2, 0.0, 1.5, 0.0, 30)
		event.ObjsRotation(3, 0.0, -1.5, 0.0, 30)
		event.ObjsRotation(4, 0.0, 1.5, 0.0, 30)
		event.ObjsRotation(5, 0.0, -1.5, 0.0, 30)
		event.ObjsRotation(6, 0.0, 1.5, 0.0, 30)
		helper_ff0edc1d(20)
		if vm.skipping() then
			return skip(8)
		end
		event.ObjsSetMotion(0, "歩き")
		event.ObjsMove(0, 5.04, var5, -0.84, 30)
		event.ObjsMove(0, 33.49, var6, 0.56, 30)
		event.EohSetFootSoundId(0, var14)
		helper_ff0edc1d(18)
		if vm.skipping() then
			return skip(9)
		end
		event.EohSetFootSoundId(0, 4)
		helper_ff0edc1d(12)
		if vm.skipping() then
			return skip(10)
		end
		event.SetFadeOut(30)
		helper_ff0edc1d(30)
		if vm.skipping() then
			return skip(11)
		end
		event.EohSetMotion(0, "立ち", 4)
	end
	if vm.imod(var11, 2) ~= 1 then
		event.SetCharaPos(0, 65.0, 36.0, 0.0)
		event.SetCharaRot(0, 0.0, -1.57, 0.0)
	else
		event.SetCharaPos(0, -65.0, 36.0, 0.0)
		event.SetCharaRot(0, 0.0, 1.57, 0.0)
	end
	event.EohSetFootSoundId(0, 0)
	event.EohSyncObj(0, "p01_train01")
	event.EohSetPos(0, pos_x, pos_y, pos_z)
end

--- Helper function.
local function helper_16ea4()
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
			helper_ff0edc1d(10)
		end
		if at <= 2 then
			helper_ff0edc1d(20)
		end
		if at <= 3 then
			helper_ff0edc1d(30)
		end
		if at <= 4 then
			helper_ff0edc1d(20)
		end
		if at <= 5 then
			helper_ff0edc1d(10)
		end
		if at <= 6 then
			helper_ff0edc1d(20)
		end
		if at <= 7 then
			helper_ff0edc1d(30)
		end
		if at <= 8 then
			helper_ff0edc1d(20)
		end
		if at <= 9 then
			helper_ff0edc1d(10)
		end
		if at <= 10 then
			var16 = 0
			print("てつのあしおと\n")
			var16 = 6
			print("いしのあしおと\n")
			var16 = 2
			helper_ff0edc1d(30)
		end
		if at <= 11 then
			helper_ff0edc1d(30)
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
	helper_ff0edc1d(10)
	if vm.skipping() then
		return skip(2)
	end
	if vm.imod(var5, 2) ~= 1 then
		event.ObjsRotation(2, 0.0, 0.0, 1.5707964, 30)
		event.ObjsRotation(3, 0.0, 0.0, 1.5707964, 30)
		if now_map_no == 83 or now_map_no == 54 or now_map_no == 34 then
			helper_ff0edc1d(20)
			if vm.skipping() then
				return skip(3)
			end
		else
			event.ObjsRotation(4, 0.0, 0.0, -0.3926991, 30)
			event.ObjsRotation(5, 0.0, 0.0, -0.3926991, 30)
			helper_ff0edc1d(30)
			if vm.skipping() then
				return skip(4)
			end
			if now_map_no == 103 then
				event.ObjsMove(5, pos_x + 45.0, pos_y - 19.0, pos_z, 30)
				helper_ff0edc1d(20)
				if vm.skipping() then
					return skip(5)
				end
			else
				event.ObjsMove(5, pos_x + 20.0, pos_y - 8.0, pos_z, 20)
				helper_ff0edc1d(10)
				if vm.skipping() then
					return skip(6)
				end
			end
		end
	else
		event.ObjsRotation(2, 0.0, 0.0, -1.5707964, 30)
		event.ObjsRotation(3, 0.0, 0.0, -1.5707964, 30)
		if now_map_no == 83 or now_map_no == 54 or now_map_no == 34 then
			helper_ff0edc1d(20)
			if vm.skipping() then
				return skip(7)
			end
		else
			event.ObjsRotation(4, 0.0, 0.0, 0.3926991, 30)
			event.ObjsRotation(5, 0.0, 0.0, 0.3926991, 30)
			helper_ff0edc1d(30)
			if vm.skipping() then
				return skip(8)
			end
			if now_map_no == 103 then
				event.ObjsMove(5, pos_x - 45.0, pos_y - 19.0, pos_z, 30)
				helper_ff0edc1d(20)
				if vm.skipping() then
					return skip(9)
				end
			else
				event.ObjsMove(5, pos_x - 20.0, pos_y - 8.0, pos_z, 20)
				helper_ff0edc1d(10)
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
	helper_ff0edc1d(30)
	if vm.skipping() then
		return skip(11)
	end
	event.SetFadeOut(30)
	helper_ff0edc1d(30)
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
local function helper_32130()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			helper_ff0edc1d(10)
		end
	end
	event.Initialize()
	event.SetMotion(0, "立ち")
	event.SetFadeOut(10)
	helper_ff0edc1d(10)
	if vm.skipping() then
		return skip(1)
	end
	event.GotoMenu(7)
	if vm.wait() then
		return skip(2)
	end
	event.SetFadeIn(10)
	helper_ff0edc1d(10)
	if vm.skipping() then
		return skip(3)
	end
end

--- Helper function.
local function helper_2e3d4()
	local active_chr_no: s32 = 0
	event.SetMesWindowMode(0, 7)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		global0 = 0
		global1 = 32
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.LoadMotion(5, "event/e400/e448/e448_mints.gltf", "info", global0)
		event.EohSyncChara(0, global0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global0)
		event.LoadChara(5, "chara/c02_base.gltf", "info", global1)
		event.LoadEquip(5, 1, 4, "info", global1)
		event.LoadEquip(5, 1, 3, "info", global1)
		event.LoadEquip(5, 1, 2, "info", global1, 37)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.LoadMotion(5, "event/e400/e448/e448_monica.gltf", "info", global1)
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
		event.LoadMotion(5, "event/e400/e448/e448_mints.gltf", "info", global0)
		event.EohSyncChara(0, global0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global0)
		event.CharaActive(1, 37)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.LoadMotion(5, "event/e400/e448/e448_monica.gltf", "info", global1)
		event.EohSyncChara(1, global1)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global1)
	end
	event.LoadChara(5, "chara/p01_03a.gltf", "info", 38)
	event.CharaActive(0, 38)
	event.EohSyncChara(2, 38)
	event.ObjsInit(2, 38)
	event.ObjsSyncObj(2, 2)
	event.LoadChara(5, "chara/p01_06a.gltf", "info", 39)
	event.CharaActive(0, 39)
	event.EohSyncChara(3, 39)
	event.ObjsInit(3, 39)
	event.ObjsSyncObj(3, 3)
	event.EohSyncObj(4, "p01_train01")
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.LoadMes(0, 5, "event/e400/e448/e448.txt")
end

--- Helper function.
local function helper_2e00c()
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
	event.SetCharaPos(0, -1952.44, 29.22, -304.96)
	event.SetCharaRot(0, 0.0, 1.62, 0.0)
end

--- Helper function.
local function helper_2f304()
	local var6: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 11 then
			if at <= 1 then
				helper_650bfa16(1)
			end
			if at <= 2 then
				helper_650bfa16(0)
			end
			if at <= 3 then
				helper_650bfa16(1)
			end
			if at <= 4 then
				helper_1d96573f(4481130)
			end
			if at <= 5 then
				helper_1d96573f(4481140)
			end
			if at <= 6 then
				helper_1d96573f(4481150)
			end
			if at <= 7 then
				helper_ff0edc1d(30)
			end
			if at <= 8 then
				helper_1d96573f(4481160)
			end
			if at <= 9 then
				helper_1d96573f(4481170)
			end
			if at <= 10 then
				helper_ff0edc1d(30)
			end
			if vm.skip_end() then
				return skip(12)
			end
			return part2()
		end
		if at <= 12 then
			helper_ff0edc1d(35)
		end
		helper_2e00c()
	end
	function part2()
		event.CancelDramaScene()
		event.SetFadeOut(30)
		helper_ff0edc1d(35)
		if vm.skipping() then
			return skip(13)
		end
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		helper_2e00c()
		event.ResetCamera(0)
		event.SetFadeIn(30)
	end
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.LoadSound(4220)
	var6 = event.SndLoadSound(4220) or var6
	helper_2e3d4()
	event.EohSetFootSoundId(0, 2)
	event.EohSetFootSoundId(1, 2)
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
	event.CmrsSetPos(-1979.65, 91.43, -121.02)
	event.CmrsSetRef(-1941.55, 74.53, -339.62)
	event.ObjsSetMotion(0, "走り", 4, -1.0, 1)
	event.ObjsSetMotion(1, "走り", 4, -1.0, 1)
	event.ObjsSetPos(1, -1838.01, 8.0, -560.01)
	event.ObjsSetRot(1, 0.0, -0.64, 0.0)
	event.ObjsSetPos(0, -1904.92, 17.42, -503.6)
	event.ObjsSetRot(0, 0.0, -0.64, 0.0)
	event.ObjsSetPos(2, -2186.89, 29.22, -198.9)
	event.ObjsSetRot(2, 0.0, 3.13, 0.0)
	event.ObjsSetPos(3, -2223.98, 29.22, -196.3)
	event.ObjsSetRot(3, 0.0, 3.13, 0.0)
	event.ObjsSetPos(4, -912.1, 0.0, 0.0)
	event.ObjsSetRot(4, 0.0, 1.57, 0.0)
	event.SetFadeIn(30)
	event.ObjsInitPas(0)
	event.ObjsSetPasFrm(0, 60)
	event.ObjsAddPas(0, -1904.92, 17.42, -503.6)
	event.ObjsAddPas(0, -1985.4, 29.22, -393.12)
	event.ObjsStartPas(0, 1)
	event.ObjsInitPas(1)
	event.ObjsSetPasFrm(1, 60)
	event.ObjsAddPas(1, -1838.01, 8.0, -560.01)
	event.ObjsAddPas(1, -1922.88, 29.4, -436.71)
	event.ObjsStartPas(1, 1)
	helper_650bfa16(0)
	if vm.skipping() then
		return skip(1)
	end
	helper_650bfa16(1)
	if vm.skipping() then
		return skip(2)
	end
	event.InitDramaScene()
	event.ObjsSetMotion(0, "歩き", 4, -1.0, 1)
	event.ObjsSetMotion(1, "歩き", 4, -1.0, 1)
	event.CmrsSetPos(-2052.02, 160.14, -365.82)
	event.CmrsSetRef(-2179.63, 74.53, -268.32)
	event.ObjsInitPas(1)
	event.ObjsSetPasFrm(1, 120)
	event.ObjsAddPas(1, -2199.24, 29.22, -360.0)
	event.ObjsAddPas(1, -2199.24, 29.22, -253.55)
	event.ObjsStartPas(1)
	event.ObjsInitPas(0)
	event.ObjsSetPasFrm(0, 120)
	event.ObjsAddPas(0, -2216.55, 29.22, -360.0)
	event.ObjsAddPas(0, -2216.55, 29.22, -253.55)
	event.ObjsStartPas(0)
	helper_650bfa16(0)
	if vm.skipping() then
		return skip(3)
	end
	helper_650bfa16(1)
	if vm.skipping() then
		return skip(4)
	end
	event.ObjsSetMotion(0, "立ち")
	event.ObjsSetMotion(1, "立ち")
	event.ObjsSetMotion(2, "会話", 2)
	event.ObjsNextMotion(2, "立ち", 4)
	helper_1d96573f(4481130)
	if vm.skipping() then
		return skip(5)
	end
	event.ObjsSetMotion(2, "立ち")
	event.ObjsSetMotion(0, "会話", 6)
	event.ObjsNextMotion(0, "立ち", 4)
	helper_1d96573f(4481140)
	if vm.skipping() then
		return skip(6)
	end
	event.ObjsSetMotion(3, "会話", 2)
	event.ObjsNextMotion(3, "立ち", 4)
	helper_1d96573f(4481150)
	if vm.skipping() then
		return skip(7)
	end
	event.ObjsSetMotion(3, "立ち")
	helper_ff0edc1d(30)
	if vm.skipping() then
		return skip(8)
	end
	event.ObjsSetPos(1, -1935.53, 29.22, -301.43)
	event.ObjsSetRot(1, 0.0, 0.0, 0.0)
	event.ObjsSetPos(0, -1952.44, 29.22, -304.96)
	event.ObjsSetRot(0, 0.0, 1.08, 0.0)
	event.CmrsSetPos(-1949.04, 34.26, -256.22)
	event.CmrsSetRef(-1934.01, 87.78, -397.48)
	event.ObjsSetMotion(1, "右向く会話", 6)
	event.ObjsNextMotion(1, "右向くL", 4)
	event.SetPakuAnim(1, "わらい口パク")
	helper_1d96573f(4481160)
	if vm.skipping() then
		return skip(9)
	end
	event.ResetPakuAnim()
	event.SndSePlay(var6, 25)
	event.ObjsSetMotion(0, "うなづく", 6)
	event.ObjsNextMotion(0, "立ち", 4)
	event.SetPakuAnim(0, "わらい口パク")
	helper_1d96573f(4481170)
	if vm.skipping() then
		return skip(10)
	end
	event.ResetPakuAnim()
	helper_ff0edc1d(30)
	if vm.skipping() then
		return skip(11)
	end
	return part2()
end

--- Helper function.
local function helper_1cd10(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	if arg1 == 1 then
		event.MesMake_2(
			arg0,
			"バース鉄道が大陸全土に\n行き渡ることは、わしとニードの\n夢なのじゃ。協力頼むぞ。"
		)
	end
	if arg1 == 2 then
		event.MesMake_2(
			arg0,
			"ゼルマイトが発見されたら\nオレも忙しくなるな。そうなったら、\n掘って掘って堀りまくるぜい！！"
		)
	end
	if arg1 == 3 then
		event.MesMake_2(
			arg0,
			"世界にはアッシの知らない\n植物が、まだまだたくさん\nあるんですかねぇ。"
		)
	end
	if arg1 == 4 then
		event.MesMake_2(
			arg0,
			"おう。ゼルマイト探しは進んでるか？\nなんか手伝うことがあったら\n遠慮なく言ってくれ。"
		)
	end
	if arg1 == 5 then
		event.MesMake_2(arg0, "絵の世界は本当に奥が深い。\n未だ極めることができない・・・")
	end
	if arg1 == 6 then
		event.MesMake_2(
			arg0,
			"ゼルマイト探しもいいが\nはりきりすぎて\n体を壊さんようにな。"
		)
	end
	if arg1 == 7 then
		event.MesMake_2(
			arg0,
			"料理の勉強をして世界一のコックを\nめざします。そしたら、坊ちゃんに\n一番にごちそうしますね。"
		)
	end
	if arg1 == 8 then
		event.MesMake_2(arg0, "いよいよ、バース鉄道が\n世界中に広がるのね。楽しみだわ。")
	end
	if arg1 == 9 then
		event.MesMake_2(arg0, "よっ！元気か。オレも元気だぜ。")
	end
	if arg1 == 10 then
		event.MesMake_2(
			arg0,
			"ゼルマイト鉱山は怖いところ\nです。くれぐれも気をつけて\nくださいませ。"
		)
	end
	if arg1 == 11 then
		event.MesMake_2(arg0, "ご無事をお祈りします・・・")
	end
	if arg1 == 12 then
		event.MesMake_2(arg0, "パンが食べたくなったら\nあたしのところへおいで。")
	end
	if arg1 == 13 then
		event.MesMake_2(arg0, "おまえ、ホントに\n冒険が好きだよなぁ。")
	end
	if arg1 == 14 then
		event.MesMake_2(arg0, "本官に頼みたいことがあったら、\nいつでも言ってくれ。")
	end
	if arg1 == 15 then
		event.MesMake_2(arg0, "どうだい？ゼルマイト鉱山には\n歯ごたえのある奴はいるかい？")
	end
	if arg1 == 16 then
		event.MesMake_2(
			arg0,
			"これからはニードやスターブルとともに\n世界の建て直しに協力するつもりだ。\nおたがい、がんばらねばならんな。"
		)
	end
	if arg1 == 17 then
		event.MesMake_2(
			arg0,
			"頼みごとをしていて言うのも変だが、\n鉱山は危険な場所だ。\nあまり無理をしないようにな。"
		)
	end
	if arg1 == 18 then
		event.MesMake_2(arg0, "これから先も、永久に世界が\n平和でありますように。")
	end
	if arg1 == 19 then
		event.MesMake_2(
			arg0,
			"バース鉄道が世界中に\n広がったら、いろんなところに\nいけるようになるね。"
		)
	end
	if arg1 == 20 then
		event.MesMake_2(arg0, "はやく、いろんなところに行って\n釣りをしてみたいよね。")
	end
	if arg1 == 21 then
		event.MesMake_2(
			arg0,
			"フラビンたら、少しは釣り以外の\nことにも興味を持って欲しいわ。"
		)
	end
	if arg1 == 22 then
		event.MesMake_2(
			arg0,
			"ゼルマイト鉱山から、\n何か恐ろしい気を感じるの。\n気をつけてね。"
		)
	end
	if arg1 == 23 then
		event.MesMake_2(
			arg0,
			"バース鉄道が世界中に広がったら\nいろんなところに旅行とか\n行っちゃおっかな。"
		)
	end
	if arg1 == 24 then
		event.MesMake_2(
			arg0,
			"ねぇねぇ、最近なんか、こっそり\n楽しいことしてるでしょ？\nわたしにも教えてよ～。"
		)
	end
	if arg1 == 25 then
		event.MesMake_2(
			arg0,
			"そうだねぇ、バース鉄道が完成したら\n”世界の果て”を見てみたいねぇ。"
		)
	end
end

--- Helper function.
local function helper_1ed64(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var7: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		var3 = vm.f32(var7 * -1.0)
		var3 = var7
	end
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetNpcTrainEtc(1, arg1) or var2
	do
		local out1, out2, out3, _ = event.GetTrainNpcPos(var2)
		var3 = out1 or var3
		var4 = out2 or var4
		var5 = out3 or var5
	end
	var7 = event.GetNpcTrainEtc(2, arg1) or var7
	if var3 < 0 then
		var3 = vm.f32(var7 * -1.0)
	else
		var3 = var7
	end
	event.SetCharaPos(arg0, var3, var4, var5)
	event.SetCharaRot(arg0, 0.0, 3.1415927, 0.0)
	event.SetMotion(arg0, "待機", 4)
end

--- Helper function.
local function helper_1fe7c(arg0: s32, arg1: s32)
	local argc: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		helper_38448da1(1)
		helper_1ed64(arg0, argc)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.EyeViewDrawOnOff(0)
	event.SetMesEtc(1, 4, -1, -1, -1, -1)
	event.SetMesEtc(1, 9, -1, -1)
	if arg1 ~= 0 then
		helper_38448da1(1)
	else
		event.SetMesPreset(1, 3)
	end
	event.Finish()
	if arg1 == 0 then
		argc = event.GetLocalCnt(arg0) or argc
		helper_1ed64(arg0, argc)
	end
end

--- Helper function.
local function helper_20124(arg0: s32, arg1: s32, arg2: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_ff0edc1d(30)
		end
		helper_1fe7c(arg0, arg1)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFadeOut(25)
	helper_ff0edc1d(30)
	if vm.skipping() then
		return skip(2)
	end
	event.GotoMenu(6, arg2)
	if vm.wait() then
		return skip(3)
	end
	helper_1fe7c(arg0, arg1)
	event.SetFadeIn(30)
end

--- Helper function.
local function helper_1f284()
	local var0: s32 = 0
	local var1: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return 1
		end
		if at <= 2 then
			helper_b7c85616(3, 1)
			helper_eb838ef8(3, -1, 3, 256, 208)
		end
		return 0
	end
	if vm.skipping() then
		return skip(1)
	end
	do
		local out1, out2 = event.GetMenuEtc_3(6)
		var0 = out1 or var0
		var1 = out2 or var1
	end
	if 0 < var0 then
		return 1
	end
	if var1 == 1 then
		helper_b7c85616(3, 1)
		event.MesMake_2(3, "もっとスクープを撮って来ないと\n賞品はやれないぜ。")
		helper_eb838ef8(3, -1, 3, 256, 208)
		if vm.skipping() then
			return skip(2)
		end
	end
	if var1 == 2 then
		helper_b7c85616(3, 1)
		event.MesMake_2(
			3,
			"ネタかスクープの数によって、\nオマエの写真家レベルが決まる。<page>レベルが上がれば、ごほうびの\nアイテムも増えるぞ。"
		)
		helper_eb838ef8(3, -1, 3, 256, 208)
		if vm.skipping() then
			return skip(3)
		end
	end
	return 0
end

--- Helper function.
local function helper_1f6cc()
	local argc: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return 0
		end
		if at <= 2 then
			return helper_1f284()
		end
		if at <= 3 then
			helper_b7c85616(3, 1)
			helper_eb838ef8(3, -1, 3, 256, 208)
		end
		return helper_1f284()
	end
	argc = event.GetItemHaveNum(355) or argc
	if argc <= 0 then
		helper_b7c85616(3, 1)
		event.MesMake_2(3, "スクープメモを\n買ってくれ。")
		helper_eb838ef8(3, -1, 3, 256, 208)
		if vm.skipping() then
			return skip(1)
		end
		return 0
	end
	do
		local out1, out2 = event.GetMenuEtc_3(5)
		var1 = out1 or var1
		var2 = out2 or var2
	end
	if var1 == var2 then
		helper_b7c85616(3, 1)
		event.MesMake_2(3, "もう、スクープは\nなさそうだな。")
		helper_eb838ef8(3, -1, 3, 256, 208)
		if vm.skipping() then
			return skip(2)
		end
		return helper_1f284()
	end
	var3 = event.GetMenuEtc_2(3) or var3
	if 0 < var3 then
		helper_b7c85616(3, 8)
		event.SetMesValue(3, 1, var3)
		event.MesMake_2(3, "スクープ条件が、[数値１]個\n明らかになった。")
		event.SetMesDrawspeed(3, 0)
		helper_eb838ef8(3, -1, 8, 0, 0)
		if vm.skipping() then
			return skip(3)
		end
	end
	helper_b7c85616(3, 1)
	var3 = event.GetMenuEtc_2(4) or var3
	if var3 <= 0 then
		event.MesMake_2(3, "なんだよ、スクープなんて\n撮れてないじゃないか。")
	else
		event.SetMesValue(3, 1, var3)
		event.MesMake_2(3, "お、[数値１]枚もスクープが\n撮れてるじゃん。さすがだな。")
	end
	helper_eb838ef8(3, -1, 3, 256, 208)
	if vm.skipping() then
		return skip(4)
	end
	return helper_1f284()
end

--- Helper function.
local function helper_1de58()
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local flag_4: s32 = 0
	local flag_5: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	flag = event.GetFlag(732) or flag
	if flag ~= 0 then
		event.MesMake_2(3, "やったな！ニンゲンも\n少しはやるもんだ。<page>見直したぜ。")
		return
	end
	flag = event.GetFlag(728) or flag
	if flag ~= 0 then
		event.MesMake_2(
			3,
			"いよいよ最後だね。\n奴を倒せば全て終わる。<page>そして、新しい何かが\n始まるんだ。"
		)
		return
	end
	flag = event.GetFlag(712) or flag
	if flag ~= 0 then
		event.MesMake_2(
			3,
			"グリフォンの気持ちもわかるけど、\n彼のした事は許されないと思うんだ。"
		)
		return
	end
	flag = event.GetFlag(702) or flag
	if flag ~= 0 then
		event.MesMake_2(3, "庭園を元に戻して、グリフォン、\nいやサンの秘密をあばくんだ。")
		return
	end
	flag = event.GetFlag(700) or flag
	if flag ~= 0 then
		event.MesMake_2(
			3,
			"「サンの思い出」って何の事かな？\n宮殿に入ってみなきゃわかんないよ。"
		)
		return
	end
	flag = event.GetFlag(640) or flag
	if flag ~= 0 then
		event.MesMake_2(
			3,
			"ぼやぼやしているとグリフォンを\n逃がしてしまうよ。<page>早く月花宮殿へ行かなきゃ。"
		)
		return
	end
	flag_2 = event.GetFlag(624) or flag_2
	flag_3 = event.GetFlag(628) or flag_3
	flag_4 = event.GetFlag(632) or flag_4
	flag_5 = event.GetFlag(636) or flag_5
	if (if (if (if flag_2 ~= 0 then flag_3 else 0) ~= 0 then flag_4 else 0) ~= 0 then flag_5 else 0) ~= 0 then
		event.MesMake_2(
			3,
			"ラピスは全て手に入れたよね。\n急いでカザロフストーンへ行こう。"
		)
		return
	end
	flag = event.GetFlag(616) or flag
	if flag ~= 0 then
		event.MesMake_2(
			3,
			"とにかく、急いでラピスを探さなきゃ、\n取り返しのつかない事になっちゃうよ。"
		)
		return
	end
	flag = event.GetFlag(600) or flag
	if flag ~= 0 then
		event.MesMake_2(
			3,
			"この宮殿から全てが始まったんだね。\nとりあえず、中に入ってみようよ。"
		)
		return
	end
	flag = event.GetFlag(540) or flag
	if flag ~= 0 then
		event.MesMake_2(
			3,
			"そろそろ、ルナ研に戻ってみない？\nイクシオンが完成してるかもしれないよ。"
		)
		return
	end
	flag = event.GetFlag(536) or flag
	if flag ~= 0 then
		event.MesMake_2(
			3,
			"いよいよグリフォンへの反撃開始だ。\nパズノス要塞へ行ってみようよ。"
		)
		return
	end
	flag = event.GetFlag(526) or flag
	if flag ~= 0 then
		event.MesMake_2(3, "なにぼやぼやしてるの！\n早くモニカを助けなきゃ！")
		return
	end
	flag = event.GetFlag(524) or flag
	if flag ~= 0 then
		event.MesMake_2(
			3,
			"ドナ・ホーンさんが\n言っていたよね。<page>ファイアーホーンを奏でれば\n道は開けるって。"
		)
		return
	end
	flag = event.GetFlag(520) or flag
	if flag ~= 0 then
		event.MesMake_2(3, "なにぼやぼやしてるの！\n早くモニカを助けなきゃ！")
		return
	end
	flag = event.GetFlag(508) or flag
	if flag ~= 0 then
		event.MesMake_2(
			3,
			"ファイアースコール装置を\n壊さなきゃ。<page>ガンドール火山の頂上に\nあるって言っていたよね。"
		)
		return
	end
	event.MesMake_2(
		3,
		"待っているだけでは\n何も起きないよ。<page>まだ行った事のない場所が\nあるんじゃないの。"
	)
end

--- Helper function.
local function helper_20258(arg0: s32, arg1: s32)
	local argc: s32 = 0
	local now_party_chara_id: s32 = 0
	local var4: s32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var9: f32 = 0
	local var11: s32 = 0
	local var12: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	local var15: f32 = 0
	local var16: f32 = 0
	local var17: f32 = 0
	local var18: f32 = 0
	local var19: f32 = 0
	local var20: f32 = 0
	local var21: f32 = 0
	local var22: f32 = 0
	local var23: f32 = 0
	local var24: any = 0
	local var25: s32 = 0
	local var26: s32 = 0
	local var27: s32 = 0
	local var28: s32 = 0
	local argc_2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			argc = 1
			argc = 2
			argc = 13
			return
		end
		if at <= 5 then
			if at <= 2 then
				var24 = 0
				helper_b7c85616(3, 1)
				helper_1cd10(3, argc)
				var25 = -1
				helper_e304888c(3, var25, 3, 256, 208)
				helper_b7c85616(1, 8)
				helper_e304888c(1, 1, 1, 0, 0)
				helper_b7c85616(2, 2)
				var25 = 30
				var25 = 31
				var25 = 32
				var24 = helper_8d58a537(2, var25, 7, 0, 0, var28, var28 - 1)
			end
			if at <= 3 then
				helper_38448da1(3)
				helper_ff0edc1d(30)
			end
			helper_1fe7c(arg0, arg1)
			return
		end
		if at <= 10 then
			if at <= 6 then
				helper_b7c85616(3, 8)
				helper_eb838ef8(3, var25, 9, 0, 0)
			end
			if at <= 7 then
				helper_eb838ef8(3, -1, 3, 256, 208)
			end
			if at <= 8 then
				helper_1fe7c(arg0, arg1)
				helper_20124(arg0, arg1, 6)
			end
			if at <= 9 then
				helper_20124(arg0, arg1, 23)
			end
			return
		end
		if at <= 12 then
			if at <= 11 then
				helper_20124(arg0, arg1, 33)
			end
			return
		end
		if at <= 13 then
			helper_20124(arg0, arg1, 1)
		end
		if at <= 14 then
			helper_20124(arg0, arg1, 2)
		end
		if at <= 15 then
			helper_20124(arg0, arg1, 3)
		end
		if at <= 16 then
			helper_20124(arg0, arg1, 7)
		end
		if at <= 17 then
			helper_20124(arg0, arg1, 8)
		end
		if at <= 18 then
			helper_20124(arg0, arg1, 9)
		end
		if at <= 19 then
			helper_20124(arg0, arg1, 10)
		end
		if at <= 20 then
			helper_20124(arg0, arg1, 11)
		end
		if at <= 21 then
			helper_20124(arg0, arg1, 12)
		end
		if at <= 22 then
			helper_20124(arg0, arg1, 13)
		end
		if at <= 23 then
			helper_20124(arg0, arg1, 14)
		end
		if at <= 24 then
			helper_20124(arg0, arg1, 15)
		end
		if at <= 25 then
			helper_20124(arg0, arg1, 16)
		end
		if at <= 26 then
			helper_20124(arg0, arg1, 17)
		end
		if at <= 27 then
			helper_20124(arg0, arg1, 18)
		end
		if at <= 28 then
			helper_20124(arg0, arg1, 19)
		end
		if at <= 29 then
			helper_20124(arg0, arg1, 20)
		end
		if at <= 30 then
			helper_20124(arg0, arg1, 21)
		end
		if at <= 31 then
			helper_20124(arg0, arg1, 22)
		end
		if at <= 32 then
			helper_20124(arg0, arg1, 32)
		end
		if at <= 33 then
			helper_1de58()
			helper_eb838ef8(3, -1, 3, 256, 208)
		end
		if at <= 34 then
			helper_1fe7c(arg0, arg1)
			helper_ff0edc1d(30)
		end
		helper_1fe7c(arg0, arg1)
	end
	if vm.skipping() then
		return skip(1)
	end
	if arg1 == 1 then
		argc = 1
	elseif arg1 == 2 then
		argc = 2
	elseif arg1 == 3 then
		argc = 13
	else
		argc = event.GetLocalCnt(arg0) or argc
	end
	now_party_chara_id = event.GetNowPartyChara() or now_party_chara_id
	if argc == now_party_chara_id then
		return
	end
	event.SetMotion(0, "立ち")
	event.Initialize()
	event.SetMesPreset(1, 0)
	var4 = 0
	if argc == 10 or argc == 18 then
		var4 = 8
	end
	if argc == 1 or argc == 6 or argc == 17 then
		var4 = 16
	end
	if argc == 2 or argc == 15 or argc == 16 or argc == 19 or argc == 20 or argc == 21 or argc == 22 then
		var4 = 24
	end
	if argc == 3 or argc == 4 or argc == 5 or argc == 7 or argc == 8 or argc == 23 or argc == 24 then
		var4 = 32
	end
	if argc == 9 or argc == 11 or argc == 13 then
		var4 = 40
	end
	event.SetMesEtc(1, 4, 30, 60, 144, -1)
	event.SetMesEtc(1, 9, 20 + var4, 16)
	event.EyeViewDrawOnOff(1)
	if arg1 ~= 0 then
		event.EohSyncChara(0, arg0)
		do
			local out1, out2, out3 = event.EohGetPos(0)
			var5 = out1 or var5
			var6 = out2 or var6
			var7 = out3 or var7
		end
		do
			local _, out2, _ = event.EohGetRot(0)
			var9 = out2 or var9
		end
	else
		var11 = event.GetNpcTrainEtc(1, argc) or var11
		do
			local out1, out2, out3, out4 = event.GetTrainNpcPos(var11)
			var5 = out1 or var5
			var6 = out2 or var6
			var7 = out3 or var7
			var9 = out4 or var9
		end
		event.EohSyncChara(0, arg0)
		event.EohSetPos(0, var5, var6, var7)
		event.EohSetRot(0, 0.0, var9, 0.0)
		event.SetMotion(arg0, "立ち", 4)
	end
	var12 = vm.f32(vm.sin(var9) * 75.0)
	var12 = vm.f32(var12 + var5)
	var13 = vm.f32(var6 + 45.0)
	var14 = vm.f32(vm.cos(var9) * 75.0)
	var14 = vm.f32(var14 + var7)
	event.SetCameraPos(var12, var13, var14)
	var15 = var5
	var16 = vm.f32(var6 + 30.0)
	var17 = var7
	event.SetCameraRef(var15, var16, var17)
	var18 = vm.f32(vm.sin(var9) * 30.0)
	var18 = vm.f32(var18 + var5)
	var19 = var6
	var20 = vm.f32(vm.cos(var9) * 30.0)
	var20 = vm.f32(var20 + var7)
	event.SetCharaPos(0, var18, var19, var20)
	var21 = 0
	var22 = vm.f32(var9 + vm.f32(3.1415927))
	if var22 > vm.f32(3.1415927) then
		var22 = vm.f32(var22 - vm.f32(6.2831855))
	end
	var23 = 0
	event.SetCharaRot(0, var21, var22, var23)
	if vm.wait() then
		return skip(2)
	end
	event.SetCrossfade(10)
	var24 = 0
	while true do
		helper_b7c85616(3, 1)
		var26 = event.GetChapter() or var26
		if var26 ~= 8 then
			var25 = event.GetPartyCharaMesNo_3(argc, 2) or var25
		else
			helper_1cd10(3, argc)
			var25 = -1
		end
		event.SetMesDrawspeed(3, 0, 0)
		helper_e304888c(3, var25, 3, 256, 208)
		helper_b7c85616(1, 8)
		event.SetMesDrawspeed(1, 0, 0)
		var27 = event.GetPartyCharaMesNo_3(argc, 0) or var27
		event.SetMesItemDirect(1, 1, var27)
		helper_e304888c(1, 1, 1, 0, 0)
		helper_b7c85616(2, 2)
		do
			local out1, out2 = event.GetPartyCharaMesNo_4(argc, 4)
			var25 = out1 or var25
			var28 = out2 or var28
		end
		if var28 == 3 then
			var25 = 30
		end
		if var28 == 4 then
			event.SetMesItemDirect(2, 1, var25)
			var25 = 31
		end
		if var28 == 5 then
			event.SetMesItemDirect(2, 1, var25)
			event.SetMesItemDirect(2, 2, vm.i32(var25 + 1))
			var25 = 32
		end
		var24 = helper_8d58a537(2, var25, 7, 0, 0, var28, vm.i32(var28 - 1))
		if vm.skipping() then
			return skip(3)
		end
		helper_38448da1(3)
		if var24 == 0 then
			if now_party_chara_id ~= 26 then
				event.SetFadeOut(25)
				helper_ff0edc1d(30)
				if vm.skipping() then
					return skip(4)
				end
				if arg1 == 0 then
					event.CharaActive(0, arg0)
					argc_2 = event.GetLocalCnt2(now_party_chara_id) or argc_2
					if 0 <= argc_2 then
						event.CharaActive(argc_2)
					end
				end
				event.SetNpcStatus(argc, 1)
				event.GotoSelectParty()
				if vm.wait() then
					return skip(5)
				end
				helper_1fe7c(arg0, arg1)
				event.SetFadeIn(30)
				return
			end
			helper_b7c85616(3, 8)
			event.SetMesDrawspeed(3, 0, 0)
			event.MesMake_2(
				3,
				"[(!)]今は連れて行けない。リンを\n   岬灯台に連れて行くのが先だ！"
			)
			helper_eb838ef8(3, -1, 9, 0, 0)
			if vm.skipping() then
				return skip(6)
			end
			event.SetMesDrawspeed(3, 0, 0.6)
		end
		if var24 == 1 then
			helper_b7c85616(3, 8)
			event.SetMesDrawspeed(3, 0, 0)
			var25 = event.GetPartyCharaMesNo_3(argc, 3) or var25
			helper_eb838ef8(3, var25, 9, 0, 0)
			if vm.skipping() then
				return skip(7)
			end
			event.SetMesDrawspeed(3, 0, 0.6)
		end
		if 3 < var28 then
			if var28 == 5 then
				if var24 == 2 then
					if argc == 1 then
						event.SetSavedataEtc(2)
						event.MesMake_2(3, "よし、これで\n修理完了じゃ！")
						helper_eb838ef8(3, -1, 3, 256, 208)
						if vm.skipping() then
							return skip(8)
						end
						helper_1fe7c(arg0, arg1)
						event.SetCrossfade(10)
					end
					if not (argc == 4) then
						break
					end
					helper_20124(arg0, arg1, 6)
					if vm.skipping() then
						return skip(9)
					end
					break
				end
				if var24 == 3 then
					if argc == 1 then
						helper_20124(arg0, arg1, 23)
						if vm.skipping() then
							return skip(10)
						end
						return
					end
					if argc == 4 then
						local t0 = helper_1f6cc()
						if vm.skipping() then
							return skip(11)
						end
						if t0 ~= 0 then
							helper_20124(arg0, arg1, 33)
							if vm.skipping() then
								return skip(12)
							end
							return
						end
					end
				end
				if var24 == 4 then
					break
				end
				if var24 == -1 then
					break
				end
			else
				if var24 == 2 then
					if argc == 15 then
						helper_20124(arg0, arg1, 0)
						if vm.skipping() then
							return skip(13)
						end
					end
					if argc == 12 then
						helper_20124(arg0, arg1, 1)
						if vm.skipping() then
							return skip(14)
						end
					end
					if argc == 6 then
						helper_20124(arg0, arg1, 2)
						if vm.skipping() then
							return skip(15)
						end
					end
					if argc == 7 then
						helper_20124(arg0, arg1, 3)
						if vm.skipping() then
							return skip(16)
						end
					end
					if argc == 2 then
						helper_20124(arg0, arg1, 7)
						if vm.skipping() then
							return skip(17)
						end
					end
					if argc == 3 then
						helper_20124(arg0, arg1, 8)
						if vm.skipping() then
							return skip(18)
						end
					end
					if argc == 5 then
						helper_20124(arg0, arg1, 9)
						if vm.skipping() then
							return skip(19)
						end
					end
					if argc == 8 then
						helper_20124(arg0, arg1, 10)
						if vm.skipping() then
							return skip(20)
						end
					end
					if argc == 10 then
						helper_20124(arg0, arg1, 11)
						if vm.skipping() then
							return skip(21)
						end
					end
					if argc == 11 then
						helper_20124(arg0, arg1, 12)
						if vm.skipping() then
							return skip(22)
						end
					end
					if argc == 13 then
						helper_20124(arg0, arg1, 13)
						if vm.skipping() then
							return skip(23)
						end
					end
					if argc == 16 then
						helper_20124(arg0, arg1, 14)
						if vm.skipping() then
							return skip(24)
						end
					end
					if argc == 18 then
						helper_20124(arg0, arg1, 15)
						if vm.skipping() then
							return skip(25)
						end
					end
					if argc == 19 then
						helper_20124(arg0, arg1, 16)
						if vm.skipping() then
							return skip(26)
						end
					end
					if argc == 20 then
						helper_20124(arg0, arg1, 17)
						if vm.skipping() then
							return skip(27)
						end
					end
					if argc == 21 then
						helper_20124(arg0, arg1, 18)
						if vm.skipping() then
							return skip(28)
						end
					end
					if argc == 22 then
						helper_20124(arg0, arg1, 19)
						if vm.skipping() then
							return skip(29)
						end
					end
					if argc == 23 then
						helper_20124(arg0, arg1, 20)
						if vm.skipping() then
							return skip(30)
						end
					end
					if argc == 24 then
						helper_20124(arg0, arg1, 21)
						if vm.skipping() then
							return skip(31)
						end
					end
					if argc == 25 then
						helper_20124(arg0, arg1, 22)
						if vm.skipping() then
							return skip(32)
						end
					end
					if argc == 17 then
						helper_20124(arg0, arg1, 32)
						if vm.skipping() then
							return skip(33)
						end
					end
					if argc == 9 then
						helper_1de58()
						event.SetMesDrawspeed(3, 0.6, 0.6)
						helper_eb838ef8(3, -1, 3, 256, 208)
						if vm.skipping() then
							return skip(34)
						end
						helper_1fe7c(arg0, arg1)
						event.SetCrossfade(10)
					end
					if argc == 14 then
						event.SetFadeOut(25)
						helper_ff0edc1d(30)
						if vm.skipping() then
							return skip(35)
						end
						event.GotoMenu(25)
						if vm.wait() then
							return skip(36)
						end
						helper_1fe7c(arg0, arg1)
						event.SetFadeIn(30)
					end
					return
				end
				if var24 == 3 then
					break
				end
				if var24 == -1 then
					break
				end
			end
		else
			if var24 == 2 then
				break
			end
			if var24 == -1 then
				break
			end
		end
	end
	helper_1fe7c(arg0, arg1)
	event.SetCrossfade(10)
end

--- Helper function.
local function helper_2406c()
	local var0: s32 = 0
	local var1: s32 = 0
	local now_map_no: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local flag_4: s32 = 0
	local flag_5: s32 = 0
	local flag_6: s32 = 0
	local var9: f32 = 0
	local player_chara: s32 = 0
	local var11: any = 0
	local now_party_chara_id: s32 = 0
	local now_map_no_2: s32 = 0
	local flag_7: s32 = 0
	local flag_8: s32 = 0
	local flag_9: s32 = 0
	local var17: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 5 then
			if at <= 1 then
				helper_3dd465f9(0, -1, var0, player_chara, 0)
			end
			if at <= 2 then
				var11 = helper_8d58a537(0, -1, 5, 256, 208, 2, 0)
			end
			if at <= 3 then
				helper_3dd465f9(0, -1, var0, player_chara, 0)
			end
			if at <= 4 then
				helper_fc624989(var0, var9, 0, 0)
			end
			return 1
		end
		if at <= 6 then
			helper_20258(var17, 1)
		end
		return 0
	end
	var0 = event.GetEventData_2(13) or var0
	var1 = 0
	now_map_no = event.GetNowMapNo() or now_map_no
	if now_map_no == 16 then
		flag = event.GetFlag(280) or flag
		flag_2 = event.GetFlag(283) or flag_2
		if flag ~= 0 and flag_2 == 0 then
			var1 = 1
		end
	end
	if now_map_no == 54 then
		flag_3 = event.GetFlag(372) or flag_3
		flag_4 = event.GetFlag(360) or flag_4
		if flag_3 ~= 0 and flag_4 == 0 then
			var1 = 1
		end
	end
	if now_map_no == 83 then
		flag_5 = event.GetFlag(448) or flag_5
		flag_6 = event.GetFlag(452) or flag_6
		if flag_5 ~= 0 and flag_6 == 0 then
			var1 = 1
		end
	end
	if var1 == 1 then
		helper_b7c85616(0, 1)
		var9 = helper_3c8e2192(var0, 0, 0)
		if vm.skipping() then
			return skip(1)
		end
		player_chara = event.GetControlChrid() or player_chara
		event.MesMake_2(0, "出発するか？")
		helper_3dd465f9(0, -1, var0, player_chara, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.SetMotion(var0, "立ち")
		event.SetMesShippo(0, 0)
		event.SetMesQuestionGyou(0, 0)
		event.SetMesEtc(0, 0, 1)
		event.MesMake_2(0, "うん！\nもう少しここにいるよ。")
		var11 = helper_8d58a537(0, -1, 5, 256, 208, 2, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.SetMesEtc(0, 0, 0)
		event.SetMesShippo(0, 1)
		if var11 ~= 0 then
			event.SetMotion(var0, "会話")
			event.MesMake_2(0, "うむ、しっかりがんばるんじゃぞ。")
			helper_3dd465f9(0, -1, var0, player_chara, 0)
			if vm.skipping() then
				return skip(4)
			end
		end
		helper_fc624989(var0, var9, 0, 0)
		if vm.skipping() then
			return skip(5)
		end
		if var11 == 0 then
			return 1
		else
			return 0
		end
	end
	now_party_chara_id = event.GetNowPartyChara() or now_party_chara_id
	if now_party_chara_id == 1 then
		helper_b7c85616(0, 1)
		event.MesMake_2(0, "二人とも気をつけてな。")
		now_map_no_2 = event.GetNowMapNo() or now_map_no_2
		flag_7 = event.GetFlag(300) or flag_7
		if now_map_no_2 == 16 and flag_7 == 0 then
			event.MesMake_2(0, "まだ出発はできんなぁ・・・\nもう少し待ってくれ。")
		end
		flag_8 = event.GetFlag(400) or flag_8
		if now_map_no_2 == 54 and flag_8 == 0 then
			event.MesMake_2(0, "まだ出発はできんなぁ・・・\nもう少し待ってくれ。")
		end
		flag_9 = event.GetFlag(500) or flag_9
		if now_map_no_2 == 83 and flag_9 == 0 then
			event.MesMake_2(0, "まだ出発はできんなぁ・・・\nもう少し待ってくれ。")
		end
		helper_f96a9d1b(var0, -1, 0, 0)
		if vm.skipping() then
			return skip(6)
		end
	else
		var17 = event.GetEventData_2(13) or var17
		helper_20258(var17, 1)
		if vm.skipping() then
			return skip(7)
		end
	end
	return 0
end

--- Helper function.
local function helper_23588()
	local var0: s32 = 0
	local now_party_chara_id: s32 = 0
	local var2: s32 = 0
	local flag: s32 = 0
	local var4: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_20258(var4, 2)
		end
	end
	var0 = event.GetEventData_2(13) or var0
	now_party_chara_id = event.GetNowPartyChara() or now_party_chara_id
	if now_party_chara_id == 2 then
		helper_b7c85616(0, 1)
		event.MesMake_2(0, "オレは常に身体を\n動かしてないと\nイライラするんだ。")
		var2 = event.GetChapter() or var2
		flag = event.GetFlag(448) or flag
		if var2 == 4 and flag == 0 then
			event.MesMake_2(
				0,
				"線路や橋がめちゃくちゃじゃねえか。\nひでぇことしやがるぜ、まったく・・・"
			)
		end
		if var2 == 3 then
			event.MesMake_2(
				0,
				"動かしてない間も整備してたんだけどな、\n実際に動かしてみると、あちこちガタが\n来てやがった。<page>毎日動かしてないと鈍っちまうってのは、\n機械も身体もいっしょだな。"
			)
		end
		helper_f96a9d1b(var0, -1, 0, 0)
		if vm.skipping() then
			return skip(1)
		end
	else
		var4 = event.GetEventData_2(13) or var4
		helper_20258(var4, 2)
		if vm.skipping() then
			return skip(2)
		end
	end
end

--- Helper function.
local function helper_23a34()
	local var0: s32 = 0
	local now_party_chara_id: s32 = 0
	local var2: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local var6: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_b7c85616(0, 1)
			helper_f96a9d1b(var0, -1, 0, 0)
		end
		if at <= 2 then
			helper_20258(var6, 3)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var0 = event.GetEventData_2(13) or var0
	now_party_chara_id = event.GetNowPartyChara() or now_party_chara_id
	if now_party_chara_id == 13 then
		helper_b7c85616(0, 1)
		event.MesMake_2(
			0,
			"俺は、火薬の匂いが大好きなんだ。\nだから、今の仕事は天職だと思ってる。<page>親方は、頭が固くて古臭くて、\n頑固でわからずやだけどな。"
		)
		var2 = event.GetChapter() or var2
		flag = event.GetFlag(280) or flag
		if var2 == 2 and flag == 0 then
			event.MesMake_2(
				0,
				"こんな岩、ファイナルボムなら\n一発で吹っ飛ばせるんだけどなぁ。"
			)
		end
		flag_2 = event.GetFlag(372) or flag_2
		if var2 == 3 and flag_2 == 0 then
			event.MesMake_2(
				0,
				"ちびちび削るしかないなんて、\n性に合わない仕事だぜ。<page>でも、下手に爆破して、\n崩れちまったら大変だからな。"
			)
		end
		flag_3 = event.GetFlag(448) or flag_3
		if var2 == 4 and flag_3 == 0 then
			event.MesMake_2(
				0,
				"正直言って、俺は何かを作ったり、\n修理したりするのって苦手なんだよな。"
			)
		end
		helper_f96a9d1b(var0, -1, 0, 0)
		if vm.skipping() then
			return skip(2)
		end
	else
		var6 = event.GetEventData_2(13) or var6
		helper_20258(var6, 3)
		if vm.skipping() then
			return skip(3)
		end
	end
end

--- Helper function.
local function helper_24f3c()
	local var0: s32 = 0
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_b7c85616(0, 1)
			helper_f96a9d1b(var0, -1, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var0 = event.GetEventData_2(13) or var0
	helper_b7c85616(0, 1)
	flag = event.GetFlag(648) or flag
	if flag == 0 then
		event.MesMake_2(0, "オレはここで待ってる。\n幸運を祈ってるぜ！")
	else
		event.MesMake_2(0, "オレはここで待ってるぜ。\n絶対、グリフォンを倒せよ。")
	end
	helper_f96a9d1b(var0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_33168()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_23a34()
		end
		if at <= 2 then
			helper_24f3c()
		end
		return 0
	end
	var0 = event.GetEventData_2(14) or var0
	if var0 == 1 then
		return helper_2406c()
	end
	if var0 == 2 then
		helper_23588()
		if vm.skipping() then
			return skip(1)
		end
	end
	if var0 == 13 then
		helper_23a34()
		if vm.skipping() then
			return skip(2)
		end
	end
	if var0 == 301 then
		helper_24f3c()
		if vm.skipping() then
			return skip(3)
		end
	end
	return 0
end

--- Helper function.
local function helper_30b6c()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 4 then
			if at <= 1 then
				helper_ff0edc1d(45)
			end
			if at <= 2 then
				helper_1d96573f(4520010)
			end
			if at <= 3 then
				helper_ff0edc1d(30)
			end
			if vm.skip_end() then
				return skip(5)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.DelExtMotion(0)
		event.DeleteChara(32)
		event.DeleteChara(33)
		event.DeleteChara(34)
		event.LoadMes(0, -1)
		event.CharaActive(0)
		event.CharaNormalDrive(0)
		event.CharaResetDa(0)
		event.ResetCamera(1, 3.1415927, 10.0)
		event.SetFadeIn(30)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFlag(452, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.LoadSound(4223)
	var0 = event.SndLoadSound(4223) or var0
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.LoadMes(0, 5, "event/e400/e452/e452.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "event/e400/e452/e452_mints.chr", "info", 0)
		event.CharaActive(0, 0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "event/e400/e452/e452_monica.chr", "info", 0)
		event.CharaActive(0, 0)
		event.EohSyncChara(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.LoadChara(5, "event/e200/e283/e283_starbre.gltf", "info", 34)
	event.CharaActive(34)
	event.EohSyncChara(2, 34)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	if active_chr_no == 1 then
		event.LoadChara(5, "chara/c01_base.gltf", "info", 32)
		event.LoadEquip(5, 0, 4, "info", 32)
		event.LoadEquip(5, 0, 3, "info", 32)
		event.LoadEquip(5, 0, 2, "info", 32, 33)
		event.LoadMotion(5, "event/e400/e452/e452_mints.chr", "info", 32)
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
		event.LoadMotion(5, "event/e400/e452/e452_monica.chr", "info", 32)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 32)
		event.EohSyncChara(1, 32)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 0)
	end
	event.CharaActive(0, 32)
	event.CharaActive(0, 33)
	event.CharaActive(0, 8)
	event.CharaActive(0, 9)
	event.CharaActive(0, 10)
	event.EohSetPos(0, -1960.0, 29.22, -120.0)
	event.EohSetRot(0, 0.0, -0.7853982, 0.0)
	event.EohSetMotion(0, "立ち", 4)
	event.EohSetPos(1, -2000.0, 29.22, -120.0)
	event.EohSetRot(1, 0.0, 0.7853982, 0.0)
	event.EohSetMotion(1, "立ち", 4)
	event.EohSetPos(2, -1980.0, 29.22, -100.0)
	event.EohSetRot(2, 0.0, 3.1415927, 0.0)
	event.EohSetMotion(2, "立ち", 4)
	event.InitDramaScene()
	event.CmrsInit()
	event.CmrsSetPos(-1980.0, 51.24, -291.47)
	event.CmrsSetRef(-1980.0, 91.37, -49.52)
	event.CharaActive(0)
	event.CharaActive(32)
	event.CharaActive(33)
	event.CharaActive(34)
	event.SetFadeIn(30)
	helper_ff0edc1d(45)
	if vm.skipping() then
		return skip(2)
	end
	event.ObjsSetMotion(2, "出発進行", 6)
	event.ObjsNextMotion(2, "出発進行L", 4)
	event.SndSePlay(var0, 0)
	event.SetPakuAnim(2, "わらい口パク")
	helper_1d96573f(4520010)
	if vm.skipping() then
		return skip(3)
	end
	event.ResetPakuAnim()
	event.SetFadeOut(30)
	helper_ff0edc1d(30)
	if vm.skipping() then
		return skip(4)
	end
	return part2()
end

--- Helper function.
local function helper_2927c(arg0: s32)
	local var1: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 5 then
			if at <= 1 then
				helper_ff0edc1d(30)
			end
			if at <= 2 then
				helper_ff0edc1d(60)
			end
			if at <= 3 then
				helper_650bfa16(0)
			end
			if at <= 4 then
				helper_ff0edc1d(30)
			end
			if vm.skip_end() then
				return skip(6)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		if arg0 ~= 0 then
			event.StopBgm(0)
		end
		event.SetMpcharaMotion("p01_train01", "kikan-m0", "停止")
		event.DeleteChara(11)
		event.DeleteChara(12)
		event.EsmClear()
		event.CharaActive(0)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	event.SetFadeOut(30)
	helper_ff0edc1d(30)
	if vm.skipping() then
		return skip(2)
	end
	event.LoadSound(4223)
	var1 = event.SndLoadSound(4223) or var1
	event.AssignStack(5)
	event.ClearStack(5)
	event.CharaActive(0, 0)
	event.CharaActive(0, 8)
	event.EohSyncObj(0, "p01_train01")
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetPos(0, -912.1, 0.0, 0.0)
	event.ObjsSetRot(0, 0.0, 1.5707964, 0.0)
	event.SetMpcharaMotion("p01_train01", "kikan-m0", "機関")
	event.LoadChara(5, "event/train/steam/steam_l.gltf", "info", 11)
	event.EohSyncChara(2, 11)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.ObjsSetPos(2, -120.0, 0.0, -1690.0)
	event.LoadChara(5, "event/train/steam/steam_r.gltf", "info", 12)
	event.EohSyncChara(3, 12)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.ObjsSetPos(3, -120.0, 0.0, -1690.0)
	event.EsmInitialize(5)
	event.EsmLoadBase("列車煙")
	event.EsmInitFix(5)
	event.EsmCreate("列車煙")
	event.EsmSetValue(0, 0)
	event.EohSyncObj(1, "p01_shadow")
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.CharaActive(0, 11)
	event.CharaActive(0, 12)
	event.InitDramaScene()
	event.CmrsInit()
	event.CmrsSetPos(-480.06, 58.66, -117.78)
	event.CmrsSetRef(-569.61, 64.12, -98.79)
	event.SetFadeIn(30)
	event.SndSePlay(var1, 1)
	event.CharaActive(11)
	event.ObjsSetPos(2, -874.19, 10.0, 30.0)
	event.ObjsSetRot(2, 0.0, 1.5707964, 0.0)
	event.ObjsSetMotion(2, "ぶしゅー", 6)
	event.CharaActive(12)
	event.ObjsSetPos(3, -874.19, 10.0, 30.0)
	event.ObjsSetRot(3, 0.0, 1.5707964, 0.0)
	event.ObjsSetMotion(3, "ぶしゅー", 6)
	helper_ff0edc1d(60)
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsMove2(0, 4000.0, 0.0, 0.0, 180, 1, 1.0)
	event.ObjsMove2(1, 4500.0, 0.0, 0.0, 180, 1, 1.0)
	event.SndSePlay(var1, 2)
	helper_650bfa16(0)
	if vm.skipping() then
		return skip(4)
	end
	if arg0 ~= 0 then
		event.FadeOutBgm(30)
	end
	event.SetFadeOut(30)
	helper_ff0edc1d(30)
	if vm.skipping() then
		return skip(5)
	end
	return part2()
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 99.
-- Defined empty, so the engine runs this instead of its default.
script[99] = function() end

--- Program 100.
script[100] = function()
	local mc_load: s32 = 0
	local old_map_no: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local var6: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	local landing1: () -> ...any
	local landing2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_1c020()
			helper_2a10c()
			if not vm.skipping() then
				return landing1()
			end
		end
		if at <= 2 then
			helper_27d90()
			if not vm.skipping() then
				return landing2()
			end
		end
		if at <= 3 then
			helper_26da0()
		end
		print("------  <START EVENT> OLD MAP ERR   ------\n")
	end
	function part2() end
	function landing1()
		return part2()
	end
	function landing2()
		event.CharaActive(1, 9)
		return part2()
	end
	print("START_EVENT----------------------------")
	helper_25b30()
	mc_load = event.CheckMcLoad() or mc_load
	if mc_load == 1 then
		event.SetCharaPos(0, -1820.0, 29.2, -335.0)
		event.SetCharaRot(0, 0.0, 1.57, 0.0)
		event.SetMotion(0, "立ち", 4)
		event.CharaNormalDrive(0)
		event.CharaResetDa(0)
		event.ResetCamera(1, 0.0, 20.0)
	else
		old_map_no = event.GetOldMapNo() or old_map_no
		var2 = event.GetMapType() or var2
		if var2 ~= -1 then
			if old_map_no == 2 or old_map_no == 75 then
				helper_25bd4()
				if vm.skipping() then
					return skip(1)
				end
			else
				var3 = event.GetCnt(1) or var3
				if (old_map_no == 18 or old_map_no == 23 or old_map_no == 120 or old_map_no == 108) and var3 == 4 then
					helper_1c020()
					event.SetFadeIn(15)
					event.ResetCamera(1, 0.0)
				else
					flag = event.GetFlag(360) or flag
					flag_2 = event.GetFlag(400) or flag_2
					if flag == 1 and flag_2 == 0 then
						helper_2a10c()
						if vm.skipping() then
							return skip(2)
						end
					else
						event.CharaActive(0, 9)
						var6 = event.GetChapter() or var6
						if var6 ~= 6 and var6 ~= 7 then
							helper_27d90()
							if vm.skipping() then
								return skip(3)
							end
						else
							helper_26da0()
							if vm.skipping() then
								return skip(4)
							end
						end
						event.CharaActive(1, 9)
					end
				end
			end
		else
			print("------  <START EVENT> OLD MAP ERR   ------\n")
		end
	end
	return part2()
end

--- Program 150.
script[150] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_26da0()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 201.
script[201] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	local t0 = helper_260d8()
	if vm.skipping() then
		return skip(1)
	end
	if t0 ~= 0 then
		event.MapJump(-1, "g03")
	end
end

--- Program 250.
script[250] = function()
	local var0: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
		if at <= 3 then
			helper_127a4()
		end
		if at <= 6 then
			helper_13ef4(0)
		end
		if at <= 7 then
			helper_16ea4()
		end
	end
	var0 = helper_1c964()
	if vm.skipping() then
		return skip(1)
	end
	if var0 ~= 1 then
		return
	end
	event.SetCnt(1, 4)
	var1 = event.GetChapter() or var1
	var2 = event.GetEventData_2(3) or var2
	if var2 <= 1 then
		if var1 ~= 6 and var1 ~= 7 then
			helper_127a4()
			if vm.skipping() then
				return skip(2)
			end
			event.StopBgm(0)
			if vm.wait() then
				return skip(3)
			end
			event.MapJump(-1, "s08")
		else
			helper_127a4()
			if vm.skipping() then
				return skip(4)
			end
			event.StopBgm(0)
			if vm.wait() then
				return skip(5)
			end
			event.MapJump(-1, "s37")
		end
		if vm.wait() then
			return skip(6)
		end
	elseif var1 ~= 6 and var1 ~= 7 then
		helper_13ef4(0)
		if vm.skipping() then
			return skip(7)
		end
		event.StopBgm(0)
		event.MapJump(100, "s07")
	else
		helper_16ea4()
		if vm.skipping() then
			return skip(8)
		end
		event.StopBgm(0)
		event.MapJump(100, "s38")
	end
end

--- Program 400.
script[400] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_32130()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 500.
script[500] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_25b30()
	helper_2f304()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 1000.
script[1000] = function()
	local var0: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	local landing1: () -> ...any
	local landing2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_30b6c()
			if not vm.skipping() then
				return landing1()
			end
		end
		if at <= 2 then
			helper_2927c(1)
			if not vm.skipping() then
				return landing2()
			end
		end
	end
	function part2() end
	function landing1()
		helper_2927c(1)
		if vm.skipping() then
			return skip(3)
		end
		event.GotoMenu(13, 9)
		if vm.wait() then
			return skip(4)
		end
		event.BgmLoadCancel()
		event.MapJump(-1, "s10")
		return part2()
	end
	function landing2()
		event.GotoMenu(13, 9)
		if vm.wait() then
			return skip(4)
		end
		event.BgmLoadCancel()
		event.MapJump(-1, "s10")
		return part2()
	end
	var0 = helper_33168()
	if vm.skipping() then
		return skip(1)
	end
	if var0 == 1 then
		helper_30b6c()
		if vm.skipping() then
			return skip(2)
		end
		helper_2927c(1)
		if vm.skipping() then
			return skip(3)
		end
		event.GotoMenu(13, 9)
		if vm.wait() then
			return skip(4)
		end
		event.BgmLoadCancel()
		event.MapJump(-1, "s10")
	end
	return part2()
end

--- Program 14000.
script[14000] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_25b30()
	helper_2a10c()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 14520.
script[14520] = function()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_2927c(1)
			if not vm.skipping() then
				return part2()
			end
		end
	end
	function part2()
		event.GotoMenu(13, 9)
		if vm.wait() then
			return skip(3)
		end
		event.BgmLoadCancel()
		event.MapJump(-1, "s10")
	end
	helper_25b30()
	helper_30b6c()
	if vm.skipping() then
		return skip(1)
	end
	helper_2927c(1)
	if vm.skipping() then
		return skip(2)
	end
	return part2()
end

return script
