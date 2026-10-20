--!strict
-- map/f/f01/f01.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_342a37b0 = require("@lib/event/helper_342a37b0")
local helper_66ac1f76 = require("@lib/event/helper_66ac1f76")
local helper_b84429a4 = require("@lib/event/helper_b84429a4")
local helper_c5ea1698 = require("@lib/event/helper_c5ea1698")
local helper_e538a72d = require("@lib/event/helper_e538a72d")
local helper_ee09935e = require("@lib/event/helper_ee09935e")

local global0: s32 = 0
local global1: s32 = 0
local global2: s32 = 0
local global3: s32 = 0
local global4: s32 = 0
local global5: s32 = 0
local global6: s32 = 0
local global7: s32 = 0
local global8: any = 0
local global9: any = 0

--- Program 99.
local function program_99()
	local var0: s32 = 0
	local var2: s32 = 0
	event.FuncPointShow("", "e277", 0)
	var0 = 0
	var2 = event.GetAnalyze(104) or var2
	if var2 ~= 0 then
		var0 = 1
	end
	var2 = event.GetAnalyze(105) or var2
	if var2 ~= 0 then
		var0 = 1
	end
	var2 = event.GetAnalyze(106) or var2
	if var0 ~= 0 then
		event.EohSyncObj(1, "p11_f0101")
		event.EohSetShow(1, 0)
	end
	helper_66ac1f76()
	event.SetCharaPos(0, 205.1, -6.0, 894.1)
end

--- Helper function.
local function helper_3f8(arg0: any)
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
local function helper_1c378()
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		global2 = 0
		global3 = 33
		global2 = 33
		global3 = 0
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesWindowMode(0, 7)
	event.AssignStack(5)
	event.ClearStack(5)
	event.LoadMes(0, 5, "event/e200/e270/e270.txt")
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		global2 = 0
		global3 = 33
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", global2)
		event.LoadMotion(5, "event/e200/e270/e270_mints.gltf", "info", global2)
		event.EohSyncChara(0, global2)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global2)
		event.LoadChara(5, "chara/c02_base.gltf", "info", global3)
		event.LoadEquip(5, 1, 4, "info", global3)
		event.LoadEquip(5, 1, 3, "info", global3)
		event.LoadEquip(5, 1, 2, "info", global3, 37)
		event.LoadMotion(5, "event/e200/e270/e270_monica.gltf", "info", global3)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global3)
		event.EohSyncChara(1, global3)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global3)
		event.CharaActive(1, 37)
	end
	if active_chr_no == 1 then
		global2 = 33
		global3 = 0
		event.LoadChara(5, "chara/c01_base.gltf", "info", global2)
		event.LoadEquip(5, 0, 4, "info", global2)
		event.LoadEquip(5, 0, 3, "info", global2)
		event.LoadEquip(5, 0, 2, "info", global2, 37)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", global2)
		event.LoadMotion(5, "event/e200/e270/e270_mints.gltf", "info", global2)
		event.EohSyncChara(0, global2)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global2)
		event.CharaActive(1, 37)
		event.LoadMotion(5, "event/e200/e270/e270_monica.gltf", "info", global3)
		event.EohSyncChara(1, global3)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global3)
		event.CharaActive(0, global3)
	end
end

--- Helper function.
local function helper_2968(arg0: s32)
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
local function helper_2b10(arg0: any, arg1: any, arg2: any, arg3: any, arg4: any)
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
local function helper_2e40(arg0: s32, arg1: s32)
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
local function helper_3c68(arg0: s32)
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
			t1, var2 = helper_2e40(arg0, var2)
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
		t0, var2 = helper_2e40(arg0, var2)
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
local function helper_2d54(arg0: any)
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
local function helper_5cd8(arg0: s32)
	local stream_open_state: s32 = 0
	local stream_open_state_2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			helper_2b10(0, -1, 8, 0, 0)
			helper_3c68(0)
		end
		helper_2d54(0)
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
	helper_2b10(0, -1, 8, 0, 0)
	event.StreamPlay(1)
	helper_3c68(0)
	if vm.skipping() then
		return skip(4)
	end
	helper_2d54(0)
	event.StreamClose(1)
end

