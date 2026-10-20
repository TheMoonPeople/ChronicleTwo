--!strict
-- map/s/s70/s70_5.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1eb1cb40 = require("@lib/event/helper_1eb1cb40")
local helper_23bda4ba = require("@lib/event/helper_23bda4ba")
local helper_261c70db = require("@lib/event/helper_261c70db")
local helper_3ea45d11 = require("@lib/event/helper_3ea45d11")
local helper_4896c0c7 = require("@lib/event/helper_4896c0c7")
local helper_7e238e1a = require("@lib/event/helper_7e238e1a")
local helper_ab9c465c = require("@lib/event/helper_ab9c465c")
local helper_adea7ba0 = require("@lib/event/helper_adea7ba0")

local global0: s32 = 0
local global1: s32 = 0
local global2: s32 = 0
local global3: s32 = 0

--- Program 99.
local function program_99() end

--- Helper function.
local function helper_11490()
	local active_chr_no: s32 = 0
	event.SetMesWindowMode(0, 7)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		global2 = 0
		global3 = 32
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", global2)
		event.LoadMotion(5, "event/e600/e616/e616_mints.gltf", "info", global2)
		event.EohSyncChara(0, global2)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global2)
		event.LoadChara(5, "chara/c02_base.gltf", "info", global3)
		event.LoadEquip(5, 1, 4, "info", global3)
		event.LoadEquip(5, 1, 3, "info", global3)
		event.LoadEquip(5, 1, 2, "info", global3, 37)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global3)
		event.LoadMotion(5, "event/e600/e616/e616_monica.gltf", "info", global3)
		event.EohSyncChara(1, global3)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global3)
		event.CharaActive(1, 37)
	end
	if active_chr_no == 1 then
		global2 = 32
		global3 = 0
		event.LoadChara(5, "chara/c01_base.gltf", "info", global2)
		event.LoadEquip(5, 0, 4, "info", global2)
		event.LoadEquip(5, 0, 3, "info", global2)
		event.LoadEquip(5, 0, 2, "info", global2, 37)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", global2)
		event.LoadMotion(5, "event/e600/e616/e616_mints.gltf", "info", global2)
		event.EohSyncChara(0, global2)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global2)
		event.CharaActive(1, 37)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global3)
		event.LoadMotion(5, "event/e600/e616/e616_monica.gltf", "info", global3)
		event.EohSyncChara(1, global3)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global3)
	end
	event.LoadChara(5, "event/e600/e616/e616_osmond.gltf", "info", 38)
	event.CharaActive(0, 38)
	event.EohSyncChara(2, 38)
	event.ObjsInit(2, 38)
	event.ObjsSyncObj(2, 2)
	event.LoadChara(5, "event/e600/e616/e616_toryon.gltf", "info", 39)
	event.CharaActive(0, 39)
	event.EohSyncChara(3, 39)
	event.ObjsInit(3, 39)
	event.ObjsSyncObj(3, 3)
	event.LoadChara(5, "event/e600/e616/e616_beam_f.gltf", "info", 40)
	event.CharaActive(0, 40)
	event.EohSyncChara(4, 40)
	event.ObjsInit(4, 40)
	event.ObjsSyncObj(4, 4)
	event.LoadChara(5, "event/e600/e616/e616_beam_h.gltf", "info", 41)
	event.CharaActive(0, 41)
	event.EohSyncChara(5, 41)
	event.ObjsInit(5, 41)
	event.ObjsSyncObj(5, 5)
	event.LoadChara(5, "event/e600/e616/e616_tama1.gltf", "info", 42)
	event.CharaActive(0, 42)
	event.EohSyncChara(6, 42)
	event.ObjsInit(6, 42)
	event.ObjsSyncObj(6, 6)
	event.LoadChara(5, "event/e600/e616/e616_ozu_moe.gltf", "info", 43)
	event.CharaActive(0, 43)
	event.LoadChara(5, "event/e600/e616/e616_ozu_kemuri.gltf", "info", 44)
	event.CharaActive(0, 44)
	event.EsmInitialize(5)
	event.EsmLoadBase("Ｅ６１６月花ビームＢ")
	event.EsmInitFix(5)
	event.LoadMes(0, 5, "event/e600/e616/e616_1.txt")
