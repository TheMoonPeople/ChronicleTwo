--!strict
-- map/f/f04/f04.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_40e84721 = require("@lib/event/helper_40e84721")
local helper_de8ac2af = require("@lib/event/helper_de8ac2af")

--- Helper function.
local function helper_1badc()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		return var0
	end
	if vm.skipping() then
		return skip(1)
	end
	var0 = event.GetAnalyze(410) or var0
	return var0
end

--- Helper function.
local function helper_1b84c()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		return var0
	end
	if vm.skipping() then
		return skip(1)
	end
	var0 = event.GetAnalyze(403) or var0
	return var0
end

--- Helper function.
local function helper_1ba38()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		return var0
	end
	if vm.skipping() then
		return skip(1)
	end
	var0 = event.GetAnalyze(406) or var0
	return var0
end

--- Helper function.
local function helper_29944()
	helper_40e84721(401, helper_1b84c())
	if helper_de8ac2af() == 0 then
		helper_40e84721(406, 0)
	end
	if helper_1ba38() == 0 then
		helper_40e84721(407, 0)
	end
end

--- Program 99.
local function program_99()
	if helper_1badc() ~= 0 then
		event.EohSyncObj(0, "p10_f0401")
		event.EohSetShow(0, 0)
	end
	helper_29944()
end

--- Helper function.
local function helper_29a90()
	local var0: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		pos_y = 0.0
		pos_y_2 = 0.0
		pos_y = 1160.0
		pos_y_2 = 1160.0
		pos_y = 2320.0
		pos_y_2 = 2320.0
	end
	if vm.skipping() then
		return skip(1)
	end
	var0 = event.GetCnt(14) or var0
	event.EohSyncObj(0, "p09_f0401")
	do
		local out1, out2, out3 = event.EohGetPos(0)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	event.EohSyncObj(1, "p24_f0401")
	do
		local out1, out2, out3 = event.EohGetPos(1)
		pos_x_2 = out1 or pos_x_2
		pos_y_2 = out2 or pos_y_2
		pos_z_2 = out3 or pos_z_2
	end
	if var0 == 0 then
		pos_y = 0.0
		pos_y_2 = 0.0
	end
	if var0 == 1 then
		pos_y = 1160.0
		pos_y_2 = 1160.0
	end
	if var0 == 2 then
		pos_y = 2320.0
		pos_y_2 = 2320.0
	end
	event.EohSetPos(0, pos_x, pos_y, pos_z)
	event.EohSetPos(1, pos_x_2, pos_y_2, pos_z_2)
end

--- Helper function.
local function helper_1bc78()
	local flag: s32 = 0
	if helper_1b84c() == 0 then
		return 0
	end
	flag = event.GetFlag(548) or flag
	if flag ~= 0 then
		return 0
	end
	return 1
end

--- Helper function.
local function helper_29b0(arg0: s32)
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
local function helper_440(arg0: any)
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
local function helper_2b58(arg0: any, arg1: any, arg2: any, arg3: any, arg4: any)
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
local function helper_2e88(arg0: s32, arg1: s32)
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
local function helper_3cb0(arg0: s32)
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
			t1, var2 = helper_2e88(arg0, var2)
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
		t0, var2 = helper_2e88(arg0, var2)
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
local function helper_2d9c(arg0: any)
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
local function helper_5d20(arg0: s32)
	local stream_open_state: s32 = 0
	local stream_open_state_2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			helper_2b58(0, -1, 8, 0, 0)
			helper_3cb0(0)
		end
		helper_2d9c(0)
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
	helper_2b58(0, -1, 8, 0, 0)
	event.StreamPlay(1)
	helper_3cb0(0)
	if vm.skipping() then
		return skip(4)
	end
	helper_2d9c(0)
	event.StreamClose(1)
end

--- Helper function.
local function helper_6010(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_5d20(arg0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, arg0)
	helper_5d20(arg0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_28a0()
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
local function helper_190c(arg0: f32, arg1: f32, arg2: f32, arg3: f32)
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
local function helper_21d10()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 13 then
			if at <= 1 then
				helper_440(20)
			end
			if at <= 2 then
				helper_6010(5480010)
			end
			if at <= 3 then
				helper_6010(5480020)
			end
			if at <= 4 then
				helper_28a0()
			end
			if at <= 5 then
				helper_6010(5480030)
			end
			if at <= 6 then
				helper_28a0()
			end
			if at <= 7 then
				helper_6010(5480040)
			end
			if at <= 8 then
				helper_28a0()
			end
			if at <= 9 then
				helper_6010(5480050)
			end
			if at <= 10 then
				helper_6010(5480060)
			end
			if at <= 11 then
				helper_6010(5480070)
			end
			if at <= 12 then
				helper_440(30)
			end
			if vm.skip_end() then
				return skip(14)
			end
			return part2()
		end
		helper_190c(0.0, 0.0, 50.0, 0.0)
	end
	function part2()
		event.CancelDramaScene()
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.DelExtMotion(0)
		event.DeleteChara(33)
		event.DeleteChara(34)
		event.LoadMes(0, -1)
		helper_190c(0.0, 0.0, 50.0, 0.0)
		event.ResetCamera(1, 0.0, 10.0)
		event.SetFadeIn(30)
	end
	event.SetFlag(548, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.LoadSound(5519)
	var0 = event.SndLoadSound(5519) or var0
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.ChangeDir("event/e500/e548/")
	event.LoadMes(0, 5, "e548.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e548_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e548_monica.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.ChangeDir("")
	if active_chr_no == 1 then
		event.LoadChara(5, "chara/c01_base.gltf", "info", 33)
		event.LoadEquip(5, 0, 4, "info", 33)
		event.LoadEquip(5, 0, 3, "info", 33)
		event.LoadEquip(5, 0, 2, "info", 33, 34)
		event.LoadMotion(5, "event/e500/e548/e548_mints.gltf", "info", 33)
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
		event.LoadMotion(5, "event/e500/e548/e548_monica.gltf", "info", 33)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 33)
		event.EohSyncChara(1, 33)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 0)
	end
	event.CharaActive(33)
	event.CharaActive(34)
	event.EohSetPos(0, 6.86, 0.0, 78.4)
	event.EohSetRot(0, 0.0, 0.03, 0.0)
	event.EohSetMotion(0, "立ち", 4)
	event.EohSetFootSoundId(0, 2)
	event.EohSetPos(1, -11.07, 0.0, 79.71)
	event.EohSetRot(1, 0.0, 0.03, 0.0)
	event.EohSetMotion(1, "立ち", 4)
	event.EohSetFootSoundId(1, 2)
	event.InitDramaScene()
	event.CmrsInit()
	event.CmrsSetPos(-0.89, 17.4, 23.48)
	event.CmrsSetRef(-4.13, 26.67, 318.08)
	event.CharaActive(0)
	event.CharaActive(33)
	event.CharaActive(34)
	event.ObjsSetMotion(0, "歩き")
	event.ObjsMove(0, 6.86, 0.0, 134.2, 80)
	event.ObjsMotionDelay(0, 80)
	event.ObjsSetMotion(0, "立ち")
	event.ObjsSetMotion(1, "歩き")
	event.ObjsMove(1, -16.25, 0.0, 134.11, 90)
	event.ObjsMotionDelay(1, 90)
	event.ObjsSetMotion(1, "立ち")
	event.SetFadeIn(30)
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "無表情")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	helper_29b0(1)
	if vm.skipping() then
		return skip(1)
	end
	helper_440(20)
	if vm.skipping() then
		return skip(2)
	end
	event.CmrsSetPos(17.79, 9.71, 164.37)
	event.CmrsSetRef(-8.32, 25.41, 125.32)
	event.ObjsSetPos(1, -9.86, 0.0, 136.53)
	event.ObjsSetRot(1, 0.0, 0.03, 0.0)
	event.ObjsResetDaPosition(1)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "無表情")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.SetPakuAnim(0, "通常口パク")
	helper_6010(5480010)
	if vm.skipping() then
		return skip(3)
	end
	event.CmrsSetPos(365.14, 3489.04, 547.36)
	event.CmrsSetRef(1061.18, 2794.56, 1334.73)
	event.CmrsMove(-1008.44, 3489.04, 1761.6, -311.9, 2794.56, 2548.54, 120)
	event.SetPakuAnim(1, "通常口パク")
	helper_6010(5480020)
	if vm.skipping() then
		return skip(4)
	end
	helper_28a0()
	if vm.skipping() then
		return skip(5)
	end
	event.SetCrossfade(30)
	event.CmrsSetPos(462.3, 74.35, 2186.93)
	event.CmrsSetRef(265.85, 104.22, 2195.54)
	event.CmrsMoveAhd(2.9, -74.33, 524.9, 240)
	event.SetPakuAnim(1, "通常口パク")
	helper_6010(5480030)
	if vm.skipping() then
		return skip(6)
	end
	helper_28a0()
	if vm.skipping() then
		return skip(7)
	end
	event.SetCrossfade(30)
	event.CmrsSetPos(-601.26, 2565.32, 2318.97)
	event.CmrsSetRef(-558.59, 2522.74, 2438.67)
	event.CmrsMove(-1019.04, 2565.32, 1129.79, -967.92, 2522.74, 1273.21, 180)
	event.SetPakuAnim(1, "通常口パク")
	helper_6010(5480040)
	if vm.skipping() then
		return skip(8)
	end
	helper_28a0()
	if vm.skipping() then
		return skip(9)
	end
	event.SetCrossfade(30)
	event.CmrsSetPos(83.14, 76.3, 216.76)
	event.CmrsSetRef(6.83, 24.83, 142.53)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsTexAnime(0, 1, "半口")
	helper_6010(5480050)
	if vm.skipping() then
		return skip(10)
	end
	event.ObjsSetMotion(1, "左向く", 6)
	event.ObjsNextMotion(1, "左向く会話", 4)
	event.ObjsMotionDelay(1, 60)
	event.ObjsSetMotion(1, "左向くL")
	event.ObjsMotionDelay(0, 30)
	event.ObjsSetMotion(0, "右向く", 6)
	event.ObjsNextMotion(0, "右向くL", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_6010(5480060)
	if vm.skipping() then
		return skip(11)
	end
	event.ObjsSeDelay(0, 10)
	event.ObjsSePlay(0, var0, 0)
	event.ObjsSetMotion(0, "右向くうなづき", 6)
	event.ObjsNextMotion(0, "右向くL", 4)
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.SetPakuAnim(0, "通常口パク")
	helper_6010(5480070)
	if vm.skipping() then
		return skip(12)
	end
	event.SetFadeOut(30)
	helper_440(30)
	if vm.skipping() then
		return skip(13)
	end
	return part2()
end

--- Helper function.
local function helper_1bda0()
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		local _ = if helper_1ba38() == 0 then 1 else 0
		return 0
	end
	if vm.skipping() then
		return skip(1)
	end
	if helper_1ba38() == 0 then
		return 0
	end
	flag = event.GetFlag(552) or flag
	if flag ~= 0 then
		return 0
	end
	return 1
end

--- Helper function.
local function helper_23dd8()
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 10 then
			if at <= 1 then
				helper_29b0(0)
			end
			if at <= 2 then
				helper_440(20)
			end
			if at <= 3 then
				helper_6010(5520010)
			end
			if at <= 4 then
				helper_440(90)
			end
			if at <= 5 then
				helper_440(20)
			end
			if at <= 6 then
				helper_6010(5520020)
			end
			if at <= 7 then
				helper_440(10)
			end
			if at <= 8 then
				helper_440(90)
			end
			if at <= 9 then
				helper_440(30)
			end
			if vm.skip_end() then
				return skip(11)
			end
			return part2()
		end
		helper_190c(vm.f32(255.2), 0.0, vm.f32(125.39), vm.f32(1.47))
	end
	function part2()
		event.CancelDramaScene()
		event.EohSetFootSoundId(0, 0)
		event.DelExtMotion(0)
		event.LoadMes(0, -1)
		helper_190c(vm.f32(255.2), 0.0, vm.f32(125.39), vm.f32(1.47))
		event.ResetCamera(1, 0.0, 10.0)
		event.SetFadeIn(30)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFlag(552, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.ChangeDir("event/e500/e552/")
	event.LoadMes(0, 5, "e552.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e552_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	event.ChangeDir("")
	if active_chr_no == 1 then
		event.LoadChara(5, "chara/c01_base.gltf", "info", 33)
		event.LoadEquip(5, 0, 4, "info", 33)
		event.LoadEquip(5, 0, 3, "info", 33)
		event.LoadEquip(5, 0, 2, "info", 33, 34)
		event.LoadMotion(5, "event/e500/e548/e548_mints.gltf", "info", 33)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 33)
		event.EohSyncChara(0, 33)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 0)
	else
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 0)
	end
	event.CharaActive(33)
	event.CharaActive(34)
	event.EohSetPos(0, 6.86, 0.0, 78.4)
	event.EohSetRot(0, 0.0, 0.03, 0.0)
	event.EohSetMotion(0, "立ち", 4)
	event.EohSetFootSoundId(0, 2)
	event.InitDramaScene()
	event.CmrsInit()
	event.CmrsSetPos(-48.86, 89.93, 248.19)
	event.CmrsSetRef(12.07, 9.71, 74.55)
	event.CharaActive(0)
	event.ObjsSetMotion(0, "歩き")
	event.ObjsMove(0, 3.32, 0.0, 116.62, 80)
	event.ObjsMotionDelay(0, 80)
	event.ObjsSetMotion(0, "立ち")
	event.SetFadeIn(30)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "無表情")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	helper_29b0(0)
	if vm.skipping() then
		return skip(2)
	end
	helper_440(20)
	if vm.skipping() then
		return skip(3)
	end
	event.CmrsSetPos(22.04, 8.19, 149.45)
	event.CmrsSetRef(-1.58, 23.89, 108.84)
	event.ObjsSetMotion(0, "上向く", 6)
	event.ObjsNextMotion(0, "上向くL", 4)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "通常目～おどろき目")
	event.SetPakuAnim(0, "通常口パク")
	helper_6010(5520010)
	if vm.skipping() then
		return skip(4)
	end
	event.CmrsSetPos(142.67, 815.3, 537.72)
	event.CmrsSetRef(130.25, 993.61, 1012.41)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "無表情")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.CmrsMove(81.88, 1714.97, 1427.25, 69.16, 1893.28, 1913.55, 90)
	helper_440(90)
	if vm.skipping() then
		return skip(5)
	end
	event.CmrsSetPos(-48.86, 89.93, 248.19)
	event.CmrsSetRef(12.07, 9.71, 74.55)
	helper_440(20)
	if vm.skipping() then
		return skip(6)
	end
	event.SetPakuAnim(0, "通常口パク")
	helper_6010(5520020)
	if vm.skipping() then
		return skip(7)
	end
	event.ObjsSetMotion(0, "上向く戻り", 6)
	event.ObjsNextMotion(0, "走り", 4)
	helper_440(10)
	if vm.skipping() then
		return skip(8)
	end
	event.ObjsRotation(0, 0.0, 1.47, 0.0, 5)
	event.ObjsMove(0, 255.2, 0.0, 125.39, 120)
	event.CmrsMove(-51.8, 89.93, 247.2, 139.01, 3.51, 77.46, 90)
	helper_440(90)
	if vm.skipping() then
		return skip(9)
	end
	event.SetFadeOut(30)
	helper_440(30)
	if vm.skipping() then
		return skip(10)
	end
	return part2()
