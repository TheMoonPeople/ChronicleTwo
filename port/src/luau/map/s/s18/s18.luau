--!strict
-- map/s/s18/s18.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_025d5797 = require("@lib/event/helper_025d5797")
local helper_29a88422 = require("@lib/event/helper_29a88422")
local helper_31a4c001 = require("@lib/event/helper_31a4c001")
local helper_3a74ecc4 = require("@lib/event/helper_3a74ecc4")
local helper_4be4f575 = require("@lib/event/helper_4be4f575")
local helper_4d0c9edd = require("@lib/event/helper_4d0c9edd")
local helper_585b7236 = require("@lib/event/helper_585b7236")
local helper_6dfa44e2 = require("@lib/event/helper_6dfa44e2")
local helper_71fa1d07 = require("@lib/event/helper_71fa1d07")
local helper_73d6f64a = require("@lib/event/helper_73d6f64a")
local helper_7841320d = require("@lib/event/helper_7841320d")
local helper_9d5ade37 = require("@lib/event/helper_9d5ade37")
local helper_d9c15850 = require("@lib/event/helper_d9c15850")

local global0: s32 = 0
local global1: s32 = 0
local global2: s32 = 0
local global3: s32 = 0

--- Program 99.
local function program_99()
	local flag: s32 = 0
	local flag_2: s32 = 0
	event.StopBgm(0)
	event.LoadSound(3686)
	event.EohSyncObj(30, "p01_s18", "s18_02-a0")
	event.EohSetShow(30, 0)
	flag = event.GetFlag(330) or flag
	flag_2 = event.GetFlag(340) or flag_2
	if flag == 1 and flag_2 == 0 then
		event.FuncPointShow("", "e336", 1)
	end
end

--- Helper function.
local function helper_106f0()
	local active_chr_no: s32 = 0
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
		event.LoadMotion(5, "event/e300/e332/e332_mints.gltf", "info", global2)
		event.EohSyncChara(0, global2)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global2)
		event.LoadChara(5, "chara/c02_base.gltf", "info", global3)
		event.LoadEquip(5, 1, 4, "info", global3)
		event.LoadEquip(5, 1, 3, "info", global3)
		event.LoadEquip(5, 1, 2, "info", global3, 13)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global3)
		event.LoadMotion(5, "event/e300/e332/e332_monica.gltf", "info", global3)
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
		event.LoadEquip(5, 0, 4, "info", global2)
		event.LoadEquip(5, 0, 3, "info", global2)
		event.LoadEquip(5, 0, 2, "info", global2, 13)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", global2)
		event.LoadMotion(5, "event/e300/e332/e332_mints.gltf", "info", global2)
		event.EohSyncChara(0, global2)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global2)
		event.CharaActive(1, 13)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global3)
		event.LoadMotion(5, "event/e300/e332/e332_monica.gltf", "info", global3)
		event.EohSyncChara(1, global3)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global3)
	end
	event.LoadChara(5, "event/d03/p00_26a.gltf", "info", 11)
	event.CharaActive(0, 11)
	event.EohSyncChara(4, 11)
	event.ObjsInit(2, 11)
	event.ObjsSyncObj(2, 4)
	event.EohSetShadow(4, 0)
	event.EohSyncChara(2, 1)
	event.EohSetShow(2, 0)
	event.EohSyncChara(3, 2)
	event.EohSetShow(3, 0)
	event.LoadMes(0, 5, "event/e300/e332/e332.txt")
end

--- Helper function.
local function helper_102ec()
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
	end
	if active_chr_no == 1 then
		event.CharaActive(1, global3)
		event.CharaActive(0, global2)
		event.DelExtMotion(global2)
		event.DelExtMotion(global3)
		event.DeleteChara(global2)
		event.DeleteChara(13)
	end
	event.DeleteChara(11)
	event.EohSyncChara(2, 1)
	event.EohSetShow(2, 1)
	event.EohSyncChara(3, 2)
	event.EohSetShow(3, 1)
	event.SetStatusbarShow(1, 1.0)
	event.Finish()
end