end

--- Helper function.
local function helper_110bc()
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
	event.DeleteChara(38)
	event.DeleteChara(39)
	event.DeleteChara(40)
	event.DeleteChara(41)
	event.DeleteChara(42)
	event.DeleteChara(43)
	event.DeleteChara(44)
end

--- Helper function.
local function helper_128a0()
	local var6: s32 = 0
	local projection: f32 = 0
	local var8: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 21 then
			if at <= 1 then
				helper_4896c0c7(6160070)
			end
			if at <= 2 then
				helper_adea7ba0(30)
			end
			if at <= 3 then
				helper_adea7ba0(10)
			end
			if at <= 4 then
				helper_adea7ba0(60)
			end
			if at <= 5 then
				var8 = 2
				helper_3ea45d11(6160080, -1)
			end
			if at <= 6 then
				helper_3ea45d11(6160090, -1)
			end
			if at <= 7 then
				helper_23bda4ba(2)
			end
			if at <= 8 then
				helper_23bda4ba(2)
			end
			if at <= 9 then
				helper_adea7ba0(30)
			end
			if at <= 10 then
				helper_adea7ba0(90)
			end
			if at <= 11 then
				helper_4896c0c7(6160100)
			end
			if at <= 16 then
				helper_adea7ba0(60)
			end
			if at <= 17 then
				helper_261c70db()
			end
			if at <= 18 then
				helper_261c70db()
			end
			if at <= 19 then
				helper_4896c0c7(6160110)
			end
			if at <= 20 then
				helper_adea7ba0(35)
			end
			if vm.skip_end() then
				return skip(22)
			end
			return part2()
		end
		helper_110bc()
	end
	function part2()
		event.CancelDramaScene()
		event.BgmLoadCancel()
		event.SetWind(-1)
		event.SndSeStop(var6, 10)
		event.SndSeAllStop(4)
		event.SeAllStop()
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.EsmClear()
		if vm.wait() then
			return skip(23)
		end
		helper_110bc()
		event.SetProjection(projection)
		event.ResetCamera(0)
		event.SetFadeIn(30)
	end
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.LoadSound(7200)
	var6 = event.SndLoadSound(7200) or var6
	helper_11490()
	projection = event.GetProjection() or projection
	event.InitDramaScene()
	event.EohSetFootSoundId(0, 16)
	event.EohSetFootSoundId(1, 16)
	event.EohSetFootSoundId(2, 16)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おこり顔")
	event.ObjsTexAnime(0, 1, "おこり目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "おこり顔")
	event.ObjsTexAnime(1, 1, "おこり目パチ")
	event.CharaActive(0, global2)
	event.CharaActive(1, global3)
	event.CharaActive(1, 38)
	event.ObjsSetMotion(0, "立ち", 4, -1.0, 1)
	event.ObjsSetMotion(1, "何てこと", 6, -1.0, 1)
	event.Ext(466, 1, "何てことL", 4, -1.0, 1) -- retail: the handler rejects 5 arguments
	event.ObjsSetMotion(2, "立ち（上見）", 4)
	event.ObjsSetPos(1, 32.0, 0.0, 1400.0)
	event.ObjsSetRot(1, 0.0, -0.59, 0.0)
	event.ObjsSetPos(0, -32.0, 0.0, 1400.0)
	event.ObjsSetRot(0, 0.0, 3.13, 0.0)
	event.ObjsSetPos(2, 17.0, 0.0, 1400.0)
	event.ObjsSetRot(2, 0.0, 0.01, 0.0)
	event.ObjsSetPos(3, 418.95, 294.2, 1072.8)
	event.ObjsSetRot(3, 0.0, -2.72, 0.0)
	event.ObjsSetPos(4, 0.0, 0.0, 0.0)
	event.ObjsSetRot(4, 0.0, 0.0, 0.0)
	event.ObjsSetPos(5, 17.0, 0.0, 1380.0)
	event.ObjsSetRot(5, 0.0, 0.0, 0.0)
	event.CmrsSetPos(-9.53, 17.78, 1399.96)
	event.CmrsSetRef(36.07, 23.27, 1405.88)
	event.SetFadeIn(30)
	event.SetPakuAnim(1, "通常口パク")
	helper_4896c0c7(6160060)
	if vm.skipping() then
		return skip(1)
	end
	event.ResetPakuAnim()
	event.SndSePlay(var6, 6)
	event.SetPakuAnim(2, "通常口パク")
	helper_4896c0c7(6160070)
	if vm.skipping() then
		return skip(2)
	end
	event.ResetPakuAnim()
	event.SndSePlay(var6, 7)
	helper_adea7ba0(30)
	if vm.skipping() then
		return skip(3)
	end
	event.SndSePlay(var6, 8)
	event.SetWind(80.0, 17.0, 0.0, 1380.0)
	event.SetMotion(41, "ヒット", 6, -1, 1)
	event.CharaActive(1, 41)
	helper_adea7ba0(10)
	if vm.skipping() then
		return skip(4)
	end
	event.SndSePlay(var6, 9)
	event.SetWind(-1)
	event.ObjsSetMotion(1, "後ろ爆発", 6)
	event.ObjsNextMotion(1, "後ろ爆発L", 4)
	event.ObjsSetMotion(2, "とびあがる", 2)
	event.ObjsNextMotion(2, "とびあがるループ", 4)
	helper_adea7ba0(60)
	if vm.skipping() then
		return skip(5)
	end
	event.SetReference(38, "hi", 43)
	event.CharaActive(1, 43)
	event.CharaActive(0, 41)
	event.SetMotion(43, "走り（燃える）", 4, -1, 1)
	event.ObjsSetPos(4, 913.78, 1615.71, -1455.71)
	event.ObjsSetPos(6, 913.78, 1615.71, -1455.71)
	event.ObjsSetRot(6, 0.0, -0.16, 0.0)
	event.ObjsSetPos(5, 0.0, 0.0, 1380.0)
	event.CharaActive(1, global2)
	event.ObjsSetRot(1, 0.0, 3.13, 0.0)
	event.ObjsSetMotion(2, "走り（燃える）", 4)
	event.SetProjection(400.0)
	event.CmrsSetPos(0.0, 38.21, 1638.99)
	event.CmrsSetRef(0.0, 194.92, 737.84)
	var8 = 2
	event.ObjsInitPas(var8)
	event.ObjsSetPasFrm(var8, 180)
	event.ObjsAddPas(var8, 0.0, 0.0, 1350.0)
	event.ObjsAddPas(var8, 100.0, 0.0, 1250.0)
	event.ObjsAddPas(var8, 0.0, 0.0, 1150.0)
	event.ObjsAddPas(var8, -100.0, 0.0, 1250.0)
	event.ObjsAddPas(var8, 0.0, 0.0, 1350.0)
	event.ObjsAddPas(var8, 100.0, 0.0, 1250.0)
	event.ObjsAddPas(var8, 0.0, 0.0, 1150.0)
	event.ObjsAddPas(var8, -100.0, 0.0, 1250.0)
	event.ObjsAddPas(var8, 0.0, 0.0, 1350.0)
	event.ObjsStartPas(var8)
	event.CharaActive(1, 40)
	event.ObjsSetMotion(4, "入り", 6)
	event.ObjsNextMotion(4, "溜めループ", 4)
	event.SndSePlay(var6, 3)
	helper_3ea45d11(6160080, -1)
	if vm.skipping() then
		return skip(6)
	end
	helper_3ea45d11(6160090, -1)
	if vm.skipping() then
		return skip(7)
	end
	helper_23bda4ba(2)
	if vm.skipping() then
		return skip(8)
	end
	event.ObjsSetMotion(0, "走り")
	event.ObjsSetMotion(1, "走り")
	event.ObjsRotation(2, 0.0, 0.01, 0.0, 20)
	event.ObjsRotation(1, 0.0, 0.01, 0.0, 20)
	event.ObjsRotation(0, 0.0, -0.01, 0.0, 20)
	helper_23bda4ba(2)
	if vm.skipping() then
		return skip(9)
	end
	event.CharaActive(1, 42)
	event.SndSePlay(var6, 4)
	event.EsmCreate("Ｅ６１６月花ビームＢ")
	event.EsmSetVect1(913.78, 1615.71, -1455.71)
	event.EsmSetVect2(0.0, -0.16, 0.0)
	event.ObjsSetMotion(4, "発射", 6)
	event.ObjsSetMotion(6, "弾道", 6)
	event.ObjsMove(0, -32.0, 0.0, 1818.0, 60)
	event.ObjsMove(1, 32.0, 0.0, 1818.0, 60)
	event.ObjsMove(2, 0.0, 0.0, 1818.0, 60)
	helper_adea7ba0(30)
	if vm.skipping() then
		return skip(10)
	end
	event.CharaActive(1, 41)
	event.SetMotion(41, "ヒット", 6, -1, 1)
	event.SndSePlay(var6, 5)
	helper_adea7ba0(90)
	if vm.skipping() then
		return skip(11)
	end
	event.CharaActive(0, 40)
	event.SetProjection(projection)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おこり顔")
	event.ObjsTexAnime(0, 1, "おこり目～おどろき目")
	event.ObjsSetPos(0, -32.0, 0.0, 2418.0)
	event.SndSePlay(var6, 10)
	event.CmrsSetPos(-4.22, 16.51, 2448.91)
	event.CmrsSetRef(-30.91, 22.39, 2407.0)
	event.ObjsSetMotion(0, "左後ろ見る", 6, -1.0, 1)
	event.ObjsNextMotion(0, "左後ろ見るL", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_4896c0c7(6160100)
	if vm.skipping() then
		return skip(12)
	end
	event.ResetPakuAnim()
	event.StopBgm(0)
	if vm.wait() then
		return skip(13)
	end
	if vm.wait() then
		return skip(14)
	end
	if vm.wait() then
		return skip(15)
	end
	if vm.wait() then
		return skip(16)
	end
	event.LoadBgm(190)
	event.EohSyncChrobj(20, 39, "puropera")
	event.ObjsInit(20)
	event.ObjsSyncObj(20, 20)
	event.ObjsRotation(20, 0.0, -0.08, 0.0, -1)
	event.PlayBgm(0)
	event.CharaActive(1, 39)
	event.ObjsSetMotion(3, "浮遊", 4)
	event.CmrsSetPos(329.6, 416.23, 860.98)
	event.CmrsSetRef(418.95, 436.16, 1072.8)
	helper_adea7ba0(60)
	if vm.skipping() then
		return skip(17)
	end
	event.CmrsMove2(117.44, 416.23, 937.94, 373.95, 436.16, 1038.44, 90, 0, 0.4)
	helper_261c70db()
	if vm.skipping() then
		return skip(18)
	end
	event.CmrsMove2(-325.06, 685.54, 1733.22, 87.51, 627.46, 1290.16, 150, 0, 0.4)
	helper_261c70db()
	if vm.skipping() then
		return skip(19)
	end
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おこり顔")
	event.ObjsTexAnime(0, 1, "おこり目パチ")
	event.CharaActive(0, 43)
	event.DelReference(43)
	event.SetReference(38, "hi", 44)
	event.CharaActive(1, 44)
	event.SetMotion(44, "立ち（煙）", 4, -1, 1)
	event.ObjsSetMotion(1, "立ち", 4, -1.0, 1)
	event.ObjsSetMotion(2, "立ち（煙）", 4)
	event.ObjsSetMotion(1, "走り", 4)
	event.CmrsSetPos(-154.51, 10.06, 1495.9)
	event.CmrsSetRef(1.55, 150.34, 2062.42)
	event.ObjsSetPos(1, -81.32, 0.0, 1615.39)
	event.ObjsSetRot(1, 0.0, -0.59, 0.0)
	event.ObjsSetPos(0, -148.27, 0.0, 1617.78)
	event.ObjsSetRot(0, 0.0, 0.13, 0.0)
	event.ObjsSetPos(2, -101.78, 0.0, 1761.73)
	event.ObjsSetRot(2, 0.0, 0.01, 0.0)
	event.ObjsMove(1, -98.54, 0.0, 1658.48, 20)
	event.ObjsRotDelay(1, 20)
	event.ObjsRotation(1, 0.0, -2.63, 0.0, 10)
	event.ObjsMotionDelay(1, 40)
	event.ObjsSetMotion(1, "立ち")
	event.ObjsNextMotion(1, "会話", 2)
	event.ObjsNextMotion(1, "立ち")
	helper_4896c0c7(6160110)
	if vm.skipping() then
		return skip(20)
	end
	event.ObjsSetMotion(0, "左後ろ見る戻り", 6, -1.0, 1)
	event.SetFadeOut(30)
	helper_adea7ba0(35)
	if vm.skipping() then
		return skip(21)
	end
	return part2()
end

--- Helper function.
local function helper_e8b8()
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
		event.LoadMotion(5, "event/e600/e616/e616_mints.gltf", "info", global0)
		event.EohSyncChara(0, global0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global0)
		event.LoadChara(5, "chara/c02_base.gltf", "info", global1)
		event.LoadEquip(5, 1, 4, "info", global1)
		event.LoadEquip(5, 1, 3, "info", global1)
		event.LoadEquip(5, 1, 2, "info", global1, 37)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.LoadMotion(5, "event/e600/e616/e616_monica.gltf", "info", global1)
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
		event.LoadMotion(5, "event/e600/e616/e616_mints.gltf", "info", global0)
		event.EohSyncChara(0, global0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global0)
		event.CharaActive(1, 37)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.LoadMotion(5, "event/e600/e616/e616_monica.gltf", "info", global1)
		event.EohSyncChara(1, global1)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global1)
	end
	event.LoadChara(5, "event/e600/e616/e616_osmond.gltf", "info", 38)
	event.CharaActive(0, 38)
	event.EohSyncChara(2, 38)
	event.ObjsInit(2, 38)
	event.ObjsSyncObj(2, 2)
	event.LoadMes(0, 5, "event/e600/e616/e616_1.txt")
end

--- Helper function.
local function helper_e550()
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
	event.SetStatus(1, 0, 256, 0)
	event.DeleteChara(38)
	event.Finish()
	if vm.wait() then
		return skip(2)
	end
end

--- Helper function.
local function helper_f63c()
	local var6: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 16 then
			if at <= 1 then
				helper_e8b8()
				helper_4896c0c7(6160010)
			end
			if at <= 2 then
				helper_23bda4ba(2)
			end
			if at <= 3 then
				helper_adea7ba0(15)
			end
			if at <= 4 then
				helper_23bda4ba(2)
			end
			if at <= 5 then
				helper_adea7ba0(30)
			end
			if at <= 6 then
				helper_23bda4ba(2)
			end
			if at <= 7 then
				helper_adea7ba0(30)
			end
			if at <= 8 then
				helper_4896c0c7(6160020)
			end
			if at <= 9 then
				helper_4896c0c7(6160030)
			end
			if at <= 10 then
				helper_4896c0c7(6160040)
			end
			if at <= 11 then
				helper_adea7ba0(15)
			end
			if at <= 12 then
				helper_4896c0c7(6160050)
			end
			if at <= 13 then
				helper_adea7ba0(30)
			end
			if at <= 14 then
				helper_adea7ba0(200)
			end
			if at <= 15 then
				helper_adea7ba0(35)
			end
			if vm.skip_end() then
				return skip(17)
			end
			return part2()
		end
		if at <= 18 then
			helper_e550()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.BgmLoadCancel()
		event.SndSeAllStop(4)
		if vm.wait() then
			return skip(18)
		end
		helper_e550()
		if vm.skipping() then
			return skip(19)
		end
		event.ResetCamera(0)
		event.SetFadeIn(30)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFlag(616, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.LoadSound(7200)
	var6 = event.SndLoadSound(7200) or var6
	helper_e8b8()
	event.InitDramaScene()
	event.SetStatus(1, 0, 256, 1)
	event.EohSetFootSoundId(0, 16)
	event.EohSetFootSoundId(1, 16)
	event.EohSetFootSoundId(2, 16)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "無表情")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "無表情")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.CharaActive(1, global0)
	event.CharaActive(1, global1)
	event.CharaActive(1, 38)
	event.CmrsSetPos(0.0, 20.12, 505.57)
	event.CmrsSetRef(0.0, 30.0, 1531.66)
	event.ObjsSetMotion(0, "歩き", 4, -1.0, 1)
	event.ObjsMotionDelay(0, 180)
	event.ObjsSetMotion(0, "立ち", 4)
	event.ObjsSetMotion(1, "歩き", 4, -1.0, 1)
	event.ObjsMotionDelay(1, 180)
	event.ObjsSetMotion(1, "立ち", 4)
	event.ObjsSetMotion(2, "走り")
	event.ObjsMotionDelay(2, 200)
	event.ObjsSetMotion(2, "とまる", 4)
	event.ObjsSetPos(1, 16.0, 0.0, 621.38)
	event.ObjsSetRot(1, 0.0, 0.0, 0.0)
	event.ObjsSetPos(0, -16.0, 0.0, 621.38)
	event.ObjsSetRot(0, 0.0, 0.0, 0.0)
	event.ObjsSetPos(2, 0.0, 0.0, 2232.39)
	event.ObjsSetRot(2, 0.0, 3.13, 0.0)
	event.SetFadeIn(30)
	event.ObjsInitPas(2)
	event.ObjsSetPasFrm(2, 200)
	event.ObjsAddPas(2, 0.0, 0.0, 2232.39)
	event.ObjsAddPas(2, 0.0, 0.0, 527.58)
	event.ObjsStartPas(2)
	event.ObjsInitPas(0)
	event.ObjsSetPasFrm(0, 180)
	event.ObjsAddPas(0, -16.0, 0.0, 621.38)
	event.ObjsAddPas(0, -16.0, 0.0, 730.69)
	event.ObjsStartPas(0)
	event.ObjsInitPas(1)
	event.ObjsSetPasFrm(1, 180)
	event.ObjsAddPas(1, 16.0, 0.0, 621.38)
	event.ObjsAddPas(1, 16.0, 0.0, 730.69)
	event.ObjsStartPas(1)
	helper_4896c0c7(6160010)
	if vm.skipping() then
		return skip(2)
	end
	helper_23bda4ba(2)
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsSetRot(1, 0.0, 3.13, 0.0)
	event.ObjsSetRot(0, 0.0, 3.13, 0.0)
	helper_adea7ba0(15)
	if vm.skipping() then
		return skip(4)
	end
	event.SndSePlay(var6, 1)
	event.ObjsRotation(2, 0.0, 0.01, 0.0, 30)
	helper_23bda4ba(2)
	if vm.skipping() then
		return skip(5)
	end
	helper_adea7ba0(30)
	if vm.skipping() then
		return skip(6)
	end
	event.ObjsSetMotion(2, "走り")
	event.ObjsInitPas(2)
	event.ObjsSetPasFrm(2, 60)
	event.ObjsAddPas(2, 0.0, 0.0, 527.58)
	event.ObjsAddPas(2, 0.0, 0.0, 700.0)
	event.ObjsStartPas(2)
	helper_23bda4ba(2)
	if vm.skipping() then
		return skip(7)
	end
	event.ObjsSetMotion(0, "下見立ち", 4, -1.0, 1)
	event.ObjsSetMotion(1, "下見立ち", 4, -1.0, 1)
	event.ObjsSetMotion(2, "ぜいぜい", 4)
	event.ObjsSetRot(1, 0.0, -2.55, 0.0)
	event.ObjsSetRot(0, 0.0, 2.89, 0.0)
	event.CmrsSetPos(-38.64, 38.38, 652.69)
	event.CmrsSetRef(-1.85, 14.77, 711.67)
	helper_adea7ba0(30)
	if vm.skipping() then
		return skip(8)
	end
	event.ObjsSetMotion(0, "下見会話", 2)
	event.ObjsNextMotion(0, "下見立ち")
	event.SetPakuAnim(0, "通常口パク")
	helper_4896c0c7(6160020)
	if vm.skipping() then
		return skip(9)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(2, "ぜいぜい（見上げ）in", 2)
	event.ObjsNextMotion(2, "ぜいぜい（見上げ）", 4)
	helper_4896c0c7(6160030)
	if vm.skipping() then
		return skip(10)
	end
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "無表情")
	event.ObjsTexAnime(1, 1, "通常目～おこり目")
	event.ObjsSetMotion(1, "キョロキョロ")
	event.SetPakuAnim(1, "通常口パク")
	helper_4896c0c7(6160040)
	if vm.skipping() then
		return skip(11)
	end
	event.ResetPakuAnim()
	helper_adea7ba0(15)
	if vm.skipping() then
		return skip(12)
	end
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おこり顔")
	event.ObjsTexAnime(0, 1, "おこり目パチ")
	event.CmrsSetPos(-28.76, 13.15, 706.38)
	event.CmrsSetRef(-17.78, 21.48, 726.14)
	event.ObjsSetMotion(0, "上見る", 6, -1.0, 1)
	event.ObjsNextMotion(0, "上見るL")
	event.SetPakuAnim(0, "通常口パク")
	helper_4896c0c7(6160050)
	if vm.skipping() then
		return skip(13)
	end
	event.ResetPakuAnim()
	helper_adea7ba0(30)
	if vm.skipping() then
		return skip(14)
	end
	event.CmrsInitPas()
	event.CmrsSetPasFrm(200)
	event.CmrsAddPas(616.77, 208.31, 1155.4, 646.89, 231.29, 968.2)
	event.CmrsAddPas(-272.08, 208.31, 1012.37, -241.96, 231.29, 825.17)
	event.CmrsStartPas()
	event.SetCrossfade(30)
	helper_adea7ba0(200)
	if vm.skipping() then
		return skip(15)
	end
	event.SetFadeOut(30)
	helper_adea7ba0(35)
	if vm.skipping() then
		return skip(16)
	end
	return part2()
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

