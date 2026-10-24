--!strict
-- map/d/d05/b01/d05b01.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Program 99.
local function program_99()
	local flag: s32 = 0
	local flag_2: s32 = 0
	event.StopBgm(0)
	event.LoadSound(5683)
	flag = event.GetFlag(526) or flag
	if flag == 1 then
		event.FuncPointShow("d05", "func", 0)
		event.EohSyncObj(0, "d05", "d05ba02-a")
		event.EohSetShow(0, 0)
		event.EohSyncObj(0, "d05", "d05b01_1", "takil")
		event.EohSetScale(0, 0.43, 1.0, 1.0)
		event.EohSyncObj(0, "d05", "d05b01_1", "takir")
		event.EohSetScale(0, 0.43, 1.0, 1.0)
		event.FuncPointShow("p01", "invent_2023-1", 1)
	end
	flag_2 = event.GetFlag(528) or flag_2
	if flag_2 == 0 then
		event.EohSyncObj(0, "d05", "d05ba03-a")
		event.EohSetShow(0, 1)
	else
		event.FuncPointShow("", "e528", 0)
	end
end

--- Helper function.
local function helper_18dc(arg0: f32, arg1: f32, arg2: f32, arg3: f32)
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
local function helper_410(arg0: any)
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
local function helper_2b28(arg0: any, arg1: any, arg2: any, arg3: any, arg4: any)
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
local function helper_2e58(arg0: s32, arg1: s32)
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
local function helper_3c80(arg0: s32)
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
			t1, var2 = helper_2e58(arg0, var2)
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
		t0, var2 = helper_2e58(arg0, var2)
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
local function helper_2d6c(arg0: any)
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
local function helper_5cf0(arg0: s32)
	local stream_open_state: s32 = 0
	local stream_open_state_2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			helper_2b28(0, -1, 8, 0, 0)
			helper_3c80(0)
		end
		helper_2d6c(0)
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
	helper_2b28(0, -1, 8, 0, 0)
	event.StreamPlay(1)
	helper_3c80(0)
	if vm.skipping() then
		return skip(4)
	end
	helper_2d6c(0)
	event.StreamClose(1)
end

--- Helper function.
local function helper_5fe0(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_5cf0(arg0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, arg0)
	helper_5cf0(arg0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_263b8()
	local active_chr_no: s32 = 0
	local var1: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 4 then
			if at <= 1 then
				helper_5fe0(5360100)
			end
			if at <= 2 then
				helper_5fe0(5360110)
			end
			if at <= 3 then
				helper_410(30)
			end
			if vm.skip_end() then
				return skip(5)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SndSeStop(var1, 2)
		event.SetStatus(1, 0, 256, 0)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.DelExtMotion(0)
		event.DeleteChara(8)
		event.DeleteChara(9)
		event.DelImg(0)
		event.LoadMes(0, -1)
		event.SetStatusbarShow(1, 1.0)
		event.EohSetShow(4, 1)
		event.EohSetShow(5, 1)
	end
	event.SetFlag(536, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.SetStatusbarShow(0, 1.0)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 2 then
		event.DngSetupMainUnit(0)
		active_chr_no = 0
	end
	if active_chr_no == 3 then
		event.DngSetupMainUnit(1)
		active_chr_no = 1
	end
	event.StopBgm(0)
	event.LoadSound(5825)
	var1 = event.SndLoadSound(5825) or var1
	event.SetStatus(1, 0, 256, 1)
	event.ChangeDir("event/e500/e536/")
	event.LoadMes(0, 5, "e536.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e536_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e536_monica.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.ChangeDir("")
	if active_chr_no == 1 then
		event.LoadChara(5, "chara/c01_base.gltf", "info", 8)
		event.LoadEquip(5, 0, 4, "info", 8)
		event.LoadEquip(5, 0, 3, "info", 8)
		event.LoadEquip(5, 0, 2, "info", 8, 9)
		event.LoadMotion(5, "event/e500/e536/e536_mints.gltf", "info", 8)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 8)
		event.EohSyncChara(0, 8)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	else
		event.LoadChara(5, "chara/c02_base.gltf", "info", 8)
		event.LoadEquip(5, 1, 4, "info", 8)
		event.LoadEquip(5, 1, 3, "info", 8)
		event.LoadEquip(5, 1, 2, "info", 8, 9)
		event.LoadMotion(5, "event/e500/e536/e536_monica.gltf", "info", 8)
		event.EohSyncChara(1, 8)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 0)
	end
	event.CharaActive(8)
	event.CharaActive(9)
	event.EohSyncChara(4, 1)
	event.EohSyncChara(5, 2)
	event.EohSetShow(4, 0)
	event.EohSetShow(5, 0)
	event.EohSetPos(0, -9.0, 0.0, 100.0)
	event.EohSetRot(0, 0.0, 3.02, 0.0)
	event.EohSetMotion(0, "立ち", 4)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "無表情")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	event.EohSetPos(1, 9.0, 0.0, 100.0)
	event.EohSetRot(1, 0.0, -3.02, 0.0)
	event.EohSetMotion(1, "立ち", 4)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "おこり顔")
	event.EohSetTexAnim(1, 1, "おこり目パチ")
	event.InitDramaScene()
	event.CmrsInit()
	event.CmrsSetPos(0.0, 18.65, 43.37)
	event.CmrsSetRef(0.0, 15.13, 108.54)
	event.SetFadeIn(30)
	helper_410(30)
	if vm.skipping() then
		return skip(1)
	end
	event.ObjsSetMotion(1, "許せない", 6)
	event.ObjsNextMotion(1, "許せないL", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_5fe0(5360100)
	if vm.skipping() then
		return skip(2)
	end
	event.ObjsSetMotion(0, "右向く", 6)
	event.ObjsNextMotion(0, "右向くL", 4)
	event.ObjsSeDelay(0, 10)
	event.ObjsSePlay(0, var1, 10)
	event.SetPakuAnim(0, "通常口パク")
	helper_5fe0(5360110)
	if vm.skipping() then
		return skip(3)
	end
	event.SetFadeOut(30)
	helper_410(30)
	if vm.skipping() then
		return skip(4)
	end
	return part2()
end

--- Helper function.
local function helper_4348(arg0: any, arg1: s32)
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
local function helper_7d14(arg0: any, arg1: s32, arg2: s32)
	local var3: s32 = 0
	local var4: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var4 = 0
			var3 = helper_4348(arg0, arg1)
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
		var3 = helper_4348(arg0, arg1)
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
local function helper_87dc(arg0: s32, arg1: s32, arg2: s32, arg3: s32, arg4: s32)
	local var6: s32 = 0
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			local _ = helper_2b28(arg0, arg1, arg2, arg3, arg4)
			_, var6 = helper_7d14(arg0, 0, var6)
		end
		helper_2d6c(arg0)
	end
	if vm.skipping() then
		return skip(1)
	end
	local _ = helper_2b28(arg0, arg1, arg2, arg3, arg4)
	_, var6 = helper_7d14(arg0, 0, var6)
	if vm.skipping() then
		return skip(2)
	end
	helper_2d6c(arg0)
end

--- Helper function.
local function helper_6d34(arg0: s32)
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
local function helper_6a74(arg0: s32)
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
local function helper_6e8c(arg0: s32, arg1: any, arg2: any, arg3: s32)
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
				helper_6d34(arg0)
			end
			if at <= 2 then
				var8 = 0
				var7 = helper_6a74(arg0)
				var8 = -1
				var8 = 1
				var6 = var7
				var8 = -1
				var8 = 1
				var8 = -1
				var8 = 1
			end
			helper_2d6c(arg0)
			return -1
		end
		helper_2d6c(arg0)
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
	helper_6d34(arg0)
	if vm.skipping() then
		return skip(2)
	end
	while true do
		var8 = 0
		var7 = helper_6a74(arg0)
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
					helper_2d6c(arg0)
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
	helper_2d6c(arg0)
	return arg2
end

--- Helper function.
local function helper_7ba4(arg0: s32, arg1: any, arg2: s32, arg3: s32, arg4: s32, arg5: s32, arg6: s32)
	local var8: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		return var8
	end
	local _ = helper_2b28(arg0, arg1, arg2, arg3, arg4)
	var8 = helper_6e8c(arg0, arg5, arg6, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPos(arg0, 0)
	return var8
end

--- Helper function.
local function helper_e92c()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			helper_410(10)
		end
	end
	event.Initialize()
	event.SetMotion(0, "立ち")
	event.SetFadeOut(10)
	helper_410(10)
	if vm.skipping() then
		return skip(1)
	end
	event.GotoMenu(7)
	if vm.wait() then
		return skip(2)
	end
	event.SetFadeIn(10)
	helper_410(10)
	if vm.skipping() then
		return skip(3)
	end
end

--- Helper function.
local function helper_8678(arg0: s32, arg1: s32, arg2: s32, arg3: s32, arg4: s32, arg5: s32)
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		helper_2d6c(arg0)
		return arg5
	end
	local _ = helper_2b28(arg0, arg1, arg2, arg3, arg4)
	_, arg5 = helper_7d14(arg0, 1, arg5)
	if vm.skipping() then
		return skip(1)
	end
	helper_2d6c(arg0)
	return arg5
end

--- Helper function.
local function helper_2870()
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
local function helper_34c0(arg0: s32, arg1: any, arg2: any)
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
		helper_2d6c(arg0)
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
			helper_2d6c(arg0)
		end
	end
	event.ResetPakuMotion()
	event.TrgPakuAnim(0)
	event.ResetPakuAnim()
	event.StreamStop(1)
	event.SetMesOkuri(arg0, 1)
end

--- Helper function.
local function helper_3bc4(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_34c0(arg0, vm.ftoi(arg1), -1)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	helper_34c0(arg0, vm.ftoi(arg1), -1)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_562c(arg0: s32, arg1: s32)
	local stream_open_state: s32 = 0
	local stream_open_state_2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			helper_2b28(0, -1, 8, 0, 0)
			helper_3bc4(0, arg1)
		end
		helper_2d6c(0)
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
	helper_2b28(0, -1, 8, 0, 0)
	event.StreamPlay(1)
	helper_3bc4(0, arg1)
	if vm.skipping() then
		return skip(4)
	end
	helper_2d6c(0)
	event.StreamClose(1)
	event.SetMesPos(0, 0)
end

--- Helper function.
local function helper_1197c()
	local active_chr_no: s32 = 0
	local var1: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_410(15)
		end
		if at <= 2 then
			active_chr_no = 0
			helper_2870()
		end
		if at <= 3 then
			helper_410(30)
		end
		if at <= 4 then
			helper_2870()
		end
		if at <= 5 then
			helper_410(30)
		end
		if at <= 6 then
			helper_562c(5260010, 120)
		end
		if at <= 7 then
			helper_410(90)
		end
		if at <= 8 then
			helper_410(30)
		end
		helper_18dc(0.0, -30.0, 1500.0, vm.f32(3.14))
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFlag(526, 1)
	event.SetFadeOut(15)
	helper_410(15)
	if vm.skipping() then
		return skip(2)
	end
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.SetStatusbarShow(0, 1.0)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no ~= 0 then
		event.DngSetupMainUnit(0)
		active_chr_no = 0
	end
	event.AssignStack(5)
	event.ClearStack(5)
	var1 = event.SndLoadSound(5814) or var1
	event.SetStatus(1, 0, 256, 1)
	event.ChangeDir("event/e500/e526/")
	event.LoadMes(0, 5, "e526.txt")
	event.LoadMotion(5, "e526_mints.gltf", "info", 0)
	event.CharaActive(0)
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.LoadChara(5, "phorn.gltf", "info", 8)
	event.CharaActive(8)
	event.SetReference(0, "item", 8)
	event.ChangeDir("")
	event.EohSyncChara(1, 1)
	event.EohSyncChara(2, 2)
	event.EohSetShow(1, 0)
	event.EohSetShow(2, 0)
	event.EohSetPos(0, 0.0, -30.0, 1500.0)
	event.EohSetRot(0, 0.0, 3.14, 0.0)
	event.EohSetMotion(0, "ホーン吹く", 4)
	event.EohNormalDrive(0)
	event.EohResetDaPosition(0)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "ふき顔")
	event.EohSetTexAnim(0, 1, "下向き目パチ")
	event.FuncPointShow("d05", "takil", 1)
	event.FuncPointShow("d05", "takir", 1)
	event.CmrsInit()
	event.CmrsSetPos(16.1, -10.46, 1474.52)
	event.CmrsSetRef(0.26, -9.87, 1496.35)
	event.CmrsMove2(30.06, -19.27, 1455.3, 2.31, -16.91, 1493.52, 60, 0, 1.0)
	event.SndSePlay(var1, 0)
	event.SetFadeIn(30)
	helper_2870()
	if vm.skipping() then
		return skip(3)
	end
	helper_410(30)
	if vm.skipping() then
		return skip(4)
	end
	event.CmrsSetPos(0.0, 30.39, 1561.77)
	event.CmrsSetRef(0.0, -19.94, 1493.75)
	event.CmrsMove2(0.0, 30.39, 1561.77, 0.0, 11.85, 1493.75, 80, 0, 1.0)
	event.SndSePlay(var1, 1)
	event.ObjsSetMotion(0, "ホーン持ち立ち", 4)
	helper_2870()
	if vm.skipping() then
		return skip(5)
	end
	helper_410(30)
	if vm.skipping() then
		return skip(6)
	end
	event.CmrsSetPos(14.64, -10.25, 1472.02)
	event.CmrsSetRef(0.03, -10.34, 1496.41)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "おどろき顔")
	event.EohSetTexAnim(0, 1, "おどろき目パチ")
	event.SetPakuAnim(0, "通常口パク")
	helper_562c(5260010, 120)
	if vm.skipping() then
		return skip(7)
	end
	event.CmrsSetPos(0.0, 0.69, 877.16)
	event.CmrsSetRef(0.0, -9.03, 949.98)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "デフォルト顔")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	helper_410(90)
	if vm.skipping() then
		return skip(8)
	end
	event.SndSeStop(var1, 1)
	event.SetFadeOut(30)
	helper_410(30)
	if vm.skipping() then
		return skip(9)
	end
	event.SetStatus(1, 0, 256, 0)
	event.EohSetFootSoundId(0, 0)
	event.DelExtMotion(0)
	event.DeleteChara(8)
	event.LoadMes(0, -1)
	event.SetStatusbarShow(1, 1.0)
	event.EohSetShow(1, 1)
	event.EohSetShow(2, 1)
	helper_18dc(0.0, -30.0, 1500.0, vm.f32(3.14))
	event.SetCameraRef(0.0, 0.0, 1500.0)
	event.SetCameraPos(0.0, 10.0, 1600.0)
	event.ResetCamera(0)
	event.SetFadeIn(30)
	event.Finish()
