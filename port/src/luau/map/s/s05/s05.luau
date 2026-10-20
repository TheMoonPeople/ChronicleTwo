--!strict
-- map/s/s05/s05.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_2c717f26 = require("@lib/event/helper_2c717f26")
local helper_ed4529cf = require("@lib/event/helper_ed4529cf")

local global0: s32 = 0
local global1: s32 = 0

--- Program 99.
local function program_99()
	event.SetBitCtrl(16, 1)
	event.SetFadeIn(15)
end

--- Helper function.
local function helper_ebc0(arg0: s32)
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local flag_4: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	event.GetCnt(3)
	event.AssignStack(4)
	event.ClearStack(4)
	if arg0 ~= 0 then
		event.LoadChara(4, "event/e200/e220/e220_noam.gltf", "info", 9)
		event.SetCharaNo(9, 153)
		event.CharaActive(9)
		event.SetCharaPos(9, 2199.07, 29.83, 981.55)
		event.SetCharaRot(9, 0.0, 2.68, 0.0)
		event.SetMotion(9, "釣り")
		flag = event.GetFlag(28) or flag
		if flag == 0 then
			event.EohSyncChara(0, 9)
			event.EohSetFrameStatus(0, "wine", 0)
		end
		event.ChangeDir("event/e200/e215/")
		event.LoadChara(4, "e215_wicky.gltf", "info", 11)
		event.SetCharaNo(11, 152)
		event.CharaActive(11)
		event.SetCharaPos(11, 2022.78, 0.01, 1090.61)
		event.SetCharaRot(11, 0.0, 0.0, 0.0)
		event.SetMotion(11, "寝そべってる")
		event.LoadChara(4, "e215_mogri.gltf", "info", 12)
		event.SetCharaNo(12, 150)
		event.CharaActive(12)
		event.SetCharaPos(12, 1895.53, -3.91, 1206.14)
		event.SetCharaRot(12, 0.0, 0.0, 0.0)
		event.SetMotion(12, "座り")
		event.ChangeDir("")
		event.LoadChara(4, "event/nanahige/p02_07a.gltf", "info", 10)
		event.SetCharaNo(10, 155)
		event.CharaActive(10)
		event.SetCharaPos(10, 1824.39, 0.01, 1158.94)
		event.SetCharaRot(10, 0.0, 0.04, 0.0)
		event.SetMotion(10, "立ち")
		event.SetNearDist(10, 25.0)
		event.LoadChara(4, "event/e200/e230/e230_dokuring.gltf", "info", 13)
		event.CharaActive(0, 13)
		event.SetCharaPos(13, -1892.15, 3.14, 941.97)
		event.SetCharaRot(13, 3.1415927, 0.0, 0.0)
		event.SetScale(13, 2.0, 2.0, 2.0)
		event.CopyChara(4, 13, 15)
		event.CharaActive(0, 15)
		event.SetCharaPos(15, -1883.07, 3.14, 938.36)
		event.SetCharaRot(15, 3.1415927, 0.0, 0.0)
		event.SetScale(15, 2.0, 2.0, 2.0)
		event.CopyChara(4, 13, 16)
		event.CharaActive(0, 16)
		event.SetCharaPos(16, -1885.02, 3.14, 931.43)
		event.SetCharaRot(16, 3.1415927, 0.0, 0.0)
		event.SetScale(16, 2.0, 2.0, 2.0)
		event.CopyChara(4, 13, 17)
		event.CharaActive(0, 17)
		event.SetCharaPos(17, -1896.36, 3.14, 935.12)
		event.SetCharaRot(17, 3.1415927, 0.0, 0.0)
		event.SetScale(17, 2.0, 2.0, 2.0)
	end
	event.LoadChara(4, "event/e200/e230/e230_utan.gltf", "info", 8)
	event.CharaActive(1, 8)
	flag_2 = event.GetFlag(253) or flag_2
	if flag_2 == 0 then
		event.SetCharaPos(8, -1938.91, 0.4, 1036.52)
		event.SetCharaRot(8, 0.0, 2.44, 0.0)
		event.FuncPointShow("p01_s0501", "invent_2005-0", 1)
		event.FuncPointShow("p01_s0501", "invent_2005-1", 0)
		event.FuncPointShow("p01_s0501", "kaiwa01-0", 1)
		event.FuncPointShow("p01_s0501", "kaiwa03-0", 0)
		event.EohSyncObj(0, "p09_s0501", "s050119-c")
		event.EohSetShow(0, 1)
		event.EohSyncObj(0, "p09_s0501", "s050120-c")
		event.EohSetShow(0, 0)
	else
		event.SetCharaPos(8, -2202.71, 0.4, 759.61)
		event.SetCharaRot(8, 0.0, 2.16, 0.0)
		event.FuncPointShow("p01_s0501", "invent_2005-0", 0)
		event.FuncPointShow("p01_s0501", "invent_2005-1", 1)
		event.FuncPointShow("p01_s0501", "kaiwa01-0", 0)
		event.FuncPointShow("p01_s0501", "kaiwa03-0", 1)
		event.EohSyncObj(0, "p09_s0501", "s050119-c")
		event.EohSetShow(0, 0)
		event.EohSyncObj(0, "p09_s0501", "s050120-c")
		event.EohSetShow(0, 1)
	end
	flag_3 = event.GetFlag(240) or flag_3
	flag_4 = event.GetFlag(245) or flag_4
	event.EohSyncObj(0, "p08_s0501")
	if flag_3 ~= 0 and flag_4 == 0 then
		event.LoadChara(4, "chara/b04a.gltf", "b04a", 14)
		event.CharaActive(1, 14)
		event.SetCharaPos(14, -127.39, 0.0, -701.37)
		event.SetCharaRot(14, 0.0, -1.68, 0.0)
		event.SetStatus(1, 14, 256, 0)
		event.SetCharaFarDist(14, 2400.0)
		event.FuncPointShow("p01_s0501", "invent_2008-0", 1)
		event.FuncPointShow("p01_s0501", "kaiwa02-0", 1)
		event.EohSetShow(0, 1)
	else
		event.FuncPointShow("p01_s0501", "invent_2008-0", 0)
		event.FuncPointShow("p01_s0501", "kaiwa02-0", 0)
		event.EohSetShow(0, 0)
	end
end

--- Helper function.
local function helper_27ae4()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		helper_ebc0(1)
		helper_ebc0(0)
	end
	if vm.skipping() then
		return skip(1)
	end
	var0 = event.GetCnt(3) or var0
	if var0 < 7 then
		helper_ebc0(1)
	else
		helper_ebc0(0)
	end
end

--- Helper function.
local function helper_11c00()
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.FuncPointShow("", "fc_e220", 0)
	event.FuncPointShow("", "fc_e230", 0)
	event.FuncPointShow("", "fc_e235", 0)
	event.FuncPointShow("", "fc_e247", 0)
	event.FuncPointShow("", "fc_e253", 0)
	event.FuncPointShow("", "next_floor", 0)
	event.FuncPointShow("", "item_e245", 0)
	event.FuncPointShow("", "itemget_paplle", 0)
	event.FuncPointShow("", "itemget_mimi", 0)
end

--- Helper function.
local function helper_11ee8()
	local var0: s32 = 0
	local argc: s32 = 0
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		helper_11c00()
		print("cnt=", var0, "-------------------------------------\n")
		print("esaget-------------\n")
		print("apple-------------\n")
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	helper_11c00()
	var0 = event.GetCnt(3) or var0
	print("cnt=", var0, "-------------------------------------\n")
	if var0 >= 8 then
		event.EohSyncObj(0, "p05_s0501", "s050111-m0")
		event.EohSetShow(0, 1)
		event.EohSetPos(0, -2274.43, 37.38, 712.87)
		event.EohSetRot(0, 0.0, 0.0, 0.0)
		event.EohSyncObj(0, "p05_s0501", "s050102-a")
		event.EohSetPos(0, -2274.43, 37.38, 712.87)
		event.EohSetRot(0, 0.0, 0.0, 0.0)
		event.EohSyncObj(0, "p05_s0501", "s050102-c")
		event.EohSetPos(0, -2274.43, 37.38, 712.87)
		event.EohSetRot(0, 0.0, 0.0, 0.0)
		event.FuncPointShow("", "next_floor", 1)
	end
	if var0 > 1 and var0 < 7 then
		print("esaget-------------\n")
		event.FuncPointShow("", "itemget_mimi", 1)
	end
	flag = event.GetFlag(230) or flag
	if flag ~= 0 and var0 < 5 then
		argc = event.GetItemNum(291) or argc
		if argc <= 0 then
			print("apple-------------\n")
			event.FuncPointShow("", "itemget_paplle", 1)
			event.CharaActive(1, 13)
			event.CharaActive(1, 15)
			event.CharaActive(1, 16)
			event.CharaActive(1, 17)
		else
			event.CharaActive(0, 13)
			event.CharaActive(0, 15)
			event.CharaActive(0, 16)
			event.CharaActive(0, 17)
		end
	end
	if var0 <= 2 then
		argc = event.GetItemNum(302) or argc
		if argc <= 0 then
			event.FuncPointShow("", "fc_e220", 1)
		end
	end
	flag = event.GetFlag(230) or flag
	if flag == 0 then
		event.FuncPointShow("", "fc_e230", 1)
		return
	end
	if var0 == 3 then
		event.FuncPointShow("", "fc_e235", 1)
		return
	end
	if var0 == 5 then
		print("haguhagu on--------------\n")
		event.FuncPointShow("", "item_e245", 1)
		return
	end
	if var0 == 6 then
		event.FuncPointShow("", "fc_e247", 1)
		helper_ed4529cf()
		return
	end
	if var0 == 7 then
		flag = event.GetFlag(250) or flag
		if flag == 1 then
			event.FuncPointShow("", "fc_e253", 1)
		end
	end
end

--- Helper function.
local function helper_29d8(arg0: s32)
	local var1: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	while true do
		var1 = event.ObjsCheck(arg0) or var1
		if var1 == 0 then
			break
		else
			if vm.wait() then
				return skip(2)
			end
		end
	end
end

--- Helper function.
local function helper_468(arg0: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			arg0 = vm.wrap(arg0 - 1)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	while arg0 >= 0 do
		arg0 = arg0 - 1
		if vm.wait() then
			return skip(2)
		end
	end
end

--- Helper function.
local function helper_28c8()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	while true do
		var0 = event.CmrsCheck() or var0
		if var0 == 0 then
			break
		else
			if vm.wait() then
				return skip(2)
			end
		end
	end
end

--- Helper function.
local function helper_26268(arg0: f32, arg1: f32, arg2: f32, arg3: f32)
	local var4: s32 = 0
	local angle: f32 = 0
	local active_chr_no: s32 = 0
	local var11: f32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 10 then
			if at <= 1 then
				helper_29d8(0)
			end
			if at <= 2 then
				helper_29d8(0)
			end
			if at <= 3 then
				helper_468(14)
			end
			if at <= 4 then
				helper_468(16)
			end
			if at <= 5 then
				helper_29d8(0)
			end
			if at <= 6 then
				helper_468(30)
			end
			if at <= 7 then
				helper_28c8()
			end
			if at <= 8 then
				var11 = vm.f32(var11 - vm.f32(3.1415927))
				helper_29d8(0)
			end
			if at <= 9 then
				helper_468(15)
			end
			if vm.skip_end() then
				return skip(11)
			end
			return part2()
		end
	end
	function part2()
		event.SetFadeIn(0)
		event.ObjsInit(0)
		event.EohSetMotion(0, "立ち")
		event.EohSetPos(0, -170.0, 0.0, 50.0)
		event.EohSetRot(0, 0.0, -1.57, 0.0)
		event.EohResetDaPosition(0)
		event.SetCameraRef(-170.0, 30.0, 50.0)
		event.SetCameraPos(-70.0, 35.0, 50.0)
		event.ResetCamera(0)
		event.DelExtMotion(0)
	end
	event.SetFadeOut(0)
	if vm.wait() then
		return skip(1)
	end
	event.Initialize()
	event.InitDramaScene()
	var4 = event.SndLoadSound(8, "snd2/sp/sp_031.sound.json") or var4
	event.AssignStack(5)
	event.ClearStack(5)
	angle = event.AngleLimit(angle) or angle
	event.SetWorldCoord(arg0, arg1, arg2, arg3)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		event.LoadMotion(5, "dungeon/chara/mints_01in.gltf", "info", 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "dungeon/chara/monica_01in.gltf", "info", 0)
	end
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetPos(0, 116.96, 18.76, 19.22)
	event.ObjsSetRot(0, 0.0, -1.96, 0.0)
	event.ObjsSeDelay(0, 1)
	event.ObjsResetDaPosition(0)
	event.EohSetFootSoundId(0, 3)
	event.CmrsInit()
	event.CmrsSetPos(186.89, 58.05, -1.19)
	event.CmrsSetRef(50.97, 32.07, 20.9)
	event.CmrsFadeInit()
	event.CmrsFadeIn(30)
	if active_chr_no == 0 then
		event.CmrsMove2(137.93, 48.95, 6.77, 50.97, 32.07, 20.9, 160, 2, 0.4)
		event.ObjsMove(0, 23.61, 18.53, -17.13, 140)
		event.ObjsSetMotion(0, "丸太歩き", 4)
		event.ObjsRotDelay(0, 130)
		event.ObjsRotation(0, 0.0, -1.0, 0.0, 10)
		helper_29d8(0)
		if vm.skipping() then
			return skip(2)
		end
		event.ObjsSetMotion(0, "ジャンプ", 2)
		event.ObjsNextMotion(0, "ジャンプ中", 6, 0.3)
		event.ObjsNextMotion(0, "着地", 6)
	else
		event.CmrsMove2(137.93, 48.95, 6.77, 50.97, 32.07, 20.9, 100, 2, 0.4)
		event.ObjsMove(0, 23.61, 18.53, -17.13, 60)
		event.ObjsSetMotion(0, "丸太歩き", 4)
		event.ObjsRotDelay(0, 50)
		event.ObjsRotation(0, 0.0, -1.0, 0.0, 10)
		helper_29d8(0)
		if vm.skipping() then
			return skip(3)
		end
		event.ObjsSetMotion(0, "ジャンプ", 2)
		event.ObjsNextMotion(0, "ジャンプ中", 6, 0.2)
		event.ObjsNextMotion(0, "着地", 6)
	end
	event.EohSetFootSoundId(0, 16)
	helper_468(14)
	if vm.skipping() then
		return skip(4)
	end
	event.SndSePlay(var4, 2)
	event.ObjsJump(0, -85.0, 0.0, 50.0, -0.25, 30)
	event.ObjsRotDelay(0, 10)
	event.ObjsRotation(0, 0.0, -1.57, 0.0, 20)
	helper_468(16)
	if vm.skipping() then
		return skip(5)
	end
	helper_29d8(0)
	if vm.skipping() then
		return skip(6)
	end
	event.SndSePlay(var4, 4)
	helper_468(30)
	if vm.skipping() then
		return skip(7)
	end
	event.ObjsSetMotion(0, "歩き")
	event.ObjsMove(0, -170.0, 0.0, 50.0, 50)
	helper_28c8()
	if vm.skipping() then
		return skip(8)
	end
	event.SetCrossfade(30)
	do
		local _, out2, _ = event.EohGetRot(0)
		var11 = out2 or var11
	end
	event.CmrsSetRef(-170.0, 30.0, 50.0)
	var11 = vm.f32(var11 - vm.f32(3.1415927))
	var11 = event.AngleLimit(var11) or var11
	event.CmrsSetAhd(var11, 5.0, 100.0)
	helper_29d8(0)
	if vm.skipping() then
		return skip(9)
	end
	event.ObjsSetMotion(0, "立ち")
	helper_468(15)
	if vm.skipping() then
		return skip(10)
	end
	event.CancelDramaScene()
	return part2()
end

--- Helper function.
local function helper_12f80()
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
	event.SetMesWindowMode(0, 7)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		global0 = 0
		global1 = 32
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.LoadMotion(5, "event/e200/e215/e215_mints.gltf", "info", global0)
		event.EohSyncChara(0, global0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global0)
		event.LoadChara(5, "chara/c02_base.gltf", "info", global1)
		event.LoadEquip(5, 1, 4, "info", global1)
		event.LoadEquip(5, 1, 3, "info", global1)
		event.LoadEquip(5, 1, 2, "info", global1, 37)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.LoadMotion(5, "event/e200/e215/e215_monica.gltf", "info", global1)
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
		event.LoadMotion(5, "event/e200/e215/e215_mints.gltf", "info", global0)
		event.EohSyncChara(0, global0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global0)
		event.CharaActive(1, 37)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.LoadMotion(5, "event/e200/e215/e215_monica.gltf", "info", global1)
		event.EohSyncChara(1, global1)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global1)
	end
	event.LoadMes(0, 5, "event/e200/e215/e215.txt")
