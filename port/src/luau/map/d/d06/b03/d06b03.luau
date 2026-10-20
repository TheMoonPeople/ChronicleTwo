--!strict
-- map/d/d06/b03/d06b03.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_05fbffe0 = require("@lib/event/helper_05fbffe0")
local helper_076280e8 = require("@lib/event/helper_076280e8")
local helper_34727ca1 = require("@lib/event/helper_34727ca1")
local helper_38448da1 = require("@lib/event/helper_38448da1")
local helper_4575bf67 = require("@lib/event/helper_4575bf67")
local helper_650bfa16 = require("@lib/event/helper_650bfa16")
local helper_79e692b8 = require("@lib/event/helper_79e692b8")
local helper_8a56995e = require("@lib/event/helper_8a56995e")
local helper_ac1aeb7a = require("@lib/event/helper_ac1aeb7a")
local helper_b7c85616 = require("@lib/event/helper_b7c85616")
local helper_b8bc5976 = require("@lib/event/helper_b8bc5976")
local helper_e304888c = require("@lib/event/helper_e304888c")
local helper_ff0edc1d = require("@lib/event/helper_ff0edc1d")

local global0: s32 = 0
local global1: s32 = 0

--- Helper function.
local function helper_177d8()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local block: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 5 then
			if at <= 1 then
				helper_ff0edc1d(30)
			end
			if at <= 2 then
				helper_650bfa16(2)
			end
			if at <= 3 then
				helper_ff0edc1d(30)
			end
			if at <= 4 then
				helper_ff0edc1d(30)
			end
			if vm.skip_end() then
				return skip(6)
			end
			return part2()
		end
		if at <= 6 then
			helper_ff0edc1d(4)
		end
	end
	function part2()
		event.CancelDramaScene()
		event.StopBgm(0)
		helper_ff0edc1d(4)
		if vm.skipping() then
			return skip(7)
		end
		event.LoadBgm(39)
		event.PlayBgm(0)
		event.CharaActive(0)
		event.CharaActive(8)
		event.CharaActive(9)
		event.SetStatus(1, 0, 256, 0)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.DelExtMotion(0)
		event.DeleteChara(8)
		event.DeleteChara(9)
		event.DeleteChara(10)
		event.DelImg(0)
		event.LoadMes(0, -1)
	end
	event.SetFlag(728, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.LoadSound(7603)
	var0 = event.SndLoadSound(7603) or var0
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.SetStatus(1, 0, 256, 1)
	event.ChangeDir("event/e700/e728/")
	event.LoadMes(0, 5, "e728.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e728_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e728_monica.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.LoadChara(5, "e728_dark.gltf", "info", 10)
	event.CharaActive(10)
	event.EohSyncChara(2, 10)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	block = event.LoadImg_4(5, "e728telop06.json", 0) or block
	event.SpriteInit(0)
	event.SpriteSetType(0, 0)
	event.SpriteSetTexture(0, "e728telop06", block)
	event.SpriteSetColor(0, 128, 128, 128, 0)
	event.SpriteSetUvsize(0, 0, 0, 512, 128)
	event.SpriteSetPutsize(0, 512, 128)
	event.SpriteSetPos(0, 256, 312)
	event.SpriteSetDraw(0, 1)
	event.EohSyncSprite(3, 0)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.ChangeDir("")
	if active_chr_no == 1 then
		event.LoadChara(5, "chara/c01_base.gltf", "info", 8)
		event.LoadEquip(5, 0, 4, "info", 8)
		event.LoadEquip(5, 0, 3, "info", 8)
		event.LoadEquip(5, 0, 2, "info", 8, 9)
		event.LoadMotion(5, "event/e700/e728/e728_mints.gltf", "info", 8)
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
		event.LoadMotion(5, "event/e700/e728/e728_monica.gltf", "info", 8)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 8)
		event.EohSyncChara(1, 8)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 0)
	end
	event.CharaActive(8)
	event.CharaActive(9)
	event.EohSetPos(1, -1.42, 0.0, -83.64)
	event.EohSetRot(1, 0.0, -0.12, 0.0)
	event.EohSetFootSoundId(1, 2)
	event.EohSetPos(0, -23.19, 0.0, -81.74)
	event.EohSetRot(0, 0.0, 0.26, 0.0)
	event.EohSetFootSoundId(0, 2)
	event.EohSetPos(2, 10.04, 99.12, 177.76)
	event.EohSetRot(2, 0.0, -3.07, 0.0)
	event.EohSetFootSoundId(2, 1)
	event.ObjsSetScale(2, 2.0, 2.0, 2.0)
	event.InitDramaScene()
	event.ObjsSetMotion(1, "立ち", 4)
	event.ObjsSetMotion(0, "立ち", 4)
	event.ObjsSetMotion(2, "立ち", 4)
	event.CharaActive(0)
	event.CharaActive(8)
	event.CharaActive(9)
	event.CharaActive(10)
	event.CmrsInit()
	event.CmrsSetPos(-79.96, 12.55, -243.16)
	event.CmrsSetRef(-22.0, 50.18, -66.57)
	event.SetFadeIn(30)
	helper_ff0edc1d(60)
	if vm.skipping() then
		return skip(1)
	end
	event.FadeOutBgm(30)
	helper_ff0edc1d(30)
	if vm.skipping() then
		return skip(2)
	end
	event.CmrsSetPos(12.3, 90.7, -58.0)
	event.CmrsSetRef(8.16, 163.3, 185.9)
	event.ObjsSetColor(3, 128, 128, 128, 128, 30)
	event.SndSePlay(var0, 0)
	event.ObjsSetMotion(2, "乱舞", 6)
	event.ObjsNextMotion(2, "乱舞L", 4)
	helper_650bfa16(2)
	if vm.skipping() then
		return skip(3)
	end
	helper_ff0edc1d(30)
	if vm.skipping() then
		return skip(4)
	end
	event.ObjsSetColor(3, 128, 128, 128, 0, 30)
	event.SetFadeOut(30)
	helper_ff0edc1d(30)
	if vm.skipping() then
		return skip(5)
	end
	return part2()
end

--- Helper function.
local function helper_1efcc()
	local time: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_ff0edc1d(4)
		end
	end
	event.Initialize()
	if vm.wait() then
		return skip(1)
	end
	event.StopBgm(0)
	helper_ff0edc1d(4)
	if vm.skipping() then
		return skip(2)
	end
	event.LoadBgm(39)
	event.PlayBgm(0)
	time = event.GetTime() or time
	event.SetCnt(10, time)
	event.SetTime(24.0)
	event.SetTimeStepEnable(0)
	event.LoadMonsterFile(621, 1)
	event.LoadMonsterFile(622, 0)
	event.AutoSetMonster(621, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
	event.AutoSetMonster(622, -3.84976, 5016.45, 9390.18, 1.0471976, 0.0, 0.0)
	event.Stopwatch(3, 350, 370, 1)
	event.Stopwatch(2, 18000)
	event.Stopwatch_1(0)
	if vm.wait() then
		return skip(3)
	end
	event.SetFadeIn(30)
	event.Finish()
end

--- Helper function.
local function helper_197dc()
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
		event.LoadMotion(5, "event/e700/e732/e732_mints.gltf", "info", global0)
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
		event.LoadMotion(5, "event/e700/e732/e732_monica.gltf", "info", global1)
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
		event.LoadMotion(5, "event/e700/e732/e732_mints.gltf", "info", global0)
		event.EohSyncChara(0, global0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global0)
		event.CharaActive(1, 13)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.LoadMotion(5, "event/e700/e732/e732_monica.gltf", "info", global1)
		event.EohSyncChara(1, global1)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global1)
	end
	event.EohSyncObj(6, "p06_d06b03-0")
	event.EohSetShow(6, 0)
	event.CharaActive(1, 17)
	event.CharaActive(1, 18)
	event.LoadMes(0, 5, "event/e700/e732/e732.txt")
end

