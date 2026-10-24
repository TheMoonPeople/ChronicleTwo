--!strict
-- map/s/s65/s65_2.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0839363b = require("@lib/event/helper_0839363b")
local helper_0958ca60 = require("@lib/event/helper_0958ca60")
local helper_238b5abc = require("@lib/event/helper_238b5abc")
local helper_25abe6d2 = require("@lib/event/helper_25abe6d2")
local helper_344d6cd8 = require("@lib/event/helper_344d6cd8")
local helper_406f4cdb = require("@lib/event/helper_406f4cdb")
local helper_52aadc70 = require("@lib/event/helper_52aadc70")
local helper_8cd371d7 = require("@lib/event/helper_8cd371d7")
local helper_9dafbc83 = require("@lib/event/helper_9dafbc83")
local helper_c28d4a31 = require("@lib/event/helper_c28d4a31")
local helper_c624bc16 = require("@lib/event/helper_c624bc16")
local helper_d3f20302 = require("@lib/event/helper_d3f20302")
local helper_e34416e2 = require("@lib/event/helper_e34416e2")
local helper_f57795f8 = require("@lib/event/helper_f57795f8")

local global0: s32 = 0
local global1: s32 = 0
local global2: s32 = 0
local global3: s32 = 0

--- Event 99, which map data, a script or the engine runs by number.
local function event_99() end

--- Helper function.
local function helper_11428()
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
	event.LoadMes(0, 5, "event/e600/e616/e616.txt")
end

--- Helper function.
local function helper_11054()
	local active_chr_no: s32 = 0
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
local function helper_12838()
	local var6: s32 = 0
	local projection: f32 = 0
	local var8: s32 = 0
	local at: number = 0
	vm.section(function()
		event.Initialize()
		event.SetMesWindowMode(0, 7)
		var6 = event.SndLoadSound_2(7200) or var6
		helper_11428()
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
		at = 1
		helper_e34416e2(6160060)
		event.ResetPakuAnim()
		event.SndSePlay(var6, 6)
		event.SetPakuAnim(2, "通常口パク")
		at = 2
		helper_e34416e2(6160070)
		event.ResetPakuAnim()
		event.SndSePlay(var6, 7)
		at = 3
		helper_25abe6d2(30)
		event.SndSePlay(var6, 8)
		event.SetWind(80.0, 17.0, 0.0, 1380.0)
		event.SetMotion(41, "ヒット", 6, -1, 1)
		event.CharaActive(1, 41)
		at = 4
		helper_25abe6d2(10)
		event.SndSePlay(var6, 9)
		event.SetWind(-1)
		event.ObjsSetMotion(2, "とびあがる", 2)
		event.ObjsNextMotion(2, "とびあがるループ", 4)
		at = 5
		helper_25abe6d2(60)
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
		event.ObjsSetPasFrm(var8, 240)
		event.ObjsAddPas(var8, 0.0, 0.0, 1350.0)
		event.ObjsAddPas(var8, 100.0, 0.0, 1250.0)
		event.ObjsAddPas(var8, 0.0, 0.0, 1150.0)
		event.ObjsAddPas(var8, -100.0, 0.0, 1250.0)
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
		at = 6
		helper_c28d4a31(6160080, -1)
		at = 7
		helper_c28d4a31(6160090, -1)
		at = 8
		helper_0958ca60(2)
		event.ObjsSetMotion(0, "走り")
		event.ObjsSetMotion(1, "走り")
		event.ObjsRotation(2, 0.0, 0.01, 0.0, 20)
		event.ObjsRotation(1, 0.0, 0.01, 0.0, 20)
		event.ObjsRotation(0, 0.0, -0.01, 0.0, 20)
		at = 9
		helper_0958ca60(2)
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
		at = 10
		helper_25abe6d2(30)
		event.CharaActive(1, 41)
		event.SetMotion(41, "ヒット", 6, -1, 1)
		event.SndSePlay(var6, 5)
		at = 11
		helper_25abe6d2(90)
		event.CharaActive(0, 40)
		event.SetProjection(projection)
		event.ObjsTexAnime(0, 0)
		event.ObjsTexAnime(0, 1, "おこり顔")
		event.ObjsTexAnime(0, 1, "おこり目～おどろき目")
		event.ObjsSetPos(0, -32.0, 0.0, 2418.0)
		event.CmrsSetPos(-4.69, 10.72, 2447.12)
		event.CmrsSetRef(-32.39, 22.39, 2411.64)
		event.ObjsSetMotion(0, "左後ろ見る", 6, -1.0, 1)
		event.ObjsNextMotion(0, "左後ろ見るL", 4)
		at = 12
		helper_e34416e2(6160100)
		event.StopBgm(0)
		at = 13
		vm.wait(13)
		at = 14
		vm.wait(14)
		at = 15
		vm.wait(15)
		at = 16
		vm.wait(16)
		event.LoadBgm(190)
		event.EohSyncChrobj(20, 39, "puropera")
		event.ObjsInit(20)
		event.ObjsSyncObj(20, 20)
		event.ObjsRotation(20, 0.0, -0.08, 0.0, -1)
		event.PlayBgm(0)
		event.SndSePlay(var6, 10)
		event.CharaActive(1, 39)
		event.ObjsSetMotion(3, "浮遊", 4)
		event.CmrsSetPos(329.6, 416.23, 860.98)
		event.CmrsSetRef(418.95, 436.16, 1072.8)
		at = 17
		helper_25abe6d2(60)
		event.CmrsMove2(117.44, 416.23, 937.94, 373.95, 436.16, 1038.44, 120, 0, 0.4)
		at = 18
		helper_c624bc16()
		event.CmrsMove2(-1039.68, 1120.44, 3017.49, -375.04, 936.38, 1696.66, 300, 0, 0.4)
		at = 19
		helper_c624bc16()
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
		event.CmrsSetPos(-154.51, 10.06, 1495.9)
		event.CmrsSetRef(1.55, 150.34, 2062.42)
		event.ObjsSetPos(1, -97.73, 0.0, 1668.0)
		event.ObjsSetRot(1, 0.0, -2.63, 0.0)
		event.ObjsSetPos(0, -148.27, 0.0, 1617.78)
		event.ObjsSetRot(0, 0.0, 0.13, 0.0)
		event.ObjsSetPos(2, -101.78, 0.0, 1761.73)
		event.ObjsSetRot(2, 0.0, 0.01, 0.0)
		at = 20
		helper_e34416e2(6160110)
		event.ObjsSetMotion(0, "左後ろ見る戻り", 6, -1.0, 1)
		event.SetFadeOut(30)
		at = 21
		helper_25abe6d2(35)
	end, function(received: { any }): boolean
		if at <= 1 then
			helper_8cd371d7(6160070)
		end
		if at <= 2 then
			helper_d3f20302(30)
		end
		if at <= 3 then
			helper_d3f20302(10)
		end
		if at <= 4 then
			helper_d3f20302(60)
		end
		if at <= 5 then
			var8 = 2
			helper_52aadc70(6160080, -1)
		end
		if at <= 6 then
			helper_52aadc70(6160090, -1)
		end
		if at <= 7 then
			helper_238b5abc(2)
		end
		if at <= 8 then
			helper_238b5abc(2)
		end
		if at <= 9 then
			helper_d3f20302(30)
		end
		if at <= 10 then
			helper_d3f20302(90)
		end
		if at <= 11 then
			helper_8cd371d7(6160100)
		end
		if at <= 16 then
			helper_d3f20302(60)
		end
		if at <= 17 then
			helper_344d6cd8()
		end
		if at <= 18 then
			helper_344d6cd8()
		end
		if at <= 19 then
			helper_8cd371d7(6160110)
		end
		if at <= 20 then
			helper_d3f20302(35)
		end
		return true
	end)
	event.CancelDramaScene()
	event.BgmLoadCancel()
	event.SetWind(-1)
	event.EohSetFootSoundId(0, 0)
	event.EohSetFootSoundId(1, 0)
	event.EsmClear()
	helper_11054()
	event.SetProjection(projection)
	event.ResetCamera(0)
	event.SetFadeIn(30)
