--!strict
-- map/s/s30/s30_2.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0c95681b = require("@lib/event/helper_0c95681b")
local helper_0e678234 = require("@lib/event/helper_0e678234")
local helper_278438ff = require("@lib/event/helper_278438ff")
local helper_2ddedb3b = require("@lib/event/helper_2ddedb3b")
local helper_40fdc4db = require("@lib/event/helper_40fdc4db")
local helper_41b952e8 = require("@lib/event/helper_41b952e8")
local helper_85ab2618 = require("@lib/event/helper_85ab2618")
local helper_94f2e77c = require("@lib/event/helper_94f2e77c")
local helper_9dafbc83 = require("@lib/event/helper_9dafbc83")
local helper_b5328081 = require("@lib/event/helper_b5328081")
local helper_c776923d = require("@lib/event/helper_c776923d")
local helper_d08f674a = require("@lib/event/helper_d08f674a")
local helper_d54ddd83 = require("@lib/event/helper_d54ddd83")
local helper_ecb662ce = require("@lib/event/helper_ecb662ce")
local helper_f8047a1c = require("@lib/event/helper_f8047a1c")

--- Program 99.
local function program_99()
	helper_278438ff()
end

--- Helper function.
local function helper_2fb54(arg0: any)
	local var1: s32 = 0
	local var2: any = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
		if at <= 2 then
			helper_0c95681b(30)
		end
		if at <= 3 then
			helper_0c95681b(15)
		end
	end
	event.Initialize()
	event.SetMotion(0, "立ち")
	event.SetMesWindowMode(0, 4)
	event.SetMesQuestionGyou(0, 1)
	event.SetMesEtc(0, 0, 1)
	event.SetMesEtc(0, 1, 1)
	event.MesMake_2(
		0,
		"Destination du t[UNI00e9]l[UNI00e9]porteur ?\nT[UNI00e9]l[UNI00e9]porteur - Nord\nT[UNI00e9]l[UNI00e9]porteur - Est\nT[UNI00e9]l[UNI00e9]porteur - Ouest\nDevant la Porte temporelle"
	)
	var1 = 4
	var2 = helper_c776923d(0, -1, 8, 0, 0, var1, 1)
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesQuestionGyou(0, 0)
	event.SetMesEtc(0, 0, 0)
	event.SetMesEtc(0, 1, 0)
	if var2 == -1 then
		return
	end
	if vm.wrap(var2 - 1) ~= 1 and vm.wrap(var2 - 1) ~= 2 and vm.wrap(var2 - 1) ~= 3 and vm.wrap(var2 - 1) ~= 0 then
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
		var3 = out1 or var3
		var4 = out2 or var4
		var5 = out3 or var5
	end
	event.EsmSetVect1(var3, var4, var5)
	var6 = event.GetSndId(2) or var6
	event.SndSePlay(var6, 120)
	helper_0c95681b(15)
	if vm.skipping() then
		return skip(2)
	end
	event.SetCharaShow(0, 0, 1, 0.05)
	event.SetCharaShow(1, 0, 1, 0.05)
	event.SetCharaShow(2, 0, 1, 0.05)
	event.SetCharaShow(3, 0, 1, 0.05)
	helper_0c95681b(30)
	if vm.skipping() then
		return skip(3)
	end
	event.SetFadeOut(15)
	helper_0c95681b(15)
	if vm.skipping() then
		return skip(4)
	end
	event.EsmClear()
	event.SetCharaShow(0, 1)
	event.SetCharaShow(1, 1)
	event.SetCharaShow(2, 1)
	event.SetCharaShow(3, 1)
	event.SetCnt(18, vm.wrap(var2 - 1))
	event.MapJump(-1, "f04")
	if vm.wait() then
		return skip(5)
	end
end

--- Helper function.
local function helper_16cb8()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			if vm.skip_end() then
				return skip(2)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.CharaActive(0)
		event.SetStatus(1, 0, 256, 0)
		event.DeleteChara(32)
		event.LoadMes(0, -1)
	end
	event.SetFlag(540, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.AssignStack(5)
	event.ClearStack(5)
	event.GetActiveChrNo()
	event.SetStatus(1, 0, 256, 1)
	event.ChangeDir("event/e500/e540/")
	event.LoadMes(0, 5, "e540_1.txt")
	event.CharaActive(0, 0)
	event.LoadChara(5, "e540_phorn.gltf", "info", 32)
	event.CharaActive(32)
	event.EohSyncChara(0, 32)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ChangeDir("")
	event.EohSyncObj(1, "p04_s30")
	event.EohSetShow(1, 0)
	event.EohSyncObj(2, "p05_s30")
	event.EohSetShow(2, 0)
	event.EohSetPos(0, 0.0, 70.1, -10.0)
	event.EohSetRot(0, 0.0, 0.0, 0.0)
	event.EohSetMotion(0, "立ち", 4)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "目パチ")
	event.InitDramaScene()
	event.CmrsInit()
	event.CmrsSetRef(0.0, 173.0, -75.0)
	event.CmrsSetAhd(-2.7, 0.0, 10.0)
	event.CmrsMoveAhd(2.7, 0.0, 10.0, 120)
	event.CmrsQuake(0.0, 0.5, 0.0, -1)
	event.SetFadeIn(10)
	helper_0c95681b(120)
	if vm.skipping() then
		return skip(1)
	end
	event.SetFadeOut(0)
	return part2()
end

--- Helper function.
local function helper_17500()
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 17 then
			if at <= 1 then
				helper_0c95681b(30)
			end
			if at <= 2 then
				helper_f8047a1c(5400050)
			end
			if at <= 3 then
				helper_f8047a1c(5400060)
			end
			if at <= 4 then
				helper_2ddedb3b(2)
			end
			if at <= 5 then
				helper_f8047a1c(5400070)
			end
			if at <= 6 then
				helper_f8047a1c(5400080)
			end
			if at <= 7 then
				helper_2ddedb3b(2)
			end
			if at <= 8 then
				helper_f8047a1c(5400085)
			end
			if at <= 9 then
				helper_f8047a1c(5400090)
			end
			if at <= 10 then
				helper_2ddedb3b(1)
			end
			if at <= 11 then
				helper_f8047a1c(5400100)
			end
			if at <= 12 then
				helper_2ddedb3b(2)
			end
			if at <= 13 then
				helper_2ddedb3b(2)
			end
			if at <= 14 then
				helper_f8047a1c(5400105)
			end
			if at <= 15 then
				helper_f8047a1c(5400110)
			end
			if at <= 16 then
				helper_0c95681b(10)
			end
			if vm.skip_end() then
				return skip(18)
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
		event.SetStatus(1, 0, 8, 0)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.DelExtMotion(0)
		event.DeleteChara(32)
		event.DeleteChara(33)
		event.DeleteChara(34)
		event.DeleteChara(35)
		event.DeleteChara(36)
		event.DeleteChara(37)
		event.DeleteChara(38)
		event.DeleteChara(39)
		event.DeleteChara(40)
		event.DeleteChara(41)
		event.LoadMes(0, -1)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFlag(540, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.SndLoadSound(5513)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.SetStatus(1, 0, 256, 1)
	event.SetStatus(1, 0, 8, 1)
	event.ChangeDir("event/e500/e540/")
	event.LoadMes(0, 5, "e540_1.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e540_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e540_monica.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.LoadChara(5, "e540_phorn.gltf", "info", 34)
	event.CharaActive(34)
	event.SetStatus(1, 34, 8, 1)
	event.EohSyncChara(2, 34)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.LoadChara(5, "e540_puzzhei.gltf", "info", 35)
	event.CharaActive(35)
	event.EohSyncChara(3, 35)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.CopyChara(5, 35, 36)
	event.CharaActive(36)
	event.EohSyncChara(4, 36)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.CopyChara(5, 35, 37)
	event.CharaActive(37)
	event.EohSyncChara(5, 37)
	event.ObjsInit(5)
	event.ObjsSyncObj(5, 5)
	event.CopyChara(5, 35, 38)
	event.CharaActive(38)
	event.EohSyncChara(6, 38)
	event.ObjsInit(6)
	event.ObjsSyncObj(6, 6)
	event.CopyChara(5, 35, 39)
	event.CharaActive(39)
	event.EohSyncChara(7, 39)
	event.ObjsInit(7)
	event.ObjsSyncObj(7, 7)
	event.CopyChara(5, 35, 40)
	event.CharaActive(40)
	event.EohSyncChara(8, 40)
	event.ObjsInit(8)
	event.ObjsSyncObj(8, 8)
	event.CopyChara(5, 35, 41)
	event.CharaActive(41)
	event.EohSyncChara(9, 41)
	event.ObjsInit(9)
	event.ObjsSyncObj(9, 9)
	event.ChangeDir("")
	if active_chr_no == 1 then
		event.LoadChara(5, "chara/c01_base.gltf", "info", 32)
		event.LoadEquip(5, 0, 4, "info", 32)
		event.LoadEquip(5, 0, 3, "info", 32)
		event.LoadEquip(5, 0, 2, "info", 32, 33)
		event.LoadMotion(5, "event/e500/e540/e540_mints.gltf", "info", 32)
		event.EohSyncChara(0, 32)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	else
		event.LoadChara(5, "chara/c02_base.gltf", "info", 32)
		event.LoadEquip(5, 1, 4, "info", 32)
		event.LoadEquip(5, 1, 3, "info", 32)
		event.LoadEquip(5, 1, 2, "info", 32, 33)
		event.LoadMotion(5, "event/e500/e540/e540_monica.gltf", "info", 32)
		event.EohSyncChara(1, 32)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.CharaActive(32)
	event.CharaActive(33)
	event.SetStatus(1, 32, 8, 1)
	event.EohSyncObj(10, "p04_s30")
	event.EohSetShow(10, 1)
	event.EohSyncObj(11, "p05_s30")
	event.EohSetShow(11, 1)
	event.EohSetPos(0, 80.0, 70.1, 20.0)
	event.EohSetRot(0, 0.0, 0.0, 0.0)
	event.EohSetMotion(0, "立ち", 4)
	event.EohNormalDrive(0)
	event.EohSetMotion(0, "ホーン王見立ち", 4)
	event.EohSetPos(1, 64.0, 70.1, 20.0)
	event.EohSetRot(1, 0.0, 0.0, 0.0)
	event.EohSetMotion(1, "立ち", 4)
	event.EohNormalDrive(1)
	event.EohSetMotion(1, "ドナ見", 4)
	event.EohSetPos(2, 100.0, 70.1, 20.0)
	event.EohSetRot(2, 0.0, 0.0, 0.0)
	event.EohSetMotion(2, "立ち（腕組み）", 4)
	event.EohSetShadow(3, 0)
	event.EohSetPos(3, 0.0, 1.0, 361.0)
	event.EohSetRot(3, 0.0, 0.0, 0.0)
	event.EohSetMotion(3, "座り", 4)
	event.EohSetShadow(4, 0)
	event.EohSetPos(4, 80.0, 1.0, 361.0)
	event.EohSetRot(4, 0.0, 0.0, 0.0)
	event.EohSetMotion(4, "座り", 4)
	event.EohSetShadow(5, 0)
	event.EohSetPos(5, -80.0, 1.0, 361.0)
	event.EohSetRot(5, 0.0, 0.0, 0.0)
	event.EohSetMotion(5, "座り", 4)
	event.EohSetShadow(6, 0)
	event.EohSetPos(6, 160.0, 1.0, 361.0)
	event.EohSetRot(6, 0.0, 0.0, 0.0)
	event.EohSetMotion(6, "座り2", 4)
	event.EohSetShadow(7, 0)
	event.EohSetPos(7, -160.0, 1.0, 361.0)
	event.EohSetRot(7, 0.0, 0.0, 0.0)
	event.EohSetMotion(7, "座り", 4)
	event.EohSetShadow(8, 0)
	event.EohSetPos(8, -228.0, 1.0, 316.0)
	event.EohSetRot(8, 0.0, -1.0, 0.0)
	event.EohSetMotion(8, "座り2", 4)
	event.EohSetShadow(9, 0)
	event.EohSetPos(9, 228.0, 1.0, 316.0)
	event.EohSetRot(9, 0.0, 1.0, 0.0)
	event.EohSetMotion(9, "座り", 4)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "おこり顔")
	event.EohSetTexAnim(0, 1, "おこり目パチ")
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "ひき顔")
	event.EohSetTexAnim(1, 1, "ひき目パチ")
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "目パチ")
	event.EohSetTexAnim(3, 0)
	event.EohSetTexAnim(3, 1, "目パチ")
	event.EohSetTexAnim(4, 0)
	event.EohSetTexAnim(4, 1, "目パチ")
	event.EohSetTexAnim(5, 0)
	event.EohSetTexAnim(5, 1, "目パチ")
	event.EohSetTexAnim(6, 0)
	event.EohSetTexAnim(6, 1, "目パチ")
	event.EohSetTexAnim(7, 0)
	event.EohSetTexAnim(7, 1, "目パチ")
	event.EohSetTexAnim(8, 0)
	event.EohSetTexAnim(8, 1, "目パチ")
	event.EohSetTexAnim(9, 0)
	event.EohSetTexAnim(9, 1, "目パチ")
	event.InitDramaScene()
	event.CharaActive(0, 0)
	event.CharaActive(0, 32)
	event.CharaActive(0, 33)
	event.CharaActive(0, 34)
	event.CmrsInit()
	event.CmrsSetPos(41.57, 84.34, 48.91)
	event.CmrsSetRef(82.14, 93.76, 16.53)
	event.SetFadeIn(0)
	event.CharaActive(1, 0)
	event.CharaActive(1, 32)
	event.CharaActive(1, 33)
	event.CharaActive(1, 34)
	helper_0c95681b(30)
	if vm.skipping() then
		return skip(2)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_f8047a1c(5400050)
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsSetMotion(2, "会話（腕組み）", 2)
	event.ObjsNextMotion(2, "立ち（腕組み）", 4)
	event.SetPakuAnim(2, "口パク")
	helper_f8047a1c(5400060)
	if vm.skipping() then
		return skip(4)
	end
	helper_2ddedb3b(2)
	if vm.skipping() then
		return skip(5)
	end
	event.SetPakuAnim(0, "通常口パク")
	helper_f8047a1c(5400070)
	if vm.skipping() then
		return skip(6)
	end
	event.ObjsSetMotion(2, "二人見る", 2)
	event.ObjsNextMotion(2, "二人見る（会話）", 6)
	event.ObjsNextMotion(2, "二人見るループ", 4)
	event.SetPakuAnim(2, "口パク")
	helper_f8047a1c(5400080)
	if vm.skipping() then
		return skip(7)
	end
	helper_2ddedb3b(2)
	if vm.skipping() then
		return skip(8)
	end
	event.SetPakuAnim(2, "口パク")
	helper_f8047a1c(5400085)
	if vm.skipping() then
		return skip(9)
	end
	event.ObjsSetMotion(1, "ドナ見左", 2)
	event.ObjsNextMotion(1, "ドナ見左L", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_f8047a1c(5400090)
	if vm.skipping() then
		return skip(10)
	end
	helper_2ddedb3b(1)
	if vm.skipping() then
		return skip(11)
	end
	event.CmrsSetPos(100.0, 86.37, 61.52)
	event.CmrsSetRef(100.0, 95.95, 20.56)
	event.ObjsSetMotion(2, "二人見る戻り", 6)
	event.ObjsNextMotion(2, "立ち（腕組み）", 4)
	event.SetPakuAnim(2, "口パク")
	helper_f8047a1c(5400100)
	if vm.skipping() then
		return skip(12)
	end
	helper_2ddedb3b(2)
	if vm.skipping() then
		return skip(13)
	end
	event.ObjsSetMotion(2, "兵を見る", 6)
	event.ObjsNextMotion(2, "兵を見るループ", 4)
	helper_2ddedb3b(2)
	if vm.skipping() then
		return skip(14)
	end
	event.SetPakuAnim(2, "口パク")
	helper_f8047a1c(5400105)
	if vm.skipping() then
		return skip(15)
	end
	event.CmrsSetPos(289.77, 38.76, 341.39)
	event.CmrsSetRef(255.07, 40.17, 231.65)
	event.EohSetPos(3, 269.0, 1.0, 246.0)
	event.EohSetRot(3, 0.0, 1.0, 0.0)
	event.EohSetMotion(3, "座り", 4)
	event.EohSetShadow(4, 0)
	event.EohSetPos(4, 303.0, 1.0, 176.0)
	event.EohSetRot(4, 0.0, 1.0, 0.0)
	event.EohSetMotion(4, "座り2", 4)
	event.EohSetShadow(5, 0)
	event.EohSetPos(5, 346.0, 1.0, 104.0)
	event.EohSetRot(5, 0.0, 1.0, 0.0)
	event.EohSetMotion(5, "座り", 4)
	event.SetPakuAnim(4, "口パク")
	helper_f8047a1c(5400110)
	if vm.skipping() then
		return skip(16)
	end
	event.SetFadeOut(10)
	helper_0c95681b(10)
	if vm.skipping() then
		return skip(17)
	end
	return part2()
end

--- Helper function.
local function helper_1a948()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 8 then
			if at <= 1 then
				helper_0c95681b(10)
			end
			if at <= 2 then
				helper_f8047a1c(5400120)
			end
			if at <= 3 then
				helper_f8047a1c(5400130)
			end
			if at <= 4 then
				helper_2ddedb3b(3)
			end
			if at <= 5 then
				helper_f8047a1c(5400140)
			end
			if at <= 6 then
				helper_2ddedb3b(2)
			end
			if at <= 7 then
				helper_0c95681b(10)
			end
			if vm.skip_end() then
				return skip(9)
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
		event.LoadMes(0, -1)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFlag(540, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.LoadSound(5513)
	var0 = event.SndLoadSound(5513) or var0
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.SetStatus(1, 0, 256, 1)
	event.ChangeDir("event/e500/e540/")
	event.LoadMes(0, 5, "e540_1.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e540_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e540_monica.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.LoadChara(5, "e540_phorn.gltf", "info", 34)
	event.CharaActive(34)
	event.EohSyncChara(2, 34)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.LoadChara(5, "e540_puzzhei.gltf", "info", 35)
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
		event.LoadMotion(5, "event/e500/e540/e540_mints.gltf", "info", 32)
		event.EohSyncChara(0, 32)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	else
		event.LoadChara(5, "chara/c02_base.gltf", "info", 32)
		event.LoadEquip(5, 1, 4, "info", 32)
		event.LoadEquip(5, 1, 3, "info", 32)
		event.LoadEquip(5, 1, 2, "info", 32, 33)
		event.LoadMotion(5, "event/e500/e540/e540_monica.gltf", "info", 32)
		event.EohSyncChara(1, 32)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.CharaActive(32)
	event.CharaActive(33)
	event.EohSetPos(0, 80.0, 70.1, 20.0)
	event.EohSetRot(0, 0.0, 0.0, 0.0)
	event.EohSetMotion(0, "立ち", 4)
	event.EohNormalDrive(0)
	event.EohSetMotion(0, "ホーン王見立ち", 4)
	event.EohSetPos(1, 64.0, 70.1, 20.0)
	event.EohSetRot(1, 0.0, 0.0, 0.0)
	event.EohSetMotion(1, "立ち", 4)
	event.EohNormalDrive(1)
	event.EohSetMotion(1, "来る", 4)
	event.EohNormalDrive(1)
	event.EohResetDaPosition(1)
	event.EohSetPos(2, 100.0, 70.1, 20.0)
	event.EohSetRot(2, 0.0, 0.0, 0.0)
	event.EohSetMotion(2, "立ち（腕組み）", 4)
	event.EohSetShadow(3, 0)
	event.EohSetPos(3, 298.75, 0.0, 173.53)
	event.EohSetRot(3, 0.0, 1.0, 0.0)
	event.EohSetMotion(3, "座り", 4)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "おこり顔")
	event.EohSetTexAnim(0, 1, "おこり目パチ")
	event.EohSetTexAnim(0, 1, "半口")
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "おこり顔")
	event.EohSetTexAnim(1, 1, "おこり目パチ")
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "目パチ")
	event.EohSetTexAnim(3, 0)
	event.EohSetTexAnim(3, 1, "目パチ")
	event.InitDramaScene()
	event.CmrsInit()
	event.CmrsSetPos(40.32, 114.09, 55.71)
	event.CmrsSetRef(66.42, 86.67, 21.9)
	event.SetFadeIn(10)
	helper_0c95681b(10)
	if vm.skipping() then
		return skip(2)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_f8047a1c(5400120)
	if vm.skipping() then
		return skip(3)
	end
	event.CmrsSetPos(319.02, 26.29, 201.4)
	event.CmrsSetRef(272.55, 29.04, 150.57)
	event.SndSePlay(var0, 5)
	event.ObjsSetMotion(3, "座り（振り向く）", 6)
	event.ObjsNextMotion(3, "座りループ（振り向く）", 4)
	event.SetPakuAnim(3, "口パク")
	helper_f8047a1c(5400130)
	if vm.skipping() then
		return skip(4)
	end
	helper_2ddedb3b(3)
	if vm.skipping() then
		return skip(5)
	end
	event.CmrsSetPos(113.33, 100.73, 59.89)
	event.CmrsSetRef(100.22, 100.12, 18.03)
	event.CmrsMove2(109.46, 100.73, 47.52, 100.22, 100.12, 18.03, 60, 2, 1.0)
	event.ObjsSetMotion(2, "会話（腕組み）", 2)
	event.ObjsNextMotion(2, "立ち（腕組み）", 4)
	event.SetPakuAnim(2, "口パク")
	helper_f8047a1c(5400140)
	if vm.skipping() then
		return skip(6)
	end
	helper_2ddedb3b(2)
	if vm.skipping() then
		return skip(7)
	end
	event.SetFadeOut(10)
	helper_0c95681b(10)
	if vm.skipping() then
		return skip(8)
	end
	return part2()
