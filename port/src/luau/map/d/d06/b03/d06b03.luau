--!strict
-- map/d/d06/b03/d06b03.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_038a2e4d = require("@lib/event/helper_038a2e4d")
local helper_04a03fbb = require("@lib/event/helper_04a03fbb")
local helper_0958ca60 = require("@lib/event/helper_0958ca60")
local helper_238b5abc = require("@lib/event/helper_238b5abc")
local helper_26c3d54b = require("@lib/event/helper_26c3d54b")
local helper_29101c9c = require("@lib/event/helper_29101c9c")
local helper_344d6cd8 = require("@lib/event/helper_344d6cd8")
local helper_479dc9e9 = require("@lib/event/helper_479dc9e9")
local helper_53ffe901 = require("@lib/event/helper_53ffe901")
local helper_54207bc4 = require("@lib/event/helper_54207bc4")
local helper_581cb30c = require("@lib/event/helper_581cb30c")
local helper_6992f518 = require("@lib/event/helper_6992f518")
local helper_7b829e53 = require("@lib/event/helper_7b829e53")
local helper_82705ce2 = require("@lib/event/helper_82705ce2")
local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")
local helper_9cbdc640 = require("@lib/event/helper_9cbdc640")
local helper_a0450e0f = require("@lib/event/helper_a0450e0f")
local helper_c624bc16 = require("@lib/event/helper_c624bc16")
local helper_c930491d = require("@lib/event/helper_c930491d")
local helper_dbff9fb6 = require("@lib/event/helper_dbff9fb6")

local global0: s32 = 0
local global1: s32 = 0

--- Helper function.
local function helper_177d8()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local block: s32 = 0
	vm.section(function()
		event.SetFlag(728, 1)
		event.Initialize()
		event.SetMesWindowMode(0, 7)
		event.LoadSound(7603)
		var0 = event.SndLoadSound_2(7603) or var0
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
		helper_888ab2a3(60)
		event.FadeOutBgm(30)
		helper_888ab2a3(30)
		event.CmrsSetPos(12.3, 90.7, -58.0)
		event.CmrsSetRef(8.16, 163.3, 185.9)
		event.ObjsSetColor(3, 128, 128, 128, 128, 30)
		event.SndSePlay(var0, 0)
		event.ObjsSetMotion(2, "乱舞", 6)
		event.ObjsNextMotion(2, "乱舞L", 4)
		helper_0958ca60(2)
		helper_888ab2a3(30)
		event.ObjsSetColor(3, 128, 128, 128, 0, 30)
		event.SetFadeOut(30)
		helper_888ab2a3(30)
	end)
	event.CancelDramaScene()
	event.StopBgm(0)
	helper_888ab2a3(4)
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

--- Helper function.
local function helper_1efcc()
	local time: f32 = 0
	event.Initialize()
	vm.wait(1)
	event.StopBgm(0)
	helper_888ab2a3(4)
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
	vm.wait(3)
	event.SetFadeIn(30)
	event.Finish()
end

