--!strict
-- map/d/d06/b03/d06b03_3.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0958ca60 = require("@lib/event/helper_0958ca60")
local helper_238b5abc = require("@lib/event/helper_238b5abc")
local helper_23cc77c6 = require("@lib/event/helper_23cc77c6")
local helper_25abe6d2 = require("@lib/event/helper_25abe6d2")
local helper_344d6cd8 = require("@lib/event/helper_344d6cd8")
local helper_479dc9e9 = require("@lib/event/helper_479dc9e9")
local helper_52aadc70 = require("@lib/event/helper_52aadc70")
local helper_581cb30c = require("@lib/event/helper_581cb30c")
local helper_80ad60c2 = require("@lib/event/helper_80ad60c2")
local helper_b8685bd9 = require("@lib/event/helper_b8685bd9")
local helper_c28d4a31 = require("@lib/event/helper_c28d4a31")
local helper_c624bc16 = require("@lib/event/helper_c624bc16")
local helper_d3f20302 = require("@lib/event/helper_d3f20302")
local helper_d42be94f = require("@lib/event/helper_d42be94f")
local helper_e445ef54 = require("@lib/event/helper_e445ef54")
local helper_e91b4623 = require("@lib/event/helper_e91b4623")

local global0: s32 = 0
local global1: s32 = 0

--- Helper function.
local function helper_19e04()
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
	event.EohSyncObj_2(6, "p06_d06b03-0")
	event.EohSetShow(6, 0)
	event.CharaActive(1, 17)
	event.CharaActive(1, 18)
	event.LoadMes(0, 5, "event/e700/e732/e732_1.txt")
end

--- Helper function.
local function helper_22300000()
	local var0: s32 = 0
	local _ = var0 == 2
	var0 = 0
	local _ = var0 == 3
	var0 = 1
	global0 = 0
	global1 = 8
	global0 = 8
	global1 = 0
end

--- Helper function.
local function helper_19958()
	local active_chr_no: s32 = 0
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
	vm.wait(1)
end