end

--- Helper function.
local function helper_1c4e0()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 5 then
			if at <= 1 then
				helper_0c95681b(10)
			end
			if at <= 2 then
				helper_f8047a1c(5400150)
			end
			if at <= 3 then
				helper_2ddedb3b(2)
			end
			if at <= 4 then
				helper_0c95681b(10)
			end
			if vm.skip_end() then
				return skip(6)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
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
	if vm.skipping() then
		return skip(1)
	end
	event.SetFlag(540, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.LoadSound(5514)
	var0 = event.SndLoadSound(5514) or var0
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.SetStatus(1, 0, 256, 1)
	event.ChangeDir("event/e500/e540/")
	event.LoadMes(0, 5, "e540_1.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e540_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e540_monica.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.LoadChara(5, "e540_phorn.gltf", "info", 34)
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
		event.LoadMotion(5, "event/e500/e540/e540_mints.gltf", "info", 32)
		event.EohSyncChara(0, 32)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	else
		event.LoadChara(5, "chara/c02_base.gltf", "info", 32)
		event.LoadEquip(5, 1, 4, "info", 32)
		event.LoadEquip(5, 1, 3, "info", 32)
		event.LoadEquip(5, 1, 2, "info", 32, 33)
		event.LoadMotion(5, "event/e500/e540/e540_monica.gltf", "info", 32)
		event.EohSyncChara(1, 32)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.CharaActive(32)
	event.CharaActive(33)
	event.EohSetPos(0, 80.0, 70.1, 20.0)
	event.EohSetRot(0, 0.0, 0.0, 0.0)
	event.EohSetMotion(0, "立ち", 4)
	event.EohNormalDrive(0)
	event.EohSetMotion(0, "ホーン王見立ち", 4)
	event.EohSetPos(1, 64.0, 70.1, 20.0)
	event.EohSetRot(1, 0.0, 0.0, 0.0)
	event.EohSetMotion(1, "立ち", 4)
	event.EohNormalDrive(1)
	event.EohSetMotion(1, "来る", 4)
	event.EohNormalDrive(1)
	event.EohSetPos(2, 100.0, 70.1, 20.0)
	event.EohSetRot(2, 0.0, 0.0, 0.0)
	event.EohSetMotion(2, "立ち（腕組み）", 4)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "おこり顔")
	event.EohSetTexAnim(0, 1, "おこり目パチ")
	event.EohSetTexAnim(0, 1, "半口")
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "おこり顔")
	event.EohSetTexAnim(1, 1, "おこり目パチ")
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "目パチ")
	event.InitDramaScene()
	event.CmrsInit()
	event.CmrsSetPos(120.44, 85.35, 69.84)
	event.CmrsSetRef(99.94, 92.32, 25.03)
	event.SetFadeIn(10)
	helper_0c95681b(10)
	if vm.skipping() then
		return skip(2)
	end
	event.StopBgm(0)
	event.SndSePlay(var0, 6)
	event.ObjsSetMotion(2, "撃てぇ", 2)
	event.ObjsNextMotion(2, "撃てぇループ", 4)
	event.SetPakuAnim(2, "口パク")
	helper_f8047a1c(5400150)
	if vm.skipping() then
		return skip(3)
	end
	helper_2ddedb3b(2)
	if vm.skipping() then
		return skip(4)
	end
	event.SetFadeOut(10)
	helper_0c95681b(10)
	if vm.skipping() then
		return skip(5)
	end
	return part2()
end