--- Helper function.
local function helper_197dc()
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
	event.LoadMes(0, 5, "event/e700/e732/e732.txt")
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
local function helper_19330()
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
local function helper_1a7e8()
	local projection: f32 = 0
	local at: number = 0
	vm.section(function()
		event.SetFlag(732, 1)
		event.Initialize()
		event.SetMesWindowMode(0, 7)
		event.StopBgm(0)
		at = 1
		helper_888ab2a3(4)
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
		at = 2
		helper_888ab2a3(15)
		event.CmrsInitPas()
		event.CmrsSetPasFrm(200)
		event.CmrsAddPas(281.98, 20.1, 298.37, 1436.08, 1324.63, 1446.43)
		event.CmrsAddPas(281.98, 20.1, 298.37, 1436.08, 215.39, 1446.43)
		event.CmrsStartPas()
		at = 3
		helper_c624bc16()
		at = 4
		helper_888ab2a3(30)
		event.CmrsSetPos(520.35, 27.62, 447.72)
		event.CmrsSetRef(443.3, 23.28, 472.44)
		event.SetPakuAnim(1, "通常口パク")
		at = 5
		helper_29101c9c(7320210, -1)
		event.ResetPakuAnim()
		at = 6
		helper_888ab2a3(30)
		event.SetPakuAnim(1, "通常口パク")
		at = 7
		helper_29101c9c(7320215, -1)
		event.ResetPakuAnim()
		at = 8
		helper_888ab2a3(30)
		event.SetPakuAnim(1, "通常口パク")
		at = 9
		helper_29101c9c(7320220, -1)
		event.ResetPakuAnim()
		at = 10
		helper_888ab2a3(30)
		event.CmrsSetPos(422.7, -0.4, 438.35)
		event.CmrsSetRef(1436.08, 1232.78, 1446.43)
		event.SetPakuAnim(0, "通常口パク")
		at = 11
		helper_29101c9c(7320230, -1)
		event.ResetPakuAnim()
		at = 12
		helper_888ab2a3(30)
		event.SetPakuAnim(0, "通常口パク")
		at = 13
		helper_29101c9c(7320240, -1)
		event.ResetPakuAnim()
		at = 14
		helper_888ab2a3(30)
		event.ObjsSetMotion(0, "上→右", 6)
		event.ObjsNextMotion(0, "右向くL", 4)
		event.SetPakuAnim(0, "通常口パク")
		at = 15
		helper_29101c9c(7320250, -1)
		event.ResetPakuAnim()
		at = 16
		helper_0958ca60(0)
		at = 17
		helper_888ab2a3(30)
		event.SetProjection(projection)
		event.CmrsSetPos(520.35, 27.62, 447.72)
		event.CmrsSetRef(443.3, 23.28, 472.44)
		event.SetPakuAnim(0, "通常口パク")
		at = 18
		helper_29101c9c(7320255, -1)
		event.ResetPakuAnim()
		at = 19
		helper_888ab2a3(15)
		event.ObjsSetMotion(1, "上から左", 6)
		event.ObjsNextMotion(1, "左向くL", 4)
		event.ObjsMotionDelay(1, 60)
		event.ObjsSetMotion(1, "詩人ね", 6)
		event.ObjsNextMotion(1, "詩人ねL", 4)
		event.SetPakuAnim(1, "わらい口パク")
		at = 20
		helper_29101c9c(7320260, -1)
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
		helper_29101c9c(7320270, -1)
		event.ResetPakuAnim()
		at = 24
		helper_0958ca60(0)
		at = 25
		helper_888ab2a3(30)
		event.SetProjection(projection)
		event.ObjsSetMotion(0, "上向くL", 4, -1.0, 1)
		event.ObjsSetMotion(1, "上向くL", 4, -1.0, 1)
		event.CmrsSetPos(281.98, 20.1, 298.37)
		event.CmrsSetRef(1436.08, 215.39, 1446.43)
		at = 26
		helper_29101c9c(7320280, -1)
		at = 27
		helper_888ab2a3(30)
		at = 28
		helper_29101c9c(7320285, -1)
		at = 29
		helper_888ab2a3(30)
		at = 30
		helper_29101c9c(7320290, -1)
		at = 31
		helper_888ab2a3(30)
		at = 32
		helper_29101c9c(7320295, -1)
		event.CmrsMove2(281.98, 20.1, 298.37, 1436.08, 1963.82, 1446.43, 300, 0, 1.0)
		at = 33
		helper_888ab2a3(30)
		at = 34
		helper_29101c9c(7320300, -1)
		at = 35
		helper_888ab2a3(30)
		at = 36
		helper_29101c9c(7320310, -1)
		at = 37
		helper_c624bc16()
		at = 38
		helper_29101c9c(7320320, -1)
		at = 39
		helper_888ab2a3(30)
		at = 40
		helper_29101c9c(7320330, -1)
		at = 41
		helper_888ab2a3(30)
		event.ObjsTexAnime(0, 0)
		event.ObjsTexAnime(0, 1, "デフォルト顔")
		event.ObjsTexAnime(0, 1, "通常目パチ")
		event.CmrsSetPos(539.13, 94.76, 524.34)
		event.CmrsSetRef(457.63, 10.5, 460.14)
		event.CmrsMove2(484.6, 41.24, 479.15, 471.35, 30.37, 469.8, 300, 2, 1.0)
		event.SetCrossfade(30)
		at = 42
		helper_29101c9c(7320340, -1)
		at = 43
		helper_888ab2a3(30)
		at = 44
		helper_29101c9c(7320350, -1)
		at = 45
		helper_888ab2a3(30)
		at = 46
		helper_29101c9c(7320360, -1)
		at = 47
		helper_c624bc16()
		at = 48
		helper_888ab2a3(30)
		event.ObjsSetMotion(0, "帽子取る", 6)
		event.ObjsNextMotion(0, "帽子取るL", 4)
		at = 49
		helper_29101c9c(7320370, -1)
		at = 50
		helper_0958ca60(0)
		event.ObjsSetMotion(0, "ぶるぶる", 6)
		event.ObjsNextMotion(0, "帽子取るL", 4)
		at = 51
		helper_29101c9c(7320380, -1)
		at = 52
		helper_0958ca60(0)
		event.SetProjection(182.9)
		event.CmrsInitPas()
		event.CmrsSetPasFrm(240)
		event.CmrsAddPas(422.7, 30.65, 438.35, 1436.08, 349.8, 1446.43)
		event.CmrsAddPas(353.73, 30.65, 369.74, 1436.08, 349.8, 1446.43)
		event.CmrsStartPas()
		at = 53
		helper_888ab2a3(180)
		event.FadeOutBgm(60)
		event.SetFadeOut(60)
		at = 54
		helper_888ab2a3(60)
		event.StopBgm(0)
	end, function(received: { any }): boolean
		if at <= 1 then
			helper_22300000()
			helper_038a2e4d(15)
		end
		if at <= 2 then
			helper_344d6cd8()
		end
		if at <= 3 then
			helper_038a2e4d(30)
		end
		if at <= 4 then
			helper_53ffe901(7320210, -1)
		end
		if at <= 5 then
			helper_038a2e4d(30)
		end
		if at <= 6 then
			helper_53ffe901(7320215, -1)
		end
		if at <= 7 then
			helper_038a2e4d(30)
		end
		if at <= 8 then
			helper_53ffe901(7320220, -1)
		end
		if at <= 9 then
			helper_038a2e4d(30)
		end
		if at <= 10 then
			helper_53ffe901(7320230, -1)
		end
		if at <= 11 then
			helper_038a2e4d(30)
		end
		if at <= 12 then
			helper_53ffe901(7320240, -1)
		end
		if at <= 13 then
			helper_038a2e4d(30)
		end
		if at <= 14 then
			helper_53ffe901(7320250, -1)
		end
		if at <= 15 then
			helper_238b5abc(0)
		end
		if at <= 16 then
			helper_038a2e4d(30)
		end
		if at <= 17 then
			helper_53ffe901(7320255, -1)
		end
		if at <= 18 then
			helper_038a2e4d(15)
		end
		if at <= 19 then
			helper_53ffe901(7320260, -1)
		end
		if at <= 20 then
			helper_238b5abc(0)
		end
		if at <= 21 then
			helper_238b5abc(1)
		end
		if at <= 22 then
			helper_53ffe901(7320270, -1)
		end
		if at <= 23 then
			helper_238b5abc(0)
		end
		if at <= 24 then
			helper_038a2e4d(30)
		end
		if at <= 25 then
			helper_53ffe901(7320280, -1)
		end
		if at <= 26 then
			helper_038a2e4d(30)
		end
		if at <= 27 then
			helper_53ffe901(7320285, -1)
		end
		if at <= 28 then
			helper_038a2e4d(30)
		end
		if at <= 29 then
			helper_53ffe901(7320290, -1)
		end
		if at <= 30 then
			helper_038a2e4d(30)
		end
		if at <= 31 then
			helper_53ffe901(7320295, -1)
		end
		if at <= 32 then
			helper_038a2e4d(30)
		end
		if at <= 33 then
			helper_53ffe901(7320300, -1)
		end
		if at <= 34 then
			helper_038a2e4d(30)
		end
		if at <= 35 then
			helper_53ffe901(7320310, -1)
		end
		if at <= 36 then
			helper_344d6cd8()
		end
		if at <= 37 then
			helper_53ffe901(7320320, -1)
		end
		if at <= 38 then
			helper_038a2e4d(30)
		end
		if at <= 39 then
			helper_53ffe901(7320330, -1)
		end
		if at <= 40 then
			helper_038a2e4d(30)
		end
		if at <= 41 then
			helper_53ffe901(7320340, -1)
		end
		if at <= 42 then
			helper_038a2e4d(30)
		end
		if at <= 43 then
			helper_53ffe901(7320350, -1)
		end
		if at <= 44 then
			helper_038a2e4d(30)
		end
		if at <= 45 then
			helper_53ffe901(7320360, -1)
		end
		if at <= 46 then
			helper_344d6cd8()
		end
		if at <= 47 then
			helper_038a2e4d(30)
		end
		if at <= 48 then
			helper_53ffe901(7320370, -1)
		end
		if at <= 49 then
			helper_238b5abc(0)
		end
		if at <= 50 then
			helper_53ffe901(7320380, -1)
		end
		if at <= 51 then
			helper_238b5abc(0)
		end
		if at <= 52 then
			helper_038a2e4d(180)
		end
		if at <= 53 then
			helper_038a2e4d(60)
		end
		return true
	end)
	event.CancelDramaScene()
	event.SetProjection(projection)
	at = 55
	helper_19330()
