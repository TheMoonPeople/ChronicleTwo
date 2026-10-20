--!strict
-- map/s/s19/s19.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_2aeee3a7 = require("@lib/event/helper_2aeee3a7")
local helper_34213fb6 = require("@lib/event/helper_34213fb6")
local helper_39d75add = require("@lib/event/helper_39d75add")
local helper_40746e5f = require("@lib/event/helper_40746e5f")
local helper_581fd7f7 = require("@lib/event/helper_581fd7f7")
local helper_8b35005d = require("@lib/event/helper_8b35005d")
local helper_b1312a3f = require("@lib/event/helper_b1312a3f")
local helper_c55c858b = require("@lib/event/helper_c55c858b")
local helper_cb728406 = require("@lib/event/helper_cb728406")
local helper_dbbdb6d9 = require("@lib/event/helper_dbbdb6d9")
local helper_e697ec97 = require("@lib/event/helper_e697ec97")
local helper_f92564d3 = require("@lib/event/helper_f92564d3")

--- Program 99.
local function program_99()
	local flag: s32 = 0
	local flag_2: s32 = 0
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.LoadSound(4684)
	flag = event.GetFlag(408) or flag
	flag_2 = event.GetFlag(420) or flag_2
	var2 = event.GetSavedataEtc(2) or var2
	if flag == 1 and flag_2 == 0 and var2 == 1 then
	else
		event.StopBgm(0)
		helper_f92564d3(4)
		if vm.skipping() then
			return skip(1)
		end
		event.LoadBgm(167)
		event.PlayBgm(0)
	end
end

--- Helper function.
local function helper_2e60(arg0: s32, arg1: s32)
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
local function helper_3c88(arg0: s32)
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
			t1, var2 = helper_2e60(arg0, var2)
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
		t0, var2 = helper_2e60(arg0, var2)
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
local function helper_5cf8(arg0: s32)
	local stream_open_state: s32 = 0
	local stream_open_state_2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			helper_dbbdb6d9(0, -1, 8, 0, 0)
			helper_3c88(0)
		end
		helper_581fd7f7(0)
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
	helper_dbbdb6d9(0, -1, 8, 0, 0)
	event.StreamPlay(1)
	helper_3c88(0)
	if vm.skipping() then
		return skip(4)
	end
	helper_581fd7f7(0)
	event.StreamClose(1)
end