end

--- Helper function.
local function helper_2b80(arg0: any, arg1: any, arg2: any, arg3: any, arg4: any)
	local var5: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		return var5
	end
	if vm.skipping() then
		return skip(1)
	end
	var5 = event.MesMake_3(arg0, arg1) or var5
	event.SetMesPos(arg0, arg2)
	event.SetMesAutoset(arg0, arg3, arg4, arg3, arg4)
	return var5
end

--- Helper function.
local function helper_2eb0(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local pressed: s32 = 0
	local pressed_2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		var3 = 1
		var3 = 0
		var3 = 0
		return 0, arg1
	end
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetMesWindowMode(arg0) or var2
	var3 = 1
	if var2 == 7 then
		var3 = 0
	end
	if var2 == 0 then
		var3 = 0
	end
	var4 = event.GetMesStatus(arg0) or var4
	if var4 == 0 then
		return 0, arg1
	end
	if var4 == 1 then
		return 0, arg1
	end
	if var4 == 4 then
		return 0, arg1
	end
	pressed = event.CheckButton(0) or pressed
	pressed_2 = event.CheckButton(1) or pressed_2
	if (if pressed ~= 0 then 1 else pressed_2) ~= 0 then
		if var3 ~= 0 then
			if pressed_2 ~= 0 then
				event.MesSePlay(0)
			end
			if pressed ~= 0 then
				event.MesSePlay(1)
			end
		end
		if var4 == 5 then
			event.MesNextpage(arg0)
		end
		if var4 == 3 then
			return 1, arg1
		end
		if var4 ~= 5 and var4 ~= 3 then
			event.SetMesDrawspeed(arg0, 0.0)
			event.TrgPakuMotion(2)
			arg1 = 2
		end
	end
	return 0, arg1
end

--- Helper function.
local function helper_3cd8(arg0: s32)
	local var1: s32 = 0
	local var2: s32 = 0
	local argc: s32 = 0
	local argc_2: s32 = 0
	local var5: s32 = 0
	local var6: s32 = 0
	local var7: s32 = 0
	local loud: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var2 = 0
			var6 = 0
			loud = 0
			argc_2 = argc
			var2 = 2
			var7 = loud
			local t1: s32
			t1, var2 = helper_2eb0(arg0, var2)
			var5 = t1
			var6 = var6 + 1
		end
		var6 = vm.i32(var6 + 1)
	end
	if vm.skipping() then
		return skip(1)
	end
	var1 = event.GetSavedataEtc(5) or var1
	event.TrgPakuAnim(1)
	event.TrgPakuMotion(0)
	var2 = 0
	var6 = 0
	argc_2 = event.StreamGetStatus(1) or argc_2
	loud = 0
	while true do
		argc_2 = argc
		argc = event.StreamGetStatus(1) or argc
		if argc_2 ~= 0 and argc == 0 then
			event.TrgPakuMotion(2)
			var2 = 2
			if var1 ~= 0 then
				break
			end
		end
		var7 = loud
		loud = event.StreamSilentCheck(1) or loud
		if var7 == 0 and loud == 1 then
			event.TrgPakuAnim(1)
		end
		if var7 == 1 and loud == 0 then
			event.TrgPakuAnim(0)
		end
		local t0: s32
		t0, var2 = helper_2eb0(arg0, var2)
		var5 = t0
		if var5 ~= 0 then
			var6 = vm.i32(var6 + 1)
			break
		else
			if vm.wait() then
				return skip(2)
			end
			var6 = vm.i32(var6 + 1)
		end
	end
	if var2 == 0 then
		event.TrgPakuMotion(2)
	end
	event.ResetPakuMotion()
	event.TrgPakuAnim(0)
	event.ResetPakuAnim()
	event.StreamStop(1)
end

--- Helper function.
local function helper_2dc4(arg0: any)
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesCursor(arg0, -1)
	event.MesClose(arg0)
	event.SetMesPos(arg0, 0)
end

--- Helper function.
local function helper_5d48(arg0: s32)
	local stream_open_state: s32 = 0
	local stream_open_state_2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			helper_2b80(0, -1, 8, 0, 0)
			helper_3cd8(0)
		end
		helper_2dc4(0)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.StreamOpen3(1, arg0)
	while true do
		stream_open_state = event.StreamOpenCheck() or stream_open_state
		if stream_open_state == 0 then
			break
		else
			if vm.wait() then
				return skip(2)
			end
		end
	end
	event.StreamStandby(1)
	while true do
		stream_open_state_2 = event.StreamOpenCheck() or stream_open_state_2
		if stream_open_state_2 == 0 then
			break
		else
			if vm.wait() then
				return skip(3)
			end
		end
	end
	helper_2b80(0, -1, 8, 0, 0)
	event.StreamPlay(1)
	helper_3cd8(0)
	if vm.skipping() then
		return skip(4)
	end
	helper_2dc4(0)
	event.StreamClose(1)
end

--- Helper function.
local function helper_6038(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_5d48(arg0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, arg0)
	helper_5d48(arg0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_12ca8()
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
end

--- Helper function.
local function helper_13bcc()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local vector_x: f32 = 0
	local vector_y: f32 = 0
	local vector_z: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local var12: s32 = 0
	local var13: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 16 then
			if at <= 1 then
				helper_12f80()
				var9 = vm.f32(0.46)
				var10 = vm.f32(0.0066666664)
				var12 = 0
				var7 = vm.f32(var7 + 20.0)
				vector_x = vm.f32(vector_x + vm.f32(130.0 * vm.sin(var9)))
				vector_z = vm.f32(vector_z + vm.f32(130.0 * vm.cos(var9)))
				vector_y = vm.f32(vector_y + vm.f32(29.79))
				var9 = vm.f32(var9 + var10)
				var9 = vm.f32(var9 - vm.f32(6.2831855))
				var9 = vm.f32(var9 + vm.f32(6.2831855))
				var12 = var12 + 1
			end
			if at <= 2 then
				helper_468(10)
			end
			if at <= 3 then
				helper_6038(2150010)
			end
			if at <= 4 then
				helper_6038(2150020)
			end
			if at <= 5 then
				helper_29d8(0)
			end
			if at <= 6 then
				helper_468(6)
			end
			if at <= 7 then
				helper_6038(2150030)
			end
			if at <= 8 then
				helper_29d8(1)
			end
			if at <= 9 then
				helper_468(10)
			end
			if at <= 10 then
				helper_29d8(1)
			end
			if at <= 11 then
				helper_29d8(1)
			end
			if at <= 12 then
				helper_6038(2150040)
			end
			if at <= 13 then
				helper_6038(2150050)
			end
			if at <= 14 then
				helper_468(16)
			end
			if at <= 15 then
				helper_6038(2150060)
			end
			if vm.skip_end() then
				return skip(17)
			end
			return part2()
		end
		if at <= 17 then
			helper_468(45)
		end
		helper_12ca8()
	end
	function part2()
		event.CancelDramaScene()
		event.SetFadeOut(30)
		helper_468(45)
		if vm.skipping() then
			return skip(18)
		end
		helper_12ca8()
		event.ResetCamera(1, 0.0, 20.0)
		event.SetFadeIn(30)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFlag(215, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	var13 = event.SndLoadSound(2800) or var13
	helper_12f80()
	event.InitDramaScene()
	event.StopBgm(0)
	event.EohSetSoundId(0, var13)
	event.EohSetSoundId(1, var13)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "デフォルト顔")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.CharaActive(1, global0)
	event.CharaActive(1, global1)
	event.CmrsInit()
	event.CmrsSetPos(2810.55, 19.2, 1417.95)
	event.CmrsSetRef(2838.92, 19.55, 1472.76)
	event.ObjsSetPos(0, 3016.47, 0.01, 1619.33)
	event.ObjsSetRot(0, 0.0, -2.17, 0.0)
	event.ObjsSetPos(1, 3035.62, 0.01, 1589.73)
	event.ObjsSetRot(1, 0.0, -2.28, 0.0)
	event.ObjsMove(0, 2903.57, 0.01, 1552.25, 130)
	event.ObjsRotation(0, 0.0, -2.05, 0.0, 90)
	event.ObjsMove(1, 2918.09, 0.01, 1527.87, 130)
	event.ObjsRotation(1, 0.0, -2.04, 0.0, 90)
	event.ObjsSetMotion(0, "キョロキョロ歩き", 4, -1.0, 1)
	event.ObjsSetMotion(1, "きょろきょろ歩き", 4, -1.0, 1)
	var9 = vm.f32(0.46)
	var10 = vm.f32(0.0066666664)
	var12 = 0
	while var12 < 121 do
		do
			local out1, out2, out3 = event.GetCharaPos(global0)
			var6 = out1 or var6
			var7 = out2 or var7
			var8 = out3 or var8
		end
		do
			local out1, out2, out3 = event.GetCharaPos(global1)
			var0 = out1 or var0
			var1 = out2 or var1
			var2 = out3 or var2
		end
		do
			local out1, out2, out3 = event.SubVector(var0, var1, var2, var6, var7, var8)
			var0 = out1 or var0
			var1 = out2 or var1
			var2 = out3 or var2
		end
		do
			local out1, out2, out3 = event.ScaleVector(var0, var1, var2, 0.5)
			var0 = out1 or var0
			var1 = out2 or var1
			var2 = out3 or var2
		end
		do
			local out1, out2, out3 = event.AddVector(var6, var7, var8, var0, var1, var2)
			var6 = out1 or var6
			var7 = out2 or var7
			var8 = out3 or var8
		end
		var7 = vm.f32(var7 + 20.0)
		event.CmrsSetRef(var6, var7, var8)
		do
			local out1, out2, out3 = event.CopyVector(var6, var7, var8)
			vector_x = out1 or vector_x
			vector_y = out2 or vector_y
			vector_z = out3 or vector_z
		end
		vector_x = vm.f32(vector_x + vm.f32(130.0 * vm.sin(var9)))
		vector_z = vm.f32(vector_z + vm.f32(130.0 * vm.cos(var9)))
		vector_y = vm.f32(vector_y + vm.f32(29.79))
		event.CmrsSetPos(vector_x, vector_y, vector_z)
		var9 = vm.f32(var9 + var10)
		if var9 > vm.f32(3.1415927) then
			var9 = vm.f32(var9 - vm.f32(6.2831855))
		end
		if var9 <= vm.f32(-3.1415927) then
			var9 = vm.f32(var9 + vm.f32(6.2831855))
		end
		var12 = var12 + 1
		if vm.wait() then
			return skip(2)
		end
	end
	helper_468(10)
	if vm.skipping() then
		return skip(3)
	end
	event.CmrsSetPos(2803.91, 11.38, 1411.86)
	event.CmrsSetRef(2831.84, 19.55, 1460.49)
	event.ObjsSetPos(0, 2831.19, 0.01, 1465.72)
	event.ObjsSetRot(0, 0.0, -2.05, 0.0)
	event.ObjsSetPos(1, 2837.63, 0.01, 1446.26)
	event.ObjsSetRot(1, 0.0, -1.92, 0.0)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おこり顔")
	event.ObjsTexAnime(0, 1, "おこり目パチ")
	event.ObjsSetMotion(0, "立ち", 4)
	event.ObjsSetMotion(1, "立ち", 4, -1.0, 1)
	event.SetPakuAnim(1, "通常口パク")
	helper_6038(2150010)
	if vm.skipping() then
		return skip(4)
	end
	event.ResetPakuAnim()
	event.SndSePlay(var13, 4)
	event.ObjsSetMotion(0, "待って", 6, -1.0, 1)
	event.ObjsNextMotion(0, "待ってL", 0)
	event.SetPakuAnim(0, "通常口パク")
	helper_6038(2150020)
	if vm.skipping() then
		return skip(5)
	end
	event.ResetPakuAnim()
	helper_29d8(0)
	if vm.skipping() then
		return skip(6)
	end
	event.ObjsSetMotion(1, "左向く", 6)
	event.ObjsNextMotion(1, "左向くL", 0)
	helper_468(6)
	if vm.skipping() then
		return skip(7)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_6038(2150030)
	if vm.skipping() then
		return skip(8)
	end
	event.ResetPakuAnim()
	helper_29d8(1)
	if vm.skipping() then
		return skip(9)
	end
	event.ObjsSetMotion(0, "待って戻り", 6, -1.0, 1)
	event.ObjsNextMotion(0, "立ち", 4)
	helper_468(10)
	if vm.skipping() then
		return skip(10)
	end
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "おこり顔")
	event.ObjsTexAnime(1, 1, "おこり目パチ")
	event.ObjsSetMotion(1, "左向く戻り", 2)
	event.ObjsMotionWait(1)
	helper_29d8(1)
	if vm.skipping() then
		return skip(11)
	end
	event.SndSePlay(var13, 5)
	event.ObjsNextMotion(1, "身を乗り出す", 2)
	event.ObjsNextMotion(1, "身を乗り出すＬ", 0)
	helper_29d8(1)
	if vm.skipping() then
		return skip(12)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_6038(2150040)
	if vm.skipping() then
		return skip(13)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(1, "身を乗り出す戻り", 6)
	event.ObjsMotionDelay(0, 30)
	event.ObjsSetMotion(0, "右向く", 6)
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "デフォルト顔")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.SetPakuAnim(1, "通常口パク")
	helper_6038(2150050)
	if vm.skipping() then
		return skip(14)
	end
	event.ResetPakuAnim()
	event.ObjsNextMotion(0, "右向くうなづき", 2)
	event.ObjsNextMotion(0, "右向くL", 0)
	helper_468(16)
	if vm.skipping() then
		return skip(15)
	end
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.SetPakuAnim(0, "通常口パク")
	helper_6038(2150060)
	if vm.skipping() then
		return skip(16)
	end
	event.ResetPakuAnim()
	return part2()
end

--- Program 501.
local function program_501()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_13bcc()
			if not vm.skipping() then
				return part2()
			end
		end
		helper_11ee8()
	end
	function part2()
		event.SetCnt(3, 1)
		helper_11ee8()
	end
	if vm.skipping() then
		return skip(1)
	end
	helper_13bcc()
	if vm.skipping() then
		return skip(2)
	end
	return part2()
end

--- Helper function.
local function helper_d8c(arg0: s32)
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
local function helper_f90(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			local _ = helper_d8c(arg0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	while true do
		if helper_d8c(arg0) ~= 0 then
			break
		else
			if vm.wait() then
				return skip(2)
			end
		end
	end
end

--- Helper function.
local function helper_e238()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			helper_468(10)
		end
	end
	event.Initialize()
	event.SetMotion(0, "立ち")
	event.SetFadeOut(10)
	helper_468(10)
	if vm.skipping() then
		return skip(1)
	end
	event.GotoMenu(7)
	if vm.wait() then
		return skip(2)
	end
	event.SetFadeIn(10)
	helper_468(10)
	if vm.skipping() then
		return skip(3)
	end
end

--- Helper function.
local function helper_15ebc()
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
	event.SetMesWindowMode(0, 7)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		global0 = 0
		global1 = 32
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.LoadMotion(5, "event/e200/e220/e220_mints.gltf", "info", global0)
		event.EohSyncChara(0, global0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global0)
		event.LoadChara(5, "chara/c02_base.gltf", "info", global1)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.EohSyncChara(1, global1)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.LoadEquip(5, 1, 4, "info", global1)
		event.LoadEquip(5, 1, 3, "info", global1)
		event.LoadEquip(5, 1, 2, "info", global1, 37)
		event.CharaActive(0, global1)
		event.CharaActive(1, 37)
	end
	if active_chr_no == 1 then
		global0 = 32
		global1 = 0
		event.LoadChara(5, "chara/c01_base.gltf", "info", global0)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.LoadMotion(5, "event/e200/e220/e220_mints.gltf", "info", global0)
		event.EohSyncChara(0, global0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.LoadEquip(5, 0, 4, "info", global0)
		event.LoadEquip(5, 0, 3, "info", global0)
		event.LoadEquip(5, 0, 2, "info", global0, 37)
		event.CharaActive(0, global0)
		event.CharaActive(1, 37)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.EohSyncChara(1, global1)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global1)
	end
	event.LoadChara(5, "event/e200/e220/e220_noam.gltf", "info", 34)
	event.CharaActive(0, 34)
	event.EohSyncChara(2, 34)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.EohSyncObj(3, 34, "wine")
	event.LoadChara(5, "item/f_rod.gltf", "info", 35)
	event.CharaActive(0, 35)
	event.EohSyncChara(4, 35)
	event.ObjsInit(3, 35)
	event.ObjsSyncObj(3, 4)
	event.LoadChara(5, "event/itemget_ev/itemget_ev.gltf", "info", 36)
	event.CharaActive(0, 36)
	event.EohSyncChara(5, 36)
	event.ObjsInit(4, 36)
	event.ObjsSyncObj(4, 5)
	event.LoadMes(0, 5, "event/e200/e220/e220.txt")
end

--- Helper function.
local function helper_2af4(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesWindowMode(arg0, arg1)
end

--- Helper function.
local function helper_43a0(arg0: any, arg1: s32)
	local var2: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local var5: s32 = 0
	local stream_playing: s32 = 0
	local var7: s32 = 0
	local pressed: s32 = 0
	local pressed_2: s32 = 0
	local pressed_3: s32 = 0
	local pressed_4: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		var2 = 0
		var3 = 0
		var2 = 1
		var3 = 1
		var5 = 1
		var5 = 0
		var5 = 0
		return 0
	end
	if vm.skipping() then
		return skip(1)
	end
	var2 = 0
	var3 = 0
	if arg1 == 1 then
		var2 = 1
	end
	if arg1 == 2 then
		var3 = 1
	end
	var4 = event.GetMesWindowMode(arg0) or var4
	var5 = 1
	if var4 == 7 then
		var5 = 0
	end
	if var4 == 0 then
		var5 = 0
	end
	stream_playing = event.GetMesVoice() or stream_playing
	var7 = event.GetMesStatus(arg0) or var7
	if var7 == 0 then
		return 0
	end
	if var7 == 1 then
		return 0
	end
	if var7 == 3 then
		if stream_playing == 0 then
			event.TrgPakuAnim(0)
			event.TrgPakuMotion(1)
		end
	end
	if var7 == 4 then
		return 0
	end
	if var7 == 5 then
		if stream_playing == 0 then
			event.TrgPakuAnim(0)
			event.TrgPakuMotion(1)
		end
	end
	pressed = event.CheckButton(0) or pressed
	pressed_2 = event.CheckButton(1) or pressed_2
	pressed_3 = event.CheckButton(2) or pressed_3
	pressed_4 = event.CheckButton(3) or pressed_4
	if
		(
			if (if (if pressed ~= 0 then 1 else pressed_2) ~= 0 then 1 else if var2 ~= 0 then pressed_3 else 0)
					~= 0
				then 1
				else if var3 ~= 0 then pressed_4 else 0
		) ~= 0
	then
		if var5 ~= 0 then
			if pressed_2 ~= 0 then
				event.MesSePlay(0)
			end
			if pressed ~= 0 then
				event.MesSePlay(1)
			end
			if (if var2 ~= 0 then pressed_3 else 0) ~= 0 then
				event.MesSePlay(0)
			end
			if (if var3 ~= 0 then pressed_4 else 0) ~= 0 then
				event.MesSePlay(0)
			end
		end
		if var7 == 5 then
			event.MesNextpage(arg0)
			if stream_playing == 0 then
				event.TrgPakuAnim(1)
				event.TrgPakuMotion(0)
			end
		end
		if var7 == 3 then
			if stream_playing == 0 then
				event.TrgPakuAnim(0)
				event.TrgPakuMotion(2)
			end
			if (if var2 ~= 0 then pressed_3 else 0) ~= 0 then
				return 2
			end
			if (if var3 ~= 0 then pressed_4 else 0) ~= 0 then
				return 3
			end
			return 1
		end
		if var7 ~= 5 and var7 ~= 3 then
			event.SetMesDrawspeed(arg0, 0.0)
			event.TrgPakuAnim(0)
			event.TrgPakuMotion(1)
			if stream_playing ~= 0 then
				event.StreamStop(1)
			end
		end
	end
	return 0
end

--- Helper function.
local function helper_7d6c(arg0: any, arg1: s32, arg2: s32)
	local var3: s32 = 0
	local var4: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var4 = 0
			var3 = helper_43a0(arg0, arg1)
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
		var3 = helper_43a0(arg0, arg1)
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
local function helper_8834(arg0: s32, arg1: any, arg2: s32, arg3: s32, arg4: s32)
	local var6: s32 = 0
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			local _ = helper_2b80(arg0, arg1, arg2, arg3, arg4)
			_, var6 = helper_7d6c(arg0, 0, var6)
		end
		helper_2dc4(arg0)
	end
	if vm.skipping() then
		return skip(1)
	end
	local _ = helper_2b80(arg0, arg1, arg2, arg3, arg4)
	_, var6 = helper_7d6c(arg0, 0, var6)
	if vm.skipping() then
		return skip(2)
	end
	helper_2dc4(arg0)
end

--- Helper function.
local function helper_ce6c(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local argc: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_2af4(1, 4)
			var2 = -1
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(1, 4)
	helper_2af4(1, 4)
	var2 = -1
	if arg1 <= 0 then
		return
	end
	if arg1 == 1 then
		var2 = 10
		event.SetMesItem(1, 1, arg0)
	end
	if 1 < arg1 then
		var2 = 11
		event.SetMesItem(1, 1, arg0)
		event.SetMesValue(1, 2, arg1)
	end
	if var2 == -1 then
		return
	end
	argc = event.GetSysSndId() or argc
	event.SndSePlay(argc, 18)
	helper_8834(1, var2, 8, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_15b78()
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
	event.DeleteChara(34)
	event.DeleteChara(35)
	event.DeleteChara(36)
end

--- Helper function.
local function helper_56c()
	local argc: s32 = 0
	local argc_2: s32 = 0
	local argc_3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	argc = event.CheckGetItemLimit() or argc
	argc_2 = event.CheckItemOver() or argc_2
	if argc >= 1 or argc_2 >= 1 then
		argc_3 = event.GetNowLoopNo() or argc_3
		if argc_3 == 1 then
			event.GotoMenu(16)
			if vm.wait() then
				return skip(2)
			end
			return
		end
		if argc_3 == 2 then
			event.GotoMenu(17)
			if vm.wait() then
				return skip(3)
			end
			return
		end
	end
end

--- Helper function.
local function helper_16de0()
	local var1: s32 = 0
	local var2: s32 = 0
	local flag: s32 = 0
	local var4: s32 = 0
	local var5: s32 = 0
	local flag_2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_15ebc()
			helper_468(15)
		end
		if at <= 2 then
			helper_6038(2200010)
		end
		if at <= 3 then
			helper_6038(2200020)
		end
		if at <= 4 then
			helper_29d8(0)
		end
		if at <= 5 then
			helper_6038(2200030)
		end
		if at <= 6 then
			helper_6038(2200040)
		end
		if at <= 7 then
			helper_468(15)
		end
		if at <= 8 then
			helper_468(10)
		end
		if at <= 9 then
			helper_6038(2200050)
		end
		if at <= 10 then
			helper_6038(2200055)
		end
		if at <= 11 then
			helper_468(16)
		end
		if at <= 13 then
			helper_6038(2200080)
		end
		if at <= 14 then
			helper_6038(2200085)
		end
		if at <= 15 then
			helper_6038(2200090)
		end
		if at <= 16 then
			helper_ce6c(302, 1)
		end
		if at <= 17 then
			helper_ce6c(313, 1)
		end
		if at <= 18 then
			helper_6038(2200095)
		end
		if at <= 19 then
			helper_8834(0, -1, 8, 0, 0)
		end
		if at <= 20 then
			helper_8834(0, -1, 8, 0, 0)
		end
		if at <= 21 then
			helper_468(16)
		end
		if at <= 22 then
			helper_468(5)
		end
		if at <= 23 then
			helper_6038(2200060)
		end
		if at <= 24 then
			helper_29d8(2)
		end
		if at <= 25 then
			helper_468(15)
		end
		if at <= 26 then
			helper_6038(2200070)
		end
		if at <= 27 then
			helper_29d8(2)
		end
		if at <= 28 then
			helper_468(45)
		end
		if at <= 29 then
			helper_15b78()
			helper_56c()
		end
	end
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	var5 = event.SndLoadSound(2803) or var5
	var4 = event.SndLoadSound(8, "snd2/sp/sp_006.sound.json") or var4
	event.SetFadeOut(30)
	helper_468(45)
	if vm.skipping() then
		return skip(1)
	end
	helper_15ebc()
	event.StopBgm(0)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.CharaActive(0, 9)
	event.CharaActive(1, global0)
	event.CharaActive(1, global1)
	event.CharaActive(1, 34)
	event.CmrsSetPos(2187.89, 60.39, 925.42)
	event.CmrsSetRef(2234.31, 29.74, 1032.94)
	event.ObjsSetPos(0, 2298.04, 0.0, 1110.65)
	event.ObjsSetRot(0, 0.0, -2.41, 0.0)
	event.ObjsSetPos(1, 2311.91, 0.0, 1092.4)
	event.ObjsSetRot(1, 0.0, -2.28, 0.0)
	event.ObjsSetPos(2, 2199.07, 29.83, 981.55)
	event.ObjsSetRot(2, 0.0, 2.68, 0.0)
	var2 = event.EohGetFrameStatus(2, "wine") or var2
	event.EohSetFrameShow(2, "wine", 0)
	event.EohSetSoundId(2, var5)
	event.SetFadeIn(30)
	flag = event.GetFlag(220) or flag
	if flag == 0 then
		event.SetFlag(220, 1)
		event.ObjsSetMotion(0, "立ち", 4, -1.0, 1)
		event.ObjsSetMotion(1, "立ち", 4, -1.0, 1)
		event.ObjsSetMotion(2, "釣り", 4)
		helper_468(15)
		if vm.skipping() then
			return skip(2)
		end
		event.ObjsSetMotion(2, "釣り会話", 0)
		event.ObjsMotionDelay(2, 195)
		event.ObjsSetMotion(2, "釣り", 0)
		helper_6038(2200010)
		if vm.skipping() then
			return skip(3)
		end
		event.ObjsInit(2)
		event.ObjsSyncObj(2, 2)
		event.ObjsSetMotion(2, "釣り", 0)
		event.ObjsSetMotion(0, "会話", 2)
		event.ObjsNextMotion(0, "立ち", 0)
		event.SetPakuAnim(0, "通常口パク")
		helper_6038(2200020)
		if vm.skipping() then
			return skip(4)
		end
		event.ResetPakuAnim()
		helper_29d8(0)
		if vm.skipping() then
			return skip(5)
		end
		event.ObjsSetMotion(2, "釣り会話", 0)
		event.ObjsMotionDelay(2, 270)
		event.ObjsSetMotion(2, "釣り", 0)
		helper_6038(2200030)
		if vm.skipping() then
			return skip(6)
		end
		event.ObjsInit(2)
		event.ObjsSyncObj(2, 2)
		event.ObjsSetMotion(2, "釣り", 0)
		event.ObjsSetMotion(2, "釣り会話", 0)
		event.ObjsMotionDelay(2, 180)
		event.ObjsSetMotion(2, "釣り", 0)
		helper_6038(2200040)
		if vm.skipping() then
			return skip(7)
		end
		event.ObjsInit(2)
		event.ObjsSyncObj(2, 2)
		event.ObjsSetMotion(2, "釣り", 0)
	else
		event.ObjsSetMotion(0, "立ち", 4, -1.0, 1)
		event.ObjsSetMotion(1, "立ち", 4, -1.0, 1)
		event.ObjsSetMotion(2, "釣り", 4)
	end
	helper_468(15)
	if vm.skipping() then
		return skip(8)
	end
	event.ObjsMotionDelay(2, 30)
	event.ObjsSetMotion(2, "右向く", 6)
	event.ObjsNextMotion(2, "右向くL", 0)
	helper_468(10)
	if vm.skipping() then
		return skip(9)
	end
	helper_6038(2200050)
	if vm.skipping() then
		return skip(10)
	end
	helper_6038(2200055)
	if vm.skipping() then
		return skip(11)
	end
	event.ObjsSetMotion(0, "右向く", 6, -1.0, 1)
	event.ObjsNextMotion(0, "右向くL", 4)
	event.ObjsSetMotion(1, "左向く", 6, -1.0, 1)
	event.ObjsNextMotion(1, "左向くL", 4)
	helper_468(16)
	if vm.skipping() then
		return skip(12)
	end
	event.GotoUseItem(370)
	do
		local skipped = vm.wait()
		var1 = event.DeferredOutput() or var1
		if skipped then
			return skip(13)
		end
	end
	if var1 == 370 then
		event.SetFlag(28, 1)
		event.EohSetFrameStatus(2, "wine", var2)
		event.EohSetFrameShow(2, "wine", 1)
		event.CmrsSetPos(2256.03, 46.87, 1157.6)
		event.CmrsSetRef(2209.88, 21.76, 1049.74)
		event.ObjsSetPos(0, 2212.29, 0.0, 1088.81)
		event.ObjsSetRot(0, 0.0, 3.03, 0.0)
		event.ObjsSetPos(1, 2241.69, 0.0, 1085.4)
		event.ObjsSetRot(1, 0.0, -2.64, 0.0)
		event.ObjsSetPos(2, 2211.11, -1.43, 1044.24)
		event.ObjsSetRot(2, 0.0, 0.16, 0.0)
		event.ObjsSetMotion(0, "立ち", 4, -1.0, 1)
		event.ObjsSetMotion(1, "立ち", 4, -1.0, 1)
		event.ObjsSetMotion(2, "とびおり", 6)
		event.SetPakuAnim(0, "通常口パク")
		helper_6038(2200080)
		if vm.skipping() then
			return skip(14)
		end
		event.ResetPakuAnim()
		event.SetPakuAnim(0, "通常口パク")
		helper_6038(2200085)
		if vm.skipping() then
			return skip(15)
		end
		event.ResetPakuAnim()
		event.SndSePlay(var5, 5)
		event.ObjsSetMotion(2, "竿やる", 2)
		event.ObjsNextMotion(2, "竿やるL", 0)
		helper_6038(2200090)
		if vm.skipping() then
			return skip(16)
		end
		event.EohSetFrameShow(2, "rod", 0)
		event.EohSetFrameShow(2, "obj3", 0)
		event.EohSetFrameShow(2, "obj4", 0)
		event.CharaActive(0, global1)
		event.CharaActive(0, 34)
		event.CharaActive(1, 35)
		event.CharaActive(1, 36)
		event.CmrsSetPos(2216.13, 50.5, 1037.69)
		event.CmrsSetRef(2211.23, 28.7, 1078.48)
		event.ObjsSetPos(4, 2209.46, 34.32, 1071.72)
		event.ObjsSetRot(4, 0.0, 0.0, 0.0)
		event.SndSePlay(var5, 6)
		event.SndSePlay(var4, 0)
		event.SetReference(global0, "gun_hand", 35)
		event.ObjsSetMotion(0, "釣り竿ゲット", 4, -1.0, 1)
		event.ObjsSetMotion(4, "発動", 6)
		helper_ce6c(302, 1)
		if vm.skipping() then
			return skip(17)
		end
		helper_ce6c(313, 1)
		if vm.skipping() then
			return skip(18)
		end
		event.CharaActive(1, global1)
		event.CharaActive(1, 34)
		event.CharaActive(0, 35)
		event.CharaActive(0, 36)
		event.CmrsSetPos(2256.03, 46.87, 1157.6)
		event.CmrsSetRef(2209.88, 21.76, 1049.74)
		event.EohSetFrameShow(2, "chn64", 0)
		event.ObjsSetPos(0, 2212.29, 0.0, 1088.81)
		event.ObjsSetRot(0, 0.0, 3.03, 0.0)
		event.ObjsSetPos(1, 2241.69, 0.0, 1085.4)
		event.ObjsSetRot(1, 0.0, -2.64, 0.0)
		event.ObjsSetMotion(0, "立ち", 4, -1.0, 1)
		event.ObjsSetMotion(1, "立ち", 4, -1.0, 1)
		event.ObjsSetMotion(2, "立ち", 4)
		event.ObjsSetMotion(2, "会話", 6)
		event.ObjsNextMotion(2, "立ち", 0)
		helper_6038(2200095)
		if vm.skipping() then
			return skip(19)
		end
		event.SetMesWindowMode(0, 8)
		event.MesMake_2(
			0,
			"[(!)] 釣りをするには、釣り竿を装備してください。\n   次にエサ（ミミー）をアイテムメニューのコマンドで\n   竿につけます。エサをつけ忘れると釣れません。"
		)
		helper_8834(0, -1, 8, 0, 0)
		if vm.skipping() then
			return skip(20)
		end
		event.MesMake_2(
			0,
			"[(!)]その状態で、水際に立って(O)ボタンを\n   押せば、釣りを始めることができます。"
		)
		helper_8834(0, -1, 8, 0, 0)
		if vm.skipping() then
			return skip(21)
		end
		event.SetMesWindowMode(0, 7)
	else
		event.ObjsSetMotion(0, "右向く戻り", 6, -1.0, 1)
		event.ObjsNextMotion(0, "立ち", 4)
		event.ObjsSetMotion(1, "左向く戻り", 6, -1.0, 1)
		event.ObjsNextMotion(1, "立ち", 4)
		helper_468(16)
		if vm.skipping() then
			return skip(22)
		end
		if var1 <= 0 then
			event.ObjsSetMotion(2, "そっぽ向く", 2)
			event.ObjsNextMotion(2, "そっぽ向くL", 0)
			helper_468(5)
			if vm.skipping() then
				return skip(23)
			end
			helper_6038(2200060)
			if vm.skipping() then
				return skip(24)
			end
			helper_29d8(2)
			if vm.skipping() then
				return skip(25)
			end
			event.CmrsSetPos(2342.69, 17.58, 1135.11)
			event.CmrsSetRef(2285.51, 29.74, 1075.97)
		else
			event.ObjsSetMotion(2, "首を振る", 6)
			event.ObjsNextMotion(2, "釣り", 0)
			helper_468(15)
			if vm.skipping() then
				return skip(26)
			end
			helper_6038(2200070)
			if vm.skipping() then
				return skip(27)
			end
			helper_29d8(2)
			if vm.skipping() then
				return skip(28)
			end
			event.CmrsSetPos(2342.69, 17.58, 1135.11)
			event.CmrsSetRef(2285.51, 29.74, 1075.97)
		end
	end
	event.SetFadeOut(30)
	helper_468(45)
	if vm.skipping() then
		return skip(29)
	end
	helper_15b78()
	event.CharaActive(1, 9)
	flag_2 = event.GetFlag(28) or flag_2
	if flag_2 ~= 0 then
		event.AddItem(302, 1)
		event.AddItem(313, 1)
		helper_56c()
		if vm.skipping() then
			return skip(30)
		end
		event.SubItem(370, 1)
		event.EohSyncChara(0, 9)
		event.EohSetFrameStatus(0, "wine", 1)
	end
	event.ResetCamera(0)
	event.SetFadeIn(30)
end

--- Helper function.
local function helper_19c30()
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
	event.SetMesWindowMode(0, 7)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		global0 = 0
		global1 = 32
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.LoadMotion(5, "event/e200/e240/e240_mints.gltf", "info", global0)
		event.EohSyncChara(0, global0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global0)
		event.LoadChara(5, "chara/c02_base.gltf", "info", global1)
		event.LoadEquip(5, 1, 4, "info", global1)
		event.LoadEquip(5, 1, 3, "info", global1)
		event.LoadEquip(5, 1, 2, "info", global1, 37)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.LoadMotion(5, "event/e200/e240/e240_monica.gltf", "info", global1)
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
		event.LoadMotion(5, "event/e200/e240/e240_mints.gltf", "info", global0)
		event.EohSyncChara(0, global0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global0)
		event.CharaActive(1, 37)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.LoadMotion(5, "event/e200/e240/e240_monica.gltf", "info", global1)
		event.EohSyncChara(1, global1)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global1)
	end
	event.LoadChara(5, "event/e200/e240/e240_madan.gltf", "info", 34)
	event.CharaActive(0, 34)
	event.EohSyncChara(2, 34)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.LoadChara(5, "event/e200/e240/e240_sao.gltf", "info", 35)
	event.CharaActive(0, 35)
	event.EohSyncChara(4, 35)
	event.ObjsInit(3, 35)
	event.ObjsSyncObj(3, 4)
	event.LoadChara(5, "event/e200/e240/e240_wink.gltf", "info", 38)
	event.CharaActive(0, 38)
	event.SetCharaType(38, 4)
	event.LoadChara(5, "event/e200/e240/mizubasira.gltf", "info", 39)
	event.CharaActive(0, 39)
	event.LoadChara(5, "event/e200/e240/hamon.gltf", "info", 40)
	event.CharaActive(0, 40)
	event.LoadChara(5, "event/e200/e240/e240_line.gltf", "info", 41)
	event.CharaActive(0, 41)
	event.EohSyncChara(5, 41)
	event.ObjsInit(4, 41)
	event.ObjsSyncObj(4, 5)
	event.LoadChara(5, "event/e200/e240/e240_line1.gltf", "info", 42)
	event.CharaActive(0, 42)
	event.LoadMes(0, 5, "event/e200/e240/e240.txt")
end

--- Helper function.
local function helper_3518(arg0: s32, arg1: any, arg2: any)
	local argc: s32 = 0
	local argc_2: s32 = 0
	local var6: s32 = 0
	local var7: s32 = 0
	local loud: s32 = 0
	local var9: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var6 = 0
			loud = 0
			var9 = 1
			argc_2 = argc
			var9 = 0
			var7 = loud
		end
		var6 = vm.i32(var6 + 1)
		var9 = 0
		helper_2dc4(arg0)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesOkuri(arg0, 0)
	event.TrgPakuAnim(1)
	event.TrgPakuMotion(0)
	var6 = 0
	argc_2 = event.StreamGetStatus(1) or argc_2
	loud = 0
	var9 = 1
	while var9 ~= 0 do
		argc_2 = argc
		argc = event.StreamGetStatus(1) or argc
		if argc_2 ~= 0 and argc == 0 then
			event.TrgPakuMotion(2)
			if arg1 == -1 then
				var9 = 0
			end
		end
		var7 = loud
		loud = event.StreamSilentCheck(1) or loud
		if var7 == 0 and loud == 1 then
			event.TrgPakuAnim(1)
		end
		if var7 == 1 and loud == 0 then
			event.TrgPakuAnim(0)
		end
		if vm.wait() then
			return skip(2)
		end
		var6 = vm.i32(var6 + 1)
		if arg1 ~= -1 then
			if arg1 <= var6 then
				var9 = 0
			end
		end
		if arg2 == var6 then
			helper_2dc4(arg0)
		end
	end
	event.ResetPakuMotion()
	event.TrgPakuAnim(0)
	event.ResetPakuAnim()
	event.StreamStop(1)
	event.SetMesOkuri(arg0, 1)
end

--- Helper function.
local function helper_3c1c(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_3518(arg0, vm.ftoi(arg1), -1)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	helper_3518(arg0, vm.ftoi(arg1), -1)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_5684(arg0: s32, arg1: s32)
	local stream_open_state: s32 = 0
	local stream_open_state_2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			helper_2b80(0, -1, 8, 0, 0)
			helper_3c1c(0, arg1)
		end
		helper_2dc4(0)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.StreamOpen3(1, arg0)
	while true do
		stream_open_state = event.StreamOpenCheck() or stream_open_state
		if stream_open_state == 0 then
			break
		else
			if vm.wait() then
				return skip(2)
			end
		end
	end
	event.StreamStandby(1)
	while true do
		stream_open_state_2 = event.StreamOpenCheck() or stream_open_state_2
		if stream_open_state_2 == 0 then
			break
		else
			if vm.wait() then
				return skip(3)
			end
		end
	end
	event.MesMake_2(0, arg0)
	helper_2b80(0, -1, 8, 0, 0)
	event.StreamPlay(1)
	helper_3c1c(0, arg1)
	if vm.skipping() then
		return skip(4)
	end
	helper_2dc4(0)
	event.StreamClose(1)
	event.SetMesPos(0, 0)
end

--- Helper function.
local function helper_1985c()
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
	event.DeleteChara(34)
	event.DeleteChara(35)
	event.DeleteChara(38)
	event.DeleteChara(39)
	event.DeleteChara(40)
	event.DeleteChara(41)
	event.DeleteChara(42)
end

--- Helper function.
local function helper_1aea8()
	local var4: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 70 then
			if at <= 1 then
				helper_468(45)
			end
			if at <= 2 then
				helper_19c30()
			end
			if at <= 3 then
				helper_468(15)
			end
			if at <= 4 then
				helper_29d8(0)
			end
			if at <= 5 then
				helper_468(30)
			end
			if at <= 6 then
				helper_29d8(0)
			end
			if at <= 7 then
				helper_468(60)
			end
			if at <= 8 then
				helper_468(15)
			end
			if at <= 9 then
				helper_468(30)
			end
			if at <= 10 then
				helper_468(30)
			end
			if at <= 11 then
				helper_468(30)
			end
			if at <= 12 then
				helper_29d8(1)
			end
			if at <= 13 then
				helper_29d8(1)
			end
			if at <= 14 then
				helper_468(30)
			end
			if at <= 15 then
				helper_468(15)
			end
			if at <= 16 then
				helper_468(60)
			end
			if at <= 21 then
				helper_468(60)
			end
			if at <= 22 then
				helper_468(10)
			end
			if at <= 23 then
				helper_5684(2400010, -1)
			end
			if at <= 24 then
				helper_5684(2400015, -1)
			end
			if at <= 25 then
				helper_468(30)
			end
			if at <= 26 then
				helper_468(120)
			end
			if at <= 27 then
				helper_6038(2400020)
			end
			if at <= 28 then
				helper_29d8(1)
			end
			if at <= 29 then
				helper_6038(2400025)
			end
			if at <= 30 then
				helper_29d8(1)
			end
			if at <= 31 then
				helper_468(15)
			end
			if at <= 32 then
				helper_29d8(2)
			end
			if at <= 33 then
				helper_5684(2400030, -1)
			end
			if at <= 34 then
				helper_468(30)
			end
			if at <= 35 then
				helper_29d8(2)
			end
			if at <= 36 then
				helper_5684(2400035, -1)
			end
			if at <= 37 then
				helper_6038(2400040)
			end
			if at <= 38 then
				helper_29d8(1)
			end
			if at <= 39 then
				helper_6038(2400045)
			end
			if at <= 40 then
				helper_29d8(1)
			end
			if at <= 41 then
				helper_6038(2400050)
			end
			if at <= 42 then
				helper_29d8(2)
			end
			if at <= 43 then
				helper_5684(2400055, -1)
			end
			if at <= 44 then
				helper_6038(2400060)
			end
			if at <= 45 then
				helper_29d8(1)
			end
			if at <= 46 then
				helper_6038(2400070)
			end
			if at <= 47 then
				helper_29d8(0)
			end
			if at <= 48 then
				helper_29d8(2)
			end
			if at <= 49 then
				helper_5684(2400080, -1)
			end
			if at <= 50 then
				helper_5684(2400085, -1)
			end
			if at <= 51 then
				helper_6038(2400090)
			end
			if at <= 52 then
				helper_5684(2400095, -1)
			end
			if at <= 53 then
				helper_5684(2400100, -1)
			end
			if at <= 54 then
				helper_5684(2400105, -1)
			end
			if at <= 55 then
				helper_6038(2400110)
			end
			if at <= 56 then
				helper_5684(2400115, -1)
			end
			if at <= 57 then
				helper_468(60)
			end
			if at <= 58 then
				helper_6038(2400120)
			end
			if at <= 59 then
				helper_29d8(0)
			end
			if at <= 60 then
				helper_6038(2400125)
			end
			if at <= 61 then
				helper_29d8(0)
			end
			if at <= 62 then
				helper_6038(2400130)
			end
			if at <= 63 then
				helper_6038(2400140)
			end
			if at <= 64 then
				helper_29d8(1)
			end
			if at <= 65 then
				helper_468(30)
			end
			if at <= 66 then
				helper_468(15)
			end
			if at <= 67 then
				helper_5684(2400150, -1)
			end
			if at <= 68 then
				helper_468(60)
			end
			if at <= 69 then
				helper_468(35)
			end
			if vm.skip_end() then
				return skip(71)
			end
			return part2()
		end
		helper_1985c()
	end
	function part2()
		event.CancelDramaScene()
		event.SndSeStop(var4, 4)
		event.SndSeStop(var4, 6)
		event.SndSeStop(var4, 10)
		event.StopBgm(0)
		helper_1985c()
		event.ResetCamera(0)
		event.SetFadeIn(30)
	end
	event.SetFlag(240, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.StopBgm(0)
	helper_468(4)
	if vm.skipping() then
		return skip(1)
	end
	event.LoadBgm(193)
	event.PlayBgm(1)
	event.LoadSound(2812)
	var4 = event.SndLoadSound(2812) or var4
	event.SetFadeOut(30)
	helper_468(45)
	if vm.skipping() then
		return skip(2)
	end
	helper_19c30()
	event.InitDramaScene()
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "デフォルト顔")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.CharaActive(1, global0)
	event.CharaActive(1, global1)
	event.CharaActive(1, 35)
	event.CharaActive(0, 34)
	event.CharaActive(1, 41)
	event.SetCameraPos(-111.63, 33.95, -443.55)
	event.SetCameraRef(-297.56, 30.0, -373.68)
	event.SetCharaPos(0, -297.56, 0.0, -373.68)
	event.SetCharaRot(0, 0.0, 2.57, 0.0)
	event.ObjsSetPos(0, -303.57, 0.0, -356.14)
	event.ObjsSetRot(0, 0.0, 2.57, 0.0)
	event.ObjsSetPos(1, -327.35, 0.0, -377.28)
	event.ObjsSetRot(1, 0.0, 2.57, 0.0)
	event.ObjsSetPos(2, -127.39, 0.0, -701.37)
	event.ObjsSetRot(2, 0.0, -1.68, 0.0)
	event.SetCharaRot(41, 0.0, 0.0, 1.57)
	event.SetReference(35, "ito", 41)
	if vm.wait() then
		return skip(3)
	end
	event.SetReference(global0, "gun_hand", 35)
	event.SndSePlay(var4, 4)
	event.SndSePlay(var4, 6)
	event.SetFadeIn(30)
	event.SetMotion(41, "糸切れる", 5, -1, 1)
	event.ObjsSetMotion(0, "竿を引く", 4, -1.0, 1)
	event.ObjsSetMotion(3, "竿を引く", 4)
	event.ObjsSetMotion(1, "釣り観戦", 4, -1.0, 1)
	helper_468(15)
	if vm.skipping() then
		return skip(4)
	end
	event.ObjsMove(0, -300.7, 0.0, -364.52, 90)
	event.SndSePlay(var4, 5)
	helper_29d8(0)
	if vm.skipping() then
		return skip(5)
	end
	helper_468(30)
	if vm.skipping() then
		return skip(6)
	end
	event.CmrsSetPos(-331.46, 23.14, -254.41)
	event.CmrsSetRef(-295.08, 10.97, -376.82)
	event.ObjsMove(0, -297.56, 0.0, -373.68, 90)
	event.SndSePlay(var4, 8)
	helper_29d8(0)
	if vm.skipping() then
		return skip(7)
	end
	helper_468(60)
	if vm.skipping() then
		return skip(8)
	end
	event.SndSeStop(var4, 4)
	event.SndSeStop(var4, 6)
	event.SndSePlay(var4, 7)
	event.SetMotion(41, "糸切れる", 2, -1, 1)
	event.CharaActive(1, 42)
	event.SetCharaPos(42, -184.19, -4.56, -446.98)
	event.SetCharaRot(42, 0.0, 2.57, 0.0)
	event.SetMotion(42, "糸切れる", 2, -1, 1)
	event.ObjsSetMotion(0, "糸切れる", 2)
	event.ObjsSetMotion(3, "糸切れる", 2)
	event.ObjsSetMotion(1, "ユリス追う（顔）", 2)
	helper_468(15)
	if vm.skipping() then
		return skip(9)
	end
	event.SndSePlay(var4, 5)
	helper_468(30)
	if vm.skipping() then
		return skip(10)
	end
	event.CharaActive(0, 42)
	event.CharaActive(0, 41)
	event.CharaActive(0, 35)
	event.DeleteChara(35)
	event.DeleteChara(41)
	event.DeleteChara(42)
	event.ObjsSetPos(0, -284.58, 0.0, -370.78)
	event.ObjsSetRot(0, 0.0, 2.93, 0.0)
	event.ObjsSetPos(1, -370.53, 0.0, -348.56)
	event.ObjsSetRot(1, 0.0, 0.89, 0.0)
	event.ObjsSetMotion(1, "歩き", 4, -1.0, 1)
	event.ObjsMove(1, -334.31, 0.0, -340.4, 60)
	event.CmrsSetPos(-390.3, 27.35, -176.88)
	event.CmrsSetRef(-290.9, 59.06, -387.86)
	event.CmrsQuakeDelay(30)
	event.CmrsQuake(0.0, 0.3, 0.0, 90)
	event.CharaActive(1, 40)
	event.SetCharaPos(40, -127.39, -18.0, -701.37)
	event.SetCharaRot(40, 0.0, -1.68, 0.0)
	helper_468(30)
	if vm.skipping() then
		return skip(11)
	end
	helper_468(30)
	if vm.skipping() then
		return skip(12)
	end
	event.CharaActive(1, 34)
	event.ObjsSetMotion(2, "浮かび笑", 6)
	event.ObjsNextMotion(2, "待機")
	event.CharaActive(1, 39)
	event.SetCharaPos(39, -241.56, -9.72, -479.54)
	event.SetCharaRot(39, 0.0, 0.0, 0.0)
	event.SetMotion(39, "水柱", 2, -1, 1)
	helper_29d8(1)
	if vm.skipping() then
		return skip(13)
	end
	event.SndSePlay(var4, 9)
	event.ObjsRotation(1, 0.0, 2.45, 0.0, 10)
	helper_29d8(1)
	if vm.skipping() then
		return skip(14)
	end
	event.ObjsSetMotion(1, "立ち")
	event.ObjsSetMotion(0, "マーダン出現", 2)
	event.ObjsSetMotion(3, "マーダン出現", 2)
	event.ObjsNextMotion(0, "マーダン出現L")
	event.ObjsNextMotion(3, "マーダン出現L")
	helper_468(30)
	if vm.skipping() then
		return skip(15)
	end
	helper_468(15)
	if vm.skipping() then
		return skip(16)
	end
	event.FadeOutBgm(60)
	helper_468(60)
	if vm.skipping() then
		return skip(17)
	end
	event.StopBgm(1)
	if vm.wait() then
		return skip(18)
	end
	if vm.wait() then
		return skip(19)
	end
	if vm.wait() then
		return skip(20)
	end
	if vm.wait() then
		return skip(21)
	end
	event.LoadBgm(193)
	event.PlayBgm(0)
	event.SndSeStop(var4, 9)
	event.SndSePlay(var4, 10)
	helper_468(60)
	if vm.skipping() then
		return skip(22)
	end
	event.CharaActive(0, 39)
	event.DeleteChara(39)
	event.ObjsSetMotion(2, "あせる")
	helper_468(10)
	if vm.skipping() then
		return skip(23)
	end
	helper_5684(2400010, -1)
	if vm.skipping() then
		return skip(24)
	end
	helper_5684(2400015, -1)
	if vm.skipping() then
		return skip(25)
	end
	event.ObjsMotionWait(2)
	event.ObjsSetMotion(2, "ユリスを見る", 2)
	event.ObjsNextMotion(2, "ユリスを見るL")
	helper_468(30)
	if vm.skipping() then
		return skip(26)
	end
	event.ObjsSetMotion(2, "モニカを見る", 2)
	event.ObjsNextMotion(2, "モニカを見るL")
	helper_468(120)
	if vm.skipping() then
		return skip(27)
	end
	event.CmrsSetPos(-312.91, 53.63, -372.03)
	event.CmrsSetRef(-334.31, 16.44, -340.4)
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "おこり顔")
	event.ObjsTexAnime(1, 1, "おこり目パチ")
	event.ObjsSetMotion(1, "上向く会話", 2)
	event.ObjsNextMotion(1, "上向くL")
	event.SetPakuAnim(1, "通常口パク")
	helper_6038(2400020)
	if vm.skipping() then
		return skip(28)
	end
	event.ResetPakuAnim()
	helper_29d8(1)
	if vm.skipping() then
		return skip(29)
	end
	event.ObjsSetMotion(1, "上向く会話", 2)
	event.ObjsNextMotion(1, "上向くL")
	event.SetPakuAnim(1, "通常口パク")
	helper_6038(2400025)
	if vm.skipping() then
		return skip(30)
	end
	event.ResetPakuAnim()
	helper_29d8(1)
	if vm.skipping() then
		return skip(31)
	end
	helper_468(15)
	if vm.skipping() then
		return skip(32)
	end
	event.CmrsSetPos(-390.3, 27.35, -176.88)
	event.CmrsSetRef(-290.9, 59.06, -387.86)
	event.ObjsSetMotion(1, "上向くL", 4)
	event.ObjsSetPos(0, -305.91, 0.0, -329.68)
	event.ObjsResetDaPosition(0)
	event.ObjsSetMotion(0, "上向くL", 4)
	event.ObjsSetMotion(2, "目ほそめ", 2)
	event.ObjsNextMotion(2, "目ほそめL", 4)
	helper_29d8(2)
	if vm.skipping() then
		return skip(33)
	end
	event.ObjsSetMotion(2, "目ほそめ会話", 2)
	event.ObjsNextMotion(2, "目とじ会話", 2)
	event.ObjsNextMotion(2, "目ほそめ会話", 2)
	event.ObjsNextMotion(2, "目とじ会話", 2)
	event.ObjsNextMotion(2, "目ほそめ会話", 4)
	helper_5684(2400030, -1)
	if vm.skipping() then
		return skip(34)
	end
	event.CharaActive(1, 38)
	event.SetCharaPos(38, -127.39, 0.0, -701.37)
	event.SetCharaRot(38, 0.0, -1.68, 0.0)
	event.SetMotion(38, "ウィンク", 2, -1, 1)
	event.ObjsSetMotion(2, "ウィンク", 2)
	helper_468(30)
	if vm.skipping() then
		return skip(35)
	end
	event.ObjsSetMotion(2, "目とじ", 2)
	event.ObjsNextMotion(2, "目とじL", 4)
	helper_29d8(2)
	if vm.skipping() then
		return skip(36)
	end
	event.ObjsSetMotion(2, "目とじ会話", 2)
	event.ObjsNextMotion(2, "目ほそめ会話", 2)
	event.ObjsNextMotion(2, "目とじ会話", 2)
	event.ObjsNextMotion(2, "目ほそめ会話", 2)
	event.ObjsNextMotion(2, "目とじ会話", 4)
	helper_5684(2400035, -1)
	if vm.skipping() then
		return skip(37)
	end
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.ObjsMotionWait(2)
	event.ObjsSetMotion(2, "目とじ戻り", 2)
	event.ObjsNextMotion(2, "モニカを見る", 2)
	event.ObjsNextMotion(2, "モニカを見るL")
	event.ObjsSetMotion(1, "上向く", 2)
	event.ObjsNextMotion(1, "上向く会話", 2)
	event.ObjsNextMotion(1, "上向くL")
	helper_6038(2400040)
	if vm.skipping() then
		return skip(38)
	end
	helper_29d8(1)
	if vm.skipping() then
		return skip(39)
	end
	event.ObjsSetMotion(1, "上向く会話", 2)
	event.ObjsNextMotion(1, "上向くL")
	helper_6038(2400045)
	if vm.skipping() then
		return skip(40)
	end
	helper_29d8(1)
	if vm.skipping() then
		return skip(41)
	end
	event.ObjsSetMotion(2, "会話")
	helper_6038(2400050)
	if vm.skipping() then
		return skip(42)
	end
	event.ObjsSetMotion(2, "目ほそめ", 2)
	event.ObjsNextMotion(2, "目ほそめL", 4)
	helper_29d8(2)
	if vm.skipping() then
		return skip(43)
	end
	event.ObjsSetMotion(2, "目ほそめ会話", 2)
	event.ObjsNextMotion(2, "目とじ会話", 2)
	event.ObjsNextMotion(2, "目ほそめ会話", 2)
	event.ObjsNextMotion(2, "目とじ会話", 2)
	event.ObjsNextMotion(2, "目ほそめ会話", 4)
	helper_5684(2400055, -1)
	if vm.skipping() then
		return skip(44)
	end
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.CharaActive(0, 38)
	event.CmrsSetPos(-292.54, 67.5, -392.04)
	event.CmrsSetRef(-319.35, 18.11, -332.98)
	event.ObjsSetMotion(1, "上向きから頭抱え", 2)
	event.ObjsNextMotion(1, "頭かかえＬ", 4)
	event.ObjsSetMotion(0, "左向く", 2)
	event.ObjsNextMotion(0, "左向くL")
	helper_6038(2400060)
	if vm.skipping() then
		return skip(45)
	end
	helper_29d8(1)
	if vm.skipping() then
		return skip(46)
	end
	event.ObjsSetMotion(0, "左向く戻り", 2)
	event.ObjsNextMotion(0, "上向く", 2)
	event.ObjsNextMotion(0, "上向く会話", 2)
	event.ObjsNextMotion(0, "上向くL")
	event.SetPakuAnim(0, "通常口パク")
	helper_6038(2400070)
	if vm.skipping() then
		return skip(47)
	end
	event.ResetPakuAnim()
	helper_29d8(0)
	if vm.skipping() then
		return skip(48)
	end
	event.CmrsSetPos(-348.01, 19.24, -271.83)
	event.CmrsSetRef(-309.88, 30.88, -357.76)
	event.ObjsSetMotion(0, "上向くL", 4)
	event.ObjsSetMotion(1, "上向くL", 4)
	event.ObjsSetMotion(2, "ユリスを見る", 6)
	event.ObjsNextMotion(2, "ユリスを見るL", 4)
	helper_29d8(2)
	if vm.skipping() then
		return skip(49)
	end
	event.ObjsSetMotion(2, "ユリス見会話")
	helper_5684(2400080, -1)
	if vm.skipping() then
		return skip(50)
	end
	event.CharaActive(1, 38)
	event.SetCharaPos(38, -127.39, 0.0, -701.37)
	event.SetCharaRot(38, 0.0, -1.68, 0.0)
	event.SetMotion(38, "ウィンク", 2, -1, 1)
	event.ObjsSetMotion(2, "ぶちゅー", 2)
	event.ObjsNextMotion(2, "ユリスを見るL")
	event.ObjsMotionWait(2)
	helper_5684(2400085, -1)
	if vm.skipping() then
		return skip(51)
	end
	event.CharaActive(0, 38)
	event.ObjsSetMotion(2, "ユリス見会話")
	helper_6038(2400090)
	if vm.skipping() then
		return skip(52)
	end
	helper_5684(2400095, -1)
	if vm.skipping() then
		return skip(53)
	end
	event.CharaActive(1, 38)
	event.SetCharaPos(38, -127.39, 0.0, -701.37)
	event.SetCharaRot(38, 0.0, -1.68, 0.0)
	event.SetMotion(38, "ウィンク", 2, -1, 1)
	event.ObjsSetMotion(2, "ウィンク", 2)
	event.ObjsNextMotion(2, "ユリス見会話")
	helper_5684(2400100, -1)
	if vm.skipping() then
		return skip(54)
	end
	event.CharaActive(0, 38)
	helper_5684(2400105, -1)
	if vm.skipping() then
		return skip(55)
	end
	helper_6038(2400110)
	if vm.skipping() then
		return skip(56)
	end
	helper_5684(2400115, -1)
	if vm.skipping() then
		return skip(57)
	end
	event.CharaActive(1, 38)
	event.SetCharaPos(38, -127.39, 0.0, -701.37)
	event.SetCharaRot(38, 0.0, -1.68, 0.0)
	event.SetMotion(38, "ウィンク", 2, -1, 1)
	event.ObjsSetMotion(2, "ウィンク", 2)
	event.ObjsNextMotion(2, "ユリスを見る", 2)
	event.ObjsNextMotion(2, "ユリスを見るL")
	helper_468(60)
	if vm.skipping() then
		return skip(58)
	end
	event.CharaActive(0, 38)
	event.ObjsSetMotion(0, "上向く会話", 2)
	event.ObjsNextMotion(0, "上向くL", 4)
	helper_6038(2400120)
	if vm.skipping() then
		return skip(59)
	end
	helper_29d8(0)
	if vm.skipping() then
		return skip(60)
	end
	event.ObjsSetMotion(0, "上向く会話", 2)
	event.ObjsNextMotion(0, "上向くL", 4)
	helper_6038(2400125)
	if vm.skipping() then
		return skip(61)
	end
	helper_29d8(0)
	if vm.skipping() then
		return skip(62)
	end
	event.ObjsSetMotion(0, "上向くL")
	event.ObjsSetMotion(2, "ユリス見会話")
	helper_6038(2400130)
	if vm.skipping() then
		return skip(63)
	end
	event.ObjsSetMotion(1, "上向きから驚き", 2)
	event.ObjsNextMotion(1, "驚きＬ")
	event.ObjsNextMotion(2, "モニカを見る", 2)
	event.ObjsNextMotion(2, "モニカを見るL")
	event.SndSePlay(var4, 11)
	helper_6038(2400140)
	if vm.skipping() then
		return skip(64)
	end
	helper_29d8(1)
	if vm.skipping() then
		return skip(65)
	end
	helper_468(30)
	if vm.skipping() then
		return skip(66)
	end
	event.CmrsSetPos(-756.17, 221.27, 17.93)
	event.CmrsSetRef(-308.68, 56.91, -420.42)
	event.SndSeStop(var4, 10)
	helper_468(15)
	if vm.skipping() then
		return skip(67)
	end
	event.SetPakuAnim(1, "通常口パク")
	event.ObjsSetMotion(2, "ユリス見会話")
	helper_5684(2400150, -1)
	if vm.skipping() then
		return skip(68)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(2, "ユリスを見るL")
	event.FadeOutBgm(60)
	helper_468(60)
	if vm.skipping() then
		return skip(69)
	end
	event.SetFadeOut(30)
	helper_468(35)
	if vm.skipping() then
		return skip(70)
	end
	return part2()
end

--- Helper function.
local function helper_1f934()
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
	event.SetMesWindowMode(0, 7)
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
		event.LoadEquip(5, 1, 2, "info", global1, 37)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global1)
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
		event.EohSyncChara(0, global0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global0)
		event.CharaActive(1, 37)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.EohSyncChara(1, global1)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global1)
	end
	event.LoadChara(5, "event/e200/e245/e245_madan.gltf", "info", 34)
	event.CharaActive(0, 34)
	event.EohSyncChara(4, 34)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 4)
	event.LoadChara(5, "event/e200/e245/e245_ma_kaeru.gltf", "info", 39)
	event.CharaActive(0, 39)
	event.EohSyncChara(6, 39)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 6)
	event.SetCharaType(39, 4)
	event.LoadChara(5, "event/e200/e245/e245_ma_hamon.gltf", "info", 40)
	event.CharaActive(0, 40)
	event.LoadChara(5, "event/e200/e245/e245_magicwink.gltf", "info", 38)
	event.CharaActive(0, 38)
	event.LoadChara(5, "event/e200/e245/e245_pink.gltf", "info", 41)
	event.CharaActive(0, 41)
	event.LoadMes(0, 5, "event/e200/e245/e245.txt")
end

--- Helper function.
local function helper_1f5a8()
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
	event.DeleteChara(34)
	event.DeleteChara(38)
	event.DeleteChara(41)
	event.DeleteChara(39)
	event.DeleteChara(40)
end

--- Helper function.
local function helper_20820()
	local var4: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 26 then
			if at <= 1 then
				helper_468(4)
			end
			if at <= 2 then
				helper_468(45)
			end
			if at <= 3 then
				helper_1f934()
				helper_468(15)
			end
			if at <= 4 then
				helper_5684(2450010, -1)
			end
			if at <= 5 then
				helper_5684(2450015, -1)
			end
			if at <= 6 then
				helper_29d8(2)
			end
			if at <= 7 then
				helper_5684(2450020, -1)
			end
			if at <= 8 then
				helper_6038(2450030)
			end
			if at <= 9 then
				helper_29d8(0)
			end
			if at <= 10 then
				helper_5684(2450040, -1)
			end
			if at <= 11 then
				helper_468(30)
			end
			if at <= 12 then
				helper_468(150)
			end
			if at <= 13 then
				helper_468(40)
			end
			if at <= 14 then
				helper_6038(2450050)
			end
			if at <= 15 then
				helper_29d8(0)
			end
			if at <= 16 then
				helper_29d8(2)
			end
			if at <= 17 then
				helper_5684(2450060, -1)
			end
			if at <= 18 then
				helper_5684(2450070, -1)
			end
			if at <= 19 then
				helper_29d8(2)
			end
			if at <= 20 then
				helper_6038(2450080)
			end
			if at <= 21 then
				helper_29d8(0)
			end
			if at <= 22 then
				helper_6038(2450090)
			end
			if at <= 23 then
				helper_6038(2450100)
			end
			if at <= 24 then
				helper_29d8(1)
			end
			if at <= 25 then
				helper_468(30)
			end
			if vm.skip_end() then
				return skip(27)
			end
			return part2()
		end
		if at <= 27 then
			helper_468(35)
		end
		helper_1f5a8()
	end
	function part2()
		event.CancelDramaScene()
		event.SetFadeOut(30)
		helper_468(35)
		if vm.skipping() then
			return skip(28)
		end
		event.StopBgm(0)
		event.SndSeStop(var4, 4)
		helper_1f5a8()
		event.ResetCamera(0)
		event.SetFadeIn(30)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFlag(245, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.StopBgm(0)
	helper_468(4)
	if vm.skipping() then
		return skip(2)
	end
	event.LoadBgm(193)
	event.PlayBgm(0)
	var4 = event.SndLoadSound(2815) or var4
	event.SetFadeOut(30)
	helper_468(45)
	if vm.skipping() then
		return skip(3)
	end
	helper_1f934()
	event.InitDramaScene()
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "デフォルト顔")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.CharaActive(1, global0)
	event.CharaActive(1, global1)
	event.CharaActive(1, 34)
	event.CmrsSetPos(-390.3, 27.35, -176.88)
	event.CmrsSetRef(-290.9, 59.06, -387.86)
	event.SetCharaPos(0, -297.56, 0.0, -373.68)
	event.SetCharaRot(0, 0.0, 2.57, 0.0)
	event.CharaActive(1, 40)
	event.SetCharaPos(40, -127.39, -18.0, -701.37)
	event.SetCharaRot(40, 0.0, -1.68, 0.0)
	event.ObjsSetPos(0, -289.3, 0.0, -369.79)
	event.ObjsSetRot(0, 0.0, 2.93, 0.0)
	event.ObjsSetPos(1, -320.6, 0.0, -374.1)
	event.ObjsSetRot(1, 0.0, 2.57, 0.0)
	event.ObjsSetPos(2, -127.39, 0.0, -701.37)
	event.ObjsSetRot(2, 0.0, -1.68, 0.0)
	event.SetFadeIn(30)
	event.SndSePlay(var4, 4)
	event.ObjsSetMotion(0, "上向くL", 4, -1.0, 1)
	event.ObjsSetMotion(1, "上向くL", 2, -1.0, 1)
	event.ObjsSetMotion(2, "笑う", 2)
	event.ObjsNextMotion(2, "会話速", 2)
	event.ObjsNextMotion(2, "目ほそめ会話", 2)
	event.ObjsNextMotion(2, "会話速", 2)
	event.ObjsNextMotion(2, "目ほそめ会話", 4)
	helper_468(15)
	if vm.skipping() then
		return skip(4)
	end
	helper_5684(2450010, -1)
	if vm.skipping() then
		return skip(5)
	end
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 4)
	event.ObjsSetMotion(2, "会話速", 2)
	event.ObjsNextMotion(2, "目ほそめ会話", 2)
	event.ObjsNextMotion(2, "目ほそめ会話", 2)
	event.ObjsNextMotion(2, "会話速", 2)
	event.ObjsNextMotion(2, "目ほそめ会話", 4)
	helper_5684(2450015, -1)
	if vm.skipping() then
		return skip(6)
	end
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 4)
	helper_29d8(2)
	if vm.skipping() then
		return skip(7)
	end
	event.ObjsSetMotion(2, "笑う", 4)
	helper_5684(2450020, -1)
	if vm.skipping() then
		return skip(8)
	end
	event.ObjsSetMotion(2, "ユリスを見る", 2)
	event.ObjsNextMotion(2, "ユリスを見るL", 4)
	event.ObjsSetMotion(0, "上向く会話", 2)
	event.ObjsNextMotion(0, "上向くL", 4)
	helper_6038(2450030)
	if vm.skipping() then
		return skip(9)
	end
	helper_29d8(0)
	if vm.skipping() then
		return skip(10)
	end
	event.ObjsSetMotion(0, "上向くL")
	event.ObjsSetMotion(2, "ユリス見会話")
	helper_5684(2450040, -1)
	if vm.skipping() then
		return skip(11)
	end
	event.ObjsSetMotion(2, "ウィンク", 2)
	event.ObjsNextMotion(2, "待機")
	helper_468(30)
	if vm.skipping() then
		return skip(12)
	end
	event.CharaActive(1, 38)
	event.SetCharaPos(38, -127.39, 0.0, -701.37)
	event.SetCharaRot(38, 0.0, -1.68, 0.0)
	event.SetMotion(38, "魔法解く", 2, -1, 1)
	event.CharaActive(1, 41)
	event.SetCharaPos(41, -127.39, 0.0, -701.37)
	event.SetCharaRot(41, 0.0, -1.68, 0.0)
	event.SetMotion(41, "桃色世界", 2, -1, 1)
	event.SndSePlay(var4, 5)
	helper_468(150)
	if vm.skipping() then
		return skip(13)
	end
	event.SetCharaShow(41, 0, 1, 0.025)
	helper_468(40)
	if vm.skipping() then
		return skip(14)
	end
	event.ObjsSetMotion(0, "上向く会話", 2)
	event.ObjsNextMotion(0, "上向くL", 4)
	helper_6038(2450050)
	if vm.skipping() then
		return skip(15)
	end
	helper_29d8(0)
	if vm.skipping() then
		return skip(16)
	end
	event.ObjsSetMotion(0, "上向くL")
	event.ObjsSetMotion(2, "ユリスを見る", 2)
	event.ObjsNextMotion(2, "ユリス見会話")
	helper_29d8(2)
	if vm.skipping() then
		return skip(17)
	end
	helper_5684(2450060, -1)
	if vm.skipping() then
		return skip(18)
	end
	event.ObjsSetPos(4, -127.39, 0.0, -701.37)
	event.ObjsSetRot(4, 0.0, -1.68, 0.0)
	event.SetScale(39, 2.0, 2.0, 2.0)
	event.ObjsMotionDelay(2, 70)
	event.ObjsSetMotion(2, "帰る", 2)
	event.CharaActive(1, 39)
	event.ObjsSetMotion(4, "帰る", 5)
	event.ObjsMotionDelay(4, 70)
	event.ObjsSetMotion(4, "帰る", 6)
	event.ObjsSeDelay(2, 70)
	event.ObjsSePlay(2, var4, 6)
	helper_5684(2450070, -1)
	if vm.skipping() then
		return skip(19)
	end
	helper_29d8(2)
	if vm.skipping() then
		return skip(20)
	end
	event.CharaActive(0, 39)
	event.CharaActive(0, 40)
	event.ObjsSetMotion(1, "立ち", 4, -1.0, 1)
	event.ObjsSetPos(1, -324.44, 0.0, -385.55)
	event.ObjsSetRot(1, 0.0, 2.57, 0.0)
	event.CmrsSetPos(-247.47, 25.33, -442.62)
	event.CmrsSetRef(-302.69, 22.64, -384.86)
	event.ObjsSetMotion(0, "左向く", 2)
	event.ObjsNextMotion(0, "左向くL", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_6038(2450080)
	if vm.skipping() then
		return skip(21)
	end
	event.ResetPakuAnim()
	helper_29d8(0)
	if vm.skipping() then
		return skip(22)
	end
	event.SetPakuAnim(0, "通常口パク")
	helper_6038(2450090)
	if vm.skipping() then
		return skip(23)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(1, "右向く", 6)
	event.ObjsNextMotion(1, "右向くL", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_6038(2450100)
	if vm.skipping() then
		return skip(24)
	end
	event.ResetPakuAnim()
	helper_29d8(1)
	if vm.skipping() then
		return skip(25)
	end
	event.FadeOutBgm(60)
	helper_468(30)
	if vm.skipping() then
		return skip(26)
	end
	return part2()
end

--- Program 506.
local function program_506()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_468(15)
		end
		if at <= 2 then
			helper_20820()
			if not vm.skipping() then
				return part2()
			end
		end
		helper_11ee8()
	end
	function part2()
		event.SetCnt(3, 6)
		helper_11ee8()
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFadeOut(15)
	helper_468(15)
	if vm.skipping() then
		return skip(2)
	end
	event.DeleteChara(14)
	event.FuncPointShow("p01_s0501", "invent_2008-0", 0)
	event.FuncPointShow("p01_s0501", "kaiwa02-0", 0)
	event.EohSyncObj(0, "p08_s0501")
	event.EohSetShow(0, 0)
	helper_20820()
	if vm.skipping() then
		return skip(3)
	end
	return part2()
end

--- Helper function.
local function helper_86d0(arg0: s32, arg1: s32, arg2: s32, arg3: s32, arg4: s32, arg5: s32)
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		helper_2dc4(arg0)
		return arg5
	end
	local _ = helper_2b80(arg0, arg1, arg2, arg3, arg4)
	_, arg5 = helper_7d6c(arg0, 1, arg5)
	if vm.skipping() then
		return skip(1)
	end
	helper_2dc4(arg0)
	return arg5
end

--- Helper function.
local function helper_2753c()
	local active_chr_no: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			return
		end
		if at <= 3 then
			helper_29d8(0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		event.LoadMotion(5, "dungeon/chara/c01b_miss.gltf", "info", 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "dungeon/chara/c02a_miss.gltf", "info", 0)
	end
	if active_chr_no == 2 or active_chr_no == 3 then
		if vm.wait() then
			return skip(2)
		end
		return
	end
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetMotion(0, "立ち", 4)
	do
		local out1, out2, out3 = event.GetCameraPos()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	event.ObjsReference(0, pos_x, pos_y, pos_z, 6)
	helper_29d8(0)
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsSetMotion(0, "だめだめ", 6)
	event.ObjsNextMotion(0, "立ち", 4)
	helper_29d8(0)
	if vm.skipping() then
		return skip(4)
	end
	if active_chr_no == 0 or active_chr_no == 1 then
		event.DelExtMotion(0)
	end
end

--- Helper function.
local function helper_6d8c(arg0: s32)
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
local function helper_6acc(arg0: s32)
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
local function helper_6ee4(arg0: s32, arg1: any, arg2: any, arg3: s32)
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
				helper_6d8c(arg0)
			end
			if at <= 2 then
				var8 = 0
				var7 = helper_6acc(arg0)
				var8 = -1
				var8 = 1
				var6 = var7
				var8 = -1
				var8 = 1
				var8 = -1
				var8 = 1
			end
			helper_2dc4(arg0)
			return -1
		end
		helper_2dc4(arg0)
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
	helper_6d8c(arg0)
	if vm.skipping() then
		return skip(2)
	end
	while true do
		var8 = 0
		var7 = helper_6acc(arg0)
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
					helper_2dc4(arg0)
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
	helper_2dc4(arg0)
	return arg2
end

--- Helper function.
local function helper_7bfc(arg0: s32, arg1: any, arg2: s32, arg3: s32, arg4: s32, arg5: s32, arg6: s32)
	local var8: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		return var8
	end
	local _ = helper_2b80(arg0, arg1, arg2, arg3, arg4)
	var8 = helper_6ee4(arg0, arg5, arg6, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPos(arg0, 0)
	return var8
end

--- Helper function.
local function helper_10f54()
	local var0: any = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_468(60)
			end
			return 1
		end
		var4 = var4 + 1
		return 0
	end
	event.Initialize()
	event.SetMotion(0, "立ち", 4)
	event.SetMesWindowMode(0, 5)
	event.SetMesDrawspeed(0, 1)
	event.MesMake_2(0, "次のフロアに進みますか？")
	var0 = helper_7bfc(0, -1, 8, 256, 208, 2, 1)
	if vm.skipping() then
		return skip(1)
	end
	if var0 == 0 then
		event.CmrsInit()
		event.CmrsSetPos(-2144.16, 79.66, 654.8)
		event.CmrsSetRef(-2382.06, 11.3, 623.75)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.ObjsSetPos(0, -2363.64, 0.4, 625.83)
		event.ObjsSetRot(0, 0.0, -1.52, 0.0)
		event.ObjsSetMotion(0, "走り", 4)
		event.ObjsMove(0, -2489.67, 0.4, 624.1, 60)
		event.CmrsMove2(-2144.16, 79.66, 654.8, -2388.46, 36.03, 632.32, 48, 60, 2.5)
		event.CmrsFadeInit()
		event.CmrsFadeDelay(30)
		event.CmrsFadeOut(30, 0.0, 0.0, 0.0)
		helper_468(60)
		if vm.skipping() then
			return skip(2)
		end
		return 1
	end
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	do
		local out1, out2, out3 = event.GetCharaPos(0)
		var1 = out1 or var1
		var2 = out2 or var2
		var3 = out3 or var3
	end
	var1 = vm.f32(var1 + vm.f32(30.0 * vm.sin(vm.f32(1.59))))
	var3 = vm.f32(var3 + vm.f32(30.0 * vm.cos(vm.f32(1.59))))
	event.ObjsSetMotion(0, "歩き", 4, -1.0, 1)
	event.ObjsRotation(0, 0.0, 1.59, 0.0, 15)
	event.ObjsMove(0, var1, var2, var3, 45)
	var4 = 0
	while var4 < 45 do
		do
			local out1, out2, out3 = event.GetCharaPos(0)
			var1 = out1 or var1
			var2 = out2 or var2
			var3 = out3 or var3
		end
		event.CmrsSetRef(var1, var2 + 30.0, var3)
		if vm.wait() then
			return skip(3)
		end
		var4 = var4 + 1
	end
	event.ObjsSetMotion(0, "立ち", 4, -1.0, 1)
	return 0
end

--- Helper function.
local function helper_1ab4(arg0: f32, arg1: f32, arg2: f32, arg3: f32)
	local skip: (number) -> ...any
	function skip(at: number)
		return vm.f32(vm.f32(vm.fdiv(vm.f32(vm.f32(arg1 - arg0) * arg2), arg3)) + arg0)
	end
	if vm.skipping() then
		return skip(1)
	end
	return vm.f32(vm.f32(vm.fdiv(vm.f32(vm.f32(arg1 - arg0) * arg2), arg3)) + arg0)
end

--- Helper function.
local function helper_9e14(arg0: any, arg1: f32)
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
			var13 = helper_1ab4(0.0, angle, var14, var15)
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
		var13 = helper_1ab4(0.0, angle, var14, var15)
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
local function helper_2cb4(arg0: any, arg1: any, arg2: any, arg3: any)
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	if vm.wait() then
		return skip(2)
	end
	if vm.wait() then
		return skip(3)
	end
	event.SetMesPos(arg0, 0)
	event.MesMake_2(arg0, arg1)
	event.SetMesAutoset(arg0, arg2, arg3)
end

--- Helper function.
local function helper_81a0(arg0: s32, arg1: any, arg2: any, arg3: s32, arg4: any)
	local var5: s32 = 0
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_2cb4(arg0, arg1, arg2, arg3)
		end
		if at <= 2 then
			_, var5 = helper_7d6c(arg0, 0, var5)
		end
		helper_2dc4(arg0)
	end
	if vm.skipping() then
		return skip(1)
	end
	helper_2cb4(arg0, arg1, arg2, arg3)
	if vm.skipping() then
		return skip(2)
	end
	_, var5 = helper_7d6c(arg0, 0, var5)
	if vm.skipping() then
		return skip(3)
	end
	helper_2dc4(arg0)
end

--- Helper function.
local function helper_7cc(arg0: s32)
	local argc: s32 = 0
	local argc_2: s32 = 0
	local argc_3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_468(10)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	argc = event.CheckGetItemLimit() or argc
	argc_2 = event.CheckItemOver() or argc_2
	if argc >= 1 or argc_2 >= 1 then
		if arg0 == 1 then
			event.SetFadeOut(10)
			helper_468(10)
			if vm.skipping() then
				return skip(2)
			end
		end
		argc_3 = event.GetNowLoopNo() or argc_3
		if argc_3 == 1 then
			event.GotoMenu(16)
			if vm.wait() then
				return skip(3)
			end
		end
		if argc_3 == 2 then
			event.GotoMenu(17)
			if vm.wait() then
				return skip(4)
			end
		end
		if arg0 == 1 then
			event.SetFadeIn(10)
		end
	end
end

--- Helper function.
local function helper_1070c(arg0: s32)
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: any = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	do
		local out1, out2, out3 = event.GetCharaPos(0)
		var1 = out1 or var1
		var2 = out2 or var2
		var3 = out3 or var3
	end
	do
		local out1, out2, out3 = event.GetCharaPos(arg0)
		var4 = out1 or var4
		var5 = out2 or var5
		var6 = out3 or var6
	end
	do
		local out1, out2, out3 = event.SubVector(var4, var5, var6, var1, var2, var3)
		var4 = out1 or var4
		var5 = out2 or var5
		var6 = out3 or var6
	end
	var7 = event.Atan2f(var4, var6) or var7
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetMotion(0, "歩き", 4, -1.0, 1)
	print("angle=", string.format("%f", var7), "----------\n")
	var8 = vm.ftoi(vm.f32(var7 / vm.f32(0.19634955)))
	var8 = helper_2c717f26(var8)
	print("frame=", var8, "-------------\n")
	event.ObjsRotation(0, 0.0, var7, 0.0, var8)
	helper_468(var8)
	if vm.skipping() then
		return skip(1)
	end
	event.ObjsSetMotion(0, "立ち", 4, -1.0, 1)
end

--- Helper function.
local function helper_10c70()
	local var0: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_468(30)
		end
		return 1
	end
	event.Initialize()
	event.SetMotion(0, "立ち", 4)
	event.SetMesWindowMode(0, 5)
	event.SetMesDrawspeed(0, 1)
	event.MesMake_2(0, "『シャーロット停車場』に戻りますか？")
	var0 = helper_7bfc(0, -1, 8, 256, 208, 2, 1)
	if vm.skipping() then
		return skip(1)
	end
	if var0 == 0 then
		event.SetFadeOut(30)
		helper_468(30)
		if vm.skipping() then
			return skip(2)
		end
		return 1
	end
	return 0
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

script[99] = program_99

--- Program 100.
script[100] = function()
	local var0: s32 = 0
	local old_map_no: s32 = 0
	local flag: s32 = 0
	local mc_load: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	local landing1: () -> ...any
	function skip(at: number)
		if at <= 1 then
			program_501()
			if not vm.skipping() then
				return landing1()
			end
		end
	end
	function part2() end
	function landing1()
		event.SetFadeIn(15)
		return part2()
	end
	event.StopBgm(0)
	event.Initialize()
	var0 = event.GetFloorInfo(1, 6, 7) or var0
	event.SetFloorInfo(1, 6, 7, vm.i32(var0 + 1))
	print("s05StartEvent kita------------------------------------------\n")
	program_99()
	helper_27ae4()
	helper_11ee8()
	mc_load = event.CheckMcLoad() or mc_load
	if mc_load == 1 then
		event.SetCharaPos(0, 2808.3, 0.0, 1609.9)
		event.SetCharaRot(0, 0.0, 3.14, 0.0)
		event.SetMotion(0, "立ち", 4)
		event.CharaNormalDrive(0)
		event.CharaResetDa(0)
		event.ResetCamera(1, 0.0, 20.0)
	else
		old_map_no = event.GetOldMapNo() or old_map_no
		event.GetMapType(old_map_no)
		flag = event.GetFlag(215) or flag
		if flag ~= 0 then
			helper_26268(vm.f32(3205.97), 0.0, vm.f32(1599.83), 0.0)
			if vm.skipping() then
				return skip(1)
			end
		end
		event.SetFadeIn(15)
		flag = event.GetFlag(209) or flag
		if flag == 1 then
			flag = event.GetFlag(215) or flag
			if flag == 0 then
				program_501()
				if vm.skipping() then
					return skip(2)
				end
				event.SetFadeIn(15)
			end
		end
	end
	return part2()
end

--- Program 150.
-- Defined empty, so the engine runs this instead of its default.
script[150] = function() end

--- Program 151.
script[151] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_f90(32)
		end
	end
	event.SetCnt(3, 0)
	event.SetFlag(215, 0)
	event.SetFlag(220, 0)
	event.SetFlag(230, 0)
	event.SetFlag(235, 0)
	event.SubItem(302, 1)
	helper_11ee8()
	if vm.wait() then
		return skip(1)
	end
	helper_f90(32)
	if vm.skipping() then
		return skip(2)
	end
end

--- Program 400.
script[400] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_e238()
	if vm.skipping() then
		return skip(1)
	end
end

script[501] = program_501

--- Program 502.
script[502] = function()
	local flag: s32 = 0
	local argc: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		helper_11ee8()
		helper_11ee8()
		helper_11ee8()
	end
	event.SetMotion(0, "立ち")
	helper_16de0()
	if vm.skipping() then
		return skip(1)
	end
	argc = event.GetItemNum(302) or argc
	flag = event.GetFlag(230) or flag
	if argc ~= 0 and flag == 1 then
		event.SetCnt(3, 3)
		helper_11ee8()
	end
	if argc > 0 and flag == 0 then
		event.SetCnt(3, 2)
		helper_11ee8()
	end
	helper_11ee8()
end

--- Program 503.
script[503] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	if vm.wait() then
		return skip(1)
	end
	event.LoadScript("s05/s05b.stb", 501)
end

--- Program 504.
script[504] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	if vm.wait() then
		return skip(1)
	end
	event.LoadScript("s05/s05b.stb", 502)
end

--- Program 505.
script[505] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		helper_27ae4()
		helper_11ee8()
	end
	helper_1aea8()
	if vm.skipping() then
		return skip(1)
	end
	event.SetCnt(3, 5)
	helper_27ae4()
	helper_11ee8()
end

script[506] = program_506

--- Program 507.
script[507] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	if vm.wait() then
		return skip(1)
	end
	event.LoadScript("s05/s05b.stb", 503)
end

--- Program 508.
script[508] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	if vm.wait() then
		return skip(1)
	end
	event.LoadScript("s05/s05b.stb", 504)
end

--- Program 550.
script[550] = function()
	local var0: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	local landing1: () -> ...any
	function skip(at: number)
		if at <= 1 then
			var0 = 2
		end
		if at <= 2 then
			program_506()
			if not vm.skipping() then
				return landing1()
			end
		end
		if at <= 3 then
			helper_2753c()
		end
	end
	function part2() end
	function landing1()
		return part2()
	end
	event.Initialize()
	print("use item--------------\n")
	var0 = event.GetEventData_2(6) or var0
	if var0 == 1 then
		event.SetMesWindowMode(0, 1)
		event.SetMesShippo(0, 0)
		event.MesMake_2(0, "ぬしさまにハグハグを渡そう。\n（(#)でメニューを開く）")
		var1 = helper_86d0(0, -1, 5, 256, 208, var1)
		if vm.skipping() then
			return skip(1)
		end
		event.SetMesShippo(0, 1)
		if var1 == 1 then
			var0 = 2
		end
	end
	if var0 == 2 then
		event.GotoUseItem(310)
		do
			local skipped = vm.wait()
			var2 = event.DeferredOutput() or var2
			if skipped then
				return skip(2)
			end
		end
		if var2 == 310 then
			program_506()
			if vm.skipping() then
				return skip(3)
			end
		elseif var2 <= 0 then
		else
			helper_2753c()
			if vm.skipping() then
				return skip(4)
			end
		end
	end
	return part2()
end

--- Program 551.
script[551] = function()
	local var0: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var0 = 1
			var2 = 4
			var1 = 6
		end
	end
	event.Initialize()
	local t0 = helper_10f54() == 1
	if vm.skipping() then
		return skip(1)
	end
	if t0 then
		event.SetBitCtrl(16, 0)
		var0 = 1
		var2 = 4
		var1 = 6
		event.DngSetFloorId(var2)
		event.SetFloorInfo(var0, var1, 5, 2)
		event.SetFloorInfo(var0, var2, 5, 1)
		event.FuncPointShow("", "next_floor", 0)
		event.GotoDng(1, var2, 1000)
		if vm.wait() then
			return skip(2)
		end
	end
end

--- Program 552.
script[552] = function()
	local var0: s32 = 0
	local player_chara: s32 = 0
	local var3: s32 = 0
	local var4: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local var11: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	local landing1: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_8834(0, -1, 3, 170, 208)
		end
		if at <= 3 then
			program_506()
			if not vm.skipping() then
				return landing1()
			end
		end
		if at <= 4 then
			helper_2753c()
		end
	end
	function part2() end
	function landing1()
		return part2()
	end
	print("e552--------------\n")
	var0 = event.GetEventData_2(6) or var0
	if var0 == 1 then
		event.SetCameraPos(-203.52, 16.84, -181.02)
		event.SetCameraRef(-184.65, 30.0, -343.81)
		player_chara = event.GetControlChrid() or player_chara
		var3 = 14
		event.SetMesShippo(0, 1)
		event.SetMesPreset(0, 0)
		do
			local out1, _, out3 = event.GetCharaPos(player_chara)
			var4 = out1 or var4
			var6 = out3 or var6
		end
		do
			local out1, _, out3 = event.GetCharaPos(var3)
			var7 = out1 or var7
			var9 = out3 or var9
		end
		var10 = event.GetRotLookPos(var7 - var4, var9 - var6) or var10
		helper_9e14(player_chara, var10)
		if vm.skipping() then
			return skip(1)
		end
		event.SetCharaRot(player_chara, 0.0, var10, 0.0)
		event.SetMotion(player_chara, "立ち")
		event.SetMotion(14, "会話")
		event.MesMake_2(
			0,
			"ハグハグちゃんは\nゲットできたのかしら？<page>ワタクシの美貌がそこなわれると\n世界的な損失ざますのよ。<page>心してはりきってちょうだい。\n（(#)でアイテム使用）"
		)
		helper_8834(0, -1, 3, 170, 208)
		if vm.skipping() then
			return skip(2)
		end
		event.SetMotion(14, "立ち")
	end
	if var0 == 2 then
		event.GotoUseItem(310)
		do
			local skipped = vm.wait()
			var11 = event.DeferredOutput() or var11
			if skipped then
				return skip(3)
			end
		end
		if var11 == 310 then
			program_506()
			if vm.skipping() then
				return skip(4)
			end
		elseif 0 < var11 then
			helper_2753c()
			if vm.skipping() then
				return skip(5)
			end
		end
	end
	return part2()
end

--- Program 553.
script[553] = function()
	local player_chara: s32 = 0
	local var1: s32 = 0
	local var2: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_81a0(0, -1, var1, player_chara, 0)
		end
		if at <= 2 then
			helper_81a0(0, -1, var1, player_chara, 0)
		end
	end
	player_chara = event.GetControlChrid() or player_chara
	var1 = 8
	event.SetMesShippo(0, 1)
	event.SetMesPreset(0, 0)
	do
		local out1, _, out3 = event.GetCharaPos(player_chara)
		var2 = out1 or var2
		var4 = out3 or var4
	end
	do
		local out1, _, out3 = event.GetCharaPos(var1)
		var5 = out1 or var5
		var7 = out3 or var7
	end
	var8 = event.GetRotLookPos(var5 - var2, var7 - var4) or var8
	helper_9e14(player_chara, var8)
	if vm.skipping() then
		return skip(1)
	end
	event.SetCharaRot(player_chara, 0.0, var8, 0.0)
	event.SetMotion(player_chara, "立ち")
	flag = event.GetFlag(240) or flag
	if flag == 0 then
		event.MesMake_2(0, "沼のぬしさまは\n神聖なるお魚さまで\nあらせられる。")
		helper_81a0(0, -1, var1, player_chara, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.MesMake_2(0, "お目にかかりたいあまり\n釣り上げたりしては\nバチがあたるぞ。")
	else
		flag_2 = event.GetFlag(253) or flag_2
		if flag_2 == 0 then
			event.MesMake_2(
				0,
				"なんとまぁ、ぬしさまに\nお目にかかれたとな。<page>ご無礼がなかったじゃろうな。"
			)
		else
			event.MesMake_2(
				0,
				"こんな岩など、若い頃なら\nはるかかなたに投げ飛ばせたんじゃ。<page>年はとりたくないのう・・・"
			)
		end
	end
	helper_81a0(0, -1, var1, player_chara, 0)
	if vm.skipping() then
		return skip(3)
	end
end

--- Program 560.
script[560] = function()
	local argc: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_7cc(1)
		end
		helper_11ee8()
	end
	argc = event.GetItemNum(291) or argc
	if argc <= 0 then
		event.SetMotion(0, "立ち")
		helper_ce6c(291, 4)
		if vm.skipping() then
			return skip(1)
		end
		event.AddItem(291, 4)
		helper_7cc(1)
		if vm.skipping() then
			return skip(2)
		end
		event.SetMesWindowMode(0, 7)
	end
	helper_11ee8()
end

--- Program 561.
script[561] = function()
	local var0: s32 = 0
	local argc: s32 = 0
	local var2: s32 = 0
	local player_chara: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_81a0(0, -1, var0, player_chara, 0)
		end
		if at <= 2 then
			helper_ce6c(313, 5)
		end
		if at <= 3 then
			helper_7cc(1)
		end
	end
	event.SetMotion(0, "立ち", 4)
	var0 = 9
	helper_1070c(var0)
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesWindowMode(0, 1)
	argc = event.GetItemNum(313) or argc
	var2 = event.GetSavedataEtc(3, 302) or var2
	if argc <= 0 and var2 ~= 313 then
		event.MesMake_2(0, "エサがなくなっちまたのか？\nしょうがねぇな、ほらよ。")
	else
		event.MesMake_2(0, "釣れる日もありゃダメな日もある。\nエサのことなら心配すんな。")
	end
	player_chara = event.GetControlChrid() or player_chara
	helper_81a0(0, -1, var0, player_chara, 0)
	if vm.skipping() then
		return skip(2)
	end
	if argc <= 0 and var2 ~= 313 then
		event.SetMesWindowMode(0, 7)
		helper_ce6c(313, 5)
		if vm.skipping() then
			return skip(3)
		end
		event.AddItem(313, 5)
		helper_7cc(1)
		if vm.skipping() then
			return skip(4)
		end
	end
end

--- Program 600.
script[600] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	local t0 = helper_10c70() == 1
	if vm.skipping() then
		return skip(1)
	end
	if t0 then
		event.DngSetStageId(1)
		event.DngSetFloorId(0)
		event.SetBitCtrl(16, 0)
		event.MapJump(-1, "s02")
		if vm.wait() then
			return skip(2)
		end
	end
end

--- Program 1000.
script[1000] = function()
	local var0: s32 = 0
	local var2: s32 = 0
	local player_chara: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local player_chara_2: s32 = 0
	local player_chara_3: s32 = 0
	local player_chara_4: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_81a0(0, -1, 10, player_chara, 0)
		end
		if at <= 2 then
			helper_81a0(0, -1, 10, player_chara_2, 0)
		end
		if at <= 3 then
			helper_81a0(0, -1, 11, player_chara_3, 0)
		end
		if at <= 4 then
			helper_81a0(0, -1, 12, player_chara_4, 0)
		end
	end
	var0 = event.GetMesWindowMode(0) or var0
	event.SetMesWindowMode(0, 1)
	var2 = event.GetEventData_2(13) or var2
	event.GetEventData_2(14)
	event.SetMotion(0, "立ち", 4)
	helper_1070c(var2)
	if vm.skipping() then
		return skip(1)
	end
	if var2 == 8 then
		flag = event.GetFlag(240) or flag
		if flag == 0 then
			event.MesMake_2(0, "沼のぬしさまは\n神聖なるお魚さまで\nあらせられる。")
			event.MesMake_2(
				0,
				"お目にかかりたいあまり\n釣り上げたりしては\nバチがあたるぞ。"
			)
		else
			flag_2 = event.GetFlag(253) or flag_2
			if flag_2 == 0 then
				event.MesMake_2(
					0,
					"なんとまぁ、ぬしさまに\nお目にかかれたとな。<page>ご無礼がなかったじゃろうな。"
				)
			else
				event.MesMake_2(
					0,
					"こんな岩など、若い頃なら\nはるかかなたに投げ飛ばせたんじゃ。<page>年はとりたくないのう・・・"
				)
			end
		end
		player_chara = event.GetControlChrid() or player_chara
		helper_81a0(0, -1, 10, player_chara, 0)
		if vm.skipping() then
			return skip(2)
		end
	end
	if var2 == 10 then
		event.MesMake_2(0, "ワタシは今幸せなのだ。\nそっと、しておいてくれないか。")
		player_chara_2 = event.GetControlChrid() or player_chara_2
		helper_81a0(0, -1, 10, player_chara_2, 0)
		if vm.skipping() then
			return skip(3)
		end
	end
	if var2 == 11 then
		event.MesMake_2(
			0,
			"おいらは戻らねぇよ\nここで一生幸せに暮らすことに\n決めたんだもんね。"
		)
		player_chara_3 = event.GetControlChrid() or player_chara_3
		helper_81a0(0, -1, 11, player_chara_3, 0)
		if vm.skipping() then
			return skip(4)
		end
	end
	if var2 == 12 then
		event.MesMake_2(
			0,
			"ここは最高だよ。\nボーッとしているだけで不思議と\n幸せな気分になってくる。\n連れ戻そうたって無駄だぜ。"
		)
		player_chara_4 = event.GetControlChrid() or player_chara_4
		helper_81a0(0, -1, 12, player_chara_4, 0)
		if vm.skipping() then
			return skip(5)
		end
	end
	event.SetMesWindowMode(0, var0)
end

--- Program 12150.
script[12150] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetFlag(215, 0)
	event.SetCnt(3, 0)
	helper_ebc0(1)
	helper_13bcc()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 12200.
script[12200] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetFlag(220, 0)
	event.SetFlag(28, 0)
	event.CharaActive(8)
	event.CharaActive(9)
	event.CharaActive(10)
	event.SetMotion(0, "立ち")
	helper_16de0()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 12300.
script[12300] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	if vm.wait() then
		return skip(1)
	end
	event.LoadScript("s05/s05b.stb", 501)
end

--- Program 12350.
script[12350] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	if vm.wait() then
		return skip(1)
	end
	event.LoadScript("s05/s05b.stb", 502)
end

--- Program 12400.
script[12400] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		helper_11ee8()
	end
	helper_1aea8()
	if vm.skipping() then
		return skip(1)
	end
	event.SetCnt(3, 5)
	helper_11ee8()
end

--- Program 12450.
script[12450] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_20820()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 12470.
script[12470] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	if vm.wait() then
		return skip(1)
	end
	event.LoadScript("s05/s05b.stb", 503)
end

--- Program 12530.
script[12530] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	if vm.wait() then
		return skip(1)
	end
	event.LoadScript("s05/s05b.stb", 504)
end

return script
