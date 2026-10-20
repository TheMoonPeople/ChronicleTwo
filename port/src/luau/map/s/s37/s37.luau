--!strict
-- map/s/s37/s37.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_076280e8 = require("@lib/event/helper_076280e8")
local helper_1d96573f = require("@lib/event/helper_1d96573f")
local helper_38448da1 = require("@lib/event/helper_38448da1")
local helper_57cb224f = require("@lib/event/helper_57cb224f")
local helper_650bfa16 = require("@lib/event/helper_650bfa16")
local helper_8a56995e = require("@lib/event/helper_8a56995e")
local helper_ac1aeb7a = require("@lib/event/helper_ac1aeb7a")
local helper_b8bc5976 = require("@lib/event/helper_b8bc5976")
local helper_e304888c = require("@lib/event/helper_e304888c")
local helper_ff0edc1d = require("@lib/event/helper_ff0edc1d")

--- Helper function.
local function helper_23514()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 14 then
			if at <= 1 then
				helper_1d96573f(6160450)
			end
			if at <= 2 then
				helper_076280e8()
			end
			if at <= 3 then
				helper_1d96573f(6160460)
			end
			if at <= 4 then
				helper_076280e8()
			end
			if at <= 5 then
				helper_1d96573f(6160470)
			end
			if at <= 6 then
				helper_1d96573f(6160480)
			end
			if at <= 7 then
				helper_1d96573f(6160490)
			end
			if at <= 8 then
				helper_1d96573f(6160500)
			end
			if at <= 9 then
				helper_ff0edc1d(30)
			end
			if at <= 10 then
				helper_1d96573f(6160510)
			end
			if at <= 11 then
				helper_1d96573f(6160520)
			end
			if at <= 12 then
				helper_1d96573f(6160530)
			end
			if at <= 13 then
				helper_ff0edc1d(30)
			end
			if vm.skip_end() then
				return skip(15)
			end
			return part2()
		end
		if at <= 15 then
			helper_ff0edc1d(30)
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SetFadeOut(30)
		helper_ff0edc1d(30)
		if vm.skipping() then
			return skip(16)
		end
		event.SndSeAllStop(4)
		event.CharaActive(0)
		event.CharaActive(32)
		event.CharaActive(33)
		event.SetStatus(1, 0, 256, 0)
		event.DelExtMotion(0)
		event.DeleteChara(32)
		event.DeleteChara(33)
		event.DeleteChara(34)
		event.LoadMes(0, -1)
	end
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.StopBgm(0)
	var0 = event.SndLoadSound(6203) or var0
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.SetStatus(1, 0, 256, 1)
	event.ChangeDir("event/e600/e616/")
	event.LoadMes(0, 5, "e616.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e616_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e616_monica.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.LoadChara(5, "e616_osmond.gltf", "info", 34)
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
		event.LoadMotion(5, "event/e616/e616/e616_mints.chr", "info", 32)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 32)
		event.EohSyncChara(0, 32)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	else
		event.LoadChara(5, "chara/c02_base.gltf", "info", 32)
		event.LoadEquip(5, 1, 4, "info", 32)
		event.LoadEquip(5, 1, 3, "info", 32)
		event.LoadEquip(5, 1, 2, "info", 32, 33)
		event.LoadMotion(5, "event/e616/e616/e616_monica.chr", "info", 32)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 32)
		event.EohSyncChara(1, 32)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 0)
	end
	event.CharaActive(32)
	event.CharaActive(33)
	event.ObjsSetPos(1, 16.0, 2.56, 91.59)
	event.ObjsSetRot(1, 0.0, -0.36, 0.0)
	event.ObjsSetPos(0, -16.0, 2.56, 91.59)
	event.ObjsSetRot(0, 0.0, 0.4, 0.0)
	event.ObjsSetPos(2, -0.02, 0.4, 133.89)
	event.ObjsSetRot(2, 0.0, -3.12, 0.0)
	event.ObjsSetMotion(0, "下見立ち", 4, -1.0, 1)
	event.ObjsSetMotion(1, "下見立ち", 4, -1.0, 1)
	event.ObjsSetMotion(2, "立ち2")
	event.InitDramaScene()
	event.SetFadeIn(30)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "デフォルト顔")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.CmrsInitPas()
	event.CmrsSetPasFrm(200)
	event.CmrsAddPas(-0.25, 46.07, -202.38, 0.0, 0.7, 166.5)
	event.CmrsAddPas(-0.12, 46.07, -7.83, 0.0, 0.7, 166.5)
	event.CmrsStartPas()
	event.ObjsSetMotion(2, "会話2", 2)
	event.ObjsNextMotion(2, "立ち2", 4)
	helper_1d96573f(6160440)
	if vm.skipping() then
		return skip(1)
	end
	event.ObjsSetMotion(2, "会話2", 2)
	event.ObjsNextMotion(2, "立ち2", 4)
	helper_1d96573f(6160450)
	if vm.skipping() then
		return skip(2)
	end
	helper_076280e8()
	if vm.skipping() then
		return skip(3)
	end
	event.CmrsInitPas()
	event.CmrsSetPasFrm(60)
	event.CmrsAddPas(-0.12, 46.07, -7.83, 0.0, 0.7, 166.5)
	event.CmrsAddPas(-0.09, 46.07, 32.22, 0.0, 0.7, 166.5)
	event.CmrsStartPas()
	event.ObjsSetMotion(2, "会話2", 2)
	event.ObjsNextMotion(2, "立ち2", 4)
	helper_1d96573f(6160460)
	if vm.skipping() then
		return skip(4)
	end
	helper_076280e8()
	if vm.skipping() then
		return skip(5)
	end
	event.ObjsSetMotion(2, "会話2", 2)
	event.ObjsNextMotion(2, "現在から未来", 2)
	event.ObjsNextMotion(2, "立ち2")
	helper_1d96573f(6160470)
	if vm.skipping() then
		return skip(6)
	end
	event.ObjsSetMotion(2, "会話2", 2)
	event.ObjsNextMotion(2, "立ち2", 4)
	helper_1d96573f(6160480)
	if vm.skipping() then
		return skip(7)
	end
	helper_1d96573f(6160490)
	if vm.skipping() then
		return skip(8)
	end
	event.ObjsSetMotion(2, "うなづく", 2)
	event.ObjsNextMotion(2, "えっへん", 2)
	event.ObjsNextMotion(2, "えっへんループ", 4)
	event.SndSePlay(var0, 8)
	helper_1d96573f(6160500)
	if vm.skipping() then
		return skip(9)
	end
	helper_ff0edc1d(30)
	if vm.skipping() then
		return skip(10)
	end
	event.ObjsSetPos(2, 0.01, 2.56, 119.48)
	event.ObjsSetMotion(2, "立ち2", 4)
	event.CmrsSetPos(-0.08, 42.18, 169.74)
	event.CmrsSetRef(0.06, 16.11, 104.69)
	event.ObjsSetMotion(1, "右向く", 2)
	event.ObjsNextMotion(1, "右向く会話", 6)
	event.ObjsNextMotion(1, "右向くL", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_1d96573f(6160510)
	if vm.skipping() then
		return skip(11)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(1, "右向く会話", 2)
	event.ObjsNextMotion(1, "右向くL", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_1d96573f(6160520)
	if vm.skipping() then
		return skip(12)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(0, "下→左", 6)
	event.ObjsNextMotion(0, "左向く会話", 6)
	event.ObjsNextMotion(0, "左向くL", 4)
	event.SetPakuAnim(0, "わらい口パク")
	helper_1d96573f(6160530)
	if vm.skipping() then
		return skip(13)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(1, "右向くうなづき", 2)
	event.ObjsNextMotion(1, "右向くL", 4)
	event.ObjsSetMotion(2, "うなづく", 2)
	event.ObjsNextMotion(2, "立ち2", 4)
	event.ObjsSetMotion(0, "左向くうなづき", 6)
	event.ObjsNextMotion(0, "左向くL", 4)
	event.SndSePlay(var0, 9)
	event.SndSePlay(var0, 10)
	helper_ff0edc1d(30)
	if vm.skipping() then
		return skip(14)
	end
	return part2()
end

--- Helper function.
local function helper_25830(arg0: f32)
	local var2: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	do
		local _, out2, _ = event.GetCharaRot(0)
		var2 = out2 or var2
	end
	var4 = vm.f32(arg0 + vm.f32(6.2831855))
	var5 = vm.f32(var2 + vm.f32(6.2831855))
	var6 = vm.f32(var4 - var5)
	if var6 < 0 then
		var6 = vm.f32(var6 * -1.0)
	end
	if vm.f32(3.1415927) < var6 then
		var6 = vm.f32(var6 - vm.f32(3.1415927))
	end
	if vm.f32(3.1415927) < var6 then
		var6 = vm.f32(var6 - vm.f32(3.1415927))
	end
	event.Initialize()
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetMotion(0, "歩き")
	event.ObjsRotation(0, 0.0, arg0, 0.0, vm.ftoi(vm.f32(var6 * 10.0)))
	helper_650bfa16(0)
	if vm.skipping() then
		return skip(1)
	end
	event.ObjsSetMotion(0, "立ち")
	event.Finish()
end

--- Helper function.
local function helper_198e4(arg0: s32)
	local flag: s32 = 0
	local flag_2: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		return 0
	end
	if vm.skipping() then
		return skip(1)
	end
	flag = event.GetFlag(203) or flag
	flag_2 = event.GetFlag(204) or flag_2
	if flag ~= 0 and flag_2 == 0 then
		return 0
	end
	var3 = event.GetCnt(1) or var3
	print("CheckTrainDoor,station_id=", var3, ",lr=", arg0, "-----------------------------\n")
	if var3 == 2 then
		if arg0 ~= 0 then
			return 1
		else
			return 0
		end
	end
	if var3 == 3 then
		if arg0 ~= 0 then
			return 1
		else
			return 0
		end
	end
	if var3 == 4 then
		if arg0 ~= 0 then
			return 0
		else
			return 1
		end
	end
	if var3 == 5 then
		if arg0 ~= 0 then
			return 0
		else
			return 1
		end
	end
	if var3 == 6 then
		if arg0 ~= 0 then
			return 0
		else
			return 1
		end
	end
	if var3 == 7 then
		if arg0 ~= 0 then
			return 1
		else
			return 0
		end
	end
	if var3 == 8 then
		if arg0 ~= 0 then
			return 0
		else
			return 1
		end
	end
	if var3 == 9 then
		if arg0 ~= 0 then
			return 1
		else
			return 0
		end
	end
	if arg0 ~= 0 then
		return 0
	else
		return 1
	end
end

--- Helper function.
local function helper_17988()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			return
		end
		if at <= 3 then
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
		if at <= 7 then
			return
		end
		if at <= 8 then
			return
		end
		if at <= 9 then
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var0 = event.GetCnt(1) or var0
	if var0 == 2 then
		event.MapJump(-1, "s02")
		if vm.wait() then
			return skip(2)
		end
		return
	end
	if var0 == 3 then
		event.MapJump(-1, "s04")
		if vm.wait() then
			return skip(3)
		end
		return
	end
	if var0 == 4 then
		event.MapJump(-1, "s09")
		if vm.wait() then
			return skip(4)
		end
		return
	end
	if var0 == 5 then
		event.MapJump(-1, "s10")
		if vm.wait() then
			return skip(5)
		end
		return
	end
	if var0 == 6 then
		event.MapJump(-1, "s11")
		if vm.wait() then
			return skip(6)
		end
		return
	end
	if var0 == 7 then
		event.MapJump(-1, "s12")
		if vm.wait() then
			return skip(7)
		end
		return
	end
	if var0 == 8 then
		event.MapJump(-1, "s31")
		if vm.wait() then
			return skip(8)
		end
		return
	end
	if var0 == 9 then
		event.MapJump(-1, "s34")
		if vm.wait() then
			return skip(9)
		end
		return
	end
	event.MapJump(-1, "i02h01")
	if vm.wait() then
		return skip(10)
	end
end

--- Helper function.
local function helper_1a41c()
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
		if at <= 2 then
			if at <= 1 then
				var1 = 86
				var1 = 64
			end
			return
		end
		if at <= 3 then
			helper_650bfa16(0)
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
		var1 = 86
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "dungeon/chara/c02a_miss.gltf", "info", 0)
		var1 = 64
	end
	if active_chr_no == 2 or active_chr_no == 3 then
		if vm.wait() then
			return skip(2)
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
	helper_650bfa16(0)
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsSetMotion(0, "だめだめ", 6)
	event.ObjsNextMotion(0, "立ち", 4)
	event.ObjsRotDelay(0, var1)
	event.ObjsRotation(0, rot_x, rot_y, rot_z, 6)
	helper_650bfa16(0)
	if vm.skipping() then
		return skip(4)
	end
	if active_chr_no == 0 or active_chr_no == 1 then
		event.DelExtMotion(0)
	end
	event.Finish()
end

--- Helper function.
local function helper_1ab68()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 25 then
			if at <= 1 then
				helper_b8bc5976(6000260, 90)
			end
			if at <= 2 then
				helper_650bfa16(0)
			end
			if at <= 3 then
				helper_650bfa16(1)
			end
			if at <= 4 then
				helper_076280e8()
			end
			if at <= 5 then
				helper_650bfa16(0)
			end
			if at <= 6 then
				helper_650bfa16(1)
			end
			if at <= 7 then
				helper_650bfa16(2)
			end
			if at <= 8 then
				helper_1d96573f(6000270)
			end
			if at <= 9 then
				helper_650bfa16(1)
			end
			if at <= 10 then
				helper_8a56995e(1)
			end
			if at <= 11 then
				helper_ff0edc1d(50)
			end
			if at <= 12 then
				helper_e304888c(0, -1, 8, 0, 0)
				helper_57cb224f(0)
			end
			if at <= 13 then
				helper_38448da1(0)
				helper_650bfa16(1)
			end
			if at <= 14 then
				helper_ac1aeb7a(6000290, -1)
			end
			if at <= 15 then
				helper_650bfa16(2)
			end
			if at <= 16 then
				helper_1d96573f(6000300)
			end
			if at <= 17 then
				helper_650bfa16(1)
			end
			if at <= 18 then
				helper_1d96573f(6000310)
			end
			if at <= 19 then
				helper_650bfa16(0)
			end
			if at <= 20 then
				helper_650bfa16(1)
			end
			if at <= 21 then
				helper_1d96573f(6000320)
			end
			if at <= 22 then
				helper_650bfa16(2)
			end
			if at <= 23 then
				helper_650bfa16(2)
			end
			if at <= 24 then
				helper_ff0edc1d(30)
			end
			if vm.skip_end() then
				return skip(26)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SndSeStop(var0, 5)
		event.StopBgm(0)
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
		event.LoadMes(0, -1)
	end
	event.SetFlag(600, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.LoadSound(4524)
	var0 = event.SndLoadSound(4524) or var0
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
	event.LoadChara(5, "e600_osmond.gltf", "info", 34)
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
		event.LoadMotion(5, "event/e600/e600/e600_mints.gltf", "info", 32)
		event.EohSyncChara(0, 32)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	else
		event.LoadChara(5, "chara/c02_base.gltf", "info", 32)
		event.LoadEquip(5, 1, 4, "info", 32)
		event.LoadEquip(5, 1, 3, "info", 32)
		event.LoadEquip(5, 1, 2, "info", 32, 33)
		event.LoadMotion(5, "event/e600/e600/e600_monica.gltf", "info", 32)
		event.EohSyncChara(1, 32)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.CharaActive(32)
	event.CharaActive(33)
	event.EohSyncObj(3, "p02_s3701-0")
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.EohSyncObj(4, "p06_s3701-0")
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.EohSyncObj(5, "p02_s3701-1")
	event.ObjsInit(5)
	event.ObjsSyncObj(5, 5)
	event.EohSyncObj(6, "p06_s3701-1")
	event.ObjsInit(6)
	event.ObjsSyncObj(6, 6)
	event.EohSetPos(0, -10.0, 0.4, 20.0)
	event.EohSetRot(0, 0.0, 0.0, 0.0)
	event.EohSetFootSoundId(0, 23)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "うれし顔")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	event.EohSetSoundId(0, var0)
	event.EohSetPos(1, 10.0, 0.4, 0.0)
	event.EohSetRot(1, 0.0, 0.0, 0.0)
	event.EohSetFootSoundId(1, 23)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "不満顔")
	event.EohSetTexAnim(1, 1, "不満目パチ")
	event.EohSetPos(2, 0.0, 6.0, 166.5)
	event.EohSetRot(2, 0.0, 0.0, 0.0)
	event.EohSetMotion(2, "カチャカチャ", 4)
	event.EohSetRot(3, 0.0, 0.9, 0.0)
	event.EohSetRot(4, 0.0, 0.9, 0.0)
	event.EohSetRot(5, 0.0, -0.9, 0.0)
	event.EohSetRot(6, 0.0, -0.9, 0.0)
	event.InitDramaScene()
	var2 = vm.f32(vm.f32(vm.sin(vm.f32(0.9)) * 10.0) + vm.f32(-39.016))
	var3 = vm.f32(0.4)
	var4 = vm.f32(vm.f32(vm.cos(vm.f32(0.9)) * 10.0) + vm.f32(140.882))
	event.ObjsMove(0, -10.0, 0.4, 120.0, 120, 1)
	event.ObjsMove(0, var2, var3, var4, 40, 1)
	event.ObjsRotDelay(0, 116)
	event.ObjsRotation(0, 0.0, -0.72, 0.0, 10)
	event.ObjsRotDelay(0, 26)
	event.ObjsRotation(0, 0.0, 0.9, 0.0, 10)
	event.ObjsSetMotion(0, "キョロキョロ歩き", 4)
	event.ObjsMotionDelay(0, 160)
	event.ObjsSetMotion(0, "座る", 2)
	event.ObjsNextMotion(0, "座るL", 4)
	event.ObjsPosDelay(0, 10)
	event.ObjsMove(0, -39.016, 0.4, 140.882, 10, 1)
	event.ObjsSeDelay(0, 180)
	event.ObjsSePlay(0, var0, 6)
	var5 = vm.f32(vm.f32(vm.sin(vm.f32(-0.9)) * 4.0) + vm.f32(39.016))
	var6 = vm.f32(0.4)
	var7 = vm.f32(vm.f32(vm.cos(vm.f32(-0.9)) * 4.0) + vm.f32(140.882))
	event.ObjsMove(1, 10.0, 0.4, 120.0, 140, 1)
	event.ObjsMove(1, var5, var6, var7, 40, 1)
	event.ObjsRotDelay(1, 136)
	event.ObjsRotation(1, 0.0, 0.72, 0.0, 10)
	event.ObjsRotDelay(1, 26)
	event.ObjsRotation(1, 0.0, -0.9, 0.0, 10)
	event.ObjsSetMotion(1, "歩き", 4)
	event.ObjsMotionDelay(1, 176)
	event.ObjsSetMotion(1, "立ち")
	event.ObjsMotionDelay(1, 4)
	event.ObjsSetMotion(1, "すわり", 2)
	event.ObjsNextMotion(1, "すわりL", 4)
	event.ObjsPosDelay(1, 10)
	event.ObjsMove(1, 39.016, 0.4, 140.882, 10, 1)
	event.ObjsSeDelay(1, 200)
	event.ObjsSePlay(1, var0, 6)
	event.SndSePlay(var0, 5)
	event.CmrsInit()
	event.CmrsSetPos(33.53, 60.0, 94.399994)
	event.CmrsSetRef(13.04, 24.91, 34.309998)
	event.CmrsMove2(33.53, 60.0, 224.4, 13.04, 24.91, 164.31, 140, 2, 1.0)
	event.SetFadeIn(30)
	event.SetPakuAnim(0, "わらい口パク")
	helper_b8bc5976(6000250, 60)
	if vm.skipping() then
		return skip(1)
	end
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "不満顔")
	event.EohSetTexAnim(1, 1, "不満目～ひき目")
	event.SetPakuAnim(1, "通常口パク")
	helper_b8bc5976(6000260, 90)
	if vm.skipping() then
		return skip(2)
	end
	helper_650bfa16(0)
	if vm.skipping() then
		return skip(3)
	end
	event.SndSePlay(var0, 7)
	event.ObjsRotation2(0, 0.0, -0.7, 0.0, 16, 0, 1.0)
	event.ObjsRotation2(4, 0.0, -0.7, 0.0, 16, 0, 1.0)
	helper_650bfa16(1)
	if vm.skipping() then
		return skip(4)
	end
	event.SndSePlay(var0, 7)
	event.ObjsRotation2(1, 0.0, 0.7, 0.0, 16, 0, 1.0)
	event.ObjsRotation2(6, 0.0, 0.7, 0.0, 16, 0, 1.0)
	helper_076280e8()
	if vm.skipping() then
		return skip(5)
	end
	helper_650bfa16(0)
	if vm.skipping() then
		return skip(6)
	end
	helper_650bfa16(1)
	if vm.skipping() then
		return skip(7)
	end
	event.SndSeStop(var0, 5)
	event.SndSePlay(var0, 8)
	event.ObjsMotionWait(2)
	event.ObjsSetMotion(2, "座り２", 4)
	helper_650bfa16(2)
	if vm.skipping() then
		return skip(8)
	end
	helper_1d96573f(6000270)
	if vm.skipping() then
		return skip(9)
	end
	event.SndSePlay(var0, 9)
	event.ObjsRotation2(1, 0.0, -0.5, 0.0, 16, 0, 1.0)
	event.ObjsRotation2(6, 0.0, -0.5, 0.0, 16, 0, 1.0)
	helper_650bfa16(1)
	if vm.skipping() then
		return skip(10)
	end
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "不満顔")
	event.EohSetTexAnim(1, 1, "ひき目～通常目")
	event.ObjsSetMotion(1, "すわり会話", 2)
	event.ObjsNextMotion(1, "すわりL", 4)
	event.SetPakuAnim(1, "通常口パク", "口とじ～間とじ")
	event.StreamOpen3(1, 6000280)
	helper_8a56995e(1)
	if vm.skipping() then
		return skip(11)
	end
	event.StreamPlay(1)
	helper_ff0edc1d(50)
	if vm.skipping() then
		return skip(12)
	end
	event.MesMake_2(0, 6000280)
	helper_e304888c(0, -1, 8, 0, 0)
	helper_57cb224f(0)
	if vm.skipping() then
		return skip(13)
	end
	helper_38448da1(0)
	event.StreamClose(1)
	helper_650bfa16(1)
	if vm.skipping() then
		return skip(14)
	end
	event.SndSePlay(var0, 10)
	event.ObjsSetMotion(2, "振り向く（座り）", 6, 0.6)
	event.ObjsNextMotion(2, "振り向くループ", 4)
	helper_ac1aeb7a(6000290, -1)
	if vm.skipping() then
		return skip(15)
	end
	helper_650bfa16(2)
	if vm.skipping() then
		return skip(16)
	end
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "不満顔")
	event.EohSetTexAnim(1, 1, "通常目～あいそ目")
	event.ObjsSetMotion(1, "はは、いいです", 2)
	event.ObjsNextMotion(1, "すわりL", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_1d96573f(6000300)
	if vm.skipping() then
		return skip(17)
	end
	helper_650bfa16(1)
	if vm.skipping() then
		return skip(18)
	end
	event.CmrsSetPos(-56.79, 19.84, 145.38)
	event.CmrsSetRef(-39.26, 20.59, 138.61)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "デフォルト顔")
	event.EohSetTexAnim(0, 1, "まばたき目パチ")
	event.ObjsSetMotion(2, "座り２", 4)
	event.ObjsSetMotion(0, "行こう！", 4)
	event.ObjsRotation2(1, 0.0, 0.7, 0.0, 16, 0, 1.0)
	event.ObjsRotation2(6, 0.0, 0.7, 0.0, 16, 0, 1.0)
	event.SetPakuAnim(0, "わらい口パク")
	helper_1d96573f(6000310)
	if vm.skipping() then
		return skip(19)
	end
	helper_650bfa16(0)
	if vm.skipping() then
		return skip(20)
	end
	helper_650bfa16(1)
	if vm.skipping() then
		return skip(21)
	end
	event.CmrsSetPos(0.0, 38.05, 203.65)
	event.CmrsSetRef(-0.0, 19.67, 164.42)
	event.SetProjection(331.9)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "デフォルト顔")
	event.EohSetTexAnim(1, 1, "あきれ目とじ")
	event.EohSetTexAnim(1, 1, "半口")
	event.ObjsSetMotion(0, "いざ", 4)
	event.ObjsSetMotion(2, "いざ", 6)
	event.ObjsNextMotion(2, "いざループ", 4)
	event.ObjsSetMotion(1, "頭抱えL", 4)
	helper_1d96573f(6000320)
	if vm.skipping() then
		return skip(22)
	end
	helper_650bfa16(2)
	if vm.skipping() then
		return skip(23)
	end
	event.ObjsMotionWait(2)
	event.ObjsSetMotion(2, "カチッ", 6)
	event.ObjsNextMotion(2, "カチッループ", 4)
	event.ObjsSeDelay(2, 8)
	event.ObjsSePlay(2, var0, 12)
	event.ObjsSeDelay(2, 10)
	event.ObjsSePlay(2, var0, 13)
	helper_650bfa16(2)
	if vm.skipping() then
		return skip(24)
	end
	event.SndSePlay(var0, 14)
	event.FadeOutBgm(30)
	event.SetFadeOut(30)
	helper_ff0edc1d(30)
	if vm.skipping() then
		return skip(25)
	end
	return part2()