--- Helper function.
local function helper_5fe8(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_5cf8(arg0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, arg0)
	helper_5cf8(arg0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_6098(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_cb728406(1)
		end
		if at <= 2 then
			helper_c55c858b(0, arg1)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.StreamOpen3(1, arg0)
	helper_cb728406(1)
	if vm.skipping() then
		return skip(2)
	end
	event.StreamPlay(1)
	helper_c55c858b(0, arg1)
	if vm.skipping() then
		return skip(3)
	end
	event.StreamClose(1)
end

--- Helper function.
local function helper_5634(arg0: s32, arg1: s32)
	local stream_open_state: s32 = 0
	local stream_open_state_2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			helper_dbbdb6d9(0, -1, 8, 0, 0)
			helper_c55c858b(0, arg1)
		end
		helper_581fd7f7(0)
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
	helper_dbbdb6d9(0, -1, 8, 0, 0)
	event.StreamPlay(1)
	helper_c55c858b(0, arg1)
	if vm.skipping() then
		return skip(4)
	end
	helper_581fd7f7(0)
	event.StreamClose(1)
	event.SetMesPos(0, 0)
end

--- Helper function.
local function helper_12f4(arg0: s32)
	local stream_open_state: s32 = 0
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var2 = 0
		end
		if at <= 2 then
			var2 = vm.i32(var2 + 1)
		end
		var2 = vm.i32(var2 + 1)
		return var2
	end
	if vm.skipping() then
		return skip(1)
	end
	var2 = 0
	while true do
		if vm.wait() then
			return skip(2)
		end
		var2 = vm.i32(var2 + 1)
		stream_open_state = event.StreamOpenCheck() or stream_open_state
		if stream_open_state == 0 then
			break
		end
	end
	event.StreamStandby(arg0)
	while true do
		if vm.wait() then
			return skip(3)
		end
		var2 = vm.i32(var2 + 1)
		stream_open_state = event.StreamOpenCheck() or stream_open_state
		if stream_open_state == 0 then
			break
		end
	end
	return var2
end

--- Helper function.
local function helper_11c1c()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local rot_x: f32 = 0
	local rot_y: f32 = 0
	local var4: f32 = 0
	local vector_x: f32 = 0
	local vector_y: f32 = 0
	local vector_z: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var11: f32 = 0
	local var12: f32 = 0
	local var13: f32 = 0
	local var14: s32 = 0
	local var15: s32 = 0
	local var16: s32 = 0
	local stream_open_state: s32 = 0
	local var18: s32 = 0
	local var19: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 61 then
			if at <= 2 then
				var4 = vm.f32(vector_z - vm.f32(3.1415927))
				helper_39d75add(1)
			end
			if at <= 3 then
				helper_5fe8(4080010)
			end
			if at <= 4 then
				helper_5fe8(4080020)
			end
			if at <= 5 then
				helper_5fe8(4080030)
			end
			if at <= 6 then
				var11 = -140.0
				var12 = vm.f32(1.9)
				var13 = vm.f32(-0.044)
				var15 = 0
				var16 = 0
				var14 = 0
				var11 = vm.f32(var11 + var12)
				var12 = vm.f32(var12 + var13)
				var15 = 0
				var16 = 1
				var16 = 0
				helper_dbbdb6d9(0, -1, 8, 0, 0)
				var18 = 4080040
				var15 = 1
				helper_581fd7f7(0)
				var18 = 4080043
				var15 = 1
				helper_581fd7f7(0)
				var18 = 4080046
				var15 = 1
				var14 = var14 + 1
			end
			if at <= 7 then
				helper_581fd7f7(0)
				helper_5fe8(4080050)
			end
			if at <= 8 then
				helper_5fe8(4080060)
			end
			if at <= 9 then
				helper_5fe8(4080070)
			end
			if at <= 10 then
				helper_39d75add(0)
			end
			if at <= 11 then
				helper_5fe8(4080080)
			end
			if at <= 12 then
				helper_6098(4080090, -1)
			end
			if at <= 13 then
				helper_39d75add(0)
			end
			if at <= 14 then
				helper_f92564d3(50)
			end
			if at <= 15 then
				helper_39d75add(3)
			end
			if at <= 16 then
				helper_f92564d3(4)
			end
			if at <= 17 then
				helper_e697ec97()
			end
			if at <= 18 then
				helper_5fe8(4080100)
			end
			if at <= 19 then
				helper_5fe8(4080110)
			end
			if at <= 20 then
				helper_f92564d3(10)
			end
			if at <= 21 then
				helper_39d75add(0)
			end
			if at <= 22 then
				helper_39d75add(3)
			end
			if at <= 23 then
				helper_5fe8(4080120)
			end
			if at <= 24 then
				helper_5fe8(4080130)
			end
			if at <= 25 then
				helper_5fe8(4080140)
			end
			if at <= 26 then
				helper_5fe8(4080150)
			end
			if at <= 27 then
				helper_f92564d3(90)
			end
			if at <= 28 then
				helper_f92564d3(10)
			end
			if at <= 29 then
				helper_5634(4080160, 50)
			end
			if at <= 30 then
				helper_39d75add(2)
			end
			if at <= 31 then
				helper_5fe8(4080170)
			end
			if at <= 32 then
				helper_39d75add(2)
			end
			if at <= 33 then
				helper_5fe8(4080180)
			end
			if at <= 34 then
				helper_5fe8(4080185)
			end
			if at <= 35 then
				helper_f92564d3(10)
			end
			if at <= 36 then
				helper_6098(4080190, -1)
			end
			if at <= 37 then
				var19 = helper_12f4(1)
			end
			if at <= 38 then
				helper_dbbdb6d9(0, -1, 8, 0, 0)
				helper_f92564d3(vm.i32(30 - var19))
			end
			if at <= 39 then
				helper_f92564d3(14)
			end
			if at <= 40 then
				helper_581fd7f7(0)
				helper_f92564d3(10)
			end
			if at <= 41 then
				helper_f92564d3(4)
			end
			if at <= 42 then
				helper_f92564d3(3)
			end
			if at <= 43 then
				helper_40746e5f()
			end
			if at <= 44 then
				helper_f92564d3(2)
			end
			if at <= 45 then
				helper_5634(4080205, 40)
			end
			if at <= 46 then
				helper_40746e5f()
			end
			if at <= 47 then
				helper_5fe8(4080210)
			end
			if at <= 48 then
				helper_f92564d3(2)
			end
			if at <= 49 then
				helper_f92564d3(8)
			end
			if at <= 50 then
				helper_39d75add(2)
			end
			if at <= 51 then
				helper_f92564d3(4)
			end
			if at <= 52 then
				helper_f92564d3(10)
			end
			if at <= 53 then
				helper_39d75add(2)
			end
			if at <= 54 then
				helper_5fe8(4080220)
			end
			if at <= 55 then
				helper_5fe8(4080230)
			end
			if at <= 56 then
				helper_39d75add(5)
			end
			if at <= 57 then
				helper_f92564d3(10)
			end
			if at <= 58 then
				helper_f92564d3(4)
			end
			if at <= 59 then
				helper_f92564d3(6)
			end
			if at <= 60 then
				helper_f92564d3(30)
			end
			if vm.skip_end() then
				return skip(62)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SndSeStop(var0, 2)
		event.SndSeStop(var0, 5)
		event.SndSeStop(var0, 6)
		event.SndSeStop(var0, 8)
		event.SndSeStop(var0, 9)
		event.SndSeStop(var0, 11)
		event.StopBgm(0)
		event.SetStatus(1, 0, 256, 0)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.EohSetMotion(0, "立ち", 4)
		event.EohSetMotion(1, "立ち", 4)
		event.EohSetRot(4, vector_x, vector_y, vector_z)
		event.EohSetPos(5, pos_x, pos_y, pos_z)
		event.DelExtMotion(0)
		event.DeleteChara(8)
		event.DeleteChara(9)
		event.DeleteChara(10)
		event.DeleteChara(11)
		event.DeleteChara(12)
		event.DeleteChara(13)
		event.LoadMes(0, -1)
		event.SetStatusbarShow(1, 1.0)
		event.EohSetShow(6, 1)
		event.EohSetShow(7, 1)
		event.BgmLoadCancel()
		event.Finish()
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFlag(408, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.SetStatusbarShow(0, 1.0)
	event.LoadSound(4803)
	var0 = event.SndLoadSound(4803) or var0
	event.SndSePlay(var0, 11)
	if vm.wait() then
		return skip(2)
	end
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.SetStatus(1, 0, 256, 1)
	event.ChangeDir("event/e400/e408/")
	event.LoadMes(0, 5, "e408.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e408_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e408_monica.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.LoadChara(5, "e408_paw.gltf", "info", 10)
	event.CharaActive(0, 10)
	event.EohSyncChara(2, 10)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.LoadChara(5, "e408_shigu.gltf", "info", 11)
	event.CharaActive(0, 11)
	event.EohSyncChara(3, 11)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.LoadChara(5, "mariometto_a.gltf", "info", 12)
	event.CharaActive(0, 12)
	event.SetReference(11, "metto_null", 12)
	event.LoadChara(5, "e408_mizusibuki.gltf", "info", 13)
	event.CharaActive(0, 13)
	event.SetCharaType(13, 4)
	event.ChangeDir("")
	if active_chr_no == 1 then
		event.LoadChara(5, "chara/c01_base.gltf", "info", 8)
		event.LoadEquip(5, 0, 4, "info", 8)
		event.LoadEquip(5, 0, 3, "info", 8)
		event.LoadEquip(5, 0, 2, "info", 8, 9)
		event.LoadMotion(5, "event/e400/e408/e408_mints.gltf", "info", 8)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 8)
		event.EohSyncChara(0, 8)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 0)
	else
		event.LoadChara(5, "chara/c02_base.gltf", "info", 8)
		event.LoadEquip(5, 1, 4, "info", 8)
		event.LoadEquip(5, 1, 3, "info", 8)
		event.LoadEquip(5, 1, 2, "info", 8, 9)
		event.LoadMotion(5, "event/e400/e408/e408_monica.gltf", "info", 8)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 8)
		event.EohSyncChara(1, 8)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 0)
	end
	event.CharaActive(8)
	event.CharaActive(9)
	event.EohSyncChara(6, 1)
	event.EohSyncChara(7, 2)
	event.EohSyncObj(4, "p06_s19", "s19_09-m1")
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.EohSyncObj(5, "p06_s19", "s19_10-m1")
	event.ObjsInit(5)
	event.ObjsSyncObj(5, 5)
	event.EohSetPos(0, -70.0, 5.18, 610.0)
	event.EohSetRot(0, 0.0, 3.14, 0.0)
	event.EohSetFootSoundId(0, 16)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "無表情")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	event.EohSetPos(1, -85.0, 5.18, 620.0)
	event.EohSetRot(1, 0.0, 3.14, 0.0)
	event.EohSetFootSoundId(1, 16)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "デフォルト顔")
	event.EohSetTexAnim(1, 1, "通常目パチ")
	event.EohSetPos(2, -76.0, -38.33, 1157.0)
	event.EohSetRot(2, 0.0, 3.14, 0.0)
	event.EohSetFootSoundId(2, 16)
	event.EohSetPos(3, -68.33, -4.68, 302.5)
	event.EohSetRot(3, 0.0, 0.0, 0.0)
	event.EohSetMotion(3, "出現", 5)
	event.EohSetTexAnim(3, 0)
	event.EohSetTexAnim(3, 1, "赤目パチ")
	event.SetCharaPos(13, -72.26, 0.0, 371.59)
	event.SetCharaRot(13, 0.0, -0.12, 0.0)
	event.EohSetShow(6, 0)
	event.EohSetShow(7, 0)
	do
		local out1, out2, out3 = event.EohGetRot(4)
		rot_x = out1 or rot_x
		rot_y = out2 or rot_y
		var4 = out3 or var4
	end
	do
		local out1, out2, out3 = event.CopyVector(rot_x, rot_y, var4)
		vector_x = out1 or vector_x
		vector_y = out2 or vector_y
		vector_z = out3 or vector_z
	end
	do
		local out1, out2, out3 = event.EohGetPos(5)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	var4 = vm.f32(vector_z - vm.f32(3.1415927))
	var4 = event.AngleLimit(var4) or var4
	event.InitDramaScene()
	event.CmrsInit()
	event.CmrsSetPos(-78.09, 35.57, 471.0)
	event.CmrsSetRef(-77.73, 22.13, 561.51)
	event.ObjsMove(0, -70.0, 4.89, 540.0, 60, 1)
	event.ObjsSetMotion(0, "歩き", 4)
	event.ObjsMotionDelay(0, 60)
	event.ObjsSetMotion(0, "立ち")
	event.ObjsMove(1, -85.0, 5.18, 540.0, 70, 1)
	event.ObjsSetMotion(1, "歩き", 4)
	event.ObjsMotionDelay(1, 70)
	event.ObjsSetMotion(1, "立ち")
	event.SetFadeIn(30)
	helper_39d75add(1)
	if vm.skipping() then
		return skip(3)
	end
	event.SetPakuAnim(0, "通常口パク")
	helper_5fe8(4080010)
	if vm.skipping() then
		return skip(4)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_5fe8(4080020)
	if vm.skipping() then
		return skip(5)
	end
	event.CmrsSetPos(-80.97, 22.27, 518.15)
	event.CmrsSetRef(-69.62, 27.4, 537.26)
	event.SetPakuAnim(0, "通常口パク")
	helper_5fe8(4080030)
	if vm.skipping() then
		return skip(6)
	end
	event.SetMesOkuri(0, 0)
	var11 = -140.0
	var12 = vm.f32(1.9)
	var13 = vm.f32(-0.044)
	event.CmrsSetPos(-86.24, 243.02, 628.3)
	event.CmrsSetRef(var11, 253.78, 519.17)
	var15 = 0
	var16 = 0
	var14 = 0
	while var14 < 440 do
		event.CmrsSetRef(var11, 253.78, 519.17)
		var11 = vm.f32(var11 + var12)
		if var14 < 42 then
			var12 = vm.f32(var12 + var13)
		end
		if var15 == 1 then
			stream_open_state = event.StreamOpenCheck() or stream_open_state
			if stream_open_state == 0 then
				var15 = 0
				var16 = 1
				event.StreamStandby(1)
			end
		end
		if var16 == 1 then
			stream_open_state = event.StreamOpenCheck() or stream_open_state
			if stream_open_state == 0 then
				var16 = 0
				event.MesMake_2(0, var18)
				helper_dbbdb6d9(0, -1, 8, 0, 0)
				event.StreamPlay(1)
			end
		end
		if var14 == 0 then
			var18 = 4080040
			event.StreamOpen3(1, var18)
			var15 = 1
		end
		if var14 == 150 then
			helper_581fd7f7(0)
			event.StreamClose(1)
			var18 = 4080043
			event.StreamOpen3(1, var18)
			var15 = 1
		end
		if var14 == 324 then
			helper_581fd7f7(0)
			event.StreamClose(1)
			var18 = 4080046
			event.StreamOpen3(1, var18)
			var15 = 1
		end
		var14 = var14 + 1
		if vm.wait() then
			return skip(7)
		end
	end
	helper_581fd7f7(0)
	event.StreamClose(1)
	event.SetMesOkuri(0, 1)
	event.CmrsSetPos(-71.52, 55.19, 769.57)
	event.CmrsSetRef(-78.08, 79.65, 504.61)
	event.SetPakuAnim(0, "通常口パク")
	helper_5fe8(4080050)
	if vm.skipping() then
		return skip(8)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_5fe8(4080060)
	if vm.skipping() then
		return skip(9)
	end
	event.ObjsSetMotion(0, "左向く", 6)
	event.ObjsNextMotion(0, "左向くL", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_5fe8(4080070)
	if vm.skipping() then
		return skip(10)
	end
	helper_39d75add(0)
	if vm.skipping() then
		return skip(11)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_5fe8(4080080)
	if vm.skipping() then
		return skip(12)
	end
	helper_6098(4080090, -1)
	if vm.skipping() then
		return skip(13)
	end
	event.ObjsSetMotion(0, "左向く戻り", 6)
	event.ObjsNextMotion(0, "立ち", 4)
	helper_39d75add(0)
	if vm.skipping() then
		return skip(14)
	end
	event.CharaActive(11)
	event.CharaActive(12)
	event.ObjsSetMotion(3, "出現", 6)
	event.ObjsNextMotion(3, "出現L", 4)
	event.CharaActive(1, 13)
	event.SetMotion(13, "出現", 6)
	event.SndSePlay(var0, 2)
	helper_f92564d3(50)
	if vm.skipping() then
		return skip(15)
	end
	event.CmrsSetPos(-79.56, 83.32, 667.05)
	event.CmrsSetRef(-76.25, 31.32, 465.62)
	event.ObjsSetMotion(0, "驚く", 6)
	event.ObjsNextMotion(0, "驚くL", 4)
	event.ObjsSetMotion(1, "びっくりから上見", 6)
	event.ObjsNextMotion(1, "上向くL", 4)
	helper_39d75add(3)
	if vm.skipping() then
		return skip(16)
	end
	event.StopBgm(0)
	event.SetLoadbgFile("snd2/bgm/bg_191.sound.json")
	helper_f92564d3(4)
	if vm.skipping() then
		return skip(17)
	end
	helper_e697ec97()
	if vm.skipping() then
		return skip(18)
	end
	event.LoadBgmPack(191)
	event.PlayBgm(0)
	event.CmrsSetPos(-82.34, 24.64, 525.1)
	event.CmrsSetRef(-68.49, 28.0, 544.23)
	event.CharaActive(0, 13)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "おこり顔")
	event.EohSetTexAnim(0, 1, "おこり目パチ")
	event.SetPakuAnim(0, "大口パク")
	helper_5fe8(4080100)
	if vm.skipping() then
		return skip(19)
	end
	event.CmrsSetPos(-73.64, 31.85, 524.1)
	event.CmrsSetRef(-86.33, 28.93, 539.68)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "おこり顔")
	event.EohSetTexAnim(1, 1, "おこり目パチ")
	event.SetPakuAnim(1, "通常口パク")
	helper_5fe8(4080110)
	if vm.skipping() then
		return skip(20)
	end
	event.CmrsSetPos(-80.48, 94.7, 723.29)
	event.CmrsSetRef(-76.25, 38.16, 465.62)
	event.ObjsSetPos(3, -78.11, -15.13, 426.88)
	event.ObjsSetMotion(3, "攻撃", 6)
	event.ObjsNextMotion(3, "立ち2", 4)
	helper_f92564d3(10)
	if vm.skipping() then
		return skip(21)
	end
	event.SndSePlay(var0, 3)
	event.ObjsMove(0, -44.9, 3.81, 599.34, 20)
	event.ObjsRotation(0, 0.0, 0.38, 0.0, 8)
	event.ObjsRotDelay(0, 4)
	event.ObjsRotation(0, 0.0, -2.98, 0.0, 8)
	event.ObjsSetMotion(0, "走り")
	event.ObjsMotionDelay(0, 20)
	event.ObjsSetMotion(0, "立ち")
	event.ObjsMove(1, -112.34, 5.0, 594.97, 20)
	event.ObjsRotation(1, 0.0, -0.5, 0.0, 8)
	event.ObjsRotDelay(1, 4)
	event.ObjsRotation(1, 0.0, 2.78, 0.0, 8)
	event.ObjsSetMotion(1, "走り")
	event.ObjsMotionDelay(1, 20)
	event.ObjsSetMotion(1, "立ち")
	helper_39d75add(0)
	if vm.skipping() then
		return skip(22)
	end
	helper_39d75add(3)
	if vm.skipping() then
		return skip(23)
	end
	event.CmrsSetPos(-62.07, 18.74, 574.92)
	event.CmrsSetRef(-42.47, 24.02, 598.1)
	event.SndSePlay(var0, 4)
	event.ObjsSetMotion(0, "やめろ", 6)
	event.ObjsNextMotion(0, "驚くL", 4)
	event.SetPakuAnim(0, "大口パク")
	helper_5fe8(4080120)
	if vm.skipping() then
		return skip(24)
	end
	event.CmrsSetPos(-90.65, 28.85, 590.7)
	event.CmrsSetRef(-115.93, 29.03, 592.13)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "おこり顔")
	event.EohSetTexAnim(1, 1, "おこり目パチ")
	event.ObjsSetMotion(1, "上向くL", 4, -1.0, 1)
	event.SetPakuAnim(1, "大口パク")
	helper_5fe8(4080130)
	if vm.skipping() then
		return skip(25)
	end
	event.CmrsSetPos(-72.77, 80.75, 769.84)
	event.CmrsSetRef(-77.4, 43.66, 562.84)
	event.SndSePlay(var0, 5)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "おこり顔")
	event.EohSetTexAnim(1, 1, "おこり目パチ")
	event.ObjsSetMotion(3, "威嚇", 6)
	event.ObjsNextMotion(3, "立ち2", 4)
	event.SetPakuAnim(0, "大口パク")
	helper_5fe8(4080140)
	if vm.skipping() then
		return skip(26)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_5fe8(4080150)
	if vm.skipping() then
		return skip(27)
	end
	event.SndSeStop(var0, 5)
	event.CmrsSetPos(-76.95, 45.52, 498.09)
	event.CmrsSetRef(-76.43, 15.43, 706.96)
	event.SndSePlay(var0, 6)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "おこり顔")
	event.EohSetTexAnim(0, 1, "おこり目～通常目")
	event.CharaActive(10)
	event.ObjsRotation2(4, rot_x, rot_y, var4, 40, 0, 0.5)
	event.ObjsRotDelay(4, 168)
	event.ObjsRotation2(4, vector_x, vector_y, vector_z, 40, 0, 0.5)
	event.ObjsPosDelay(5, 80)
	event.ObjsMove2(5, pos_x, pos_y + 80.0, pos_z, 32, 1, 0.5)
	event.ObjsPosDelay(5, 40)
	event.ObjsMove2(5, pos_x, pos_y, pos_z, 32, 0, 0.5)
	event.ObjsSetMotion(0, "立ち", 6)
	event.ObjsMotionDelay(0, 4)
	event.ObjsSetMotion(0, "振り向く（左）", 6)
	event.ObjsNextMotion(0, "振り向く（左）L", 4)
	event.ObjsSetMotion(1, "立ち", 6)
	event.ObjsMotionDelay(1, 10)
	event.ObjsSetMotion(1, "振り向き", 6)
	event.ObjsNextMotion(1, "振り向きＬ", 4)
	helper_f92564d3(90)
	if vm.skipping() then
		return skip(28)
	end
	event.ObjsSetMotion(2, "上見走り")
	event.ObjsMove(2, -76.55, 0.45, 877.82, 60, 1)
	helper_f92564d3(10)
	if vm.skipping() then
		return skip(29)
	end
	event.SetPakuAnim(0, "通常口パク")
	helper_5634(4080160, 50)
	if vm.skipping() then
		return skip(30)
	end
	helper_39d75add(2)
	if vm.skipping() then
		return skip(31)
	end
	event.CmrsSyncObj(2, 0.0, 18.3, -4.0, -2.0, -0.57, 24.0)
	event.ObjsSetPos(2, -76.0, 1.92, 813.28)
	event.ObjsMove(2, -78.0, 4.89, 551.73, 120, 1)
	event.ObjsMotionDelay(2, 120)
	event.ObjsSetMotion(2, "上見立ち")
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "おこり目")
	event.ObjsSetMotion(0, "驚くL", 4, -1.0, 1)
	event.ObjsSetMotion(1, "上向くL", 4, -1.0, 1)
	helper_5fe8(4080170)
	if vm.skipping() then
		return skip(32)
	end
	helper_39d75add(2)
	if vm.skipping() then
		return skip(33)
	end
	event.CmrsReleaseObj()
	event.SetPakuAnim(1, "通常口パク")
	helper_5fe8(4080180)
	if vm.skipping() then
		return skip(34)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_5fe8(4080185)
	if vm.skipping() then
		return skip(35)
	end
	helper_f92564d3(10)
	if vm.skipping() then
		return skip(36)
	end
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "おこり目～おどろき目")
	event.ObjsSetMotion(2, "！！", 2)
	event.ObjsNextMotion(2, "上見立ち")
	helper_6098(4080190, -1)
	if vm.skipping() then
		return skip(37)
	end
	event.CmrsSetPos(-73.07, -10.65, 595.6)
	event.CmrsSetRef(-87.35, 69.1, 460.59)
	event.SndSePlay(var0, 7)
	event.CharaActive(0, 10)
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "おこり目")
	event.ObjsSetMotion(3, "攻撃", 6)
	event.ObjsMotionDelay(3, 30)
	event.ObjsSetMotion(3, "攻撃", 1)
	event.SetPakuAnim(0, "通常口パク")
	event.StreamOpen3(1, 4080200)
	var19 = helper_12f4(1)
	if vm.skipping() then
		return skip(38)
	end
	event.SetMesOkuri(0, 0)
	event.MesMake_2(0, 4080200)
	helper_dbbdb6d9(0, -1, 8, 0, 0)
	event.StreamPlay(1)
	helper_f92564d3(vm.i32(30 - var19))
	if vm.skipping() then
		return skip(39)
	end
	event.CmrsSetPos(-92.53, 6.56, 559.96)
	event.CmrsSetRef(-39.54, 19.62, 593.16)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "おこり顔")
	event.EohSetTexAnim(0, 1, "おこり目パチ")
	event.EohSetTexAnim(0, 1, "大口パク")
	event.ObjsSetMotion(0, "立ち", 4)
	event.ObjsSetMotion(0, "走り")
	event.ObjsMove(0, -64.66, 4.79, 541.75, 14, 1)
	helper_f92564d3(14)
	if vm.skipping() then
		return skip(40)
	end
	helper_581fd7f7(0)
	event.StreamClose(1)
	event.SetMesOkuri(0, 1)
	event.CmrsSetPos(-77.13, 11.5, 549.0)
	event.CmrsSetRef(-117.01, 21.86, 587.27)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "おこり顔")
	event.EohSetTexAnim(1, 1, "おこり目パチ")
	event.EohSetTexAnim(1, 1, "大口")
	event.ObjsSetMotion(1, "上見びっくり", 6)
	event.ObjsNextMotion(1, "上向くL", 4)
	helper_f92564d3(10)
	if vm.skipping() then
		return skip(41)
	end
	event.CmrsSetPos(-81.01, 33.49, 535.66)
	event.CmrsSetRef(-86.5, 39.49, 520.89)
	event.SndSePlay(var0, 8)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "おこり顔")
	event.EohSetTexAnim(0, 1, "おこり目パチ")
	event.EohSetTexAnim(0, 1, "大口")
	event.ObjsSetMotion(3, "攻撃2", 6)
	event.ObjsMotionDelay(3, 10)
	event.ObjsSetMotion(3, "攻撃", 1)
	event.ObjsSetPos(0, -8.54, 2.83, 545.17)
	event.ObjsSetRot(0, 0.0, -1.7, 0.0)
	helper_f92564d3(4)
	if vm.skipping() then
		return skip(42)
	end
	event.CmrsMove2(-81.01, 33.49, 535.66, -67.85, 33.31, 537.58, 12, 0, 0.4)
	helper_f92564d3(3)
	if vm.skipping() then
		return skip(43)
	end
	event.ObjsSetMotion(0, "タックル", 6, -1.0, 1)
	helper_40746e5f()
	if vm.skipping() then
		return skip(44)
	end
	event.ObjsSetMotion(3, "攻撃3", 6)
	event.CmrsMove2(-157.5, 18.3, 524.15, -141.51, 23.91, 526.12, 8, 2, 1.0)
	event.CmrsQuake(0.0, 6.0, 0.0, 30)
	helper_f92564d3(2)
	if vm.skipping() then
		return skip(45)
	end
	if active_chr_no == 0 then
		event.CharaActive(0, 0)
	else
		event.CharaActive(0, 8)
		event.CharaActive(0, 9)
	end
	helper_5634(4080205, 40)
	if vm.skipping() then
		return skip(46)
	end
	helper_40746e5f()
	if vm.skipping() then
		return skip(47)
	end
	event.CmrsSetPos(-154.32, 107.18, 768.06)
	event.CmrsSetRef(-95.44, 20.24, 463.89)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "おこり顔")
	event.EohSetTexAnim(0, 1, "おこり目パチ")
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "おこり顔")
	event.EohSetTexAnim(1, 1, "おこり目パチ")
	if active_chr_no == 0 then
		event.CharaActive(0)
	else
		event.CharaActive(8)
		event.CharaActive(9)
	end
	event.CharaActive(10)
	event.ObjsSetPos(0, -144.47, 6.3, 567.45)
	event.ObjsSetRot(0, 0.0, 2.02, 0.0)
	event.ObjsSetMotion(0, "立ちあがる", 6, -1.0, 1)
	event.ObjsNextMotion(0, "立ち", 4)
	event.ObjsSetMotion(1, "立ち", 4, -1.0, 1)
	event.ObjsSetPos(2, -168.07, 3.48, 508.64)
	event.ObjsSetRot(2, 0.0, 1.22, 0.0)
	event.ObjsResetMotion(2)
	event.ObjsSetMotion(2, "立ちあがる", 6)
	event.ObjsNextMotion(2, "立ち", 4)
	event.ObjsSetPos(3, -50.57, -15.41, 428.09)
	event.ObjsSetRot(3, 0.0, -0.36, 0.0)
	event.ObjsSetMotion(3, "立ち2", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_5fe8(4080210)
	if vm.skipping() then
		return skip(48)
	end
	event.ObjsSetMotion(1, "走り")
	event.ObjsMove(1, -111.4, 3.75, 698.18, 40, 1)
	event.ObjsRotation(1, 0.0, 0.14, 0.0, 8)
	helper_f92564d3(2)
	if vm.skipping() then
		return skip(49)
	end
	event.ObjsSetMotion(0, "走り")
	event.ObjsMove(0, -146.03, 4.47, 681.95, 50, 1)
	event.ObjsRotation(0, 0.0, 0.1, 0.0, 8)
	helper_f92564d3(8)
	if vm.skipping() then
		return skip(50)
	end
	event.ObjsSetMotion(2, "走り")
	event.ObjsMove(2, -157.24, 4.74, 682.84, 50, 1)
	event.ObjsRotation(2, 0.0, 0.02, 0.0, 8)
	helper_39d75add(2)
	if vm.skipping() then
		return skip(51)
	end
	event.CmrsSetPos(-76.59, 45.52, 642.13)
	event.CmrsSetRef(-76.07, 15.43, 850.71)
	event.FadeOutBgm(60)
	event.ObjsMove(1, -85.95, -25.91, 1068.48, 80, 1)
	event.ObjsMotionDelay(1, 80)
	event.ObjsSetMotion(1, "立ち")
	event.ObjsRotDelay(1, 72)
	event.ObjsRotation(1, 0.0, 3.02, 0.0, 8)
	event.ObjsRotDelay(4, 90)
	event.ObjsRotation2(4, rot_x, rot_y, var4, 40, 0, 0.5)
	event.ObjsPosDelay(5, 130)
	event.ObjsMove2(5, pos_x, pos_y + 80.0, pos_z, 32, 1, 0.5)
	event.ObjsSeDelay(5, 90)
	event.ObjsSePlay(5, var0, 9)
	helper_f92564d3(4)
	if vm.skipping() then
		return skip(52)
	end
	event.ObjsSetPos(0, -61.85, 3.51, 650.67)
	event.ObjsSetRot(0, 0.0, -0.1, 0.0)
	event.ObjsMove(0, -54.15, -4.35, 911.55, 60, 1)
	event.ObjsMotionDelay(0, 60)
	event.ObjsSetMotion(0, "立ち")
	event.ObjsMotionDelay(0, 5)
	event.ObjsSetMotion(0, "振り向く（右）", 6)
	event.ObjsNextMotion(0, "振り向く（右）L", 4)
	helper_f92564d3(10)
	if vm.skipping() then
		return skip(53)
	end
	event.ObjsSetPos(2, -87.61, 3.87, 655.48)
	event.ObjsSetRot(2, 0.0, 0.1, 0.0)
	event.ObjsMove(2, -87.84, 2.52, 774.78, 40, 1)
	event.ObjsMotionDelay(2, 40)
	event.ObjsSetMotion(2, "振り向く", 2)
	event.ObjsNextMotion(2, "振り向くL", 4)
	helper_39d75add(2)
	if vm.skipping() then
		return skip(54)
	end
	helper_5fe8(4080220)
	if vm.skipping() then
		return skip(55)
	end
	event.SetPakuAnim(0, "大口パク")
	helper_5fe8(4080230)
	if vm.skipping() then
		return skip(56)
	end
	helper_39d75add(5)
	if vm.skipping() then
		return skip(57)
	end
	event.ObjsSetMotion(1, "走り")
	event.ObjsMotionDelay(1, 50)
	event.ObjsSetMotion(1, "立ち")
	event.ObjsMove(1, -19.76, -41.08, 1213.94, 50)
	event.ObjsRotation(1, 0.0, 0.26, 0.0, 6)
	event.ObjsSetMotion(0, "振り向く（右）戻り", 6)
	event.ObjsNextMotion(0, "立ち", 4)
	event.ObjsMotionDelay(0, 1)
	event.ObjsSetMotion(0, "走り")
	event.ObjsPosDelay(0, 18)
	event.ObjsMove(0, -66.76, -20.35, 1068.29, 40, 1)
	helper_f92564d3(10)
	if vm.skipping() then
		return skip(58)
	end
	event.ObjsSetMotion(2, "振り向く戻り", 6)
	event.ObjsNextMotion(2, "走り")
	event.ObjsPosDelay(2, 20)
	event.ObjsMove(2, -82.88, -2.14, 896.69, 40, 1)
	helper_f92564d3(4)
	if vm.skipping() then
		return skip(59)
	end
	helper_f92564d3(6)
	if vm.skipping() then
		return skip(60)
	end
	event.SetFadeOut(30)
	helper_f92564d3(30)
	if vm.skipping() then
		return skip(61)
	end
	return part2()
end

--- Helper function.
local function helper_225a4(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	if vm.wait() then
		return skip(2)
	end
	event.EohSyncObj(0, "p01_s19", "s19_02-a0")
	event.EohSetShow(0, arg0)
	event.Finish()
end

--- Helper function.
local function helper_1bfac()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local block: s32 = 0
	local rot_x: f32 = 0
	local rot_y: f32 = 0
	local var5: f32 = 0
	local vector_x: f32 = 0
	local vector_y: f32 = 0
	local vector_z: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 12 then
			if at <= 1 then
				helper_f92564d3(6)
			end
			if at <= 2 then
				var5 = vm.f32(vector_z - vm.f32(3.1415927))
				helper_f92564d3(30)
			end
			if at <= 3 then
				helper_39d75add(1)
			end
			if at <= 4 then
				helper_f92564d3(10)
			end
			if at <= 5 then
				helper_5fe8(4160010)
			end
			if at <= 6 then
				helper_5fe8(4160020)
			end
			if at <= 7 then
				helper_39d75add(1)
			end
			if at <= 8 then
				helper_f92564d3(10)
			end
			if at <= 9 then
				helper_5fe8(4160030)
			end
			if at <= 10 then
				helper_39d75add(0)
			end
			if at <= 11 then
				helper_f92564d3(30)
			end
			if vm.skip_end() then
				return skip(13)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SndSeStop(var0, 0)
		event.SndSeStop(var0, 1)
		event.SndSeStop(var0, 2)
		event.SpriteSetDraw(0, 0)
		event.PlayBgm(0)
		event.SetStatus(1, 0, 256, 0)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.EohSetMotion(0, "立ち", 4)
		event.EohSetMotion(1, "立ち", 4)
		event.EohSetRot(3, vector_x, vector_y, vector_z)
		event.EohSetPos(4, pos_x, pos_y, pos_z)
		event.DelExtMotion(0)
		event.DeleteChara(8)
		event.DeleteChara(9)
		event.DeleteChara(10)
		event.DeleteChara(11)
		event.DelImg(0)
		event.LoadMes(0, -1)
		event.SetStatusbarShow(1, 1.0)
		event.EohSetShow(5, 1)
		event.EohSetShow(6, 1)
		event.CharaActive(0)
		event.SetCharaPos(0, -96.2, 1.8, 851.5)
		event.SetCharaRot(0, 0.0, 3.14, 0.0)
		event.SetMotion(0, "立ち", 4)
		event.CharaNormalDrive(0)
		event.CharaResetDa(0)
		event.SetCameraRef(-96.2, 31.8, 851.5)
		event.SetCameraPos(-96.2, 41.8, 951.5)
		event.ResetCamera(0)
		if vm.wait() then
			return skip(14)
		end
		event.LoadMonsterFile(516, 1)
		event.LoadMonsterFile(1001, 0)
		event.AutoSetMonster(516, -78.11, -15.13, 426.88, 0.0, 0.0, 0.0)
		event.SetFadeIn(30)
		event.Finish()
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFlag(416, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.SetStatusbarShow(0, 1.0)
	event.StopBgm(0)
	helper_f92564d3(6)
	if vm.skipping() then
		return skip(2)
	end
	event.LoadBgm(30)
	event.LoadSound(4809)
	var0 = event.SndLoadSound(4809) or var0
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.SetStatus(1, 0, 256, 1)
	event.ChangeDir("event/e400/e416/")
	event.LoadMes(0, 5, "e416.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e416_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e416_monica.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	block = event.LoadImg_4(5, "e416telop01.json", 0) or block
	event.SpriteInit(0)
	event.SpriteSetType(0, 0)
	event.SpriteSetTexture(0, "e416telop01", block)
	event.SpriteSetColor(0, 128, 128, 128, 0)
	event.SpriteSetUvsize(0, 0, 0, 512, 128)
	event.SpriteSetPutsize(0, 512, 128)
	event.SpriteSetPos(0, 256, 312)
	event.SpriteSetAlphab(0, 0)
	event.SpriteSetDraw(0, 0)
	event.EohSyncSprite(7, 0)
	event.ObjsInit(5)
	event.ObjsSyncObj(5, 7)
	event.ChangeDir("")
	event.LoadChara(5, "event/e400/e410/e410_shigu.gltf", "info", 10)
	event.CharaActive(10)
	event.EohSyncChara(2, 10)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.LoadChara(5, "event/e400/e410/mariometto_a.gltf", "info", 11)
	event.CharaActive(11)
	event.SetReference(10, "metto_null", 11)
	if active_chr_no == 1 then
		event.LoadChara(5, "chara/c01_base.gltf", "info", 8)
		event.LoadEquip(5, 0, 4, "info", 8)
		event.LoadEquip(5, 0, 3, "info", 8)
		event.LoadEquip(5, 0, 2, "info", 8, 9)
		event.LoadMotion(5, "event/e400/e416/e416_mints.gltf", "info", 8)
		event.EohSyncChara(0, 8)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	else
		event.LoadChara(5, "chara/c02_base.gltf", "info", 8)
		event.LoadEquip(5, 1, 4, "info", 8)
		event.LoadEquip(5, 1, 3, "info", 8)
		event.LoadEquip(5, 1, 2, "info", 8, 9)
		event.LoadMotion(5, "event/e400/e416/e416_monica.gltf", "info", 8)
		event.EohSyncChara(1, 8)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.CharaActive(8)
	event.CharaActive(9)
	event.EohSyncChara(5, 1)
	event.EohSyncChara(6, 2)
	event.EohSyncObj(3, "p06_s19", "s19_09-m1")
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.EohSyncObj(4, "p06_s19", "s19_10-m1")
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.EohSetPos(0, -65.0, -38.28, 1157.0)
	event.EohSetRot(0, 0.0, 3.14, 0.0)
	event.EohSetMotion(0, "立ち", 4)
	event.EohSetFootSoundId(0, 16)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "おこり顔")
	event.EohSetTexAnim(0, 1, "おこり目パチ")
	event.EohSetPos(1, -85.0, -38.13, 1157.0)
	event.EohSetRot(1, 0.0, 3.14, 0.0)
	event.EohSetMotion(1, "立ち", 4)
	event.EohSetFootSoundId(1, 16)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "おこり顔")
	event.EohSetTexAnim(1, 1, "おこり目パチ")
	event.EohSetPos(2, -78.11, -15.13, 426.88)
	event.EohSetRot(2, 0.0, 0.0, 0.0)
	event.EohSetMotion(2, "威嚇", 4)
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "赤目パチ")
	event.EohSetShow(5, 0)
	event.EohSetShow(6, 0)
	do
		local out1, out2, out3 = event.EohGetRot(3)
		rot_x = out1 or rot_x
		rot_y = out2 or rot_y
		var5 = out3 or var5
	end
	do
		local out1, out2, out3 = event.CopyVector(rot_x, rot_y, var5)
		vector_x = out1 or vector_x
		vector_y = out2 or vector_y
		vector_z = out3 or vector_z
	end
	do
		local out1, out2, out3 = event.EohGetPos(4)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	var5 = vm.f32(vector_z - vm.f32(3.1415927))
	var5 = event.AngleLimit(var5) or var5
	event.InitDramaScene()
	event.CmrsInit()
	event.CmrsSetPos(-228.84, 94.46, 882.3)
	event.CmrsSetRef(-94.17, 38.37, 1068.72)
	event.ObjsRotation2(3, rot_x, rot_y, var5, 40, 0, 0.5)
	event.ObjsPosDelay(4, 80)
	event.ObjsMove2(4, pos_x, pos_y + 80.0, pos_z, 32, 1, 0.5)
	event.ObjsPosDelay(0, 100)
	event.ObjsMove(0, -65.0, -16.86, 1002.55, 40)
	event.ObjsMotionDelay(0, 100)
	event.ObjsSetMotion(0, "走り")
	event.ObjsMotionDelay(0, 40)
	event.ObjsSetMotion(0, "立ち")
	event.ObjsPosDelay(1, 110)
	event.ObjsMove(1, -85.0, -16.86, 1002.55, 40)
	event.ObjsMotionDelay(1, 110)
	event.ObjsSetMotion(1, "走り")
	event.ObjsMotionDelay(1, 40)
	event.ObjsSetMotion(1, "立ち")
	event.SetFadeIn(30)
	helper_f92564d3(30)
	if vm.skipping() then
		return skip(3)
	end
	event.SndSePlay(var0, 0)
	helper_39d75add(1)
	if vm.skipping() then
		return skip(4)
	end
	helper_f92564d3(10)
	if vm.skipping() then
		return skip(5)
	end
	event.CmrsSetPos(-70.27, 35.0, 783.66)
	event.CmrsSetRef(-73.25, 38.33, 674.48)
	event.SpriteSetDraw(0, 1)
	event.ObjsSetColor(5, 128, 128, 128, 128, 30)
	event.SndSePlay(var0, 1)
	event.ObjsSetPos(0, -50.18, 3.08, 671.54)
	event.ObjsSetRot(0, 0.0, -2.9, 0)
	event.ObjsResetDaPosition(0)
	event.ObjsSetPos(1, -96.49, 3.79, 674.91)
	event.ObjsSetRot(1, 0.0, 2.78, 0.0)
	event.ObjsResetDaPosition(1)
	event.PlayBgm(0)
	helper_5fe8(4160010)
	if vm.skipping() then
		return skip(6)
	end
	event.SpriteSetDraw(0, 0)
	event.SndSeStop(var0, 1)
	event.CmrsSetPos(-29.56, 15.56, 642.62)
	event.CmrsSetRef(-64.62, 25.05, 676.95)
	event.ObjsSetMotion(0, "間抜け立ち", 4, -1.0, 1)
	event.ObjsSetPos(1, -78.55, 3.48, 677.41)
	event.ObjsSetRot(1, 0.0, 2.3, 0.0)
	event.ObjsSetMotion(1, "指差し", 6, -1.0, 1)
	event.ObjsNextMotion(1, "指差し会話", 6)
	event.ObjsNextMotion(1, "指差しＬ", 4)
	event.SetPakuAnim(1, "大口パク")
	helper_5fe8(4160020)
	if vm.skipping() then
		return skip(7)
	end
	helper_39d75add(1)
	if vm.skipping() then
		return skip(8)
	end
	event.ObjsSetMotion(0, "うん！", 2)
	event.ObjsNextMotion(0, "間抜け立ち", 4)
	helper_f92564d3(10)
	if vm.skipping() then
		return skip(9)
	end
	event.SndSePlay(var0, 2)
	event.SetPakuAnim(0, "通常口パク")
	helper_5fe8(4160030)
	if vm.skipping() then
		return skip(10)
	end
	helper_39d75add(0)
	if vm.skipping() then
		return skip(11)
	end
	event.SetFadeOut(30)
	helper_f92564d3(30)
	if vm.skipping() then
		return skip(12)
	end
	return part2()
end

--- Helper function.
local function helper_199cc()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local rot_x: f32 = 0
	local rot_y: f32 = 0
	local var4: f32 = 0
	local vector_x: f32 = 0
	local vector_y: f32 = 0
	local vector_z: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 10 then
			if at <= 1 then
				var4 = vm.f32(vector_z - vm.f32(3.1415927))
				helper_f92564d3(30)
			end
			if at <= 2 then
				helper_39d75add(1)
			end
			if at <= 3 then
				helper_f92564d3(6)
			end
			if at <= 4 then
				helper_5fe8(4100010)
			end
			if at <= 5 then
				helper_5fe8(4100020)
			end
			if at <= 6 then
				helper_5fe8(4100030)
			end
			if at <= 7 then
				helper_f92564d3(10)
			end
			if at <= 8 then
				helper_f92564d3(20)
			end
			if at <= 9 then
				helper_f92564d3(30)
			end
			if vm.skip_end() then
				return skip(11)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SndSeStop(var0, 0)
		event.SndSeStop(var0, 1)
		event.SetStatus(1, 0, 256, 0)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.EohSetMotion(0, "立ち", 4)
		event.EohSetMotion(1, "立ち", 4)
		event.EohSetRot(3, vector_x, vector_y, vector_z)
		event.EohSetPos(4, pos_x, pos_y, pos_z)
		event.DelExtMotion(0)
		event.DeleteChara(8)
		event.DeleteChara(9)
		event.DeleteChara(10)
		event.DeleteChara(11)
		event.LoadMes(0, -1)
		event.SetStatusbarShow(1, 1.0)
		event.EohSetShow(5, 1)
		event.EohSetShow(6, 1)
		event.Finish()
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFlag(410, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.SetStatusbarShow(0, 1.0)
	event.LoadSound(4806)
	var0 = event.SndLoadSound(4806) or var0
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.SetStatus(1, 0, 256, 1)
	event.ChangeDir("event/e400/e410/")
	event.LoadMes(0, 5, "e410.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e410_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e410_monica.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.LoadChara(5, "e410_shigu.gltf", "info", 10)
	event.CharaActive(10)
	event.EohSyncChara(2, 10)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.LoadChara(5, "mariometto_a.gltf", "info", 11)
	event.CharaActive(11)
	event.SetReference(10, "metto_null", 11)
	event.ChangeDir("")
	if active_chr_no == 1 then
		event.LoadChara(5, "chara/c01_base.gltf", "info", 8)
		event.LoadEquip(5, 0, 4, "info", 8)
		event.LoadEquip(5, 0, 3, "info", 8)
		event.LoadEquip(5, 0, 2, "info", 8, 9)
		event.LoadMotion(5, "event/e400/e410/e410_mints.gltf", "info", 8)
		event.EohSyncChara(0, 8)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	else
		event.LoadChara(5, "chara/c02_base.gltf", "info", 8)
		event.LoadEquip(5, 1, 4, "info", 8)
		event.LoadEquip(5, 1, 3, "info", 8)
		event.LoadEquip(5, 1, 2, "info", 8, 9)
		event.LoadMotion(5, "event/e400/e410/e410_monica.gltf", "info", 8)
		event.EohSyncChara(1, 8)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.CharaActive(8)
	event.CharaActive(9)
	event.EohSyncChara(5, 1)
	event.EohSyncChara(6, 2)
	event.EohSyncObj(3, "p06_s19", "s19_09-m1")
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.EohSyncObj(4, "p06_s19", "s19_10-m1")
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.EohSetPos(0, -65.0, -38.28, 1157.0)
	event.EohSetRot(0, 0.0, 3.14, 0.0)
	event.EohSetMotion(0, "立ち", 4)
	event.EohSetFootSoundId(0, 16)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "デフォルト顔")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	event.EohSetPos(1, -85.0, -38.13, 1157.0)
	event.EohSetRot(1, 0.0, 3.14, 0.0)
	event.EohSetMotion(1, "立ち", 4)
	event.EohSetFootSoundId(1, 16)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "デフォルト顔")
	event.EohSetTexAnim(1, 1, "通常目パチ")
	event.EohSetPos(2, -78.11, -15.13, 426.88)
	event.EohSetRot(2, 0.0, 0.0, 0.0)
	event.EohSetMotion(2, "威嚇", 4)
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "赤目パチ")
	event.EohSetShow(5, 0)
	event.EohSetShow(6, 0)
	do
		local out1, out2, out3 = event.EohGetRot(3)
		rot_x = out1 or rot_x
		rot_y = out2 or rot_y
		var4 = out3 or var4
	end
	do
		local out1, out2, out3 = event.CopyVector(rot_x, rot_y, var4)
		vector_x = out1 or vector_x
		vector_y = out2 or vector_y
		vector_z = out3 or vector_z
	end
	do
		local out1, out2, out3 = event.EohGetPos(4)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	var4 = vm.f32(vector_z - vm.f32(3.1415927))
	var4 = event.AngleLimit(var4) or var4
	event.InitDramaScene()
	event.CmrsInit()
	event.CmrsSetPos(-228.84, 94.46, 882.3)
	event.CmrsSetRef(-94.17, 38.37, 1068.72)
	event.ObjsRotation2(3, rot_x, rot_y, var4, 40, 0, 0.5)
	event.ObjsPosDelay(4, 80)
	event.ObjsMove2(4, pos_x, pos_y + 80.0, pos_z, 32, 1, 0.5)
	event.ObjsPosDelay(0, 100)
	event.ObjsMove(0, -65.0, -16.86, 1002.55, 40)
	event.ObjsMotionDelay(0, 100)
	event.ObjsSetMotion(0, "走り")
	event.ObjsMotionDelay(0, 40)
	event.ObjsSetMotion(0, "立ち")
	event.ObjsPosDelay(1, 110)
	event.ObjsMove(1, -85.0, -16.86, 1002.55, 40)
	event.ObjsMotionDelay(1, 110)
	event.ObjsSetMotion(1, "走り")
	event.ObjsMotionDelay(1, 40)
	event.ObjsSetMotion(1, "立ち")
	event.SetFadeIn(30)
	helper_f92564d3(30)
	if vm.skipping() then
		return skip(2)
	end
	event.SndSePlay(var0, 0)
	helper_39d75add(1)
	if vm.skipping() then
		return skip(3)
	end
	helper_f92564d3(6)
	if vm.skipping() then
		return skip(4)
	end
	event.CmrsSetPos(-70.27, 35.0, 783.66)
	event.CmrsSetRef(-73.25, 38.33, 674.48)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "デフォルト顔")
	event.EohSetTexAnim(0, 1, "こまり目パチ")
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "おこり顔")
	event.EohSetTexAnim(1, 1, "おこり目パチ")
	event.SndSePlay(var0, 1)
	event.ObjsSetPos(0, -50.18, 3.08, 671.54)
	event.ObjsSetRot(0, 0.0, -2.9, 0)
	event.ObjsResetDaPosition(0)
	event.ObjsSetPos(1, -96.49, 3.79, 674.91)
	event.ObjsSetRot(1, 0.0, 2.78, 0.0)
	event.ObjsResetDaPosition(1)
	helper_5fe8(4100010)
	if vm.skipping() then
		return skip(5)
	end
	helper_5fe8(4100020)
	if vm.skipping() then
		return skip(6)
	end
	helper_5fe8(4100030)
	if vm.skipping() then
		return skip(7)
	end
	event.ObjsSetMotion(1, "歩き")
	event.ObjsMotionDelay(1, 60)
	event.ObjsSetMotion(1, "立ち")
	event.ObjsMove(1, -73.19, 2.27, 776.78, 60, 1)
	event.ObjsRotation(1, 0.0, 0.26, 0.0, 10)
	helper_f92564d3(10)
	if vm.skipping() then
		return skip(8)
	end
	event.ObjsSetMotion(0, "歩き")
	event.ObjsMotionDelay(0, 50)
	event.ObjsSetMotion(0, "立ち")
	event.ObjsMove(0, -63.51, 2.44, 748.06, 50, 1)
	event.ObjsRotation(0, 0.0, -0.14, 0.0, 10)
	helper_f92564d3(20)
	if vm.skipping() then
		return skip(9)
	end
	event.SetFadeOut(30)
	helper_f92564d3(30)
	if vm.skipping() then
		return skip(10)
	end
	return part2()