end

--- Helper function.
local function helper_2980(arg0: s32)
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
local function helper_e1e0()
	local active_chr_no: s32 = 0
	local var1: s32 = 0
	local rot_x: f32 = 0
	local rot_y: f32 = 0
	local rot_z: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
		if at <= 2 then
			helper_2980(0)
		end
	end
	event.Initialize()
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		event.LoadMotion(5, "dungeon/chara/c01b_miss.gltf", "info", 0)
		var1 = 86
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "dungeon/chara/c02a_miss.gltf", "info", 0)
		var1 = 64
	end
	if active_chr_no == 2 or active_chr_no == 3 then
		if vm.wait() then
			return skip(1)
		end
		event.Finish()
		return
	end
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetMotion(0, "立ち", 4)
	do
		local out1, out2, out3 = event.EohGetRot(0)
		rot_x = out1 or rot_x
		rot_y = out2 or rot_y
		rot_z = out3 or rot_z
	end
	do
		local out1, out2, out3 = event.GetCameraPos()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	event.ObjsReference(0, pos_x, pos_y, pos_z, 6)
	helper_2980(0)
	if vm.skipping() then
		return skip(2)
	end
	event.ObjsSetMotion(0, "だめだめ", 6)
	event.ObjsNextMotion(0, "立ち", 4)
	event.ObjsRotDelay(0, var1)
	event.ObjsRotation(0, rot_x, rot_y, rot_z, 6)
	helper_2980(0)
	if vm.skipping() then
		return skip(3)
	end
	if active_chr_no == 0 or active_chr_no == 1 then
		event.DelExtMotion(0)
	end
	event.Finish()
end

--- Helper function.
local function helper_12c24()
	local active_chr_no: s32 = 0
	local var1: s32 = 0
	local block: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 20 then
			if at <= 1 then
				active_chr_no = 0
				helper_410(4)
			end
			if at <= 2 then
				helper_410(90)
			end
			if at <= 3 then
				helper_2980(0)
			end
			if at <= 4 then
				helper_410(20)
			end
			if at <= 5 then
				helper_2870()
			end
			if at <= 6 then
				helper_410(46)
			end
			if at <= 7 then
				helper_410(30)
			end
			if at <= 8 then
				helper_2980(2)
			end
			if at <= 9 then
				helper_5fe0(5280010)
			end
			if at <= 10 then
				helper_5fe0(5280020)
			end
			if at <= 11 then
				helper_5fe0(5280030)
			end
			if at <= 12 then
				helper_410(20)
			end
			if at <= 13 then
				helper_2980(0)
			end
			if at <= 14 then
				helper_2980(2)
			end
			if at <= 15 then
				helper_410(30)
			end
			if at <= 16 then
				helper_2980(2)
			end
			if at <= 17 then
				helper_5fe0(5280040)
			end
			if at <= 18 then
				helper_410(90)
			end
			if at <= 19 then
				helper_410(30)
			end
			if vm.skip_end() then
				return skip(21)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SpriteSetDraw(0, 0)
		event.PlayBgm(0)
		event.SetStatus(1, 0, 256, 0)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.DelExtMotion(0)
		event.DeleteChara(8)
		event.DeleteChara(9)
		event.DeleteChara(10)
		event.DelImg(0)
		event.LoadMes(0, -1)
		event.SetStatusbarShow(1, 1.0)
		event.EohSetShow(3, 1)
		event.EohSetShow(4, 1)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFlag(528, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.SetStatusbarShow(0, 1.0)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no ~= 0 then
		event.DngSetupMainUnit(0)
		active_chr_no = 0
	end
	event.StopBgm(0)
	helper_410(4)
	if vm.skipping() then
		return skip(2)
	end
	event.LoadBgm(190)
	event.LoadSound(5817)
	var1 = event.SndLoadSound(5817) or var1
	event.SetStatus(1, 0, 256, 1)
	event.ChangeDir("event/e500/e528/")
	event.LoadMes(0, 5, "e528.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e528_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e528_monica.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.LoadChara(5, "e528_guiltoni.gltf", "info", 10)
	event.CharaActive(10)
	event.EohSyncChara(2, 10)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	block = event.LoadImg_4(5, "e528telop01.json", 0) or block
	event.SpriteInit(0)
	event.SpriteSetType(0, 0)
	event.SpriteSetTexture(0, "e528telop01", block)
	event.SpriteSetColor(0, 128, 128, 128, 128)
	event.SpriteSetUvsize(0, 0, 0, 512, 128)
	event.SpriteSetPutsize(0, 512, 128)
	event.SpriteSetPos(0, 256, 347)
	event.SpriteSetAlphab(0, 0)
	event.SpriteSetDraw(0, 0)
	event.EohSyncSprite(5, 0)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 5)
	event.ChangeDir("")
	if active_chr_no == 1 then
		event.LoadChara(5, "chara/c01_base.gltf", "info", 8)
		event.LoadEquip(5, 0, 4, "info", 8)
		event.LoadEquip(5, 0, 3, "info", 8)
		event.LoadEquip(5, 0, 2, "info", 8, 9)
		event.LoadMotion(5, "event/e500/e528/e528_mints.gltf", "info", 8)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 8)
		event.EohSyncChara(0, 8)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	else
		event.LoadChara(5, "chara/c02_base.gltf", "info", 8)
		event.LoadEquip(5, 1, 4, "info", 8)
		event.LoadEquip(5, 1, 3, "info", 8)
		event.LoadEquip(5, 1, 2, "info", 8, 9)
		event.LoadMotion(5, "event/e500/e528/e528_monica.gltf", "info", 8)
		event.EohSyncChara(1, 8)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 0)
	end
	event.CharaActive(8)
	event.CharaActive(9)
	event.EohSyncChara(3, 1)
	event.EohSyncChara(4, 2)
	event.EohSetShow(3, 0)
	event.EohSetShow(4, 0)
	event.EohSetPos(0, 0.0, 0.0, 500.0)
	event.EohSetRot(0, 0.0, 3.14, 0.0)
	event.EohSetMotion(0, "立ち", 4)
	event.EohSetFootSoundId(0, 2)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "無表情")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	event.EohSetPos(1, -100.0, 0.0, -200.0)
	event.EohSetRot(1, 0.0, 2.54, 0.0)
	event.EohSetMotion(1, "倒れ", 4)
	event.EohNormalDrive(1)
	event.EohResetDaPosition(1)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "死に")
	event.EohSetPos(2, -73.0, 0.0, -190.0)
	event.EohSetRot(2, 0.0, 0.0, 0.0)
	event.EohSetMotion(2, "しゃがみ", 4)
	event.EohSetSoundId(2, var1)
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "デフォルト顔")
	event.EohSetTexAnim(2, 1, "左向き目パチ")
	event.InitDramaScene()
	event.ObjsMove(0, 0.0, 0.0, 400.0, 120)
	event.ObjsSetMotion(0, "歩き", 4, -1.0, 1)
	event.ObjsMotionDelay(0, 120)
	event.ObjsSetMotion(0, "立ち")
	event.CmrsInit()
	event.CmrsSetPos(224.74, 194.1, 112.15)
	event.CmrsSetRef(119.89, 90.28, 320.08)
	event.SetFadeIn(30)
	helper_410(90)
	if vm.skipping() then
		return skip(3)
	end
	event.CmrsSetPos(23.71, 15.41, 365.52)
	event.CmrsSetRef(0.81, 20.88, 397.45)
	helper_2980(0)
	if vm.skipping() then
		return skip(4)
	end
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "無表情")
	event.EohSetTexAnim(0, 1, "通常目～おどろき目")
	event.EohSetTexAnim(0, 1, "半口")
	helper_410(20)
	if vm.skipping() then
		return skip(5)
	end
	event.CmrsSetPos(0.0, 27.58, 241.33)
	event.CmrsSetRef(11.62, 31.84, 143.18)
	event.CmrsMove(0.0, 27.58, 241.33, -10.98, 31.84, 142.98, 60)
	helper_2870()
	if vm.skipping() then
		return skip(6)
	end
	event.SetCrossfade(30)
	event.CmrsSetPos(-62.71, 22.94, -127.1)
	event.CmrsSetRef(-79.95, 18.68, -193.59)
	event.ObjsNextMotion(2, "気がつき", 6)
	event.ObjsNextMotion(2, "起きあがり", 6)
	event.ObjsNextMotion(2, "立ち", 4)
	helper_410(46)
	if vm.skipping() then
		return skip(7)
	end
	event.SndSePlay(var1, 2)
	helper_410(30)
	if vm.skipping() then
		return skip(8)
	end
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "デフォルト顔")
	event.EohSetTexAnim(2, 1, "目左向き～前向き")
	helper_2980(2)
	if vm.skipping() then
		return skip(9)
	end
	event.SetCrossfade(30)
	event.CmrsSetPos(-65.53, 36.67, -170.72)
	event.CmrsSetRef(-72.23, 31.54, -186.28)
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "デフォルト顔")
	event.EohSetTexAnim(2, 1, "通常目パチ")
	event.SetPakuAnim(2, "通常口パク")
	helper_5fe0(5280010)
	if vm.skipping() then
		return skip(10)
	end
	event.CmrsSetPos(17.17, 21.0, 369.81)
	event.CmrsSetRef(-1.57, 20.75, 398.07)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "おこり顔")
	event.EohSetTexAnim(0, 1, "おこり目パチ")
	event.ObjsSetMotion(0, "左前見る", 6)
	event.ObjsNextMotion(0, "左前見るL", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_5fe0(5280020)
	if vm.skipping() then
		return skip(11)
	end
	event.CmrsSetPos(-72.45, 23.3, -129.48)
	event.CmrsSetRef(-72.45, 23.3, -169.9)
	event.PlayBgm(0)
	event.SndSePlay(var1, 3)
	event.EohSetFrameStatus(2, "sword--v0", 1)
	event.ObjsSetMotion(2, "剣だし", 6)
	event.ObjsNextMotion(2, "剣だしL", 4)
	event.SetPakuAnim(2, "通常口パク")
	helper_5fe0(5280030)
	if vm.skipping() then
		return skip(12)
	end
	event.CmrsSetPos(-51.78, 20.26, -260.52)
	event.CmrsSetRef(-58.41, 20.26, -190.32)
	event.SndSePlay(var1, 4)
	event.ObjsSetMotion(2, "ジャンプ", 6)
	helper_410(20)
	if vm.skipping() then
		return skip(13)
	end
	event.CmrsSetPos(17.17, 21.0, 369.81)
	event.CmrsSetRef(-1.57, 20.75, 398.07)
	event.ObjsSetMotion(0, "上見る", 6)
	event.ObjsNextMotion(0, "上見るL", 4)
	helper_2980(0)
	if vm.skipping() then
		return skip(14)
	end
	event.CmrsSetPos(6.12, 32.14, 446.85)
	event.CmrsSetRef(-0.05, 14.21, 365.23)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "おこり顔")
	event.EohSetTexAnim(0, 1, "おこり目パチ")
	event.EohSetTexAnim(0, 1, "半口")
	event.ObjsSetMotion(0, "上見る戻り", 6)
	event.ObjsNextMotion(0, "モニカ見立ち", 4)
	event.SndSePlay(var1, 5)
	event.ObjsSetPos(2, 0.0, 0.0, 260.0)
	event.ObjsSetMotion(2, "着地", 6)
	event.ObjsNextMotion(2, "着地L", 4)
	helper_2980(2)
	if vm.skipping() then
		return skip(15)
	end
	event.CmrsSetPos(9.03, 31.27, 338.8)
	event.CmrsSetRef(5.32, 18.96, 267.84)
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "おこり顔")
	event.EohSetTexAnim(2, 1, "おこり目パチ")
	event.ObjsSetMotion(2, "キメ", 6)
	event.ObjsNextMotion(2, "キメL", 4)
	event.SndSePlay(var1, 6)
	helper_410(30)
	if vm.skipping() then
		return skip(16)
	end
	event.SndSePlay(var1, 7)
	helper_2980(2)
	if vm.skipping() then
		return skip(17)
	end
	event.SetPakuAnim(2, "通常口パク")
	helper_5fe0(5280040)
	if vm.skipping() then
		return skip(18)
	end
	event.SetCrossfade(30)
	event.CmrsSetPos(1.63, 33.52, 291.68)
	event.CmrsSetRef(1.34, 31.08, 268.48)
	event.CmrsMove(5.68, 33.52, 291.63, 5.38, 31.08, 268.43, 120)
	event.SpriteSetDraw(0, 1)
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "おこり顔")
	event.EohSetTexAnim(2, 1, "おこり目パチ")
	event.EohSetTexAnim(2, 1, "わらい口とじ")
	helper_410(90)
	if vm.skipping() then
		return skip(19)
	end
	event.SetFadeOut(30)
	helper_410(30)
	if vm.skipping() then
		return skip(20)
	end
	return part2()
