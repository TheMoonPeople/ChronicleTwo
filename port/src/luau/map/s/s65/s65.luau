--!strict
-- map/s/s65/s65.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_076280e8 = require("@lib/event/helper_076280e8")
local helper_0f1c5378 = require("@lib/event/helper_0f1c5378")
local helper_1d96573f = require("@lib/event/helper_1d96573f")
local helper_650bfa16 = require("@lib/event/helper_650bfa16")
local helper_7d537157 = require("@lib/event/helper_7d537157")
local helper_9dafbc83 = require("@lib/event/helper_9dafbc83")
local helper_b8bc5976 = require("@lib/event/helper_b8bc5976")
local helper_ff0edc1d = require("@lib/event/helper_ff0edc1d")

local global0: s32 = 0
local global1: s32 = 0
local global2: s32 = 0
local global3: s32 = 0

--- Program 99.
local function program_99() end

--- Helper function.
local function helper_10b84()
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
local function helper_107b0()
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
local function helper_11f94()
	local var6: s32 = 0
	local projection: f32 = 0
	local var8: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 21 then
			if at <= 1 then
				helper_1d96573f(6160070)
			end
			if at <= 2 then
				helper_ff0edc1d(30)
			end
			if at <= 3 then
				helper_ff0edc1d(10)
			end
			if at <= 4 then
				helper_ff0edc1d(60)
			end
			if at <= 5 then
				var8 = 2
				helper_b8bc5976(6160080, -1)
			end
			if at <= 6 then
				helper_b8bc5976(6160090, -1)
			end
			if at <= 7 then
				helper_650bfa16(2)
			end
			if at <= 8 then
				helper_650bfa16(2)
			end
			if at <= 9 then
				helper_ff0edc1d(30)
			end
			if at <= 10 then
				helper_ff0edc1d(90)
			end
			if at <= 11 then
				helper_1d96573f(6160100)
			end
			if at <= 16 then
				helper_ff0edc1d(60)
			end
			if at <= 17 then
				helper_076280e8()
			end
			if at <= 18 then
				helper_076280e8()
			end
			if at <= 19 then
				helper_1d96573f(6160110)
			end
			if at <= 20 then
				helper_ff0edc1d(35)
			end
			if vm.skip_end() then
				return skip(22)
			end
			return part2()
		end
		helper_107b0()
	end
	function part2()
		event.CancelDramaScene()
		event.BgmLoadCancel()
		event.SetWind(-1)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.EsmClear()
		helper_107b0()
		event.SetProjection(projection)
		event.ResetCamera(0)
		event.SetFadeIn(30)
	end
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	var6 = event.SndLoadSound(7200) or var6
	helper_10b84()
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
	helper_1d96573f(6160060)
	if vm.skipping() then
		return skip(1)
	end
	event.ResetPakuAnim()
	event.SndSePlay(var6, 6)
	event.SetPakuAnim(2, "通常口パク")
	helper_1d96573f(6160070)
	if vm.skipping() then
		return skip(2)
	end
	event.ResetPakuAnim()
	event.SndSePlay(var6, 7)
	helper_ff0edc1d(30)
	if vm.skipping() then
		return skip(3)
	end
	event.SndSePlay(var6, 8)
	event.SetWind(80.0, 17.0, 0.0, 1380.0)
	event.SetMotion(41, "ヒット", 6, -1, 1)
	event.CharaActive(1, 41)
	helper_ff0edc1d(10)
	if vm.skipping() then
		return skip(4)
	end
	event.SndSePlay(var6, 9)
	event.SetWind(-1)
	event.ObjsSetMotion(2, "とびあがる", 2)
	event.ObjsNextMotion(2, "とびあがるループ", 4)
	helper_ff0edc1d(60)
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
	helper_b8bc5976(6160080, -1)
	if vm.skipping() then
		return skip(6)
	end
	helper_b8bc5976(6160090, -1)
	if vm.skipping() then
		return skip(7)
	end
	helper_650bfa16(2)
	if vm.skipping() then
		return skip(8)
	end
	event.ObjsSetMotion(0, "走り")
	event.ObjsSetMotion(1, "走り")
	event.ObjsRotation(2, 0.0, 0.01, 0.0, 20)
	event.ObjsRotation(1, 0.0, 0.01, 0.0, 20)
	event.ObjsRotation(0, 0.0, -0.01, 0.0, 20)
	helper_650bfa16(2)
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
	helper_ff0edc1d(30)
	if vm.skipping() then
		return skip(10)
	end
	event.CharaActive(1, 41)
	event.SetMotion(41, "ヒット", 6, -1, 1)
	event.SndSePlay(var6, 5)
	helper_ff0edc1d(90)
	if vm.skipping() then
		return skip(11)
	end
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
	helper_1d96573f(6160100)
	if vm.skipping() then
		return skip(12)
	end
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
	event.SndSePlay(var6, 10)
	event.CharaActive(1, 39)
	event.ObjsSetMotion(3, "浮遊", 4)
	event.CmrsSetPos(329.6, 416.23, 860.98)
	event.CmrsSetRef(418.95, 436.16, 1072.8)
	helper_ff0edc1d(60)
	if vm.skipping() then
		return skip(17)
	end
	event.CmrsMove2(117.44, 416.23, 937.94, 373.95, 436.16, 1038.44, 120, 0, 0.4)
	helper_076280e8()
	if vm.skipping() then
		return skip(18)
	end
	event.CmrsMove2(-1039.68, 1120.44, 3017.49, -375.04, 936.38, 1696.66, 300, 0, 0.4)
	helper_076280e8()
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
	event.CmrsSetPos(-154.51, 10.06, 1495.9)
	event.CmrsSetRef(1.55, 150.34, 2062.42)
	event.ObjsSetPos(1, -97.73, 0.0, 1668.0)
	event.ObjsSetRot(1, 0.0, -2.63, 0.0)
	event.ObjsSetPos(0, -148.27, 0.0, 1617.78)
	event.ObjsSetRot(0, 0.0, 0.13, 0.0)
	event.ObjsSetPos(2, -101.78, 0.0, 1761.73)
	event.ObjsSetRot(2, 0.0, 0.01, 0.0)
	helper_1d96573f(6160110)
	if vm.skipping() then
		return skip(20)
	end
	event.ObjsSetMotion(0, "左後ろ見る戻り", 6, -1.0, 1)
	event.SetFadeOut(30)
	helper_ff0edc1d(35)
	if vm.skipping() then
		return skip(21)
	end
	return part2()
