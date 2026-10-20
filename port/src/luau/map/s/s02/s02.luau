--!strict
-- map/s/s02/s02.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_06269a50 = require("@lib/event/helper_06269a50")
local helper_08472fdb = require("@lib/event/helper_08472fdb")
local helper_2913f82c = require("@lib/event/helper_2913f82c")
local helper_69020fbe = require("@lib/event/helper_69020fbe")
local helper_79c09698 = require("@lib/event/helper_79c09698")
local helper_b72ef077 = require("@lib/event/helper_b72ef077")
local helper_c46d8c15 = require("@lib/event/helper_c46d8c15")
local helper_cd0e70ce = require("@lib/event/helper_cd0e70ce")
local helper_d4172c24 = require("@lib/event/helper_d4172c24")
local helper_d4f8509e = require("@lib/event/helper_d4f8509e")
local helper_ed22addb = require("@lib/event/helper_ed22addb")
local helper_f8511a7a = require("@lib/event/helper_f8511a7a")
local helper_fd4e9f5c = require("@lib/event/helper_fd4e9f5c")

local global0: s32 = 0
local global1: s32 = 0

--- Helper function.
local function helper_255e4()
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.EohSyncObj(0, "p01_s0201", "s0208-m0")
	event.EohSetShow(0, 0)
	event.EohSyncObj(1, "p01_s0201", "s0208-m1")
	event.EohSetShow(1, 0)
	event.EohSyncObj(2, "p01_s0201", "s0208-m2")
	event.EohSetShow(2, 0)
	event.EohSyncObj(3, "p01_s0201", "s0208-m3")
	event.EohSetShow(3, 0)
	event.EohSyncObj(4, "p01_s0201", "s0213-m0")
	event.EohSetShow(4, 0)
end

--- Helper function.
local function helper_e34c()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.EohSyncObj(0, "p01_train01", "train07-m0")
	do
		local out1, out2, out3 = event.EohGetPos(0)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	event.EohSetPos(0, pos_x - 56.0, pos_y, pos_z)
	event.EohSetRot(0, 0.0, 0.0, 0.56)
	event.EohSyncObj(0, "p01_train01", "train07-m1")
	do
		local out1, out2, out3 = event.EohGetPos(0)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	event.EohSetPos(0, pos_x - 56.0, pos_y, pos_z)
	event.EohSetRot(0, 0.0, 0.0, 0.56)
	event.EohSyncObj(0, "p01_train01", "train07-m2")
	do
		local out1, out2, out3 = event.EohGetPos(0)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	event.EohSetPos(0, pos_x - 56.0, pos_y, pos_z)
	event.EohSetRot(0, 0.0, 0.0, 0.56)
	event.EohSyncObj(0, "p01_train01", "train07-m3")
	do
		local out1, out2, out3 = event.EohGetPos(0)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	event.EohSetPos(0, pos_x + 56.0, pos_y, pos_z)
	event.EohSetRot(0, 0.0, 3.1415927, -0.56)
	event.EohSyncObj(0, "p01_train01", "train07-m4")
	do
		local out1, out2, out3 = event.EohGetPos(0)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	event.EohSetPos(0, pos_x + 56.0, pos_y, pos_z)
	event.EohSetRot(0, 0.0, 3.1415927, -0.56)
	event.EohSyncObj(0, "p01_train01", "train07-m5")
	do
		local out1, out2, out3 = event.EohGetPos(0)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	event.EohSetPos(0, pos_x + 56.0, pos_y, pos_z)
	event.EohSetRot(0, 0.0, 3.1415927, -0.56)
	event.EohSyncObj(0, "p01_train01", "train02-a0")
	event.EohSetShow(0, 1)
	event.EohSyncObj(0, "p01_train01", "train02-a1")
	event.EohSetShow(0, 1)
	event.EohSyncObj(0, "p01_train01", "train02-a2")
	event.EohSetShow(0, 1)
	event.EohSyncObj(0, "p01_train01", "train02-a3")
	event.EohSetShow(0, 1)
	event.EohSyncObj(0, "p01_train01", "train02-a4")
	event.EohSetShow(0, 1)
	event.EohSyncObj(0, "p01_train01", "train02-a5")
	event.EohSetShow(0, 1)
end

--- Helper function.
local function helper_44ac8()
	local flag: s32 = 0
	print("map_init-------------------------\n")
	flag = event.GetFlag(280) or flag
	if flag ~= 0 then
		helper_255e4()
	end
	helper_e34c()
	helper_ed22addb()
	helper_d4172c24()
end

--- Helper function.
local function helper_3f33c()
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		global0 = 0
		global1 = 32
		global0 = 32
		global1 = 0
	end
	if vm.skipping() then
		return skip(1)
	end
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		global0 = 0
		global1 = 32
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.EohSyncChara(0, global0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global0)
		event.LoadChara(5, "chara/c02_base.gltf", "info", global1)
		event.LoadEquip(5, 1, 4, "info", global1)
		event.LoadEquip(5, 1, 3, "info", global1)
		event.LoadEquip(5, 1, 2, "info", global1, 38)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.LoadMotion(5, "event/e200/e254/e254_monica.gltf", "info", global1)
		event.EohSyncChara(1, global1)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global1)
		event.CharaActive(1, 38)
	end
	if active_chr_no == 1 then
		global0 = 32
		global1 = 0
		event.LoadChara(5, "chara/c01_base.gltf", "info", global0)
		event.LoadEquip(5, 0, 4, "info", global0)
		event.LoadEquip(5, 0, 3, "info", global0)
		event.LoadEquip(5, 0, 2, "info", global0, 38)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.EohSyncChara(0, global0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global0)
		event.CharaActive(1, 38)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.LoadMotion(5, "event/e200/e254/e254_monica.gltf", "info", global1)
		event.EohSyncChara(1, global1)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global1)
	end
	event.EohSyncChara(2, 1)
	event.EohSetShow(2, 0)
	event.EohSyncChara(3, 2)
	event.EohSetShow(3, 0)
	event.LoadChara(5, "event/e200/e254/e254_conda.gltf", "info", 36)
	event.CharaActive(0, 36)
	event.EohSyncChara(4, 36)
	event.ObjsInit(3, 36)
	event.ObjsSyncObj(3, 4)
	event.LoadMes(0, 5, "event/e200/e254/e254.txt")
end

--- Helper function.
local function helper_7d0c(arg0: any, arg1: s32, arg2: s32)
	local var3: s32 = 0
	local var4: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var4 = 0
			var3 = helper_cd0e70ce(arg0, arg1)
			arg2 = 0
			arg2 = 1
			arg2 = 1
			var4 = var4 + 1
		end
		var4 = vm.i32(var4 + 1)
		return var4, arg2
	end
	if vm.skipping() then
		return skip(1)
	end
	event.TrgPakuAnim(1)
	event.TrgPakuMotion(0)
	var4 = 0
	while true do
		var3 = helper_cd0e70ce(arg0, arg1)
		if var3 ~= 0 then
			arg2 = 0
			if arg1 == 1 and var3 == 2 then
				arg2 = 1
			end
			if arg1 == 2 and var3 == 3 then
				arg2 = 1
			end
			var4 = vm.i32(var4 + 1)
			break
		else
			if vm.wait() then
				return skip(2)
			end
			var4 = vm.i32(var4 + 1)
		end
	end
	event.ResetPakuMotion()
	event.TrgPakuAnim(0)
	event.ResetPakuAnim()
	return var4, arg2
end

--- Helper function.
local function helper_87d4(arg0: s32, arg1: any, arg2: s32, arg3: s32, arg4: s32)
	local var6: s32 = 0
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			local _ = helper_2913f82c(arg0, arg1, arg2, arg3, arg4)
			_, var6 = helper_7d0c(arg0, 0, var6)
		end
		helper_b72ef077(arg0)
	end
	if vm.skipping() then
		return skip(1)
	end
	local _ = helper_2913f82c(arg0, arg1, arg2, arg3, arg4)
	_, var6 = helper_7d0c(arg0, 0, var6)
	if vm.skipping() then
		return skip(2)
	end
	helper_b72ef077(arg0)
end

--- Helper function.
local function helper_3efc8()
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
		event.DelExtMotion(global1)
		event.DeleteChara(global1)
		event.DeleteChara(38)
	end
	if active_chr_no == 1 then
		event.CharaActive(1, global1)
		event.CharaActive(0, global0)
		event.DelExtMotion(global1)
		event.DeleteChara(global0)
		event.DeleteChara(38)
	end
	event.EohSyncChara(2, 1)
	event.EohSetShow(2, 1)
	event.EohSyncChara(3, 2)
	event.EohSetShow(3, 1)
	event.DeleteChara(36)
end