--- Helper function.
local function helper_1ae20()
	local projection: f32 = 0
	local at: number = 0
	vm.section(function()
		event.SetFlag(732, 1)
		event.Initialize()
		event.SetMesWindowMode(0, 7)
		event.StopBgm(0)
		at = 1
		helper_25abe6d2(4)
		event.LoadBgm(53)
		event.PlayBgm(0)
		event.LoadSound(7841)
		helper_19e04()
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
		at = 2
		helper_25abe6d2(15)
		event.CmrsInitPas()
		event.CmrsSetPasFrm(200)
		event.CmrsAddPas(281.98, 20.1, 298.37, 1436.08, 1324.63, 1446.43)
		event.CmrsAddPas(281.98, 20.1, 298.37, 1436.08, 215.39, 1446.43)
		event.CmrsStartPas()
		at = 3
		helper_c624bc16()
		at = 4
		helper_25abe6d2(30)
		event.CmrsSetPos(520.35, 27.62, 447.72)
		event.CmrsSetRef(443.3, 23.28, 472.44)
		event.SetPakuAnim(1, "通常口パク")
		at = 5
		helper_c28d4a31(7320210, -1)
		event.ResetPakuAnim()
		at = 6
		helper_25abe6d2(30)
		event.SetPakuAnim(1, "通常口パク")
		at = 7
		helper_c28d4a31(7320215, -1)
		event.ResetPakuAnim()
		at = 8
		helper_25abe6d2(30)
		event.SetPakuAnim(1, "通常口パク")
		at = 9
		helper_c28d4a31(7320220, -1)
		event.ResetPakuAnim()
		at = 10
		helper_25abe6d2(30)
		event.CmrsSetPos(422.7, -0.4, 438.35)
		event.CmrsSetRef(1436.08, 1232.78, 1446.43)
		event.SetPakuAnim(0, "通常口パク")
		at = 11
		helper_c28d4a31(7320230, -1)
		event.ResetPakuAnim()
		at = 12
		helper_25abe6d2(30)
		event.SetPakuAnim(0, "通常口パク")
		at = 13
		helper_c28d4a31(7320240, -1)
		event.ResetPakuAnim()
		at = 14
		helper_25abe6d2(30)
		event.ObjsSetMotion(0, "上→右", 6)
		event.ObjsNextMotion(0, "右向くL", 4)
		event.SetPakuAnim(0, "通常口パク")
		at = 15
		helper_c28d4a31(7320250, -1)
		event.ResetPakuAnim()
		at = 16
		helper_0958ca60(0)
		at = 17
		helper_25abe6d2(30)
		event.SetProjection(projection)
		event.CmrsSetPos(520.35, 27.62, 447.72)
		event.CmrsSetRef(443.3, 23.28, 472.44)
		event.SetPakuAnim(0, "通常口パク")
		at = 18
		helper_c28d4a31(7320255, -1)
		event.ResetPakuAnim()
		at = 19
		helper_25abe6d2(15)
		event.ObjsSetMotion(1, "上から左", 6)
		event.ObjsNextMotion(1, "左向くL", 4)
		event.ObjsMotionDelay(1, 60)
		event.ObjsSetMotion(1, "詩人ね", 6)
		event.ObjsNextMotion(1, "詩人ねL", 4)
		event.SetPakuAnim(1, "わらい口パク")
		at = 20
		helper_c28d4a31(7320260, -1)
		event.ResetPakuAnim()
		at = 21
		helper_0958ca60(0)
		at = 22
		helper_0958ca60(1)
		event.ObjsTexAnime(0, 0)
		event.ObjsTexAnime(0, 1, "デフォルト顔")
		event.ObjsTexAnime(0, 1, "前向き～下向き")
		event.ObjsSetMotion(0, "そうかな", 6)
		event.ObjsNextMotion(0, "そうかなL", 4)
		event.SetPakuAnim(0, "わらい口パク")
		at = 23
		helper_c28d4a31(7320270, -1)
		event.ResetPakuAnim()
		at = 24
		helper_0958ca60(0)
		at = 25
		helper_25abe6d2(30)
		event.SetProjection(projection)
		event.ObjsSetMotion(0, "上向くL", 4, -1.0, 1)
		event.ObjsSetMotion(1, "上向くL", 4, -1.0, 1)
		event.CmrsSetPos(281.98, 20.1, 298.37)
		event.CmrsSetRef(1436.08, 215.39, 1446.43)
		at = 26
		helper_c28d4a31(7320280, -1)
		at = 27
		helper_25abe6d2(30)
		at = 28
		helper_c28d4a31(7320285, -1)
		at = 29
		helper_25abe6d2(30)
		at = 30
		helper_c28d4a31(7320290, -1)
		at = 31
		helper_25abe6d2(30)
		at = 32
		helper_c28d4a31(7320295, -1)
		event.CmrsMove2(281.98, 20.1, 298.37, 1436.08, 1963.82, 1446.43, 300, 0, 1.0)
		at = 33
		helper_25abe6d2(30)
		at = 34
		helper_c28d4a31(7320300, -1)
		at = 35
		helper_25abe6d2(30)
		at = 36
		helper_c28d4a31(7320310, -1)
		at = 37
		helper_c624bc16()
		at = 38
		helper_c28d4a31(7320320, -1)
		at = 39
		helper_25abe6d2(30)
		at = 40
		helper_c28d4a31(7320330, -1)
		at = 41
		helper_25abe6d2(30)
		event.ObjsTexAnime(0, 0)
		event.ObjsTexAnime(0, 1, "デフォルト顔")
		event.ObjsTexAnime(0, 1, "通常目パチ")
		event.CmrsSetPos(539.13, 94.76, 524.34)
		event.CmrsSetRef(457.63, 10.5, 460.14)
		event.CmrsMove2(484.6, 41.24, 479.15, 471.35, 30.37, 469.8, 300, 2, 1.0)
		event.SetCrossfade(30)
		at = 42
		helper_c28d4a31(7320340, -1)
		at = 43
		helper_25abe6d2(30)
		at = 44
		helper_c28d4a31(7320350, -1)
		at = 45
		helper_25abe6d2(30)
		at = 46
		helper_c28d4a31(7320360, -1)
		at = 47
		helper_c624bc16()
		at = 48
		helper_25abe6d2(30)
		event.ObjsSetMotion(0, "帽子取る", 6)
		event.ObjsNextMotion(0, "帽子取るL", 4)
		at = 49
		helper_c28d4a31(7320370, -1)
		at = 50
		helper_0958ca60(0)
		event.ObjsSetMotion(0, "ぶるぶる", 6)
		event.ObjsNextMotion(0, "帽子取るL", 4)
		at = 51
		helper_c28d4a31(7320380, -1)
		at = 52
		helper_0958ca60(0)
		event.SetProjection(182.9)
		event.CmrsInitPas()
		event.CmrsSetPasFrm(240)
		event.CmrsAddPas(422.7, 30.65, 438.35, 1436.08, 349.8, 1446.43)
		event.CmrsAddPas(353.73, 30.65, 369.74, 1436.08, 349.8, 1446.43)
		event.CmrsStartPas()
		at = 53
		helper_25abe6d2(180)
		event.FadeOutBgm(60)
		event.SetFadeOut(60)
		at = 54
		helper_25abe6d2(60)
		event.StopBgm(0)
	end, function(received: { any }): boolean
		if at <= 1 then
			helper_22300000()
			helper_d3f20302(15)
		end
		if at <= 2 then
			helper_344d6cd8()
		end
		if at <= 3 then
			helper_d3f20302(30)
		end
		if at <= 4 then
			helper_52aadc70(7320210, -1)
		end
		if at <= 5 then
			helper_d3f20302(30)
		end
		if at <= 6 then
			helper_52aadc70(7320215, -1)
		end
		if at <= 7 then
			helper_d3f20302(30)
		end
		if at <= 8 then
			helper_52aadc70(7320220, -1)
		end
		if at <= 9 then
			helper_d3f20302(30)
		end
		if at <= 10 then
			helper_52aadc70(7320230, -1)
		end
		if at <= 11 then
			helper_d3f20302(30)
		end
		if at <= 12 then
			helper_52aadc70(7320240, -1)
		end
		if at <= 13 then
			helper_d3f20302(30)
		end
		if at <= 14 then
			helper_52aadc70(7320250, -1)
		end
		if at <= 15 then
			helper_238b5abc(0)
		end
		if at <= 16 then
			helper_d3f20302(30)
		end
		if at <= 17 then
			helper_52aadc70(7320255, -1)
		end
		if at <= 18 then
			helper_d3f20302(15)
		end
		if at <= 19 then
			helper_52aadc70(7320260, -1)
		end
		if at <= 20 then
			helper_238b5abc(0)
		end
		if at <= 21 then
			helper_238b5abc(1)
		end
		if at <= 22 then
			helper_52aadc70(7320270, -1)
		end
		if at <= 23 then
			helper_238b5abc(0)
		end
		if at <= 24 then
			helper_d3f20302(30)
		end
		if at <= 25 then
			helper_52aadc70(7320280, -1)
		end
		if at <= 26 then
			helper_d3f20302(30)
		end
		if at <= 27 then
			helper_52aadc70(7320285, -1)
		end
		if at <= 28 then
			helper_d3f20302(30)
		end
		if at <= 29 then
			helper_52aadc70(7320290, -1)
		end
		if at <= 30 then
			helper_d3f20302(30)
		end
		if at <= 31 then
			helper_52aadc70(7320295, -1)
		end
		if at <= 32 then
			helper_d3f20302(30)
		end
		if at <= 33 then
			helper_52aadc70(7320300, -1)
		end
		if at <= 34 then
			helper_d3f20302(30)
		end
		if at <= 35 then
			helper_52aadc70(7320310, -1)
		end
		if at <= 36 then
			helper_344d6cd8()
		end
		if at <= 37 then
			helper_52aadc70(7320320, -1)
		end
		if at <= 38 then
			helper_d3f20302(30)
		end
		if at <= 39 then
			helper_52aadc70(7320330, -1)
		end
		if at <= 40 then
			helper_d3f20302(30)
		end
		if at <= 41 then
			helper_52aadc70(7320340, -1)
		end
		if at <= 42 then
			helper_d3f20302(30)
		end
		if at <= 43 then
			helper_52aadc70(7320350, -1)
		end
		if at <= 44 then
			helper_d3f20302(30)
		end
		if at <= 45 then
			helper_52aadc70(7320360, -1)
		end
		if at <= 46 then
			helper_344d6cd8()
		end
		if at <= 47 then
			helper_d3f20302(30)
		end
		if at <= 48 then
			helper_52aadc70(7320370, -1)
		end
		if at <= 49 then
			helper_238b5abc(0)
		end
		if at <= 50 then
			helper_52aadc70(7320380, -1)
		end
		if at <= 51 then
			helper_238b5abc(0)
		end
		if at <= 52 then
			helper_d3f20302(180)
		end
		if at <= 53 then
			helper_d3f20302(60)
		end
		return true
	end)
	event.CancelDramaScene()
	event.SetProjection(projection)
	at = 55
	helper_19958()
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Event 99, which map data, a script or the engine runs by number.
-- Defined empty, so the engine runs this instead of its default.
function script.event_99() end

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	local flag: s32 = 0
	local active_chr_no: s32 = 0
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
		helper_d42be94f()
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
	vm.wait(2)
	event.SetFadeIn(30)
	event.Finish()
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
-- Defined empty, so the engine runs this instead of its default.
function script.key_open() end