--- Helper function.
local function helper_1daf0()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 23 then
			if at <= 1 then
				helper_0c95681b(30)
			end
			if at <= 2 then
				helper_0c95681b(10)
			end
			if at <= 3 then
				helper_0c95681b(6)
			end
			if at <= 4 then
				helper_2ddedb3b(6)
			end
			if at <= 5 then
				helper_f8047a1c(5400160)
			end
			if at <= 6 then
				helper_0c95681b(20)
			end
			if at <= 7 then
				helper_f8047a1c(5400170)
			end
			if at <= 8 then
				helper_2ddedb3b(3)
			end
			if at <= 9 then
				helper_0c95681b(6)
			end
			if at <= 10 then
				helper_f8047a1c(5400180)
			end
			if at <= 11 then
				helper_0c95681b(10)
			end
			if at <= 12 then
				helper_2ddedb3b(2)
			end
			if at <= 13 then
				helper_0c95681b(30)
			end
			if at <= 14 then
				helper_0c95681b(60)
			end
			if at <= 15 then
				helper_0c95681b(20)
			end
			if at <= 16 then
				helper_2ddedb3b(2)
			end
			if at <= 17 then
				helper_f8047a1c(5400190)
			end
			if at <= 18 then
				helper_f8047a1c(5400200)
			end
			if at <= 19 then
				helper_2ddedb3b(2)
			end
			if at <= 20 then
				helper_f8047a1c(5400210)
			end
			if at <= 21 then
				helper_f8047a1c(5400220)
			end
			if at <= 22 then
				helper_0c95681b(30)
			end
			if vm.skip_end() then
				return skip(24)
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
		event.DeleteChara(37)
		event.DeleteChara(38)
		event.LoadMes(0, -1)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFlag(540, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.LoadSound(5511)
	var0 = event.SndLoadSound(5511) or var0
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.SetStatus(1, 0, 256, 1)
	event.ChangeDir("event/e500/e540/")
	event.LoadMes(0, 5, "e540_1.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e540_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e540_monica.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.LoadChara(5, "e540_eina.gltf", "info", 34)
	event.CharaActive(0, 34)
	event.EohSyncChara(2, 34)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.LoadChara(5, "e540_phorn.gltf", "info", 35)
	event.CharaActive(35)
	event.EohSyncChara(3, 35)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.LoadChara(5, "e540_einahei.gltf", "info", 36)
	event.CharaActive(0, 36)
	event.EohSyncChara(4, 36)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.CopyChara(5, 36, 37)
	event.CharaActive(0, 37)
	event.EohSyncChara(5, 37)
	event.ObjsInit(5)
	event.ObjsSyncObj(5, 5)
	event.LoadChara(5, "e540_puzzhei.gltf", "info", 38)
	event.CharaActive(38)
	event.EohSyncChara(6, 38)
	event.ObjsInit(6)
	event.ObjsSyncObj(6, 6)
	event.ChangeDir("")
	if active_chr_no == 1 then
		event.LoadChara(5, "chara/c01_base.gltf", "info", 32)
		event.LoadEquip(5, 0, 4, "info", 32)
		event.LoadEquip(5, 0, 3, "info", 32)
		event.LoadEquip(5, 0, 2, "info", 32, 33)
		event.LoadMotion(5, "event/e500/e540/e540_mints.gltf", "info", 32)
		event.EohSyncChara(0, 32)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	else
		event.LoadChara(5, "chara/c02_base.gltf", "info", 32)
		event.LoadEquip(5, 1, 4, "info", 32)
		event.LoadEquip(5, 1, 3, "info", 32)
		event.LoadEquip(5, 1, 2, "info", 32, 33)
		event.LoadMotion(5, "event/e500/e540/e540_monica.gltf", "info", 32)
		event.EohSyncChara(1, 32)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.CharaActive(32)
	event.CharaActive(33)
	event.EohSetPos(0, 68.35, 70.1, 3.9)
	event.EohSetRot(0, 0.0, 0.0, 0.0)
	event.EohSetMotion(0, "立ち", 4)
	event.EohNormalDrive(0)
	event.EohSetMotion(0, "ホーン王見立ち", 4)
	event.EohSetFootSoundId(0, 21)
	event.EohSetPos(1, 89.63, 70.1, 2.96)
	event.EohSetRot(1, 0.0, 0.24, 0.0)
	event.EohSetMotion(1, "ドナ見", 4)
	event.EohSetPos(2, 18.39, 70.1, -355.71)
	event.EohSetRot(2, 0.0, 0.44, 0.0)
	event.EohSetMotion(2, "立ち", 4)
	event.EohSetFootSoundId(2, 21)
	event.EohSetPos(3, 116.44, 70.1, -15.84)
	event.EohSetRot(3, 0.0, 0.56, 0.0)
	event.EohSetMotion(3, "立ち", 4)
	event.EohSetFootSoundId(3, 21)
	event.EohSetPos(6, 13.68, 70.1, -191.36)
	event.EohSetRot(6, 0.0, 0.48, 0.0)
	event.EohSetMotion(6, "立ち", 4)
	event.EohSetFootSoundId(6, 21)
	event.EohSetPos(4, 28.67, 70.1, -389.3)
	event.EohSetRot(4, 0.0, 0.44, 0.0)
	event.EohSetMotion(4, "立ち", 4)
	event.EohSetPos(5, -15.16, 70.1, -370.34)
	event.EohSetRot(5, 0.0, 0.44, 0.0)
	event.EohSetMotion(5, "立ち", 4)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "デフォルト顔")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "デフォルト顔")
	event.EohSetTexAnim(1, 1, "通常目パチ")
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "うれし顔")
	event.EohSetTexAnim(2, 1, "うれし目パチ")
	event.EohSetTexAnim(3, 0)
	event.EohSetTexAnim(3, 1, "目パチ")
	event.EohSetTexAnim(6, 0)
	event.EohSetTexAnim(6, 1, "目パチ")
	event.EohSetTexAnim(4, 0)
	event.EohSetTexAnim(4, 1, "目パチ")
	event.EohSetTexAnim(5, 0)
	event.EohSetTexAnim(5, 1, "目パチ")
	event.InitDramaScene()
	event.ObjsSetMotion(6, "走り", 4)
	event.ObjsMotionDelay(6, 50)
	event.ObjsSetMotion(6, "立ち")
	event.ObjsMove(6, 79.43, 70.1, -65.0, 50)
	event.CmrsInit()
	event.CmrsSetPos(214.84, 178.87, 41.98)
	event.CmrsSetRef(89.35, 79.16, -8.28)
	event.SetFadeIn(10)
	helper_0c95681b(30)
	if vm.skipping() then
		return skip(2)
	end
	event.ObjsSetMotion(3, "振り返る3", 6)
	event.ObjsNextMotion(3, "振り返り左L", 4)
	event.ObjsRotation(3, 0.0, -2.6, 0.0, 40)
	helper_0c95681b(10)
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsSetMotion(0, "左・振り返る", 6)
	event.ObjsNextMotion(0, "左・振り返るL", 4)
	helper_0c95681b(6)
	if vm.skipping() then
		return skip(4)
	end
	event.ObjsSetMotion(1, "振り返り左", 6)
	event.ObjsNextMotion(1, "振り返り左L", 4)
	helper_2ddedb3b(6)
	if vm.skipping() then
		return skip(5)
	end
	event.SetPakuAnim(6, "口パク")
	helper_f8047a1c(5400160)
	if vm.skipping() then
		return skip(6)
	end
	event.CmrsSetPos(195.0, 197.78, -163.62)
	event.CmrsSetRef(13.28, 67.8, -330.22)
	event.CharaActive(0, 38)
	event.CharaActive(34)
	event.CharaActive(36)
	event.CharaActive(37)
	event.ObjsSetPos(3, 92.67, 70.1, -212.11)
	event.ObjsSetRot(3, 0.0, -2.68, 0.0)
	event.ObjsSetMotion(3, "歩き", 4)
	event.ObjsMotionDelay(3, 60)
	event.ObjsSetMotion(3, "立ち")
	event.ObjsMove(3, 62.46, 70.1, -268.72, 60)
	event.ObjsSetMotion(2, "歩き", 4)
	event.ObjsMotionDelay(2, 50)
	event.ObjsSetMotion(2, "立ち")
	event.ObjsMove(2, 37.12, 70.1, -316.3, 50)
	event.ObjsSetMotion(4, "歩き", 4)
	event.ObjsMotionDelay(4, 30)
	event.ObjsSetMotion(4, "立ち")
	event.ObjsMove(4, 38.39, 70.1, -363.89, 30)
	event.ObjsSetMotion(5, "歩き", 4)
	event.ObjsMotionDelay(5, 30)
	event.ObjsSetMotion(5, "立ち")
	event.ObjsMove(5, -3.33, 70.1, -345.45, 30)
	helper_0c95681b(20)
	if vm.skipping() then
		return skip(7)
	end
	helper_f8047a1c(5400170)
	if vm.skipping() then
		return skip(8)
	end
	helper_2ddedb3b(3)
	if vm.skipping() then
		return skip(9)
	end
	helper_0c95681b(6)
	if vm.skipping() then
		return skip(10)
	end
	event.CmrsSetPos(40.24, 96.95, -350.23)
	event.CmrsSetRef(44.75, 91.93, -290.65)
	event.ObjsSetRot(2, 0.0, 0.56, 0.0)
	event.SetPakuAnim(2, "口パク")
	helper_f8047a1c(5400180)
	if vm.skipping() then
		return skip(11)
	end
	helper_0c95681b(10)
	if vm.skipping() then
		return skip(12)
	end
	event.ObjsSetMotion(2, "ユリスに気づく", 6)
	event.ObjsNextMotion(2, "ユリスに気づくL")
	helper_2ddedb3b(2)
	if vm.skipping() then
		return skip(13)
	end
	helper_0c95681b(30)
	if vm.skipping() then
		return skip(14)
	end
	event.SetCrossfade(30)
	event.CmrsSetPos(80.24, 84.75, -29.43)
	event.CmrsSetRef(66.39, 91.93, 3.38)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "うるうる顔")
	event.EohSetTexAnim(0, 1, "キラ目")
	event.EohSetTexAnim(0, 1, "半口")
	event.ObjsSetMotion(0, "立ち", 4, -1.0, 1)
	event.ObjsSetRot(0, 0.0, 3.12, 0.0)
	helper_0c95681b(60)
	if vm.skipping() then
		return skip(15)
	end
	event.ObjsSetMotion(0, "走り")
	event.ObjsMotionDelay(0, 14)
	event.ObjsSetMotion(0, "立ち")
	event.ObjsMove(0, 60.15, 70.1, -26.59, 14)
	helper_0c95681b(20)
	if vm.skipping() then
		return skip(16)
	end
	event.CmrsSetPos(85.11, 96.95, -273.25)
	event.CmrsSetRef(42.99, 87.73, -304.39)
	event.CharaActive(0, 35)
	event.ObjsSetPos(0, 60.41, 70.1, -250.13)
	event.ObjsSetRot(0, 0.0, -2.72, 0.0)
	event.ObjsMove(0, 37.51, 70.1, -302.81, 24)
	event.ObjsSetMotion(0, "走り", 4, -1.0, 1)
	event.ObjsNextMotion(0, "抱き合う", 6)
	event.ObjsNextMotion(0, "抱き合うL", 4)
	event.ObjsSeDelay(0, 20)
	event.ObjsSePlay(0, var0, 7)
	event.ObjsSetPos(2, 37.51, 70.1, -302.81)
	event.ObjsSetRot(2, 0.0, -2.72, 0.0)
	event.ObjsSetMotion(2, "立ち2", 4)
	event.ObjsMotionDelay(2, 20)
	event.ObjsSetMotion(2, "抱き合う", 6)
	event.ObjsNextMotion(2, "抱き合うL", 4)
	helper_2ddedb3b(2)
	if vm.skipping() then
		return skip(17)
	end
	event.SetPakuAnim(2, "わらい口パク")
	helper_f8047a1c(5400190)
	if vm.skipping() then
		return skip(18)
	end
	helper_f8047a1c(5400200)
	if vm.skipping() then
		return skip(19)
	end
	event.ObjsSetMotion(0, "見つめ合う", 6)
	event.ObjsNextMotion(0, "見つめ合うL", 4)
	event.ObjsSetMotion(2, "見つめ合う", 6)
	event.ObjsNextMotion(2, "見つめ合うL", 4)
	helper_2ddedb3b(2)
	if vm.skipping() then
		return skip(20)
	end
	event.SetPakuAnim(2, "わらい口パク")
	helper_f8047a1c(5400210)
	if vm.skipping() then
		return skip(21)
	end
	event.CmrsSetPos(27.34, 99.88, -328.08)
	event.CmrsSetRef(33.32, 93.68, -311.06)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "泣き笑い顔")
	event.EohSetTexAnim(0, 1, "泣き目パチ")
	event.CharaActive(35)
	event.CharaActive(0, 34)
	event.SetPakuAnim(0, "わらい口パク")
	helper_f8047a1c(5400220)
	if vm.skipping() then
		return skip(22)
	end
	event.SetFadeOut(30)
	helper_0c95681b(30)
	if vm.skipping() then
		return skip(23)
	end
	return part2()
end