end

--- Helper function.
local function helper_1e454()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 5 then
			if at <= 1 then
				helper_b8bc5976(6000340, 110)
			end
			if at <= 2 then
				helper_b8bc5976(6000350, 110)
			end
			if at <= 3 then
				helper_ff0edc1d(40)
			end
			if at <= 4 then
				helper_ff0edc1d(30)
			end
			if vm.skip_end() then
				return skip(6)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SndSeStop(var0, 0)
		event.ScrEffStopRaster(0.0, 0.0, 0.0, 0)
		event.CharaActive(0)
		event.CharaActive(32)
		event.CharaActive(33)
		event.SetStatus(1, 0, 256, 0)
		event.EohSetSoundId(0, -1)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.DelExtMotion(0)
		event.DeleteChara(32)
		event.DeleteChara(33)
		event.DeleteChara(34)
		event.LoadMes(0, -1)
	end
	event.SetFlag(600, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.LoadSound(4526)
	var0 = event.SndLoadSound(4526) or var0
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
	event.LoadChara(5, "e600_osmond.gltf", "info", 34)
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
		event.LoadMotion(5, "event/e600/e600/e600_mints.gltf", "info", 32)
		event.EohSyncChara(0, 32)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	else
		event.LoadChara(5, "chara/c02_base.gltf", "info", 32)
		event.LoadEquip(5, 1, 4, "info", 32)
		event.LoadEquip(5, 1, 3, "info", 32)
		event.LoadEquip(5, 1, 2, "info", 32, 33)
		event.LoadMotion(5, "event/e600/e600/e600_monica.gltf", "info", 32)
		event.EohSyncChara(1, 32)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.CharaActive(32)
	event.CharaActive(33)
	event.EohSyncObj(7, "p05_s3701")
	event.EohSetPos(0, -39.016, 1.25, 140.882)
	event.EohSetRot(0, 0.0, -0.7, 0.0)
	event.EohSetMotion(0, "G", 4)
	event.EohSetFootSoundId(0, 23)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "G顔")
	event.EohSetPos(1, 39.016, 1.7, 140.882)
	event.EohSetRot(1, 0.0, 0.7, 0.0)
	event.EohSetMotion(1, "G", 4)
	event.EohSetFootSoundId(1, 23)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "G顔")
	event.EohSetPos(2, 0.0, 6.0, 166.5)
	event.EohSetRot(2, 0.0, 0.0, 0.0)
	event.EohSetMotion(2, "Ｇ", 4)
	event.EohSetShow(7, 0)
	event.CmrsInit()
	event.CmrsSetPos(35.19, 14.51, 178.25)
	event.CmrsSetRef(38.15, 14.27, 141.92)
	event.CmrsMove(39.29, 13.43, 167.84, 35.5, 17.91, 140.49, 110)
	event.CmrsQuake(0.0, 0.1, 0.0, -1)
	event.SndSePlay(var0, 0)
	event.SetFadeIn(30)
	helper_b8bc5976(6000330, 112)
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsSetPos(-3.0, 25.26, 187.91)
	event.CmrsSetRef(-3.0, 20.4, 163.23)
	event.CmrsMove(3.0, 25.26, 187.91, 3.0, 20.4, 163.23, 110)
	helper_b8bc5976(6000340, 110)
	if vm.skipping() then
		return skip(2)
	end
	event.CmrsSetPos(-30.64, 18.44, 178.96)
	event.CmrsSetRef(-37.03, 14.27, 145.46)
	event.CmrsMove2(-34.26, 15.42, 170.41, -35.4, 17.4, 145.19, 120, 2, 1.0)
	helper_b8bc5976(6000350, 110)
	if vm.skipping() then
		return skip(3)
	end
	event.SndSePlay(var0, 1)
	event.ScrEffInitRaster(0.0, 0.0, 0.15707964)
	event.ScrEffStartRaster(60.0, 0.3926991, -1.0, 60)
	helper_ff0edc1d(40)
	if vm.skipping() then
		return skip(4)
	end
	event.SetFadeOut(30)
	helper_ff0edc1d(30)
	if vm.skipping() then
		return skip(5)
	end
	return part2()