end

--- Helper function.
local function helper_15e7c()
	local active_chr_no: s32 = 0
	local var1: s32 = 0
	local block: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 29 then
			if at <= 1 then
				helper_ff0edc1d(130)
			end
			if at <= 2 then
				helper_ff0edc1d(10)
			end
			if at <= 4 then
				helper_650bfa16(0)
			end
			if at <= 5 then
				helper_ff0edc1d(6)
			end
			if at <= 6 then
				helper_1d96573f(7000020)
			end
			if at <= 7 then
				helper_1d96573f(7000030)
			end
			if at <= 8 then
				helper_650bfa16(1)
			end
			if at <= 9 then
				helper_ff0edc1d(110)
			end
			if at <= 10 then
				helper_650bfa16(2)
			end
			if at <= 11 then
				helper_ff0edc1d(90)
			end
			if at <= 12 then
				helper_650bfa16(2)
			end
			if at <= 13 then
				helper_ff0edc1d(40)
			end
			if at <= 14 then
				helper_076280e8()
			end
			if at <= 15 then
				helper_1d96573f(7000040)
			end
			if at <= 16 then
				helper_1d96573f(7000050)
			end
			if at <= 17 then
				helper_1d96573f(7000060)
			end
			if at <= 18 then
				helper_1d96573f(7000070)
			end
			if at <= 19 then
				helper_1d96573f(7000080)
			end
			if at <= 20 then
				helper_1d96573f(7000090)
			end
			if at <= 21 then
				helper_1d96573f(7000095)
			end
			if at <= 22 then
				helper_1d96573f(7000100)
			end
			if at <= 23 then
				helper_1d96573f(7000110)
			end
			if at <= 24 then
				helper_1d96573f(7000120)
			end
			if at <= 25 then
				helper_1d96573f(7000125)
			end
			if at <= 26 then
				helper_1d96573f(7000130)
			end
			if at <= 27 then
				helper_650bfa16(2)
			end
			if at <= 28 then
				helper_ff0edc1d(4)
			end
			if vm.skip_end() then
				return skip(30)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SetCrossfade(60)
		event.FuncPointShow("", "e700_light", 0)
		event.SetStatus(1, 0, 256, 0)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.SpriteSetDraw(0, 0)
		event.DelExtMotion(0)
		event.DeleteChara(32)
		event.DeleteChara(33)
		event.DeleteChara(34)
		event.DeleteChara(35)
		event.DelImg(0)
		event.LoadMes(0, -1)
	end
	event.SetFlag(700, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.StopBgm(0)
	event.LoadSound(7203)
	var1 = event.SndLoadSound(7203) or var1
	event.SetStatus(1, 0, 256, 1)
	event.ChangeDir("event/e700/e700/")
	event.LoadMes(0, 5, "e700.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e700_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e700_monica.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.LoadChara(5, "e700_andrea.gltf", "info", 34)
	event.SetStatus(1, 34, 8, 1)
	event.CharaActive(0, 34)
	event.EohSyncChara(2, 34)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.LoadChara(5, "e700_a_hikari.gltf", "info", 35)
	event.CharaActive(0, 35)
	event.EohSyncChara(3, 35)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	block = event.LoadImg_4(5, "e700.json", 0) or block
	event.SpriteInit(0)
	event.SpriteSetType(0, 0)
	event.SpriteSetTexture(0, "e70001", block)
	event.SpriteSetColor(0, 128, 128, 128, 128)
	event.SpriteSetUvsize(0, 0, 0, 512, 448)
	event.SpriteSetPutsize(0, 512, 448)
	event.SpriteSetPos(0, 256, 224)
	event.SpriteSetAlphab(0, 0)
	event.SpriteSetDraw(0, 0)
	event.ChangeDir("")
	if active_chr_no == 1 then
		event.LoadChara(5, "chara/c01_base.gltf", "info", 32)
		event.LoadEquip(5, 0, 4, "info", 32)
		event.LoadEquip(5, 0, 3, "info", 32)
		event.LoadEquip(5, 0, 2, "info", 32, 33)
		event.LoadMotion(5, "event/e700/e700/e700_mints.gltf", "info", 32)
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
		event.LoadMotion(5, "event/e700/e700/e700_monica.gltf", "info", 32)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 32)
		event.EohSyncChara(1, 32)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 0)
	end
	event.CharaActive(32)
	event.CharaActive(33)
	event.EohSyncFuncp(4, "", "e700_light")
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.EohSetPos(0, 8.0, 0.0, 2200.0)
	event.EohSetRot(0, 0.0, 3.14, 0.0)
	event.EohSetMotion(0, "歩き", 4)
	event.EohSetFootSoundId(0, 16)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "おこり顔")
	event.EohSetTexAnim(0, 1, "おこり目パチ")
	event.EohSetPos(1, -8.0, 0.0, 2200.0)
	event.EohSetRot(1, 0.0, 3.14, 0.0)
	event.EohSetMotion(1, "歩き", 4)
	event.EohSetFootSoundId(1, 16)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "おこり顔")
	event.EohSetTexAnim(1, 1, "おこり目パチ")
	event.EohSetPos(2, 0.0, 150.0, 960.0)
	event.EohSetRot(2, 0.0, 0.0, 0.0)
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "デフォルト顔")
	event.EohSetTexAnim(2, 1, "目とじ")
	event.EohSetPos(3, 0.0, 170.0, 960.0)
	event.EohSetRot(3, 0.0, 0.0, 0.0)
	event.EohSetPos(4, 0.0, 170.0, 960.0)
	event.ObjsMove(0, 8.0, 0.0, 2120, 80)
	event.ObjsMove(1, -8.0, 0.0, 2120, 80)
	event.CmrsInit()
	event.CmrsSetPos(0.0, 20.0, 2100.0)
	event.CmrsSetRef(0.0, 20.0, 2200.0)
	event.SetFadeIn(30)
	helper_650bfa16(0)
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsSetPos(0.0, 87.46, 2196.95)
	event.CmrsSetRef(0.0, 32.09, 2006.78)
	event.CmrsMove2(0.0, 9.53, 2097.37, 0.0, 32.09, 2006.78, 120, 2, 0.2)
	event.ObjsMove(0, 7.0, 0.0, 2000.0, 140)
	event.ObjsMotionDelay(0, 140)
	event.ObjsSetMotion(0, "立ち", 4)
	event.ObjsMove(1, -7.0, 0.0, 2000.0, 140)
	event.ObjsMotionDelay(1, 140)
	event.ObjsSetMotion(1, "立ち", 4)
	helper_ff0edc1d(130)
	if vm.skipping() then
		return skip(2)
	end
	event.SetFadeOut(10)
	helper_ff0edc1d(10)
	if vm.skipping() then
		return skip(3)
	end
	event.SoundAllStop()
	event.SndInReverb(0)
	event.GotoDrawChapter(7)
	if vm.wait() then
		return skip(4)
	end
	event.SndInReverb(1)
	event.CmrsSetPos(22.7, 24.08, 957.3)
	event.CmrsSetRef(-2.24, 21.49, 1005.71)
	event.LoadBgm(6)
	event.PlayBgm(0)
	event.InitDramaScene()
	event.SetFadeIn(20)
	event.ObjsSetPos(0, 7.0, 0.0, 1016.0)
	event.ObjsMove(0, 7.0, 0.0, 1000.0, 20)
	event.ObjsSetMotion(0, "歩き", 4, -1.0, 1)
	event.ObjsMotionDelay(0, 20)
	event.ObjsSetMotion(0, "立ち")
	event.ObjsSetPos(1, -7.0, 0.0, 1018.0)
	event.ObjsMove(1, -7.0, 0.0, 998.0, 26)
	event.ObjsSetMotion(1, "歩き", 4, -1.0, 1)
	event.ObjsMotionDelay(1, 26)
	event.ObjsSetMotion(1, "立ち")
	helper_650bfa16(0)
	if vm.skipping() then
		return skip(5)
	end
	helper_ff0edc1d(6)
	if vm.skipping() then
		return skip(6)
	end
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "おこり顔")
	event.EohSetTexAnim(0, 1, "まばたき目パチ")
	event.ObjsSetMotion(0, "上向く", 6)
	event.ObjsNextMotion(0, "上向くL", 4)
	event.ObjsMotionDelay(1, 10)
	event.ObjsSetMotion(1, "上向く", 6)
	event.ObjsNextMotion(1, "上向くL", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_1d96573f(7000020)
	if vm.skipping() then
		return skip(7)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_1d96573f(7000030)
	if vm.skipping() then
		return skip(8)
	end
	helper_650bfa16(1)
	if vm.skipping() then
		return skip(9)
	end
	event.CmrsSetPos(0.0, 72.76, 1200.51)
	event.CmrsSetRef(0.0, 22.72, 1005.7)
	event.CmrsMove2(0.0, 72.76, 1200.51, 0.0, 55.04, 1005.7, 60, 2, 1.0)
	event.CharaActive(1, 34)
	event.CharaActive(1, 35)
	event.ObjsSetMotion(3, "登場", 4)
	event.FuncPointShow("", "e700_light", 1)
	event.ObjsMove(2, 0.0, 70.0, 960.0, 120)
	event.ObjsMove(3, 0.0, 90.0, 960.0, 120)
	event.ObjsMove(4, 0.0, 90.0, 960.0, 120)
	event.ObjsSeDelay(2, 50)
	event.ObjsSePlay(2, var1, 0)
	helper_ff0edc1d(110)
	if vm.skipping() then
		return skip(10)
	end
	helper_650bfa16(2)
	if vm.skipping() then
		return skip(11)
	end
	event.CmrsSetPos(39.56, 22.59, 956.15)
	event.CmrsSetRef(-2.02, 13.89, 997.54)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "おこり顔")
	event.EohSetTexAnim(0, 1, "おこり目パチ")
	event.EohSetTexAnim(0, 1, "半口")
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "おこり顔")
	event.EohSetTexAnim(1, 1, "おこり目パチ")
	event.EohSetTexAnim(1, 1, "半口")
	event.ObjsMove2(2, 0.0, 20.0, 960.0, 90, 2, 0.5)
	event.ObjsMove2(3, 0.0, 40.0, 960.0, 90, 2, 0.5)
	event.ObjsMove2(4, 0.0, 40.0, 960.0, 90, 2, 0.5)
	helper_ff0edc1d(90)
	if vm.skipping() then
		return skip(12)
	end
	event.CmrsSetPos(0.0, 22.59, 1078.28)
	event.CmrsSetRef(0.0, 24.19, 997.19)
	helper_650bfa16(2)
	if vm.skipping() then
		return skip(13)
	end
	event.ObjsSetMotion(3, "出現", 2)
	event.ObjsNextMotion(3, "後光", 4)
	helper_ff0edc1d(40)
	if vm.skipping() then
		return skip(14)
	end
	event.CmrsSetPos(0.0, 41.57, 992.39)
	event.CmrsSetRef(0.0, 24.71, 935.78)
	event.CmrsMove2(0.0, 48.71, 992.39, 0.0, 48.68, 935.78, 90, 2, 0.6)
	helper_076280e8()
	if vm.skipping() then
		return skip(15)
	end
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "デフォルト顔")
	event.EohSetTexAnim(2, 1, "目とじ～目あけ")
	event.SetPakuAnim(2, "通常口パク")
	helper_1d96573f(7000040)
	if vm.skipping() then
		return skip(16)
	end
	event.CmrsSetPos(14.56, 51.58, 960.44)
	event.CmrsSetRef(-1.24, 13.9, 1001.7)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "無表情")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "無表情")
	event.EohSetTexAnim(1, 1, "通常目パチ")
	event.CharaActive(0, 35)
	event.SetPakuAnim(1, "通常口パク")
	helper_1d96573f(7000050)
	if vm.skipping() then
		return skip(17)
	end
	event.CmrsSetPos(0.0, 17.98, 1052.41)
	event.CmrsSetRef(0.0, 26.48, 1001.7)
	event.CharaActive(1, 35)
	event.SetPakuAnim(2, "しんけん口パク")
	helper_1d96573f(7000060)
	if vm.skipping() then
		return skip(18)
	end
	event.CmrsSetPos(14.56, 51.58, 960.44)
	event.CmrsSetRef(-1.24, 13.9, 1001.7)
	event.CharaActive(0, 35)
	event.SetPakuAnim(1, "通常口パク")
	helper_1d96573f(7000070)
	if vm.skipping() then
		return skip(19)
	end
	event.SetPakuAnim(0, "通常口パク")
	helper_1d96573f(7000080)
	if vm.skipping() then
		return skip(20)
	end
	event.CmrsSetPos(0.0, 48.71, 992.39)
	event.CmrsSetRef(0.0, 48.68, 935.78)
	event.CharaActive(1, 35)
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "しんけん顔")
	event.EohSetTexAnim(2, 1, "目あき～目とじ")
	event.ObjsSetMotion(2, "うつむく", 2)
	event.ObjsNextMotion(2, "うつむくＬ", 4)
	event.SetPakuAnim(2, "しんけん口パク")
	helper_1d96573f(7000090)
	if vm.skipping() then
		return skip(21)
	end
	event.SetPakuAnim(2, "しんけん口パク")
	helper_1d96573f(7000095)
	if vm.skipping() then
		return skip(22)
	end
	event.CmrsSetPos(14.56, 51.58, 960.44)
	event.CmrsSetRef(-1.24, 13.9, 1001.7)
	event.CharaActive(0, 35)
	event.SetPakuAnim(1, "通常口パク")
	helper_1d96573f(7000100)
	if vm.skipping() then
		return skip(23)
	end
	event.CmrsSetPos(0.0, 17.98, 1052.41)
	event.CmrsSetRef(0.0, 26.48, 1001.7)
	event.CharaActive(1, 35)
	event.SetPakuAnim(2, "しんけん口パク")
	helper_1d96573f(7000110)
	if vm.skipping() then
		return skip(24)
	end
	event.SetPakuAnim(2, "しんけん口パク")
	helper_1d96573f(7000120)
	if vm.skipping() then
		return skip(25)
	end
	event.SetPakuAnim(2, "しんけん口パク")
	helper_1d96573f(7000125)
	if vm.skipping() then
		return skip(26)
	end
	event.CmrsSetPos(0.0, 48.71, 992.39)
	event.CmrsSetRef(0.0, 48.68, 935.78)
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "しんけん顔")
	event.EohSetTexAnim(2, 1, "目とじ～目あけ２")
	event.ObjsSetMotion(2, "うつむく戻り", 6)
	event.ObjsNextMotion(2, "浮遊立ち", 4)
	event.SetPakuAnim(2, "しんけん口パク")
	helper_1d96573f(7000130)
	if vm.skipping() then
		return skip(27)
	end
	event.CmrsSetPos(31.07, 49.02, 853.79)
	event.CmrsSetRef(-33.5, 41.8, 1000.7)
	event.ObjsSetPos(2, 0.0, 20.0, 900.0)
	event.ObjsSetPos(3, 0.0, 40.0, 896.0)
	event.ObjsSetPos(4, 0.0, 40.0, 896.0)
	event.ObjsSetMotion(2, "両手開く", 6)
	event.ObjsNextMotion(2, "両手開くＬ", 4)
	helper_650bfa16(2)
	if vm.skipping() then
		return skip(28)
	end
	event.SndSePlay(var1, 1)
	event.SpriteSetDraw(0, 1)
	event.SetCrossfade(4)
	helper_ff0edc1d(4)
	if vm.skipping() then
		return skip(29)
	end
	return part2()