--- Event 151, which map data, a script or the engine runs by number.
script.event_151 = helper_23cc77c6

--- Event 500, which map data, a script or the engine runs by number.
function script.event_500()
	local active_chr_no: s32 = 0
	local active_chr_no_2: s32 = 0
	print(">>>>>>>>>>>>>>>>>RUN 500\n")
	event.Initialize()
	event.ActchrSetDefMotion(0)
	event.SetFadeOut(20)
	helper_25abe6d2(20)
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

--- Event 510, which map data, a script or the engine runs by number.
function script.event_510()
	helper_1ae20()
	event.SetSavedataEtc(0, 10)
	vm.wait(2)
	event.MapJump_3(-1, "s66", 520)
end

--- Event 550, which map data, a script or the engine runs by number.
function script.event_550()
	event.SetStatusbarShow(0, 1.0)
	event.SetCharaShow(1, 0)
	event.SetCharaShow(2, 0)
	helper_e91b4623()
	event.BgmLoadCancel()
	vm.wait(2)
	event.LoadDungeonMapFile("d06b02")
	event.LoadScript("d06b02/d06b02.stb", 100)
end

--- Event 1200, which map data, a script or the engine runs by number.
function script.event_1200()
	local flag: s32 = 0
	local flag_2: s32 = 0
	local var2: s32 = 0
	local at: number = 0
	return vm.guard(function()
		flag = event.GetFlag(728) or flag
		flag_2 = event.GetFlag(732) or flag_2
		if flag ~= 0 and flag_2 == 0 then
			var2 = vm.float_bits(event.GetRand(100)) or var2
			if var2 < 50 then
				at = 1
				helper_e445ef54(0, 8570060)
			else
				at = 2
				helper_e445ef54(0, 8570070)
			end
			return
		end
		at = 3
		helper_b8685bd9(0)
		return
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				helper_80ad60c2(0, 8570070)
			end
			return 0
		end
		if at <= 3 then
			return 0
		end
		return nil
	end)
