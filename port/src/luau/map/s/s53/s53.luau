--!strict
-- map/s/s53/s53.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_315544cc = require("@lib/event/helper_315544cc")
local helper_8001137a = require("@lib/event/helper_8001137a")
local helper_8f303b3a = require("@lib/event/helper_8f303b3a")
local helper_b2ebd4c4 = require("@lib/event/helper_b2ebd4c4")
local helper_c5d439e6 = require("@lib/event/helper_c5d439e6")

--- Helper function.
local function helper_2dd8(arg0: s32, arg1: s32)
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
local function helper_3c00(arg0: s32)
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
			t1, var2 = helper_2dd8(arg0, var2)
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
		t0, var2 = helper_2dd8(arg0, var2)
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
local function helper_5c70(arg0: s32)
	local stream_open_state: s32 = 0
	local stream_open_state_2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			helper_315544cc(0, -1, 8, 0, 0)
			helper_3c00(0)
		end
		helper_b2ebd4c4(0)
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
	helper_315544cc(0, -1, 8, 0, 0)
	event.StreamPlay(1)
	helper_3c00(0)
	if vm.skipping() then
		return skip(4)
	end
	helper_b2ebd4c4(0)
	event.StreamClose(1)
end

--- Helper function.
local function helper_5f60(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_5c70(arg0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, arg0)
	helper_5c70(arg0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_109c(arg0: s32)
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
local function helper_3440(arg0: s32, arg1: any, arg2: any)
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
		helper_b2ebd4c4(arg0)
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
			helper_b2ebd4c4(arg0)
		end
	end
	event.ResetPakuMotion()
	event.TrgPakuAnim(0)
	event.ResetPakuAnim()
	event.StreamStop(1)
	event.SetMesOkuri(arg0, 1)
end

--- Helper function.
local function helper_3b44(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_3440(arg0, vm.ftoi(arg1), -1)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	helper_3440(arg0, vm.ftoi(arg1), -1)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_6010(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_109c(1)
		end
		if at <= 2 then
			helper_3b44(0, arg1)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.StreamOpen3(1, arg0)
	helper_109c(1)
	if vm.skipping() then
		return skip(2)
	end
	event.StreamPlay(1)
	helper_3b44(0, arg1)
	if vm.skipping() then
		return skip(3)
	end
	event.StreamClose(1)
end

--- Helper function.
local function helper_b8ac()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 56 then
			if at <= 1 then
				helper_8f303b3a()
			end
			if at <= 2 then
				helper_8001137a(0)
			end
			if at <= 3 then
				helper_8001137a(1)
			end
			if at <= 4 then
				helper_8001137a(0)
			end
			if at <= 5 then
				helper_8001137a(1)
			end
			if at <= 6 then
				helper_c5d439e6(9)
			end
			if at <= 7 then
				helper_5f60(6000010)
			end
			if at <= 8 then
				helper_8001137a(0)
			end
			if at <= 9 then
				helper_5f60(6000020)
			end
			if at <= 10 then
				helper_8001137a(0)
			end
			if at <= 11 then
				helper_5f60(6000030)
			end
			if at <= 12 then
				helper_8001137a(4)
			end
			if at <= 13 then
				helper_5f60(6000040)
			end
			if at <= 14 then
				helper_8001137a(2)
			end
			if at <= 15 then
				helper_5f60(6000050)
			end
			if at <= 16 then
				helper_8001137a(0)
			end
			if at <= 17 then
				helper_5f60(6000060)
			end
			if at <= 18 then
				helper_8001137a(1)
			end
			if at <= 19 then
				helper_5f60(6000070)
			end
			if at <= 20 then
				helper_5f60(6000080)
			end
			if at <= 21 then
				helper_8001137a(3)
			end
			if at <= 22 then
				helper_5f60(6000090)
			end
			if at <= 23 then
				helper_8001137a(2)
			end
			if at <= 24 then
				helper_5f60(6000100)
			end
			if at <= 25 then
				helper_5f60(6000105)
			end
			if at <= 26 then
				helper_8001137a(3)
			end
			if at <= 27 then
				helper_6010(6000110, -1)
			end
			if at <= 28 then
				helper_8001137a(4)
			end
			if at <= 29 then
				helper_6010(6000120, -1)
			end
			if at <= 30 then
				helper_8001137a(2)
			end
			if at <= 31 then
				helper_8001137a(4)
			end
			if at <= 32 then
				helper_8001137a(2)
			end
			if at <= 33 then
				helper_5f60(6000130)
			end
			if at <= 34 then
				helper_8001137a(0)
			end
			if at <= 35 then
				helper_5f60(6000140)
			end
			if at <= 36 then
				helper_8001137a(3)
			end
			if at <= 37 then
				helper_5f60(6000150)
			end
			if at <= 38 then
				helper_5f60(6000155)
			end
			if at <= 39 then
				helper_8001137a(1)
			end
			if at <= 40 then
				helper_5f60(6000160)
			end
			if at <= 41 then
				helper_5f60(6000170)
			end
			if at <= 42 then
				helper_5f60(6000180)
			end
			if at <= 43 then
				helper_5f60(6000185)
			end
			if at <= 44 then
				helper_8001137a(4)
			end
			if at <= 45 then
				helper_5f60(6000190)
			end
			if at <= 46 then
				helper_8001137a(0)
			end
			if at <= 47 then
				helper_5f60(6000200)
			end
			if at <= 48 then
				helper_5f60(6000210)
			end
			if at <= 49 then
				helper_8001137a(0)
			end
			if at <= 50 then
				helper_8001137a(3)
			end
			if at <= 51 then
				helper_5f60(6000220)
			end
			if at <= 52 then
				helper_8001137a(2)
			end
			if at <= 53 then
				helper_5f60(6000230)
			end
			if at <= 54 then
				helper_5f60(6000240)
			end
			if at <= 55 then
				helper_c5d439e6(30)
			end
			if vm.skip_end() then
				return skip(57)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.CharaActive(0)
		event.CharaActive(32)
		event.CharaActive(33)
		event.SetStatus(1, 0, 256, 0)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.DelExtMotion(0)
		event.DeleteChara(32)
		event.DeleteChara(33)
		event.DeleteChara(34)
		event.DeleteChara(35)
		event.DeleteChara(36)
		event.LoadMes(0, -1)
	end
	event.SetFlag(600, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.StopBgm(0)
	helper_c5d439e6(4)
	if vm.skipping() then
		return skip(1)
	end
	event.LoadBgm(22)
	event.PlayBgm(0)
	event.LoadSound(4523)
	var0 = event.SndLoadSound(4523) or var0
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.SetStatus(1, 0, 256, 1)
	event.ChangeDir("event/e600/e600/")
	event.LoadMes(0, 5, "e600.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e600_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e600_monica.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.LoadChara(5, "e600_chap.gltf", "info", 34)
	event.CharaActive(34)
	event.EohSyncChara(2, 34)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.LoadChara(5, "e600_osmond.gltf", "info", 35)
	event.CharaActive(0, 35)
	event.EohSyncChara(3, 35)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.LoadChara(5, "e600_mago.gltf", "info", 36)
	event.CharaActive(36)
	event.EohSyncChara(4, 36)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
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
	event.CharaActive(32)
	event.CharaActive(33)
	event.EohSetPos(0, 565.74, 48.42, 0.79)
	event.EohSetRot(0, 0.0, 3.14, 0.0)
	event.EohSetFootSoundId(0, 23)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "デフォルト顔")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	event.EohSetPos(1, 602.14, 63.97, -7.69)
	event.EohSetRot(1, 0.0, 3.14, 0.0)
	event.EohSetFootSoundId(1, 23)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "デフォルト顔")
	event.EohSetTexAnim(1, 1, "通常目パチ")
	event.EohSetPos(2, -123.16, 14.67, -196.21)
	event.EohSetRot(2, 0.0, 3.14, 0.0)
	event.EohSetPos(3, -213.02, 14.67, -149.68)
	event.EohSetRot(3, 0.0, 2.42, 0.0)
	event.EohSetFootSoundId(3, 23)
	event.EohSetPos(4, -152.32, 14.67, -196.21)
	event.EohSetRot(4, 0.0, 3.14, 0.0)
	event.EohSetTexAnim(4, 0)
	event.EohSetTexAnim(4, 1, "目パチ")
	event.InitDramaScene()
	event.ObjsInitPas(0)
	event.ObjsSetPasFrm(0, 120)
	event.ObjsAddPas(0, 565.74, 48.42, 0.79)
	event.ObjsAddPas(0, 491.77, 16.99, -29.55)
	event.ObjsAddPas(0, 357.26, 14.67, -106.31)
	event.ObjsAddPas(0, 259.52, 14.67, -176.94)
	event.ObjsStartPas(0, 1)
	event.ObjsSetMotion(0, "走り", 4)
	event.ObjsInitPas(1)
	event.ObjsSetPasFrm(1, 120)
	event.ObjsAddPas(1, 602.14, 63.97, -7.69)
	event.ObjsAddPas(1, 529.27, 32.92, -47.0)
	event.ObjsAddPas(1, 441.98, -0.0, -93.18)
	event.ObjsAddPas(1, 364.0, 7.04, -149.53)
	event.ObjsStartPas(1, 1)
	event.ObjsSetMotion(1, "走り", 4)
	event.CmrsInit()
	event.CmrsSetPos(-704.32, 463.53, -741.46)
	event.CmrsSetRef(-2.99, 112.23, -234.69)
	event.CmrsMove2(-477.41, 352.38, -577.5, -2.99, 112.23, -234.69, 80, 2, 1.0)
	event.SetFadeIn(30)
	helper_8f303b3a()
	if vm.skipping() then
		return skip(2)
	end
	helper_8001137a(0)
	if vm.skipping() then
		return skip(3)
	end
	helper_8001137a(1)
	if vm.skipping() then
		return skip(4)
	end
	event.CmrsSetPos(-222.06, 39.24, -408.93)
	event.CmrsSetRef(-115.83, 66.67, -257.29)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "うれし顔")
	event.EohSetTexAnim(0, 1, "うれし目パチ")
	event.ObjsSetPos(0, -146.58, 14.67, -299.69)
	event.ObjsSetRot(0, 0.0, 0.77, 0.0)
	event.ObjsSetPos(1, -133.27, 14.67, -317.47)
	event.ObjsSetRot(1, 0.0, 0.43, 0.0)
	event.ObjsMove(0, -123.49, 14.67, -266.73, 12)
	event.ObjsMove(1, -97.54, 14.67, -266.46, 12)
	event.ObjsSetMotion(0, "走り", 6, -1.0, 1)
	event.ObjsNextMotion(0, "立ち", 0)
	event.ObjsSetMotion(1, "走り", 6, -1.0, 1)
	event.ObjsNextMotion(1, "立ち", 0)
	helper_8001137a(0)
	if vm.skipping() then
		return skip(5)
	end
	helper_8001137a(1)
	if vm.skipping() then
		return skip(6)
	end
	helper_c5d439e6(9)
	if vm.skipping() then
		return skip(7)
	end
	event.ObjsSetMotion(0, "上向く", 6)
	event.ObjsNextMotion(0, "上向くL", 4)
	event.ObjsSetMotion(1, "上向く", 6)
	event.ObjsNextMotion(1, "上向くL", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_5f60(6000010)
	if vm.skipping() then
		return skip(8)
	end
	helper_8001137a(0)
	if vm.skipping() then
		return skip(9)
	end
	event.ObjsSetMotion(0, "上向く会話", 6)
	event.ObjsNextMotion(0, "上向くL", 4)
	event.SetPakuAnim(0, "わらい口パク")
	helper_5f60(6000020)
	if vm.skipping() then
		return skip(10)
	end
	helper_8001137a(0)
	if vm.skipping() then
		return skip(11)
	end
	event.ObjsSetMotion(4, "会話１", 6)
	event.ObjsNextMotion(4, "立ち", 4)
	helper_5f60(6000030)
	if vm.skipping() then
		return skip(12)
	end
	helper_8001137a(4)
	if vm.skipping() then
		return skip(13)
	end
	event.ObjsSetMotion(2, "会話２", 6)
	event.ObjsNextMotion(2, "立ち", 4)
	event.SetPakuAnim(2, "わらい口パク")
	helper_5f60(6000040)
	if vm.skipping() then
		return skip(14)
	end
	helper_8001137a(2)
	if vm.skipping() then
		return skip(15)
	end
	event.ObjsSetMotion(0, "喜び", 6)
	event.ObjsNextMotion(0, "上向くL", 4)
	event.ObjsSeDelay(0, 10)
	event.ObjsSePlay(0, var0, 2)
	event.ObjsSeDelay(0, 20)
	event.ObjsSePlay(0, var0, 2)
	event.SetPakuAnim(0, "わらい口パク")
	helper_5f60(6000050)
	if vm.skipping() then
		return skip(16)
	end
	helper_8001137a(0)
	if vm.skipping() then
		return skip(17)
	end
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "デフォルト顔")
	event.EohSetTexAnim(1, 1, "通常目～あきれ目")
	event.ObjsTexaDelay(1, 30)
	event.ObjsTexAnime(1, 1, "あきれ目パチ")
	event.SetPakuAnim(1, "通常口パク")
	helper_5f60(6000060)
	if vm.skipping() then
		return skip(18)
	end
	helper_8001137a(1)
	if vm.skipping() then
		return skip(19)
	end
	event.SetPakuAnim(2, "通常口パク")
	helper_5f60(6000070)
	if vm.skipping() then
		return skip(20)
	end
	event.CmrsMove2(-222.06, 39.24, -408.93, -145.74, 55.24, -240.17, 30, 0, 1.0)
	event.ObjsSetMotion(0, "上向く戻り", 6)
	event.ObjsNextMotion(0, "立ち", 4)
	event.ObjsRotation(0, 0.0, -0.19, 0.0, 20)
	event.ObjsSetMotion(1, "上向く戻り", 6)
	event.ObjsNextMotion(1, "立ち", 4)
	event.ObjsRotation(1, 0.0, -0.53, 0.0, 20)
	event.ObjsSetMotion(4, "振り向く", 2)
	event.ObjsNextMotion(4, "振り向くループ", 4)
	event.CharaActive(35)
	event.ObjsMove(3, -183.46, 14.67, -213.48, 60)
	event.ObjsSetMotion(3, "歩き", 4)
	event.ObjsMotionDelay(3, 60)
	event.ObjsSetMotion(3, "立ち")
	helper_5f60(6000080)
	if vm.skipping() then
		return skip(21)
	end
	helper_8001137a(3)
	if vm.skipping() then
		return skip(22)
	end
	event.ObjsSetMotion(2, "会話２", 2)
	event.ObjsNextMotion(2, "立ち", 4)
	event.ObjsMotionDelay(4, 10)
	event.ObjsSetMotion(4, "振り向く戻り", 2)
	event.ObjsNextMotion(4, "立ち", 4)
	event.SetPakuAnim(2, "通常口パク")
	helper_5f60(6000090)
	if vm.skipping() then
		return skip(23)
	end
	helper_8001137a(2)
	if vm.skipping() then
		return skip(24)
	end
	event.ObjsSetMotion(3, "会話2", 2)
	event.ObjsNextMotion(3, "立ち", 4)
	helper_5f60(6000100)
	if vm.skipping() then
		return skip(25)
	end
	helper_5f60(6000105)
	if vm.skipping() then
		return skip(26)
	end
	helper_8001137a(3)
	if vm.skipping() then
		return skip(27)
	end
	event.ObjsSetMotion(4, "見合わせる", 2)
	event.ObjsNextMotion(4, "見合わせるループ", 4)
	event.ObjsSetMotion(2, "顔見合わせる", 2)
	event.ObjsNextMotion(2, "顔見合わせるＬ", 4)
	helper_6010(6000110, -1)
	if vm.skipping() then
		return skip(28)
	end
	helper_8001137a(4)
	if vm.skipping() then
		return skip(29)
	end
	helper_6010(6000120, -1)
	if vm.skipping() then
		return skip(30)
	end
	helper_8001137a(2)
	if vm.skipping() then
		return skip(31)
	end
	event.ObjsSetMotion(4, "見合わせ戻り", 2)
	event.ObjsNextMotion(4, "立ち", 4)
	event.ObjsSetMotion(2, "顔見合わせる戻り", 2)
	event.ObjsNextMotion(2, "立ち", 4)
	helper_8001137a(4)
	if vm.skipping() then
		return skip(32)
	end
	helper_8001137a(2)
	if vm.skipping() then
		return skip(33)
	end
	event.ObjsSetMotion(0, "会話", 2)
	event.ObjsNextMotion(0, "立ち", 4)
	event.SetPakuAnim(0, "わらい口パク")
	helper_5f60(6000130)
	if vm.skipping() then
		return skip(34)
	end
	helper_8001137a(0)
	if vm.skipping() then
		return skip(35)
	end
	event.ObjsSetMotion(3, "だろ！", 2)
	event.ObjsNextMotion(3, "だろ！（会話）", 6)
	event.ObjsNextMotion(3, "だろ！ループ", 4)
	event.ObjsSeDelay(3, 10)
	event.ObjsSePlay(3, var0, 3)
	helper_5f60(6000140)
	if vm.skipping() then
		return skip(36)
	end
	helper_8001137a(3)
	if vm.skipping() then
		return skip(37)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_5f60(6000150)
	if vm.skipping() then
		return skip(38)
	end
	event.ObjsSetMotion(1, "会話", 2)
	event.ObjsNextMotion(1, "立ち", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_5f60(6000155)
	if vm.skipping() then
		return skip(39)
	end
	helper_8001137a(1)
	if vm.skipping() then
		return skip(40)
	end
	event.SetPakuAnim(2, "わらい口パク")
	helper_5f60(6000160)
	if vm.skipping() then
		return skip(41)
	end
	event.SetPakuAnim(0, "わらい口パク")
	helper_5f60(6000170)
	if vm.skipping() then
		return skip(42)
	end
	event.CmrsSetPos(-104.38, 40.81, -363.85)
	event.CmrsSetRef(-127.67, 39.82, -217.46)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "デフォルト顔")
	event.EohSetTexAnim(1, 1, "通常目パチ")
	event.ObjsSetRot(4, 0.0, 2.9, 0.0)
	event.ObjsSetMotion(4, "会話２", 6)
	event.ObjsNextMotion(4, "立ち", 4)
	event.ObjsSetMotion(3, "立ち", 4)
	helper_5f60(6000180)
	if vm.skipping() then
		return skip(43)
	end
	helper_5f60(6000185)
	if vm.skipping() then
		return skip(44)
	end
	helper_8001137a(4)
	if vm.skipping() then
		return skip(45)
	end
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "うれし顔")
	event.EohSetTexAnim(0, 1, "うれし目～通常目")
	event.ObjsSetMotion(0, "左上見る", 6)
	event.ObjsNextMotion(0, "左上見るL", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_5f60(6000190)
	if vm.skipping() then
		return skip(46)
	end
	helper_8001137a(0)
	if vm.skipping() then
		return skip(47)
	end
	event.SetPakuAnim(2, "通常口パク")
	helper_5f60(6000200)
	if vm.skipping() then
		return skip(48)
	end
	event.ObjsSetMotion(0, "左上見る戻り", 6)
	event.ObjsNextMotion(0, "立ち", 4)
	event.ObjsSetMotion(3, "まかせろ", 2)
	event.ObjsNextMotion(3, "まかせろループ", 4)
	event.ObjsSeDelay(3, 10)
	event.ObjsSePlay(3, var0, 4)
	helper_5f60(6000210)
	if vm.skipping() then
		return skip(49)
	end
	helper_8001137a(0)
	if vm.skipping() then
		return skip(50)
	end
	helper_8001137a(3)
	if vm.skipping() then
		return skip(51)
	end
	event.ObjsSetMotion(2, "会話２", 2)
	event.ObjsNextMotion(2, "立ち", 4)
	event.SetPakuAnim(2, "通常口パク")
	helper_5f60(6000220)
	if vm.skipping() then
		return skip(52)
	end
	helper_8001137a(2)
	if vm.skipping() then
		return skip(53)
	end
	event.SetPakuAnim(1, "わらい口パク")
	helper_5f60(6000230)
	if vm.skipping() then
		return skip(54)
	end
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "うれし顔")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	event.SetPakuAnim(0, "わらい口パク")
	helper_5f60(6000240)
	if vm.skipping() then
		return skip(55)
	end
	event.SetFadeOut(30)
	helper_c5d439e6(30)
	if vm.skipping() then
		return skip(56)
	end
	return part2()
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 150.
script[150] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_b8ac()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 500.
script[500] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_b8ac()
	if vm.skipping() then
		return skip(1)
	end
	event.BgmLoadCancel()
	event.MapJump(-1, "s37", 500)
	if vm.wait() then
		return skip(2)
	end
end

return script