end

--- Helper function.
local function helper_1fc94()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 22 then
			if at <= 1 then
				helper_650bfa16(3)
			end
			if at <= 2 then
				helper_650bfa16(1)
			end
			if at <= 3 then
				helper_650bfa16(3)
			end
			if at <= 4 then
				helper_650bfa16(1)
			end
			if at <= 5 then
				helper_650bfa16(1)
			end
			if at <= 6 then
				helper_ff0edc1d(30)
			end
			if at <= 7 then
				helper_ff0edc1d(60)
			end
			if at <= 8 then
				helper_650bfa16(3)
			end
			if at <= 9 then
				helper_076280e8()
			end
			if at <= 10 then
				helper_ff0edc1d(60)
			end
			if at <= 11 then
				helper_1d96573f(6480030)
			end
			if at <= 12 then
				helper_1d96573f(6480040)
			end
			if at <= 13 then
				helper_b8bc5976(6480050, 180)
			end
			if at <= 14 then
				helper_1d96573f(6480060)
			end
			if at <= 15 then
				helper_076280e8()
			end
			if at <= 16 then
				helper_b8bc5976(6480070, 90)
			end
			if at <= 17 then
				helper_1d96573f(6480075)
			end
			if at <= 18 then
				helper_1d96573f(6480080)
			end
			if at <= 19 then
				helper_1d96573f(6480090)
			end
			if at <= 20 then
				helper_ff0edc1d(60)
			end
			if at <= 21 then
				helper_ff0edc1d(30)
			end
			if vm.skip_end() then
				return skip(23)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.BgmLoadCancel()
		event.SndSeStop(var0, 4)
		event.SndSeStop(var0, 5)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.EohSetFootSoundId(2, 0)
		event.EohSetFootSoundId(3, 0)
		event.SpriteSetDraw(0, 0)
		event.DelExtMotion(0)
		event.DeleteChara(33)
		event.DeleteChara(34)
		event.DeleteChara(35)
		event.DeleteChara(36)
		event.LoadMes(0, -1)
		event.CharaActive(0)
		event.SetCharaPos(0, -2.21, 0.0, 25.73)
		event.SetCharaRot(0, 0.0, 0.03, 0.0)
		event.SetMotion(0, "立ち", 4)
		event.CharaNormalDrive(0)
		event.CharaResetDa(0)
		event.ResetCamera(1, 3.1415927, 10.0)
		event.SetFadeIn(30)
	end
	event.SetFlag(648, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.EyeViewDrawOnOff(1)
	event.StopBgm(0)
	helper_ff0edc1d(4)
	if vm.skipping() then
		return skip(1)
	end
	event.LoadBgm(22)
	event.PlayBgm(0)
	event.LoadSound(6234)
	var0 = event.SndLoadSound(6234) or var0
	event.SndSePlay(var0, 0)
	event.SndSeStop(var0, 0)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.ChangeDir("event/e600/e648/")
	event.LoadMes(0, 5, "e648.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e648_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e648_monica.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.LoadChara(5, "e648_eina.gltf", "info", 35)
	event.CharaActive(35)
	event.EohSyncChara(2, 35)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.LoadChara(5, "e648_osmond.gltf", "info", 36)
	event.CharaActive(36)
	event.EohSyncChara(3, 36)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.EohSyncObj(4, "p06_s3701-0")
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.EohSyncObj(5, "p06_s3701-1")
	event.ObjsInit(5)
	event.ObjsSyncObj(5, 5)
	event.EohSyncObj(6, "p07_s3701")
	event.ObjsInit(6)
	event.ObjsSyncObj(6, 6)
	event.ChangeDir("")
	if active_chr_no == 1 then
		event.LoadChara(5, "chara/c01_base.gltf", "info", 33)
		event.LoadEquip(5, 0, 4, "info", 33)
		event.LoadEquip(5, 0, 3, "info", 33)
		event.LoadEquip(5, 0, 2, "info", 33, 34)
		event.LoadMotion(5, "event/e600/e648/e648_mints.gltf", "info", 33)
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
		event.LoadMotion(5, "event/e600/e648/e648_monica.gltf", "info", 33)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 33)
		event.EohSyncChara(1, 33)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 0)
	end
	event.CharaActive(33)
	event.CharaActive(34)
	event.EohSetPos(0, 3.38, -9.6, -127.86)
	event.EohSetRot(0, 0.0, 0.03, 0.0)
	event.EohSetMotion(0, "立ち", 4)
	event.EohSetFootSoundId(0, 23)
	event.EohSetPos(1, 19.72, -9.6, -146.14)
	event.EohSetRot(1, 0.0, -0.81, 0.0)
	event.EohSetMotion(1, "立ち", 4)
	event.EohSetFootSoundId(1, 23)
	event.EohSetPos(3, 0.11, -2.82, -96.44)
	event.EohSetRot(3, 0.0, 0.0, 0.0)
	event.EohSetMotion(3, "立ち", 4)
	event.EohSetFootSoundId(3, 23)
	event.EohSetPos(2, 6.69, -90.34, 352.05)
	event.EohSetRot(2, 0.0, -3.12, 0.0)
	event.EohSetMotion(2, "立ち", 4)
	event.ObjsSetScale(2, 5.0, 5.0, 5.0)
	event.EohSetShow(6, 1)
	event.EohSetRot(4, 0.0, -0.698, 0.0)
	event.EohSetRot(5, 0.0, 0.698, 0.0)
	event.InitDramaScene()
	event.CmrsInit()
	event.CmrsSetPos(-46.32, 72.59, -4.25)
	event.CmrsSetRef(17.61, 1.85, -139.47)
	event.CharaActive(0)
	event.CharaActive(33)
	event.CharaActive(34)
	event.SetFadeIn(30)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "無表情")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "無表情")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.CmrsMove(-21.97, 53.85, 239.94, -0.71, 18.82, 149.47, 240)
	event.ObjsSetMotion(3, "歩き")
	event.ObjsMove(3, -2.2, 0.4, 130.63, 210, 1)
	event.ObjsSetMotion(0, "歩き")
	event.ObjsMove(0, -17.63, 2.56, 106.07, 210, 1)
	event.ObjsSetMotion(1, "歩き")
	event.ObjsMove(1, 2.24, -9.6, -123.75, 40, 1)
	event.ObjsRotation(1, 0.0, 0.03, 0.0, 60)
	event.ObjsMove(1, 8.05, 2.56, 103.09, 200, 1)
	helper_650bfa16(3)
	if vm.skipping() then
		return skip(2)
	end
	event.ObjsMove(3, 17.35, 1.28, 162.87, 60, 1)
	event.ObjsRotation(3, 0.0, 0.6, 0.0, 12)
	event.ObjsMotionDelay(3, 60)
	event.ObjsSetMotion(3, "立ち")
	event.ObjsMove(0, -23.89, 1.28, 151.76, 60, 1)
	event.ObjsRotation(0, 0.0, -0.21, 0.0, 12)
	event.ObjsMotionDelay(0, 60)
	event.ObjsSetMotion(0, "立ち")
	helper_650bfa16(1)
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsMove(1, 48.6, 2.56, 134.01, 60, 1)
	event.ObjsRotation(1, 0.0, 0.39, 0.0, 12)
	event.ObjsMotionDelay(1, 60)
	event.ObjsSetMotion(1, "立ち")
	helper_650bfa16(3)
	if vm.skipping() then
		return skip(4)
	end
	event.ObjsMove(3, 0.45, 6.12, 164.04, 20)
	event.ObjsRotation(3, 0.0, 0.12, 0.0, 12)
	event.ObjsSetMotion(3, "座り２in", 6)
	event.ObjsNextMotion(3, "座り２", 4)
	event.SndSePlay(var0, 2)
	event.ObjsMove(0, -38.0, 1.28, 140.62, 20, 1)
	event.ObjsRotation(0, 0.0, -0.81, 0.0, 12)
	event.ObjsSetMotion(0, "座る", 6)
	event.ObjsNextMotion(0, "座るL", 4)
	helper_650bfa16(1)
	if vm.skipping() then
		return skip(5)
	end
	event.SndSePlay(var0, 3)
	event.ObjsMove(1, 37.97, 1.28, 143.09, 20, 1)
	event.ObjsRotation(1, 0.0, 0.39, 0.0, 12)
	event.ObjsSetMotion(1, "すわる", 6)
	event.ObjsNextMotion(1, "すわるL", 4)
	helper_650bfa16(1)
	if vm.skipping() then
		return skip(6)
	end
	helper_ff0edc1d(30)
	if vm.skipping() then
		return skip(7)
	end
	event.SndSePlay(var0, 4)
	event.ObjsRotation(1, 0.0, 0.0, 0.0, 60)
	event.ObjsRotation(0, 0.0, 0.0, 0.0, 60)
	event.ObjsRotation(4, 0.0, 0.0, 0.0, 60)
	event.ObjsRotation(5, 0.0, 0.0, 0.0, 60)
	helper_ff0edc1d(60)
	if vm.skipping() then
		return skip(8)
	end
	event.SndSeStop(var0, 4)
	event.CmrsSetPos(-1.39, 81.74, 51.11)
	event.CmrsSetRef(-0.5, 5.15, 148.47)
	event.ObjsSetMotion(1, "モニタ見", 4)
	event.ObjsSetMotion(0, "モニタ見座り", 4)
	event.SndSePlay(var0, 5)
	event.ObjsSetMotion(3, "座り", 6)
	event.ObjsNextMotion(3, "いじる", 6)
	event.ObjsNextMotion(3, "座り", 4)
	event.CmrsMove(-0.45, 41.97, 94.94, 0.95, 44.66, 154.44, 120)
	helper_650bfa16(3)
	if vm.skipping() then
		return skip(9)
	end
	event.SndSePlay(var0, 6)
	helper_076280e8()
	if vm.skipping() then
		return skip(10)
	end
	helper_ff0edc1d(60)
	if vm.skipping() then
		return skip(11)
	end
	event.SndSeStop(var0, 5)
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "目パチ")
	event.SetPakuAnim(2, "口パク")
	helper_1d96573f(6480030)
	if vm.skipping() then
		return skip(12)
	end
	event.SetPakuAnim(2, "口パク")
	helper_1d96573f(6480040)
	if vm.skipping() then
		return skip(13)
	end
	event.CmrsSetPos(-8.29, 48.08, 237.9)
	event.CmrsSetRef(-26.87, 28.39, 169.28)
	event.CmrsMove(5.54, 48.08, 239.48, 27.19, 24.6, 164.47, 270)
	helper_b8bc5976(6480050, 180)
	if vm.skipping() then
		return skip(14)
	end
	helper_1d96573f(6480060)
	if vm.skipping() then
		return skip(15)
	end
	helper_076280e8()
	if vm.skipping() then
		return skip(16)
	end
	event.CmrsSetPos(-3.52, 33.93, 32.57)
	event.CmrsSetRef(-1.23, 25.71, 110.05)
	event.ObjsSetMotion(3, "座り２", 4)
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "目パチ")
	event.SetPakuAnim(2, "わらい口パク")
	helper_b8bc5976(6480070, 90)
	if vm.skipping() then
		return skip(17)
	end
	event.SetPakuAnim(2, "わらい口パク")
	helper_1d96573f(6480075)
	if vm.skipping() then
		return skip(18)
	end
	event.CmrsSetPos(-32.92, 60.21, 232.25)
	event.CmrsSetRef(-8.31, 19.18, 160.67)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "デフォルト顔")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.SndSePlay(var0, 7)
	event.ObjsSetMotion(0, "モニタ見うなづき", 6)
	event.ObjsNextMotion(0, "モニタ見座り", 4)
	event.SetPakuAnim(0, "\tわらい口パク")
	helper_1d96573f(6480080)
	if vm.skipping() then
		return skip(19)
	end
	event.SndSePlay(var0, 8)
	event.ObjsSetMotion(1, "モニタうなずき", 6)
	event.ObjsNextMotion(1, "モニタ見", 4)
	event.SetPakuAnim(1, "わらい口パク")
	helper_1d96573f(6480090)
	if vm.skipping() then
		return skip(20)
	end
	event.ObjsSetMotion(3, "うなづく", 6)
	event.ObjsNextMotion(3, "座り２", 4)
	helper_ff0edc1d(60)
	if vm.skipping() then
		return skip(21)
	end
	event.SetFadeOut(30)
	helper_ff0edc1d(30)
	if vm.skipping() then
		return skip(22)
	end
	return part2()
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 100.
script[100] = function()
	event.SetFadeIn(30)