end

--- Helper function.
local function helper_1bec8()
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		local _ = if helper_1badc() == 0 then 1 else 0
		return 0
	end
	if vm.skipping() then
		return skip(1)
	end
	if helper_1badc() == 0 then
		return 0
	end
	flag = event.GetFlag(556) or flag
	if flag ~= 0 then
		return 0
	end
	return 1
end

--- Helper function.
local function helper_27650()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local var2: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 12 then
			if at <= 1 then
				helper_440(60)
			end
			if at <= 2 then
				helper_440(90)
			end
			if at <= 3 then
				helper_440(90)
			end
			if at <= 4 then
				helper_440(120)
			end
			if at <= 5 then
				helper_6010(5560010)
			end
			if at <= 6 then
				helper_6010(5560020)
			end
			if at <= 7 then
				helper_6010(5560025)
			end
			if at <= 8 then
				helper_440(75)
			end
			if at <= 9 then
				helper_6010(5560030)
			end
			if at <= 10 then
				helper_440(60)
			end
			if at <= 11 then
				helper_440(30)
			end
			if vm.skip_end() then
				return skip(13)
			end
			return part2()
		end
		helper_190c(0.0, 0.0, 50.0, 0.0)
	end
	function part2()
		event.CancelDramaScene()
		event.SndSeStop(var0, 0)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		var2 = event.GetDefBgmNo(102) or var2
		event.LoadBgm(var2)
		event.PlayBgm(0)
		event.DelExtMotion(0)
		event.DeleteChara(33)
		event.DeleteChara(34)
		event.LoadMes(0, -1)
		helper_190c(0.0, 0.0, 50.0, 0.0)
		event.ResetCamera(1, 0.0, 10.0)
		event.SetFadeIn(30)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFlag(556, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.StopBgm(0)
	event.LoadSound(5524)
	var0 = event.SndLoadSound(5524) or var0
	event.SndSePlay(var0, 0)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.ChangeDir("event/e500/e556/")
	event.LoadMes(0, 5, "e556.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e556_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e556_monica.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.ChangeDir("")
	if active_chr_no == 1 then
		event.LoadChara(5, "chara/c01_base.gltf", "info", 33)
		event.LoadEquip(5, 0, 4, "info", 33)
		event.LoadEquip(5, 0, 3, "info", 33)
		event.LoadEquip(5, 0, 2, "info", 33, 34)
		event.LoadMotion(5, "event/e500/e548/e548_mints.gltf", "info", 33)
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
		event.LoadMotion(5, "event/e500/e548/e548_monica.gltf", "info", 33)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 33)
		event.EohSyncChara(1, 33)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 0)
	end
	event.CharaActive(33)
	event.CharaActive(34)
	event.EohSetPos(0, -193.68, 0.0, 73.48)
	event.EohSetRot(0, 0.0, 0.03, 0.0)
	event.EohSetMotion(0, "上向くL", 4)
	event.EohSetFootSoundId(0, 2)
	event.EohSetPos(1, -216.19, 0.0, 74.79)
	event.EohSetRot(1, 0.0, 0.03, 0.0)
	event.EohSetMotion(1, "上向くL", 4)
	event.EohSetFootSoundId(1, 2)
	event.InitDramaScene()
	event.CmrsInit()
	event.CmrsSetPos(-1887.71, 3927.56, 1055.04)
	event.CmrsSetRef(-1156.25, 3675.26, 2209.98)
	event.CharaActive(0)
	event.CharaActive(33)
	event.CharaActive(34)
	event.CmrsMove(-1527.79, 3854.3, 1598.26, -829.22, 3554.42, 2756.88, 60)
	event.SetFadeIn(30)
	event.SndSePlay(var0, 1)
	helper_440(60)
	if vm.skipping() then
		return skip(2)
	end
	event.SetCrossfade(30)
	event.CmrsSetPos(695.29, 4027.12, 592.97)
	event.CmrsSetRef(1043.56, 2105.14, 2169.9)
	event.SndSeStop(var0, 1)
	event.SndSePlay(var0, 2)
	event.CmrsMove(792.52, 3840.41, 1112.82, 1023.76, 2204.87, 2154.46, 90)
	helper_440(90)
	if vm.skipping() then
		return skip(3)
	end
	event.SetCrossfade(30)
	event.CmrsSetPos(390.04, 1913.65, 1546.59)
	event.CmrsSetRef(-3.71, 2508.25, 2769.81)
	event.SndSeStop(var0, 2)
	event.SndSePlay(var0, 3)
	event.CmrsMove(311.55, 2000.73, 1796.37, -36.66, 2508.25, 2871.9, 90)
	helper_440(90)
	if vm.skipping() then
		return skip(4)
	end
	event.SetCrossfade(30)
	event.CmrsSetPos(77.11, 1977.53, 568.47)
	event.CmrsSetRef(-6.16, 2923.06, 2851.89)
	event.SndSeStop(var0, 3)
	event.SndSePlay(var0, 4)
	event.CmrsMove(-8.75, 1736.89, 256.13, -3.94, 2828.04, 2790.99, 120)
	helper_440(120)
	if vm.skipping() then
		return skip(5)
	end
	event.SetCrossfade(30)
	event.CmrsSetPos(-168.35, 63.68, 137.42)
	event.CmrsSetRef(-203.33, 14.92, 72.64)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おどろき顔")
	event.ObjsTexAnime(0, 1, "おどろき目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "おこり顔")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.SetPakuAnim(0, "通常口パク")
	helper_6010(5560010)
	if vm.skipping() then
		return skip(6)
	end
	event.ObjsSetMotion(1, "上向く会話", 6)
	event.ObjsNextMotion(1, "上向くL", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_6010(5560020)
	if vm.skipping() then
		return skip(7)
	end
	event.CmrsSetPos(-208.74, 0.55, 25.47)
	event.CmrsSetRef(-204.56, 33.98, 76.86)
	event.ObjsSetMotion(1, "上向く会話", 6)
	event.ObjsMotionDelay(1, 120)
	event.ObjsNextMotion(1, "上向くL", 4)
	event.ObjsMotionDelay(0, 10)
	event.ObjsSetMotion(0, "上向く戻り", 6)
	event.ObjsNextMotion(0, "右向く", 4)
	event.ObjsMotionDelay(0, 10)
	event.ObjsSetMotion(0, "右向くL")
	event.SetPakuAnim(1, "通常口パク")
	helper_6010(5560025)
	if vm.skipping() then
		return skip(8)
	end
	event.ObjsSetPos(1, -9.86, 0.0, 136.53)
	event.ObjsSetRot(1, 0.0, 0.03, 0.0)
	event.ObjsResetDaPosition(1)
	event.CmrsSetPos(-181.0, 10.89, 97.27)
	event.CmrsSetRef(-195.22, 24.21, 69.35)
	event.ObjsSetMotion(0, "右向く戻り", 6)
	event.ObjsNextMotion(0, "上向く", 4)
	event.ObjsMotionDelay(1, 60)
	event.ObjsSetMotion(0, "上向くL")
	helper_440(75)
	if vm.skipping() then
		return skip(9)
	end
	event.SetPakuAnim(0, "通常口パク")
	helper_6010(5560030)
	if vm.skipping() then
		return skip(10)
	end
	event.CmrsSetPos(-2993.05, 3147.07, -1117.3)
	event.CmrsSetRef(-2885.8, 3145.8, -973.91)
	helper_440(60)
	if vm.skipping() then
		return skip(11)
	end
	event.SetFadeOut(30)
	helper_440(30)
	if vm.skipping() then
		return skip(12)
	end
	return part2()
end

--- Helper function.
local function helper_34f0(arg0: s32, arg1: any, arg2: any)
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
		helper_2d9c(arg0)
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
			helper_2d9c(arg0)
		end
	end
	event.ResetPakuMotion()
	event.TrgPakuAnim(0)
	event.ResetPakuAnim()
	event.StreamStop(1)
	event.SetMesOkuri(arg0, 1)
end

--- Helper function.
local function helper_3bf4(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_34f0(arg0, vm.ftoi(arg1), -1)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	helper_34f0(arg0, vm.ftoi(arg1), -1)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_565c(arg0: s32, arg1: s32)
	local stream_open_state: s32 = 0
	local stream_open_state_2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			helper_2b58(0, -1, 8, 0, 0)
			helper_3bf4(0, arg1)
		end
		helper_2d9c(0)
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
	helper_2b58(0, -1, 8, 0, 0)
	event.StreamPlay(1)
	helper_3bf4(0, arg1)
	if vm.skipping() then
		return skip(4)
	end
	helper_2d9c(0)
	event.StreamClose(1)
	event.SetMesPos(0, 0)
end

--- Helper function.
local function helper_2acc(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesWindowMode(arg0, arg1)
end

--- Helper function.
local function helper_4378(arg0: any, arg1: s32)
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
local function helper_7a90(arg0: any, arg1: s32, arg2: s32)
	local var3: s32 = 0
	local var4: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var4 = 0
			var3 = helper_4378(arg0, arg1)
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
		var3 = helper_4378(arg0, arg1)
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
local function helper_8558(arg0: s32, arg1: any, arg2: s32, arg3: s32, arg4: s32)
	local var6: s32 = 0
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			local _ = helper_2b58(arg0, arg1, arg2, arg3, arg4)
			_, var6 = helper_7a90(arg0, 0, var6)
		end
		helper_2d9c(arg0)
	end
	if vm.skipping() then
		return skip(1)
	end
	local _ = helper_2b58(arg0, arg1, arg2, arg3, arg4)
	_, var6 = helper_7a90(arg0, 0, var6)
	if vm.skipping() then
		return skip(2)
	end
	helper_2d9c(arg0)
end

--- Helper function.
local function helper_cb90(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local argc: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_2acc(1, 4)
			var2 = -1
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(1, 4)
	helper_2acc(1, 4)
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
	helper_8558(1, var2, 8, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_7a4(arg0: s32)
	local argc: s32 = 0
	local argc_2: s32 = 0
	local argc_3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_440(10)
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
			helper_440(10)
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
local function helper_1c2f4()
	local var0: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local active_chr_no: s32 = 0
	local block: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 47 then
			if at <= 1 then
				helper_440(180)
			end
			if at <= 2 then
				helper_440(30)
			end
			if at <= 3 then
				helper_440(150)
			end
			if at <= 4 then
				helper_440(30)
			end
			if at <= 5 then
				helper_6010(5080010)
			end
			if at <= 6 then
				helper_6010(5080020)
			end
			if at <= 7 then
				helper_6010(5080025)
			end
			if at <= 8 then
				helper_6010(5080030)
			end
			if at <= 9 then
				helper_565c(5080040, 300)
			end
			if at <= 10 then
				helper_565c(5080050, 300)
			end
			if at <= 11 then
				helper_28a0()
			end
			if at <= 12 then
				helper_6010(5080060)
			end
			if at <= 13 then
				helper_29b0(2)
			end
			if at <= 14 then
				helper_6010(5080070)
			end
			if at <= 15 then
				helper_6010(5080075)
			end
			if at <= 16 then
				helper_29b0(2)
			end
			if at <= 17 then
				helper_6010(5080080)
			end
			if at <= 18 then
				helper_440(10)
			end
			if at <= 19 then
				helper_440(30)
			end
			if at <= 20 then
				helper_6010(5080090)
			end
			if at <= 21 then
				helper_29b0(0)
			end
			if at <= 22 then
				helper_6010(5080100)
			end
			if at <= 23 then
				helper_29b0(0)
			end
			if at <= 24 then
				helper_29b0(2)
			end
			if at <= 25 then
				helper_6010(5080110)
			end
			if at <= 26 then
				helper_6010(5080120)
			end
			if at <= 27 then
				helper_565c(5080130, 240)
			end
			if at <= 28 then
				helper_565c(5080140, 150)
			end
			if at <= 29 then
				helper_565c(5080145, 180)
			end
			if at <= 30 then
				helper_28a0()
			end
			if at <= 31 then
				helper_6010(5080150)
			end
			if at <= 32 then
				helper_6010(5080160)
			end
			if at <= 33 then
				helper_29b0(1)
			end
			if at <= 34 then
				helper_6010(5080170)
			end
			if at <= 35 then
				helper_29b0(2)
			end
			if at <= 36 then
				helper_6010(5080180)
			end
			if at <= 37 then
				helper_29b0(2)
			end
			if at <= 38 then
				helper_cb90(372, 1)
			end
			if at <= 39 then
				helper_29b0(5)
			end
			if at <= 40 then
				helper_6010(5080190)
			end
			if at <= 41 then
				helper_6010(5080195)
			end
			if at <= 42 then
				helper_29b0(2)
			end
			if at <= 43 then
				helper_6010(5080200)
			end
			if at <= 44 then
				helper_29b0(0)
			end
			if at <= 45 then
				helper_6010(5080210)
			end
			if at <= 46 then
				helper_440(30)
			end
			if vm.skip_end() then
				return skip(48)
			end
			return part2()
		end
		if at <= 48 then
			helper_7a4(0)
		end
		helper_190c(vm.f32(-1688.6), 1160.0, 5131.0, vm.f32(2.55))
	end
	function part2()
		event.CancelDramaScene()
		event.SetStatus(1, 0, 256, 0)
		event.SndSeStop(var2, 0)
		event.SndSeStop(var1, 3)
		event.SndSeStop(var1, 4)
		event.SndSeStop(var1, 5)
		event.CharaActive(1, var0)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.SpriteSetDraw(0, 0)
		event.DelExtMotion(0)
		event.DeleteChara(33)
		event.DeleteChara(34)
		event.DeleteChara(35)
		event.DeleteChara(36)
		event.DeleteChara(37)
		event.DelImg(0)
		event.LoadMes(0, -1)
		helper_7a4(0)
		if vm.skipping() then
			return skip(49)
		end
		event.PlayBgm(0)
		helper_190c(vm.f32(-1688.6), 1160.0, 5131.0, vm.f32(2.55))
		event.ResetCamera(1, 3.1415927, 10.0)
		event.SetFadeIn(30)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFlag(508, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	var0 = event.SearchCharaNo(401) or var0
	event.CharaActive(0, var0)
	event.LoadSound(5500)
	var1 = event.SndLoadSound(5500) or var1
	var2 = event.SndLoadSound(8, "snd2/sp/sp_006.sound.json") or var2
	event.SetStatus(1, 0, 256, 1)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.ChangeDir("event/e500/e508/")
	event.LoadMes(0, 5, "e508.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e508_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e508_monica.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.LoadChara(5, "e508_gisecon.gltf", "info", 35)
	event.CharaActive(35)
	event.EohSyncChara(2, 35)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.LoadChara(5, "e508_bom_t.gltf", "info", 36)
	event.CharaActive(36)
	event.EohSyncChara(4, 36)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	block = event.LoadImg_4(5, "e508.json", 0) or block
	event.SpriteInit(0)
	event.SpriteSetType(0, 0)
	event.SpriteSetTexture(0, "e50801", block)
	event.SpriteSetColor(0, 128, 128, 128, 0)
	event.SpriteSetUvsize(0, 0, 0, 512, 448)
	event.SpriteSetPutsize(0, 512, 448)
	event.SpriteSetPos(0, 256, 224)
	event.SpriteSetDraw(0, 1)
	event.EohSyncSprite(3, 0)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.ChangeDir("")
	if active_chr_no == 1 then
		event.LoadChara(5, "chara/c01_base.gltf", "info", 33)
		event.LoadEquip(5, 0, 4, "info", 33)
		event.LoadEquip(5, 0, 3, "info", 33)
		event.LoadEquip(5, 0, 2, "info", 33, 34)
		event.LoadMotion(5, "event/e500/e508/e508_mints.gltf", "info", 33)
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
		event.LoadMotion(5, "event/e500/e508/e508_monica.gltf", "info", 33)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 33)
		event.EohSyncChara(1, 33)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 0)
	end
	event.CharaActive(33)
	event.CharaActive(34)
	event.LoadChara(5, "event/itemget_ev/itemget_ev.gltf", "info", 37)
	event.CharaActive(37)
	event.EohSyncChara(5, 37)
	event.ObjsInit(5)
	event.ObjsSyncObj(5, 5)
	event.EohSetPos(0, 29.8, -1160.0, 5918.68)
	event.EohSetRot(0, 0.0, -2.13, 0.0)
	event.EohSetMotion(0, "立ち", 4)
	event.EohSetFootSoundId(0, 2)
	event.EohSetPos(1, 116.43, -1160.0, 5909.81)
	event.EohSetRot(1, 0.0, -2.13, 0.0)
	event.EohSetMotion(1, "立ち", 4)
	event.EohSetFootSoundId(1, 2)
	event.EohSetPos(2, -95.34, 1160.0, 5824.2)
	event.EohSetRot(2, 0.0, 3.07, 0.0)
	event.EohSetMotion(2, "立ち", 4)
	event.EohSetFootSoundId(2, 2)
	event.EohSetPos(5, -67.36, 1194.16, 5795.09)
	event.EohSetRot(5, 0.0, 1.39, 0.0)
	event.EohSetShow(5, 0)
	event.EohSetShow(4, 0)
	event.InitDramaScene()
	event.CmrsInit()
	event.CmrsSetPos(-103.82, 1168.63, 5924.94)
	event.CmrsSetRef(-95.48, 1187.1, 5825.3)
	event.CharaActive(0)
	event.CharaActive(0, 37)
	event.CmrsMoveAhd2(-2.77, -18.15, 77.63, 150, 2, 0.5)
	event.SetFadeIn(30)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "デフォルト顔")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	helper_440(180)
	if vm.skipping() then
		return skip(2)
	end
	event.ObjsSetPos(0, 59.27, 1160.0, 5900.71)
	event.ObjsSetPos(1, 116.43, 1160.0, 5909.81)
	helper_440(30)
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsSetMotion(0, "歩き")
	event.ObjsMove(0, -29.62, 1160.0, 5881.12, 120)
	event.ObjsMotionDelay(0, 120)
	event.ObjsSetMotion(0, "立ち")
	event.ObjsMotionDelay(1, 10)
	event.ObjsSetMotion(1, "歩き")
	event.ObjsMove(1, -17.95, 1160.0, 5866.09, 120)
	event.ObjsMotionDelay(1, 120)
	event.ObjsSetMotion(1, "立ち")
	helper_440(150)
	if vm.skipping() then
		return skip(4)
	end
	event.SndSePlay(var1, 2)
	event.ObjsSetMotion(2, "振り向く", 6)
	event.ObjsNextMotion(2, "振り向くループ", 4)
	helper_440(30)
	if vm.skipping() then
		return skip(5)
	end
	event.SndSeStop(var1, 2)
	event.CmrsSetPos(-42.11, 1183.03, 5838.93)
	event.CmrsSetRef(-92.5, 1187.1, 5823.57)
	event.ObjsSetMotion(2, "振り向く（会話）", 6)
	event.ObjsNextMotion(2, "振り向くループ", 4)
	event.SetPakuAnim(2, "口パク")
	helper_6010(5080010)
	if vm.skipping() then
		return skip(6)
	end
	event.ObjsSetRot(0, 0.0, -2.61, 0.0)
	event.ObjsResetDaPosition(0)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.CmrsSetPos(-40.15, 1177.76, 5832.3)
	event.CmrsSetRef(-19.81, 1181.94, 5882.99)
	event.ObjsSetMotion(1, "会話", 6)
	event.ObjsNextMotion(1, "立ち", 4)
	event.SetPakuAnim(1, "わらい口パク")
	helper_6010(5080020)
	if vm.skipping() then
		return skip(7)
	end
	event.SetPakuAnim(1, "わらい口パク")
	helper_6010(5080025)
	if vm.skipping() then
		return skip(8)
	end
	event.ObjsSetMotion(0, "会話", 6)
	event.ObjsNextMotion(0, "立ち", 4)
	event.SetPakuAnim(0, "わらい口パク")
	helper_6010(5080030)
	if vm.skipping() then
		return skip(9)
	end
	event.CmrsSetPos(-288.23, 1713.07, 1700.32)
	event.CmrsSetRef(-265.03, 1706.85, 1729.17)
	event.CmrsMove(-245.15, 1713.07, 1697.71, -265.03, 1706.85, 1729.17, 600)
	event.SetPakuAnim(1, "わらい口パク")
	helper_565c(5080040, 300)
	if vm.skipping() then
		return skip(10)
	end
	event.SetPakuAnim(2, "口パク")
	helper_565c(5080050, 300)
	if vm.skipping() then
		return skip(11)
	end
	helper_28a0()
	if vm.skipping() then
		return skip(12)
	end
	event.ObjsSetPos(0, -43.15, 1160.0, 5855.69)
	event.ObjsSetRot(0, 0.0, -1.89, 0.0)
	event.ObjsSetPos(1, -36.4, 1160.0, 5827.54)
	event.ObjsSetRot(1, 0.0, -1.65, 0.0)
	event.ObjsSetPos(2, -95.84, 1160.0, 5822.44)
	event.ObjsSetRot(2, 0.0, 1.11, 0.0)
	event.CmrsSetPos(-43.6, 1261.21, 5957.35)
	event.CmrsSetRef(-64.76, 1175.56, 5833.21)
	event.ObjsSetMotion(2, "会話２（手腰に）", 6)
	event.ObjsNextMotion(2, "立ち", 4)
	event.SetPakuAnim(2, "口パク")
	helper_6010(5080060)
	if vm.skipping() then
		return skip(13)
	end
	helper_29b0(2)
	if vm.skipping() then
		return skip(14)
	end
	event.ObjsSetMotion(1, "会話", 6)
	event.ObjsNextMotion(1, "立ち", 4)
	event.SetPakuAnim(1, "わらい口パク")
	helper_6010(5080070)
	if vm.skipping() then
		return skip(15)
	end
	event.ObjsSetMotion(1, "会話", 6)
	event.ObjsNextMotion(1, "立ち", 4)
	event.SetPakuAnim(1, "わらい口パク")
	helper_6010(5080075)
	if vm.skipping() then
		return skip(16)
	end
	event.ObjsSetMotion(2, "歩き")
	event.ObjsMotionDelay(2, 60)
	event.ObjsSetMotion(2, "立ち")
	event.ObjsRotation(2, 0.0, 2.79, 0.0, 12)
	event.ObjsMove(2, -85.83, 1160.0, 5772.54, 60)
	helper_29b0(2)
	if vm.skipping() then
		return skip(17)
	end
	event.SetPakuAnim(2, "口パク")
	helper_6010(5080080)
	if vm.skipping() then
		return skip(18)
	end
	event.CmrsSetPos(-54.61, 1199.22, 5675.45)
	event.CmrsSetRef(-68.38, 1175.56, 5850.15)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "無表情")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "無表情")
	event.ObjsSetMotion(1, "歩き")
	event.ObjsMotionDelay(1, 90)
	event.ObjsSetMotion(1, "立ち")
	event.ObjsRotation(1, 0.0, -2.97, 0.0, 12)
	event.ObjsMove(1, -55.34, 1160.0, 5775.54, 90)
	event.ObjsMotionDelay(1, 10)
	event.ObjsSetMotion(1, "立ち→グイ見る", 6)
	event.ObjsNextMotion(1, "グイ見るL", 4)
	helper_440(10)
	if vm.skipping() then
		return skip(19)
	end
	event.ObjsSetMotion(0, "歩き")
	event.ObjsRotation(0, 0.0, -2.97, 0.0, 12)
	event.ObjsMove(0, -35.96, 1160.0, 5773.94, 90)
	event.ObjsMotionDelay(0, 90)
	event.ObjsSetMotion(0, "立ち")
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "無表情")
	event.ObjsTexAnime(0, 1, "前向き～目下")
	helper_440(30)
	if vm.skipping() then
		return skip(20)
	end
	event.SetPakuAnim(1, "わらい口パク")
	helper_6010(5080090)
	if vm.skipping() then
		return skip(21)
	end
	helper_29b0(0)
	if vm.skipping() then
		return skip(22)
	end
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "目下～おどろき目")
	event.ObjsTexAnime(0, 1, "口とじ～大口")
	event.ObjsSetMotion(2, "会話２（手腰に）")
	event.ObjsMotionDelay(2, 90)
	event.ObjsSetMotion(2, "立ち")
	event.SetPakuAnim(2, "口パク")
	helper_6010(5080100)
	if vm.skipping() then
		return skip(23)
	end
	helper_29b0(0)
	if vm.skipping() then
		return skip(24)
	end
	helper_29b0(2)
	if vm.skipping() then
		return skip(25)
	end
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "通常目～おどろき目")
	event.ObjsSetMotion(1, "直接？！", 6)
	event.ObjsNextMotion(1, "グイ見るL", 4)
	event.ObjsSetMotion(0, "直接！？", 6)
	event.ObjsNextMotion(0, "左向くL", 4)
	event.SetPakuAnim(1, "大口パク")
	helper_6010(5080110)
	if vm.skipping() then
		return skip(26)
	end
	event.ObjsSetColor(3, 128, 128, 128, 128, 30)
	event.SetPakuAnim(2, "口パク")
	helper_6010(5080120)
	if vm.skipping() then
		return skip(27)
	end
	event.ObjsSetColor(3, 128, 128, 128, 0, 30)
	event.ObjsSetMotion(0, "立ち")
	event.ObjsSetMotion(1, "立ち")
	event.ObjsSetMotion(2, "立ち")
	event.CmrsSetPos(-1.14, 2507.89, -1061.57)
	event.CmrsSetRef(-1.4, 2524.83, -894.87)
	event.CmrsMove2(-1.25, 516.45, -1054.54, -1.36, 518.76, -917.04, 330, 0, 0.7)
	event.SetPakuAnim(2, "口パク")
	helper_565c(5080130, 240)
	if vm.skipping() then
		return skip(28)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_565c(5080140, 150)
	if vm.skipping() then
		return skip(29)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_565c(5080145, 180)
	if vm.skipping() then
		return skip(30)
	end
	helper_28a0()
	if vm.skipping() then
		return skip(31)
	end
	event.CmrsSetPos(-68.79, 1173.91, 5887.0)
	event.CmrsSetRef(-63.03, 1177.39, 5762.52)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "デフォルト顔")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.ObjsSetMotion(2, "会話２（手腰に）")
	event.ObjsMotionDelay(2, 90)
	event.ObjsSetMotion(2, "立ち")
	event.SetPakuAnim(2, "口パク")
	helper_6010(5080150)
	if vm.skipping() then
		return skip(32)
	end
	event.ObjsSetMotion(0, "左向く", 6)
	event.ObjsNextMotion(0, "左向く会話", 4)
	event.ObjsMotionDelay(0, 90)
	event.ObjsSetMotion(0, "左向くL")
	event.ObjsMotionDelay(1, 10)
	event.ObjsSetMotion(1, "右向く", 6)
	event.ObjsNextMotion(1, "右向くL", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_6010(5080160)
	if vm.skipping() then
		return skip(33)
	end
	helper_29b0(1)
	if vm.skipping() then
		return skip(34)
	end
	event.ObjsMotionDelay(2, 30)
	event.ObjsSetMotion(2, "モニカ見る", 6)
	event.ObjsNextMotion(2, "モニカ見るループ", 4)
	event.ObjsMotionDelay(2, 30)
	event.ObjsSetMotion(2, "モニカ見る（会話）", 6)
	event.ObjsNextMotion(2, "モニカ見るループ", 4)
	event.ObjsMotionDelay(1, 30)
	event.ObjsSetMotion(1, "右向く戻り", 6)
	event.ObjsNextMotion(1, "立ち→グイ見る", 4)
	event.ObjsNextMotion(1, "グイ見るL", 4)
	event.SetPakuAnim(2, "口パク")
	helper_6010(5080170)
	if vm.skipping() then
		return skip(35)
	end
	helper_29b0(2)
	if vm.skipping() then
		return skip(36)
	end
	event.EohSetShow(4, 1)
	event.SetReference(35, "b", 36)
	event.ObjsSetMotion(0, "爆弾ゲット", 4)
	event.ObjsSetMotion(1, "立ち")
	event.ObjsSetMotion(2, "立ち", 4)
	event.ObjsSetPos(0, -55.61, 1160.0, 5803.78)
	event.ObjsSetRot(0, 0.0, -1.65, 0.0)
	event.ObjsSetPos(1, -55.51, 1160.0, 5780.57)
	event.ObjsSetRot(1, 0.0, -1.65, 0.0)
	event.ObjsSetPos(2, -95.43, 1160.0, 5795.54)
	event.ObjsSetRot(2, 0.0, 1.59, 0.0)
	event.CmrsSetPos(-49.1, 1184.63, 5789.27)
	event.CmrsSetRef(-125.19, 1191.35, 5802.1)
	event.SndSePlay(var1, 3)
	event.ObjsSetMotion(2, "だす", 6)
	event.ObjsNextMotion(2, "だすループ", 4)
	event.SetPakuAnim(2, "口パク")
	helper_6010(5080180)
	if vm.skipping() then
		return skip(37)
	end
	event.SndSeStop(var1, 3)
	helper_29b0(2)
	if vm.skipping() then
		return skip(38)
	end
	event.EohSetShow(1, 0)
	event.DelReference(36)
	if active_chr_no == 0 then
		event.SetReference(0, "item", 36)
	else
		event.SetReference(33, "item", 36)
	end
	event.ObjsSetMotion(2, "立ち", 4)
	event.CmrsSetPos(-94.34, 1203.09, 5799.78)
	event.CmrsSetRef(-54.1, 1186.29, 5805.08)
	event.SndPauseBgm()
	event.CharaActive(37)
	event.EohSetShow(5, 1)
	event.ObjsSetMotion(5, "発動", 6)
	event.ObjsSeDelay(5, 30)
	event.ObjsSePlay(5, var2, 0)
	event.SndSePlay(var1, 4)
	helper_cb90(372, 1)
	if vm.skipping() then
		return skip(39)
	end
	event.ObjsMotionWait(5)
	helper_29b0(5)
	if vm.skipping() then
		return skip(40)
	end
	event.PlayBgm(0)
	event.DelReference(36)
	event.EohSetShow(1, 1)
	event.ObjsSetMotion(0, "立ち", 4)
	event.CmrsSetPos(3.92, 1224.43, 5857.27)
	event.CmrsSetRef(-77.23, 1174.09, 5794.78)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsSetMotion(2, "会話２（手腰に）", 6)
	event.ObjsMotionDelay(2, 90)
	event.ObjsNextMotion(2, "立ち", 4)
	event.SetPakuAnim(2, "口パク")
	helper_6010(5080190)
	if vm.skipping() then
		return skip(41)
	end
	event.SetPakuAnim(2, "口パク")
	helper_6010(5080195)
	if vm.skipping() then
		return skip(42)
	end
	helper_29b0(2)
	if vm.skipping() then
		return skip(43)
	end
	event.ObjsSetMotion(0, "会話", 6)
	event.ObjsNextMotion(0, "立ち", 4)
	event.SetPakuAnim(0, "わらい口パク")
	helper_6010(5080200)
	if vm.skipping() then
		return skip(44)
	end
	helper_29b0(0)
	if vm.skipping() then
		return skip(45)
	end
	event.ObjsSetMotion(2, "ぐっ", 6)
	event.ObjsNextMotion(2, "ぐぅ（会話）", 4)
	event.ObjsMotionDelay(2, 60)
	event.ObjsNextMotion(2, "ぐっループ", 4)
	event.SndSePlay(var1, 5)
	event.ObjsTexAnime(2, 1, "口とじ～くいしばり")
	helper_6010(5080210)
	if vm.skipping() then
		return skip(46)
	end
	event.SetFadeOut(30)
	helper_440(30)
	if vm.skipping() then
		return skip(47)
	end
	return part2()
end

--- Helper function.
local function helper_1048()
	local argc: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	while true do
		argc = event.CheckLoadbgFile() or argc
		if argc == 0 then
			break
		else
			if vm.wait() then
				return skip(2)
			end
		end
	end
end

--- Helper function.
local function helper_14220()
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.SpriteSetDraw(0, 0)
end

--- Helper function.
local function helper_142ac(arg0: s32)
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
		if at <= 3 then
			helper_8558(0, -1, 5, 0, 0)
		end
		helper_14220()
	end
	if vm.skipping() then
		return skip(1)
	end
	flag = event.GetFlag(612) or flag
	if flag == 0 then
		return
	end
	event.SetMesWindowMode(0, 12)
	event.SpriteInit(0)
	event.SpriteSetType(0, 0)
	event.SpriteSetPos(0, 256, 208)
	event.SpriteSetPutsize(0, 512, 416)
	event.SpriteSetColor(0, 255, 255, 255, 255)
	event.SpriteSetDraw(0, 0)
	event.EohSyncSprite(20, 0)
	event.ObjsInit(20)
	event.ObjsSyncObj(20, 20)
	event.SpriteSetDraw(0, 1)
	event.SetFadeIn(0)
	if vm.wait() then
		return skip(2)
	end
	if arg0 ~= 0 then
		event.MesMake_2(0, "イクシオンの時空転移装置で\nボクたちは未来へとジャンプした。")
	else
		event.MesMake_2(0, "イクシオンの時空転移装置で\n私たちは現在に戻ってきた。")
	end
	if vm.wait() then
		return skip(3)
	end
	helper_8558(0, -1, 5, 0, 0)
	if vm.skipping() then
		return skip(4)
	end
	if vm.wait() then
		return skip(5)
	end
	event.SetFadeOut(0, 255.0, 255.0, 255.0)
	if vm.wait() then
		return skip(6)
	end
	helper_14220()
end

--- Helper function.
local function helper_17c28(arg0: f32, arg1: f32, arg2: f32, arg3: f32, arg4: s32, arg5: s32)
	local now_party_chara_id: s32 = 0
	local active_chr_no: s32 = 0
	local flag: s32 = 0
	local var12: s32 = 0
	local var13: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var17: s32 = 0
	local active_chr_no_2: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 9 then
			if at <= 1 then
				helper_1048()
			end
			if at <= 2 then
				helper_440(20)
			end
			if at <= 3 then
				helper_29b0(0)
			end
			if at <= 4 then
				helper_1048()
			end
			if at <= 5 then
				print("pumpkin---------------------------\n")
				print("stripte -----------------------------\n")
				print("princess-----------------------------\n")
				print("separate----------------------------\n")
				helper_29b0(6)
			end
			if at <= 6 then
				helper_440(60)
			end
			if at <= 7 then
				helper_440(60)
			end
			if at <= 8 then
				helper_142ac(0)
			end
			if vm.skip_end() then
				return skip(10)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		if flag ~= 0 then
			event.SndSeStop(var12, 0)
		end
		event.FadeOutBgm(30)
		event.SndSeStop(var13, 0)
		now_party_chara_id = event.GetNowPartyChara() or now_party_chara_id
		active_chr_no_2 = event.GetActiveChrNo() or active_chr_no_2
		event.DeleteChara(37)
		if active_chr_no_2 == 1 then
			event.DelExtMotion(0)
			event.DeleteChara(33)
		end
		if active_chr_no_2 == 0 then
			event.DeleteChara(32)
		end
		if now_party_chara_id ~= -1 then
			event.DeleteChara(34)
		end
		event.DeleteChara(35)
		event.DeleteChara(36)
		event.DeleteChara(38)
		event.DeleteChara(39)
	end
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.SetMotion(0, "立ち")
	if arg4 == 0 then
		event.SetLoadbgFile("event/time_gate/blue/tg_maru_blue.gltf", "event/time_gate/blue/tg_sita_blue.gltf")
	else
		event.SetLoadbgFile("event/time_gate/red/tg_maru_red.gltf", "event/time_gate/red/tg_sita_red.gltf")
	end
	event.CmrsInit()
	event.CmrsFadeInit()
	event.CmrsFadeOut(30)
	helper_28a0()
	if vm.skipping() then
		return skip(1)
	end
	event.InitDramaScene()
	event.SetSkipBotton(20)
	event.SetSkipFcol(255.0, 255.0, 255.0)
	event.SetCharaShow(120, 0)
	event.SetCharaShow(121, 0)
	event.AssignStack(5)
	event.ClearStack(5)
	event.SetWorldCoord(arg0, arg1, arg2, arg3)
	helper_1048()
	if vm.skipping() then
		return skip(2)
	end
	if arg4 == 0 then
		event.LoadChara(5, "event/time_gate/blue/tg_maru_blue.gltf", "info", 35)
		event.CharaActive(35)
		event.SetCharaType(35, 4)
		event.EohSyncChara(3, 35)
		event.ObjsInit(3)
		event.ObjsSyncObj(3, 3)
		event.ObjsSetPos(3, 0.0, 70.0, 0.0)
		event.ObjsSetRot(3, 0.0, 0.0, 0.0)
		event.LoadChara(5, "event/time_gate/blue/tg_sita_blue.gltf", "info2", 36)
		event.CharaActive(36)
		event.SetCharaType(36, 4)
		event.EohSyncChara(4, 36)
		event.ObjsInit(4)
		event.ObjsSyncObj(4, 4)
		event.ObjsSetPos(4, 0.0, 0.88, 0.0)
		event.ObjsSetRot(4, 0.0, 0.0, 0.0)
	else
		event.LoadChara(5, "event/time_gate/red/tg_maru_red.gltf", "info", 35)
		event.CharaActive(35)
		event.SetCharaType(35, 4)
		event.EohSyncChara(3, 35)
		event.ObjsInit(3)
		event.ObjsSyncObj(3, 3)
		event.ObjsSetPos(3, 0.0, 70.0, 0.0)
		event.ObjsSetRot(3, 0.0, 0.0, 0.0)
		event.LoadChara(5, "event/time_gate/red/tg_sita_red.gltf", "info2", 36)
		event.CharaActive(36)
		event.SetCharaType(36, 4)
		event.EohSyncChara(4, 36)
		event.ObjsInit(4)
		event.ObjsSyncObj(4, 4)
		event.ObjsSetPos(4, 0.0, 0.88, 0.0)
		event.ObjsSetRot(4, 0.0, 0.0, 0.0)
	end
	now_party_chara_id = event.GetNowPartyChara() or now_party_chara_id
	if now_party_chara_id ~= -1 then
		event.LoadCharaNpc(0, 5, now_party_chara_id, 34)
		event.CharaActive(34)
		event.EohSyncChara(2, 34)
		event.EohSetPos(2, 23.24, 0.0, -46.31)
		event.EohSetRot(2, 0.0, -0.44, 0.0)
		event.EohSetTexAnim(2, 0)
	end
	if arg5 ~= 0 then
		active_chr_no = event.GetActiveChrNo() or active_chr_no
		if active_chr_no == 1 then
			event.GetEquipItemno(0, 2)
			event.GetEquipItemno(0, 3)
			event.GetEquipItemno(0, 4)
		end
		if active_chr_no == 0 then
			event.GetEquipItemno(1, 2)
			event.GetEquipItemno(1, 3)
			event.GetEquipItemno(1, 4)
		end
		if active_chr_no == 1 then
			event.LoadMotion(5, "event/time_gate/blue/c02a_warp.gltf", "info", 0)
			event.CharaActive(0)
			event.EohSyncChara(0, 0)
			event.LoadChara(5, "chara/c01_base.gltf", "info", 33)
			event.CharaActive(33)
			event.EohSyncChara(1, 33)
			event.LoadEquip(5, 0, 4, "info", 33)
			event.LoadEquip(5, 0, 3, "info", 33)
			event.LoadEquip(5, 0, 2, "info", 33, 37)
			event.CharaActive(37)
			event.EohSyncChara(5, 37)
		end
		if active_chr_no == 0 then
			event.LoadChara(5, "chara/c02_base.gltf", "info", 32)
			event.CharaActive(32)
			event.EohSyncChara(0, 32)
			event.LoadEquip(5, 1, 4, "info", 32)
			event.LoadEquip(5, 1, 3, "info", 32)
			event.LoadEquip(5, 1, 2, "info", 32, 37)
			event.LoadMotion(5, "event/time_gate/blue/c02a_warp.gltf", "info", 32)
			event.CharaActive(37)
			event.EohSyncChara(5, 37)
			event.CharaActive(0)
			event.EohSyncChara(1, 0)
		end
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.ObjsSetPos(0, 3.19, 0.0, -55.28)
		event.ObjsSetRot(0, 0.0, 0.0, 0.0)
		event.ObjsSetMotion(0, "立ち", 4, 0.02)
		event.ObjsResetDaPosition(0)
		event.ObjsTexAnime(0, 0)
		event.EohSetPos(1, -23.79, 0.0, -39.77)
		event.EohSetRot(1, 0.0, 0.64, 0.0)
		event.EohSetMotion(1, "立ち", 0.02)
	else
		event.GetEquipItemno(1, 2)
		event.GetEquipItemno(1, 3)
		event.GetEquipItemno(1, 4)
		event.LoadMotion(5, "event/time_gate/blue/c02a_warp.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.ObjsSetPos(0, 3.19, 0.0, -55.28)
		event.ObjsSetRot(0, 0.0, 0.0, 0.0)
		event.ObjsSetMotion(0, "立ち", 4, 0.02)
		event.ObjsResetDaPosition(0)
		event.ObjsTexAnime(0, 0)
	end
	flag = event.GetFlag(612) or flag
	if flag ~= 0 then
		var12 = event.SndLoadSound(8, "snd2/sp/sp_043.sound.json") or var12
	else
		var13 = event.SndLoadSound(8, "snd2/sp/sp_013.sound.json") or var13
	end
	if arg4 == 0 then
		event.SetLoadbgFile("event/time_gate/blue/atora_shine2.gltf", "event/time_gate/blue/atora_glare2.gltf")
	else
		event.SetLoadbgFile("event/time_gate/red/atora_shine2.chr", "event/time_gate/red/atora_glare2.chr")
	end
	event.ObjsSetMotion(0, "立ち", 4)
	event.ObjsSetPos(0, 0.0, 0.0, 0.0)
	event.ObjsResetDaPosition(0)
	if flag ~= 0 then
		event.SndSePlay(var12, 0)
	else
		event.SndSePlay(var13, 0)
		helper_440(20)
		if vm.skipping() then
			return skip(3)
		end
	end
	event.SetFadeIn(30)
	if flag ~= 0 then
		event.CmrsSetPos(21.59, 19.4, 49.13)
		event.CmrsSetRef(3.27, 21.44, 1.91)
	else
		event.CmrsSetPos(-1.62, 25.82, 35.3)
		event.CmrsSetRef(-0.26, 22.33, -0.02)
	end
	event.ObjsSetMotion(0, "タイムワープ", 6)
	event.ObjsNextMotion(0, "タイムワープL", 5)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "目を閉じる")
	event.ObjsTexAnime(0, 1, "すまし口")
	helper_29b0(0)
	if vm.skipping() then
		return skip(4)
	end
	helper_1048()
	if vm.skipping() then
		return skip(5)
	end
	if arg4 == 0 then
		event.LoadChara(5, "event/time_gate/blue/atora_shine2.gltf", "info", 38)
	else
		event.LoadChara(5, "event/time_gate/red/atora_shine2.chr", "info", 38)
	end
	if flag ~= 0 then
		event.CharaActive(0, 38)
	else
		event.CharaActive(1, 38)
	end
	event.SetCharaType(38, 4)
	event.EohSyncChara(6, 38)
	event.ObjsInit(6)
	event.ObjsSyncObj(6, 6)
	do
		local out1, out2, out3 = event.EohGetFramePos(0, "atoramiria")
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	event.ObjsSetPos(6, pos_x + vm.f32(0.18), pos_y + vm.f32(0.02), pos_z + vm.f32(0.3))
	event.ObjsSetRot(6, 0.0, 0.0, 0.0)
	var17 = event.GetEquipItemno(1, 4) or var17
	if var17 == 263 then
		print("pumpkin---------------------------\n")
		event.ObjsSetPos(6, -0.35, 22.68, 1.67)
		event.ObjsSetRot(6, 0.0, -6.33, 0.0)
	end
	if var17 == 264 then
		print("stripte -----------------------------\n")
		event.ObjsSetPos(6, -0.48, 22.78, 2.07)
		event.ObjsSetRot(6, 0.0, -6.4, 0.0)
	end
	if var17 == 265 then
		event.ObjsSetPos(6, -0.33, 22.73, 1.95)
		event.ObjsSetRot(6, 0.0, -6.4, 0.0)
	end
	if var17 == 266 then
		print("princess-----------------------------\n")
		event.ObjsSetPos(6, -0.42, 22.89, 1.99)
		event.ObjsSetRot(6, 0.0, -6.4, 0.0)
	end
	if var17 == 267 then
		print("separate----------------------------\n")
		event.ObjsSetPos(6, -0.23, 23.26, 2.52)
		event.ObjsSetRot(6, 0.0, -6.4, 0.0)
	end
	event.ObjsSetMotion(0, "タイムワープL", 5)
	event.ObjsSetMotion(6, "発動", 6)
	event.ObjsNextMotion(6, "発動L", 4)
	event.ObjsTexAnime(0, 0, "目を閉じる")
	event.ObjsTexAnime(0, 1, "閉じたまま")
	event.ObjsTexAnime(0, 1, "すまし口")
	if flag ~= 0 then
		event.SndSePlay(var12, 2)
	end
	helper_29b0(6)
	if vm.skipping() then
		return skip(6)
	end
	if arg4 == 0 then
		event.LoadChara(5, "event/time_gate/blue/atora_glare2.gltf", "info", 39)
	else
		event.LoadChara(5, "event/time_gate/red/atora_glare2.chr", "info", 39)
	end
	event.CharaActive(39)
	event.SetCharaType(39, 4)
	event.EohSyncChara(7, 39)
	event.ObjsInit(7)
	event.ObjsSyncObj(7, 7)
	event.ObjsSetPos(7, 0.0, 0.88, 0.0)
	event.ObjsSetRot(7, 0.0, 0.0, 0.0)
	event.CmrsSetPos(-2.99, 25.82, 71.15)
	event.CmrsSetRef(-0.26, 22.33, 0.02)
	event.CmrsMove2(-7.1, 25.8, 178.24, -0.26, 45.36, 0.02, 90, 0, 0.4)
	event.ObjsSetScale(3, 2.8, 2.8, 2.8, 90)
	event.ObjsSetScale(4, 2.0, 2.0, 2.0, 90)
	event.ObjsSetScale(7, 2.0, 2.0, 2.0, 90)
	helper_440(60)
	if vm.skipping() then
		return skip(7)
	end
	event.SetFadeOut(60, 255.0, 255.0, 255.0)
	helper_440(60)
	if vm.skipping() then
		return skip(8)
	end
	helper_142ac(0)
	if vm.skipping() then
		return skip(9)
	end
	return part2()
end

--- Helper function.
local function helper_130f0(arg0: f32, arg1: f32, arg2: f32, arg3: f32)
	local var7: s32 = 0
	local now_party_chara_id: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 7 then
			if at <= 1 then
				helper_440(30)
			end
			if at <= 2 then
				helper_28a0()
			end
			if at <= 3 then
				helper_29b0(0)
			end
			if at <= 4 then
				helper_6010(5220010)
			end
			if at <= 5 then
				helper_6010(5220015)
			end
			if at <= 6 then
				helper_440(30)
			end
			if vm.skip_end() then
				return skip(8)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SndSeStop(var7, 0)
		event.DelExtMotion(0)
		event.DeleteChara(33)
		event.DeleteChara(34)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFlag(522, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	var7 = event.SndLoadSound(8, "snd2/sp/sp_043.sound.json") or var7
	event.AssignStack(5)
	event.ClearStack(5)
	event.SetWorldCoord(arg0, arg1, arg2, arg3)
	event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 0)
	event.LoadMotion(5, "event/e500/e522/e522_mints.gltf", "info", 0)
	event.CharaActive(1, 0)
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetMotion(0, "立ち", 0)
	now_party_chara_id = event.GetNowPartyChara() or now_party_chara_id
	if now_party_chara_id ~= -1 then
		event.LoadCharaNpc(0, 5, now_party_chara_id, 33)
		event.CharaActive(0, 33)
		event.EohSyncChara(1, 33)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.LoadChara(5, "event/time_gate/blue/atora_shine2.gltf", "info", 34)
	event.CharaActive(0, 34)
	event.SetCharaType(34, 4)
	event.EohSyncChara(2, 34)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.LoadMes(0, 5, "event/e500/e522/e522.txt")
	event.SetFadeOut(30)
	helper_440(30)
	if vm.skipping() then
		return skip(2)
	end
	event.SetFadeIn(30)
	event.SndSePlay(var7, 0)
	event.InitDramaScene()
	event.CharaActive(1, 33)
	event.CmrsSetPos(5.32, 62.92, -97.07)
	event.CmrsSetRef(11.48, 61.6, -39.43)
	event.ObjsSetPos(0, 39.64, -0.0, 9.33)
	event.ObjsSetRot(0, 0.0, -2.33, 0.0)
	event.ObjsSetPos(1, 34.65, 0.0, 29.92)
	event.ObjsSetRot(1, 0.0, -2.36, 0.0)
	event.ObjsSetMotion(0, "上向く", 6)
	event.ObjsNextMotion(0, "上向くL", 0)
	event.CmrsMove2(5.32, 24.78, -97.07, 11.48, 29.98, -39.43, 90, 2, 0.4)
	helper_28a0()
	if vm.skipping() then
		return skip(3)
	end
	event.CharaActive(0, 33)
	event.CmrsSetPos(25.53, 21.33, -15.17)
	event.CmrsSetRef(32.72, 21.29, -3.29)
	event.ObjsSetRot(0, 0.0, -2.69, 0.0)
	event.CharaDaEnable(0, 0)
	event.CharaActive(1, 34)
	event.EohGetFramePos(0, "atoramiria")
	event.SetReference(0, "atoramiria", 34)
	event.SetCharaPos(34, 0.04, -1.42988, 0.89)
	event.ObjsSeDelay(2, 25)
	event.ObjsSePlay(2, var7, 1)
	event.ObjsSetMotion(2, "発動", 6)
	event.ObjsNextMotion(2, "発動L", 0)
	event.ObjsSetMotion(0, "アトラ見る", 6)
	event.ObjsNextMotion(0, "アトラ見るL", 0)
	helper_29b0(0)
	if vm.skipping() then
		return skip(4)
	end
	event.ObjsSetMotion(0, "アトラさわる", 6)
	event.ObjsNextMotion(0, "アトラさわるL", 6)
	helper_6010(5220010)
	if vm.skipping() then
		return skip(5)
	end
	helper_6010(5220015)
	if vm.skipping() then
		return skip(6)
	end
	event.SetFadeOut(30)
	helper_440(30)
	if vm.skipping() then
		return skip(7)
	end
	return part2()
end

--- Helper function.
local function helper_14814(arg0: f32, arg1: f32, arg2: f32, arg3: f32, arg4: s32, arg5: s32)
	local flag: s32 = 0
	local now_party_chara_id: s32 = 0
	local active_chr_no: s32 = 0
	local var12: s32 = 0
	local var13: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 10 then
			if at <= 1 then
				helper_28a0()
			end
			if at <= 2 then
				helper_1048()
			end
			if at <= 3 then
				helper_440(30)
			end
			if at <= 4 then
				helper_29b0(0)
			end
			if at <= 5 then
				helper_1048()
			end
			if at <= 6 then
				helper_29b0(6)
			end
			if at <= 7 then
				helper_440(60)
			end
			if at <= 8 then
				helper_440(60)
			end
			if at <= 9 then
				helper_142ac(1)
			end
			if vm.skip_end() then
				return skip(11)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		if flag ~= 0 then
			event.SndSeStop(var12, 0)
		else
			event.SndSeStop(var13, 0)
		end
		event.FadeOutBgm(30)
		active_chr_no = event.GetActiveChrNo() or active_chr_no
		if active_chr_no == 0 then
			event.DelExtMotion(0)
			event.DeleteChara(33)
		end
		if active_chr_no == 1 then
			event.DeleteChara(32)
		end
		now_party_chara_id = event.GetNowPartyChara() or now_party_chara_id
		if now_party_chara_id ~= -1 then
			event.DeleteChara(34)
		end
		event.DeleteChara(35)
		event.DeleteChara(36)
		event.DeleteChara(37)
		event.DeleteChara(38)
		event.DeleteChara(39)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	flag = event.GetFlag(612) or flag
	event.SetMotion(0, "立ち")
	if arg4 ~= 0 then
		event.SetLoadbgFile("event/time_gate/red/tg_maru_red.gltf", "event/time_gate/red/tg_sita_red.gltf")
	else
		event.SetLoadbgFile("event/time_gate/blue/tg_maru_blue.gltf", "event/time_gate/blue/tg_sita_blue.gltf")
	end
	event.CmrsInit()
	event.CmrsFadeInit()
	event.CmrsFadeOut(30)
	helper_28a0()
	if vm.skipping() then
		return skip(2)
	end
	helper_1048()
	if vm.skipping() then
		return skip(3)
	end
	event.InitDramaScene()
	event.SetSkipBotton(20)
	event.SetSkipFcol(255.0, 255.0, 255.0)
	event.SetWorldCoord(arg0, arg1, arg2, arg3)
	event.SetCharaShow(120, 0)
	event.SetCharaShow(121, 0)
	event.AssignStack(5)
	event.ClearStack(5)
	if arg4 ~= 0 then
		event.LoadChara(5, "event/time_gate/red/tg_maru_red.gltf", "info", 35)
		event.LoadChara(5, "event/time_gate/red/tg_sita_red.gltf", "info2", 36)
	else
		event.LoadChara(5, "event/time_gate/blue/tg_maru_blue.gltf", "info", 35)
		event.LoadChara(5, "event/time_gate/blue/tg_sita_blue.gltf", "info2", 36)
	end
	event.CharaActive(35)
	event.SetCharaType(35, 4)
	event.EohSyncChara(3, 35)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.ObjsSetPos(3, 0.0, 70.0, 0.0)
	event.ObjsSetRot(3, 0.0, 0.0, 0.0)
	event.CharaActive(36)
	event.SetCharaType(36, 4)
	event.EohSyncChara(4, 36)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.ObjsSetPos(4, 0.0, 0.0, 0.0)
	event.ObjsSetRot(4, 0.0, 0.0, 0.0)
	now_party_chara_id = event.GetNowPartyChara() or now_party_chara_id
	if now_party_chara_id ~= -1 then
		event.LoadCharaNpc(0, 5, now_party_chara_id, 34)
		event.CharaActive(34)
		event.EohSyncChara(2, 34)
		event.EohSetPos(2, 49.73999, 0.0, 8.969971)
		event.EohSetRot(2, 0.0, -1.76, 0.0)
	end
	if arg5 ~= 0 then
		active_chr_no = event.GetActiveChrNo() or active_chr_no
		if active_chr_no == 0 then
			event.GetEquipItemno(1, 2)
			event.GetEquipItemno(1, 3)
			event.GetEquipItemno(1, 4)
		end
		if active_chr_no == 1 then
			event.GetEquipItemno(0, 2)
			event.GetEquipItemno(0, 3)
			event.GetEquipItemno(0, 4)
		end
		if active_chr_no == 0 then
			if flag ~= 0 then
				event.LoadMotion(5, "event/e00/e80/e80_mints.gltf", "info", 0)
			else
				event.LoadMotion(5, "event/time_gate/red/c01b_warp.gltf", "info", 0)
			end
			event.CharaActive(0)
			event.EohSyncChara(0, 0)
			event.LoadChara(5, "chara/c02_base.gltf", "info", 33)
			event.CharaActive(33)
			event.EohSyncChara(1, 33)
			event.LoadEquip(5, 1, 4, "info", 33)
			event.LoadEquip(5, 1, 3, "info", 33)
			event.LoadEquip(5, 1, 2, "info", 33, 37)
			event.CharaActive(37)
			event.EohSyncChara(5, 37)
			event.EohSetShow(5, 1)
		end
		if active_chr_no == 1 then
			event.LoadChara(5, "chara/c01_base.gltf", "info", 32)
			if flag ~= 0 then
				event.LoadMotion(5, "event/e00/e80/e80_mints.gltf", "info", 32)
			else
				event.LoadMotion(5, "event/time_gate/red/c01b_warp.gltf", "info", 32)
			end
			event.CharaActive(32)
			event.EohSyncChara(0, 32)
			event.LoadEquip(5, 0, 4, "info", 32)
			event.LoadEquip(5, 0, 3, "info", 32)
			event.LoadEquip(5, 0, 2, "info", 32, 37)
			event.CharaActive(37)
			event.EohSyncChara(5, 37)
			event.EohSetShow(5, 1)
			event.CharaActive(0)
			event.EohSyncChara(1, 0)
		end
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.ObjsSetPos(0, 38.0, 0.0, 22.0)
		event.ObjsSetRot(0, 0.0, -2.12, 0.0)
		event.ObjsSetMotion(0, "立ち", 4)
		event.ObjsTexAnime(0, 0)
		event.EohSetPos(1, 18.619995, 0.0, 35.179993)
		event.EohSetRot(1, 0.0, -2.48, 0.0)
		event.EohSetMotion(1, "立ち", 0.02)
		event.EohResetDaPosition(1)
	else
		event.GetEquipItemno(1, 2)
		event.GetEquipItemno(1, 3)
		event.GetEquipItemno(1, 4)
		event.LoadMotion(5, "event/time_gate/red/c01b_warp.gltf", "info", 0)
		event.LoadMotion(5, "event/e500/e523/e523_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.ObjsSetPos(0, 38.0, 0.0, 22.0)
		event.ObjsSetRot(0, 0.0, -2.12, 0.0)
		event.ObjsSetMotion(0, "立ち", 4)
		event.ObjsTexAnime(0, 0)
	end
	if flag ~= 0 then
		var12 = event.SndLoadSound(8, "snd2/sp/sp_043.sound.json") or var12
	else
		var13 = event.SndLoadSound(8, "snd2/sp/sp_013.sound.json") or var13
	end
	if arg4 ~= 0 then
		event.SetLoadbgFile("event/time_gate/red/atora_shine.gltf", "event/time_gate/red/atora_glare.gltf")
	else
		event.SetLoadbgFile("event/time_gate/blue/atora_shine2.gltf", "event/time_gate/blue/atora_glare2.gltf")
	end
	event.ObjsSetPos(0, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(0, "旧・立ち", 4)
	event.ObjsResetDaPosition(0)
	if flag ~= 0 then
		event.SndSePlay(var12, 0)
	else
		event.SndSePlay(var13, 0)
		helper_440(30)
		if vm.skipping() then
			return skip(4)
		end
	end
	event.SetFadeIn(30)
	if flag ~= 0 then
		event.CmrsSetPos(-56.29, 15.74, 3.56)
		event.CmrsSetRef(-12.65, 16.48, 2.06)
	else
		event.CmrsSetPos(-48.179993, 19.61, -28.70996)
		event.CmrsSetRef(-0.789978, 16.48, -0.05999756)
	end
	if arg5 == 0 and arg4 == 0 and flag == 0 then
		event.CmrsSetPos(-30.09, 19.5, 4.41)
		event.CmrsSetRef(-14.63, 21.71, 1.0)
	end
	event.ObjsSetMotion(0, "タイムワープ", 6, 0.45)
	event.ObjsNextMotion(0, "タイムワープL", 4)
	event.ObjsTexAnime(0, 1, "開閉口")
	helper_29b0(0)
	if vm.skipping() then
		return skip(5)
	end
	helper_1048()
	if vm.skipping() then
		return skip(6)
	end
	if arg4 ~= 0 then
		event.LoadChara(5, "event/time_gate/red/atora_shine.gltf", "info", 38)
	else
		event.LoadChara(5, "event/time_gate/blue/atora_shine2.gltf", "info", 38)
	end
	if flag ~= 0 then
		event.CharaActive(0, 38)
	else
		event.CharaActive(1, 38)
	end
	event.EohSyncChara(6, 38)
	event.ObjsInit(6)
	event.ObjsSyncObj(6, 6)
	do
		local out1, out2, out3 = event.EohGetFramePos(0, "atoramiria")
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	if arg4 ~= 0 then
		event.ObjsSetPos(6, pos_x, pos_y, pos_z)
	else
		event.ObjsSetPos(6, -3.54, 17.04, -1.46)
	end
	event.ObjsSetRot(6, -0.45, -2.12, 0.0)
	event.CmrsSetPos(-21.5, 23.92, -12.580017)
	event.CmrsSetRef(-0.789978, 16.17, -0.05999756)
	event.ObjsTexAnime(0, 0, "開閉口")
	event.ObjsTexAnime(0, 1, "開き口")
	event.ObjsSetMotion(0, "タイムワープL", 5)
	event.ObjsSetMotion(6, "発動", 6)
	event.ObjsNextMotion(6, "発動L", 4)
	if flag == 0 then
		helper_29b0(6)
		if vm.skipping() then
			return skip(7)
		end
	else
		event.SndSePlay(var12, 2)
	end
	if arg4 ~= 0 then
		event.LoadChara(5, "event/time_gate/red/atora_glare.gltf", "info", 39)
	else
		event.LoadChara(5, "event/time_gate/red/atora_glare.gltf", "info", 39)
	end
	event.CharaActive(39)
	event.EohSyncChara(7, 39)
	event.ObjsInit(7)
	event.ObjsSyncObj(7, 7)
	event.ObjsSetPos(7, 0.0, 0.0, 0.0)
	event.ObjsSetRot(7, 0.0, -2.12, 0.0)
	event.CmrsSetPos(-40.590027, 19.47, -24.339966)
	event.CmrsSetRef(13.950012, 15.23, 9.190002)
	event.CmrsMove2(-128.31, 19.47, -78.22998, 13.950012, 48.35, 9.190002, 90, 0, 0.4)
	event.ObjsSetScale(3, 2.8, 2.8, 2.8, 90)
	event.ObjsSetScale(4, 2.0, 2.0, 2.0, 90)
	event.ObjsSetScale(7, 2.0, 2.0, 2.0, 90)
	helper_440(60)
	if vm.skipping() then
		return skip(8)
	end
	event.SetFadeOut(60, 255.0, 255.0, 255.0)
	helper_440(60)
	if vm.skipping() then
		return skip(9)
	end
	helper_142ac(1)
	if vm.skipping() then
		return skip(10)
	end
	return part2()
end

--- Helper function.
local function helper_1b508(arg0: f32, arg1: f32, arg2: f32, arg3: f32)
	local member: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	local landing1: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_130f0(arg0, arg1, arg2, arg3)
			if not vm.skipping() then
				return landing1()
			end
		end
		if at <= 2 then
			helper_14814(arg0, arg1, arg2, arg3, 0, 0)
			if not vm.skipping() then
				return part2()
			end
		end
	end
	function part2()
		event.SetWorldCoord(0.0, 0.0, 0.0, 0.0)
	end
	function landing1()
		helper_14814(arg0, arg1, arg2, arg3, 0, 0)
		if vm.skipping() then
			return skip(3)
		end
		return part2()
	end
	member = event.JoinPartyMember(1) or member
	if member == 1 then
		helper_17c28(arg0, arg1, arg2, arg3, 0, 1)
		if vm.skipping() then
			return skip(1)
		end
	else
		flag = event.GetFlag(520) or flag
		flag_2 = event.GetFlag(532) or flag_2
		if flag ~= 0 and flag_2 == 0 then
			flag_3 = event.GetFlag(522) or flag_3
			if flag_3 == 0 then
				helper_130f0(arg0, arg1, arg2, arg3)
				if vm.skipping() then
					return skip(2)
				end
			end
		end
		helper_14814(arg0, arg1, arg2, arg3, 0, 0)
		if vm.skipping() then
			return skip(3)
		end
	end
	return part2()
end

--- Helper function.
local function helper_6ab0(arg0: s32)
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
local function helper_67f0(arg0: s32)
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
local function helper_6c08(arg0: s32, arg1: any, arg2: any, arg3: s32)
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
				helper_6ab0(arg0)
			end
			if at <= 2 then
				var8 = 0
				var7 = helper_67f0(arg0)
				var8 = -1
				var8 = 1
				var6 = var7
				var8 = -1
				var8 = 1
				var8 = -1
				var8 = 1
			end
			helper_2d9c(arg0)
			return -1
		end
		helper_2d9c(arg0)
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
	helper_6ab0(arg0)
	if vm.skipping() then
		return skip(2)
	end
	while true do
		var8 = 0
		var7 = helper_67f0(arg0)
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
					helper_2d9c(arg0)
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
	helper_2d9c(arg0)
	return arg2
end

--- Helper function.
local function helper_7920(arg0: s32, arg1: any, arg2: s32, arg3: s32, arg4: s32, arg5: s32, arg6: s32)
	local var8: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		return var8
	end
	local _ = helper_2b58(arg0, arg1, arg2, arg3, arg4)
	var8 = helper_6c08(arg0, arg5, arg6, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPos(arg0, 0)
	return var8
end

--- Helper function.
local function helper_2a974()
	local var0: s32 = 0
	local var1: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		helper_2d9c(1)
		return -1
	end
	var0 = event.GetCnt(14) or var0
	event.SetMesWindowMode(1, 4)
	event.MesMake_2(1, "エレベーターのボタンがある。")
	helper_2b58(1, -1, 5, 0, 0)
	event.SetMesWindowMode(0, 4)
	event.SetMesQuestionGyou(0, 0)
	event.SetMesEtc(0, 0, 1)
	event.SetMesEtc(0, 1, 1)
	event.SetMesEtc(0, 5, var0, 2)
	event.MesMake_2(0, "１階\n２階\n３階")
	var1 = helper_7920(0, -1, 8, 0, 0, 3, var0)
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesEtc(0, 0, 0)
	event.SetMesEtc(0, 1, 0)
	event.SetMesEtc(0, 5, var0, -1)
	helper_2d9c(1)
	if var1 < 0 or var1 == var0 then
		return -1
	else
		event.SetCnt(14, var1)
		return var1
	end
end

--- Helper function.
local function helper_2a810()
	local flag: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	local landing1: () -> ...any
	function skip(at: number)
		if at <= 1 then
			local _ = helper_1b84c()
			helper_1c2f4()
			if not vm.skipping() then
				return landing1()
			end
		end
		return 1
	end
	function part2()
		return 0
	end
	function landing1()
		return 1
	end
	if vm.skipping() then
		return skip(1)
	end
	flag = event.GetFlag(508) or flag
	if helper_1b84c() ~= 0 and flag == 0 then
		event.AddItem(372, 1)
		helper_1c2f4()
		if vm.skipping() then
			return skip(2)
		end
		return 1
	end
	return part2()
end

--- Helper function.
local function helper_2c0fc(arg0: s32)
	local var1: s32 = 0
	local var2: s32 = 0
	local var3: any = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
		if at <= 2 then
			helper_440(30)
		end
		if at <= 3 then
			helper_440(15)
		end
		if at <= 4 then
			helper_190c(vm.f32(-2079.4), 6.0, vm.f32(5052.4), vm.f32(2.16))
			helper_190c(vm.f32(2011.1), 6.0, 5158.5, vm.f32(-2.23))
			helper_190c(286.5, 6.0, vm.f32(-22.3), vm.f32(-0.16))
			helper_190c(vm.f32(-228.6), 6.0, vm.f32(5828.1), vm.f32(-0.02))
		end
	end
	var1 = helper_1badc()
	event.Initialize()
	event.SetMotion(0, "立ち")
	event.SetMesWindowMode(0, 4)
	event.SetMesQuestionGyou(0, 1)
	event.SetMesEtc(0, 0, 1)
	event.SetMesEtc(0, 1, 1)
	if var1 ~= 0 then
		event.MesMake_2(
			0,
			"転送ゲートの行き先を選択\n転送ゲート・北\n転送ゲート・東\n転送ゲート・西\nタイムゲート前\nパズノス・ブリッジ"
		)
		var2 = 5
	else
		event.MesMake_2(
			0,
			"転送ゲートの行き先を選択\n転送ゲート・北\n転送ゲート・東\n転送ゲート・西\nタイムゲート前"
		)
		var2 = 4
	end
	var3 = helper_7920(0, -1, 8, 0, 0, var2, vm.i32(arg0 + 1))
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesQuestionGyou(0, 0)
	event.SetMesEtc(0, 0, 0)
	event.SetMesEtc(0, 1, 0)
	if var3 == -1 then
		return
	end
	if vm.wrap(var3 - 1) == arg0 then
		return
	end
	event.AssignStack(5)
	event.ClearStack(5)
	event.EsmInitialize(5)
	event.EsmLoadBase("サンワープ２")
	event.EsmInitFix(5)
	event.EsmCreate("サンワープ２")
	do
		local out1, out2, out3 = event.GetCharaPos(0)
		var4 = out1 or var4
		var5 = out2 or var5
		var6 = out3 or var6
	end
	event.EsmSetVect1(var4, var5, var6)
	var7 = event.GetSndId(2) or var7
	event.SndSePlay(var7, 120)
	helper_440(15)
	if vm.skipping() then
		return skip(2)
	end
	event.SetCharaShow(0, 0, 1, 0.05)
	event.SetCharaShow(1, 0, 1, 0.05)
	event.SetCharaShow(2, 0, 1, 0.05)
	event.SetCharaShow(3, 0, 1, 0.05)
	helper_440(30)
	if vm.skipping() then
		return skip(3)
	end
	event.SetFadeOut(15)
	helper_440(15)
	if vm.skipping() then
		return skip(4)
	end
	event.EsmClear()
	event.SetCharaShow(0, 1)
	event.SetCharaShow(1, 1)
	event.SetCharaShow(2, 1)
	event.SetCharaShow(3, 1)
	if vm.wrap(var3 - 1) == 1 then
		helper_190c(vm.f32(-2079.4), 6.0, vm.f32(5052.4), vm.f32(2.16))
	end
	if vm.wrap(var3 - 1) == 2 then
		helper_190c(vm.f32(2011.1), 6.0, 5158.5, vm.f32(-2.23))
	end
	if vm.wrap(var3 - 1) == 3 then
		helper_190c(286.5, 6.0, vm.f32(-22.3), vm.f32(-0.16))
	end
	if vm.wrap(var3 - 1) == 0 then
		helper_190c(vm.f32(-228.6), 6.0, vm.f32(5828.1), vm.f32(-0.02))
	end
	if vm.wrap(var3 - 1) == 4 then
		event.MapJump(-1, "s30")
		if vm.wait() then
			return skip(5)
		end
		return
	end
	event.ResetCamera(1, 3.1415927)
	event.SetFadeIn(15)
end

--- Helper function.
local function helper_2b9a8()
	local var0: any = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
		if at <= 2 then
			helper_440(30)
		end
		if at <= 3 then
			helper_440(15)
		end
	end
	event.Initialize()
	event.SetMotion(0, "立ち")
	event.SetMesWindowMode(0, 5)
	event.MesMake_2(0, "パズノス・ブリッジへ移動しますか？")
	var0 = helper_7920(0, -1, 8, 256, 208, 2, 1)
	if vm.skipping() then
		return skip(1)
	end
	if var0 ~= 0 then
		return
	end
	event.AssignStack(5)
	event.ClearStack(5)
	event.EsmInitialize(5)
	event.EsmLoadBase("サンワープ２")
	event.EsmInitFix(5)
	event.EsmCreate("サンワープ２")
	do
		local out1, out2, out3 = event.GetCharaPos(0)
		var1 = out1 or var1
		var2 = out2 or var2
		var3 = out3 or var3
	end
	event.EsmSetVect1(var1, var2, var3)
	var4 = event.GetSndId(2) or var4
	event.SndSePlay(var4, 120)
	helper_440(15)
	if vm.skipping() then
		return skip(2)
	end
	event.SetCharaShow(0, 0, 1, 0.05)
	event.SetCharaShow(1, 0, 1, 0.05)
	event.SetCharaShow(2, 0, 1, 0.05)
	event.SetCharaShow(3, 0, 1, 0.05)
	helper_440(30)
	if vm.skipping() then
		return skip(3)
	end
	event.SetFadeOut(15)
	helper_440(15)
	if vm.skipping() then
		return skip(4)
	end
	event.EsmClear()
	event.SetCharaShow(0, 1)
	event.SetCharaShow(1, 1)
	event.SetCharaShow(2, 1)
	event.SetCharaShow(3, 1)
	event.MapJump(-1, "s30")
	if vm.wait() then
		return skip(5)
	end
end

--- Helper function.
local function helper_251d0()
	local var6: s32 = 0
	local var7: f32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 10 then
			if at <= 1 then
				helper_28a0()
			end
			if at <= 2 then
				helper_440(4)
			end
			if at <= 3 then
				helper_440(10)
			end
			if at <= 4 then
				helper_440(30)
			end
			if at <= 5 then
				helper_440(4)
			end
			if at <= 6 then
				helper_440(10)
			end
			if at <= 7 then
				helper_440(30)
			end
			if at <= 8 then
				var6 = 0
				var7 = vm.f32(0.02)
				var6 = var6 + 1
			end
			if at <= 9 then
				var7 = vm.f32(var7 * vm.f32(1.2))
				helper_440(2)
			end
			if vm.skip_end() then
				return skip(11)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SetProjection(524.9)
		event.CharaActive(0)
		event.DeleteChara(32)
		event.DeleteChara(33)
		event.DeleteChara(34)
		event.DeleteChara(35)
		event.DeleteChara(36)
		event.DeleteChara(37)
	end
	event.SetFlag(540, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.StopBgm(0)
	helper_440(4)
	if vm.skipping() then
		return skip(1)
	end
	event.LoadBgm(116)
	event.PlayBgm(0)
	event.AssignStack(5)
	event.ClearStack(5)
	event.CharaActive(0, 0)
	event.ChangeDir("event/e500/e540/")
	event.LoadChara(5, "e540_jet.gltf", "info", 32)
	event.CharaActive(0, 32)
	event.CopyChara(5, 32, 33)
	event.CharaActive(0, 33)
	event.LoadChara(5, "e540_parm1.gltf", "info", 34)
	event.CharaActive(1, 34)
	event.LoadChara(5, "e540_parm2.gltf", "info", 35)
	event.CharaActive(1, 35)
	event.LoadChara(5, "e540_parm3.gltf", "info", 36)
	event.CharaActive(1, 36)
	event.LoadChara(5, "e540_parm4.gltf", "info", 37)
	event.CharaActive(1, 37)
	event.ChangeDir("")
	event.EohSyncObj(0, "p10_f0401")
	event.EohSetShow(0, 0)
	event.EohSyncObj(0, "p20_f0401")
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.EohSyncObj(1, "p22_f0401", "f0401_27-m-0")
	event.EohSetShow(1, 0)
	event.EohSyncObj(1, "p22_f0401", "f0401_27-m-1")
	event.EohSetShow(1, 0)
	event.EohSyncObj(1, "p22_f0401", "f0401_25-m")
	event.EohSetShow(1, 0)
	event.EohSyncObj(1, "p22_f0401")
	event.EohGetFramePos(1, "e540_parm1")
	event.SetCharaPos(34, -2400.0, 1700.0, 2600.0)
	event.SetCharaRot(34, 0.0, 1.6, 0.0)
	event.SetMotion(34, "射出1", 5)
	event.EohSyncObj(1, "p22_f0401")
	event.EohGetFramePos(1, "e540_parm2")
	event.SetCharaPos(35, -2100.0, 1700.0, 5300.0)
	event.SetCharaRot(35, 0.0, 2.4, 0.0)
	event.SetMotion(35, "射出1", 5)
	event.EohSyncObj(1, "p22_f0401")
	event.EohGetFramePos(1, "e540_parm3")
	event.SetCharaPos(36, 2200.0, 1700.0, 5300.0)
	event.SetCharaRot(36, 0.0, -2.4, 0.0)
	event.SetMotion(36, "射出1", 5)
	event.EohSyncObj(1, "p22_f0401")
	event.EohGetFramePos(1, "e540_parm4")
	event.SetCharaPos(37, 2400.0, 1700.0, 2600.0)
	event.SetCharaRot(37, 0.0, -1.6, 0.0)
	event.SetMotion(37, "射出1", 5)
	event.SetCharaPos(32, -930.0, 750.0, 2330.0)
	event.SetCharaPos(33, 930.0, 750.0, 2330.0)
	event.InitDramaScene()
	event.SetProjection(524.9)
	event.CmrsInit()
	event.CmrsSetPos(0.0, 2449.87, -2065.79)
	event.CmrsSetRef(0.0, 2430.55, -2020.14)
	event.CmrsMove2(0.0, 2785.4, -2065.79, 0.0, 2787.08, -2020.14, 120, 2, 1.0)
	event.SetFadeIn(10)
	helper_28a0()
	if vm.skipping() then
		return skip(2)
	end
	event.CmrsSetPos(-2108.31, 1992.04, 1136.27)
	event.CmrsSetRef(-2039.71, 1945.46, 1320.75)
	helper_440(4)
	if vm.skipping() then
		return skip(3)
	end
	event.SetMotion(34, "射出1", 6)
	helper_440(10)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(35, "射出1", 6)
	helper_440(30)
	if vm.skipping() then
		return skip(5)
	end
	event.CmrsSetPos(1955.54, 2093.16, 785.71)
	event.CmrsSetRef(1839.34, 1936.52, 1240.3)
	helper_440(4)
	if vm.skipping() then
		return skip(6)
	end
	event.SetMotion(37, "射出1", 6)
	helper_440(10)
	if vm.skipping() then
		return skip(7)
	end
	event.SetMotion(36, "射出1", 6)
	helper_440(30)
	if vm.skipping() then
		return skip(8)
	end
	event.CmrsSetPos(1709.28, 50.66, -919.25)
	event.CmrsSetRef(1370.18, 511.19, 109.87)
	event.SetProjection(390.0)
	event.CharaActive(1, 32)
	event.CharaActive(1, 33)
	event.SetCharaShow(32, 1, 1, 0.016666668)
	event.SetCharaShow(33, 1, 1, 0.016666668)
	var6 = 0
	var7 = vm.f32(0.02)
	while var6 < 120 do
		var6 = var6 + 1
		if vm.wait() then
			return skip(9)
		end
		if vm.imod(var6, 4) == 0 then
			event.CmrsInit()
			event.CmrsQuake(0.0, var7, 0.0, -1)
			var7 = vm.f32(var7 * vm.f32(1.2))
		end
		if var6 == 110 then
			event.SetFadeOut(10)
		end
	end
	helper_440(2)
	if vm.skipping() then
		return skip(10)
	end
	return part2()
end

--- Helper function.
local function helper_26bd8()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_29b0(0)
			end
			if at <= 2 then
				helper_440(10)
			end
			if vm.skip_end() then
				return skip(4)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.CharaActive(0)
		event.DeleteChara(32)
		event.DeleteChara(33)
	end
	event.SetFlag(540, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.AssignStack(5)
	event.ClearStack(5)
	event.CharaActive(0, 0)
	event.ChangeDir("event/e500/e540/")
	event.LoadChara(5, "e540_jet.gltf", "info", 32)
	event.CharaActive(32)
	event.SetCharaType(32, 4)
	event.EohSyncChara(3, 32)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.CopyChara(5, 32, 33)
	event.CharaActive(33)
	event.SetCharaType(33, 4)
	event.EohSyncChara(4, 33)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.ChangeDir("")
	event.EohSyncObj(0, "p10_f0401")
	event.EohSetShow(0, 0)
	event.EohSyncObj(0, "p20_f0401")
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.EohSyncObj(1, "p11_f0401")
	event.EohSetShow(1, 0)
	event.EohSyncObj(2, "p22_f0401")
	event.EohSetShow(2, 0)
	event.EohSetPos(0, 0.0, 0.0, 3300.0)
	event.EohSetPos(3, -930.0, 750.0, 2330.0)
	event.EohSetPos(4, 930.0, 750.0, 2330.0)
	event.InitDramaScene()
	event.CmrsInit()
	event.CmrsSetPos(1276.52, 7391.95, 1416.71)
	event.CmrsSetRef(1173.37, 7042.65, 1560.26)
	event.CmrsQuake(0.0, 3.0, 0.0, -1)
	event.SetFadeIn(10)
	helper_440(10)
	if vm.skipping() then
		return skip(1)
	end
	event.ObjsMove2(0, 0.0, 9000.0, 3300.0, 160, 1, 1.0)
	event.ObjsMove2(3, -930.0, 9750.0, 2330.0, 160, 1, 1.0)
	event.ObjsMove2(4, 930.0, 9750.0, 2330.0, 160, 1, 1.0)
	helper_29b0(0)
	if vm.skipping() then
		return skip(2)
	end
	event.SetFadeOut(10)
	helper_440(10)
	if vm.skipping() then
		return skip(3)
	end
	return part2()
end

--- Helper function.
local function helper_c84(arg0: f32, arg1: f32)
	local skip: (number) -> ...any
	function skip(at: number)
		return arg0
	end
	if vm.skipping() then
		return skip(1)
	end
	if arg0 > arg1 then
		return arg0
	else
		return arg1
	end
end

--- Helper function.
local function helper_aa0(arg0: f32)
	local skip: (number) -> ...any
	function skip(at: number)
		return vm.f32(-1.0 * arg0)
	end
	if vm.skipping() then
		return skip(1)
	end
	if arg0 < 0 then
		return vm.f32(-1.0 * arg0)
	else
		return arg0
	end
end

--- Helper function.
local function helper_1a8c(arg0: f32, arg1: f32, arg2: f32, arg3: f32)
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
local function helper_8da8(arg0: s32, arg1: any, arg2: any)
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
			var34 = vm.f32(helper_c84(helper_aa0(angle), helper_aa0(angle_2)) * 8.0)
			var35 = helper_1a8c(0.0, angle, var33, var34)
			var35 = vm.f32(var35 + var27)
			var36 = helper_1a8c(0.0, angle_2, var33, var34)
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
	var34 = vm.f32(helper_c84(helper_aa0(angle), helper_aa0(angle_2)) * 8.0)
	while var33 < var34 do
		var35 = helper_1a8c(0.0, angle, var33, var34)
		var35 = vm.f32(var35 + var27)
		event.SetCharaRot(arg0, 0.0, var35, 0.0)
		var36 = helper_1a8c(0.0, angle_2, var33, var34)
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
local function helper_2c8c(arg0: any, arg1: any, arg2: any, arg3: any)
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
local function helper_7ec4(arg0: s32, arg1: any, arg2: any, arg3: s32, arg4: any)
	local var5: s32 = 0
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_2c8c(arg0, arg1, arg2, arg3)
		end
		if at <= 2 then
			_, var5 = helper_7a90(arg0, 0, var5)
		end
		helper_2d9c(arg0)
	end
	if vm.skipping() then
		return skip(1)
	end
	helper_2c8c(arg0, arg1, arg2, arg3)
	if vm.skipping() then
		return skip(2)
	end
	_, var5 = helper_7a90(arg0, 0, var5)
	if vm.skipping() then
		return skip(3)
	end
	helper_2d9c(arg0)
end

--- Helper function.
local function helper_a2dc(arg0: any, arg1: any, arg2: any)
	local rot_y: f32 = 0
	local player_chara: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_8da8(player_chara, arg0, arg1)
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
	helper_8da8(player_chara, arg0, arg1)
	if vm.skipping() then
		return skip(2)
	end
	return rot_y
end

--- Helper function.
local function helper_9b38(arg0: any, arg1: f32)
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
			var13 = helper_1a8c(0.0, angle, var14, var15)
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
		var13 = helper_1a8c(0.0, angle, var14, var15)
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
local function helper_a44c(arg0: any, arg1: f32, arg2: any, arg3: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_9b38(arg0, arg1)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	if arg3 ~= 0 then
		helper_9b38(arg0, arg1)
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
local function helper_a59c(arg0: s32, arg1: s32, arg2: s32, arg3: s32)
	local var4: f32 = 0
	local player_chara: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var4 = helper_a2dc(arg0, arg2, arg3)
		end
		if at <= 2 then
			helper_7ec4(0, arg1, arg0, player_chara, 0)
		end
		if at <= 3 then
			helper_a44c(arg0, var4, arg2, arg3)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var4 = helper_a2dc(arg0, arg2, arg3)
	if vm.skipping() then
		return skip(2)
	end
	player_chara = event.GetControlChrid() or player_chara
	helper_7ec4(0, arg1, arg0, player_chara, 0)
	if vm.skipping() then
		return skip(3)
	end
	helper_a44c(arg0, var4, arg2, arg3)
	if vm.skipping() then
		return skip(4)
	end
end

--- Helper function.
local function helper_df5c(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_440(15)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFadeOut(15)
	helper_440(15)
	if vm.skipping() then
		return skip(2)
	end
	event.GotoMenu(6, arg0)
	if vm.wait() then
		return skip(3)
	end
	event.SetFadeIn(15)
end

--- Helper function.
local function helper_10574()
	local player_chara: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local flag_4: s32 = 0
	local flag_5: s32 = 0
	local flag_6: s32 = 0
	local flag_7: s32 = 0
	local flag_8: s32 = 0
	local flag_9: s32 = 0
	local player_chara_2: s32 = 0
	local var14: f32 = 0
	local var16: f32 = 0
	local var17: f32 = 0
	local var19: f32 = 0
	local var20: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_7ec4(0, -1, var1, player_chara, 0)
		end
		if at <= 2 then
			var3 = 1
			helper_a59c(var1, -1, 0, 0)
		end
		if at <= 3 then
			helper_7ec4(0, -1, var1, player_chara, 0)
		end
		if at <= 4 then
			helper_9b38(player_chara_2, var20)
		end
		if at <= 5 then
			helper_7ec4(0, -1, var1, player_chara_2, 0)
		end
		if at <= 6 then
			helper_df5c(30)
		end
		if at <= 7 then
			helper_df5c(28)
		end
		if at <= 8 then
			helper_df5c(29)
		end
	end
	player_chara = event.GetControlChrid() or player_chara
	var1 = event.GetEventData_2(13) or var1
	var2 = event.GetEventData_2(14) or var2
	print("talk_chara_id=", var1, "talk_chara=", var2, "\n")
	event.CtrlcStay()
	event.SetAi(0, var1)
	event.SetMesShippo(0, 1)
	event.SetMesPreset(0, 0)
	event.MesMake_2(0, "こんにちは。\nいい天気だね。")
	var3 = 0
	if var2 == 400 then
		flag = event.GetFlag(640) or flag
		if flag == 0 then
			flag_2 = event.GetFlag(616) or flag_2
			if flag_2 == 0 then
				flag_3 = event.GetFlag(540) or flag_3
				if flag_3 == 0 then
					flag_4 = event.GetFlag(536) or flag_4
					if flag_4 == 0 then
						event.MesMake_2(
							0,
							"ギルトーニは手強い、決して\n油断してはならぬぞ。<page>キミならきっと勝てるはずだ。\nアトラミリアに選ばれた\nキミなら・・・"
						)
					else
						event.MesMake_2(
							0,
							"そうか、ギルトーニも\n悲しい男だったのだな。<page>グリフォンは二つの時代の\n人々を巻き込んで、いったい\n何をするつもりなのだ・・・"
						)
					end
				else
					event.MesMake_2(
						0,
						"君たちならきっと、\nグリフォンを倒すことが\nできるだろう。<page>期待しているぞ。"
					)
				end
			else
				event.MesMake_2(
					0,
					"クロノユニオン・・・<page>古代人たちの英知によって\n世界が救われると\n言うのか・・・"
				)
			end
		else
			event.MesMake_2(
				0,
				"いよいよ最後の決戦か。\nグリフォン大帝との闘いには、\n多くの仲間の血が流された・・・<page>絶対に負けるわけにはいかん！\nユリス、モニカ、頼んだぞ。\n必ず、奴を倒すのだ。"
			)
		end
	end
	if var2 == 401 then
		flag_5 = event.GetFlag(640) or flag_5
		if flag_5 == 0 then
			flag_6 = event.GetFlag(616) or flag_6
			if flag_6 == 0 then
				flag_7 = event.GetFlag(540) or flag_7
				if flag_7 == 0 then
					flag_8 = event.GetFlag(536) or flag_8
					if flag_8 == 0 then
						flag_9 = event.GetFlag(520) or flag_9
						if flag_9 == 0 then
							event.MesMake_2(
								0,
								"よう、まずはファイアースコールを破壊して、\n火炎雨をどうにかしねぇと、ヘイム・ラダを\n元に戻すことなんてできないぜ。"
							)
						else
							event.MesMake_2(
								0,
								"そうか、そんなことになってしまったか。\nファイアースコールを破壊しただけでも、\nまずはよかったというべきか。"
							)
							helper_8da8(player_chara, var1, 0)
							if vm.skipping() then
								return skip(1)
							end
							helper_7ec4(0, -1, var1, player_chara, 0)
							if vm.skipping() then
								return skip(2)
							end
							var3 = 1
							event.MesMake_2(
								0,
								"しかし、火口に落ちてしまった\nおまえさんの連れも心配だな。<page>こうなったら、ヘイム・ラダを復興して、\nこのガンドラダをさらにパワーアップする\nしかないな。"
							)
						end
					else
						event.MesMake_2(
							0,
							"ギルトーニを倒しちまうとは、\nおまえたち、スゲェんだな。<page>後は親玉のグリフォン大帝だ。\n気合を入れてかかれよ。"
						)
					end
				else
					event.MesMake_2(
						0,
						"パズノスの活躍、見せてもらった。\nうれしくてつい涙が出ちまったぜ。<page>なんてったって、移動要塞パズノスは\nオレたちの血と汗の結晶だからな。"
					)
				end
			else
				event.MesMake_2(
					0,
					"ラピス？\nう～ん、オレにはなんのことだか\nわかんねぇなぁ。"
				)
			end
		else
			event.MesMake_2(
				0,
				"いよいよ、グリフォンってやつと\n対決するわけだな。<page>がんばれよ、兄弟！"
			)
		end
	end
	if var2 == 402 then
		event.MesMake_2(0, "ヘーイ、いいのがそろってるよ！\n買ってって！！")
	end
	if var2 == 403 then
		event.MesMake_2(
			0,
			"パーツの品揃えならまかしときな。\nウチでさがせば、バッチリだぜ。"
		)
	end
	if var2 == 404 then
		event.MesMake_2(
			0,
			"バトルは奥が深い。武器だけでゴリ押し\nしているようでは、まだまだだぜ。<page>バトルってやつは、アイテムを使って、\n切り抜けるのが、かっこいいんだ。"
		)
	end
	if var2 == 405 then
		event.MesMake_2(
			0,
			"ガンドラダ大工房でつくれないもの\nなどない。どんな巨大なものでも\nこの工房でならつくれてしまうんだぜ。"
		)
	end
	if var2 == 406 then
		event.MesMake_2(
			0,
			"オイ、おまえたちどこから入ってきたんだ。\nここは、危ないから気をつけるんだぞ。"
		)
	end
	if var2 == 407 then
		event.MesMake_2(
			0,
			"ボクら今までどうしてたんだろう？\nなんか思い出せないんだよね。"
		)
	end
	if var2 == 408 then
		event.MesMake_2(
			0,
			"オレたちがグリフォンに消されていた\nなんて・・・なんて恐ろしいやつなんだ。\nグリフォン大帝ってやつは。"
		)
	end
	if var2 == 409 then
		event.MesMake_2(0, "今、いそがしいんです。\n邪魔しないでください。")
	end
	if var2 == 410 then
		event.MesMake_2(
			0,
			"私たちもカゲながら健闘を祈っています。\nがんばってください！！"
		)
	end
	if var2 == 411 then
		event.MesMake_2(
			0,
			"おっとー、ここの\nケースの中の武器は\n非売品らしいぜ。<page>しっかし、世の中には\nいろんな形をした武器が\nあるもんだなぁ・・・"
		)
	end
	if var2 == 412 then
		event.MesMake_2(
			0,
			"ファイアースコールを\n降らせるなんて、\nギルトーニって奴は・・・<page>ずるがしこいって言うか・・・\n本当にひどい奴だ。"
		)
	end
	if var2 == 413 then
		event.MesMake_2(0, "何だ？この看板の\nハートは・・・<page>趣味悪いぜ・・・")
	end
	if var3 == 0 then
		helper_a59c(var1, -1, 0, 0)
		if vm.skipping() then
			return skip(3)
		end
	end
	if var3 == 1 then
		helper_7ec4(0, -1, var1, player_chara, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.SetMotion(var1, "立ち")
		event.Finish()
	end
	if var3 == 2 then
		event.SetCameraPos(1.39, 51.09, 278.55)
		event.SetCameraRef(-54.8, 23.29, 223.57)
		player_chara_2 = event.GetControlChrid() or player_chara_2
		do
			local out1, _, out3 = event.GetCharaPos(player_chara_2)
			var14 = out1 or var14
			var16 = out3 or var16
		end
		do
			local out1, _, out3 = event.GetCharaPos(var1)
			var17 = out1 or var17
			var19 = out3 or var19
		end
		var20 = event.GetRotLookPos(var17 - var14, var19 - var16) or var20
		helper_9b38(player_chara_2, var20)
		if vm.skipping() then
			return skip(5)
		end
		event.SetCharaRot(player_chara_2, 0.0, var20, 0.0)
		event.SetMotion(player_chara_2, "立ち")
		helper_7ec4(0, -1, var1, player_chara_2, 0)
		if vm.skipping() then
			return skip(6)
		end
		event.ResetCamera(1, 3.1415927)
	end
	event.SetAi(1, var1)
	if var2 == 402 then
		helper_df5c(30)
		if vm.skipping() then
			return skip(7)
		end
	end
	if var2 == 403 then
		helper_df5c(28)
		if vm.skipping() then
			return skip(8)
		end
	end
	if var2 == 404 then
		helper_df5c(29)
		if vm.skipping() then
			return skip(9)
		end
	end
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

script[99] = program_99

--- Program 100.
script[100] = function()
	local old_map_no: s32 = 0
	local var1: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	local part3: () -> ...any
	function skip(at: number)
		if at <= 1 then
			local _ = helper_1bda0()
			helper_23dd8()
			if not vm.skipping() then
				return part2()
			end
		end
		if at <= 2 then
			local _ = helper_1bec8()
			helper_27650()
			if not vm.skipping() then
				return part3()
			end
		end
		helper_190c(0.0, 0.0, 0.0, 0.0)
		helper_29a90()
		helper_190c(vm.f32(-2079.4), 6.0, vm.f32(5052.4), vm.f32(2.16))
		helper_190c(vm.f32(2011.1), 6.0, 5158.5, vm.f32(-2.23))
		helper_190c(286.5, 6.0, vm.f32(-22.3), vm.f32(-0.16))
		helper_190c(vm.f32(-228.6), 6.0, vm.f32(5828.1), vm.f32(-0.02))
		helper_29a90()
		helper_190c(0.0, 2460.0, 6000.0, vm.f32(3.14))
	end
	function part2()
		if helper_1bec8() ~= 0 then
			helper_27650()
			if vm.skipping() then
				return skip(3)
			end
		end
		return part3()
	end
	function part3()
		if old_map_no == 3 then
			helper_190c(0.0, 0.0, 0.0, 0.0)
		end
		if old_map_no == 105 then
			var1 = event.GetCnt(18) or var1
			event.SetCnt(14, 0)
			helper_29a90()
			if var1 == 1 then
				helper_190c(vm.f32(-2079.4), 6.0, vm.f32(5052.4), vm.f32(2.16))
			end
			if var1 == 2 then
				helper_190c(vm.f32(2011.1), 6.0, 5158.5, vm.f32(-2.23))
			end
			if var1 == 3 then
				helper_190c(286.5, 6.0, vm.f32(-22.3), vm.f32(-0.16))
			end
			if var1 == 0 then
				helper_190c(vm.f32(-228.6), 6.0, vm.f32(5828.1), vm.f32(-0.02))
			end
		end
		if old_map_no == 107 then
			event.SetCnt(14, 2)
			helper_29a90()
			helper_190c(0.0, 2460.0, 6000.0, vm.f32(3.14))
		end
		event.ResetCamera(1, 0.0, 10.0)
	end
	old_map_no = event.GetOldMapNo() or old_map_no
	event.SetFadeIn(15)
	if old_map_no == 3 then
		event.SetCnt(14, 0)
	end
	program_99()
	helper_29a90()
	if helper_1bc78() ~= 0 then
		helper_21d10()
		if vm.skipping() then
			return skip(1)
		end
	end
	if helper_1bda0() ~= 0 then
		helper_23dd8()
		if vm.skipping() then
			return skip(2)
		end
	end
	return part2()
end

--- Program 150.
script[150] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_21d10()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 151.
script[151] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_1c2f4()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 300.
script[300] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_1b508(0.0, 0.0, 0.0, vm.f32(6.2831855))
	if vm.skipping() then
		return skip(1)
	end
	event.MapJump(-1, "g04")
	if vm.wait() then
		return skip(2)
	end
end

--- Program 550.
script[550] = function()
	local var0: s32 = 0
	local var1: any = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	local landing1: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_440(10)
		end
		if at <= 2 then
			helper_190c(vm.f32(684.8), 0.0, vm.f32(6024.3), vm.f32(-2.87))
			helper_190c(vm.f32(684.8), 1160.0, vm.f32(6024.3), vm.f32(-2.87))
			local _ = helper_2a810()
			if not vm.skipping() then
				return landing1()
			end
		end
		helper_29a90()
	end
	function part2() end
	function landing1()
		helper_29a90()
		event.ResetCamera(1, 0.0, 10.0)
		event.SetFadeIn(10)
	end
	event.Initialize()
	event.SetMotion(0, "立ち")
	var0 = event.GetSndId(2) or var0
	var1 = helper_2a974()
	if vm.skipping() then
		return skip(1)
	end
	if var1 >= 0 then
		event.SndSePlay(var0, 70)
		event.SetFadeOut(10)
		helper_440(10)
		if vm.skipping() then
			return skip(2)
		end
		if var1 == 0 then
			helper_190c(vm.f32(684.8), 0.0, vm.f32(6024.3), vm.f32(-2.87))
		end
		if var1 == 1 then
			helper_190c(vm.f32(684.8), 1160.0, vm.f32(6024.3), vm.f32(-2.87))
			local t0 = helper_2a810()
			if vm.skipping() then
				return skip(3)
			end
			if t0 ~= 0 then
				helper_29a90()
				event.ResetCamera(1, 0.0, 10.0)
				event.SetFadeIn(10)
				return
			end
		end
		if var1 == 2 then
			helper_190c(vm.f32(684.8), 2320.0, vm.f32(6024.3), vm.f32(-2.87))
		end
		event.SndSePlay(var0, 71)
		helper_29a90()
		event.ResetCamera(1, 0.0, 10.0)
		event.SetFadeIn(10)
	end
	return part2()
end

--- Program 551.
script[551] = function()
	local var0: s32 = 0
	local var1: any = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	local landing1: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_440(10)
		end
		if at <= 2 then
			helper_190c(vm.f32(-2553.7), 0.0, vm.f32(3882.6), vm.f32(1.55))
			helper_190c(vm.f32(-2553.7), 1160.0, vm.f32(3882.6), vm.f32(1.55))
			local _ = helper_2a810()
			if not vm.skipping() then
				return landing1()
			end
		end
		helper_29a90()
	end
	function part2() end
	function landing1()
		helper_29a90()
		event.ResetCamera(1, 0.0, 10.0)
		event.SetFadeIn(10)
	end
	event.Initialize()
	event.SetMotion(0, "立ち")
	var0 = event.GetSndId(2) or var0
	var1 = helper_2a974()
	if vm.skipping() then
		return skip(1)
	end
	if var1 >= 0 then
		event.SndSePlay(var0, 70)
		event.SetFadeOut(10)
		helper_440(10)
		if vm.skipping() then
			return skip(2)
		end
		if var1 == 0 then
			helper_190c(vm.f32(-2553.7), 0.0, vm.f32(3882.6), vm.f32(1.55))
		end
		if var1 == 1 then
			helper_190c(vm.f32(-2553.7), 1160.0, vm.f32(3882.6), vm.f32(1.55))
			local t0 = helper_2a810()
			if vm.skipping() then
				return skip(3)
			end
			if t0 ~= 0 then
				helper_29a90()
				event.ResetCamera(1, 0.0, 10.0)
				event.SetFadeIn(10)
				return
			end
		end
		if var1 == 2 then
			helper_190c(vm.f32(-2553.7), 2320.0, vm.f32(3882.6), vm.f32(1.55))
		end
		event.SndSePlay(var0, 71)
		helper_29a90()
		event.ResetCamera(1, 0.0, 10.0)
		event.SetFadeIn(10)
	end
	return part2()
end

--- Program 552.
script[552] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	event.SetMotion(0, "立ち")
	event.SetFadeOut(15)
	helper_440(15)
	if vm.skipping() then
		return skip(1)
	end
	event.MapJump(-1, "s39")
	if vm.wait() then
		return skip(2)
	end
end

--- Program 560.
script[560] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_2c0fc(1)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 561.
script[561] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_2c0fc(3)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 562.
script[562] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetCnt(13, 2)
	helper_2b9a8()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 563.
script[563] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetCnt(13, 3)
	helper_2b9a8()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 564.
script[564] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetCnt(13, 4)
	helper_2b9a8()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 565.
script[565] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetCnt(13, 5)
	helper_2b9a8()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 566.
script[566] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_2c0fc(2)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 567.
script[567] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_2c0fc(0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 600.
script[600] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_251d0()
	if vm.skipping() then
		return skip(1)
	end
	event.BgmLoadCancel()
	event.MapJump(-1, "s30", 600)
end

--- Program 601.
script[601] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_26bd8()
	if vm.skipping() then
		return skip(1)
	end
	event.BgmLoadCancel()
	event.MapJump(-1, "s55", 600)
end

--- Program 1000.
script[1000] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_10574()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 15080.
script[15080] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.DbgSetAnalyzeFlag(3, 3, 0)
	event.DbgSetAnalyzeFlag(3, 4, 0)
	event.DbgSetAnalyzeFlag(3, 5, 0)
	event.DbgSetAnalyzeFlag(3, 6, 0)
	event.DbgSetAnalyzeFlag(3, 7, 0)
	event.DbgSetAnalyzeFlag(3, 8, 0)
	event.DbgSetAnalyzeFlag(3, 9, 0)
	event.DbgSetAnalyzeFlag(3, 0, 1)
	event.DbgSetAnalyzeFlag(3, 1, 1)
	event.DbgSetAnalyzeFlag(3, 2, 1)
	event.SetFlag(508, 0)
	event.MapJump(-1, 102, 151)
	if vm.wait() then
		return skip(1)
	end
end

--- Program 15220.
script[15220] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetFlag(520, 1)
	event.SetFlag(522, 0)
	event.ExtTyped(1078, "ii", 1, 0)
	helper_1b508(0.0, 0.0, 0.0, vm.f32(6.2831855))
	if vm.skipping() then
		return skip(1)
	end
	event.MapJump(-1, "g04")
	if vm.wait() then
		return skip(2)
	end
end

--- Program 15480.
script[15480] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.DbgSetAnalyzeFlag(3, 3, 0)
	event.DbgSetAnalyzeFlag(3, 4, 0)
	event.DbgSetAnalyzeFlag(3, 5, 0)
	event.DbgSetAnalyzeFlag(3, 6, 0)
	event.DbgSetAnalyzeFlag(3, 7, 0)
	event.DbgSetAnalyzeFlag(3, 8, 0)
	event.DbgSetAnalyzeFlag(3, 9, 0)
	event.DbgSetAnalyzeFlag(3, 0, 1)
	event.DbgSetAnalyzeFlag(3, 1, 1)
	event.DbgSetAnalyzeFlag(3, 2, 1)
	event.SetFlag(548, 0)
	event.SetFlag(552, 1)
	event.SetFlag(556, 1)
	event.MapJump(-1, 102, 100)
	if vm.wait() then
		return skip(1)
	end
end

--- Program 15520.
script[15520] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.DbgSetAnalyzeFlag(3, 7, 0)
	event.DbgSetAnalyzeFlag(3, 8, 0)
	event.DbgSetAnalyzeFlag(3, 9, 0)
	event.DbgSetAnalyzeFlag(3, 0, 1)
	event.DbgSetAnalyzeFlag(3, 1, 1)
	event.DbgSetAnalyzeFlag(3, 2, 1)
	event.DbgSetAnalyzeFlag(3, 3, 1)
	event.DbgSetAnalyzeFlag(3, 4, 1)
	event.DbgSetAnalyzeFlag(3, 5, 1)
	event.DbgSetAnalyzeFlag(3, 6, 1)
	event.SetFlag(548, 1)
	event.SetFlag(552, 0)
	event.SetFlag(556, 1)
	event.MapJump(-1, 102, 100)
	if vm.wait() then
		return skip(1)
	end
end

--- Program 15560.
script[15560] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.DbgSetAnalyzeFlag(3, 0, 1)
	event.DbgSetAnalyzeFlag(3, 1, 1)
	event.DbgSetAnalyzeFlag(3, 2, 1)
	event.DbgSetAnalyzeFlag(3, 3, 1)
	event.DbgSetAnalyzeFlag(3, 4, 1)
	event.DbgSetAnalyzeFlag(3, 5, 1)
	event.DbgSetAnalyzeFlag(3, 6, 1)
	event.DbgSetAnalyzeFlag(3, 7, 1)
	event.DbgSetAnalyzeFlag(3, 8, 1)
	event.DbgSetAnalyzeFlag(3, 9, 1)
	event.DbgSetAnalyzeFlag(3, 10, 1)
	event.SetFlag(548, 1)
	event.SetFlag(552, 1)
	event.SetFlag(556, 0)
	event.MapJump(-1, 102, 100)
	if vm.wait() then
		return skip(1)
	end
end

return script