--- Helper function.
local function helper_213c0()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 29 then
			if at <= 1 then
				helper_0c95681b(40)
			end
			if at <= 2 then
				helper_f8047a1c(5400350)
			end
			if at <= 3 then
				helper_2ddedb3b(2)
			end
			if at <= 4 then
				helper_f8047a1c(5400360)
			end
			if at <= 5 then
				helper_0c95681b(20)
			end
			if at <= 6 then
				helper_f8047a1c(5400365)
			end
			if at <= 7 then
				helper_2ddedb3b(1)
			end
			if at <= 8 then
				helper_0c95681b(10)
			end
			if at <= 9 then
				helper_f8047a1c(5400370)
			end
			if at <= 10 then
				helper_0c95681b(20)
			end
			if at <= 11 then
				helper_f8047a1c(5400380)
			end
			if at <= 12 then
				helper_0c95681b(10)
			end
			if at <= 13 then
				helper_f8047a1c(5400390)
			end
			if at <= 14 then
				helper_2ddedb3b(2)
			end
			if at <= 15 then
				helper_2ddedb3b(0)
			end
			if at <= 16 then
				helper_0c95681b(10)
			end
			if at <= 17 then
				helper_f8047a1c(5400400)
			end
			if at <= 18 then
				helper_0c95681b(10)
			end
			if at <= 19 then
				helper_f8047a1c(5400410)
			end
			if at <= 20 then
				helper_2ddedb3b(2)
			end
			if at <= 21 then
				helper_0c95681b(10)
			end
			if at <= 22 then
				helper_f8047a1c(5400415)
			end
			if at <= 23 then
				helper_0c95681b(10)
			end
			if at <= 24 then
				helper_f8047a1c(5400420)
			end
			if at <= 25 then
				helper_f8047a1c(5400430)
			end
			if at <= 26 then
				helper_2ddedb3b(0)
			end
			if at <= 27 then
				helper_2ddedb3b(1)
			end
			if at <= 28 then
				helper_0c95681b(30)
			end
			if vm.skip_end() then
				return skip(30)
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
		event.LoadMes(0, -1)
	end
	event.SetFlag(540, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.StopBgm(0)
	helper_0c95681b(4)
	if vm.skipping() then
		return skip(1)
	end
	event.LoadBgm(111)
	event.LoadSound(5511)
	var0 = event.SndLoadSound(5511) or var0
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.SetStatus(1, 0, 256, 1)
	event.ChangeDir("event/e500/e540/")
	event.LoadMes(0, 5, "e540_1.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e540_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e540_monica.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.LoadChara(5, "e540_phorn.gltf", "info", 34)
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
		event.LoadMotion(5, "event/e500/e540/e540_mints.gltf", "info", 32)
		event.EohSyncChara(0, 32)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	else
		event.LoadChara(5, "chara/c02_base.gltf", "info", 32)
		event.LoadEquip(5, 1, 4, "info", 32)
		event.LoadEquip(5, 1, 3, "info", 32)
		event.LoadEquip(5, 1, 2, "info", 32, 33)
		event.LoadMotion(5, "event/e500/e540/e540_monica.gltf", "info", 32)
		event.EohSyncChara(1, 32)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.CharaActive(32)
	event.CharaActive(33)
	event.EohSetPos(0, -14.0, 70.1, -60.0)
	event.EohSetRot(0, 0.0, 0.36, 0.0)
	event.EohSetMotion(0, "立ち", 4)
	event.EohNormalDrive(0)
	event.EohSetMotion(0, "ホーン王見立ち", 4)
	event.EohResetDaPosition(0)
	event.EohSetPos(1, 14.0, 70.1, -60.0)
	event.EohSetRot(1, 0.0, -0.36, 0.0)
	event.EohSetMotion(1, "ドナ見", 4)
	event.EohResetDaPosition(1)
	event.EohSetPos(2, 0.0, 70.1, -30.0)
	event.EohSetRot(2, 0.0, 3.14, 0.0)
	event.EohSetMotion(2, "立ち", 4)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "デフォルト顔")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "デフォルト顔")
	event.EohSetTexAnim(1, 1, "通常目パチ")
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "目パチ")
	event.InitDramaScene()
	event.PlayBgm(0)
	event.CmrsInit()
	event.CmrsSetPos(0.0, 161.28, 112.88)
	event.CmrsSetRef(0.0, 93.01, -16.09)
	event.SetFadeIn(30)
	helper_0c95681b(40)
	if vm.skipping() then
		return skip(2)
	end
	event.ObjsSetMotion(2, "会話", 2)
	event.ObjsNextMotion(2, "立ち", 4)
	event.SetPakuAnim(2, "口パク")
	helper_f8047a1c(5400350)
	if vm.skipping() then
		return skip(3)
	end
	helper_2ddedb3b(2)
	if vm.skipping() then
		return skip(4)
	end
	event.ObjsSetMotion(1, "ドナ見会話", 2)
	event.ObjsNextMotion(1, "ドナ見", 4)
	event.SetPakuAnim(1, "わらい口パク")
	helper_f8047a1c(5400360)
	if vm.skipping() then
		return skip(5)
	end
	helper_0c95681b(20)
	if vm.skipping() then
		return skip(6)
	end
	event.SetPakuAnim(1, "わらい口パク")
	helper_f8047a1c(5400365)
	if vm.skipping() then
		return skip(7)
	end
	helper_2ddedb3b(1)
	if vm.skipping() then
		return skip(8)
	end
	helper_0c95681b(10)
	if vm.skipping() then
		return skip(9)
	end
	event.CmrsSetPos(17.58, 93.16, -32.22)
	event.CmrsSetRef(13.81, 91.96, -54.3)
	event.SndSePlay(var0, 10)
	event.ObjsSetMotion(1, "がっつ", 6)
	event.ObjsNextMotion(1, "がっつL", 4)
	event.SetPakuAnim(1, "わらい口パク")
	helper_f8047a1c(5400370)
	if vm.skipping() then
		return skip(10)
	end
	helper_0c95681b(20)
	if vm.skipping() then
		return skip(11)
	end
	event.CmrsSetPos(0.0, 77.39, -110.94)
	event.CmrsSetRef(0.0, 91.69, -28.42)
	event.ObjsSetRot(2, 0.0, 2.9, 0.0)
	event.ObjsSetMotion(1, "ドナ見", 4, -1.0, 1)
	event.SetPakuAnim(2, "口パク")
	helper_f8047a1c(5400380)
	if vm.skipping() then
		return skip(12)
	end
	helper_0c95681b(10)
	if vm.skipping() then
		return skip(13)
	end
	event.ObjsSetMotion(2, "ユリス見る", 2)
	event.ObjsNextMotion(2, "ユリス見る（会話）", 6)
	event.ObjsNextMotion(2, "ユリス見るループ", 4)
	event.SetPakuAnim(2, "口パク")
	helper_f8047a1c(5400390)
	if vm.skipping() then
		return skip(14)
	end
	helper_2ddedb3b(2)
	if vm.skipping() then
		return skip(15)
	end
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "前向き～目下")
	event.ObjsSetMotion(0, "うつむく2", 6)
	event.ObjsNextMotion(0, "うつむく2L", 4)
	helper_2ddedb3b(0)
	if vm.skipping() then
		return skip(16)
	end
	helper_0c95681b(10)
	if vm.skipping() then
		return skip(17)
	end
	event.SetPakuAnim(0, "通常口パク")
	helper_f8047a1c(5400400)
	if vm.skipping() then
		return skip(18)
	end
	helper_0c95681b(10)
	if vm.skipping() then
		return skip(19)
	end
	event.ObjsSetMotion(2, "ユリス見る（会話）", 2)
	event.ObjsNextMotion(2, "ユリス見るループ", 4)
	event.SetPakuAnim(2, "口パク")
	helper_f8047a1c(5400410)
	if vm.skipping() then
		return skip(20)
	end
	helper_2ddedb3b(2)
	if vm.skipping() then
		return skip(21)
	end
	helper_0c95681b(10)
	if vm.skipping() then
		return skip(22)
	end
	event.CmrsSetPos(58.42, 102.63, -0.58)
	event.CmrsSetRef(2.09, 87.48, -43.45)
	event.ObjsSetMotion(0, "ホーン王見立ち", 4, -1.0, 1)
	event.ObjsSetRot(2, 0.0, 3.14, 0.0)
	event.ObjsSetMotion(2, "立ち", 4)
	event.SetPakuAnim(2, "口パク")
	helper_f8047a1c(5400415)
	if vm.skipping() then
		return skip(23)
	end
	helper_0c95681b(10)
	if vm.skipping() then
		return skip(24)
	end
	event.SetPakuAnim(2, "口パク")
	helper_f8047a1c(5400420)
	if vm.skipping() then
		return skip(25)
	end
	event.ObjsTexAnime(0, 1, "わらい口パク")
	event.ObjsTexaDelay(0, 20)
	event.ObjsTexAnime(0, 0, "わらい口パク")
	event.ObjsTexAnime(1, 1, "わらい口パク")
	event.ObjsTexaDelay(1, 20)
	event.ObjsTexAnime(1, 0, "わらい口パク")
	helper_f8047a1c(5400430)
	if vm.skipping() then
		return skip(26)
	end
	helper_2ddedb3b(0)
	if vm.skipping() then
		return skip(27)
	end
	helper_2ddedb3b(1)
	if vm.skipping() then
		return skip(28)
	end
	event.SetFadeOut(30)
	helper_0c95681b(30)
	if vm.skipping() then
		return skip(29)
	end
	return part2()
end

--- Helper function.
local function helper_23fac()
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 12 then
			if at <= 1 then
				helper_f8047a1c(6400050)
			end
			if at <= 2 then
				helper_f8047a1c(6400055)
			end
			if at <= 3 then
				helper_2ddedb3b(3)
			end
			if at <= 4 then
				helper_f8047a1c(6400060)
			end
			if at <= 5 then
				helper_2ddedb3b(2)
			end
			if at <= 6 then
				helper_f8047a1c(6400070)
			end
			if at <= 7 then
				helper_f8047a1c(6400075)
			end
			if at <= 8 then
				helper_2ddedb3b(3)
			end
			if at <= 9 then
				helper_f8047a1c(6400080)
			end
			if at <= 10 then
				helper_2ddedb3b(3)
			end
			if at <= 11 then
				helper_0c95681b(30)
			end
			if vm.skip_end() then
				return skip(13)
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
		event.DeleteChara(37)
		event.LoadMes(0, -1)
	end
	event.SetFlag(640, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.StopBgm(0)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.SetStatus(1, 0, 256, 1)
	event.ChangeDir("event/e600/e640/")
	event.LoadMes(0, 5, "e640_1.txt")
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
	event.LoadChara(5, "e640_eina.gltf", "info", 34)
	event.CharaActive(34)
	event.EohSyncChara(2, 34)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.LoadChara(5, "e640_phorn.gltf", "info", 35)
	event.CharaActive(35)
	event.EohSyncChara(3, 35)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.LoadChara(5, "e640_puzzhei.gltf", "info", 36)
	event.CharaActive(36)
	event.EohSyncChara(4, 36)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.CopyChara(5, 36, 37)
	event.CharaActive(37)
	event.EohSyncChara(5, 37)
	event.ObjsInit(5, 37)
	event.ObjsSyncObj(5, 5)
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
	event.EohSetPos(2, -22.03, 0.0, 229.95)
	event.EohSetRot(2, 0.0, 0.24, 0.0)
	event.EohSetFootSoundId(2, 2)
	event.EohSetPos(3, 0.96, 0.0, 230.46)
	event.EohSetRot(3, 0.0, 0.0, 0.0)
	event.EohSetFootSoundId(3, 2)
	event.InitDramaScene()
	event.CmrsInit()
	event.CmrsSetPos(5.23, 26.13, 279.27)
	event.CmrsSetRef(-4.11, 27.26, 246.6)
	event.CharaActive(0, 36)
	event.CharaActive(0, 37)
	event.ObjsSetMotion(2, "立ち", 4)
	event.ObjsSetMotion(3, "剣持ち立ち", 4)
	event.SetFadeIn(30)
	helper_0c95681b(60)
	if vm.skipping() then
		return skip(1)
	end
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "目パチ")
	event.ObjsTexAnime(3, 0)
	event.ObjsTexAnime(3, 1, "わらい顔")
	event.ObjsTexAnime(3, 1, "通常目パチ")
	event.ObjsSetMotion(3, "剣持ち会話", 6)
	event.ObjsNextMotion(3, "剣持ち立ち", 4)
	event.SetPakuAnim(3, "わらい口パク")
	helper_f8047a1c(6400050)
	if vm.skipping() then
		return skip(2)
	end
	event.SetPakuAnim(3, "わらい口パク")
	helper_f8047a1c(6400055)
	if vm.skipping() then
		return skip(3)
	end
	helper_2ddedb3b(3)
	if vm.skipping() then
		return skip(4)
	end
	event.ObjsSetMotion(2, "会話", 6)
	event.ObjsNextMotion(2, "立ち", 4)
	event.SetPakuAnim(2, "口パク")
	helper_f8047a1c(6400060)
	if vm.skipping() then
		return skip(5)
	end
	helper_2ddedb3b(2)
	if vm.skipping() then
		return skip(6)
	end
	event.ObjsSetMotion(3, "右見る", 6)
	event.ObjsNextMotion(3, "右見るL", 4)
	event.ObjsMotionDelay(2, 30)
	event.ObjsSetMotion(2, "ホーンを見る", 6)
	event.ObjsNextMotion(2, "ホーンを見るＬ", 4)
	event.SetPakuAnim(3, "わらい口パク")
	helper_f8047a1c(6400070)
	if vm.skipping() then
		return skip(7)
	end
	event.SetPakuAnim(3, "わらい口パク")
	helper_f8047a1c(6400075)
	if vm.skipping() then
		return skip(8)
	end
	helper_2ddedb3b(3)
	if vm.skipping() then
		return skip(9)
	end
	event.ObjsSetMotion(3, "右見る戻り", 6)
	event.ObjsNextMotion(3, "剣持ち上見立ち", 4)
	event.ObjsSetMotion(2, "正面モニターを見る", 6)
	event.ObjsNextMotion(2, "正面モニターを見るＬ", 4)
	event.SetPakuAnim(3, "わらい口パク")
	helper_f8047a1c(6400080)
	if vm.skipping() then
		return skip(10)
	end
	helper_2ddedb3b(3)
	if vm.skipping() then
		return skip(11)
	end
	event.SetFadeOut(30)
	helper_0c95681b(30)
	if vm.skipping() then
		return skip(12)
	end
	return part2()
end