end

--- Program 150.
script[150] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_23514()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 200.
script[200] = function()
	local var0: s32 = 0
	local var1: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var1 = helper_198e4(1)
			helper_ff0edc1d(30)
		end
		if at <= 2 then
			helper_17988()
		end
		if at <= 3 then
			helper_1a41c()
		end
	end
	print("--------------------------event200-------------------------\n")
	helper_25830(vm.f32(-1.5707964))
	if vm.skipping() then
		return skip(1)
	end
	var0 = event.GetSndId(2) or var0
	var1 = helper_198e4(1)
	if var1 ~= 0 then
		event.SetMotion(0, "立ち")
		event.SndSePlay(var0, 94)
		event.SetFadeOut(30)
		helper_ff0edc1d(30)
		if vm.skipping() then
			return skip(2)
		end
		event.SetCnt(15, 1)
		event.StopBgm(0)
		helper_17988()
		if vm.skipping() then
			return skip(3)
		end
	else
		event.SndSePlay(var0, 108)
		helper_1a41c()
		if vm.skipping() then
			return skip(4)
		end
	end
end

--- Program 201.
script[201] = function()
	local var0: s32 = 0
	local var1: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var1 = helper_198e4(0)
			helper_ff0edc1d(30)
		end
		if at <= 2 then
			helper_17988()
		end
		if at <= 3 then
			helper_1a41c()
		end
	end
	print("--------------------------event201-------------------------\n")
	helper_25830(vm.f32(1.5707964))
	if vm.skipping() then
		return skip(1)
	end
	var0 = event.GetSndId(2) or var0
	var1 = helper_198e4(0)
	if var1 ~= 0 then
		event.SetMotion(0, "立ち")
		event.SndSePlay(var0, 94)
		event.SetFadeOut(30)
		helper_ff0edc1d(30)
		if vm.skipping() then
			return skip(2)
		end
		event.SetCnt(15, 0)
		event.StopBgm(0)
		helper_17988()
		if vm.skipping() then
			return skip(3)
		end
	else
		event.SndSePlay(var0, 108)
		helper_1a41c()
		if vm.skipping() then
			return skip(4)
		end
	end