--- Helper function.
local function helper_5fc8(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_5cd8(arg0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, arg0)
	helper_5cd8(arg0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_34a8(arg0: s32, arg1: any, arg2: any)
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
		helper_2d54(arg0)
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
			helper_2d54(arg0)
		end
	end
	event.ResetPakuMotion()
	event.TrgPakuAnim(0)
	event.ResetPakuAnim()
	event.StreamStop(1)
	event.SetMesOkuri(arg0, 1)
end

--- Helper function.
local function helper_3bac(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_34a8(arg0, vm.ftoi(arg1), -1)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	helper_34a8(arg0, vm.ftoi(arg1), -1)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_5614(arg0: s32, arg1: s32)
	local stream_open_state: s32 = 0
	local stream_open_state_2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			helper_2b10(0, -1, 8, 0, 0)
			helper_3bac(0, arg1)
		end
		helper_2d54(0)
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
	helper_2b10(0, -1, 8, 0, 0)
	event.StreamPlay(1)
	helper_3bac(0, arg1)
	if vm.skipping() then
		return skip(4)
	end
	helper_2d54(0)
	event.StreamClose(1)
	event.SetMesPos(0, 0)
end

--- Helper function.
local function helper_1c0a0()
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
		event.DeleteChara(37)
	end
	if active_chr_no == 1 then
		event.CharaActive(1, global3)
		event.CharaActive(0, global2)
		event.DelExtMotion(global2)
		event.DelExtMotion(global3)
		event.DeleteChara(global2)
		event.DeleteChara(37)
	end
end

--- Helper function.
local function helper_1cfc4()
	local var4: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 45 then
			if at <= 1 then
				helper_1c378()
				helper_3f8(15)
			end
			if at <= 2 then
				helper_2968(1)
			end
			if at <= 3 then
				helper_3f8(5)
			end
			if at <= 4 then
				helper_2968(0)
			end
			if at <= 5 then
				helper_3f8(5)
			end
			if at <= 6 then
				helper_3f8(60)
			end
			if at <= 7 then
				helper_5fc8(2700010)
			end
			if at <= 8 then
				helper_5fc8(2700020)
			end
			if at <= 9 then
				helper_3f8(30)
			end
			if at <= 10 then
				helper_2968(1)
			end
			if at <= 11 then
				helper_2968(1)
			end
			if at <= 12 then
				helper_5fc8(2700030)
			end
			if at <= 13 then
				helper_3f8(30)
			end
			if at <= 14 then
				helper_3f8(15)
			end
			if at <= 15 then
				helper_5fc8(2700040)
			end
			if at <= 16 then
				helper_5fc8(2700050)
			end
			if at <= 17 then
				helper_5fc8(2700055)
			end
			if at <= 18 then
				helper_3f8(60)
			end
			if at <= 19 then
				helper_5614(2700060, -1)
			end
			if at <= 20 then
				helper_3f8(30)
			end
			if at <= 21 then
				helper_3f8(15)
			end
			if at <= 23 then
				helper_5fc8(2700070)
			end
			if at <= 24 then
				helper_2968(1)
			end
			if at <= 25 then
				helper_5fc8(2700080)
			end
			if at <= 26 then
				helper_2968(1)
			end
			if at <= 27 then
				helper_3f8(30)
			end
			if at <= 28 then
				helper_3f8(15)
			end
			if at <= 29 then
				helper_5614(2700090, -1)
			end
			if at <= 30 then
				helper_5614(2700095, -1)
			end
			if at <= 31 then
				helper_5614(2700100, -1)
			end
			if at <= 32 then
				helper_5614(2700110, -1)
			end
			if at <= 33 then
				helper_5614(2700120, -1)
			end
			if at <= 34 then
				helper_5fc8(2700130)
			end
			if at <= 35 then
				helper_2968(1)
			end
			if at <= 36 then
				helper_3f8(30)
			end
			if at <= 37 then
				helper_3f8(15)
			end
			if at <= 38 then
				helper_5fc8(2700140)
			end
			if at <= 39 then
				helper_5fc8(2700150)
			end
			if at <= 40 then
				helper_3f8(30)
			end
			if at <= 41 then
				helper_3f8(15)
			end
			if at <= 42 then
				helper_5614(2700155, -1)
			end
			if at <= 43 then
				helper_3f8(30)
			end
			if at <= 44 then
				helper_3f8(35)
			end
			if vm.skip_end() then
				return skip(46)
			end
			return part2()
		end
		helper_1c0a0()
	end
	function part2()
		event.CancelDramaScene()
		event.SetWind(-1)
		event.SndSeStop(var4, 2)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		helper_1c0a0()
		event.ResetCamera(0)
		event.SetFadeIn(30)
	end
	event.SetFlag(270, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.StopBgm(0)
	event.SetFadeOut(30)
	helper_3f8(45)
	if vm.skipping() then
		return skip(1)
	end
	event.LoadSound(2500)
	var4 = event.SndLoadSound(2500) or var4
	helper_1c378()
	event.InitDramaScene()
	event.CharaActive(1, global2)
	event.CharaActive(1, global3)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おこり顔")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "おこり顔")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.CmrsSetPos(174.76, 389.28, 1785.94)
	event.CmrsSetRef(34.41, 90.8, 382.81)
	event.SetCharaPos(0, -297.56, 0.0, -373.68)
	event.SetCharaRot(0, 0.0, 2.57, 0.0)
	event.EohSetFootSoundId(0, 1)
	event.EohSetFootSoundId(1, 1)
	event.ObjsSetPos(0, 68.8, 23.7, 1491.8)
	event.ObjsSetRot(0, 0.0, 3.05, 0.0)
	event.ObjsSetPos(1, 93.9, 23.7, 1438.4)
	event.ObjsSetRot(1, 0.0, 3.05, 0.0)
	event.SetFadeIn(30)
	event.SndSePlay(var4, 2)
	event.ObjsSetMotion(0, "歩き", 4, -1.0, 1)
	event.ObjsSetMotion(1, "歩き", 4, -1.0, 1)
	helper_3f8(15)
	if vm.skipping() then
		return skip(2)
	end
	event.ObjsMove(0, 37.43, 14.75, 561.52, 600, 1)
	event.ObjsMove(1, 58.59, 15.55, 560.22, 600, 1)
	event.CmrsInitPas()
	event.CmrsSetPasFrm(660)
	event.CmrsAddPas(174.76, 389.28, 1785.94, 34.41, 90.8, 382.81)
	event.CmrsAddPas(171.97, 318.75, 1758.0, 34.41, 90.8, 382.81)
	event.CmrsAddPas(161.43, 215.48, 1652.69, 34.41, 90.8, 382.81)
	event.CmrsAddPas(142.06, 138.98, 1459.02, 34.41, 90.8, 382.81)
	event.CmrsAddPas(64.19, 10.12, 750.23, 30.64, 90.8, 392.13)
	event.CmrsStartPas()
	helper_2968(1)
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsRotation(1, 0.0, -2.75, 0.0, 5)
	helper_3f8(5)
	if vm.skipping() then
		return skip(4)
	end
	event.ObjsSetMotion(1, "立ち", 0)
	helper_2968(0)
	if vm.skipping() then
		return skip(5)
	end
	event.ObjsRotation(0, 0.0, 3.05, 0.0, 5)
	helper_3f8(5)
	if vm.skipping() then
		return skip(6)
	end
	event.ObjsSetMotion(0, "立ち", 0)
	event.SndSeStop(var4, 2)
	helper_3f8(60)
	if vm.skipping() then
		return skip(7)
	end
	helper_5fc8(2700010)
	if vm.skipping() then
		return skip(8)
	end
	helper_5fc8(2700020)
	if vm.skipping() then
		return skip(9)
	end
	helper_3f8(30)
	if vm.skipping() then
		return skip(10)
	end
	event.CmrsSetPos(25.23, 45.67, 520.07)
	event.CmrsSetRef(56.48, 39.42, 567.84)
	event.ObjsMove(1, 58.3, 15.55, 557.33, 10, 1)
	event.ObjsSetMotion(1, "歩き", 2)
	helper_2968(1)
	if vm.skipping() then
		return skip(11)
	end
	event.ObjsSetMotion(1, "立ち", 2)
	event.ObjsNextMotion(1, "上向く", 6)
	helper_2968(1)
	if vm.skipping() then
		return skip(12)
	end
	event.ObjsNextMotion(1, "上向く会話", 2)
	event.ObjsNextMotion(1, "上向くL", 4)
	event.SetPakuAnim(1, "通常口パク")
	event.ObjsSetMotion(0, "右向く", 6)
	event.ObjsNextMotion(0, "右向くL", 0)
	helper_5fc8(2700030)
	if vm.skipping() then
		return skip(13)
	end
	event.ResetPakuAnim()
	event.ObjsNextMotion(1, "上向くL", 4)
	helper_3f8(30)
	if vm.skipping() then
		return skip(14)
	end
	event.CmrsSetPos(64.19, 10.12, 750.23)
	event.CmrsSetRef(30.64, 90.8, 392.13)
	helper_3f8(15)
	if vm.skipping() then
		return skip(15)
	end
	event.ObjsSetMotion(0, "右向く戻り")
	event.ObjsNextMotion(0, "上向く", 6)
	event.ObjsNextMotion(0, "上向くL", 4)
	helper_5fc8(2700040)
	if vm.skipping() then
		return skip(16)
	end
	event.ObjsSetMotion(1, "上向く会話", 6)
	event.ObjsNextMotion(1, "上向くL", 4)
	helper_5fc8(2700050)
	if vm.skipping() then
		return skip(17)
	end
	event.ObjsSetMotion(1, "上向く会話", 6)
	event.ObjsNextMotion(1, "上向くL", 4)
	helper_5fc8(2700055)
	if vm.skipping() then
		return skip(18)
	end
	event.ObjsNextMotion(1, "上向くL", 4)
	helper_3f8(60)
	if vm.skipping() then
		return skip(19)
	end
	event.ObjsSetMotion(0, "風", 6)
	event.ObjsNextMotion(0, "風Ｌ", 4)
	event.ObjsSetMotion(1, "風", 6)
	event.ObjsNextMotion(1, "風Ｌ", 4)
	event.SndSePlay(var4, 3)
	event.SetWind(40.0, 34.48, 48.5, 396.61)
	helper_5614(2700060, -1)
	if vm.skipping() then
		return skip(20)
	end
	event.SetWind(-1)
	event.ObjsSetMotion(0, "風戻り", 6)
	event.ObjsNextMotion(0, "上向くL", 4)
	event.ObjsSetMotion(1, "風戻り", 6)
	event.ObjsNextMotion(1, "上向くL", 4)
	helper_3f8(30)
	if vm.skipping() then
		return skip(21)
	end
	event.CmrsSetPos(25.23, 45.67, 520.07)
	event.CmrsSetRef(56.48, 39.42, 567.84)
	helper_3f8(15)
	if vm.skipping() then
		return skip(22)
	end
	event.ObjsSetMotion(1, "あいつは～専用", 6)
	event.ObjsNextMotion(1, "あいつは～専用Ｌ", 4)
	event.ObjsMotionDelay(1, 90)
	event.ObjsSetMotion(1, "時の～専用上～見立ちに", 6)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "おこり目")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "デフォルト顔")
	event.ObjsTexAnime(1, 1, "おこり目とじ")
	event.ObjsTexaDelay(1, 60)
	event.ObjsTexAnime(1, 1, "おこり目とじ～目あき")
	if vm.wait() then
		return skip(23)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_5fc8(2700070)
	if vm.skipping() then
		return skip(24)
	end
	helper_2968(1)
	if vm.skipping() then
		return skip(25)
	end
	event.ObjsMotionWait(1)
	event.ResetPakuAnim()
	event.ObjsSetMotion(1, "上向くL", 6)
	event.ObjsNextMotion(1, "上向く会話", 6)
	event.ObjsNextMotion(1, "上向くL", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_5fc8(2700080)
	if vm.skipping() then
		return skip(26)
	end
	helper_2968(1)
	if vm.skipping() then
		return skip(27)
	end
	event.ObjsMotionWait(1)
	event.ResetPakuAnim()
	event.ObjsNextMotion(1, "上向くL", 4)
	helper_3f8(30)
	if vm.skipping() then
		return skip(28)
	end
	event.CmrsInitPas()
	event.CmrsSetPasFrm(930)
	event.CmrsAddPas(132.27, 70.71, 488.53, 58.05, 36.97, 556.81)
	event.CmrsAddPas(159.15, 70.71, 562.03, 58.05, 36.97, 556.81)
	event.CmrsAddPas(132.93, 70.71, 625.44, 58.05, 36.97, 556.81)
	event.CmrsAddPas(77.3, 70.71, 656.87, 58.05, 36.97, 556.81)
	event.CmrsAddPas(28.82, 70.71, 654.67, 58.05, 36.97, 556.81)
	event.CmrsAddPas(-9.49, 70.71, 633.72, 58.05, 36.97, 556.81)
	event.CmrsAddPas(-37.15, 70.71, 595.03, 58.05, 36.97, 556.81)
	event.CmrsAddPas(-44.53, 70.71, 550.01, 58.05, 36.97, 556.81)
	event.CmrsAddPas(-32.67, 70.71, 507.99, 58.05, 36.97, 556.81)
	event.CmrsAddPas(-6.04, 70.71, 475.89, 58.05, 36.97, 556.81)
	event.CmrsStartPas()
	helper_3f8(15)
	if vm.skipping() then
		return skip(29)
	end
	event.ObjsSetMotion(1, "上向く会話", 2)
	event.ObjsNextMotion(1, "上向くL", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_5614(2700090, -1)
	if vm.skipping() then
		return skip(30)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(1, "上向く会話", 2)
	event.ObjsNextMotion(1, "上向くL", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_5614(2700095, -1)
	if vm.skipping() then
		return skip(31)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(1, "上向く会話", 2)
	event.ObjsNextMotion(1, "上向くL", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_5614(2700100, -1)
	if vm.skipping() then
		return skip(32)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(1, "上向く会話", 2)
	event.ObjsNextMotion(1, "上向くL", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_5614(2700110, -1)
	if vm.skipping() then
		return skip(33)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(1, "上向く会話", 2)
	event.ObjsNextMotion(1, "上向くL", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_5614(2700120, -1)
	if vm.skipping() then
		return skip(34)
	end
	event.ResetPakuAnim()
	event.CmrsSetPos(40.68, 60.8, 523.12)
	event.CmrsSetRef(50.29, 32.81, 569.09)
	event.ObjsSetMotion(1, "上向くL", 4)
	event.ObjsMotionDelay(1, 110)
	event.ObjsSetMotion(1, "上向き会話2", 6)
	event.ObjsNextMotion(1, "上向くL", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_5fc8(2700130)
	if vm.skipping() then
		return skip(35)
	end
	helper_2968(1)
	if vm.skipping() then
		return skip(36)
	end
	event.ObjsMotionWait(1)
	event.ResetPakuAnim()
	event.ObjsNextMotion(1, "上向くL", 4)
	helper_3f8(30)
	if vm.skipping() then
		return skip(37)
	end
	event.CmrsSetPos(64.19, 10.12, 750.23)
	event.CmrsSetRef(30.64, 90.8, 392.13)
	helper_3f8(15)
	if vm.skipping() then
		return skip(38)
	end
	helper_5fc8(2700140)
	if vm.skipping() then
		return skip(39)
	end
	helper_5fc8(2700150)
	if vm.skipping() then
		return skip(40)
	end
	helper_3f8(30)
	if vm.skipping() then
		return skip(41)
	end
	event.CmrsSetPos(19.5, 49.85, 518.46)
	event.CmrsSetRef(52.88, 36.97, 566.51)
	helper_3f8(15)
	if vm.skipping() then
		return skip(42)
	end
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おこり顔")
	event.ObjsTexAnime(0, 1, "おこり目～がっかり目")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(1, 1, "力こめ目とじ")
	event.ObjsTexAnime(1, 1, "口閉じ～口くいしばり")
	event.SndSePlay(var4, 5)
	event.ObjsSetMotion(1, "悔しがりラスト", 6)
	event.ObjsNextMotion(1, "悔しがりラストＬ", 4)
	event.ObjsSetMotion(0, "上向く戻り", 6)
	event.ObjsNextMotion(0, "立ち", 4)
	event.CmrsMove2(26.54, 49.85, 528.59, 52.88, 36.97, 566.51, 60, 2, 1.0)
	helper_5614(2700155, -1)
	if vm.skipping() then
		return skip(43)
	end
	helper_3f8(30)
	if vm.skipping() then
		return skip(44)
	end
	event.SetFadeOut(30)
	helper_3f8(35)
	if vm.skipping() then
		return skip(45)
	end
	return part2()
end

--- Helper function.
local function helper_20710()
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		global4 = 0
		global5 = 32
		global4 = 32
		global5 = 0
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesWindowMode(0, 7)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		global4 = 0
		global5 = 32
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", global4)
		event.LoadMotion(5, "event/e200/e272/e272_mints.gltf", "info", global4)
		event.EohSyncChara(0, global4)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global4)
		event.LoadChara(5, "chara/c02_base.gltf", "info", global5)
		event.LoadEquip(5, 1, 4, "info", global5)
		event.LoadEquip(5, 1, 3, "info", global5)
		event.LoadEquip(5, 1, 2, "info", global5, 37)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global5)
		event.LoadMotion(5, "event/e200/e272/e272_monica.gltf", "info", global5)
		event.EohSyncChara(1, global5)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global5)
		event.CharaActive(1, 37)
	end
	if active_chr_no == 1 then
		global4 = 32
		global5 = 0
		event.LoadChara(5, "chara/c01_base.gltf", "info", global4)
		event.LoadEquip(5, 0, 4, "info", global4)
		event.LoadEquip(5, 0, 3, "info", global4)
		event.LoadEquip(5, 0, 2, "info", global4, 37)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", global4)
		event.LoadMotion(5, "event/e200/e272/e272_mints.gltf", "info", global4)
		event.EohSyncChara(0, global4)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global4)
		event.CharaActive(1, 37)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global5)
		event.LoadMotion(5, "event/e200/e272/e272_monica.gltf", "info", global5)
		event.EohSyncChara(1, global5)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global5)
	end
	event.LoadChara(5, "event/e200/e255/e255_rafu_tane.gltf", "info", 35)
	event.CharaActive(0, 35)
	event.EohSyncChara(2, 35)
	event.ObjsInit(3, 35)
	event.ObjsSyncObj(3, 2)
	event.LoadChara(5, "event/e200/e272/e272_hanabaku.gltf", "info", 38)
	event.CharaActive(0, 38)
	event.LoadChara(5, "event/e200/e272/e272_kirakira.gltf", "info", 39)
	event.CharaActive(0, 39)
	event.EohSyncChara(4, 39)
	event.ObjsInit(5, 39)
	event.ObjsSyncObj(5, 4)
	event.LoadChara(5, "event/itemget_ev/itemget_ev.gltf", "info", 40)
	event.EohSyncChara(5, 40)
	event.ObjsInit(6)
	event.ObjsSyncObj(6, 5)
	event.CharaActive(0, 40)
	event.LoadMes(0, 5, "event/e200/e272/e272.txt")
end

--- Helper function.
local function helper_2a84(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesWindowMode(arg0, arg1)
end

--- Helper function.
local function helper_4330(arg0: any, arg1: s32)
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
local function helper_7cfc(arg0: any, arg1: s32, arg2: s32)
	local var3: s32 = 0
	local var4: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var4 = 0
			var3 = helper_4330(arg0, arg1)
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
		var3 = helper_4330(arg0, arg1)
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
local function helper_87c4(arg0: s32, arg1: any, arg2: s32, arg3: s32, arg4: s32)
	local var6: s32 = 0
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			local _ = helper_2b10(arg0, arg1, arg2, arg3, arg4)
			_, var6 = helper_7cfc(arg0, 0, var6)
		end
		helper_2d54(arg0)
	end
	if vm.skipping() then
		return skip(1)
	end
	local _ = helper_2b10(arg0, arg1, arg2, arg3, arg4)
	_, var6 = helper_7cfc(arg0, 0, var6)
	if vm.skipping() then
		return skip(2)
	end
	helper_2d54(arg0)
end

--- Helper function.
local function helper_cdfc(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local argc: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_2a84(1, 4)
			var2 = -1
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(1, 4)
	helper_2a84(1, 4)
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
	helper_87c4(1, var2, 8, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_202bc()
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		event.CharaActive(1, global4)
		event.CharaActive(0, global5)
		event.DelExtMotion(global4)
		event.DelExtMotion(global5)
		event.DelExtMotion(36)
		event.DeleteChara(global5)
		event.DeleteChara(36)
		event.DeleteChara(37)
	end
	if active_chr_no == 1 then
		event.CharaActive(1, global5)
		event.CharaActive(0, global4)
		event.DelExtMotion(global4)
		event.DelExtMotion(global5)
		event.DelExtMotion(36)
		event.DeleteChara(global4)
		event.DeleteChara(36)
		event.DeleteChara(37)
	end
	event.DeleteChara(35)
	event.DeleteChara(38)
	event.DeleteChara(39)
	event.DeleteChara(40)
	event.SetMpcharaMotion("jyuraku", "jyuraku", "瞬き")
end

--- Helper function.
local function helper_21790()
	local var10: s32 = 0
	local var11: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 47 then
			if at <= 1 then
				helper_20710()
				helper_3f8(15)
			end
			if at <= 2 then
				helper_2968(0)
			end
			if at <= 3 then
				helper_3f8(5)
			end
			if at <= 4 then
				helper_2968(1)
			end
			if at <= 5 then
				helper_3f8(5)
			end
			if at <= 6 then
				helper_3f8(60)
			end
			if at <= 7 then
				helper_5fc8(2720010)
			end
			if at <= 8 then
				helper_2968(0)
			end
			if at <= 9 then
				helper_5fc8(2720020)
			end
			if at <= 10 then
				helper_5fc8(2720030)
			end
			if at <= 11 then
				helper_5fc8(2720035)
			end
			if at <= 12 then
				helper_3f8(30)
			end
			if at <= 13 then
				helper_5fc8(2720040)
			end
			if at <= 14 then
				helper_3f8(30)
			end
			if at <= 15 then
				helper_5fc8(2720050)
			end
			if at <= 16 then
				helper_5fc8(2720060)
			end
			if at <= 17 then
				helper_2968(0)
			end
			if at <= 18 then
				helper_5fc8(2720070)
			end
			if at <= 19 then
				helper_3f8(30)
			end
			if at <= 20 then
				helper_3f8(15)
			end
			if at <= 21 then
				helper_5fc8(2720080)
			end
			if at <= 22 then
				helper_3f8(30)
			end
			if at <= 23 then
				helper_3f8(15)
			end
			if at <= 24 then
				helper_5fc8(2720090)
			end
			if at <= 25 then
				helper_3f8(30)
			end
			if at <= 26 then
				helper_3f8(30)
			end
			if at <= 27 then
				helper_3f8(15)
			end
			if at <= 28 then
				helper_3f8(90)
			end
			if at <= 29 then
				helper_3f8(120)
			end
			if at <= 30 then
				helper_3f8(30)
			end
			if at <= 31 then
				helper_cdfc(361, 1)
			end
			if at <= 32 then
				helper_5fc8(2720100)
			end
			if at <= 33 then
				helper_5fc8(2720110)
			end
			if at <= 34 then
				helper_3f8(15)
			end
			if at <= 35 then
				helper_5fc8(2720120)
			end
			if at <= 36 then
				helper_3f8(15)
			end
			if at <= 37 then
				helper_5fc8(2720130)
			end
			if at <= 38 then
				helper_5fc8(2720140)
			end
			if at <= 39 then
				helper_5fc8(2720150)
			end
			if at <= 40 then
				helper_3f8(30)
			end
			if at <= 41 then
				helper_5fc8(2720160)
			end
			if at <= 42 then
				helper_5fc8(2720165)
			end
			if at <= 43 then
				helper_5fc8(2720170)
			end
			if at <= 44 then
				helper_cdfc(308, 1)
			end
			if at <= 45 then
				helper_3f8(120)
			end
			if at <= 46 then
				helper_87c4(0, -1, 8, 0, 0)
			end
			if vm.skip_end() then
				return skip(48)
			end
			return part2()
		end
		if at <= 48 then
			helper_3f8(30)
		end
		helper_202bc()
	end
	function part2()
		event.CancelDramaScene()
		event.SetFadeOut(30)
		helper_3f8(30)
		if vm.skipping() then
			return skip(49)
		end
		event.SetWind(-1)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		helper_202bc()
		event.ResetCamera(0)
		event.SetFadeIn(30)
	end
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.SetFadeOut(30)
	helper_3f8(45)
	if vm.skipping() then
		return skip(1)
	end
	event.SetFlag(272, 1)
	event.LoadSound(2503)
	var10 = event.SndLoadSound(2503) or var10
	var11 = event.SndLoadSound(8, "snd2/sp/sp_006.sound.json") or var11
	helper_20710()
	event.InitDramaScene()
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "デフォルト顔")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.CharaActive(1, global4)
	event.CharaActive(1, global5)
	event.CharaActive(0, 35)
	event.CmrsSetPos(104.47, 46.8, 1479.26)
	event.CmrsSetRef(86.03, 73.72, 1247.28)
	event.SetCharaPos(0, -297.56, 0.0, -373.68)
	event.SetCharaRot(0, 0.0, 2.57, 0.0)
	event.EohSetFootSoundId(0, 1)
	event.EohSetFootSoundId(1, 1)
	event.SetCharaPos(38, -96.86, 52.75, 388.46)
	event.SetCharaRot(38, 0.0, 0.0, 0.0)
	event.SetCharaPos(39, 37.43, 34.75, 561.52)
	event.SetCharaRot(39, 0.0, 0.0, 0.0)
	event.ObjsSetPos(0, 47.14, -8.67, 849.46)
	event.ObjsSetRot(0, 0.0, 3.05, 0.0)
	event.ObjsSetPos(1, 70.25, -10.75, 900.05)
	event.ObjsSetRot(1, 0.0, 3.05, 0.0)
	event.SetFadeIn(30)
	event.SetMpcharaMotion("jyuraku", "jyuraku", "瞬き")
	event.ObjsSetMotion(0, "歩き", 4, -1.0, 1)
	event.ObjsSetMotion(1, "歩き", 4, -1.0, 1)
	helper_3f8(15)
	if vm.skipping() then
		return skip(2)
	end
	event.ObjsMove(0, 37.43, 14.75, 561.52, 240, 1)
	event.ObjsMove(1, 58.59, 15.55, 560.22, 270, 1)
	event.CmrsInitPas()
	event.CmrsSetPasFrm(200)
	event.CmrsAddPas(104.47, 46.8, 1479.26, 86.03, 73.72, 1247.28)
	event.CmrsAddPas(65.3, 46.8, 986.65, 46.86, 73.72, 754.67)
	event.CmrsStartPas()
	helper_2968(0)
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsRotation(0, 0.0, -3.11, 0.0, 5)
	helper_3f8(5)
	if vm.skipping() then
		return skip(4)
	end
	event.ObjsSetMotion(0, "立ち", 0)
	helper_2968(1)
	if vm.skipping() then
		return skip(5)
	end
	event.ObjsRotation(1, 0.0, -2.87, 0.0, 5)
	helper_3f8(5)
	if vm.skipping() then
		return skip(6)
	end
	event.ObjsSetMotion(1, "上向くL", 0)
	helper_3f8(60)
	if vm.skipping() then
		return skip(7)
	end
	event.ObjsSetMotion(0, "上向く", 2)
	event.ObjsNextMotion(0, "上向く会話", 2)
	event.ObjsNextMotion(0, "上向くL", 4)
	helper_5fc8(2720010)
	if vm.skipping() then
		return skip(8)
	end
	helper_2968(0)
	if vm.skipping() then
		return skip(9)
	end
	event.ObjsNextMotion(0, "上向くL", 4)
	helper_5fc8(2720020)
	if vm.skipping() then
		return skip(10)
	end
	helper_5fc8(2720030)
	if vm.skipping() then
		return skip(11)
	end
	helper_5fc8(2720035)
	if vm.skipping() then
		return skip(12)
	end
	helper_3f8(30)
	if vm.skipping() then
		return skip(13)
	end
	event.CmrsSetPos(62.05, 41.42, 524.15)
	event.CmrsSetRef(28.43, 35.31, 613.0)
	event.ObjsSetMotion(0, "上向く会話", 6)
	event.ObjsNextMotion(0, "上向くL", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_5fc8(2720040)
	if vm.skipping() then
		return skip(14)
	end
	event.ResetPakuAnim()
	event.ObjsMotionWait(0)
	event.ObjsSetMotion(0, "上向くL", 4)
	helper_3f8(30)
	if vm.skipping() then
		return skip(15)
	end
	event.CmrsSetPos(65.3, 46.8, 986.65)
	event.CmrsSetRef(46.86, 73.72, 754.67)
	helper_5fc8(2720050)
	if vm.skipping() then
		return skip(16)
	end
	event.ObjsSetMotion(0, "上向く会話", 6)
	event.ObjsNextMotion(0, "上向くL", 4)
	helper_5fc8(2720060)
	if vm.skipping() then
		return skip(17)
	end
	helper_2968(0)
	if vm.skipping() then
		return skip(18)
	end
	helper_5fc8(2720070)
	if vm.skipping() then
		return skip(19)
	end
	helper_3f8(30)
	if vm.skipping() then
		return skip(20)
	end
	event.CmrsSetPos(35.55, 36.73, 529.53)
	event.CmrsSetRef(46.86, 52.13, 754.67)
	event.ObjsSetMotion(0, "考える", 4)
	helper_3f8(15)
	if vm.skipping() then
		return skip(21)
	end
	event.CmrsMove2(35.81, 36.73, 534.67, 46.86, 52.13, 754.67, 30, 2, 1.0)
	event.SetPakuAnim(0, "通常口パク")
	helper_5fc8(2720080)
	if vm.skipping() then
		return skip(22)
	end
	event.ResetPakuAnim()
	helper_3f8(30)
	if vm.skipping() then
		return skip(23)
	end
	event.CmrsSetPos(283.52, 88.96, 846.8)
	event.CmrsSetRef(90.35, 78.53, 545.4)
	helper_3f8(15)
	if vm.skipping() then
		return skip(24)
	end
	helper_5fc8(2720090)
	if vm.skipping() then
		return skip(25)
	end
	event.SetMpcharaMotion("jyuraku", "jyuraku", "もごもご")
	helper_3f8(30)
	if vm.skipping() then
		return skip(26)
	end
	event.SetMpcharaMotion("jyuraku", "jyuraku", "ふんっ")
	helper_3f8(30)
	if vm.skipping() then
		return skip(27)
	end
	event.CharaActive(1, 38)
	event.SetMotion(38, "鼻爆発", 2, -1, 1)
	event.SndSePlay(var10, 4)
	event.SetWind(40.0, -96.86, 52.75, 388.46)
	helper_3f8(15)
	if vm.skipping() then
		return skip(28)
	end
	event.SetWind(-1)
	event.SetMpcharaMotion("jyuraku", "jyuraku", "瞬き")
	event.ObjsSetMotion(0, "驚く", 6)
	event.ObjsSetMotion(1, "おどろき", 6)
	event.ObjsNextMotion(0, "驚くL", 4)
	event.ObjsNextMotion(1, "おどろきL", 4)
	helper_3f8(90)
	if vm.skipping() then
		return skip(29)
	end
	event.CharaActive(0, 38)
	event.CmrsSetPos(64.11, 33.73, 495.58)
	event.CmrsSetRef(35.93, 39.28, 614.27)
	event.ObjsSetRot(1, 0.0, -2.03, 0.0)
	event.CharaActive(1, 39)
	event.SetMotion(39, "キラキラ（ループ）", 4, -1, 1)
	event.ObjsInitPas(5)
	event.ObjsSetPasFrm(5, 120)
	event.ObjsAddPas(5, 39.0, 68.91, 553.15)
	event.ObjsAddPas(5, 39.0, 42.39, 553.15)
	event.ObjsStartPas(5)
	event.SndSePlay(var10, 5)
	event.ObjsSetMotion(0, "キラキラ見る", 2)
	event.ObjsSetMotion(1, "おどろきＬから上向き立ち", 2)
	event.ObjsNextMotion(0, "取る", 6)
	event.ObjsNextMotion(1, "上向く戻り", 6, 0.025)
	event.ObjsNextMotion(0, "取るL", 4)
	event.ObjsNextMotion(1, "立ち", 4)
	helper_3f8(120)
	if vm.skipping() then
		return skip(30)
	end
	event.SetMotion(39, "消える", 2, -1, 1)
	helper_3f8(30)
	if vm.skipping() then
		return skip(31)
	end
	event.CharaActive(0, 39)
	event.CmrsSetPos(32.21, 52.0, 529.74)
	event.CmrsSetRef(38.35, 42.39, 562.99)
	event.ObjsSetPos(6, 44.55, 45.78, 564.88)
	event.ObjsSetRot(6, 0.0, -3.11, 0.0)
	event.SndPauseBgm()
	event.CharaActive(1, 40)
	event.SndSePlay(var10, 6)
	event.SndSePlay(var11, 0)
	event.ObjsSetMotion(6, "発動", 6)
	event.SetReference(global4, "item", 35)
	event.CharaActive(1, 35)
	event.ObjsSetMotion(0, "種ゲット", 4)
	helper_cdfc(361, 1)
	if vm.skipping() then
		return skip(32)
	end
	event.PlayBgm(0)
	event.DelReference(35)
	event.CharaActive(0, 40)
	event.CmrsSetPos(65.3, 46.8, 986.65)
	event.CmrsSetRef(46.86, 73.72, 754.67)
	event.ObjsSetRot(1, 0.0, -2.87, 0.0)
	event.ObjsSetMotion(0, "上向くL", 0)
	event.ObjsSetMotion(1, "上向くL", 0)
	helper_5fc8(2720100)
	if vm.skipping() then
		return skip(33)
	end
	helper_5fc8(2720110)
	if vm.skipping() then
		return skip(34)
	end
	event.CmrsSetPos(40.41, 53.02, 519.29)
	event.CmrsSetRef(64.94, -1.06, 669.16)
	helper_3f8(15)
	if vm.skipping() then
		return skip(35)
	end
	event.SetPakuAnim(0, "通常口パク")
	helper_5fc8(2720120)
	if vm.skipping() then
		return skip(36)
	end
	event.ResetPakuAnim()
	event.CmrsSetPos(65.3, 46.8, 986.65)
	event.CmrsSetRef(46.86, 73.72, 754.67)
	helper_3f8(15)
	if vm.skipping() then
		return skip(37)
	end
	helper_5fc8(2720130)
	if vm.skipping() then
		return skip(38)
	end
	event.ObjsSetMotion(0, "上向く会話", 2)
	event.ObjsNextMotion(0, "上向くL", 4)
	helper_5fc8(2720140)
	if vm.skipping() then
		return skip(39)
	end
	event.ObjsNextMotion(0, "上向くL", 4)
	helper_5fc8(2720150)
	if vm.skipping() then
		return skip(40)
	end
	helper_3f8(30)
	if vm.skipping() then
		return skip(41)
	end
	event.CmrsSetPos(40.41, 53.02, 519.29)
	event.CmrsSetRef(64.94, -1.06, 669.16)
	event.ObjsSetMotion(0, "あせり会話", 6)
	event.ObjsNextMotion(0, "上向くL", 4)
	event.SetPakuAnim(0, "大口パク")
	helper_5fc8(2720160)
	if vm.skipping() then
		return skip(42)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(0, "大口パク")
	event.ObjsSetMotion(0, "あせり会話", 6)
	event.ObjsNextMotion(0, "上向くL", 4)
	helper_5fc8(2720165)
	if vm.skipping() then
		return skip(43)
	end
	event.ResetPakuAnim()
	event.CmrsSetPos(65.3, 46.8, 986.65)
	event.CmrsSetRef(46.86, 73.72, 754.67)
	event.ObjsSetMotion(0, "立ち", 4)
	helper_5fc8(2720170)
	if vm.skipping() then
		return skip(44)
	end
	helper_cdfc(308, 1)
	if vm.skipping() then
		return skip(45)
	end
	event.CmrsSetPos(40.41, 53.02, 519.29)
	event.CmrsSetRef(64.94, -1.06, 669.16)
	event.ObjsSetMotion(0, "右向く", 6)
	event.ObjsNextMotion(0, "右向くL", 6)
	event.ObjsSetMotion(1, "左向く", 6)
	event.ObjsNextMotion(1, "左向く戻り", 6)
	event.ObjsNextMotion(1, "だめだめ", 6)
	event.ObjsNextMotion(1, "立ち", 6)
	helper_3f8(120)
	if vm.skipping() then
		return skip(46)
	end
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]『太陽のしずく』を手に入れるには、まず\n   『ヒマーラと話ができるようになるアイテム』が\n   必要です。<page>   そのアイテムの入手方法には、ジオラマの\n   進行が関係しています。ジオラマを発展させ、\n   ジュラクの未来世界を探索してみましょう。"
	)
	helper_87c4(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(47)
	end
	event.SetMesPreset(0, 0)
	return part2()
end

--- Helper function.
local function helper_24bec()
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
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", global0)
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
	event.LoadMes(0, 5, "event/e200/e275/e275.txt")
end

--- Helper function.
local function helper_2858()
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
local function helper_24914()
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
local function helper_25678()
	local var4: s32 = 0
	local var5: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 11 then
			if at <= 1 then
				helper_24bec()
				helper_3f8(15)
			end
			if at <= 2 then
				helper_3f8(60)
			end
			if at <= 3 then
				helper_5fc8(2750010)
			end
			if at <= 4 then
				helper_2858()
			end
			if at <= 5 then
				helper_3f8(30)
			end
			if at <= 6 then
				helper_3f8(15)
			end
			if at <= 7 then
				helper_5fc8(2750020)
			end
			if at <= 8 then
				helper_5fc8(2750030)
			end
			if at <= 9 then
				helper_3f8(60)
			end
			if at <= 10 then
				helper_3f8(35)
			end
			if vm.skip_end() then
				return skip(12)
			end
			return part2()
		end
		helper_24914()
	end
	function part2()
		event.CancelDramaScene()
		helper_24914()
		event.ResetCamera(0)
		event.SetFadeIn(30)
	end
	event.SetFlag(275, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.SetFadeOut(30)
	helper_3f8(45)
	if vm.skipping() then
		return skip(1)
	end
	helper_24bec()
	event.LoadSound(2506)
	event.InitDramaScene()
	event.CharaActive(1, global0)
	event.CharaActive(1, global1)
	event.CmrsSetPos(-4.27, 55.7, 754.91)
	event.CmrsSetRef(14.71, 53.79, 698.03)
	event.SetCharaPos(0, -297.56, 0.0, -373.68)
	event.SetCharaRot(0, 0.0, 2.57, 0.0)
	var4 = event.GetAnalyze(106) or var4
	var5 = event.GetAnalyze(105) or var5
	if var5 ~= 0 then
		event.CmrsSetPos(13.7, 24.83, 757.8)
		event.CmrsSetRef(14.71, 53.79, 698.03)
	end
	if var4 ~= 0 then
		event.CmrsSetPos(49.24, 24.83, 746.5)
		event.CmrsSetRef(14.71, 53.79, 698.03)
	end
	event.ObjsSetPos(0, 13.4, 6.52, 613.7)
	event.ObjsSetRot(0, 0.0, -2.92, 0.0)
	event.ObjsSetPos(1, 47.24, 7.54, 600.38)
	event.ObjsSetRot(1, 0.0, -2.92, 0.0)
	event.SetFadeIn(30)
	event.ObjsSetMotion(0, "上向くL", 4, -1.0, 1)
	event.ObjsSetMotion(1, "上向くL", 4, -1.0, 1)
	helper_3f8(15)
	if vm.skipping() then
		return skip(2)
	end
	if (if var4 ~= 0 then 1 else var5) ~= 0 then
		event.CmrsInitPas()
		if (if var4 ~= 0 then var5 else 0) ~= 0 then
			event.CmrsSetPasFrm(480)
		end
		if (if var4 ~= 0 then 1 else var5) ~= 0 then
			event.CmrsSetPasFrm(240)
		end
		if var4 ~= 0 then
			event.CmrsAddPas(49.24, 24.83, 746.5, 14.71, 53.79, 698.03)
		end
		if var5 ~= 0 then
			event.CmrsAddPas(13.7, 24.83, 757.8, 14.71, 53.79, 698.03)
		end
		event.CmrsAddPas(-4.27, 55.7, 754.91, 14.71, 53.79, 698.03)
		event.CmrsStartPas()
	else
		helper_3f8(60)
		if vm.skipping() then
			return skip(3)
		end
	end
	helper_5fc8(2750010)
	if vm.skipping() then
		return skip(4)
	end
	helper_2858()
	if vm.skipping() then
		return skip(5)
	end
	helper_3f8(30)
	if vm.skipping() then
		return skip(6)
	end
	event.CmrsSetPos(17.1, 20.28, 879.05)
	event.CmrsSetRef(14.71, 53.79, 698.03)
	helper_3f8(15)
	if vm.skipping() then
		return skip(7)
	end
	helper_5fc8(2750020)
	if vm.skipping() then
		return skip(8)
	end
	helper_5fc8(2750030)
	if vm.skipping() then
		return skip(9)
	end
	helper_3f8(60)
	if vm.skipping() then
		return skip(10)
	end
	event.SetFadeOut(30)
	helper_3f8(35)
	if vm.skipping() then
		return skip(11)
	end
	return part2()
end

--- Helper function.
local function helper_28de4()
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		global6 = 0
		global7 = 32
		global6 = 32
		global7 = 0
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesWindowMode(0, 7)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		global6 = 0
		global7 = 32
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", global6)
		event.LoadMotion(5, "event/e200/e280/e280_mints.gltf", "info", global6)
		event.EohSyncChara(0, global6)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global6)
		event.LoadChara(5, "chara/c02_base.gltf", "info", global7)
		event.LoadEquip(5, 1, 4, "info", global7)
		event.LoadEquip(5, 1, 3, "info", global7)
		event.LoadEquip(5, 1, 2, "info", global7, 37)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global7)
		event.LoadMotion(5, "event/e200/e280/e280_monica.gltf", "info", global7)
		event.EohSyncChara(1, global7)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global7)
		event.CharaActive(1, 37)
	end
	if active_chr_no == 1 then
		global6 = 32
		global7 = 0
		event.LoadChara(5, "chara/c01_base.gltf", "info", global6)
		event.LoadEquip(5, 0, 4, "info", global6)
		event.LoadEquip(5, 0, 3, "info", global6)
		event.LoadEquip(5, 0, 2, "info", global6, 37)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", global6)
		event.LoadMotion(5, "event/e200/e280/e280_mints.gltf", "info", global6)
		event.EohSyncChara(0, global6)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global6)
		event.CharaActive(1, 37)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global7)
		event.LoadMotion(5, "event/e200/e280/e280_monica.gltf", "info", global7)
		event.EohSyncChara(1, global7)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global7)
	end
	event.LoadMes(0, 5, "event/e200/e280/e280a.txt")
