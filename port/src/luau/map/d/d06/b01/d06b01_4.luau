--!strict
-- map/d/d06/b01/d06b01_4.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_04f0a514 = require("@lib/event/helper_04f0a514")
local helper_1f8e2df2 = require("@lib/event/helper_1f8e2df2")
local helper_4bea09db = require("@lib/event/helper_4bea09db")
local helper_699116d4 = require("@lib/event/helper_699116d4")
local helper_79ff6d9e = require("@lib/event/helper_79ff6d9e")
local helper_890b5665 = require("@lib/event/helper_890b5665")
local helper_8bfd924b = require("@lib/event/helper_8bfd924b")
local helper_9a07ee86 = require("@lib/event/helper_9a07ee86")
local helper_ccab783e = require("@lib/event/helper_ccab783e")
local helper_e69aa2b6 = require("@lib/event/helper_e69aa2b6")
local helper_e744e944 = require("@lib/event/helper_e744e944")
local helper_ec79699f = require("@lib/event/helper_ec79699f")
local helper_f4db3f22 = require("@lib/event/helper_f4db3f22")

local global0: s32 = 0
local global1: s32 = 0
local global2: s32 = 0
local global3: s32 = 0

--- Program 99.
local function program_99() end

--- Helper function.
local function helper_1963c()
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
	event.LoadMes(0, 5, "event/e700/e728/e728_1.txt")
end

--- Helper function.
local function helper_19184()
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
local function helper_1a7b8()
	local var4: s32 = 0
	local projection: f32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 8 then
			if at <= 1 then
				helper_1963c()
				helper_890b5665(15)
			end
			if at <= 2 then
				helper_890b5665(30)
			end
			if at <= 3 then
				helper_1f8e2df2(7280010, -1)
			end
			if at <= 4 then
				helper_4bea09db()
			end
			if at <= 5 then
				helper_890b5665(30)
			end
			if at <= 6 then
				helper_890b5665(30)
			end
			if at <= 7 then
				helper_4bea09db()
			end
			if vm.skip_end() then
				return skip(9)
			end
			return part2()
		end
		if at <= 9 then
			helper_890b5665(60)
		end
		helper_19184()
	end
	function part2()
		event.CancelDramaScene()
		event.CmrsFadeOut(60, 255.0, 255.0, 255.0)
		helper_890b5665(60)
		if vm.skipping() then
			return skip(10)
		end
		event.SndSeAllStop(4)
		event.BgmLoadCancel()
		if vm.wait() then
			return skip(11)
		end
		event.SetProjection(projection)
		helper_19184()
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
	helper_1963c()
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
	helper_890b5665(15)
	if vm.skipping() then
		return skip(2)
	end
	event.SndSePlay(var4, 0)
	event.ObjsSetMotion(11, "ドスッ", 2)
	event.ObjsNextMotion(11, "ドスッＬ", 4)
	helper_890b5665(30)
	if vm.skipping() then
		return skip(3)
	end
	event.CmrsInitPas()
	event.CmrsSetPasFrm(200)
	event.CmrsAddPas(-67.28, 15.66, -27.15, -7.11, 7.02, -6.4)
	event.CmrsAddPas(-67.28, 40.31, -27.15, -7.11, 31.68, -6.4)
	event.CmrsStartPas()
	helper_1f8e2df2(7280010, -1)
	if vm.skipping() then
		return skip(4)
	end
	helper_4bea09db()
	if vm.skipping() then
		return skip(5)
	end
	event.CmrsSetPos(0.0, 4.51, -46.14)
	event.CmrsSetRef(0.0, 30.71, -128.08)
	helper_890b5665(30)
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
	helper_890b5665(30)
	if vm.skipping() then
		return skip(7)
	end
	event.SetCharaShow(10, 0, 1, 0.0033)
	event.CmrsInitPas()
	event.CmrsSetPasFrm(300)
	event.CmrsAddPas(0.0, 18.36, -103.26, 0.0, 27.17, 0.0)
	event.CmrsAddPas(0.0, 88.44, -103.26, 0.0, 97.25, 0.0)
	event.CmrsStartPas()
	helper_4bea09db()
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
			helper_890b5665(30)
		end
		if at <= 3 then
			helper_1a7b8()
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
	helper_890b5665(20)
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
	helper_890b5665(30)
	if vm.skipping() then
		return skip(3)
	end
	helper_1a7b8()
	if vm.skipping() then
		return skip(4)
	end
	return part2()
end

