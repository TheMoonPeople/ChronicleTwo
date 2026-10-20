--!strict
-- map/d/d06/e01/d06e01.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_06ab565c = require("@lib/event/helper_06ab565c")
local helper_1406a200 = require("@lib/event/helper_1406a200")
local helper_20fe46f0 = require("@lib/event/helper_20fe46f0")
local helper_5c96a7ac = require("@lib/event/helper_5c96a7ac")
local helper_746bd51d = require("@lib/event/helper_746bd51d")
local helper_872c66b5 = require("@lib/event/helper_872c66b5")
local helper_92234a24 = require("@lib/event/helper_92234a24")
local helper_9329a84e = require("@lib/event/helper_9329a84e")
local helper_a694495f = require("@lib/event/helper_a694495f")
local helper_c3a08f7f = require("@lib/event/helper_c3a08f7f")
local helper_daca499b = require("@lib/event/helper_daca499b")
local helper_f2bfb50b = require("@lib/event/helper_f2bfb50b")

--- Program 99.
local function program_99() end

--- Helper function.
local function helper_193c(arg0: f32, arg1: f32, arg2: f32, arg3: f32)
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
local function helper_568c(arg0: s32, arg1: s32)
	local stream_open_state: s32 = 0
	local stream_open_state_2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			helper_872c66b5(0, -1, 8, 0, 0)
			helper_5c96a7ac(0, arg1)
		end
		helper_06ab565c(0)
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
	helper_872c66b5(0, -1, 8, 0, 0)
	event.StreamPlay(1)
	helper_5c96a7ac(0, arg1)
	if vm.skipping() then
		return skip(4)
	end
	helper_06ab565c(0)
	event.StreamClose(1)
	event.SetMesPos(0, 0)
end

--- Helper function.
local function helper_2eb8(arg0: s32, arg1: s32)
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
local function helper_3ce0(arg0: s32)
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
			t1, var2 = helper_2eb8(arg0, var2)
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
		t0, var2 = helper_2eb8(arg0, var2)
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
local function helper_5d50(arg0: s32)
	local stream_open_state: s32 = 0
	local stream_open_state_2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			helper_872c66b5(0, -1, 8, 0, 0)
			helper_3ce0(0)
		end
		helper_06ab565c(0)
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
	helper_872c66b5(0, -1, 8, 0, 0)
	event.StreamPlay(1)
	helper_3ce0(0)
	if vm.skipping() then
		return skip(4)
	end
	helper_06ab565c(0)
	event.StreamClose(1)
end