end

--- Helper function.
local function helper_105d8()
	local var0: s32 = 0
	local rot_x: f32 = 0
	local rot_y: f32 = 0
	local var3: f32 = 0
	local vector_x: f32 = 0
	local vector_y: f32 = 0
	local vector_z: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 7 then
			if at <= 1 then
				var3 = vm.f32(vector_z - vm.f32(3.1415927))
				helper_39d75add(1)
			end
			if at <= 2 then
				helper_f92564d3(20)
			end
			if at <= 3 then
				helper_39d75add(3)
			end
			if at <= 4 then
				helper_39d75add(0)
			end
			if at <= 5 then
				helper_39d75add(3)
			end
			if at <= 6 then
				helper_39d75add(1)
			end
			if vm.skip_end() then
				return skip(8)
			end
			return part2()
		end
		helper_34213fb6(-75.0, -10.0, 950.0, vm.f32(3.1415927))
	end
	function part2()
		event.CancelDramaScene()
		event.SndSeStop(var0, 1)
		if vm.wait() then
			return skip(9)
		end
		event.EohSetRot(1, vector_x, vector_y, vector_z)
		event.EohSetPos(3, pos_x, pos_y, pos_z)
		event.EohSetShow(4, 1)
		event.EohSetShow(5, 1)
		helper_34213fb6(-75.0, -10.0, 950.0, vm.f32(3.1415927))
		event.SetCameraPos(-75.0, 50.0, 1030.0)
		event.SetCameraRef(-75.0, 20.0, 950.0)
		event.ResetCamera(0)
		event.SetCrossfade(30)
		event.Finish()
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	var0 = event.SndLoadSound(8, "snd2/sp/sp_033.sound.json") or var0
	event.CharaActive(0)
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.EohSyncObj(1, "p06_s19", "s19_09-m1")
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.EohSyncObj(3, "p06_s19", "s19_10-m1")
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.EohSyncChara(4, 1)
	event.EohSyncChara(5, 2)
	event.EohSetShow(4, 0)
	event.EohSetShow(5, 0)
	event.EohSetPos(0, -75.0, -35.0, 1200.0)
	event.EohSetRot(0, 0.0, 3.1415927, 0.0)
	event.EohSetMotion(0, "立ち", 4)
	event.EohResetDaPosition(0)
	event.EohSetFootSoundId(0, 7)
	event.CmrsInit()
	event.CmrsSetPos(-127.01131, -7.1499996, 911.04)
	event.CmrsSetRef(-62.911304, 39.29, 1129.9199)
	event.CmrsFadeInit()
	event.InitDramaScene()
	event.SetFadeIn(30)
	event.SndSePlay(var0, 1)
	do
		local out1, out2, out3 = event.EohGetRot(1)
		rot_x = out1 or rot_x
		rot_y = out2 or rot_y
		var3 = out3 or var3
	end
	do
		local out1, out2, out3 = event.CopyVector(rot_x, rot_y, var3)
		vector_x = out1 or vector_x
		vector_y = out2 or vector_y
		vector_z = out3 or vector_z
	end
	do
		local out1, out2, out3 = event.EohGetPos(3)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	var3 = vm.f32(vector_z - vm.f32(3.1415927))
	var3 = event.AngleLimit(var3) or var3
	event.ObjsRotation2(1, rot_x, rot_y, var3, 40, 0, 0.5)
	helper_39d75add(1)
	if vm.skipping() then
		return skip(2)
	end
	event.ObjsMove2(3, pos_x, pos_y + 80.0, pos_z, 32, 1, 0.5)
	helper_f92564d3(20)
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsSetMotion(0, "走り")
	event.ObjsMove(0, -75.0, -35.0, 1055.0, 30)
	event.EohSetFootSoundId(0, 16)
	helper_39d75add(3)
	if vm.skipping() then
		return skip(4)
	end
	event.ObjsMove2(3, pos_x, pos_y, pos_z, 32, 0, 0.5)
	helper_39d75add(0)
	if vm.skipping() then
		return skip(5)
	end
	event.ObjsSetMotion(0, "立ち")
	event.ObjsMotionDelay(0, 30)
	event.ObjsPosDelay(0, 30)
	event.ObjsSetMotion(0, "歩き")
	event.ObjsMove(0, -75.0, -25.0, 1015.0, 40)
	event.ObjsMotionDelay(0, 40)
	event.ObjsSetMotion(0, "立ち")
	helper_39d75add(3)
	if vm.skipping() then
		return skip(6)
	end
	event.EohSetFootSoundId(0, 0)
	event.ObjsRotation2(1, vector_x, vector_y, vector_z, 40, 0, 0.5)
	helper_39d75add(1)
	if vm.skipping() then
		return skip(7)
	end
	return part2()
