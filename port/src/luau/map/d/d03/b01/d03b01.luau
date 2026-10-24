--!strict
-- map/d/d03/b01/d03b01.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_161be1ae = require("@lib/event/helper_161be1ae")
local helper_22e0636e = require("@lib/event/helper_22e0636e")
local helper_23a302d6 = require("@lib/event/helper_23a302d6")
local helper_42b7a2cf = require("@lib/event/helper_42b7a2cf")
local helper_52115bbf = require("@lib/event/helper_52115bbf")
local helper_5b643440 = require("@lib/event/helper_5b643440")
local helper_7ee99e81 = require("@lib/event/helper_7ee99e81")
local helper_9538e344 = require("@lib/event/helper_9538e344")
local helper_9d157a91 = require("@lib/event/helper_9d157a91")
local helper_9dde4b39 = require("@lib/event/helper_9dde4b39")
local helper_b23727d0 = require("@lib/event/helper_b23727d0")
local helper_b2a6ae08 = require("@lib/event/helper_b2a6ae08")
local helper_c746120b = require("@lib/event/helper_c746120b")
local helper_fcdf0839 = require("@lib/event/helper_fcdf0839")

local global0: s32 = 0
local global1: s32 = 0
local global2: s32 = 0
local global3: s32 = 0

--- Helper function.
local function helper_19124()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	event.EohSyncChara(0, 0)
	event.EohSetFootSoundId(0, 2)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetPos(0, 1858.52, -189.52, 1308.84)
	event.ObjsSetRot(0, 0.0, -2.22, 0.0)
	event.ObjsSetMotion(0, "歩き", 4, -1.0, 1)
	event.CmrsSetPos(1910.24, -159.5, 1350.91)
	event.CmrsSetRef(1816.64, -159.5, 1274.78)
	event.ObjsMove(0, 1816.64, -189.5, 1274.78, 60)
	event.SetFadeIn(30)
	helper_c746120b(60)
	if vm.skipping() then
		return skip(1)
	end
	event.EohSetFootSoundId(0, -1)
	event.ResetCamera(0)
	event.Finish()
end