--- Helper function.
local function helper_25fac()
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 6 then
			if at <= 1 then
				helper_f8047a1c(6400110)
			end
			if at <= 2 then
				helper_f8047a1c(6400120)
			end
			if at <= 3 then
				helper_2ddedb3b(3)
			end
			if at <= 4 then
				helper_f8047a1c(6400130)
			end
			if at <= 5 then
				helper_0c95681b(30)
			end
			if vm.skip_end() then
				return skip(7)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
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
		event.DeleteChara(35)
		event.DeleteChara(36)
		event.DeleteChara(37)
		event.LoadMes(0, -1)
	end
	event.SetFlag(640, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.SetStatus(1, 0, 256, 1)
	event.ChangeDir("event/e600/e640/")
	event.LoadMes(0, 5, "e640_1.txt")
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
	event.LoadChara(5, "e640_eina.gltf", "info", 34)
	event.CharaActive(34)
	event.EohSyncChara(2, 34)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.LoadChara(5, "e640_phorn.gltf", "info", 35)
	event.CharaActive(35)
	event.EohSyncChara(3, 35)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.LoadChara(5, "e640_puzzhei.gltf", "info", 36)
	event.CharaActive(36)
	event.EohSyncChara(4, 36)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.CopyChara(5, 36, 37)
	event.CharaActive(37)
	event.EohSyncChara(5, 37)
	event.ObjsInit(5, 37)
	event.ObjsSyncObj(5, 5)
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
	event.EohSetPos(2, -50.23, 0.0, 222.06)
	event.EohSetRot(2, 0.0, 0.0, 0.0)
	event.EohSetFootSoundId(2, 2)
	event.EohSetPos(3, 0.96, 0.0, 230.46)
	event.EohSetRot(3, 0.0, 0.0, 0.0)
	event.EohSetFootSoundId(3, 2)
	event.EohSetPos(4, -220.73, 1.34, 314.3)
	event.EohSetRot(4, 0.0, -1.08, 0.0)
	event.EohSetPos(5, -163.0, 1.59, 359.91)
	event.EohSetRot(5, 0.0, 0.0, 0.0)
	event.InitDramaScene()
	event.CmrsInit()
	event.CmrsSetPos(0.41, 62.21, 279.76)
	event.CmrsSetRef(1.48, 26.74, 234.15)
	event.CharaActive(36)
	event.CharaActive(37)
	event.ObjsSetMotion(2, "正面モニターを見るＬ", 4)
	event.ObjsSetMotion(3, "剣持ち上見立ち", 4)
	event.ObjsSetMotion(4, "座り2")
	event.ObjsSetMotion(5, "座り（見上げ）")
	event.SetFadeIn(30)
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "目パチ")
	event.SetPakuAnim(2, "口パク")
	helper_0c95681b(60)
	if vm.skipping() then
		return skip(1)
	end
	event.ObjsTexAnime(3, 0)
	event.ObjsTexAnime(3, 1, "目パチ")
	event.SetPakuAnim(3, "口パク")
	helper_f8047a1c(6400110)
	if vm.skipping() then
		return skip(2)
	end
	event.ObjsSetMotion(3, "兵士見る", 6)
	event.ObjsNextMotion(3, "兵士見るL", 4)
	event.SetPakuAnim(3, "口パク")
	helper_f8047a1c(6400120)
	if vm.skipping() then
		return skip(3)
	end
	helper_2ddedb3b(3)
	if vm.skipping() then
		return skip(4)
	end
	event.CmrsSetPos(-270.36, 35.52, 412.37)
	event.CmrsSetRef(-220.2, 31.24, 361.75)
	event.ObjsTexAnime(4, 0)
	event.ObjsTexAnime(4, 1, "目パチ")
	event.SetPakuAnim(4, "口パク")
	helper_f8047a1c(6400130)
	if vm.skipping() then
		return skip(5)
	end
	event.FadeOutBgm(30)
	event.SetFadeOut(30)
	helper_0c95681b(30)
	if vm.skipping() then
		return skip(6)
	end
	return part2()
end

