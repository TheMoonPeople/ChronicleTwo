--!strict
-- map/d/d06/b01/d06b01.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")

local global0: s32 = 0
local global1: s32 = 0
local global2: s32 = 0
local global3: s32 = 0

--- Program 99.
local function program_99() end

--- Helper function.
local function helper_428(arg0: any)
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
local function helper_2888()
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
local function helper_2998(arg0: s32)
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
local function helper_2b40(arg0: any, arg1: any, arg2: any, arg3: any, arg4: any)
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
local function helper_2e70(arg0: s32, arg1: s32)
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
local function helper_3c98(arg0: s32)
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
			t1, var2 = helper_2e70(arg0, var2)
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
		t0, var2 = helper_2e70(arg0, var2)
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
local function helper_2d84(arg0: any)
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
local function helper_5d08(arg0: s32)
	local stream_open_state: s32 = 0
	local stream_open_state_2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			helper_2b40(0, -1, 8, 0, 0)
			helper_3c98(0)
		end
		helper_2d84(0)
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
	helper_2b40(0, -1, 8, 0, 0)
	event.StreamPlay(1)
	helper_3c98(0)
	if vm.skipping() then
		return skip(4)
	end
	helper_2d84(0)
	event.StreamClose(1)
end

--- Helper function.
local function helper_5ff8(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_5d08(arg0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, arg0)
	helper_5d08(arg0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_34d8(arg0: s32, arg1: any, arg2: any)
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
		helper_2d84(arg0)
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
			helper_2d84(arg0)
		end
	end
	event.ResetPakuMotion()
	event.TrgPakuAnim(0)
	event.ResetPakuAnim()
	event.StreamStop(1)
	event.SetMesOkuri(arg0, 1)
end

--- Helper function.
local function helper_3bdc(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_34d8(arg0, vm.ftoi(arg1), -1)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	helper_34d8(arg0, vm.ftoi(arg1), -1)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_5644(arg0: s32, arg1: s32)
	local stream_open_state: s32 = 0
	local stream_open_state_2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			helper_2b40(0, -1, 8, 0, 0)
			helper_3bdc(0, arg1)
		end
		helper_2d84(0)
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
	helper_2b40(0, -1, 8, 0, 0)
	event.StreamPlay(1)
	helper_3bdc(0, arg1)
	if vm.skipping() then
		return skip(4)
	end
	helper_2d84(0)
	event.StreamClose(1)
	event.SetMesPos(0, 0)
end

--- Helper function.
local function helper_10334()
	local active_chr_no: s32 = 0
	local var1: s32 = 0
	local block: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 29 then
			if at <= 1 then
				helper_428(70)
			end
			if at <= 2 then
				helper_428(50)
			end
			if at <= 3 then
				helper_2888()
			end
			if at <= 4 then
				helper_2998(2)
			end
			if at <= 5 then
				helper_5ff8(7160010)
			end
			if at <= 6 then
				helper_2998(1)
			end
			if at <= 7 then
				helper_2888()
			end
			if at <= 8 then
				helper_2888()
			end
			if at <= 9 then
				helper_5ff8(7160020)
			end
			if at <= 10 then
				helper_5ff8(7160030)
			end
			if at <= 11 then
				helper_5ff8(7160040)
			end
			if at <= 12 then
				helper_5ff8(7160045)
			end
			if at <= 13 then
				helper_2888()
			end
			if at <= 14 then
				helper_5ff8(7160050)
			end
			if at <= 15 then
				helper_2888()
			end
			if at <= 16 then
				helper_5ff8(7160060)
			end
			if at <= 17 then
				helper_2888()
			end
			if at <= 18 then
				helper_428(20)
			end
			if at <= 19 then
				helper_2888()
			end
			if at <= 20 then
				helper_428(100)
			end
			if at <= 21 then
				helper_428(60)
			end
			if at <= 22 then
				helper_2888()
			end
			if at <= 23 then
				helper_428(6)
			end
			if at <= 24 then
				helper_428(34)
			end
			if at <= 25 then
				helper_2998(3)
			end
			if at <= 26 then
				helper_5644(7160070, -1)
			end
			if at <= 27 then
				helper_428(30)
			end
			if at <= 28 then
				helper_428(30)
			end
			if vm.skip_end() then
				return skip(30)
			end
			return part2()
		end
		if at <= 30 then
			helper_428(4)
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SndSeStop(var1, 3)
		event.SndSeStop(var1, 4)
		event.SpriteSetDraw(0, 0)
		event.SetStatus(1, 0, 256, 0)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.SetCharaShow(1, 1)
		event.SetCharaShow(2, 1)
		event.DelExtMotion(0)
		event.DeleteChara(8)
		event.DeleteChara(9)
		event.DeleteChara(10)
		event.DeleteChara(11)
		event.DeleteChara(12)
		event.DeleteChara(13)
		event.DeleteChara(14)
		event.LoadMes(0, -1)
		event.DelImg(0)
		event.StopBgm(0)
		helper_428(4)
		if vm.skipping() then
			return skip(31)
		end
		event.LoadBgm(41)
		event.PlayBgm(0)
		event.SetStatusbarShow(1, 1.0)
		event.Finish()
	end
	event.SetFlag(716, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.SetStatusbarShow(0, 1.0)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	helper_428(4)
	if vm.skipping() then
		return skip(1)
	end
	event.LoadBgm(117)
	event.LoadSound(7823)
	var1 = event.SndLoadSound(7823) or var1
	event.SetStatus(1, 0, 256, 1)
	event.ChangeDir("event/e700/e716/")
	event.LoadMes(0, 5, "e716.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e716_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e716_monica.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.LoadChara(5, "e716_griffon.gltf", "info", 10)
	event.CharaActive(10)
	event.EohSyncChara(2, 10)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.LoadChara(5, "e716_boss08a.gltf", "info", 11)
	event.CharaActive(0, 11)
	event.EohSyncChara(3, 11)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.LoadChara(5, "e716_hikari.gltf", "info", 12)
	event.CharaActive(0, 12)
	event.EohSyncChara(5, 12)
	event.ObjsInit(5)
	event.ObjsSyncObj(5, 5)
	event.LoadChara(5, "e716_hikari1.gltf", "info", 13)
	event.CharaActive(0, 13)
	event.EohSyncChara(6, 13)
	event.ObjsInit(6)
	event.ObjsSyncObj(6, 6)
	event.LoadChara(5, "e716_rolling.gltf", "info", 14)
	event.CharaActive(0, 14)
	block = event.LoadImg_4(5, "e716telop01.json", 0) or block
	event.SpriteInit(0)
	event.SpriteSetType(0, 0)
	event.SpriteSetTexture(0, "e716telop01", block)
	event.SpriteSetColor(0, 128, 128, 128, 0)
	event.SpriteSetUvsize(0, 0, 0, 512, 128)
	event.SpriteSetPutsize(0, 512, 128)
	event.SpriteSetPos(0, 256, 272)
	event.SpriteSetAlphab(0, 0)
	event.SpriteSetDraw(0, 0)
	event.EohSyncSprite(4, 0)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.ChangeDir("")
	if active_chr_no == 1 then
		event.LoadChara(5, "chara/c01_base.gltf", "info", 8)
		event.LoadEquip(5, 0, 4, "info", 8)
		event.LoadEquip(5, 0, 3, "info", 8)
		event.LoadEquip(5, 0, 2, "info", 8, 9)
		event.LoadMotion(5, "event/e700/e716/e716_mints.gltf", "info", 8)
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
		event.LoadMotion(5, "event/e700/e716/e716_monica.gltf", "info", 8)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 8)
		event.EohSyncChara(1, 8)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 0)
	end
	event.CharaActive(8)
	event.CharaActive(9)
	event.SetCharaShow(1, 0)
	event.SetCharaShow(2, 0)
	event.EohSetPos(0, -8.0, 40.0, -1100.0)
	event.EohSetRot(0, 0.0, 0.0, 0.0)
	event.EohSetMotion(0, "立ち", 4)
	event.EohSetFootSoundId(0, 2)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "おこり顔")
	event.EohSetTexAnim(0, 1, "おこり目パチ")
	event.EohSetPos(1, 8.0, 40.0, -1100.0)
	event.EohSetRot(1, 0.0, 0.0, 0.0)
	event.EohSetMotion(1, "立ち", 4)
	event.EohSetFootSoundId(1, 2)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "おこり顔")
	event.EohSetTexAnim(1, 1, "おこり目パチ")
	event.EohSetPos(2, 0.0, 0.0, 0.0)
	event.EohSetRot(2, 0.0, 3.14, 0.0)
	event.EohSetMotion(2, "立ち（後ろ）", 4)
	event.EohSetFootSoundId(2, 2)
	event.InitDramaScene()
	event.CmrsInit()
	event.CmrsSetPos(6.27, 44.45, -1056.3)
	event.CmrsSetRef(-5.8, 72.27, -1139.67)
	event.SetFadeIn(30)
	helper_428(70)
	if vm.skipping() then
		return skip(2)
	end
	event.CmrsSetPos(0.0, 45.57, -821.24)
	event.CmrsSetRef(0.0, 62.17, -781.76)
	event.CmrsMove2(0.0, 45.57, -821.24, 0.0, 44.79, -764.81, 60, 2, 0.4)
	event.PlayBgm(0)
	helper_428(50)
	if vm.skipping() then
		return skip(3)
	end
	event.SndSePlay(var1, 0)
	event.ObjsSetMotion(2, "後ろ向きから振り返り", 6)
	event.ObjsNextMotion(2, "立ち", 4)
	helper_2888()
	if vm.skipping() then
		return skip(4)
	end
	event.SetCrossfade(30)
	event.CmrsSetPos(0.0, 51.5, -47.79)
	event.CmrsSetRef(0.0, 51.5, 7.22)
	helper_2998(2)
	if vm.skipping() then
		return skip(5)
	end
	event.SetPakuMotion(2, "会話", 0, "立ち", 0)
	helper_5ff8(7160010)
	if vm.skipping() then
		return skip(6)
	end
	event.CmrsInitPas()
	event.CmrsSetPasFrm(100)
	event.CmrsAddPas(0.0, 67.68, -429.93, 0.0, 66.4, -374.92)
	event.CmrsAddPas(0.0, 53.12, -422.5, 0.0, 51.84, -367.49)
	event.CmrsAddPas(0.0, 39.11, -416.35, 0.0, 37.83, -361.34)
	event.CmrsAddPas(0.0, 22.09, -390.47, 0.0, 20.81, -335.46)
	event.CmrsStartPas()
	event.ObjsSetPos(0, -9.0, 0.0, -400.0)
	event.ObjsMove(0, -9.0, 0.0, -300.0, 100)
	event.ObjsSetMotion(0, "歩き", 4)
	event.ObjsMotionDelay(0, 100)
	event.ObjsSetMotion(0, "立ち")
	event.ObjsSetPos(1, 9.0, 0.0, -400.0)
	event.ObjsMove(1, 9.0, 0.0, -300.0, 100)
	event.ObjsSetMotion(1, "歩き", 4)
	event.ObjsMotionDelay(1, 100)
	event.ObjsSetMotion(1, "立ち")
	helper_2998(1)
	if vm.skipping() then
		return skip(7)
	end
	helper_2888()
	if vm.skipping() then
		return skip(8)
	end
	event.SetCrossfade(60)
	event.CmrsSetPos(6.0, 55.51, -39.78)
	event.CmrsSetRef(6.0, 54.23, 15.23)
	event.CmrsMove(-2.0, 55.51, -39.78, -2.0, 54.23, 15.23, 90)
	helper_2888()
	if vm.skipping() then
		return skip(9)
	end
	event.CmrsSetPos(-36.97, 20.61, -265.32)
	event.CmrsSetRef(7.39, 19.33, -299.35)
	event.ObjsSetMotion(0, "グリフォン！！", 6)
	event.ObjsNextMotion(0, "グリフォン！！L", 4)
	event.ObjsSeDelay(0, 10)
	event.ObjsSePlay(0, var1, 1)
	event.SetPakuAnim(0, "通常口パク")
	helper_5ff8(7160020)
	if vm.skipping() then
		return skip(10)
	end
	event.ObjsSetMotion(1, "指差し", 6)
	event.ObjsNextMotion(1, "指差しL", 4)
	event.ObjsSeDelay(1, 10)
	event.ObjsSePlay(1, var1, 2)
	event.SetPakuAnim(1, "通常口パク")
	helper_5ff8(7160030)
	if vm.skipping() then
		return skip(11)
	end
	event.SetCrossfade(30)
	event.CmrsSetPos(-8.0, 20.0, -338.23)
	event.CmrsSetRef(-8.0, 20.0, -277.78)
	event.CmrsMove2(0.0, 20.0, -338.23, 0.0, 20.0, -277.78, 90, 2, 0.3)
	event.SetPakuMotion(2, "会話", 0, "立ち", 0)
	helper_5ff8(7160040)
	if vm.skipping() then
		return skip(12)
	end
	event.SetPakuMotion(2, "会話", 0, "立ち", 0)
	helper_5ff8(7160045)
	if vm.skipping() then
		return skip(13)
	end
	helper_2888()
	if vm.skipping() then
		return skip(14)
	end
	event.SetCrossfade(30)
	event.CmrsSetPos(-8.0, 52.0, -59.19)
	event.CmrsSetRef(-8.0, 52.0, 15.23)
	event.CmrsMove2(0.0, 52.0, -59.19, 0.0, 52.0, 15.23, 90, 2, 0.3)
	event.SetPakuMotion(2, "会話", 0, "立ち", 0)
	helper_5ff8(7160050)
	if vm.skipping() then
		return skip(15)
	end
	helper_2888()
	if vm.skipping() then
		return skip(16)
	end
	event.SetCrossfade(30)
	event.CmrsSetPos(-4.0, 56.21, -28.1)
	event.CmrsSetRef(-4.0, 56.16, 15.23)
	event.CmrsMove2(0.0, 56.21, -28.1, 0.0, 56.16, 15.23, 90, 2, 0.3)
	event.SetPakuMotion(2, "会話", 0, "立ち", 0)
	helper_5ff8(7160060)
	if vm.skipping() then
		return skip(17)
	end
	helper_2888()
	if vm.skipping() then
		return skip(18)
	end
	event.ObjsSetMotion(2, "手広げ", 2)
	event.ObjsNextMotion(2, "手広げＬ", 4)
	event.ObjsSeDelay(2, 10)
	event.ObjsSePlay(2, var1, 3)
	event.CmrsMove2(0.0, 30.2, -186.75, 0.0, 49.5, 15.23, 40, 0, 0.2)
	helper_428(20)
	if vm.skipping() then
		return skip(19)
	end
	event.SetCharaPos(14, 0.0, 0.0, 0.0)
	event.SetCharaPos(14, 0.0, 0.0, 0.0)
	event.SetMotion(14, "手広げＬ", 6)
	event.CharaActive(1, 14)
	helper_2888()
	if vm.skipping() then
		return skip(20)
	end
	event.CmrsSetPos(-36.48, 7.72, -377.14)
	event.CmrsSetRef(-28.24, 21.42, -338.45)
	event.ObjsSetMotion(0, "上向く", 6, -1.0, 1)
	event.ObjsNextMotion(0, "上向くL", 4)
	event.ObjsSetMotion(1, "上向く", 6, -1.0, 1)
	event.ObjsNextMotion(1, "上向くL", 4)
	event.ObjsMove(2, 0.0, 160.0, 0.0, 60)
	event.ObjsSetMotion(2, "回る", 6)
	event.ObjsNextMotion(2, "放つ", 6)
	event.ObjsNextMotion(2, "放つＬ", 4)
	event.CharaActive(1, 12)
	event.SetCharaShow(12, 1, 1, 0.025)
	event.ObjsSetPos(5, 0.0, 40.0, -10.0)
	event.ObjsSetRot(5, 0.0, 0.0, 0.0)
	event.ObjsMove(5, 0.0, 200.0, -10.0, 60)
	helper_428(100)
	if vm.skipping() then
		return skip(21)
	end
	event.CharaActive(1, 13)
	event.ObjsSetPos(6, 0.0, 200.0, -10.0)
	event.ObjsSetRot(6, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(6, "放つＬ", 6)
	helper_428(60)
	if vm.skipping() then
		return skip(22)
	end
	event.CmrsSetPos(-9.86, 51.69, -251.99)
	event.CmrsSetRef(1.75, 8.15, -309.3)
	event.CmrsMove2(-7.66, 45.43, -262.87, 1.75, 8.15, -309.3, 60, 2, 0.2)
	event.EohSetTexAnim(0, 1, "半口")
	event.EohSetTexAnim(1, 1, "半口")
	event.ObjsSetRot(0, 0.0, 0.12, 0.0)
	event.ObjsSetMotion(0, "上向くL", 4, -1.0, 1)
	event.ObjsSetRot(1, 0.0, -0.12, 0.0)
	event.ObjsSetMotion(1, "上向くL", 4, -1.0, 1)
	event.CharaActive(0, 12)
	event.CharaActive(0, 13)
	event.SetCharaPos(12, 0.0, 200.0, 0.0)
	event.SetCharaRot(12, 0.0, 0.0, 0.0)
	event.SetMotion(12, "手広げＬ", 4)
	helper_2888()
	if vm.skipping() then
		return skip(23)
	end
	event.CmrsSetPos(0.0, 200.0, -340.0)
	event.CmrsSetRef(0.0, 200.0, 0.0)
	event.CmrsMove2(0.0, 200.0, -130.0, 0.0, 200.0, 0.0, 120, 2, 0.2)
	event.CharaActive(0, 10)
	event.CharaActive(1, 11)
	event.ObjsSetPos(3, 0.0, 160.0, 0.0)
	event.ObjsSetRot(3, 0.0, 3.14, 0.0)
	event.ObjsSetMotion(3, "立ち", 4)
	helper_428(6)
	if vm.skipping() then
		return skip(24)
	end
	event.SndSePlay(var1, 4)
	helper_428(34)
	if vm.skipping() then
		return skip(25)
	end
	event.ObjsNextMotion(3, "舞", 6)
	event.ObjsNextMotion(3, "舞Ｌ", 4)
	helper_2998(3)
	if vm.skipping() then
		return skip(26)
	end
	event.SpriteSetDraw(0, 1)
	event.ObjsColorDelay(4, 30)
	event.ObjsSetColor(4, 128, 128, 128, 128, 30)
	event.ObjsColorDelay(4, 90)
	event.ObjsSetColor(4, 128, 128, 128, 0, 30)
	helper_5644(7160070, -1)
	if vm.skipping() then
		return skip(27)
	end
	helper_428(30)
	if vm.skipping() then
		return skip(28)
	end
	event.FadeOutBgm(30)
	event.SetFadeOut(30)
	helper_428(30)
	if vm.skipping() then
		return skip(29)
	end
	return part2()
end

--- Helper function.
local function helper_18f4(arg0: f32, arg1: f32, arg2: f32, arg3: f32)
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
local function helper_d4c(arg0: s32)
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
local function helper_f50(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			local _ = helper_d4c(arg0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	while true do
		if helper_d4c(arg0) ~= 0 then
			break
		else
			if vm.wait() then
				return skip(2)
			end
		end
	end
end

--- Helper function.
local function helper_4360(arg0: any, arg1: s32)
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
local function helper_7a78(arg0: any, arg1: s32, arg2: s32)
	local var3: s32 = 0
	local var4: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var4 = 0
			var3 = helper_4360(arg0, arg1)
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
		var3 = helper_4360(arg0, arg1)
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
local function helper_8540(arg0: s32, arg1: s32, arg2: s32, arg3: s32, arg4: s32)
	local var6: s32 = 0
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			local _ = helper_2b40(arg0, arg1, arg2, arg3, arg4)
			_, var6 = helper_7a78(arg0, 0, var6)
		end
		helper_2d84(arg0)
	end
	if vm.skipping() then
		return skip(1)
	end
	local _ = helper_2b40(arg0, arg1, arg2, arg3, arg4)
	_, var6 = helper_7a78(arg0, 0, var6)
	if vm.skipping() then
		return skip(2)
	end
	helper_2d84(arg0)
end

--- Helper function.
local function helper_1903c()
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		active_chr_no = 0
		active_chr_no = 1
		global0 = 0
		global1 = 8
		global0 = 8
		global1 = 0
	end
	if vm.skipping() then
		return skip(1)
	end
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
	if active_chr_no == 0 then
		global0 = 0
		global1 = 8
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.LoadMotion(5, "event/e700/e728/e728_mints.gltf", "info", global0)
		event.EohSyncChara(0, global0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global0)
		event.LoadChara(5, "chara/c02_base.gltf", "info", global1)
		event.LoadEquip(5, 1, 1, "info", global1, 17)
		event.LoadEquip(5, 1, 0, "info", global1, 18)
		event.LoadEquip(5, 1, 4, "info", global1)
		event.LoadEquip(5, 1, 3, "info", global1)
		event.LoadEquip(5, 1, 2, "info", global1, 13)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.LoadMotion(5, "event/e700/e728/e728_monica.gltf", "info", global1)
		event.EohSyncChara(1, global1)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global1)
		event.CharaActive(1, 13)
	end
	if active_chr_no == 1 then
		global0 = 8
		global1 = 0
		event.LoadChara(5, "chara/c01_base.gltf", "info", global0)
		event.LoadEquip(5, 0, 1, "info", global0, 17)
		event.LoadEquip(5, 0, 0, "info", global0, 18)
		event.LoadEquip(5, 0, 4, "info", global0)
		event.LoadEquip(5, 0, 3, "info", global0)
		event.LoadEquip(5, 0, 2, "info", global0, 13)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.LoadMotion(5, "event/e700/e728/e728_mints.gltf", "info", global0)
		event.EohSyncChara(0, global0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global0)
		event.CharaActive(1, 13)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.LoadMotion(5, "event/e700/e728/e728_monica.gltf", "info", global1)
		event.EohSyncChara(1, global1)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global1)
	end
	event.LoadChara(5, "event/e700/e728/e728_boss10a.gltf", "info", 19)
	event.CharaActive(0, 19)
	event.EohSyncChara(11, 19)
	event.ObjsInit(11, 19)
	event.ObjsSyncObj(11, 11)
	event.LoadChara(5, "event/e700/e728/e728_particle.gltf", "info", 10)
	event.CharaActive(0, 10)
	event.CharaActive(1, 17)
	event.CharaActive(1, 18)
	event.LoadMes(0, 5, "event/e700/e728/e728.txt")
end

--- Helper function.
local function helper_18b84()
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
		event.DeleteChara(13)
		event.DeleteChara(17)
		event.DeleteChara(18)
	end
	if active_chr_no == 1 then
		event.CharaActive(1, global1)
		event.CharaActive(0, global0)
		event.DelExtMotion(global0)
		event.DelExtMotion(global1)
		event.DeleteChara(global0)
		event.DeleteChara(13)
		event.DeleteChara(17)
		event.DeleteChara(18)
	end
	event.DeleteChara(19)
	event.DeleteChara(10)
	event.EohSyncChara(2, 1)
	event.EohSetShow(2, 1)
	event.EohSyncChara(3, 2)
	event.EohSetShow(3, 1)
	event.SetStatusbarShow(1, 1.0)
	event.Finish()
end

--- Helper function.
local function helper_1a1b8()
	local var4: s32 = 0
	local projection: f32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 8 then
			if at <= 1 then
				helper_1903c()
				helper_428(15)
			end
			if at <= 2 then
				helper_428(30)
			end
			if at <= 3 then
				helper_5644(7280010, -1)
			end
			if at <= 4 then
				helper_2888()
			end
			if at <= 5 then
				helper_428(30)
			end
			if at <= 6 then
				helper_428(30)
			end
			if at <= 7 then
				helper_2888()
			end
			if vm.skip_end() then
				return skip(9)
			end
			return part2()
		end
		if at <= 9 then
			helper_428(60)
		end
		helper_18b84()
	end
	function part2()
		event.CancelDramaScene()
		event.CmrsFadeOut(60, 255.0, 255.0, 255.0)
		helper_428(60)
		if vm.skipping() then
			return skip(10)
		end
		event.SndSeAllStop(4)
		event.BgmLoadCancel()
		if vm.wait() then
			return skip(11)
		end
		event.SetProjection(projection)
		helper_18b84()
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFlag(728, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.StopBgm(0)
	event.LoadSound(7831)
	var4 = event.SndLoadSound(7831) or var4
	helper_1903c()
	projection = event.GetProjection() or projection
	event.InitDramaScene()
	event.EohSyncChara(2, 1)
	event.EohSetShow(2, 0)
	event.EohSyncChara(3, 2)
	event.EohSetShow(3, 0)
	event.CharaActive(0, 17)
	event.CharaActive(0, 18)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おこり顔")
	event.ObjsTexAnime(0, 1, "おこり目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "おこり顔")
	event.ObjsTexAnime(1, 1, "おこり目パチ")
	event.CharaActive(1, global0)
	event.CharaActive(1, global1)
	event.CharaActive(1, 19)
	event.CmrsSetPos(-67.28, 15.66, -27.15)
	event.CmrsSetRef(-7.11, 7.02, -6.4)
	event.ObjsSetPos(11, 0.0, 0.0, 0.0)
	event.ObjsSetRot(11, 0.0, 3.12, 0.0)
	event.ObjsSetPos(0, -10.0, 0.0, -90.19)
	event.ObjsSetRot(0, 0.0, 0.12, 0.0)
	event.ObjsSetPos(1, 10.0, 0.0, -90.73)
	event.ObjsSetRot(1, 0.0, -0.12, 0.0)
	event.SetFadeIn(30)
	event.ObjsSetMotion(11, "立ち4", 4)
	event.ObjsSetMotion(0, "立ち", 4, -1.0, 1)
	event.ObjsSetMotion(1, "立ち", 4, -1.0, 1)
	helper_428(15)
	if vm.skipping() then
		return skip(2)
	end
	event.SndSePlay(var4, 0)
	event.ObjsSetMotion(11, "ドスッ", 2)
	event.ObjsNextMotion(11, "ドスッＬ", 4)
	helper_428(30)
	if vm.skipping() then
		return skip(3)
	end
	event.CmrsInitPas()
	event.CmrsSetPasFrm(200)
	event.CmrsAddPas(-67.28, 15.66, -27.15, -7.11, 7.02, -6.4)
	event.CmrsAddPas(-67.28, 40.31, -27.15, -7.11, 31.68, -6.4)
	event.CmrsStartPas()
	helper_5644(7280010, -1)
	if vm.skipping() then
		return skip(4)
	end
	helper_2888()
	if vm.skipping() then
		return skip(5)
	end
	event.CmrsSetPos(0.0, 4.51, -46.14)
	event.CmrsSetRef(0.0, 30.71, -128.08)
	helper_428(30)
	if vm.skipping() then
		return skip(6)
	end
	event.SndSePlay(var4, 1)
	event.SetCharaPos(10, 0.0, 0.0, 0.0)
	event.SetCharaRot(10, 0.0, 3.12, 0.0)
	event.SetMotion(10, "ドスッＬ")
	event.CharaActive(1, 10)
	event.CmrsSetPos(0.0, 18.36, -103.26)
	event.CmrsSetRef(0.0, 27.17, 0.0)
	helper_428(30)
	if vm.skipping() then
		return skip(7)
	end
	event.SetCharaShow(10, 0, 1, 0.0033)
	event.CmrsInitPas()
	event.CmrsSetPasFrm(300)
	event.CmrsAddPas(0.0, 18.36, -103.26, 0.0, 27.17, 0.0)
	event.CmrsAddPas(0.0, 88.44, -103.26, 0.0, 97.25, 0.0)
	event.CmrsStartPas()
	helper_2888()
	if vm.skipping() then
		return skip(8)
	end
	return part2()
end

--- Program 502.
local function program_502()
	local active_chr_no: s32 = 0
	local active_chr_no_2: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 2 then
			helper_428(30)
		end
		if at <= 3 then
			helper_1a1b8()
			if not vm.skipping() then
				return part2()
			end
		end
	end
	function part2()
		event.BgmLoadCancel()
		event.LoadDungeonMapFile("s44")
		event.LoadScript("s44/s44.stb", 510)
	end
	event.Initialize()
	event.ActchrSetDefMotion(0)
	event.FadeOutBgm(20)
	event.SetFadeOut(20)
	helper_428(20)
	if vm.skipping() then
		return skip(1)
	end
	event.SoundAllStop()
	if vm.wait() then
		return skip(2)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.SetCharaCondition(active_chr_no, 8, 1)
	event.DelMonster(-1)
	active_chr_no_2 = event.GetActiveChrNo() or active_chr_no_2
	if active_chr_no_2 == 2 then
		event.DngSetupMainUnit(0)
	end
	if active_chr_no_2 == 3 then
		event.DngSetupMainUnit(1)
	end
	helper_428(30)
	if vm.skipping() then
		return skip(3)
	end
	helper_1a1b8()
	if vm.skipping() then
		return skip(4)
	end
	return part2()
end

--- Helper function.
local function helper_14a70()
	local var0: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 14 then
			if at <= 1 then
				helper_428(60)
			end
			if at <= 2 then
				helper_2888()
			end
			if at <= 3 then
				helper_428(6)
			end
			if at <= 4 then
				helper_2998(2)
			end
			if at <= 5 then
				helper_2998(2)
			end
			if at <= 6 then
				helper_2998(2)
			end
			if at <= 7 then
				helper_428(20)
			end
			if at <= 8 then
				helper_2888()
			end
			if at <= 9 then
				helper_428(60)
			end
			if at <= 10 then
				helper_428(240)
			end
			if at <= 11 then
				helper_2998(3)
			end
			if at <= 12 then
				helper_428(40)
			end
			if at <= 13 then
				helper_428(30)
			end
			if vm.skip_end() then
				return skip(15)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.PlayBgm(0)
		event.DeleteChara(8)
		event.DeleteChara(9)
		event.DeleteChara(10)
		event.DeleteChara(11)
		event.DeleteChara(12)
		event.DeleteChara(13)
		event.DeleteChara(14)
		event.DeleteChara(15)
		event.DeleteChara(16)
		event.LoadMes(0, -1)
		event.CharaActive(1, 0)
		event.Finish()
	end
	event.Initialize()
	event.SetFlag(720, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.AssignStack(5)
	event.ClearStack(5)
	event.StopBgm(0)
	helper_428(4)
	if vm.skipping() then
		return skip(1)
	end
	event.LoadBgm(38)
	event.LoadSound(7827)
	var0 = event.SndLoadSound(7827) or var0
	event.CharaActive(0, 0)
	event.ChangeDir("event/e700/e720/")
	event.LoadChara(5, "e720_boss08a.gltf", "info", 12)
	event.CharaActive(12)
	event.EohSyncChara(2, 12)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.LoadChara(5, "e720_boss09a.gltf", "info", 13)
	event.CharaActive(0, 13)
	event.EohSyncChara(3, 13)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.LoadChara(5, "e720_eye.gltf", "info", 14)
	event.CharaActive(0, 14)
	event.LoadChara(5, "e720_hane.gltf", "info", 15)
	event.CharaActive(0, 15)
	event.LoadChara(5, "e720_hane2.gltf", "info", 16)
	event.CharaActive(0, 16)
	event.ChangeDir("")
	event.LoadChara(5, "chara/c01_base.gltf", "info", 8)
	event.LoadEquip(5, 0, 4, "info", 8)
	event.LoadEquip(5, 0, 3, "info", 8)
	event.LoadEquip(5, 0, 2, "info", 8, 9)
	event.LoadMotion(5, "event/e700/e720/e720_mints.gltf", "info", 8)
	event.CharaActive(8)
	event.CharaActive(9)
	event.EohSyncChara(0, 8)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.LoadChara(5, "chara/c02_base.gltf", "info", 10)
	event.LoadEquip(5, 1, 4, "info", 10)
	event.LoadEquip(5, 1, 3, "info", 10)
	event.LoadEquip(5, 1, 2, "info", 10, 11)
	event.LoadMotion(5, "event/e700/e720/e720_monica.gltf", "info", 10)
	event.CharaActive(10)
	event.CharaActive(11)
	event.EohSyncChara(1, 10)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.EohSetPos(0, -8.0, 0.0, -300.0)
	event.EohSetRot(0, 0.0, 0.0, 0.0)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "おこり顔")
	event.EohSetTexAnim(0, 1, "おこり目パチ")
	event.EohSetPos(1, 8.0, 0.0, -300.0)
	event.EohSetRot(1, 0.0, 0.0, 0.0)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "おこり顔")
	event.EohSetTexAnim(1, 1, "おこり目パチ")
	event.EohSetPos(2, 0.0, 0.0, 0.0)
	event.EohSetRot(2, 0.0, 3.14, 0.0)
	event.EohSetFootSoundId(2, 2)
	event.EohSetPos(3, 0.0, 0.0, 0.0)
	event.EohSetRot(3, 0.0, 3.14, 0.0)
	event.SetCharaPos(14, 0.0, 54.23, -19.48)
	event.SetCharaRot(14, 0.0, 3.14, 0.0)
	event.SetCharaPos(15, 0.0, 0.0, 0.0)
	event.SetCharaRot(15, 0.0, 3.14, 0.0)
	event.SetCharaPos(16, 0.0, 0.0, -300.0)
	event.SetCharaRot(16, 0.0, -0.3, 0.0)
	event.InitDramaScene()
	event.ObjsSetMotion(2, "落ち立つ", 6)
	event.ObjsNextMotion(2, "落ち立つＬ", 4)
	event.CmrsInit()
	event.CmrsSetPos(0.0, 47.27, -59.93)
	event.CmrsSetRef(0.0, 54.56, 0.0)
	event.SndSePlay(var0, 0)
	event.SetFadeIn(30)
	helper_428(60)
	if vm.skipping() then
		return skip(2)
	end
	event.SndSePlay(var0, 1)
	event.CmrsMove2(0.0, 13.39, -110.66, 0.0, 40.47, 0.0, 40, 0, 0.2)
	helper_2888()
	if vm.skipping() then
		return skip(3)
	end
	helper_428(6)
	if vm.skipping() then
		return skip(4)
	end
	event.CmrsSetPos(-10.28, 38.76, -46.62)
	event.CmrsSetRef(-43.29, 78.66, 15.21)
	event.SndSePlay(var0, 2)
	event.ObjsSetMotion(2, "羽広げ", 6)
	event.ObjsMotionWait(2)
	helper_2998(2)
	if vm.skipping() then
		return skip(5)
	end
	event.CmrsSetPos(10.28, 38.76, -46.62)
	event.CmrsSetRef(43.29, 78.66, 15.21)
	event.SndSePlay(var0, 2)
	event.ObjsResetMotion(2)
	event.ObjsSetMotion(2, "羽広げ", 6)
	event.ObjsMotionWait(2)
	helper_2998(2)
	if vm.skipping() then
		return skip(6)
	end
	event.CmrsSetPos(0.0, 24.76, -90.76)
	event.CmrsSetRef(0.0, 52.6, 0.0)
	event.SndSePlay(var0, 3)
	event.ObjsSetMotion(2, "掴む", 6)
	event.ObjsNextMotion(2, "掴むＬ", 4)
	helper_2998(2)
	if vm.skipping() then
		return skip(7)
	end
	event.CmrsSetPos(0.0, 48.79, -25.5)
	event.CmrsSetRef(0.0, 58.19, -16.62)
	event.SndSePlay(var0, 4)
	event.CharaActive(0, 12)
	event.CharaActive(1, 13)
	event.CharaActive(1, 14)
	event.SetMotion(14, "光る", 6)
	helper_428(20)
	if vm.skipping() then
		return skip(8)
	end
	event.CmrsSetPos(-29.82, 47.88, -38.26)
	event.CmrsSetRef(-0.06, 56.08, -3.93)
	event.CmrsMove2(-115.99, 6.24, -137.7, -0.06, 47.97, -3.93, 40, 2, 1.0)
	event.SndSePlay(var0, 5)
	event.CharaActive(0, 14)
	event.CharaActive(1, 15)
	event.ObjsSetMotion(3, "バサ", 6)
	event.ObjsNextMotion(3, "バサＬ", 4)
	event.SetMotion(15, "バサ", 6)
	helper_2888()
	if vm.skipping() then
		return skip(9)
	end
	helper_428(60)
	if vm.skipping() then
		return skip(10)
	end
	event.CmrsSetPos(-30.14, 11.81, -262.23)
	event.CmrsSetRef(0.94, 19.52, -298.52)
	event.CharaActive(0, 15)
	event.CharaActive(1, 16)
	event.SetMotion(16, "舞う羽根", 6)
	helper_428(240)
	if vm.skipping() then
		return skip(11)
	end
	event.CmrsSetPos(0.0, 34.0, -110.0)
	event.CmrsSetRef(0.0, 34.0, -20.0)
	event.SndSePlay(var0, 6)
	event.ObjsSetMotion(3, "構え", 6)
	event.ObjsNextMotion(3, "構えＬ", 4)
	helper_2998(3)
	if vm.skipping() then
		return skip(12)
	end
	helper_428(40)
	if vm.skipping() then
		return skip(13)
	end
	event.SetFadeOut(30)
	helper_428(30)
	if vm.skipping() then
		return skip(14)
	end
	return part2()
end

--- Helper function.
local function helper_16dcc()
	local var0: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 11 then
			if at <= 1 then
				helper_428(66)
			end
			if at <= 2 then
				helper_428(40)
			end
			if at <= 3 then
				helper_2998(3)
			end
			if at <= 4 then
				helper_428(40)
			end
			if at <= 5 then
				helper_2888()
			end
			if at <= 6 then
				helper_428(20)
			end
			if at <= 7 then
				helper_2998(3)
			end
			if at <= 8 then
				helper_2888()
			end
			if at <= 9 then
				helper_428(20)
			end
			if at <= 10 then
				helper_428(30)
			end
			if vm.skip_end() then
				return skip(12)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SndSeStop(var0, 0)
		event.SndSeStop(var0, 1)
		event.SndSeStop(var0, 2)
		event.SndSeStop(var0, 3)
		event.SndSeStop(var0, 4)
		event.LoadBgm(38)
		event.PlayBgm(0)
		event.DeleteChara(8)
		event.DeleteChara(9)
		event.DeleteChara(10)
		event.DeleteChara(11)
		event.DeleteChara(12)
		event.DeleteChara(13)
		event.LoadMes(0, -1)
		event.DelImg(0)
		event.EsmClear()
		event.CharaActive(1, 0)
		event.Finish()
	end
	event.Initialize()
	event.SetFlag(724, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.AssignStack(5)
	event.ClearStack(5)
	event.StopBgm(0)
	event.LoadSound(7830)
	var0 = event.SndLoadSound(7830) or var0
	event.CharaActive(0, 0)
	event.ChangeDir("event/e700/e724/")
	event.LoadChara(5, "e724_boss09a.gltf", "info", 12)
	event.CharaActive(12)
	event.EohSyncChara(2, 12)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.LoadChara(5, "e724_boss10a.gltf", "info", 13)
	event.CharaActive(0, 13)
	event.EohSyncChara(3, 13)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.ChangeDir("")
	event.LoadChara(5, "chara/c01_base.gltf", "info", 8)
	event.LoadEquip(5, 0, 4, "info", 8)
	event.LoadEquip(5, 0, 3, "info", 8)
	event.LoadEquip(5, 0, 2, "info", 8, 9)
	event.LoadMotion(5, "event/e700/e724/e724_mints.gltf", "info", 8)
	event.CharaActive(0, 8)
	event.CharaActive(0, 9)
	event.EohSyncChara(0, 8)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.LoadChara(5, "chara/c02_base.gltf", "info", 10)
	event.LoadEquip(5, 1, 4, "info", 10)
	event.LoadEquip(5, 1, 3, "info", 10)
	event.LoadEquip(5, 1, 2, "info", 10, 11)
	event.LoadMotion(5, "event/e700/e724/e724_monica.gltf", "info", 10)
	event.CharaActive(0, 8)
	event.CharaActive(0, 9)
	event.CharaActive(0, 10)
	event.CharaActive(0, 11)
	event.EohSyncChara(1, 10)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.EsmInitialize(5)
	event.EsmLoadBase("グリ炎")
	event.EsmInitFix(5)
	event.EohSetPos(0, -15.0, 0.0, -100.0)
	event.EohSetRot(0, 0.0, 0.24, 0.0)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "おこり顔")
	event.EohSetTexAnim(0, 1, "おこり目パチ")
	event.EohSetPos(1, 15.0, 0.0, -100.0)
	event.EohSetRot(1, 0.0, -0.24, 0.0)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "おこり顔")
	event.EohSetTexAnim(1, 1, "おこり目パチ")
	event.EohSetPos(2, 0.0, 0.0, 0.0)
	event.EohSetRot(2, 0.0, 3.14, 0.0)
	event.EohSetFootSoundId(2, 2)
	event.EohSetPos(3, 0.0, 0.0, 0.0)
	event.EohSetRot(3, 0.0, 3.14, 0.0)
	event.InitDramaScene()
	event.ObjsSetMotion(2, "ドスン", 6)
	event.ObjsNextMotion(2, "ドスンＬ", 4)
	event.CmrsInit()
	event.CmrsSetPos(0.0, 9.34, -123.04)
	event.CmrsSetRef(0.0, 27.06, -41.89)
	event.SetFadeIn(30)
	helper_428(4)
	if vm.skipping() then
		return skip(1)
	end
	event.SndSePlay(var0, 0)
	helper_428(66)
	if vm.skipping() then
		return skip(2)
	end
	event.CmrsSetPos(-27.3, 38.14, -3.46)
	event.CmrsSetRef(2.7, 38.14, -3.48)
	event.CharaActive(0, 12)
	event.CharaActive(1, 13)
	event.ObjsSetMotion(3, "ブルブル", 4)
	helper_428(40)
	if vm.skipping() then
		return skip(3)
	end
	event.CmrsMove2(-28.75, 59.94, -54.17, -0.03, 57.31, -6.26, 40, 0, 0.1)
	event.SndSePlay(var0, 1)
	event.ObjsSetMotion(3, "ガバッ！", 2)
	event.ObjsNextMotion(3, "ガバッ！Ｌ", 4)
	helper_2998(3)
	if vm.skipping() then
		return skip(4)
	end
	event.CmrsMove2(-28.74, 34.61, -53.85, -0.01, 38.28, -6.24, 40, 0, 1.0)
	helper_428(40)
	if vm.skipping() then
		return skip(5)
	end
	event.SndSePlay(var0, 2)
	event.EsmCreate_2("グリ炎", 13)
	helper_2888()
	if vm.skipping() then
		return skip(6)
	end
	helper_428(20)
	if vm.skipping() then
		return skip(7)
	end
	event.CmrsSetPos(-10.62, 51.43, -49.36)
	event.CmrsSetRef(-0.01, 57.74, -6.24)
	event.ObjsSetMotion(3, "顔向ける", 2)
	event.ObjsNextMotion(3, "顔向けるＬ", 4)
	event.ObjsSeDelay(3, 10)
	event.ObjsSePlay(3, var0, 3)
	helper_2998(3)
	if vm.skipping() then
		return skip(8)
	end
	event.CmrsSetPos(0.0, 34.11, -66.77)
	event.CmrsSetRef(0.0, 38.24, -8.51)
	event.CmrsMove2(0.0, 13.84, -155.54, 0.0, 34.07, -8.51, 40, 2, 0.2)
	event.CharaActive(1, 8)
	event.CharaActive(1, 9)
	event.CharaActive(1, 10)
	event.CharaActive(1, 11)
	event.ObjsSetMotion(3, "構え", 2)
	event.ObjsNextMotion(3, "構えＬ", 4)
	event.ObjsSeDelay(3, 16)
	event.ObjsSePlay(3, var0, 4)
	helper_2888()
	if vm.skipping() then
		return skip(9)
	end
	helper_428(20)
	if vm.skipping() then
		return skip(10)
	end
	event.SetFadeOut(30)
	helper_428(30)
	if vm.skipping() then
		return skip(11)
	end
	return part2()
end

--- Helper function.
local function helper_1b860()
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		active_chr_no = 0
		active_chr_no = 1
		global2 = 0
		global3 = 8
		global2 = 8
		global3 = 0
	end
	if vm.skipping() then
		return skip(1)
	end
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
	if active_chr_no == 0 then
		global2 = 0
		global3 = 8
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", global2)
		event.LoadMotion(5, "event/e700/e728/e728_mints.gltf", "info", global2)
		event.EohSyncChara(0, global2)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global2)
		event.LoadChara(5, "chara/c02_base.gltf", "info", global3)
		event.LoadEquip(5, 1, 1, "info", global3, 17)
		event.LoadEquip(5, 1, 0, "info", global3, 18)
		event.LoadEquip(5, 1, 4, "info", global3)
		event.LoadEquip(5, 1, 3, "info", global3)
		event.LoadEquip(5, 1, 2, "info", global3, 13)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global3)
		event.LoadMotion(5, "event/e700/e728/e728_monica.gltf", "info", global3)
		event.EohSyncChara(1, global3)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global3)
		event.CharaActive(1, 13)
	end
	if active_chr_no == 1 then
		global2 = 8
		global3 = 0
		event.LoadChara(5, "chara/c01_base.gltf", "info", global2)
		event.LoadEquip(5, 0, 1, "info", global2, 17)
		event.LoadEquip(5, 0, 0, "info", global2, 18)
		event.LoadEquip(5, 0, 4, "info", global2)
		event.LoadEquip(5, 0, 3, "info", global2)
		event.LoadEquip(5, 0, 2, "info", global2, 13)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", global2)
		event.LoadMotion(5, "event/e700/e728/e728_mints.gltf", "info", global2)
		event.EohSyncChara(0, global2)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global2)
		event.CharaActive(1, 13)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global3)
		event.LoadMotion(5, "event/e700/e728/e728_monica.gltf", "info", global3)
		event.EohSyncChara(1, global3)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global3)
	end
	event.EohSyncChara(2, 1)
	event.EohSetShow(2, 0)
	event.EohSyncChara(3, 2)
	event.EohSetShow(3, 0)
	event.LoadChara(5, "event/e700/e728/e728_sun.gltf", "info", 9)
	event.CharaActive(0, 9)
	event.EohSyncChara(4, 9)
	event.ObjsInit(2, 9)
	event.ObjsSyncObj(2, 4)
	event.CharaActive(1, 17)
	event.CharaActive(1, 18)
	event.LoadMes(0, 5, "event/e700/e728/e728.txt")
	event.AssignStack(6)
	event.ClearStack(6)
	event.LoadChara(6, "event/e700/e728/atora_red.gltf", "atora_red", 19)
	event.CharaActive(0, 19)
	event.EohSyncChara(11, 19)
	event.ObjsInit(11, 19)
	event.ObjsSyncObj(11, 11)
	event.LoadChara(6, "event/e700/e728/atora_blue.gltf", "atora_blue", 20)
	event.CharaActive(0, 20)
	event.EohSyncChara(12, 20)
	event.ObjsInit(12, 20)
	event.ObjsSyncObj(12, 12)
	event.LoadChara(6, "event/e700/e728/atora_yellow.gltf", "a_yellow", 21)
	event.CharaActive(0, 21)
	event.EohSyncChara(13, 21)
	event.ObjsInit(13, 21)
	event.ObjsSyncObj(13, 13)
	event.LoadChara(6, "event/e700/e728/e728_dark_smoke.gltf", "info", 10)
	event.CharaActive(0, 10)
	event.EohSyncChara(5, 10)
	event.ObjsInit(5, 10)
	event.ObjsSyncObj(5, 5)
	event.LoadChara(6, "event/e700/e728/e728_desmoke2.gltf", "info", 12)
	event.CharaActive(0, 12)
	event.SetCharaType(12, 4)
	event.LoadChara(6, "event/e700/e728/e728_desmoke.gltf", "info", 11)
	event.CharaActive(0, 11)
	event.SetCharaType(11, 4)
	event.LoadChara(6, "event/e700/e728/e728_smoky_haze.gltf", "info", 22)
	event.CharaActive(0, 22)
	event.SetCharaType(22, 4)
	event.LoadChara(6, "event/e700/e728/e728_eleki.gltf", "info", 23)
	event.CharaActive(0, 23)
	event.SetCharaType(23, 4)