--- Helper function.
local function helper_40070()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 15 then
			if at <= 1 then
				helper_79c09698(4)
			end
			if at <= 2 then
				helper_3f33c()
				helper_fd4e9f5c(0, 1)
				helper_79c09698(30)
			end
			if at <= 3 then
				helper_79c09698(135)
			end
			if at <= 4 then
				helper_87d4(0, -1, 2, 256, 416)
			end
			if at <= 5 then
				helper_79c09698(15)
			end
			if at <= 6 then
				helper_87d4(0, -1, 7, 341, 208)
			end
			if at <= 7 then
				helper_87d4(0, -1, 8, 341, 208)
			end
			if at <= 8 then
				helper_79c09698(45)
			end
			if at <= 9 then
				helper_79c09698(45)
			end
			if at <= 10 then
				helper_79c09698(8)
			end
			if at <= 11 then
				helper_79c09698(22)
			end
			if at <= 12 then
				helper_79c09698(30)
			end
			if at <= 13 then
				helper_79c09698(30)
			end
			if at <= 14 then
				helper_79c09698(30)
			end
			if vm.skip_end() then
				return skip(16)
			end
			return part2()
		end
		helper_3efc8()
	end
	function part2()
		event.CancelDramaScene()
		event.SetStatus(1, global0, 8, 0)
		event.SetStatus(1, global1, 8, 0)
		helper_3efc8()
		event.Finish()
		event.BgmLoadCancel()
	end
	event.SetFlag(254, 1)
	event.Initialize()
	event.SetFadeOut(30)
	helper_79c09698(30)
	if vm.skipping() then
		return skip(1)
	end
	event.StopBgm(0)
	helper_79c09698(4)
	if vm.skipping() then
		return skip(2)
	end
	event.LoadBgm(49)
	helper_3f33c()
	helper_fd4e9f5c(0, 1)
	event.InitDramaScene()
	event.PlayBgm(0)
	event.CmrsInit()
	event.CmrsSetPos(-585.93, 175.94, -940.12)
	event.CmrsSetRef(-702.67, 128.67, -892.92)
	event.CmrsMove(-565.48, 108.18, -866.56, -690.38, 73.25, -848.03, 165)
	event.CharaActive(1, global0)
	event.CharaActive(1, global1)
	event.CharaActive(1, 38)
	event.CharaActive(1, 36)
	event.SetStatus(1, global0, 8, 1)
	event.SetStatus(1, global1, 8, 1)
	event.ObjsSetPos(0, -1285.55, 14.1, -942.2)
	event.ObjsSetMotion(0, "走り", 4)
	event.ObjsReference(0, -749.29, 0.0, -826.86, 1)
	event.ObjsMove(0, -749.29, 0.0, -826.86, 165, 1)
	event.EohSetFootSoundId(0, 1)
	event.SetFadeIn(30)
	helper_79c09698(30)
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsSetPos(1, -1285.55, 14.1, -942.2)
	event.ObjsSetMotion(1, "走り", 4)
	event.ObjsReference(1, -767.89, 0.0, -768.84, 1)
	event.ObjsMove(1, -767.89, 0.0, -768.84, 135, 1)
	event.EohSetFootSoundId(1, 1)
	helper_79c09698(135)
	if vm.skipping() then
		return skip(4)
	end
	event.EohSetFootSoundId(0, -1)
	event.EohSetFootSoundId(1, -1)
	event.SetStatus(1, global0, 8, 0)
	event.SetStatus(1, global1, 8, 0)
	event.CmrsInit()
	event.CmrsSetPos(-350.28, 3.09, -880.0)
	event.CmrsSetRef(-237.75, 35.02, -880.0)
	event.ObjsSetPos(3, -246.0, 0.0, -880.0)
	event.ObjsSetRot(3, 0.0, -1.57, 0.0)
	event.ObjsSetMotion(3, "おーい", 4)
	event.MesMake_2(0, "オ～イ")
	helper_87d4(0, -1, 2, 256, 416)
	if vm.skipping() then
		return skip(5)
	end
	event.CmrsSetPos(-269.42, 43.82, -641.43)
	event.CmrsSetRef(-355.67, 8.13, -699.39)
	event.ObjsSetPos(0, -424.81, 0.0, -640.72)
	event.ObjsReference(0, -354.91, 0.0, -694.75, 1)
	event.ObjsSetMotion(0, "走り", 4)
	event.EohSetFootSoundId(0, 1)
	event.ObjsSetPos(1, -399.05, 0.0, -634.81)
	event.ObjsReference(1, -359.19, 0.0, -671.7, 1)
	event.ObjsSetMotion(1, "歩き", 4)
	event.EohSetFootSoundId(1, 1)
	event.ObjsSetPos(3, -321.61, 0.0, -694.6)
	event.ObjsSetRot(3, 0.0, -1.61, 0.0)
	event.ObjsSetMotion(3, "立ち", 4)
	event.ObjsMove(0, -354.91, 0.0, -694.75, 45)
	event.ObjsRotDelay(0, 45)
	event.ObjsRotation(0, 0.0, 1.16, 0.0, 5)
	event.ObjsMotionDelay(0, 50)
	event.ObjsSetMotion(0, "立ち")
	helper_79c09698(15)
	if vm.skipping() then
		return skip(6)
	end
	event.ObjsMove(1, -359.19, 0.0, -671.7, 60)
	event.ObjsRotDelay(1, 60)
	event.ObjsRotation(1, 0.0, 1.87, 0.0, 5)
	event.ObjsMotionDelay(1, 65)
	event.ObjsSetMotion(1, "立ち")
	event.ObjsSetMotion(3, "会話2")
	event.MesMake_2(
		0,
		"オオ？ジオストーンを\n見つけたようじゃな。<page>では、カーペントリオンを使って、\n森をつくり変えてみるとするかの。"
	)
	helper_87d4(0, -1, 7, 341, 208)
	if vm.skipping() then
		return skip(7)
	end
	event.MesMake_2(0, "ついて来なされ。")
	helper_87d4(0, -1, 8, 341, 208)
	if vm.skipping() then
		return skip(8)
	end
	event.EohSetFootSoundId(4, 1)
	event.ObjsSetMotion(3, "歩き２")
	event.ObjsReference(3, -306.48, 0.0, -624.02, 45)
	helper_79c09698(45)
	if vm.skipping() then
		return skip(9)
	end
	event.ObjsMove(3, -306.48, 0.0, -624.02, 90)
	helper_79c09698(45)
	if vm.skipping() then
		return skip(10)
	end
	event.ObjsSetMotion(0, "走り")
	event.ObjsReference(0, -305.78, 0.0, -632.54, 8)
	helper_79c09698(8)
	if vm.skipping() then
		return skip(11)
	end
	event.ObjsMove(0, -305.78, 0.0, -632.54, 45)
	helper_79c09698(22)
	if vm.skipping() then
		return skip(12)
	end
	event.ObjsSetMotion(1, "歩き")
	event.ObjsReference(1, -351.88, 0.0, -630.2, 30)
	helper_79c09698(30)
	if vm.skipping() then
		return skip(13)
	end
	event.ObjsMove(1, -351.88, 0.0, -630.2, 45)
	helper_79c09698(30)
	if vm.skipping() then
		return skip(14)
	end
	event.SetFadeOut(30)
	helper_79c09698(30)
	if vm.skipping() then
		return skip(15)
	end
	return part2()
end

--- Helper function.
local function helper_2bb50()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_79c09698(60)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	event.CmrsSetPos(-625.66, 104.24, -868.06)
	event.CmrsSetRef(-903.96, 23.48, -831.72)
	event.CharaActive(1, 0)
	event.EohSyncChara(0, 0)
	event.EohSetFootSoundId(0, 1)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetPos(0, -1023.6, 0.0, -838.96)
	event.ObjsSetRot(0, 0.0, 1.58, 0.0)
	event.SetFadeIn(30)
	event.ObjsSetMotion(0, "走り", 4, -1.0, 1)
	event.ObjsMove(0, -778.4, 0.0, -836.7, 60)
	event.CmrsMove2(-625.66, 104.24, -868.06, -778.4, 20.0, -836.7, 48, 2, 0.4)
	helper_79c09698(60)
	if vm.skipping() then
		return skip(2)
	end
	event.ObjsSetMotion(0, "立ち", 4, -1.0, 1)
	event.ResetCamera(0)
end

--- Helper function.
local function helper_44928()
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	flag = event.GetFlag(207) or flag
	if flag == 0 then
		if vm.wait() then
			return skip(1)
		end
		event.LoadScript("s02/s02b.stb", 501)
		return
	end
end

--- Helper function.
local function helper_2b6c8()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	event.SetFadeOut(0)
	event.CmrsInit()
	event.CmrsSetPos(-971.07, 66.21, -121.97)
	event.CmrsSetRef(-826.79, 21.3, 58.4)
	event.EohSyncChara(0, 0)
	event.EohSetFootSoundId(0, 1)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetPos(0, -949.3, 0.0, 34.7)
	event.ObjsSetRot(0, 0.0, 1.36, 0.0)
	event.ObjsSetMotion(0, "走り", 4)
	event.ObjsMove(0, -806.69, 0.0, 85.01, 60)
	event.CmrsFadeInit()
	event.CmrsFadeIn(30, 0.0, 0.0, 0.0)
	helper_79c09698(60)
	if vm.skipping() then
		return skip(1)
	end
	event.ObjsSetMotion(0, "立ち", 4)
	event.ResetCamera(0)
end

--- Helper function.
local function helper_1acc0(arg0: s32, arg1: s32, arg2: s32)
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
local function helper_1c480()
	local var0: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		print("station_id=", var0, ",train_id=", var1, ",lr_id=", var2, "\n")
		helper_1acc0(var0, var1, var2)
	end
	if vm.skipping() then
		return skip(1)
	end
	var0 = event.GetCnt(1) or var0
	var1 = event.GetCnt(0) or var1
	var2 = event.GetCnt(15) or var2
	print("station_id=", var0, ",train_id=", var1, ",lr_id=", var2, "\n")
	helper_1acc0(var0, var1, var2)
end

--- Helper function.
local function helper_fc88()
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
local function helper_fffc()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			print("slope-------------------off\t\n")
		end
		helper_fc88()
	end
	if vm.skipping() then
		return skip(1)
	end
	print("slope-------------------off\t\n")
	event.EohSyncObj(0, "p01_train01", "train07-m0")
	do
		local out1, out2, out3 = event.EohGetPos(0)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	event.EohSetPos(0, pos_x + 56.0, pos_y, pos_z)
	event.EohSetRot(0, 0.0, 0.0, 0.0)
	event.EohSyncObj(0, "p01_train01", "train07-m1")
	do
		local out1, out2, out3 = event.EohGetPos(0)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	event.EohSetPos(0, pos_x + 56.0, pos_y, pos_z)
	event.EohSetRot(0, 0.0, 0.0, 0.0)
	event.EohSyncObj(0, "p01_train01", "train07-m2")
	do
		local out1, out2, out3 = event.EohGetPos(0)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	event.EohSetPos(0, pos_x + 56.0, pos_y, pos_z)
	event.EohSetRot(0, 0.0, 0.0, 0.0)
	event.EohSyncObj(0, "p01_train01", "train07-m3")
	do
		local out1, out2, out3 = event.EohGetPos(0)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	event.EohSetPos(0, pos_x - 56.0, pos_y, pos_z)
	event.EohSetRot(0, 0.0, 0.0, 0.0)
	event.EohSyncObj(0, "p01_train01", "train07-m4")
	do
		local out1, out2, out3 = event.EohGetPos(0)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	event.EohSetPos(0, pos_x - 56.0, pos_y, pos_z)
	event.EohSetRot(0, 0.0, 0.0, 0.0)
	event.EohSyncObj(0, "p01_train01", "train07-m5")
	do
		local out1, out2, out3 = event.EohGetPos(0)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	event.EohSetPos(0, pos_x - 56.0, pos_y, pos_z)
	event.EohSetRot(0, 0.0, 0.0, 0.0)
	if vm.wait() then
		return skip(2)
	end
	helper_fc88()
end

--- Helper function.
local function helper_261b8()
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.CharaActive(0, 8)
	event.CharaActive(0, 9)
	event.CharaActive(0, 10)
end

--- Helper function.
local function helper_18d4(arg0: f32, arg1: f32, arg2: f32, arg3: f32)
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.SetCharaPos(0, arg0, arg1, arg2)
	event.SetCharaRot(0, 0.0, arg3, 0.0)
	event.SetMotion(0, "立ち", 4)
	event.CharaNormalDrive(0)
	event.CharaResetDa(0)
end

--- Helper function.
local function helper_260cc()
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.CharaActive(1, 8)
	event.CharaActive(1, 9)
	event.CharaActive(1, 10)
end