end

--- Helper function.
local function helper_102dc()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local var2: s32 = 0
	vm.section(function()
		event.SetFlag(728, 1)
		event.Initialize()
		event.SetMesWindowMode(0, 7)
		event.LoadSound(7835)
		var0 = event.SndLoadSound_2(7835) or var0
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
		event.LoadChara(5, "e728_DEhikari.gltf", "info", 14)
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
		event.EohSyncObj_2(6, "p06_d06b03-0")
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
		helper_888ab2a3(30)
		event.CmrsMove2(6.95, 33.33, -38.64, -16.79, 86.78, 30.71, 120, 2, 1.0)
		helper_29101c9c(7280160, 540)
		event.SetProjection(524.9)
		event.CmrsSetPos(-17.25, 2.73, -179.23)
		event.CmrsSetRef(-11.0, 60.16, -36.27)
		event.SndSePlay(var0, 0)
		event.ObjsSetMotion(2, "手を上げる", 6)
		event.ObjsNextMotion(2, "手を上げるL", 4)
		helper_0958ca60(2)
		event.ObjsMotionDelay(2, 180)
		event.ObjsSetMotion(2, "死に絶えるのだ", 6)
		event.ObjsNextMotion(2, "死に絶えるのだL", 4)
		event.ObjsSeDelay(2, 180)
		event.ObjsSePlay(2, var0, 1)
		event.StreamOpen3(1, 7280163)
		helper_9cbdc640(1)
		event.MesMake_2(0, 7280163)
		helper_82705ce2(0, -1, 8, 0, 0)
		event.StreamPlay(1)
		helper_888ab2a3(180)
		event.SetCrossfade(30)
		event.CmrsSetPos(1.58, 101.91, -60.95)
		event.CmrsSetRef(-17.89, 92.73, 25.56)
		helper_a0450e0f(0, -1)
		helper_6992f518(0)
		event.StreamClose(1)
		helper_0958ca60(2)
		event.CmrsSetPos(-37.44, 9.97, -30.69)
		event.CmrsSetRef(1007.77, 434.9, -2136.35)
		event.CmrsQuake2(0.0, 3.3, 0.0, 60)
		event.SndSePlay(var0, 2)
		event.EohSetShow(6, 1)
		helper_888ab2a3(60)
		event.ObjsSetMotion(0, "上向く", 6)
		event.ObjsNextMotion(0, "上向くL", 4)
		event.ObjsSetMotion(1, "上向く", 6)
		event.ObjsNextMotion(1, "上向くL", 4)
		helper_888ab2a3(30)
		event.ObjsTexAnime(0, 0)
		event.ObjsTexAnime(0, 1, "おこり顔")
		event.ObjsTexAnime(0, 1, "おこり目～おどろき目")
		event.ObjsTexAnime(1, 0)
		event.ObjsTexAnime(1, 1, "おこり顔")
		event.ObjsTexAnime(1, 1, "おこり目～おどろき目")
		event.ObjsTexAnime(1, 1, "口とじ～大口")
		event.ObjsTexAnime(0, 1, "口とじ～大口")
		helper_29101c9c(7280165, 90)
		event.CmrsSetPos(-5.51, 54.41, -260.22)
		event.CmrsSetRef(-13.59, 43.11, -47.5)
		event.ObjsSetMotion(2, "立ち", 4)
		event.ObjsSetScale(6, 1.0, 1.0, 1.0, 180)
		event.ObjsSetMotion(2, "振り返る", 6)
		event.ObjsNextMotion(2, "上見立ち", 4)
		helper_888ab2a3(60)
		event.CmrsMove2(-5.51, 375.83, -260.22, -4.47, 459.86, -47.34, 120, 0, 1.0)
		helper_c624bc16()
		event.CmrsSetPos(-44.01, 88.99, -11.02)
		event.CmrsSetRef(-13.6, 22.3, -75.12)
		event.ObjsTexAnime(0, 0)
		event.ObjsTexAnime(0, 1, "おこり顔")
		event.ObjsTexAnime(0, 1, "おこり目パチ")
		event.ObjsTexAnime(1, 0)
		event.ObjsTexAnime(1, 1, "おこり顔")
		event.ObjsTexAnime(1, 1, "おこり目パチ")
		event.SetPakuAnim(1, "通常口パク")
		helper_29101c9c(7280170, 150)
		event.SetPakuAnim(0, "通常口パク")
		helper_29101c9c(7280180, 120)
		event.CmrsMove2(-88.64, 165.69, 144.36, -18.85, 102.29, 59.43, 120, 0, 0.5)
		event.SndSeStop(var0, 2)
		event.SndSePlay(var0, 3)
		helper_888ab2a3(30)
		helper_29101c9c(7280190, 500)
		helper_c624bc16()
		event.CmrsSetPos(-14.82, 6.49, -265.28)
		event.CmrsSetRef(-12.4, 63.83, -45.92)
		event.ObjsSetPos(2, -10.86, 37.42, 79.41)
		event.ObjsResetDaPosition(2)
		helper_888ab2a3(30)
		event.ObjsSetMotion(2, "振り返る2", 6)
		event.ObjsNextMotion(2, "立ち", 4)
		helper_29101c9c(7280200, 210)
		helper_0958ca60(2)
		event.SndSePlay(var0, 4)
		event.ObjsSetMotion(2, "闇世界の王", 6)
		event.ObjsNextMotion(2, "闇世界の王L", 4)
		event.ObjsSeDelay(2, 30)
		event.ObjsSePlay(2, var0, 5)
		helper_29101c9c(7280210, 480)
		helper_0958ca60(2)
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
		helper_29101c9c(7280220, 210)
		event.SndSePlay(var0, 6)
		event.CharaActive(12)
		event.ObjsSetPos(4, -16.64, 87.63, 60.46)
		event.ObjsSetRot(4, 0.0, -3.07, 0.0)
		event.ObjsSetMotion(4, "魔法あたる", 6)
		event.ObjsSetMotion(2, "魔法あたる", 6)
		event.ObjsNextMotion(2, "立ち")
		helper_0958ca60(2)
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
		helper_0958ca60(1)
		helper_888ab2a3(60)
		event.CmrsSetPos(-0.53, 9.74, -325.24)
		event.CmrsSetRef(-10.06, 15.31, -377.35)
		event.ObjsTexAnime(3, 0)
		event.SndSePlay(var0, 8)
		event.ObjsTexAnime(3, 1, "つかれ目パチ")
		helper_888ab2a3(60)
		event.SndSeStop(var0, 8)
		event.CmrsSetPos(8.44, 122.24, -79.64)
		event.CmrsSetRef(17.47, 121.82, 84.02)
		event.CharaActive(0, 13)
		event.CmrsMove(-31.27, 122.24, -88.16, -24.72, 121.82, 75.61, 420)
		helper_29101c9c(7280230, 420)
		helper_c624bc16()
		event.CmrsSetPos(-143.28, 120.11, -54.02)
		event.CmrsSetRef(-4.2, 126.33, 56.81)
		event.SndSePlay(var0, 9)
		event.ObjsSetMotion(2, "杖投げる", 6)
		helper_888ab2a3(60)
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
		helper_888ab2a3(45)
		event.EohSetShow(8, 1)
		event.ObjsSetMotion(8, "刺さる", 6)
		helper_888ab2a3(5)
		helper_29101c9c(7280235, 90)
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
		helper_888ab2a3(90)
		event.CmrsSetPos(-139.53, 12.92, -295.36)
		event.CmrsSetRef(-5.92, 14.31, -385.02)
		event.ObjsSetScale(2, 1.0, 1.0, 1.0)
		event.ObjsSetPos(2, 4.32, 1.63, -115.01)
		event.ObjsResetDaPosition(2)
		event.ObjsMove(2, 4.32, 25.63, -115.01, 120)
		event.ObjsMove(3, -9.83, 25.0, -376.53, 120)
		helper_0958ca60(3)
		helper_888ab2a3(30)
		event.CmrsSetPos(-10.74, 103.97, -46.08)
		event.CmrsSetRef(-10.95, 122.33, 62.77)
		event.SetModelLightSwitch(10, 1)
		event.ObjsSetScale(2, 2.0, 2.0, 2.0)
		event.ObjsSetPos(2, -10.86, 37.42, 79.41)
		event.ObjsResetDaPosition(2)
		event.SndSePlay(var0, 11)
		event.ObjsSetMotion(2, "カモーン", 6)
		event.ObjsNextMotion(2, "カモーンL", 4)
		helper_888ab2a3(90)
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
		helper_888ab2a3(60)
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
		helper_888ab2a3(100)
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
		helper_888ab2a3(30)
		event.ObjsTexAnime(3, 0)
		event.ObjsTexAnime(3, 1, "目とじ２～くるし目")
		event.ObjsSetMotion(0, "しゃがむ", 6)
		event.ObjsNextMotion(0, "しゃがむL", 4)
		event.ObjsMotionDelay(1, 15)
		event.ObjsSetMotion(1, "しゃがみ", 6)
		event.ObjsNextMotion(1, "しゃがみL", 4)
		event.ObjsSetMotion(3, "ユリス見る", 6)
		event.ObjsNextMotion(3, "ユリス見るL", 4)
		helper_888ab2a3(60)
		helper_29101c9c(7280240, 90)
		helper_29101c9c(7280245, 300)
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
		helper_888ab2a3(90)
		event.ObjsTexAnime(1, 0)
		event.ObjsTexAnime(1, 1, "おこり顔")
		event.ObjsTexAnime(1, 1, "おこり目パチ")
		event.LoadBgm(37)
		event.PlayBgm(0)
		helper_888ab2a3(30)
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
		helper_888ab2a3(30)
		helper_888ab2a3(90)
		event.CmrsSetPos(21.35, 75.0, -74.7)
		event.CmrsSetRef(-18.07, 133.59, 68.07)
		event.ObjsSetPos(0, -17.05, 0.0, -260.83)
		event.ObjsSetRot(0, 0.0, 0.3, 0.0)
		event.ObjsResetDaPosition(0)
		event.ObjsSetPos(1, 20.43, 0.0, -290.0)
		event.ObjsSetRot(1, 0.0, 0.12, 0.0)
		event.ObjsResetDaPosition(1)
		event.CmrsMove2(71.01, 5.64, -395.51, -82.14, 81.58, 45.26, 120, 2, 1.0)
		helper_c624bc16()
		helper_888ab2a3(30)
		event.CmrsSetPos(-14.25, 113.8, -124.29)
		event.CmrsSetRef(-12.74, 114.05, 57.05)
		event.ObjsSetMotion(2, "杖構える", 6)
		event.ObjsNextMotion(2, "杖構えるL", 4)
		event.ObjsSeDelay(2, 30)
		event.ObjsSePlay(2, var0, 14)
		helper_888ab2a3(30)
		event.SetMotionBlur(100)
		event.CmrsQuake2(0.0, 8.5, 5.5, 150)
		helper_888ab2a3(90)
		event.SetFadeOut(20, 255, 255, 255)
		helper_888ab2a3(31)
	end)
	event.CancelDramaScene()
	event.SetMotionBlur(0)
	event.SndSeStop(var0, 2)
	event.SndSeStop(var0, 3)
	event.SndSeStop(var0, 8)
	var2 = event.GetBgmNo() or var2
	if var2 ~= 37 then
		event.StopBgm(0)
		helper_888ab2a3(4)
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
	local at: number = 0
	return vm.guard(function()
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
		event.SetLoadbgFile_2("snd2/bgm/bg_060.sound.json", "textures/dungeon/image/gameover.json")
		at = 1
		helper_888ab2a3(30)
		event.SetStatusbarShow(0, 0.06666667)
		at = 2
		helper_479dc9e9()
		event.LoadBgmPack(60)
		if var8 == 1 or var8 ~= 1 and arg1 < 0 then
			event.PlayBgm(0)
		end
		at = 3
		helper_888ab2a3(30)
		event.DngPause(1, 1)
		event.DngCollisionAllClr()
		if var8 ~= 1 then
			block = event.LoadImg_4(5, "textures/dungeon/image/gameover.json", 1) or block
			if arg1 >= 0 then
				at = 4
				helper_04a03fbb(arg1, -1)
				at = 5
				helper_888ab2a3(10)
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
			at = 6
			helper_888ab2a3(30)
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
			at = 7
			helper_888ab2a3(120)
			while true do
				if helper_581cb30c(0) ~= 0 then
					break
				end
				at = 8
				vm.wait(8)
			end
		elseif active_chr_no == 3 then
			var10 = event.CheckEnableCharaChange(1) or var10
			if var10 == 0 then
				at = 9
				helper_7b829e53(1)
			else
				at = 10
				helper_7b829e53(4)
			end
		elseif active_chr_no == 0 or active_chr_no == 2 then
			at = 11
			helper_7b829e53(active_chr_no)
		else
			at = 12
			helper_7b829e53(1)
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
			at = 13
			helper_888ab2a3(30)
			if active_chr_no == 2 then
				event.EsmClear()
			end
			event.MenuCharaChenge(-1)
			at = 14
			vm.wait(14)
			event.SetFadeOut(0)
		else
			event.FadeOutBgm(30)
			event.SetFadeOut(30)
			at = 15
			helper_888ab2a3(30)
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
		at = 16
		helper_888ab2a3(4)
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
	end, function(received: { any })
		if at <= 15 then
			if at <= 1 then
				helper_344d6cd8()
			end
			if at <= 2 then
				helper_038a2e4d(30)
			end
			if at <= 3 then
				helper_26c3d54b(arg1, -1)
			end
			if at <= 4 then
				helper_038a2e4d(10)
			end
			if at <= 5 then
				helper_038a2e4d(30)
			end
			if at <= 6 then
				helper_038a2e4d(120)
			end
			if at <= 8 then
				helper_54207bc4(1)
			end
			if at <= 9 then
				local _ = helper_dbff9fb6(0)
				helper_54207bc4(4)
			end
			if at <= 10 then
				helper_54207bc4(active_chr_no)
			end
			if at <= 11 then
				helper_54207bc4(1)
			end
			if at <= 12 then
				helper_038a2e4d(30)
			end
			if at <= 14 then
				helper_038a2e4d(30)
			end
			return 1
		end
		if at <= 16 then
			print("---------------------------------------------DEAD RELOAD_BGM = ", load_no, "\n")
			print("---------------------------------------------BOSS BATTLE = ", boss_map, "\n")
			print("---------------------------------------------PAUSE BATTLE BGM = ", var2, "\n")
			print("---------------------------------------------BATTLE BGM PLAY\n")
			return 0
		end
		return nil
	end)