end

--- Helper function.
local function helper_1b234()
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		event.CharaActive(1, global2)
		event.CharaActive(0, global3)
		event.DelExtMotion(global2)
		event.DelExtMotion(global3)
		event.DeleteChara(global3)
		event.DeleteChara(13)
		event.DeleteChara(17)
		event.DeleteChara(18)
	end
	if active_chr_no == 1 then
		event.CharaActive(1, global3)
		event.CharaActive(0, global2)
		event.DelExtMotion(global2)
		event.DelExtMotion(global3)
		event.DeleteChara(global2)
		event.DeleteChara(13)
		event.DeleteChara(17)
		event.DeleteChara(18)
	end
	event.DeleteChara(9)
	event.DeleteChara(10)
	event.DeleteChara(11)
	event.DeleteChara(12)
	event.DeleteChara(22)
	event.DeleteChara(23)
	event.DeleteChara(19)
	event.DeleteChara(20)
	event.DeleteChara(21)
	event.SetStatus(1, 0, 256, 0)
	event.DelImg(0)
	event.EohSyncChara(2, 1)
	event.EohSetShow(2, 1)
	event.EohSyncChara(3, 2)
	event.EohSetShow(3, 1)
	event.SetStatusbarShow(1, 1.0)
	if vm.wait() then
		return skip(2)
	end
	event.Finish()