--- Helper function.
local function helper_28ec8()
	local flag: s32 = 0
	local time: f32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 8 then
			if at <= 1 then
				helper_fffc()
			end
			if at <= 2 then
				helper_261b8()
				helper_d4f8509e(1)
			end
			if at <= 3 then
				helper_79c09698(10)
			end
			if at <= 4 then
				helper_e34c()
				helper_79c09698(15)
			end
			if at <= 5 then
				helper_79c09698(15)
			end
			if at <= 6 then
				helper_79c09698(40)
			end
			if at <= 7 then
				helper_79c09698(10)
			end
			if vm.skip_end() then
				return skip(9)
			end
			return part2()
		end
		helper_18d4(-130.0, 0.0, -366.0, vm.f32(-1.57))
		helper_e34c()
		helper_260cc()
	end
	function part2()
		event.CancelDramaScene()
		event.SetMpcharaMotion("p01_train01", "kikan-m0", "停止")
		event.CmrsInit()
		event.SndSeStop(var2, 0)
		event.EsmClear()
		event.EohSetPos(1, 1.3, 8.0, 700.0)
		event.EohSetRot(2, 0.0, 0.0, 0.0)
		event.EohSetRot(3, 0.0, 0.0, 0.0)
		event.EohSetRot(4, 0.0, 0.0, 0.0)
		event.EohSetRot(5, 0.0, 0.0, 0.0)
		event.EohSetRot(6, 0.0, 0.0, 0.0)
		event.EohSetRot(7, 0.0, 0.0, 0.0)
		event.EohSetShow(9, 1)
		event.CharaActive(1, 0)
		helper_18d4(-130.0, 0.0, -366.0, vm.f32(-1.57))
		event.SetCameraRef(-130.0, 30.0, -366.0)
		event.SetCameraPos(-270.0, 40.0, -366.0)
		flag = event.GetFlag(30) or flag
		if flag == 0 then
			helper_e34c()
		end
		helper_260cc()
		event.SetFadeIn(15)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	event.SetFlag(30, 0)
	helper_fffc()
	if vm.skipping() then
		return skip(2)
	end
	helper_261b8()
	event.AssignStack(5)
	event.ClearStack(5)
	var2 = event.SndLoadSound(8, "snd2/sp/sp_018.sound.json") or var2
	event.SndSePlay(var2, 0)
	event.EohSyncChara(0, 0)
	event.EohSetFootSoundId(0, 6)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetPos(0, 0.0, 0.0, 0.0)
	event.ObjsSetRot(0, 0.0, 0.0, 0.0)
	event.CharaActive(0, 0)
	time = event.GetTime() or time
	if time > 0.0 and time < 5.5 then
		event.EohSetShadow(0, 0)
	end
	event.EohSyncObj(1, "p01_train01")
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.ObjsSetPos(1, 1.3, 8.0, 500.0)
	event.ObjsSetRot(1, 0.0, 0.0, 0.0)
	event.EohSyncObj(9, "p01_shadow-0")
	event.EohSetShow(9, 0)
	event.EohSyncObj(2, "p01_train01", "train08-m6")
	event.ObjsSyncObj(2, 2)
	event.ObjsSetRot(2, 0.0, 0.0, 0.0)
	event.EohSyncObj(3, "p01_train01", "train08-m7")
	event.ObjsSyncObj(3, 3)
	event.ObjsSetRot(3, 0.0, 0.0, 0.0)
	event.EohSyncObj(4, "p01_train01", "train10-m18")
	event.ObjsSyncObj(4, 4)
	event.ObjsSetRot(4, 0.0, 0.0, 0.0)
	event.EohSyncObj(5, "p01_train01", "train10-m19")
	event.ObjsSyncObj(5, 5)
	event.ObjsSetRot(5, 0.0, 0.0, 0.0)
	event.EohSyncObj(6, "p01_train01", "train10-m6")
	event.ObjsSyncObj(6, 6)
	event.EohSyncObj(7, "p01_train01", "train10-m7")
	event.ObjsSyncObj(7, 7)
	event.EsmInitialize(5)
	event.EsmLoadBase("列車煙")
	event.EsmInitFix(5)
	event.EohSyncObj(8, "p01_train01")
	event.EsmCreate("列車煙")
	event.EsmSetValue(0, 8)
	event.SetMpcharaMotion("p01_train01", "kikan-m0", "機関")
	event.CmrsInit()
	event.CmrsSetPos(-185.19, 68.62, 1049.53)
	event.CmrsSetRef(140.3, 63.52, 109.43)
	event.SetFadeIn(30)
	event.InitDramaScene()
	event.ObjsMove2(1, 1.3, 8.0, 700.0, 40, 2, 1.0)
	helper_d4f8509e(1)
	if vm.skipping() then
		return skip(3)
	end
	helper_79c09698(10)
	if vm.skipping() then
		return skip(4)
	end
	event.SetCrossfade(30)
	event.EohSetPos(1, 1.3, 8.0, 700.0)
	helper_e34c()
	event.SetFlag(30, 1)
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.CmrsSetPos(-254.85, 60.24, -455.84)
	event.CmrsSetRef(-89.19, 67.53, -382.63)
	event.CharaActive(1, 0)
	event.ObjsSetPos(0, -40.0, 45.6, -366.0)
	event.ObjsSetRot(0, 0.0, -1.56, 0.0)
	helper_79c09698(15)
	if vm.skipping() then
		return skip(5)
	end
	var3 = event.GetSndId(2) or var3
	event.SndSePlay(var3, 106)
	event.ObjsRotation(2, 0.0, -1.5, 0.0, 30)
	event.ObjsRotation(3, 0.0, 1.5, 0.0, 30)
	event.ObjsRotation(4, 0.0, 1.5, 0.0, 30)
	event.ObjsRotation(5, 0.0, -1.5, 0.0, 30)
	event.ObjsRotation(6, 0.0, -1.5, 0.0, 30)
	event.ObjsRotation(7, 0.0, 1.5, 0.0, 30)
	helper_79c09698(15)
	if vm.skipping() then
		return skip(6)
	end
	event.ObjsSetMotion(0, "走り", 0, -1.0, 1)
	event.ObjsMotionDelay(0, 40)
	event.ObjsSetMotion(0, "立ち")
	event.ObjsMove(0, -68.89, 43.64, -366.0, 10)
	event.ObjsMove(0, -131.89, 0.0, -366.0, 30)
	helper_79c09698(40)
	if vm.skipping() then
		return skip(7)
	end
	event.SetFadeOut(10)
	helper_79c09698(10)
	if vm.skipping() then
		return skip(8)
	end
	return part2()
end

--- Helper function.
local function helper_27ae8()
	local var0: s32 = 0
	local time: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var5: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_261b8()
			helper_d4f8509e(1)
		end
		if at <= 2 then
			helper_79c09698(10)
		end
		if at <= 3 then
			helper_79c09698(30)
		end
		if at <= 4 then
			helper_79c09698(20)
		end
		if at <= 5 then
			helper_d4f8509e(0)
		end
		if at <= 6 then
			helper_79c09698(10)
		end
		helper_18d4(-130.0, 0.0, -365.0, vm.f32(-1.57))
		helper_260cc()
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	var0 = event.SndLoadSound(8, "snd2/sp/sp_019.sound.json") or var0
	helper_261b8()
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.CharaActive(0, 0)
	time = event.GetTime() or time
	if time > 0.0 and time < 5.5 then
		event.EohSetShadow(0, 0)
	end
	event.EohSyncObj(1, "p01_train01")
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.ObjsSetPos(1, 1.3, 8.0, 500.0)
	event.ObjsSetRot(1, 0.0, 0.0, 0.0)
	event.EohSyncObj(6, "p01_shadow-0")
	event.EohSetShow(6, 0)
	event.EohSyncObj(2, "p01_train01", "s3601_12-m4")
	event.ObjsSyncObj(2, 2)
	event.ObjsSetRot(2, 0.0, 0.0, 0.0)
	event.EohSyncObj(3, "p01_train01", "s3601_14-m2")
	event.ObjsSyncObj(3, 3)
	event.ObjsSetRot(3, 0.0, 0.0, 0.0)
	event.EohSyncObj(4, "p01_train01", "s3601_16-m2")
	event.ObjsSyncObj(4, 4)
	event.ObjsSetRot(4, 0.0, 0.0, 0.0)
	event.EohSyncObj(5, "p01_train01", "s3601_17-m3")
	do
		local out1, out2, out3 = event.EohGetPos(5)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	event.ObjsSyncObj(5, 5)
	event.ObjsSetRot(5, 0.0, 0.0, 0.0)
	event.CmrsInit()
	event.CmrsSetPos(-185.19, 68.62, 1049.53)
	event.CmrsSetRef(140.3, 63.52, 109.43)
	event.SetFadeIn(30)
	event.ObjsMove2(1, 1.3, 8.0, 700.0, 40, 2, 1.0)
	event.SndSePlay(var0, 0)
	helper_d4f8509e(1)
	if vm.skipping() then
		return skip(2)
	end
	helper_79c09698(10)
	if vm.skipping() then
		return skip(3)
	end
	event.SetCrossfade(30)
	event.CmrsSetPos(-254.85, 60.24, -455.84)
	event.CmrsSetRef(-89.19, 67.53, -382.63)
	event.EohSetPos(1, 1.3, 8.0, 700.0)
	event.CharaActive(0)
	event.ObjsSetPos(0, -20.0, 40.0, -365.0)
	event.ObjsSetRot(0, 0.0, -1.57, 0.0)
	event.ObjsRotation(2, 0.0, 0.0, -1.5707964, 30)
	event.ObjsRotation(3, 0.0, 0.0, -1.5707964, 30)
	event.ObjsRotation(4, 0.0, 0.0, 0.3926991, 30)
	event.ObjsRotation(5, 0.0, 0.0, 0.3926991, 30)
	var5 = event.GetSndId(2) or var5
	event.SndSePlay(var5, 92)
	helper_79c09698(30)
	if vm.skipping() then
		return skip(4)
	end
	event.ObjsMove(5, pos_x - 22.5, pos_y - 9.5, pos_z, 30)
	helper_79c09698(20)
	if vm.skipping() then
		return skip(5)
	end
	event.ObjsMove(0, -130.0, 0.0, -365.0, 30)
	event.ObjsSetMotion(0, "走り", 4)
	event.EohSetFootSoundId(0, 6)
	helper_d4f8509e(0)
	if vm.skipping() then
		return skip(6)
	end
	event.EohSetFootSoundId(0, 0)
	event.ObjsSetMotion(0, "立ち")
	helper_79c09698(10)
	if vm.skipping() then
		return skip(7)
	end
	event.SetFadeIn(1)
	event.EohSetPos(1, 1.3, 8.0, 700.0)
	event.EohSetRot(1, 0.0, 0.0, 0.0)
	event.EohSetRot(2, 0.0, 0.0, 0.0)
	event.EohSetRot(3, 0.0, 0.0, 0.0)
	event.EohSetRot(4, 0.0, 0.0, 0.0)
	event.EohSetPos(5, pos_x, pos_y, pos_z)
	event.EohSetRot(5, 0.0, 0.0, 0.0)
	event.EohSetShow(6, 1)
	event.CharaActive(0)
	helper_18d4(-130.0, 0.0, -365.0, vm.f32(-1.57))
	event.CharaNormalDrive(0)
	event.CharaResetDa(0)
	event.SetCameraRef(-130.0, 30.0, -366.0)
	event.SetCameraPos(-270.0, 40.0, -366.0)
	helper_260cc()
	event.SetFadeIn(15)
end

--- Helper function.
local function helper_d2c(arg0: s32)
	local get_pad_down: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		return vm.i32(bit32.band(get_pad_down, arg0))
	end
	if vm.skipping() then
		return skip(1)
	end
	get_pad_down = event.GetPaddown() or get_pad_down
	return vm.i32(bit32.band(get_pad_down, arg0))
end