end

--- Program 202.
script[202] = function()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_ff0edc1d(30)
		end
	end
	print("--------------------------event202-------------------------\n")
	helper_25830(vm.f32(3.1415927))
	if vm.skipping() then
		return skip(1)
	end
	event.SetMotion(0, "立ち")
	var0 = event.GetSndId(2) or var0
	event.SndSePlay(var0, 94)
	event.SetFadeOut(30)
	helper_ff0edc1d(30)
	if vm.skipping() then
		return skip(2)
	end
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.SetCnt(0, 1)
	event.SetCharaPos(0, 0.0, -14.0, 235.0)
	event.SetCharaRot(0, 0.0, 3.1415927, 0.0)
	event.StopBgm(0)
	event.MapJump(-1, "s38")
end

--- Program 500.
script[500] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_1ab68()
	if vm.skipping() then
		return skip(1)
	end
	event.BgmLoadCancel()
	event.MapJump(-1, "s59", 500)
	if vm.wait() then
		return skip(2)
	end
end

--- Program 510.
script[510] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_1e454()
	if vm.skipping() then
		return skip(1)
	end
	event.BgmLoadCancel()
	event.MapJump(-1, "s58", 500)
	if vm.wait() then
		return skip(2)
	end
end

--- Program 520.
script[520] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_1fc94()
	if vm.skipping() then
		return skip(1)
	end
	event.MapJump(-1, "s11", 520)
	if vm.wait() then
		return skip(2)
	end
end

--- Program 530.
script[530] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_23514()
	if vm.skipping() then
		return skip(1)
	end
	event.MapJump(-1, "s11", 599)
	if vm.wait() then
		return skip(2)
	end
end

--- Program 16480.
script[16480] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_1fc94()
	if vm.skipping() then
		return skip(1)
	end
	event.MapJump(-1, "s11", 520)
	if vm.wait() then
		return skip(2)
	end
end

return script