end

--- Helper function.
local function helper_28ab4()
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		event.CharaActive(1, global6)
		event.CharaActive(0, global7)
		event.DelExtMotion(global6)
		event.DelExtMotion(global7)
		event.DeleteChara(global7)
		event.DeleteChara(37)
	end
	if active_chr_no == 1 then
		event.CharaActive(1, global7)
		event.CharaActive(0, global6)
		event.DelExtMotion(global6)
		event.DelExtMotion(global7)
		event.DeleteChara(global6)
		event.DeleteChara(37)
	end
	event.MapJump(-1, "s26", 700)
end

--- Helper function.
local function helper_29a30()
	local var6: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 70 then
			if at <= 1 then
				helper_28de4()
				helper_5fc8(2800010)
			end
			if at <= 2 then
				helper_5fc8(2800015)
			end
			if at <= 3 then
				helper_5fc8(2800020)
			end
			if at <= 4 then
				helper_2968(1)
			end
			if at <= 5 then
				helper_3f8(30)
			end
			if at <= 6 then
				helper_3f8(15)
			end
			if at <= 7 then
				helper_5fc8(2800030)
			end
			if at <= 8 then
				helper_5fc8(2800040)
			end
			if at <= 9 then
				helper_3f8(30)
			end
			if at <= 10 then
				helper_3f8(15)
			end
			if at <= 11 then
				helper_5fc8(2800050)
			end
			if at <= 12 then
				helper_2968(1)
			end
			if at <= 13 then
				helper_3f8(30)
			end
			if at <= 14 then
				helper_3f8(15)
			end
			if at <= 15 then
				helper_5fc8(2800060)
			end
			if at <= 16 then
				helper_5fc8(2800065)
			end
			if at <= 17 then
				helper_5fc8(2800070)
			end
			if at <= 18 then
				helper_3f8(30)
			end
			if at <= 19 then
				helper_3f8(15)
			end
			if at <= 20 then
				helper_5fc8(2800080)
			end
			if at <= 21 then
				helper_5fc8(2800085)
			end
			if at <= 22 then
				helper_2968(0)
			end
			if at <= 23 then
				helper_3f8(30)
			end
			if at <= 24 then
				helper_3f8(15)
			end
			if at <= 25 then
				helper_5fc8(2800090)
			end
			if at <= 26 then
				helper_2968(1)
			end
			if at <= 27 then
				helper_3f8(30)
			end
			if at <= 28 then
				helper_3f8(15)
			end
			if at <= 29 then
				helper_5614(2800100, -1)
			end
			if at <= 30 then
				helper_2858()
			end
			if at <= 31 then
				helper_2858()
			end
			if at <= 32 then
				helper_5614(2800110, 120)
			end
			if at <= 33 then
				helper_3f8(60)
			end
			if at <= 34 then
				helper_3f8(15)
			end
			if at <= 35 then
				helper_5fc8(2800120)
			end
			if at <= 36 then
				helper_5fc8(2800130)
			end
			if at <= 37 then
				helper_2968(0)
			end
			if at <= 38 then
				helper_5fc8(2800140)
			end
			if at <= 39 then
				helper_2968(1)
			end
			if at <= 40 then
				helper_5fc8(2800145)
			end
			if at <= 41 then
				helper_5fc8(2800150)
			end
			if at <= 42 then
				helper_2968(0)
			end
			if at <= 43 then
				helper_5fc8(2800160)
			end
			if at <= 44 then
				helper_2968(1)
			end
			if at <= 45 then
				helper_3f8(30)
			end
			if at <= 46 then
				helper_3f8(15)
			end
			if at <= 47 then
				helper_5fc8(2800170)
			end
			if at <= 48 then
				helper_5fc8(2800180)
			end
			if at <= 49 then
				helper_3f8(30)
			end
			if at <= 50 then
				helper_2968(0)
			end
			if at <= 51 then
				helper_2968(0)
			end
			if at <= 52 then
				helper_5fc8(2800190)
			end
			if at <= 53 then
				helper_2968(0)
			end
			if at <= 54 then
				helper_5fc8(2800195)
			end
			if at <= 55 then
				helper_2968(0)
			end
			if at <= 56 then
				helper_2968(1)
			end
			if at <= 57 then
				helper_5fc8(2800200)
			end
			if at <= 58 then
				helper_2968(1)
			end
			if at <= 59 then
				helper_5fc8(2800205)
			end
			if at <= 60 then
				helper_2968(1)
			end
			if at <= 61 then
				helper_5fc8(2800210)
			end
			if at <= 62 then
				helper_2968(0)
			end
			if at <= 63 then
				helper_2968(0)
			end
			if at <= 64 then
				helper_2968(1)
			end
			if at <= 65 then
				helper_2968(0)
			end
			if at <= 66 then
				helper_2968(1)
			end
			if at <= 67 then
				helper_3f8(15)
			end
			if at <= 68 then
				helper_3f8(200)
			end
			if at <= 69 then
				helper_3f8(35)
			end
			if vm.skip_end() then
				return skip(71)
			end
			return part2()
		end
		helper_28ab4()
	end
	function part2()
		event.CancelDramaScene()
		event.StopBgm(0)
		event.SndSeStop(var6, 8)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		helper_28ab4()
		event.ResetCamera(0)
	end
	event.SetFlag(280, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.SetFadeOut(30)
	event.StopBgm(0)
	helper_3f8(45)
	if vm.skipping() then
		return skip(1)
	end
	event.LoadBgm(59)
	event.LoadSound(2511)
	event.PlayBgm(0, 36)
	var6 = event.SndLoadSound(2511) or var6
	helper_28de4()
	event.InitDramaScene()
	event.EohSetFootSoundId(0, 1)
	event.EohSetFootSoundId(1, 1)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "デフォルト顔")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.CharaActive(1, global6)
	event.CharaActive(1, global7)
	event.CmrsSetPos(34.43, 5.8, 741.1)
	event.CmrsSetRef(26.93, 51.37, 586.27)
	event.ObjsSetPos(1, 38.74, 7.54, 600.65)
	event.ObjsSetRot(1, 0.0, -2.68, 0.0)
	event.ObjsSetPos(0, 20.1, 6.52, 613.49)
	event.ObjsSetRot(0, 0.0, 3.12, 0.0)
	event.SetFadeIn(30)
	event.ObjsSetMotion(0, "上向くL", 4, -1.0, 1)
	event.ObjsSetMotion(1, "上向くL", 4, -1.0, 1)
	helper_5fc8(2800010)
	if vm.skipping() then
		return skip(2)
	end
	helper_5fc8(2800015)
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsTexAnime(0, 1, "わらい口ひらき")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "デフォルト顔")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.CmrsSetPos(-1.53, 38.93, 576.75)
	event.CmrsSetRef(47.63, 28.44, 622.59)
	event.ObjsSetMotion(1, "上向く会話", 2)
	event.ObjsNextMotion(1, "上向くL", 4)
	event.SetPakuAnim(1, "わらい口パク")
	helper_5fc8(2800020)
	if vm.skipping() then
		return skip(4)
	end
	event.ResetPakuAnim()
	helper_2968(1)
	if vm.skipping() then
		return skip(5)
	end
	event.ObjsSetMotion(1, "上向くL", 4)
	helper_3f8(30)
	if vm.skipping() then
		return skip(6)
	end
	event.CmrsSetPos(38.84, 15.89, 762.06)
	event.CmrsSetRef(30.81, 47.05, 622.71)
	helper_3f8(15)
	if vm.skipping() then
		return skip(7)
	end
	helper_5fc8(2800030)
	if vm.skipping() then
		return skip(8)
	end
	helper_5fc8(2800040)
	if vm.skipping() then
		return skip(9)
	end
	helper_3f8(30)
	if vm.skipping() then
		return skip(10)
	end
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsTexAnime(0, 1, "半口")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "デフォルト顔")
	event.ObjsTexAnime(1, 1, "不満目パチ")
	event.CmrsSetPos(17.72, 36.99, 568.83)
	event.CmrsSetRef(35.34, 28.44, 619.23)
	helper_3f8(15)
	if vm.skipping() then
		return skip(11)
	end
	event.ObjsSetMotion(1, "はぁ？", 6)
	event.ObjsNextMotion(1, "上向くL", 4)
	event.SetPakuAnim(1, "あきれ口パク")
	helper_5fc8(2800050)
	if vm.skipping() then
		return skip(12)
	end
	event.ResetPakuAnim()
	helper_2968(1)
	if vm.skipping() then
		return skip(13)
	end
	helper_3f8(30)
	if vm.skipping() then
		return skip(14)
	end
	event.CmrsSetPos(38.84, 15.89, 762.06)
	event.CmrsSetRef(30.81, 47.05, 622.71)
	helper_3f8(15)
	if vm.skipping() then
		return skip(15)
	end
	helper_5fc8(2800060)
	if vm.skipping() then
		return skip(16)
	end
	event.CmrsSetPos(54.46, 37.12, 558.59)
	event.CmrsSetRef(20.97, 30.6, 620.45)
	helper_5fc8(2800065)
	if vm.skipping() then
		return skip(17)
	end
	event.CmrsSetPos(38.84, 15.89, 762.06)
	event.CmrsSetRef(30.81, 47.05, 622.71)
	helper_5fc8(2800070)
	if vm.skipping() then
		return skip(18)
	end
	helper_3f8(30)
	if vm.skipping() then
		return skip(19)
	end
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おこり顔")
	event.ObjsTexAnime(0, 1, "おこり目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "不満顔")
	event.ObjsTexAnime(1, 1, "不満目パチ")
	event.CmrsSetPos(42.96, 39.99, 563.11)
	event.CmrsSetRef(28.37, 28.44, 607.63)
	event.ObjsSetRot(0, 0.0, -2.56, 0.0)
	helper_3f8(15)
	if vm.skipping() then
		return skip(20)
	end
	event.SetPakuAnim(0, "通常口パク")
	helper_5fc8(2800080)
	if vm.skipping() then
		return skip(21)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(0, "上見から右見", 6)
	event.ObjsNextMotion(0, "右向く会話", 6)
	event.ObjsNextMotion(0, "右向くL", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_5fc8(2800085)
	if vm.skipping() then
		return skip(22)
	end
	event.ResetPakuAnim()
	helper_2968(0)
	if vm.skipping() then
		return skip(23)
	end
	helper_3f8(30)
	if vm.skipping() then
		return skip(24)
	end
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "おこり顔")
	event.ObjsTexAnime(1, 1, "おこり目パチ")
	event.ObjsSetRot(0, 0.0, 3.12, 0.0)
	event.CmrsSetPos(-23.31, 28.11, 596.86)
	event.CmrsSetRef(26.9, 28.44, 606.75)
	helper_3f8(15)
	if vm.skipping() then
		return skip(25)
	end
	event.ObjsSetMotion(1, "上向きから左向き", 6)
	event.ObjsNextMotion(1, "左向くL", 4)
	event.ObjsMotionDelay(1, 60)
	event.ObjsSetMotion(1, "左向きから上向き", 6)
	event.ObjsNextMotion(1, "上向く会話", 2)
	event.ObjsNextMotion(1, "上向くL", 4)
	event.ObjsMotionDelay(0, 60)
	event.ObjsSetMotion(0, "右見から上見", 6)
	event.ObjsNextMotion(0, "上向くL", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_5fc8(2800090)
	if vm.skipping() then
		return skip(26)
	end
	event.ResetPakuAnim()
	helper_2968(1)
	if vm.skipping() then
		return skip(27)
	end
	helper_3f8(30)
	if vm.skipping() then
		return skip(28)
	end
	event.CmrsSetPos(60.85, 50.28, 994.5)
	event.CmrsSetRef(37.15, 90.96, 620.83)
	helper_3f8(15)
	if vm.skipping() then
		return skip(29)
	end
	event.CmrsInitPas()
	event.CmrsSetPasFrm(200)
	event.CmrsAddPas(60.85, 50.28, 994.5, 37.15, 90.96, 620.83)
	event.CmrsAddPas(53.55, 50.28, 879.42, 29.85, 90.96, 505.75)
	event.CmrsStartPas()
	helper_5614(2800100, -1)
	if vm.skipping() then
		return skip(30)
	end
	event.SndSePlay(var6, 8)
	helper_2858()
	if vm.skipping() then
		return skip(31)
	end
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "うれし目パチ")
	event.CmrsSetPos(15.67, 33.06, 545.55)
	event.CmrsSetRef(37.65, 31.67, 641.15)
	event.CmrsInitPas()
	event.CmrsSetPasFrm(200)
	event.CmrsAddPas(15.67, 33.06, 545.55, 37.65, 31.67, 641.15)
	event.CmrsAddPas(21.77, 33.06, 572.11, 37.65, 31.67, 641.15)
	event.CmrsStartPas()
	helper_2858()
	if vm.skipping() then
		return skip(32)
	end
	event.CmrsSetPos(38.84, 15.89, 762.06)
	event.CmrsSetRef(30.81, 47.05, 622.71)
	event.SndSeStop(var6, 8)
	helper_5614(2800110, 120)
	if vm.skipping() then
		return skip(33)
	end
	event.SndSePlay(var6, 9)
	event.ObjsSetMotion(1, "がっかり肩落とし", 6)
	event.ObjsNextMotion(1, "がっかり肩落としＬ", 4)
	event.ObjsSetMotion(0, "がっかり", 6)
	event.ObjsNextMotion(0, "がっかりＬ", 4)
	helper_3f8(60)
	if vm.skipping() then
		return skip(34)
	end
	event.ObjsSetMotion(1, "頭抱えるＬ", 4, -1.0, 1)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "こまり顔")
	event.ObjsTexAnime(0, 1, "こまり目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "おこり顔")
	event.ObjsTexAnime(1, 1, "おこり目とじ")
	event.CmrsSetPos(-23.31, 28.11, 596.86)
	event.CmrsSetRef(26.9, 28.44, 606.75)
	helper_3f8(15)
	if vm.skipping() then
		return skip(35)
	end
	helper_5fc8(2800120)
	if vm.skipping() then
		return skip(36)
	end
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "こまり顔")
	event.ObjsTexAnime(0, 1, "こまり目～通常目")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "おこり顔")
	event.ObjsTexAnime(1, 1, "おこり目とじ～おこり目あき")
	event.ObjsTexaDelay(1, 30)
	event.ObjsTexAnime(1, 1, "おこり目パチ")
	event.SndSePlay(var6, 10)
	event.ObjsSetMotion(0, "がっかり→上", 6)
	event.ObjsNextMotion(0, "上向くL", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_5fc8(2800130)
	if vm.skipping() then
		return skip(37)
	end
	event.ResetPakuAnim()
	helper_2968(0)
	if vm.skipping() then
		return skip(38)
	end
	event.ObjsSetMotion(0, "上見から右見", 6)
	event.ObjsNextMotion(0, "右向くL", 4)
	event.ObjsSetMotion(1, "手をおろす", 6)
	event.ObjsNextMotion(1, "下向き立ちＬ", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_5fc8(2800140)
	if vm.skipping() then
		return skip(39)
	end
	event.ResetPakuAnim()
	helper_2968(1)
	if vm.skipping() then
		return skip(40)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_5fc8(2800145)
	if vm.skipping() then
		return skip(41)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(0, "右向く会話", 6)
	event.ObjsNextMotion(0, "右向くL", 4)
	helper_5fc8(2800150)
	if vm.skipping() then
		return skip(42)
	end
	helper_2968(0)
	if vm.skipping() then
		return skip(43)
	end
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "おこり顔")
	event.ObjsTexaDelay(1, 30)
	event.ObjsTexAnime(1, 1, "さみし顔")
	event.ObjsTexAnime(1, 1, "おこり目パチ")
	event.ObjsTexaDelay(1, 30)
	event.ObjsTexAnime(1, 1, "おこり目～さみし目")
	event.ObjsSetMotion(1, "下向き立ちＬ", 4)
	event.ObjsMotionDelay(1, 30)
	event.ObjsSetMotion(1, "下向きから左向き", 6)
	event.ObjsNextMotion(1, "左向く会話", 6)
	event.ObjsNextMotion(1, "左向くL", 4)
	event.SetPakuAnim(1, "さみし口パク")
	helper_5fc8(2800160)
	if vm.skipping() then
		return skip(44)
	end
	event.ResetPakuAnim()
	helper_2968(1)
	if vm.skipping() then
		return skip(45)
	end
	helper_3f8(30)
	if vm.skipping() then
		return skip(46)
	end
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "さみし顔")
	event.ObjsTexAnime(1, 1, "さみし目パチ")
	event.CmrsSetPos(42.73, 39.99, 562.51)
	event.CmrsSetRef(25.56, 28.44, 606.38)
	event.ObjsSetRot(0, 0.0, -2.56, 0.0)
	helper_3f8(15)
	if vm.skipping() then
		return skip(47)
	end
	event.SetPakuAnim(0, "通常口パク")
	helper_5fc8(2800170)
	if vm.skipping() then
		return skip(48)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(1, "左向きから下向き", 6)
	event.ObjsNextMotion(1, "下向き立ちＬ", 4)
	event.SetPakuAnim(1, "さみし口パク")
	helper_5fc8(2800180)
	if vm.skipping() then
		return skip(49)
	end
	event.ResetPakuAnim()
	helper_3f8(30)
	if vm.skipping() then
		return skip(50)
	end
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "デフォルト顔")
	event.ObjsTexAnime(1, 1, "さみし目～通常目")
	event.ObjsTexaDelay(1, 60)
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.CmrsSetPos(28.25, 31.54, 674.64)
	event.CmrsSetRef(28.22, 28.44, 600.45)
	event.ObjsSetMotion(0, "右回転90度（ＰＧ）", 6)
	event.ObjsNextMotion(0, "モニカ見立ち")
	event.ObjsRotation(0, 0.0, 2.4, 0.0, 20)
	helper_2968(0)
	if vm.skipping() then
		return skip(51)
	end
	helper_2968(0)
	if vm.skipping() then
		return skip(52)
	end
	event.SndSePlay(var6, 11)
	event.ObjsSetMotion(0, "がっつ", 2)
	event.ObjsNextMotion(0, "モニカ見立ち", 4)
	event.SetPakuAnim(0, "わらい口パク")
	helper_5fc8(2800190)
	if vm.skipping() then
		return skip(53)
	end
	event.ResetPakuAnim()
	helper_2968(0)
	if vm.skipping() then
		return skip(54)
	end
	event.ObjsSetMotion(0, "会話", 2)
	event.ObjsNextMotion(0, "モニカ見立ち", 4)
	helper_5fc8(2800195)
	if vm.skipping() then
		return skip(55)
	end
	helper_2968(0)
	if vm.skipping() then
		return skip(56)
	end
	event.SndSePlay(var6, 12)
	event.ObjsRotation(1, 0.0, -1.0, 0.0, 30)
	event.ObjsSetMotion(1, "左回転90度（ＰＧ）", 6)
	helper_2968(1)
	if vm.skipping() then
		return skip(57)
	end
	event.ObjsSetMotion(1, "会話", 6)
	event.ObjsNextMotion(1, "立ち", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_5fc8(2800200)
	if vm.skipping() then
		return skip(58)
	end
	event.ResetPakuAnim()
	helper_2968(1)
	if vm.skipping() then
		return skip(59)
	end
	event.ObjsSetMotion(1, "会話", 2)
	event.ObjsNextMotion(1, "立ち", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_5fc8(2800205)
	if vm.skipping() then
		return skip(60)
	end
	event.ResetPakuAnim()
	helper_2968(1)
	if vm.skipping() then
		return skip(61)
	end
	event.SndSePlay(var6, 13)
	event.ObjsSetMotion(0, "がっつ", 6)
	event.ObjsNextMotion(0, "モニカ見立ち", 4)
	event.SetPakuAnim(0, "わらい口パク")
	helper_5fc8(2800210)
	if vm.skipping() then
		return skip(62)
	end
	event.ResetPakuAnim()
	helper_2968(0)
	if vm.skipping() then
		return skip(63)
	end
	event.SndSePlay(var6, 14)
	event.SndSePlay(var6, 15)
	event.ObjsSetMotion(0, "モニカ見立うなづき", 6)
	event.ObjsNextMotion(0, "モニカ見立ち", 4)
	event.ObjsSetMotion(1, "うなづく", 6)
	event.ObjsNextMotion(1, "立ち", 4)
	helper_2968(0)
	if vm.skipping() then
		return skip(64)
	end
	helper_2968(1)
	if vm.skipping() then
		return skip(65)
	end
	event.ObjsSetMotion(1, "歩き")
	event.ObjsSetMotion(0, "歩き")
	event.ObjsRotation(0, 0.0, 0.0, 0.0, 20)
	event.ObjsRotation(1, 0.0, 0.0, 0.0, 20)
	helper_2968(0)
	if vm.skipping() then
		return skip(66)
	end
	helper_2968(1)
	if vm.skipping() then
		return skip(67)
	end
	event.ObjsSetMotion(1, "走り")
	event.ObjsSetMotion(0, "走り")
	event.ObjsMove(0, 20.44, 6.52, 1490.12, 390, 1)
	event.ObjsMove(1, 39.08, 7.54, 1478.94, 390, 1)
	event.CmrsInitPas()
	event.CmrsSetPasFrm(240)
	event.CmrsAddPas(28.25, 31.54, 674.64, 28.22, 28.44, 600.45)
	event.CmrsAddPas(28.59, 31.54, 1526.51, 28.22, 28.44, 600.45)
	event.CmrsStartPas()
	helper_3f8(15)
	if vm.skipping() then
		return skip(68)
	end
	helper_3f8(200)
	if vm.skipping() then
		return skip(69)
	end
	event.FadeOutBgm(30)
	event.SetFadeOut(30)
	helper_3f8(35)
	if vm.skipping() then
		return skip(70)
	end
	return part2()
end

--- Helper function.
local function helper_2fb48()
	local active_chr_no: s32 = 0
	event.SetMesWindowMode(0, 7)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		global0 = 0
		global1 = 32
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.LoadMotion(5, "event/e200/e285/e285_mints.gltf", "info", global0)
		event.EohSyncChara(0, global0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global0)
		event.LoadChara(5, "chara/c02_base.gltf", "info", global1)
		event.LoadEquip(5, 1, 4, "info", global1)
		event.LoadEquip(5, 1, 3, "info", global1)
		event.LoadEquip(5, 1, 2, "info", global1, 37)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.LoadMotion(5, "event/e200/e285/e285_monica.gltf", "info", global1)
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
		event.LoadMotion(5, "event/e200/e285/e285_mints.gltf", "info", global0)
		event.EohSyncChara(0, global0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global0)
		event.CharaActive(1, 37)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.LoadMotion(5, "event/e200/e285/e285_monica.gltf", "info", global1)
		event.EohSyncChara(1, global1)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global1)
	end
	event.LoadItem(5, 31, "info", 36)
	event.CharaActive(0, 36)
	event.LoadChara(5, "event/e200/e272/e272_hanabaku.gltf", "info", 38)
	event.CharaActive(0, 38)
	event.LoadChara(5, "event/e200/e272/e272_kirakira.gltf", "info", 39)
	event.CharaActive(0, 39)
	event.EohSyncChara(4, 39)
	event.ObjsInit(5, 39)
	event.ObjsSyncObj(5, 4)
	event.LoadChara(5, "event/itemget_ev/itemget_ev.gltf", "info", 40)
	event.EohSyncChara(5, 40)
	event.ObjsInit(6)
	event.ObjsSyncObj(6, 5)
	event.CharaActive(0, 40)
	event.LoadMes(0, 5, "event/e200/e285/e285.txt")
end

--- Helper function.
local function helper_2dfec()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_5614(2850010, -1)
		end
		if at <= 2 then
			helper_2858()
		end
		if at <= 3 then
			helper_3f8(30)
		end
	end
	event.SetFadeIn(30)
	event.SndSePlay(global8, 0)
	event.CmrsMove(111.21, 97.1, 1515.22, 354.23, 94.23, 1247.17, 540)
	helper_3f8(50)
	if vm.skipping() then
		return skip(1)
	end
	helper_5614(2850010, -1)
	if vm.skipping() then
		return skip(2)
	end
	helper_2858()
	if vm.skipping() then
		return skip(3)
	end
	helper_3f8(30)
	if vm.skipping() then
		return skip(4)
	end
	event.SndSeStop(global8, 0)
end

--- Helper function.
local function helper_2e1d4()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_3f8(15)
		end
		if at <= 2 then
			helper_5fc8(2850020)
		end
		if at <= 3 then
			helper_3f8(30)
		end
		if at <= 4 then
			helper_3f8(30)
		end
		if at <= 5 then
			helper_3f8(15)
		end
		if at <= 6 then
			helper_3f8(90)
		end
		if at <= 7 then
			helper_3f8(150)
		end
		if at <= 8 then
			helper_3f8(20)
		end
		if at <= 9 then
			helper_3f8(30)
		end
		if at <= 10 then
			helper_2968(0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.ObjsSetMotion(0, "立ち", 0)
	event.ObjsSetMotion(1, "立ち", 0)
	helper_3f8(15)
	if vm.skipping() then
		return skip(2)
	end
	helper_5fc8(2850020)
	if vm.skipping() then
		return skip(3)
	end
	event.SetMpcharaMotion("jyuraku", "jyuraku", "もごもご")
	helper_3f8(30)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMpcharaMotion("jyuraku", "jyuraku", "ふんっ")
	helper_3f8(30)
	if vm.skipping() then
		return skip(5)
	end
	event.CharaActive(1, 38)
	event.SetWind(40.0, -96.86, 52.75, 388.46)
	event.SetMotion(38, "鼻爆発", 2, -1, 1)
	event.SndSePlay(global8, 1)
	helper_3f8(15)
	if vm.skipping() then
		return skip(6)
	end
	event.SetWind(-1)
	event.SetMpcharaMotion("jyuraku", "jyuraku", "瞬き")
	event.ObjsSetMotion(0, "驚く", 6)
	event.ObjsSetMotion(1, "おどろき", 6)
	event.ObjsNextMotion(0, "驚くL", 4)
	event.ObjsNextMotion(1, "おどろきL", 4)
	helper_3f8(90)
	if vm.skipping() then
		return skip(7)
	end
	event.CharaActive(1, 39)
	event.SetMotion(39, "キラキラ（ループ）", 4, -1, 1)
	event.SndSePlay(global8, 2)
	event.ObjsInitPas(5)
	event.ObjsSetPasFrm(5, 150)
	event.ObjsAddPas(5, 12.99, 142.28, 609.6)
	event.ObjsAddPas(5, 12.99, 35.2, 609.6)
	event.ObjsStartPas(5)
	event.ObjsSetMotion(0, "キラキラ見る", 2)
	event.ObjsSetMotion(1, "おどろきＬから上向き立ち", 2)
	helper_3f8(150)
	if vm.skipping() then
		return skip(8)
	end
	event.ObjsNextMotion(0, "取る", 6)
	event.ObjsNextMotion(1, "上向く戻り", 6, 0.025)
	event.ObjsNextMotion(0, "取るL", 4)
	event.ObjsNextMotion(1, "立ち", 4)
	helper_3f8(20)
	if vm.skipping() then
		return skip(9)
	end
	event.SetMotion(39, "消える", 2, -1, 1)
	helper_3f8(30)
	if vm.skipping() then
		return skip(10)
	end
	helper_2968(0)
	if vm.skipping() then
		return skip(11)
	end
	event.CharaActive(0, 39)
end

--- Helper function.
local function helper_2ebf4()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_3f8(15)
		end
		if at <= 2 then
			helper_cdfc(31, 1)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.ObjsSetPos(6, 5.99, 36.82, 613.24)
	event.ObjsSetRot(6, 0.0, -2.92, 0.0)
	event.CharaActive(1, 36)
	event.CharaActive(1, 40)
	event.SndSePlay(global8, 3)
	event.SndSePlay(global8, 4)
	event.SndPauseBgm()
	event.SndSePlay(global9, 0)
	event.ObjsSetMotion(6, "発動", 6)
	event.SetReference(global0, "gun_hand", 36)
	event.ObjsSetMotion(0, "銃ゲット", 4)
	helper_3f8(15)
	if vm.skipping() then
		return skip(2)
	end
	helper_cdfc(31, 1)
	if vm.skipping() then
		return skip(3)
	end
	event.DelReference(36)
	event.CharaActive(0, 40)
	event.SndSeStop(global9, 0)
	event.PlayBgm(0)
end

--- Helper function.
local function helper_2efdc()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_5fc8(2850030)
		end
		if at <= 2 then
			helper_3f8(15)
		end
		if at <= 3 then
			helper_3f8(60)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.ObjsSetMotion(0, "上向く会話", 2)
	event.ObjsNextMotion(0, "上向くL", 4)
	helper_5fc8(2850030)
	if vm.skipping() then
		return skip(2)
	end
	event.ObjsSetMotion(0, "歩き", 4)
	event.ObjsSetMotion(1, "歩き", 4)
	event.ObjsRotation(0, 0.0, 0.2, 0.0, 15)
	event.ObjsRotation(1, 0.0, 0.0, 0.0, 15)
	helper_3f8(15)
	if vm.skipping() then
		return skip(3)
	end
	event.CmrsFadeInit()
	event.CmrsFadeDelay(30)
	event.CmrsFadeOut(30, 0.0, 0.0, 0.0)
	event.ObjsInitPas(0)
	event.ObjsSetPasFrm(0, 120)
	event.ObjsAddPas(0, 13.4, 6.52, 613.7)
	event.ObjsAddPas(0, 16.54, 2.3, 632.93)
	event.ObjsAddPas(0, 19.85, -3.85, 662.84)
	event.ObjsAddPas(0, 22.02, -8.04, 684.68)
	event.ObjsAddPas(0, 24.22, -12.54, 709.74)
	event.ObjsAddPas(0, 26.96, -12.32, 737.33)
	event.ObjsStartPas(0)
	event.ObjsInitPas(1)
	event.ObjsSetPasFrm(1, 120)
	event.ObjsAddPas(1, 47.24, 7.54, 600.38)
	event.ObjsAddPas(1, 49.86, 2.84, 624.2)
	event.ObjsAddPas(1, 51.55, -2.15, 651.95)
	event.ObjsAddPas(1, 52.91, -6.17, 674.31)
	event.ObjsAddPas(1, 55.85, -12.79, 722.8)
	event.ObjsStartPas(1)
	helper_3f8(60)
	if vm.skipping() then
		return skip(4)
	end
end

--- Helper function.
local function helper_2f73c()
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
		event.DeleteChara(36)
		event.DeleteChara(37)
	end
	if active_chr_no == 1 then
		event.CharaActive(1, global1)
		event.CharaActive(0, global0)
		event.DelExtMotion(global0)
		event.DelExtMotion(global1)
		event.DeleteChara(global0)
		event.DeleteChara(36)
		event.DeleteChara(37)
	end
	event.SetMpcharaMotion("jyuraku", "jyuraku", "瞬き")
	event.DeleteChara(36)
	event.DeleteChara(38)
	event.DeleteChara(39)
	event.DeleteChara(40)
end

--- Helper function.
local function helper_30b18()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 4 then
			if at <= 1 then
				helper_2e1d4()
			end
			if at <= 2 then
				helper_2ebf4()
			end
			if at <= 3 then
				helper_2efdc()
			end
			if vm.skip_end() then
				return skip(5)
			end
			return part2()
		end
		helper_2f73c()
	end
	function part2()
		event.CancelDramaScene()
		event.SndSeStop(global8, 0)
		event.SetWind(-1)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		helper_2f73c()
		event.ResetCamera(0)
		event.SetFadeIn(30)
	end
	event.SetFlag(285, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.LoadSound(2517)
	global8 = event.SndLoadSound(2517) or global8
	global9 = event.SndLoadSound(8, "snd2/sp/sp_006.sound.json") or global9
	helper_2fb48()
	event.InitDramaScene()
	event.EohSetFootSoundId(0, 1)
	event.EohSetFootSoundId(1, 1)
	event.CharaActive(1, global0)
	event.CharaActive(1, global1)
	event.SetCharaPos(38, -96.86, 52.75, 388.46)
	event.SetCharaRot(38, 0.0, 0.0, 0.0)
	event.SetCharaPos(39, 37.43, 34.75, 561.52)
	event.SetCharaRot(39, 0.0, 0.0, 0.0)
	event.CmrsSetPos(111.21, 97.1, 1515.22)
	event.CmrsSetRef(-186.27, 94.23, 1323.31)
	event.ObjsSetPos(0, 13.4, 6.52, 613.7)
	event.ObjsSetRot(0, 0.0, -2.92, 0.0)
	event.ObjsSetPos(1, 47.24, 7.54, 600.38)
	event.ObjsSetRot(1, 0.0, -2.2, 0.0)
	helper_2dfec()
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsSetPos(46.15, 36.68, 848.41)
	event.CmrsSetRef(38.64, 44.8, 724.85)
	helper_2e1d4()
	if vm.skipping() then
		return skip(2)
	end
	event.CmrsSetPos(3.9, 53.24, 586.95)
	event.CmrsSetRef(8.68, 32.62, 613.94)
	helper_2ebf4()
	if vm.skipping() then
		return skip(3)
	end
	event.CmrsSetPos(46.15, 36.68, 848.41)
	event.CmrsSetRef(38.64, 44.8, 724.85)
	helper_2efdc()
	if vm.skipping() then
		return skip(4)
	end
	return part2()
end

--- Helper function.
local function helper_75c(arg0: s32)
	local argc: s32 = 0
	local argc_2: s32 = 0
	local argc_3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_3f8(10)
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
			helper_3f8(10)
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
local function helper_1000()
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
local function helper_13ec8()
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.SpriteSetDraw(0, 0)
end

--- Helper function.
local function helper_13f54(arg0: s32)
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
		if at <= 3 then
			helper_87c4(0, -1, 5, 0, 0)
		end
		helper_13ec8()
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
	helper_87c4(0, -1, 5, 0, 0)
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
	helper_13ec8()
end

--- Helper function.
local function helper_178d0(arg0: f32, arg1: f32, arg2: f32, arg3: f32, arg4: s32, arg5: s32)
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
				helper_1000()
			end
			if at <= 2 then
				helper_3f8(20)
			end
			if at <= 3 then
				helper_2968(0)
			end
			if at <= 4 then
				helper_1000()
			end
			if at <= 5 then
				print("pumpkin---------------------------\n")
				print("stripte -----------------------------\n")
				print("princess-----------------------------\n")
				print("separate----------------------------\n")
				helper_2968(6)
			end
			if at <= 6 then
				helper_3f8(60)
			end
			if at <= 7 then
				helper_3f8(60)
			end
			if at <= 8 then
				helper_13f54(0)
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
	helper_2858()
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
	helper_1000()
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
		helper_3f8(20)
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
	helper_2968(0)
	if vm.skipping() then
		return skip(4)
	end
	helper_1000()
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
	helper_2968(6)
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
	helper_3f8(60)
	if vm.skipping() then
		return skip(7)
	end
	event.SetFadeOut(60, 255.0, 255.0, 255.0)
	helper_3f8(60)
	if vm.skipping() then
		return skip(8)
	end
	helper_13f54(0)
	if vm.skipping() then
		return skip(9)
	end
	return part2()
end

--- Helper function.
local function helper_12d98(arg0: f32, arg1: f32, arg2: f32, arg3: f32)
	local var7: s32 = 0
	local now_party_chara_id: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 7 then
			if at <= 1 then
				helper_3f8(30)
			end
			if at <= 2 then
				helper_2858()
			end
			if at <= 3 then
				helper_2968(0)
			end
			if at <= 4 then
				helper_5fc8(5220010)
			end
			if at <= 5 then
				helper_5fc8(5220015)
			end
			if at <= 6 then
				helper_3f8(30)
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
	helper_3f8(30)
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
	helper_2858()
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
	helper_2968(0)
	if vm.skipping() then
		return skip(4)
	end
	event.ObjsSetMotion(0, "アトラさわる", 6)
	event.ObjsNextMotion(0, "アトラさわるL", 6)
	helper_5fc8(5220010)
	if vm.skipping() then
		return skip(5)
	end
	helper_5fc8(5220015)
	if vm.skipping() then
		return skip(6)
	end
	event.SetFadeOut(30)
	helper_3f8(30)
	if vm.skipping() then
		return skip(7)
	end
	return part2()
end

--- Helper function.
local function helper_144bc(arg0: f32, arg1: f32, arg2: f32, arg3: f32, arg4: s32, arg5: s32)
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
				helper_2858()
			end
			if at <= 2 then
				helper_1000()
			end
			if at <= 3 then
				helper_3f8(30)
			end
			if at <= 4 then
				helper_2968(0)
			end
			if at <= 5 then
				helper_1000()
			end
			if at <= 6 then
				helper_2968(6)
			end
			if at <= 7 then
				helper_3f8(60)
			end
			if at <= 8 then
				helper_3f8(60)
			end
			if at <= 9 then
				helper_13f54(1)
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
	helper_2858()
	if vm.skipping() then
		return skip(2)
	end
	helper_1000()
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
		helper_3f8(30)
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
	helper_2968(0)
	if vm.skipping() then
		return skip(5)
	end
	helper_1000()
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
		helper_2968(6)
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
	helper_3f8(60)
	if vm.skipping() then
		return skip(8)
	end
	event.SetFadeOut(60, 255.0, 255.0, 255.0)
	helper_3f8(60)
	if vm.skipping() then
		return skip(9)
	end
	helper_13f54(1)
	if vm.skipping() then
		return skip(10)
	end
	return part2()
end

--- Helper function.
local function helper_1b1b0(arg0: f32, arg1: f32, arg2: f32, arg3: f32)
	local member: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	local landing1: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_12d98(arg0, arg1, arg2, arg3)
			if not vm.skipping() then
				return landing1()
			end
		end
		if at <= 2 then
			helper_144bc(arg0, arg1, arg2, arg3, 0, 0)
			if not vm.skipping() then
				return part2()
			end
		end
	end
	function part2()
		event.SetWorldCoord(0.0, 0.0, 0.0, 0.0)
	end
	function landing1()
		helper_144bc(arg0, arg1, arg2, arg3, 0, 0)
		if vm.skipping() then
			return skip(3)
		end
		return part2()
	end
	member = event.JoinPartyMember(1) or member
	if member == 1 then
		helper_178d0(arg0, arg1, arg2, arg3, 0, 1)
		if vm.skipping() then
			return skip(1)
		end
	else
		flag = event.GetFlag(520) or flag
		flag_2 = event.GetFlag(532) or flag_2
		if flag ~= 0 and flag_2 == 0 then
			flag_3 = event.GetFlag(522) or flag_3
			if flag_3 == 0 then
				helper_12d98(arg0, arg1, arg2, arg3)
				if vm.skipping() then
					return skip(2)
				end
			end
		end
		helper_144bc(arg0, arg1, arg2, arg3, 0, 0)
		if vm.skipping() then
			return skip(3)
		end
	end
	return part2()
end

--- Helper function.
local function helper_2658c()
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
		event.LoadMotion(5, "event/e200/e277/e277_mints.gltf", "info", global0)
		event.EohSyncChara(0, global0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global0)
		event.LoadChara(5, "chara/c02_base.gltf", "info", global1)
		event.LoadEquip(5, 1, 4, "info", global1)
		event.LoadEquip(5, 1, 3, "info", global1)
		event.LoadEquip(5, 1, 2, "info", global1, 37)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.LoadMotion(5, "event/e200/e277/e277_monica.gltf", "info", global1)
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
		event.LoadMotion(5, "event/e200/e277/e277_mints.gltf", "info", global0)
		event.EohSyncChara(0, global0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global0)
		event.CharaActive(1, 37)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.LoadMotion(5, "event/e200/e277/e277_monica.gltf", "info", global1)
		event.EohSyncChara(1, global1)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global1)
	end
	event.LoadChara(5, "event/e200/e277/e277_hima_b.gltf", "info", 35)
	event.CharaActive(0, 35)
	event.EohSyncChara(2, 35)
	event.ObjsInit(2, 35)
	event.ObjsSyncObj(2, 2)
	event.LoadMes(0, 5, "event/e200/e277/e277.txt")
end

--- Helper function.
local function helper_26290()
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
	event.DeleteChara(35)
end

--- Helper function.
local function helper_27310()
	local var4: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 22 then
			if at <= 1 then
				helper_2658c()
				helper_3f8(15)
			end
			if at <= 2 then
				helper_2968(1)
			end
			if at <= 3 then
				helper_5614(2770010, -1)
			end
			if at <= 4 then
				helper_2968(0)
			end
			if at <= 5 then
				helper_5614(2770020, 60)
			end
			if at <= 6 then
				helper_3f8(15)
			end
			if at <= 7 then
				helper_5fc8(2770030)
			end
			if at <= 8 then
				helper_2968(1)
			end
			if at <= 9 then
				helper_5fc8(2770040)
			end
			if at <= 10 then
				helper_2968(1)
			end
			if at <= 11 then
				helper_5fc8(2770050)
			end
			if at <= 12 then
				helper_2968(1)
			end
			if at <= 13 then
				helper_3f8(30)
			end
			if at <= 14 then
				helper_5fc8(2770060)
			end
			if at <= 15 then
				helper_2968(0)
			end
			if at <= 16 then
				helper_5fc8(2770065)
			end
			if at <= 17 then
				helper_2968(0)
			end
			if at <= 18 then
				helper_5614(2770070, -1)
			end
			if at <= 19 then
				helper_5614(2770080, -1)
			end
			if at <= 20 then
				helper_2968(0)
			end
			if at <= 21 then
				helper_3f8(30)
			end
			if vm.skip_end() then
				return skip(23)
			end
			return part2()
		end
		if at <= 23 then
			helper_3f8(30)
		end
		helper_26290()
	end
	function part2()
		event.CancelDramaScene()
		event.SetFadeOut(30)
		helper_3f8(30)
		if vm.skipping() then
			return skip(24)
		end
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		helper_26290()
		event.ResetCamera(0)
		event.SetFadeIn(30)
	end
	event.SetFlag(277, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.SetFadeOut(30)
	helper_3f8(45)
	if vm.skipping() then
		return skip(1)
	end
	event.LoadSound(2509)
	var4 = event.SndLoadSound(2509) or var4
	helper_2658c()
	event.InitDramaScene()
	event.EohSetFootSoundId(0, 1)
	event.EohSetFootSoundId(1, 1)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "デフォルト顔")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.CharaActive(1, global0)
	event.CharaActive(1, global1)
	event.CmrsSetPos(-117.43, 40.09, 1220.9)
	event.CmrsSetRef(-24.54, 60.52, 1410.11)
	event.SetCharaPos(0, -297.56, 0.0, -373.68)
	event.SetCharaRot(0, 0.0, 2.57, 0.0)
	event.ObjsSetPos(0, -130.99, 21.7, 1253.92)
	event.ObjsSetRot(0, 0.0, 0.77, 0.0)
	event.ObjsSetPos(1, -113.36, 16.04, 1218.2)
	event.ObjsSetRot(1, 0.0, 0.17, 0.0)
	event.SetFadeIn(30)
	event.ObjsSetMotion(0, "歩き")
	event.ObjsSetMotion(1, "歩き")
	helper_3f8(15)
	if vm.skipping() then
		return skip(2)
	end
	event.ObjsMove(0, -76.57, 22.37, 1326.65, 90, 1)
	event.ObjsMove(1, -99.28, 16.04, 1239.49, 30, 1)
	helper_2968(1)
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsSetMotion(1, "立ち")
	helper_5614(2770010, -1)
	if vm.skipping() then
		return skip(4)
	end
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsRotation(0, 0.0, -2.87, 0.0, 20)
	helper_2968(0)
	if vm.skipping() then
		return skip(5)
	end
	event.ObjsSetMotion(0, "立ち")
	helper_5614(2770020, 60)
	if vm.skipping() then
		return skip(6)
	end
	event.CmrsSetPos(-88.03, 39.16, 1280.67)
	event.CmrsSetRef(-98.45, 39.74, 1240.52)
	event.SetReference(global1, "item", 35)
	event.CharaActive(1, 35)
	event.SndSePlay(var4, 0)
	event.ObjsSetMotion(1, "バッチ持ち立ち", 4)
	helper_3f8(15)
	if vm.skipping() then
		return skip(7)
	end
	event.ObjsSetMotion(1, "バッチ持ち会話", 2)
	event.ObjsNextMotion(1, "バッチ持ち立ち", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_5fc8(2770030)
	if vm.skipping() then
		return skip(8)
	end
	event.ResetPakuAnim()
	helper_2968(1)
	if vm.skipping() then
		return skip(9)
	end
	event.ObjsSetMotion(1, "バッチ持ち会話", 2)
	event.ObjsNextMotion(1, "バッチ持ち立ち", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_5fc8(2770040)
	if vm.skipping() then
		return skip(10)
	end
	event.ResetPakuAnim()
	helper_2968(1)
	if vm.skipping() then
		return skip(11)
	end
	event.ObjsSetMotion(1, "バッチ持ち会話", 2)
	event.ObjsNextMotion(1, "バッチ持ち立ち", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_5fc8(2770050)
	if vm.skipping() then
		return skip(12)
	end
	event.ResetPakuAnim()
	helper_2968(1)
	if vm.skipping() then
		return skip(13)
	end
	event.ObjsSetMotion(1, "バッチ持ち立ち")
	helper_3f8(30)
	if vm.skipping() then
		return skip(14)
	end
	event.CharaActive(0, 35)
	event.DelReference(35)
	event.CmrsSetPos(-117.43, 40.09, 1220.9)
	event.CmrsSetRef(-24.54, 60.52, 1410.11)
	event.ObjsSetMotion(0, "やったね", 6)
	event.ObjsNextMotion(0, "立ち", 4)
	event.SetPakuAnim(0, "わらい口パク")
	helper_5fc8(2770060)
	if vm.skipping() then
		return skip(15)
	end
	event.ResetPakuAnim()
	helper_2968(0)
	if vm.skipping() then
		return skip(16)
	end
	event.ObjsSetMotion(0, "会話", 2)
	event.ObjsNextMotion(0, "立ち", 4)
	event.SetPakuAnim(0, "わらい口パク")
	helper_5fc8(2770065)
	if vm.skipping() then
		return skip(17)
	end
	event.ResetPakuAnim()
	helper_2968(0)
	if vm.skipping() then
		return skip(18)
	end
	helper_5614(2770070, -1)
	if vm.skipping() then
		return skip(19)
	end
	event.ObjsSetMotion(1, "歩き")
	event.ObjsMove(1, -60.53, 20.6, 1300.47, 60, 1)
	event.CmrsMove(-133.69, 30.07, 1231.38, -2.07, 60.52, 1392.67, 150)
	event.ObjsSetMotion(0, "モニカ見立うなづき", 6)
	event.ObjsNextMotion(0, "立ち", 4)
	helper_5614(2770080, -1)
	if vm.skipping() then
		return skip(20)
	end
	event.ObjsSetMotion(0, "歩き")
	event.ObjsRotation(0, 0.0, 0.89, 0.0, 30)
	helper_2968(0)
	if vm.skipping() then
		return skip(21)
	end
	event.ObjsMove(0, -42.89, 22.37, 1361.14, 60, 1)
	event.ObjsMove(1, -28.2, 20.64, 1346.17, 60, 1)
	helper_3f8(30)
	if vm.skipping() then
		return skip(22)
	end
	return part2()
end

--- Helper function.
local function helper_a58(arg0: f32)
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
local function helper_1a44(arg0: f32, arg1: f32, arg2: f32, arg3: f32)
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
local function helper_1b18(arg0: s32, arg1: f32)
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	do
		local _, out2, _ = event.GetCharaRot(arg0)
		var5 = out2 or var5
	end
	var6 = vm.f32(arg1 - var5)
	if var6 < vm.f32(-3.1415927) then
		var6 = vm.f32(var6 + vm.f32(6.2831855))
	end
	if vm.f32(3.1415927) < var6 then
		var6 = vm.f32(var6 - vm.f32(6.2831855))
	end
	if -0.5 < var6 and var6 < 0.5 then
	else
		event.SetMotion(arg0, "歩き")
	end
	var7 = 0.0
	var8 = vm.f32(helper_a58(var6) * 8.0)
	while var7 < var8 do
		var9 = helper_1a44(0.0, var6, var7, var8)
		var9 = vm.f32(var9 + var5)
		event.SetCharaRot(arg0, 0.0, var9, 0.0)
		var7 = vm.f32(var7 + 1.0)
		if vm.wait() then
			return skip(1)
		end
	end
	event.GetCharaRot(arg0) -- retail: argument 2 is a value where the handler writes an output; the output is discarded; argument 3 is a value where the handler writes an output; the output is discarded; argument 4 is a value where the handler writes an output; the output is discarded
	event.SetMotion(arg0, "立ち")
end

--- Helper function.
local function helper_20d0(arg0: s32, arg1: f32, arg2: f32)
	local var3: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	do
		local out1, _, out3 = event.GetCharaPos(arg0)
		var3 = out1 or var3
		var5 = out3 or var5
	end
	var6 = event.GetRotLookPos(arg1 - var3, arg2 - var5) or var6
	helper_1b18(arg0, var6)
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_c3c(arg0: f32, arg1: f32)
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
local function helper_9014(arg0: s32, arg1: any, arg2: any)
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
			var34 = vm.f32(helper_c3c(helper_a58(angle), helper_a58(angle_2)) * 8.0)
			var35 = helper_1a44(0.0, angle, var33, var34)
			var35 = vm.f32(var35 + var27)
			var36 = helper_1a44(0.0, angle_2, var33, var34)
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
	var34 = vm.f32(helper_c3c(helper_a58(angle), helper_a58(angle_2)) * 8.0)
	while var33 < var34 do
		var35 = helper_1a44(0.0, angle, var33, var34)
		var35 = vm.f32(var35 + var27)
		event.SetCharaRot(arg0, 0.0, var35, 0.0)
		var36 = helper_1a44(0.0, angle_2, var33, var34)
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
local function helper_2c44(arg0: any, arg1: any, arg2: any, arg3: any)
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
local function helper_8130(arg0: s32, arg1: any, arg2: any, arg3: s32, arg4: any)
	local var5: s32 = 0
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_2c44(arg0, arg1, arg2, arg3)
		end
		if at <= 2 then
			_, var5 = helper_7cfc(arg0, 0, var5)
		end
		helper_2d54(arg0)
	end
	if vm.skipping() then
		return skip(1)
	end
	helper_2c44(arg0, arg1, arg2, arg3)
	if vm.skipping() then
		return skip(2)
	end
	_, var5 = helper_7cfc(arg0, 0, var5)
	if vm.skipping() then
		return skip(3)
	end
	helper_2d54(arg0)
end

--- Helper function.
local function helper_a548(arg0: any, arg1: any, arg2: any)
	local rot_y: f32 = 0
	local player_chara: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_9014(player_chara, arg0, arg1)
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
	helper_9014(player_chara, arg0, arg1)
	if vm.skipping() then
		return skip(2)
	end
	return rot_y
end

--- Helper function.
local function helper_9da4(arg0: any, arg1: f32)
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
			var13 = helper_1a44(0.0, angle, var14, var15)
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
		var13 = helper_1a44(0.0, angle, var14, var15)
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
local function helper_a6b8(arg0: any, arg1: f32, arg2: any, arg3: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_9da4(arg0, arg1)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	if arg3 ~= 0 then
		helper_9da4(arg0, arg1)
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
local function helper_a808(arg0: s32, arg1: s32, arg2: s32, arg3: s32)
	local var4: f32 = 0
	local player_chara: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var4 = helper_a548(arg0, arg2, arg3)
		end
		if at <= 2 then
			helper_8130(0, arg1, arg0, player_chara, 0)
		end
		if at <= 3 then
			helper_a6b8(arg0, var4, arg2, arg3)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var4 = helper_a548(arg0, arg2, arg3)
	if vm.skipping() then
		return skip(2)
	end
	player_chara = event.GetControlChrid() or player_chara
	helper_8130(0, arg1, arg0, player_chara, 0)
	if vm.skipping() then
		return skip(3)
	end
	helper_a6b8(arg0, var4, arg2, arg3)
	if vm.skipping() then
		return skip(4)
	end
end

--- Helper function.
local function helper_e1c8(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_3f8(15)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFadeOut(15)
	helper_3f8(15)
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
local function helper_107e0()
	local player_chara: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local flag_4: s32 = 0
	local var9: s32 = 0
	local flag_5: s32 = 0
	local flag_6: s32 = 0
	local flag_7: s32 = 0
	local player_chara_2: s32 = 0
	local var14: f32 = 0
	local var16: f32 = 0
	local var17: f32 = 0
	local var19: f32 = 0
	local var20: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_8130(0, -1, var1, player_chara, 0)
		end
		if at <= 2 then
			var3 = 1
			helper_a808(var1, -1, 0, 0)
		end
		if at <= 3 then
			helper_8130(0, -1, var1, player_chara, 0)
		end
		if at <= 4 then
			helper_9da4(player_chara_2, var20)
		end
		if at <= 5 then
			helper_8130(0, -1, var1, player_chara_2, 0)
		end
		if at <= 6 then
			helper_e1c8(25)
		end
		if at <= 7 then
			helper_e1c8(24)
		end
		if at <= 8 then
			helper_e1c8(26)
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
	if var2 == 100 then
		var4 = event.GetAnalyze(103) or var4
		if var4 == 0 then
			event.MesMake_2(
				0,
				"なんだかさぁ、最近さびしいんだよね。\nなんか、大きなものが足りないような\n気がするんだ。なんだろ・・・"
			)
		else
			flag = event.GetFlag(280) or flag
			if flag == 0 then
				event.MesMake_2(
					0,
					"ジュラクさまが復活したよ！\nそれにしても、今まで、ジュラクさまのことを\n忘れてしまってたなんて、どうしてなんだろう。"
				)
			else
				event.MesMake_2(
					0,
					"この森も元どおりになってよかった。\nジュラクさまの機嫌もいいし、言うことなしだ。"
				)
			end
		end
	end
	if var2 == 101 then
		flag_2 = event.GetFlag(280) or flag_2
		if flag_2 == 0 then
			event.MesMake_2(
				0,
				"やあ、なかなかいいのが揃ってるよ。\nジュラクさまの復活記念で特別にサービス\nしとくから、買っていってくれ。"
			)
		else
			event.MesMake_2(
				0,
				"おかげさまで、すっかりジュラクさまやこの森も\n元どおりだ。ありがとな。\nまた、武器が必要になったらいつでも来てくれよ。"
			)
		end
	end
	if var2 == 104 then
		flag_3 = event.GetFlag(280) or flag_3
		if flag_3 == 0 then
			event.MesMake_2(
				0,
				"うむむ・・・グリフォンのやつにしてやられた。\nまさか、消されてしまっていたとは・・・"
			)
		else
			event.MesMake_2(
				0,
				"ジュラクさまも、復活されたことだし、いよいよ\nグリフォン大帝に反撃するときだ。\nみんなが力を合わせれば、きっと勝てるはずさ。"
			)
		end
	end
	if var2 == 102 then
		flag_4 = event.GetFlag(280) or flag_4
		if flag_4 == 0 then
			var9 = event.GetSavedataEtc(1, 52) or var9
			if var9 == 0 then
				event.MesMake_2(
					0,
					"モンスターへんげバッジ入荷しましたよ～。\nめったに手に入らないものだから、\n売り切れないうちに買っておいてね。"
				)
			else
				event.MesMake_2(
					0,
					"あぶなかったね。そのモンスターへんげバッジ\n最後の一個だったの。一度売り切れたら、今度\nいつ入荷できるかわからないのよね～。"
				)
			end
		else
			event.MesMake_2(
				0,
				"モンスターへんげバッジは使ってる？\nあれね、他にも違う種類がたくさんあるんだよ。"
			)
			helper_9014(player_chara, var1, 0)
			if vm.skipping() then
				return skip(1)
			end
			helper_8130(0, -1, var1, player_chara, 0)
			if vm.skipping() then
				return skip(2)
			end
			var3 = 1
			event.MesMake_2(
				0,
				"モンスターが欲しがってるものを３個セットで\nプレゼントすると上機嫌になって、倒したとき、\nバッジを落とす場合があるの。やってみて！<page>それには、もちろんウチで売ってる\nギフトカプセルが必要だったりするんだけどね。\nうふ！ささ、買った買った！"
			)
		end
	end
	if var2 == 103 then
		flag_5 = event.GetFlag(280) or flag_5
		if flag_5 == 0 then
			event.MesMake_2(
				0,
				"ハーイ！ちゃんと食べてる？\n食べないと大きくなれないんだから。\nいい、ちゃんと食べるのよ。"
			)
		else
			event.MesMake_2(
				0,
				"ジュラクさまの機嫌もいいし、お店も\n繁盛してるし、最近いいことばっかだわ。"
			)
		end
	end
	if var2 == 105 then
		flag_6 = event.GetFlag(640) or flag_6
		if flag_6 == 0 then
			flag_7 = event.GetFlag(280) or flag_7
			if flag_7 == 0 then
				event.MesMake_2(
					0,
					"私、今までどうしてたのかなぁ？\nう～ん、よく思い出せないの。<page>あれ？よく見ると、めずらしい\nかっこうしてるね。"
				)
			else
				event.MesMake_2(
					0,
					"いよいよ新たなる地に旅立たれるのですね。\nがんばってください。"
				)
			end
		else
			event.MesMake_2(
				0,
				"きっと、グリフォン大帝を倒して\nこの闇の歴史を元に戻してください。\nお願いします！！"
			)
		end
	end
	if var3 == 0 then
		helper_a808(var1, -1, 0, 0)
		if vm.skipping() then
			return skip(3)
		end
	end
	if var3 == 1 then
		helper_8130(0, -1, var1, player_chara, 0)
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
		helper_9da4(player_chara_2, var20)
		if vm.skipping() then
			return skip(5)
		end
		event.SetCharaRot(player_chara_2, 0.0, var20, 0.0)
		event.SetMotion(player_chara_2, "立ち")
		helper_8130(0, -1, var1, player_chara_2, 0)
		if vm.skipping() then
			return skip(6)
		end
		event.ResetCamera(1, 3.1415927)
	end
	event.SetAi(1, var1)
	if var2 == 101 then
		helper_e1c8(25)
		if vm.skipping() then
			return skip(7)
		end
	end
	if var2 == 102 then
		helper_e1c8(24)
		if vm.skipping() then
			return skip(8)
		end
	end
	if var2 == 103 then
		helper_e1c8(26)
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
	local var8: s32 = 0
	local argc: s32 = 0
	local argc_2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
		if at <= 2 then
			return
		end
		if at <= 5 then
			if at <= 3 then
				helper_3f8(10)
			end
			return
		end
		if at <= 6 then
			return
		end
		if at <= 7 then
			return
		end
		if at <= 8 then
			helper_75c(1)
		end
	end
	program_99()
	old_map_no = event.GetOldMapNo() or old_map_no
	if old_map_no == 0 then
		event.SetCameraPos(39.03, 111.84, 77.64)
		event.SetCameraRef(36.78, 22.33, 74.62)
		event.SetFadeOut(0, 255, 255, 255)
		if vm.wait() then
			return skip(1)
		end
		event.SetCameraPos(102.4, 73.47, 1368.2)
		event.SetCameraRef(102.4, 53.47, 1488.2)
		event.SetCharaPos(0, 110.0, 23.7, 1533.0)
		event.SetCharaRot(0, 0.0, -3.1415927, 0.0)
		event.ResetCamera(1, 3.14, 2.0)
	end
	event.SetFadeIn(30)
	event.GetFlag(250)
	event.GetFlag(260)
	event.GetFlag(270)
	event.GetFlag(272)
	event.GetFlag(275)
	event.GetFlag(280)
	event.GetFlag(285)
	var8 = event.GetAnalyze(103) or var8
	event.GetAnalyze(104)
	event.GetDioramaPercent(0)
	if var8 == 0 then
		return
	end
	if helper_e538a72d() ~= 0 then
		event.SetFadeOut(30)
		event.SetFlag(270, 1)
		helper_1cfc4()
		if vm.skipping() then
			return skip(2)
		end
		event.SetCharaPos(0, 169.8, 23.7, 1378.8)
		return
	end
	if helper_342a37b0() ~= 0 then
		event.SetFadeOut(30)
		event.SetFlag(272, 1)
		helper_21790()
		if vm.skipping() then
			return skip(3)
		end
		event.AddItem(361)
		event.AddItem(308)
		argc = event.CheckGetItemLimit() or argc
		argc_2 = event.CheckItemOver() or argc_2
		if argc >= 1 or argc_2 >= 1 then
			event.SetFadeOut(10)
			helper_3f8(10)
			if vm.skipping() then
				return skip(4)
			end
			event.GotoMenu(16)
			if vm.wait() then
				return skip(5)
			end
			event.SetFadeIn(10)
		end
		return
	end
	if helper_ee09935e() ~= 0 then
		event.SetFadeOut(30)
		event.SetFlag(275, 1)
		helper_66ac1f76()
		helper_25678()
		if vm.skipping() then
			return skip(6)
		end
		return
	end
	if helper_b84429a4() ~= 0 then
		event.SetFadeOut(30)
		event.SetFlag(280, 1)
		helper_29a30()
		if vm.skipping() then
			return skip(7)
		end
		return
	end
	if helper_c5ea1698() ~= 0 then
		event.SetFadeOut(30)
		event.SetFlag(285, 1)
		helper_30b18()
		if vm.skipping() then
			return skip(8)
		end
		event.AddItem(31)
		helper_75c(1)
		if vm.skipping() then
			return skip(9)
		end
		return
	end
	event.SetCharaPos(0, 110.0, 23.7, 1533.0)
	event.SetCharaRot(0, 0.0, -3.1415927, 0.0)
	event.ResetCamera(1)
end

--- Program 150.
script[150] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_21790()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 300.
script[300] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_1b1b0(100.0, vm.f32(23.67), 1500.0, 0.0)
	if vm.skipping() then
		return skip(1)
	end
	event.MapJump(-1, "g01")
end

--- Program 400.
script[400] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.FuncPointShow("", "e277", 0)
	event.SetFlag(277, 1)
	helper_27310()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 401.
script[401] = function()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	local player_chara: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local flag_4: s32 = 0
	local flag_5: s32 = 0
	local argc: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_87c4(0, -1, 3, 0, 416)
		end
		if at <= 2 then
			helper_87c4(0, -1, 3, 0, 416)
		end
		if at <= 3 then
			helper_87c4(0, -1, 3, 0, 416)
		end
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
	event.SetCameraNextPos(-140.41, 35.58, 1026.08)
	event.SetCameraNextRef(23.01, 135.7, 535.77)
	player_chara = event.GetControlChrid() or player_chara
	helper_20d0(player_chara, 0.0, 300.0)
	if vm.skipping() then
		return skip(1)
	end
	event.SetMotion(0, "立ち")
	event.SetMesPreset(0, 0)
	flag = event.GetFlag(640) or flag
	if flag == 0 then
		flag_2 = event.GetFlag(372) or flag_2
		if flag_2 == 0 then
			flag_3 = event.GetFlag(280) or flag_3
			if flag_3 == 0 then
				flag_4 = event.GetFlag(275) or flag_4
				if flag_4 == 0 then
					flag_5 = event.GetFlag(272) or flag_5
					if flag_5 == 0 then
						event.MesMake_2(
							0,
							"モーン、モーン。\n記憶がいまひとつ戻らないのね～\nもう少し時間が必要なのね～"
						)
					else
						event.MesMake_2(
							0,
							"モーン、モーン。\n種はちゃんと植えたのね～？\n芽は出たのね～？<page>せっかくあげたから無駄にしては\nダメなのね～"
						)
					end
				else
					argc = event.GetItemNum(356) or argc
					if argc <= 0 then
						event.MesMake_2(
							0,
							"太陽のしずくは、森のヒマーラという\nモンスターと話せば手に入るのね～\nバッジを使って、話をするのね～"
						)
						helper_87c4(0, -1, 3, 0, 416)
						if vm.skipping() then
							return skip(2)
						end
						event.MesMake_2(
							0,
							"ヒマーラになるためには、ヒマーラバッジを\n手に入れる必要があるのね～<page>ヒマーラバッジは、洋服屋さんで\n売ってることもあるのね～<page>そう言えば、洋服屋さんは、\nワチの鼻の中にもあったのね～"
						)
						helper_87c4(0, -1, 3, 0, 416)
						if vm.skipping() then
							return skip(3)
						end
						event.MesMake_2(0, "右の鼻はまだ空いてるのね～\nテナント募集中なのね～")
					else
						event.MesMake_2(
							0,
							"太陽のしずく、見つけたみたいなのね～\nあとは、ラフレシアの種を植えたところに\n太陽のしずくをかけるのね～<page>七色蝶に会えるといいのね～\n健闘をいのるのね～"
						)
					end
				end
			else
				event.MesMake_2(
					0,
					"くわしいことはてんびん谷の寺院にいる\n大賢者クレストに聞くのね～\nなんでも占ってくれるのね～、心強いのね～"
				)
			end
		else
			event.MesMake_2(
				0,
				"どうやら、クレストに会えたみたいなのね～\nとりあえず、よかったのね～<page>でも、まだまだ先は長そうなのね～\nがんばるのね～"
			)
		end
	else
		event.MesMake_2(
			0,
			"ユーたち、いよいよグリフォンと戦うのね～\nでも、ひとつ気になることがあるのね～<page>グリフォンから感じる「気」の中に、優しい気が\n混じってるのね～不思議なのね～"
		)
	end
	helper_87c4(0, -1, 3, 0, 416)
	if vm.skipping() then
		return skip(4)
	end
	event.SetCameraPos(pos_x, pos_y, pos_z)
	event.SetCameraRef(pos_x_2, pos_y_2, pos_z_2)
	event.SetCrossfade(10)
end

--- Program 402.
script[402] = function()
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_75c(1)
		end
		if at <= 2 then
			helper_2a84(0, 1)
			helper_87c4(0, -1, 5, 256, 208)
		end
	end
	event.SetMotion(0, "立ち")
	flag = event.GetFlag(36) or flag
	if flag == 0 then
		event.SetFlag(36, 1)
		event.AddItem(376)
		helper_cdfc(376, 1)
		if vm.skipping() then
			return skip(1)
		end
		helper_75c(1)
		if vm.skipping() then
			return skip(2)
		end
	else
		helper_2a84(0, 1)
		event.MesMake_2(0, "この卵から、何が\n産まれるのかな？")
		helper_87c4(0, -1, 5, 256, 208)
		if vm.skipping() then
			return skip(3)
		end
	end
end

--- Program 501.
script[501] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_30b18()
	if vm.skipping() then
		return skip(1)
	end
	event.SetFadeIn(30)
end

--- Program 1000.
script[1000] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_107e0()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 12700.
script[12700] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.DbgSetAnalyzeFlag(0, 4, 0)
	event.DbgSetAnalyzeFlag(0, 5, 0)
	event.DbgSetAnalyzeFlag(0, 6, 0)
	event.DbgSetAnalyzeFlag(0, 7, 0)
	event.DbgSetAnalyzeFlag(0, 8, 0)
	event.DbgSetAnalyzeFlag(0, 9, 0)
	event.DbgSetAnalyzeFlag(0, 0, 1)
	event.DbgSetAnalyzeFlag(0, 2, 1)
	event.DbgSetAnalyzeFlag(0, 3, 1)
	event.SetFlag(270, 0)
	event.SetFlag(272, 1)
	event.SetFlag(275, 1)
	event.SetFlag(277, 1)
	event.SetFlag(280, 1)
	event.SetFlag(285, 1)
	event.MapJump(-1, 25, 100)
	if vm.wait() then
		return skip(1)
	end
end

--- Program 12720.
script[12720] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.DbgSetAnalyzeFlag(0, 4, 0)
	event.DbgSetAnalyzeFlag(0, 5, 0)
	event.DbgSetAnalyzeFlag(0, 6, 0)
	event.DbgSetAnalyzeFlag(0, 7, 0)
	event.DbgSetAnalyzeFlag(0, 8, 0)
	event.DbgSetAnalyzeFlag(0, 9, 0)
	event.DbgSetAnalyzeFlag(0, 0, 1)
	event.DbgSetAnalyzeFlag(0, 2, 1)
	event.DbgSetAnalyzeFlag(0, 3, 1)
	event.SetFlag(270, 1)
	event.SetFlag(272, 0)
	event.SetFlag(275, 1)
	event.SetFlag(277, 1)
	event.SetFlag(280, 1)
	event.SetFlag(285, 1)
	event.MapJump(-1, 25, 100)
	if vm.wait() then
		return skip(1)
	end
end

--- Program 12750.
script[12750] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.DbgSetAnalyzeFlag(0, 5, 0)
	event.DbgSetAnalyzeFlag(0, 6, 0)
	event.DbgSetAnalyzeFlag(0, 7, 0)
	event.DbgSetAnalyzeFlag(0, 8, 0)
	event.DbgSetAnalyzeFlag(0, 9, 0)
	event.DbgSetAnalyzeFlag(0, 0, 1)
	event.DbgSetAnalyzeFlag(0, 2, 1)
	event.DbgSetAnalyzeFlag(0, 3, 1)
	event.DbgSetAnalyzeFlag(0, 4, 1)
	event.SetFlag(270, 1)
	event.SetFlag(272, 1)
	event.SetFlag(275, 0)
	event.SetFlag(277, 1)
	event.SetFlag(280, 1)
	event.SetFlag(285, 1)
	event.MapJump(-1, 25, 100)
	if vm.wait() then
		return skip(1)
	end
end

--- Program 12770.
script[12770] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.DbgSetAnalyzeFlag(0, 5, 0)
	event.DbgSetAnalyzeFlag(0, 6, 0)
	event.DbgSetAnalyzeFlag(0, 7, 0)
	event.DbgSetAnalyzeFlag(0, 8, 0)
	event.DbgSetAnalyzeFlag(0, 9, 0)
	event.DbgSetAnalyzeFlag(0, 0, 1)
	event.DbgSetAnalyzeFlag(0, 2, 1)
	event.DbgSetAnalyzeFlag(0, 3, 1)
	event.DbgSetAnalyzeFlag(0, 4, 1)
	event.SetFlag(270, 1)
	event.SetFlag(272, 1)
	event.SetFlag(275, 1)
	event.SetFlag(277, 0)
	event.SetFlag(280, 1)
	event.SetFlag(285, 1)
	event.SetSavedataEtc(1, 52, 1)
	event.MapJump(-1, 25, 400)
	if vm.wait() then
		return skip(1)
	end
end

--- Program 12800.
script[12800] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.DbgSetAnalyzeFlag(0, 5, 0)
	event.DbgSetAnalyzeFlag(0, 6, 0)
	event.DbgSetAnalyzeFlag(0, 7, 0)
	event.DbgSetAnalyzeFlag(0, 8, 0)
	event.DbgSetAnalyzeFlag(0, 9, 0)
	event.DbgSetAnalyzeFlag(0, 0, 1)
	event.DbgSetAnalyzeFlag(0, 2, 1)
	event.DbgSetAnalyzeFlag(0, 3, 1)
	event.DbgSetAnalyzeFlag(0, 4, 1)
	event.SetFlag(270, 1)
	event.SetFlag(272, 1)
	event.SetFlag(275, 1)
	event.SetFlag(277, 1)
	event.SetFlag(280, 0)
	event.SetFlag(285, 1)
	event.SetFlag(260, 1)
	event.MapJump(-1, 25, 100)
	if vm.wait() then
		return skip(1)
	end
end

--- Program 12850.
script[12850] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.DbgSetAnalyzeFlag(0, 0, 1)
	event.DbgSetAnalyzeFlag(0, 2, 1)
	event.DbgSetAnalyzeFlag(0, 3, 1)
	event.DbgSetAnalyzeFlag(0, 4, 1)
	event.DbgSetAnalyzeFlag(0, 5, 1)
	event.DbgSetAnalyzeFlag(0, 6, 1)
	event.DbgSetAnalyzeFlag(0, 7, 1)
	event.DbgSetAnalyzeFlag(0, 8, 1)
	event.DbgSetAnalyzeFlag(0, 9, 1)
	event.SetFlag(270, 1)
	event.SetFlag(272, 1)
	event.SetFlag(275, 1)
	event.SetFlag(277, 1)
	event.SetFlag(280, 1)
	event.SetFlag(285, 0)
	event.MapJump(-1, 25, 100)
	if vm.wait() then
		return skip(1)
	end
end

return script