--- Helper function.
local function helper_19330()
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
	event.EohSetShow(6, 1)
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
local function helper_1a7e8()
	local projection: f32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 54 then
			if at <= 1 then
				helper_197dc()
				helper_ff0edc1d(15)
			end
			if at <= 2 then
				helper_076280e8()
			end
			if at <= 3 then
				helper_ff0edc1d(30)
			end
			if at <= 4 then
				helper_b8bc5976(7320210, -1)
			end
			if at <= 5 then
				helper_ff0edc1d(30)
			end
			if at <= 6 then
				helper_b8bc5976(7320215, -1)
			end
			if at <= 7 then
				helper_ff0edc1d(30)
			end
			if at <= 8 then
				helper_b8bc5976(7320220, -1)
			end
			if at <= 9 then
				helper_ff0edc1d(30)
			end
			if at <= 10 then
				helper_b8bc5976(7320230, -1)
			end
			if at <= 11 then
				helper_ff0edc1d(30)
			end
			if at <= 12 then
				helper_b8bc5976(7320240, -1)
			end
			if at <= 13 then
				helper_ff0edc1d(30)
			end
			if at <= 14 then
				helper_b8bc5976(7320250, -1)
			end
			if at <= 15 then
				helper_650bfa16(0)
			end
			if at <= 16 then
				helper_ff0edc1d(30)
			end
			if at <= 17 then
				helper_b8bc5976(7320255, -1)
			end
			if at <= 18 then
				helper_ff0edc1d(15)
			end
			if at <= 19 then
				helper_b8bc5976(7320260, -1)
			end
			if at <= 20 then
				helper_650bfa16(0)
			end
			if at <= 21 then
				helper_650bfa16(1)
			end
			if at <= 22 then
				helper_b8bc5976(7320270, -1)
			end
			if at <= 23 then
				helper_650bfa16(0)
			end
			if at <= 24 then
				helper_ff0edc1d(30)
			end
			if at <= 25 then
				helper_b8bc5976(7320280, -1)
			end
			if at <= 26 then
				helper_ff0edc1d(30)
			end
			if at <= 27 then
				helper_b8bc5976(7320285, -1)
			end
			if at <= 28 then
				helper_ff0edc1d(30)
			end
			if at <= 29 then
				helper_b8bc5976(7320290, -1)
			end
			if at <= 30 then
				helper_ff0edc1d(30)
			end
			if at <= 31 then
				helper_b8bc5976(7320295, -1)
			end
			if at <= 32 then
				helper_ff0edc1d(30)
			end
			if at <= 33 then
				helper_b8bc5976(7320300, -1)
			end
			if at <= 34 then
				helper_ff0edc1d(30)
			end
			if at <= 35 then
				helper_b8bc5976(7320310, -1)
			end
			if at <= 36 then
				helper_076280e8()
			end
			if at <= 37 then
				helper_b8bc5976(7320320, -1)
			end
			if at <= 38 then
				helper_ff0edc1d(30)
			end
			if at <= 39 then
				helper_b8bc5976(7320330, -1)
			end
			if at <= 40 then
				helper_ff0edc1d(30)
			end
			if at <= 41 then
				helper_b8bc5976(7320340, -1)
			end
			if at <= 42 then
				helper_ff0edc1d(30)
			end
			if at <= 43 then
				helper_b8bc5976(7320350, -1)
			end
			if at <= 44 then
				helper_ff0edc1d(30)
			end
			if at <= 45 then
				helper_b8bc5976(7320360, -1)
			end
			if at <= 46 then
				helper_076280e8()
			end
			if at <= 47 then
				helper_ff0edc1d(30)
			end
			if at <= 48 then
				helper_b8bc5976(7320370, -1)
			end
			if at <= 49 then
				helper_650bfa16(0)
			end
			if at <= 50 then
				helper_b8bc5976(7320380, -1)
			end
			if at <= 51 then
				helper_650bfa16(0)
			end
			if at <= 52 then
				helper_ff0edc1d(180)
			end
			if at <= 53 then
				helper_ff0edc1d(60)
			end
			if vm.skip_end() then
				return skip(55)
			end
			return part2()
		end
		if at <= 55 then
			helper_19330()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SetProjection(projection)
		helper_19330()
		if vm.skipping() then
			return skip(56)
		end
	end
	event.SetFlag(732, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.StopBgm(0)
	helper_ff0edc1d(4)
	if vm.skipping() then
		return skip(1)
	end
	event.LoadBgm(53)
	event.PlayBgm(0)
	event.LoadSound(7841)
	helper_197dc()
	projection = event.GetProjection() or projection
	event.InitDramaScene()
	event.EohSyncChara(2, 1)
	event.EohSetShow(2, 0)
	event.EohSyncChara(3, 2)
	event.EohSetShow(3, 0)
	event.CharaActive(0, 17)
	event.CharaActive(0, 18)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "デフォルト顔")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.CharaActive(1, global0)
	event.CharaActive(1, global1)
	event.CmrsSetPos(281.98, 20.1, 298.37)
	event.CmrsSetRef(1436.08, 1324.63, 1446.43)
	event.ObjsSetMotion(0, "上向くL", 4, -1.0, 1)
	event.ObjsSetMotion(1, "上向くL", 4, -1.0, 1)
	event.ObjsSetPos(0, 457.63, 0.0, 460.14)
	event.ObjsSetRot(0, 0.0, 0.72, 0.0)
	event.ObjsSetPos(1, 443.3, 0.0, 472.44)
	event.ObjsSetRot(1, 0.0, 0.72, 0.0)
	event.SetFadeIn(30)
	helper_ff0edc1d(15)
	if vm.skipping() then
		return skip(2)
	end
	event.CmrsInitPas()
	event.CmrsSetPasFrm(200)
	event.CmrsAddPas(281.98, 20.1, 298.37, 1436.08, 1324.63, 1446.43)
	event.CmrsAddPas(281.98, 20.1, 298.37, 1436.08, 215.39, 1446.43)
	event.CmrsStartPas()
	helper_076280e8()
	if vm.skipping() then
		return skip(3)
	end
	helper_ff0edc1d(30)
	if vm.skipping() then
		return skip(4)
	end
	event.CmrsSetPos(520.35, 27.62, 447.72)
	event.CmrsSetRef(443.3, 23.28, 472.44)
	event.SetPakuAnim(1, "通常口パク")
	helper_b8bc5976(7320210, -1)
	if vm.skipping() then
		return skip(5)
	end
	event.ResetPakuAnim()
	helper_ff0edc1d(30)
	if vm.skipping() then
		return skip(6)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_b8bc5976(7320215, -1)
	if vm.skipping() then
		return skip(7)
	end
	event.ResetPakuAnim()
	helper_ff0edc1d(30)
	if vm.skipping() then
		return skip(8)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_b8bc5976(7320220, -1)
	if vm.skipping() then
		return skip(9)
	end
	event.ResetPakuAnim()
	helper_ff0edc1d(30)
	if vm.skipping() then
		return skip(10)
	end
	event.CmrsSetPos(422.7, -0.4, 438.35)
	event.CmrsSetRef(1436.08, 1232.78, 1446.43)
	event.SetPakuAnim(0, "通常口パク")
	helper_b8bc5976(7320230, -1)
	if vm.skipping() then
		return skip(11)
	end
	event.ResetPakuAnim()
	helper_ff0edc1d(30)
	if vm.skipping() then
		return skip(12)
	end
	event.SetPakuAnim(0, "通常口パク")
	helper_b8bc5976(7320240, -1)
	if vm.skipping() then
		return skip(13)
	end
	event.ResetPakuAnim()
	helper_ff0edc1d(30)
	if vm.skipping() then
		return skip(14)
	end
	event.ObjsSetMotion(0, "上→右", 6)
	event.ObjsNextMotion(0, "右向くL", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_b8bc5976(7320250, -1)
	if vm.skipping() then
		return skip(15)
	end
	event.ResetPakuAnim()
	helper_650bfa16(0)
	if vm.skipping() then
		return skip(16)
	end
	helper_ff0edc1d(30)
	if vm.skipping() then
		return skip(17)
	end
	event.SetProjection(projection)
	event.CmrsSetPos(520.35, 27.62, 447.72)
	event.CmrsSetRef(443.3, 23.28, 472.44)
	event.SetPakuAnim(0, "通常口パク")
	helper_b8bc5976(7320255, -1)
	if vm.skipping() then
		return skip(18)
	end
	event.ResetPakuAnim()
	helper_ff0edc1d(15)
	if vm.skipping() then
		return skip(19)
	end
	event.ObjsSetMotion(1, "上から左", 6)
	event.ObjsNextMotion(1, "左向くL", 4)
	event.ObjsMotionDelay(1, 60)
	event.ObjsSetMotion(1, "詩人ね", 6)
	event.ObjsNextMotion(1, "詩人ねL", 4)
	event.SetPakuAnim(1, "わらい口パク")
	helper_b8bc5976(7320260, -1)
	if vm.skipping() then
		return skip(20)
	end
	event.ResetPakuAnim()
	helper_650bfa16(0)
	if vm.skipping() then
		return skip(21)
	end
	helper_650bfa16(1)
	if vm.skipping() then
		return skip(22)
	end
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "前向き～下向き")
	event.ObjsSetMotion(0, "そうかな", 6)
	event.ObjsNextMotion(0, "そうかなL", 4)
	event.SetPakuAnim(0, "わらい口パク")
	helper_b8bc5976(7320270, -1)
	if vm.skipping() then
		return skip(23)
	end
	event.ResetPakuAnim()
	helper_650bfa16(0)
	if vm.skipping() then
		return skip(24)
	end
	helper_ff0edc1d(30)
	if vm.skipping() then
		return skip(25)
	end
	event.SetProjection(projection)
	event.ObjsSetMotion(0, "上向くL", 4, -1.0, 1)
	event.ObjsSetMotion(1, "上向くL", 4, -1.0, 1)
	event.CmrsSetPos(281.98, 20.1, 298.37)
	event.CmrsSetRef(1436.08, 215.39, 1446.43)
	helper_b8bc5976(7320280, -1)
	if vm.skipping() then
		return skip(26)
	end
	helper_ff0edc1d(30)
	if vm.skipping() then
		return skip(27)
	end
	helper_b8bc5976(7320285, -1)
	if vm.skipping() then
		return skip(28)
	end
	helper_ff0edc1d(30)
	if vm.skipping() then
		return skip(29)
	end
	helper_b8bc5976(7320290, -1)
	if vm.skipping() then
		return skip(30)
	end
	helper_ff0edc1d(30)
	if vm.skipping() then
		return skip(31)
	end
	helper_b8bc5976(7320295, -1)
	if vm.skipping() then
		return skip(32)
	end
	event.CmrsMove2(281.98, 20.1, 298.37, 1436.08, 1963.82, 1446.43, 300, 0, 1.0)
	helper_ff0edc1d(30)
	if vm.skipping() then
		return skip(33)
	end
	helper_b8bc5976(7320300, -1)
	if vm.skipping() then
		return skip(34)
	end
	helper_ff0edc1d(30)
	if vm.skipping() then
		return skip(35)
	end
	helper_b8bc5976(7320310, -1)
	if vm.skipping() then
		return skip(36)
	end
	helper_076280e8()
	if vm.skipping() then
		return skip(37)
	end
	helper_b8bc5976(7320320, -1)
	if vm.skipping() then
		return skip(38)
	end
	helper_ff0edc1d(30)
	if vm.skipping() then
		return skip(39)
	end
	helper_b8bc5976(7320330, -1)
	if vm.skipping() then
		return skip(40)
	end
	helper_ff0edc1d(30)
	if vm.skipping() then
		return skip(41)
	end
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.CmrsSetPos(539.13, 94.76, 524.34)
	event.CmrsSetRef(457.63, 10.5, 460.14)
	event.CmrsMove2(484.6, 41.24, 479.15, 471.35, 30.37, 469.8, 300, 2, 1.0)
	event.SetCrossfade(30)
	helper_b8bc5976(7320340, -1)
	if vm.skipping() then
		return skip(42)
	end
	helper_ff0edc1d(30)
	if vm.skipping() then
		return skip(43)
	end
	helper_b8bc5976(7320350, -1)
	if vm.skipping() then
		return skip(44)
	end
	helper_ff0edc1d(30)
	if vm.skipping() then
		return skip(45)
	end
	helper_b8bc5976(7320360, -1)
	if vm.skipping() then
		return skip(46)
	end
	helper_076280e8()
	if vm.skipping() then
		return skip(47)
	end
	helper_ff0edc1d(30)
	if vm.skipping() then
		return skip(48)
	end
	event.ObjsSetMotion(0, "帽子取る", 6)
	event.ObjsNextMotion(0, "帽子取るL", 4)
	helper_b8bc5976(7320370, -1)
	if vm.skipping() then
		return skip(49)
	end
	helper_650bfa16(0)
	if vm.skipping() then
		return skip(50)
	end
	event.ObjsSetMotion(0, "ぶるぶる", 6)
	event.ObjsNextMotion(0, "帽子取るL", 4)
	helper_b8bc5976(7320380, -1)
	if vm.skipping() then
		return skip(51)
	end
	helper_650bfa16(0)
	if vm.skipping() then
		return skip(52)
	end
	event.SetProjection(182.9)
	event.CmrsInitPas()
	event.CmrsSetPasFrm(240)
	event.CmrsAddPas(422.7, 30.65, 438.35, 1436.08, 349.8, 1446.43)
	event.CmrsAddPas(353.73, 30.65, 369.74, 1436.08, 349.8, 1446.43)
	event.CmrsStartPas()
	helper_ff0edc1d(180)
	if vm.skipping() then
		return skip(53)
	end
	event.FadeOutBgm(60)
	event.SetFadeOut(60)
	helper_ff0edc1d(60)
	if vm.skipping() then
		return skip(54)
	end
	event.StopBgm(0)
	return part2()