--- Helper function.
local function helper_1be60()
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
	event.LoadMes(0, 5, "event/e700/e728/e728_1.txt")
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
	event.LoadChara(6, "event/e700/e728/e728_dark_smoke.gltf", "info", 10, 1)
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
local function helper_1b834()
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
local function helper_1d868()
	local var4: s32 = 0
	local projection: f32 = 0
	local active_chr_no: s32 = 0
	local block: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 44 then
			if at <= 4 then
				helper_1be60()
				helper_890b5665(60)
			end
			if at <= 5 then
				helper_890b5665(60)
			end
			if at <= 6 then
				helper_890b5665(60)
			end
			if at <= 7 then
				helper_4bea09db()
			end
			if at <= 8 then
				helper_890b5665(60)
			end
			if at <= 9 then
				helper_1f8e2df2(7280130, -1)
			end
			if at <= 10 then
				helper_890b5665(15)
			end
			if at <= 11 then
				helper_4bea09db()
			end
			if at <= 12 then
				helper_890b5665(30)
			end
			if at <= 13 then
				helper_699116d4(5)
			end
			if at <= 14 then
				helper_699116d4(5)
			end
			if at <= 15 then
				helper_4bea09db()
			end
			if at <= 16 then
				helper_4bea09db()
			end
			if at <= 17 then
				helper_890b5665(20)
			end
			if at <= 18 then
				helper_890b5665(15)
			end
			if at <= 19 then
				helper_4bea09db()
			end
			if at <= 20 then
				helper_890b5665(30)
			end
			if at <= 21 then
				helper_1f8e2df2(7280140, 30)
			end
			if at <= 22 then
				helper_699116d4(2)
			end
			if at <= 23 then
				helper_699116d4(0)
			end
			if at <= 24 then
				helper_890b5665(15)
			end
			if at <= 25 then
				helper_699116d4(0)
			end
			if at <= 26 then
				helper_699116d4(0)
			end
			if at <= 27 then
				helper_1f8e2df2(7280150, -1)
			end
			if at <= 28 then
				helper_890b5665(60)
			end
			if at <= 33 then
				helper_890b5665(90)
			end
			if at <= 34 then
				helper_890b5665(30)
			end
			if at <= 35 then
				helper_890b5665(90)
			end
			if at <= 36 then
				helper_890b5665(60)
			end
			if at <= 37 then
				helper_4bea09db()
			end
			if at <= 38 then
				helper_890b5665(60)
			end
			if at <= 39 then
				helper_890b5665(90)
			end
			if at <= 40 then
				helper_4bea09db()
			end
			if at <= 41 then
				helper_4bea09db()
			end
			if at <= 42 then
				helper_890b5665(60)
			end
			if at <= 43 then
				helper_890b5665(60)
			end
			if vm.skip_end() then
				return skip(45)
			end
			return part2()
		end
		if at <= 45 then
			helper_890b5665(65)
		end
		if at <= 47 then
			helper_1b834()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.CmrsFadeOut(60, 255.0, 255.0, 255.0)
		helper_890b5665(65)
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
		helper_1b834()
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
	helper_1be60()
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
	helper_890b5665(60)
	if vm.skipping() then
		return skip(5)
	end
	event.CmrsSetPos(-32.93, 11.56, -74.72)
	event.CmrsSetRef(2.53, 23.99, -128.27)
	helper_890b5665(60)
	if vm.skipping() then
		return skip(6)
	end
	event.SndSePlay(var4, 0)
	event.PlayBgm(0)
	event.CmrsSetPos(-9.32, 6.57, -86.8)
	event.CmrsSetRef(-1.8, 11.05, -21.29)
	event.SetMotion(11, "倒れ")
	event.CharaActive(1, 11)
	helper_890b5665(60)
	if vm.skipping() then
		return skip(7)
	end
	event.CmrsInitPas()
	event.CmrsSetPasFrm(120)
	event.CmrsAddPas(-9.32, 6.57, -86.8, -1.8, 11.05, -21.29)
	event.CmrsAddPas(-9.32, 74.82, -86.8, -1.8, 79.3, -21.29)
	event.CmrsStartPas()
	helper_4bea09db()
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
	helper_890b5665(60)
	if vm.skipping() then
		return skip(9)
	end
	helper_1f8e2df2(7280130, -1)
	if vm.skipping() then
		return skip(10)
	end
	helper_890b5665(15)
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
	helper_4bea09db()
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
	helper_890b5665(30)
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
	helper_699116d4(5)
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
	helper_699116d4(5)
	if vm.skipping() then
		return skip(15)
	end
	helper_4bea09db()
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
	helper_4bea09db()
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
	helper_890b5665(20)
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
	helper_890b5665(15)
	if vm.skipping() then
		return skip(19)
	end
	event.CharaActive(1, 23)
	event.SetCharaPos(23, 0.0, 0.0, 0.0)
	event.SetCharaRot(23, 0.0, 0.0, 0.0)
	event.SetMotion(23, "暗黒エレキ", 6, -1, 1)
	event.CmrsQuake(0.0, 0.6, 0.0, 30)
	helper_4bea09db()
	if vm.skipping() then
		return skip(20)
	end
	helper_890b5665(30)
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
	helper_1f8e2df2(7280140, 30)
	if vm.skipping() then
		return skip(22)
	end
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "通常目パチ")
	event.ObjsSetMotion(0, "寝かせる", 2)
	event.ObjsNextMotion(0, "寝かせるL", 4)
	event.ObjsSetMotion(2, "寝かせる", 2)
	event.ObjsNextMotion(2, "寝かせるL", 4)
	helper_699116d4(2)
	if vm.skipping() then
		return skip(23)
	end
	helper_699116d4(0)
	if vm.skipping() then
		return skip(24)
	end
	helper_890b5665(15)
	if vm.skipping() then
		return skip(25)
	end
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おこり顔")
	event.ObjsTexAnime(0, 1, "前向き～下向き")
	event.ObjsSetMotion(0, "うなづく", 2)
	event.ObjsNextMotion(0, "寝かせるL", 4)
	helper_699116d4(0)
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
	helper_699116d4(0)
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
	helper_1f8e2df2(7280150, -1)
	if vm.skipping() then
		return skip(28)
	end
	event.FadeOutBgm(60)
	helper_890b5665(60)
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
	helper_890b5665(90)
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
	helper_890b5665(30)
	if vm.skipping() then
		return skip(35)
	end
	event.ObjsSetMotion(5, "ブルブル", 4)
	event.CharaActive(0, 19)
	event.CharaActive(0, 20)
	event.CharaActive(0, 21)
	helper_890b5665(90)
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
	helper_890b5665(60)
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
	event.LoadChara(6, "event/e700/e728/e728_dark.gltf", "info", 10, 1)
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
	block = event.LoadImg_4(6, "textures/event/e700/e728/e728telop06_1.json", 0) or block
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
	helper_4bea09db()
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
	helper_890b5665(60)
	if vm.skipping() then
		return skip(39)
	end
	event.SetMotion(11, "手を広げるL", 4, -1, 1)
	helper_890b5665(90)
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
	helper_4bea09db()
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
	helper_4bea09db()
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
	helper_890b5665(60)
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
	helper_890b5665(60)
	if vm.skipping() then
		return skip(44)
	end
	return part2()
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
			helper_ec79699f(0.0, 0.0, -200.0, 0.0)
		end
	end
	program_99()
	flag = event.GetFlag(58) or flag
	if flag == 1 then
		helper_ccab783e()
		if vm.skipping() then
			return skip(1)
		end
		event.SetBitCtrl(1, 1)
		helper_ec79699f(0.0, 0.0, -200.0, 0.0)
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
			helper_e744e944(64)
		end
	end
	if vm.wait() then
		return skip(1)
	end
	helper_e744e944(64)
	if vm.skipping() then
		return skip(2)
	end