--- Helper function.
local function helper_116a4()
	local var4: s32 = 0
	local flag: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 25 then
			if at <= 1 then
				helper_6dfa44e2(60)
			end
			if at <= 2 then
				helper_71fa1d07()
			end
			if at <= 3 then
				helper_6dfa44e2(60)
			end
			if at <= 4 then
				helper_6dfa44e2(30)
			end
			if at <= 5 then
				helper_d9c15850(1)
			end
			if at <= 6 then
				helper_d9c15850(0)
			end
			if at <= 7 then
				helper_6dfa44e2(60)
			end
			if at <= 8 then
				helper_6dfa44e2(30)
			end
			if at <= 9 then
				helper_4be4f575(3320010)
			end
			if at <= 10 then
				helper_4be4f575(3320020)
			end
			if at <= 11 then
				helper_d9c15850(1)
			end
			if at <= 12 then
				helper_6dfa44e2(20)
			end
			if at <= 13 then
				helper_4be4f575(3320025)
			end
			if at <= 14 then
				helper_71fa1d07()
			end
			if at <= 15 then
				helper_6dfa44e2(30)
			end
			if at <= 16 then
				helper_6dfa44e2(20)
			end
			if at <= 17 then
				helper_6dfa44e2(20)
			end
			if at <= 18 then
				helper_73d6f64a(0, -1, 8, 64, 0)
			end
			if at <= 19 then
				helper_d9c15850(1)
			end
			if at <= 20 then
				helper_73d6f64a(0, -1, 8, 64, 0)
			end
			if at <= 21 then
				helper_d9c15850(1)
			end
			if at <= 22 then
				helper_73d6f64a(0, -1, 8, 460, 0)
			end
			if at <= 23 then
				helper_d9c15850(0)
			end
			if at <= 24 then
				helper_6dfa44e2(30)
			end
			if vm.skip_end() then
				return skip(26)
			end
			return part2()
		end
		helper_102ec()
	end
	function part2()
		event.CancelDramaScene()
		event.SndSeAllStop(4)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		helper_102ec()
	end
	event.SetFlag(332, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.StopBgm(0)
	event.LoadSound(3820)
	var4 = event.SndLoadSound(3820) or var4
	helper_106f0()
	event.InitDramaScene()
	event.EohSetFootSoundId(0, 1)
	event.EohSetFootSoundId(1, 1)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "デフォルト顔")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.CharaActive(1, 11)
	event.CmrsSetPos(2137.92, 789.89, -634.43)
	event.CmrsSetRef(1501.16, 847.03, -450.95)
	event.ObjsSetPos(2, -169.01, 1296.7, 919.52)
	event.ObjsSetRot(2, 0.0, 2.52, 0.0)
	event.ObjsSetPos(0, -1308.19, 201.28, -552.77)
	event.ObjsSetRot(0, 0.0, 1.8, 0.0)
	event.ObjsSetPos(1, -1303.45, 200.12, -532.19)
	event.ObjsSetRot(1, 0.0, 1.92, 0.0)
	event.SetFadeIn(30)
	event.SndSePlay(var4, 0)
	event.SndSePlay(var4, 1)
	event.ObjsSetMotion(2, "肉つかみ飛び", 4)
	event.ObjsMove(2, -127.0, 1099.81, 692.26, 140)
	helper_d9c15850(2)
	if vm.skipping() then
		return skip(1)
	end
	event.CharaActive(1, global2)
	event.CharaActive(1, global3)
	event.SndSePlay(var4, 2)
	event.SndSePlay(var4, 3)
	event.ObjsSetPos(2, -1272.85, 225.03, -556.23)
	event.ObjsSetRot(2, 0.0, 1.92, 0.0)
	event.ObjsMove(2, -1272.85, 267.03, -556.23, 60, 0)
	event.ObjsSetMotion(0, "着地", 6, -1.0, 1)
	event.ObjsNextMotion(0, "立ち", 4)
	event.ObjsSetMotion(1, "着地", 6, -1.0, 1)
	event.ObjsNextMotion(1, "立ち", 4)
	event.CmrsSetPos(-1178.39, 236.2, -586.84)
	event.CmrsSetRef(-1272.85, 237.51, -556.23)
	helper_6dfa44e2(60)
	if vm.skipping() then
		return skip(2)
	end
	event.CmrsSetPos(-1191.17, 236.2, -746.66)
	event.CmrsSetRef(-1103.65, 237.51, -660.25)
	event.CmrsMoveAhd2(-1.31, -1.31, 104.9, 160, 2, 0.2)
	helper_71fa1d07()
	if vm.skipping() then
		return skip(3)
	end
	helper_6dfa44e2(60)
	if vm.skipping() then
		return skip(4)
	end
	event.SetFadeOut(30)
	helper_6dfa44e2(30)
	if vm.skipping() then
		return skip(5)
	end
	event.CmrsSetPos(-90.5, 14.06, -606.53)
	event.CmrsSetRef(-64.24, 89.53, -950.56)
	event.ObjsSetPos(1, -238.89, 0.0, -900.0)
	event.ObjsSetRot(1, 0.0, 1.44, 0.0)
	event.ObjsSetPos(0, -268.89, 0.0, -900.0)
	event.ObjsSetRot(0, 0.0, 1.44, 0.0)
	event.ObjsSetMotion(1, "歩き", 4, -1.0, 1)
	event.ObjsSetMotion(0, "歩き", 4, -1.0, 1)
	event.SetFadeIn(30)
	event.ObjsMove(0, -76.82, 0.0, -888.62, 190, 1)
	event.ObjsRotDelay(0, 180)
	event.ObjsRotation(0, 0.0, 3.1, 0.0, 10)
	event.ObjsMove(1, -57.31, 0.0, -886.09, 180, 1)
	event.ObjsRotDelay(1, 170)
	event.ObjsRotation(1, 0.0, -3.04, 0.0, 10)
	helper_d9c15850(1)
	if vm.skipping() then
		return skip(6)
	end
	event.ObjsSetMotion(1, "立ち")
	helper_d9c15850(0)
	if vm.skipping() then
		return skip(7)
	end
	event.ObjsSetMotion(0, "立ち")
	helper_6dfa44e2(60)
	if vm.skipping() then
		return skip(8)
	end
	event.CmrsSetPos(-84.25, 9.79, -925.95)
	event.CmrsSetRef(-68.29, 20.6, -887.75)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おどろき顔")
	event.ObjsTexAnime(0, 1, "おどろき目パチ")
	helper_6dfa44e2(30)
	if vm.skipping() then
		return skip(9)
	end
	event.SetPakuAnim(0, "通常口パク")
	helper_4be4f575(3320010)
	if vm.skipping() then
		return skip(10)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(1, "会話", 6)
	event.ObjsNextMotion(1, "立ち", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_4be4f575(3320020)
	if vm.skipping() then
		return skip(11)
	end
	helper_d9c15850(1)
	if vm.skipping() then
		return skip(12)
	end
	helper_6dfa44e2(20)
	if vm.skipping() then
		return skip(13)
	end
	event.CmrsSetPos(-272.67, 64.11, 813.12)
	event.CmrsSetRef(-83.25, 1200.0, -897.58)
	event.SndSePlay(var4, 4)
	event.CmrsMove2(-272.67, 67.63, 813.15, -83.25, 364.11, -897.58, 200, 0, 0.2)
	event.ObjsSetMotion(1, "会話", 6)
	event.ObjsNextMotion(1, "立ち", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_4be4f575(3320025)
	if vm.skipping() then
		return skip(14)
	end
	event.ResetPakuAnim()
	helper_71fa1d07()
	if vm.skipping() then
		return skip(15)
	end
	helper_6dfa44e2(30)
	if vm.skipping() then
		return skip(16)
	end
	flag = event.GetFlag(330) or flag
	if flag == 0 then
		event.SetFadeOut(20)
		helper_6dfa44e2(20)
		if vm.skipping() then
			return skip(17)
		end
		event.CmrsSetPos(-85.63, 12.99, -898.44)
		event.CmrsSetRef(-67.07, 18.64, -859.32)
		event.EohSetPos(0, -76.27, 0.0, -854.62)
		event.EohSetRot(0, 0.0, 2.76, 0.0)
		event.EohSetTexAnim(0, 0)
		event.EohSetTexAnim(0, 1, "デフォルト顔")
		event.EohSetTexAnim(0, 1, "通常目パチ")
		event.EohSetPos(1, -55.61, 0.0, -856.61)
		event.EohSetRot(1, 0.0, 3.0, 0.0)
		event.EohSetTexAnim(1, 0)
		event.EohSetTexAnim(1, 1, "デフォルト顔")
		event.EohSetTexAnim(1, 1, "通常目パチ")
		event.SetFadeIn(20)
		helper_6dfa44e2(20)
		if vm.skipping() then
			return skip(18)
		end
		event.ObjsTexaDelay(0, 12)
		event.ObjsTexAnime(0, 1, "右向き目")
		event.SetMesWindowMode(0, 1)
		event.SetMesShippo(0, 1)
		event.ObjsSetMotion(1, "左向く", 6)
		event.ObjsNextMotion(1, "左向くL", 4)
		event.MesMake_2(0, "リンが心配ね。\nまずは、リンの病気のことを考えないと・・・")
		event.SetPakuAnim(1, "通常口パク")
		helper_73d6f64a(0, -1, 8, 64, 0)
		if vm.skipping() then
			return skip(19)
		end
		helper_d9c15850(1)
		if vm.skipping() then
			return skip(20)
		end
		event.ObjsSetMotion(1, "左向く会話", 6)
		event.ObjsNextMotion(1, "左向くL", 4)
		event.MesMake_2(
			0,
			"とにかく今は、これ以上先に行くのは、\nやめておいた方がいいわ。"
		)
		event.SetPakuAnim(1, "通常口パク")
		helper_73d6f64a(0, -1, 8, 64, 0)
		if vm.skipping() then
			return skip(21)
		end
		helper_d9c15850(1)
		if vm.skipping() then
			return skip(22)
		end
		event.ObjsSetMotion(0, "うなづく", 6)
		event.ObjsNextMotion(0, "立ち", 4)
		event.MesMake_2(0, "うん、そうだね。")
		event.SetPakuAnim(0, "通常口パク")
		helper_73d6f64a(0, -1, 8, 460, 0)
		if vm.skipping() then
			return skip(23)
		end
		helper_d9c15850(0)
		if vm.skipping() then
			return skip(24)
		end
	end
	event.SetFadeOut(30)
	helper_6dfa44e2(30)
	if vm.skipping() then
		return skip(25)
	end
	return part2()
end

--- Helper function.
local function helper_18ac(arg0: f32, arg1: f32, arg2: f32, arg3: f32)
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
local function helper_23ba0(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.FuncPointShow("", "rev_floor", arg0)
	if arg0 == 1 then
		event.AssignStack(4)
		event.ClearStack(4)
		event.LoadChara(4, "event/d03/p00_26a.gltf", "info", 8)
		event.CharaActive(1, 8)
		event.SetCharaPos(8, -1594.13, 282.8, -492.73)
		event.SetCharaRot(8, 0.0, 0.89, 0.0)
		event.SetMotion(8, "立ち", 4)
		event.SetStatus(1, 8, 8)
	else
		event.DeleteChara(8)
	end
end

--- Helper function.
local function helper_217cc()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_6dfa44e2(60)
			end
			if at <= 2 then
				helper_6dfa44e2(20)
			end
			if vm.skip_end() then
				return skip(4)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.CharaActive(1, 0)
		event.EohSetFootSoundId(0, 0)
		event.DelExtMotion(0)
		event.DeleteChara(8)
		event.LoadMes(0, -1)
		event.Finish()
	end
	event.Initialize()
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.SetStatusbarShow(0, 1.0)
	var0 = event.SndLoadSound(3820) or var0
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		event.LoadMotion(5, "event/e300/e308/e308_mints.gltf", "info", 0)
	else
		event.LoadMotion(5, "event/e300/e308/e308_monica.gltf", "info", 0)
	end
	event.CharaActive(0, 0)
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.LoadChara(5, "event/d03/p00_26a.gltf", "info", 8)
	event.CharaActive(1, 8)
	event.EohSyncChara(1, 8)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.EohSetShadow(1, 0)
	event.EohSetPos(0, -1306.0, 200.39, -546.0)
	event.EohSetRot(0, 0.0, 1.88, 0.0)
	event.EohSetPos(1, -169.01, 1296.7, 919.52)
	event.EohSetRot(1, 0.0, 2.52, 0.0)
	event.EohSetMotion(1, "肉つかみ飛び", 4)
	event.CmrsInit()
	event.CmrsSetPos(2137.92, 789.89, -634.43)
	event.CmrsSetRef(1501.16, 847.03, -450.95)
	event.ObjsMove(1, -127.0, 1099.81, 692.26, 90)
	event.SndSePlay(var0, 0)
	event.SndSePlay(var0, 1)
	event.SetFadeIn(30)
	helper_d9c15850(1)
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsSetPos(-1182.17, 240.83, -585.56)
	event.CmrsSetRef(-1306.0, 230.83, -546.0)
	event.CharaActive(1, 0)
	event.SndSePlay(var0, 2)
	event.SndSePlay(var0, 3)
	event.ObjsSetPos(1, -1272.85, 225.03, -556.23)
	event.ObjsSetRot(1, 0.0, 1.92, 0.0)
	event.ObjsMove(1, -1272.85, 267.03, -556.23, 60)
	event.ObjsSetMotion(0, "着地", 6, -1.0, 1)
	event.ObjsNextMotion(0, "立ち", 4)
	helper_6dfa44e2(60)
	if vm.skipping() then
		return skip(2)
	end
	event.SetFadeOut(20)
	helper_6dfa44e2(20)
	if vm.skipping() then
		return skip(3)
	end
	return part2()
end

--- Helper function.
local function helper_14194()
	local active_chr_no: s32 = 0
	local block: s32 = 0
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
		event.LoadMotion(5, "event/e300/e336/e336_mints.gltf", "info", global0)
		event.EohSyncChara(0, global0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global0)
		event.LoadChara(5, "chara/c02_base.gltf", "info", global1)
		event.LoadEquip(5, 1, 1, "info", global1, 14)
		event.LoadEquip(5, 1, 0, "info", global1, 15)
		event.LoadEquip(5, 1, 4, "info", global1)
		event.LoadEquip(5, 1, 3, "info", global1)
		event.LoadEquip(5, 1, 2, "info", global1, 13)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.LoadMotion(5, "event/e300/e336/e336_monica.gltf", "info", global1)
		event.EohSyncChara(1, global1)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global1)
		event.CharaActive(1, 13)
		event.CharaActive(0, 14)
		event.CharaActive(0, 15)
	end
	if active_chr_no == 1 then
		global0 = 8
		global1 = 0
		event.LoadChara(5, "chara/c01_base.gltf", "info", global0)
		event.LoadEquip(5, 0, 1, "info", global0, 14)
		event.LoadEquip(5, 0, 0, "info", global0, 15)
		event.LoadEquip(5, 0, 4, "info", global0)
		event.LoadEquip(5, 0, 3, "info", global0)
		event.LoadEquip(5, 0, 2, "info", global0, 13)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.LoadMotion(5, "event/e300/e336/e336_mints.gltf", "info", global0)
		event.EohSyncChara(0, global0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global0)
		event.CharaActive(1, 13)
		event.CharaActive(0, 14)
		event.CharaActive(0, 15)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.LoadMotion(5, "event/e300/e336/e336_monica.gltf", "info", global1)
		event.EohSyncChara(1, global1)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global1)
	end
	event.EohSyncChara(2, 1)
	event.EohSetShow(2, 0)
	event.EohSyncChara(3, 2)
	event.EohSetShow(3, 0)
	event.LoadChara(5, "event/e300/e336/e336_lin.gltf", "info", 9)
	event.CharaActive(0, 9)
	event.EohSyncChara(4, 9)
	event.ObjsInit(2, 9)
	event.ObjsSyncObj(2, 4)
	block = event.LoadImg_4(5, "textures/event/e300/e336/e336.json", 0) or block
	event.SpriteInit(0)
	event.SpriteSetType(0, 0)
	event.SpriteSetTexture(0, "e33601", block)
	event.SpriteSetColor(0, 128, 128, 128, 0)
	event.SpriteSetUvsize(0, 0, 0, 512, 416)
	event.SpriteSetPutsize(0, 512, 416)
	event.SpriteSetPos(0, 256, 208)
	event.SpriteSetDraw(0, 0)
	event.EohSyncSprite(10, 0)
	event.ObjsInit(10)
	event.ObjsSyncObj(10, 10)
	event.SpriteInit(1)
	event.SpriteSetType(1, 0)
	event.SpriteSetTexture(1, "e33602", block)
	event.SpriteSetColor(1, 128, 128, 128, 0)
	event.SpriteSetUvsize(1, 0, 0, 512, 416)
	event.SpriteSetPutsize(1, 512, 416)
	event.SpriteSetPos(1, 256, 208)
	event.SpriteSetDraw(1, 0)
	event.EohSyncSprite(11, 1)
	event.ObjsInit(11)
	event.ObjsSyncObj(11, 11)
	event.SpriteInit(2)
	event.SpriteSetType(2, 0)
	event.SpriteSetTexture(2, "e33603", block)
	event.SpriteSetColor(2, 128, 128, 128, 0)
	event.SpriteSetUvsize(2, 0, 0, 512, 416)
	event.SpriteSetPutsize(2, 512, 416)
	event.SpriteSetPos(2, 256, 208)
	event.SpriteSetDraw(2, 0)
	event.EohSyncSprite(12, 2)
	event.ObjsInit(12)
	event.ObjsSyncObj(12, 12)
	event.SpriteInit(3)
	event.SpriteSetType(3, 0)
	event.SpriteSetTexture(3, "e33604", block)
	event.SpriteSetColor(3, 128, 128, 128, 0)
	event.SpriteSetUvsize(3, 0, 0, 512.0, 416.0)
	event.SpriteSetPutsize(3, 512, 416)
	event.SpriteSetPos(3, 256, 208)
	event.SpriteSetDraw(3, 0)
	event.EohSyncSprite(13, 3)
	event.ObjsInit(13)
	event.ObjsSyncObj(13, 13)
	event.SpriteInit(4)
	event.SpriteSetType(4, 0)
	event.SpriteSetTexture(4, "e33605", block)
	event.SpriteSetColor(4, 128, 128, 128, 128)
	event.SpriteSetUvsize(4, 0, 0, 512.0, 416.0)
	event.SpriteSetPutsize(4, 512, 416)
	event.SpriteSetPos(4, 256, 208)
	event.SpriteSetDraw(4, 0)
	event.EohSyncSprite(14, 4)
	event.ObjsInit(14)
	event.ObjsSyncObj(14, 14)
	block = event.LoadImg_4(5, "textures/event/e300/e336/e336telop01.json", 1) or block
	event.SpriteInit(5)
	event.SpriteSetType(5, 0)
	event.SpriteSetTexture(5, "e336telop01", block)
	event.SpriteSetUvsize(5, 0, 0, 512, 128)
	event.SpriteSetPutsize(5, 512, 128)
	event.SpriteSetPos(5, 320, 334)
	event.SpriteSetColor(5, 128, 128, 128, 0)
	event.SpriteSetScale(5, 1.0, 1.0)
	event.SpriteSetDraw(5, 0)
	event.EohSyncSprite(15, 5)
	event.ObjsInit(15)
	event.ObjsSyncObj(15, 15)
	event.LoadMes(0, 5, "event/e300/e336/e336.txt")
end

--- Helper function.
local function helper_13b20()
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
		event.DeleteChara(14)
		event.DeleteChara(15)
	end
	if active_chr_no == 1 then
		event.CharaActive(1, global1)
		event.CharaActive(0, global0)
		event.DelExtMotion(global0)
		event.DelExtMotion(global1)
		event.DeleteChara(global0)
		event.DeleteChara(13)
		event.DeleteChara(14)
		event.DeleteChara(15)
	end
	event.DeleteChara(9)
	event.DeleteChara(16)
	event.DeleteChara(10)
	event.DeleteChara(11)
	event.SpriteSetDraw(0, 0)
	event.SpriteSetDraw(1, 0)
	event.SpriteSetDraw(2, 0)
	event.SpriteSetDraw(3, 0)
	event.SpriteSetDraw(4, 0)
	event.SpriteSetDraw(5, 0)
	event.DelImg(0)
	event.DelImg(1)
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
local function helper_1646c()
	local var4: s32 = 0
	local time: f32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 91 then
			if at <= 1 then
				helper_6dfa44e2(4)
			end
			if at <= 2 then
				helper_14194()
				helper_6dfa44e2(120)
			end
			if at <= 3 then
				helper_6dfa44e2(120)
			end
			if at <= 4 then
				helper_6dfa44e2(40)
			end
			if at <= 5 then
				helper_6dfa44e2(5)
			end
			if at <= 6 then
				helper_6dfa44e2(15)
			end
			if at <= 7 then
				helper_6dfa44e2(5)
			end
			if at <= 8 then
				helper_6dfa44e2(40)
			end
			if at <= 9 then
				helper_6dfa44e2(5)
			end
			if at <= 10 then
				helper_6dfa44e2(15)
			end
			if at <= 11 then
				helper_6dfa44e2(5)
			end
			if at <= 12 then
				helper_6dfa44e2(40)
			end
			if at <= 13 then
				helper_6dfa44e2(5)
			end
			if at <= 14 then
				helper_6dfa44e2(15)
			end
			if at <= 15 then
				helper_6dfa44e2(5)
			end
			if at <= 16 then
				helper_025d5797(3360020, -1)
			end
			if at <= 17 then
				helper_025d5797(3360030, -1)
			end
			if at <= 18 then
				helper_d9c15850(0)
			end
			if at <= 19 then
				helper_d9c15850(1)
			end
			if at <= 20 then
				helper_71fa1d07()
			end
			if at <= 21 then
				helper_6dfa44e2(30)
			end
			if at <= 22 then
				helper_71fa1d07()
			end
			if at <= 23 then
				helper_6dfa44e2(30)
			end
			if at <= 24 then
				helper_4be4f575(3360040)
			end
			if at <= 25 then
				helper_d9c15850(2)
			end
			if at <= 26 then
				helper_4be4f575(3360050)
			end
			if at <= 27 then
				helper_d9c15850(4)
			end
			if at <= 28 then
				helper_4be4f575(3360055)
			end
			if at <= 29 then
				helper_d9c15850(4)
			end
			if at <= 30 then
				helper_6dfa44e2(30)
			end
			if at <= 31 then
				helper_4be4f575(3360060)
			end
			if at <= 32 then
				helper_4be4f575(3360070)
			end
			if at <= 33 then
				helper_6dfa44e2(30)
			end
			if at <= 34 then
				helper_4be4f575(3360080)
			end
			if at <= 35 then
				helper_6dfa44e2(30)
			end
			if at <= 36 then
				helper_4be4f575(3360090)
			end
			if at <= 37 then
				helper_4be4f575(3360100)
			end
			if at <= 38 then
				helper_4be4f575(3360110)
			end
			if at <= 39 then
				helper_6dfa44e2(30)
			end
			if at <= 40 then
				helper_4be4f575(3360120)
			end
			if at <= 41 then
				helper_4be4f575(3360130)
			end
			if at <= 42 then
				helper_4be4f575(3360140)
			end
			if at <= 43 then
				helper_4be4f575(3360145)
			end
			if at <= 44 then
				helper_4be4f575(3360150)
			end
			if at <= 45 then
				helper_4be4f575(3360155)
			end
			if at <= 46 then
				helper_4be4f575(3360160)
			end
			if at <= 47 then
				helper_4be4f575(3360165)
			end
			if at <= 48 then
				helper_4be4f575(3360170)
			end
			if at <= 49 then
				helper_4be4f575(3360175)
			end
			if at <= 50 then
				helper_4be4f575(3360180)
			end
			if at <= 51 then
				helper_4be4f575(3360185)
			end
			if at <= 52 then
				helper_4be4f575(3360190)
			end
			if at <= 53 then
				helper_4be4f575(3360200)
			end
			if at <= 54 then
				helper_4be4f575(3360205)
			end
			if at <= 55 then
				helper_6dfa44e2(30)
			end
			if at <= 56 then
				helper_4be4f575(3360210)
			end
			if at <= 57 then
				helper_4be4f575(3360220)
			end
			if at <= 58 then
				helper_6dfa44e2(30)
			end
			if at <= 59 then
				helper_4be4f575(3360230)
			end
			if at <= 60 then
				helper_4be4f575(3360240)
			end
			if at <= 61 then
				helper_025d5797(3360245, -1)
			end
			if at <= 62 then
				helper_6dfa44e2(30)
			end
			if at <= 63 then
				helper_6dfa44e2(15)
			end
			if at <= 64 then
				helper_4be4f575(3360250)
			end
			if at <= 65 then
				helper_6dfa44e2(150)
			end
			if at <= 66 then
				helper_6dfa44e2(30)
			end
			if at <= 67 then
				helper_6dfa44e2(30)
			end
			if at <= 68 then
				helper_4be4f575(3360260)
			end
			if at <= 69 then
				helper_4be4f575(3360270)
			end
			if at <= 70 then
				helper_6dfa44e2(30)
			end
			if at <= 71 then
				helper_6dfa44e2(15)
			end
			if at <= 72 then
				helper_4be4f575(3360280)
			end
			if at <= 73 then
				helper_4be4f575(3360290)
			end
			if at <= 74 then
				helper_71fa1d07()
			end
			if at <= 75 then
				helper_6dfa44e2(30)
			end
			if at <= 76 then
				helper_6dfa44e2(15)
			end
			if at <= 77 then
				helper_6dfa44e2(30)
			end
			if at <= 78 then
				helper_6dfa44e2(30)
			end
			if at <= 79 then
				helper_6dfa44e2(15)
			end
			if at <= 80 then
				helper_6dfa44e2(15)
			end
			if at <= 81 then
				helper_6dfa44e2(90)
			end
			if at <= 82 then
				helper_6dfa44e2(30)
			end
			if at <= 83 then
				helper_6dfa44e2(90)
			end
			if at <= 84 then
				helper_71fa1d07()
			end
			if at <= 85 then
				helper_6dfa44e2(30)
			end
			if at <= 86 then
				helper_6dfa44e2(30)
			end
			if at <= 87 then
				helper_6dfa44e2(15)
			end
			if at <= 88 then
				helper_4be4f575(3360310)
			end
			if at <= 89 then
				helper_4be4f575(3360320)
			end
			if at <= 90 then
				helper_6dfa44e2(60)
			end
			if vm.skip_end() then
				return skip(92)
			end
			return part2()
		end
		if at <= 92 then
			helper_6dfa44e2(30)
		end
		if at <= 94 then
			helper_13b20()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SetFadeOut(30)
		helper_6dfa44e2(30)
		if vm.skipping() then
			return skip(93)
		end
		event.SetTime(time)
		event.SetTimeStepEnable(1)
		event.SetMotionBlur(0)
		event.SndSeAllStop(4)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		if vm.wait() then
			return skip(94)
		end
		helper_13b20()
		if vm.skipping() then
			return skip(95)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFlag(336, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.SetMotionBlur(0)
	event.StopBgm(0)
	helper_6dfa44e2(4)
	if vm.skipping() then
		return skip(2)
	end
	event.LoadBgm(112)
	event.LoadSound(3823)
	var4 = event.SndLoadSound(3823) or var4
	helper_14194()
	time = event.GetTime() or time
	event.InitDramaScene()
	event.EohSetFootSoundId(0, 1)
	event.EohSetFootSoundId(1, 1)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "デフォルト顔")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "デフォルト顔")
	event.ObjsTexAnime(2, 1, "通常目パチ")
	event.ObjsTexAnime(2, 1, "半口")
	event.CharaActive(1, global0)
	event.CharaActive(1, global1)
	event.CharaActive(1, 9)
	event.CmrsSetPos(-303.43, 42.35, -704.35)
	event.CmrsSetRef(-137.93, 52.07, -827.54)
	event.ObjsSetPos(2, -71.03, 0.0, -852.13)
	event.ObjsSetRot(2, 0.0, -3.312, 0.0)
	event.ObjsSetPos(0, -51.68, 0.0, -885.58)
	event.ObjsSetRot(0, 0.0, 3.04, 0.0)
	event.ObjsSetPos(1, -92.78, 0.0, -885.46)
	event.ObjsSetRot(1, 0.0, 2.96, 0.0)
	event.ObjsSetMotion(0, "立ち", 4)
	event.ObjsSetMotion(2, "立ち", 4)
	event.ObjsSetMotion(1, "立ち", 4)
	event.SetFadeIn(30)
	helper_6dfa44e2(120)
	if vm.skipping() then
		return skip(3)
	end
	event.SetCrossfade(30)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "無表情")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "無表情")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.CmrsSetPos(-102.49, 15.34, -957.31)
	event.CmrsSetRef(-71.83, 20.94, -886.5)
	helper_6dfa44e2(120)
	if vm.skipping() then
		return skip(4)
	end
	event.CmrsInitPas()
	event.CmrsSetPasFrm(240)
	event.CmrsAddPas(-157.91, 17.6, -857.92, 44.13, 27.32, -844.52)
	event.CmrsAddPas(-109.74, 17.6, -854.73, 44.13, 27.32, -844.52)
	event.CmrsStartPas()
	helper_6dfa44e2(40)
	if vm.skipping() then
		return skip(5)
	end
	event.SndSePlay(var4, 2)
	event.SetFadeOut(5, 255, 255, 255)
	helper_6dfa44e2(5)
	if vm.skipping() then
		return skip(6)
	end
	event.SetFadeIn(5)
	event.SpriteSetDraw(4, 1)
	helper_6dfa44e2(15)
	if vm.skipping() then
		return skip(7)
	end
	event.SndSePlay(var4, 2)
	event.SetFadeOut(5, 255, 255, 255)
	helper_6dfa44e2(5)
	if vm.skipping() then
		return skip(8)
	end
	event.SetFadeIn(5)
	event.SpriteSetDraw(4, 0)
	helper_6dfa44e2(40)
	if vm.skipping() then
		return skip(9)
	end
	event.SndSePlay(var4, 2)
	event.SetFadeOut(5, 255, 255, 255)
	helper_6dfa44e2(5)
	if vm.skipping() then
		return skip(10)
	end
	event.SetFadeIn(5)
	event.SpriteSetDraw(4, 1)
	helper_6dfa44e2(15)
	if vm.skipping() then
		return skip(11)
	end
	event.SndSePlay(var4, 2)
	event.SetFadeOut(5, 255, 255, 255)
	helper_6dfa44e2(5)
	if vm.skipping() then
		return skip(12)
	end
	event.SetFadeIn(5)
	event.SpriteSetDraw(4, 0)
	helper_6dfa44e2(40)
	if vm.skipping() then
		return skip(13)
	end
	event.SndSePlay(var4, 2)
	event.SetFadeOut(5, 255, 255, 255)
	helper_6dfa44e2(5)
	if vm.skipping() then
		return skip(14)
	end
	event.SetFadeIn(5)
	event.SpriteSetDraw(4, 1)
	helper_6dfa44e2(15)
	if vm.skipping() then
		return skip(15)
	end
	event.SndSePlay(var4, 2)
	event.SetFadeOut(5, 255, 255, 255)
	helper_6dfa44e2(5)
	if vm.skipping() then
		return skip(16)
	end
	event.SetFadeIn(5)
	event.SpriteSetDraw(4, 0)
	event.CmrsSetPos(-86.68, 23.43, -938.64)
	event.CmrsSetRef(-64.82, 27.32, -852.79)
	event.ObjsSetMotion(2, "頭かかえ", 6)
	event.ObjsNextMotion(2, "頭かかえL", 4)
	event.ObjsMotionDelay(0, 30)
	event.ObjsSeDelay(0, 30)
	event.ObjsSePlay(0, var4, 3)
	event.ObjsSetMotion(0, "左・振り返り", 6)
	event.ObjsNextMotion(0, "左・振り返りL", 4)
	event.ObjsMotionDelay(1, 30)
	event.ObjsSetMotion(1, "振りかえり", 6)
	event.ObjsNextMotion(1, "振りかえりL", 4)
	helper_025d5797(3360020, -1)
	if vm.skipping() then
		return skip(17)
	end
	helper_025d5797(3360030, -1)
	if vm.skipping() then
		return skip(18)
	end
	event.SetMotionBlur(60)
	event.CmrsSetPos(-76.1, 46.54, -770.39)
	event.CmrsSetRef(-70.1, 27.32, -860.66)
	event.ObjsSetRot(0, 0.0, -0.48, 0.0)
	event.ObjsSetRot(1, 0.0, 0.44, 0.0)
	event.CmrsMove(-157.21, 46.54, 449.93, -70.1, 27.32, -860.66, 90)
	event.SndSePlay(var4, 4)
	event.ObjsSetMotion(0, "走り", 4)
	event.ObjsSetMotion(1, "走り", 4)
	event.ObjsMove(0, -54.72, 0.0, -869.17, 15, 1)
	event.ObjsMove(1, -84.82, 0.0, -874.03, 15, 1)
	helper_d9c15850(0)
	if vm.skipping() then
		return skip(19)
	end
	helper_d9c15850(1)
	if vm.skipping() then
		return skip(20)
	end
	event.ObjsSetMotion(0, "立ち", 4)
	event.ObjsSetMotion(1, "立ち", 4)
	event.CmrsFadeInit()
	event.CmrsFadeDelay(60)
	event.CmrsFadeOut(30, 255.0, 255.0, 255.0)
	helper_71fa1d07()
	if vm.skipping() then
		return skip(21)
	end
	event.SetMotionBlur(0)
	helper_6dfa44e2(30)
	if vm.skipping() then
		return skip(22)
	end
	event.DeleteChara(9)
	event.LoadChara(5, "event/e300/e336/e336_crest.gltf", "info", 11)
	event.CharaActive(0, 11)
	event.EohSyncChara(6, 11)
	event.ObjsInit(4, 11)
	event.ObjsSyncObj(4, 6)
	event.LoadChara(5, "event/e300/e336/e336_lin2.gltf", "info", 9)
	event.CharaActive(0, 9)
	event.EohSyncChara(4, 9)
	event.ObjsInit(2, 9)
	event.ObjsSyncObj(2, 4)
	event.SetTime(12.0)
	event.SetTimeStepEnable(0)
	event.PlayBgm(0)
	event.CmrsSetPos(-297.31, 603.3, -529.44)
	event.CmrsSetRef(-114.1, 586.6, -822.33)
	event.CmrsMove2(-297.31, 51.86, -529.44, -114.1, 35.16, -822.33, 240, 2, 0.2)
	event.CharaActive(0, 13)
	event.CharaActive(0, global0)
	event.CharaActive(0, global1)
	event.CharaActive(1, 9)
	event.CharaActive(1, 11)
	event.ObjsSetMotion(2, "立ち", 4)
	event.ObjsSetMotion(4, "立ち2", 4)
	event.ObjsSetPos(4, -51.68, 0.0, -885.58)
	event.ObjsSetRot(4, 0.0, 3.04, 0.0)
	event.ObjsSetPos(2, -76.82, 0.0, -887.22)
	event.ObjsSetRot(2, 0.0, 1.76, 0.0)
	event.CmrsFadeIn(60, 255.0, 255.0, 255.0)
	helper_71fa1d07()
	if vm.skipping() then
		return skip(23)
	end
	helper_6dfa44e2(30)
	if vm.skipping() then
		return skip(24)
	end
	event.ObjsTexAnime(4, 0)
	event.ObjsTexAnime(4, 1, "無表情")
	event.ObjsTexAnime(4, 1, "通常目パチ")
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "デフォルト顔")
	event.ObjsTexAnime(2, 1, "通常目パチ")
	event.CmrsSetPos(-56.27, 12.94, -955.94)
	event.CmrsSetRef(-64.49, 18.56, -881.94)
	event.CmrsMove2(-29.91, 12.94, -940.74, -64.49, 18.56, -881.94, 600, 2, 0.1)
	event.SndSePlay(var4, 5)
	event.ObjsSetMotion(2, "右向く", 6)
	event.ObjsNextMotion(2, "右向くL", 4)
	event.SetPakuAnim(4, "通常口パク")
	helper_4be4f575(3360040)
	if vm.skipping() then
		return skip(25)
	end
	helper_d9c15850(2)
	if vm.skipping() then
		return skip(26)
	end
	event.ObjsSetMotion(4, "左を見る", 6)
	event.ObjsNextMotion(4, "左を見るL", 6)
	event.ObjsNextMotion(4, "考える", 6)
	event.ObjsNextMotion(4, "考えるL", 4)
	event.SetPakuAnim(6, "通常口パク")
	helper_4be4f575(3360050)
	if vm.skipping() then
		return skip(27)
	end
	helper_d9c15850(4)
	if vm.skipping() then
		return skip(28)
	end
	event.ObjsSetMotion(4, "考える戻り", 6)
	event.ObjsNextMotion(4, "左を見るL", 4)
	event.SetPakuAnim(6, "通常口パク")
	helper_4be4f575(3360055)
	if vm.skipping() then
		return skip(29)
	end
	helper_d9c15850(4)
	if vm.skipping() then
		return skip(30)
	end
	helper_6dfa44e2(30)
	if vm.skipping() then
		return skip(31)
	end
	event.CmrsInit()
	event.ObjsTexAnime(4, 0)
	event.ObjsTexAnime(4, 1, "大わらい顔")
	event.ObjsTexAnime(4, 1, "通常目パチ")
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "おこり顔")
	event.ObjsTexAnime(2, 1, "通常目パチ")
	event.CmrsSetPos(-31.38, 30.21, -910.26)
	event.CmrsSetRef(-87.35, 19.34, -871.43)
	event.CmrsMove2(-29.12, 30.21, -907.0, -85.09, 19.34, -868.17, 600, 2, 0.1)
	event.ObjsSetMotion(2, "腰に手", 6)
	event.ObjsNextMotion(2, "腰に手会話", 2)
	event.ObjsNextMotion(2, "腰に手L", 4)
	event.SetPakuAnim(4, "通常口パク")
	helper_4be4f575(3360060)
	if vm.skipping() then
		return skip(32)
	end
	event.SndSePlay(var4, 7)
	event.ObjsSetMotion(4, "笑い", 6)
	event.ObjsNextMotion(4, "笑いL", 2)
	event.ObjsNextMotion(4, "笑い戻り", 6)
	event.ObjsNextMotion(4, "立ち2", 4)
	event.ObjsTexAnime(4, 0)
	event.ObjsTexAnime(4, 1, "わらい顔")
	event.ObjsTexAnime(4, 1, "わらい目パチ")
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "デフォルト顔")
	event.ObjsTexAnime(2, 1, "おこり目～通常目")
	event.ObjsTexaDelay(30)
	event.ObjsTexAnime(4, 1, "通常目パチ")
	event.SetPakuAnim(6, "わらい口パク")
	helper_4be4f575(3360070)
	if vm.skipping() then
		return skip(33)
	end
	event.ResetPakuAnim()
	helper_6dfa44e2(30)
	if vm.skipping() then
		return skip(34)
	end
	event.ObjsSetMotion(4, "会話2", 2)
	event.ObjsNextMotion(4, "立ち2", 4)
	event.SetPakuAnim(6, "通常口パク")
	helper_4be4f575(3360080)
	if vm.skipping() then
		return skip(35)
	end
	event.ResetPakuAnim()
	helper_6dfa44e2(30)
	if vm.skipping() then
		return skip(36)
	end
	event.CmrsInit()
	event.SetCrossfade(30)
	event.CmrsSetPos(-80.0, 6.0, -766.5)
	event.CmrsSetRef(-80.0, 23.0, -889.39)
	event.CmrsMove2(-56.0, 6.0, -766.5, -56.0, 23.0, -889.39, 300, 2, 0.1)
	helper_4be4f575(3360090)
	if vm.skipping() then
		return skip(37)
	end
	event.CmrsInit()
	event.SetCrossfade(30)
	event.CmrsSetPos(-56.38, 6.57, -939.5)
	event.CmrsSetRef(-65.1, 23.91, -871.04)
	event.ObjsSetRot(2, 0.0, 2.84, 0.0)
	event.ObjsSetMotion(2, "立ち", 4)
	event.ObjsSetMotion(4, "会話3", 2)
	event.ObjsNextMotion(4, "立ち2", 4)
	event.SetPakuAnim(6, "通常口パク")
	helper_4be4f575(3360100)
	if vm.skipping() then
		return skip(38)
	end
	event.ResetPakuAnim()
	event.SndSePlay(var4, 6)
	event.ObjsSetMotion(2, "うーん", 6)
	event.ObjsNextMotion(2, "うーんL", 4)
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "無表情")
	event.ObjsTexAnime(2, 1, "前向き～左向き")
	event.SetPakuAnim(4, "通常口パク")
	helper_4be4f575(3360110)
	if vm.skipping() then
		return skip(39)
	end
	event.ResetPakuAnim()
	helper_6dfa44e2(30)
	if vm.skipping() then
		return skip(40)
	end
	event.ObjsSetRot(2, 0.0, 1.76, 0.0)
	event.ObjsTexAnime(4, 0)
	event.ObjsTexAnime(4, 1, "無表情")
	event.ObjsTexAnime(4, 1, "通常目パチ")
	event.CmrsSetPos(-78.92, 13.21, -914.21)
	event.CmrsSetRef(-33.74, 32.68, -868.91)
	event.ObjsSetMotion(2, "立ち", 4)
	event.ObjsSetMotion(4, "会話3", 2)
	event.ObjsNextMotion(4, "立ち2", 4)
	event.SetPakuAnim(6, "通常口パク")
	helper_4be4f575(3360120)
	if vm.skipping() then
		return skip(41)
	end
	event.ResetPakuAnim()
	event.SpriteSetDraw(0, 1)
	event.ObjsSetColor(10, 128, 128, 128, 128, 30)
	event.ObjsSetMotion(4, "会話3", 2)
	event.ObjsNextMotion(4, "立ち2", 4)
	event.SetPakuAnim(6, "通常口パク")
	helper_4be4f575(3360130)
	if vm.skipping() then
		return skip(42)
	end
	event.ResetPakuAnim()
	event.SpriteSetDraw(1, 1)
	event.ObjsSetColor(11, 128, 128, 128, 128, 30)
	event.SetPakuAnim(6, "通常口パク")
	helper_4be4f575(3360140)
	if vm.skipping() then
		return skip(43)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(6, "通常口パク")
	helper_4be4f575(3360145)
	if vm.skipping() then
		return skip(44)
	end
	event.ResetPakuAnim()
	event.SpriteSetDraw(2, 1)
	event.ObjsSetColor(12, 128, 128, 128, 128, 30)
	event.SetPakuAnim(6, "通常口パク")
	helper_4be4f575(3360150)
	if vm.skipping() then
		return skip(45)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(6, "通常口パク")
	helper_4be4f575(3360155)
	if vm.skipping() then
		return skip(46)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(6, "通常口パク")
	helper_4be4f575(3360160)
	if vm.skipping() then
		return skip(47)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(6, "通常口パク")
	helper_4be4f575(3360165)
	if vm.skipping() then
		return skip(48)
	end
	event.ResetPakuAnim()
	event.SpriteSetDraw(3, 1)
	event.ObjsSetColor(13, 128, 128, 128, 128, 30)
	event.SetPakuAnim(6, "通常口パク")
	helper_4be4f575(3360170)
	if vm.skipping() then
		return skip(49)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(6, "通常口パク")
	helper_4be4f575(3360175)
	if vm.skipping() then
		return skip(50)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(6, "通常口パク")
	helper_4be4f575(3360180)
	if vm.skipping() then
		return skip(51)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(6, "通常口パク")
	helper_4be4f575(3360185)
	if vm.skipping() then
		return skip(52)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(6, "通常口パク")
	helper_4be4f575(3360190)
	if vm.skipping() then
		return skip(53)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(6, "通常口パク")
	helper_4be4f575(3360200)
	if vm.skipping() then
		return skip(54)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(6, "通常口パク")
	helper_4be4f575(3360205)
	if vm.skipping() then
		return skip(55)
	end
	event.ResetPakuAnim()
	event.SpriteSetDraw(0, 0)
	event.SpriteSetDraw(1, 0)
	event.SpriteSetDraw(2, 0)
	event.ObjsSetColor(13, 128, 128, 128, 0, 30)
	helper_6dfa44e2(30)
	if vm.skipping() then
		return skip(56)
	end
	event.ObjsTexAnime(4, 0)
	event.ObjsTexAnime(4, 1, "わらい顔")
	event.ObjsTexAnime(4, 1, "わらい目パチ")
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "デフォルト顔")
	event.ObjsTexAnime(2, 1, "通常目パチ")
	event.CmrsSetPos(-2.61, 26.27, -934.98)
	event.CmrsSetRef(-85.09, 13.74, -868.17)
	event.ObjsSetMotion(2, "右向くL", 4)
	event.SetPakuAnim(6, "通常口パク")
	event.ObjsSetMotion(4, "会話3", 2)
	event.ObjsNextMotion(4, "立ち2", 4)
	helper_4be4f575(3360210)
	if vm.skipping() then
		return skip(57)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(4, "通常口パク")
	helper_4be4f575(3360220)
	if vm.skipping() then
		return skip(58)
	end
	event.ResetPakuAnim()
	helper_6dfa44e2(30)
	if vm.skipping() then
		return skip(59)
	end
	event.ObjsTexAnime(4, 0)
	event.ObjsTexAnime(4, 1, "大わらい顔")
	event.ObjsTexAnime(4, 1, "わらい目パチ")
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "わらい顔")
	event.ObjsTexAnime(2, 1, "通常目パチ")
	event.CmrsSetPos(-64.24, 26.65, -742.64)
	event.CmrsSetRef(-63.35, 32.68, -885.22)
	event.CmrsMove2(-64.42, 26.65, -682.97, -63.35, 32.68, -885.22, 600, 2, 0.1)
	event.ObjsSetMotion(4, "立ち2", 4)
	event.SetPakuAnim(4, "わらい口パク")
	helper_4be4f575(3360230)
	if vm.skipping() then
		return skip(60)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(4, "会話2", 2)
	event.ObjsNextMotion(4, "左を見る", 6)
	event.ObjsNextMotion(4, "左を見るL", 4)
	event.SetPakuAnim(6, "わらい口パク")
	helper_4be4f575(3360240)
	if vm.skipping() then
		return skip(61)
	end
	event.ObjsTexAnime(4, 1, "わらい口パク")
	event.ObjsTexAnime(2, 1, "わらい口パク")
	event.SndSePlay(var4, 7)
	event.ObjsSetMotion(4, "笑い", 6)
	event.ObjsNextMotion(4, "笑いL", 4)
	helper_025d5797(3360245, -1)
	if vm.skipping() then
		return skip(62)
	end
	event.CmrsFadeOut(30, 255.0, 255.0, 255.0)
	event.FadeOutBgm(30)
	helper_6dfa44e2(30)
	if vm.skipping() then
		return skip(63)
	end
	event.StopBgm(0)
	event.CmrsInit()
	event.DeleteChara(9)
	event.CharaActive(0, 11)
	event.LoadChara(5, "event/e300/e336/e336_me.gltf", "info", 10)
	event.CharaActive(0, 10)
	event.EohSyncChara(5, 10)
	event.ObjsInit(3, 10)
	event.ObjsSyncObj(3, 5)
	event.LoadChara(5, "event/e300/e336/e336_lin.gltf", "info", 9)
	event.CharaActive(0, 9)
	event.EohSyncChara(4, 9)
	event.ObjsInit(2, 9)
	event.ObjsSyncObj(2, 4)
	event.LoadChara(5, "event/e300/e336/e336_rin_kemuri.gltf", "info", 16)
	event.CharaActive(0, 16)
	event.EohSyncChara(7, 16)
	event.ObjsInit(7, 16)
	event.ObjsSyncObj(7, 7)
	event.SetTime(time)
	event.SetTimeStepEnable(1)
	event.CmrsSetPos(-114.47, 17.08, -834.34)
	event.CmrsSetRef(-71.89, 20.6, -808.25)
	event.CharaActive(1, 13)
	event.CharaActive(1, global0)
	event.CharaActive(1, global1)
	event.CharaActive(1, 9)
	event.CharaActive(1, 16)
	event.CharaActive(1, 10)
	event.ObjsSetScale(3, 0.0, 0.0, 0.0, 0)
	event.SetCharaShow(16, 0)
	event.ObjsSetPos(2, -74.74, 0.0, -806.3)
	event.ObjsSetRot(2, 0.0, -3.312, 0.0)
	event.ObjsSetPos(7, -74.74, 0.0, -806.3)
	event.ObjsSetRot(7, 0.0, -3.312, 0.0)
	event.ObjsSetPos(3, -76.09, 22.0, -809.66)
	event.ObjsSetRot(3, 0.0, -3.312, 0.0)
	event.ObjsSetPos(0, -51.68, 0.0, -885.58)
	event.ObjsSetRot(0, 0.0, -0.32, 0.0)
	event.ObjsSetPos(1, -92.78, 0.0, -885.46)
	event.ObjsSetRot(1, 0.0, 0.2, 0.0)
	event.ObjsSetMotion(2, "頭かかえL", 4)
	event.ObjsSetMotion(7, "頭かかえL", 4)
	event.CmrsFadeIn(60, 255.0, 255.0, 255.0)
	event.SndSePlay(var4, 8)
	helper_6dfa44e2(15)
	if vm.skipping() then
		return skip(64)
	end
	event.SetCharaShow(16, 1, 1, 0.0125)
	helper_4be4f575(3360250)
	if vm.skipping() then
		return skip(65)
	end
	event.CmrsMove2(-102.78, 34.32, -836.68, -71.89, 27.85, -808.25, 120, 0, 0.4)
	event.SndSePlay(var4, 9)
	event.ObjsSetScale(3, 0.25, 0.25, 0.25, 180)
	helper_6dfa44e2(150)
	if vm.skipping() then
		return skip(66)
	end
	helper_6dfa44e2(30)
	if vm.skipping() then
		return skip(67)
	end
	event.ObjsSetScale(3, 1.25, 1.25, 1.25, 240)
	event.CmrsSetPos(-64.41, 9.43, -967.48)
	event.CmrsSetRef(-76.6, 52.07, -819.83)
	event.ObjsSetMotion(0, "上見驚き", 6)
	event.ObjsSetMotion(1, "上驚き", 6)
	event.ObjsNextMotion(0, "上向くL", 4)
	event.ObjsNextMotion(1, "上向くL", 4)
	helper_6dfa44e2(30)
	if vm.skipping() then
		return skip(68)
	end
	event.SetPakuAnim(0, "通常口パク")
	helper_4be4f575(3360260)
	if vm.skipping() then
		return skip(69)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(1, "通常口パク")
	helper_4be4f575(3360270)
	if vm.skipping() then
		return skip(70)
	end
	event.ResetPakuAnim()
	event.ObjsSetScale(3, 1.75, 1.75, 1.75, 240)
	helper_6dfa44e2(30)
	if vm.skipping() then
		return skip(71)
	end
	event.CmrsSetPos(-224.41, 16.45, -978.74)
	event.CmrsSetRef(-76.09, 69.2, -809.66)
	helper_6dfa44e2(15)
	if vm.skipping() then
		return skip(72)
	end
	event.CmrsMove2(-296.34, 16.45, -752.06, -76.09, 69.2, -809.66, 240, 0, 0.4)
	helper_4be4f575(3360280)
	if vm.skipping() then
		return skip(73)
	end
	helper_4be4f575(3360290)
	if vm.skipping() then
		return skip(74)
	end
	helper_71fa1d07()
	if vm.skipping() then
		return skip(75)
	end
	helper_6dfa44e2(30)
	if vm.skipping() then
		return skip(76)
	end
	event.CmrsInit()
	event.CmrsSetPos(-52.97, 41.64, -777.44)
	event.CmrsSetRef(-80.22, 14.54, -868.17)
	helper_6dfa44e2(15)
	if vm.skipping() then
		return skip(77)
	end
	event.ObjsMove(3, -76.09, 48.73, -809.66, 5, 0)
	event.SndSePlay(var4, 10)
	event.ObjsSetMotion(0, "上見驚き", 6)
	event.ObjsSetMotion(1, "上驚き", 6)
	event.ObjsNextMotion(0, "上向くL", 4)
	event.ObjsNextMotion(1, "上向くL", 4)
	event.SndSeStop(var4, 9)
	helper_6dfa44e2(30)
	if vm.skipping() then
		return skip(78)
	end
	event.SetFadeOut(30)
	helper_6dfa44e2(30)
	if vm.skipping() then
		return skip(79)
	end
	event.ObjsSetMotion(0, "立ち", 4)
	event.ObjsSetMotion(1, "立ち", 4)
	event.DeleteChara(10)
	event.CharaActive(0, 9)
	event.CharaActive(0, 16)
	event.LoadChara(5, "dungeon/monster/e220a.gltf", "e220a", 10)
	event.CharaActive(1, 10)
	event.EohSyncChara(5, 10)
	event.ObjsInit(3, 10)
	event.ObjsSyncObj(3, 5)
	event.LoadBgm(190)
	event.ObjsSetPos(3, -102.77, 0.0, -720.48)
	event.ObjsSetRot(3, 0.0, -3.312, 0.0)
	event.ObjsSetMotion(3, "攻撃１", 6)
	event.ObjsNextMotion(3, "立ち", 4)
	event.CmrsSetPos(-164.4, 14.41, -665.54)
	event.CmrsSetRef(-24.29, 14.54, -859.25)
	helper_6dfa44e2(15)
	if vm.skipping() then
		return skip(80)
	end
	event.SetFadeIn(30)
	helper_6dfa44e2(15)
	if vm.skipping() then
		return skip(81)
	end
	event.PlayBgm(0)
	event.CmrsQuake(0.0, 0.3, 0.0, 90)
	event.SndSePlay(var4, 11)
	helper_6dfa44e2(90)
	if vm.skipping() then
		return skip(82)
	end
	helper_6dfa44e2(30)
	if vm.skipping() then
		return skip(83)
	end
	event.CmrsSetPos(-129.58, 12.28, -799.76)
	event.CmrsSetRef(-95.81, 20.0, -706.37)
	event.ObjsSetMotion(0, "立ち", 4)
	event.ObjsSetMotion(1, "立ち", 4)
	event.CmrsMove2(-129.58, 41.07, -799.76, -95.81, 48.78, -706.37, 120, 0, 0.4)
	helper_6dfa44e2(90)
	if vm.skipping() then
		return skip(84)
	end
	event.SpriteSetDraw(5, 1)
	event.ObjsSetColor(15, 128, 128, 128, 128, 30)
	event.ObjsSetMotion(3, "遊び", 6)
	event.ObjsNextMotion(3, "立ち", 4)
	event.SndSePlay(var4, 12)
	helper_71fa1d07()
	if vm.skipping() then
		return skip(85)
	end
	event.ObjsSetColor(15, 128, 128, 128, 0, 30)
	helper_6dfa44e2(30)
	if vm.skipping() then
		return skip(86)
	end
	helper_6dfa44e2(30)
	if vm.skipping() then
		return skip(87)
	end
	event.CharaActive(1, 14)
	event.CharaActive(1, 15)
	event.EohSyncChara(2, 1)
	event.EohSetShow(2, 1)
	event.EohSyncChara(3, 2)
	event.EohSetShow(3, 1)
	event.CmrsSetPos(-29.29, 6.3, -834.76)
	event.CmrsSetRef(-76.21, 19.78, -889.08)
	event.ObjsSetMotion(0, "バトル立ち", 4)
	event.ObjsSetMotion(1, "バトル立ち", 4)
	helper_6dfa44e2(15)
	if vm.skipping() then
		return skip(88)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_4be4f575(3360310)
	if vm.skipping() then
		return skip(89)
	end
	event.ResetPakuAnim()
	event.SndSePlay(var4, 13)
	event.ObjsSetMotion(0, "うなづく", 6)
	event.ObjsNextMotion(0, "バトル立ち", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_4be4f575(3360320)
	if vm.skipping() then
		return skip(90)
	end
	event.ResetPakuAnim()
	helper_6dfa44e2(60)
	if vm.skipping() then
		return skip(91)
	end
	return part2()
end

--- Helper function.
local function helper_1e34c()
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
		event.LoadMotion(5, "event/e300/e340/e340_mints.gltf", "info", global0)
		event.EohSyncChara(0, global0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global0)
		event.LoadChara(5, "chara/c02_base.gltf", "info", global1)
		event.LoadEquip(5, 1, 1, "info", global1, 14)
		event.LoadEquip(5, 1, 0, "info", global1, 15)
		event.LoadEquip(5, 1, 4, "info", global1)
		event.LoadEquip(5, 1, 3, "info", global1)
		event.LoadEquip(5, 1, 2, "info", global1, 13)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.LoadMotion(5, "event/e300/e340/e340_monica.gltf", "info", global1)
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
		event.LoadEquip(5, 0, 1, "info", global0, 14)
		event.LoadEquip(5, 0, 0, "info", global0, 15)
		event.LoadEquip(5, 0, 4, "info", global0)
		event.LoadEquip(5, 0, 3, "info", global0)
		event.LoadEquip(5, 0, 2, "info", global0, 13)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.LoadMotion(5, "event/e300/e340/e340_mints.gltf", "info", global0)
		event.EohSyncChara(0, global0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global0)
		event.CharaActive(1, 13)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.LoadMotion(5, "event/e300/e340/e340_monica.gltf", "info", global1)
		event.EohSyncChara(1, global1)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global1)
	end
	event.LoadChara(5, "event/e300/e340/e340_lin.gltf", "info", 11)
	event.CharaActive(0, 11)
	event.EohSyncChara(4, 11)
	event.ObjsInit(2, 11)
	event.ObjsSyncObj(2, 4)
	event.LoadChara(5, "dungeon/monster/e220a.gltf", "e220a", 12)
	event.CharaActive(0, 12)
	event.EohSyncChara(5, 12)
	event.ObjsInit(3, 12)
	event.ObjsSyncObj(3, 5)
	event.LoadChara(5, "event/e300/e340/e340_mem_kieru.gltf", "info", 16)
	event.CharaActive(0, 16)
	event.CharaActive(1, 14)
	event.CharaActive(1, 15)
	event.LoadMes(0, 5, "event/e300/e340/e340.txt")