end

--- Helper function.
local function helper_1d25c()
	local var4: s32 = 0
	local projection: f32 = 0
	local active_chr_no: s32 = 0
	local block: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 44 then
			if at <= 4 then
				helper_1b860()
				helper_428(60)
			end
			if at <= 5 then
				helper_428(60)
			end
			if at <= 6 then
				helper_428(60)
			end
			if at <= 7 then
				helper_2888()
			end
			if at <= 8 then
				helper_428(60)
			end
			if at <= 9 then
				helper_5644(7280130, -1)
			end
			if at <= 10 then
				helper_428(15)
			end
			if at <= 11 then
				helper_2888()
			end
			if at <= 12 then
				helper_428(30)
			end
			if at <= 13 then
				helper_2998(5)
			end
			if at <= 14 then
				helper_2998(5)
			end
			if at <= 15 then
				helper_2888()
			end
			if at <= 16 then
				helper_2888()
			end
			if at <= 17 then
				helper_428(20)
			end
			if at <= 18 then
				helper_428(15)
			end
			if at <= 19 then
				helper_2888()
			end
			if at <= 20 then
				helper_428(30)
			end
			if at <= 21 then
				helper_5644(7280140, 30)
			end
			if at <= 22 then
				helper_2998(2)
			end
			if at <= 23 then
				helper_2998(0)
			end
			if at <= 24 then
				helper_428(15)
			end
			if at <= 25 then
				helper_2998(0)
			end
			if at <= 26 then
				helper_2998(0)
			end
			if at <= 27 then
				helper_5644(7280150, -1)
			end
			if at <= 28 then
				helper_428(60)
			end
			if at <= 33 then
				helper_428(90)
			end
			if at <= 34 then
				helper_428(30)
			end
			if at <= 35 then
				helper_428(90)
			end
			if at <= 36 then
				helper_428(60)
			end
			if at <= 37 then
				helper_2888()
			end
			if at <= 38 then
				helper_428(60)
			end
			if at <= 39 then
				helper_428(90)
			end
			if at <= 40 then
				helper_2888()
			end
			if at <= 41 then
				helper_2888()
			end
			if at <= 42 then
				helper_428(60)
			end
			if at <= 43 then
				helper_428(60)
			end
			if vm.skip_end() then
				return skip(45)
			end
			return part2()
		end
		if at <= 45 then
			helper_428(65)
		end
		if at <= 47 then
			helper_1b234()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.CmrsFadeOut(60, 255.0, 255.0, 255.0)
		helper_428(65)
		if vm.skipping() then
			return skip(46)
		end
		event.SetProjection(projection)
		event.BgmLoadCancel()
		event.SndSeAllStop(4)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		if vm.wait() then
			return skip(47)
		end
		helper_1b234()
		if vm.skipping() then
			return skip(48)
		end
		if vm.wait() then
			return skip(49)
		end
		event.ResetCamera(0)
	end
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.StopBgm(0)
	if vm.wait() then
		return skip(1)
	end
	if vm.wait() then
		return skip(2)
	end
	if vm.wait() then
		return skip(3)
	end
	if vm.wait() then
		return skip(4)
	end
	event.LoadBgm(33)
	event.LoadSound(7833)
	var4 = event.SndLoadSound(7833) or var4
	helper_1b860()
	event.SetStatus(1, 0, 256, 1)
	projection = event.GetProjection() or projection
	event.InitDramaScene()
	event.EohSetFootSoundId(0, 2)
	event.EohSetFootSoundId(1, 2)
	event.EohSyncChara(2, 1)
	event.EohSetShow(2, 0)
	event.EohSyncChara(3, 2)
	event.EohSetShow(3, 0)
	event.CharaActive(0, 17)
	event.CharaActive(0, 18)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おこり顔")
	event.ObjsTexAnime(0, 1, "おこり目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "おこり顔")
	event.ObjsTexAnime(1, 1, "おこり目パチ")
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "目とじ")
	event.CharaActive(1, global2)
	event.CharaActive(1, global3)
	event.CharaActive(1, 9)
	event.CharaActive(1, 19)
	event.CharaActive(1, 20)
	event.CharaActive(1, 21)
	event.CmrsSetPos(-32.56, 15.66, -127.35)
	event.CmrsSetRef(3.81, 7.02, -6.74)
	event.ObjsSetMotion(0, "かまえるL", 4, -1.0, 1)
	event.ObjsSetMotion(1, "構えるL", 4, -1.0, 1)
	event.ObjsSetMotion(2, "倒れ", 4)
	event.ObjsSetMotion(13, "ループ", 4)
	event.ObjsSetPos(5, 0.0, 0.0, 0.0)
	event.ObjsSetRot(5, 0.0, 3.12, 0.0)
	event.ObjsSetPos(2, 0.0, 0.0, 0.0)
	event.ObjsSetRot(2, 0.0, 3.12, 0.0)
	event.ObjsSetPos(0, -10.0, 0.0, -120.19)
	event.ObjsSetRot(0, 0.0, 0.12, 0.0)
	event.ObjsSetPos(1, 10.0, 0.0, -120.73)
	event.ObjsSetRot(1, 0.0, -0.12, 0.0)
	event.ObjsSetPos(11, -13.5, 2.0, -18.9)
	event.ObjsSetPos(12, 14.39, 2.0, -20.63)
	event.ObjsSetPos(13, 0.92, 2.0, -40.58)
	event.SetCharaPos(11, 0.0, 0.0, 0.0)
	event.SetCharaRot(11, 0.0, 3.12, 0.0)
	event.CmrsFadeIn(60, 255.0, 255.0, 255.0)
	helper_428(60)
	if vm.skipping() then
		return skip(5)
	end
	event.CmrsSetPos(-32.93, 11.56, -74.72)
	event.CmrsSetRef(2.53, 23.99, -128.27)
	helper_428(60)
	if vm.skipping() then
		return skip(6)
	end
	event.SndSePlay(var4, 0)
	event.PlayBgm(0)
	event.CmrsSetPos(-9.32, 6.57, -86.8)
	event.CmrsSetRef(-1.8, 11.05, -21.29)
	event.SetMotion(11, "倒れ")
	event.CharaActive(1, 11)
	helper_428(60)
	if vm.skipping() then
		return skip(7)
	end
	event.CmrsInitPas()
	event.CmrsSetPasFrm(120)
	event.CmrsAddPas(-9.32, 6.57, -86.8, -1.8, 11.05, -21.29)
	event.CmrsAddPas(-9.32, 74.82, -86.8, -1.8, 79.3, -21.29)
	event.CmrsStartPas()
	helper_2888()
	if vm.skipping() then
		return skip(8)
	end
	event.SndSeStop(var4, 0)
	event.CmrsSetPos(0.0, 39.3, -81.55)
	event.CmrsSetRef(0.0, 43.79, 47.97)
	event.SetCrossfade(30)
	event.SetCharaPos(12, 0.0, 0.0, 0.0)
	event.SetCharaRot(12, 0.0, 0.0, 0.0)
	event.SetReference(10, "tama", 12)
	event.CharaActive(0, 11)
	event.CharaActive(1, 12)
	event.CharaActive(1, 10)
	event.ObjsSetMotion(5, "頭出る", 2)
	event.ObjsNextMotion(5, "頭出るL", 4)
	event.SetMotion(12, "煙", 4)
	helper_428(60)
	if vm.skipping() then
		return skip(9)
	end
	helper_5644(7280130, -1)
	if vm.skipping() then
		return skip(10)
	end
	helper_428(15)
	if vm.skipping() then
		return skip(11)
	end
	event.SndSePlay(var4, 1)
	event.ObjsSetPos(5, -9.28, 0.0, 92.69)
	event.ObjsSetRot(5, 0.0, 3.12, 0.0)
	event.CmrsSetPos(2.87, 91.44, 141.96)
	event.CmrsSetRef(-29.58, -87.11, -60.47)
	event.ObjsSetMotion(5, "手出る", 2)
	event.ObjsNextMotion(5, "手出るL", 4)
	event.CmrsInitPas()
	event.CmrsSetPasFrm(60)
	event.CmrsAddPas(-2.01, 89.39, 130.66, -44.03, -87.11, -58.36)
	event.CmrsAddPas(11.99, 89.39, 127.55, -30.02, -87.11, -61.48)
	event.CmrsStartPas()
	helper_2888()
	if vm.skipping() then
		return skip(12)
	end
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おこり顔")
	event.ObjsTexAnime(0, 1, "おこり目パチ")
	event.ObjsTexAnime(0, 1, "半口")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "おこり顔")
	event.ObjsTexAnime(1, 1, "おこり目パチ")
	event.ObjsTexAnime(1, 1, "口とじ～大口")
	event.CmrsSetPos(-13.15, 15.34, -65.86)
	event.CmrsSetRef(-0.08, 23.99, -128.89)
	helper_428(30)
	if vm.skipping() then
		return skip(13)
	end
	event.ObjsSetPos(5, 4.78, 0.0, 53.85)
	event.ObjsSetRot(5, 0.0, 3.12, 0.0)
	event.CmrsSetPos(-57.13, 39.76, -179.68)
	event.CmrsSetRef(-1.0, 27.1, -92.85)
	event.SndSePlay(var4, 2)
	event.ObjsSetMotion(5, "手を上げる", 2)
	event.ObjsNextMotion(5, "手を上げるL", 4)
	helper_2998(5)
	if vm.skipping() then
		return skip(14)
	end
	event.CmrsInitPas()
	event.CmrsSetPasFrm(30)
	event.CmrsAddPas(-9.42, 77.41, 0.77, 18.74, 30.15, 60.29)
	event.CmrsAddPas(-9.42, 110.88, 0.77, 18.74, 63.62, 60.29)
	event.CmrsStartPas()
	event.SndSePlay(var4, 2)
	event.ObjsSetMotion(5, "手を上げる", 6)
	event.ObjsNextMotion(5, "手を上げるL", 4)
	helper_2998(5)
	if vm.skipping() then
		return skip(15)
	end
	helper_2888()
	if vm.skipping() then
		return skip(16)
	end
	event.SetProjection(2000.0)
	event.ObjsSetPos(5, -1.85, 0.0, 111.08)
	event.ObjsSetRot(5, 0.0, 3.12, 0.0)
	event.CmrsSetPos(-65.42, 178.12, 284.97)
	event.CmrsSetRef(1.97, 9.98, -1.2)
	event.ObjsSetMotion(5, "刺す", 6)
	event.ObjsSetMotionNowTime(5, 7.3)
	event.ObjsSetStep(5, 0.0)
	event.CmrsInitPas()
	event.CmrsSetPasFrm(30)
	event.CmrsAddPas(-93.52, 235.35, 238.15, 10.9, 0.71, 16.2)
	event.CmrsAddPas(-51.36, 154.32, 132.67, 1.44, 0.71, -4.66)
	event.CmrsStartPas()
	helper_2888()
	if vm.skipping() then
		return skip(17)
	end
	event.SetProjection(projection)
	event.ObjsSetPos(0, 0.0, 0.0, 0.0)
	event.ObjsSetRot(0, 0.0, 3.12, 0.0)
	event.ObjsSetPos(2, 0.0, 0.0, 0.0)
	event.ObjsSetRot(2, 0.0, 3.12, 0.0)
	event.CmrsSetPos(-4.32, 54.48, 94.69)
	event.CmrsSetRef(14.36, 29.4, 225.15)
	event.ObjsSetMotionNowTime(5, 0.0)
	event.ObjsSetStep(5, 0.2)
	event.ObjsSetMotion(0, "助ける", 6)
	event.ObjsNextMotion(0, "助けるL", 4)
	event.ObjsSetMotion(2, "助ける", 6)
	event.ObjsNextMotion(2, "助けるL", 4)
	helper_428(20)
	if vm.skipping() then
		return skip(18)
	end
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おこり顔")
	event.ObjsTexAnime(0, 1, "おこり目パチ")
	event.ObjsSetMotion(5, "手を上げるL", 4)
	event.ObjsSetPos(5, 2.97, 0.0, 29.69)
	event.ObjsSetRot(5, 0.0, 3.12, 0.0)
	event.CmrsSetPos(-6.23, 29.14, -137.75)
	event.CmrsSetRef(7.05, 22.23, 28.01)
	event.ObjsSetMotion(5, "刺す", 6)
	event.ObjsNextMotion(5, "刺すL", 4)
	event.SndSePlay(var4, 3)
	helper_428(15)
	if vm.skipping() then
		return skip(19)
	end
	event.CharaActive(1, 23)
	event.SetCharaPos(23, 0.0, 0.0, 0.0)
	event.SetCharaRot(23, 0.0, 0.0, 0.0)
	event.SetMotion(23, "暗黒エレキ", 6, -1, 1)
	event.CmrsQuake(0.0, 0.6, 0.0, 30)
	helper_2888()
	if vm.skipping() then
		return skip(20)
	end
	helper_428(30)
	if vm.skipping() then
		return skip(21)
	end
	event.ObjsSetPos(2, 35.51, 0.0, -10.86)
	event.ObjsSetRot(2, 0.0, 1.68, 0.0)
	event.ObjsSetPos(0, 35.51, 0.0, -10.86)
	event.ObjsSetRot(0, 0.0, 1.68, 0.0)
	event.ObjsSetMotion(0, "抱え", 4)
	event.ObjsSetMotion(2, "抱え", 4)
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "目とじ～目あき")
	event.CharaActive(0, 23)
	event.ObjsSetMotion(5, "刺すL", 4)
	event.ObjsSetPos(2, 200.0, 0.0, 0.0)
	event.ObjsSetRot(2, 0.0, -1.44, 0.0)
	event.ObjsSetPos(0, 200.0, 0.0, 0.0)
	event.ObjsSetRot(0, 0.0, -1.44, 0.0)
	event.CmrsSetPos(130.67, 16.54, 1.06)
	event.CmrsSetRef(202.0, 15.78, 1.22)
	helper_5644(7280140, 30)
	if vm.skipping() then
		return skip(22)
	end
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "通常目パチ")
	event.ObjsSetMotion(0, "寝かせる", 2)
	event.ObjsNextMotion(0, "寝かせるL", 4)
	event.ObjsSetMotion(2, "寝かせる", 2)
	event.ObjsNextMotion(2, "寝かせるL", 4)
	helper_2998(2)
	if vm.skipping() then
		return skip(23)
	end
	helper_2998(0)
	if vm.skipping() then
		return skip(24)
	end
	helper_428(15)
	if vm.skipping() then
		return skip(25)
	end
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おこり顔")
	event.ObjsTexAnime(0, 1, "前向き～下向き")
	event.ObjsSetMotion(0, "うなづく", 2)
	event.ObjsNextMotion(0, "寝かせるL", 4)
	helper_2998(0)
	if vm.skipping() then
		return skip(26)
	end
	event.SndSePlay(var4, 4)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おこり顔")
	event.ObjsTexAnime(0, 1, "下向き～前向き")
	event.SndSePlay(var4, 5)
	event.ObjsSetMotion(0, "立つ", 2)
	event.ObjsNextMotion(0, "立ち", 4)
	helper_2998(0)
	if vm.skipping() then
		return skip(27)
	end
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おこり顔")
	event.ObjsTexAnime(0, 1, "おこり目パチ")
	event.ObjsSetPos(5, 2.97, 0.0, 29.69)
	event.ObjsSetRot(5, 0.0, 1.8, 0.0)
	event.ObjsSetPos(0, 81.45, 0.0, 21.84)
	event.ObjsSetRot(0, 0.0, -1.44, 0.0)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		event.CharaActive(1, 17)
		event.CharaActive(1, 18)
	else
		event.EohSyncChara(2, 1)
		event.EohSetShow(2, 1)
		event.EohSyncChara(3, 2)
		event.EohSetShow(3, 1)
	end
	event.SndSePlay(var4, 6)
	event.ObjsSetMotion(0, "かまえる", 6)
	event.ObjsNextMotion(0, "かまえるL", 4)
	event.CmrsSetPos(166.63, 38.2, -13.18)
	event.CmrsSetRef(70.91, 29.78, 10.61)
	helper_5644(7280150, -1)
	if vm.skipping() then
		return skip(28)
	end
	event.FadeOutBgm(60)
	helper_428(60)
	if vm.skipping() then
		return skip(29)
	end
	event.StopBgm(0)
	if vm.wait() then
		return skip(30)
	end
	if vm.wait() then
		return skip(31)
	end
	if vm.wait() then
		return skip(32)
	end
	if vm.wait() then
		return skip(33)
	end
	event.LoadBgm(167)
	event.PlayBgm(0)
	event.ObjsSetPos(5, 2.97, 0.0, 29.69)
	event.ObjsSetRot(5, 0.0, 3.12, 0.0)
	event.ObjsSetPos(0, -10.0, 0.0, -120.19)
	event.ObjsSetRot(0, 0.0, 0.12, 0.0)
	event.CmrsInitPas()
	event.CmrsSetPasFrm(60)
	event.CmrsAddPas(0.1, 17.53, -95.17, 5.91, 10.61, 34.67)
	event.CmrsAddPas(-1.18, 22.61, -123.61, 5.91, 32.94, 34.67)
	event.CmrsStartPas()
	event.SndSePlay(var4, 7)
	event.ObjsSetMotion(5, "杖かざす", 6)
	event.ObjsNextMotion(5, "杖かざすL", 4)
	event.ObjsMove2(11, -22.49, 36.0, -50.18, 40, 0, 1.0)
	event.ObjsMove2(12, 14.15, 32.65, -67.78, 40, 0, 1.0)
	event.ObjsMove2(13, -7.3, 24.54, -54.27, 40, 0, 1.0)
	helper_428(90)
	if vm.skipping() then
		return skip(34)
	end
	event.CmrsSetPos(14.08, 134.04, -46.86)
	event.CmrsSetRef(3.49, 46.6, 27.57)
	event.SetReference(22, "red", 19)
	event.SetReference(22, "blue", 20)
	event.SetReference(22, "yellow", 21)
	event.ObjsSetPos(11, 0.0, 0.0, 0.0)
	event.ObjsSetPos(12, 0.0, 0.0, 0.0)
	event.ObjsSetPos(13, 0.0, 0.0, 0.0)
	event.CharaActive(0, 12)
	event.SetCharaPos(22, 2.97, 0.0, 29.69)
	event.SetCharaRot(22, 0.0, 3.12, 0.0)
	event.CharaActive(1, 22)
	event.SetMotion(22, "ブルブル", 2, -1, 1)
	helper_428(30)
	if vm.skipping() then
		return skip(35)
	end
	event.ObjsSetMotion(5, "ブルブル", 4)
	event.CharaActive(0, 19)
	event.CharaActive(0, 20)
	event.CharaActive(0, 21)
	helper_428(90)
	if vm.skipping() then
		return skip(36)
	end
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おこり顔")
	event.ObjsTexAnime(0, 1, "おこり目パチ")
	event.ObjsTexAnime(0, 1, "半口")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "おこり顔")
	event.ObjsTexAnime(1, 1, "おこり目パチ")
	event.ObjsTexAnime(1, 1, "半口")
	event.CmrsSetPos(-34.37, 35.47, -57.39)
	event.CmrsSetRef(-2.38, 20.71, -112.3)
	event.ObjsSetMotion(1, "おどろき", 2, -1.0, 1)
	event.ObjsNextMotion(1, "おどろきL", 4)
	event.ObjsSetMotion(0, "驚く", 2, -1.0, 1)
	event.ObjsNextMotion(0, "驚くL", 4)
	event.CharaActive(0, 10)
	event.CharaActive(0, 22)
	helper_428(60)
	if vm.skipping() then
		return skip(37)
	end
	event.DeleteChara(10)
	event.DeleteChara(11)
	event.DeleteChara(12)
	event.DeleteChara(22)
	event.DeleteChara(19)
	event.DeleteChara(20)
	event.DeleteChara(21)
	event.ClearStack(6)
	event.LoadChara(6, "event/e700/e728/e728_dark.gltf", "info", 10)
	event.CharaActive(0, 10)
	event.EohSyncChara(15, 10)
	event.ObjsInit(15, 10)
	event.ObjsSyncObj(15, 15)
	event.LoadChara(6, "event/e700/e728/e728_power.gltf", "info", 11)
	event.CharaActive(0, 11)
	event.SetCharaType(11, 4)
	event.LoadChara(6, "event/e700/e728/e728_deeye.gltf", "info", 12)
	event.CharaActive(0, 12)
	event.SetCharaType(12, 4)
	event.LoadChara(6, "event/e700/e728/e728_gokou.gltf", "info", 22)
	event.CharaActive(0, 22)
	event.EohSyncChara(9, 22)
	event.ObjsInit(9, 22)
	event.ObjsSyncObj(9, 9)
	event.SetCharaType(22, 4)
	event.LoadChara(6, "event/e700/e728/b11a_hikari_blue.gltf", "info", 23)
	event.CharaActive(0, 23)
	event.SetCharaType(23, 4)
	event.LoadChara(6, "event/e700/e728/e728_gokou2.gltf", "info", 19)
	event.CharaActive(0, 19)
	event.SetCharaType(19, 4)
	event.LoadChara(6, "event/e700/e728/e728_deobi_y.gltf", "info", 20)
	event.CharaActive(0, 20)
	event.EohSyncChara(8, 20)
	event.ObjsInit(8, 20)
	event.ObjsSyncObj(8, 8)
	event.LoadChara(6, "event/e700/e728/e728_deobi_m.gltf", "info", 21)
	event.CharaActive(0, 21)
	event.EohSyncChara(7, 21)
	event.ObjsInit(7, 21)
	event.ObjsSyncObj(7, 7)
	block = event.LoadImg_4(6, "textures/event/e700/e728/e728telop06.json", 0) or block
	event.SpriteInit(4)
	event.SpriteSetType(4, 0)
	event.SpriteSetTexture(4, "e728telop06", block)
	event.SpriteSetUvsize(4, 0, 0, 512, 128)
	event.SpriteSetPutsize(4, 512, 128)
	event.SpriteSetPos(4, 320, 334)
	event.SpriteSetColor(4, 128, 128, 128, 0)
	event.SpriteSetScale(4, 1.0, 1.0)
	event.SpriteSetDraw(4, 0)
	event.EohSyncSprite(14, 4)
	event.ObjsInit(14)
	event.ObjsSyncObj(14, 14)
	event.SetReference(10, "tama", 23)
	event.CharaActive(1, 23)
	event.CharaActive(1, 10)
	event.ObjsSetPos(15, 0.0, 0.0, 0.0)
	event.ObjsSetRot(15, 0.0, 3.12, 0.0)
	event.ObjsSetMotion(15, "立ち", 6)
	event.CharaActive(0, global2)
	if active_chr_no == 1 then
		event.CharaActive(0, 17)
		event.CharaActive(0, 18)
	else
		event.EohSyncChara(2, 1)
		event.EohSetShow(2, 0)
		event.EohSyncChara(3, 2)
		event.EohSetShow(3, 0)
	end
	event.CmrsInitPas()
	event.CmrsSetPasFrm(120)
	event.CmrsAddPas(-10.71, 26.07, -68.91, 0.0, 43.32, 0.0)
	event.CmrsAddPas(-18.68, 7.34, -120.21, 0.0, 43.32, 0.0)
	event.CmrsStartPas()
	event.SpriteSetDraw(4, 1)
	event.ObjsSetColor(14, 128, 128, 128, 128, 30)
	helper_2888()
	if vm.skipping() then
		return skip(38)
	end
	event.ObjsSetColor(14, 128, 128, 128, 0, 30)
	event.SetCharaPos(11, 0.0, 36.79, 0.0)
	event.SetCharaRot(11, 0.0, 3.12, 0.0)
	event.CharaActive(1, 11)
	event.SndSePlay(var4, 8)
	event.ObjsSetMotion(15, "手を広げる", 6)
	event.ObjsNextMotion(15, "手を広げるL", 4)
	helper_428(60)
	if vm.skipping() then
		return skip(39)
	end
	event.SetMotion(11, "手を広げるL", 4, -1, 1)
	helper_428(90)
	if vm.skipping() then
		return skip(40)
	end
	event.SetCharaPos(12, 0.0, 54.76, 0.0)
	event.SetCharaRot(12, 0.0, 3.12, 0.0)
	event.CharaActive(1, 12)
	event.SndSePlay(var4, 9)
	event.SetMotion(12, "光る", 2, -1, 1)
	event.CmrsInitPas()
	event.CmrsSetPasFrm(120)
	event.CmrsAddPas(3.2, 65.86, -18.65, 0.0, 49.46, 0.0)
	event.CmrsAddPas(-6.36, 65.86, -20.29, -9.56, 49.46, -1.64)
	event.CmrsStartPas()
	event.SetCrossfade(30)
	helper_2888()
	if vm.skipping() then
		return skip(41)
	end
	event.SndSeStop(var4, 8)
	event.CharaActive(0, 12)
	event.CharaActive(0, 11)
	event.ObjsSetPos(0, -15.0, 0.0, -120.19)
	event.ObjsSetRot(0, 0.0, 0.12, 0.0)
	event.ObjsSetPos(1, 15.0, 0.0, -120.73)
	event.ObjsSetRot(1, 0.0, -0.12, 0.0)
	event.SetCharaPos(21, 15.0, 0.0, -120.73)
	event.SetCharaRot(21, 0.0, -0.12, 0.0)
	event.SetProjection(1400.0)
	event.CmrsSetPos(0.56, 50.63, -367.73)
	event.CmrsSetRef(0.5, 17.72, -1.34)
	event.CmrsMove(0.58, 50.63, -514.46, 0.5, 17.72, -1.34, 60)
	event.CharaActive(1, global2)
	event.SndSePlay(var4, 10)
	event.SetCharaPos(22, 0.0, 35.0, 240.0)
	event.SetCharaRot(22, 0.0, 3.12, 0.0)
	event.CharaActive(1, 22)
	event.ObjsSetMotion(15, "後光", 6)
	event.ObjsNextMotion(15, "後光L", 4)
	event.ObjsSetMotion(9, "後光", 6)
	event.ObjsNextMotion(9, "後光L", 4)
	event.ObjsSetMotion(1, "まぶしい", 2, -1.0, 1)
	event.ObjsNextMotion(1, "まぶしいL", 4)
	event.ObjsSetMotion(0, "まぶしい", 2, -1.0, 1)
	event.ObjsNextMotion(0, "まぶしいL", 4)
	helper_2888()
	if vm.skipping() then
		return skip(42)
	end
	event.SetReference(global2, "ground", 20)
	event.SetCharaPos(19, -40.51, 35.0, -103.49)
	event.SetCharaRot(19, 0.0, -1.2, 0.0)
	event.CmrsSetPos(-119.45, 31.61, -18.57)
	event.CmrsSetRef(-14.55, 16.86, -108.78)
	event.SetCrossfade(30)
	event.CharaActive(1, 19)
	event.SetMotion(19, "後光2", 4, -1, 1)
	helper_428(60)
	if vm.skipping() then
		return skip(43)
	end
	event.CharaActive(1, 21)
	event.CharaActive(1, 20)
	event.SndSePlay(var4, 11)
	event.ObjsSetMotion(1, "まきつき", 6)
	event.ObjsNextMotion(1, "ひっぱられ", 6)
	event.ObjsSetMotion(0, "まきつく", 6)
	event.ObjsNextMotion(0, "引きずり込まれる", 6)
	event.ObjsSetMotion(7, "まきつきL", 6)
	event.ObjsNextMotion(7, "ひっぱられ", 6)
	event.ObjsSetMotion(8, "まきつくL", 6)
	event.ObjsNextMotion(8, "引きずり込まれる", 6)
	helper_428(60)
	if vm.skipping() then
		return skip(44)
	end
	return part2()