end

--- Helper function.
local function helper_102dc()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local var2: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 52 then
			if at <= 1 then
				helper_b8bc5976(7280160, 540)
			end
			if at <= 2 then
				helper_650bfa16(2)
			end
			if at <= 3 then
				helper_8a56995e(1)
			end
			if at <= 4 then
				helper_e304888c(0, -1, 8, 0, 0)
				helper_ff0edc1d(180)
			end
			if at <= 5 then
				helper_05fbffe0(0, -1)
			end
			if at <= 6 then
				helper_38448da1(0)
				helper_650bfa16(2)
			end
			if at <= 7 then
				helper_ff0edc1d(60)
			end
			if at <= 8 then
				helper_ff0edc1d(30)
			end
			if at <= 9 then
				helper_b8bc5976(7280165, 90)
			end
			if at <= 10 then
				helper_ff0edc1d(60)
			end
			if at <= 11 then
				helper_076280e8()
			end
			if at <= 12 then
				helper_b8bc5976(7280170, 150)
			end
			if at <= 13 then
				helper_b8bc5976(7280180, 120)
			end
			if at <= 14 then
				helper_ff0edc1d(30)
			end
			if at <= 15 then
				helper_b8bc5976(7280190, 500)
			end
			if at <= 16 then
				helper_076280e8()
			end
			if at <= 17 then
				helper_ff0edc1d(30)
			end
			if at <= 18 then
				helper_b8bc5976(7280200, 210)
			end
			if at <= 19 then
				helper_650bfa16(2)
			end
			if at <= 20 then
				helper_b8bc5976(7280210, 480)
			end
			if at <= 21 then
				helper_650bfa16(2)
			end
			if at <= 22 then
				helper_b8bc5976(7280220, 210)
			end
			if at <= 23 then
				helper_650bfa16(2)
			end
			if at <= 24 then
				helper_650bfa16(1)
			end
			if at <= 25 then
				helper_ff0edc1d(60)
			end
			if at <= 26 then
				helper_ff0edc1d(60)
			end
			if at <= 27 then
				helper_b8bc5976(7280230, 420)
			end
			if at <= 28 then
				helper_076280e8()
			end
			if at <= 29 then
				helper_ff0edc1d(60)
			end
			if at <= 30 then
				helper_ff0edc1d(45)
			end
			if at <= 31 then
				helper_ff0edc1d(5)
			end
			if at <= 32 then
				helper_b8bc5976(7280235, 90)
			end
			if at <= 33 then
				helper_ff0edc1d(90)
			end
			if at <= 34 then
				helper_650bfa16(3)
			end
			if at <= 35 then
				helper_ff0edc1d(30)
			end
			if at <= 36 then
				helper_ff0edc1d(90)
			end
			if at <= 37 then
				helper_ff0edc1d(60)
			end
			if at <= 38 then
				helper_ff0edc1d(100)
			end
			if at <= 39 then
				helper_ff0edc1d(30)
			end
			if at <= 40 then
				helper_ff0edc1d(60)
			end
			if at <= 41 then
				helper_b8bc5976(7280240, 90)
			end
			if at <= 42 then
				helper_b8bc5976(7280245, 300)
			end
			if at <= 43 then
				helper_ff0edc1d(90)
			end
			if at <= 44 then
				helper_ff0edc1d(30)
			end
			if at <= 45 then
				helper_ff0edc1d(30)
			end
			if at <= 46 then
				helper_ff0edc1d(90)
			end
			if at <= 47 then
				helper_076280e8()
			end
			if at <= 48 then
				helper_ff0edc1d(30)
			end
			if at <= 49 then
				helper_ff0edc1d(30)
			end
			if at <= 50 then
				helper_ff0edc1d(90)
			end
			if at <= 51 then
				helper_ff0edc1d(31)
			end
			if vm.skip_end() then
				return skip(53)
			end
			return part2()
		end
		if at <= 53 then
			helper_ff0edc1d(4)
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SetMotionBlur(0)
		event.SndSeStop(var0, 2)
		event.SndSeStop(var0, 3)
		event.SndSeStop(var0, 8)
		var2 = event.GetBgmNo() or var2
		if var2 ~= 37 then
			event.StopBgm(0)
			helper_ff0edc1d(4)
			if vm.skipping() then
				return skip(54)
			end
			event.LoadBgm(37)
			event.PlayBgm(0)
		end
		event.CharaActive(0)
		event.CharaActive(8)
		event.CharaActive(9)
		event.SetStatus(1, 0, 256, 0)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.DelExtMotion(0)
		event.DeleteChara(8)
		event.DeleteChara(9)
		event.DeleteChara(10)
		event.DeleteChara(11)
		event.DeleteChara(12)
		event.DeleteChara(13)
		event.DeleteChara(14)
		event.DeleteChara(15)
		event.LoadMes(0, -1)
	end
	event.SetFlag(728, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.LoadSound(7835)
	var0 = event.SndLoadSound(7835) or var0
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.SetStatus(1, 0, 256, 1)
	event.ChangeDir("event/e700/e728/")
	event.LoadMes(0, 5, "e728.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e728_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e728_monica.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.LoadChara(5, "e728_dark.gltf", "info", 10)
	event.CharaActive(10)
	event.EohSyncChara(2, 10)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.LoadChara(5, "e728_sun.gltf", "info", 11)
	event.CharaActive(11)
	event.EohSyncChara(3, 11)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.LoadChara(5, "e728_magic_h.gltf", "info", 12)
	event.CharaActive(12)
	event.EohSyncChara(4, 12)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.LoadChara(5, "e728_magic_l.gltf", "info", 13)
	event.CharaActive(13)
	event.EohSyncChara(5, 13)
	event.ObjsInit(5)
	event.ObjsSyncObj(5, 5)
	event.LoadChara(5, "e728_dehikari.gltf", "info", 14)
	event.CharaActive(14)
	event.EohSyncChara(7, 14)
	event.ObjsInit(7)
	event.ObjsSyncObj(7, 7)
	event.LoadChara(5, "e728_san_hit.gltf", "info", 15)
	event.CharaActive(15)
	event.EohSyncChara(8, 15)
	event.ObjsInit(8)
	event.ObjsSyncObj(8, 8)
	event.ChangeDir("")
	if active_chr_no == 1 then
		event.LoadChara(5, "chara/c01_base.gltf", "info", 8)
		event.LoadEquip(5, 0, 4, "info", 8)
		event.LoadEquip(5, 0, 3, "info", 8)
		event.LoadEquip(5, 0, 2, "info", 8, 9)
		event.LoadMotion(5, "event/e700/e728/e728_mints.gltf", "info", 8)
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
		event.LoadMotion(5, "event/e700/e728/e728_monica.gltf", "info", 8)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 8)
		event.EohSyncChara(1, 8)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 0)
	end
	event.CharaActive(8)
	event.CharaActive(9)
	event.EohSyncObj(6, "p06_d06b03-0")
	event.ObjsInit(6)
	event.ObjsSyncObj(6, 6)
	event.ObjsSetScale(6, 0.7, 0.7, 0.7)
	event.EohSetPos(1, -1.42, 0.0, -83.64)
	event.EohSetRot(1, 0.0, -0.12, 0.0)
	event.EohSetFootSoundId(1, 2)
	event.EohSetPos(0, -23.19, 0.0, -81.74)
	event.EohSetRot(0, 0.0, 0.26, 0.0)
	event.EohSetFootSoundId(0, 2)
	event.EohSetPos(2, -12.34, 0.0, 42.31)
	event.EohSetRot(2, 0.0, -3.07, 0.0)
	event.EohSetFootSoundId(2, 1)
	event.ObjsSetScale(2, 2.0, 2.0, 2.0)
	event.SetReference(10, "tama", 14)
	event.EohSetPos(3, 452.27, -10000, 254.12)
	event.EohSetRot(3, 0.0, -0.1, 0.0)
	event.EohSetFootSoundId(3, 1)
	event.EohSetPos(8, 452.27, -10000, 254.12)
	event.EohSetRot(8, 0.0, -0.1, 0.0)
	event.EohSetShow(6, 0)
	event.EohSetShow(8, 0)
	event.InitDramaScene()
	event.ObjsSetMotion(1, "立ち", 4)
	event.ObjsSetMotion(0, "立ち", 4)
	event.ObjsSetMotion(2, "立ち", 4)
	event.ObjsSetMotion(3, "立ち", 4)
	event.ObjsResetDaPosition(3)
	event.CharaActive(0)
	event.CharaActive(8)
	event.CharaActive(9)
	event.CharaActive(10)
	event.CharaActive(11)
	event.CharaActive(0, 12)
	event.CharaActive(0, 13)
	event.SetProjection(360.9)
	event.CmrsInit()
	event.CmrsSetPos(6.95, 33.33, -38.64)
	event.CmrsSetRef(2.96, 21.19, 34.24)
	event.SetFadeIn(30)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おこり顔")
	event.ObjsTexAnime(0, 1, "おこり目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "おこり顔")
	event.ObjsTexAnime(1, 1, "おこり目パチ")
	helper_ff0edc1d(30)
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsMove2(6.95, 33.33, -38.64, -16.79, 86.78, 30.71, 120, 2, 1.0)
	helper_b8bc5976(7280160, 540)
	if vm.skipping() then
		return skip(2)
	end
	event.SetProjection(524.9)
	event.CmrsSetPos(-17.25, 2.73, -179.23)
	event.CmrsSetRef(-11.0, 60.16, -36.27)
	event.SndSePlay(var0, 0)
	event.ObjsSetMotion(2, "手を上げる", 6)
	event.ObjsNextMotion(2, "手を上げるL", 4)
	helper_650bfa16(2)
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsMotionDelay(2, 180)
	event.ObjsSetMotion(2, "死に絶えるのだ", 6)
	event.ObjsNextMotion(2, "死に絶えるのだL", 4)
	event.ObjsSeDelay(2, 180)
	event.ObjsSePlay(2, var0, 1)
	event.StreamOpen3(1, 7280163)
	helper_8a56995e(1)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(0, 7280163)
	helper_e304888c(0, -1, 8, 0, 0)
	event.StreamPlay(1)
	helper_ff0edc1d(180)
	if vm.skipping() then
		return skip(5)
	end
	event.SetCrossfade(30)
	event.CmrsSetPos(1.58, 101.91, -60.95)
	event.CmrsSetRef(-17.89, 92.73, 25.56)
	helper_05fbffe0(0, -1)
	if vm.skipping() then
		return skip(6)
	end
	helper_38448da1(0)
	event.StreamClose(1)
	helper_650bfa16(2)
	if vm.skipping() then
		return skip(7)
	end
	event.CmrsSetPos(-37.44, 9.97, -30.69)
	event.CmrsSetRef(1007.77, 434.9, -2136.35)
	event.CmrsQuake2(0.0, 3.3, 0.0, 60)
	event.SndSePlay(var0, 2)
	event.EohSetShow(6, 1)
	helper_ff0edc1d(60)
	if vm.skipping() then
		return skip(8)
	end
	event.ObjsSetMotion(0, "上向く", 6)
	event.ObjsNextMotion(0, "上向くL", 4)
	event.ObjsSetMotion(1, "上向く", 6)
	event.ObjsNextMotion(1, "上向くL", 4)
	helper_ff0edc1d(30)
	if vm.skipping() then
		return skip(9)
	end
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おこり顔")
	event.ObjsTexAnime(0, 1, "おこり目～おどろき目")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "おこり顔")
	event.ObjsTexAnime(1, 1, "おこり目～おどろき目")
	event.ObjsTexAnime(1, 1, "口とじ～大口")
	event.ObjsTexAnime(0, 1, "口とじ～大口")
	helper_b8bc5976(7280165, 90)
	if vm.skipping() then
		return skip(10)
	end
	event.CmrsSetPos(-5.51, 54.41, -260.22)
	event.CmrsSetRef(-13.59, 43.11, -47.5)
	event.ObjsSetMotion(2, "立ち", 4)
	event.ObjsSetScale(6, 1.0, 1.0, 1.0, 180)
	event.ObjsSetMotion(2, "振り返る", 6)
	event.ObjsNextMotion(2, "上見立ち", 4)
	helper_ff0edc1d(60)
	if vm.skipping() then
		return skip(11)
	end
	event.CmrsMove2(-5.51, 375.83, -260.22, -4.47, 459.86, -47.34, 120, 0, 1.0)
	helper_076280e8()
	if vm.skipping() then
		return skip(12)
	end
	event.CmrsSetPos(-44.01, 88.99, -11.02)
	event.CmrsSetRef(-13.6, 22.3, -75.12)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おこり顔")
	event.ObjsTexAnime(0, 1, "おこり目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "おこり顔")
	event.ObjsTexAnime(1, 1, "おこり目パチ")
	event.SetPakuAnim(1, "通常口パク")
	helper_b8bc5976(7280170, 150)
	if vm.skipping() then
		return skip(13)
	end
	event.SetPakuAnim(0, "通常口パク")
	helper_b8bc5976(7280180, 120)
	if vm.skipping() then
		return skip(14)
	end
	event.CmrsMove2(-88.64, 165.69, 144.36, -18.85, 102.29, 59.43, 120, 0, 0.5)
	event.SndSeStop(var0, 2)
	event.SndSePlay(var0, 3)
	helper_ff0edc1d(30)
	if vm.skipping() then
		return skip(15)
	end
	helper_b8bc5976(7280190, 500)
	if vm.skipping() then
		return skip(16)
	end
	helper_076280e8()
	if vm.skipping() then
		return skip(17)
	end
	event.CmrsSetPos(-14.82, 6.49, -265.28)
	event.CmrsSetRef(-12.4, 63.83, -45.92)
	event.ObjsSetPos(2, -10.86, 37.42, 79.41)
	event.ObjsResetDaPosition(2)
	helper_ff0edc1d(30)
	if vm.skipping() then
		return skip(18)
	end
	event.ObjsSetMotion(2, "振り返る2", 6)
	event.ObjsNextMotion(2, "立ち", 4)
	helper_b8bc5976(7280200, 210)
	if vm.skipping() then
		return skip(19)
	end
	helper_650bfa16(2)
	if vm.skipping() then
		return skip(20)
	end
	event.SndSePlay(var0, 4)
	event.ObjsSetMotion(2, "闇世界の王", 6)
	event.ObjsNextMotion(2, "闇世界の王L", 4)
	event.ObjsSeDelay(2, 30)
	event.ObjsSePlay(2, var0, 5)
	helper_b8bc5976(7280210, 480)
	if vm.skipping() then
		return skip(21)
	end
	helper_650bfa16(2)
	if vm.skipping() then
		return skip(22)
	end
	event.CmrsSetPos(-45.16, 123.78, 11.64)
	event.CmrsSetRef(-7.21, 140.87, 80.61)
	event.StopBgm(0)
	event.CharaActive(13)
	event.ObjsSetPos(5, -9.83, 0.0, -376.53)
	event.ObjsSetMotion(5, "魔法かまえ")
	event.ObjsSetMotion(3, "魔法かまえ", 4)
	event.ObjsSetPos(3, -9.83, 0.0, -376.53)
	event.ObjsResetDaPosition(3)
	event.ObjsSetPos(8, -9.83, 0.0, -376.53)
	event.ObjsSetMotion(2, "フハハハハ", 4)
	helper_b8bc5976(7280220, 210)
	if vm.skipping() then
		return skip(23)
	end
	event.SndSePlay(var0, 6)
	event.CharaActive(12)
	event.ObjsSetPos(4, -16.64, 87.63, 60.46)
	event.ObjsSetRot(4, 0.0, -3.07, 0.0)
	event.ObjsSetMotion(4, "魔法あたる", 6)
	event.ObjsSetMotion(2, "魔法あたる", 6)
	event.ObjsNextMotion(2, "立ち")
	helper_650bfa16(2)
	if vm.skipping() then
		return skip(24)
	end
	event.SndSeStop(var0, 3)
	event.CmrsSetPos(-12.59, 20.81, -29.79)
	event.CmrsSetRef(-11.75, 19.91, -100.77)
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "おこり顔")
	event.ObjsTexAnime(1, 1, "おこり目パチ")
	event.ObjsTexAnime(1, 1, "半口")
	event.SndSePlay(var0, 7)
	event.ObjsSetMotion(0, "後ろ見る", 6)
	event.ObjsNextMotion(0, "後ろ見るL", 4)
	event.ObjsSetMotion(1, "後ろ見", 6)
	event.ObjsNextMotion(1, "後ろ見L", 4)
	helper_650bfa16(1)
	if vm.skipping() then
		return skip(25)
	end
	helper_ff0edc1d(60)
	if vm.skipping() then
		return skip(26)
	end
	event.CmrsSetPos(-0.53, 9.74, -325.24)
	event.CmrsSetRef(-10.06, 15.31, -377.35)
	event.ObjsTexAnime(3, 0)
	event.SndSePlay(var0, 8)
	event.ObjsTexAnime(3, 1, "つかれ目パチ")
	helper_ff0edc1d(60)
	if vm.skipping() then
		return skip(27)
	end
	event.SndSeStop(var0, 8)
	event.CmrsSetPos(8.44, 122.24, -79.64)
	event.CmrsSetRef(17.47, 121.82, 84.02)
	event.CharaActive(0, 13)
	event.CmrsMove(-31.27, 122.24, -88.16, -24.72, 121.82, 75.61, 420)
	helper_b8bc5976(7280230, 420)
	if vm.skipping() then
		return skip(28)
	end
	helper_076280e8()
	if vm.skipping() then
		return skip(29)
	end
	event.CmrsSetPos(-143.28, 120.11, -54.02)
	event.CmrsSetRef(-4.2, 126.33, 56.81)
	event.SndSePlay(var0, 9)
	event.ObjsSetMotion(2, "杖投げる", 6)
	helper_ff0edc1d(60)
	if vm.skipping() then
		return skip(30)
	end
	event.CmrsSetPos(-63.01, 36.02, -308.06)
	event.CmrsSetRef(6.33, 11.27, -369.11)
	event.SetModelLightSwitch(10, 0)
	event.SetModelLightColor(10, 128.0, 128.0, 128.0, 128.0)
	event.ObjsResetMotion(2)
	event.ObjsSetMotion(2, "杖投げる", 6)
	event.ObjsSetScale(2, 0.5, 1.0, 1.0)
	event.ObjsSetPos(2, 6.23, -0.75, -116.64)
	event.ObjsResetDaPosition(2)
	event.ObjsSeDelay(3, 45)
	event.ObjsSePlay(3, var0, 10)
	event.ObjsMotionDelay(3, 45)
	event.ObjsSetMotion(3, "刺さる", 6)
	event.ObjsNextMotion(3, "刺さるL", 4)
	helper_ff0edc1d(45)
	if vm.skipping() then
		return skip(31)
	end
	event.EohSetShow(8, 1)
	event.ObjsSetMotion(8, "刺さる", 6)
	helper_ff0edc1d(5)
	if vm.skipping() then
		return skip(32)
	end
	helper_b8bc5976(7280235, 90)
	if vm.skipping() then
		return skip(33)
	end
	event.CmrsSetPos(-13.1, 29.49, -152.47)
	event.CmrsSetRef(-13.69, 6.9, -67.55)
	event.EohSetShow(8, 0)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おどろき顔")
	event.ObjsTexAnime(0, 1, "おどろき目パチ")
	event.ObjsTexAnime(0, 1, "口とじ～大口")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "おどろき顔")
	event.ObjsTexAnime(1, 1, "おどろき目パチ")
	event.ObjsTexAnime(1, 1, "大口")
	event.ObjsSetScale(2, 2.0, 2.0, 2.0)
	event.ObjsSetPos(2, -10.86, 37.42, 79.41)
	event.ObjsResetDaPosition(2)
	event.ObjsSetPos(1, -1.96, 0.0, -78.42)
	event.ObjsSetRot(1, 0.0, -0.48, 0.0)
	event.ObjsResetDaPosition(1)
	helper_ff0edc1d(90)
	if vm.skipping() then
		return skip(34)
	end
	event.CmrsSetPos(-139.53, 12.92, -295.36)
	event.CmrsSetRef(-5.92, 14.31, -385.02)
	event.ObjsSetScale(2, 1.0, 1.0, 1.0)
	event.ObjsSetPos(2, 4.32, 1.63, -115.01)
	event.ObjsResetDaPosition(2)
	event.ObjsMove(2, 4.32, 25.63, -115.01, 120)
	event.ObjsMove(3, -9.83, 25.0, -376.53, 120)
	helper_650bfa16(3)
	if vm.skipping() then
		return skip(35)
	end
	helper_ff0edc1d(30)
	if vm.skipping() then
		return skip(36)
	end
	event.CmrsSetPos(-10.74, 103.97, -46.08)
	event.CmrsSetRef(-10.95, 122.33, 62.77)
	event.SetModelLightSwitch(10, 1)
	event.ObjsSetScale(2, 2.0, 2.0, 2.0)
	event.ObjsSetPos(2, -10.86, 37.42, 79.41)
	event.ObjsResetDaPosition(2)
	event.SndSePlay(var0, 11)
	event.ObjsSetMotion(2, "カモーン", 6)
	event.ObjsNextMotion(2, "カモーンL", 4)
	helper_ff0edc1d(90)
	if vm.skipping() then
		return skip(37)
	end
	event.CmrsSetPos(-139.53, 12.92, -295.36)
	event.CmrsSetRef(-5.92, 14.31, -385.02)
	event.SetModelLightSwitch(10, 0)
	event.SetModelLightColor(10, 128.0, 128.0, 128.0, 128.0)
	event.ObjsSetMotion(1, "立ち", 4)
	event.ObjsSetMotion(0, "立ち", 4)
	event.ObjsSetScale(2, 1.0, 1.0, 1.0)
	event.ObjsSetPos(2, 4.32, 25.63, -115.01)
	event.ObjsResetDaPosition(2)
	event.ObjsMove(2, 13.34, 42.27, -29.33, 10)
	event.SndSePlay(var0, 12)
	event.ObjsMotionDelay(3, 10)
	event.ObjsSetMotion(3, "落ちる", 6)
	event.ObjsNextMotion(3, "落ちるL", 4)
	event.ObjsMove(3, -9.83, 0.0, -376.53, 30)
	helper_ff0edc1d(60)
	if vm.skipping() then
		return skip(38)
	end
	event.SetModelLightSwitch(10, 1)
	event.CmrsSetPos(8.05, 9.57, -432.58)
	event.CmrsSetRef(-4.2, 9.01, -384.9)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おこり顔")
	event.ObjsTexAnime(0, 1, "おこり目パチ")
	event.ObjsTexAnime(0, 1, "半口")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "おこり顔")
	event.ObjsTexAnime(1, 1, "おこり目パチ")
	event.ObjsTexAnime(1, 1, "半口")
	event.ObjsSetMotion(2, "立ち", 4)
	event.ObjsSetScale(2, 2.0, 2.0, 2.0)
	event.ObjsSetPos(2, -10.86, 37.42, 79.41)
	event.ObjsResetDaPosition(2)
	event.ObjsSetPos(0, -27.05, 0.0, -181.8)
	event.ObjsSetRot(0, 0.0, 3.06, 0.0)
	event.ObjsResetDaPosition(0)
	event.ObjsSetPos(1, 7.3, 0.0, -200.98)
	event.ObjsSetRot(1, 0.0, 3.04, 0.0)
	event.ObjsResetDaPosition(1)
	event.ObjsSetMotion(0, "走り", 4)
	event.ObjsMove(0, -25.77, 0.0, -317.97, 120)
	event.ObjsRotation(0, 0.0, 2.94, 0.0, 120)
	event.ObjsSetMotion(1, "走り", 4)
	event.ObjsMove(1, 4.82, 0.0, -318.77, 120)
	event.ObjsRotation(1, 0.0, -3.0, 0.0, 120)
	helper_ff0edc1d(100)
	if vm.skipping() then
		return skip(39)
	end
	event.CmrsSetPos(-31.52, 44.28, -338.11)
	event.CmrsSetRef(-5.77, 5.41, -388.31)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetPos(0, -24.38, 0.0, -382.48)
	event.ObjsSetRot(0, 0.0, 2.22, 0.0)
	event.ObjsResetDaPosition(0)
	event.ObjsResetMotion(0)
	event.ObjsSetMotion(0, "立ち", 4)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.ObjsSetPos(1, 10.7, 0.0, -369.54)
	event.ObjsSetRot(1, 0.0, -2.64, 0.0)
	event.ObjsResetDaPosition(1)
	event.ObjsResetMotion(1)
	event.ObjsSetMotion(1, "立ち", 4)
	helper_ff0edc1d(30)
	if vm.skipping() then
		return skip(40)
	end
	event.ObjsTexAnime(3, 0)
	event.ObjsTexAnime(3, 1, "目とじ２～くるし目")
	event.ObjsSetMotion(0, "しゃがむ", 6)
	event.ObjsNextMotion(0, "しゃがむL", 4)
	event.ObjsMotionDelay(1, 15)
	event.ObjsSetMotion(1, "しゃがみ", 6)
	event.ObjsNextMotion(1, "しゃがみL", 4)
	event.ObjsSetMotion(3, "ユリス見る", 6)
	event.ObjsNextMotion(3, "ユリス見るL", 4)
	helper_ff0edc1d(60)
	if vm.skipping() then
		return skip(41)
	end
	helper_b8bc5976(7280240, 90)
	if vm.skipping() then
		return skip(42)
	end
	helper_b8bc5976(7280245, 300)
	if vm.skipping() then
		return skip(43)
	end
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "かなし顔")
	event.ObjsTexAnime(0, 1, "かなし目パチ")
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "かなし顔")
	event.ObjsTexAnime(0, 1, "かなし目～おこり目")
	event.ObjsTexAnime(0, 1, "歯くいしばり")
	event.CmrsSetPos(-6.87, 5.41, -405.85)
	event.CmrsSetRef(-26.19, 16.97, -379.68)
	event.ObjsSetMotion(3, "落ちるL", 6)
	event.ObjsSetPos(1, 10.32, 0.0, -384.63)
	event.ObjsResetDaPosition(1)
	helper_ff0edc1d(90)
	if vm.skipping() then
		return skip(44)
	end
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "おこり顔")
	event.ObjsTexAnime(1, 1, "おこり目パチ")
	event.LoadBgm(37)
	event.PlayBgm(0)
	helper_ff0edc1d(30)
	if vm.skipping() then
		return skip(45)
	end
	event.SndSePlay(var0, 13)
	event.ObjsSetMotion(0, "しゃがむ戻り", 6)
	event.ObjsRotation(0, 0.0, 0.18, 0.0, 20)
	event.ObjsMotionDelay(0, 20)
	event.ObjsNextMotion(0, "立ち", 4)
	event.ObjsSetMotion(1, "おきあがり", 6)
	event.ObjsRotation(1, 0.0, -0.24, 0.0, 20)
	event.ObjsMotionDelay(1, 20)
	event.ObjsNextMotion(1, "立ち", 4)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おこり顔")
	event.ObjsTexAnime(0, 1, "おこり目パチ")
	event.CmrsSetPos(-11.62, 15.51, -310.99)
	event.CmrsSetRef(-10.21, 16.97, -375.48)
	helper_ff0edc1d(30)
	if vm.skipping() then
		return skip(46)
	end
	helper_ff0edc1d(90)
	if vm.skipping() then
		return skip(47)
	end
	event.CmrsSetPos(21.35, 75.0, -74.7)
	event.CmrsSetRef(-18.07, 133.59, 68.07)
	event.ObjsSetPos(0, -17.05, 0.0, -260.83)
	event.ObjsSetRot(0, 0.0, 0.3, 0.0)
	event.ObjsResetDaPosition(0)
	event.ObjsSetPos(1, 20.43, 0.0, -290.0)
	event.ObjsSetRot(1, 0.0, 0.12, 0.0)
	event.ObjsResetDaPosition(1)
	event.CmrsMove2(71.01, 5.64, -395.51, -82.14, 81.58, 45.26, 120, 2, 1.0)
	helper_076280e8()
	if vm.skipping() then
		return skip(48)
	end
	helper_ff0edc1d(30)
	if vm.skipping() then
		return skip(49)
	end
	event.CmrsSetPos(-14.25, 113.8, -124.29)
	event.CmrsSetRef(-12.74, 114.05, 57.05)
	event.ObjsSetMotion(2, "杖構える", 6)
	event.ObjsNextMotion(2, "杖構えるL", 4)
	event.ObjsSeDelay(2, 30)
	event.ObjsSePlay(2, var0, 14)
	helper_ff0edc1d(30)
	if vm.skipping() then
		return skip(50)
	end
	event.SetMotionBlur(100)
	event.CmrsQuake2(0.0, 8.5, 5.5, 150)
	helper_ff0edc1d(90)
	if vm.skipping() then
		return skip(51)
	end
	event.SetFadeOut(20, 255, 255, 255)
	helper_ff0edc1d(31)
	if vm.skipping() then
		return skip(52)
	end
	return part2()