end

--- Helper function.
local function helper_1de1c()
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
		event.DeleteChara(14)
		event.DeleteChara(15)
	end
	if active_chr_no == 1 then
		event.CharaActive(1, global1)
		event.CharaActive(0, global0)
		event.DelExtMotion(global0)
		event.DelExtMotion(global1)
		event.DeleteChara(global0)
		event.DeleteChara(13)
		event.DeleteChara(14)
		event.DeleteChara(15)
	end
	event.DeleteChara(11)
	event.DeleteChara(12)
	event.DeleteChara(16)
	event.SetStatus(1, 0, 256, 0)
	event.EohSyncChara(2, 1)
	event.EohSetShow(2, 1)
	event.EohSyncChara(3, 2)
	event.EohSetShow(3, 1)
	event.SetStatusbarShow(1, 1.0)
	event.Finish()
	if vm.wait() then
		return skip(2)
	end
end

--- Helper function.
local function helper_1f5f0()
	local var4: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 27 then
			if at <= 5 then
				helper_1e34c()
				helper_6dfa44e2(15)
			end
			if at <= 6 then
				helper_6dfa44e2(30)
			end
			if at <= 7 then
				helper_6dfa44e2(90)
			end
			if at <= 8 then
				helper_d9c15850(0)
			end
			if at <= 9 then
				helper_d9c15850(1)
			end
			if at <= 10 then
				helper_6dfa44e2(60)
			end
			if at <= 11 then
				helper_4be4f575(3400010)
			end
			if at <= 12 then
				helper_6dfa44e2(60)
			end
			if at <= 13 then
				helper_4be4f575(3400015)
			end
			if at <= 14 then
				helper_4be4f575(3400020)
			end
			if at <= 15 then
				helper_4be4f575(3400025)
			end
			if at <= 16 then
				helper_6dfa44e2(30)
			end
			if at <= 17 then
				helper_6dfa44e2(15)
			end
			if at <= 18 then
				helper_4be4f575(3400030)
			end
			if at <= 19 then
				helper_4be4f575(3400040)
			end
			if at <= 20 then
				helper_4be4f575(3400050)
			end
			if at <= 21 then
				helper_6dfa44e2(15)
			end
			if at <= 22 then
				helper_025d5797(3400060, -1)
			end
			if at <= 23 then
				helper_6dfa44e2(30)
			end
			if at <= 24 then
				helper_6dfa44e2(60)
			end
			if at <= 25 then
				helper_4be4f575(3400070)
			end
			if at <= 26 then
				helper_6dfa44e2(30)
			end
			if vm.skip_end() then
				return skip(28)
			end
			return part2()
		end
		if at <= 28 then
			helper_6dfa44e2(30)
		end
		if at <= 30 then
			helper_1de1c()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SetFadeOut(30)
		helper_6dfa44e2(30)
		if vm.skipping() then
			return skip(29)
		end
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.SndSeAllStop(4)
		if vm.wait() then
			return skip(30)
		end
		helper_1de1c()
		if vm.skipping() then
			return skip(31)
		end
		event.SetFadeIn(30)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFlag(340, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.SetFadeOut(0)
	event.StopBgm(0)
	if vm.wait() then
		return skip(2)
	end
	if vm.wait() then
		return skip(3)
	end
	if vm.wait() then
		return skip(4)
	end
	if vm.wait() then
		return skip(5)
	end
	helper_1e34c()
	event.LoadSound(3826)
	var4 = event.SndLoadSound(3826) or var4
	event.LoadBgm(49)
	event.SetStatus(1, 0, 256, 1)
	event.InitDramaScene()
	event.EohSetFootSoundId(0, 1)
	event.EohSetFootSoundId(1, 1)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "デフォルト顔")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "無表情")
	event.ObjsTexAnime(2, 1, "通常目パチ")
	event.CharaActive(1, global0)
	event.CharaActive(1, global1)
	event.CharaActive(1, 11)
	event.CharaActive(1, 12)
	event.CmrsSetPos(-559.26, 65.75, -328.45)
	event.CmrsSetRef(-142.53, 58.24, -796.93)
	event.ObjsSetPos(2, -142.0, 0.0, -1031.0)
	event.ObjsSetRot(2, 0.0, -0.36, 0.0)
	event.ObjsSetPos(3, -296.82, 0.0, -544.32)
	event.ObjsSetRot(3, 0.0, -1.72, 0.0)
	event.SetCharaPos(16, -296.82, 0.0, -544.32)
	event.SetCharaRot(16, 0.0, -1.72, 0.0)
	event.ObjsSetPos(0, -439.61, 0.0, -561.58)
	event.ObjsSetRot(0, 0.0, 1.32, 0.0)
	event.ObjsSetPos(1, -441.56, 0.0, -520.65)
	event.ObjsSetRot(1, 0.0, 0.8, 0.0)
	event.ObjsSetMotion(0, "バトル立ち", 4)
	event.ObjsSetMotion(1, "バトル立ち", 4)
	event.ObjsSetMotion(2, "座り", 4)
	event.ObjsSetMotion(3, "死に", 2)
	event.CharaActive(1, 16)
	event.SetFadeIn(30)
	helper_6dfa44e2(15)
	if vm.skipping() then
		return skip(6)
	end
	event.SndSePlay(var4, 2)
	helper_6dfa44e2(30)
	if vm.skipping() then
		return skip(7)
	end
	event.SetCharaShow(12, 0, 1, 0.025)
	event.SetCharaShow(16, 0, 1, 0.025)
	event.SndSePlay(var4, 3)
	helper_6dfa44e2(90)
	if vm.skipping() then
		return skip(8)
	end
	event.CharaActive(0, 12)
	event.CharaActive(0, 16)
	event.EohSyncChara(2, 1)
	event.EohSetShow(2, 0)
	event.EohSyncChara(3, 2)
	event.EohSetShow(3, 0)
	event.CharaActive(0, 14)
	event.CharaActive(0, 15)
	event.ObjsSetMotion(0, "走り")
	event.ObjsSetMotion(1, "走り")
	event.ObjsSetPos(0, -231.36, 0.0, -872.18)
	event.ObjsSetRot(0, 0.0, 2.52, 0.0)
	event.ObjsSetPos(1, -176.93, 0.0, -859.14)
	event.ObjsSetRot(1, 0.0, 2.96, 0.0)
	event.ObjsMove(0, -178.43, 0.0, -986.22, 90, 1)
	event.ObjsMove(1, -152.11, 0.0, -973.42, 90, 1)
	event.CmrsSetPos(-198.82, 54.44, -881.4)
	event.CmrsSetRef(-144.13, 15.05, -1023.93)
	helper_d9c15850(0)
	if vm.skipping() then
		return skip(9)
	end
	helper_d9c15850(1)
	if vm.skipping() then
		return skip(10)
	end
	event.ObjsSetMotion(0, "立ち")
	event.ObjsSetMotion(1, "立ち")
	event.CmrsSetPos(-76.1, 10.61, -1046.48)
	event.CmrsSetRef(-132.11, 15.05, -1017.56)
	event.PlayBgm(0)
	helper_6dfa44e2(60)
	if vm.skipping() then
		return skip(11)
	end
	event.SetPakuAnim(4, "通常口パク")
	helper_4be4f575(3400010)
	if vm.skipping() then
		return skip(12)
	end
	event.ResetPakuAnim()
	helper_6dfa44e2(60)
	if vm.skipping() then
		return skip(13)
	end
	event.ObjsSetMotion(2, "顔上げ", 6)
	event.ObjsNextMotion(2, "顔上げL", 4)
	event.SetPakuAnim(4, "通常口パク")
	helper_4be4f575(3400015)
	if vm.skipping() then
		return skip(14)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(4, "通常口パク")
	helper_4be4f575(3400020)
	if vm.skipping() then
		return skip(15)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(4, "通常口パク")
	helper_4be4f575(3400025)
	if vm.skipping() then
		return skip(16)
	end
	event.ResetPakuAnim()
	helper_6dfa44e2(30)
	if vm.skipping() then
		return skip(17)
	end
	event.CmrsSetPos(-160.43, 21.01, -1099.02)
	event.CmrsSetRef(-150.14, 15.05, -994.77)
	helper_6dfa44e2(15)
	if vm.skipping() then
		return skip(18)
	end
	event.ObjsSetMotion(1, "会話", 6)
	event.ObjsNextMotion(1, "立ち", 4)
	event.ObjsSetMotion(0, "右向く", 6)
	event.ObjsNextMotion(0, "右向くL", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_4be4f575(3400030)
	if vm.skipping() then
		return skip(19)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(1, "左向く", 6)
	event.ObjsNextMotion(1, "左向くL", 4)
	event.ObjsSetMotion(0, "右向く会話", 2)
	event.ObjsNextMotion(0, "右向くL", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_4be4f575(3400040)
	if vm.skipping() then
		return skip(20)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(1, "左向くうなづき", 6)
	event.ObjsNextMotion(1, "左向くL", 4)
	helper_4be4f575(3400050)
	if vm.skipping() then
		return skip(21)
	end
	helper_6dfa44e2(15)
	if vm.skipping() then
		return skip(22)
	end
	event.SndSePlay(var4, 4)
	event.ObjsSetMotion(0, "立ち", 4)
	event.ObjsSetMotion(1, "立ち", 4)
	event.ObjsSetMotion(2, "立ちあがる", 1)
	event.ObjsSetMotion(2, "立ちあがる", 6)
	event.ObjsNextMotion(2, "立ち", 4)
	event.CmrsSetPos(-174.6, 3.67, -986.98)
	event.CmrsSetRef(-146.07, 14.84, -1024.36)
	helper_025d5797(3400060, -1)
	if vm.skipping() then
		return skip(23)
	end
	helper_6dfa44e2(30)
	if vm.skipping() then
		return skip(24)
	end
	event.CmrsSetPos(-153.96, 18.46, -1073.61)
	event.CmrsSetRef(-151.84, 23.17, -999.4)
	helper_6dfa44e2(60)
	if vm.skipping() then
		return skip(25)
	end
	event.ObjsSetMotion(2, "うなづく", 6)
	event.ObjsNextMotion(2, "立ち", 4)
	event.ObjsSetMotion(0, "うなづく", 6)
	event.ObjsNextMotion(0, "立ち", 4)
	event.ObjsSetMotion(1, "うなづく", 6)
	event.ObjsNextMotion(1, "立ち", 4)
	event.SndSePlay(var4, 5)
	event.SndSePlay(var4, 6)
	helper_4be4f575(3400070)
	if vm.skipping() then
		return skip(26)
	end
	helper_6dfa44e2(30)
	if vm.skipping() then
		return skip(27)
	end
	return part2()
end

--- Helper function.
local function helper_22464()
	local active_chr_no: s32 = 0
	local flag: s32 = 0
	local var2: any = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: s32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local var12: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	local var15: f32 = 0
	local var16: s32 = 0
	local active_chr_no_2: s32 = 0
	local flag_2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_73d6f64a(0, 21, 5, 256, 208)
			end
			if at <= 2 then
				helper_6dfa44e2(10)
			end
			return 0
		end
		if at <= 5 then
			if at <= 4 then
				helper_6dfa44e2(30)
			end
			return 1
		end
		if at <= 6 then
			var13 = vm.f32(vm.f32(vm.sin(vm.f32(3.14)) * 30.0) + var10)
			var14 = var11
			var15 = vm.f32(vm.f32(vm.cos(vm.f32(3.14)) * 30.0) + var12)
			var16 = 0
			var11 = vm.f32(var11 + 30.0)
			var16 = var16 + 1
		end
		if at <= 7 then
			helper_73d6f64a(0, -1, 5, 0, 0)
		end
		return 0
	end
	event.Initialize()
	event.ActchrSetDefMotion(0)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 2 or active_chr_no == 3 then
		event.SetMesWindowMode(0, 1)
		event.SetMesDrawspeed(0, 1)
		if active_chr_no == 2 then
			helper_73d6f64a(0, 20, 5, 256, 208)
			if vm.skipping() then
				return skip(1)
			end
		else
			helper_73d6f64a(0, 21, 5, 256, 208)
			if vm.skipping() then
				return skip(2)
			end
		end
		event.SetFadeOut(10)
		helper_6dfa44e2(10)
		if vm.skipping() then
			return skip(3)
		end
		event.SetCharaPos(0, 951.18, 106.54, 1509.16)
		event.SetCharaRot(0, 0.0, -3.13, 0.0)
		event.SetCameraPos(951.95, 133.23, 1642.83)
		event.SetCameraRef(951.18, 136.54, 1509.16)
		event.ResetCamera(0)
		event.SetFadeIn(10)
		event.Finish()
		return 0
	end
	flag = event.GetFlag(340) or flag
	if flag == 1 then
		var2 = helper_31a4c001(1, -1)
		if vm.skipping() then
			return skip(4)
		end
		event.EohSyncChara(0, 0)
		event.EohSetFootSoundId(0, 1)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		if var2 == 0 then
			event.SetFadeOut(30)
			helper_6dfa44e2(30)
			if vm.skipping() then
				return skip(5)
			end
			return 1
		else
			do
				local out1, out2, out3 = event.GetCharaPos(0)
				var3 = out1 or var3
				var4 = out2 or var4
				var5 = out3 or var5
			end
			var6 = vm.f32(vm.f32(vm.sin(vm.f32(3.14)) * 30.0) + var3)
			var7 = var4
			var8 = vm.f32(vm.f32(vm.cos(vm.f32(3.14)) * 30.0) + var5)
			event.ObjsMove(0, var6, var7, var8, 30, 1)
			event.ObjsReference(0, var6, var7, var8, 10)
			event.ObjsSetMotion(0, "歩き")
			var9 = 0
			while var9 < 30 do
				do
					local out1, out2, out3 = event.GetCharaPos(0)
					var3 = out1 or var3
					var4 = out2 or var4
					var5 = out3 or var5
				end
				var4 = vm.f32(var4 + 30.0)
				event.SetCameraRef(var3, var4, var5)
				var9 = var9 + 1
				if vm.wait() then
					return skip(6)
				end
			end
			event.ResetCamera(0)
			event.Finish()
		end
	else
		event.EohSyncChara(0, 0)
		event.EohSetFootSoundId(0, 1)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		do
			local out1, out2, out3 = event.GetCharaPos(0)
			var10 = out1 or var10
			var11 = out2 or var11
			var12 = out3 or var12
		end
		var13 = vm.f32(vm.f32(vm.sin(vm.f32(3.14)) * 30.0) + var10)
		var14 = var11
		var15 = vm.f32(vm.f32(vm.cos(vm.f32(3.14)) * 30.0) + var12)
		event.ObjsMove(0, var13, var14, var15, 30, 1)
		event.ObjsReference(0, var13, var14, var15, 10)
		event.ObjsSetMotion(0, "歩き")
		event.ObjsMotionDelay(0, 30)
		event.ObjsSetMotion(0, "立ち")
		var16 = 0
		while var16 < 30 do
			do
				local out1, out2, out3 = event.GetCharaPos(0)
				var10 = out1 or var10
				var11 = out2 or var11
				var12 = out3 or var12
			end
			var11 = vm.f32(var11 + 30.0)
			event.SetCameraRef(var10, var11, var12)
			var16 = var16 + 1
			if vm.wait() then
				return skip(7)
			end
		end
		event.ResetCamera(0)
		active_chr_no_2 = event.GetActiveChrNo() or active_chr_no_2
		event.SetMesWindowMode(0, 1)
		event.SetMesDrawspeed(0, 0)
		event.SetMesShippo(0, 0)
		flag_2 = event.GetFlag(330) or flag_2
		if flag_2 == 0 then
			if active_chr_no_2 == 0 then
				event.MesMake_2(
					0,
					"リンが心配だね。\n今は、これ以上先に行くのは、\nやめておこう。"
				)
			else
				event.MesMake_2(
					0,
					"リンが心配ね。\n今は、これ以上先に行くのは、\nやめておいた方がいいわ。"
				)
			end
		elseif active_chr_no_2 == 0 then
			event.MesMake_2(
				0,
				"ねぇモニカ、神木のところで\nすこし休まない？\nリンも疲れてると思うし・・・"
			)
		else
			event.MesMake_2(
				0,
				"ねぇユリス、神木のところで\nちょっと休まない？\nリンも疲れてると思うし・・・"
			)
		end
		helper_73d6f64a(0, -1, 5, 0, 0)
		if vm.skipping() then
			return skip(8)
		end
		event.SetMesShippo(0, 1)
		event.Finish()
	end
	return 0
end

--- Helper function.
local function helper_6060(arg0: any, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_29a88422(1)
		end
		if at <= 2 then
			helper_9d5ade37(0, arg1)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.StreamOpen3(1, arg0)
	helper_29a88422(1)
	if vm.skipping() then
		return skip(2)
	end
	event.StreamPlay(1)
	helper_9d5ade37(0, arg1)
	if vm.skipping() then
		return skip(3)
	end
	event.StreamClose(1)
end

--- Helper function.
local function helper_defc(arg0: any, arg1: any)
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
		if at <= 15 then
			if at <= 1 then
				helper_3a74ecc4()
			end
			if at <= 2 then
				helper_6dfa44e2(30)
			end
			if at <= 3 then
				helper_6060(arg1, -1)
			end
			if at <= 4 then
				helper_6dfa44e2(10)
			end
			if at <= 5 then
				helper_6dfa44e2(30)
			end
			if at <= 6 then
				helper_6dfa44e2(120)
			end
			if at <= 7 then
				local _ = helper_7841320d(0)
			end
			if at <= 8 then
				helper_585b7236(1)
			end
			if at <= 9 then
				helper_585b7236(4)
			end
			if at <= 10 then
				helper_585b7236(active_chr_no)
			end
			if at <= 11 then
				helper_585b7236(1)
			end
			if at <= 12 then
				helper_6dfa44e2(30)
			end
			if at <= 14 then
				helper_6dfa44e2(30)
			end
			return 1
		end
		print("---------------------------------------------DEAD RELOAD_BGM = ", load_no, "\n")
		print("---------------------------------------------BOSS BATTLE = ", boss_map, "\n")
		print("---------------------------------------------PAUSE BATTLE BGM = ", var2, "\n")
		print("---------------------------------------------BATTLE BGM PLAY\n")
		return 0
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
	helper_6dfa44e2(30)
	if vm.skipping() then
		return skip(1)
	end
	event.SetStatusbarShow(0, 0.06666667)
	helper_3a74ecc4()
	if vm.skipping() then
		return skip(2)
	end
	event.LoadBgmPack(60)
	if var8 == 1 or var8 ~= 1 and arg1 < 0 then
		event.PlayBgm(0)
	end
	helper_6dfa44e2(30)
	if vm.skipping() then
		return skip(3)
	end
	event.DngPause(1, 1)
	event.DngCollisionAllClr()
	if var8 ~= 1 then
		block = event.LoadImg_4(5, "textures/dungeon/image/gameover.json", 1) or block
		if arg1 >= 0 then
			helper_6060(arg1, -1)
			if vm.skipping() then
				return skip(4)
			end
			helper_6dfa44e2(10)
			if vm.skipping() then
				return skip(5)
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
		helper_6dfa44e2(30)
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
		helper_6dfa44e2(120)
		if vm.skipping() then
			return skip(7)
		end
		while true do
			if helper_7841320d(0) ~= 0 then
				break
			end
			if vm.wait() then
				return skip(8)
			end
		end
	elseif active_chr_no == 3 then
		var10 = event.CheckEnableCharaChange(1) or var10
		if var10 == 0 then
			helper_585b7236(1)
			if vm.skipping() then
				return skip(9)
			end
		else
			helper_585b7236(4)
			if vm.skipping() then
				return skip(10)
			end
		end
	elseif active_chr_no == 0 or active_chr_no == 2 then
		helper_585b7236(active_chr_no)
		if vm.skipping() then
			return skip(11)
		end
	else
		helper_585b7236(1)
		if vm.skipping() then
			return skip(12)
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
		helper_6dfa44e2(30)
		if vm.skipping() then
			return skip(13)
		end
		if active_chr_no == 2 then
			event.EsmClear()
		end
		event.MenuCharaChenge(-1)
		if vm.wait() then
			return skip(14)
		end
		event.SetFadeOut(0)
	else
		event.FadeOutBgm(30)
		event.SetFadeOut(30)
		helper_6dfa44e2(30)
		if vm.skipping() then
			return skip(15)
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
	helper_6dfa44e2(4)
	if vm.skipping() then
		return skip(16)
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
local function helper_101c8(arg0: s32)
	return helper_defc(arg0, -1)
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

script[99] = program_99

--- Program 100.
script[100] = function()
	local flag: s32 = 0
	local flag_2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_18ac(0.0, 0.0, -600.0, vm.f32(3.14))
			helper_23ba0(1)
			return
		end
		helper_18ac(-1306.0, vm.f32(200.39), -546.0, vm.f32(1.88))
		helper_23ba0(1)
	end
	event.Initialize()
	program_99()
	event.SetFadeOut(0)
	flag = event.GetFlag(300) or flag
	flag_2 = event.GetFlag(332) or flag_2
	if flag == 1 then
		if flag_2 == 0 then
			helper_116a4()
			if vm.skipping() then
				return skip(1)
			end
			helper_18ac(0.0, 0.0, -600.0, vm.f32(3.14))
			event.SetCameraRef(0.0, 30.0, -600.0)
			event.SetCameraPos(0.0, 40.0, -480.0)
			event.ResetCamera(0)
			helper_23ba0(1)
			event.SetFadeIn(20)
			event.Finish()
			return
		else
			helper_217cc()
			if vm.skipping() then
				return skip(2)
			end
		end
	end
	helper_18ac(-1306.0, vm.f32(200.39), -546.0, vm.f32(1.88))
	event.SetCameraPos(-1182.17, 240.83, -585.56)
	event.SetCameraRef(-1306.0, 230.83, -546.0)
	event.ResetCamera(0)
	helper_23ba0(1)
	event.SetFadeIn(20)
	event.Finish()
end

--- Program 150.
script[150] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_1646c()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 500.
script[500] = function()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_1f5f0()
			if not vm.skipping() then
				return part2()
			end
		end
		helper_4d0c9edd(vm.f32(-65.93), 0.0, vm.f32(-944.95), vm.f32(1.07))
		helper_23ba0(1)
	end
	function part2()
		event.PlayBgm(0)
		helper_4d0c9edd(vm.f32(-65.93), 0.0, vm.f32(-944.95), vm.f32(1.07))
		event.SetCameraPos(-175.81, 28.77, -1006.32)
		event.SetCameraRef(-65.93, 30.0, -944.95)
		event.ResetCamera(0)
		helper_23ba0(1)
		event.SetFadeIn(30)
		event.Finish()
	end
	event.Initialize()
	event.ActchrSetDefMotion(0)
	event.SetFadeOut(30)
	helper_6dfa44e2(30)
	if vm.skipping() then
		return skip(1)
	end
	event.DelMonster(-1)
	event.SetBitCtrl(1, 0)
	event.EohSyncObj(0, "p01_s18", "s18_02-a0")
	event.EohSetShow(0, 0)
	helper_1f5f0()
	if vm.skipping() then
		return skip(2)
	end
	return part2()
end

--- Program 502.
script[502] = function()
	local stage_id: s32 = 0
	local var1: s32 = 0
	local argc: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		helper_23ba0(0)
	end
	local t0 = helper_22464()
	if vm.skipping() then
		return skip(1)
	end
	if t0 ~= 0 then
		helper_23ba0(0)
		stage_id = event.DngGetStageId() or stage_id
		var1 = event.DngGetFloorId() or var1
		argc = event.GetNextFloor(var1, 0) or argc
		event.DngSetFloorId(argc)
		event.SetFloorInfo(stage_id, var1, 5, 2)
		event.SetFloorInfo(stage_id, argc, 5, 1)
		event.SetCharaPos(0, 0.0, 0.0, 0.0)
		event.LoadScript("d03/d03.stb", 1000)
		return
	end
end

--- Program 510.
script[510] = function()
	local active_chr_no: s32 = 0
	local var1: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_23ba0(0)
			helper_1646c()
			if not vm.skipping() then
				return part2()
			end
		end
		if at <= 2 then
			helper_6dfa44e2(4)
		end
		helper_18ac(0.0, 0.0, -100.0, 0.0)
	end
	function part2()
		event.SetBitCtrl(1, 1)
		event.EohSyncObj(30, "p01_s18", "s18_02-a0")
		event.EohSetShow(30, 1)
		var1 = event.GetBgmNo() or var1
		if var1 ~= 190 then
			event.StopBgm(0)
			helper_6dfa44e2(4)
			if vm.skipping() then
				return skip(3)
			end
			event.LoadBgm(190)
		end
		event.PlayBgm(0)
		event.LoadMonsterFile(68, 1)
		event.AutoSetMonster(68, 0.0, 0.0, 0.0, 0.0, 3.14, 0.0)
		helper_18ac(0.0, 0.0, -100.0, 0.0)
		event.SetCameraRef(0.0, 30.0, -100.0)
		event.SetCameraPos(0.0, 40.0, -220.0)
		event.ResetCamera(0)
		event.SetFadeIn(30)
		event.Finish()
	end
	event.Initialize()
	event.ActchrSetDefMotion(0)
	event.SetFadeOut(30)
	helper_6dfa44e2(30)
	if vm.skipping() then
		return skip(1)
	end
	helper_23ba0(0)
	event.FuncPointShow("", "e336", 0)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 2 then
		event.DngSetupMainUnit(0)
	end
	if active_chr_no == 3 then
		event.DngSetupMainUnit(1)
	end
	helper_1646c()
	if vm.skipping() then
		return skip(2)
	end
	return part2()
end

--- Program 520.
script[520] = function()
	local active_chr_no: s32 = 0
	local var1: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_73d6f64a(0, 22, 5, 256, 208)
			end
			if at <= 2 then
				helper_73d6f64a(0, 23, 5, 256, 208)
			end
			return
		end
		if at <= 4 then
			helper_6dfa44e2(30)
		end
		helper_23ba0(0)
	end
	event.Initialize()
	if vm.wait() then
		return skip(1)
	end
	event.ActchrSetDefMotion(0)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 2 or active_chr_no == 3 then
		event.SetMesWindowMode(0, 1)
		event.SetMesDrawspeed(0, 1)
		if active_chr_no == 2 then
			helper_73d6f64a(0, 22, 5, 256, 208)
			if vm.skipping() then
				return skip(2)
			end
		else
			helper_73d6f64a(0, 23, 5, 256, 208)
			if vm.skipping() then
				return skip(3)
			end
		end
		event.Finish()
		return
	end
	var1 = helper_31a4c001(2, -1)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMesWindowMode(0, 1)
	event.SetMesDrawspeed(0, 0)
	if var1 == 0 then
		event.SetFadeOut(30)
		helper_6dfa44e2(30)
		if vm.skipping() then
			return skip(5)
		end
		helper_23ba0(0)
		event.LoadScript("d03/d03.stb", 1000)
		return
	end
	event.Finish()
end

--- Program 1200.
script[1200] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_101c8(0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 13320.
script[13320] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetFadeOut(0)
	helper_116a4()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 13360.
script[13360] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetFadeOut(0)
	helper_1646c()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 13400.
script[13400] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetFadeOut(0)
	helper_1f5f0()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 23020.
script[23020] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		helper_18ac(0.0, 0.0, -100.0, 0.0)
	end
	event.Initialize()
	event.SetFadeOut(0)
	event.StopBgm(0)
	helper_6dfa44e2(4)
	if vm.skipping() then
		return skip(1)
	end
	event.LoadBgm(190)
	event.PlayBgm(0)
	event.LoadMonsterFile(68, 1)
	event.AutoSetMonster(68, 0.0, 0.0, 0.0, 0.0, 3.14, 0.0)
	helper_18ac(0.0, 0.0, -100.0, 0.0)
	event.SetCameraRef(0.0, 30.0, -100.0)
	event.SetCameraPos(0.0, 40.0, -220.0)
	event.ResetCamera(0)
	event.SetFadeIn(30)
	event.Finish()
end

return script