end

--- Program 151.
script[151] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_890b5665(4)
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
	helper_890b5665(4)
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
			helper_890b5665(30)
		end
		if at <= 3 then
			helper_04f0a514(0, -1, 8, 0, 0)
		end
	end
	event.Initialize()
	if vm.wait() then
		return skip(1)
	end
	event.SetFadeOut(30)
	helper_890b5665(30)
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
	helper_04f0a514(0, -1, 8, 0, 0)
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
			helper_890b5665(30)
		end
		if at <= 3 then
			helper_04f0a514(0, -1, 8, 0, 0)
		end
	end
	event.Initialize()
	if vm.wait() then
		return skip(1)
	end
	event.SetFadeOut(30)
	helper_890b5665(30)
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
	helper_04f0a514(0, -1, 8, 0, 0)
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
	helper_890b5665(10)
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
	helper_890b5665(10)
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
			helper_ec79699f(0.0, 0.0, -200.0, 0.0)
		end
	end
	helper_e69aa2b6()
	if vm.skipping() then
		return skip(1)
	end
	helper_ec79699f(0.0, 0.0, -200.0, 0.0)
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
			helper_ec79699f(0.0, 0.0, -200.0, 0.0)
		end
	end
	helper_f4db3f22()
	if vm.skipping() then
		return skip(1)
	end
	helper_ec79699f(0.0, 0.0, -200.0, 0.0)
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
			helper_890b5665(4)
		end
	end
	helper_1d868()
	if vm.skipping() then
		return skip(1)
	end
	var0 = event.GetBgmNo() or var0
	if var0 ~= 167 then
		event.StopBgm(0)
		helper_890b5665(4)
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
	helper_9a07ee86()
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
				helper_8bfd924b(0, 8560070)
			end
			return
		end
	end
	flag = event.GetFlag(716) or flag
	flag_2 = event.GetFlag(728) or flag_2
	if flag ~= 0 and flag_2 == 0 then
		value = event.GetRandInt(100) or value
		if value < 50 then
			helper_8bfd924b(0, 8560060)
			if vm.skipping() then
				return skip(1)
			end
		else
			helper_8bfd924b(0, 8560070)
			if vm.skipping() then
				return skip(2)
			end
		end
		return
	end
	helper_79ff6d9e(0)
	if vm.skipping() then
		return skip(3)
	end
end

--- Program 17160.
script[17160] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_ccab783e()
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
	helper_1a7b8()
	if vm.skipping() then
		return skip(1)
	end
	event.LoadDungeonMapFile("s44")
	event.LoadScript("s44/s44.stb", 510)
end

return script