end

--- Helper function.
local function helper_d3c(arg0: s32)
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
local function helper_f40(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			local _ = helper_d3c(arg0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	while true do
		if helper_d3c(arg0) ~= 0 then
			break
		else
			if vm.wait() then
				return skip(2)
			end
		end
	end
end

--- Helper function.
local function helper_1ee30()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local var2: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 24 then
			if at <= 1 then
				var2 = helper_12f4(1)
			end
			if at <= 2 then
				helper_f92564d3(vm.i32(10 - var2))
			end
			if at <= 3 then
				helper_f92564d3(vm.i32(30 - var2))
			end
			if at <= 4 then
				helper_39d75add(3)
			end
			if at <= 5 then
				helper_f92564d3(80)
			end
			if at <= 6 then
				helper_5fe8(4200020)
			end
			if at <= 7 then
				helper_39d75add(2)
			end
			if at <= 8 then
				helper_f92564d3(60)
			end
			if at <= 9 then
				helper_39d75add(3)
			end
			if at <= 10 then
				helper_f92564d3(25)
			end
			if at <= 11 then
				helper_5fe8(4200030)
			end
			if at <= 12 then
				helper_5fe8(4200040)
			end
			if at <= 13 then
				helper_39d75add(2)
			end
			if at <= 14 then
				helper_5fe8(4200050)
			end
			if at <= 15 then
				helper_5fe8(4200060)
			end
			if at <= 16 then
				helper_f92564d3(8)
			end
			if at <= 17 then
				helper_f92564d3(30)
			end
			if at <= 18 then
				helper_39d75add(1)
			end
			if at <= 19 then
				helper_5fe8(4200070)
			end
			if at <= 20 then
				helper_5fe8(4200080)
			end
			if at <= 21 then
				helper_5fe8(4200090)
			end
			if at <= 22 then
				helper_5fe8(4200100)
			end
			if at <= 23 then
				helper_f92564d3(30)
			end
			if vm.skip_end() then
				return skip(25)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.FuncPointShow("", "e420_lg", 0)
		event.SndSeStop(var0, 4)
		event.SetStatus(1, 0, 256, 0)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.EohSetMotion(0, "立ち", 4)
		event.EohSetMotion(1, "立ち", 4)
		event.DelExtMotion(0)
		event.DeleteChara(8)
		event.DeleteChara(9)
		event.DeleteChara(10)
		event.DeleteChara(11)
		event.DeleteChara(12)
		event.DeleteChara(13)
		event.LoadMes(0, -1)
		event.SetStatusbarShow(1, 1.0)
		event.EohSetShow(4, 1)
		event.EohSetShow(5, 1)
		event.Finish()
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFlag(420, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.SetStatusbarShow(0, 1.0)
	event.StopBgm(0)
	event.LoadSound(4811)
	var0 = event.SndLoadSound(4811) or var0
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.SetStatus(1, 0, 256, 1)
	event.ChangeDir("event/e400/e420/")
	event.LoadMes(0, 5, "e420.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e420_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e420_monica.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.LoadChara(5, "e420_paw.gltf", "info", 10)
	event.CharaActive(10)
	event.EohSyncChara(2, 10)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.LoadChara(5, "e420_shigu.gltf", "info", 11)
	event.CharaActive(11)
	event.EohSyncChara(3, 11)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.LoadChara(5, "mariometto_a.gltf", "info", 12)
	event.CharaActive(12)
	event.SetReference(11, "metto_null", 12)
	event.EohSyncChara(6, 12)
	event.ObjsInit(6)
	event.ObjsSyncObj(6, 6)
	event.LoadChara(5, "e420_kanden.gltf", "info", 13)
	event.CharaActive(0, 13)
	event.ChangeDir("")
	if active_chr_no == 1 then
		event.LoadChara(5, "chara/c01_base.gltf", "info", 8)
		event.LoadEquip(5, 0, 4, "info", 8)
		event.LoadEquip(5, 0, 3, "info", 8)
		event.LoadEquip(5, 0, 2, "info", 8, 9)
		event.LoadMotion(5, "event/e400/e420/e420_mints.gltf", "info", 8)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 8)
		event.EohSyncChara(0, 8)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 0)
	else
		event.LoadChara(5, "chara/c02_base.gltf", "info", 8)
		event.LoadEquip(5, 1, 4, "info", 8)
		event.LoadEquip(5, 1, 3, "info", 8)
		event.LoadEquip(5, 1, 2, "info", 8, 9)
		event.LoadMotion(5, "event/e400/e420/e420_monica.gltf", "info", 8)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 8)
		event.EohSyncChara(1, 8)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 0)
	end
	event.CharaActive(8)
	event.CharaActive(9)
	event.EohSyncChara(4, 1)
	event.EohSyncChara(5, 2)
	event.EohSetPos(0, -50.18, 3.08, 671.54)
	event.EohSetRot(0, 0.0, -2.9, 0.0)
	event.EohSetMotion(0, "上向くL", 4)
	event.EohSetFootSoundId(0, 16)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "無表情")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	event.EohSetPos(1, -96.49, 3.79, 674.91)
	event.EohSetRot(1, 0.0, 2.78, 0.0)
	event.EohSetMotion(1, "上向くL", 4)
	event.EohSetFootSoundId(1, 16)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "無表情")
	event.EohSetTexAnim(1, 1, "通常目パチ")
	event.EohSetPos(2, -72.89, 2.34, 770.75)
	event.EohSetRot(2, 0.0, -3.02, 0.0)
	event.EohSetMotion(2, "立ち", 4)
	event.EohSetFootSoundId(2, 16)
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "おこり目パチ")
	event.EohSetPos(3, -78.16, -9.08, 455.31)
	event.EohSetRot(3, 0.0, 0.0, 0.0)
	event.EohSetMotion(3, "立ち2", 4)
	event.EohSetTexAnim(3, 0)
	event.EohSetTexAnim(3, 1, "赤目パチ")
	event.SetCharaPos(13, -78.16, -9.08, 455.31)
	event.SetCharaRot(13, 0.0, 0.0, 0.0)
	event.EohSetShow(4, 0)
	event.EohSetShow(5, 0)
	event.InitDramaScene()
	event.CmrsSetPos(-91.15, 8.06, 663.16)
	event.CmrsSetRef(-79.05, 47.63, 524.91)
	event.ObjsSetMotion(3, "感電", 6)
	event.ObjsNextMotion(3, "感電L", 4)
	event.SetFadeIn(30)
	event.SetMesOkuri(0, 0)
	event.StreamOpen3(1, 4200010)
	var2 = helper_12f4(1)
	if vm.skipping() then
		return skip(2)
	end
	helper_f92564d3(vm.i32(10 - var2))
	if vm.skipping() then
		return skip(3)
	end
	event.StreamPlay(1)
	helper_f92564d3(vm.i32(30 - var2))
	if vm.skipping() then
		return skip(4)
	end
	helper_39d75add(3)
	if vm.skipping() then
		return skip(5)
	end
	event.FuncPointShow("", "e420_lg", 1)
	event.SndSePlay(var0, 4)
	event.CharaActive(1, 13)
	helper_f92564d3(80)
	if vm.skipping() then
		return skip(6)
	end
	event.CharaActive(0, 13)
	event.StreamClose(1)
	event.SetMesOkuri(0, 1)
	event.FuncPointShow("", "e420_lg", 0)
	event.CmrsSetPos(-39.38, 84.75, 556.88)
	event.CmrsSetRef(-82.55, -1.03, 671.45)
	event.ObjsMove(2, -72.44, 3.87, 634.26, 40, 1)
	event.ObjsSetMotion(2, "上見走り", 4)
	event.ObjsMotionDelay(2, 40)
	event.ObjsSetMotion(2, "上見立ち")
	helper_5fe8(4200020)
	if vm.skipping() then
		return skip(7)
	end
	helper_39d75add(2)
	if vm.skipping() then
		return skip(8)
	end
	event.CmrsSetPos(-81.13, -20.11, 556.35)
	event.CmrsSetRef(-83.71, 9.43, 543.03)
	event.SndSeStop(var0, 4)
	event.EohSetTexAnim(3, 0)
	event.EohSetTexAnim(3, 1, "赤目～赤目とじ")
	event.ObjsSetMotion(3, "メット落ちる", 6)
	event.ObjsNextMotion(3, "倒れる", 6)
	event.ObjsMotionWait(3)
	event.ObjsSeDelay(3, 60)
	event.ObjsSePlay(3, var0, 6)
	event.ObjsMove2(6, -75.71, -140.18, 221.57, 30, 1, 1.0)
	event.ObjsRotation2(6, 0.0, 0.0, 1.8, 30, 0, 1.0)
	event.ObjsSeDelay(6, 50)
	event.ObjsSePlay(6, var0, 5)
	event.ObjsSetMotion(0, "立ち", 4)
	event.ObjsSetMotion(1, "立ち", 4)
	event.ObjsSetMotion(2, "立ち", 4)
	helper_f92564d3(60)
	if vm.skipping() then
		return skip(9)
	end
	event.CharaActive(0, 12)
	helper_39d75add(3)
	if vm.skipping() then
		return skip(10)
	end
	event.CmrsSetPos(-266.34, 202.78, 745.86)
	event.CmrsSetRef(-86.65, 17.8, 537.9)
	event.CmrsSetPos(-77.85, 7.32, 623.69)
	event.CmrsSetRef(-79.23, 12.59, 599.39)
	event.CmrsQuake(0.0, 2.0, 0.0, 25)
	helper_f92564d3(25)
	if vm.skipping() then
		return skip(11)
	end
	event.EohSetTexAnim(3, 0)
	event.EohSetTexAnim(3, 1, "苦痛目とじ")
	event.ObjsSetMotion(3, "ぐったり", 6)
	event.CmrsSetPos(-266.34, 202.78, 745.86)
	event.CmrsSetRef(-86.65, 17.8, 537.9)
	helper_5fe8(4200030)
	if vm.skipping() then
		return skip(12)
	end
	event.ObjsMove(2, -49.93, 4.12, 578.82, 30, 1)
	event.ObjsRotation(2, 0.0, 2.78, 0.0, 10)
	event.ObjsSetMotion(2, "走り")
	event.ObjsMotionDelay(2, 30)
	event.ObjsSetMotion(2, "立ち")
	helper_5fe8(4200040)
	if vm.skipping() then
		return skip(13)
	end
	helper_39d75add(2)
	if vm.skipping() then
		return skip(14)
	end
	event.CmrsInit()
	event.CmrsSetPos(-126.48, 23.27, 645.95)
	event.CmrsSetRef(-48.09, 21.64, 692.16)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "デフォルト顔")
	event.EohSetTexAnim(1, 1, "通常目パチ")
	event.SetPakuAnim(1, "わらい口パク")
	helper_5fe8(4200050)
	if vm.skipping() then
		return skip(15)
	end
	event.SetPakuAnim(0, "通常口パク")
	helper_5fe8(4200060)
	if vm.skipping() then
		return skip(16)
	end
	event.ObjsMove(0, -73.29, 4.2, 606.39, 40, 1)
	event.ObjsRotDelay(0, 30)
	event.ObjsRotation(0, 0.0, 2.9, 0.0, 10)
	event.ObjsSetMotion(0, "走り")
	event.ObjsMotionDelay(0, 40)
	event.ObjsSetMotion(0, "立ち")
	helper_f92564d3(8)
	if vm.skipping() then
		return skip(17)
	end
	event.ObjsMove(1, -89.41, 4.65, 588.63, 40, 1)
	event.ObjsRotDelay(1, 30)
	event.ObjsRotation(1, 0.0, 2.18, 0.0, 10)
	event.ObjsSetMotion(1, "走り")
	event.ObjsMotionDelay(1, 40)
	event.ObjsSetMotion(1, "立ち")
	helper_f92564d3(30)
	if vm.skipping() then
		return skip(18)
	end
	event.CmrsSetPos(-23.86, 87.25, 654.66)
	event.CmrsSetRef(-59.69, 21.64, 584.77)
	event.EohSetTexAnim(3, 0)
	event.EohSetTexAnim(3, 1, "半目パチ")
	helper_39d75add(1)
	if vm.skipping() then
		return skip(19)
	end
	helper_5fe8(4200070)
	if vm.skipping() then
		return skip(20)
	end
	helper_5fe8(4200080)
	if vm.skipping() then
		return skip(21)
	end
	helper_5fe8(4200090)
	if vm.skipping() then
		return skip(22)
	end
	event.ObjsSetMotion(1, "会話", 2)
	event.ObjsNextMotion(1, "立ち", 4)
	helper_5fe8(4200100)
	if vm.skipping() then
		return skip(23)
	end
	event.SetFadeOut(30)
	helper_f92564d3(30)
	if vm.skipping() then
		return skip(24)
	end
	return part2()