--- Helper function.
local function helper_6040(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_5d50(arg0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, arg0)
	helper_5d50(arg0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_29220()
	local active_chr_no: s32 = 0
	local var1: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 38 then
			if at <= 1 then
				helper_f2bfb50b(0)
			end
			if at <= 2 then
				helper_568c(7020010, 100)
			end
			if at <= 3 then
				helper_568c(7020020, 30)
			end
			if at <= 4 then
				helper_f2bfb50b(0)
			end
			if at <= 5 then
				helper_daca499b()
			end
			if at <= 6 then
				helper_daca499b()
			end
			if at <= 7 then
				helper_a694495f(42)
			end
			if at <= 8 then
				helper_6040(7020030)
			end
			if at <= 9 then
				helper_6040(7020040)
			end
			if at <= 10 then
				helper_a694495f(20)
			end
			if at <= 11 then
				helper_f2bfb50b(0)
			end
			if at <= 12 then
				helper_a694495f(20)
			end
			if at <= 13 then
				helper_a694495f(40)
			end
			if at <= 14 then
				helper_a694495f(44)
			end
			if at <= 15 then
				helper_6040(7020050)
			end
			if at <= 16 then
				helper_f2bfb50b(1)
			end
			if at <= 17 then
				helper_6040(7020060)
			end
			if at <= 18 then
				helper_6040(7020070)
			end
			if at <= 19 then
				helper_6040(7020080)
			end
			if at <= 20 then
				helper_6040(7020085)
			end
			if at <= 21 then
				helper_f2bfb50b(0)
			end
			if at <= 22 then
				helper_6040(7020090)
			end
			if at <= 23 then
				helper_f2bfb50b(0)
			end
			if at <= 24 then
				helper_f2bfb50b(1)
			end
			if at <= 25 then
				helper_6040(7020093)
			end
			if at <= 26 then
				helper_6040(7020097)
			end
			if at <= 27 then
				helper_daca499b()
			end
			if at <= 28 then
				helper_6040(7020100)
			end
			if at <= 29 then
				helper_daca499b()
			end
			if at <= 30 then
				helper_6040(7020110)
			end
			if at <= 31 then
				helper_6040(7020120)
			end
			if at <= 32 then
				helper_6040(7020130)
			end
			if at <= 33 then
				helper_f2bfb50b(0)
			end
			if at <= 34 then
				helper_f2bfb50b(1)
			end
			if at <= 35 then
				helper_6040(7020135)
			end
			if at <= 36 then
				helper_6040(7020140)
			end
			if at <= 37 then
				helper_a694495f(30)
			end
			if vm.skip_end() then
				return skip(39)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SetStatus(1, 0, 256, 0)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.DelExtMotion(0)
		event.DeleteChara(32)
		event.DeleteChara(33)
		event.LoadMes(0, -1)
	end
	event.Initialize()
	event.SetFlag(702, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.StopBgm(0)
	helper_a694495f(4)
	if vm.skipping() then
		return skip(1)
	end
	event.LoadBgm(21)
	event.PlayBgm(0)
	event.LoadSound(7816)
	var1 = event.SndLoadSound(7816) or var1
	event.SetStatus(1, 0, 256, 1)
	event.ChangeDir("event/e700/e702/")
	event.LoadMes(0, 5, "e702.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e702_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e702_monica.gltf", "info", 0)
		event.CharaActive(0)
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
		event.LoadMotion(5, "event/e700/e702/e702_mints.gltf", "info", 32)
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
		event.LoadMotion(5, "event/e700/e702/e702_monica.gltf", "info", 32)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 32)
		event.EohSyncChara(1, 32)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 0)
	end
	event.CharaActive(32)
	event.CharaActive(33)
	event.EohSetPos(0, 10.0, 0.0, 600.0)
	event.EohSetRot(0, 0.0, 3.14, 0.0)
	event.EohSetFootSoundId(0, 21)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "無表情")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	event.EohSetPos(1, -10.0, 0.0, 600.0)
	event.EohSetRot(1, 0.0, 3.14, 0.0)
	event.EohSetFootSoundId(1, 21)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "無表情")
	event.EohSetTexAnim(1, 1, "通常目パチ")
	event.InitDramaScene()
	event.ObjsMove(0, 8, 0.0, 500, 90)
	event.ObjsSetMotion(0, "歩き", 4)
	event.ObjsMove(1, -8, 0.0, 500, 90)
	event.ObjsSetMotion(1, "歩き", 4)
	event.CmrsInit()
	event.CmrsSetPos(0.0, 44.63, 650.83)
	event.CmrsSetRef(0.0, 17.43, 579.14)
	event.CmrsMove2(0.0, 44.63, 650.83, 0.0, 48.22, 579.14, 60, 2, 0.2)
	event.SetFadeIn(30)
	helper_f2bfb50b(0)
	if vm.skipping() then
		return skip(2)
	end
	event.CmrsSetPos(25.64, 9.7, 457.81)
	event.CmrsSetRef(-0.0, 19.0, 494.74)
	event.CmrsMove(25.64, 9.7, 357.81, 0.0, 19.0, 394.74, 160)
	event.ObjsMove(0, 8, 0.0, 400, 160)
	event.ObjsSetMotion(0, "キョロキョロ歩き", 4)
	event.ObjsMove(1, -8, 0.0, 400, 160)
	event.ObjsSetMotion(1, "歩き", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_568c(7020010, 100)
	if vm.skipping() then
		return skip(3)
	end
	event.SetPakuAnim(0, "通常口パク")
	helper_568c(7020020, 30)
	if vm.skipping() then
		return skip(4)
	end
	helper_f2bfb50b(0)
	if vm.skipping() then
		return skip(5)
	end
	event.CmrsSetPos(0.0, 40.03, 416.7)
	event.CmrsSetRef(-18.0, 40.45, 363.59)
	event.CmrsMove2(0.0, 40.03, 416.7, -40.11, 40.45, 389.73, 60, 2, 0.4)
	helper_daca499b()
	if vm.skipping() then
		return skip(6)
	end
	event.CmrsSetPos(0.0, 40.03, 416.7)
	event.CmrsSetRef(18.0, 40.45, 363.59)
	event.CmrsMove2(0.0, 40.03, 416.7, 40.11, 40.45, 389.73, 60, 2, 0.4)
	helper_daca499b()
	if vm.skipping() then
		return skip(7)
	end
	event.CmrsSetPos(0.0, 18.82, 317.17)
	event.CmrsSetRef(0.0, 21.57, 360.74)
	event.ObjsMove(0, 8, 0.0, 360, 40)
	event.ObjsMotionDelay(0, 40)
	event.ObjsSetMotion(0, "気がつく", 2)
	event.ObjsNextMotion(0, "そうか！！", 6)
	event.ObjsNextMotion(0, "そうか！！L", 4)
	event.ObjsTexaDelay(0, 40)
	event.ObjsTexAnime(0, 1, "通常目～おどろき目")
	event.ObjsTexaDelay(0, 30)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おどろき顔")
	event.ObjsTexAnime(0, 1, "まばたき目パチ")
	event.ObjsSeDelay(0, 82)
	event.ObjsSePlay(0, var1, 0)
	event.ObjsMove(1, -8, 0.0, 350, 56)
	event.ObjsRotDelay(1, 46)
	event.ObjsRotation(1, 0.0, 2.42, 0.0, 10)
	event.ObjsMotionDelay(1, 56)
	event.ObjsSetMotion(1, "立ち")
	event.ObjsTexaDelay(1, 50)
	event.ObjsTexAnime(1, 0, "通常目パチ")
	event.ObjsTexAnime(1, 1, "前向き～右向き")
	helper_a694495f(42)
	if vm.skipping() then
		return skip(8)
	end
	event.SetPakuAnim(0, "通常口パク")
	helper_6040(7020030)
	if vm.skipping() then
		return skip(9)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_6040(7020040)
	if vm.skipping() then
		return skip(10)
	end
	event.CmrsSetPos(-40.7, 35.07, 417.89)
	event.CmrsSetRef(-4.43, 24.95, 377.6)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "無表情")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	event.ObjsSetMotion(0, "立ち", 4, -1, 1)
	event.ObjsSetMotion(0, "走り")
	event.ObjsRotation(0, 0.0, 2.14, 0.0, 6)
	event.ObjsPosDelay(0, 4)
	event.ObjsMove(0, 210.81, 0.0, 225.65, 60)
	helper_a694495f(20)
	if vm.skipping() then
		return skip(11)
	end
	event.EohSetFootSoundId(0, 2)
	helper_f2bfb50b(0)
	if vm.skipping() then
		return skip(12)
	end
	event.ObjsSetPos(0, 718.74, 0.0, -118.54)
	event.ObjsSetRot(0, 0.0, 1.85, 0.0)
	event.ObjsSetMotion(0, "立ち", 4, -1, 1)
	event.CmrsSetPos(24.13, 18.72, 352.73)
	event.CmrsSetRef(-5.12, 23.16, 345.48)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "無表情")
	event.EohSetTexAnim(1, 1, "通常目パチ")
	event.EohSetTexAnim(1, 1, "半口")
	event.ObjsSetRot(1, 0.0, 2.06, 0.0)
	helper_a694495f(20)
	if vm.skipping() then
		return skip(13)
	end
	event.ObjsMove(1, 52.38, 0.0, 313.0, 40)
	event.ObjsSetMotion(1, "走り")
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "無表情")
	event.EohSetTexAnim(1, 1, "通常目～おこり目")
	event.EohSetTexAnim(1, 1, "口とじ")
	helper_a694495f(40)
	if vm.skipping() then
		return skip(14)
	end
	event.CmrsSetPos(757.91, 16.92, -132.45)
	event.CmrsSetRef(694.19, 20.24, -121.26)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "おこり顔")
	event.EohSetTexAnim(1, 1, "おこり目パチ")
	event.EohSetFootSoundId(1, 2)
	event.ObjsSetRot(1, 0.0, 1.73, 0.0)
	event.ObjsSetPos(1, 597.66, 0.0, -109.91)
	event.ObjsMove(1, 714.6, 0.0, -132.69, 40)
	event.ObjsMotionDelay(1, 40)
	event.ObjsSetMotion(1, "立ち")
	helper_a694495f(44)
	if vm.skipping() then
		return skip(15)
	end
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "無表情")
	event.EohSetTexAnim(0, 1, "前向き～左向き")
	event.ObjsSetMotion(1, "右向く", 6)
	event.ObjsNextMotion(1, "右向くL", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_6040(7020050)
	if vm.skipping() then
		return skip(16)
	end
	helper_f2bfb50b(1)
	if vm.skipping() then
		return skip(17)
	end
	event.CmrsSetPos(640.61, 12.5, -112.65)
	event.CmrsSetRef(758.05, 45.97, -133.12)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "デフォルト顔")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	event.SetPakuAnim(0, "通常口パク")
	helper_6040(7020060)
	if vm.skipping() then
		return skip(18)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_6040(7020070)
	if vm.skipping() then
		return skip(19)
	end
	event.SetPakuAnim(0, "通常口パク")
	helper_6040(7020080)
	if vm.skipping() then
		return skip(20)
	end
	event.CmrsSetPos(757.91, 16.92, -132.45)
	event.CmrsSetRef(694.19, 20.24, -121.26)
	event.ObjsSetRot(1, 0.0, 0.17, 0.0)
	event.ObjsSetMotion(1, "立ち", 4, -1.0, 1)
	event.ObjsResetDaPosition(1)
	event.ObjsSetMotion(0, "ホールを示す", 6)
	event.ObjsNextMotion(0, "ホールを示すL", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_6040(7020085)
	if vm.skipping() then
		return skip(21)
	end
	helper_f2bfb50b(0)
	if vm.skipping() then
		return skip(22)
	end
	event.ObjsSetMotion(0, "絵を指す", 6)
	event.ObjsNextMotion(0, "絵を指すL", 4)
	event.ObjsMotionDelay(1, 24)
	event.ObjsSetMotion(1, "左向く", 6)
	event.ObjsNextMotion(1, "左向くL", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_6040(7020090)
	if vm.skipping() then
		return skip(23)
	end
	helper_f2bfb50b(0)
	if vm.skipping() then
		return skip(24)
	end
	helper_f2bfb50b(1)
	if vm.skipping() then
		return skip(25)
	end
	event.CmrsSetPos(659.67, 80.0, -113.9)
	event.CmrsSetRef(778.51, 80.0, -136.24)
	event.CmrsMove2(659.67, 60.0, -113.9, 778.51, 60.0, -136.24, 200, 2, 0.2)
	event.ObjsSetMotion(1, "上向くL", 4, -1.0, 1)
	event.ObjsSetRot(1, 0.0, 1.73, 0.0)
	event.ObjsSetMotion(0, "上向くL", 4, -1.0, 1)
	event.SetPakuAnim(0, "通常口パク")
	helper_6040(7020093)
	if vm.skipping() then
		return skip(26)
	end
	event.SetPakuAnim(0, "通常口パク")
	helper_6040(7020097)
	if vm.skipping() then
		return skip(27)
	end
	helper_daca499b()
	if vm.skipping() then
		return skip(28)
	end
	event.CmrsSetPos(738.56, 22.45, -93.25)
	event.CmrsSetRef(721.11, 22.0, -138.58)
	event.CmrsMove2(731.87, 22.45, -90.67, 714.42, 22.0, -136.01, 160, 2, 0.2)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "無表情")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "無表情")
	event.EohSetTexAnim(1, 1, "通常目パチ")
	event.SetPakuAnim(0, "通常口パク")
	helper_6040(7020100)
	if vm.skipping() then
		return skip(29)
	end
	helper_daca499b()
	if vm.skipping() then
		return skip(30)
	end
	event.CmrsSetPos(640.61, 12.5, -112.65)
	event.CmrsSetRef(758.05, 45.97, -133.12)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "デフォルト顔")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "デフォルト顔")
	event.EohSetTexAnim(1, 1, "通常目パチ")
	event.SetPakuAnim(0, "通常口パク")
	helper_6040(7020110)
	if vm.skipping() then
		return skip(31)
	end
	event.SetPakuAnim(1, "わらい口パク")
	helper_6040(7020120)
	if vm.skipping() then
		return skip(32)
	end
	event.ObjsSetMotion(1, "上から右", 6)
	event.ObjsNextMotion(1, "右向くL", 4)
	event.ObjsMotionDelay(0, 20)
	event.ObjsSetMotion(0, "上→左", 6)
	event.ObjsNextMotion(0, "左向くL", 4)
	event.SetPakuAnim(1, "わらい口パク")
	helper_6040(7020130)
	if vm.skipping() then
		return skip(33)
	end
	helper_f2bfb50b(0)
	if vm.skipping() then
		return skip(34)
	end
	helper_f2bfb50b(1)
	if vm.skipping() then
		return skip(35)
	end
	event.SndSePlay(var1, 1)
	event.ObjsSetMotion(1, "面白くなって", 6)
	event.ObjsNextMotion(1, "面白くなってL", 4)
	event.ObjsMotionDelay(1, 42)
	event.ObjsNextMotion(1, "面白く_待機", 4)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "デフォルト顔")
	event.EohSetTexAnim(1, 1, "通常目～おこり目")
	event.SetPakuAnim(1, "わらい口パク")
	helper_6040(7020135)
	if vm.skipping() then
		return skip(36)
	end
	event.ObjsSetMotion(0, "左向くうなづき", 6)
	event.ObjsNextMotion(0, "左向くL", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_6040(7020140)
	if vm.skipping() then
		return skip(37)
	end
	event.SetFadeOut(30)
	helper_a694495f(30)
	if vm.skipping() then
		return skip(38)
	end
	return part2()
end

--- Helper function.
local function helper_7ac0(arg0: any, arg1: s32, arg2: s32)
	local var3: s32 = 0
	local var4: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var4 = 0
			var3 = helper_746bd51d(arg0, arg1)
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
		var3 = helper_746bd51d(arg0, arg1)
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
local function helper_8588(arg0: s32, arg1: s32, arg2: s32, arg3: s32, arg4: s32)
	local var6: s32 = 0
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			local _ = helper_872c66b5(arg0, arg1, arg2, arg3, arg4)
			_, var6 = helper_7ac0(arg0, 0, var6)
		end
		helper_06ab565c(arg0)
	end
	if vm.skipping() then
		return skip(1)
	end
	local _ = helper_872c66b5(arg0, arg1, arg2, arg3, arg4)
	_, var6 = helper_7ac0(arg0, 0, var6)
	if vm.skipping() then
		return skip(2)
	end
	helper_06ab565c(arg0)
end

--- Helper function.
local function helper_6ae0(arg0: s32)
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
local function helper_6820(arg0: s32)
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
local function helper_6c38(arg0: s32, arg1: any, arg2: any, arg3: s32)
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
				helper_6ae0(arg0)
			end
			if at <= 2 then
				var8 = 0
				var7 = helper_6820(arg0)
				var8 = -1
				var8 = 1
				var6 = var7
				var8 = -1
				var8 = 1
				var8 = -1
				var8 = 1
			end
			helper_06ab565c(arg0)
			return -1
		end
		helper_06ab565c(arg0)
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
	helper_6ae0(arg0)
	if vm.skipping() then
		return skip(2)
	end
	while true do
		var8 = 0
		var7 = helper_6820(arg0)
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
					helper_06ab565c(arg0)
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
	helper_06ab565c(arg0)
	return arg2
end

--- Helper function.
local function helper_7950(arg0: s32, arg1: any, arg2: s32, arg3: s32, arg4: s32, arg5: s32, arg6: s32)
	local var8: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		return var8
	end
	local _ = helper_872c66b5(arg0, arg1, arg2, arg3, arg4)
	var8 = helper_6c38(arg0, arg5, arg6, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPos(arg0, 0)
	return var8
end

--- Helper function.
local function helper_baf0(arg0: s32, arg1: s32)
	local var2: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		return var2
	end
	event.SetMesQuestionGyou(1, 0)
	event.SetMesWindowMode(1, 5)
	event.SetMesDrawspeed(1, 1)
	event.SetMesItemDirect(1, 1, vm.i32(arg1 + 20000))
	var2 = helper_7950(1, vm.i32(arg0 + 70), 8, 256, 208, 2, 1)
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesDrawspeed(1, 0)
	return var2
end

--- Helper function.
local function helper_2d518()
	local var0: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_a694495f(30)
		end
		return 1
	end
	event.Initialize()
	event.SetMotion(0, "立ち")
	var0 = helper_baf0(4, -1)
	if vm.skipping() then
		return skip(1)
	end
	if var0 == 0 then
		event.SetFadeOut(30)
		helper_a694495f(30)
		if vm.skipping() then
			return skip(2)
		end
		return 1
	end
	return 0
end

--- Helper function.
local function helper_2d6d4()
	local active_chr_no: s32 = 0
	local var1: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_8588(0, 20, 5, 256, 208)
			end
			if at <= 2 then
				helper_8588(0, 21, 5, 256, 208)
			end
			return 0
		end
		if at <= 4 then
			helper_a694495f(30)
		end
		return 1
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	event.ActchrSetDefMotion(0)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 2 or active_chr_no == 3 then
		event.SetMesWindowMode(0, 1)
		event.SetMesDrawspeed(0, 1)
		if active_chr_no == 2 then
			helper_8588(0, 20, 5, 256, 208)
			if vm.skipping() then
				return skip(2)
			end
		else
			helper_8588(0, 21, 5, 256, 208)
			if vm.skipping() then
				return skip(3)
			end
		end
		event.Finish()
		return 0
	end
	var1 = helper_baf0(4, -1)
	if vm.skipping() then
		return skip(4)
	end
	if var1 == 0 then
		event.SetFadeOut(30)
		helper_a694495f(30)
		if vm.skipping() then
			return skip(5)
		end
		return 1
	end
	return 0
end

--- Helper function.
local function helper_2dafc()
	local var0: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_a694495f(30)
		end
		return 1
	end
	event.Initialize()
	event.SetMotion(0, "立ち")
	var0 = helper_baf0(5, 97)
	if vm.skipping() then
		return skip(1)
	end
	if var0 == 0 then
		event.SetFadeOut(30)
		helper_a694495f(30)
		if vm.skipping() then
			return skip(2)
		end
		return 1
	end
	return 0
end

--- Helper function.
local function helper_1037c()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			helper_a694495f(10)
		end
	end
	event.Initialize()
	event.SetMotion(0, "立ち")
	event.SetFadeOut(10)
	helper_a694495f(10)
	if vm.skipping() then
		return skip(1)
	end
	event.GotoMenu(7)
	if vm.wait() then
		return skip(2)
	end
	event.SetFadeIn(10)
	helper_a694495f(10)
	if vm.skipping() then
		return skip(3)
	end
end

--- Helper function.
local function helper_2eddc(arg0: s32)
	local block: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_a694495f(4)
		end
		if at <= 2 then
			helper_92234a24(32)
		end
		if at <= 3 then
			helper_a694495f(4)
		end
	end
	event.SetMotion(0, "立ち")
	event.AssignStack(5)
	event.ClearStack(5)
	event.SpriteInit(0)
	event.SpriteSetType(0, 0)
	if arg0 == 0 then
		event.SetLoadbgFile("textures/event/etc/heki401.json")
	end
	if arg0 == 1 then
		event.SetLoadbgFile("textures/event/etc/heki402.json")
	end
	if arg0 == 2 then
		event.SetLoadbgFile("textures/event/etc/heki403.json")
	end
	if arg0 == 3 then
		event.SetLoadbgFile("textures/event/etc/heki404.json")
	end
	if arg0 == 4 then
		event.SetLoadbgFile("textures/event/etc/heki405.json")
	end
	if arg0 == 5 then
		event.SetLoadbgFile("textures/event/etc/heki406.json")
	end
	if arg0 == 6 then
		event.SetLoadbgFile("textures/event/etc/heki407.json")
	end
	if arg0 == 7 then
		event.SetLoadbgFile("textures/event/etc/heki408.json")
	end
	helper_1406a200()
	if vm.skipping() then
		return skip(1)
	end
	if arg0 == 0 then
		block = event.LoadImg_4(5, "textures/event/etc/heki401.json", 0) or block
		event.SpriteSetTexture(0, "heki401", block)
	end
	if arg0 == 1 then
		block = event.LoadImg_4(5, "textures/event/etc/heki402.json", 0) or block
		event.SpriteSetTexture(0, "heki402", block)
	end
	if arg0 == 2 then
		block = event.LoadImg_4(5, "textures/event/etc/heki403.json", 0) or block
		event.SpriteSetTexture(0, "heki403", block)
	end
	if arg0 == 3 then
		block = event.LoadImg_4(5, "textures/event/etc/heki404.json", 0) or block
		event.SpriteSetTexture(0, "heki404", block)
	end
	if arg0 == 4 then
		block = event.LoadImg_4(5, "textures/event/etc/heki405.json", 0) or block
		event.SpriteSetTexture(0, "heki405", block)
	end
	if arg0 == 5 then
		block = event.LoadImg_4(5, "textures/event/etc/heki406.json", 0) or block
		event.SpriteSetTexture(0, "heki406", block)
	end
	if arg0 == 6 then
		block = event.LoadImg_4(5, "textures/event/etc/heki407.json", 0) or block
		event.SpriteSetTexture(0, "heki407", block)
	end
	if arg0 == 7 then
		block = event.LoadImg_4(5, "textures/event/etc/heki408.json", 0) or block
		event.SpriteSetTexture(0, "heki408", block)
	end
	event.SpriteSetColor(0, 128, 128, 128, 0)
	event.SpriteSetUvsize(0, 0, 0, 512, 416)
	event.SpriteSetPutsize(0, 512, 416)
	event.SpriteSetPos(0, 256, 208)
	event.SpriteSetDraw(0, 0)
	event.EohSyncSprite(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.SpriteSetDraw(0, 1)
	event.ObjsSetColor(0, 128.0, 128.0, 128.0, 128.0, 4)
	helper_a694495f(4)
	if vm.skipping() then
		return skip(2)
	end
	helper_92234a24(32)
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsSetColor(0, 128.0, 128.0, 128.0, 0.0, 4)
	helper_a694495f(4)
	if vm.skipping() then
		return skip(4)
	end
	event.SpriteSetDraw(0, 0)
	event.SpriteSetDraw(0, 0)
	event.DelImg(0)
end

--- Helper function.
local function helper_104f0()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local block: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 43 then
			if at <= 1 then
				helper_f2bfb50b(1)
			end
			if at <= 2 then
				helper_a694495f(30)
			end
			if at <= 3 then
				helper_f2bfb50b(1)
			end
			if at <= 4 then
				helper_568c(6080010, -1)
			end
			if at <= 5 then
				helper_a694495f(30)
			end
			if at <= 6 then
				helper_daca499b()
			end
			if at <= 7 then
				helper_daca499b()
			end
			if at <= 8 then
				helper_a694495f(30)
			end
			if at <= 9 then
				helper_a694495f(60)
			end
			if at <= 10 then
				helper_a694495f(30)
			end
			if at <= 11 then
				helper_f2bfb50b(1)
			end
			if at <= 12 then
				helper_a694495f(30)
			end
			if at <= 13 then
				helper_568c(6080020, -1)
			end
			if at <= 14 then
				helper_a694495f(30)
			end
			if at <= 15 then
				helper_568c(6080025, -1)
			end
			if at <= 16 then
				helper_f2bfb50b(2)
			end
			if at <= 17 then
				helper_568c(6080030, -1)
			end
			if at <= 18 then
				helper_a694495f(15)
			end
			if at <= 19 then
				helper_568c(6080035, -1)
			end
			if at <= 20 then
				helper_a694495f(30)
			end
			if at <= 21 then
				helper_568c(6080040, -1)
			end
			if at <= 22 then
				helper_a694495f(15)
			end
			if at <= 23 then
				helper_568c(6080045, -1)
			end
			if at <= 24 then
				helper_568c(6080050, -1)
			end
			if at <= 25 then
				helper_a694495f(30)
			end
			if at <= 26 then
				helper_568c(6080060, -1)
			end
			if at <= 27 then
				helper_a694495f(15)
			end
			if at <= 28 then
				helper_568c(6080070, -1)
			end
			if at <= 29 then
				helper_a694495f(30)
			end
			if at <= 30 then
				helper_568c(6080075, -1)
			end
			if at <= 31 then
				helper_f2bfb50b(2)
			end
			if at <= 32 then
				helper_568c(6080080, -1)
			end
			if at <= 33 then
				helper_a694495f(15)
			end
			if at <= 34 then
				helper_a694495f(120)
			end
			if at <= 35 then
				helper_a694495f(30)
			end
			if at <= 36 then
				helper_568c(6080090, -1)
			end
			if at <= 37 then
				helper_a694495f(60)
			end
			if at <= 38 then
				helper_f2bfb50b(3)
			end
			if at <= 39 then
				helper_568c(6080100, -1)
			end
			if at <= 40 then
				helper_a694495f(20)
			end
			if at <= 41 then
				helper_568c(6080105, 240)
			end
			if at <= 42 then
				helper_a694495f(30)
			end
			if vm.skip_end() then
				return skip(44)
			end
			return part2()
		end
		if at <= 44 then
			helper_a694495f(4)
		end
		helper_193c(0.0, vm.f32(0.2), 400.0, vm.f32(3.14))
	end
	function part2()
		event.CancelDramaScene()
		event.StopBgm(0)
		helper_a694495f(4)
		if vm.skipping() then
			return skip(45)
		end
		event.LoadBgm(36)
		event.PlayBgm(0)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.DelExtMotion(0)
		event.DeleteChara(8)
		event.DeleteChara(10)
		event.DeleteChara(11)
		event.DeleteChara(12)
		event.DelImg(0)
		event.LoadMes(0, -1)
		event.SetCharaShow(1, 1)
		event.SetCharaShow(2, 1)
		helper_193c(0.0, vm.f32(0.2), 400.0, vm.f32(3.14))
		event.SetCameraRef(0.0, 30.2, 400.0)
		event.SetCameraPos(0.0, 40.2, 520.0)
		event.ResetCamera(0)
		event.SetStatusbarShow(1, 1.0)
		event.SetFadeIn(30)
	end
	event.SetFadeOut(0)
	event.SetFlag(608, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.SetStatusbarShow(0, 1.0)
	event.StopBgm(0)
	helper_a694495f(4)
	if vm.skipping() then
		return skip(1)
	end
	event.LoadBgm(51)
	event.PlayBgm(0)
	event.LoadSound(7806)
	var0 = event.SndLoadSound(7806) or var0
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.ChangeDir("event/e600/e608/")
	event.LoadMes(0, 5, "e608.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e608_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e608_monica.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	block = event.LoadImg_4(5, "e608telop01.json", 0) or block
	event.SpriteInit(0)
	event.SpriteSetType(0, 0)
	event.SpriteSetTexture(0, "e608telop01", block)
	event.SpriteSetColor(0, 128, 128, 128, 0)
	event.SpriteSetUvsize(0, 0, 0, 512, 128)
	event.SpriteSetPutsize(0, 512, 128)
	event.SpriteSetPos(0, 256, 312)
	event.SpriteSetDraw(0, 1)
	event.EohSyncSprite(4, 0)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.ChangeDir("")
	if active_chr_no == 1 then
		event.LoadChara(5, "chara/c01_base.gltf", "info", 8)
		event.LoadEquip(5, 0, 4, "info", 8)
		event.LoadEquip(5, 0, 3, "info", 8)
		event.LoadEquip(5, 0, 2, "info", 8, 10)
		event.LoadMotion(5, "event/e600/e608/e608_mints.gltf", "info", 8)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 8)
		event.EohSyncChara(0, 8)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 0)
	else
		event.LoadChara(5, "chara/c02_base.gltf", "info", 8)
		event.LoadEquip(5, 1, 4, "info", 8)
		event.LoadEquip(5, 1, 3, "info", 8)
		event.LoadEquip(5, 1, 2, "info", 8, 10)
		event.LoadMotion(5, "event/e600/e608/e608_monica.gltf", "info", 8)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 8)
		event.EohSyncChara(1, 8)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 0)
	end
	event.CharaActive(8)
	event.CharaActive(10)
	event.LoadChara(5, "event/e600/e608/e608_f_sun.gltf", "info", 11)
	event.CharaActive(11)
	event.EohSyncChara(2, 11)
	event.ObjsInit(2, 11)
	event.ObjsSyncObj(2, 2)
	event.LoadChara(5, "event/e600/e608/e608_sun.gltf", "info", 12)
	event.CharaActive(12)
	event.EohSyncChara(3, 12)
	event.ObjsInit(3, 12)
	event.ObjsSyncObj(3, 3)
	event.EohSetPos(0, 18.8, 0.2, 627.69)
	event.EohSetRot(0, 0.0, 3.07, 0.0)
	event.EohSetMotion(0, "立ち", 4)
	event.EohSetFootSoundId(0, 21)
	event.EohSetPos(1, -18.33, 0.2, 634.43)
	event.EohSetRot(1, 0.0, 3.11, 0.0)
	event.EohSetMotion(1, "立ち", 4)
	event.EohSetFootSoundId(1, 21)
	event.EohSetPos(2, -1.11, 280.0, -571.36)
	event.EohSetRot(2, 0.0, -0.01, 0.0)
	event.EohSetMotion(2, "立ち", 4)
	event.EohSetFootSoundId(2, 21)
	event.EohSetPos(3, 0.59, 43.94, -81.95)
	event.EohSetRot(3, 0.0, -0.01, 0.0)
	event.EohSetMotion(3, "両手広げるＬ", 4)
	event.EohSetFootSoundId(3, 21)
	event.InitDramaScene()
	event.SetCharaShow(1, 0)
	event.SetCharaShow(2, 0)
	event.CmrsInit()
	event.CmrsSetPos(-3.47, 496.82, -690.82)
	event.CmrsSetRef(-5.22, 214.08, 91.62)
	event.CharaActive(0)
	event.CharaActive(8)
	event.CharaActive(10)
	event.CharaActive(11)
	event.CharaActive(0, 12)
	event.SetFadeIn(30)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "デフォルト顔")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.ObjsSetMotion(0, "歩き")
	event.ObjsMove(0, 18.97, 0.2, 554.51, 90, 1)
	event.ObjsMotionDelay(0, 90)
	event.ObjsSetMotion(0, "立ち")
	event.ObjsSetMotion(1, "歩き")
	event.ObjsMove(1, -18.13, 0.2, 545.88, 90, 1)
	event.ObjsMotionDelay(1, 90)
	event.ObjsSetMotion(1, "立ち")
	helper_f2bfb50b(1)
	if vm.skipping() then
		return skip(2)
	end
	helper_a694495f(30)
	if vm.skipping() then
		return skip(3)
	end
	event.CmrsSetPos(-2.06, 19.94, 249.02)
	event.CmrsSetRef(-1.59, 24.2, 291.92)
	event.ObjsSetPos(1, -9.31, 0.2, 281.32)
	event.ObjsSetRot(1, 0.0, 2.99, 0.0)
	event.ObjsResetDaPosition(1)
	event.ObjsSetPos(0, 7.09, 0.2, 282.56)
	event.ObjsSetRot(0, 0.0, -2.97, 0.0)
	event.ObjsResetDaPosition(0)
	event.ObjsSetMotion(0, "上向く", 6)
	event.ObjsNextMotion(0, "上向くL", 4)
	event.ObjsMotionDelay(1, 5)
	event.ObjsSetMotion(1, "上向く", 6)
	event.ObjsNextMotion(1, "上向くL", 4)
	helper_f2bfb50b(1)
	if vm.skipping() then
		return skip(4)
	end
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "通常目～おどろき目")
	event.ObjsTexAnime(0, 1, "口とじ～大口")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "無表情")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.ObjsTexAnime(1, 1, "半口")
	helper_568c(6080010, -1)
	if vm.skipping() then
		return skip(5)
	end
	helper_a694495f(30)
	if vm.skipping() then
		return skip(6)
	end
	event.CmrsSetPos(-154.98, 28.42, 533.81)
	event.CmrsSetRef(-279.55, 40.6, 353.0)
	event.CmrsMove(225.39, 28.42, 472.47, 339.8, 36.75, 291.8, 360)
	helper_daca499b()
	if vm.skipping() then
		return skip(7)
	end
	event.CmrsMove(-3.33, 119.35, 266.15, -1.27, 158.81, 55.32, 90)
	helper_daca499b()
	if vm.skipping() then
		return skip(8)
	end
	helper_a694495f(30)
	if vm.skipping() then
		return skip(9)
	end
	event.SetCrossfade(30)
	event.CmrsSetPos(-1.36, 292.54, -536.23)
	event.CmrsSetRef(-2.12, 298.3, -575.85)
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "通常目")
	event.ObjsSetPos(1, -18.46, 0.2, 55.61)
	event.ObjsResetDaPosition(1)
	event.ObjsSetPos(0, 14.5, 0.2, 63.44)
	event.ObjsResetDaPosition(0)
	helper_a694495f(60)
	if vm.skipping() then
		return skip(10)
	end
	event.ObjsSetMotion(2, "歩き")
	event.ObjsMove(2, -1.25, 130.16, -257.23, 400, 1)
	event.ObjsMotionDelay(2, 400)
	event.ObjsSetMotion(2, "立ち")
	helper_a694495f(30)
	if vm.skipping() then
		return skip(11)
	end
	event.CmrsSetPos(-3.6, 35.33, 230.79)
	event.CmrsSetRef(-2.02, 46.97, 103.92)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "無表情")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "無表情")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.ObjsSetMotion(0, "上→左", 6)
	event.ObjsNextMotion(0, "左向くL", 4)
	event.ObjsMotionDelay(1, 10)
	event.ObjsSetMotion(1, "上から右", 6)
	event.ObjsNextMotion(1, "右向くL", 4)
	helper_f2bfb50b(1)
	if vm.skipping() then
		return skip(12)
	end
	helper_a694495f(30)
	if vm.skipping() then
		return skip(13)
	end
	helper_568c(6080020, -1)
	if vm.skipping() then
		return skip(14)
	end
	event.ObjsSetMotion(0, "左→上", 6)
	event.ObjsNextMotion(0, "上向くL", 4)
	event.ObjsMotionDelay(1, 10)
	event.ObjsSetMotion(1, "右から上", 6)
	event.ObjsNextMotion(1, "上向くL", 4)
	helper_a694495f(30)
	if vm.skipping() then
		return skip(15)
	end
	helper_568c(6080025, -1)
	if vm.skipping() then
		return skip(16)
	end
	helper_f2bfb50b(2)
	if vm.skipping() then
		return skip(17)
	end
	event.CmrsSetPos(42.03, 12.5, 8.79)
	event.CmrsSetRef(-17.69, 20.13, 73.01)
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "無表情")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.SetPakuAnim(1, "通常口パク")
	helper_568c(6080030, -1)
	if vm.skipping() then
		return skip(18)
	end
	helper_a694495f(15)
	if vm.skipping() then
		return skip(19)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_568c(6080035, -1)
	if vm.skipping() then
		return skip(20)
	end
	helper_a694495f(30)
	if vm.skipping() then
		return skip(21)
	end
	event.CmrsSetPos(-1.98, 141.34, -232.47)
	event.CmrsSetRef(-1.03, 144.72, -259.94)
	helper_568c(6080040, -1)
	if vm.skipping() then
		return skip(22)
	end
	helper_a694495f(15)
	if vm.skipping() then
		return skip(23)
	end
	event.ObjsSetMotion(2, "笑う", 6)
	event.ObjsNextMotion(2, "笑うL", 4)
	event.ObjsNextMotion(2, "笑う戻り", 4)
	event.ObjsNextMotion(2, "立ち")
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "通常目～わらい目")
	helper_568c(6080045, -1)
	if vm.skipping() then
		return skip(24)
	end
	event.CmrsSetPos(-3.6, 35.33, 230.79)
	event.CmrsSetRef(-2.02, 46.97, 103.92)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おこり顔")
	event.ObjsTexAnime(0, 1, "おこり目パチ")
	event.SetPakuAnim(0, "通常口パク")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "おこり顔")
	event.ObjsTexAnime(1, 1, "おこり目パチ")
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "通常目")
	event.ObjsSetMotion(2, "歩き")
	event.ObjsMove(2, -0.89, 36.96, -59.99, 400, 1)
	event.ObjsMotionDelay(2, 400)
	event.ObjsSetMotion(2, "立ち")
	helper_568c(6080050, -1)
	if vm.skipping() then
		return skip(25)
	end
	helper_a694495f(30)
	if vm.skipping() then
		return skip(26)
	end
	helper_568c(6080060, -1)
	if vm.skipping() then
		return skip(27)
	end
	helper_a694495f(15)
	if vm.skipping() then
		return skip(28)
	end
	helper_568c(6080070, -1)
	if vm.skipping() then
		return skip(29)
	end
	helper_a694495f(30)
	if vm.skipping() then
		return skip(30)
	end
	helper_568c(6080075, -1)
	if vm.skipping() then
		return skip(31)
	end
	event.SndSePlay(var0, 3)
	event.ObjsSetMotion(0, "かまえる", 6)
	event.ObjsNextMotion(0, "かまえるL", 4)
	event.ObjsSeDelay(1, 10)
	event.ObjsSePlay(1, var0, 4)
	event.ObjsMotionDelay(1, 10)
	event.ObjsSetMotion(1, "身構え", 6)
	event.ObjsNextMotion(1, "身構えL", 4)
	helper_f2bfb50b(2)
	if vm.skipping() then
		return skip(32)
	end
	event.ObjsSetMotion(2, "笑う", 6)
	event.ObjsNextMotion(2, "笑うL", 4)
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "通常目～わらい目")
	helper_568c(6080080, -1)
	if vm.skipping() then
		return skip(33)
	end
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "通常目")
	helper_a694495f(15)
	if vm.skipping() then
		return skip(34)
	end
	event.SetCrossfade(30)
	event.CmrsSetPos(-1.56, 41.19, 0.3)
	event.CmrsSetRef(-0.5, 43.3, -50.78)
	event.CmrsMove2(-1.3, 37.59, -12.38, -0.5, 43.3, -50.78, 120, 2, 1.0)
	event.ObjsSetColor(4, 128, 128, 128, 128, 30)
	helper_a694495f(120)
	if vm.skipping() then
		return skip(35)
	end
	event.ObjsSetColor(4, 128, 128, 128, 0, 30)
	helper_a694495f(30)
	if vm.skipping() then
		return skip(36)
	end
	event.CmrsSetPos(13.66, 39.05, 16.1)
	event.CmrsSetRef(16.97, 18.33, 61.91)
	event.ObjsSetMotion(2, "立ち")
	event.CmrsMove(-16.73, 39.05, 18.35, -15.62, 18.33, 64.27, 120)
	event.SetPakuAnim(0, "通常口パク")
	helper_568c(6080090, -1)
	if vm.skipping() then
		return skip(37)
	end
	event.CmrsSetPos(1.22, 23.49, 141.64)
	event.CmrsSetRef(1.34, 25.13, 39.83)
	event.ObjsSetMotion(2, "フードに手をやる", 6)
	event.ObjsNextMotion(2, "フードに手をやるL", 4)
	helper_a694495f(60)
	if vm.skipping() then
		return skip(38)
	end
	event.SndSePlay(var0, 5)
	event.CmrsSetPos(33.21, 53.76, -44.92)
	event.CmrsSetRef(3.6, 57.9, -78.66)
	event.ObjsTexAnime(3, 0)
	event.ObjsTexAnime(3, 1, "目とじ")
	event.CharaActive(0, 11)
	event.CharaActive(12)
	event.ObjsSetMotion(3, "頭ぶるぶる", 6)
	event.ObjsNextMotion(3, "両手広げる", 4)
	event.ObjsNextMotion(3, "両手広げるＬ", 4)
	helper_f2bfb50b(3)
	if vm.skipping() then
		return skip(39)
	end
	event.ObjsSetMotion(3, "両手広げ会話")
	event.ObjsTexAnime(3, 0)
	event.ObjsTexAnime(3, 1, "目とじ～目あき")
	helper_568c(6080100, -1)
	if vm.skipping() then
		return skip(40)
	end
	helper_a694495f(20)
	if vm.skipping() then
		return skip(41)
	end
	event.CmrsPrdelay(60)
	event.CmrsSetPos(9.9, 35.11, 33.88)
	event.CmrsSetRef(15.48, 21.68, 64.42)
	event.CmrsMove(11.17, 31.65, 40.85, 15.48, 21.68, 64.42, 60)
	event.CmrsSetPos(-14.64, 35.21, 35.6)
	event.CmrsSetRef(-16.78, 21.68, 60.9)
	event.ObjsTexaDelay(3, 60)
	event.ObjsTexAnime(3, 0)
	event.ObjsTexAnime(3, 1, "こわれ目パチ")
	event.CmrsMove(-14.36, 32.13, 37.22, -17.13, 20.52, 65.0, 60)
	event.CmrsSetPos(0.31, 58.43, -61.11)
	event.CmrsSetRef(0.74, 63.75, -85.24)
	event.ObjsSetMotion(3, "両手広げ会話", 4)
	event.ObjsMotionDelay(3, 240)
	event.ObjsNextMotion(3, "両手広げるＬ", 4)
	event.CmrsMove(0.73, 32.94, -12.13, 0.74, 63.75, -85.24, 60)
	helper_568c(6080105, 240)
	if vm.skipping() then
		return skip(42)
	end
	event.SetFadeOut(30)
	helper_a694495f(30)
	if vm.skipping() then
		return skip(43)
	end
	return part2()