end

--- Helper function.
local function helper_dfb8()
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
local function helper_dcbc()
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
	event.DeleteChara(38)
end

--- Helper function.
local function helper_ed3c()
	local var6: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 15 then
			if at <= 1 then
				helper_650bfa16(2)
			end
			if at <= 2 then
				helper_ff0edc1d(15)
			end
			if at <= 3 then
				helper_650bfa16(2)
			end
			if at <= 4 then
				helper_ff0edc1d(30)
			end
			if at <= 5 then
				helper_650bfa16(2)
			end
			if at <= 6 then
				helper_ff0edc1d(30)
			end
			if at <= 7 then
				helper_1d96573f(6160020)
			end
			if at <= 8 then
				helper_1d96573f(6160030)
			end
			if at <= 9 then
				helper_1d96573f(6160040)
			end
			if at <= 10 then
				helper_ff0edc1d(15)
			end
			if at <= 11 then
				helper_1d96573f(6160050)
			end
			if at <= 12 then
				helper_ff0edc1d(30)
			end
			if at <= 13 then
				helper_ff0edc1d(200)
			end
			if at <= 14 then
				helper_ff0edc1d(35)
			end
			if vm.skip_end() then
				return skip(16)
			end
			return part2()
		end
		helper_dcbc()
	end
	function part2()
		event.CancelDramaScene()
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.BgmLoadCancel()
		event.SndSeAllStop(4)
		helper_dcbc()
		event.ResetCamera(0)
		event.SetFadeIn(30)
	end
	event.SetFlag(616, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.StopBgm(0)
	event.LoadBgm(166)
	event.PlayBgm(0)
	var6 = event.SndLoadSound(7200) or var6
	helper_dfb8()
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
	helper_1d96573f(6160010)
	if vm.skipping() then
		return skip(1)
	end
	helper_650bfa16(2)
	if vm.skipping() then
		return skip(2)
	end
	event.ObjsSetRot(1, 0.0, 3.13, 0.0)
	event.ObjsSetRot(0, 0.0, 3.13, 0.0)
	helper_ff0edc1d(15)
	if vm.skipping() then
		return skip(3)
	end
	event.SndSePlay(var6, 1)
	event.ObjsRotation(2, 0.0, 0.01, 0.0, 30)
	helper_650bfa16(2)
	if vm.skipping() then
		return skip(4)
	end
	helper_ff0edc1d(30)
	if vm.skipping() then
		return skip(5)
	end
	event.ObjsSetMotion(2, "走り")
	event.ObjsInitPas(2)
	event.ObjsSetPasFrm(2, 60)
	event.ObjsAddPas(2, 0.0, 0.0, 527.58)
	event.ObjsAddPas(2, 0.0, 0.0, 700.0)
	event.ObjsStartPas(2)
	helper_650bfa16(2)
	if vm.skipping() then
		return skip(6)
	end
	event.ObjsSetMotion(0, "下見立ち", 4, -1.0, 1)
	event.ObjsSetMotion(1, "下見立ち", 4, -1.0, 1)
	event.ObjsSetMotion(2, "ぜいぜい", 4)
	event.ObjsSetRot(1, 0.0, -2.55, 0.0)
	event.ObjsSetRot(0, 0.0, 2.89, 0.0)
	event.CmrsSetPos(-38.64, 38.38, 652.69)
	event.CmrsSetRef(-1.85, 14.77, 711.67)
	helper_ff0edc1d(30)
	if vm.skipping() then
		return skip(7)
	end
	event.ObjsSetMotion(0, "下見会話", 2)
	event.ObjsNextMotion(0, "下見立ち")
	event.SetPakuAnim(0, "通常口パク")
	helper_1d96573f(6160020)
	if vm.skipping() then
		return skip(8)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(2, "ぜいぜい（見上げ）in", 2)
	event.ObjsNextMotion(2, "ぜいぜい（見上げ）", 4)
	helper_1d96573f(6160030)
	if vm.skipping() then
		return skip(9)
	end
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "無表情")
	event.ObjsTexAnime(1, 1, "通常目～おこり目")
	event.ObjsSetMotion(1, "キョロキョロ")
	event.SetPakuAnim(1, "通常口パク")
	helper_1d96573f(6160040)
	if vm.skipping() then
		return skip(10)
	end
	event.ResetPakuAnim()
	helper_ff0edc1d(15)
	if vm.skipping() then
		return skip(11)
	end
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おこり顔")
	event.ObjsTexAnime(0, 1, "おこり目パチ")
	event.CmrsSetPos(-28.76, 13.15, 706.38)
	event.CmrsSetRef(-17.78, 21.48, 726.14)
	event.ObjsSetMotion(0, "上見る", 6, -1.0, 1)
	event.ObjsNextMotion(0, "上見るL")
	event.SetPakuAnim(0, "通常口パク")
	helper_1d96573f(6160050)
	if vm.skipping() then
		return skip(12)
	end
	event.ResetPakuAnim()
	helper_ff0edc1d(30)
	if vm.skipping() then
		return skip(13)
	end
	event.CmrsInitPas()
	event.CmrsSetPasFrm(200)
	event.CmrsAddPas(616.77, 208.31, 1155.4, 646.89, 231.29, 968.2)
	event.CmrsAddPas(-272.08, 208.31, 1012.37, -241.96, 231.29, 825.17)
	event.CmrsStartPas()
	event.SetCrossfade(30)
	helper_ff0edc1d(200)
	if vm.skipping() then
		return skip(14)
	end
	event.SetFadeOut(30)
	helper_ff0edc1d(35)
	if vm.skipping() then
		return skip(15)
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
	program_99()
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