--- Helper function.
local function helper_12b90()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_c746120b(30)
		end
	end
	event.Initialize()
	event.SetMesWindowMode(0, 0)
	event.SetFadeIn(30)
	event.MesMake_2(0, "Ｅ３５６　～ギルトーニ撃退・クレストとの別れ～(つづき)")
	helper_fcdf0839(0, -1, 5, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.SetFadeOut(30)
	helper_c746120b(30)
	if vm.skipping() then
		return skip(2)
	end
	event.Finish()
end

--- Helper function.
local function helper_102e4()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 9 then
			if at <= 1 then
				active_chr_no = 0
				helper_c746120b(80)
			end
			if at <= 2 then
				helper_9538e344(3480010, 120)
			end
			if at <= 3 then
				helper_b2a6ae08()
			end
			if at <= 4 then
				helper_c746120b(10)
			end
			if at <= 5 then
				helper_b2a6ae08()
			end
			if at <= 6 then
				helper_c746120b(10)
			end
			if at <= 7 then
				helper_42b7a2cf(3480020)
			end
			if at <= 8 then
				helper_c746120b(30)
			end
			if vm.skip_end() then
				return skip(10)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.EohSyncChara(0, 1)
		event.EohSetShow(0, 1)
		event.EohSyncChara(0, 2)
		event.EohSetShow(0, 1)
		event.DelExtMotion(0)
		event.DeleteChara(9)
		event.DeleteChara(10)
		event.DeleteChara(11)
		event.LoadMes(0, -1)
		event.SetStatusbarShow(1, 1.0)
		event.SetCharaPos(0, 1390.73, -76.07, 523.09)
		event.SetCharaRot(0, 0.0, -2.28, 0.0)
		event.SetMotion(0, "立ち", 4)
		event.CharaNormalDrive(0)
		event.CharaResetDa(0)
		event.ResetCamera(1, 3.14, 10.0)
		event.SetFadeIn(30)
		event.Finish()
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFlag(348, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.SetProjection(524.9)
	var0 = event.SndLoadSound(3829) or var0
	event.SetStatusbarShow(0, 1.0)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no ~= 0 or active_chr_no ~= 1 then
		event.DngSetupMainUnit(0)
		event.SetActiveChrNo(0)
		active_chr_no = 0
	end
	event.ChangeDir("event/e300/e348/")
	event.LoadMes(0, 5, "e348.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e348_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e348_monica.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.LoadChara(5, "e348_lin.gltf", "info", 11)
	event.CharaActive(11)
	event.EohSyncChara(2, 11)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.ChangeDir("")
	if active_chr_no == 1 then
		event.LoadChara(5, "chara/c01_base.gltf", "info", 9)
		event.LoadEquip(5, 0, 4, "info", 9)
		event.LoadEquip(5, 0, 3, "info", 9)
		event.LoadEquip(5, 0, 2, "info", 9, 10)
		event.LoadMotion(5, "event/e300/e348/e348_mints.gltf", "info", 10)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 9)
		event.EohSyncChara(0, 9)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 0)
	else
		event.LoadChara(5, "chara/c02_base.gltf", "info", 9)
		event.LoadEquip(5, 1, 4, "info", 9)
		event.LoadEquip(5, 1, 3, "info", 9)
		event.LoadEquip(5, 1, 2, "info", 9, 10)
		event.LoadMotion(5, "event/e300/e348/e348_monica.gltf", "info", 9)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 9)
		event.EohSyncChara(1, 9)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 0)
	end
	event.CharaActive(9)
	event.CharaActive(10)
	event.EohSyncChara(3, 1)
	event.EohSetShow(3, 0)
	event.EohSyncChara(4, 2)
	event.EohSetShow(4, 0)
	event.EohSetPos(0, 1521.47, -107.28, 771.74)
	event.EohSetRot(0, 0.0, -2.88, 0.0)
	event.EohSetMotion(0, "歩き", 4)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "デフォルト顔")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	event.EohSetTexAnim(0, 1, "半口")
	event.EohSetFootSoundId(0, 2)
	event.EohSetPos(1, 1505.66, -106.53, 783.49)
	event.EohSetRot(1, 0.0, 3.04, 0.0)
	event.EohSetMotion(1, "歩き", 4)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "デフォルト顔")
	event.EohSetTexAnim(1, 1, "通常目パチ")
	event.EohSetTexAnim(1, 1, "半口")
	event.EohSetFootSoundId(1, 2)
	event.EohSetPos(2, 1506.3, -108.37, 803.96)
	event.EohSetRot(2, 0.0, -3.12, 0.0)
	event.EohSetMotion(2, "歩き", 4)
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "無表情")
	event.EohSetTexAnim(2, 1, "通常目パチ")
	event.EohSetTexAnim(2, 1, "半口")
	event.ObjsMove(0, 1521.47, -107.28, 731.74, 80)
	event.ObjsMove(1, 1505.66, -106.53, 743.49, 80)
	event.ObjsMove(2, 1506.3, -108.37, 763.96, 80)
	event.InitDramaScene()
	event.CmrsInit()
	event.CmrsSetPos(1478.0, -94.44, 748.45)
	event.CmrsSetRef(1526.09, -83.38, 795.48)
	event.CmrsMove(1478.0, -94.44, 708.45, 1526.09, -83.38, 755.48, 80)
	event.SetFadeIn(30)
	helper_c746120b(80)
	if vm.skipping() then
		return skip(2)
	end
	event.CmrsSetPos(1635.22, -45.35, 898.95)
	event.CmrsSetRef(1509.85, -91.47, 744.47)
	event.CmrsMove2(1635.22, -45.35, 898.95, 1509.85, 36.75, 744.47, 60, 0, 1.0)
	event.ObjsSetPos(0, 1522.58, -104.86, 733.22)
	event.ObjsSetRot(0, 0.0, -2.52, 0.0)
	event.ObjsResetDaPosition(0)
	event.ObjsSetPos(1, 1508.09, -104.9, 755.07)
	event.ObjsSetRot(1, 0.0, -2.76, 0.0)
	event.ObjsResetDaPosition(1)
	event.ObjsSetPos(2, 1536.72, -109.15, 777.79)
	event.ObjsSetRot(2, 0.0, -2.68, 0.0)
	event.ObjsMove(0, 1491.96, -99.81, 672.57, 90)
	event.ObjsMove(1, 1473.85, -100.1, 691.32, 90)
	event.ObjsMove(2, 1493.11, -100.84, 700.12, 90)
	helper_9538e344(3480010, 120)
	if vm.skipping() then
		return skip(3)
	end
	helper_b2a6ae08()
	if vm.skipping() then
		return skip(4)
	end
	helper_c746120b(10)
	if vm.skipping() then
		return skip(5)
	end
	event.CmrsSetPos(1459.8, -32.33, 632.79)
	event.CmrsSetRef(1494.99, -96.61, 704.05)
	event.CmrsMove2(1475.8, -54.94, 665.2, 1494.99, -84.52, 704.05, 60, 0, 1.0)
	event.ObjsSetMotion(0, "上向くL", 4, -1.0, 1)
	event.ObjsSetMotion(1, "上向くL", 4, -1.0, 1)
	event.ObjsSetMotion(2, "上見立ち", 4)
	helper_b2a6ae08()
	if vm.skipping() then
		return skip(6)
	end
	helper_c746120b(10)
	if vm.skipping() then
		return skip(7)
	end
	event.CmrsSetPos(1518.17, -76.49, 671.12)
	event.CmrsSetRef(1493.05, -78.0, 693.7)
	event.ObjsSetPos(2, 1501.04, -100.84, 688.87)
	event.ObjsSetRot(2, 0.0, -2.68, 0.0)
	event.SndSePlay(var0, 6)
	event.ObjsSetMotion(1, "右向く", 6, -1.0, 1)
	event.ObjsNextMotion(1, "右向くL", 4)
	helper_42b7a2cf(3480020)
	if vm.skipping() then
		return skip(8)
	end
	event.SetFadeOut(30)
	helper_c746120b(30)
	if vm.skipping() then
		return skip(9)
	end
	return part2()