end

--- Event 1201, which map data, a script or the engine runs by number.
function script.event_1201()
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
	event.Initialize()
	event.DngPause(15, 1)
	var0 = 0
	event.Initialize()
	var1 = event.SndLoadSound_3(8, "snd2/sp/sp_052.sound.json") or var1
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
	helper_25abe6d2(90)
	event.GetActiveBgmStatus(-1)
	var2 = event.GetEventInfoSndid(4) or var2
	argc = event.GetSeStatus(var2, 0) or argc
	battle_bgm_vol = event.GetBtlBgmVol() or battle_bgm_vol
	event.SndSeStop(var2, 0)
	event.StopBgm(0)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.SetLoadbgFile_2("snd2/bgm/bg_060.sound.json", "textures/dungeon/image/gameover.json")
	helper_25abe6d2(30)
	helper_479dc9e9()
	event.LoadBgmPack(60)
	event.PlayBgm(0)
	helper_25abe6d2(30)
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
	helper_25abe6d2(30)
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
	helper_25abe6d2(120)
	while true do
		if helper_581cb30c(0) ~= 0 then
			break
		else
			vm.wait(7)
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
		helper_25abe6d2(30)
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
	helper_25abe6d2(4)
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

--- Event 27070, which map data, a script or the engine runs by number.
script.event_27070 = helper_23cc77c6

return script