--- Helper function.
local function helper_27d58()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 8 then
			if at <= 1 then
				helper_41b952e8(6400200, -1)
			end
			if at <= 2 then
				helper_2ddedb3b(4)
			end
			if at <= 3 then
				helper_0c95681b(30)
			end
			if at <= 4 then
				helper_0c95681b(30)
			end
			if at <= 5 then
				helper_41b952e8(6400210, -1)
			end
			if at <= 6 then
				helper_2ddedb3b(3)
			end
			if at <= 7 then
				helper_0c95681b(30)
			end
			if vm.skip_end() then
				return skip(9)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SndSeStop(var0, 3)
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
		event.DeleteChara(36)
		event.DeleteChara(37)
		event.LoadMes(0, -1)
	end
	event.SetFlag(640, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.LoadSound(6213)
	var0 = event.SndLoadSound(6213) or var0
	event.SndSePlay(var0, 0)
	event.SndSeStop(var0, 0)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.SetStatus(1, 0, 256, 1)
	event.ChangeDir("event/e600/e640/")
	event.LoadMes(0, 5, "e640_1.txt")
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
	event.LoadChara(5, "e640_eina.gltf", "info", 34)
	event.CharaActive(34)
	event.EohSyncChara(2, 34)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.LoadChara(5, "e640_phorn.gltf", "info", 35)
	event.CharaActive(35)
	event.EohSyncChara(3, 35)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.LoadChara(5, "e640_puzzhei.gltf", "info", 36)
	event.CharaActive(36)
	event.EohSyncChara(4, 36)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.CopyChara(5, 36, 37)
	event.CharaActive(37)
	event.EohSyncChara(5, 37)
	event.ObjsInit(5, 37)
	event.ObjsSyncObj(5, 5)
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
	event.EohSetPos(2, -50.23, 0.0, 222.06)
	event.EohSetRot(2, 0.0, 0.0, 0.0)
	event.EohSetFootSoundId(2, 2)
	event.EohSetPos(3, 0.96, 0.0, 230.46)
	event.EohSetRot(3, 0.0, 0.0, 0.0)
	event.EohSetFootSoundId(3, 2)
	event.EohSetPos(4, -220.73, 1.34, 314.3)
	event.EohSetRot(4, 0.0, -1.08, 0.0)
	event.EohSetPos(5, -163.0, 1.59, 359.91)
	event.EohSetRot(5, 0.0, 0.0, 0.0)
	event.InitDramaScene()
	event.SndSePlay(var0, 3)
	event.CmrsInit()
	event.CmrsSetPos(-264.58, 36.34, 412.73)
	event.CmrsSetRef(-127.0, 16.05, 263.16)
	event.CharaActive(36)
	event.CharaActive(37)
	event.ObjsSetMotion(2, "正面モニターを見るＬ", 4)
	event.ObjsSetMotion(3, "剣持ち上見立ち", 4)
	event.ObjsSetMotion(4, "座り2", 4)
	event.ObjsSetMotion(5, "座り2", 4)
	event.SetFadeIn(30)
	helper_0c95681b(60)
	if vm.skipping() then
		return skip(1)
	end
	event.ObjsSetMotion(4, "座り（振り向く）", 6)
	event.ObjsNextMotion(4, "座りループ（振り向く）", 4)
	event.ObjsTexAnime(4, 0)
	event.ObjsTexAnime(4, 1, "目パチ")
	event.SetPakuAnim(4, "口パク")
	helper_41b952e8(6400200, -1)
	if vm.skipping() then
		return skip(2)
	end
	helper_2ddedb3b(4)
	if vm.skipping() then
		return skip(3)
	end
	helper_0c95681b(30)
	if vm.skipping() then
		return skip(4)
	end
	event.ObjsSetMotion(3, "兵士見る", 6)
	event.ObjsNextMotion(3, "兵士見るL", 4)
	event.CmrsSetPos(1.82, 29.37, 280.93)
	event.CmrsSetRef(0.99, 26.27, 232.1)
	helper_0c95681b(30)
	if vm.skipping() then
		return skip(5)
	end
	event.ObjsSetMotion(3, "ペズローダー", 6)
	event.ObjsNextMotion(3, "ペズローダーL", 4)
	event.ObjsMotionDelay(3, 100)
	event.ObjsSetMotion(3, "発射！！", 6)
	event.ObjsNextMotion(3, "発射！！L", 4)
	event.ObjsSeDelay(3, 100)
	event.ObjsSePlay(3, var0, 4)
	event.ObjsTexAnime(3, 0)
	event.ObjsTexAnime(3, 1, "目パチ")
	event.SetPakuAnim(3, "口パク")
	helper_41b952e8(6400210, -1)
	if vm.skipping() then
		return skip(6)
	end
	helper_2ddedb3b(3)
	if vm.skipping() then
		return skip(7)
	end
	event.SetFadeOut(30)
	helper_0c95681b(30)
	if vm.skipping() then
		return skip(8)
	end
	return part2()
end

--- Helper function.
local function helper_29e38()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 31 then
			if at <= 1 then
				helper_41b952e8(6400270, -1)
			end
			if at <= 2 then
				helper_0c95681b(15)
			end
			if at <= 3 then
				helper_f8047a1c(6400275)
			end
			if at <= 4 then
				helper_f8047a1c(6400280)
			end
			if at <= 5 then
				helper_0c95681b(90)
			end
			if at <= 6 then
				helper_f8047a1c(6400290)
			end
			if at <= 7 then
				helper_2ddedb3b(2)
			end
			if at <= 8 then
				helper_2ddedb3b(3)
			end
			if at <= 9 then
				helper_2ddedb3b(4)
			end
			if at <= 10 then
				helper_0c95681b(30)
			end
			if at <= 11 then
				helper_f8047a1c(6400300)
			end
			if at <= 12 then
				helper_f8047a1c(6400305)
			end
			if at <= 13 then
				helper_f8047a1c(6400310)
			end
			if at <= 14 then
				helper_f8047a1c(6400320)
			end
			if at <= 15 then
				helper_f8047a1c(6400325)
			end
			if at <= 16 then
				helper_2ddedb3b(3)
			end
			if at <= 17 then
				helper_f8047a1c(6400330)
			end
			if at <= 18 then
				helper_2ddedb3b(2)
			end
			if at <= 19 then
				helper_41b952e8(6400340, -1)
			end
			if at <= 20 then
				helper_41b952e8(6400350, -1)
			end
			if at <= 21 then
				helper_0c95681b(15)
			end
			if at <= 22 then
				helper_f8047a1c(6400355)
			end
			if at <= 23 then
				helper_f8047a1c(6400360)
			end
			if at <= 24 then
				helper_f8047a1c(6400370)
			end
			if at <= 25 then
				helper_2ddedb3b(3)
			end
			if at <= 26 then
				helper_94f2e77c()
			end
			if at <= 27 then
				helper_0c95681b(30)
			end
			if at <= 28 then
				helper_f8047a1c(6400380)
			end
			if at <= 29 then
				helper_f8047a1c(6400390)
			end
			if at <= 30 then
				helper_0c95681b(30)
			end
			if vm.skip_end() then
				return skip(32)
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
		event.DeleteChara(37)
		event.LoadMes(0, -1)
	end
	event.SetFlag(640, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.LoadSound(6216)
	var0 = event.SndLoadSound(6216) or var0
	event.SndSePlay(var0, 0)
	event.SndSeStop(var0, 0)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.SetStatus(1, 0, 256, 1)
	event.ChangeDir("event/e600/e640/")
	event.LoadMes(0, 5, "e640_1.txt")
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
	event.LoadChara(5, "e640_eina.gltf", "info", 34)
	event.CharaActive(34)
	event.EohSyncChara(2, 34)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.LoadChara(5, "e640_phorn.gltf", "info", 35)
	event.CharaActive(35)
	event.EohSyncChara(3, 35)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.LoadChara(5, "e640_puzzhei.gltf", "info", 36)
	event.CharaActive(36)
	event.EohSyncChara(4, 36)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.CopyChara(5, 36, 37)
	event.CharaActive(37)
	event.EohSyncChara(5, 37)
	event.ObjsInit(5, 37)
	event.ObjsSyncObj(5, 5)
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
	event.EohSetPos(2, -40.58, 0.0, 233.19)
	event.EohSetRot(2, 0.0, 0.0, 0.0)
	event.EohSetFootSoundId(2, 2)
	event.EohSetPos(3, 9.27, 0.0, 339.65)
	event.EohSetRot(3, 0.0, 0.0, 0.0)
	event.EohSetFootSoundId(3, 2)
	event.EohSetFrameShow(3, "sword", 0)
	event.EohSetPos(4, -0.19, 0.0, 360.73)
	event.EohSetRot(4, 0.0, 0.0, 0.0)
	event.EohSetPos(5, -259.81, 3.1, 246.3)
	event.EohSetRot(5, 0.0, -0.84, 0.0)
	event.InitDramaScene()
	event.CmrsInit()
	event.CmrsSetPos(24.18, 110.64, 432.72)
	event.CmrsSetRef(-7.16, -5.33, 336.77)
	event.CharaActive(36)
	event.CharaActive(37)
	event.ObjsSetMotion(2, "正面モニターを見るＬ", 4)
	event.ObjsSetMotion(3, "イス持ち立ち", 4)
	event.ObjsSetMotion(4, "座り（見上げ）", 4)
	event.ObjsSetMotion(5, "座り2", 4)
	event.SetFadeIn(30)
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "目パチ")
	event.ObjsTexAnime(3, 0)
	event.ObjsTexAnime(3, 1, "目パチ")
	event.ObjsTexAnime(4, 0)
	event.ObjsTexAnime(4, 1, "真剣顔")
	event.ObjsTexAnime(4, 1, "真剣目パチ")
	helper_0c95681b(60)
	if vm.skipping() then
		return skip(1)
	end
	event.ObjsSetMotion(4, "座り（見上会話）", 6)
	event.ObjsNextMotion(4, "座り（見上げ）", 4)
	event.SetPakuAnim(4, "真剣口パク")
	helper_41b952e8(6400270, -1)
	if vm.skipping() then
		return skip(2)
	end
	helper_0c95681b(15)
	if vm.skipping() then
		return skip(3)
	end
	event.SetPakuAnim(4, "真剣口パク")
	helper_f8047a1c(6400275)
	if vm.skipping() then
		return skip(4)
	end
	event.SetPakuAnim(3, "口パク")
	helper_f8047a1c(6400280)
	if vm.skipping() then
		return skip(5)
	end
	event.ObjsSetMotion(2, "見上げ歩き")
	event.ObjsMove(2, -32.19, 0.0, 328.91, 180)
	event.ObjsMotionDelay(2, 150)
	event.ObjsNextMotion(2, "見上げ立ち")
	helper_0c95681b(90)
	if vm.skipping() then
		return skip(6)
	end
	event.ObjsMotionDelay(3, 30)
	event.ObjsSetMotion(3, "右見る2", 6)
	event.ObjsNextMotion(3, "右見る2L", 4)
	event.ObjsMotionDelay(4, 30)
	event.ObjsSetMotion(4, "エイナ見る", 6)
	event.ObjsNextMotion(4, "エイナ見るループ", 4)
	event.SetPakuAnim(2, "口パク")
	helper_f8047a1c(6400290)
	if vm.skipping() then
		return skip(7)
	end
	helper_2ddedb3b(2)
	if vm.skipping() then
		return skip(8)
	end
	helper_2ddedb3b(3)
	if vm.skipping() then
		return skip(9)
	end
	helper_2ddedb3b(4)
	if vm.skipping() then
		return skip(10)
	end
	helper_0c95681b(30)
	if vm.skipping() then
		return skip(11)
	end
	event.CmrsSetPos(55.84, 33.24, 396.17)
	event.CmrsSetRef(-5.02, 28.33, 333.78)
	event.ObjsSetMotion(4, "座り（見上げ）", 4)
	event.ObjsResetDaPosition(4)
	event.ObjsSetMotion(2, "立ち", 4)
	event.ObjsResetDaPosition(2)
	event.ObjsSetPos(2, -30.14, 0.0, 329.47)
	event.ObjsResetDaPosition(2)
	event.ObjsSetRot(2, 0.0, 1.2, 0.0)
	event.ObjsResetDaPosition(2)
	event.ObjsSetMotion(3, "立ち", 4)
	event.ObjsResetDaPosition(3)
	event.ObjsSetPos(3, 5.9, 0.0, 327.17)
	event.ObjsResetDaPosition(3)
	event.ObjsSetRot(3, 0.0, -1.44, 0.0)
	event.ObjsResetDaPosition(3)
	event.SetPakuAnim(3, "口パク")
	helper_f8047a1c(6400300)
	if vm.skipping() then
		return skip(12)
	end
	event.SetPakuAnim(3, "口パク")
	helper_f8047a1c(6400305)
	if vm.skipping() then
		return skip(13)
	end
	event.SetPakuAnim(2, "口パク")
	helper_f8047a1c(6400310)
	if vm.skipping() then
		return skip(14)
	end
	event.ObjsSetMotion(3, "会話", 6)
	event.ObjsNextMotion(3, "立ち", 4)
	event.SetPakuAnim(3, "口パク")
	helper_f8047a1c(6400320)
	if vm.skipping() then
		return skip(15)
	end
	event.SetPakuAnim(3, "口パク")
	helper_f8047a1c(6400325)
	if vm.skipping() then
		return skip(16)
	end
	helper_2ddedb3b(3)
	if vm.skipping() then
		return skip(17)
	end
	event.ObjsSetMotion(2, "会話２", 6)
	event.ObjsNextMotion(2, "立ち", 4)
	event.SetPakuAnim(2, "口パク")
	helper_f8047a1c(6400330)
	if vm.skipping() then
		return skip(18)
	end
	helper_2ddedb3b(2)
	if vm.skipping() then
		return skip(19)
	end
	event.CmrsSetPos(-66.15, 28.08, 373.06)
	event.CmrsSetRef(-13.57, 19.89, 326.3)
	event.ObjsSetPos(4, 277.89, 0.0, 243.97)
	event.ObjsSetRot(4, 0.0, 1.08, 0.0)
	event.ObjsSetPos(5, 383.38, 0.0, 32.91)
	event.ObjsSetRot(5, 0.0, 0.81, 0.0)
	event.ObjsSetMotion(3, "会話", 6)
	event.ObjsNextMotion(3, "立ち", 4)
	event.SetPakuAnim(3, "口パク")
	helper_41b952e8(6400340, -1)
	if vm.skipping() then
		return skip(20)
	end
	event.ObjsSetMotion(2, "会話", 6)
	event.ObjsNextMotion(2, "立ち", 4)
	event.SetPakuAnim(2, "口パク")
	helper_41b952e8(6400350, -1)
	if vm.skipping() then
		return skip(21)
	end
	helper_0c95681b(15)
	if vm.skipping() then
		return skip(22)
	end
	event.SetPakuAnim(2, "口パク")
	helper_f8047a1c(6400355)
	if vm.skipping() then
		return skip(23)
	end
	event.ObjsSetMotion(2, "モニターに向きなおる", 6)
	event.ObjsNextMotion(2, "モニターに向きなおるＬ", 4)
	event.SetPakuAnim(2, "口パク")
	helper_f8047a1c(6400360)
	if vm.skipping() then
		return skip(24)
	end
	event.CmrsSetPos(-2.98, 79.27, 382.96)
	event.CmrsSetRef(23.85, 14.87, 323.24)
	event.ObjsSetMotion(2, "正面モニターを見るＬ", 4)
	event.ObjsResetDaPosition(2)
	event.ObjsSetPos(2, -30.14, 0.0, 329.47)
	event.ObjsResetDaPosition(2)
	event.ObjsSetRot(2, 0.0, 0.0, 0.0)
	event.ObjsResetDaPosition(2)
	event.ObjsSetMotion(3, "立ち", 4)
	event.ObjsResetDaPosition(3)
	event.ObjsSetPos(3, 17.79, 0.0, 331.05)
	event.ObjsResetDaPosition(3)
	event.ObjsSetRot(3, 0.0, -0.08, 0.0)
	event.ObjsResetDaPosition(3)
	event.ObjsSetMotion(3, "うつむく", 6)
	event.ObjsNextMotion(3, "うつむくL", 4)
	event.SetPakuAnim(3, "口パク")
	helper_f8047a1c(6400370)
	if vm.skipping() then
		return skip(25)
	end
	event.CmrsMove2(5.14, 64.37, 364.89, 23.85, 14.87, 323.24, 90, 2, 1.0)
	helper_2ddedb3b(3)
	if vm.skipping() then
		return skip(26)
	end
	event.ObjsSetMotion(3, "顔上げる", 6)
	event.ObjsNextMotion(3, "上見立ち", 4)
	helper_94f2e77c()
	if vm.skipping() then
		return skip(27)
	end
	helper_0c95681b(30)
	if vm.skipping() then
		return skip(28)
	end
	event.CmrsSetPos(24.18, 110.64, 432.72)
	event.CmrsSetRef(-7.16, -5.33, 336.77)
	event.ObjsSetPos(4, -0.19, 0.0, 360.73)
	event.ObjsSetRot(4, 0.0, 0.0, 0.0)
	event.ObjsResetDaPosition(4)
	event.SetPakuAnim(2, "口パク")
	helper_f8047a1c(6400380)
	if vm.skipping() then
		return skip(29)
	end
	event.SndSePlay(var0, 4)
	event.ObjsSetMotion(4, "発動", 6)
	event.ObjsNextMotion(4, "発動ループ", 4)
	event.SetPakuAnim(4, "真剣口パク")
	helper_f8047a1c(6400390)
	if vm.skipping() then
		return skip(30)
	end
	event.FadeOutBgm(30)
	event.SetFadeOut(30)
	helper_0c95681b(30)
	if vm.skipping() then
		return skip(31)
	end
	return part2()
end

--- Helper function.
local function helper_2d558()
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 5 then
			if at <= 1 then
				helper_41b952e8(6400440, -1)
			end
			if at <= 2 then
				helper_0c95681b(15)
			end
			if at <= 3 then
				helper_41b952e8(6400450, -1)
			end
			if at <= 4 then
				helper_0c95681b(30)
			end
			if vm.skip_end() then
				return skip(6)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.BgmLoadCancel()
		event.EohSetShow(9, 1)
		event.EohSetShow(8, 0)
		event.EohSetShow(10, 0)
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
		event.DeleteChara(37)
		event.DeleteChara(38)
		event.DeleteChara(39)
		event.LoadMes(0, -1)
	end
	event.SetFlag(640, 1)
	event.BgmLoadCancel()
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.SetStatus(1, 0, 256, 1)
	event.ChangeDir("event/e600/e640/")
	event.LoadMes(0, 5, "e640_1.txt")
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
	event.LoadChara(5, "e640_eina.gltf", "info", 34)
	event.CharaActive(34)
	event.EohSyncChara(2, 34)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.LoadChara(5, "e640_phorn.gltf", "info", 35)
	event.CharaActive(35)
	event.EohSyncChara(3, 35)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.LoadChara(5, "e640_puzzhei.gltf", "info", 36)
	event.CharaActive(36)
	event.EohSyncChara(4, 36)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.CopyChara(5, 36, 37)
	event.CharaActive(37)
	event.EohSyncChara(5, 37)
	event.ObjsInit(5, 37)
	event.ObjsSyncObj(5, 5)
	event.CopyChara(5, 37, 38)
	event.CharaActive(38)
	event.EohSyncChara(6, 38)
	event.ObjsInit(6, 38)
	event.ObjsSyncObj(6, 6)
	event.LoadChara(5, "e520_dsmoke.gltf", "info", 39)
	event.CharaActive(39)
	event.EohSyncChara(7, 39)
	event.ObjsInit(7)
	event.ObjsSyncObj(7, 7)
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
	event.EohSyncObj(8, "p05_s30")
	event.ObjsInit(8)
	event.ObjsSyncObj(8, 8)
	event.EohSyncObj(9, "p04_s30")
	event.ObjsInit(9)
	event.ObjsSyncObj(9, 9)
	event.EohSyncObj(10, "p06_s30")
	event.ObjsInit(10)
	event.ObjsSyncObj(10, 10)
	event.EohSetPos(0, 0.0, 0.0, 0.0)
	event.EohSetRot(0, 0.0, 3.14, 0.0)
	event.EohSetFootSoundId(0, 2)
	event.EohSetPos(1, 0.0, 0.0, 0.0)
	event.EohSetRot(1, 0.0, 3.14, 0.0)
	event.EohSetFootSoundId(1, 2)
	event.EohSetPos(2, -50.23, 0.0, 222.06)
	event.EohSetRot(2, 0.0, 0.0, 0.0)
	event.EohSetFootSoundId(2, 2)
	event.EohSetPos(3, 0.96, 0.0, 230.46)
	event.EohSetRot(3, 0.0, 0.0, 0.0)
	event.EohSetFootSoundId(3, 2)
	event.EohSetPos(4, 1.07, 1.34, 357.76)
	event.EohSetRot(4, 0.0, 0.24, 0.0)
	event.EohSetPos(5, -80.47, 1.59, 355.25)
	event.EohSetRot(5, 0.0, 0.0, 0.0)
	event.EohSetPos(6, -163.0, 1.59, 359.91)
	event.EohSetRot(6, 0.0, 0.0, 0.0)
	event.EohSetPos(7, -691.18, 494.82, 1627.66)
	event.EohSetRot(7, 0.0, -0.8, 0.0)
	event.ObjsSetScale(7, 0.05, 0.1, 0.05)
	event.EohSetPos(8, -726.68, 569.6, 1677.89)
	event.EohSetRot(8, 0.0, 1.57, 0.314)
	event.ObjsSetScale(8, 0.3, 0.3, 0.3)
	event.EohSetPos(10, 0.0, 200.0, 0.0)
	event.EohSetShow(7, 1)
	event.EohSetShow(9, 0)
	event.EohSetShow(8, 1)
	event.EohSetShow(10, 1)
	event.InitDramaScene()
	event.CmrsInit()
	event.CmrsSetPos(56.95, 6.31, 97.48)
	event.CmrsSetRef(-6.19, 48.61, 240.92)
	event.CharaActive(36)
	event.CharaActive(37)
	event.ObjsSetMotion(2, "正面モニターを見るＬ", 4)
	event.ObjsSetMotion(3, "立ち", 4)
	event.ObjsSetMotion(4, "座り2", 4)
	event.ObjsSetMotion(5, "座り（見上げ）", 4)
	event.ObjsSetMotion(6, "座り2", 4)
	event.ObjsMove2(8, -726.68, 0.0, 1677.89, 600, 1, 1.0)
	event.ObjsMove2(7, -691.18, 0.0, 1627.66, 600, 1, 1.0)
	event.SetFadeIn(30)
	helper_0c95681b(60)
	if vm.skipping() then
		return skip(1)
	end
	event.ObjsSetMotion(2, "スクリーン指差す", 2)
	event.ObjsNextMotion(2, "スクリーン指差すＬ", 4)
	helper_41b952e8(6400440, -1)
	if vm.skipping() then
		return skip(2)
	end
	helper_0c95681b(15)
	if vm.skipping() then
		return skip(3)
	end
	helper_41b952e8(6400450, -1)
	if vm.skipping() then
		return skip(4)
	end
	event.SetFadeOut(30)
	helper_0c95681b(30)
	if vm.skipping() then
		return skip(5)
	end
	return part2()
end

--- Helper function.
local function helper_130b0(arg0: s32)
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var8: f32 = 0
	local var11: f32 = 0
	local yaw: f32 = 0
	local yaw_2: f32 = 0
	local var15: s32 = 0
	local var16: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 6 then
			if at <= 1 then
				helper_d08f674a(1)
			end
			if at <= 2 then
				helper_85ab2618(0, -1, arg0, 0, 0)
			end
			if at <= 3 then
				helper_d08f674a(1)
			end
			if at <= 4 then
				helper_85ab2618(0, -1, arg0, 0, 0)
			end
			if at <= 5 then
				helper_ecb662ce(0, 1)
				var16 = helper_c776923d(0, -1, 5, 256, 208, 2, 0)
			end
			return 1
		end
		if at <= 7 then
			helper_85ab2618(0, -1, arg0, 0, 0)
		end
		if at <= 8 then
			helper_0c95681b(11)
		end
		return 0
	end
	helper_ecb662ce(0, 7)
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.EohSyncChara(1, arg0)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	do
		local out1, out2, out3 = event.GetCharaPos(0)
		var1 = out1 or var1
		var2 = out2 or var2
		var3 = out3 or var3
	end
	do
		local _, out2, _ = event.GetCharaRot(0)
		var8 = out2 or var8
	end
	do
		local out1, out2, out3 = event.GetCharaPos(arg0)
		var4 = out1 or var4
		var5 = out2 or var5
		var6 = out3 or var6
	end
	do
		local _, out2, _ = event.GetCharaRot(arg0)
		var11 = out2 or var11
	end
	yaw = event.GetRefAngle(var1, var2, var3, var4, var5, var6) or yaw
	yaw_2 = event.GetRefAngle(var4, var5, var6, var1, var2, var3) or yaw_2
	var15 = event.AngleCmp(var8, yaw, 0.1) or var15
	if var15 ~= 0 then
		event.ObjsRotation(0, 0.0, yaw, 0.0, 10)
		event.ObjsSetMotion(0, "歩き")
		event.ObjsMotionDelay(0, 10)
	end
	event.ObjsSetMotion(0, "立ち")
	var15 = event.AngleCmp(var11, yaw_2, 0.1) or var15
	if var15 ~= 0 then
		event.ObjsRotation(1, 0.0, yaw_2, 0.0, 10)
		event.ObjsSetMotion(1, "歩き")
		event.ObjsMotionDelay(1, 10)
	end
	event.ObjsSetMotion(1, "立ち")
	helper_0c95681b(20)
	if vm.skipping() then
		return skip(1)
	end
	event.StreamOpen3(1, 5400010)
	helper_d08f674a(1)
	if vm.skipping() then
		return skip(2)
	end
	event.StreamPlay(1)
	event.SetPakuMotion(1, "会話", 0, "立ち", 0)
	event.MesMake_2(0, "Notre contre-attaque contre Griffon\nva bient[UNI00f4]t commencer.")
	helper_85ab2618(0, -1, arg0, 0, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.StreamClose(1)
	event.StreamOpen3(1, 5400015)
	helper_d08f674a(1)
	if vm.skipping() then
		return skip(4)
	end
	event.StreamPlay(1)
	event.MesMake_2(0, "Vous [UNI00ea]tes pr[UNI00ea]ts ?")
	helper_85ab2618(0, -1, arg0, 0, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.StreamClose(1)
	helper_ecb662ce(0, 1)
	event.MesMake_2(0, "Oui.\nNon.")
	var16 = helper_c776923d(0, -1, 5, 256, 208, 2, 0)
	if vm.skipping() then
		return skip(6)
	end
	if var16 == 0 then
		return 1
	else
		helper_ecb662ce(0, 7)
		event.StreamOpen3(1, 5400020)
		helper_d08f674a(1)
		if vm.skipping() then
			return skip(7)
		end
		event.StreamPlay(1)
		event.SetPakuMotion(1, "会話", 0, "立ち", 0)
		event.MesMake_2(0, "Leurs Golems arrivent droit sur nous.\nLe temps presse.")
		helper_85ab2618(0, -1, arg0, 0, 0)
		if vm.skipping() then
			return skip(8)
		end
		event.StreamClose(1)
		var15 = event.AngleCmp(var11, yaw_2, 0.1) or var15
		if var15 ~= 0 then
			event.ObjsRotation(1, 0.0, var11, 0.0, 10)
			event.ObjsSetMotion(1, "歩き")
			event.ObjsMotionDelay(1, 10)
		end
		event.ObjsSetMotion(1, "立ち")
		helper_0c95681b(11)
		if vm.skipping() then
			return skip(9)
		end
		return 0
	end
end

--- Helper function.
local function helper_14104()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 10 then
			if at <= 1 then
				helper_2ddedb3b(2)
			end
			if at <= 2 then
				helper_0c95681b(20)
			end
			if at <= 3 then
				helper_f8047a1c(5400030)
			end
			if at <= 4 then
				helper_2ddedb3b(2)
			end
			if at <= 5 then
				helper_0c95681b(2)
			end
			if at <= 6 then
				helper_0c95681b(4)
			end
			if at <= 7 then
				helper_0c95681b(4)
			end
			if at <= 8 then
				helper_0c95681b(20)
			end
			if at <= 9 then
				helper_0c95681b(10)
			end
			if vm.skip_end() then
				return skip(11)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SndSeStop(var0, 4)
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
		event.DeleteChara(37)
		event.DeleteChara(38)
		event.DeleteChara(39)
		event.DeleteChara(40)
		event.LoadMes(0, -1)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFlag(540, 1)
	event.CharaActive(0, 8)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.StopBgm(0)
	event.LoadSound(5511)
	var0 = event.SndLoadSound(5511) or var0
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.SetStatus(1, 0, 256, 1)
	event.ChangeDir("event/e500/e540/")
	event.LoadMes(0, 5, "e540_1.txt")
	if active_chr_no == 0 then
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.CharaActive(0)
		event.EohSyncChara(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.LoadChara(5, "e540_phorn.gltf", "info", 40)
	event.CharaActive(40)
	event.EohSyncChara(2, 40)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.LoadChara(5, "e540_puzzhei.gltf", "info", 34)
	event.CharaActive(34)
	event.EohSyncChara(3, 34)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.CopyChara(5, 34, 35)
	event.CharaActive(35)
	event.EohSyncChara(4, 35)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.CopyChara(5, 34, 36)
	event.CharaActive(36)
	event.EohSyncChara(5, 36)
	event.ObjsInit(5)
	event.ObjsSyncObj(5, 5)
	event.CopyChara(5, 34, 37)
	event.CharaActive(37)
	event.EohSyncChara(6, 37)
	event.ObjsInit(6)
	event.ObjsSyncObj(6, 6)
	event.CopyChara(5, 34, 38)
	event.CharaActive(38)
	event.EohSyncChara(7, 38)
	event.ObjsInit(7)
	event.ObjsSyncObj(7, 7)
	event.CopyChara(5, 34, 39)
	event.CharaActive(39)
	event.EohSyncChara(8, 39)
	event.ObjsInit(8)
	event.ObjsSyncObj(8, 8)
	event.ChangeDir("")
	if active_chr_no == 1 then
		event.LoadChara(5, "chara/c01_base.gltf", "info", 32)
		event.LoadEquip(5, 0, 4, "info", 32)
		event.LoadEquip(5, 0, 3, "info", 32)
		event.LoadEquip(5, 0, 2, "info", 32, 33)
		event.EohSyncChara(0, 32)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	else
		event.LoadChara(5, "chara/c02_base.gltf", "info", 32)
		event.LoadEquip(5, 1, 4, "info", 32)
		event.LoadEquip(5, 1, 3, "info", 32)
		event.LoadEquip(5, 1, 2, "info", 32, 33)
		event.EohSyncChara(1, 32)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.CharaActive(32)
	event.CharaActive(33)
	event.EohSetPos(0, -16.0, 70.1, -100.0)
	event.EohSetRot(0, 0.0, 0.0, 0.0)
	event.EohSetFootSoundId(0, 21)
	event.EohSetPos(1, 16.0, 70.1, -100.0)
	event.EohSetRot(1, 0.0, 0.0, 0.0)
	event.EohSetPos(2, 0.0, 70.1, -70.0)
	event.EohSetRot(2, 0.0, 0.0, 0.0)
	event.EohSetFootSoundId(2, 21)
	event.EohSetPos(3, 14.22, 0.0, 280.53)
	event.EohSetRot(3, 0.0, 3.04, 0.0)
	event.EohSetMotion(3, "立ち（上見）", 4)
	event.EohSetPos(4, -62.16, 0.0, 310.45)
	event.EohSetRot(4, 0.0, 3.04, 0.0)
	event.EohSetMotion(4, "立ち（上見）", 4)
	event.EohSetPos(5, -171.97, 0.0, 244.75)
	event.EohSetRot(5, 0.0, 2.52, 0.0)
	event.EohSetMotion(5, "立ち（上見）", 4)
	event.EohSetPos(6, -134.34, 0.0, 241.88)
	event.EohSetRot(6, 0.0, 2.64, 0.0)
	event.EohSetMotion(6, "立ち（上見）", 4)
	event.EohSetPos(7, 62.37, 0.0, 316.77)
	event.EohSetRot(7, 0.0, -3.0, 0.0)
	event.EohSetMotion(7, "立ち（上見）", 4)
	event.EohSetPos(8, 143.2, 0.0, 254.62)
	event.EohSetRot(8, 0.0, -2.64, 0.0)
	event.EohSetMotion(8, "立ち（上見）", 4)
	event.InitDramaScene()
	event.ObjsSetMotion(2, "歩き", 4)
	event.ObjsMotionDelay(2, 60)
	event.ObjsSetMotion(2, "立ち")
	event.ObjsMove(2, 0.0, 70.1, -10.0, 60)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "無表情")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "無表情")
	event.EohSetTexAnim(1, 1, "通常目パチ")
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "目パチ")
	event.EohSetTexAnim(3, 0)
	event.EohSetTexAnim(3, 1, "目パチ")
	event.EohSetTexAnim(4, 0)
	event.EohSetTexAnim(4, 1, "目パチ")
	event.EohSetTexAnim(5, 0)
	event.EohSetTexAnim(5, 1, "目パチ")
	event.EohSetTexAnim(6, 0)
	event.EohSetTexAnim(6, 1, "目パチ")
	event.EohSetTexAnim(7, 0)
	event.EohSetTexAnim(7, 1, "目パチ")
	event.EohSetTexAnim(8, 0)
	event.EohSetTexAnim(8, 1, "目パチ")
	event.CmrsInit()
	event.CmrsSetPos(121.52, 158.28, 97.7)
	event.CmrsSetRef(28.49, 109.07, -1.87)
	event.SetFadeIn(30)
	helper_2ddedb3b(2)
	if vm.skipping() then
		return skip(2)
	end
	helper_0c95681b(20)
	if vm.skipping() then
		return skip(3)
	end
	event.CmrsSetPos(0.0, 190.14, -152.05)
	event.CmrsSetRef(0.0, 94.47, 55.83)
	event.ObjsSetMotion(2, "会話（下見）", 6)
	event.ObjsNextMotion(2, "立ち（下見）", 4)
	event.SetPakuAnim(2, "口パク")
	helper_f8047a1c(5400030)
	if vm.skipping() then
		return skip(4)
	end
	helper_2ddedb3b(2)
	if vm.skipping() then
		return skip(5)
	end
	event.SndSePlay(var0, 4)
	event.ObjsSetMotion(3, "歩き")
	event.ObjsMotionDelay(3, 40)
	event.ObjsSetMotion(3, "立ち")
	event.ObjsMove(3, 17.24, 0.0, 350.53, 40)
	event.ObjsRotation(3, 0.0, 0.04, 0.0, 10)
	event.ObjsSetMotion(5, "歩き")
	event.ObjsMotionDelay(5, 40)
	event.ObjsSetMotion(5, "立ち")
	event.ObjsMove(5, -222.61, 0.0, 281.7, 40)
	event.ObjsRotation(5, 0.0, -1.0, 0.0, 10)
	helper_0c95681b(2)
	if vm.skipping() then
		return skip(6)
	end
	event.ObjsSetMotion(4, "走り")
	event.ObjsMotionDelay(4, 38)
	event.ObjsSetMotion(4, "立ち")
	event.ObjsMove(4, -137.5, 0.0, 360.4, 38)
	event.ObjsRotation(4, 0.0, -1.08, 0.0, 10)
	event.ObjsSetMotion(6, "走り")
	event.ObjsMotionDelay(6, 38)
	event.ObjsSetMotion(6, "立ち")
	event.ObjsMove(6, -62.11, 0.0, 215.4, 38)
	event.ObjsRotation(6, 0.0, 2.16, 0.0, 10)
	helper_0c95681b(4)
	if vm.skipping() then
		return skip(7)
	end
	event.ObjsSetMotion(7, "走り")
	event.ObjsMotionDelay(7, 36)
	event.ObjsSetMotion(7, "立ち")
	event.ObjsMove(7, 127.46, 0.0, 350.84, 36)
	event.ObjsRotation(7, 0.0, 0.76, 0.0, 10)
	helper_0c95681b(4)
	if vm.skipping() then
		return skip(8)
	end
	event.ObjsSetMotion(8, "走り")
	event.ObjsMotionDelay(8, 30)
	event.ObjsSetMotion(8, "立ち")
	event.ObjsMove(8, 192.76, 0.0, 152.86, 30)
	event.ObjsRotation(8, 0.0, 2.8, 0.0, 10)
	helper_0c95681b(20)
	if vm.skipping() then
		return skip(9)
	end
	event.SetFadeOut(10)
	helper_0c95681b(10)
	if vm.skipping() then
		return skip(10)
	end
	return part2()
end

--- Helper function.
local function helper_237ec()
	local var0: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	local part3: () -> ...any
	local part4: () -> ...any
	local part5: () -> ...any
	local part6: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_14104()
			if not vm.skipping() then
				return part2()
			end
		end
		if at <= 4 then
			helper_17500()
			if not vm.skipping() then
				return part3()
			end
		end
		if at <= 7 then
			helper_1a948()
			if not vm.skipping() then
				return part4()
			end
		end
		if at <= 10 then
			helper_1c4e0()
			if not vm.skipping() then
				return part5()
			end
		end
		if at <= 13 then
			helper_1daf0()
			if not vm.skipping() then
				return part6()
			end
		end
	end
	function part2()
		if vm.wait() then
			return skip(3)
		end
		event.CharaActive(0, 8)
		event.LoadBgm(116)
		event.PlayBgm(0)
		event.SetMovieCc(0, 0)
		event.SetMovieCc(1, 0, 570, "Paznos... D[UNI00e9]collage !", 60)
		event.SetMovieCc(0, 1)
		event.LoadSound(5513)
		event.AssignStack(5)
		event.ClearStack(5)
		event.SetFadeIn(10)
		event.LoadMovie(5, "movie/e54001.mp4", 0)
		if vm.wait() then
			return skip(4)
		end
		event.SetMovieCc(0, 0)
		event.SetFadeOut(0)
		helper_17500()
		if vm.skipping() then
			return skip(5)
		end
		return part3()
	end
	function part3()
		if vm.wait() then
			return skip(6)
		end
		event.SeAllStop()
		event.SetFadeIn(10)
		event.AssignStack(5)
		event.ClearStack(5)
		event.LoadMovie(5, "movie/e54002.mp4", 0)
		if vm.wait() then
			return skip(7)
		end
		event.SetFadeOut(0)
		helper_1a948()
		if vm.skipping() then
			return skip(8)
		end
		return part4()
	end
	function part4()
		if vm.wait() then
			return skip(9)
		end
		event.SeAllStop()
		var0 = event.GetEventInfoSndid(4) or var0
		event.SndSePlay(var0, 11)
		event.SetFadeIn(10)
		event.AssignStack(5)
		event.ClearStack(5)
		event.LoadMovie(5, "movie/e54003.mp4", 0)
		if vm.wait() then
			return skip(10)
		end
		event.SndSeStop(var0, 11)
		event.SetFadeOut(0)
		helper_1c4e0()
		if vm.skipping() then
			return skip(11)
		end
		return part5()
	end
	function part5()
		if vm.wait() then
			return skip(12)
		end
		event.SeAllStop()
		event.SetFadeIn(10)
		event.AssignStack(5)
		event.ClearStack(5)
		event.LoadMovie(5, "movie/e54004.mp4")
		if vm.wait() then
			return skip(13)
		end
		event.SetFadeOut(0)
		helper_1daf0()
		if vm.skipping() then
			return skip(14)
		end
		return part6()
	end
	function part6()
		event.BgmLoadCancel()
		event.MapJump(-1, "s29", 600)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFlag(540, 1)
	helper_14104()
	if vm.skipping() then
		return skip(2)
	end
	return part2()
end

--- Helper function.
local function helper_e76c()
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
			print("talk_chara_id=", var1, "talk_chara=", var2, "\n")
			var3 = 0
			helper_b5328081(player_chara, var1, 0)
		end
		if at <= 2 then
			helper_85ab2618(0, -1, var1, player_chara, 0)
		end
		if at <= 3 then
			var3 = 1
			helper_0e678234(var1, -1, 0, 0)
		end
		if at <= 4 then
			helper_85ab2618(0, -1, var1, player_chara, 0)
		end
		if at <= 5 then
			helper_40fdc4db(player_chara_2, var20)
		end
		if at <= 6 then
			helper_85ab2618(0, -1, var1, player_chara_2, 0)
		end
		if at <= 7 then
			helper_d54ddd83(30)
		end
		if at <= 8 then
			helper_d54ddd83(28)
		end
		if at <= 9 then
			helper_d54ddd83(29)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	player_chara = event.GetControlChrid() or player_chara
	var1 = event.GetEventData_2(13) or var1
	var2 = event.GetEventData_2(14) or var2
	print("talk_chara_id=", var1, "talk_chara=", var2, "\n")
	event.CtrlcStay()
	event.SetAi(0, var1)
	event.SetMesShippo(0, 1)
	event.SetMesPreset(0, 0)
	event.MesMake_2(0, "Bonjouuuur.\nBeau temps, non ?")
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
							"Gaspard est redoutable. Sois \nvigilant, ne baisse jamais \nla garde, pas m[UNI00ea]me un instant.<page>Je sais que tu peux le battre.\nL'Atlamillia t'a choisi,\nce n'est sans doute pas pour rien."
						)
					else
						event.MesMake_2(
							0,
							"Ah, Gaspard aussi [UNI00e9]tait malheureux.<page>Pourquoi Griffon s'acharne-t-il\n[UNI00e0] d[UNI00e9]truire tant de gens..."
						)
					end
				else
					event.MesMake_2(
						0,
						"Si quelqu'un peut vaincre Griffon, \nc'est bien vous, je le sais.<page>On compte sur vous."
					)
				end
			else
				event.MesMake_2(
					0,
					"L'union chrono... Ainsi, le monde\nva [UNI00ea]tre sauv[UNI00e9] par le savoir des\nanciens..."
				)
			end
		else
			event.MesMake_2(
				0,
				"Alors, nous y voil[UNI00e0], hein ? J'ai\nperdu de nombreux amis dans\nce combat contre Griffon...<page>Vous [UNI00ea]tes notre dernier espoir !\nMax, Monica, je compte sur vous. \nVous devez vaincre Griffon !"
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
								"Bon, pour commencer, il faut \nd[UNI00e9]truire le Lance-feu.<page>Si on ne fait rien contre\nces averses de braises en bas, \nD[UNI00e9]soland est perdu."
							)
						else
							event.MesMake_2(
								0,
								"Alors c'est [UNI00e7]a qui se passait.\nOn peut s'estimer heureux que le\nLance-feu ait [UNI00e9]t[UNI00e9] d[UNI00e9]truit."
							)
							helper_b5328081(player_chara, var1, 0)
							if vm.skipping() then
								return skip(2)
							end
							helper_85ab2618(0, -1, var1, player_chara, 0)
							if vm.skipping() then
								return skip(3)
							end
							var3 = 1
							event.MesMake_2(
								0,
								"Mais je m'inqui[UNI00e8]te pour la personne\nqui est tomb[UNI00e9]e dans le crat[UNI00e8]re.<page>Je suppose que tout ce que nous\npouvons faire, c'est reconstruire\nD[UNI00e9]soland et am[UNI00e9]liorer l'Atelier."
							)
						end
					else
						event.MesMake_2(
							0,
							"Vous avez vaincu Gaspard !\nEh bien ! Vous [UNI00ea]tes [UNI00e9]tonnants !<page>Finissons-en maintenant avec son\nchef, l'Empereur Griffon !"
						)
					end
				else
					event.MesMake_2(
						0,
						"La joie de revoir Paznos [UNI00e0] l'action\nm'a mis les larmes aux yeux.<page>Tout ce pour quoi nous avons\ntravaill[UNI00e9] si dur a finalement pay[UNI00e9]."
					)
				end
			else
				event.MesMake_2(0, "Une pierre ? Huum, ah non, je ne\nconnais vraiment rien [UNI00e0] ce sujet.")
			end
		else
			event.MesMake_2(0, "Il est temps d'affronter Griffon,\nhein ? Bonne chance. Vous l'aurez !")
		end
	end
	if var2 == 402 then
		event.MesMake_2(0, "H[UNI00e9] vous ! On a des trucs g[UNI00e9]niaux\npour vous ! Vous voulez quoi ?")
	end
	if var2 == 403 then
		event.MesMake_2(0, "De quoi avez-vous besoin ? Je le\ntrouverai. J'ai tout ce qu'il faut.")
	end
	if var2 == 404 then
		event.MesMake_2(
			0,
			"Combattre peut [UNI00ea]tre complexe.\nIl ne faut pas toujours se \npr[UNI00e9]cipiter et tirer dans le tas.<page>On peut aussi utiliser des objets,\nrep[UNI00e9]rer les faiblesses de\nl'ennemi et les exploiter."
		)
	end
	if var2 == 405 then
		event.MesMake_2(
			0,
			"On peut tout fabriquer [UNI00e0] l'Atelier\nD[UNI00e9]sogundor. Peu importe la taille,\ngros ou petit, on peut le faire."
		)
	end
	if var2 == 406 then
		event.MesMake_2(
			0,
			"H[UNI00e9], comment [UNI00ea]tes-vous entr[UNI00e9]s ici ?\nVous feriez mieux d'[UNI00ea]tre prudents,\n[UNI00e7]a peut [UNI00ea]tre tr[UNI00e8]s dangereux."
		)
	end
	if var2 == 407 then
		event.MesMake_2(
			0,
			"Mais qu'est-ce qui s'est pass[UNI00e9] ?\nJ'ai l'impression d'avoir \ntout oubli[UNI00e9]..."
		)
	end
	if var2 == 408 then
		event.MesMake_2(0, "Alors Griffon nous a tous effac[UNI00e9]s ?\nCe type est vraiment un monstre.")
	end
	if var2 == 409 then
		event.MesMake_2(0, "J'ai pas mal de travail.\nNe te mets pas dans mes jambes.")
	end
	if var2 == 410 then
		event.MesMake_2(0, "On est tous derri[UNI00e8]re toi, nous\naussi. [UNI00c0] 100 %.")
	end
	if var2 == 411 then
		event.MesMake_2(
			0,
			"On dirait que les armes\nde cette bo[UNI00ee]te ne\nsont pas [UNI00e0] vendre.<page>Il y a vraiment des armes aussi\nbizarres que merveilleuses\ndans ce monde..."
		)
	end
	if var2 == 412 then
		event.MesMake_2(
			0,
			"Alors ce type, Gaspard, peut\nactiver le Lance-feu ?<page>Il n'est pas que rus[UNI00e9]...\nIl est vraiment mal[UNI00e9]fique."
		)
	end
	if var2 == 413 then
		event.MesMake_2(
			0,
			"[UNI00c7]a veut dire quoi ce c[UNI0153]ur,\nsur ce panneau...<page>C'est plut[UNI00f4]t moche,\nsi tu veux mon avis..."
		)
	end
	if var3 == 0 then
		helper_0e678234(var1, -1, 0, 0)
		if vm.skipping() then
			return skip(4)
		end
	end
	if var3 == 1 then
		helper_85ab2618(0, -1, var1, player_chara, 0)
		if vm.skipping() then
			return skip(5)
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
		helper_40fdc4db(player_chara_2, var20)
		if vm.skipping() then
			return skip(6)
		end
		event.SetCharaRot(player_chara_2, 0.0, var20, 0.0)
		event.SetMotion(player_chara_2, "立ち")
		helper_85ab2618(0, -1, var1, player_chara_2, 0)
		if vm.skipping() then
			return skip(7)
		end
		event.ResetCamera(1, 3.1415927)
	end
	event.SetAi(1, var1)
	if var2 == 402 then
		helper_d54ddd83(30)
		if vm.skipping() then
			return skip(8)
		end
	end
	if var2 == 403 then
		helper_d54ddd83(28)
		if vm.skipping() then
			return skip(9)
		end
	end
	if var2 == 404 then
		helper_d54ddd83(29)
		if vm.skipping() then
			return skip(10)
		end
	end
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