--- Helper function.
local function helper_f30(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			local _ = helper_d2c(arg0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	while true do
		if helper_d2c(arg0) ~= 0 then
			break
		else
			if vm.wait() then
				return skip(2)
			end
		end
	end
end

--- Helper function.
local function helper_6d2c(arg0: s32)
	local var1: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	var1 = event.GetMesStatus(arg0) or var1
	while var1 == 0 or var1 == 1 do
		if vm.wait() then
			return skip(2)
		end
		var1 = event.GetMesStatus(arg0) or var1
	end
end

--- Helper function.
local function helper_6a6c(arg0: s32)
	local var1: s32 = 0
	local get_lxf: f32 = 0
	local get_lyf: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		return -1
	end
	if vm.skipping() then
		return skip(1)
	end
	var1 = event.GetMesWindowMode(arg0) or var1
	do
		local out1, out2, _, _ = event.GetApad_4()
		get_lxf = out1 or get_lxf
		get_lyf = out2 or get_lyf
	end
	if var1 == 5 then
		if get_lxf < -0.5 then
			return -1
		end
		if 0.5 < get_lxf then
			return 1
		end
	else
		if get_lyf < -0.5 then
			return -1
		end
		if 0.5 < get_lyf then
			return 1
		end
	end
	return 0
end

--- Helper function.
local function helper_6e84(arg0: s32, arg1: any, arg2: any, arg3: s32)
	local var4: s32 = 0
	local get_pad_down: s32 = 0
	local var6: s32 = 0
	local var7: s32 = 0
	local var8: s32 = 0
	local pressed: s32 = 0
	local pressed_2: s32 = 0
	local var11: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 4 then
			if at <= 1 then
				var8 = 0
				var7 = 0
				var6 = 0
				helper_6d2c(arg0)
			end
			if at <= 2 then
				var8 = 0
				var7 = helper_6a6c(arg0)
				var8 = -1
				var8 = 1
				var6 = var7
				var8 = -1
				var8 = 1
				var8 = -1
				var8 = 1
			end
			helper_b72ef077(arg0)
			return -1
		end
		helper_b72ef077(arg0)
		return arg2
	end
	if vm.skipping() then
		return skip(1)
	end
	var4 = event.GetMesQuestionGyou(arg0) or var4
	event.SetMesDrawspeed(arg0, 0.0)
	var8 = 0
	var7 = 0
	var6 = 0
	event.SetMesCursor(arg0, -1)
	event.SetMesCursor(arg0, arg2)
	helper_6d2c(arg0)
	if vm.skipping() then
		return skip(2)
	end
	while true do
		var8 = 0
		var7 = helper_6a6c(arg0)
		if var6 == 0 and var7 == -1 then
			event.MesSePlay(2)
			var8 = -1
		end
		if var6 == 0 and var7 == 1 then
			event.MesSePlay(2)
			var8 = 1
		end
		var6 = var7
		pressed = event.CheckButton(0) or pressed
		pressed_2 = event.CheckButton(1) or pressed_2
		get_pad_down = event.GetPaddown() or get_pad_down
		var11 = event.GetMesWindowMode(arg0) or var11
		if var11 == 5 then
			if bit32.band(get_pad_down, 32768) ~= 0 then
				event.MesSePlay(2)
				var8 = -1
			end
			if bit32.band(get_pad_down, 8192) ~= 0 then
				event.MesSePlay(2)
				var8 = 1
			end
		else
			if bit32.band(get_pad_down, 4096) ~= 0 then
				event.MesSePlay(2)
				var8 = -1
			end
			if bit32.band(get_pad_down, 16384) ~= 0 then
				event.MesSePlay(2)
				var8 = 1
			end
		end
		if pressed_2 ~= 0 then
			event.MesSePlay(3)
			if vm.wait() then
				return skip(3)
			end
			break
		else
			if pressed ~= 0 then
				event.MesSePlay(1)
				if vm.wait() then
					return skip(4)
				end
				if arg3 == 0 then
					helper_b72ef077(arg0)
					return -1
				end
			end
			if var8 == 1 then
				if arg2 < vm.wrap(vm.wrap(arg1 - 1) + var4) then
					arg2 = vm.wrap(arg2 + 1)
				else
					arg2 = vm.wrap(vm.wrap(arg1 - 1) + var4)
				end
			end
			if var8 == -1 then
				if var4 < arg2 then
					arg2 = arg2 - 1
				else
					arg2 = var4
				end
			end
			event.SetMesCursor(arg0, arg2)
			if vm.wait() then
				return skip(5)
			end
		end
	end
	helper_b72ef077(arg0)
	return arg2
end

--- Helper function.
local function helper_7b9c(arg0: s32, arg1: any, arg2: s32, arg3: s32, arg4: s32, arg5: s32, arg6: s32)
	local var8: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			local _ = helper_2913f82c(arg0, arg1, arg2, arg3, arg4)
			var8 = helper_6e84(arg0, arg5, arg6, 0)
		end
		return var8
	end
	if vm.skipping() then
		return skip(1)
	end
	local _ = helper_2913f82c(arg0, arg1, arg2, arg3, arg4)
	var8 = helper_6e84(arg0, arg5, arg6, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.SetMesPos(arg0, 0)
	return var8
end

--- Helper function.
local function helper_262a4()
	local var0: any = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_79c09698(30)
			end
			if at <= 2 then
				helper_79c09698(30)
			end
			return 1
		end
		var6 = var6 + 1
		return 0
	end
	event.Initialize()
	event.SetMesWindowMode(0, 5)
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.SetMotion(0, "立ち", 4)
	event.MesMake_2(0, "『シャーロット』に移動しますか？")
	var0 = helper_7b9c(0, -1, 8, 256, 208, 2, 1)
	if vm.skipping() then
		return skip(1)
	end
	if var0 == 0 then
		event.ObjsSetPos(0, -936.47, 0.0, -23.84)
		event.ObjsSetRot(0, 0.0, -1.65, 0.0)
		event.ObjsSetMotion(0, "走り", 4)
		event.CmrsInit()
		event.CmrsSetPos(-751.82, 79.08, -27.15)
		event.CmrsSetRef(-928.2, 36.53, -26.64)
		flag = event.GetFlag(207) or flag
		flag_2 = event.GetFlag(208) or flag_2
		if flag == 1 and flag_2 == 0 then
			event.BgmLoadCancel()
		end
		event.ObjsMove(0, -1142.09, 0.0, -28.24, 60)
		event.CmrsMove(-751.82, 79.08, -27.15, -921.16, 65.58, -20.12, 60)
		helper_79c09698(30)
		if vm.skipping() then
			return skip(2)
		end
		event.SetFadeOut(30)
		helper_79c09698(30)
		if vm.skipping() then
			return skip(3)
		end
		return 1
	end
	do
		local out1, out2, out3 = event.GetCharaPos(0)
		var3 = out1 or var3
		var4 = out2 or var4
		var5 = out3 or var5
	end
	var3 = vm.f32(var3 + vm.f32(30.0 * vm.sin(vm.f32(1.57))))
	var5 = vm.f32(var5 + vm.f32(30.0 * vm.cos(vm.f32(1.57))))
	event.ObjsSetMotion(0, "歩き", 4, -1.0, 1)
	event.ObjsRotation(0, 0.0, 1.57, 0.0, 15)
	event.ObjsMove(0, var3, var4, var5, 45)
	var6 = 0
	while var6 < 45 do
		do
			local out1, out2, out3 = event.GetCharaPos(0)
			var3 = out1 or var3
			var4 = out2 or var4
			var5 = out3 or var5
		end
		event.CmrsSetRef(var3, var4 + 30.0, var5)
		if vm.wait() then
			return skip(4)
		end
		var6 = var6 + 1
	end
	event.ObjsSetMotion(0, "立ち", 4, -1.0, 1)
	event.SetMesWindowMode(0, 7)
	return 0
end

--- Helper function.
local function helper_26ea4()
	local var0: any = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local angle: f32 = 0
	local var8: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_79c09698(30)
			end
			if at <= 2 then
				helper_79c09698(30)
			end
			return 1
		end
		var8 = var8 + 1
		return 0
	end
	event.Initialize()
	event.SetMesWindowMode(0, 5)
	event.SetMotion(0, "立ち", 4)
	event.MesMake_2(0, "『七色蝶の森』に移動しますか？")
	var0 = helper_7b9c(0, -1, 8, 256, 208, 2, 1)
	if vm.skipping() then
		return skip(1)
	end
	if var0 == 0 then
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.ObjsSetPos(0, -836.17, 0.0, -823.5)
		event.ObjsSetRot(0, 0.0, -1.66, 0.0)
		event.ObjsSetMotion(0, "走り", 4)
		event.CmrsInit()
		event.CmrsSetPos(-668.11, 97.09, -886.72)
		event.CmrsSetRef(-839.94, 44.81, -838.79)
		event.ObjsMove(0, -1044.71, 0.0, -836.63, 60)
		event.CmrsMove(-668.11, 97.09, -886.72, -881.32, 61.14, -861.93, 60)
		helper_79c09698(30)
		if vm.skipping() then
			return skip(2)
		end
		event.SetFadeOut(30)
		helper_79c09698(30)
		if vm.skipping() then
			return skip(3)
		end
		return 1
	end
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetMotion(0, "歩き", 4)
	do
		local out1, out2, out3 = event.GetCharaPos(0)
		var1 = out1 or var1
		var2 = out2 or var2
		var3 = out3 or var3
	end
	do
		local out1, out2, out3 = event.GetCharaRot(0)
		var4 = out1 or var4
		var5 = out2 or var5
		var6 = out3 or var6
	end
	angle = vm.f32(vm.f32(3.1415927) + var5)
	angle = event.AngleLimit(angle) or angle
	angle = vm.f32(1.5707964)
	var1 = vm.f32(var1 + vm.f32(30.0 * vm.sin(angle)))
	var3 = vm.f32(var3 + vm.f32(30.0 * vm.cos(angle)))
	event.ObjsRotation(0, var4, angle, var6, 15)
	event.ObjsMove(0, var1, var2, var3, 45)
	var8 = 0
	while var8 < 45 do
		do
			local out1, out2, out3 = event.GetCharaPos(0)
			var1 = out1 or var1
			var2 = out2 or var2
			var3 = out3 or var3
		end
		event.CmrsSetRef(var1, var2 + 30.0, var3)
		if vm.wait() then
			return skip(4)
		end
		var8 = var8 + 1
	end
	event.SetMesWindowMode(0, 7)
	return 0
end

--- Helper function.
local function helper_2c054()
	local var2: s32 = 0
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			helper_2bb50()
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.DngSetStageId(1)
	event.GotoMenu(3, 1)
	if vm.wait() then
		return skip(2)
	end
	do
		local _, _, out3, _ = event.GetMenuParam_4()
		var2 = out3 or var2
	end
	if vm.wait() then
		return skip(3)
	end
	if var2 == 0 then
		helper_2bb50()
		if vm.skipping() then
			return skip(4)
		end
	else
		if var2 == 6 then
			event.MapJump(-1, "s05", 100)
			if vm.wait() then
				return skip(5)
			end
			return
		end
		flag = event.GetFlag(212) or flag
		if var2 == 2 and flag == 0 or var2 == 14 then
			event.BgmLoadCancel()
		end
		event.GotoDng(1, var2, 1010)
	end
end

--- Helper function.
local function helper_1cdc4()
	local var0: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_fd4e9f5c(0, 1)
			return 0
		end
		if at <= 3 then
			helper_79c09698(15)
		end
		return 0
	end
	event.SetMotion(0, "立ち")
	event.Initialize()
	helper_fd4e9f5c(0, 4)
	event.MesMake_2(0, "中に入る\n出発する")
	var0 = helper_7b9c(0, -1, 5, 256, 208, 2, 0)
	if vm.skipping() then
		return skip(1)
	end
	if var0 == -1 then
		helper_fd4e9f5c(0, 1)
		return 0
	end
	if var0 == 1 then
		event.SetFadeOut(15)
		helper_79c09698(15)
		if vm.skipping() then
			return skip(2)
		end
		event.GotoMenu(19, 0)
		if vm.wait() then
			return skip(3)
		end
		event.SetFadeIn(15)
		helper_79c09698(15)
		if vm.skipping() then
			return skip(4)
		end
		return 0
	end
	return 1
end

--- Helper function.
local function helper_12c04()
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
			helper_79c09698(10)
		end
		if at <= 2 then
			helper_79c09698(20)
		end
		if at <= 3 then
			helper_79c09698(18)
		end
		if at <= 4 then
			helper_79c09698(12)
		end
		if at <= 5 then
			helper_79c09698(30)
		end
		if at <= 6 then
			helper_79c09698(10)
		end
		if at <= 7 then
			helper_79c09698(20)
		end
		if at <= 8 then
			helper_79c09698(18)
		end
		if at <= 9 then
			helper_79c09698(12)
		end
		if at <= 10 then
			helper_79c09698(30)
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
		helper_79c09698(10)
		if vm.skipping() then
			return skip(2)
		end
		event.ObjsRotation(1, 0.0, -4.9415927, 0.0, 30)
		event.ObjsRotation(2, 0.0, -4.9415927, 0.0, 30)
		event.ObjsRotation(3, 0.0, -4.9415927, 0.0, 30)
		helper_79c09698(20)
		if vm.skipping() then
			return skip(3)
		end
		event.ObjsSetMotion(0, "歩き")
		event.ObjsMove(0, -29.1, 1.38, -0.82, 30)
		event.ObjsMove(0, -50.41, 1.38, 0.05, 30)
		event.EohSetFootSoundId(0, 6)
		helper_79c09698(18)
		if vm.skipping() then
			return skip(4)
		end
		event.EohSetFootSoundId(0, 3)
		helper_79c09698(12)
		if vm.skipping() then
			return skip(5)
		end
		event.SetFadeOut(30)
		helper_79c09698(30)
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
		helper_79c09698(10)
		if vm.skipping() then
			return skip(7)
		end
		event.ObjsRotation(1, 0.0, -1.8, 0.0, 30)
		event.ObjsRotation(2, 0.0, -1.8, 0.0, 30)
		event.ObjsRotation(3, 0.0, -1.8, 0.0, 30)
		helper_79c09698(20)
		if vm.skipping() then
			return skip(8)
		end
		event.ObjsSetMotion(0, "歩き")
		event.ObjsMove(0, 29.1, 1.38, 0.82, 30)
		event.ObjsMove(0, 50.41, 1.38, -0.05, 30)
		event.EohSetFootSoundId(0, 6)
		helper_79c09698(18)
		if vm.skipping() then
			return skip(9)
		end
		event.EohSetFootSoundId(0, 3)
		helper_79c09698(12)
		if vm.skipping() then
			return skip(10)
		end
		event.SetFadeOut(30)
		helper_79c09698(30)
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
local function helper_14354(arg0: s32)
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
			helper_79c09698(10)
		end
		if at <= 2 then
			helper_79c09698(20)
		end
		if at <= 3 then
			helper_79c09698(18)
		end
		if at <= 4 then
			helper_79c09698(12)
		end
		if at <= 5 then
			helper_79c09698(30)
		end
		if at <= 6 then
			helper_79c09698(10)
		end
		if at <= 7 then
			helper_79c09698(20)
		end
		if at <= 8 then
			helper_79c09698(18)
		end
		if at <= 9 then
			helper_79c09698(12)
		end
		if at <= 10 then
			helper_79c09698(30)
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
		helper_79c09698(10)
		if vm.skipping() then
			return skip(2)
		end
		event.ObjsRotation(1, 0.0, 1.5, 0.0, 30)
		event.ObjsRotation(2, 0.0, -1.5, 0.0, 30)
		event.ObjsRotation(3, 0.0, 1.5, 0.0, 30)
		event.ObjsRotation(4, 0.0, -1.5, 0.0, 30)
		event.ObjsRotation(5, 0.0, 1.5, 0.0, 30)
		event.ObjsRotation(6, 0.0, -1.5, 0.0, 30)
		helper_79c09698(20)
		if vm.skipping() then
			return skip(3)
		end
		event.ObjsSetMotion(0, "歩き")
		event.ObjsMove(0, -5.04, var5, 0.84, 30)
		event.ObjsMove(0, -33.49, var6, -0.56, 30)
		event.EohSetFootSoundId(0, var14)
		helper_79c09698(18)
		if vm.skipping() then
			return skip(4)
		end
		event.EohSetFootSoundId(0, 4)
		helper_79c09698(12)
		if vm.skipping() then
			return skip(5)
		end
		event.SetFadeOut(30)
		helper_79c09698(30)
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
		helper_79c09698(10)
		if vm.skipping() then
			return skip(7)
		end
		event.ObjsRotation(1, 0.0, -1.5, 0.0, 30)
		event.ObjsRotation(2, 0.0, 1.5, 0.0, 30)
		event.ObjsRotation(3, 0.0, -1.5, 0.0, 30)
		event.ObjsRotation(4, 0.0, 1.5, 0.0, 30)
		event.ObjsRotation(5, 0.0, -1.5, 0.0, 30)
		event.ObjsRotation(6, 0.0, 1.5, 0.0, 30)
		helper_79c09698(20)
		if vm.skipping() then
			return skip(8)
		end
		event.ObjsSetMotion(0, "歩き")
		event.ObjsMove(0, 5.04, var5, -0.84, 30)
		event.ObjsMove(0, 33.49, var6, 0.56, 30)
		event.EohSetFootSoundId(0, var14)
		helper_79c09698(18)
		if vm.skipping() then
			return skip(9)
		end
		event.EohSetFootSoundId(0, 4)
		helper_79c09698(12)
		if vm.skipping() then
			return skip(10)
		end
		event.SetFadeOut(30)
		helper_79c09698(30)
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
local function helper_17304()
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
			helper_79c09698(10)
		end
		if at <= 2 then
			helper_79c09698(20)
		end
		if at <= 3 then
			helper_79c09698(30)
		end
		if at <= 4 then
			helper_79c09698(20)
		end
		if at <= 5 then
			helper_79c09698(10)
		end
		if at <= 6 then
			helper_79c09698(20)
		end
		if at <= 7 then
			helper_79c09698(30)
		end
		if at <= 8 then
			helper_79c09698(20)
		end
		if at <= 9 then
			helper_79c09698(10)
		end
		if at <= 10 then
			var16 = 0
			print("てつのあしおと\n")
			var16 = 6
			print("いしのあしおと\n")
			var16 = 2
			helper_79c09698(30)
		end
		if at <= 11 then
			helper_79c09698(30)
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
	helper_79c09698(10)
	if vm.skipping() then
		return skip(2)
	end
	if vm.imod(var5, 2) ~= 1 then
		event.ObjsRotation(2, 0.0, 0.0, 1.5707964, 30)
		event.ObjsRotation(3, 0.0, 0.0, 1.5707964, 30)
		if now_map_no == 83 or now_map_no == 54 or now_map_no == 34 then
			helper_79c09698(20)
			if vm.skipping() then
				return skip(3)
			end
		else
			event.ObjsRotation(4, 0.0, 0.0, -0.3926991, 30)
			event.ObjsRotation(5, 0.0, 0.0, -0.3926991, 30)
			helper_79c09698(30)
			if vm.skipping() then
				return skip(4)
			end
			if now_map_no == 103 then
				event.ObjsMove(5, pos_x + 45.0, pos_y - 19.0, pos_z, 30)
				helper_79c09698(20)
				if vm.skipping() then
					return skip(5)
				end
			else
				event.ObjsMove(5, pos_x + 20.0, pos_y - 8.0, pos_z, 20)
				helper_79c09698(10)
				if vm.skipping() then
					return skip(6)
				end
			end
		end
	else
		event.ObjsRotation(2, 0.0, 0.0, -1.5707964, 30)
		event.ObjsRotation(3, 0.0, 0.0, -1.5707964, 30)
		if now_map_no == 83 or now_map_no == 54 or now_map_no == 34 then
			helper_79c09698(20)
			if vm.skipping() then
				return skip(7)
			end
		else
			event.ObjsRotation(4, 0.0, 0.0, 0.3926991, 30)
			event.ObjsRotation(5, 0.0, 0.0, 0.3926991, 30)
			helper_79c09698(30)
			if vm.skipping() then
				return skip(8)
			end
			if now_map_no == 103 then
				event.ObjsMove(5, pos_x - 45.0, pos_y - 19.0, pos_z, 30)
				helper_79c09698(20)
				if vm.skipping() then
					return skip(9)
				end
			else
				event.ObjsMove(5, pos_x - 20.0, pos_y - 8.0, pos_z, 20)
				helper_79c09698(10)
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
	helper_79c09698(30)
	if vm.skipping() then
		return skip(11)
	end
	event.SetFadeOut(30)
	helper_79c09698(30)
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
local function helper_e1d8()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			helper_79c09698(10)
		end
	end
	event.Initialize()
	event.SetMotion(0, "立ち")
	event.SetFadeOut(10)
	helper_79c09698(10)
	if vm.skipping() then
		return skip(1)
	end
	event.GotoMenu(7)
	if vm.wait() then
		return skip(2)
	end
	event.SetFadeIn(10)
	helper_79c09698(10)
	if vm.skipping() then
		return skip(3)
	end
end

--- Helper function.
local function helper_9024(arg0: s32, arg1: any, arg2: any)
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
	function skip(at: number)
		if at <= 1 then
			var27 = var10
			var28 = var15
			angle = vm.f32(var28 - var27)
			var30 = var13
			var31 = var16
			angle_2 = vm.f32(var31 - var30)
			var33 = 0.0
			var34 = vm.f32(helper_69020fbe(helper_06269a50(angle), helper_06269a50(angle_2)) * 8.0)
			var35 = helper_f8511a7a(0.0, angle, var33, var34)
			var35 = vm.f32(var35 + var27)
			var36 = helper_f8511a7a(0.0, angle_2, var33, var34)
			var36 = vm.f32(var36 + var30)
			var33 = vm.f32(var33 + 1.0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
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
	var34 = vm.f32(helper_69020fbe(helper_06269a50(angle), helper_06269a50(angle_2)) * 8.0)
	while var33 < var34 do
		var35 = helper_f8511a7a(0.0, angle, var33, var34)
		var35 = vm.f32(var35 + var27)
		event.SetCharaRot(arg0, 0.0, var35, 0.0)
		var36 = helper_f8511a7a(0.0, angle_2, var33, var34)
		var36 = vm.f32(var36 + var30)
		event.SetCharaRot(arg1, 0.0, var36, 0.0)
		var33 = vm.f32(var33 + 1.0)
		if vm.wait() then
			return skip(2)
		end
	end
	event.SetCharaRot(arg0, 0.0, var15, 0.0)
	event.SetMotion(arg0, "立ち")
	event.SetCharaRot(arg1, 0.0, var16, 0.0)
	event.SetMotion(arg1, "会話")
end

--- Helper function.
local function helper_a558(arg0: any, arg1: any, arg2: any)
	local rot_y: f32 = 0
	local player_chara: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_9024(player_chara, arg0, arg1)
		end
		return rot_y
	end
	if vm.skipping() then
		return skip(1)
	end
	if arg2 ~= 0 then
		event.EohSyncChara(0, arg0)
		do
			local _, out2, _ = event.EohGetRot(0)
			rot_y = out2 or rot_y
		end
	end
	player_chara = event.GetControlChrid() or player_chara
	helper_9024(player_chara, arg0, arg1)
	if vm.skipping() then
		return skip(2)
	end
	return rot_y
end

--- Helper function.
local function helper_8140(arg0: s32, arg1: any, arg2: any, arg3: s32, arg4: any)
	local var5: s32 = 0
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_08472fdb(arg0, arg1, arg2, arg3)
		end
		if at <= 2 then
			_, var5 = helper_7d0c(arg0, 0, var5)
		end
		helper_b72ef077(arg0)
	end
	if vm.skipping() then
		return skip(1)
	end
	helper_08472fdb(arg0, arg1, arg2, arg3)
	if vm.skipping() then
		return skip(2)
	end
	_, var5 = helper_7d0c(arg0, 0, var5)
	if vm.skipping() then
		return skip(3)
	end
	helper_b72ef077(arg0)
end

--- Helper function.
local function helper_9db4(arg0: any, arg1: f32)
	local rot_y: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local angle: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	local var15: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var10 = rot_y
			var11 = arg1
			angle = vm.f32(var11 - var10)
			var14 = 0.0
			var15 = 10.0
			var13 = helper_f8511a7a(0.0, angle, var14, var15)
			var13 = vm.f32(var13 + var10)
			var14 = vm.f32(var14 + 1.0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.EohSyncChara(0, arg0)
	event.EohGetPos(0)
	do
		local _, out2, _ = event.EohGetRot(0)
		rot_y = out2 or rot_y
	end
	var10 = rot_y
	var11 = arg1
	angle = vm.f32(var11 - var10)
	angle = event.AngleLimit(angle) or angle
	if -0.5 < angle and angle < 0.5 then
		event.SetMotion(arg0, "立ち")
	else
		event.SetMotion(arg0, "歩き")
	end
	var14 = 0.0
	var15 = 10.0
	while var14 <= var15 do
		var13 = helper_f8511a7a(0.0, angle, var14, var15)
		var13 = vm.f32(var13 + var10)
		event.EohSetRot(0, 0.0, var13, 0.0)
		var14 = vm.f32(var14 + 1.0)
		if vm.wait() then
			return skip(2)
		end
	end
	event.EohSetRot(0, 0.0, arg1, 0.0)
end

--- Helper function.
local function helper_a6c8(arg0: any, arg1: f32, arg2: any, arg3: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_9db4(arg0, arg1)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	if arg3 ~= 0 then
		helper_9db4(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
	if arg2 ~= 0 then
		event.SetCrossfade(10)
	end
end

--- Helper function.
local function helper_a818(arg0: s32, arg1: s32, arg2: s32, arg3: s32)
	local var4: f32 = 0
	local player_chara: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var4 = helper_a558(arg0, arg2, arg3)
		end
		if at <= 2 then
			helper_8140(0, arg1, arg0, player_chara, 0)
		end
		if at <= 3 then
			helper_a6c8(arg0, var4, arg2, arg3)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var4 = helper_a558(arg0, arg2, arg3)
	if vm.skipping() then
		return skip(2)
	end
	player_chara = event.GetControlChrid() or player_chara
	helper_8140(0, arg1, arg0, player_chara, 0)
	if vm.skipping() then
		return skip(3)
	end
	helper_a6c8(arg0, var4, arg2, arg3)
	if vm.skipping() then
		return skip(4)
	end
end

--- Helper function.
local function helper_1d170(arg0: s32, arg1: s32)
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
local function helper_1f1c4(arg0: s32, arg1: s32)
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
local function helper_202dc(arg0: s32, arg1: s32)
	local argc: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		helper_b72ef077(1)
		helper_1f1c4(arg0, argc)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.EyeViewDrawOnOff(0)
	event.SetMesEtc(1, 4, -1, -1, -1, -1)
	event.SetMesEtc(1, 9, -1, -1)
	if arg1 ~= 0 then
		helper_b72ef077(1)
	else
		event.SetMesPreset(1, 3)
	end
	event.Finish()
	if arg1 == 0 then
		argc = event.GetLocalCnt(arg0) or argc
		helper_1f1c4(arg0, argc)
	end
end

--- Helper function.
local function helper_20584(arg0: s32, arg1: s32, arg2: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_79c09698(30)
		end
		helper_202dc(arg0, arg1)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFadeOut(25)
	helper_79c09698(30)
	if vm.skipping() then
		return skip(2)
	end
	event.GotoMenu(6, arg2)
	if vm.wait() then
		return skip(3)
	end
	helper_202dc(arg0, arg1)
	event.SetFadeIn(30)
end

--- Helper function.
local function helper_1f6e4()
	local var0: s32 = 0
	local var1: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return 1
		end
		if at <= 2 then
			helper_fd4e9f5c(3, 1)
			helper_87d4(3, -1, 3, 256, 208)
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
		helper_fd4e9f5c(3, 1)
		event.MesMake_2(3, "もっとスクープを撮って来ないと\n賞品はやれないぜ。")
		helper_87d4(3, -1, 3, 256, 208)
		if vm.skipping() then
			return skip(2)
		end
	end
	if var1 == 2 then
		helper_fd4e9f5c(3, 1)
		event.MesMake_2(
			3,
			"ネタかスクープの数によって、\nオマエの写真家レベルが決まる。<page>レベルが上がれば、ごほうびの\nアイテムも増えるぞ。"
		)
		helper_87d4(3, -1, 3, 256, 208)
		if vm.skipping() then
			return skip(3)
		end
	end
	return 0
end

--- Helper function.
local function helper_1fb2c()
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
			return helper_1f6e4()
		end
		if at <= 3 then
			helper_fd4e9f5c(3, 1)
			helper_87d4(3, -1, 3, 256, 208)
		end
		return helper_1f6e4()
	end
	argc = event.GetItemHaveNum(355) or argc
	if argc <= 0 then
		helper_fd4e9f5c(3, 1)
		event.MesMake_2(3, "スクープメモを\n買ってくれ。")
		helper_87d4(3, -1, 3, 256, 208)
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
		helper_fd4e9f5c(3, 1)
		event.MesMake_2(3, "もう、スクープは\nなさそうだな。")
		helper_87d4(3, -1, 3, 256, 208)
		if vm.skipping() then
			return skip(2)
		end
		return helper_1f6e4()
	end
	var3 = event.GetMenuEtc_2(3) or var3
	if 0 < var3 then
		helper_fd4e9f5c(3, 8)
		event.SetMesValue(3, 1, var3)
		event.MesMake_2(3, "スクープ条件が、[数値１]個\n明らかになった。")
		event.SetMesDrawspeed(3, 0)
		helper_87d4(3, -1, 8, 0, 0)
		if vm.skipping() then
			return skip(3)
		end
	end
	helper_fd4e9f5c(3, 1)
	var3 = event.GetMenuEtc_2(4) or var3
	if var3 <= 0 then
		event.MesMake_2(3, "なんだよ、スクープなんて\n撮れてないじゃないか。")
	else
		event.SetMesValue(3, 1, var3)
		event.MesMake_2(3, "お、[数値１]枚もスクープが\n撮れてるじゃん。さすがだな。")
	end
	helper_87d4(3, -1, 3, 256, 208)
	if vm.skipping() then
		return skip(4)
	end
	return helper_1f6e4()
end

--- Helper function.
local function helper_1e2b8()
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
local function helper_206b8(arg0: s32, arg1: s32)
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
				helper_fd4e9f5c(3, 1)
				helper_1d170(3, argc)
				var25 = -1
				helper_2913f82c(3, var25, 3, 256, 208)
				helper_fd4e9f5c(1, 8)
				helper_2913f82c(1, 1, 1, 0, 0)
				helper_fd4e9f5c(2, 2)
				var25 = 30
				var25 = 31
				var25 = 32
				var24 = helper_7b9c(2, var25, 7, 0, 0, var28, var28 - 1)
			end
			if at <= 3 then
				helper_b72ef077(3)
				helper_79c09698(30)
			end
			helper_202dc(arg0, arg1)
			return
		end
		if at <= 10 then
			if at <= 6 then
				helper_fd4e9f5c(3, 8)
				helper_87d4(3, var25, 9, 0, 0)
			end
			if at <= 7 then
				helper_87d4(3, -1, 3, 256, 208)
			end
			if at <= 8 then
				helper_202dc(arg0, arg1)
				helper_20584(arg0, arg1, 6)
			end
			if at <= 9 then
				helper_20584(arg0, arg1, 23)
			end
			return
		end
		if at <= 12 then
			if at <= 11 then
				helper_20584(arg0, arg1, 33)
			end
			return
		end
		if at <= 13 then
			helper_20584(arg0, arg1, 1)
		end
		if at <= 14 then
			helper_20584(arg0, arg1, 2)
		end
		if at <= 15 then
			helper_20584(arg0, arg1, 3)
		end
		if at <= 16 then
			helper_20584(arg0, arg1, 7)
		end
		if at <= 17 then
			helper_20584(arg0, arg1, 8)
		end
		if at <= 18 then
			helper_20584(arg0, arg1, 9)
		end
		if at <= 19 then
			helper_20584(arg0, arg1, 10)
		end
		if at <= 20 then
			helper_20584(arg0, arg1, 11)
		end
		if at <= 21 then
			helper_20584(arg0, arg1, 12)
		end
		if at <= 22 then
			helper_20584(arg0, arg1, 13)
		end
		if at <= 23 then
			helper_20584(arg0, arg1, 14)
		end
		if at <= 24 then
			helper_20584(arg0, arg1, 15)
		end
		if at <= 25 then
			helper_20584(arg0, arg1, 16)
		end
		if at <= 26 then
			helper_20584(arg0, arg1, 17)
		end
		if at <= 27 then
			helper_20584(arg0, arg1, 18)
		end
		if at <= 28 then
			helper_20584(arg0, arg1, 19)
		end
		if at <= 29 then
			helper_20584(arg0, arg1, 20)
		end
		if at <= 30 then
			helper_20584(arg0, arg1, 21)
		end
		if at <= 31 then
			helper_20584(arg0, arg1, 22)
		end
		if at <= 32 then
			helper_20584(arg0, arg1, 32)
		end
		if at <= 33 then
			helper_1e2b8()
			helper_87d4(3, -1, 3, 256, 208)
		end
		if at <= 34 then
			helper_202dc(arg0, arg1)
			helper_79c09698(30)
		end
		helper_202dc(arg0, arg1)
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
		helper_fd4e9f5c(3, 1)
		var26 = event.GetChapter() or var26
		if var26 ~= 8 then
			var25 = event.GetPartyCharaMesNo_3(argc, 2) or var25
		else
			helper_1d170(3, argc)
			var25 = -1
		end
		event.SetMesDrawspeed(3, 0, 0)
		helper_2913f82c(3, var25, 3, 256, 208)
		helper_fd4e9f5c(1, 8)
		event.SetMesDrawspeed(1, 0, 0)
		var27 = event.GetPartyCharaMesNo_3(argc, 0) or var27
		event.SetMesItemDirect(1, 1, var27)
		helper_2913f82c(1, 1, 1, 0, 0)
		helper_fd4e9f5c(2, 2)
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
		var24 = helper_7b9c(2, var25, 7, 0, 0, var28, vm.i32(var28 - 1))
		if vm.skipping() then
			return skip(3)
		end
		helper_b72ef077(3)
		if var24 == 0 then
			if now_party_chara_id ~= 26 then
				event.SetFadeOut(25)
				helper_79c09698(30)
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
				helper_202dc(arg0, arg1)
				event.SetFadeIn(30)
				return
			end
			helper_fd4e9f5c(3, 8)
			event.SetMesDrawspeed(3, 0, 0)
			event.MesMake_2(
				3,
				"[(!)]今は連れて行けない。リンを\n   岬灯台に連れて行くのが先だ！"
			)
			helper_87d4(3, -1, 9, 0, 0)
			if vm.skipping() then
				return skip(6)
			end
			event.SetMesDrawspeed(3, 0, 0.6)
		end
		if var24 == 1 then
			helper_fd4e9f5c(3, 8)
			event.SetMesDrawspeed(3, 0, 0)
			var25 = event.GetPartyCharaMesNo_3(argc, 3) or var25
			helper_87d4(3, var25, 9, 0, 0)
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
						helper_87d4(3, -1, 3, 256, 208)
						if vm.skipping() then
							return skip(8)
						end
						helper_202dc(arg0, arg1)
						event.SetCrossfade(10)
					end
					if not (argc == 4) then
						break
					end
					helper_20584(arg0, arg1, 6)
					if vm.skipping() then
						return skip(9)
					end
					break
				end
				if var24 == 3 then
					if argc == 1 then
						helper_20584(arg0, arg1, 23)
						if vm.skipping() then
							return skip(10)
						end
						return
					end
					if argc == 4 then
						local t0 = helper_1fb2c()
						if vm.skipping() then
							return skip(11)
						end
						if t0 ~= 0 then
							helper_20584(arg0, arg1, 33)
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
						helper_20584(arg0, arg1, 0)
						if vm.skipping() then
							return skip(13)
						end
					end
					if argc == 12 then
						helper_20584(arg0, arg1, 1)
						if vm.skipping() then
							return skip(14)
						end
					end
					if argc == 6 then
						helper_20584(arg0, arg1, 2)
						if vm.skipping() then
							return skip(15)
						end
					end
					if argc == 7 then
						helper_20584(arg0, arg1, 3)
						if vm.skipping() then
							return skip(16)
						end
					end
					if argc == 2 then
						helper_20584(arg0, arg1, 7)
						if vm.skipping() then
							return skip(17)
						end
					end
					if argc == 3 then
						helper_20584(arg0, arg1, 8)
						if vm.skipping() then
							return skip(18)
						end
					end
					if argc == 5 then
						helper_20584(arg0, arg1, 9)
						if vm.skipping() then
							return skip(19)
						end
					end
					if argc == 8 then
						helper_20584(arg0, arg1, 10)
						if vm.skipping() then
							return skip(20)
						end
					end
					if argc == 10 then
						helper_20584(arg0, arg1, 11)
						if vm.skipping() then
							return skip(21)
						end
					end
					if argc == 11 then
						helper_20584(arg0, arg1, 12)
						if vm.skipping() then
							return skip(22)
						end
					end
					if argc == 13 then
						helper_20584(arg0, arg1, 13)
						if vm.skipping() then
							return skip(23)
						end
					end
					if argc == 16 then
						helper_20584(arg0, arg1, 14)
						if vm.skipping() then
							return skip(24)
						end
					end
					if argc == 18 then
						helper_20584(arg0, arg1, 15)
						if vm.skipping() then
							return skip(25)
						end
					end
					if argc == 19 then
						helper_20584(arg0, arg1, 16)
						if vm.skipping() then
							return skip(26)
						end
					end
					if argc == 20 then
						helper_20584(arg0, arg1, 17)
						if vm.skipping() then
							return skip(27)
						end
					end
					if argc == 21 then
						helper_20584(arg0, arg1, 18)
						if vm.skipping() then
							return skip(28)
						end
					end
					if argc == 22 then
						helper_20584(arg0, arg1, 19)
						if vm.skipping() then
							return skip(29)
						end
					end
					if argc == 23 then
						helper_20584(arg0, arg1, 20)
						if vm.skipping() then
							return skip(30)
						end
					end
					if argc == 24 then
						helper_20584(arg0, arg1, 21)
						if vm.skipping() then
							return skip(31)
						end
					end
					if argc == 25 then
						helper_20584(arg0, arg1, 22)
						if vm.skipping() then
							return skip(32)
						end
					end
					if argc == 17 then
						helper_20584(arg0, arg1, 32)
						if vm.skipping() then
							return skip(33)
						end
					end
					if argc == 9 then
						helper_1e2b8()
						event.SetMesDrawspeed(3, 0.6, 0.6)
						helper_87d4(3, -1, 3, 256, 208)
						if vm.skipping() then
							return skip(34)
						end
						helper_202dc(arg0, arg1)
						event.SetCrossfade(10)
					end
					if argc == 14 then
						event.SetFadeOut(25)
						helper_79c09698(30)
						if vm.skipping() then
							return skip(35)
						end
						event.GotoMenu(25)
						if vm.wait() then
							return skip(36)
						end
						helper_202dc(arg0, arg1)
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
	helper_202dc(arg0, arg1)
	event.SetCrossfade(10)
end

--- Helper function.
local function helper_244cc()
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
				helper_8140(0, -1, var0, player_chara, 0)
			end
			if at <= 2 then
				var11 = helper_7b9c(0, -1, 5, 256, 208, 2, 0)
			end
			if at <= 3 then
				helper_8140(0, -1, var0, player_chara, 0)
			end
			if at <= 4 then
				helper_a6c8(var0, var9, 0, 0)
			end
			return 1
		end
		if at <= 6 then
			helper_206b8(var17, 1)
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
		helper_fd4e9f5c(0, 1)
		var9 = helper_a558(var0, 0, 0)
		if vm.skipping() then
			return skip(1)
		end
		player_chara = event.GetControlChrid() or player_chara
		event.MesMake_2(0, "出発するか？")
		helper_8140(0, -1, var0, player_chara, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.SetMotion(var0, "立ち")
		event.SetMesShippo(0, 0)
		event.SetMesQuestionGyou(0, 0)
		event.SetMesEtc(0, 0, 1)
		event.MesMake_2(0, "うん！\nもう少しここにいるよ。")
		var11 = helper_7b9c(0, -1, 5, 256, 208, 2, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.SetMesEtc(0, 0, 0)
		event.SetMesShippo(0, 1)
		if var11 ~= 0 then
			event.SetMotion(var0, "会話")
			event.MesMake_2(0, "うむ、しっかりがんばるんじゃぞ。")
			helper_8140(0, -1, var0, player_chara, 0)
			if vm.skipping() then
				return skip(4)
			end
		end
		helper_a6c8(var0, var9, 0, 0)
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
		helper_fd4e9f5c(0, 1)
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
		helper_a818(var0, -1, 0, 0)
		if vm.skipping() then
			return skip(6)
		end
	else
		var17 = event.GetEventData_2(13) or var17
		helper_206b8(var17, 1)
		if vm.skipping() then
			return skip(7)
		end
	end
	return 0
end

--- Helper function.
local function helper_430b4()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 4 then
			if at <= 1 then
				helper_79c09698(45)
			end
			if at <= 2 then
				helper_c46d8c15(2830010)
			end
			if at <= 3 then
				helper_79c09698(30)
			end
			if vm.skip_end() then
				return skip(5)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.DelExtMotion(0)
		event.DeleteChara(32)
		event.DeleteChara(33)
		event.DeleteChara(34)
		event.LoadMes(0, -1)
		event.CharaActive(0)
		event.SetCharaPos(0, 2290.27, 0.0, 1646.13)
		event.SetCharaRot(0, 0.0, 3.14, 0.0)
		event.CharaNormalDrive(0)
		event.CharaResetDa(0)
		event.ResetCamera(1, 3.1415927, 10.0)
		event.SetFadeIn(30)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFlag(283, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.LoadSound(2237)
	var0 = event.SndLoadSound(2237) or var0
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.ChangeDir("event/e200/e283/")
	event.LoadMes(0, 5, "e283.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e283_mints.gltf", "info", 0)
		event.CharaActive(0, 0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e283_monica.gltf", "info", 0)
		event.CharaActive(0, 0)
		event.EohSyncChara(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.LoadChara(5, "e283_starbre.gltf", "info", 34)
	event.CharaActive(34)
	event.EohSyncChara(2, 34)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.ChangeDir("")
	if active_chr_no == 1 then
		event.LoadChara(5, "chara/c01_base.gltf", "info", 32)
		event.LoadEquip(5, 0, 4, "info", 32)
		event.LoadEquip(5, 0, 3, "info", 32)
		event.LoadEquip(5, 0, 2, "info", 32, 33)
		event.LoadMotion(5, "event/e200/e283/e283_mints.gltf", "info", 32)
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
		event.LoadMotion(5, "event/e200/e283/e283_monica.gltf", "info", 32)
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
	event.EohSetPos(0, -160.79, 0.0, -340.48)
	event.EohSetRot(0, 0.0, 2.9, 0.0)
	event.EohSetMotion(0, "立ち", 4)
	event.EohSetFootSoundId(0, 3)
	event.EohSetPos(1, -187.76, 0.0, -348.73)
	event.EohSetRot(1, 0.0, 2.18, 0.0)
	event.EohSetMotion(1, "立ち", 4)
	event.EohSetFootSoundId(1, 3)
	event.EohSetPos(2, -143.76, 0.0, -369.25)
	event.EohSetRot(2, 0.0, -1.46, 0.0)
	event.EohSetMotion(2, "立ち", 4)
	event.InitDramaScene()
	event.CmrsInit()
	event.CmrsSetPos(-254.7, 9.64, -441.04)
	event.CmrsSetRef(-145.97, 41.38, -347.02)
	event.CharaActive(0)
	event.CharaActive(32)
	event.CharaActive(33)
	event.CharaActive(34)
	event.SetFadeIn(30)
	event.StopBgm(0)
	helper_79c09698(45)
	if vm.skipping() then
		return skip(2)
	end
	event.ObjsSetMotion(2, "出発進行", 6)
	event.ObjsNextMotion(2, "出発進行L", 4)
	event.SndSePlay(var0, 2)
	helper_c46d8c15(2830010)
	if vm.skipping() then
		return skip(3)
	end
	event.SetFadeOut(30)
	helper_79c09698(30)
	if vm.skipping() then
		return skip(4)
	end
	return part2()
end

--- Helper function.
local function helper_2a840()
	local var0: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 6 then
			if at <= 1 then
				helper_79c09698(30)
			end
			if at <= 2 then
				helper_255e4()
				helper_fffc()
			end
			if at <= 3 then
				helper_79c09698(30)
			end
			if at <= 4 then
				helper_d4f8509e(0)
			end
			if at <= 5 then
				helper_79c09698(30)
			end
			if vm.skip_end() then
				return skip(7)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SetMpcharaMotion("p01_train01", "kikan-m0", "停止")
		event.EsmClear()
		event.DeleteChara(32)
		event.DeleteChara(33)
		event.EohSetShadow(0, 1)
		event.CharaActive(0)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	event.SetFadeOut(30)
	helper_79c09698(30)
	if vm.skipping() then
		return skip(2)
	end
	event.LoadSound(2237)
	var0 = event.SndLoadSound(2237) or var0
	event.CharaActive(0, 0)
	event.CharaActive(0, 8)
	event.CharaActive(0, 9)
	event.CharaActive(0, 10)
	helper_255e4()
	helper_fffc()
	if vm.skipping() then
		return skip(3)
	end
	event.EohSyncObj(0, "p01_train01")
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetPos(0, 0.0, 0.0, 400.0)
	event.ObjsSetRot(0, 0.0, 0.0, 0.0)
	event.SetMpcharaMotion("p01_train01", "kikan-m0", "機関")
	event.EohSyncObj(1, "p01_shadow-0")
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.AssignStack(5)
	event.ClearStack(5)
	event.LoadChara(5, "event/train/steam/steam_l.gltf", "info", 32)
	event.CharaActive(0, 32)
	event.EohSyncChara(2, 32)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.LoadChara(5, "event/train/steam/steam_r.gltf", "info", 33)
	event.CharaActive(0, 33)
	event.EohSyncChara(3, 33)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.EsmInitialize(5)
	event.EsmLoadBase("列車煙")
	event.EsmInitFix(5)
	event.EohSyncObj(0, "p01_train01")
	event.EsmCreate("列車煙")
	event.EsmSetValue(0, 0)
	event.InitDramaScene()
	event.CmrsInit()
	event.CmrsSetPos(-304.68, 110.91, -288.45)
	event.CmrsSetRef(-158.49, 89.18, -46.7)
	event.SetFadeIn(30)
	helper_79c09698(30)
	if vm.skipping() then
		return skip(4)
	end
	event.CharaActive(1, 32)
	event.ObjsSetPos(2, 30.0, 20.0, 380.0)
	event.ObjsSetRot(2, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(2, "ぶしゅー", 6)
	event.CharaActive(1, 33)
	event.ObjsSetPos(3, -30.0, 20.0, 380.0)
	event.ObjsSetRot(3, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(3, "ぶしゅー", 6)
	event.ObjsMove2(0, 0.0, 0.0, 6000.0, 210, 1, 1.0)
	event.ObjsMove2(1, 0.0, 0.0, 6000.0, 210, 1, 1.0)
	event.ObjsMove2(2, 0.0, 0.0, 6000.0, 210, 1, 1.0)
	event.ObjsMove2(3, 0.0, 0.0, 6000.0, 210, 1, 1.0)
	event.SndSePlay(var0, 3)
	helper_d4f8509e(0)
	if vm.skipping() then
		return skip(5)
	end
	event.SetFadeOut(30)
	helper_79c09698(30)
	if vm.skipping() then
		return skip(6)
	end
	return part2()
end

--- Helper function.
local function helper_239e8()
	local var0: s32 = 0
	local now_party_chara_id: s32 = 0
	local var2: s32 = 0
	local flag: s32 = 0
	local var4: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_fd4e9f5c(0, 1)
			helper_a818(var0, -1, 0, 0)
		end
		if at <= 2 then
			helper_206b8(var4, 2)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var0 = event.GetEventData_2(13) or var0
	now_party_chara_id = event.GetNowPartyChara() or now_party_chara_id
	if now_party_chara_id == 2 then
		helper_fd4e9f5c(0, 1)
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
		helper_a818(var0, -1, 0, 0)
		if vm.skipping() then
			return skip(2)
		end
	else
		var4 = event.GetEventData_2(13) or var4
		helper_206b8(var4, 2)
		if vm.skipping() then
			return skip(3)
		end
	end
end

--- Helper function.
local function helper_23e94()
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
			helper_fd4e9f5c(0, 1)
			helper_a818(var0, -1, 0, 0)
		end
		if at <= 2 then
			helper_206b8(var6, 3)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var0 = event.GetEventData_2(13) or var0
	now_party_chara_id = event.GetNowPartyChara() or now_party_chara_id
	if now_party_chara_id == 13 then
		helper_fd4e9f5c(0, 1)
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
		helper_a818(var0, -1, 0, 0)
		if vm.skipping() then
			return skip(2)
		end
	else
		var6 = event.GetEventData_2(13) or var6
		helper_206b8(var6, 3)
		if vm.skipping() then
			return skip(3)
		end
	end
end

--- Helper function.
local function helper_2539c()
	local var0: s32 = 0
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_fd4e9f5c(0, 1)
			helper_a818(var0, -1, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var0 = event.GetEventData_2(13) or var0
	helper_fd4e9f5c(0, 1)
	flag = event.GetFlag(648) or flag
	if flag == 0 then
		event.MesMake_2(0, "オレはここで待ってる。\n幸運を祈ってるぜ！")
	else
		event.MesMake_2(0, "オレはここで待ってるぜ。\n絶対、グリフォンを倒せよ。")
	end
	helper_a818(var0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 99.
script[99] = function()
	event.Initialize()
	helper_44ac8()
	event.SetCameraPos(-368.0, 50.0, 62.1)
	event.SetCameraRef(-368.0, 30.0, -57.9)
	event.SetCharaPos(0, -368.0, 0.0, -57.9)
	event.SetCharaRot(0, 0.0, 0.0, 0.0)
	event.SetFadeIn(15)
end

--- Program 100.
script[100] = function()
	local flag: s32 = 0
	local flag_2: s32 = 0
	local mc_load: s32 = 0
	local old_map_no: s32 = 0
	local var4: s32 = 0
	local var5: s32 = 0
	local var6: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	local landing1: () -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
		if at <= 2 then
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			helper_1c480()
			helper_28ec8()
			if not vm.skipping() then
				return landing1()
			end
		end
		if at <= 5 then
			helper_27ae8()
		end
	end
	function part2() end
	function landing1()
		event.SetMotion(0, "立ち")
		return part2()
	end
	event.Initialize()
	helper_44ac8()
	print("start_event--------------------------------------------\n")
	flag = event.GetFlag(31) or flag
	flag_2 = event.GetFlag(254) or flag_2
	if flag ~= 0 and flag_2 == 0 then
		helper_40070()
		if vm.skipping() then
			return skip(1)
		end
		event.MapJump(-1, "s47", 505)
		return
	end
	mc_load = event.CheckMcLoad() or mc_load
	if mc_load == 1 then
		event.SetCharaPos(0, -750.0, 0.0, -75.0)
		event.SetCharaRot(0, 0.0, 1.57, 0.0)
		event.SetMotion(0, "立ち", 4)
		event.CharaNormalDrive(0)
		event.CharaResetDa(0)
		event.ResetCamera(1, 0.0, 20.0)
	else
		old_map_no = event.GetOldMapNo() or old_map_no
		var4 = event.GetMapType(old_map_no) or var4
		if var4 ~= -1 then
			if var4 == 7 or var4 == 8 then
				helper_2bb50()
				if vm.skipping() then
					return skip(2)
				end
				event.SetMotion(0, "立ち")
				return
			else
				if old_map_no == 53 then
					helper_44928()
					if vm.skipping() then
						return skip(3)
					end
					return
				end
				if old_map_no == 0 then
					helper_2b6c8()
					if vm.skipping() then
						return skip(4)
					end
				else
					var5 = event.GetCnt(1) or var5
					if
						(old_map_no == 18 or old_map_no == 23 or old_map_no == 120 or old_map_no == 108)
						and var5 == 2
					then
						helper_1c480()
						event.SetFadeIn(15)
						event.ResetCamera(1, 0.0)
					else
						var6 = event.GetChapter() or var6
						if var6 ~= 6 and var6 ~= 7 then
							helper_28ec8()
							if vm.skipping() then
								return skip(5)
							end
						else
							helper_27ae8()
							if vm.skipping() then
								return skip(6)
							end
						end
					end
				end
			end
		end
		event.SetMotion(0, "立ち")
	end
	return part2()
end

--- Program 150.
script[150] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesStr(0, 16, "なかみ")
	event.MesMake_2(0, "ここから[文字列１６]ここまで")
	helper_87d4(0, -1, 5, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 151.
script[151] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_f30(32)
		end
	end
	if vm.wait() then
		return skip(1)
	end
	helper_f30(32)
	if vm.skipping() then
		return skip(2)
	end
end

--- Program 209.
script[209] = function()
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	local t0 = helper_262a4()
	if vm.skipping() then
		return skip(1)
	end
	if t0 ~= 0 then
		event.SetFadeOut(0)
		if vm.wait() then
			return skip(2)
		end
		flag = event.GetFlag(208) or flag
		if flag == 0 then
			event.BgmPlayCancel()
		end
		event.MapJump(-1, "g01")
		return
	end
end

--- Program 210.
script[210] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_2c054()
		end
	end
	local t0 = helper_26ea4()
	if vm.skipping() then
		return skip(1)
	end
	if t0 ~= 0 then
		helper_2c054()
		if vm.skipping() then
			return skip(2)
		end
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
			helper_12c04()
		end
		if at <= 6 then
			helper_14354(1)
		end
		if at <= 7 then
			helper_17304()
		end
	end
	var0 = helper_1cdc4()
	if vm.skipping() then
		return skip(1)
	end
	if var0 ~= 1 then
		return
	end
	event.SetCnt(1, 2)
	var1 = event.GetChapter() or var1
	var2 = event.GetEventData_2(3) or var2
	if var2 <= 1 then
		if var1 ~= 6 and var1 ~= 7 then
			helper_12c04()
			if vm.skipping() then
				return skip(2)
			end
			event.StopBgm(0)
			if vm.wait() then
				return skip(3)
			end
			event.MapJump(-1, "s08")
		else
			helper_12c04()
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
		helper_14354(1)
		if vm.skipping() then
			return skip(7)
		end
		event.StopBgm(0)
		event.MapJump(100, "s07")
	else
		helper_17304()
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
	helper_e1d8()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 499.
script[499] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_28ec8()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 501.
script[501] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	event.SetFadeOut(0)
	if vm.wait() then
		return skip(1)
	end
	event.LoadScript("s02/s02b.stb", 501)
end

--- Program 502.
script[502] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	if vm.wait() then
		return skip(1)
	end
	event.LoadScript("s02/s02b.stb", 502)
end

--- Program 503.
script[503] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	if vm.wait() then
		return skip(1)
	end
	event.LoadScript("s02/s02b.stb", 503)
end

--- Program 504.
script[504] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	helper_44ac8()
	helper_2b6c8()
	if vm.skipping() then
		return skip(1)
	end
	event.SetMotion(0, "立ち")
end

--- Program 1000.
script[1000] = function()
	local var0: s32 = 0
	local var1: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	local landing1: () -> ...any
	local landing2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_430b4()
			if not vm.skipping() then
				return landing1()
			end
		end
		if at <= 2 then
			helper_2a840()
			if not vm.skipping() then
				return landing2()
			end
		end
		if at <= 4 then
			helper_239e8()
		end
		if at <= 5 then
			helper_23e94()
		end
		if at <= 6 then
			helper_2539c()
		end
	end
	function part2()
		if var0 == 2 then
			helper_239e8()
			if vm.skipping() then
				return skip(5)
			end
		end
		if var0 == 13 then
			helper_23e94()
			if vm.skipping() then
				return skip(6)
			end
		end
		if var0 == 301 then
			helper_2539c()
			if vm.skipping() then
				return skip(7)
			end
		end
	end
	function landing1()
		helper_2a840()
		if vm.skipping() then
			return skip(3)
		end
		event.GotoMenu(13, 4)
		if vm.wait() then
			return skip(4)
		end
		event.MapJump(-1, "s04")
		return part2()
	end
	function landing2()
		event.GotoMenu(13, 4)
		if vm.wait() then
			return skip(4)
		end
		event.MapJump(-1, "s04")
		return part2()
	end
	var0 = event.GetEventData_2(14) or var0
	if var0 == 1 then
		var1 = helper_244cc()
		if vm.skipping() then
			return skip(1)
		end
		if var1 == 1 then
			helper_430b4()
			if vm.skipping() then
				return skip(2)
			end
			helper_2a840()
			if vm.skipping() then
				return skip(3)
			end
			event.GotoMenu(13, 4)
			if vm.wait() then
				return skip(4)
			end
			event.MapJump(-1, "s04")
		end
	end
	return part2()
end

--- Program 12070.
script[12070] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	event.SetFadeOut(0)
	if vm.wait() then
		return skip(1)
	end
	event.LoadScript("s02/s02b.stb", 501)
end

--- Program 12541.
script[12541] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetFloorInfo(1, 7, 5, 256)
	helper_40070()
	if vm.skipping() then
		return skip(1)
	end
	event.MapJump(-1, "s47", 505)
end

--- Program 12830.
script[12830] = function()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_2a840()
			if not vm.skipping() then
				return part2()
			end
		end
	end
	function part2()
		event.GotoMenu(13, 4)
		if vm.wait() then
			return skip(3)
		end
		event.MapJump(-1, "s04")
	end
	helper_430b4()
	if vm.skipping() then
		return skip(1)
	end
	helper_2a840()
	if vm.skipping() then
		return skip(2)
	end
	return part2()
end

return script