end

--- Helper function.
local function helper_15fec()
	local active_chr_no: s32 = 0
	event.SetMesWindowMode(0, 7)
	event.SetStatusbarShow(0, 1.0)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		global2 = 0
		global3 = 8
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", global2)
		event.LoadMotion(5, "event/e300/e356/e356_mints.gltf", "info", global2)
		event.EohSyncChara(0, global2)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global2)
		event.LoadChara(5, "chara/c02_base.gltf", "info", global3)
		event.LoadEquip(5, 1, 1, "info", global3, 17)
		event.LoadEquip(5, 1, 0, "info", global3, 18)
		event.LoadEquip(5, 1, 4, "info", global3)
		event.LoadEquip(5, 1, 3, "info", global3)
		event.LoadEquip(5, 1, 2, "info", global3, 12)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global3)
		event.LoadMotion(5, "event/e300/e356/e356_monica.gltf", "info", global3)
		event.EohSyncChara(1, global3)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global3)
		event.CharaActive(1, 12)
		event.CharaActive(0, 17)
		event.CharaActive(0, 18)
	end
	if active_chr_no == 1 then
		global2 = 8
		global3 = 0
		event.LoadChara(5, "chara/c01_base.gltf", "info", global2)
		event.LoadEquip(5, 0, 1, "info", global2, 17)
		event.LoadEquip(5, 0, 0, "info", global2, 18)
		event.LoadEquip(5, 0, 4, "info", global2)
		event.LoadEquip(5, 0, 3, "info", global2)
		event.LoadEquip(5, 0, 2, "info", global2, 12)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", global2)
		event.LoadMotion(5, "event/e300/e356/e356_mints.gltf", "info", global2)
		event.EohSyncChara(0, global2)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global2)
		event.CharaActive(1, 12)
		event.CharaActive(0, 17)
		event.CharaActive(0, 18)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global3)
		event.LoadMotion(5, "event/e300/e356/e356_monica.gltf", "info", global3)
		event.EohSyncChara(1, global3)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global3)
	end
	event.EohSyncChara(2, 1)
	event.EohSetShow(2, 0)
	event.EohSyncChara(3, 2)
	event.EohSetShow(3, 0)
	event.LoadChara(5, "event/e300/e356/e356_lin.gltf", "info", 9)
	event.CharaActive(0, 9)
	event.EohSyncChara(4, 9)
	event.ObjsInit(2, 9)
	event.ObjsSyncObj(2, 4)
	event.EohSyncObj(9, "p06_d03b01")
	event.ObjsInit(9)
	event.ObjsSyncObj(9, 9)
	event.EohSetShow(9, 0)
	event.LoadMes(0, 5, "event/e300/e356/e356.txt")
end

--- Helper function.
local function helper_15ae0()
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
		event.DeleteChara(12)
		event.DeleteChara(17)
		event.DeleteChara(18)
	end
	if active_chr_no == 1 then
		event.CharaActive(1, global3)
		event.CharaActive(0, global2)
		event.DelExtMotion(global2)
		event.DelExtMotion(global3)
		event.DeleteChara(global2)
		event.DeleteChara(12)
		event.DeleteChara(17)
		event.DeleteChara(18)
	end
	event.DeleteChara(9)
	event.SetStatus(1, 0, 256, 0)
	event.EohSyncChara(2, 1)
	event.EohSetShow(2, 1)
	event.EohSyncChara(3, 2)
	event.EohSetShow(3, 1)
	event.EohSetShow(9, 0)
	event.SetStatusbarShow(1, 1.0)
	event.Finish()
end