end

--- Helper function.
local function helper_15fb0()
	local active_chr_no: s32 = 0
	local var1: s32 = 0
	local block: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 62 then
			if at <= 1 then
				active_chr_no = 0
				helper_410(4)
			end
			if at <= 2 then
				helper_5fe0(5320010)
			end
			if at <= 3 then
				helper_410(40)
			end
			if at <= 4 then
				helper_2980(2)
			end
			if at <= 5 then
				helper_5fe0(5320020)
			end
			if at <= 6 then
				helper_5fe0(5320030)
			end
			if at <= 7 then
				helper_5fe0(5320040)
			end
			if at <= 8 then
				helper_5fe0(5320045)
			end
			if at <= 9 then
				helper_5fe0(5320050)
			end
			if at <= 10 then
				helper_2870()
			end
			if at <= 11 then
				helper_5fe0(5320060)
			end
			if at <= 12 then
				helper_5fe0(5320065)
			end
			if at <= 13 then
				helper_5fe0(5320070)
			end
			if at <= 14 then
				helper_5fe0(5320080)
			end
			if at <= 15 then
				helper_410(30)
			end
			if at <= 16 then
				helper_410(15)
			end
			if at <= 17 then
				helper_2980(1)
			end
			if at <= 18 then
				helper_410(20)
			end
			if at <= 19 then
				helper_5fe0(5320090)
			end
			if at <= 20 then
				helper_562c(5320100, 40)
			end
			if at <= 21 then
				helper_410(5)
			end
			if at <= 22 then
				helper_562c(5320110, 20)
			end
			if at <= 23 then
				helper_410(5)
			end
			if at <= 24 then
				helper_562c(5320120, 40)
			end
			if at <= 25 then
				helper_2980(1)
			end
			if at <= 26 then
				helper_5fe0(5320130)
			end
			if at <= 27 then
				helper_2980(0)
			end
			if at <= 28 then
				helper_2980(1)
			end
			if at <= 29 then
				helper_410(20)
			end
			if at <= 30 then
				helper_5fe0(5320140)
			end
			if at <= 31 then
				helper_2980(2)
			end
			if at <= 32 then
				helper_562c(5320150, -1)
			end
			if at <= 33 then
				helper_410(10)
			end
			if at <= 34 then
				helper_5fe0(5320155)
			end
			if at <= 35 then
				helper_2980(2)
			end
			if at <= 36 then
				helper_5fe0(5320160)
			end
			if at <= 37 then
				helper_2980(1)
			end
			if at <= 38 then
				helper_410(40)
			end
			if at <= 39 then
				helper_5fe0(5320170)
			end
			if at <= 40 then
				helper_2870()
			end
			if at <= 41 then
				helper_5fe0(5320180)
			end
			if at <= 42 then
				helper_5fe0(5320190)
			end
			if at <= 43 then
				helper_5fe0(5320200)
			end
			if at <= 44 then
				helper_2980(3)
			end
			if at <= 45 then
				helper_5fe0(5320210)
			end
			if at <= 46 then
				helper_5fe0(5320220)
			end
			if at <= 47 then
				helper_2980(4)
			end
			if at <= 48 then
				helper_5fe0(5320225)
			end
			if at <= 49 then
				helper_2980(5)
			end
			if at <= 50 then
				helper_5fe0(5320230)
			end
			if at <= 51 then
				helper_5fe0(5320240)
			end
			if at <= 52 then
				helper_5fe0(5320245)
			end
			if at <= 53 then
				helper_2980(6)
			end
			if at <= 54 then
				helper_5fe0(5320250)
			end
			if at <= 55 then
				helper_5fe0(5320260)
			end
			if at <= 56 then
				helper_2980(7)
			end
			if at <= 57 then
				helper_5fe0(5320270)
			end
			if at <= 58 then
				helper_2980(7)
			end
			if at <= 59 then
				helper_5fe0(5320275)
			end
			if vm.skip_end() then
				return skip(63)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SetCrossfade(60)
		event.PlayBgm(0)
		event.SetStatus(1, 0, 256, 0)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.SpriteSetDraw(0, 0)
		event.SpriteSetDraw(1, 0)
		event.SpriteSetDraw(2, 0)
		event.SpriteSetDraw(3, 0)
		event.SpriteSetDraw(4, 0)
		event.DelExtMotion(0)
		event.DeleteChara(8)
		event.DeleteChara(9)
		event.DeleteChara(10)
		event.DeleteChara(11)
		event.DeleteChara(12)
		event.DeleteChara(14)
		event.DelImg(0)
		event.LoadMes(0, -1)
		event.CmrsInit()
		event.SetStatusbarShow(1, 1.0)
		event.EohSetShow(3, 1)
		event.EohSetShow(4, 1)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFlag(532, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.SetStatusbarShow(0, 1.0)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no ~= 0 then
		event.DngSetupMainUnit(0)
		active_chr_no = 0
	end
	event.StopBgm(0)
	helper_410(4)
	if vm.skipping() then
		return skip(2)
	end
	event.LoadBgm(113)
	event.LoadSound(5820)
	var1 = event.SndLoadSound(5820) or var1
	event.SetStatus(1, 0, 256, 1)
	event.ChangeDir("event/e500/e532/")
	event.LoadMes(0, 5, "e532.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e532_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e532_monica.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.LoadChara(5, "e532_guiltoni.gltf", "info", 11)
	event.CharaActive(11)
	event.EohSyncChara(2, 11)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.LoadChara(5, "shuchusen.gltf", "info", 12)
	event.CharaActive(0, 12)
	event.LoadChara(5, "e532_syougeki.gltf", "info", 14)
	event.CharaActive(0, 14)
	event.EohSyncChara(11, 14)
	event.ObjsInit(9)
	event.ObjsSyncObj(9, 11)
	block = event.LoadImg_4(5, "e532.json", 0) or block
	event.SpriteInit(0)
	event.SpriteSetType(0, 0)
	event.SpriteSetTexture(0, "e53201", block)
	event.SpriteSetColor(0, 128, 128, 128, 0)
	event.SpriteSetUvsize(0, 0, 0, 512, 448)
	event.SpriteSetPutsize(0, 512, 448)
	event.SpriteSetPos(0, 256, 224)
	event.SpriteSetDraw(0, 1)
	event.EohSyncSprite(5, 0)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 5)
	event.SpriteInit(1)
	event.SpriteSetType(1, 0)
	event.SpriteSetTexture(1, "e53202", block)
	event.SpriteSetColor(1, 128, 128, 128, 0)
	event.SpriteSetUvsize(1, 0, 0, 512, 448)
	event.SpriteSetPutsize(1, 512, 448)
	event.SpriteSetPos(1, 256, 224)
	event.SpriteSetDraw(1, 1)
	event.EohSyncSprite(6, 1)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 6)
	event.SpriteInit(2)
	event.SpriteSetType(2, 0)
	event.SpriteSetTexture(2, "e53203", block)
	event.SpriteSetColor(2, 128, 128, 128, 0)
	event.SpriteSetUvsize(2, 0, 0, 512, 448)
	event.SpriteSetPutsize(2, 512, 448)
	event.SpriteSetPos(2, 256, 224)
	event.SpriteSetDraw(2, 1)
	event.EohSyncSprite(7, 2)
	event.ObjsInit(5)
	event.ObjsSyncObj(5, 7)
	event.SpriteInit(3)
	event.SpriteSetType(3, 0)
	event.SpriteSetTexture(3, "e53204", block)
	event.SpriteSetColor(3, 128, 128, 128, 0)
	event.SpriteSetUvsize(3, 0, 0, 512, 448)
	event.SpriteSetPutsize(3, 512, 448)
	event.SpriteSetPos(3, 256, 224)
	event.SpriteSetDraw(3, 1)
	event.EohSyncSprite(8, 3)
	event.ObjsInit(6)
	event.ObjsSyncObj(6, 8)
	event.SpriteInit(4)
	event.SpriteSetType(4, 0)
	event.SpriteSetTexture(4, "e53205", block)
	event.SpriteSetColor(4, 128, 128, 128, 0)
	event.SpriteSetUvsize(4, 0, 0, 512, 448)
	event.SpriteSetPutsize(4, 512, 448)
	event.SpriteSetPos(4, 256, 224)
	event.SpriteSetDraw(4, 1)
	event.EohSyncSprite(9, 4)
	event.ObjsInit(7)
	event.ObjsSyncObj(7, 9)
	event.ChangeDir("")
	if active_chr_no == 1 then
	else
		event.LoadChara(5, "chara/c02_base.gltf", "info", 8)
		event.LoadEquip(5, 1, 4, "info", 8)
		event.LoadEquip(5, 1, 3, "info", 8)
		event.LoadEquip(5, 1, 2, "info", 8, 9)
		event.LoadEquip(5, 1, 0, "info", 8, 10)
		event.LoadMotion(5, "event/e500/e532/e532_monica.gltf", "info", 8)
		event.EohSyncChara(1, 8)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.CharaActive(8)
	event.CharaActive(9)
	event.CharaActive(0, 10)
	event.EohSyncChara(3, 1)
	event.EohSyncChara(4, 2)
	event.EohSetPos(0, 0.0, 0.0, 100.0)
	event.EohSetRot(0, 0.0, 3.14, 0.0)
	event.EohSetMotion(0, "バトル立ち2", 4)
	event.EohSetFootSoundId(0, 2)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "おこり顔")
	event.EohSetTexAnim(0, 1, "おこり目パチ")
	event.EohSetPos(1, -100.0, 0.0, -200.0)
	event.EohSetRot(1, 0.0, 2.54, 0.0)
	event.EohSetMotion(1, "起きあがり待ち", 4)
	event.EohNormalDrive(1)
	event.EohResetDaPosition(1)
	event.EohSetFootSoundId(1, 2)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "死に")
	event.EohSetPos(2, 0.0, 0.0, 0.0)
	event.EohSetRot(2, 0.0, 0.0, 0.0)
	event.EohSetMotion(2, "はぁはぁ", 4)
	event.EohNormalDrive(2)
	event.EohResetDaPosition(2)
	event.EohSetSoundId(2, var1)
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "苦し顔")
	event.EohSetTexAnim(2, 1, "苦し目パチ")
	event.SetCharaPos(12, 0.0, -1000.0, 0.0)
	event.InitDramaScene()
	event.CmrsInit()
	event.CmrsSetPos(38.02, 17.95, 16.08)
	event.CmrsSetRef(5.45, 17.89, 15.92)
	event.SetFadeIn(30)
	event.SetPakuAnim(2, "苦し口パク")
	helper_5fe0(5320010)
	if vm.skipping() then
		return skip(3)
	end
	event.CmrsSetPos(24.94, 8.23, 72.51)
	event.CmrsSetRef(1.57, 16.42, 98.07)
	helper_410(40)
	if vm.skipping() then
		return skip(4)
	end
	event.CmrsSetPos(-3.92, 12.48, 46.35)
	event.CmrsSetRef(0.46, 18.98, 16.47)
	event.ObjsSetMotion(2, "顔上げ", 6)
	event.ObjsNextMotion(2, "顔上げL", 4)
	helper_2980(2)
	if vm.skipping() then
		return skip(5)
	end
	event.SetPakuAnim(2, "苦し口パク")
	helper_5fe0(5320020)
	if vm.skipping() then
		return skip(6)
	end
	event.CmrsSetPos(24.94, 8.23, 72.51)
	event.CmrsSetRef(1.57, 16.42, 98.07)
	event.SetPakuAnim(0, "通常口パク")
	helper_5fe0(5320030)
	if vm.skipping() then
		return skip(7)
	end
	event.CmrsSetRef(0.0, 20.0, 50.0)
	event.CmrsSetAhd(-0.36, 0.0, 100.0)
	event.CmrsMoveAhd2(2.64, 0.0, 100.0, 280, 2, 1.0)
	event.SetPakuAnim(2, "苦し口パク")
	helper_5fe0(5320040)
	if vm.skipping() then
		return skip(8)
	end
	event.SetPakuAnim(2, "苦し口パク")
	helper_5fe0(5320045)
	if vm.skipping() then
		return skip(9)
	end
	event.SetPakuAnim(0, "通常口パク")
	helper_5fe0(5320050)
	if vm.skipping() then
		return skip(10)
	end
	helper_2870()
	if vm.skipping() then
		return skip(11)
	end
	event.CmrsSetPos(16.36, 17.95, 32.78)
	event.CmrsSetRef(0.93, 19.2, 17.0)
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "苦し顔")
	event.EohSetTexAnim(2, 1, "苦し目あき～目とじ")
	event.SetPakuAnim(2, "わらい口パク")
	helper_5fe0(5320060)
	if vm.skipping() then
		return skip(12)
	end
	event.SetPakuAnim(2, "わらい口パク")
	helper_5fe0(5320065)
	if vm.skipping() then
		return skip(13)
	end
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "苦し顔")
	event.EohSetTexAnim(2, 1, "目とじ～苦し目あき")
	event.SetPakuAnim(2, "わらい口パク")
	helper_5fe0(5320070)
	if vm.skipping() then
		return skip(14)
	end
	event.CmrsSetPos(16.15, 37.27, 153.71)
	event.CmrsSetRef(3.58, 24.38, 96.09)
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "おこり顔")
	event.EohSetTexAnim(2, 1, "苦し目パチ")
	event.SetPakuAnim(0, "通常口パク")
	helper_5fe0(5320080)
	if vm.skipping() then
		return skip(15)
	end
	event.SndSePlay(var1, 2)
	event.ObjsSetMotion(2, "起きあがり", 6)
	event.ObjsNextMotion(2, "起きあがりL", 4)
	helper_410(30)
	if vm.skipping() then
		return skip(16)
	end
	event.ObjsSetMotion(1, "起きあがり", 6)
	event.ObjsNextMotion(1, "起きあがりL", 4)
	helper_410(15)
	if vm.skipping() then
		return skip(17)
	end
	event.CmrsSetPos(-84.02, 9.18, -188.66)
	event.CmrsSetRef(-99.08, 9.86, -193.29)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "死に")
	event.EohSetTexAnim(1, 1, "目とじ～目あき")
	event.SndSePlay(var1, 3)
	helper_2980(1)
	if vm.skipping() then
		return skip(18)
	end
	helper_410(20)
	if vm.skipping() then
		return skip(19)
	end
	event.CmrsSetPos(-23.98, 12.62, 43.97)
	event.CmrsSetRef(-1.29, 22.54, 7.67)
	event.SetPakuAnim(2, "通常口パク")
	helper_5fe0(5320090)
	if vm.skipping() then
		return skip(20)
	end
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "おこり顔")
	event.EohSetTexAnim(1, 1, "おこり目パチ")
	event.EohSetTexAnim(1, 1, "口とじ～大口")
	event.CharaActive(12)
	event.CmrsSyncObj(1, 0.0, 20.0, 7.0, -1.0, 0.0, 40.0)
	event.CmrsAhddelay(19)
	event.CmrsReleaseObj()
	event.CmrsPrdelay(20)
	event.CmrsSetPos(-26.37, 17.77, -50.44)
	event.CmrsSetRef(-51.96, 20.0, -102.44)
	event.CmrsCharaDelay(20)
	event.CmrsCharaAttach(12, 60.0, 20)
	event.CharaActive(1, 10)
	event.ObjsSetRot(1, 0.0, 0.46, 0.0)
	event.ObjsSetMotion(1, "剣走り", 4, -1.0, 1)
	event.ObjsMove(1, -11.76, 0.0, -20.14, 60)
	event.ObjsTexaDelay(1, 20)
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "おこり顔")
	event.ObjsTexAnime(1, 1, "おこり目パチ")
	event.ObjsTexAnime(1, 1, "歯くいしばり")
	helper_562c(5320100, 40)
	if vm.skipping() then
		return skip(21)
	end
	event.CharaActive(0, 12)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "おこり顔")
	event.EohSetTexAnim(1, 1, "おこり目パチ")
	event.EohSetTexAnim(1, 1, "半口")
	event.CmrsSetPos(-69.98, 14.49, -24.99)
	event.CmrsSetRef(-2.25, 17.76, -8.93)
	event.CmrsPrdelay(45)
	event.CmrsSetPos(-52.69, 22.4, 13.43)
	event.CmrsSetRef(-30.89, 6.61, -41.34)
	event.ObjsSetRot(2, 0.0, -2.4, 0.0)
	event.ObjsMotionDelay(2, 10)
	event.ObjsSetMotion(2, "よけ", 6)
	event.ObjsNextMotion(2, "ふっとばし", 6)
	event.ObjsTexaDelay(2, 40)
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "おこり顔")
	event.ObjsTexAnime(2, 1, "おこり目パチ")
	event.ObjsTexAnime(2, 1, "口ふっ")
	event.ObjsSetMotion(1, "斬り", 6)
	event.ObjsNextMotion(1, "吹っ飛び", 6)
	event.ObjsPosDelay(1, 20)
	event.ObjsMove2(1, -34.13, 0.0, -72.15, 26, 2, 1.0)
	event.ObjsSePlay(1, var1, 4)
	event.ObjsSeDelay(1, 50)
	event.ObjsSePlay(1, var1, 6)
	event.ObjsTexaDelay(1, 20)
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "おこり顔")
	event.ObjsTexAnime(1, 1, "目あき～目とじ")
	event.ObjsTexAnime(1, 1, "半口")
	event.CharaActive(1, 14)
	event.ObjsSetPos(2, 0.0, 0.0, 0.0)
	event.ObjsSetRot(9, 0.0, -2.4, 0.0)
	event.ObjsSetMotion(9, "ふっとばし", 5)
	event.ObjsMotionDelay(9, 26)
	event.ObjsSetMotion(9, "ふっとばし", 6)
	event.ObjsSeDelay(9, 34)
	event.ObjsSePlay(9, var1, 5)
	helper_410(5)
	if vm.skipping() then
		return skip(22)
	end
	helper_562c(5320110, 20)
	if vm.skipping() then
		return skip(23)
	end
	helper_410(5)
	if vm.skipping() then
		return skip(24)
	end
	helper_562c(5320120, 40)
	if vm.skipping() then
		return skip(25)
	end
	helper_2980(1)
	if vm.skipping() then
		return skip(26)
	end
	event.CharaActive(0, 14)
	event.CmrsSetPos(24.94, 8.23, 72.51)
	event.CmrsSetRef(1.57, 16.42, 98.07)
	event.ObjsSetMotion(0, "モニカ！！", 6)
	event.ObjsNextMotion(0, "モニカ！！L", 4)
	event.SetPakuAnim(0, "大口パク")
	helper_5fe0(5320130)
	if vm.skipping() then
		return skip(27)
	end
	helper_2980(0)
	if vm.skipping() then
		return skip(28)
	end
	event.CmrsSetPos(-18.95, 19.99, -37.66)
	event.CmrsSetRef(-30.66, 14.75, -65.72)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "おこり顔")
	event.EohSetTexAnim(1, 1, "おこり目パチ")
	event.SndSePlay(var1, 7)
	event.ObjsSetMotion(1, "しゃがみにらみ", 6, -1.0, 1)
	event.ObjsNextMotion(1, "しゃがみにらみL", 4)
	helper_2980(1)
	if vm.skipping() then
		return skip(29)
	end
	helper_410(20)
	if vm.skipping() then
		return skip(30)
	end
	event.CmrsSetPos(-57.1, 14.78, -90.75)
	event.CmrsSetRef(-21.25, 17.36, -33.53)
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "わらい顔")
	event.EohSetTexAnim(2, 1, "おこり目パチ")
	event.SndSePlay(var1, 8)
	event.ObjsSetRot(2, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(2, "後ろ見", 6)
	event.ObjsNextMotion(2, "後ろ見L", 4)
	event.SetPakuAnim(2, "通常口パク")
	helper_5fe0(5320140)
	if vm.skipping() then
		return skip(31)
	end
	helper_2980(2)
	if vm.skipping() then
		return skip(32)
	end
	event.CmrsSetPos(0.0, 27.09, 35.56)
	event.CmrsSetRef(0.0, 29.67, -20.86)
	event.PlayBgm(0)
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "わらい顔")
	event.EohSetTexAnim(2, 1, "おこり目パチ")
	event.ObjsSetMotion(2, "笑う", 4)
	event.ObjsMotionDelay(2, 140)
	event.ObjsSetMotion(2, "笑う2")
	event.ObjsTexaDelay(2, 140)
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "わらい顔")
	event.ObjsTexAnime(2, 1, "おこり目～大わらい目")
	event.ObjsTexAnime(2, 1, "大わらい口パク")
	helper_562c(5320150, -1)
	if vm.skipping() then
		return skip(33)
	end
	helper_410(10)
	if vm.skipping() then
		return skip(34)
	end
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "わらい顔")
	event.EohSetTexAnim(2, 1, "大わらい目～通常目")
	event.SndSePlay(var1, 9)
	event.ObjsSetMotion(2, "戻り", 2)
	event.ObjsNextMotion(2, "立ち", 4)
	event.SetPakuAnim(2, "わらい口パク")
	helper_5fe0(5320155)
	if vm.skipping() then
		return skip(35)
	end
	helper_2980(2)
	if vm.skipping() then
		return skip(36)
	end
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "わらい顔")
	event.EohSetTexAnim(2, 1, "前向き～右向き")
	event.ObjsSetMotion(1, "立つ", 2)
	event.ObjsNextMotion(1, "立つL", 4)
	event.ObjsSeDelay(1, 4)
	event.ObjsSePlay(1, var1, 10)
	event.SetPakuAnim(1, "通常口パク")
	helper_5fe0(5320160)
	if vm.skipping() then
		return skip(37)
	end
	helper_2980(1)
	if vm.skipping() then
		return skip(38)
	end
	event.CmrsSetPos(24.94, 8.23, 72.51)
	event.CmrsSetRef(1.57, 16.42, 98.07)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "おこり顔")
	event.EohSetTexAnim(0, 1, "おこり目パチ")
	event.EohSetTexAnim(0, 1, "歯くいしばり")
	event.ObjsSetMotion(0, "バトル立ち2", 4)
	helper_410(40)
	if vm.skipping() then
		return skip(39)
	end
	event.CmrsSetPos(1.0, 31.0, 29.43)
	event.CmrsSetRef(1.0, 31.0, 1.39)
	event.CmrsMove2(1.0, 31.0, 23.46, 1.0, 31.0, 1.39, 90, 2, 1.0)
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "デフォルト顔")
	event.EohSetTexAnim(2, 1, "通常目パチ")
	event.ObjsTexaDelay(2, 120)
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "デフォルト顔")
	event.ObjsTexAnime(2, 1, "目あき～目とじ")
	event.SetPakuAnim(2, "通常口パク")
	helper_5fe0(5320170)
	if vm.skipping() then
		return skip(40)
	end
	helper_2870()
	if vm.skipping() then
		return skip(41)
	end
	event.SndSetEnvVol(0.0)
	event.ObjsSetColor(3, 128, 128, 128, 128, 10)
	event.SetPakuAnim(2, "通常口パク")
	helper_5fe0(5320180)
	if vm.skipping() then
		return skip(42)
	end
	event.SetPakuAnim(2, "通常口パク")
	helper_5fe0(5320190)
	if vm.skipping() then
		return skip(43)
	end
	event.SetPakuAnim(2, "通常口パク")
	helper_5fe0(5320200)
	if vm.skipping() then
		return skip(44)
	end
	helper_2980(3)
	if vm.skipping() then
		return skip(45)
	end
	event.ObjsSetColor(4, 128, 128, 128, 128, 10)
	event.SetPakuAnim(2, "通常口パク")
	helper_5fe0(5320210)
	if vm.skipping() then
		return skip(46)
	end
	event.SetPakuAnim(2, "通常口パク")
	helper_5fe0(5320220)
	if vm.skipping() then
		return skip(47)
	end
	helper_2980(4)
	if vm.skipping() then
		return skip(48)
	end
	event.ObjsSetColor(3, 128, 128, 128, 0)
	event.ObjsSetColor(5, 128, 128, 128, 128, 10)
	event.SetPakuAnim(2, "通常口パク")
	helper_5fe0(5320225)
	if vm.skipping() then
		return skip(49)
	end
	helper_2980(5)
	if vm.skipping() then
		return skip(50)
	end
	event.ObjsSetColor(4, 128, 128, 128, 0)
	event.ObjsSetColor(6, 128, 128, 128, 128, 10)
	event.SetPakuAnim(2, "通常口パク")
	helper_5fe0(5320230)
	if vm.skipping() then
		return skip(51)
	end
	event.SetPakuAnim(2, "通常口パク")
	helper_5fe0(5320240)
	if vm.skipping() then
		return skip(52)
	end
	event.SetPakuAnim(2, "通常口パク")
	helper_5fe0(5320245)
	if vm.skipping() then
		return skip(53)
	end
	helper_2980(6)
	if vm.skipping() then
		return skip(54)
	end
	event.ObjsSetColor(5, 128, 128, 128, 0)
	event.ObjsSetColor(7, 128, 128, 128, 128, 10)
	event.SetPakuAnim(2, "通常口パク")
	helper_5fe0(5320250)
	if vm.skipping() then
		return skip(55)
	end
	event.SetPakuAnim(2, "通常口パク")
	helper_5fe0(5320260)
	if vm.skipping() then
		return skip(56)
	end
	helper_2980(7)
	if vm.skipping() then
		return skip(57)
	end
	event.ObjsSetColor(6, 128, 128, 128, 0)
	event.ObjsSetColor(7, 128, 128, 128, 0, 30)
	event.SndSetEnvVol(1.0)
	event.SetPakuAnim(2, "通常口パク")
	helper_5fe0(5320270)
	if vm.skipping() then
		return skip(58)
	end
	helper_2980(7)
	if vm.skipping() then
		return skip(59)
	end
	event.SetPakuAnim(2, "通常口パク")
	helper_5fe0(5320275)
	if vm.skipping() then
		return skip(60)
	end
	if vm.wait() then
		return skip(61)
	end
	if vm.wait() then
		return skip(62)
	end
	return part2()