end

--- Helper function.
local function helper_c9e0(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_b7c85616(1, 4)
			helper_34727ca1(1, vm.i32(60 + arg0), 8, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(1, 4)
	helper_b7c85616(1, 4)
	helper_34727ca1(1, vm.i32(60 + arg0), 8, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_deec(arg0: s32, arg1: s32)
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
				helper_ff0edc1d(30)
			end
			if at <= 2 then
				helper_4575bf67()
			end
			if at <= 3 then
				helper_ff0edc1d(30)
			end
			if at <= 4 then
				helper_ac1aeb7a(arg1, -1)
			end
			if at <= 5 then
				helper_ff0edc1d(10)
			end
			if at <= 6 then
				helper_ff0edc1d(30)
			end
			if at <= 7 then
				helper_ff0edc1d(120)
			end
			if at <= 8 then
				local _ = helper_79e692b8(0)
			end
			if at <= 9 then
				helper_c9e0(1)
			end
			if at <= 10 then
				helper_c9e0(4)
			end
			if at <= 11 then
				helper_c9e0(active_chr_no)
			end
			if at <= 12 then
				helper_c9e0(1)
			end
			if at <= 13 then
				helper_ff0edc1d(30)
			end
			if at <= 15 then
				helper_ff0edc1d(30)
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
	helper_ff0edc1d(30)
	if vm.skipping() then
		return skip(2)
	end
	event.SetStatusbarShow(0, 0.06666667)
	helper_4575bf67()
	if vm.skipping() then
		return skip(3)
	end
	event.LoadBgmPack(60)
	if var8 == 1 or var8 ~= 1 and arg1 < 0 then
		event.PlayBgm(0)
	end
	helper_ff0edc1d(30)
	if vm.skipping() then
		return skip(4)
	end
	event.DngPause(1, 1)
	event.DngCollisionAllClr()
	if var8 ~= 1 then
		block = event.LoadImg_4(5, "textures/dungeon/image/gameover.json", 1) or block
		if arg1 >= 0 then
			helper_ac1aeb7a(arg1, -1)
			if vm.skipping() then
				return skip(5)
			end
			helper_ff0edc1d(10)
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
		helper_ff0edc1d(30)
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
		helper_ff0edc1d(120)
		if vm.skipping() then
			return skip(8)
		end
		while true do
			if helper_79e692b8(0) ~= 0 then
				break
			end
			if vm.wait() then
				return skip(9)
			end
		end
	elseif active_chr_no == 3 then
		var10 = event.CheckEnableCharaChange(1) or var10
		if var10 == 0 then
			helper_c9e0(1)
			if vm.skipping() then
				return skip(10)
			end
		else
			helper_c9e0(4)
			if vm.skipping() then
				return skip(11)
			end
		end
	elseif active_chr_no == 0 or active_chr_no == 2 then
		helper_c9e0(active_chr_no)
		if vm.skipping() then
			return skip(12)
		end
	else
		helper_c9e0(1)
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
		helper_ff0edc1d(30)
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
		helper_ff0edc1d(30)
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
	helper_ff0edc1d(4)
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
local function helper_10250(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		return helper_deec(arg0, arg1)
	end
	if vm.skipping() then
		return skip(1)
	end
	return helper_deec(arg0, arg1)
end

--- Helper function.
local function helper_101b8(arg0: s32)
	return helper_deec(arg0, -1)
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 99.
-- Defined empty, so the engine runs this instead of its default.
script[99] = function() end

--- Program 100.
script[100] = function()
	local flag: s32 = 0
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	flag = event.GetFlag(728) or flag
	if flag == 1 then
		active_chr_no = event.GetActiveChrNo() or active_chr_no
		if active_chr_no == 2 then
			event.DngSetupMainUnit(0)
		end
		if active_chr_no == 3 then
			event.DngSetupMainUnit(1)
		end
		event.SetStatusbarShow(0, 1.0)
		helper_177d8()
		if vm.skipping() then
			return skip(1)
		end
		event.SetStatusbarShow(1, 1.0)
		event.LoadMonsterFile(621, 1)
		event.LoadMonsterFile(622, 0)
		event.AutoSetMonster(621, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
		event.AutoSetMonster(622, -3.84976, 5016.45, 9390.18, 1.0471976, 0.0, 0.0)
		event.Stopwatch(3, 350, 370, 1)
		event.Stopwatch(2, 18000)
		event.Stopwatch_1(0)
	end
	event.SetCharaPos(0, 0.0, 0.0, -400.0)
	event.SetCharaRot(0, 0.0, 0.0, 0.0)
	event.SetCameraRef(0.0, 30.0, -400.0)
	event.SetCameraPos(0.0, 40.0, -520.0)
	event.ResetCamera(0)
	if vm.wait() then
		return skip(2)
	end
	event.SetFadeIn(30)
	event.Finish()
end

--- Program 150.
-- Defined empty, so the engine runs this instead of its default.
script[150] = function() end

--- Program 151.
script[151] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_1efcc()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 500.
script[500] = function()
	local active_chr_no: s32 = 0
	local active_chr_no_2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	print(">>>>>>>>>>>>>>>>>RUN 500\n")
	event.Initialize()
	event.ActchrSetDefMotion(0)
	event.SetFadeOut(20)
	helper_ff0edc1d(20)
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		event.SetCharaCondition(0, 8, 1)
	end
	if active_chr_no == 1 then
		event.SetCharaCondition(1, 8, 1)
	end
	event.DelMonster(-1)
	event.SetFloorInfo(5, 27, 5, 2)
	active_chr_no_2 = event.GetActiveChrNo() or active_chr_no_2
	if active_chr_no_2 == 2 then
		event.DngSetupMainUnit(0)
	end
	if active_chr_no_2 == 3 then
		event.DngSetupMainUnit(1)
	end
	event.GotoEdit(180, 500)
end

--- Program 510.
script[510] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_1a7e8()
	if vm.skipping() then
		return skip(1)
	end
	event.SetSavedataEtc(0, 10)
	if vm.wait() then
		return skip(2)
	end
	event.MapJump(-1, "s66", 520)
end

--- Program 550.
script[550] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetStatusbarShow(0, 1.0)
	event.SetCharaShow(1, 0)
	event.SetCharaShow(2, 0)
	helper_102dc()
	if vm.skipping() then
		return skip(1)
	end
	event.BgmLoadCancel()
	if vm.wait() then
		return skip(2)
	end
	event.LoadDungeonMapFile("d06b02")
	event.LoadScript("d06b02/d06b02.stb", 100)
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
				helper_10250(0, 8570070)
			end
			return
		end
	end
	flag = event.GetFlag(728) or flag
	flag_2 = event.GetFlag(732) or flag_2
	if flag ~= 0 and flag_2 == 0 then
		value = event.GetRandInt(100) or value
		if value < 50 then
			helper_10250(0, 8570060)
			if vm.skipping() then
				return skip(1)
			end
		else
			helper_10250(0, 8570070)
			if vm.skipping() then
				return skip(2)
			end
		end
		return
	end
	helper_101b8(0)
	if vm.skipping() then
		return skip(3)
	end
end

--- Program 1201.
script[1201] = function()
	local var0: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local argc: s32 = 0
	local battle_bgm_vol: s32 = 0
	local active_chr_no: s32 = 0
	local block: s32 = 0
	local debug_flag: s32 = 0
	local load_no: s32 = 0
	local boss_map: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 8 then
			if at <= 1 then
				helper_ff0edc1d(30)
			end
			if at <= 2 then
				helper_4575bf67()
			end
			if at <= 3 then
				helper_ff0edc1d(30)
			end
			if at <= 4 then
				helper_ff0edc1d(30)
			end
			if at <= 5 then
				helper_ff0edc1d(120)
			end
			if at <= 6 then
				local _ = helper_79e692b8(0)
			end
			if at <= 7 then
				debug_flag = 0
				helper_ff0edc1d(30)
			end
			return 1
		end
		return 0
	end
	event.Initialize()
	event.DngPause(15, 1)
	var0 = 0
	event.Initialize()
	var1 = event.SndLoadSound(8, "snd2/sp/sp_052.sound.json") or var1
	event.AssignStack(5)
	event.ClearStack(5)
	event.DngPause(16384, 1)
	event.SndSePlay(var1, 0)
	event.SpriteInit(0)
	event.SpriteSetType(0, 0)
	event.SpriteSetPos(0, 256, 208)
	event.SpriteSetPutsize(0, 512, 416)
	event.SpriteSetColor(0, 128, 128, 128, 0)
	event.SpriteSetDraw(0, 0)
	event.EohSyncSprite(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.SpriteSetDraw(0, 1)
	event.ObjsSetColor(0, 128, 128, 128, 128, 90)
	helper_ff0edc1d(90)
	if vm.skipping() then
		return skip(1)
	end
	event.GetActiveBgmStatus(-1)
	var2 = event.GetEventInfoSndid(4) or var2
	argc = event.GetSeStatus(var2, 0) or argc
	battle_bgm_vol = event.GetBtlBgmVol() or battle_bgm_vol
	event.SndSeStop(var2, 0)
	event.StopBgm(0)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.SetLoadbgFile("snd2/bgm/bg_060.sound.json", "textures/dungeon/image/gameover.json")
	helper_ff0edc1d(30)
	if vm.skipping() then
		return skip(2)
	end
	helper_4575bf67()
	if vm.skipping() then
		return skip(3)
	end
	event.LoadBgmPack(60)
	event.PlayBgm(0)
	helper_ff0edc1d(30)
	if vm.skipping() then
		return skip(4)
	end
	event.DngPause(1, 1)
	event.DngCollisionAllClr()
	block = event.LoadImg_4(5, "textures/dungeon/image/gameover.json", 0) or block
	event.SpriteInit(1)
	event.SpriteSetType(1, 0)
	event.SpriteSetTexture(1, "gameover1", block)
	event.SpriteSetColor(1, 128, 128, 128, 128)
	event.SpriteSetUvsize(1, 0, 0, 576, 128)
	event.SpriteSetPutsize(1, 576, 128)
	event.SpriteSetPos(1, -320, 208)
	event.SpriteSetDraw(1, 1)
	event.EohSyncSprite(1, 1)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.ObjsMove(1, 288, 208, 0.0, 20)
	helper_ff0edc1d(30)
	if vm.skipping() then
		return skip(5)
	end
	event.SpriteInit(2)
	event.SpriteSetType(2, 0)
	event.SpriteSetTexture(2, "gameover1", block)
	event.SpriteSetColor(2, 128, 128, 128, 0)
	event.SpriteSetUvsize(2, 0, 128, 576, 64)
	event.SpriteSetPutsize(2, 576, 64)
	event.SpriteSetPos(2, 256, 208)
	event.SpriteSetDraw(2, 1)
	event.EohSyncSprite(2, 2)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.ObjsSetColor(2, 128, 128, 128, 128, 120)
	helper_ff0edc1d(120)
	if vm.skipping() then
		return skip(6)
	end
	while true do
		if helper_79e692b8(0) ~= 0 then
			break
		else
			if vm.wait() then
				return skip(7)
			end
		end
	end
	debug_flag = event.GetDebugFlag() or debug_flag
	debug_flag = 0
	if debug_flag == 1 then
		event.DngDebugCommand(0)
		event.ActchrSetDefMotion(0, 4)
	else
		event.FadeOutBgm(30)
		event.SetFadeOut(30)
		helper_ff0edc1d(30)
		if vm.skipping() then
			return skip(8)
		end
		if active_chr_no == 2 then
			event.EsmClear()
		end
		event.StopBgm(0)
		event.SpriteSetDraw(0, 0)
		event.SpriteSetDraw(1, 0)
		event.DelImg(0)
		if var0 == 1 then
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
	helper_ff0edc1d(4)
	if vm.skipping() then
		return skip(9)
	end
	load_no = event.GetBgmStatusNowNo() or load_no
	event.LoadBgm(load_no)
	event.SetActiveBgmStatus(-1)
	event.SpriteSetDraw(0, 0)
	event.SpriteSetDraw(1, 0)
	event.DelImg(0)
	boss_map = event.DngCheckBossMap() or boss_map
	if boss_map ~= 1 then
		if argc == 1 then
			event.SndSePlay(var2, 0)
			event.SndSetSeVol(var2, 0, battle_bgm_vol)
		end
	end
	event.SetCameraCtrl(1)
	event.SetStatusbarShow(1, 1.0)
	if debug_flag ~= 1 then
		event.SetFadeIn(30)
	end
	event.DngPause(16385, 0)
	event.Finish()
	return 0
end

--- Program 27070.
script[27070] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_1efcc()
	if vm.skipping() then
		return skip(1)
	end
end

return script