end

--- Helper function.
local function helper_10250(arg0: s32, arg1: s32)
	return helper_deec(arg0, arg1)
end

--- Helper function.
local function helper_101b8(arg0: s32)
	return helper_deec(arg0, -1)
end

--- Helper function.
local function helper_22800000(arg0: s32, arg1: s32)
	return helper_c930491d(arg0, arg1)
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
		helper_177d8()
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
script.event_151 = helper_1efcc

--- Event 500, which map data, a script or the engine runs by number.
function script.event_500()
	local active_chr_no: s32 = 0
	local active_chr_no_2: s32 = 0
	print(">>>>>>>>>>>>>>>>>RUN 500\n")
	event.Initialize()
	event.ActchrSetDefMotion(0)
	event.SetFadeOut(20)
	helper_888ab2a3(20)
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
	helper_1a7e8()
	event.SetSavedataEtc(0, 10)
	vm.wait(2)
	event.MapJump_3(-1, "s66", 520)
end

--- Event 550, which map data, a script or the engine runs by number.
function script.event_550()
	event.SetStatusbarShow(0, 1.0)
	event.SetCharaShow(1, 0)
	event.SetCharaShow(2, 0)
	helper_102dc()
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
				helper_10250(0, 8570060)
			else
				at = 2
				helper_10250(0, 8570070)
			end
			return
		end
		at = 3
		helper_101b8(0)
		return
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				helper_22800000(0, 8570070)
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
	helper_888ab2a3(90)
	event.GetActiveBgmStatus(-1)
	var2 = event.GetEventInfoSndid(4) or var2
	argc = event.GetSeStatus(var2, 0) or argc
	battle_bgm_vol = event.GetBtlBgmVol() or battle_bgm_vol
	event.SndSeStop(var2, 0)
	event.StopBgm(0)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.SetLoadbgFile_2("snd2/bgm/bg_060.sound.json", "textures/dungeon/image/gameover.json")
	helper_888ab2a3(30)
	helper_479dc9e9()
	event.LoadBgmPack(60)
	event.PlayBgm(0)
	helper_888ab2a3(30)
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
	helper_888ab2a3(30)
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
	helper_888ab2a3(120)
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
		helper_888ab2a3(30)
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
	helper_888ab2a3(4)
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
script.event_27070 = helper_1efcc

return script