--- Helper function.
local function helper_17184()
	local var4: s32 = 0
	local time: f32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 21 then
			if at <= 1 then
				helper_42b7a2cf(3560340)
			end
			if at <= 2 then
				helper_c746120b(60)
			end
			if at <= 3 then
				helper_42b7a2cf(3560350)
			end
			if at <= 4 then
				helper_42b7a2cf(3560360)
			end
			if at <= 5 then
				helper_5b643440(2)
			end
			if at <= 6 then
				helper_b2a6ae08()
			end
			if at <= 7 then
				helper_42b7a2cf(3560370)
			end
			if at <= 8 then
				helper_b2a6ae08()
			end
			if at <= 9 then
				helper_42b7a2cf(3560380)
			end
			if at <= 10 then
				helper_42b7a2cf(3560385)
			end
			if at <= 11 then
				helper_42b7a2cf(3560390)
			end
			if at <= 12 then
				helper_b2a6ae08()
			end
			if at <= 13 then
				helper_9538e344(3560400, -1)
			end
			if at <= 14 then
				helper_c746120b(30)
			end
			if at <= 15 then
				helper_42b7a2cf(3560410)
			end
			if at <= 16 then
				helper_42b7a2cf(3560420)
			end
			if at <= 17 then
				helper_42b7a2cf(3560430)
			end
			if at <= 18 then
				helper_42b7a2cf(3560440)
			end
			if at <= 19 then
				helper_c746120b(60)
			end
			if at <= 20 then
				helper_c746120b(170)
			end
			if vm.skip_end() then
				return skip(22)
			end
			return part2()
		end
		if at <= 22 then
			helper_c746120b(30)
		end
		helper_15ae0()
	end
	function part2()
		event.CancelDramaScene()
		event.SetFadeOut(30)
		helper_c746120b(30)
		if vm.skipping() then
			return skip(23)
		end
		event.SetTime(time)
		event.SetTimeStepEnable(1)
		event.SndSeAllStop(4)
		event.BgmLoadCancel()
		if vm.wait() then
			return skip(24)
		end
		helper_15ae0()
		event.ResetCamera(0)
		event.SetFadeIn(30)
	end
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.SetMotionBlur(0)
	event.StopBgm(0)
	event.LoadSound(3847)
	var4 = event.SndLoadSound(3847) or var4
	helper_15fec()
	event.SetStatus(1, 0, 256, 1)
	time = event.GetTime() or time
	event.InitDramaScene()
	event.SetTime(21.0)
	event.SetTimeStepEnable(0)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "無表情")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "無表情")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "無表情")
	event.ObjsTexAnime(2, 1, "通常目パチ")
	event.ObjsTexAnime(2, 1, "半口")
	event.ObjsSetMotion(0, "立ち", 4)
	event.ObjsSetMotion(1, "立ち", 4)
	event.ObjsSetMotion(2, "立ち", 4)
	event.CharaActive(1, global2)
	event.CharaActive(1, global3)
	event.CharaActive(1, 9)
	event.ObjsSetPos(2, 543.2, 144.04, -840.61)
	event.ObjsSetRot(2, 0.0, 1.17, 0.0)
	event.ObjsSetPos(1, 569.2, 139.28, -817.83)
	event.ObjsSetRot(1, 0.0, -2.4, 0.0)
	event.ObjsSetPos(0, 574.57, 140.74, -836.69)
	event.ObjsSetRot(0, 0.0, -1.64, 0.0)
	event.CmrsInitPas()
	event.CmrsSetPasFrm(200)
	event.CmrsAddPas(698.5, 198.36, -687.33, 415.41, 488.3, -904.7)
	event.CmrsAddPas(698.5, 198.36, -687.33, 415.41, 183.45, -904.7)
	event.CmrsStartPas()
	event.SetFadeIn(30)
	helper_c746120b(230)
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsSetPos(515.1, 182.78, -800.37)
	event.CmrsSetRef(557.38, 155.79, -834.03)
	event.ObjsSetMotion(0, "下向く", 6)
	event.ObjsNextMotion(0, "下向くL", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_42b7a2cf(3560340)
	if vm.skipping() then
		return skip(2)
	end
	event.ResetPakuAnim()
	helper_c746120b(60)
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsSetMotion(1, "顔そむけ", 6)
	event.ObjsNextMotion(1, "顔そむけＬ", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_42b7a2cf(3560350)
	if vm.skipping() then
		return skip(4)
	end
	event.ResetPakuAnim()
	event.LoadBgm(59)
	event.PlayBgm(0)
	event.ObjsSetMotion(1, "立ち", 4)
	event.ObjsSetMotion(0, "立ち", 4)
	event.CmrsInitPas()
	event.CmrsSetPasFrm(150)
	event.CmrsAddPas(580.92, 168.28, -803.2, 557.45, 170.23, -863.66)
	event.CmrsAddPas(561.82, 168.28, -795.79, 538.36, 170.23, -856.24)
	event.CmrsStartPas()
	event.ObjsSetMotion(2, "ううん", 6)
	event.ObjsNextMotion(2, "立ち", 4)
	event.SetPakuAnim(4, "通常口パク")
	helper_42b7a2cf(3560360)
	if vm.skipping() then
		return skip(5)
	end
	event.ResetPakuAnim()
	helper_5b643440(2)
	if vm.skipping() then
		return skip(6)
	end
	helper_b2a6ae08()
	if vm.skipping() then
		return skip(7)
	end
	event.CmrsInitPas()
	event.CmrsSetPasFrm(150)
	event.CmrsAddPas(531.29, 159.38, -832.46, 583.97, 163.32, -843.63)
	event.CmrsAddPas(535.18, 159.38, -814.11, 587.86, 163.32, -825.29)
	event.CmrsStartPas()
	event.SetPakuAnim(1, "通常口パク")
	helper_42b7a2cf(3560370)
	if vm.skipping() then
		return skip(8)
	end
	event.ResetPakuAnim()
	helper_b2a6ae08()
	if vm.skipping() then
		return skip(9)
	end
	event.CmrsSetPos(501.31, 169.51, -797.49)
	event.CmrsSetRef(551.47, 171.45, -833.25)
	event.SndSePlay(var4, 34)
	event.ObjsSetMotion(2, "振り向く", 6)
	event.ObjsNextMotion(2, "振り向くL", 4)
	event.SetPakuAnim(4, "通常口パク")
	helper_42b7a2cf(3560380)
	if vm.skipping() then
		return skip(10)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(2, "上向く", 6)
	event.ObjsNextMotion(2, "上向くL", 4)
	event.SetPakuAnim(4, "通常口パク")
	helper_42b7a2cf(3560385)
	if vm.skipping() then
		return skip(11)
	end
	event.ResetPakuAnim()
	event.CmrsInitPas()
	event.CmrsSetPasFrm(200)
	event.CmrsAddPas(521.48, 197.33, -852.11, 539.71, 166.13, -844.52)
	event.CmrsAddPas(511.07, 215.78, -856.44, 539.71, 166.13, -844.52)
	event.CmrsStartPas()
	event.SetPakuAnim(4, "通常口パク")
	helper_42b7a2cf(3560390)
	if vm.skipping() then
		return skip(12)
	end
	event.ResetPakuAnim()
	helper_b2a6ae08()
	if vm.skipping() then
		return skip(13)
	end
	event.CmrsSetPos(501.31, 169.51, -797.49)
	event.CmrsSetRef(551.47, 171.45, -833.25)
	event.SetPakuAnim(1, "通常口パク")
	helper_9538e344(3560400, -1)
	if vm.skipping() then
		return skip(14)
	end
	event.ResetPakuAnim()
	event.SndSePlay(var4, 35)
	event.ObjsSetMotion(2, "向きかえる", 6)
	event.ObjsNextMotion(2, "立ち", 4)
	helper_c746120b(30)
	if vm.skipping() then
		return skip(15)
	end
	event.SetPakuAnim(4, "通常口パク")
	helper_42b7a2cf(3560410)
	if vm.skipping() then
		return skip(16)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(4, "通常口パク")
	helper_42b7a2cf(3560420)
	if vm.skipping() then
		return skip(17)
	end
	event.ResetPakuAnim()
	event.SndSePlay(var4, 36)
	event.ObjsSetMotion(1, "うなづく", 6)
	event.ObjsNextMotion(1, "立ち", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_42b7a2cf(3560430)
	if vm.skipping() then
		return skip(18)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(0, "通常口パク")
	helper_42b7a2cf(3560440)
	if vm.skipping() then
		return skip(19)
	end
	event.ResetPakuAnim()
	helper_c746120b(60)
	if vm.skipping() then
		return skip(20)
	end
	event.CmrsInitPas()
	event.CmrsSetPasFrm(200)
	event.CmrsAddPas(698.5, 198.36, -687.33, 415.41, 183.45, -904.7)
	event.CmrsAddPas(698.5, 198.36, -687.33, 415.41, 488.3, -904.7)
	event.CmrsStartPas()
	helper_c746120b(170)
	if vm.skipping() then
		return skip(21)
	end
	return part2()
end

--- Helper function.
local function helper_132cc()
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
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
	if active_chr_no == 0 then
		global0 = 0
		global1 = 8
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.LoadMotion(5, "event/e300/e352/e352_mints.gltf", "info", global0)
		event.EohSyncChara(0, global0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global0)
		event.LoadChara(5, "chara/c02_base.gltf", "info", global1)
		event.LoadEquip(5, 1, 1, "info", global1, 17)
		event.LoadEquip(5, 1, 0, "info", global1, 18)
		event.LoadEquip(5, 1, 4, "info", global1)
		event.LoadEquip(5, 1, 3, "info", global1)
		event.LoadEquip(5, 1, 2, "info", global1, 12)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.LoadMotion(5, "event/e300/e352/e352_monica1.gltf", "info", global1)
		event.EohSyncChara(1, global1)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global1)
		event.CharaActive(1, 12)
		event.CharaActive(0, 17)
		event.CharaActive(0, 18)
	end
	if active_chr_no == 1 then
		global0 = 8
		global1 = 0
		event.LoadChara(5, "chara/c01_base.gltf", "info", global0)
		event.LoadEquip(5, 0, 1, "info", global0, 17)
		event.LoadEquip(5, 0, 0, "info", global0, 18)
		event.LoadEquip(5, 0, 4, "info", global0)
		event.LoadEquip(5, 0, 3, "info", global0)
		event.LoadEquip(5, 0, 2, "info", global0, 12)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.LoadMotion(5, "event/e300/e352/e352_mints.gltf", "info", global0)
		event.EohSyncChara(0, global0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global0)
		event.CharaActive(1, 12)
		event.CharaActive(0, 17)
		event.CharaActive(0, 18)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.LoadMotion(5, "event/e300/e352/e352_monica1.gltf", "info", global1)
		event.EohSyncChara(1, global1)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global1)
	end
	event.EohSyncChara(2, 1)
	event.EohSetShow(2, 0)
	event.EohSyncChara(3, 2)
	event.EohSetShow(3, 0)
	event.LoadChara(5, "event/e300/e352/e352_lin.gltf", "info", 9)
	event.CharaActive(0, 9)
	event.EohSyncChara(4, 9)
	event.ObjsInit(2, 9)
	event.ObjsSyncObj(2, 4)
	event.EohSyncObj(9, "p06_d03b01")
	event.ObjsInit(9)
	event.ObjsSyncObj(9, 9)
	event.EohSetShow(9, 1)
	event.LoadMes(0, 5, "event/e300/e352/e352.txt")
end

--- Helper function.
local function helper_12d88()
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
		event.DeleteChara(12)
		event.DeleteChara(17)
		event.DeleteChara(18)
	end
	if active_chr_no == 1 then
		event.CharaActive(1, global1)
		event.CharaActive(0, global0)
		event.DelExtMotion(global0)
		event.DelExtMotion(global1)
		event.DeleteChara(global0)
		event.DeleteChara(12)
		event.DeleteChara(17)
		event.DeleteChara(18)
	end
	event.DeleteChara(9)
	event.EohSyncChara(2, 1)
	event.EohSetShow(2, 1)
	event.EohSyncChara(3, 2)
	event.EohSetShow(3, 1)
	event.EohSetShow(9, 0)
	event.SetStatusbarShow(1, 1.0)
	event.Finish()
	if vm.wait() then
		return skip(2)
	end
	event.LoadDungeonMapFile("d03b02")
	event.LoadScript("d03b02/d03b02.stb", 503)
end

--- Helper function.
local function helper_14464()
	local var4: s32 = 0
	local time: f32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 15 then
			if at <= 4 then
				helper_132cc()
				helper_c746120b(230)
			end
			if at <= 5 then
				helper_b2a6ae08()
			end
			if at <= 6 then
				helper_42b7a2cf(3520170)
			end
			if at <= 7 then
				helper_5b643440(1)
			end
			if at <= 8 then
				helper_5b643440(0)
			end
			if at <= 9 then
				helper_42b7a2cf(3520180)
			end
			if at <= 10 then
				helper_5b643440(0)
			end
			if at <= 11 then
				helper_5b643440(0)
			end
			if at <= 12 then
				helper_5b643440(1)
			end
			if at <= 13 then
				helper_b2a6ae08()
			end
			if at <= 14 then
				helper_b2a6ae08()
			end
			if vm.skip_end() then
				return skip(16)
			end
			return part2()
		end
		if at <= 16 then
			helper_c746120b(30)
		end
		if at <= 18 then
			helper_12d88()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SetFadeOut(30)
		helper_c746120b(30)
		if vm.skipping() then
			return skip(17)
		end
		event.SetTime(time)
		event.SetTimeStepEnable(1)
		event.SndSeAllStop(4)
		if vm.wait() then
			return skip(18)
		end
		event.SoundLoadCancel()
		event.BgmLoadCancel()
		helper_12d88()
		if vm.skipping() then
			return skip(19)
		end
	end
	event.SetFlag(352, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.SetMotionBlur(0)
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
	event.LoadSound(3836)
	var4 = event.SndLoadSound(3836) or var4
	helper_132cc()
	time = event.GetTime() or time
	event.InitDramaScene()
	event.SetTime(18.0)
	event.SetTimeStepEnable(0)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "無表情")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "無表情")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "無表情")
	event.ObjsTexAnime(2, 1, "通常目パチ")
	event.ObjsTexAnime(2, 1, "半口")
	event.ObjsSetMotion(0, "立ち", 4)
	event.ObjsSetMotion(1, "立ち", 4)
	event.ObjsSetMotion(2, "上見立ち", 4)
	event.EohSetFootSoundId(0, 2)
	event.EohSetFootSoundId(1, 2)
	event.CharaActive(1, global0)
	event.CharaActive(1, global1)
	event.CharaActive(1, 9)
	event.CmrsSetPos(752.46, 293.85, -635.82)
	event.CmrsSetRef(463.46, 169.14, -865.91)
	event.ObjsSetPos(2, 543.2, 144.04, -840.61)
	event.ObjsSetRot(2, 0.0, -1.99, 0.0)
	event.ObjsSetPos(0, 553.04, 141.0, -816.53)
	event.ObjsSetRot(0, 0.0, -2.4, 0.0)
	event.ObjsSetPos(1, 564.98, 142.65, -851.46)
	event.ObjsSetRot(1, 0.0, -1.64, 0.0)
	event.SndSePlay(var4, 0)
	event.SetFadeIn(30)
	helper_c746120b(230)
	if vm.skipping() then
		return skip(5)
	end
	event.CmrsSetPos(485.46, 185.48, -900.58)
	event.CmrsSetRef(556.75, 169.14, -889.42)
	event.CmrsMove2(477.74, 185.48, -851.26, 549.03, 169.14, -840.1, 120, 2, 1.0)
	helper_b2a6ae08()
	if vm.skipping() then
		return skip(6)
	end
	event.ObjsSeDelay(1, 60)
	event.ObjsSePlay(1, var4, 1)
	event.ObjsMotionDelay(1, 60)
	event.ObjsSetMotion(1, "左向く", 6)
	event.ObjsNextMotion(1, "左向くＬ", 4)
	event.ObjsMotionDelay(0, 60)
	event.ObjsSetMotion(0, "右向く", 6)
	event.ObjsNextMotion(0, "右向くＬ", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_42b7a2cf(3520170)
	if vm.skipping() then
		return skip(7)
	end
	event.ResetPakuAnim()
	helper_5b643440(1)
	if vm.skipping() then
		return skip(8)
	end
	helper_5b643440(0)
	if vm.skipping() then
		return skip(9)
	end
	event.ObjsSetMotion(0, "右向くうなづき", 6)
	event.ObjsNextMotion(0, "右向くL", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_42b7a2cf(3520180)
	if vm.skipping() then
		return skip(10)
	end
	event.ResetPakuAnim()
	helper_5b643440(0)
	if vm.skipping() then
		return skip(11)
	end
	event.ObjsSetMotion(0, "右向く戻り", 6)
	event.ObjsSetMotion(1, "左向く戻り", 6)
	event.ObjsRotation(0, 0.0, -2.04, 0.0, 10)
	event.ObjsRotation(1, 0.0, -2.0, 0.0, 10)
	event.ObjsSetMotion(0, "走り")
	event.ObjsSetMotion(1, "走り", 0, -1.0, 1)
	event.ObjsMove(0, 492.39, 147.92, -843.54, 40, 1)
	event.ObjsMove(1, 498.64, 148.11, -878.52, 40, 1)
	helper_5b643440(0)
	if vm.skipping() then
		return skip(12)
	end
	helper_5b643440(1)
	if vm.skipping() then
		return skip(13)
	end
	event.CmrsMove(516.37, 181.42, -848.28, 565.24, 159.44, -832.68, 120)
	helper_b2a6ae08()
	if vm.skipping() then
		return skip(14)
	end
	event.CmrsSetPos(802.37, 193.9, -653.74)
	event.CmrsSetRef(562.44, 177.39, -814.42)
	event.CmrsInitPas()
	event.CmrsSetPasFrm(120)
	event.CmrsAddPas(802.37, 193.9, -653.74, 562.44, 177.39, -814.42)
	event.CmrsAddPas(802.37, 323.65, -653.74, 562.44, 307.14, -814.42)
	event.CmrsStartPas()
	event.ObjsMove(0, 315.33, 250.34, -928.08, 150, 1)
	event.ObjsMove(1, 324.09, 250.34, -964.29, 150, 1)
	helper_b2a6ae08()
	if vm.skipping() then
		return skip(15)
	end
	return part2()
end

--- Helper function.
local function helper_19544()
	local active_chr_no: s32 = 0
	local var1: any = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_fcdf0839(0, 21, 5, 256, 208)
			end
			if at <= 2 then
				helper_c746120b(10)
			end
			return 0
		end
		if at <= 6 then
			if at <= 4 then
				helper_c746120b(30)
			end
			if at <= 5 then
				helper_c746120b(30)
			end
			return 1
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
			helper_fcdf0839(0, 20, 5, 256, 208)
			if vm.skipping() then
				return skip(1)
			end
		else
			helper_fcdf0839(0, 21, 5, 256, 208)
			if vm.skipping() then
				return skip(2)
			end
		end
		event.SetFadeOut(10)
		helper_c746120b(10)
		if vm.skipping() then
			return skip(3)
		end
		event.SetCharaPos(0, 1804.36, -189.51, 1279.76)
		event.SetCharaRot(0, 0.0, -2.47, 0.0)
		event.SetCameraPos(1889.79, -158.65, 1386.92)
		event.SetCameraRef(1804.36, -159.51, 1279.76)
		event.ResetCamera(0)
		event.SetFadeIn(10)
		event.Finish()
		return 0
	end
	var1 = helper_9dde4b39(2, -1)
	if vm.skipping() then
		return skip(4)
	end
	event.EohSyncChara(0, 0)
	event.EohSetFootSoundId(0, 2)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	if var1 == 0 then
		event.CmrsSetPos(1776.49, -106.69, 1400.79)
		event.CmrsSetRef(1951.33, -163.61, 1351.42)
		event.ObjsSetPos(0, 1943.88, -189.72, 1357.17)
		event.ObjsSetRot(0, 0.0, 1.21, 0.0)
		event.ObjsSetMotion(0, "走り", 4, -1.0, 1)
		event.ObjsInitPas(0)
		event.ObjsSetPasFrm(0, 60)
		event.ObjsAddPas(0, 1943.88, -189.72, 1357.17)
		event.ObjsAddPas(0, 2022.78, -189.88, 1386.95)
		event.ObjsAddPas(0, 2104.45, -195.47, 1399.2)
		event.ObjsAddPas(0, 2155.72, -202.4, 1401.26)
		event.ObjsStartPas(0)
		helper_c746120b(30)
		if vm.skipping() then
			return skip(5)
		end
		event.SetFadeOut(30)
		helper_c746120b(30)
		if vm.skipping() then
			return skip(6)
		end
		event.SetMotion(0, "立ち", 4)
		event.EohSetFootSoundId(0, -1)
		return 1
	else
		do
			local out1, out2, out3 = event.GetCharaPos(0)
			var2 = out1 or var2
			var3 = out2 or var3
			var4 = out3 or var4
		end
		var5 = vm.f32(vm.f32(vm.sin(vm.f32(-2.14)) * 30.0) + var2)
		var6 = var3
		var7 = vm.f32(vm.f32(vm.cos(vm.f32(-2.14)) * 30.0) + var4)
		event.ObjsMove(0, var5, var6, var7, 30, 1)
		event.ObjsReference(0, var5, var6, var7, 10)
		event.ObjsSetMotion(0, "歩き")
		var8 = 0
		while var8 < 30 do
			do
				local out1, out2, out3 = event.GetCharaPos(0)
				var2 = out1 or var2
				var3 = out2 or var3
				var4 = out3 or var4
			end
			var3 = vm.f32(var3 + 30.0)
			event.SetCameraRef(var2, var3, var4)
			var8 = var8 + 1
			if vm.wait() then
				return skip(7)
			end
		end
		event.EohSetFootSoundId(0, -1)
		event.ResetCamera(0)
		event.Finish()
	end
	return 0
end

--- Helper function.
local function helper_c9e8(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_7ee99e81(1, 4)
			helper_fcdf0839(1, vm.i32(60 + arg0), 8, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(1, 4)
	helper_7ee99e81(1, 4)
	helper_fcdf0839(1, vm.i32(60 + arg0), 8, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_def4(arg0: any, arg1: any)
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
				helper_9d157a91()
			end
			if at <= 2 then
				helper_c746120b(30)
			end
			if at <= 3 then
				helper_b23727d0(arg1, -1)
			end
			if at <= 4 then
				helper_c746120b(10)
			end
			if at <= 5 then
				helper_c746120b(30)
			end
			if at <= 6 then
				helper_c746120b(120)
			end
			if at <= 7 then
				local _ = helper_22e0636e(0)
			end
			if at <= 8 then
				helper_c9e8(1)
			end
			if at <= 9 then
				helper_c9e8(4)
			end
			if at <= 10 then
				helper_c9e8(active_chr_no)
			end
			if at <= 11 then
				helper_c9e8(1)
			end
			if at <= 12 then
				helper_c746120b(30)
			end
			if at <= 14 then
				helper_c746120b(30)
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
	helper_c746120b(30)
	if vm.skipping() then
		return skip(1)
	end
	event.SetStatusbarShow(0, 0.06666667)
	helper_9d157a91()
	if vm.skipping() then
		return skip(2)
	end
	event.LoadBgmPack(60)
	if var8 == 1 or var8 ~= 1 and arg1 < 0 then
		event.PlayBgm(0)
	end
	helper_c746120b(30)
	if vm.skipping() then
		return skip(3)
	end
	event.DngPause(1, 1)
	event.DngCollisionAllClr()
	if var8 ~= 1 then
		block = event.LoadImg_4(5, "textures/dungeon/image/gameover.json", 1) or block
		if arg1 >= 0 then
			helper_b23727d0(arg1, -1)
			if vm.skipping() then
				return skip(4)
			end
			helper_c746120b(10)
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
		helper_c746120b(30)
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
		helper_c746120b(120)
		if vm.skipping() then
			return skip(7)
		end
		while true do
			if helper_22e0636e(0) ~= 0 then
				break
			end
			if vm.wait() then
				return skip(8)
			end
		end
	elseif active_chr_no == 3 then
		var10 = event.CheckEnableCharaChange(1) or var10
		if var10 == 0 then
			helper_c9e8(1)
			if vm.skipping() then
				return skip(9)
			end
		else
			helper_c9e8(4)
			if vm.skipping() then
				return skip(10)
			end
		end
	elseif active_chr_no == 0 or active_chr_no == 2 then
		helper_c9e8(active_chr_no)
		if vm.skipping() then
			return skip(11)
		end
	else
		helper_c9e8(1)
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
		helper_c746120b(30)
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
		helper_c746120b(30)
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
	helper_c746120b(4)
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
local function helper_101c0(arg0: s32)
	return helper_def4(arg0, -1)
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 99.
script[99] = helper_161be1ae

--- Program 100.
script[100] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_161be1ae()
	helper_19124()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 150.
script[150] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_23a302d6(32)
		end
	end
	if vm.wait() then
		return skip(1)
	end
	helper_23a302d6(32)
	if vm.skipping() then
		return skip(2)
	end
end

--- Program 500.
-- Defined empty, so the engine runs this instead of its default.
script[500] = function() end

--- Program 501.
script[501] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_12b90()
	if vm.skipping() then
		return skip(1)
	end
	event.GotoEdit(1, 502)
end

--- Program 502.
script[502] = function()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_102e4()
			if not vm.skipping() then
				return part2()
			end
		end
	end
	function part2() end
	event.Initialize()
	event.FuncPointShow("", "e348", 0)
	helper_52115bbf()
	event.SetFadeOut(30)
	helper_c746120b(30)
	if vm.skipping() then
		return skip(1)
	end
	helper_102e4()
	if vm.skipping() then
		return skip(2)
	end
	return part2()
end

--- Program 503.
script[503] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_17184()
	if vm.skipping() then
		return skip(1)
	end
	event.MapJump(-1, "g02", 502)
end

--- Program 504.
script[504] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_14464()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 510.
script[510] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	local t0 = helper_19544()
	if vm.skipping() then
		return skip(1)
	end
	if t0 ~= 0 then
		event.LoadScript("d03/d03.stb", 1000)
	end
end

--- Program 1200.
script[1200] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_101c0(0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 13480.
script[13480] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_102e4()
	if vm.skipping() then
		return skip(1)
	end
end

return script