--- Program 150.
script[150] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_11f94()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 400.
script[400] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_0f1c5378()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 520.
script[520] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	event.SetMotion(0, "立ち")
	event.SetFadeOut(30)
	helper_ff0edc1d(30)
	if vm.skipping() then
		return skip(1)
	end
	event.SetBitCtrl(1, 0)
	event.SetFlag(616, 1)
	event.MapJump(-1, "s70", 520)
	if vm.wait() then
		return skip(2)
	end
end

--- Program 530.
script[530] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_11f94()
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
	helper_7d537157()
	if vm.skipping() then
		return skip(1)
	end
	event.MapJump(-1, "s12", 590)
	if vm.wait() then
		return skip(2)
	end
end

--- Program 550.
script[550] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_15e7c()
	if vm.skipping() then
		return skip(1)
	end
	event.BgmLoadCancel()
	event.SoundLoadCancel()
	event.MapJump(-1, "g05", 500)
	if vm.wait() then
		return skip(2)
	end
end

--- Program 16160.
script[16160] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_ed3c()
	if vm.skipping() then
		return skip(1)
	end
	event.MapJump(-1, "s32", 500)
	if vm.wait() then
		return skip(2)
	end
end

--- Program 17000.
script[17000] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_15e7c()
	if vm.skipping() then
		return skip(1)
	end
	event.BgmLoadCancel()
	event.MapJump(-1, "g05", 500)
	if vm.wait() then
		return skip(2)
	end
end

return script