end

--- Helper function.
local function helper_7d1c(arg0: any, arg1: s32, arg2: s32)
	local var3: s32 = 0
	local var4: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var4 = 0
			var3 = helper_b1312a3f(arg0, arg1)
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
		var3 = helper_b1312a3f(arg0, arg1)
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
local function helper_87e4(arg0: s32, arg1: s32, arg2: s32, arg3: s32, arg4: s32)
	local var6: s32 = 0
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			local _ = helper_dbbdb6d9(arg0, arg1, arg2, arg3, arg4)
			_, var6 = helper_7d1c(arg0, 0, var6)
		end
		helper_581fd7f7(arg0)
	end
	if vm.skipping() then
		return skip(1)
	end
	local _ = helper_dbbdb6d9(arg0, arg1, arg2, arg3, arg4)
	_, var6 = helper_7d1c(arg0, 0, var6)
	if vm.skipping() then
		return skip(2)
	end
	helper_581fd7f7(arg0)
end

--- Helper function.
local function helper_6d3c(arg0: s32)
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
local function helper_6a7c(arg0: s32)
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
local function helper_6e94(arg0: s32, arg1: any, arg2: any, arg3: s32)
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
				helper_6d3c(arg0)
			end
			if at <= 2 then
				var8 = 0
				var7 = helper_6a7c(arg0)
				var8 = -1
				var8 = 1
				var6 = var7
				var8 = -1
				var8 = 1
				var8 = -1
				var8 = 1
			end
			helper_581fd7f7(arg0)
			return -1
		end
		helper_581fd7f7(arg0)
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
	helper_6d3c(arg0)
	if vm.skipping() then
		return skip(2)
	end
	while true do
		var8 = 0
		var7 = helper_6a7c(arg0)
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
					helper_581fd7f7(arg0)
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
	helper_581fd7f7(arg0)
	return arg2