end

--- Helper function.
local function helper_24198()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 13 then
			if at <= 1 then
				helper_2888()
			end
			if at <= 2 then
				helper_5644(6400090, -1)
			end
			if at <= 3 then
				helper_2998(2)
			end
			if at <= 4 then
				helper_428(20)
			end
			if at <= 5 then
				helper_5644(6400095, -1)
			end
			if at <= 6 then
				helper_2998(2)
			end
			if at <= 7 then
				helper_428(30)
			end
			if at <= 8 then
				helper_2998(2)
			end
			if at <= 9 then
				helper_5644(6400100, -1)
			end
			if at <= 10 then
				helper_428(60)
			end
			if at <= 11 then
				helper_2998(2)
			end
			if at <= 12 then
				helper_428(30)
			end
			if vm.skip_end() then
				return skip(14)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SndSeStop(var0, 0)
		event.SndSeStop(var0, 1)
		event.SetMotionBlur(0)
		event.BgmLoadCancel()
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
		event.LoadMes(0, -1)
	end
	event.SetFlag(640, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.StopBgm(0)
	helper_428(4)
	if vm.skipping() then
		return skip(1)
	end
	event.LoadBgm(33)
	event.PlayBgm(0)
	event.LoadSound(6208)
	var0 = event.SndLoadSound(6208) or var0
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.SetStatus(1, 0, 256, 1)
	event.ChangeDir("event/e600/e640/")
	event.LoadMes(0, 5, "e640.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e640_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e640_monica.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.LoadChara(5, "e640_griffon.gltf", "info", 34)
	event.CharaActive(34)
	event.EohSyncChara(2, 34)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.LoadChara(5, "e640_grigokou.gltf", "info", 35)
	event.CharaActive(35)
	event.EohSyncChara(3, 35)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.ChangeDir("")
	if active_chr_no == 1 then
		event.LoadChara(5, "chara/c01_base.gltf", "info", 32)
		event.LoadEquip(5, 0, 4, "info", 32)
		event.LoadEquip(5, 0, 3, "info", 32)
		event.LoadEquip(5, 0, 2, "info", 32, 33)
		event.LoadMotion(5, "event/e600/e640/e640_mints.gltf", "info", 32)
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
		event.LoadMotion(5, "event/e600/e640/e640_monica.gltf", "info", 32)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 32)
		event.EohSyncChara(1, 32)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 0)
	end
	event.CharaActive(32)
	event.CharaActive(33)
	event.EohSetPos(0, 0.0, 0.0, 0.0)
	event.EohSetRot(0, 0.0, 3.14, 0.0)
	event.EohSetFootSoundId(0, 2)
	event.EohSetPos(1, 0.0, 0.0, 0.0)
	event.EohSetRot(1, 0.0, 3.14, 0.0)
	event.EohSetFootSoundId(1, 2)
	event.EohSetPos(2, -12.69, 210.91, 31.92)
	event.EohSetRot(2, 0.0, 0.0, 0.0)
	event.EohSetFootSoundId(2, 2)
	event.EohSetPos(3, -12.69, 210.91, 31.92)
	event.EohSetRot(3, 0.0, 0.0, 0.0)
	event.InitDramaScene()
	event.CharaActive(0, 35)
	event.CmrsInit()
	event.CmrsSetPos(-16.84, 208.3, 357.29)
	event.CmrsSetRef(-12.28, 234.47, 95.52)
	event.SetFadeIn(30)
	event.SetMotionBlur(100)
	event.CmrsMove2(-13.43, 263.98, 96.05, -12.81, 265.44, 61.96, 60, 2, 1.0)
	helper_2888()
	if vm.skipping() then
		return skip(2)
	end
	event.SetCrossfade(30)
	event.SetMotionBlur(0)
	event.CmrsMove2(-13.21, 262.59, 85.71, -12.24, 265.7, 32.15, 300, 2, 1.0)
	event.ObjsSetMotion(2, "会話翼閉じ")
	event.ObjsMotionDelay(2, 60)
	event.ObjsNextMotion(2, "立ち翼閉じ", 4)
	helper_5644(6400090, -1)
	if vm.skipping() then
		return skip(3)
	end
	helper_2998(2)
	if vm.skipping() then
		return skip(4)
	end
	helper_428(20)
	if vm.skipping() then
		return skip(5)
	end
	event.ObjsSetMotion(2, "会話翼閉じ")
	helper_5644(6400095, -1)
	if vm.skipping() then
		return skip(6)
	end
	event.ObjsNextMotion(2, "立ち翼閉じ", 4)
	helper_2998(2)
	if vm.skipping() then
		return skip(7)
	end
	helper_428(30)
	if vm.skipping() then
		return skip(8)
	end
	event.CmrsInit()
	event.CmrsSetPos(17.28, 279.9, 82.24)
	event.CmrsSetRef(-12.04, 265.49, 33.59)
	helper_2998(2)
	if vm.skipping() then
		return skip(9)
	end
	event.ObjsSetMotion(2, "会話翼閉じ")
	event.ObjsMotionDelay(2, 120)
	event.ObjsNextMotion(2, "広げ", 6)
	event.ObjsNextMotion(2, "広げＬ", 4)
	event.CmrsPrdelay(110)
	event.CmrsSetPos(-12.04, 271.55, 72.44)
	event.CmrsSetRef(-12.55, 264.36, 33.58)
	event.CmrsMove2(-13.58, 244.64, 142.02, -12.47, 253.04, 34.41, 60, 0, 0.5)
	event.ObjsSeDelay(2, 110)
	event.ObjsSePlay(2, var0, 0)
	event.ObjsMotionDelay(2, 110)
	helper_5644(6400100, -1)
	if vm.skipping() then
		return skip(10)
	end
	event.CharaActive(35)
	event.SetCharaShow(35, 1, 1, 0.033333335)
	helper_428(60)
	if vm.skipping() then
		return skip(11)
	end
	event.ObjsSetMotion(2, "コントロール", 6)
	event.ObjsNextMotion(2, "コントロールＬ", 4)
	helper_2998(2)
	if vm.skipping() then
		return skip(12)
	end
	event.SetFadeOut(30)
	helper_428(30)
	if vm.skipping() then
		return skip(13)
	end
	return part2()