end

--- Helper function.
local function helper_e85c()
	local active_chr_no: s32 = 0
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
	event.LoadMes(0, 5, "event/e600/e616/e616.txt")
end

--- Helper function.
local function helper_e560()
	local active_chr_no: s32 = 0
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
	event.DeleteChara(38)
end

--- Helper function.
local function helper_f5e0()
	local var6: s32 = 0
	vm.section(function()
		event.SetFlag(616, 1)
		event.Initialize()
		event.SetMesWindowMode(0, 7)
		event.StopBgm(0)
		event.LoadBgm(166)
		event.PlayBgm(0)
		var6 = event.SndLoadSound_2(7200) or var6
		helper_e85c()
		event.InitDramaScene()
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
		helper_e34416e2(6160010)
		helper_0958ca60(2)
		event.ObjsSetRot(1, 0.0, 3.13, 0.0)
		event.ObjsSetRot(0, 0.0, 3.13, 0.0)
		helper_25abe6d2(15)
		event.SndSePlay(var6, 1)
		event.ObjsRotation(2, 0.0, 0.01, 0.0, 30)
		helper_0958ca60(2)
		helper_25abe6d2(30)
		event.ObjsSetMotion(2, "走り")
		event.ObjsInitPas(2)
		event.ObjsSetPasFrm(2, 60)
		event.ObjsAddPas(2, 0.0, 0.0, 527.58)
		event.ObjsAddPas(2, 0.0, 0.0, 700.0)
		event.ObjsStartPas(2)
		helper_0958ca60(2)
		event.ObjsSetMotion(0, "下見立ち", 4, -1.0, 1)
		event.ObjsSetMotion(1, "下見立ち", 4, -1.0, 1)
		event.ObjsSetMotion(2, "ぜいぜい", 4)
		event.ObjsSetRot(1, 0.0, -2.55, 0.0)
		event.ObjsSetRot(0, 0.0, 2.89, 0.0)
		event.CmrsSetPos(-38.64, 38.38, 652.69)
		event.CmrsSetRef(-1.85, 14.77, 711.67)
		helper_25abe6d2(30)
		event.ObjsSetMotion(0, "下見会話", 2)
		event.ObjsNextMotion(0, "下見立ち")
		event.SetPakuAnim(0, "通常口パク")
		helper_e34416e2(6160020)
		event.ResetPakuAnim()
		event.ObjsSetMotion(2, "ぜいぜい（見上げ）in", 2)
		event.ObjsNextMotion(2, "ぜいぜい（見上げ）", 4)
		helper_e34416e2(6160030)
		event.ObjsTexAnime(1, 0)
		event.ObjsTexAnime(1, 1, "無表情")
		event.ObjsTexAnime(1, 1, "通常目～おこり目")
		event.ObjsSetMotion(1, "キョロキョロ")
		event.SetPakuAnim(1, "通常口パク")
		helper_e34416e2(6160040)
		event.ResetPakuAnim()
		helper_25abe6d2(15)
		event.ObjsTexAnime(0, 0)
		event.ObjsTexAnime(0, 1, "おこり顔")
		event.ObjsTexAnime(0, 1, "おこり目パチ")
		event.CmrsSetPos(-28.76, 13.15, 706.38)
		event.CmrsSetRef(-17.78, 21.48, 726.14)
		event.ObjsSetMotion(0, "上見る", 6, -1.0, 1)
		event.ObjsNextMotion(0, "上見るL")
		event.SetPakuAnim(0, "通常口パク")
		helper_e34416e2(6160050)
		event.ResetPakuAnim()
		helper_25abe6d2(30)
		event.CmrsInitPas()
		event.CmrsSetPasFrm(200)
		event.CmrsAddPas(616.77, 208.31, 1155.4, 646.89, 231.29, 968.2)
		event.CmrsAddPas(-272.08, 208.31, 1012.37, -241.96, 231.29, 825.17)
		event.CmrsStartPas()
		event.SetCrossfade(30)
		helper_25abe6d2(200)
		event.SetFadeOut(30)
		helper_25abe6d2(35)
	end)
	event.CancelDramaScene()
	event.EohSetFootSoundId(0, 0)
	event.EohSetFootSoundId(1, 0)
	event.BgmLoadCancel()
	event.SndSeAllStop(4)
	helper_e560()
	event.ResetCamera(0)
	event.SetFadeIn(30)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