script[99] = program_99

--- Program 100.
script[100] = function()
	program_99()
	helper_9dafbc83(-155.0, vm.f32(76.3), -205.0, vm.f32(0.9))
	event.ResetCamera(1, 3.14, 10)
	event.SetFadeIn(30)
end

--- Program 150.
-- Defined empty, so the engine runs this instead of its default.
script[150] = function() end

--- Program 560.
script[560] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_2fb54(4)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 600.
script[600] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_16cb8()
	if vm.skipping() then
		return skip(1)
	end
	event.BgmLoadCancel()
	event.MapJump(-1, "f04", 601)
end

--- Program 601.
script[601] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_17500()
	if vm.skipping() then
		return skip(1)
	end
	event.BgmLoadCancel()
	event.MapJump(-1, "s55", 601)
end

--- Program 602.
script[602] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_1a948()
	if vm.skipping() then
		return skip(1)
	end
	event.BgmLoadCancel()
	event.MapJump(-1, "s55", 602)
end

--- Program 603.
script[603] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_1c4e0()
	if vm.skipping() then
		return skip(1)
	end
	event.BgmLoadCancel()
	event.MapJump(-1, "s55", 603)
end

--- Program 604.
script[604] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_1daf0()
	if vm.skipping() then
		return skip(1)
	end
	event.BgmLoadCancel()
	event.MapJump(-1, "s29", 600)