end

--- Helper function.
local function helper_1030()
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
local function helper_1134(arg0: s32)
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
local function helper_60a8(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_1134(1)
		end
		if at <= 2 then
			helper_3bdc(0, arg1)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.StreamOpen3(1, arg0)
	helper_1134(1)
	if vm.skipping() then
		return skip(2)
	end
	event.StreamPlay(1)
	helper_3bdc(0, arg1)
	if vm.skipping() then
		return skip(3)
	end
	event.StreamClose(1)
end

--- Helper function.
local function helper_eac(arg0: s32)
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
local function helper_2ab4(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesWindowMode(arg0, arg1)
end

--- Helper function.
local function helper_ca38(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_2ab4(1, 4)
			helper_8540(1, vm.i32(60 + arg0), 8, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(1, 4)
	helper_2ab4(1, 4)
	helper_8540(1, vm.i32(60 + arg0), 8, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_df44(arg0: s32, arg1: s32)
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
				helper_428(30)
			end
			if at <= 2 then
				helper_1030()
			end
			if at <= 3 then
				helper_428(30)
			end
			if at <= 4 then
				helper_60a8(arg1, -1)
			end
			if at <= 5 then
				helper_428(10)
			end
			if at <= 6 then
				helper_428(30)
			end
			if at <= 7 then
				helper_428(120)
			end
			if at <= 8 then
				local _ = helper_eac(0)
			end
			if at <= 9 then
				helper_ca38(1)
			end
			if at <= 10 then
				helper_ca38(4)
			end
			if at <= 11 then
				helper_ca38(active_chr_no)
			end
			if at <= 12 then
				helper_ca38(1)
			end
			if at <= 13 then
				helper_428(30)
			end
			if at <= 15 then
				helper_428(30)
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
	helper_428(30)
	if vm.skipping() then
		return skip(2)
	end
	event.SetStatusbarShow(0, 0.06666667)
	helper_1030()
	if vm.skipping() then
		return skip(3)
	end
	event.LoadBgmPack(60)
	if var8 == 1 or var8 ~= 1 and arg1 < 0 then
		event.PlayBgm(0)
	end
	helper_428(30)
	if vm.skipping() then
		return skip(4)
	end
	event.DngPause(1, 1)
	event.DngCollisionAllClr()
	if var8 ~= 1 then
		block = event.LoadImg_4(5, "textures/dungeon/image/gameover.json", 1) or block
		if arg1 >= 0 then
			helper_60a8(arg1, -1)
			if vm.skipping() then
				return skip(5)
			end
			helper_428(10)
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
		helper_428(30)
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
		helper_428(120)
		if vm.skipping() then
			return skip(8)
		end
		while true do
			if helper_eac(0) ~= 0 then
				break
			end
			if vm.wait() then
				return skip(9)
			end
		end
	elseif active_chr_no == 3 then
		var10 = event.CheckEnableCharaChange(1) or var10
		if var10 == 0 then
			helper_ca38(1)
			if vm.skipping() then
				return skip(10)
			end
		else
			helper_ca38(4)
			if vm.skipping() then
				return skip(11)
			end
		end
	elseif active_chr_no == 0 or active_chr_no == 2 then
		helper_ca38(active_chr_no)
		if vm.skipping() then
			return skip(12)
		end
	else
		helper_ca38(1)
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
		helper_428(30)
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
		helper_428(30)
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
	helper_428(4)
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
local function helper_102a8(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		return helper_df44(arg0, arg1)
	end
	if vm.skipping() then
		return skip(1)
	end
	return helper_df44(arg0, arg1)
end

--- Helper function.
local function helper_10210(arg0: s32)
	return helper_df44(arg0, -1)
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

script[99] = program_99

--- Program 100.
script[100] = function()
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_18f4(0.0, 0.0, -200.0, 0.0)
		end
	end
	program_99()
	flag = event.GetFlag(58) or flag
	if flag == 1 then
		helper_10334()
		if vm.skipping() then
			return skip(1)
		end
		event.SetBitCtrl(1, 1)
		helper_18f4(0.0, 0.0, -200.0, 0.0)
		event.SetCameraRef(0.0, 30.0, -200.0)
		event.SetCameraPos(0.0, 40.0, -320.0)
		event.ResetCamera(0)
		if vm.wait() then
			return skip(2)
		end
		event.LoadMonsterFile(615, 1)
		event.LoadMonsterFile(618, 0)
		event.LoadMonsterFile(619, 0)
		event.LoadMonsterFile(620, 0)
		event.AutoSetMonster(615, 0.0, 50.0, 0.0, 0.0, 3.14, 0.0)
	end
	event.SetFadeIn(30)
	event.Finish()
end

--- Program 150.
script[150] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_f50(32)
		end
	end
	if vm.wait() then
		return skip(1)
	end
	helper_f50(32)
	if vm.skipping() then
		return skip(2)
	end
end

--- Program 151.
script[151] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_428(4)
		end
		if at <= 2 then
			print("Autoset---------------------------------------\n")
		end
	end
	event.Initialize()
	if vm.wait() then
		return skip(1)
	end
	event.SetFadeIn(30)
	event.StopBgm(0)
	helper_428(4)
	if vm.skipping() then
		return skip(2)
	end
	event.LoadBgm(41)
	event.PlayBgm(0)
	event.LoadMonsterFile(615, 1)
	event.LoadMonsterFile(618, 0)
	event.LoadMonsterFile(619, 0)
	event.LoadMonsterFile(620, 0)
	event.AutoSetMonster(615, 0.0, 50.0, 0.0, 0.0, 0.0, 0.0)
	print("Autoset---------------------------------------\n")
	if vm.wait() then
		return skip(3)
	end
	event.Finish()
end

--- Program 152.
script[152] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_428(30)
		end
		if at <= 3 then
			helper_8540(0, -1, 8, 0, 0)
		end
	end
	event.Initialize()
	if vm.wait() then
		return skip(1)
	end
	event.SetFadeOut(30)
	helper_428(30)
	if vm.skipping() then
		return skip(2)
	end
	event.DngPause(15, 1)
	event.DelMonster(-1)
	event.SetFadeIn(30)
	if vm.wait() then
		return skip(3)
	end
	event.MesMake_2(0, "e720 戦闘中回想１")
	helper_8540(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.DngPause(15, 0)
	event.LoadMonsterFile(616, 1)
	event.AutoSetMonster(616, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
	if vm.wait() then
		return skip(5)
	end
	event.Finish()
end

--- Program 153.
script[153] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_428(30)
		end
		if at <= 3 then
			helper_8540(0, -1, 8, 0, 0)
		end
	end
	event.Initialize()
	if vm.wait() then
		return skip(1)
	end
	event.SetFadeOut(30)
	helper_428(30)
	if vm.skipping() then
		return skip(2)
	end
	event.DngPause(15, 1)
	event.DelMonster(-1)
	event.SetFadeIn(30)
	if vm.wait() then
		return skip(3)
	end
	event.MesMake_2(0, "e724 戦闘中回想２")
	helper_8540(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.DngPause(15, 0)
	event.LoadMonsterFile(617, 1)
	event.AutoSetMonster(617, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
	if vm.wait() then
		return skip(5)
	end
	event.Finish()
end

--- Program 154.
script[154] = function()
	event.LoadDungeonMapFile("d06b02")
	event.LoadScript("d06/d06b02.stb", 100)
end

--- Program 155.
script[155] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	program_502()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 160.
script[160] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	if vm.wait() then
		return skip(1)
	end
	event.AddItem(20, 1)
	event.AddItem(21, 1)
	event.AddItem(39, 1)
	event.AddItem(40, 1)
	event.AddItem(34, 1)
	event.AddItem(79, 1)
	event.AddItem(81, 1)
	event.AddItem(60, 1)
	event.AddItem(83, 1)
	event.AddItem(78, 1)
	event.AddItem(57, 1)
	event.AddItem(89, 1)
	event.AddItem(88, 1)
	event.AddItem(101, 1)
	event.AddItem(102, 1)
	event.AddItem(109, 1)
	event.AddItem(108, 1)
	if vm.wait() then
		return skip(2)
	end
	event.Finish()
end

--- Program 500.
script[500] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	event.ActchrSetDefMotion(0)
	event.SetFadeOut(10)
	helper_428(10)
	if vm.skipping() then
		return skip(1)
	end
	event.SetCharaShow(1, 0)
	event.SetCharaShow(2, 0)
	event.SetStatusbarShow(0, 1.0)
	event.DelMonster(-1)
	event.BgmLoadCancel()
	event.SoundLoadCancel()
	event.LoadDungeonMapFile("s64")
	event.LoadScript("s64/s64.stb", 500)
end

--- Program 501.
script[501] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	event.ActchrSetDefMotion(0)
	event.SetFadeOut(10)
	helper_428(10)
	if vm.skipping() then
		return skip(1)
	end
	event.SetCharaShow(1, 0)
	event.SetCharaShow(2, 0)
	event.SetStatusbarShow(0, 1.0)
	event.DelMonster(-1)
	event.BgmLoadCancel()
	event.LoadDungeonMapFile("s31")
	event.LoadScript("s31/s31.stb", 520)
end

script[502] = program_502

--- Program 510.
script[510] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_18f4(0.0, 0.0, -200.0, 0.0)
		end
	end
	helper_14a70()
	if vm.skipping() then
		return skip(1)
	end
	helper_18f4(0.0, 0.0, -200.0, 0.0)
	event.SetCameraRef(0.0, 30.0, -200.0)
	event.SetCameraPos(0.0, 40.0, -320.0)
	event.ResetCamera(0)
	event.SetCharaShow(1, 1)
	event.SetCharaShow(2, 1)
	event.SetStatusbarShow(1, 1.0)
	if vm.wait() then
		return skip(2)
	end
	event.LoadMonsterFile(616, 1)
	event.AutoSetMonster(616, 0.0, 0.0, 150.0, 0.0, 3.14, 0.0)
	event.SetFadeIn(30)
	event.Finish()
end

--- Program 511.
script[511] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_18f4(0.0, 0.0, -200.0, 0.0)
		end
	end
	helper_16dcc()
	if vm.skipping() then
		return skip(1)
	end
	helper_18f4(0.0, 0.0, -200.0, 0.0)
	event.SetCameraRef(0.0, 30.0, -150.0)
	event.SetCameraPos(0.0, 40.0, -270.0)
	event.ResetCamera(0)
	event.SetCharaShow(1, 1)
	event.SetCharaShow(2, 1)
	event.SetStatusbarShow(1, 1.0)
	if vm.wait() then
		return skip(2)
	end
	event.LoadMonsterFile(617, 1)
	event.AutoSetMonster(617, 0.0, 0.0, 150.0, 0.0, 3.14, 0.0)
	event.SetFadeIn(30)
	event.Finish()
end

--- Program 512.
script[512] = function()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_428(4)
		end
	end
	helper_1d25c()
	if vm.skipping() then
		return skip(1)
	end
	var0 = event.GetBgmNo() or var0
	if var0 ~= 167 then
		event.StopBgm(0)
		helper_428(4)
		if vm.skipping() then
			return skip(2)
		end
		event.LoadBgm(167)
		event.PlayBgm(0)
	end
	event.BgmLoadCancel()
	event.LoadDungeonMapFile("d06b03")
	event.LoadScript("d06b03/d06b03.stb", 550)
end

--- Program 600.
script[600] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_24198()
	if vm.skipping() then
		return skip(1)
	end
	event.MapJump(-1, "s32", 600)
	if vm.wait() then
		return skip(2)
	end
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
				helper_102a8(0, 8560070)
			end
			return
		end
	end
	flag = event.GetFlag(716) or flag
	flag_2 = event.GetFlag(728) or flag_2
	if flag ~= 0 and flag_2 == 0 then
		value = event.GetRandInt(100) or value
		if value < 50 then
			helper_102a8(0, 8560060)
			if vm.skipping() then
				return skip(1)
			end
		else
			helper_102a8(0, 8560070)
			if vm.skipping() then
				return skip(2)
			end
		end
		return
	end
	helper_10210(0)
	if vm.skipping() then
		return skip(3)
	end
end

--- Program 17160.
script[17160] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_10334()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 17200.
script[17200] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetCharaShow(1, 0)
	event.SetCharaShow(2, 0)
	event.SetStatusbarShow(0, 1.0)
	event.LoadDungeonMapFile("s64")
	event.LoadScript("s64/s64.stb", 500)
	if vm.wait() then
		return skip(1)
	end
end

--- Program 17240.
script[17240] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetCharaShow(1, 0)
	event.SetCharaShow(2, 0)
	event.SetStatusbarShow(0, 1.0)
	event.LoadDungeonMapFile("s31")
	event.LoadScript("s31/s31.stb", 520)
	if vm.wait() then
		return skip(1)
	end
end

--- Program 17280.
script[17280] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_1a1b8()
	if vm.skipping() then
		return skip(1)
	end
	event.LoadDungeonMapFile("s44")
	event.LoadScript("s44/s44.stb", 510)
end

return script