script.event_99 = event_99

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	local mc_load: s32 = 0
	event_99()
	event.SetBitCtrl(1, 1)
	mc_load = event.CheckMcLoad() or mc_load
	if mc_load == 1 then
		helper_9dafbc83(50.0, vm.f32(140.7), -800.0, 0.0)
	else
		helper_9dafbc83(0.0, vm.f32(140.7), -900.0, 0.0)
	end
	event.ResetCamera(1, 0.0, 10.0)
	event.SetFadeIn(30)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = helper_12838

--- Event 400, which map data, a script or the engine runs by number.
script.event_400 = helper_f57795f8

--- Event 520, which map data, a script or the engine runs by number.
function script.event_520()
	event.Initialize()
	event.SetMotion(0, "立ち")
	event.SetFadeOut(30)
	helper_25abe6d2(30)
	event.SetBitCtrl(1, 0)
	event.SetFlag(616, 1)
	event.MapJump_3(-1, "s70", 520)
	vm.wait(2)
end

--- Event 530, which map data, a script or the engine runs by number.
function script.event_530()
	helper_12838()
	event.MapJump_3(-1, "s26", 550)
	vm.wait(2)
end

--- Event 532, which map data, a script or the engine runs by number.
function script.event_532()
	helper_0839363b()
	event.MapJump_3(-1, "s12", 590)
	vm.wait(2)
end

--- Event 550, which map data, a script or the engine runs by number.
function script.event_550()
	helper_406f4cdb()
	event.BgmLoadCancel()
	event.SoundLoadCancel()
	event.MapJump_3(-1, "g05", 500)
	vm.wait(2)
end

--- Event 16160, which map data, a script or the engine runs by number.
function script.event_16160()
	helper_f5e0()
	event.MapJump_3(-1, "s32", 500)
	vm.wait(2)
end

--- Event 17000, which map data, a script or the engine runs by number.
function script.event_17000()
	helper_406f4cdb()
	event.BgmLoadCancel()
	event.MapJump_3(-1, "g05", 500)
	vm.wait(2)
end

return script