end

--- Helper function.
local function helper_7bac(arg0: s32, arg1: any, arg2: s32, arg3: s32, arg4: s32, arg5: s32, arg6: s32)
	local var8: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		return var8
	end
	local _ = helper_dbbdb6d9(arg0, arg1, arg2, arg3, arg4)
	var8 = helper_6e94(arg0, arg5, arg6, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPos(arg0, 0)
	return var8
end

--- Helper function.
local function helper_11850(arg0: s32)
	local var1: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_f92564d3(30)
		end
		return 1
	end
	event.Initialize()
	event.SetMotion(0, "立ち")
	event.SetMesQuestionGyou(0, 0)
	event.SetMesWindowMode(0, 5)
	event.SetMesDrawspeed(0, 1)
	if arg0 == 1 then
		event.MesMake_2(0, "次のフロアへ進みますか？")
	else
		event.MesMake_2(0, "前のフロアへ戻りますか？")
	end
	var1 = helper_7bac(0, -1, 8, 256, 208, 2, 1)
	if vm.skipping() then
		return skip(1)
	end
	if var1 == 0 then
		event.SetFadeOut(30)
		helper_f92564d3(30)
		if vm.skipping() then
			return skip(2)
		end
		return 1
	else
		event.Finish()
		return 0
	end
end

--- Helper function.
local function helper_24100()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_f92564d3(30)
		end
		if at <= 2 then
			helper_39d75add(0)
		end
	end
	event.ActchrSetDefMotion(0, 4)
	event.SetFadeOut(30)
	helper_f92564d3(30)
	if vm.skipping() then
		return skip(1)
	end
	event.DngPause(1, 1)
	event.DelMonster(-1)
	helper_f92564d3(30)
	if vm.skipping() then
		return skip(2)
	end
	event.Initialize()
	var0 = event.SndLoadSound(5, "snd2/mon/en_360.sound.json") or var0
	event.AssignStack(5)
	event.ClearStack(5)
	event.SetStatusbarShow(0, 1.0)
	event.LoadChara(5, "dungeon/monster/b07a.gltf", "b07a", 8)
	event.CharaActive(1, 8)
	event.EohSyncChara(0, 8)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.SetFadeIn(15)
	event.SetCameraPos(-50.62, 42.66, 812.75)
	event.SetCameraRef(-50.82, 71.75, 656.03)
	event.CharaActive(0, 0)
	event.SndSePlay(var0, 24)
	event.ObjsSetPos(0, -50.62, 4.34, 553.77)
	event.ObjsSetRot(0, 0.0, 0.02, 0.0)
	event.ObjsSetMotion(0, "死に", 6)
	event.ObjsMotionWait(0)
	helper_39d75add(0)
	if vm.skipping() then
		return skip(3)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no ~= 2 then
		event.SetCameraPos(-21.21, 14.5, 728.16)
		event.SetCameraRef(-33.94, 17.9, 751.25)
	else
		event.SetCameraPos(8.06, 23.77, 675.07)
		event.SetCameraRef(-39.51, 29.49, 761.36)
	end
	event.CharaActive(1, 0)
	event.SetCharaPos(0, -40.07, 1.76, 766.47)
	event.SetCharaRot(0, 0.0, -3.12, 0.0)
	event.SetMotion(0, "立ち", 4)
	event.DeleteChara(8)
	event.Finish()
end

--- Helper function.
local function helper_ccdc(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_8b35005d(1, 4)
			helper_87e4(1, vm.i32(60 + arg0), 8, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(1, 4)
	helper_8b35005d(1, 4)
	helper_87e4(1, vm.i32(60 + arg0), 8, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_e1e8(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local boss_map: s32 = 0
	local var4: s32 = 0
	local argc: s32 = 0
	local battle_bgm_vol: s32 = 0
	local active_chr_no: s32 = 0
	local var8: s32 = 0
	local block: s32 = 0
	local var10: s32 = 0
	local debug_flag: s32 = 0
	local load_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 16 then
			if at <= 1 then
				print("---------------------------------------------BATTLE BGM STOP\n")
				var8 = 0
				helper_f92564d3(30)
			end
			if at <= 2 then
				helper_e697ec97()
			end
			if at <= 3 then
				helper_f92564d3(30)
			end
			if at <= 4 then
				helper_6098(arg1, -1)
			end
			if at <= 5 then
				helper_f92564d3(10)
			end
			if at <= 6 then
				helper_f92564d3(30)
			end
			if at <= 7 then
				helper_f92564d3(120)
			end
			if at <= 8 then
				local _ = helper_2aeee3a7(0)
			end
			if at <= 9 then
				helper_ccdc(1)
			end
			if at <= 10 then
				helper_ccdc(4)
			end
			if at <= 11 then
				helper_ccdc(active_chr_no)
			end
			if at <= 12 then
				helper_ccdc(1)
			end
			if at <= 13 then
				helper_f92564d3(30)
			end
			if at <= 15 then
				helper_f92564d3(30)
			end
			return 1
		end
		print("---------------------------------------------DEAD RELOAD_BGM = ", load_no, "\n")
		print("---------------------------------------------BOSS BATTLE = ", boss_map, "\n")
		print("---------------------------------------------PAUSE BATTLE BGM = ", var2, "\n")
		print("---------------------------------------------BATTLE BGM PLAY\n")
		return 0
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	event.AssignStack(5)
	event.ClearStack(5)
	var2 = event.DngCheckPause(16384) or var2
	if var2 ~= 16384 then
		event.DngPause(16384, 1)
	end
	boss_map = event.DngCheckBossMap() or boss_map
	event.GetActiveBgmStatus(-1)
	if var2 ~= 16384 and boss_map ~= 1 then
		var4 = event.GetEventInfoSndid(4) or var4
		argc = event.GetSeStatus(var4, 0) or argc
		battle_bgm_vol = event.GetBtlBgmVol() or battle_bgm_vol
		event.SndSeStop(var4, 0)
		print("---------------------------------------------BATTLE BGM STOP\n")
	end
	event.StopBgm(0)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 or active_chr_no == 1 then
		event.SetTexAnim(0, 0, "目パチ")
		event.SetTexAnim(0, 1, "死に")
	end
	if active_chr_no == 2 then
		event.ActchrSetMotion(0, "故障", 6)
		event.EsmInitialize(5, 1)
		event.EsmLoadBase("ロボ故障")
		event.EsmInitFix(5)
		event.EsmCreate("ロボ故障")
	end
	var8 = 0
	if active_chr_no == 2 then
		var8 = event.CheckEnableCharaChange(0) or var8
		if var8 == 0 then
			var8 = event.CheckEnableCharaChange(1) or var8
		end
	end
	if active_chr_no == 0 then
		var8 = event.CheckEnableCharaChange(1) or var8
	end
	if active_chr_no == 1 then
		var8 = event.CheckEnableCharaChange(0) or var8
	end
	if active_chr_no == 3 then
		var8 = event.CheckEnableCharaChange(1) or var8
		if var8 == 0 then
			var8 = event.CheckEnableCharaChange(0) or var8
		end
	end
	event.SetLoadbgFile("snd2/bgm/bg_060.sound.json", "textures/dungeon/image/gameover.json")
	helper_f92564d3(30)
	if vm.skipping() then
		return skip(2)
	end
	event.SetStatusbarShow(0, 0.06666667)
	helper_e697ec97()
	if vm.skipping() then
		return skip(3)
	end
	event.LoadBgmPack(60)
	if var8 == 1 or var8 ~= 1 and arg1 < 0 then
		event.PlayBgm(0)
	end
	helper_f92564d3(30)
	if vm.skipping() then
		return skip(4)
	end
	event.DngPause(1, 1)
	event.DngCollisionAllClr()
	if var8 ~= 1 then
		block = event.LoadImg_4(5, "textures/dungeon/image/gameover.json", 1) or block
		if arg1 >= 0 then
			helper_6098(arg1, -1)
			if vm.skipping() then
				return skip(5)
			end
			helper_f92564d3(10)
			if vm.skipping() then
				return skip(6)
			end
			event.PlayBgm(0)
		end
		event.SpriteInit(0)
		event.SpriteSetType(0, 0)
		event.SpriteSetTexture(0, "gameover1", block)
		event.SpriteSetColor(0, 128, 128, 128, 128)
		event.SpriteSetUvsize(0, 0, 0, 576, 128)
		event.SpriteSetPutsize(0, 576, 128)
		event.SpriteSetPos(0, -320, 208)
		event.SpriteSetDraw(0, 1)
		event.EohSyncSprite(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.ObjsMove(0, 288, 208, 0.0, 20)
		helper_f92564d3(30)
		if vm.skipping() then
			return skip(7)
		end
		event.SpriteInit(1)
		event.SpriteSetType(1, 0)
		event.SpriteSetTexture(1, "gameover1", block)
		event.SpriteSetColor(1, 128, 128, 128, 0)
		event.SpriteSetUvsize(1, 0, 128, 576, 64)
		event.SpriteSetPutsize(1, 576, 64)
		event.SpriteSetPos(1, 256, 208)
		event.SpriteSetDraw(1, 1)
		event.EohSyncSprite(1, 1)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.ObjsSetColor(1, 128, 128, 128, 128, 120)
		helper_f92564d3(120)
		if vm.skipping() then
			return skip(8)
		end
		while true do
			if helper_2aeee3a7(0) ~= 0 then
				break
			end
			if vm.wait() then
				return skip(9)
			end
		end
	elseif active_chr_no == 3 then
		var10 = event.CheckEnableCharaChange(1) or var10
		if var10 == 0 then
			helper_ccdc(1)
			if vm.skipping() then
				return skip(10)
			end
		else
			helper_ccdc(4)
			if vm.skipping() then
				return skip(11)
			end
		end
	elseif active_chr_no == 0 or active_chr_no == 2 then
		helper_ccdc(active_chr_no)
		if vm.skipping() then
			return skip(12)
		end
	else
		helper_ccdc(1)
		if vm.skipping() then
			return skip(13)
		end
	end
	debug_flag = event.GetDebugFlag() or debug_flag
	if debug_flag == 1 then
		event.DngDebugCommand(0)
		event.AddWhp(0, 999)
		event.AddWhp(1, 999)
		if active_chr_no == 2 then
			event.EsmClear()
		end
		if active_chr_no == 0 or active_chr_no == 1 then
			event.SetTexAnim(0, 0, "死に")
			event.SetTexAnim(0, 1, "目パチ")
		end
		event.ActchrSetDefMotion(0, 4)
	elseif var8 == 1 then
		event.SetFadeOut(30)
		helper_f92564d3(30)
		if vm.skipping() then
			return skip(14)
		end
		if active_chr_no == 2 then
			event.EsmClear()
		end
		event.MenuCharaChenge(-1)
		if vm.wait() then
			return skip(15)
		end
		event.SetFadeOut(0)
	else
		event.FadeOutBgm(30)
		event.SetFadeOut(30)
		helper_f92564d3(30)
		if vm.skipping() then
			return skip(16)
		end
		if active_chr_no == 2 then
			event.EsmClear()
		end
		event.StopBgm(0)
		event.SpriteSetDraw(0, 0)
		event.SpriteSetDraw(1, 0)
		event.DelImg(1)
		if arg0 == 1 then
			event.AddHpRate(1.0, 0)
			event.AddWhp(0, 999)
			event.AddWhp(1, 999)
			event.DngRunEvent(-1)
			event.DelMonster(-1)
			event.DngPause(1, 0)
			event.Finish()
			return 1
		else
			event.SetExitFlag(1)
			event.Finish()
			return 0
		end
	end
	event.StopBgm(0)
	helper_f92564d3(4)
	if vm.skipping() then
		return skip(17)
	end
	load_no = event.GetBgmStatusNowNo() or load_no
	event.LoadBgm(load_no)
	print("---------------------------------------------DEAD RELOAD_BGM = ", load_no, "\n")
	print("---------------------------------------------BOSS BATTLE = ", boss_map, "\n")
	print("---------------------------------------------PAUSE BATTLE BGM = ", var2, "\n")
	event.SetActiveBgmStatus(-1)
	event.SpriteSetDraw(0, 0)
	event.SpriteSetDraw(1, 0)
	event.DelImg(1)
	if var2 ~= 16384 and boss_map ~= 1 then
		if argc == 1 then
			print("---------------------------------------------BATTLE BGM PLAY\n")
			event.SndSePlay(var4, 0)
			event.SndSetSeVol(var4, 0, battle_bgm_vol)
		end
	end
	event.SetCameraCtrl(1)
	event.SetStatusbarShow(1, 1.0)
	if debug_flag ~= 1 then
		event.SetFadeIn(10)
	end
	if var2 ~= 16384 then
		event.DngPause(16385, 0)
	else
		event.DngPause(1, 0)
	end
	event.Finish()
	return 0
end

--- Helper function.
local function helper_1054c(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		return helper_e1e8(arg0, arg1)
	end
	if vm.skipping() then
		return skip(1)
	end
	return helper_e1e8(arg0, arg1)
end

--- Helper function.
local function helper_104b4(arg0: s32)
	return helper_e1e8(arg0, -1)
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

script[99] = program_99

--- Program 100.
script[100] = function()
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	local landing1: () -> ...any
	local landing2: () -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_11c1c()
				if not vm.skipping() then
					return landing1()
				end
			end
			return
		end
		if at <= 4 then
			if at <= 3 then
				helper_1bfac()
				if not vm.skipping() then
					return landing2()
				end
			end
			return
		end
		if at <= 6 then
			if at <= 5 then
				helper_f92564d3(6)
			end
			return
		end
		if at <= 7 then
			helper_105d8()
			if not vm.skipping() then
				return part2()
			end
		end
	end
	function part2() end
	function landing1()
		event.GotoEdit(75, 500)
	end
	function landing2()
		event.SetBitCtrl(1, 1)
	end
	program_99()
	if vm.skipping() then
		return skip(1)
	end
	flag = event.GetFlag(400) or flag
	flag_2 = event.GetFlag(408) or flag_2
	flag_3 = event.GetFlag(420) or flag_3
	if flag == 1 then
		if flag_2 == 0 then
			helper_11c1c()
			if vm.skipping() then
				return skip(2)
			end
			event.GotoEdit(75, 500)
			return
		end
		if flag_3 == 0 then
			var3 = event.GetSavedataEtc(2) or var3
			if var3 ~= 0 then
				helper_225a4(1)
				if vm.skipping() then
					return skip(3)
				end
				helper_1bfac()
				if vm.skipping() then
					return skip(4)
				end
				event.SetBitCtrl(1, 1)
				return
			else
				helper_199cc()
				if vm.skipping() then
					return skip(5)
				end
				event.SoundAllStop()
				helper_f92564d3(6)
				if vm.skipping() then
					return skip(6)
				end
				event.LoadBgm(18)
				event.LoadSound(4601)
				event.PlayBgm(0)
				event.LoadScript("d04/d04.stb", 1000)
				return
			end
		else
			helper_105d8()
			if vm.skipping() then
				return skip(7)
			end
		end
	else
		helper_105d8()
		if vm.skipping() then
			return skip(8)
		end
	end
	return part2()
end

--- Program 150.
script[150] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_11c1c()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 151.
script[151] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetFadeIn(30)
	event.Initialize()
	if vm.wait() then
		return skip(1)
	end
	event.SetCharaPos(0, -29.1, 1.4, 787.9)
	event.DngPause(17, 0)
	event.LoadMonsterFile(516, 1)
	event.LoadMonsterFile(1001, 0)
	event.AutoSetMonster(516, -50.0, -46.69, 202.57, 0.0, 0.0, 0.0)
	event.GetCharaPos(0)
	event.Finish()
end

--- Program 152.
script[152] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_f40(32)
		end
	end
	if vm.wait() then
		return skip(1)
	end
	helper_f40(32)
	if vm.skipping() then
		return skip(2)
	end
end

--- Program 153.
script[153] = function()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_1ee30()
			if not vm.skipping() then
				return part2()
			end
		end
	end
	function part2() end
	event.DngPause(1, 1)
	event.SetFadeOut(0)
	event.DngPause(16, 1)
	helper_f92564d3(30)
	if vm.skipping() then
		return skip(1)
	end
	event.SetFadeIn(30)
	event.DelMonster(-1)
	helper_1ee30()
	if vm.skipping() then
		return skip(2)
	end
	return part2()
end

--- Program 154.
script[154] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_f40(32)
		end
	end
	event.SetCameraRef(-33.22, 3.88, 763.5)
	if vm.wait() then
		return skip(1)
	end
	helper_f40(32)
	if vm.skipping() then
		return skip(2)
	end
end

--- Program 155.
script[155] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_1bfac()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 160.
script[160] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_f40(32)
		end
	end
	if vm.wait() then
		return skip(1)
	end
	helper_f40(32)
	if vm.skipping() then
		return skip(2)
	end
end

--- Program 200.
script[200] = function()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
		if at <= 3 then
			if at <= 2 then
				helper_87e4(0, 21, 5, 256, 208)
			end
			return
		end
	end
	event.Initialize()
	var0 = event.GetBitCtrl(1) or var0
	if var0 == 1 then
		event.DngPause(9, 1)
		event.ActchrSetDefMotion(0)
		event.SetMesWindowMode(0, 1)
		event.SetMesShippo(0, 0)
		event.MesMake_2(0, "この魚をシグーに食べさせないと！！")
		helper_87e4(0, -1, 5, 0, 0)
		if vm.skipping() then
			return skip(1)
		end
		event.DngPause(9, 0)
		return
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 2 then
		event.SetMotion(0, "立ち")
		event.SetMesWindowMode(0, 1)
		event.SetMesDrawspeed(0, 1)
		if active_chr_no == 2 then
			helper_87e4(0, 20, 5, 256, 208)
			if vm.skipping() then
				return skip(2)
			end
		else
			helper_87e4(0, 21, 5, 256, 208)
			if vm.skipping() then
				return skip(3)
			end
		end
		event.Finish()
		return
	end
	local t0 = helper_11850(0)
	if vm.skipping() then
		return skip(4)
	end
	if t0 ~= 0 then
		event.LoadScript("d04/d04.stb", 1000)
	end
end

--- Program 201.
script[201] = function()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local stage_id: s32 = 0
	local var3: s32 = 0
	local argc: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
		if at <= 3 then
			if at <= 2 then
				helper_87e4(0, 21, 5, 256, 208)
			end
			return
		end
		if at <= 4 then
			helper_f92564d3(6)
		end
	end
	event.Initialize()
	var0 = event.GetBitCtrl(1) or var0
	if var0 == 1 then
		event.DngPause(9, 1)
		event.ActchrSetDefMotion(0)
		event.SetMesWindowMode(0, 1)
		event.SetMesShippo(0, 0)
		event.MesMake_2(0, "この魚をシグーに食べさせないと！！")
		helper_87e4(0, -1, 5, 0, 0)
		if vm.skipping() then
			return skip(1)
		end
		event.DngPause(9, 0)
		return
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 2 then
		event.SetMotion(0, "立ち")
		event.SetMesWindowMode(0, 1)
		event.SetMesDrawspeed(0, 1)
		if active_chr_no == 2 then
			helper_87e4(0, 20, 5, 256, 208)
			if vm.skipping() then
				return skip(2)
			end
		else
			helper_87e4(0, 21, 5, 256, 208)
			if vm.skipping() then
				return skip(3)
			end
		end
		event.Finish()
		return
	end
	local t0 = helper_11850(1)
	if vm.skipping() then
		return skip(4)
	end
	if t0 ~= 0 then
		stage_id = event.DngGetStageId() or stage_id
		var3 = event.DngGetFloorId() or var3
		argc = event.GetNextFloor(var3, 0) or argc
		event.DngSetFloorId(argc)
		event.SetFloorInfo(stage_id, var3, 5, 2)
		event.SetFloorInfo(stage_id, argc, 5, 1)
		event.StopBgm(0)
		event.StopEnvBgm()
		event.SndStopSrc()
		helper_f92564d3(6)
		if vm.skipping() then
			return skip(5)
		end
		event.LoadBgm(18)
		event.LoadSound(4601)
		event.PlayBgm(0)
		event.LoadScript("d04/d04.stb", 1000)
	end
end

--- Program 500.
script[500] = function()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 2 then
			helper_225a4(0)
		end
		if at <= 3 then
			helper_1ee30()
			if not vm.skipping() then
				return part2()
			end
		end
	end
	function part2()
		event.BgmLoadCancel()
		event.GotoEdit(75, 100)
		if vm.wait() then
			return skip(5)
		end
	end
	event.Initialize()
	event.SetFadeOut(0)
	if vm.wait() then
		return skip(1)
	end
	if vm.wait() then
		return skip(2)
	end
	event.DelMonster(-1)
	event.SetSavedataEtc(4)
	event.SetBitCtrl(1, 0)
	helper_225a4(0)
	if vm.skipping() then
		return skip(3)
	end
	helper_1ee30()
	if vm.skipping() then
		return skip(4)
	end
	return part2()
end

--- Program 510.
script[510] = function()
	local var0: s32 = 0
	local var1: s32 = 0
	local argc: s32 = 0
	local battle_bgm_vol: s32 = 0
	local active_chr_no: s32 = 0
	local block: s32 = 0
	local debug_flag: s32 = 0
	local load_no: s32 = 0
	local boss_map: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 9 then
			if at <= 1 then
				var0 = 0
				helper_f92564d3(30)
			end
			if at <= 2 then
				helper_e697ec97()
			end
			if at <= 3 then
				helper_f92564d3(30)
			end
			if at <= 4 then
				helper_87e4(0, -1, 8, 0, 0)
			end
			if at <= 5 then
				helper_f92564d3(30)
			end
			if at <= 6 then
				helper_f92564d3(120)
			end
			if at <= 7 then
				local _ = helper_2aeee3a7(0)
			end
			if at <= 8 then
				debug_flag = 0
				helper_f92564d3(30)
			end
			return 1
		end
		return 0
	end
	helper_24100()
	if vm.skipping() then
		return skip(1)
	end
	event.DngPause(1, 0)
	var0 = 0
	event.Initialize()
	event.AssignStack(5)
	event.ClearStack(5)
	event.DngPause(16384, 1)
	event.GetActiveBgmStatus(-1)
	var1 = event.GetEventInfoSndid(4) or var1
	argc = event.GetSeStatus(var1, 0) or argc
	battle_bgm_vol = event.GetBtlBgmVol() or battle_bgm_vol
	event.SndSeStop(var1, 0)
	event.StopBgm(0)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.SetLoadbgFile("snd2/bgm/bg_060.sound.json", "textures/dungeon/image/gameover.json")
	helper_f92564d3(30)
	if vm.skipping() then
		return skip(2)
	end
	helper_e697ec97()
	if vm.skipping() then
		return skip(3)
	end
	event.LoadBgmPack(60)
	event.PlayBgm(0)
	helper_f92564d3(30)
	if vm.skipping() then
		return skip(4)
	end
	event.DngPause(1, 1)
	event.DngCollisionAllClr()
	event.SetMesWindowMode(0, 8)
	event.MesMake_2(
		0,
		"シグーを殺してしまった・・・\n未来を元に戻すには、シグーの力が\n必要だったのに・・・"
	)
	helper_87e4(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(5)
	end
	block = event.LoadImg_4(5, "textures/dungeon/image/gameover.json", 0) or block
	event.SpriteInit(0)
	event.SpriteSetType(0, 0)
	event.SpriteSetTexture(0, "gameover1", block)
	event.SpriteSetColor(0, 128, 128, 128, 128)
	event.SpriteSetUvsize(0, 0, 0, 576, 128)
	event.SpriteSetPutsize(0, 576, 128)
	event.SpriteSetPos(0, -320, 208)
	event.SpriteSetDraw(0, 1)
	event.EohSyncSprite(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsMove(0, 288, 208, 0.0, 20)
	helper_f92564d3(30)
	if vm.skipping() then
		return skip(6)
	end
	event.SpriteInit(1)
	event.SpriteSetType(1, 0)
	event.SpriteSetTexture(1, "gameover1", block)
	event.SpriteSetColor(1, 128, 128, 128, 0)
	event.SpriteSetUvsize(1, 0, 128, 576, 64)
	event.SpriteSetPutsize(1, 576, 64)
	event.SpriteSetPos(1, 256, 208)
	event.SpriteSetDraw(1, 1)
	event.EohSyncSprite(1, 1)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.ObjsSetColor(1, 128, 128, 128, 128, 120)
	helper_f92564d3(120)
	if vm.skipping() then
		return skip(7)
	end
	while true do
		if helper_2aeee3a7(0) ~= 0 then
			break
		else
			if vm.wait() then
				return skip(8)
			end
		end
	end
	debug_flag = event.GetDebugFlag() or debug_flag
	debug_flag = 0
	if debug_flag == 1 then
		event.DngDebugCommand(0)
		event.ActchrSetDefMotion(0, 4)
	else
		event.FadeOutBgm(30)
		event.SetFadeOut(30)
		helper_f92564d3(30)
		if vm.skipping() then
			return skip(9)
		end
		if active_chr_no == 2 then
			event.EsmClear()
		end
		event.StopBgm(0)
		event.SpriteSetDraw(0, 0)
		event.SpriteSetDraw(1, 0)
		event.DelImg(0)
		if var0 == 1 then
			event.AddHpRate(1.0, 0)
			event.AddWhp(0, 999)
			event.AddWhp(1, 999)
			event.DngRunEvent(-1)
			event.DelMonster(-1)
			event.DngPause(1, 0)
			event.Finish()
			return 1
		else
			event.SetExitFlag(1)
			event.Finish()
			return 0
		end
	end
	event.StopBgm(0)
	helper_f92564d3(4)
	if vm.skipping() then
		return skip(10)
	end
	load_no = event.GetBgmStatusNowNo() or load_no
	event.LoadBgm(load_no)
	event.SetActiveBgmStatus(-1)
	event.SpriteSetDraw(0, 0)
	event.SpriteSetDraw(1, 0)
	event.DelImg(0)
	boss_map = event.DngCheckBossMap() or boss_map
	if boss_map ~= 1 then
		if argc == 1 then
			event.SndSePlay(var1, 0)
			event.SndSetSeVol(var1, 0, battle_bgm_vol)
		end
	end
	event.SetCameraCtrl(1)
	event.SetStatusbarShow(1, 1.0)
	if debug_flag ~= 1 then
		event.SetFadeIn(30)
	end
	event.DngPause(16385, 0)
	event.Finish()
	return 0
end

--- Program 550.
script[550] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	event.SetMotion(0, "だめだめ")
	event.DngPause(3, 1)
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.SetMesDrawspeed(0, 1)
	event.MesMake_2(
		0,
		"[(!)]シグーにダメージを与えると\n   怒ってこちらを威嚇して来ます。<page>   その時、大きく口を開けているので、\n   電気の魚を投げ入れるチャンスです！"
	)
	helper_87e4(0, -1, 5, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesWindowMode(0, 1)
	event.SetMesDrawspeed(0, 0)
	event.DngPause(3, 0)
	event.SetMotion(0, "立ち")
	event.Finish()
end

--- Program 1200.
script[1200] = function()
	local flag: s32 = 0
	local flag_2: s32 = 0
	local value: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_1054c(0, 8610070)
			end
			return
		end
	end
	flag = event.GetFlag(416) or flag
	flag_2 = event.GetFlag(420) or flag_2
	if flag ~= 0 and flag_2 == 0 then
		value = event.GetRandInt(100) or value
		if value < 50 then
			helper_1054c(0, 8610060)
			if vm.skipping() then
				return skip(1)
			end
		else
			helper_1054c(0, 8610070)
			if vm.skipping() then
				return skip(2)
			end
		end
		return
	end
	helper_104b4(0)
	if vm.skipping() then
		return skip(3)
	end
end

--- Program 14080.
script[14080] = function()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_11c1c()
			if not vm.skipping() then
				return part2()
			end
		end
	end
	function part2()
		event.ResetEventTrg()
		event.GotoEdit(75, 500)
	end
	event.SetFadeOut(0)
	event.SetFlag(400, 1)
	event.SetFlag(402, 1)
	event.SetFlag(404, 1)
	event.SetFlag(406, 1)
	event.SetFlag(408, 0)
	program_99()
	if vm.skipping() then
		return skip(1)
	end
	helper_11c1c()
	if vm.skipping() then
		return skip(2)
	end
	return part2()
end

--- Program 14100.
script[14100] = function()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_199cc()
			if not vm.skipping() then
				return part2()
			end
		end
	end
	function part2() end
	event.SetFlag(400, 1)
	event.SetFlag(402, 1)
	event.SetFlag(404, 1)
	event.SetFlag(406, 1)
	event.SetFlag(408, 1)
	event.SetFlag(410, 0)
	program_99()
	if vm.skipping() then
		return skip(1)
	end
	helper_199cc()
	if vm.skipping() then
		return skip(2)
	end
	return part2()
end

--- Program 14160.
script[14160] = function()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_1bfac()
			if not vm.skipping() then
				return part2()
			end
		end
	end
	function part2() end
	program_99()
	if vm.skipping() then
		return skip(1)
	end
	event.SetFlag(400, 1)
	event.SetFlag(402, 1)
	event.SetFlag(404, 1)
	event.SetFlag(406, 1)
	event.SetFlag(408, 1)
	helper_1bfac()
	if vm.skipping() then
		return skip(2)
	end
	return part2()
end

--- Program 14200.
script[14200] = function()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_1ee30()
			if not vm.skipping() then
				return part2()
			end
		end
	end
	function part2()
		event.ResetEventTrg()
		event.BgmLoadCancel()
		event.GotoEdit(75, 100)
		if vm.wait() then
			return skip(3)
		end
	end
	event.SetFlag(400, 1)
	event.SetFlag(402, 1)
	event.SetFlag(404, 1)
	event.SetFlag(406, 1)
	event.SetFlag(408, 1)
	event.SetFlag(416, 1)
	program_99()
	if vm.skipping() then
		return skip(1)
	end
	helper_1ee30()
	if vm.skipping() then
		return skip(2)
	end
	return part2()
end

return script