end

--- Helper function.
local function helper_1018()
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
local function helper_1c2b8()
	local active_chr_no: s32 = 0
	local var1: s32 = 0
	local block: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 48 then
			if at <= 1 then
				helper_5fe0(5320390)
			end
			if at <= 2 then
				helper_5fe0(5320400)
			end
			if at <= 3 then
				helper_5fe0(5320410)
			end
			if at <= 4 then
				helper_2870()
			end
			if at <= 5 then
				helper_5fe0(5320420)
			end
			if at <= 6 then
				helper_5fe0(5320430)
			end
			if at <= 7 then
				helper_5fe0(5320435)
			end
			if at <= 8 then
				helper_2870()
			end
			if at <= 9 then
				helper_5fe0(5320440)
			end
			if at <= 10 then
				helper_2980(2)
			end
			if at <= 11 then
				helper_5fe0(5320450)
			end
			if at <= 12 then
				helper_2870()
			end
			if at <= 13 then
				helper_5fe0(5320460)
			end
			if at <= 14 then
				helper_5fe0(5320465)
			end
			if at <= 15 then
				helper_410(12)
			end
			if at <= 16 then
				helper_2980(2)
			end
			if at <= 17 then
				helper_410(5)
			end
			if at <= 18 then
				helper_410(5)
			end
			if at <= 19 then
				helper_2980(2)
			end
			if at <= 20 then
				helper_410(20)
			end
			if at <= 21 then
				helper_410(10)
			end
			if at <= 22 then
				helper_2870()
			end
			if at <= 23 then
				helper_410(30)
			end
			if at <= 24 then
				helper_2980(2)
			end
			if at <= 25 then
				helper_5fe0(5320480)
			end
			if at <= 26 then
				helper_2980(2)
			end
			if at <= 27 then
				helper_2870()
			end
			if at <= 28 then
				helper_5fe0(5320490)
			end
			if at <= 29 then
				helper_2870()
			end
			if at <= 30 then
				helper_5fe0(5320500)
			end
			if at <= 31 then
				helper_5fe0(5320510)
			end
			if at <= 32 then
				helper_5fe0(5320515)
			end
			if at <= 33 then
				helper_5fe0(5320520)
			end
			if at <= 34 then
				helper_2870()
			end
			if at <= 35 then
				helper_5fe0(5320530)
			end
			if at <= 36 then
				helper_5fe0(5320540)
			end
			if at <= 37 then
				helper_1018()
			end
			if at <= 38 then
				helper_2870()
			end
			if at <= 39 then
				helper_410(10)
			end
			if at <= 40 then
				helper_410(4)
			end
			if at <= 41 then
				helper_2980(1)
			end
			if at <= 42 then
				helper_410(10)
			end
			if at <= 43 then
				helper_410(10)
			end
			if at <= 44 then
				helper_5fe0(5320550)
			end
			if at <= 45 then
				helper_5fe0(5320560)
			end
			if at <= 46 then
				helper_410(90)
			end
			if at <= 47 then
				helper_410(30)
			end
			if vm.skip_end() then
				return skip(49)
			end
			return part2()
		end
		if at <= 49 then
			helper_410(4)
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SndSeStop(var1, 16)
		var3 = event.GetBgmNo() or var3
		if var3 ~= 35 then
			event.StopBgm(0)
			helper_410(4)
			if vm.skipping() then
				return skip(50)
			end
			event.LoadBgm(35)
			event.PlayBgm(0)
		end
		event.SpriteSetDraw(0, 0)
		event.SetStatus(1, 0, 256, 0)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.SpriteSetDraw(0, 0)
		event.SpriteSetDraw(1, 0)
		event.SpriteSetDraw(2, 0)
		event.SpriteSetDraw(3, 0)
		event.SpriteSetDraw(4, 0)
		event.DelExtMotion(0)
		event.DeleteChara(8)
		event.DeleteChara(9)
		event.DeleteChara(11)
		event.DeleteChara(13)
		event.DeleteChara(15)
		event.DeleteChara(16)
		event.DeleteChara(17)
		event.DeleteChara(18)
		event.DeleteChara(19)
		event.DelImg(0)
		event.LoadMes(0, -1)
		event.CmrsInit()
		event.SetStatusbarShow(1, 1.0)
		event.EohSetShow(3, 1)
		event.EohSetShow(4, 1)
	end
	event.SetFlag(532, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.SetStatusbarShow(0, 1.0)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no ~= 0 then
		event.DngSetupMainUnit(0)
		active_chr_no = 0
	end
	event.LoadSound(5822)
	var1 = event.SndLoadSound(5822) or var1
	event.SetStatus(1, 0, 256, 1)
	event.ChangeDir("event/e500/e532/")
	event.LoadMes(0, 5, "e532.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e532_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e532_monica.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.LoadChara(5, "e532_guiltoni.gltf", "info", 11)
	event.CharaActive(11)
	event.EohSyncChara(2, 11)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.LoadChara(5, "e532_m_guil.gltf", "p00_23a", 13)
	event.CharaActive(0, 13)
	event.EohSyncChara(10, 13)
	event.ObjsInit(8)
	event.ObjsSyncObj(8, 10)
	event.LoadChara(5, "e532_kawaru_hikari.gltf", "info", 15)
	event.CharaActive(0, 15)
	event.LoadChara(5, "e532_guil_kage.gltf", "info", 16)
	event.CharaActive(0, 16)
	event.LoadChara(5, "e532_tgate_f.gltf", "info", 17)
	event.CharaActive(0, 17)
	event.LoadChara(5, "e532_tgate_h.gltf", "info", 18)
	event.CharaActive(0, 18)
	block = event.LoadImg_4(5, "e532telop01.json", 0) or block
	event.SpriteInit(0)
	event.SpriteSetType(0, 0)
	event.SpriteSetTexture(0, "e532telop01", block)
	event.SpriteSetColor(0, 128, 128, 128, 0)
	event.SpriteSetUvsize(0, 0, 0, 512, 128)
	event.SpriteSetPutsize(0, 512, 128)
	event.SpriteSetPos(0, 256, 347)
	event.SpriteSetAlphab(0, 0)
	event.SpriteSetDraw(0, 0)
	event.EohSyncSprite(12, 0)
	event.ObjsInit(10)
	event.ObjsSyncObj(10, 12)
	event.ChangeDir("")
	event.LoadChara(5, "event/time_gate/red/tg_maru_red.gltf", "info", 19)
	event.CharaActive(0, 19)
	if active_chr_no == 1 then
	else
		event.LoadChara(5, "chara/c02_base.gltf", "info", 8)
		event.LoadEquip(5, 1, 4, "info", 8)
		event.LoadEquip(5, 1, 3, "info", 8)
		event.LoadEquip(5, 1, 2, "info", 8, 9)
		event.LoadMotion(5, "event/e500/e532/e532_monica.gltf", "info", 8)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 8)
		event.EohSyncChara(1, 8)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 0)
	end
	event.CharaActive(8)
	event.CharaActive(9)
	event.EohSyncChara(3, 1)
	event.EohSyncChara(4, 2)
	event.EohSetShow(3, 0)
	event.EohSetShow(4, 0)
	event.EohSetPos(0, 0.0, 0.0, 100.0)
	event.EohSetRot(0, 0.0, 3.14, 0.0)
	event.EohSetMotion(0, "立ち", 4)
	event.EohSetFootSoundId(0, 2)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "おこり顔")
	event.EohSetTexAnim(0, 1, "おこり目パチ")
	event.EohSetTexAnim(0, 1, "半口")
	event.EohSetPos(1, -34.13, 0.0, -72.15)
	event.EohSetRot(1, 0.0, 0.46, 0.0)
	event.EohSetMotion(1, "立つL", 4)
	event.EohNormalDrive(1)
	event.EohResetDaPosition(1)
	event.EohSetFootSoundId(1, 2)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "無表情")
	event.EohSetTexAnim(1, 1, "通常目パチ")
	event.EohSetPos(2, 0.0, 0.0, 0.0)
	event.EohSetRot(2, 0.0, 0.0, 0.0)
	event.EohSetMotion(2, "下向き立ち", 4)
	event.EohNormalDrive(2)
	event.EohResetDaPosition(2)
	event.EohSetSoundId(2, var1)
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "わらい顔")
	event.EohSetTexAnim(2, 1, "目とじ")
	event.EohSetPos(10, 48.15, 0.0, -39.92)
	event.EohSetRot(10, 0.0, -0.96, 0.0)
	event.EohSetMotion(10, "立ち2", 4)
	event.InitDramaScene()
	event.CmrsInit()
	event.CmrsSetPos(1.0, 31.0, 23.46)
	event.CmrsSetRef(1.0, 31.0, 1.39)
	event.SetPakuAnim(2, "わらい口パク")
	helper_5fe0(5320380)
	if vm.skipping() then
		return skip(1)
	end
	event.SetPakuAnim(2, "わらい口パク")
	helper_5fe0(5320390)
	if vm.skipping() then
		return skip(2)
	end
	event.CmrsSetPos(32.47, 29.12, 7.82)
	event.CmrsSetRef(-0.08, 29.06, 7.66)
	event.CmrsMove2(32.49, 29.12, 2.2, -0.05, 29.06, 2.04, 90, 2, 1.0)
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "わらい顔")
	event.EohSetTexAnim(2, 1, "目とじ～目あけ")
	event.SetPakuAnim(2, "わらい口パク")
	helper_5fe0(5320400)
	if vm.skipping() then
		return skip(3)
	end
	event.SetPakuAnim(2, "わらい口パク")
	helper_5fe0(5320410)
	if vm.skipping() then
		return skip(4)
	end
	helper_2870()
	if vm.skipping() then
		return skip(5)
	end
	event.CmrsSetPos(-11.1, 23.74, 47.57)
	event.CmrsSetRef(-11.12, 23.68, 10.21)
	event.CmrsMove2(1.26, 23.74, 47.57, 1.24, 23.68, 10.2, 120, 2, 1.0)
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "デフォルト顔")
	event.EohSetTexAnim(2, 1, "目とじ")
	event.SetPakuAnim(1, "通常口パク")
	helper_5fe0(5320420)
	if vm.skipping() then
		return skip(6)
	end
	event.SetPakuAnim(2, "通常口パク")
	helper_5fe0(5320430)
	if vm.skipping() then
		return skip(7)
	end
	event.SetPakuAnim(2, "通常口パク")
	helper_5fe0(5320435)
	if vm.skipping() then
		return skip(8)
	end
	helper_2870()
	if vm.skipping() then
		return skip(9)
	end
	event.CmrsSetPos(21.93, 20.24, 29.75)
	event.CmrsSetRef(0.34, 28.43, 3.64)
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "デフォルト顔")
	event.EohSetTexAnim(2, 1, "目とじ～目あき")
	event.ObjsSetMotion(2, "普通立ちへ", 6)
	event.ObjsNextMotion(2, "立ち", 4)
	event.SetPakuAnim(2, "通常口パク")
	helper_5fe0(5320440)
	if vm.skipping() then
		return skip(10)
	end
	helper_2980(2)
	if vm.skipping() then
		return skip(11)
	end
	event.CmrsSetPos(21.31, 32.88, -28.93)
	event.CmrsSetRef(15.92, 30.08, 1.51)
	event.CmrsMove2(11.89, 32.88, -30.6, 6.5, 30.08, -0.16, 90, 2, 1.0)
	event.SetPakuAnim(2, "通常口パク")
	helper_5fe0(5320450)
	if vm.skipping() then
		return skip(12)
	end
	helper_2870()
	if vm.skipping() then
		return skip(13)
	end
	event.CmrsSetPos(21.93, 20.24, 29.75)
	event.CmrsSetRef(0.34, 28.43, 3.64)
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "わらい顔")
	event.EohSetTexAnim(2, 1, "通常目パチ")
	event.SetPakuAnim(2, "わらい口パク")
	helper_5fe0(5320460)
	if vm.skipping() then
		return skip(14)
	end
	event.SetPakuAnim(2, "わらい口パク")
	helper_5fe0(5320465)
	if vm.skipping() then
		return skip(15)
	end
	event.SndSePlay(var1, 13)
	event.ObjsRotation(2, 0.0, 2.04, 0.0, 12)
	event.ObjsMove(2, 112.86, 0.0, -57.4, 120)
	event.ObjsSetMotion(2, "歩き")
	event.ObjsMotionDelay(2, 120)
	event.ObjsSetMotion(2, "立ち")
	helper_410(12)
	if vm.skipping() then
		return skip(16)
	end
	event.CmrsSetPos(12.52, 143.33, 237.6)
	event.CmrsSetRef(19.7, 10.27, 44.27)
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "デフォルト顔")
	event.EohSetTexAnim(2, 1, "通常目パチ")
	helper_2980(2)
	if vm.skipping() then
		return skip(17)
	end
	helper_410(5)
	if vm.skipping() then
		return skip(18)
	end
	event.CmrsSetPos(193.83, 30.9, -96.26)
	event.CmrsSetRef(115.38, 26.4, -60.1)
	event.ObjsSetRot(0, 0.0, 2.54, 0.0)
	event.ObjsResetDaPosition(0)
	event.ObjsSetRot(1, 0.0, 1.54, 0.0)
	event.ObjsResetDaPosition(1)
	helper_410(5)
	if vm.skipping() then
		return skip(19)
	end
	event.SndSePlay(var1, 14)
	event.ObjsSetMotion(2, "魔法構え", 2)
	event.ObjsNextMotion(2, "魔法構えL", 4)
	helper_2980(2)
	if vm.skipping() then
		return skip(20)
	end
	event.SndSePlay(var1, 15)
	event.CharaActive(1, 17)
	event.SetCharaPos(17, 112.86, 0.0, -57.4)
	event.SetCharaRot(17, 0.0, 2.04, 0.0)
	event.SetMotion(17, "魔法構えL", 6)
	helper_410(20)
	if vm.skipping() then
		return skip(21)
	end
	event.CmrsSetPos(93.61, 28.03, 33.84)
	event.CmrsSetRef(141.27, 27.9, -88.39)
	event.CmrsMove2(139.2, 30.07, -23.94, 196.24, 29.95, -119.09, 60, 2, 0.4)
	event.CharaActive(1, 18)
	event.SetCharaPos(18, 177.89, 30.0, -88.76)
	event.SetCharaRot(18, 0.0, 0.0, 0.0)
	event.SetMotion(18, "発生", 6)
	helper_410(10)
	if vm.skipping() then
		return skip(22)
	end
	event.CharaActive(1, 19)
	event.SetCharaPos(19, 177.89, 30.0, -88.76)
	event.SetCharaRot(19, 0.0, 0.0, 0.0)
	event.SetCharaShow(19, 1, 1, 0.1)
	helper_2870()
	if vm.skipping() then
		return skip(23)
	end
	helper_410(30)
	if vm.skipping() then
		return skip(24)
	end
	event.CmrsSetPos(-83.46, 20.24, 40.29)
	event.CmrsSetRef(25.57, 18.02, -14.67)
	event.ObjsSetPos(0, -34.9, 0.0, 31.89)
	event.ObjsSetRot(0, 0.0, 2.18, 0.0)
	event.ObjsResetDaPosition(0)
	event.ObjsSetPos(1, -54.15, 0.0, 12.15)
	event.ObjsSetRot(1, 0.0, 2.02, 0.0)
	event.ObjsResetDaPosition(1)
	event.ObjsMove(2, 149.89, 0.0, -76.07, 40)
	event.ObjsSetMotion(2, "歩き")
	event.ObjsMotionDelay(2, 40)
	helper_2980(2)
	if vm.skipping() then
		return skip(25)
	end
	event.CmrsSetPos(195.01, 15.44, -79.93)
	event.CmrsSetRef(159.74, 21.63, -83.99)
	event.StopBgm(0)
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "デフォルト顔")
	event.EohSetTexAnim(2, 1, "通常目～くるし目")
	event.SndSePlay(var1, 16)
	event.CharaActive(0, 17)
	event.CharaActive(0, 18)
	event.CharaActive(0, 19)
	event.CharaActive(1, 15)
	event.SetCharaShow(15, 1, 1, 0.033333335)
	event.SetCharaPos(15, 161.48, 0.0, -80.57)
	event.SetCharaRot(15, 0.0, 2.04, 0.0)
	event.ObjsSetMotion(2, "うぐっ", 6)
	event.ObjsNextMotion(2, "頭抱え", 6)
	event.ObjsNextMotion(2, "頭抱えL", 4)
	event.ObjsSePlay(2, var1, 17)
	event.ObjsSeDelay(2, 30)
	event.ObjsSePlay(2, var1, 18)
	event.ObjsTexaDelay(2, 30)
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "苦し顔")
	event.ObjsTexAnime(2, 1, "苦し目パチ")
	event.ObjsTexAnime(2, 1, "口とじ～大口")
	event.CmrsPrdelay(30)
	event.CmrsSetPos(185.9, 26.26, -83.55)
	event.CmrsSetRef(160.82, 28.01, -82.54)
	event.CmrsMove2(225.88, 13.42, -85.2, 160.83, 18.04, -82.53, 60, 0, 1.0)
	event.SetPakuAnim(2, "苦し口パク")
	helper_5fe0(5320480)
	if vm.skipping() then
		return skip(26)
	end
	helper_2980(2)
	if vm.skipping() then
		return skip(27)
	end
	helper_2870()
	if vm.skipping() then
		return skip(28)
	end
	event.CmrsSetPos(-153.15, 54.88, 77.9)
	event.CmrsSetRef(-32.02, 26.4, 15.61)
	event.CmrsMove2(-153.15, 54.88, 77.9, -32.02, 93.93, 15.61, 60, 0, 1.0)
	helper_5fe0(5320490)
	if vm.skipping() then
		return skip(29)
	end
	helper_2870()
	if vm.skipping() then
		return skip(30)
	end
	event.CmrsSetPos(-45.58, 18.39, -25.71)
	event.CmrsSetRef(-44.29, 20.81, 21.82)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "おこり顔")
	event.EohSetTexAnim(1, 1, "おこり目パチ")
	event.SndSePlay(var1, 19)
	event.ObjsSetMotion(0, "上向く", 6)
	event.ObjsNextMotion(0, "上向くL", 4)
	event.ObjsSetMotion(1, "上向く", 6)
	event.ObjsNextMotion(1, "上向くL", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_5fe0(5320500)
	if vm.skipping() then
		return skip(31)
	end
	event.ObjsSetMotion(1, "上向く", 6)
	event.CmrsSetPos(152.29, 17.2, -116.31)
	event.CmrsSetRef(169.35, 16.15, -86.33)
	event.CmrsMoveRef(163.62, 23.13, -83.64, 120)
	event.CmrsMoveAhd2(1.42, -8.07, 36.58, 90, 0, 1.0)
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "苦し顔")
	event.ObjsTexAnime(2, 1, "苦し目パチ")
	event.ObjsSetMotion(2, "苦しむ", 6)
	event.ObjsNextMotion(2, "苦しむL", 4)
	event.ObjsSeDelay(2, 30)
	event.ObjsSePlay(2, var1, 20)
	helper_5fe0(5320510)
	if vm.skipping() then
		return skip(32)
	end
	helper_5fe0(5320515)
	if vm.skipping() then
		return skip(33)
	end
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "苦し顔")
	event.ObjsTexAnime(2, 1, "苦し目とじ")
	event.SetPakuAnim(2, "苦し口パク")
	helper_5fe0(5320520)
	if vm.skipping() then
		return skip(34)
	end
	helper_2870()
	if vm.skipping() then
		return skip(35)
	end
	event.CmrsSetPos(-65.76, 1.45, 77.12)
	event.CmrsSetRef(-31.95, 23.15, 22.39)
	event.ObjsSetPos(0, -54.15, 0.0, 12.15)
	event.ObjsSetRot(0, 0.0, 2.02, 0.0)
	event.ObjsResetDaPosition(0)
	event.ObjsSetPos(1, -34.9, 0.0, 31.89)
	event.ObjsSetRot(1, 0.0, 2.18, 0.0)
	event.ObjsResetDaPosition(1)
	event.SetPakuAnim(1, "通常口パク")
	helper_5fe0(5320530)
	if vm.skipping() then
		return skip(36)
	end
	event.SetPakuAnim(0, "通常口パク")
	helper_5fe0(5320540)
	if vm.skipping() then
		return skip(37)
	end
	event.CmrsSetPos(27.41, 54.66, -24.03)
	event.CmrsSetRef(-38.65, 16.14, 19.92)
	event.CmrsMove2(27.41, 88.01, -24.03, -38.65, 16.14, 19.92, 60, 2, 1.0)
	event.SndSePlay(var1, 21)
	event.CharaActive(0, 15)
	event.CharaActive(0, 11)
	event.CharaActive(1, 16)
	event.SetCharaPos(16, 98.8, 0.0, -70.68)
	event.SetCharaRot(16, 0.0, 2.16, 0.0)
	event.SetMotion(16, "伸びる", 6)
	event.ObjsSetMotion(0, "ギル巨大化", 6)
	event.ObjsNextMotion(0, "ギル巨大化L", 4)
	event.ObjsSetMotion(1, "ギル巨大化", 6)
	event.SetLoadbgFile("snd2/bgm/bg_035.sound.json")
	helper_1018()
	if vm.skipping() then
		return skip(38)
	end
	event.LoadBgmPack(35)
	helper_2870()
	if vm.skipping() then
		return skip(39)
	end
	event.CharaActive(0, 16)
	event.PlayBgm(0)
	event.CmrsSetPos(-201.41, 27.8, 185.21)
	event.CmrsSetRef(-35.48, 67.52, 28.17)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "おこり顔")
	event.EohSetTexAnim(0, 1, "おこり目パチ")
	event.SndSeStop(var1, 16)
	event.CharaActive(1, 13)
	helper_410(10)
	if vm.skipping() then
		return skip(40)
	end
	event.SndSePlay(var1, 22)
	event.ObjsSetMotion(8, "攻撃１", 6)
	event.ObjsNextMotion(8, "攻撃１ループ", 4)
	helper_410(4)
	if vm.skipping() then
		return skip(41)
	end
	event.ObjsSetMotion(0, "よける", 6)
	event.ObjsSetMotion(1, "後ろ飛び", 6)
	event.ObjsMotionWait(1)
	helper_2980(1)
	if vm.skipping() then
		return skip(42)
	end
	helper_410(10)
	if vm.skipping() then
		return skip(43)
	end
	event.CmrsSetPos(-36.53, 21.01, 90.55)
	event.CmrsSetRef(-110.73, 24.73, 53.44)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "無表情")
	event.SndSePlay(var1, 23)
	event.ObjsSetPos(0, -130.27, 0.0, 15.93)
	event.ObjsSetMotion(0, "バトル立ち2", 4, -1.0, 1)
	event.ObjsSetPos(1, -64.55, 0.0, 84.34)
	event.ObjsSetMotion(1, "戦うしか", 4, -1.0, 1)
	helper_410(10)
	if vm.skipping() then
		return skip(44)
	end
	event.ObjsSetMotion(1, "戦うしかユリス見", 2)
	event.ObjsNextMotion(1, "戦うしかユリス見L", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_5fe0(5320550)
	if vm.skipping() then
		return skip(45)
	end
	event.ObjsSetMotion(1, "上見へ", 2)
	event.ObjsNextMotion(1, "上見へL", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_5fe0(5320560)
	if vm.skipping() then
		return skip(46)
	end
	event.CmrsSetPos(-247.3, 94.84, 129.46)
	event.CmrsSetRef(-110.28, 94.53, 54.08)
	event.CmrsMove(-217.34, 94.84, 112.98, -110.28, 94.53, 54.08, 120)
	event.SpriteSetDraw(0, 1)
	event.ObjsSetColor(10, 128, 128, 128, 128, 30)
	event.ObjsSetMotion(8, "立ち", 4)
	helper_410(90)
	if vm.skipping() then
		return skip(47)
	end
	event.SetFadeOut(30)
	helper_410(30)
	if vm.skipping() then
		return skip(48)
	end
	return part2()
end

--- Helper function.
local function helper_111c(arg0: s32)
	local stream_open_state: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	while true do
		if vm.wait() then
			return skip(2)
		end
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
		stream_open_state = event.StreamOpenCheck() or stream_open_state
		if stream_open_state == 0 then
			break
		end
	end
end

--- Helper function.
local function helper_6090(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_111c(1)
		end
		if at <= 2 then
			helper_3bc4(0, arg1)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.StreamOpen3(1, arg0)
	helper_111c(1)
	if vm.skipping() then
		return skip(2)
	end
	event.StreamPlay(1)
	helper_3bc4(0, arg1)
	if vm.skipping() then
		return skip(3)
	end
	event.StreamClose(1)
end

--- Helper function.
local function helper_22124()
	local active_chr_no: s32 = 0
	local var1: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 29 then
			if at <= 1 then
				active_chr_no = 0
				active_chr_no = 1
				helper_410(4)
			end
			if at <= 2 then
				helper_410(80)
			end
			if at <= 3 then
				helper_2870()
			end
			if at <= 4 then
				helper_2980(1)
			end
			if at <= 5 then
				helper_410(20)
			end
			if at <= 6 then
				helper_410(20)
			end
			if at <= 7 then
				helper_410(20)
			end
			if at <= 8 then
				helper_2980(1)
			end
			if at <= 9 then
				helper_410(6)
			end
			if at <= 10 then
				helper_410(10)
			end
			if at <= 11 then
				helper_410(15)
			end
			if at <= 12 then
				helper_2980(1)
			end
			if at <= 13 then
				helper_2980(0)
			end
			if at <= 14 then
				helper_5fe0(5360010)
			end
			if at <= 15 then
				helper_5fe0(5360020)
			end
			if at <= 16 then
				helper_5fe0(5360025)
			end
			if at <= 17 then
				helper_6090(5360030, -1)
			end
			if at <= 18 then
				helper_2870()
			end
			if at <= 19 then
				helper_5fe0(5360040)
			end
			if at <= 20 then
				helper_5fe0(5360045)
			end
			if at <= 21 then
				helper_2870()
			end
			if at <= 22 then
				helper_2980(2)
			end
			if at <= 23 then
				helper_410(60)
			end
			if at <= 24 then
				helper_2980(2)
			end
			if at <= 25 then
				helper_410(60)
			end
			if at <= 26 then
				helper_5fe0(5360050)
			end
			if at <= 27 then
				helper_410(30)
			end
			if at <= 28 then
				helper_410(120)
			end
			if vm.skip_end() then
				return skip(30)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.StopBgm(0)
		event.SetStatus(1, 0, 256, 0)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.DelExtMotion(0)
		event.DeleteChara(8)
		event.DeleteChara(9)
		event.DeleteChara(10)
		event.DeleteChara(11)
		event.DeleteChara(12)
		event.DeleteChara(13)
		event.DeleteChara(14)
		event.DeleteChara(15)
		event.DeleteChara(16)
		event.DelImg(0)
		event.LoadMes(0, -1)
		event.SetStatusbarShow(1, 1.0)
		event.EohSetShow(4, 1)
		event.EohSetShow(5, 1)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFlag(536, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.SetStatusbarShow(0, 1.0)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 2 then
		event.DngSetupMainUnit(0)
		active_chr_no = 0
	end
	if active_chr_no == 3 then
		event.DngSetupMainUnit(1)
		active_chr_no = 1
	end
	event.StopBgm(0)
	helper_410(4)
	if vm.skipping() then
		return skip(2)
	end
	event.LoadBgm(52)
	event.LoadSound(5823)
	var1 = event.SndLoadSound(5823) or var1
	event.SetStatus(1, 0, 256, 1)
	event.ChangeDir("event/e500/e536/")
	event.LoadMes(0, 5, "e536.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e536_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e536_monica.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.LoadChara(5, "e536_guiltoni.gltf", "info", 10)
	event.CharaActive(0, 10)
	event.EohSyncChara(2, 10)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.LoadChara(5, "e536_m_guil.gltf", "p00_23a", 11)
	event.CharaActive(11)
	event.EohSyncChara(3, 11)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.LoadChara(5, "e536_guilbaku.gltf", "info", 12)
	event.CharaActive(0, 12)
	event.LoadChara(5, "e536_guilbaku1.gltf", "info", 13)
	event.CharaActive(0, 13)
	event.LoadChara(5, "e536_hikari.gltf", "info", 14)
	event.CharaActive(0, 14)
	event.LoadChara(5, "e536_hikari1.gltf", "info", 15)
	event.CharaActive(0, 15)
	event.LoadChara(5, "e536_guil_hikari.gltf", "info", 16)
	event.CharaActive(0, 16)
	event.EohSyncChara(6, 16)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 6)
	event.ChangeDir("")
	if active_chr_no == 1 then
		event.LoadChara(5, "chara/c01_base.gltf", "info", 8)
		event.LoadEquip(5, 0, 4, "info", 8)
		event.LoadEquip(5, 0, 3, "info", 8)
		event.LoadEquip(5, 0, 2, "info", 8, 9)
		event.LoadMotion(5, "event/e500/e536/e536_mints.gltf", "info", 8)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 8)
		event.EohSyncChara(0, 8)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	else
		event.LoadChara(5, "chara/c02_base.gltf", "info", 8)
		event.LoadEquip(5, 1, 4, "info", 8)
		event.LoadEquip(5, 1, 3, "info", 8)
		event.LoadEquip(5, 1, 2, "info", 8, 9)
		event.LoadMotion(5, "event/e500/e536/e536_monica.gltf", "info", 8)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 8)
		event.EohSyncChara(1, 8)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.CharaActive(8)
	event.CharaActive(9)
	event.EohSyncChara(4, 1)
	event.EohSyncChara(5, 2)
	event.EohSetShow(4, 0)
	event.EohSetShow(5, 0)
	event.EohSetPos(0, -10.0, 0.0, 100.0)
	event.EohSetRot(0, 0.0, 3.14, 0.0)
	event.EohSetMotion(0, "立ち", 4)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "おこり顔")
	event.EohSetTexAnim(0, 1, "おこり目パチ")
	event.EohSetTexAnim(0, 1, "半口")
	event.EohSetFootSoundId(0, 2)
	event.EohSetPos(1, 10.0, 0.0, 100.0)
	event.EohSetRot(1, 0.0, 3.14, 0.0)
	event.EohSetMotion(1, "立ち", 4)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "おこり顔")
	event.EohSetTexAnim(1, 1, "おこり目パチ")
	event.EohSetTexAnim(1, 1, "半口")
	event.EohSetFootSoundId(1, 2)
	event.EohSetPos(2, 0.0, 0.0, -50.0)
	event.EohSetRot(2, 0.0, 1.57, 0.0)
	event.EohSetMotion(2, "倒れ", 4)
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "くるし顔")
	event.EohSetTexAnim(2, 1, "くるし目とじ")
	event.EohSetPos(3, 0.0, 0.0, -50.0)
	event.EohSetRot(3, 0.0, 0.0, 0.0)
	event.EohSetMotion(3, "グォオー", 4)
	event.SetCharaPos(12, 0.0, 50.0, -50.0)
	event.SetCharaRot(12, 0.0, 0.0, 0.0)
	event.SetCharaPos(13, 0.0, 50.0, -18.0)
	event.SetCharaRot(13, 0.0, 0.0, 0.0)
	event.InitDramaScene()
	event.CharaActive(1, 12)
	event.SetMotion(12, "グォオー", 6)
	event.CharaActive(1, 13)
	event.SetMotion(13, "グォオー", 6)
	event.SndSePlay(var1, 2)
	event.CmrsInit()
	event.CmrsSetPos(0.0, 150.0, 65.9)
	event.CmrsSetRef(0.0, 150.0, -23.0)
	event.CmrsMove2(0.0, 123.2, 330.45, 0.0, 123.57, -23.0, 90, 0, 0.3)
	event.SetFadeIn(30)
	helper_410(80)
	if vm.skipping() then
		return skip(3)
	end
	event.SetCharaShow(11, 0, 1, 0.1)
	helper_2870()
	if vm.skipping() then
		return skip(4)
	end
	event.CharaActive(0, 13)
	event.CharaActive(0, 12)
	event.CmrsSetPos(45.36, 6.79, 49.62)
	event.CmrsSetRef(-2.61, 16.71, 101.94)
	event.SetWind(10, 0.0, 0.0, 1.0)
	event.CharaActive(1, 14)
	event.SetCharaPos(14, 19.99, 0.0, 122.09)
	event.SetCharaRot(14, 0.0, 1.57, 0.0)
	event.ObjsSetMotion(0, "爆発", 6)
	event.ObjsNextMotion(0, "爆発L", 4)
	event.ObjsSetMotion(1, "爆発", 6)
	event.ObjsNextMotion(1, "爆発L", 4)
	helper_2980(1)
	if vm.skipping() then
		return skip(5)
	end
	helper_410(20)
	if vm.skipping() then
		return skip(6)
	end
	event.CharaActive(0, 14)
	event.CmrsSetPos(4.04, 16.09, 159.94)
	event.CmrsSetRef(4.04, 13.4, 71.43)
	event.CharaActive(0, 11)
	event.CharaActive(1, 10)
	event.CharaActive(1, 15)
	event.SetCharaPos(15, 0.0, 0.0, 15.0)
	event.SetCharaRot(15, 0.0, 0.0, 0.0)
	helper_410(20)
	if vm.skipping() then
		return skip(7)
	end
	event.SetCharaShow(15, 0, 1, 0.033333335)
	event.SetWind(-1)
	helper_410(20)
	if vm.skipping() then
		return skip(8)
	end
	event.ObjsSetMotion(0, "爆発戻り", 6)
	event.ObjsNextMotion(0, "立ち", 4)
	event.ObjsSetMotion(1, "もどり", 6)
	event.ObjsNextMotion(1, "立ち", 4)
	helper_2980(1)
	if vm.skipping() then
		return skip(9)
	end
	helper_410(6)
	if vm.skipping() then
		return skip(10)
	end
	event.ObjsSetMotion(1, "走り")
	event.ObjsMotionDelay(1, 46)
	event.ObjsSetMotion(1, "立ち")
	event.ObjsMove(1, 10.0, 0.0, -30.0, 50)
	event.ObjsRotDelay(1, 46)
	event.ObjsRotation(1, 0.0, -2.78, 0.0, 10)
	helper_410(10)
	if vm.skipping() then
		return skip(11)
	end
	event.ObjsSetMotion(0, "走り")
	event.ObjsMotionDelay(0, 46)
	event.ObjsSetMotion(0, "立ち")
	event.ObjsMove(0, -10.0, 0.0, -30.0, 50)
	event.ObjsRotDelay(0, 46)
	event.ObjsRotation(0, 0.0, 2.9, 0.0, 10)
	helper_410(15)
	if vm.skipping() then
		return skip(12)
	end
	event.CmrsSetPos(13.0, 9.86, -79.62)
	event.CmrsSetRef(13.0, 12.67, -39.5)
	event.CmrsMove2(0.0, 9.86, -79.62, 0.0, 12.67, -39.5, 60, 2, 1.0)
	event.PlayBgm(0)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "おこり顔")
	event.EohSetTexAnim(1, 1, "おこり目パチ")
	event.ObjsSetPos(2, 13.0, 0.0, -50.0)
	event.ObjsResetDaPosition(2)
	helper_2980(1)
	if vm.skipping() then
		return skip(13)
	end
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "おこり顔")
	event.EohSetTexAnim(1, 1, "おこり目～こまり目下")
	event.SndSePlay(var1, 3)
	event.ObjsSetMotion(1, "しゃがみ", 6)
	event.ObjsNextMotion(1, "しゃがみL", 4)
	helper_2980(0)
	if vm.skipping() then
		return skip(14)
	end
	event.ObjsSetMotion(0, "しゃがむ", 6)
	event.ObjsNextMotion(0, "しゃがむL", 4)
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "くるし顔")
	event.EohSetTexAnim(2, 1, "目とじ～目あけ")
	event.SetPakuAnim(1, "通常口パク")
	helper_5fe0(5360010)
	if vm.skipping() then
		return skip(15)
	end
	event.SetPakuAnim(2, "くるし口パク")
	helper_5fe0(5360020)
	if vm.skipping() then
		return skip(16)
	end
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "くるし顔")
	event.EohSetTexAnim(2, 1, "目あけ～目とじ")
	event.ObjsSetMotion(2, "ぐふっ", 2)
	event.ObjsNextMotion(2, "倒れ", 4)
	event.SetPakuAnim(2, "くるし口パク")
	helper_5fe0(5360025)
	if vm.skipping() then
		return skip(17)
	end
	helper_6090(5360030, -1)
	if vm.skipping() then
		return skip(18)
	end
	helper_2870()
	if vm.skipping() then
		return skip(19)
	end
	event.CmrsSetPos(16.76, 57.33, -49.41)
	event.CmrsSetRef(4.01, 12.67, -49.87)
	event.CmrsMove2(11.95, 41.94, -49.58, 4.01, 12.67, -49.87, 150, 2, 1.0)
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "くるし顔")
	event.EohSetTexAnim(2, 1, "くるし目～くるし目２")
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "こまり顔")
	event.EohSetTexAnim(1, 1, "こまり目パチ")
	event.SetPakuAnim(2, "くるし口パク")
	helper_5fe0(5360040)
	if vm.skipping() then
		return skip(20)
	end
	event.SetPakuAnim(2, "くるし口パク")
	helper_5fe0(5360045)
	if vm.skipping() then
		return skip(21)
	end
	helper_2870()
	if vm.skipping() then
		return skip(22)
	end
	event.SndSePlay(var1, 4)
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "くるし顔")
	event.EohSetTexAnim(2, 1, "くるし目２～通常目")
	event.EohSetTexAnim(2, 1, "わらい口")
	event.ObjsSetMotion(2, "モニカ見", 2)
	event.ObjsNextMotion(2, "モニカ見L", 4)
	helper_2980(2)
	if vm.skipping() then
		return skip(23)
	end
	helper_410(60)
	if vm.skipping() then
		return skip(24)
	end
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "こまり顔")
	event.EohSetTexAnim(1, 1, "こまり目パチ")
	event.EohSetTexAnim(1, 1, "口とじ～大口")
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "わらい顔")
	event.EohSetTexAnim(2, 1, "ゆっくり目とじ")
	event.SndSePlay(var1, 5)
	event.ObjsSetMotion(2, "死に", 2)
	event.ObjsMotionWait(2)
	helper_2980(2)
	if vm.skipping() then
		return skip(25)
	end
	helper_410(60)
	if vm.skipping() then
		return skip(26)
	end
	event.CmrsSetPos(-6.98, 9.03, -75.58)
	event.CmrsSetRef(0.96, 12.16, -49.21)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "こまり顔")
	event.EohSetTexAnim(1, 1, "目あき～目とじ")
	event.SetPakuAnim(1, "通常口パク")
	helper_5fe0(5360050)
	if vm.skipping() then
		return skip(27)
	end
	event.CmrsSetPos(-0.18, 28.97, 146.9)
	event.CmrsSetRef(9.44, 29.01, 60.59)
	event.CmrsMove(-2.36, 28.97, 166.44, 9.44, 29.01, 60.59, 150)
	event.SndSePlay(var1, 6)
	event.CharaActive(1, 16)
	event.SetCharaPos(16, 0.0, 0.0, -50.0)
	event.SetCharaRot(16, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(4, "発動・ギル光の粒", 6)
	event.ObjsNextMotion(4, "ループ・ギル光の粒", 4)
	event.FadeOutBgm(150)
	helper_410(30)
	if vm.skipping() then
		return skip(28)
	end
	event.SetFadeOut(120, 255, 255, 255)
	helper_410(120)
	if vm.skipping() then
		return skip(29)
	end
	return part2()
end

--- Helper function.
local function helper_e94(arg0: s32)
	local var1: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		return var1
	end
	if vm.skipping() then
		return skip(1)
	end
	var1 = event.ChkPadCtrl(arg0) or var1
	return var1
end

--- Helper function.
local function helper_2a9c(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesWindowMode(arg0, arg1)
end

--- Helper function.
local function helper_ccd4(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_2a9c(1, 4)
			helper_87dc(1, vm.i32(60 + arg0), 8, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(1, 4)
	helper_2a9c(1, 4)
	helper_87dc(1, vm.i32(60 + arg0), 8, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_eaa0(arg0: s32, arg1: s32)
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
				helper_410(30)
			end
			if at <= 2 then
				helper_1018()
			end
			if at <= 3 then
				helper_410(30)
			end
			if at <= 4 then
				helper_6090(arg1, -1)
			end
			if at <= 5 then
				helper_410(10)
			end
			if at <= 6 then
				helper_410(30)
			end
			if at <= 7 then
				helper_410(120)
			end
			if at <= 8 then
				local _ = helper_e94(0)
			end
			if at <= 9 then
				helper_ccd4(1)
			end
			if at <= 10 then
				helper_ccd4(4)
			end
			if at <= 11 then
				helper_ccd4(active_chr_no)
			end
			if at <= 12 then
				helper_ccd4(1)
			end
			if at <= 13 then
				helper_410(30)
			end
			if at <= 15 then
				helper_410(30)
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
	helper_410(30)
	if vm.skipping() then
		return skip(2)
	end
	event.SetStatusbarShow(0, 0.06666667)
	helper_1018()
	if vm.skipping() then
		return skip(3)
	end
	event.LoadBgmPack(60)
	if var8 == 1 or var8 ~= 1 and arg1 < 0 then
		event.PlayBgm(0)
	end
	helper_410(30)
	if vm.skipping() then
		return skip(4)
	end
	event.DngPause(1, 1)
	event.DngCollisionAllClr()
	if var8 ~= 1 then
		block = event.LoadImg_4(5, "textures/dungeon/image/gameover.json", 1) or block
		if arg1 >= 0 then
			helper_6090(arg1, -1)
			if vm.skipping() then
				return skip(5)
			end
			helper_410(10)
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
		helper_410(30)
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
		helper_410(120)
		if vm.skipping() then
			return skip(8)
		end
		while true do
			if helper_e94(0) ~= 0 then
				break
			end
			if vm.wait() then
				return skip(9)
			end
		end
	elseif active_chr_no == 3 then
		var10 = event.CheckEnableCharaChange(1) or var10
		if var10 == 0 then
			helper_ccd4(1)
			if vm.skipping() then
				return skip(10)
			end
		else
			helper_ccd4(4)
			if vm.skipping() then
				return skip(11)
			end
		end
	elseif active_chr_no == 0 or active_chr_no == 2 then
		helper_ccd4(active_chr_no)
		if vm.skipping() then
			return skip(12)
		end
	else
		helper_ccd4(1)
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
		helper_410(30)
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
		helper_410(30)
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
	helper_410(4)
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
local function helper_10e04(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		return helper_eaa0(arg0, arg1)
	end
	if vm.skipping() then
		return skip(1)
	end
	return helper_eaa0(arg0, arg1)
end

--- Helper function.
local function helper_10d6c(arg0: s32)
	return helper_eaa0(arg0, -1)
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

script[99] = program_99

--- Program 100.
script[100] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		helper_18dc(0.0, -30.0, 1600.0, vm.f32(3.14))
	end
	event.Initialize()
	event.SetFadeOut(0)
	program_99()
	event.CheckMcLoad()
	if vm.wait() then
		return skip(1)
	end
	helper_18dc(0.0, -30.0, 1600.0, vm.f32(3.14))
	event.SetCameraRef(0.0, 0.0, 1600.0)
	event.SetCameraPos(0.0, 10.0, 1700.0)
	event.ResetCamera(0)
	event.SetFadeIn(15)
	event.Finish()
end

--- Program 150.
script[150] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_263b8()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 200.
script[200] = function()
	local active_chr_no: s32 = 0
	local var1: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_87dc(0, 21, 5, 256, 208)
			end
			return
		end
		if at <= 3 then
			helper_410(15)
		end
	end
	event.Initialize()
	event.ActchrSetDefMotion(0)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 2 or active_chr_no == 3 then
		event.SetMesWindowMode(0, 1)
		event.SetMesDrawspeed(0, 1)
		if active_chr_no == 2 then
			helper_87dc(0, 20, 5, 256, 208)
			if vm.skipping() then
				return skip(1)
			end
		else
			helper_87dc(0, 21, 5, 256, 208)
			if vm.skipping() then
				return skip(2)
			end
		end
		event.Finish()
		return
	end
	event.SetMesQuestionGyou(0, 0)
	event.SetMesWindowMode(0, 5)
	event.SetMesDrawspeed(0, 1)
	event.MesMake_2(0, "前のフロアに戻りますか？")
	var1 = helper_7ba4(0, -1, 8, 0, 0, 2, 1)
	if vm.skipping() then
		return skip(3)
	end
	event.SetMesDrawspeed(0, 0)
	if var1 == 0 then
		event.SetFadeOut(15)
		helper_410(15)
		if vm.skipping() then
			return skip(4)
		end
		event.LoadScript("d05/d05.stb", 1000)
	end
	event.Finish()
end

--- Program 400.
script[400] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_e92c()
	if vm.skipping() then
		return skip(1)
	end
	event.Finish()
end

--- Program 500.
script[500] = function()
	local active_chr_no: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_87dc(0, 23, 8, 0, 0)
			end
			return
		end
		if at <= 6 then
			if at <= 3 then
				var1 = 2
				helper_410(6)
			end
			if at <= 5 then
				helper_1197c()
			end
			return
		end
		if at <= 7 then
			helper_410(6)
		end
	end
	event.Initialize()
	event.ActchrSetDefMotion(0)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 2 or active_chr_no == 3 then
		event.SetMesPreset(0, 4)
		event.SetMesWindowMode(0, 4)
		event.SetMesDrawspeed(0, 1)
		if active_chr_no == 2 then
			helper_87dc(0, 22, 8, 0, 0)
			if vm.skipping() then
				return skip(1)
			end
		else
			helper_87dc(0, 23, 8, 0, 0)
			if vm.skipping() then
				return skip(2)
			end
		end
		event.SetMesWindowMode(0, 1)
		event.SetMesDrawspeed(0, 0)
		event.Finish()
		return
	end
	var1 = event.GetEventData_2(6) or var1
	if var1 == 1 then
		event.Initialize()
		event.SetMesWindowMode(0, 1)
		event.SetMesDrawspeed(0, 1)
		var2 = helper_8678(0, 2507, 5, 256, 208, var2)
		if vm.skipping() then
			return skip(3)
		end
		event.SetMesWindowMode(0, 7)
		event.SetMesDrawspeed(0, 0)
		if var2 == 1 then
			var1 = 2
		end
	end
	if var1 == 2 then
		event.SetStatusbarShow(0, 0.16666667)
		helper_410(6)
		if vm.skipping() then
			return skip(4)
		end
		event.GotoUseItem(354)
		do
			local skipped = vm.wait()
			var3 = event.DeferredOutput() or var3
			if skipped then
				return skip(5)
			end
		end
		if var3 == 354 then
			event.FuncPointShow("d05", "func", 0)
			event.EohSyncObj(0, "d05", "d05ba02-a")
			event.EohSetShow(0, 0)
			event.FuncPointShow("p01", "invent_2023-1", 1)
			helper_1197c()
			if vm.skipping() then
				return skip(6)
			end
			return
		elseif var3 <= 0 then
			event.Finish()
		else
			helper_e1e0()
			if vm.skipping() then
				return skip(7)
			end
		end
		event.SetStatusbarShow(1, 0.16666667)
		helper_410(6)
		if vm.skipping() then
			return skip(8)
		end
	end
	event.Finish()
end

--- Program 550.
script[550] = function()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_12c24()
			if not vm.skipping() then
				return part2()
			end
		end
		helper_18dc(0.0, 0.0, 300.0, vm.f32(3.14))
	end
	function part2()
		if vm.wait() then
			return skip(3)
		end
		event.LoadMonsterFile(512, 1)
		event.AutoSetMonster(512, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
		helper_18dc(0.0, 0.0, 300.0, vm.f32(3.14))
		event.SetCameraRef(0.0, 30.0, 300.0)
		event.SetCameraPos(0.0, 40.0, 400.0)
		event.ResetCamera(0)
		event.SetFadeIn(15)
		event.Finish()
	end
	event.Initialize()
	event.ActchrSetDefMotion(0)
	event.SetBitCtrl(1, 1)
	event.SetFadeOut(15)
	helper_410(15)
	if vm.skipping() then
		return skip(1)
	end
	event.FuncPointShow("", "e528", 0)
	helper_12c24()
	if vm.skipping() then
		return skip(2)
	end
	return part2()
end

--- Program 560.
script[560] = function()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_15fb0()
			if not vm.skipping() then
				return part2()
			end
		end
	end
	function part2()
		event.BgmLoadCancel()
		event.LoadDungeonMapFile("s49")
		event.LoadScript("s49/s49.stb", 500)
	end
	event.Initialize()
	event.ActchrSetDefMotion(0)
	event.SetFadeOut(15)
	helper_410(15)
	if vm.skipping() then
		return skip(1)
	end
	event.DelMonster(-1)
	event.ExtTyped(1078, "ii", 1, 1)
	event.SetCharaChangeFlag(1, 1)
	event.SetCharaChangeMask(1, 1)
	event.ExtTyped(1078, "ii", 3, 1)
	event.SetCharaChangeFlag(3, 1)
	event.SetCharaChangeMask(3, 1)
	helper_15fb0()
	if vm.skipping() then
		return skip(2)
	end
	return part2()
end

--- Program 561.
script[561] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.ResetEventTrg()
	helper_1c2b8()
	if vm.skipping() then
		return skip(1)
	end
	event.FuncPointShow("", "e528", 0)
	event.FuncPointShow("d05", "func", 0)
	event.FuncPointShow("p01", "invent_2023-1", 1)
	event.EohSyncObj(0, "d05", "d05ba03-a")
	event.EohSetShow(0, 1)
	event.EohSyncObj(0, "d05", "d05b01_1", "takil")
	event.EohSetTranslate(0, -330.0, 0.0, 200.0)
	event.EohSyncObj(0, "d05", "d05b01_1", "takir")
	event.EohSetTranslate(0, 330.0, 0.0, 200.0)
	event.LoadMonsterFile(511, 1)
	event.AutoSetMonster(511, 0.0, 0.0, -200.0, 0.0, 0.0, 0.0)
	event.SetCharaPos(0, 0.0, 0.0, 300.0)
	event.SetCharaRot(0, 0.0, 3.14, 0.0)
	event.SetMotion(0, "立ち", 4)
	event.SetCameraPos(0.0, 40.0, 420.0)
	event.SetCameraRef(0.0, 30.0, 300.0)
	event.ResetCamera(0)
	event.SetFadeIn(15)
	event.Finish()
end

--- Program 570.
script[570] = function()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_22124()
			if not vm.skipping() then
				return part2()
			end
		end
	end
	function part2()
		event.SetFloorInfo(4, 22, 5, 2)
		event.BgmLoadCancel()
		event.LoadDungeonMapFile("s49")
		event.LoadScript("s49/s49.stb", 510)
	end
	event.Initialize()
	event.ActchrSetDefMotion(0)
	event.FadeOutBgm(0)
	event.SetFadeOut(15)
	helper_410(15)
	if vm.skipping() then
		return skip(1)
	end
	event.StopBgm(0)
	event.DelMonster(-1)
	helper_22124()
	if vm.skipping() then
		return skip(2)
	end
	return part2()
end

--- Program 571.
script[571] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetBitCtrl(1, 0)
	event.ResetEventTrg()
	helper_263b8()
	if vm.skipping() then
		return skip(1)
	end
	event.GotoEdit(3, 500)
end

--- Program 600.
script[600] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_410(4)
		end
	end
	event.Initialize()
	if vm.wait() then
		return skip(1)
	end
	event.StopBgm(0)
	helper_410(4)
	if vm.skipping() then
		return skip(2)
	end
	event.LoadBgm(35)
	event.PlayBgm(0)
	event.FuncPointShow("d05", "func", 0)
	event.FuncPointShow("", "e528", 0)
	event.LoadMonsterFile(511, 1)
	event.AutoSetMonster(511, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
	event.Finish()
end

--- Program 1200.
script[1200] = function()
	local value: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_10e04(0, 8540070)
			end
			return
		end
		if at <= 4 then
			if at <= 3 then
				helper_10e04(0, 8530110)
			end
			return
		end
	end
	flag = event.GetFlag(532) or flag
	flag_2 = event.GetFlag(536) or flag_2
	if flag ~= 0 and flag_2 == 0 then
		value = 0
		value = event.GetRandInt(100) or value
		if value < 50 then
			helper_10e04(0, 8540060)
			if vm.skipping() then
				return skip(1)
			end
		else
			helper_10e04(0, 8540070)
			if vm.skipping() then
				return skip(2)
			end
		end
		return
	end
	flag_3 = event.GetFlag(528) or flag_3
	if flag_3 ~= 0 and flag == 0 then
		value = 0
		value = event.GetRandInt(100) or value
		if value < 50 then
			helper_10e04(0, 8530100)
			if vm.skipping() then
				return skip(3)
			end
		else
			helper_10e04(0, 8530110)
			if vm.skipping() then
				return skip(4)
			end
		end
		return
	end
	helper_10d6c(0)
	if vm.skipping() then
		return skip(5)
	end
end

--- Program 15260.
script[15260] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.StopBgm(0)
	helper_1197c()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 15280.
script[15280] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_12c24()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 15320.
script[15320] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_15fb0()
	if vm.skipping() then
		return skip(1)
	end
	event.BgmLoadCancel()
	event.LoadDungeonMapFile("s49")
	event.LoadScript("s49/s49.stb", 500)
end

--- Program 15360.
script[15360] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_22124()
	if vm.skipping() then
		return skip(1)
	end
	event.BgmLoadCancel()
	event.LoadDungeonMapFile("s49")
	event.LoadScript("s49/s49.stb", 510)
end

--- Program 25020.
script[25020] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_410(4)
		end
	end
	event.Initialize()
	if vm.wait() then
		return skip(1)
	end
	event.StopBgm(0)
	helper_410(4)
	if vm.skipping() then
		return skip(2)
	end
	event.LoadBgm(190)
	event.PlayBgm(0)
	event.FuncPointShow("", "e528", 0)
	event.LoadMonsterFile(512, 1)
	event.AutoSetMonster(512, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
	event.Finish()
end

return script