end

--- Helper function.
local function helper_2dd08()
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.FuncPointShow("", "item1", 0)
	event.FuncPointShow("", "item2", 0)
	event.FuncPointShow("", "item3", 0)
	event.FuncPointShow("", "item4", 0)
	event.FuncPointShow("", "item5", 0)
	event.FuncPointShow("", "item6", 0)
	event.FuncPointShow("", "item7", 0)
	event.FuncPointShow("", "item8", 0)
	event.FuncPointShow("", "item9", 0)
	event.FuncPointShow("", "item10", 0)
	event.FuncPointShow("", "item11", 0)
	event.FuncPointShow("", "item12", 0)
	event.FuncPointShow("", "item13", 0)
	event.FuncPointShow("", "item14", 0)
	event.FuncPointShow("", "item15", 0)
	event.FuncPointShow("", "item16", 0)
	event.FuncPointShow("", "item17", 0)
	event.FuncPointShow("", "item18", 0)
	event.FuncPointShow("", "item19", 0)
	event.FuncPointShow("", "item20", 0)
	event.FuncPointShow("", "item21", 0)
	event.FuncPointShow("", "item22", 0)
end

--- Helper function.
local function helper_15394()
	local var0: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 23 then
			if at <= 1 then
				helper_6040(6100010)
			end
			if at <= 2 then
				helper_f2bfb50b(0)
			end
			if at <= 3 then
				helper_a694495f(30)
			end
			if at <= 4 then
				helper_568c(6100020, 15)
			end
			if at <= 5 then
				helper_f2bfb50b(1)
			end
			if at <= 6 then
				helper_a694495f(30)
			end
			if at <= 7 then
				helper_a694495f(30)
			end
			if at <= 8 then
				helper_a694495f(60)
			end
			if at <= 9 then
				helper_a694495f(30)
			end
			if at <= 10 then
				helper_a694495f(15)
			end
			if at <= 11 then
				helper_f2bfb50b(3)
			end
			if at <= 12 then
				helper_a694495f(60)
			end
			if at <= 13 then
				helper_a694495f(30)
			end
			if at <= 14 then
				helper_568c(6100030, 120)
			end
			if at <= 15 then
				helper_568c(6100040, 60)
			end
			if at <= 16 then
				helper_568c(6100050, 240)
			end
			if at <= 17 then
				helper_568c(6100060, 120)
			end
			if at <= 18 then
				helper_a694495f(60)
			end
			if at <= 19 then
				helper_6040(6100070)
			end
			if at <= 20 then
				helper_a694495f(30)
			end
			if at <= 21 then
				helper_6040(6100080)
			end
			if at <= 22 then
				helper_a694495f(30)
			end
			if vm.skip_end() then
				return skip(24)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.LoadBgm(36)
		event.PlayBgm(0)
		event.SndSeStop(var0, 2)
		event.SndSeStop(var0, 4)
		event.DngPause(128, 0)
		event.SpriteSetDraw(0, 0)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.DngPause(128, 0)
		event.DeleteChara(8)
		event.DeleteChara(9)
		event.DeleteChara(10)
		event.DeleteChara(11)
		event.DeleteChara(12)
		event.DeleteChara(13)
		event.DeleteChara(14)
		event.LoadMes(0, -1)
		event.CharaActive(1, 0)
		event.SetStatusbarShow(1, 1.0)
		event.SetCharaShow(1, 1)
		event.SetCharaShow(2, 1)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFlag(610, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.StopBgm(0)
	event.LoadSound(7809)
	var0 = event.SndLoadSound(7809) or var0
	event.SndSePlay(var0, 0)
	event.SndSeStop(var0, 0)
	event.SetStatusbarShow(0, 1.0)
	event.CharaActive(0, 0)
	event.AssignStack(5)
	event.ClearStack(5)
	event.ChangeDir("event/e600/e610/")
	event.LoadMes(0, 5, "e610.txt")
	event.ChangeDir("")
	event.SpriteInit(0)
	event.SpriteSetType(0, 0)
	event.SpriteSetColor(0, 128, 128, 128, 0)
	event.SpriteSetUvsize(0, 0, 0, 512, 448)
	event.SpriteSetPutsize(0, 512, 448)
	event.SpriteSetPos(0, 256, 224)
	event.SpriteSetDraw(0, 1)
	event.EohSyncSprite(5, 0)
	event.ObjsInit(5)
	event.ObjsSyncObj(5, 5)
	event.LoadChara(5, "chara/c01_base.gltf", "info", 8)
	event.LoadEquip(5, 0, 4, "info", 8)
	event.LoadEquip(5, 0, 3, "info", 8)
	event.LoadEquip(5, 0, 2, "info", 8, 9)
	event.LoadMotion(5, "event/e600/e610/e610_mints.gltf", "info", 8)
	event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 8)
	event.EohSyncChara(0, 8)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.LoadChara(5, "chara/c02_base.gltf", "info", 10)
	event.LoadEquip(5, 1, 4, "info", 10)
	event.LoadEquip(5, 1, 3, "info", 10)
	event.LoadEquip(5, 1, 2, "info", 10, 11)
	event.LoadMotion(5, "event/e600/e610/e610_monica.gltf", "info", 10)
	event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 10)
	event.EohSyncChara(1, 10)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.LoadChara(5, "event/e600/e610/e610_hana_sun_ex.gltf", "info", 12)
	event.CharaActive(12)
	event.EohSyncChara(2, 12)
	event.ObjsInit(2, 12)
	event.ObjsSyncObj(2, 2)
	event.LoadChara(5, "event/e600/e610/e610_kiran.gltf", "info", 13)
	event.CharaActive(13)
	event.EohSyncChara(3, 13)
	event.ObjsInit(3, 13)
	event.ObjsSyncObj(3, 3)
	event.LoadChara(5, "event/e600/e610/e610_hanakudake.gltf", "info", 14)
	event.CharaActive(14)
	event.EohSyncChara(4, 14)
	event.ObjsInit(4, 14)
	event.ObjsSyncObj(4, 4)
	event.SetCharaShow(1, 0)
	event.SetCharaShow(2, 0)
	event.EohSetPos(0, -36.85, 0.2, 211.1)
	event.EohSetRot(0, 0.0, -1.13, 0.0)
	event.EohSetMotion(0, "立ち", 4)
	event.EohSetFootSoundId(0, 4)
	event.EohSetPos(1, 32.44, 0.2, 194.73)
	event.EohSetRot(1, 0.0, 0.95, 0.0)
	event.EohSetMotion(1, "立ち", 4)
	event.EohSetFootSoundId(1, 4)
	event.InitDramaScene()
	event.CmrsInit()
	event.CmrsSetPos(-25.8, 19.87, 265.72)
	event.CmrsSetRef(-34.35, 19.8, 232.21)
	event.CharaActive(8)
	event.CharaActive(9)
	event.CharaActive(10)
	event.CharaActive(11)
	event.CharaActive(0, 12)
	event.CharaActive(0, 13)
	event.CharaActive(0, 14)
	event.SetFadeIn(30)
	event.ObjsSetColor(5, 0, 0, 0, 128, 0)
	helper_6040(6100010)
	if vm.skipping() then
		return skip(2)
	end
	event.ObjsSetColor(5, 0, 0, 0, 0, 1)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おこり顔")
	event.ObjsTexAnime(0, 1, "左向き目パチ")
	event.ObjsTexAnime(0, 1, "半口")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "おこり顔")
	event.ObjsTexAnime(1, 1, "右向き目パチ")
	event.ObjsTexAnime(1, 1, "半口")
	event.ObjsSetMotion(0, "はっとする", 6)
	event.ObjsNextMotion(0, "はっとするL", 4)
	helper_f2bfb50b(0)
	if vm.skipping() then
		return skip(3)
	end
	event.SndSePlay(var0, 0)
	event.SetFadeOut(30, 255, 255, 255)
	helper_a694495f(30)
	if vm.skipping() then
		return skip(4)
	end
	event.SetFadeIn(15, 255, 255, 255)
	event.CmrsSetPos(24.23, 19.45, 233.89)
	event.CmrsSetRef(37.75, 19.84, 179.82)
	event.ObjsSetMotion(1, "ふりかえり", 6)
	event.ObjsNextMotion(1, "ふりかえりL", 4)
	helper_568c(6100020, 15)
	if vm.skipping() then
		return skip(5)
	end
	helper_f2bfb50b(1)
	if vm.skipping() then
		return skip(6)
	end
	event.SndSePlay(var0, 1)
	event.SetFadeOut(30, 255, 255, 255)
	helper_a694495f(30)
	if vm.skipping() then
		return skip(7)
	end
	event.SndSePlay(var0, 2)
	event.SetFadeIn(30)
	event.ObjsSetColor(5, 0, 0, 0, 128, 0)
	helper_a694495f(30)
	if vm.skipping() then
		return skip(8)
	end
	event.CmrsFadeOut(0)
	event.ObjsSetColor(5, 0, 0, 0, 0, 0)
	helper_a694495f(60)
	if vm.skipping() then
		return skip(9)
	end
	event.SetFadeIn(30)
	event.DngPause(128, 1)
	event.CmrsSetPos(1.98, 6.53, 181.87)
	event.CmrsSetRef(1.06, 23.97, 120.97)
	event.ObjsSetPos(1, 12.41, 0.2, 137.08)
	event.ObjsSetRot(1, 0.0, -0.72, 0.0)
	event.ObjsSetMotion(1, "立ち", 4)
	event.ObjsResetDaPosition(1)
	event.ObjsSetPos(0, -9.58, 0.2, 135.04)
	event.ObjsSetRot(0, 0.0, 0.71, 0.0)
	event.ObjsSetMotion(0, "立ち", 4)
	event.ObjsResetDaPosition(0)
	event.DngPause(128, 1)
	event.SpriteSetDraw(0, 0)
	helper_a694495f(30)
	if vm.skipping() then
		return skip(10)
	end
	event.CharaActive(13)
	event.ObjsSetPos(3, 1.8, 10.3, 168.28)
	event.ObjsSetRot(3, 0.0, 0.48, 0.35)
	event.ObjsSetMotion(3, "キラン", 4)
	event.CharaActive(14)
	event.ObjsSetPos(4, 1.24, 13.3, 134.88)
	event.ObjsSetMotion(4, "現れる", 6)
	event.ObjsNextMotion(4, "ループ", 4)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おこり顔")
	event.ObjsTexAnime(0, 1, "目あき～目とじ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "おこり顔")
	event.ObjsTexAnime(1, 1, "目あき～目とじ")
	event.SndSePlay(var0, 3)
	event.ObjsSetMotion(0, "光る", 6)
	event.ObjsNextMotion(0, "下向き立ち", 4)
	event.ObjsSetMotion(1, "まぶしい", 6)
	event.ObjsNextMotion(1, "下見立ち", 4)
	helper_a694495f(15)
	if vm.skipping() then
		return skip(11)
	end
	event.CharaActive(12)
	event.ObjsSetPos(2, 1.24, 13.3, 134.88)
	helper_f2bfb50b(3)
	if vm.skipping() then
		return skip(12)
	end
	event.CharaActive(0, 13)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "目とじ～おこり目")
	event.ObjsTexAnime(0, 1, "半口")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "おこり顔")
	event.ObjsTexAnime(1, 1, "目とじ～目あき")
	helper_a694495f(60)
	if vm.skipping() then
		return skip(13)
	end
	event.ObjsSetMotion(0, "さわろうとする", 6)
	event.ObjsNextMotion(0, "下向き立ち", 4)
	event.ObjsMotionDelay(1, 20)
	event.ObjsSetMotion(1, "はじける", 6)
	event.ObjsNextMotion(1, "下見立ち", 4)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おこり顔")
	event.ObjsTexAnime(0, 1, "まばたき目パチ")
	event.ObjsTexAnime(0, 1, "半口～大口")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "おこり顔")
	event.ObjsTexAnime(1, 1, "まばたき目パチ")
	event.ObjsTexAnime(1, 1, "半口")
	event.ObjsMotionDelay(4, 15)
	event.ObjsSetMotion(4, "花くだけ", 4)
	event.ObjsSetStep(4, 0.05)
	helper_a694495f(30)
	if vm.skipping() then
		return skip(14)
	end
	event.SetCharaShow(12, 0, 1, 0.1)
	event.SndSePlay(var0, 4)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おこり顔")
	event.ObjsTexAnime(0, 1, "おこり目パチ")
	event.ObjsTexAnime(0, 1, "大口～口とじ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "おこり顔")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	helper_568c(6100030, 120)
	if vm.skipping() then
		return skip(15)
	end
	helper_568c(6100040, 60)
	if vm.skipping() then
		return skip(16)
	end
	event.SetFadeOut(420, 0, 0, 0)
	helper_568c(6100050, 240)
	if vm.skipping() then
		return skip(17)
	end
	event.CharaActive(0, 14)
	event.ObjsSetMotion(0, "下→上", 6)
	event.ObjsNextMotion(0, "上向くL", 4)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おこり顔")
	event.ObjsTexAnime(0, 1, "おこり目パチ")
	event.SetPakuAnim(0, "通常口パク")
	helper_568c(6100060, 120)
	if vm.skipping() then
		return skip(18)
	end
	helper_a694495f(60)
	if vm.skipping() then
		return skip(19)
	end
	event.SetFadeIn(15, 0, 0, 0)
	event.ObjsSetColor(5, 0, 0, 0, 128, 0)
	event.SpriteSetDraw(0, 1)
	helper_6040(6100070)
	if vm.skipping() then
		return skip(20)
	end
	event.SetFadeOut(30, 255, 255, 255)
	helper_a694495f(30)
	if vm.skipping() then
		return skip(21)
	end
	event.SetFadeIn(15, 255, 255, 255)
	event.ObjsSetColor(5, 255, 255, 255, 128, 0)
	helper_6040(6100080)
	if vm.skipping() then
		return skip(22)
	end
	event.SetFadeOut(30)
	helper_a694495f(30)
	if vm.skipping() then
		return skip(23)
	end
	return part2()
end

--- Helper function.
local function helper_18964()
	local var0: s32 = 0
	local var1: s32 = 0
	local active_chr_no: s32 = 0
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local var6: s32 = 0
	local var7: f32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 129 then
			if at <= 1 then
				helper_a694495f(4)
			end
			if at <= 2 then
				helper_a694495f(60)
			end
			if at <= 3 then
				helper_568c(6120010, -1)
			end
			if at <= 4 then
				helper_f2bfb50b(4)
			end
			if at <= 5 then
				helper_a694495f(60)
			end
			if at <= 6 then
				helper_a694495f(90)
			end
			if at <= 7 then
				helper_6040(6120020)
			end
			if at <= 8 then
				helper_6040(6120030)
			end
			if at <= 9 then
				helper_a694495f(30)
			end
			if at <= 10 then
				helper_f2bfb50b(4)
			end
			if at <= 11 then
				helper_a694495f(16)
			end
			if at <= 12 then
				helper_a694495f(6)
			end
			if at <= 13 then
				helper_a694495f(10)
			end
			if at <= 14 then
				helper_a694495f(8)
			end
			if at <= 15 then
				helper_a694495f(30)
			end
			if at <= 16 then
				helper_568c(6120040, 45)
			end
			if at <= 17 then
				helper_568c(6120050, 70)
			end
			if at <= 18 then
				helper_f2bfb50b(4)
			end
			if at <= 19 then
				helper_a694495f(30)
			end
			if at <= 20 then
				helper_568c(6120060, -1)
			end
			if at <= 21 then
				helper_a694495f(30)
			end
			if at <= 22 then
				helper_f2bfb50b(4)
			end
			if at <= 23 then
				helper_568c(6120065, -1)
			end
			if at <= 24 then
				helper_f2bfb50b(4)
			end
			if at <= 25 then
				helper_a694495f(60)
			end
			if at <= 26 then
				helper_568c(6120070, 60)
			end
			if at <= 27 then
				helper_a694495f(60)
			end
			if at <= 28 then
				helper_a694495f(90)
			end
			if at <= 29 then
				helper_a694495f(60)
			end
			if at <= 30 then
				helper_a694495f(15)
			end
			if at <= 31 then
				helper_a694495f(15)
			end
			if at <= 32 then
				helper_568c(6120080, 30)
			end
			if at <= 33 then
				helper_a694495f(30)
			end
			if at <= 34 then
				helper_a694495f(30)
			end
			if at <= 35 then
				helper_a694495f(30)
			end
			if at <= 36 then
				helper_daca499b()
			end
			if at <= 37 then
				helper_a694495f(30)
			end
			if at <= 38 then
				helper_568c(6120090, 180)
			end
			if at <= 39 then
				helper_daca499b()
			end
			if at <= 40 then
				x = vm.f32(-22.54)
				y = vm.f32(20.9)
				z = vm.f32(332.85)
				helper_daca499b()
			end
			if at <= 41 then
				helper_a694495f(60)
			end
			if at <= 42 then
				helper_568c(6120100, -1)
			end
			if at <= 43 then
				helper_a694495f(60)
			end
			if at <= 44 then
				helper_f2bfb50b(5)
			end
			if at <= 45 then
				helper_a694495f(4)
			end
			if at <= 46 then
				helper_6040(6120110)
			end
			if at <= 47 then
				helper_f2bfb50b(5)
			end
			if at <= 48 then
				helper_6040(6120120)
			end
			if at <= 49 then
				helper_6040(6120125)
			end
			if at <= 50 then
				helper_f2bfb50b(1)
			end
			if at <= 51 then
				helper_6040(6120130)
			end
			if at <= 52 then
				helper_6040(6120135)
			end
			if at <= 53 then
				helper_6040(6120140)
			end
			if at <= 54 then
				helper_f2bfb50b(5)
			end
			if at <= 55 then
				helper_568c(6120150, 150)
			end
			if at <= 56 then
				helper_f2bfb50b(5)
			end
			if at <= 57 then
				helper_568c(6120160, 150)
			end
			if at <= 58 then
				helper_568c(6120165, 240)
			end
			if at <= 59 then
				helper_f2bfb50b(5)
			end
			if at <= 60 then
				helper_9329a84e(1)
			end
			if at <= 61 then
				helper_872c66b5(0, -1, 8, 0, 0)
				var7 = vm.f32(vm.f32(vm.f32(vm.f32(-224.90002) * var6) / 350) + vm.f32(524.9))
				var6 = var6 + 1
			end
			if at <= 62 then
				helper_06ab565c(0)
				helper_daca499b()
			end
			if at <= 63 then
				helper_568c(6120180, 240)
			end
			if at <= 64 then
				helper_568c(6120185, 130)
			end
			if at <= 65 then
				helper_568c(6120190, 90)
			end
			if at <= 66 then
				helper_568c(6120200, -1)
			end
			if at <= 67 then
				helper_a694495f(15)
			end
			if at <= 68 then
				helper_568c(6120205, -1)
			end
			if at <= 69 then
				helper_a694495f(30)
			end
			if at <= 70 then
				helper_568c(6120210, -1)
			end
			if at <= 71 then
				helper_a694495f(30)
			end
			if at <= 72 then
				helper_f2bfb50b(5)
			end
			if at <= 73 then
				helper_9329a84e(1)
			end
			if at <= 74 then
				helper_872c66b5(0, -1, 8, 0, 0)
				helper_a694495f(40)
			end
			if at <= 75 then
				helper_5c96a7ac(0, -1)
			end
			if at <= 76 then
				helper_06ab565c(0)
				helper_f2bfb50b(5)
			end
			if at <= 77 then
				helper_a694495f(30)
			end
			if at <= 78 then
				helper_a694495f(15)
			end
			if at <= 79 then
				helper_568c(6120230, -1)
			end
			if at <= 80 then
				helper_f2bfb50b(5)
			end
			if at <= 81 then
				helper_a694495f(50)
			end
			if at <= 82 then
				helper_9329a84e(1)
			end
			if at <= 83 then
				helper_872c66b5(0, -1, 8, 0, 0)
				helper_a694495f(150)
			end
			if at <= 84 then
				helper_5c96a7ac(0, -1)
			end
			if at <= 85 then
				helper_06ab565c(0)
				helper_a694495f(90)
			end
			if at <= 86 then
				helper_568c(6120250, -1)
			end
			if at <= 87 then
				helper_f2bfb50b(5)
			end
			if at <= 88 then
				helper_a694495f(60)
			end
			if at <= 89 then
				helper_568c(6120260, -1)
			end
			if at <= 90 then
				helper_f2bfb50b(1)
			end
			if at <= 91 then
				helper_a694495f(30)
			end
			if at <= 92 then
				helper_568c(6120270, -1)
			end
			if at <= 93 then
				helper_a694495f(20)
			end
			if at <= 94 then
				helper_568c(6120273, -1)
			end
			if at <= 95 then
				helper_a694495f(50)
			end
			if at <= 96 then
				helper_568c(6120277, -1)
			end
			if at <= 97 then
				helper_f2bfb50b(5)
			end
			if at <= 98 then
				helper_a694495f(30)
			end
			if at <= 99 then
				helper_568c(6120280, -1)
			end
			if at <= 100 then
				helper_a694495f(40)
			end
			if at <= 101 then
				helper_568c(6120285, -1)
			end
			if at <= 102 then
				helper_a694495f(30)
			end
			if at <= 103 then
				helper_568c(6120290, -1)
			end
			if at <= 104 then
				helper_a694495f(30)
			end
			if at <= 105 then
				helper_568c(6120300, -1)
			end
			if at <= 106 then
				helper_a694495f(30)
			end
			if at <= 107 then
				helper_568c(6120305, -1)
			end
			if at <= 108 then
				helper_f2bfb50b(5)
			end
			if at <= 109 then
				helper_a694495f(20)
			end
			if at <= 110 then
				helper_568c(6120310, -1)
			end
			if at <= 111 then
				helper_f2bfb50b(5)
			end
			if at <= 112 then
				helper_a694495f(30)
			end
			if at <= 113 then
				helper_a694495f(20)
			end
			if at <= 114 then
				helper_568c(6120320, -1)
			end
			if at <= 115 then
				helper_a694495f(20)
			end
			if at <= 116 then
				helper_568c(6120323, -1)
			end
			if at <= 117 then
				helper_a694495f(20)
			end
			if at <= 118 then
				helper_568c(6120327, -1)
			end
			if at <= 119 then
				helper_f2bfb50b(5)
			end
			if at <= 120 then
				helper_a694495f(15)
			end
			if at <= 121 then
				helper_a694495f(60)
			end
			if at <= 122 then
				helper_a694495f(30)
			end
			if at <= 123 then
				helper_a694495f(30)
			end
			if at <= 124 then
				helper_a694495f(90)
			end
			if at <= 125 then
				helper_a694495f(90)
			end
			if at <= 126 then
				helper_a694495f(60)
			end
			if at <= 127 then
				helper_568c(6120330, -1)
			end
			if at <= 128 then
				helper_a694495f(30)
			end
			if vm.skip_end() then
				return skip(130)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SetMotionBlur(0)
		event.SetWind(-1)
		event.StopBgm(0)
		event.SndSeStop(var0, 15)
		event.SndSeStop(var0, 16)
		active_chr_no = event.GetActiveChrNo() or active_chr_no
		if active_chr_no == 0 then
			event.AtramiriaOnOff(0, 0, 0)
		else
			event.AtramiriaOnOff(1, 0, 0)
		end
		event.CmrsInit()
		event.BgmLoadCancel()
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
		event.DeleteChara(17)
		event.DeleteChara(18)
		event.DeleteChara(19)
		event.LoadMes(0, -1)
		event.CharaActive(0)
		event.SetCharaPos(0, -1.02, 0.2, 111.04)
		event.SetCharaRot(0, 0.0, 3.11, 0.0)
		event.SetMotion(0, "立ち", 4)
		event.CharaNormalDrive(0)
		event.CharaResetDa(0)
		event.ResetCamera(1, 3.1415927, 10.0)
		event.SetFadeIn(30)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFlag(612, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.SetStatusbarShow(0, 1.0)
	event.StopBgm(0)
	helper_a694495f(4)
	if vm.skipping() then
		return skip(2)
	end
	event.LoadBgm(33)
	event.LoadSound(7810)
	var0 = event.SndLoadSound(7810) or var0
	var1 = event.SndLoadSound(8, "snd2/sp/sp_051.sound.json") or var1
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.ChangeDir("event/e600/e612/")
	event.LoadMes(0, 5, "e612.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e612_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e612_monica.gltf", "info", 0)
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
		event.LoadEquip(5, 0, 0, "info", 8, 10)
		event.LoadEquip(5, 0, 1, "info", 8, 11)
		event.LoadMotion(5, "event/e600/e612/e612_mints.gltf", "info", 8)
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
		event.LoadEquip(5, 1, 0, "info", 8, 10)
		event.LoadEquip(5, 1, 1, "info", 8, 11)
		event.LoadMotion(5, "event/e600/e612/e612_monica.gltf", "info", 8)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 8)
		event.EohSyncChara(1, 8)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 0)
	end
	event.CharaActive(8)
	event.CharaActive(9)
	event.CharaActive(1, 10)
	event.CharaActive(1, 11)
	event.LoadChara(5, "event/e600/e612/e612_atora_a.gltf", "info", 12)
	event.CharaActive(12)
	event.EohSyncChara(2, 12)
	event.ObjsInit(2, 12)
	event.ObjsSyncObj(2, 2)
	event.LoadChara(5, "event/e600/e612/e612_atora_b.gltf", "info", 13)
	event.CharaActive(13)
	event.EohSyncChara(3, 13)
	event.ObjsInit(3, 13)
	event.ObjsSyncObj(3, 3)
	event.LoadChara(5, "event/e600/e612/e612_sun.gltf", "info", 14)
	event.CharaActive(14)
	event.EohSyncChara(4, 14)
	event.ObjsInit(4, 14)
	event.ObjsSyncObj(4, 4)
	event.LoadChara(5, "event/e600/e612/e612_griffon.gltf", "info", 15)
	event.CharaActive(15)
	event.EohSyncChara(5, 15)
	event.ObjsInit(5, 15)
	event.ObjsSyncObj(5, 5)
	event.LoadChara(5, "event/e600/e612/e612_sun_ray.gltf", "info", 16)
	event.CharaActive(16)
	event.EohSyncChara(6, 16)
	event.ObjsInit(6, 16)
	event.ObjsSyncObj(6, 6)
	event.LoadChara(5, "event/e600/e612/e612_ghikari.gltf", "info", 17)
	event.CharaActive(17)
	event.EohSyncChara(7, 17)
	event.ObjsInit(7, 17)
	event.ObjsSyncObj(7, 7)
	event.LoadChara(5, "event/e600/e612/e612_hiraki.gltf", "info", 18)
	event.CharaActive(18)
	event.EohSyncChara(8, 18)
	event.ObjsInit(8, 18)
	event.ObjsSyncObj(8, 8)
	event.LoadChara(5, "event/e600/e612/e612_sun_eye.gltf", "info", 19)
	event.CharaActive(19)
	event.EohSyncChara(9, 19)
	event.ObjsInit(9, 19)
	event.ObjsSyncObj(9, 9)
	event.EohSetPos(0, 18.48, 0.2, 307.68)
	event.EohSetRot(0, 0.0, -0.53, 0.0)
	event.EohSetMotion(0, "戦闘立ち", 4)
	event.EohSetFootSoundId(0, 21)
	event.EohSetPos(1, -23.14, 0.2, 308.89)
	event.EohSetRot(1, 0.0, 0.23, 0.0)
	event.EohSetMotion(1, "剣構え", 4)
	event.EohSetFootSoundId(1, 21)
	event.EohSetPos(4, 4.86, 0.2, 441.28)
	event.EohSetRot(4, 0.0, -3.13, 0.0)
	event.EohSetMotion(4, "よろよろ立ち", 4)
	event.EohSetFootSoundId(4, 21)
	event.SetReference(14, "hikari", 19)
	event.EohSetShow(9, 0)
	event.InitDramaScene()
	event.CmrsInit()
	event.CmrsSetPos(-78.74, 78.05, 198.62)
	event.CmrsSetRef(13.39, 2.21, 381.09)
	event.CharaActive(0)
	event.CharaActive(8)
	event.CharaActive(9)
	event.CharaActive(14)
	event.CharaActive(0, 12)
	event.CharaActive(0, 13)
	event.CharaActive(0, 15)
	event.CharaActive(0, 16)
	event.CharaActive(0, 17)
	event.CharaActive(0, 18)
	event.SetFadeIn(30)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おこり顔")
	event.ObjsTexAnime(0, 1, "おこり目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "おこり顔")
	event.ObjsTexAnime(1, 1, "おこり目パチ")
	event.ObjsTexAnime(4, 0)
	event.ObjsTexAnime(4, 1, "くるし目パチ")
	helper_a694495f(60)
	if vm.skipping() then
		return skip(3)
	end
	event.CmrsSetPos(-41.54, 14.05, 496.91)
	event.CmrsSetRef(12.6, 11.66, 379.4)
	event.ObjsTexAnime(4, 0)
	event.ObjsTexAnime(4, 1, "くるし目～目とじ")
	event.ObjsSetMotion(4, "よろよろ会話", 6)
	event.ObjsNextMotion(4, "よろよろ立ち", 4)
	helper_568c(6120010, -1)
	if vm.skipping() then
		return skip(4)
	end
	event.SndSePlay(var0, 0)
	event.ObjsSetMotion(4, "倒れる", 6)
	event.ObjsNextMotion(4, "倒れるＬ", 4)
	helper_f2bfb50b(4)
	if vm.skipping() then
		return skip(5)
	end
	helper_a694495f(60)
	if vm.skipping() then
		return skip(6)
	end
	event.CmrsSetPos(-88.01, 116.61, 327.84)
	event.CmrsSetRef(2.74, 11.66, 406.61)
	event.SetCharaShow(1, 0)
	event.SetCharaShow(2, 0)
	event.CharaActive(0, 10)
	event.CharaActive(0, 11)
	event.ObjsSetPos(0, 33.71, 0.2, 365.11)
	event.ObjsSetRot(0, 0.0, -0.17, 0.0)
	event.ObjsResetDaPosition(0)
	event.ObjsSetPos(1, -23.96, 0.2, 368.34)
	event.ObjsSetRot(1, 0.0, 0.23, 0.0)
	event.ObjsResetDaPosition(1)
	event.ObjsSetMotion(0, "歩き", 4)
	event.ObjsMove(0, 28.35, 0.2, 422.7, 60, 1)
	event.ObjsRotDelay(0, 30)
	event.ObjsRotation(0, 0.0, -0.89, 0.0, 50)
	event.ObjsMotionDelay(0, 60)
	event.ObjsSetMotion(0, "立ち")
	event.ObjsSetMotion(1, "歩き", 4)
	event.ObjsMove(1, -23.16, 0.2, 421.62, 70, 1)
	event.ObjsRotDelay(1, 30)
	event.ObjsRotation(1, 0.0, 0.95, 0.0, 50)
	event.ObjsMotionDelay(1, 70)
	event.ObjsSetMotion(1, "立ち")
	helper_a694495f(90)
	if vm.skipping() then
		return skip(7)
	end
	helper_6040(6120020)
	if vm.skipping() then
		return skip(8)
	end
	helper_6040(6120030)
	if vm.skipping() then
		return skip(9)
	end
	event.CmrsSetPos(-36.88, 13.32, 371.24)
	event.CmrsSetRef(-0.58, 15.51, 433.62)
	event.ObjsSetPos(0, 24.07, 0.2, 434.14)
	event.ObjsSetRot(0, 0.0, -1.61, 0.0)
	event.ObjsSetMotion(0, "下見立ち", 4)
	event.ObjsResetDaPosition(0)
	event.ObjsSetPos(1, -16.95, 0.2, 431.66)
	event.ObjsSetRot(1, 0.0, 1.19, 0.0)
	event.ObjsSetMotion(1, "下向き立ち", 4)
	event.ObjsResetDaPosition(1)
	helper_a694495f(30)
	if vm.skipping() then
		return skip(10)
	end
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おこり顔")
	event.ObjsTexAnime(0, 1, "おこり目～おどろき目")
	event.ObjsTexAnime(0, 1, "口とじ～大口")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "おこり顔")
	event.ObjsTexAnime(1, 1, "おこり目～おどろき目")
	event.ObjsTexAnime(1, 1, "口とじ～大口")
	event.ObjsTexAnime(4, 0)
	event.ObjsTexAnime(4, 1, "通常目パチ")
	event.SndSePlay(var0, 1)
	event.ObjsSetMotion(4, "起き上がる", 6)
	event.ObjsNextMotion(4, "石持ち立ち")
	event.ObjsSetMotion(0, "のけぞる", 6)
	event.ObjsNextMotion(0, "のけぞるL", 4)
	event.ObjsSetMotion(1, "のけぞり", 6)
	event.ObjsNextMotion(1, "のけぞりL", 4)
	helper_f2bfb50b(4)
	if vm.skipping() then
		return skip(11)
	end
	event.SetStatus(1, 0, 256, 1)
	event.CmrsSetPos(18.01, 15.67, 424.73)
	event.CmrsSetRef(26.69, 15.51, 433.92)
	event.CharaActive(12)
	event.ObjsSetPos(4, 9.42, 0.2, 432.34)
	event.ObjsSetRot(4, 0.0, 1.95, 0.0)
	event.ObjsResetDaPosition(4)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		event.AtramiriaOnOff(0, 0, 0)
	else
		event.AtramiriaOnOff(0, 8, 0)
	end
	event.ObjsSetPos(2, 25.41, 12.88, 433.35)
	event.ObjsSetRot(2, 0.0, -1.68, 0.0)
	event.ObjsSetMotion(4, "ユリスからもぎ取る", 6)
	event.ObjsSetStep(4, 0.4)
	helper_a694495f(16)
	if vm.skipping() then
		return skip(12)
	end
	event.SndSePlay(var0, 2)
	event.ObjsMove(2, 24.24, 8.61, 429.7, 3)
	helper_a694495f(6)
	if vm.skipping() then
		return skip(13)
	end
	event.CharaActive(0, 12)
	event.CmrsSetPos(-18.72, 20.05, 442.61)
	event.CmrsSetRef(-16.52, 16.03, 434.01)
	event.CharaActive(1, 13)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		event.AtramiriaOnOff(1, 0, 0)
	else
		event.AtramiriaOnOff(1, 8, 0)
	end
	event.ObjsSetPos(4, -3.81, 0.2, 442.31)
	event.ObjsSetRot(4, 0.0, -2.33, 0.0)
	event.ObjsResetDaPosition(4)
	event.ObjsSetPos(3, -15.16, 15.1, 434.91)
	event.ObjsSetRot(3, -0.6, 0.72, 0.0)
	event.ObjsSetMotion(1, "目で追うL", 4)
	event.ObjsResetDaPosition(1)
	event.ObjsSetMotion(4, "モニカから奪う", 4)
	event.ObjsSetStep(4, 0.4)
	event.SetStatus(1, 0, 256, 0)
	helper_a694495f(10)
	if vm.skipping() then
		return skip(14)
	end
	event.SndSePlay(var0, 3)
	event.ObjsMove(3, -8.89, 18.29, 433.34, 3)
	helper_a694495f(8)
	if vm.skipping() then
		return skip(15)
	end
	event.CmrsSetPos(-32.04, 13.37, 229.44)
	event.CmrsSetRef(23.02, 3.56, 367.15)
	event.CharaActive(1, 12)
	event.CharaActive(1, 13)
	event.ObjsSetPos(2, 0.0, 0.0, 0.0)
	event.ObjsSetRot(2, 0.0, 0.0, 0.0)
	event.ObjsSetPos(3, 0.0, 0.0, 0.0)
	event.ObjsSetRot(3, 0.0, 0.0, 0.0)
	event.SetReference(14, "aka_null", 12)
	event.SetReference(14, "ao_null", 13)
	event.ObjsSetPos(0, 24.07, 0.2, 434.14)
	event.ObjsSetRot(0, 0.0, -1.61, 0.0)
	event.ObjsSetMotion(0, "のけぞるL", 4)
	event.ObjsResetDaPosition(0)
	event.ObjsSetPos(1, -16.95, 0.2, 431.66)
	event.ObjsSetRot(1, 0.0, 1.19, 0.0)
	event.ObjsSetMotion(1, "のけぞりL", 4)
	event.ObjsResetDaPosition(1)
	event.ObjsSetPos(4, 4.86, 0.2, 441.28)
	event.ObjsSetRot(4, 0.0, -3.13, 0.0)
	event.ObjsResetDaPosition(4)
	event.ObjsSetMotion(4, "ジャンプ", 4)
	helper_a694495f(30)
	if vm.skipping() then
		return skip(16)
	end
	event.SndSePlay(var0, 4)
	event.ObjsMove(4, -4.5, 0.2, 273.3, 30)
	event.ObjsMotionDelay(4, 30)
	event.ObjsNextMotion(4, "石持ち立ち")
	event.ObjsSeDelay(4, 30)
	event.ObjsSePlay(4, var0, 5)
	event.ObjsSetMotion(0, "しまった！", 6)
	event.ObjsNextMotion(0, "しまった！L", 4)
	event.ObjsSetMotion(1, "目で追う", 6)
	event.ObjsNextMotion(1, "目で追うL", 4)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おこり顔")
	event.ObjsTexAnime(0, 1, "おこり目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "おこり顔")
	event.ObjsTexAnime(1, 1, "おこり目パチ")
	event.SetPakuAnim(0, "通常口パク")
	helper_568c(6120040, 45)
	if vm.skipping() then
		return skip(17)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_568c(6120050, 70)
	if vm.skipping() then
		return skip(18)
	end
	event.PlayBgm(0)
	event.CmrsSetPos(-33.83, 58.84, 228.9)
	event.CmrsSetRef(2.4, 12.62, 165.61)
	event.ObjsSetPos(4, -0.94, 0.2, 167.47)
	event.ObjsResetDaPosition(4)
	event.SndSePlay(var0, 6)
	event.ObjsSetMotion(4, "振り返る", 6)
	event.ObjsRotation(4, 0.0, -0.01, 0.0, 30)
	event.ObjsMotionDelay(4, 30)
	event.ObjsNextMotion(4, "石持ち立ち")
	helper_f2bfb50b(4)
	if vm.skipping() then
		return skip(19)
	end
	helper_a694495f(30)
	if vm.skipping() then
		return skip(20)
	end
	event.ObjsSetMotion(4, "不敵に笑う", 6)
	event.ObjsNextMotion(4, "不敵に笑うＬ", 4)
	event.ObjsMotionDelay(4, 60)
	event.ObjsNextMotion(4, "不敵に笑う戻り", 4)
	event.ObjsNextMotion(4, "石持ち立ち", 4)
	helper_568c(6120060, -1)
	if vm.skipping() then
		return skip(21)
	end
	helper_a694495f(30)
	if vm.skipping() then
		return skip(22)
	end
	helper_f2bfb50b(4)
	if vm.skipping() then
		return skip(23)
	end
	event.ObjsSetMotion(4, "石持ち会話", 6)
	event.ObjsNextMotion(4, "石持ち立ち", 4)
	helper_568c(6120065, -1)
	if vm.skipping() then
		return skip(24)
	end
	helper_f2bfb50b(4)
	if vm.skipping() then
		return skip(25)
	end
	event.CmrsSetPos(-1.12, 3.57, 211.52)
	event.CmrsSetRef(-1.09, 17.17, 165.43)
	event.ObjsSetMotion(4, "力を込める", 6)
	event.ObjsNextMotion(4, "力を込めるＬ", 4)
	helper_a694495f(60)
	if vm.skipping() then
		return skip(26)
	end
	event.CmrsSetPos(30.46, 10.46, 194.28)
	event.CmrsSetRef(-4.46, 14.37, 169.28)
	event.ObjsTexAnime(4, 0)
	event.ObjsTexAnime(4, 1, "こわれ目～赤目")
	event.EohSetShow(9, 1)
	event.ObjsSetMotion(4, "前傾姿勢", 6)
	event.ObjsNextMotion(4, "前傾姿勢Ｌ", 4)
	event.CharaActive(16)
	event.SetCharaShow(16, 1, 1, 0.033333335)
	event.ObjsSetPos(6, -0.95, 0.2, 164.64)
	event.ObjsSetMotion(6, "前傾姿勢Ｌ")
	event.CmrsQuake2(0.0, 0.2, 0.0, 360)
	event.SndSePlay(var0, 7)
	helper_568c(6120070, 60)
	if vm.skipping() then
		return skip(27)
	end
	event.ObjsSetRot(0, 0.0, -2.81, 0.0)
	event.ObjsSetMotion(0, "立ち", 4)
	event.ObjsResetDaPosition(0)
	event.ObjsSetRot(1, 0.0, 2.99, 0.0)
	event.ObjsSetMotion(1, "立ち", 4)
	event.ObjsResetDaPosition(1)
	helper_a694495f(60)
	if vm.skipping() then
		return skip(28)
	end
	event.SetCrossfade(30)
	event.CmrsSetPos(27.23, 15.0, 106.78)
	event.CmrsSetRef(5.4, 11.56, 187.66)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おこり顔")
	event.ObjsTexAnime(0, 1, "おこり目パチ")
	event.ObjsTexAnime(0, 1, "大口")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "おこり顔")
	event.ObjsTexAnime(1, 1, "おこり目パチ")
	event.ObjsTexAnime(1, 1, "大口")
	helper_a694495f(90)
	if vm.skipping() then
		return skip(29)
	end
	event.CmrsSetPos(1.44, 19.01, 221.87)
	event.CmrsSetRef(-0.86, 15.58, 174.12)
	event.ObjsSetMotion(6, "アトラミリア光る")
	helper_a694495f(60)
	if vm.skipping() then
		return skip(30)
	end
	event.CmrsSetPos(69.6, 17.0, 511.44)
	event.CmrsSetRef(42.17, 15.58, 462.62)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おこり顔")
	event.ObjsTexAnime(0, 1, "目とじ")
	event.ObjsTexAnime(0, 1, "半口")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "おこり顔")
	event.ObjsTexAnime(1, 1, "目とじ")
	event.ObjsSetMotion(6, "発光")
	event.ObjsSetStep(6, 0.2)
	helper_a694495f(15)
	if vm.skipping() then
		return skip(31)
	end
	event.ObjsMotionDelay(0, 30)
	event.ObjsSetMotion(0, "！！", 6)
	event.ObjsNextMotion(0, "！！L", 4)
	event.ObjsMotionDelay(1, 30)
	event.ObjsSetMotion(1, "まぶしい", 6)
	event.ObjsNextMotion(1, "まぶしいL", 4)
	helper_a694495f(15)
	if vm.skipping() then
		return skip(32)
	end
	helper_568c(6120080, 30)
	if vm.skipping() then
		return skip(33)
	end
	event.SetFadeOut(30, 255, 255, 255)
	helper_a694495f(30)
	if vm.skipping() then
		return skip(34)
	end
	event.FadeOutBgm(30)
	helper_a694495f(30)
	if vm.skipping() then
		return skip(35)
	end
	event.CharaActive(0, 14)
	event.CharaActive(0, 19)
	event.CharaActive(0, 12)
	event.CharaActive(0, 13)
	event.CharaActive(0, 16)
	event.CharaActive(15)
	event.ObjsSetPos(5, -0.95, 0.2, 164.64)
	event.CmrsSetPos(-1.32, 10.92, 232.98)
	event.CmrsSetRef(-1.51, 5.74, 176.6)
	event.ObjsSetMotion(5, "立ち（前傾）")
	helper_a694495f(30)
	if vm.skipping() then
		return skip(36)
	end
	event.SetFadeIn(30, 255, 255, 255)
	event.SndSePlay(var1, 0)
	event.CmrsMove2(-1.32, 10.92, 232.98, -1.51, 45.85, 176.6, 180, 0, 0.5)
	helper_daca499b()
	if vm.skipping() then
		return skip(37)
	end
	helper_a694495f(30)
	if vm.skipping() then
		return skip(38)
	end
	event.CmrsSetPos(83.44, 109.23, 85.27)
	event.CmrsSetRef(11.63, 44.02, 193.11)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おこり顔")
	event.ObjsTexAnime(0, 1, "おどろき目パチ")
	event.ObjsTexAnime(0, 1, "半口")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "おこり顔")
	event.ObjsTexAnime(1, 1, "おどろき目パチ")
	event.ObjsTexAnime(1, 1, "半口")
	event.ObjsSetPos(0, 16.61, 0.2, 323.16)
	event.ObjsSetRot(0, 0.0, -2.81, 0.0)
	event.ObjsSetMotion(0, "立ち", 4)
	event.ObjsResetDaPosition(0)
	event.ObjsSetPos(1, -19.07, 0.2, 324.55)
	event.ObjsSetRot(1, 0.0, 2.99, 0.0)
	event.ObjsSetMotion(1, "立ち", 4)
	event.ObjsResetDaPosition(1)
	event.ObjsSetMotion(5, "身を起こす", 6)
	event.ObjsNextMotion(5, "身を起こすＬ", 4)
	event.CmrsMove2(2.49, 42.34, 46.29, 5.69, 44.02, 193.66, 120, 0, 0.5)
	helper_568c(6120090, 180)
	if vm.skipping() then
		return skip(39)
	end
	helper_daca499b()
	if vm.skipping() then
		return skip(40)
	end
	event.CmrsSetPos(37.69, 39.48, 235.92)
	event.CmrsSetRef(-1.18, 50.99, 170.42)
	x = vm.f32(-22.54)
	y = vm.f32(20.9)
	z = vm.f32(332.85)
	do
		local out1, out2, out3 = event.SubVector(x, y, z, -8.96, 10.09, 279.73)
		x = out1 or x
		y = out2 or y
		z = out3 or z
	end
	event.SetWind(10, x, y, z)
	event.SetMotionBlur(100)
	event.SndSePlay(var0, 8)
	event.ObjsSetMotion(5, "開く", 6)
	event.ObjsNextMotion(5, "開くＬ", 4)
	event.CharaActive(18)
	event.ObjsMotionDelay(8, 40)
	event.ObjsSetMotion(8, "開くＬ", 6)
	event.ObjsSetMotion(0, "！！L", 4)
	event.ObjsSetMotion(1, "まぶしいL", 4)
	event.CmrsMove2(56.18, 9.11, 279.47, -1.71, 41.43, 163.58, 90, 0, 0.5)
	helper_daca499b()
	if vm.skipping() then
		return skip(41)
	end
	event.CmrsSetPos(-63.65, 24.75, 289.98)
	event.CmrsSetRef(19.98, 11.48, 346.64)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おこり顔")
	event.ObjsTexAnime(0, 1, "目とじ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "おこり顔")
	event.ObjsTexAnime(1, 1, "目とじ")
	event.ObjsSetMotion(5, "立ち", 4)
	helper_a694495f(60)
	if vm.skipping() then
		return skip(42)
	end
	event.CharaActive(0, 18)
	event.CmrsSetPos(45.23, 12.53, 223.31)
	event.CmrsSetRef(1.37, 42.75, 168.22)
	event.SetWind(-1)
	event.SetMotionBlur(0)
	event.ObjsSetMotion(0, "立ち", 4)
	event.ObjsSetMotion(1, "立ち", 4)
	event.ObjsSetMotion(5, "会話１")
	helper_568c(6120100, -1)
	if vm.skipping() then
		return skip(43)
	end
	helper_a694495f(60)
	if vm.skipping() then
		return skip(44)
	end
	helper_f2bfb50b(5)
	if vm.skipping() then
		return skip(45)
	end
	event.CmrsSetPos(-1.79, 7.56, 386.42)
	event.CmrsSetRef(-1.26, 25.12, 274.31)
	event.StopBgm(0)
	helper_a694495f(4)
	if vm.skipping() then
		return skip(46)
	end
	event.LoadBgm(167)
	event.PlayBgm(0)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おこり顔")
	event.ObjsTexAnime(0, 1, "おこり目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "おこり顔")
	event.ObjsTexAnime(1, 1, "おこり目パチ")
	event.ObjsSetMotion(5, "立ち１から立ち２", 6)
	event.ObjsNextMotion(5, "立ち2", 4)
	helper_6040(6120110)
	if vm.skipping() then
		return skip(47)
	end
	helper_f2bfb50b(5)
	if vm.skipping() then
		return skip(48)
	end
	event.CmrsSetPos(-49.43, 5.59, 296.0)
	event.CmrsSetRef(-7.47, 21.65, 323.75)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おこり顔")
	event.ObjsTexAnime(0, 1, "前～左～前")
	event.ObjsTexAnime(0, 1, "半口")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "おこり顔")
	event.ObjsTexAnime(1, 1, "おこり目パチ")
	event.SetPakuAnim(1, "通常口パク")
	helper_6040(6120120)
	if vm.skipping() then
		return skip(49)
	end
	event.ObjsSetMotion(1, "会話", 6)
	event.ObjsNextMotion(1, "立ち", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_6040(6120125)
	if vm.skipping() then
		return skip(50)
	end
	helper_f2bfb50b(1)
	if vm.skipping() then
		return skip(51)
	end
	event.CmrsSetPos(-1.79, 7.56, 386.42)
	event.CmrsSetRef(-1.26, 25.12, 274.31)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おこり顔")
	event.ObjsTexAnime(0, 1, "おこり目パチ")
	helper_6040(6120130)
	if vm.skipping() then
		return skip(52)
	end
	event.ObjsSetMotion(5, "会話２", 4)
	event.ObjsMotionDelay(5, 30)
	event.ObjsNextMotion(5, "立ち2", 4)
	helper_6040(6120135)
	if vm.skipping() then
		return skip(53)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_6040(6120140)
	if vm.skipping() then
		return skip(54)
	end
	helper_f2bfb50b(5)
	if vm.skipping() then
		return skip(55)
	end
	event.CmrsSetPos(45.23, 12.53, 223.31)
	event.CmrsSetRef(1.37, 42.75, 168.22)
	event.ObjsSetMotion(5, "会話２", 4)
	event.ObjsMotionDelay(5, 60)
	event.ObjsNextMotion(5, "立ち2", 4)
	helper_568c(6120150, 150)
	if vm.skipping() then
		return skip(56)
	end
	helper_f2bfb50b(5)
	if vm.skipping() then
		return skip(57)
	end
	event.CmrsSetPos(105.2, 163.52, 42.91)
	event.CmrsSetRef(-2.23, 23.98, 214.38)
	event.ObjsSetMotion(5, "会話２", 6)
	event.ObjsNextMotion(5, "立ち2", 4)
	helper_568c(6120160, 150)
	if vm.skipping() then
		return skip(58)
	end
	event.ObjsSetMotion(5, "立ち２から立ち１", 6)
	event.ObjsNextMotion(5, "立ち", 4)
	helper_568c(6120165, 240)
	if vm.skipping() then
		return skip(59)
	end
	helper_f2bfb50b(5)
	if vm.skipping() then
		return skip(60)
	end
	event.ObjsSetMotion(5, "立ち１から立ち２", 6)
	event.ObjsNextMotion(5, "立ち2", 4)
	event.SetCrossfade(30)
	event.CmrsSetPos(4.09, 53.77, 197.71)
	event.CmrsSetRef(12.21, 56.05, 168.85)
	event.ObjsSetMotion(5, "会話２")
	event.StreamOpen3(1, 6120170)
	helper_9329a84e(1)
	if vm.skipping() then
		return skip(61)
	end
	event.StreamPlay(1)
	event.CmrsMove(7.33, 53.77, 186.18, 12.21, 56.05, 168.85, 350)
	event.MesMake_2(0, 6120170)
	helper_872c66b5(0, -1, 8, 0, 0)
	while var6 < 350 do
		var7 = vm.f32(vm.f32(vm.f32(vm.f32(-224.90002) * var6) / 350) + vm.f32(524.9))
		event.SetProjection(var7)
		var6 = var6 + 1
		if vm.wait() then
			return skip(62)
		end
	end
	helper_06ab565c(0)
	event.StreamClose(1)
	helper_daca499b()
	if vm.skipping() then
		return skip(63)
	end
	event.SetProjection(524.9)
	event.SetCrossfade(30)
	event.CmrsSetPos(-26.16, 2.12, 260.08)
	event.CmrsSetRef(-0.76, 24.0, 324.82)
	event.ObjsSetMotion(5, "立ち2", 4)
	helper_568c(6120180, 240)
	if vm.skipping() then
		return skip(64)
	end
	event.SetCrossfade(30)
	event.CmrsSetPos(52.31, 50.13, 183.8)
	event.CmrsSetRef(-3.22, 50.82, 166.04)
	event.ObjsSetMotion(5, "会話２", 6)
	event.ObjsMotionDelay(5, 30)
	event.ObjsNextMotion(5, "立ち2", 4)
	helper_568c(6120185, 130)
	if vm.skipping() then
		return skip(65)
	end
	event.SetCrossfade(30)
	event.CmrsSetPos(0.43, 137.04, 56.89)
	event.CmrsSetRef(-1.45, 10.06, 253.11)
	event.SetPakuAnim(0, "通常口パク")
	helper_568c(6120190, 90)
	if vm.skipping() then
		return skip(66)
	end
	event.ObjsSetMotion(5, "立ち２から立ち１", 6)
	event.ObjsNextMotion(5, "立ち", 4)
	event.ObjsNextMotion(5, "会話１", 4)
	helper_568c(6120200, -1)
	if vm.skipping() then
		return skip(67)
	end
	helper_a694495f(15)
	if vm.skipping() then
		return skip(68)
	end
	helper_568c(6120205, -1)
	if vm.skipping() then
		return skip(69)
	end
	event.ObjsNextMotion(5, "立ち", 4)
	event.SetCrossfade(30)
	event.CmrsSetPos(43.9, 23.5, 203.81)
	event.CmrsSetRef(-3.91, 54.72, 160.7)
	helper_a694495f(30)
	if vm.skipping() then
		return skip(70)
	end
	event.SndSePlay(var0, 9)
	event.ObjsSetMotion(5, "握る", 6)
	event.ObjsNextMotion(5, "会話（握る）")
	event.ObjsMotionDelay(5, 180)
	event.ObjsNextMotion(5, "握るL", 4)
	helper_568c(6120210, -1)
	if vm.skipping() then
		return skip(71)
	end
	helper_a694495f(30)
	if vm.skipping() then
		return skip(72)
	end
	helper_f2bfb50b(5)
	if vm.skipping() then
		return skip(73)
	end
	event.ObjsMotionDelay(5, 40)
	event.ObjsSetMotion(5, "振り払う", 6)
	event.ObjsNextMotion(5, "会話（振り払う）", 4)
	event.ObjsMotionDelay(5, 90)
	event.ObjsSetMotion(5, "振り払うL")
	event.ObjsSeDelay(5, 40)
	event.ObjsSePlay(5, var0, 10)
	event.StreamOpen3(1, 6120220)
	helper_9329a84e(1)
	if vm.skipping() then
		return skip(74)
	end
	event.MesMake_2(0, 6120220)
	helper_872c66b5(0, -1, 8, 0, 0)
	event.StreamPlay(1)
	helper_a694495f(40)
	if vm.skipping() then
		return skip(75)
	end
	event.SetCrossfade(30)
	event.CmrsSetPos(0.88, 46.09, 208.27)
	event.CmrsSetRef(-1.11, 54.76, 161.71)
	helper_5c96a7ac(0, -1)
	if vm.skipping() then
		return skip(76)
	end
	helper_06ab565c(0)
	event.StreamClose(1)
	helper_f2bfb50b(5)
	if vm.skipping() then
		return skip(77)
	end
	helper_a694495f(30)
	if vm.skipping() then
		return skip(78)
	end
	event.SetCrossfade(30)
	event.CmrsSetPos(0.43, 137.04, 56.89)
	event.CmrsSetRef(-1.45, 10.06, 253.11)
	event.ObjsSetMotion(5, "立ち", 4)
	event.ObjsResetDaPosition(5)
	helper_a694495f(15)
	if vm.skipping() then
		return skip(79)
	end
	event.ObjsSetMotion(5, "立ち１から立ち２", 6)
	event.ObjsNextMotion(5, "立ち2", 4)
	helper_568c(6120230, -1)
	if vm.skipping() then
		return skip(80)
	end
	helper_f2bfb50b(5)
	if vm.skipping() then
		return skip(81)
	end
	helper_a694495f(50)
	if vm.skipping() then
		return skip(82)
	end
	event.SetCrossfade(30)
	event.CmrsSetPos(52.31, 50.13, 183.8)
	event.CmrsSetRef(-3.22, 50.82, 166.04)
	event.ObjsSetMotion(5, "会話２", 4)
	event.StreamOpen3(1, 6120240)
	helper_9329a84e(1)
	if vm.skipping() then
		return skip(83)
	end
	event.MesMake_2(0, 6120240)
	helper_872c66b5(0, -1, 8, 0, 0)
	event.StreamPlay(1)
	helper_a694495f(150)
	if vm.skipping() then
		return skip(84)
	end
	event.SetCrossfade(30)
	event.CmrsSetPos(-1.16, 53.95, 203.33)
	event.CmrsSetRef(-0.35, 56.22, 163.1)
	event.CmrsMove(-1.0, 53.95, 195.45, -0.35, 56.22, 163.1, 60)
	helper_5c96a7ac(0, -1)
	if vm.skipping() then
		return skip(85)
	end
	helper_06ab565c(0)
	event.StreamClose(1)
	event.ObjsNextMotion(5, "立ち2")
	helper_a694495f(90)
	if vm.skipping() then
		return skip(86)
	end
	event.SetCrossfade(30)
	event.CmrsSetPos(45.23, 12.53, 223.31)
	event.CmrsSetRef(1.37, 42.75, 168.22)
	event.ObjsSetMotion(5, "見上げ", 6)
	event.ObjsNextMotion(5, "見上げＬ", 4)
	helper_568c(6120250, -1)
	if vm.skipping() then
		return skip(87)
	end
	helper_f2bfb50b(5)
	if vm.skipping() then
		return skip(88)
	end
	helper_a694495f(60)
	if vm.skipping() then
		return skip(89)
	end
	event.CmrsSetPos(-41.31, 31.65, 268.93)
	event.CmrsSetRef(5.77, 11.37, 343.93)
	event.ObjsSetMotion(5, "立ち2", 4)
	event.ObjsSetMotion(1, "なに言ってるの？", 6)
	event.ObjsNextMotion(1, "立ち", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_568c(6120260, -1)
	if vm.skipping() then
		return skip(90)
	end
	helper_f2bfb50b(1)
	if vm.skipping() then
		return skip(91)
	end
	helper_a694495f(30)
	if vm.skipping() then
		return skip(92)
	end
	event.CmrsSetPos(-0.97, 16.6, 262.08)
	event.CmrsSetRef(-1.15, 60.73, 165.4)
	event.ObjsSetMotion(5, "会話２")
	helper_568c(6120270, -1)
	if vm.skipping() then
		return skip(93)
	end
	helper_a694495f(20)
	if vm.skipping() then
		return skip(94)
	end
	helper_568c(6120273, -1)
	if vm.skipping() then
		return skip(95)
	end
	helper_a694495f(50)
	if vm.skipping() then
		return skip(96)
	end
	helper_568c(6120277, -1)
	if vm.skipping() then
		return skip(97)
	end
	event.ObjsNextMotion(5, "立ち2", 4)
	helper_f2bfb50b(5)
	if vm.skipping() then
		return skip(98)
	end
	helper_a694495f(30)
	if vm.skipping() then
		return skip(99)
	end
	event.CmrsSetPos(146.05, 155.76, 44.66)
	event.CmrsSetRef(7.17, 5.69, 214.11)
	event.ObjsSetMotion(5, "見上げ", 6)
	event.ObjsNextMotion(5, "見上げＬ", 4)
	helper_568c(6120280, -1)
	if vm.skipping() then
		return skip(100)
	end
	helper_a694495f(40)
	if vm.skipping() then
		return skip(101)
	end
	helper_568c(6120285, -1)
	if vm.skipping() then
		return skip(102)
	end
	helper_a694495f(30)
	if vm.skipping() then
		return skip(103)
	end
	event.CmrsSetPos(6.43, 18.29, 287.68)
	event.CmrsSetRef(16.25, 19.34, 324.59)
	event.ObjsSetMotion(5, "立ち", 4)
	event.SndSePlay(var0, 11)
	event.ObjsSetMotion(0, "そんなこと", 6)
	event.ObjsNextMotion(0, "そんなことL", 4)
	event.ObjsMotionDelay(0, 45)
	event.ObjsSetMotion(0, "させない", 6)
	event.ObjsNextMotion(0, "させないL", 4)
	event.ObjsSeDelay(0, 70)
	event.ObjsSePlay(0, var0, 12)
	event.SetPakuAnim(0, "通常口パク")
	helper_568c(6120290, -1)
	if vm.skipping() then
		return skip(104)
	end
	helper_a694495f(30)
	if vm.skipping() then
		return skip(105)
	end
	event.CmrsSetPos(-6.44, 50.54, 216.04)
	event.CmrsSetRef(-1.0, 48.49, 160.07)
	event.ObjsSetMotion(0, "立ち", 4)
	event.ObjsSetMotion(1, "立ち", 4)
	event.ObjsSetMotion(5, "会話１", 4)
	helper_568c(6120300, -1)
	if vm.skipping() then
		return skip(106)
	end
	helper_a694495f(30)
	if vm.skipping() then
		return skip(107)
	end
	event.ObjsSetMotion(5, "指す", 2)
	event.ObjsNextMotion(5, "指す会話", 4)
	helper_568c(6120305, -1)
	if vm.skipping() then
		return skip(108)
	end
	event.ObjsNextMotion(5, "指すＬ", 4)
	helper_f2bfb50b(5)
	if vm.skipping() then
		return skip(109)
	end
	helper_a694495f(20)
	if vm.skipping() then
		return skip(110)
	end
	event.ObjsSetMotion(5, "握る２", 6)
	event.ObjsNextMotion(5, "会話（握る２）", 4)
	event.ObjsMotionDelay(5, 180)
	event.ObjsSetMotion(5, "振り払う（握る2）", 6)
	event.ObjsSetMotion(5, "振り払うＬ（握る2）")
	event.ObjsSeDelay(5, 200)
	event.ObjsSePlay(5, var0, 10)
	helper_568c(6120310, -1)
	if vm.skipping() then
		return skip(111)
	end
	helper_f2bfb50b(5)
	if vm.skipping() then
		return skip(112)
	end
	helper_a694495f(30)
	if vm.skipping() then
		return skip(113)
	end
	event.CmrsSetPos(-1.79, 7.56, 386.42)
	event.CmrsSetRef(-1.26, 25.12, 274.31)
	event.ObjsSetMotion(5, "立ち2", 4)
	event.ObjsResetDaPosition(5)
	helper_a694495f(20)
	if vm.skipping() then
		return skip(114)
	end
	event.ObjsSetMotion(5, "会話２", 4)
	helper_568c(6120320, -1)
	if vm.skipping() then
		return skip(115)
	end
	event.ObjsNextMotion(5, "立ち2")
	helper_a694495f(20)
	if vm.skipping() then
		return skip(116)
	end
	event.CmrsSetPos(22.17, 49.65, 213.77)
	event.CmrsSetRef(-1.95, 51.8, 171.81)
	event.ObjsSetMotion(5, "会話２", 4)
	helper_568c(6120323, -1)
	if vm.skipping() then
		return skip(117)
	end
	event.ObjsNextMotion(5, "立ち2")
	helper_a694495f(20)
	if vm.skipping() then
		return skip(118)
	end
	event.ObjsSetMotion(5, "両手ゆっくり", 6)
	event.ObjsNextMotion(5, "両手ゆっくりＬ", 4)
	helper_568c(6120327, -1)
	if vm.skipping() then
		return skip(119)
	end
	helper_f2bfb50b(5)
	if vm.skipping() then
		return skip(120)
	end
	event.CmrsSetPos(27.8, 20.33, 262.64)
	event.CmrsSetRef(4.57, 15.57, 325.51)
	helper_a694495f(15)
	if vm.skipping() then
		return skip(121)
	end
	event.ObjsSetMotion(0, "かまえる", 6)
	event.ObjsNextMotion(0, "かまえるL", 4)
	event.ObjsMotionDelay(1, 5)
	event.ObjsSetMotion(1, "身構え", 6)
	event.ObjsNextMotion(1, "身構えL", 4)
	helper_a694495f(60)
	if vm.skipping() then
		return skip(122)
	end
	event.CmrsSetPos(17.33, 128.97, 230.66)
	event.CmrsSetRef(0.33, 49.98, 168.45)
	event.CharaActive(17)
	event.SetCharaShow(17, 1, 1, 0.033333335)
	event.ObjsSetPos(7, -0.95, 0.2, 164.64)
	event.SndSePlay(var0, 13)
	event.ObjsSetMotion(5, "天に", 6)
	event.ObjsNextMotion(5, "天にＬ", 4)
	event.SndSePlay(var0, 14)
	event.SndSePlay(var0, 15)
	helper_a694495f(30)
	if vm.skipping() then
		return skip(123)
	end
	event.CmrsQuake2(0.0, 0.3, 0.0, -1)
	event.SndSePlay(var0, 16)
	helper_a694495f(30)
	if vm.skipping() then
		return skip(124)
	end
	event.CmrsSetPos(-6.24, 49.19, 375.53)
	event.CmrsSetRef(-1.83, 51.77, 225.87)
	helper_a694495f(90)
	if vm.skipping() then
		return skip(125)
	end
	event.CmrsSetPos(-31.26, 4.98, 277.65)
	event.CmrsSetRef(0.45, 22.39, 330.46)
	event.ObjsSetMotion(0, "びっくり", 6)
	event.ObjsNextMotion(0, "びっくりL", 4)
	event.ObjsMotionDelay(1, 5)
	event.ObjsSetMotion(1, "ぐらり", 6)
	event.ObjsNextMotion(1, "ぐらりL", 4)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おどろき顔")
	event.ObjsTexAnime(0, 1, "おどろき目パチ")
	event.ObjsTexAnime(0, 1, "大口")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "おどろき顔")
	event.ObjsTexAnime(1, 1, "おどろき目パチ")
	event.ObjsTexAnime(1, 1, "大口")
	helper_a694495f(90)
	if vm.skipping() then
		return skip(126)
	end
	event.CmrsSetPos(57.69, 37.12, 273.28)
	event.CmrsSetRef(0.0, 49.89, 171.27)
	helper_a694495f(60)
	if vm.skipping() then
		return skip(127)
	end
	event.CmrsSetPos(-28.88, 35.65, 295.17)
	event.CmrsSetRef(-16.06, 17.38, 336.62)
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "おこり顔")
	event.ObjsTexAnime(1, 1, "おこり目パチ")
	event.SetPakuAnim(1, "通常口パク")
	helper_568c(6120330, -1)
	if vm.skipping() then
		return skip(128)
	end
	event.FadeOutBgm(30)
	event.SetFadeOut(30)
	helper_a694495f(30)
	if vm.skipping() then
		return skip(129)
	end
	return part2()
end

--- Helper function.
local function helper_2462c()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 17 then
			if at <= 1 then
				helper_a694495f(60)
			end
			if at <= 2 then
				helper_568c(6120340, -1)
			end
			if at <= 3 then
				helper_f2bfb50b(2)
			end
			if at <= 4 then
				helper_a694495f(30)
			end
			if at <= 5 then
				helper_568c(6120350, -1)
			end
			if at <= 6 then
				helper_a694495f(30)
			end
			if at <= 7 then
				helper_568c(6120360, -1)
			end
			if at <= 8 then
				helper_f2bfb50b(2)
			end
			if at <= 9 then
				helper_568c(6120365, -1)
			end
			if at <= 10 then
				helper_f2bfb50b(2)
			end
			if at <= 11 then
				helper_a694495f(90)
			end
			if at <= 12 then
				helper_a694495f(90)
			end
			if at <= 13 then
				helper_568c(6120370, 45)
			end
			if at <= 14 then
				helper_568c(6120380, -1)
			end
			if at <= 15 then
				helper_a694495f(90)
			end
			if at <= 16 then
				helper_a694495f(30)
			end
			if vm.skip_end() then
				return skip(18)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.CmrsInit()
		event.BgmLoadCancel()
		event.SndSeStop(var0, 2)
		event.SndSeStop(var0, 3)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.DelExtMotion(0)
		event.DeleteChara(8)
		event.DeleteChara(9)
		event.DeleteChara(10)
		event.DeleteChara(13)
		event.LoadMes(0, -1)
		event.SetCharaShow(1, 1)
		event.SetCharaShow(2, 1)
		event.CharaActive(0)
		event.SetCharaPos(0, -1.02, 0.2, 111.04)
		event.SetCharaRot(0, 0.0, 3.11, 0.0)
		event.SetMotion(0, "立ち", 4)
		event.CharaNormalDrive(0)
		event.CharaResetDa(0)
		event.ResetCamera(1, 3.1415927, 10.0)
	end
	event.SetFlag(612, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.LoadSound(7812)
	var0 = event.SndLoadSound(7812) or var0
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.ChangeDir("event/e600/e612/")
	event.LoadMes(0, 5, "e612.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e612_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e612_monica.gltf", "info", 0)
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
		event.LoadMotion(5, "event/e600/e608/e608_mints.gltf", "info", 8)
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
		event.LoadMotion(5, "event/e600/e612/e612_monica.gltf", "info", 8)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 8)
		event.EohSyncChara(1, 8)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 0)
	end
	event.CharaActive(8)
	event.CharaActive(9)
	event.LoadChara(5, "event/e600/e612/e612_griffon.gltf", "info", 10)
	event.CharaActive(10)
	event.EohSyncChara(2, 10)
	event.ObjsInit(2, 10)
	event.ObjsSyncObj(2, 2)
	event.LoadChara(5, "event/e600/e612/e612_ghikari.gltf", "info", 13)
	event.CharaActive(13)
	event.EohSyncChara(5, 13)
	event.ObjsInit(5, 13)
	event.ObjsSyncObj(5, 5)
	event.SetCharaShow(1, 0)
	event.SetCharaShow(2, 0)
	event.EohSetPos(0, 16.61, 0.2, 323.16)
	event.EohSetRot(0, 0.0, 3.11, 0.0)
	event.EohSetMotion(0, "かまえるL", 4)
	event.EohSetFootSoundId(0, 4)
	event.EohSetPos(1, -19.07, 0.2, 324.55)
	event.EohSetRot(1, 0.0, 2.99, 0.0)
	event.EohSetMotion(1, "身構えL", 4)
	event.EohSetFootSoundId(1, 4)
	event.EohSetPos(2, -0.95, 0.2, 164.64)
	event.EohSetRot(2, 0.0, 0.0, 0.0)
	event.EohSetMotion(2, "両手上げＬ", 4)
	event.EohSetFootSoundId(2, 4)
	event.InitDramaScene()
	event.CmrsInit()
	event.CmrsSetPos(290.66, 22.4, 159.89)
	event.CmrsSetRef(-25.29, 32.09, 238.0)
	event.CharaActive(0)
	event.CharaActive(8)
	event.CharaActive(9)
	event.CharaActive(10)
	event.CharaActive(0, 13)
	event.SetFadeIn(30)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おこり顔")
	event.ObjsTexAnime(0, 1, "おこり目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "おこり顔")
	event.ObjsTexAnime(1, 1, "おこり目パチ")
	helper_a694495f(30)
	if vm.skipping() then
		return skip(1)
	end
	event.SndSePlay(var0, 0)
	event.ObjsSetMotion(2, "両手下ろす", 6)
	event.ObjsNextMotion(2, "立ち", 4)
	helper_a694495f(60)
	if vm.skipping() then
		return skip(2)
	end
	event.CmrsSetPos(27.47, 43.98, 229.92)
	event.CmrsSetRef(-0.83, 51.54, 164.19)
	event.ObjsSetMotion(2, "すばらしい", 4)
	event.ObjsMotionDelay(2, 120)
	event.ObjsNextMotion(2, "すばらしいＬ", 4)
	helper_568c(6120340, -1)
	if vm.skipping() then
		return skip(3)
	end
	helper_f2bfb50b(2)
	if vm.skipping() then
		return skip(4)
	end
	helper_a694495f(30)
	if vm.skipping() then
		return skip(5)
	end
	event.CmrsSetPos(75.01, 95.44, 105.8)
	event.CmrsSetRef(-40.9, 14.77, 261.94)
	event.ObjsSetMotion(2, "立ち2", 4)
	event.SndSePlay(var0, 1)
	event.ObjsSetMotion(1, "何をした？", 6)
	event.ObjsNextMotion(1, "身構えL", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_568c(6120350, -1)
	if vm.skipping() then
		return skip(6)
	end
	helper_a694495f(30)
	if vm.skipping() then
		return skip(7)
	end
	event.ObjsSetMotion(2, "会話２", 6)
	event.ObjsMotionDelay(2, 60)
	event.ObjsNextMotion(2, "立ち2", 4)
	helper_568c(6120360, -1)
	if vm.skipping() then
		return skip(8)
	end
	helper_f2bfb50b(2)
	if vm.skipping() then
		return skip(9)
	end
	event.CmrsSetPos(-0.97, 16.6, 262.08)
	event.CmrsSetRef(-1.15, 60.73, 165.4)
	event.ObjsSetMotion(2, "会話２")
	event.ObjsMotionDelay(2, 240)
	event.ObjsNextMotion(2, "立ち2", 4)
	helper_568c(6120365, -1)
	if vm.skipping() then
		return skip(10)
	end
	helper_f2bfb50b(2)
	if vm.skipping() then
		return skip(11)
	end
	event.CmrsSetPos(17.77, 47.61, 211.35)
	event.CmrsSetRef(-1.62, 53.0, 164.21)
	event.CharaActive(13)
	event.SetCharaShow(13, 1, 1, 0.033333335)
	event.ObjsSetPos(5, -0.95, 0.2, 164.64)
	event.SndSePlay(var0, 2)
	event.ObjsSetMotion(2, "両手上げ", 6)
	event.ObjsNextMotion(2, "両手上げＬ", 4)
	helper_a694495f(90)
	if vm.skipping() then
		return skip(12)
	end
	event.CmrsSetPos(-10.24, 9.39, 285.55)
	event.CmrsSetRef(3.63, 24.57, 346.84)
	event.ObjsSetPos(0, 10.93, 0.2, 329.45)
	event.ObjsSetRot(0, 0.0, -3.05, 0.0)
	event.ObjsResetDaPosition(0)
	event.ObjsSetPos(1, -10.84, 0.2, 327.13)
	event.ObjsSetRot(1, 0.0, 2.99, 0.0)
	event.ObjsResetDaPosition(1)
	event.CmrsQuake2(0.0, 0.2, 0.2, -1)
	event.SndSePlay(var0, 3)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おどろき顔")
	event.ObjsTexAnime(0, 1, "おどろき目パチ")
	event.ObjsTexAnime(0, 1, "大口")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "おどろき顔")
	event.ObjsTexAnime(1, 1, "おどろき目パチ")
	event.ObjsTexAnime(1, 1, "大口")
	event.ObjsSetMotion(0, "びっくり", 6)
	event.ObjsNextMotion(0, "びっくりL", 4)
	event.ObjsMotionDelay(1, 5)
	event.ObjsSetMotion(1, "ぐらり", 6)
	event.ObjsNextMotion(1, "ぐらりL", 4)
	helper_a694495f(90)
	if vm.skipping() then
		return skip(13)
	end
	event.CmrsSetPos(30.72, 20.08, 266.27)
	event.CmrsSetRef(-3.69, 16.93, 344.36)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おこり顔")
	event.ObjsTexAnime(0, 1, "おこり目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "おこり顔")
	event.ObjsTexAnime(1, 1, "おこり目パチ")
	event.ObjsSetMotion(0, "びっくりキョロキョロ", 6)
	event.ObjsNextMotion(0, "びっくりL", 4)
	event.ObjsMotionDelay(1, 30)
	event.ObjsSetMotion(1, "きょろきょろ", 6)
	event.ObjsNextMotion(1, "ぐらりL", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_568c(6120370, 45)
	if vm.skipping() then
		return skip(14)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_568c(6120380, -1)
	if vm.skipping() then
		return skip(15)
	end
	event.CmrsSetPos(30.39, 12.88, 208.54)
	event.CmrsSetRef(-1.44, 44.98, 166.69)
	helper_a694495f(90)
	if vm.skipping() then
		return skip(16)
	end
	event.SetFadeOut(30)
	helper_a694495f(30)
	if vm.skipping() then
		return skip(17)
	end
	return part2()
end

--- Helper function.
local function helper_274c8()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 12 then
			if at <= 1 then
				helper_568c(6120390, -1)
			end
			if at <= 2 then
				helper_a694495f(60)
			end
			if at <= 3 then
				helper_568c(6120400, -1)
			end
			if at <= 4 then
				helper_a694495f(30)
			end
			if at <= 5 then
				helper_568c(6120410, -1)
			end
			if at <= 6 then
				helper_f2bfb50b(2)
			end
			if at <= 7 then
				helper_a694495f(20)
			end
			if at <= 8 then
				helper_568c(6120415, -1)
			end
			if at <= 9 then
				helper_f2bfb50b(2)
			end
			if at <= 10 then
				helper_a694495f(30)
			end
			if at <= 11 then
				helper_a694495f(30)
			end
			if vm.skip_end() then
				return skip(13)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.DelExtMotion(0)
		event.DeleteChara(8)
		event.DeleteChara(9)
		event.DeleteChara(10)
		event.LoadMes(0, -1)
		event.SetCharaShow(1, 1)
		event.SetCharaShow(2, 1)
		event.SetStatusbarShow(1, 1.0)
	end
	event.SetFlag(612, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.LoadSound(7814)
	var0 = event.SndLoadSound(7814) or var0
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.ChangeDir("event/e600/e612/")
	event.LoadMes(0, 5, "e612.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e612_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e612_monica.gltf", "info", 0)
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
		event.LoadMotion(5, "event/e600/e608/e608_mints.gltf", "info", 8)
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
		event.LoadMotion(5, "event/e600/e612/e612_monica.gltf", "info", 8)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 8)
		event.EohSyncChara(1, 8)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 0)
	end
	event.CharaActive(8)
	event.CharaActive(9)
	event.LoadChara(5, "event/e600/e612/e612_griffon.gltf", "info", 10)
	event.CharaActive(10)
	event.EohSyncChara(2, 10)
	event.ObjsInit(2, 10)
	event.ObjsSyncObj(2, 2)
	event.SetCharaShow(1, 0)
	event.SetCharaShow(2, 0)
	event.EohSetPos(0, 10.61, 0.2, 323.16)
	event.EohSetRot(0, 0.0, -2.93, 0.0)
	event.EohSetMotion(0, "立ち", 4)
	event.EohSetFootSoundId(0, 21)
	event.EohSetPos(1, -10.07, 0.2, 324.55)
	event.EohSetRot(1, 0.0, 3.11, 0.0)
	event.EohSetMotion(1, "立ち", 4)
	event.EohSetFootSoundId(1, 21)
	event.EohSetPos(2, -0.95, 0.2, 164.64)
	event.EohSetRot(2, 0.0, 0.0, 0.0)
	event.EohSetMotion(2, "両手上げＬ", 4)
	event.EohSetFootSoundId(2, 21)
	event.InitDramaScene()
	event.CmrsInit()
	event.CmrsSetPos(0.19, 19.21, 277.15)
	event.CmrsSetRef(-0.04, 20.06, 325.14)
	event.CharaActive(0)
	event.CharaActive(8)
	event.CharaActive(9)
	event.CharaActive(10)
	event.SetFadeIn(30)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おこり顔")
	event.ObjsTexAnime(0, 1, "おこり目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "おこり顔")
	event.ObjsTexAnime(1, 1, "おこり目～おどろき目")
	event.ObjsTexAnime(1, 1, "半口")
	helper_a694495f(30)
	if vm.skipping() then
		return skip(1)
	end
	event.SetPakuAnim(0, "通常口パク")
	helper_568c(6120390, -1)
	if vm.skipping() then
		return skip(2)
	end
	helper_a694495f(60)
	if vm.skipping() then
		return skip(3)
	end
	event.CmrsSetPos(-0.94, 45.01, 219.98)
	event.CmrsSetRef(-0.16, 52.54, 162.81)
	event.SndSePlay(var0, 0)
	event.ObjsSetMotion(2, "両手下ろす", 6)
	event.ObjsNextMotion(2, "立ち", 4)
	helper_568c(6120400, -1)
	if vm.skipping() then
		return skip(4)
	end
	helper_a694495f(30)
	if vm.skipping() then
		return skip(5)
	end
	event.ObjsSetMotion(2, "ククク", 6)
	event.ObjsNextMotion(2, "ククク会話", 4)
	helper_568c(6120410, -1)
	if vm.skipping() then
		return skip(6)
	end
	helper_f2bfb50b(2)
	if vm.skipping() then
		return skip(7)
	end
	helper_a694495f(20)
	if vm.skipping() then
		return skip(8)
	end
	event.ObjsSetMotion(2, "ククク会話")
	event.ObjsMotionDelay(2, 90)
	event.ObjsNextMotion(2, "クククＬ", 4)
	helper_568c(6120415, -1)
	if vm.skipping() then
		return skip(9)
	end
	helper_f2bfb50b(2)
	if vm.skipping() then
		return skip(10)
	end
	event.ObjsSetRot(0, 0.0, 0.0, 0.0)
	event.ObjsSetRot(1, 0.0, 0.0, 0.0)
	event.CmrsSetPos(1.81, 6.92, 260.18)
	event.CmrsSetRef(1.38, 17.89, 324.46)
	event.ObjsSetMotion(0, "走り", 4)
	event.ObjsMove(0, 12.18, 0.2, 569.18, 60, 1)
	event.ObjsSetMotion(1, "走り", 4)
	event.ObjsMove(1, -11.66, 0.2, 564.61, 60, 1)
	helper_a694495f(30)
	if vm.skipping() then
		return skip(11)
	end
	event.SetFadeOut(30)
	helper_a694495f(30)
	if vm.skipping() then
		return skip(12)
	end
	return part2()
end

--- Helper function.
local function helper_60f0(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_9329a84e(1)
		end
		if at <= 2 then
			helper_5c96a7ac(0, arg1)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.StreamOpen3(1, arg0)
	helper_9329a84e(1)
	if vm.skipping() then
		return skip(2)
	end
	event.StreamPlay(1)
	helper_5c96a7ac(0, arg1)
	if vm.skipping() then
		return skip(3)
	end
	event.StreamClose(1)
end

--- Helper function.
local function helper_ca80(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_c3a08f7f(1, 4)
			helper_8588(1, vm.i32(60 + arg0), 8, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(1, 4)
	helper_c3a08f7f(1, 4)
	helper_8588(1, vm.i32(60 + arg0), 8, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_df8c(arg0: s32, arg1: s32)
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
				helper_a694495f(30)
			end
			if at <= 2 then
				helper_1406a200()
			end
			if at <= 3 then
				helper_a694495f(30)
			end
			if at <= 4 then
				helper_60f0(arg1, -1)
			end
			if at <= 5 then
				helper_a694495f(10)
			end
			if at <= 6 then
				helper_a694495f(30)
			end
			if at <= 7 then
				helper_a694495f(120)
			end
			if at <= 8 then
				local _ = helper_20fe46f0(0)
			end
			if at <= 9 then
				helper_ca80(1)
			end
			if at <= 10 then
				helper_ca80(4)
			end
			if at <= 11 then
				helper_ca80(active_chr_no)
			end
			if at <= 12 then
				helper_ca80(1)
			end
			if at <= 13 then
				helper_a694495f(30)
			end
			if at <= 15 then
				helper_a694495f(30)
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
	helper_a694495f(30)
	if vm.skipping() then
		return skip(2)
	end
	event.SetStatusbarShow(0, 0.06666667)
	helper_1406a200()
	if vm.skipping() then
		return skip(3)
	end
	event.LoadBgmPack(60)
	if var8 == 1 or var8 ~= 1 and arg1 < 0 then
		event.PlayBgm(0)
	end
	helper_a694495f(30)
	if vm.skipping() then
		return skip(4)
	end
	event.DngPause(1, 1)
	event.DngCollisionAllClr()
	if var8 ~= 1 then
		block = event.LoadImg_4(5, "textures/dungeon/image/gameover.json", 1) or block
		if arg1 >= 0 then
			helper_60f0(arg1, -1)
			if vm.skipping() then
				return skip(5)
			end
			helper_a694495f(10)
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
		helper_a694495f(30)
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
		helper_a694495f(120)
		if vm.skipping() then
			return skip(8)
		end
		while true do
			if helper_20fe46f0(0) ~= 0 then
				break
			end
			if vm.wait() then
				return skip(9)
			end
		end
	elseif active_chr_no == 3 then
		var10 = event.CheckEnableCharaChange(1) or var10
		if var10 == 0 then
			helper_ca80(1)
			if vm.skipping() then
				return skip(10)
			end
		else
			helper_ca80(4)
			if vm.skipping() then
				return skip(11)
			end
		end
	elseif active_chr_no == 0 or active_chr_no == 2 then
		helper_ca80(active_chr_no)
		if vm.skipping() then
			return skip(12)
		end
	else
		helper_ca80(1)
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
		helper_a694495f(30)
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
		helper_a694495f(30)
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
	helper_a694495f(4)
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
local function helper_102f0(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		return helper_df8c(arg0, arg1)
	end
	if vm.skipping() then
		return skip(1)
	end
	return helper_df8c(arg0, arg1)
end

--- Helper function.
local function helper_10258(arg0: s32)
	return helper_df8c(arg0, -1)
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

script[99] = program_99

--- Program 100.
script[100] = function()
	local mc_load: s32 = 0
	local flag: s32 = 0
	local old_map_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		helper_193c(vm.f32(649.7), 0.0, vm.f32(-122.2), vm.f32(1.71))
	end
	program_99()
	mc_load = event.CheckMcLoad() or mc_load
	if mc_load == 1 then
		helper_193c(20.0, 280.0, -600.0, vm.f32(3.14))
		event.ResetCamera(1, 3.14, 10.0)
		event.SetFadeIn(30)
	else
		flag = event.GetFlag(702) or flag
		if flag == 0 then
			helper_29220()
			if vm.skipping() then
				return skip(1)
			end
			helper_193c(vm.f32(649.7), 0.0, vm.f32(-122.2), vm.f32(1.71))
			event.ResetCamera(1, 3.14, 0.0)
			event.SetFadeIn(30)
			return
		end
		old_map_no = event.GetOldMapNo() or old_map_no
		var3 = event.GetMapType(old_map_no) or var3
		if var3 ~= -1 then
			if old_map_no == 128 or var3 == 7 or var3 == 8 then
				helper_193c(0.0, 280.0, -650.0, 0.0)
				event.ResetCamera(1, 3.14, 10.0)
				event.SetFadeIn(30)
			else
				helper_193c(0.0, 0.0, 600.0, vm.f32(3.14))
				event.ResetCamera(1, 3.14, 10.0)
				event.SetFadeIn(30)
			end
		end
	end
end

--- Program 150.
-- Defined empty, so the engine runs this instead of its default.
script[150] = function() end

--- Program 151.
script[151] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_a694495f(4)
		end
	end
	event.Initialize()
	if vm.wait() then
		return skip(1)
	end
	event.StopBgm(0)
	helper_a694495f(4)
	if vm.skipping() then
		return skip(2)
	end
	event.LoadBgm(36)
	event.PlayBgm(0)
	event.EohSyncObj(0, "p05_d06e01-0")
	event.EohSetShow(0, 1)
	event.SetFadeIn(30)
	event.LoadMonsterFile(515, 1)
	event.AutoSetMonster(515, 0.4, 62.5, -115.7, 0.0, 0.0, 0.0)
	event.Finish()
end

--- Program 152.
script[152] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_8588(0, -1, 8, 0, 0)
		end
		if at <= 2 then
			helper_a694495f(30)
		end
	end
	event.Initialize()
	if vm.wait() then
		return skip(1)
	end
	event.DngPause(15, 1)
	event.SpriteInit(0)
	event.SpriteSetType(0, 0)
	event.SpriteSetPos(0, 256, 208)
	event.SpriteSetPutsize(0, 512, 416)
	event.SpriteSetColor(0, 0, 0, 0, 128)
	event.SpriteSetDraw(0, 0)
	event.EohSyncSprite(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetColor(0, 128.0, 128.0, 128.0, 0.0, 30)
	event.SpriteSetDraw(0, 1)
	event.ObjsSetColor(0, 0.0, 0.0, 0.0, 128.0)
	event.SetMesWindowMode(0, 7)
	event.SetFadeIn(15)
	event.MesMake_2(0, "e610『グリフォンの言い分』")
	helper_8588(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.ObjsSetColor(0, 0.0, 0.0, 0.0, 0.0, 30)
	helper_a694495f(30)
	if vm.skipping() then
		return skip(3)
	end
	event.SpriteSetDraw(0, 0)
	event.DngPause(15, 0)
	event.Finish()
end

--- Program 153.
script[153] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_8588(0, -1, 8, 0, 0)
		end
	end
	event.Initialize()
	if vm.wait() then
		return skip(1)
	end
	event.SetMesWindowMode(0, 7)
	event.SetFadeIn(15)
	event.MesMake_2(0, "勝利")
	helper_8588(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.Finish()
end

--- Program 154.
script[154] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	if vm.wait() then
		return skip(1)
	end
	event.AddItem(19, 1)
	event.AddItem(8, 1)
	event.AddItem(30, 1)
	event.AddItem(33, 1)
	event.AddItem(38, 1)
	event.AddItem(77, 1)
	event.AddItem(80, 1)
	event.AddItem(59, 1)
	event.AddItem(87, 1)
	event.AddItem(55, 1)
	event.AddItem(72, 1)
	event.AddItem(84, 1)
	event.AddItem(63, 1)
	event.AddItem(107, 1)
	event.AddItem(96, 1)
	event.AddItem(99, 1)
	event.AddItem(105, 1)
	event.Finish()
end

--- Program 155.
script[155] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_92234a24(32)
		end
	end
	if vm.wait() then
		return skip(1)
	end
	helper_92234a24(32)
	if vm.skipping() then
		return skip(2)
	end
end

--- Program 160.
script[160] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_92234a24(32)
		end
	end
	event.SetCameraPos(0.0, 0.0, 0.0)
	event.SetCameraRef(0.0, 0.0, 0.0)
	if vm.wait() then
		return skip(1)
	end
	helper_92234a24(32)
	if vm.skipping() then
		return skip(2)
	end
end

--- Program 200.
script[200] = function()
	local argc: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			local _ = helper_2d6d4()
		end
	end
	argc = event.GetNowLoopNo() or argc
	if argc == 1 then
		local t0 = helper_2d518()
		if vm.skipping() then
			return skip(1)
		end
		if t0 ~= 0 then
			event.MapJump(-1, "g05")
			if vm.wait() then
				return skip(2)
			end
		end
	else
		local t1 = helper_2d6d4()
		if vm.skipping() then
			return skip(3)
		end
		if t1 ~= 0 then
			event.SetBitCtrl(1, 0)
			event.GotoEdit(177, 100)
		end
	end
end

--- Program 210.
script[210] = function()
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	local t0 = helper_2dafc()
	if vm.skipping() then
		return skip(1)
	end
	if t0 ~= 0 then
		event.DngSetStageId(5)
		event.GotoMenu(3, 5)
		if vm.wait() then
			return skip(2)
		end
		do
			local _, _, out3, _ = event.GetMenuParam_4()
			var2 = out3 or var2
		end
		if var2 == 0 then
			event.SetFadeIn(30)
			return
		else
			if var2 == 26 then
				event.BgmLoadCancel()
			end
			event.GotoDng(5, var2, 1010)
		end
	end
end

--- Program 400.
script[400] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_1037c()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 401.
script[401] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_2eddc(0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 402.
script[402] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_2eddc(1)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 403.
script[403] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_2eddc(2)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 404.
script[404] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_2eddc(3)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 405.
script[405] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_2eddc(4)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 406.
script[406] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_2eddc(5)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 407.
script[407] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_2eddc(6)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 408.
script[408] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_2eddc(7)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 500.
script[500] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_2dd08()
		end
		helper_193c(0.0, 0.0, 600.0, vm.f32(3.14))
	end
	helper_104f0()
	if vm.skipping() then
		return skip(1)
	end
	event.FuncPointShow("", "exit", 0)
	event.FuncPointShow("", "in_dng", 0)
	helper_2dd08()
	event.SetBitCtrl(1, 1)
	if vm.wait() then
		return skip(2)
	end
	event.EohSyncObj(0, "p05_d06e01-0")
	event.EohSetShow(0, 1)
	event.LoadMonsterFile(515, 1)
	event.AutoSetMonster(515, 0.4, 62.5, -115.7, 0.0, 0.0, 0.0)
	helper_193c(0.0, 0.0, 600.0, vm.f32(3.14))
	event.SetCameraRef(0.0, 30.0, 600.0)
	event.SetCameraPos(0.0, 40.0, 720.0)
	event.ResetCamera(0)
	event.SetFadeIn(20)
	event.Finish()
end

--- Program 502.
script[502] = function()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_15394()
			if not vm.skipping() then
				return part2()
			end
		end
	end
	function part2()
		event.SetCharaPos(0, var0, var1, var2)
		event.SetCharaRot(0, var3, var4, var5)
		event.SetCameraPos(pos_x, pos_y, pos_z)
		event.SetCameraRef(pos_x_2, pos_y_2, pos_z_2)
		event.ResetCamera(0)
		event.DngPause(1041, 0)
		event.SetFadeIn(10)
		event.Finish()
	end
	event.Initialize()
	event.ActchrSetDefMotion(0)
	event.SetFadeOut(10)
	helper_a694495f(10)
	if vm.skipping() then
		return skip(1)
	end
	event.SndSeAllStop(5)
	event.DngPause(1041, 1)
	event.DngEffectAllClear()
	do
		local out1, out2, out3 = event.GetCharaPos(0)
		var0 = out1 or var0
		var1 = out2 or var1
		var2 = out3 or var2
	end
	do
		local out1, out2, out3 = event.GetCharaRot(0)
		var3 = out1 or var3
		var4 = out2 or var4
		var5 = out3 or var5
	end
	do
		local out1, out2, out3 = event.GetCameraPos()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local out1, out2, out3 = event.GetCameraRef()
		pos_x_2 = out1 or pos_x_2
		pos_y_2 = out2 or pos_y_2
		pos_z_2 = out3 or pos_z_2
	end
	helper_15394()
	if vm.skipping() then
		return skip(2)
	end
	return part2()
end

--- Program 504.
script[504] = function()
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_18964()
			if not vm.skipping() then
				return part2()
			end
		end
	end
	function part2()
		event.SetBitCtrl(8, 1)
		event.LoadDungeonMapFile("s31")
		event.LoadScript("s31/s31.stb", 510)
		if vm.wait() then
			return skip(3)
		end
	end
	event.Initialize()
	event.ActchrSetDefMotion(0)
	event.SetFadeOut(10)
	helper_a694495f(10)
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 2 then
		event.DngSetupMainUnit(0)
	end
	if active_chr_no == 3 then
		event.DngSetupMainUnit(1)
	end
	event.DelMonster(-1)
	helper_18964()
	if vm.skipping() then
		return skip(2)
	end
	return part2()
end

--- Program 506.
script[506] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_2462c()
	if vm.skipping() then
		return skip(1)
	end
	event.LoadDungeonMapFile("s35")
	event.LoadScript("s35/s35.stb", 502)
	if vm.wait() then
		return skip(2)
	end
end

--- Program 508.
script[508] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_274c8()
	if vm.skipping() then
		return skip(1)
	end
	event.SetBitCtrl(1, 0)
	event.GotoEdit(187, 100)
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
				helper_102f0(0, 8550090)
			end
			return
		end
	end
	flag = event.GetFlag(608) or flag
	flag_2 = event.GetFlag(612) or flag_2
	if flag ~= 0 and flag_2 == 0 then
		value = event.GetRandInt(100) or value
		if value < 50 then
			helper_102f0(0, 8550080)
			if vm.skipping() then
				return skip(1)
			end
		else
			helper_102f0(0, 8550090)
			if vm.skipping() then
				return skip(2)
			end
		end
		return
	end
	helper_10258(0)
	if vm.skipping() then
		return skip(3)
	end
end

--- Program 16080.
script[16080] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_104f0()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 16100.
script[16100] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_15394()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 16120.
script[16120] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_18964()
	if vm.skipping() then
		return skip(1)
	end
	event.SetBitCtrl(8, 1)
	event.LoadDungeonMapFile("s31")
	event.LoadScript("s31/s31.stb", 510)
	if vm.wait() then
		return skip(2)
	end
end

--- Program 17020.
script[17020] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_29220()
	if vm.skipping() then
		return skip(1)
	end
end

return script