end

--- Program 605.
script[605] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_213c0()
	if vm.skipping() then
		return skip(1)
	end
	event.MapJump(-1, "s10", 510)
end

--- Program 610.
script[610] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_23fac()
	if vm.skipping() then
		return skip(1)
	end
	event.MapJump(-1, "d06b01", 600)
	if vm.wait() then
		return skip(2)
	end
end

--- Program 620.
script[620] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_25fac()
	if vm.skipping() then
		return skip(1)
	end
	event.MapJump(-1, "s32", 610)
	if vm.wait() then
		return skip(2)
	end
end

--- Program 630.
script[630] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_27d58()
	if vm.skipping() then
		return skip(1)
	end
	event.MapJump(-1, "s32", 620)
	if vm.wait() then
		return skip(2)
	end
end

--- Program 640.
script[640] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_29e38()
	if vm.skipping() then
		return skip(1)
	end
	event.MapJump(-1, "s32", 630)
	if vm.wait() then
		return skip(2)
	end
end

--- Program 650.
script[650] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_2d558()
	if vm.skipping() then
		return skip(1)
	end
	event.MapJump(-1, "s32", 640)
	if vm.wait() then
		return skip(2)
	end
end

--- Program 1000.
script[1000] = function()
	local var0: s32 = 0
	local var1: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	local landing1: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_0c95681b(15)
		end
		if at <= 2 then
			helper_237ec()
			if not vm.skipping() then
				return landing1()
			end
		end
		if at <= 3 then
			helper_e76c()
		end
		if at <= 4 then
			helper_e76c()
		end
	end
	function part2() end
	function landing1()
		return part2()
	end
	event.Initialize()
	var0 = event.GetEventData_2(14) or var0
	var1 = event.GetEventData_2(13) or var1
	if var0 == 400 then
		flag = event.GetFlag(536) or flag
		flag_2 = event.GetFlag(540) or flag_2
		if flag == 1 and flag_2 == 0 then
			local t0 = helper_130b0(var1) == 1
			if vm.skipping() then
				return skip(1)
			end
			if t0 then
				event.FadeOutBgm(15)
				event.SetFadeOut(15)
				helper_0c95681b(15)
				if vm.skipping() then
					return skip(2)
				end
				helper_237ec()
				if vm.skipping() then
					return skip(3)
				end
			end
		else
			helper_e76c()
			if vm.skipping() then
				return skip(4)
			end
		end
	else
		helper_e76c()
		if vm.skipping() then
			return skip(5)
		end
	end
	return part2()
end

--- Program 15400.
script[15400] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetFlag(536, 1)
	event.SetFlag(540, 0)
	program_99()
	helper_237ec()
	if vm.skipping() then
		return skip(1)
	end
end

return script