script[99] = program_99

--- Program 100.
script[100] = function()
	local mc_load: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		helper_ab9c465c(50.0, vm.f32(140.7), -800.0, 0.0)
		helper_ab9c465c(0.0, vm.f32(140.7), -900.0, 0.0)
	end
	program_99()
	event.SetBitCtrl(1, 1)
	mc_load = event.CheckMcLoad() or mc_load
	if mc_load == 1 then
		event.StopBgm(0)
		helper_adea7ba0(4)
		if vm.skipping() then
			return skip(1)
		end
		event.LoadBgm(166)
		event.PlayBgm(0)
		helper_ab9c465c(50.0, vm.f32(140.7), -800.0, 0.0)
	else
		helper_ab9c465c(0.0, vm.f32(140.7), -900.0, 0.0)
	end
	event.ResetCamera(1, 0.0, 10.0)
	event.SetFadeIn(30)
end

--- Program 150.
script[150] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_128a0()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 400.
script[400] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetSavedataEtc(3, 1)
	helper_7e238e1a()
	if vm.skipping() then
		return skip(1)
	end
	event.SetSavedataEtc(3, 0)
end

--- Program 520.
script[520] = function()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_f63c()
			if not vm.skipping() then
				return part2()
			end
		end
	end
	function part2()
		event.MapJump(-1, "s32", 500)
		if vm.wait() then
			return skip(3)
		end
	end
	event.Initialize()
	event.SetMotion(0, "立ち")
	event.SetFadeOut(30)
	helper_adea7ba0(30)
	if vm.skipping() then
		return skip(1)
	end
	event.SetBitCtrl(1, 0)
	event.SetFlag(616, 1)
	helper_f63c()
	if vm.skipping() then
		return skip(2)
	end
	return part2()
end

--- Program 530.
script[530] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_128a0()
	if vm.skipping() then
		return skip(1)
	end
	event.MapJump(-1, "s26", 550)
	if vm.wait() then
		return skip(2)
	end
end

--- Program 532.
script[532] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_1eb1cb40()
	if vm.skipping() then
		return skip(1)
	end
	event.MapJump(-1, "s71", 590)
	if vm.wait() then
		return skip(2)
	end
end

--- Program 16160.
script[16160] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_f63c()
	if vm.skipping() then
		return skip(1)
	end
	event.MapJump(-1, "s32", 500)
	if vm.wait() then
		return skip(2)
	end
end

return script
