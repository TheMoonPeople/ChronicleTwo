--!strict
-- map/s/s06/s06.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_fab3eef4 = require("@lib/event/helper_fab3eef4")

--- Helper function.
local function helper_430(arg0: any)
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
local function helper_29a0(arg0: s32)
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
local function helper_207bc()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_430(15)
		end
		if at <= 2 then
			helper_29a0(0)
		end
		if at <= 3 then
			helper_29a0(10)
		end
		if at <= 4 then
			helper_430(40)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	var0 = event.SndLoadSound(8, "snd2/sp/sp_040.sound.json") or var0
	event.SetStatusbarShow(0, 1.0)
	event.AssignStack(5)
	event.ClearStack(5)
	event.SetCameraPos(133.95, 349.85, 995.49)
	event.SetCameraRef(10.87, 287.26, 1174.06)
	event.EohSyncChara(0, 0)
	event.EohSetFootSoundId(0, 3)
	event.CharaActive(1, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetPos(0, 3.0, 263.17, 1196.78)
	event.ObjsSetRot(0, 0.0, -3.08, 0.0)
	event.ObjsSetMotion(0, "立ち", 4)
	event.EohSyncObj(10, "p08_s06", "s06_08-m1")
	event.EohSetShow(10, 1)
	event.ObjsInit(10)
	event.ObjsSyncObj(10, 10)
	event.ObjsSetPos(10, 2.90684, 312.375, 1188.04)
	event.ObjsMove(10, 2.90684, 412.375, 1188.04, 30)
	event.SndSePlay(var0, 0)
	event.SetFadeIn(30)
	helper_430(15)
	if vm.skipping() then
		return skip(2)
	end
	event.ObjsSetMotion(0, "走り")
	event.ObjsMotionDelay(0, 30)
	event.ObjsSetMotion(0, "立ち")
	event.ObjsMove(0, 3.0, 263.17, 1131.27, 30)
	helper_29a0(0)
	if vm.skipping() then
		return skip(3)
	end
	helper_29a0(10)
	if vm.skipping() then
		return skip(4)
	end
	event.SndSePlay(var0, 1)
	event.ObjsJump(10, 2.90684, 312.375, 1188.04, -0.2, 10)
	event.ObjsJump(10, 2.90684, 312.375, 1188.04, -0.2, 8)
	event.ObjsJump(10, 2.90684, 312.375, 1188.04, -0.2, 5)
	helper_430(40)
	if vm.skipping() then
		return skip(5)
	end
	event.SetStatusbarShow(1, 0.033333335)
	event.SetCharaPos(0, 3.0, 263.17, 1131.27)
	event.EohSetPos(10, 2.90684, 312.375, 1188.04)
	event.SetCameraRef(3.0, 293.17, 1131.27)
	event.SetCameraPos(3.0, 303.17, 1011.27)
	event.ResetCamera(0)
	event.Finish()
end

--- Helper function.
local function helper_d54(arg0: s32)
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
local function helper_f58(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			local _ = helper_d54(arg0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	while true do
		if helper_d54(arg0) ~= 0 then
			break
		else
			if vm.wait() then
				return skip(2)
			end
		end
	end
end

--- Helper function.
local function helper_2b48(arg0: any, arg1: any, arg2: any, arg3: any, arg4: any)
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
local function helper_4368(arg0: any, arg1: s32)
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
local function helper_7a80(arg0: any, arg1: s32, arg2: s32)
	local var3: s32 = 0
	local var4: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var4 = 0
			var3 = helper_4368(arg0, arg1)
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
		var3 = helper_4368(arg0, arg1)
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
local function helper_2d8c(arg0: any)
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
local function helper_8548(arg0: s32, arg1: s32, arg2: s32, arg3: s32, arg4: s32)
	local var6: s32 = 0
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			local _ = helper_2b48(arg0, arg1, arg2, arg3, arg4)
			_, var6 = helper_7a80(arg0, 0, var6)
		end
		helper_2d8c(arg0)
	end
	if vm.skipping() then
		return skip(1)
	end
	local _ = helper_2b48(arg0, arg1, arg2, arg3, arg4)
	_, var6 = helper_7a80(arg0, 0, var6)
	if vm.skipping() then
		return skip(2)
	end
	helper_2d8c(arg0)
end

--- Helper function.
local function helper_6aa0(arg0: s32)
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
local function helper_67e0(arg0: s32)
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
local function helper_6bf8(arg0: s32, arg1: any, arg2: any, arg3: s32)
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
				helper_6aa0(arg0)
			end
			if at <= 2 then
				var8 = 0
				var7 = helper_67e0(arg0)
				var8 = -1
				var8 = 1
				var6 = var7
				var8 = -1
				var8 = 1
				var8 = -1
				var8 = 1
			end
			helper_2d8c(arg0)
			return -1
		end
		helper_2d8c(arg0)
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
	helper_6aa0(arg0)
	if vm.skipping() then
		return skip(2)
	end
	while true do
		var8 = 0
		var7 = helper_67e0(arg0)
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
					helper_2d8c(arg0)
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
	helper_2d8c(arg0)
	return arg2
end

--- Helper function.
local function helper_7910(arg0: s32, arg1: any, arg2: s32, arg3: s32, arg4: s32, arg5: s32, arg6: s32)
	local var8: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		return var8
	end
	local _ = helper_2b48(arg0, arg1, arg2, arg3, arg4)
	var8 = helper_6bf8(arg0, arg5, arg6, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPos(arg0, 0)
	return var8
end

--- Program 310.
local function program_310()
	local flag: s32 = 0
	local var1: s32 = 0
	local member: s32 = 0
	local active_chr_no: s32 = 0
	local var5: any = 0
	local stage_id: s32 = 0
	local var7: s32 = 0
	local argc: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			return
		end
		if at <= 4 then
			return
		end
		if at <= 5 then
			return
		end
		if at <= 6 then
			return
		end
		if at <= 9 then
			if at <= 7 then
				helper_430(30)
			end
			return
		end
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.ActchrSetDefMotion(0)
	flag = event.GetFlag(7) or flag
	if flag == 0 then
		event.Initialize()
		event.DngPause(1, 1)
		member = event.JoinPartyMember(2) or member
		if member ~= 0 then
			var1 = event.GetMesWindowMode(0) or var1
			event.SetMesWindowMode(0, 1)
			event.SetMesShippo(0, 0)
			event.MesMake_2(0, "今はそれどころじゃない！！")
			helper_8548(0, -1, 5, 0, 0)
			if vm.skipping() then
				return skip(1)
			end
			event.SetMesWindowMode(0, var1)
			if vm.wait() then
				return skip(2)
			end
			event.DngPause(1, 0)
			event.Finish()
			return
		else
			event.SetMotion(0, "立ち")
			var1 = event.GetMesWindowMode(0) or var1
			event.SetMesWindowMode(0, 1)
			event.SetMesShippo(0, 0)
			flag = event.GetFlag(104) or flag
			if flag == 1 then
				event.MesMake_2(0, "扉は開きそうにない。\nいったん上に戻ろう！")
			else
				event.MesMake_2(0, "今はそれどころじゃない！！")
			end
			helper_8548(0, -1, 5, 0, 0)
			if vm.skipping() then
				return skip(3)
			end
			event.SetMesWindowMode(0, var1)
			if vm.wait() then
				return skip(4)
			end
			event.DngPause(1, 0)
			event.Finish()
			return
		end
	end
	event.Initialize()
	event.SetMotion(0, "立ち")
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 2 then
		event.SetMesWindowMode(0, 1)
		event.SetMesShippo(0, 0)
		event.MesMake_2(0, "ライドポッドから降りないと先へ進めそうにない。")
		helper_8548(0, -1, 8, 256, 208)
		if vm.skipping() then
			return skip(5)
		end
		event.Finish()
		return
	end
	if active_chr_no == 3 then
		event.SetMesWindowMode(0, 1)
		event.SetMesShippo(0, 0)
		helper_8548(0, 21, 8, 256, 208)
		if vm.skipping() then
			return skip(6)
		end
		event.Finish()
		return
	end
	event.SetMesWindowMode(0, 5)
	event.SetMesDrawspeed(0, 1)
	event.MesMake_2(0, "次のフロアへ進みますか？")
	var5 = helper_7910(0, -1, 8, 256, 208, 2, 1)
	if vm.skipping() then
		return skip(7)
	end
	if var5 == 0 then
		event.SetBitCtrl(1, 0)
		stage_id = event.DngGetStageId() or stage_id
		var7 = event.DngGetFloorId() or var7
		argc = event.GetNextFloor(var7, 0) or argc
		event.DngSetFloorId(argc)
		event.SetFloorInfo(stage_id, var7, 5, 2)
		event.SetFloorInfo(stage_id, argc, 5, 1)
		event.SetFadeOut(30)
		helper_430(30)
		if vm.skipping() then
			return skip(8)
		end
		flag = event.GetFlag(8) or flag
		if flag == 0 then
			event.StopBgm(0)
			event.SetFlag(8, 1)
			event.BgmLoadCancel()
			event.GotoEdit(12, 540)
			if vm.wait() then
				return skip(9)
			end
			return
		end
		event.BgmLoadCancel()
		event.GotoDng(0, 5, 1000)
		if vm.wait() then
			return skip(10)
		end
	end
	event.Finish()
end

--- Helper function.
local function helper_2136c(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	event.EohSyncObj(0, "p01_s06", "s06_02-a0")
	event.EohSyncObj(1, "p01_s06", "s06_03-a0")
	if arg0 ~= 0 then
		event.EohSetShow(0, 1)
		event.EohSetShow(1, 1)
	else
		event.EohSetShow(0, 0)
		event.EohSetShow(1, 0)
	end
end

--- Helper function.
local function helper_2890()
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
local function helper_159ac(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_2890()
		end
		if at <= 2 then
			helper_29a0(2)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsSetPos(-158.38, 85.25, 3.62)
	event.CmrsSetRef(-34.81, 85.07, -0.49)
	event.CharaActive(0, 0)
	event.CharaActive(0, 9)
	event.CharaActive(1, 10)
	event.ObjsSetPos(2, 0.0, 50.0, 0.0)
	event.ObjsSetRot(2, 0.0, -1.56, 0.0)
	event.ObjsSetScale(2, 1.3, 1.3, 1.3)
	event.CmrsFadeInit()
	event.CmrsFadeIn(30, 0.0, 0.0, 0.0)
	helper_2890()
	if vm.skipping() then
		return skip(2)
	end
	event.SndSePlay(arg0, 1)
	event.ObjsSetMotion(2, "死", 6)
	event.ObjsMotionWait(2)
	helper_29a0(2)
	if vm.skipping() then
		return skip(3)
	end
end

--- Helper function.
local function helper_15d84(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_2890()
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SndSePlay(arg0, 0)
	event.CmrsSetPos(39.97, 95.45, -42.29)
	event.CmrsSetRef(-401.26, 72.44, 58.46)
	event.CharaActive(1, 0)
	event.ObjsSetPos(0, -167.59, 50.0, 2.86)
	event.ObjsSetRot(0, 0.0, 1.77, 0.0)
	event.ObjsSetMotion(0, "勝利のポーズ", 4)
	event.CharaActive(1, 9)
	event.ObjsSetPos(1, -167.59, 50.0, 2.86)
	event.ObjsSetRot(1, 0.0, 1.77, 0.0)
	event.ObjsSetMotion(1, "勝利のポーズ", 4)
	event.CharaActive(0, 10)
	event.CmrsMove2(-117.38, 95.45, -6.36, -401.26, 72.44, 58.46, 20, 2, 0.4)
	helper_2890()
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_2e78(arg0: s32, arg1: s32)
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
local function helper_3ca0(arg0: s32)
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
			t1, var2 = helper_2e78(arg0, var2)
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
		t0, var2 = helper_2e78(arg0, var2)
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
local function helper_5d10(arg0: s32)
	local stream_open_state: s32 = 0
	local stream_open_state_2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			helper_2b48(0, -1, 8, 0, 0)
			helper_3ca0(0)
		end
		helper_2d8c(0)
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
	helper_2b48(0, -1, 8, 0, 0)
	event.StreamPlay(1)
	helper_3ca0(0)
	if vm.skipping() then
		return skip(4)
	end
	helper_2d8c(0)
	event.StreamClose(1)
end

--- Helper function.
local function helper_6000(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_5d10(arg0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, arg0)
	helper_5d10(arg0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_161d8(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_6000(1080010)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.CharaActive(1, 0)
	event.ObjsSetPos(0, -167.59, 50.0, 2.86)
	event.ObjsSetRot(0, 0.0, 1.77, 0.0)
	event.ObjsSetMotion(0, "勝利のポーズ", 4)
	event.CharaActive(1, 9)
	event.ObjsSetPos(1, -167.59, 50.0, 2.86)
	event.ObjsSetRot(1, 0.0, 1.77, 0.0)
	event.ObjsSetMotion(1, "勝利のポーズ", 4)
	event.SetPakuAnim(0, "わらい口パク")
	helper_6000(1080010)
	if vm.skipping() then
		return skip(2)
	end
	event.ResetPakuAnim()
	event.SndSeStop(arg0, 0)
end

--- Helper function.
local function helper_16510(arg0: s32)
	local var1: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_29a0(0)
		end
		if at <= 2 then
			helper_29a0(1)
		end
		if at <= 3 then
			helper_6000(1080020)
		end
		if at <= 4 then
			helper_29a0(3)
		end
		if at <= 5 then
			helper_430(30)
		end
		if at <= 6 then
			var1 = 0
		end
		if at <= 7 then
			var1 = var1 + 1
			helper_29a0(3)
		end
		if at <= 8 then
			helper_2890()
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetCameraPos(-480.46, 80.16, -12.91)
	event.SetCameraRef(-259.64, 146.91, -128.27)
	event.SetCharaPos(0, -409.26, 50.0, -69.12)
	event.SetCharaRot(0, 0.0, 1.41, 0.0)
	event.SetCharaPos(9, -409.26, 50.0, -69.12)
	event.SetCharaRot(9, 0.0, 1.41, 0.0)
	event.CharaActive(1, 11)
	event.ObjsSetPos(3, -302.17, 113.58, -60.02)
	event.ObjsSetRot(3, 0.0, -1.56, 0.0)
	event.ObjsSetMotion(0, "上見L", 6)
	event.ObjsSetMotion(1, "上見L", 6)
	helper_29a0(0)
	if vm.skipping() then
		return skip(2)
	end
	helper_29a0(1)
	if vm.skipping() then
		return skip(3)
	end
	event.SndSePlay(arg0, 2)
	event.ObjsSetMotion(3, "ウッキー", 4)
	event.SetPakuAnim(3, "おこり口パク")
	helper_6000(1080020)
	if vm.skipping() then
		return skip(4)
	end
	event.ResetPakuAnim()
	helper_29a0(3)
	if vm.skipping() then
		return skip(5)
	end
	helper_430(30)
	if vm.skipping() then
		return skip(6)
	end
	event.CmrsMove2(-491.11, 58.84, -65.59, -180.4, 265.78, -14.82, 75, 2, 0.4)
	event.SndSePlay(arg0, 3)
	event.ObjsInitPas(3)
	event.ObjsSetPasFrm(3, 90)
	event.ObjsAddPas(3, -302.17, 113.58, -60.02)
	event.ObjsAddPas(3, -273.27, 162.52, -91.31)
	event.ObjsAddPas(3, -277.61, 214.43, -63.38)
	event.ObjsAddPas(3, -270.68, 254.99, -10.75)
	event.ObjsAddPas(3, -258.74, 289.17, 32.34)
	event.ObjsAddPas(3, -264.84, 267.38, 91.29)
	event.ObjsAddPas(3, -274.53, 223.84, 104.42)
	event.ObjsAddPas(3, -263.59, 171.46, 62.02)
	event.ObjsAddPas(3, -241.79, 175.34, 11.82)
	event.ObjsAddPas(3, -235.1, 208.28, -15.33)
	event.ObjsAddPas(3, -215.1, 272.95, -30.99)
	event.ObjsAddPas(3, -206.66, 335.24, -34.05)
	event.ObjsAddPas(3, -186.98, 388.24, -30.99)
	event.ObjsAddPas(3, -161.91, 455.92, -27.1)
	event.ObjsStartPas(3)
	var1 = 0
	while var1 < 90 do
		event.ObjsSetRot(3, 0.0, -1.71, 0.0)
		if vm.wait() then
			return skip(7)
		end
		var1 = var1 + 1
	end
	helper_29a0(3)
	if vm.skipping() then
		return skip(8)
	end
	helper_2890()
	if vm.skipping() then
		return skip(9)
	end
	event.SndSeStop(arg0, 2)
end

--- Helper function.
local function helper_17298(arg0: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_29a0(0)
		end
		if at <= 2 then
			helper_29a0(1)
		end
		if at <= 3 then
			helper_6000(1080030)
		end
		if at <= 4 then
			helper_6000(1080031)
		end
		if at <= 5 then
			helper_6000(1080032)
		end
		if at <= 6 then
			helper_2890()
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsSetPos(-350.38, 95.45, -59.38)
	event.CmrsSetRef(-418.26, 93.83, -69.21)
	event.ObjsSetMotion(0, "上見戻り", 6, 0.06)
	event.ObjsSetMotion(1, "上見戻り", 6, 0.06)
	event.ObjsMotionWait(0)
	event.ObjsMotionWait(1)
	helper_29a0(0)
	if vm.skipping() then
		return skip(2)
	end
	helper_29a0(1)
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsResetMotion(0)
	event.ObjsResetMotion(1)
	event.ObjsSetMotion(0, "立ち（スティーブ）", 4, -1.0)
	event.ObjsSetMotion(1, "立ち（スティーブ）", 4, -1.0)
	event.CmrsMove2(-376.98, 95.45, -63.23, -418.26, 93.83, -69.21, 150, 2, 0.4)
	helper_6000(1080030)
	if vm.skipping() then
		return skip(4)
	end
	helper_6000(1080031)
	if vm.skipping() then
		return skip(5)
	end
	helper_6000(1080032)
	if vm.skipping() then
		return skip(6)
	end
	helper_2890()
	if vm.skipping() then
		return skip(7)
	end
end

--- Helper function.
local function helper_1776c(arg0: any)
	local var1: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_430(30)
		end
		if at <= 2 then
			helper_8548(0, -1, 8, 0, 0)
		end
		if at <= 3 then
			helper_8548(0, -1, 8, 0, 0)
		end
		if at <= 4 then
			helper_8548(0, -1, 8, 0, 0)
		end
		if at <= 5 then
			helper_8548(0, -1, 8, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsSetPos(-276.53, 81.94, 10.07)
	event.CmrsSetRef(31.75, 72.44, -9.51)
	event.ObjsSetPos(0, -165.91, 50.0, 2.54)
	event.ObjsSetRot(0, 0.0, 1.65, 0.0)
	event.ObjsSetMotion(0, "立ち（スティーブ）", 4)
	event.ObjsSetPos(1, -165.91, 50.0, 2.54)
	event.ObjsSetRot(1, 0.0, 1.65, 0.0)
	event.ObjsSetMotion(1, "立ち（スティーブ）", 4)
	helper_430(30)
	if vm.skipping() then
		return skip(2)
	end
	var1 = event.GetMesWindowMode() or var1
	event.SetMesWindowMode(0, 8)
	event.MesMake_2(
		0,
		"[(!)]ライドポッドはメインメニューの「キャラクター」から\n   「ライドポッド」を選んで乗り降りすることができます。\n   降りる場合、ユリスを選択してください。"
	)
	helper_8548(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"[(!)]ライドポッドの燃料はスターブルに\n   補給してもらうことができます。"
	)
	helper_8548(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(
		0,
		"[(!)]また、ＥＸＰをためて、スターブルに\n   コアをパワーアップしてもらうことで、\n   装着できるパーツのキャパシティが増えます。"
	)
	helper_8548(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(
		0,
		"[(!)]キャパシティを増やし、パーツをつけかえて\n   オリジナルのライドポッドをつくりだしてください。"
	)
	helper_8548(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.SetMesWindowMode(0, var1)
end

--- Helper function.
local function helper_17ef8()
	local var0: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 8 then
			if at <= 1 then
				helper_159ac(var0)
			end
			if at <= 2 then
				helper_15d84(var0)
			end
			if at <= 3 then
				helper_161d8(var0)
			end
			if at <= 4 then
				helper_16510(var0)
			end
			if at <= 5 then
				helper_17298(var0)
			end
			if at <= 6 then
				helper_1776c(var0)
			end
			if at <= 7 then
				helper_430(30)
			end
			if vm.skip_end() then
				return skip(9)
			end
			return part2()
		end
		if at <= 9 then
			helper_430(4)
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SndSeStop(var0, 0)
		event.SndSeStop(var0, 2)
		event.CharaActive(1, 0)
		event.EohSyncChara(10, 1)
		event.EohSetShow(10, 0)
		event.EohSyncChara(11, 2)
		event.EohSetShow(11, 0)
		event.DelExtMotion(0)
		event.DeleteChara(9)
		event.DeleteChara(10)
		event.DeleteChara(11)
		event.SetCameraPos(-276.53, 81.94, 10.07)
		event.SetCameraRef(31.75, 72.44, -9.51)
		event.ResetCamera(0)
		event.DngSetupMainUnit(2)
		event.SetActiveChrNo(2)
		event.SetCharaPos(0, -167.59, 50.0, 2.86)
		event.SetCharaRot(0, 0.0, 1.77, 0.0)
		event.SetStatusbarShow(1)
		event.StopBgm(0)
		helper_430(4)
		if vm.skipping() then
			return skip(10)
		end
		event.LoadBgm(15)
		event.PlayBgm(0)
		event.ResetCamera(1, 0.0, 20.0)
		event.SetFadeIn(30)
		if vm.wait() then
			return skip(11)
		end
		event.Finish()
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFlag(108, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.SetStatusbarShow(0, 1.0)
	var0 = event.SndLoadSound(1819) or var0
	event.AssignStack(5)
	event.ClearStack(5)
	event.CmrsInit()
	event.SetCameraPos(6.02, 94.24, 399.23)
	event.SetCameraRef(-4.96, 118.28, 117.71)
	event.LoadMotion(5, "event/e100/e108/e108_mints.gltf", "info", 0)
	event.CharaActive(1, 0)
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.SetCharaPos(0, 0.0, 50.0, 0.0)
	event.SetCharaRot(0, 0.0, 0.0, 0.0)
	event.LoadChara(5, "event/e100/e108/e108_steve.gltf", "info", 9)
	event.CharaActive(1, 9)
	event.EohSyncChara(1, 9)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.SetCharaPos(9, 0.0, 50.0, 0.0)
	event.SetCharaRot(9, 0.0, 0.0, 0.0)
	event.LoadChara(5, "event/e100/e108/e108_erephant.gltf", "info", 10)
	event.CharaActive(0, 10)
	event.EohSyncChara(2, 10)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.SetCharaPos(10, 0.0, 50.0, 0.0)
	event.SetCharaRot(10, 0.0, 0.0, 0.0)
	event.LoadChara(5, "event/e100/e108/e108_polcurse.gltf", "info", 11)
	event.CharaActive(0, 11)
	event.EohSyncChara(3, 11)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.SetCharaPos(9, 0.0, 50.0, 0.0)
	event.SetCharaRot(9, 0.0, 0.0, 0.0)
	event.EohSyncChara(10, 1)
	event.EohSetShow(10, 0)
	event.EohSyncChara(11, 2)
	event.EohSetShow(11, 0)
	event.LoadMes(0, 5, "event/e100/e108/e108a.txt")
	event.StopBgm(0)
	event.InitDramaScene()
	helper_159ac(var0)
	if vm.skipping() then
		return skip(2)
	end
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsTexAnime(3, 0)
	event.ObjsTexAnime(3, 1, "おこり顔")
	event.ObjsTexAnime(3, 1, "通常目パチ")
	helper_15d84(var0)
	if vm.skipping() then
		return skip(3)
	end
	helper_161d8(var0)
	if vm.skipping() then
		return skip(4)
	end
	helper_16510(var0)
	if vm.skipping() then
		return skip(5)
	end
	helper_17298(var0)
	if vm.skipping() then
		return skip(6)
	end
	helper_1776c(var0)
	if vm.skipping() then
		return skip(7)
	end
	event.SetFadeOut(30)
	helper_430(30)
	if vm.skipping() then
		return skip(8)
	end
	return part2()
end

--- Helper function.
local function helper_190ac(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_2890()
		end
		if at <= 2 then
			helper_6000(1080040)
		end
		if at <= 3 then
			helper_6000(1080041)
		end
		if at <= 4 then
			helper_6000(1080042)
		end
		if at <= 5 then
			helper_29a0(2)
		end
		if at <= 6 then
			helper_29a0(3)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsSetPos(-129.32, 99.43, 13.13)
	event.CmrsSetRef(-44.6, 102.72, 11.17)
	event.CharaActive(0, 0)
	event.CharaActive(0, 9)
	event.CharaActive(1, 10)
	event.ObjsSetPos(2, 9.11, 50.0, -10.14)
	event.ObjsSetRot(2, 0.0, -1.44, 0.0)
	event.ObjsSetScale(2, 1.2, 1.2, 1.2)
	event.ObjsSetMotion(2, "立ち", 4)
	event.CharaActive(1, 11)
	event.ObjsSetPos(3, 1.54, 105.26, 40.3)
	event.ObjsSetRot(3, 0.0, -1.8, 0.0)
	event.ObjsSetMotion(3, "オーッホッホ", 4)
	event.CmrsFadeInit()
	event.CmrsFadeIn(30, 0.0, 0.0, 0.0)
	helper_2890()
	if vm.skipping() then
		return skip(2)
	end
	event.SndSePlay(arg0, 1)
	event.ObjsSetMotion(2, "パオーン", 6)
	event.ObjsNextMotion(2, "立ち", 0)
	event.SetPakuAnim(3, "わらい口パク")
	helper_6000(1080040)
	if vm.skipping() then
		return skip(3)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(3, "わらい口パク")
	helper_6000(1080041)
	if vm.skipping() then
		return skip(4)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(3, "わらい口パク")
	helper_6000(1080042)
	if vm.skipping() then
		return skip(5)
	end
	event.ResetPakuAnim()
	helper_29a0(2)
	if vm.skipping() then
		return skip(6)
	end
	helper_29a0(3)
	if vm.skipping() then
		return skip(7)
	end
end

--- Helper function.
local function helper_19770(arg0: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_6000(1080050)
		end
		if at <= 2 then
			helper_6000(1080060)
		end
		if at <= 3 then
			helper_29a0(3)
		end
		if at <= 4 then
			helper_2890()
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsSetPos(-17.46, 142.28, 29.34)
	event.CmrsSetRef(1.26, 135.02, 26.5)
	event.CharaActive(1, 11)
	event.ObjsSetPos(3, 1.21, 102.73, 26.08)
	event.ObjsSetRot(3, 0.0, -1.56, 0.0)
	event.ObjsSetMotion(3, "逃げちゃうの？", 4)
	event.ObjsTexAnime(3, 0)
	event.ObjsTexAnime(3, 1, "わらい顔2")
	event.SetPakuAnim(3, "わらい口パク")
	helper_6000(1080050)
	if vm.skipping() then
		return skip(2)
	end
	event.ResetPakuAnim()
	event.CmrsSetPos(-17.46, 142.28, 29.34)
	event.CmrsSetRef(1.26, 135.02, 26.5)
	event.ObjsTexAnime(3, 0)
	event.ObjsTexAnime(3, 1, "たかわらい顔")
	event.ObjsSetMotion(3, "オーッホッホ", 4)
	event.SetPakuAnim(3, "わらい口パク")
	helper_6000(1080060)
	if vm.skipping() then
		return skip(3)
	end
	event.ResetPakuAnim()
	helper_29a0(3)
	if vm.skipping() then
		return skip(4)
	end
	helper_2890()
	if vm.skipping() then
		return skip(5)
	end
end

--- Helper function.
local function helper_19c6c(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_430(50)
		end
		if at <= 2 then
			helper_29a0(0)
		end
		if at <= 3 then
			helper_29a0(1)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsSetPos(-408.29, 60.12, 94.13)
	event.CmrsSetRef(-475.86, 71.34, 81.15)
	event.CharaActive(1, 0)
	event.ObjsSetPos(0, -492.64, 50.09, 76.79)
	event.ObjsSetRot(0, 0.0, 1.2, 0.0)
	event.ObjsSetMotion(0, "プルプル", 4, -1.0, 1)
	event.CharaActive(1, 9)
	event.ObjsSetPos(1, -492.64, 50.09, 76.79)
	event.ObjsSetRot(1, 0.0, 1.2, 0.0)
	event.ObjsSetMotion(1, "プルプル", 4)
	event.SndSePlay(arg0, 0)
	helper_430(50)
	if vm.skipping() then
		return skip(2)
	end
	event.SndSePlay(arg0, 2)
	event.ObjsSetMotion(0, "ジャンプ", 6, 0.4)
	event.ObjsSetMotion(1, "ジャンプ", 6, 0.4)
	event.ObjsPosDelay(0, 3)
	event.ObjsPosDelay(1, 3)
	event.ObjsJump(0, -739.96, 133.89, -9.49, -0.28, 33)
	event.ObjsJump(1, -739.96, 133.89, -9.49, -0.28, 33)
	event.ObjsMotionWait(0)
	event.ObjsMotionWait(1)
	event.CmrsMove2(-408.29, 60.12, 94.13, -709.98, 167.81, 0.97, 25, 0, 0.4)
	helper_29a0(0)
	if vm.skipping() then
		return skip(3)
	end
	helper_29a0(1)
	if vm.skipping() then
		return skip(4)
	end
	event.SndSeStop(arg0, 0)
end

--- Helper function.
local function helper_1a3dc(arg0: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_29a0(0)
		end
		if at <= 2 then
			helper_29a0(1)
		end
		if at <= 3 then
			helper_2890()
		end
		if at <= 4 then
			helper_2890()
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsSetPos(-501.66, 281.73, -144.66)
	event.CmrsSetRef(-757.43, 150.05, -3.21)
	event.CharaActive(1, 0)
	event.ObjsSetPos(0, -739.96, 133.89, -9.49)
	event.ObjsSetRot(0, 0.0, 1.2, 0.0)
	event.CharaActive(1, 9)
	event.ObjsSetPos(1, -739.96, 133.89, -9.49)
	event.ObjsSetRot(1, 0.0, 1.2, 0.0)
	event.ObjsSetMotion(0, "歩き（スティーブ）", 4, -1.0, 1)
	event.ObjsSetMotion(1, "歩き（スティーブ）", 4)
	event.ObjsRotation(0, 0.0, -1.44, 0.0, 20)
	event.ObjsRotation(1, 0.0, -1.44, 0.0, 20)
	event.CmrsFadeInit()
	event.CmrsFadeDelay(100)
	event.CmrsFadeOut(50, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(0, "歩き（スティーブ）", 4)
	event.ObjsSetMotion(1, "歩き（スティーブ）", 4)
	event.ObjsMove(0, -915.85, 133.64, -6.02, 150)
	event.ObjsMove(1, -915.85, 133.64, -6.02, 150)
	helper_29a0(0)
	if vm.skipping() then
		return skip(2)
	end
	helper_29a0(1)
	if vm.skipping() then
		return skip(3)
	end
	helper_2890()
	if vm.skipping() then
		return skip(4)
	end
	event.CmrsFadeInit()
	event.CmrsFadeOut(50, 0.0, 0.0, 0.0)
	helper_2890()
	if vm.skipping() then
		return skip(5)
	end
end

--- Helper function.
local function helper_1ab00(arg0: any)
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_1ab74(arg0: any)
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_1abe8()
	local var0: s32 = 0
	local var1: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 6 then
			if at <= 1 then
				helper_190ac(var0)
			end
			if at <= 2 then
				helper_19770(var0)
			end
			if at <= 3 then
				helper_19c6c(var0)
			end
			if at <= 4 then
				helper_1a3dc(var0)
			end
			if at <= 5 then
				helper_1ab00(var0)
				helper_1ab74(var0)
				helper_430(30)
			end
			if vm.skip_end() then
				return skip(7)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SndSeStop(var0, 0)
		event.DelExtMotion(0)
		event.DeleteChara(9)
		event.DeleteChara(10)
		event.DeleteChara(11)
		event.Finish()
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFlag(108, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.SetStatusbarShow(0, 1.0)
	var0 = event.SndLoadSound(1822) or var0
	event.AssignStack(5)
	event.ClearStack(5)
	event.CmrsInit()
	event.SetCameraPos(6.02, 94.24, 399.23)
	event.SetCameraRef(-4.96, 118.28, 117.71)
	event.LoadMotion(5, "event/e100/e108/e108_mints.gltf", "info", 0)
	event.CharaActive(1, 0)
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.SetCharaPos(0, 0.0, 50.0, 0.0)
	event.SetCharaRot(0, 0.0, 0.0, 0.0)
	event.LoadChara(5, "event/e100/e108/e108_steve.gltf", "info", 9)
	event.CharaActive(1, 9)
	event.EohSyncChara(1, 9)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.SetCharaPos(9, 0.0, 50.0, 0.0)
	event.SetCharaRot(9, 0.0, 0.0, 0.0)
	event.EohSetSoundId(1, var1)
	event.LoadChara(5, "event/e100/e108/e108_erephant.gltf", "info", 10)
	event.CharaActive(0, 10)
	event.EohSyncChara(2, 10)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.SetCharaPos(10, 0.0, 50.0, 0.0)
	event.SetCharaRot(10, 0.0, 0.0, 0.0)
	event.LoadChara(5, "event/e100/e108/e108_polcurse.gltf", "info", 11)
	event.CharaActive(0, 11)
	event.EohSyncChara(3, 11)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.SetCharaPos(11, 0.0, 50.0, 0.0)
	event.SetCharaRot(11, 0.0, 0.0, 0.0)
	event.SetTexAnim(11, 0, "口パク")
	event.EohSyncChara(10, 1)
	event.EohSetShow(10, 0)
	event.EohSyncChara(11, 2)
	event.EohSetShow(11, 0)
	event.LoadMes(0, 5, "event/e100/e108/e108b.txt")
	event.StopBgm(0)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おこり顔")
	event.ObjsTexAnime(0, 1, "おこり目パチ")
	event.ObjsTexAnime(3, 0)
	event.ObjsTexAnime(3, 1, "たかわらい顔")
	event.EohSetSoundId(1, var0)
	event.InitDramaScene()
	helper_190ac(var0)
	if vm.skipping() then
		return skip(2)
	end
	helper_19770(var0)
	if vm.skipping() then
		return skip(3)
	end
	helper_19c6c(var0)
	if vm.skipping() then
		return skip(4)
	end
	helper_1a3dc(var0)
	if vm.skipping() then
		return skip(5)
	end
	helper_1ab00(var0)
	helper_1ab74(var0)
	event.SetFadeOut(30)
	helper_430(30)
	if vm.skipping() then
		return skip(6)
	end
	return part2()
end

--- Helper function.
local function helper_1ba24(arg0: s32)
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: s32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_29a0(0)
		end
		if at <= 2 then
			helper_29a0(1)
		end
		if at <= 3 then
			helper_2890()
		end
		if at <= 4 then
			helper_29a0(0)
		end
		if at <= 5 then
			helper_29a0(1)
		end
		if at <= 6 then
			helper_29a0(0)
		end
		if at <= 7 then
			helper_29a0(1)
		end
		if at <= 8 then
			helper_2890()
		end
		if at <= 9 then
			helper_430(30)
		end
		if at <= 10 then
			var4 = 0
			helper_430(2)
		end
		if at <= 12 then
			var4 = var4 + 1
			helper_430(22)
		end
		if at <= 13 then
			helper_29a0(0)
		end
		if at <= 14 then
			helper_29a0(1)
		end
		if at <= 15 then
			helper_430(30)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsFadeInit()
	event.CmrsFadeIn(200, 0.0, 0.0, 0.0)
	event.CmrsSetPos(1010.98, 218.14, -55.12)
	event.CmrsSetRef(-755.14, 237.29, -2.56)
	event.ObjsSetPos(0, -943.03, 134.76, 0.63)
	event.ObjsSetRot(0, 0.0, 1.6, 0.0)
	event.ObjsSetPos(1, -943.03, 134.76, 0.63)
	event.ObjsSetRot(1, 0.0, 1.6, 0.0)
	event.CmrsMove(64.12, 205.59, -18.9, -755.14, 157.59, -2.56, 120)
	event.ObjsMove(0, -739.93, 134.76, -3.16, 120)
	event.ObjsMove(1, -739.93, 134.76, -3.16, 120)
	event.ObjsSetMotion(0, "歩き（スティーブ）", 4)
	event.ObjsSetMotion(1, "歩き（スティーブ）", 4)
	helper_29a0(0)
	if vm.skipping() then
		return skip(2)
	end
	helper_29a0(1)
	if vm.skipping() then
		return skip(3)
	end
	helper_2890()
	if vm.skipping() then
		return skip(4)
	end
	event.ObjsSetMotion(0, "立ち（スティーブ）", 4)
	event.ObjsSetMotion(1, "立ち（スティーブ）", 4)
	event.CmrsSetPos(-667.47, 186.39, -3.73)
	event.CmrsSetRef(-755.14, 160.61, -2.56)
	event.ObjsSetPos(0, -768.25, 133.66, -2.78)
	event.ObjsSetRot(0, 0.0, 1.6, 0.0)
	event.ObjsSetPos(1, -768.25, 133.66, -2.78)
	event.ObjsSetRot(1, 0.0, 1.6, 0.0)
	event.ObjsSetMotion(0, "歩き（スティーブ）", 4)
	event.ObjsSetMotion(1, "歩き（スティーブ）", 4)
	event.ObjsMove(0, -739.93, 134.76, -3.16, 20)
	event.ObjsMove(1, -739.93, 134.76, -3.16, 20)
	helper_29a0(0)
	if vm.skipping() then
		return skip(5)
	end
	helper_29a0(1)
	if vm.skipping() then
		return skip(6)
	end
	event.ObjsSetMotion(0, "立ち（スティーブ）")
	event.ObjsSetMotion(1, "立ち（スティーブ）")
	helper_29a0(0)
	if vm.skipping() then
		return skip(7)
	end
	helper_29a0(1)
	if vm.skipping() then
		return skip(8)
	end
	helper_2890()
	if vm.skipping() then
		return skip(9)
	end
	helper_430(30)
	if vm.skipping() then
		return skip(10)
	end
	event.CmrsSetPos(-302.7, 76.94, -10.38)
	event.CmrsSetRef(-787.0, 134.76, 18.98)
	event.CharaActive(1, 0)
	event.ObjsSetPos(0, -802.5, 134.76, -2.32)
	event.ObjsSetRot(0, 0.0, 1.6, 0.0)
	event.ObjsSetMotion(0, "立ち（スティーブ）", 4)
	event.CharaActive(1, 9)
	event.ObjsSetPos(1, -802.5, 134.76, -2.32)
	event.ObjsSetRot(1, 0.0, 1.6, 0.0)
	event.ObjsSetMotion(1, "立ち（スティーブ）", 4)
	event.SndSePlay(arg0, 2)
	event.ObjsSetMotion(0, "ジャンプ", 2, 0.4)
	event.ObjsNextMotion(0, "立ち（スティーブ）")
	event.ObjsSetMotion(1, "ジャンプ", 2, 0.4)
	event.ObjsNextMotion(1, "立ち（スティーブ）")
	event.ObjsPosDelay(0, 3)
	event.ObjsPosDelay(1, 3)
	event.ObjsJump(0, -378.73, 50.06, 32.39, -0.35, 31)
	event.ObjsJump(1, -378.73, 50.06, 32.39, -0.35, 31)
	var4 = 0
	helper_430(2)
	if vm.skipping() then
		return skip(11)
	end
	while var4 < 31 do
		do
			local out1, out2, out3 = event.GetCharaPos(9)
			var1 = out1 or var1
			var2 = out2 or var2
			var3 = out3 or var3
		end
		event.CmrsSetRef(var1 - 14.5, var2 + 17.0, var3 + vm.f32(21.3))
		if vm.wait() then
			return skip(12)
		end
		var4 = var4 + 1
	end
	do
		local out1, out2, out3 = event.GetCharaPos(9)
		var5 = out1 or var5
		var6 = out2 or var6
		var7 = out3 or var7
	end
	event.EsmCreate("砂煙e107")
	event.EsmSetVect1(var5, var6 + 5.0, var7)
	event.EsmSetVect2(1.2, 1.2, 1.2)
	event.EsmCreate("砂煙e107")
	event.EsmSetVect1(-378.99, 55.0, 20.63)
	event.EsmSetVect2(1.2, 1.2, 1.2)
	event.EsmCreate("砂煙e107")
	event.EsmSetVect1(-379.65, 55.0, 46.12)
	event.EsmSetVect2(1.2, 1.2, 1.2)
	helper_430(22)
	if vm.skipping() then
		return skip(13)
	end
	event.SndSePlay(arg0, 3)
	event.SndSePlay(arg0, 1)
	event.CmrsSetPos(-261.64, 62.84, 2.96)
	event.CmrsSetRef(-368.77, 78.25, 5.08)
	event.ObjsSetPos(0, -377.87, 50.06, 4.42)
	event.ObjsSetRot(0, 0.0, 1.6, 0.0)
	event.ObjsSetPos(1, -377.87, 50.06, 4.42)
	event.ObjsSetRot(1, 0.0, 1.6, 0.0)
	helper_29a0(0)
	if vm.skipping() then
		return skip(14)
	end
	helper_29a0(1)
	if vm.skipping() then
		return skip(15)
	end
	helper_430(30)
	if vm.skipping() then
		return skip(16)
	end
end

--- Helper function.
local function helper_1d178(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_430(43)
		end
		if at <= 2 then
			helper_29a0(2)
		end
		if at <= 3 then
			helper_2890()
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SndSeStop(arg0, 1)
	event.SndSePlay(arg0, 4)
	event.CmrsSetPos(-133.46, 84.21, 3.17)
	event.CmrsSetRef(44.81, 76.82, -5.13)
	event.CharaActive(1, 0)
	event.ObjsSetPos(0, -240.84, 50.51, -5.32)
	event.ObjsSetRot(0, 0.0, 1.6, 0.0)
	event.ObjsSetMotion(0, "立ち（スティーブ）", 4)
	event.CharaActive(1, 9)
	event.ObjsSetPos(1, -240.84, 50.51, -5.32)
	event.ObjsSetRot(1, 0.0, 1.6, 0.0)
	event.ObjsSetMotion(0, "立ち（スティーブ）", 4)
	event.CharaActive(1, 10)
	event.ObjsSetPos(2, 10.66, 50.0, -0.04)
	event.ObjsSetRot(2, 0.0, -1.56, 0.0)
	event.ObjsSetScale(2, 1.2, 1.2, 1.2)
	event.PlayBgm(0)
	event.CmrsQuakeDelay(6)
	event.CmrsQuake(0.0, 1.5, 0.0, 24)
	event.CmrsPrdelay(30)
	event.CmrsSetPos(82.22, 91.62, -68.3)
	event.CmrsSetRef(-234.51, 58.39, 145.67)
	event.ObjsSetMotion(2, "着地", 6)
	event.ObjsMotionWait(2)
	helper_430(43)
	if vm.skipping() then
		return skip(2)
	end
	event.SndSePlay(arg0, 5)
	helper_29a0(2)
	if vm.skipping() then
		return skip(3)
	end
	helper_2890()
	if vm.skipping() then
		return skip(4)
	end
end

--- Helper function.
local function helper_1d8a0(arg0: any)
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_34e0(arg0: s32, arg1: any, arg2: any)
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
		helper_2d8c(arg0)
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
			helper_2d8c(arg0)
		end
	end
	event.ResetPakuMotion()
	event.TrgPakuAnim(0)
	event.ResetPakuAnim()
	event.StreamStop(1)
	event.SetMesOkuri(arg0, 1)
end

--- Helper function.
local function helper_3be4(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_34e0(arg0, vm.ftoi(arg1), -1)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	helper_34e0(arg0, vm.ftoi(arg1), -1)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_564c(arg0: s32, arg1: s32)
	local stream_open_state: s32 = 0
	local stream_open_state_2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			helper_2b48(0, -1, 8, 0, 0)
			helper_3be4(0, arg1)
		end
		helper_2d8c(0)
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
	helper_2b48(0, -1, 8, 0, 0)
	event.StreamPlay(1)
	helper_3be4(0, arg1)
	if vm.skipping() then
		return skip(4)
	end
	helper_2d8c(0)
	event.StreamClose(1)
	event.SetMesPos(0, 0)
end

--- Helper function.
local function helper_1d914(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_6000(1080070)
		end
		if at <= 2 then
			helper_564c(1080075, 100)
		end
		if at <= 3 then
			helper_29a0(2)
		end
		if at <= 4 then
			helper_29a0(3)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsSetPos(-44.56, 149.8, 16.49)
	event.CmrsSetRef(29.9, 155.39, 35.57)
	event.CharaActive(0, 0)
	event.CharaActive(0, 9)
	event.CharaActive(1, 10)
	event.ObjsSetRot(2, 0.0, -1.32, 0.0)
	event.ObjsSetScale(2, 1.2, 1.2, 1.2)
	event.ObjsSetMotion(2, "立ち", 4)
	event.CharaActive(1, 11)
	event.ObjsSetPos(3, 35.03, 137.05, 41.92)
	event.ObjsSetRot(3, 0.0, -1.92, 0.0)
	event.SndSePlay(arg0, 6)
	event.ObjsSetMotion(3, "まわる", 6)
	event.ObjsNextMotion(3, "会話")
	event.SetPakuAnim(3, "わらい口パク")
	helper_6000(1080070)
	if vm.skipping() then
		return skip(2)
	end
	event.ResetPakuAnim()
	event.ObjsSetRot(3, 0.0, -1.56, 0.0)
	event.SndSePlay(arg0, 8)
	event.ObjsSetMotion(2, "パオーン", 6)
	event.ObjsNextMotion(2, "立ち", 0)
	event.ObjsSetMotion(3, "指差す", 6)
	event.CmrsMove2(-158.84, 98.6, 40.59, 12.88, 114.56, 18.64, 10, 1, 0.3)
	event.SetPakuAnim(3, "わらい口パク")
	helper_564c(1080075, 100)
	if vm.skipping() then
		return skip(3)
	end
	event.ResetPakuAnim()
	helper_29a0(2)
	if vm.skipping() then
		return skip(4)
	end
	helper_29a0(3)
	if vm.skipping() then
		return skip(5)
	end
end

--- Helper function.
local function helper_1e040()
	local var0: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 5 then
			if at <= 1 then
				helper_1ba24(var0)
			end
			if at <= 2 then
				helper_1d178(var0)
			end
			if at <= 3 then
				helper_1d8a0(var0)
				helper_1d914(var0)
			end
			if at <= 4 then
				helper_430(15)
			end
			if vm.skip_end() then
				return skip(6)
			end
			return part2()
		end
		if at <= 6 then
			helper_430(4)
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SndSeStop(var0, 1)
		event.EohSyncChara(10, 1)
		event.EohSetShow(10, 1)
		event.EohSyncChara(11, 2)
		event.EohSetShow(11, 1)
		event.EsmClear()
		event.DelExtMotion(0)
		event.DeleteChara(9)
		event.DeleteChara(11)
		event.ResetCamera(0)
		event.DngSetupMainUnit(2)
		event.SetActiveChrNo(2)
		event.DeleteChara(10)
		event.StopBgm(0)
		helper_430(4)
		if vm.skipping() then
			return skip(7)
		end
		event.LoadBgm(190)
		event.PlayBgm(0)
		event.SetCameraPos(-372.02, 97.7, 1.24)
		event.SetCameraRef(-275.93, 89.37, -1.57)
		event.ResetCamera(0)
		event.ObjsInit(0)
		event.ObjsInit(1)
		event.CharaActive(1, 0)
		event.SetCharaPos(0, -240.84, 50.0, -5.32)
		event.SetCharaRot(0, 0.0, 1.6, 0.0)
		event.SetStatusbarShow(1)
		event.SetFadeIn(30)
		event.AutoSetMonster(601, 10.66, 50.0, -0.04, 0.0, -1.5707964, 0.0)
		event.Finish()
	end
	event.SetFlag(108, 1)
	event.Initialize()
	event.InitDramaScene()
	event.SetMesWindowMode(0, 7)
	event.SetStatusbarShow(0, 1.0)
	event.BgmLoadEnable()
	event.SoundLoadEnable()
	event.BgmPlayEnable()
	event.LoadSound(1825)
	var0 = event.SndLoadSound(1825) or var0
	event.AssignStack(5)
	event.ClearStack(5)
	event.CmrsInit()
	event.CmrsSetPos(6.02, 94.24, 399.23)
	event.CmrsSetRef(-4.96, 118.28, 117.71)
	event.LoadMotion(5, "event/e100/e107/e107_mints.gltf", "info", 0)
	event.CharaActive(1, 0)
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetPos(0, 0.0, 50.0, 0.0)
	event.ObjsSetRot(0, 0.0, 0.0, 0.0)
	event.LoadChara(5, "event/e100/e108/e108_steve.gltf", "info", 9)
	event.CharaActive(1, 9)
	event.EohSyncChara(1, 9)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.ObjsSetPos(1, 0.0, 50.0, 0.0)
	event.ObjsSetRot(1, 0.0, 0.0, 0.0)
	event.EohSetSoundId(1, var0)
	event.LoadChara(5, "event/e100/e107/e107_erephant.gltf", "info", 10)
	event.CharaActive(0, 10)
	event.EohSyncChara(2, 10)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.ObjsSetPos(2, 0.0, 50.0, 0.0)
	event.ObjsSetRot(2, 0.0, 0.0, 0.0)
	event.EohSetShadow(2, 0)
	event.LoadChara(5, "event/e100/e107/e107_polcurse.gltf", "info", 11)
	event.CharaActive(0, 11)
	event.EohSyncChara(3, 11)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.ObjsSetPos(1, 0.0, 50.0, 0.0)
	event.ObjsSetRot(1, 0.0, 0.0, 0.0)
	event.EohSyncChara(10, 1)
	event.EohSetShow(10, 0)
	event.EohSyncChara(11, 2)
	event.EohSetShow(11, 0)
	event.SetFadeOut(0)
	event.StopBgm(0)
	helper_430(4)
	if vm.skipping() then
		return skip(1)
	end
	event.LoadBgm(105)
	event.EsmInitialize(5, 1)
	event.EsmLoadBase("砂煙e107")
	event.EsmInitFix(5)
	event.LoadMes(0, 5, "event/e100/e108/e108c.txt")
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "無表情")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	helper_1ba24(var0)
	if vm.skipping() then
		return skip(2)
	end
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "ポカーン顔")
	event.ObjsTexAnime(0, 1, "ぱちぱち")
	helper_1d178(var0)
	if vm.skipping() then
		return skip(3)
	end
	helper_1d8a0(var0)
	event.ObjsTexAnime(3, 0)
	event.ObjsTexAnime(3, 1, "わらい顔")
	helper_1d914(var0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetFadeOut(15)
	helper_430(15)
	if vm.skipping() then
		return skip(5)
	end
	return part2()
end

--- Helper function.
local function helper_1038()
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
local function helper_113c(arg0: s32)
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
local function helper_60b0(arg0: any, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_113c(1)
		end
		if at <= 2 then
			helper_3be4(0, arg1)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.StreamOpen3(1, arg0)
	helper_113c(1)
	if vm.skipping() then
		return skip(2)
	end
	event.StreamPlay(1)
	helper_3be4(0, arg1)
	if vm.skipping() then
		return skip(3)
	end
	event.StreamClose(1)
end

--- Helper function.
local function helper_eb4(arg0: s32)
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
local function helper_2abc(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesWindowMode(arg0, arg1)
end

--- Helper function.
local function helper_ca40(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_2abc(1, 4)
			helper_8548(1, vm.i32(60 + arg0), 8, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(1, 4)
	helper_2abc(1, 4)
	helper_8548(1, vm.i32(60 + arg0), 8, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_df4c(arg0: any, arg1: any)
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
				helper_430(30)
			end
			if at <= 2 then
				helper_1038()
			end
			if at <= 3 then
				helper_430(30)
			end
			if at <= 4 then
				helper_60b0(arg1, -1)
			end
			if at <= 5 then
				helper_430(10)
			end
			if at <= 6 then
				helper_430(30)
			end
			if at <= 7 then
				helper_430(120)
			end
			if at <= 8 then
				local _ = helper_eb4(0)
			end
			if at <= 9 then
				helper_ca40(1)
			end
			if at <= 10 then
				helper_ca40(4)
			end
			if at <= 11 then
				helper_ca40(active_chr_no)
			end
			if at <= 12 then
				helper_ca40(1)
			end
			if at <= 13 then
				helper_430(30)
			end
			if at <= 15 then
				helper_430(30)
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
	helper_430(30)
	if vm.skipping() then
		return skip(2)
	end
	event.SetStatusbarShow(0, 0.06666667)
	helper_1038()
	if vm.skipping() then
		return skip(3)
	end
	event.LoadBgmPack(60)
	if var8 == 1 or var8 ~= 1 and arg1 < 0 then
		event.PlayBgm(0)
	end
	helper_430(30)
	if vm.skipping() then
		return skip(4)
	end
	event.DngPause(1, 1)
	event.DngCollisionAllClr()
	if var8 ~= 1 then
		block = event.LoadImg_4(5, "textures/dungeon/image/gameover.json", 1) or block
		if arg1 >= 0 then
			helper_60b0(arg1, -1)
			if vm.skipping() then
				return skip(5)
			end
			helper_430(10)
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
		helper_430(30)
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
		helper_430(120)
		if vm.skipping() then
			return skip(8)
		end
		while true do
			if helper_eb4(0) ~= 0 then
				break
			end
			if vm.wait() then
				return skip(9)
			end
		end
	elseif active_chr_no == 3 then
		var10 = event.CheckEnableCharaChange(1) or var10
		if var10 == 0 then
			helper_ca40(1)
			if vm.skipping() then
				return skip(10)
			end
		else
			helper_ca40(4)
			if vm.skipping() then
				return skip(11)
			end
		end
	elseif active_chr_no == 0 or active_chr_no == 2 then
		helper_ca40(active_chr_no)
		if vm.skipping() then
			return skip(12)
		end
	else
		helper_ca40(1)
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
		helper_430(30)
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
		helper_430(30)
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
	helper_430(4)
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
local function helper_10218(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		return helper_df4c(arg0, -1)
	end
	if vm.skipping() then
		return skip(1)
	end
	return helper_df4c(arg0, -1)
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 150.
script[150] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_207bc()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 151.
script[151] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_f58(32)
		end
	end
	event.SetCharaPos(0, -240.84, 50.0, -5.32)
	event.SetCharaRot(0, 0.0, 1.6, 0.0)
	if vm.wait() then
		return skip(1)
	end
	helper_f58(32)
	if vm.skipping() then
		return skip(2)
	end
end

--- Program 300.
script[300] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	program_310()
	if vm.skipping() then
		return skip(1)
	end
end

script[310] = program_310

--- Program 500.
script[500] = function()
	local flag: s32 = 0
	local flag_2: s32 = 0
	local member: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_2136c(1)
			return
		end
		if at <= 2 then
			helper_207bc()
		end
		if at <= 3 then
			helper_207bc()
		end
		if at <= 4 then
			helper_207bc()
		end
		if at <= 5 then
			helper_207bc()
		end
	end
	helper_fab3eef4()
	flag = event.GetFlag(7) or flag
	if flag == 0 then
		flag = event.GetFlag(106) or flag
		flag_2 = event.GetFlag(104) or flag_2
		member = event.JoinPartyMember(2) or member
		if (if flag == 1 then member else 0) ~= 0 or flag_2 == 0 then
			event.SetBitCtrl(1, 1)
			helper_2136c(1)
		end
	end
	event.FuncPointShow("", "dun_out", 0)
	flag = event.GetFlag(7) or flag
	if flag == 1 then
		event.FuncPointShow("p01_s06", "doa1", 0)
		event.FuncPointShow("p01_s06", "doa0", 1)
		flag = event.GetFlag(109) or flag
		if flag ~= 0 then
			event.FuncPointShow("", "dun_out", 1)
		end
	else
		event.FuncPointShow("p01_s06", "doa1", 0)
		event.FuncPointShow("p01_s06", "doa0", 1)
		member = event.JoinPartyMember(2) or member
		if member == 0 then
			flag = event.GetFlag(105) or flag
			if flag == 1 then
				event.FuncPointShow("", "dun_out", 1)
			end
		else
			event.FuncPointShow("", "dun_out", 0)
		end
	end
	event.Initialize()
	event.SetFadeOut(0)
	if vm.wait() then
		return skip(1)
	end
	flag = event.GetFlag(103) or flag
	if flag == 0 then
		helper_2136c(1)
		event.LoadScript("s06/s06b.stb", 500)
		return
	else
		member = event.JoinPartyMember(2) or member
		if member ~= 0 then
			flag = event.GetFlag(25) or flag
			if flag == 1 then
				event.SetFlag(5, 0)
				flag = event.GetFlag(6) or flag
				if flag == 0 then
					event.SetFadeOut(0)
					event.SetFlag(6, 1)
					event.LoadScript("s06/s06b.stb", 510)
					return
				else
					flag = event.GetFlag(7) or flag
					if flag == 0 then
						event.SetFadeOut(0)
						event.LoadScript("s06/s06b.stb", 520)
						return
					else
						helper_207bc()
						if vm.skipping() then
							return skip(2)
						end
					end
				end
			else
				helper_207bc()
				if vm.skipping() then
					return skip(3)
				end
			end
		else
			event.SetFlag(5, 0)
			flag = event.GetFlag(7) or flag
			if flag == 1 then
				helper_207bc()
				if vm.skipping() then
					return skip(4)
				end
			else
				member = event.JoinPartyMember(2) or member
				if member == 0 then
					flag = event.GetFlag(105) or flag
					if flag == 1 then
						helper_207bc()
						if vm.skipping() then
							return skip(5)
						end
					end
				else
					event.LoadMonsterFile(601, 1)
					helper_207bc()
					if vm.skipping() then
						return skip(6)
					end
					event.Initialize()
					event.AutoSetMonster(601, -36.31, 50.0, 1.24, 0.0, 0.0, 0.0)
					event.Finish()
				end
			end
		end
	end
	event.SetFadeIn(30)
	event.Finish()
end

--- Program 501.
script[501] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	event.LoadScript("s06/s06c.stb", 500)
	if vm.wait() then
		return skip(1)
	end
end

--- Program 502.
script[502] = function()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_2136c(0)
			helper_17ef8()
			if not vm.skipping() then
				return part2()
			end
		end
	end
	function part2()
		event.DelMonster(-1)
	end
	event.SetFadeOut(30)
	helper_430(30)
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	event.SetFlag(7, 1)
	event.DngSetupMainUnit(0)
	event.SetActiveChrNo(0)
	helper_2136c(0)
	event.DngPause(17, 1)
	helper_17ef8()
	if vm.skipping() then
		return skip(2)
	end
	return part2()
end

--- Program 503.
script[503] = function()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_1abe8()
			if not vm.skipping() then
				return part2()
			end
		end
	end
	function part2()
		event.BgmLoadCancel()
		event.GotoEdit(10, 531)
		if vm.wait() then
			return skip(3)
		end
	end
	event.SetBitCtrl(1, 0)
	helper_2136c(0)
	event.SetFadeOut(30)
	helper_430(30)
	if vm.skipping() then
		return skip(1)
	end
	event.AddHpRate(1.0, 0)
	event.DngSetupMainUnit(0)
	event.SetActiveChrNo(0)
	event.DngPause(17, 1)
	helper_1abe8()
	if vm.skipping() then
		return skip(2)
	end
	return part2()
end

--- Program 504.
script[504] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetFadeOut(0)
	helper_1e040()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 505.
script[505] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.LoadScript("s06/06c.stb", 500)
	if vm.wait() then
		return skip(1)
	end
end

--- Program 506.
script[506] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.LoadScript("s06/06c.stb", 500)
	if vm.wait() then
		return skip(1)
	end
end

--- Program 507.
script[507] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetFadeOut(0)
	event.SetFlag(6, 1)
	event.LoadScript("s06/s06b.stb", 510)
	if vm.wait() then
		return skip(1)
	end
end

--- Program 600.
script[600] = function()
	local active_chr_no: s32 = 0
	local var1: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_8548(0, 21, 5, 256, 208)
			end
			return
		end
		if at <= 3 then
			helper_430(30)
		end
	end
	event.Initialize()
	event.ActchrSetDefMotion(0)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 2 or active_chr_no == 3 then
		event.Initialize()
		event.SetMesWindowMode(0, 1)
		event.SetMesDrawspeed(0, 1)
		if active_chr_no == 2 then
			helper_8548(0, 20, 5, 256, 208)
			if vm.skipping() then
				return skip(1)
			end
		else
			helper_8548(0, 21, 5, 256, 208)
			if vm.skipping() then
				return skip(2)
			end
		end
		event.SetMesDrawspeed(0, 0)
		event.DngPause(1, 0)
		event.Finish()
		return
	end
	event.SetMesWindowMode(0, 5)
	event.MesMake_2(0, "『地下水道』に移動しますか？")
	var1 = helper_7910(0, -1, 8, 256, 208, 2, 1)
	if vm.skipping() then
		return skip(3)
	end
	if var1 == 0 then
		event.SetFadeOut(30)
		helper_430(30)
		if vm.skipping() then
			return skip(4)
		end
		event.SetBitCtrl(1, 0)
		event.LoadScript("d01/d01.stb", 1000)
		return
	end
	event.Finish()
end

--- Program 601.
script[601] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		helper_2136c(1)
	end
	if vm.wait() then
		return skip(1)
	end
	helper_2136c(1)
	event.LoadScript("s06/s06c.stb", 600)
end

--- Program 630.
script[630] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.GotoEdit(12, 540)
	if vm.wait() then
		return skip(1)
	end
end

--- Program 1200.
script[1200] = function()
	local active_chr_no: s32 = 0
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_10218(0)
		end
		if at <= 2 then
			helper_10218(0)
		end
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 2 then
		flag = event.GetFlag(7) or flag
		if flag == 0 then
			event.SetFlag(6, 1)
			if vm.wait() then
				return skip(1)
			end
			event.LoadScript("s06/s06.stb", 503)
		else
			helper_10218(0)
			if vm.skipping() then
				return skip(2)
			end
		end
	else
		helper_10218(0)
		if vm.skipping() then
			return skip(3)
		end
	end
end

--- Program 11030.
script[11030] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetFlag(103, 0)
	if vm.wait() then
		return skip(1)
	end
	event.LoadScript("s06/s06b.stb", 500)
end

--- Program 11040.
script[11040] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.wait() then
		return skip(1)
	end
	event.LoadScript("s06/s06c.stb", 500)
end

--- Program 11070.
script[11070] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetFlag(107, 1)
	if vm.wait() then
		return skip(1)
	end
	event.LoadScript("s06/s06b.stb", 510)
end

--- Program 11081.
script[11081] = function()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_17ef8()
			if not vm.skipping() then
				return part2()
			end
		end
	end
	function part2()
		event.SetFlag(7, 1)
	end
	event.DngPause(1, 1)
	event.SetFadeOut(15)
	helper_430(15)
	if vm.skipping() then
		return skip(1)
	end
	event.DngSetupMainUnit(0)
	event.SetActiveChrNo(0)
	event.DngPause(17, 1)
	helper_17ef8()
	if vm.skipping() then
		return skip(2)
	end
	return part2()
end

--- Program 11082.
script[11082] = function()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_1abe8()
			if not vm.skipping() then
				return part2()
			end
		end
	end
	function part2()
		event.BgmLoadCancel()
		event.GotoEdit(10, 531)
		if vm.wait() then
			return skip(3)
		end
	end
	event.SetBitCtrl(1, 0)
	event.SetFadeOut(30)
	helper_430(30)
	if vm.skipping() then
		return skip(1)
	end
	event.AddHpRate(1.0, 0)
	event.DngSetupMainUnit(0)
	event.SetActiveChrNo(0)
	event.DngPause(17, 1)
	helper_1abe8()
	if vm.skipping() then
		return skip(2)
	end
	return part2()
end

--- Program 21010.
script[21010] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_430(4)
		end
		helper_2136c(1)
	end
	event.Initialize()
	if vm.wait() then
		return skip(1)
	end
	event.StopBgm(0)
	helper_430(4)
	if vm.skipping() then
		return skip(2)
	end
	event.LoadBgm(190)
	event.PlayBgm(0)
	event.SetFadeIn(30)
	event.SetCharaPos(0, 0.0, 50.0, 100.0)
	event.SetCharaRot(0, 0.0, 3.1415927, 0.0)
	helper_2136c(1)
	event.LoadMonsterFile(601, 1)
	event.AutoSetMonster(601, 10.66, 50.0, -0.04, 0.0, -1.5707964, 0.0)
	event.Finish()
	event.ResetCamera(1, 0.0, 20.0)
end

return script
