--!strict
-- map/s/s08/s08.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_125385ee = require("@lib/event/helper_125385ee")
local helper_19b130fb = require("@lib/event/helper_19b130fb")
local helper_5be5f988 = require("@lib/event/helper_5be5f988")
local helper_669c752b = require("@lib/event/helper_669c752b")
local helper_7f754b8f = require("@lib/event/helper_7f754b8f")
local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")
local helper_8b00b423 = require("@lib/event/helper_8b00b423")
local helper_8e5b8087 = require("@lib/event/helper_8e5b8087")
local helper_907fd9a8 = require("@lib/event/helper_907fd9a8")
local helper_93cb8168 = require("@lib/event/helper_93cb8168")
local helper_a3cc6850 = require("@lib/event/helper_a3cc6850")
local helper_a3d45606 = require("@lib/event/helper_a3d45606")
local helper_bc7aeb92 = require("@lib/event/helper_bc7aeb92")
local helper_c624bc16 = require("@lib/event/helper_c624bc16")
local helper_c956b4a2 = require("@lib/event/helper_c956b4a2")
local helper_df4094fb = require("@lib/event/helper_df4094fb")
local helper_e34416e2 = require("@lib/event/helper_e34416e2")
local helper_ee4287cb = require("@lib/event/helper_ee4287cb")

local global0: s32 = 0

--- Helper function.
local function helper_2349c()
	event.SndSePlay(global0, 2)
	event.SndSePlay(global0, 8)
end

--- Helper function.
local function helper_23558()
	event.Initialize()
	global0 = 0
	event.LoadSound(2200)
	global0 = event.SndLoadSound_2(2200) or global0
	event.AssignStack(4)
	event.ClearStack(4)
	event.LoadChara(4, "event/e200/e203/e203_starbre.gltf", "info", 9)
	event.EohSyncChara(1, 9)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.CharaActive(1, 9)
	event.SetCharaPos(9, 5.62, 36.1, 39.9)
	event.SetCharaRot(9, 0.0, 3.04, 0.0)
	event.SetMotion(9, "立ち", 4)
	event.LoadChara(4, "event/e200/e203/e203_vorneo.gltf", "info", 10)
	event.EohSyncChara(2, 10)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.CharaActive(1, 10)
	event.SetCharaPos(10, -38.37, 36.08, 32.88)
	event.SetCharaRot(10, 0.0, 1.48, 0.0)
	event.SetMotion(10, "立ち", 4)
	event.LoadChara(4, "event/e200/e203/e203_tom.gltf", "info", 11)
	event.EohSyncChara(3, 11)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.CharaActive(1, 11)
	event.SetCharaPos(11, -1.81, 36.1, 72.51)
	event.SetCharaRot(11, 0.0, -0.48, 0.0)
	event.SetMotion(11, "立ち", 4)
	event.EohSetSoundId(3, global0)
	event.RegisterVillager(9, 1)
	event.RegisterVillager(10, 2)
	event.RegisterVillager(11, 13, 65)
	event.SetCharaNo(9, 1)
	event.SetCharaNo(10, 2)
	event.SetCharaNo(11, 13)
	helper_2349c()
end

--- Helper function.
local function helper_1fed8()
	local block: s32 = 0
	event.SetMesWindowMode(0, 7)
	event.AssignStack(5)
	event.ClearStack(5)
	event.CmrsInit()
	event.LoadMotion(5, "event/e200/e203/e203_mints.gltf", "info", 0)
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.CharaActive(0, 0)
	event.LoadChara(5, "event/e200/e203/e203_starbre.gltf", "info", 33)
	event.EohSyncChara(1, 33)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.CharaActive(0, 33)
	event.LoadChara(5, "event/e200/e203/e203_vorneo.gltf", "info", 34)
	event.EohSyncChara(2, 34)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.CharaActive(0, 34)
	event.LoadChara(5, "event/e200/e203/e203_tom.gltf", "info", 35)
	event.EohSyncChara(3, 35)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.CharaActive(0, 35)
	event.LoadChara(5, "event/e200/e203/e203_sekitan.gltf", "info", 37)
	event.EohSyncChara(5, 37)
	event.ObjsInit(5)
	event.ObjsSyncObj(5, 5)
	event.CharaActive(0, 37)
	event.EohSyncObj_3(4, "p06_kikan", "kikan_06-m")
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.ObjsSetRot(4, 0.0, 3.1415927, 0.0)
	block = event.LoadImg_4(5, "textures/event/e200/e203/e203.json", 0) or block
	event.SpriteInit(0)
	event.SpriteSetType(0, 0)
	event.SpriteSetTexture(0, "e20301", block)
	event.SpriteSetColor(0, 128, 128, 128, 0)
	event.SpriteSetUvsize(0, 0, 0, 512, 416)
	event.SpriteSetPutsize(0, 51.2, 41.6)
	event.SpriteSetPos(0, 256, 208)
	event.SpriteSetDraw(0, 0)
	event.EohSyncSprite(10, 0)
	event.ObjsInit(10)
	event.ObjsSyncObj(10, 10)
	event.SpriteInit(1)
	event.SpriteSetType(1, 0)
	event.SpriteSetTexture(1, "e20302", block)
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
	event.SpriteSetTexture(2, "e20303", block)
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
	event.SpriteSetTexture(3, "e20304", block)
	event.SpriteSetColor(3, 128, 128, 128, 0)
	event.SpriteSetUvsize(3, 0, 0, 512.0, 416.0)
	event.SpriteSetPutsize(3, 51.2, 41.6)
	event.SpriteSetPos(3, 256, 208)
	event.SpriteSetDraw(3, 0)
	event.EohSyncSprite(13, 3)
	event.ObjsInit(13)
	event.ObjsSyncObj(13, 13)
	event.LoadMes(0, 5, "event/e200/e203/e203.txt")
	event.SetStatus(1, 0, 256, 1)
end

--- Helper function.
local function helper_1da38(arg0: any)
	event.SetFadeIn(30)
	helper_888ab2a3(30)
	event.ObjsSetMotion(0, "上見立ち", 4)
	event.ObjsResetDaPosition(0)
	event.ObjsSetMotion(1, "腰に手", 4)
	event.ObjsSetMotion(2, "斜め向き立ち", 4)
	event.ObjsSetMotion(3, "石炭", 4)
	event.CmrsMove2(41.03, 65.52, -72.49, 1.22, 60.93, 25.12, 60, 0, 1.0)
	helper_c624bc16()
	helper_888ab2a3(20)
end

--- Helper function.
local function helper_1dcec(arg0: any)
	event.ObjsSetMotion(0, "上見立ち", 4)
	event.ObjsResetDaPosition(0)
	event.ObjsSetMotion(2, "スコップ立ち", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_e34416e2(2030010)
	event.ResetPakuAnim()
	event.SetPakuAnim(1, "通常口パク")
	helper_e34416e2(2030020)
	event.ResetPakuAnim()
end

--- Helper function.
local function helper_1e36c(arg0: any)
	event.CharaActive(0, 11)
	event.CharaActive(1, 33)
	event.SpriteSetPutsize(1, 512.0, 416.0)
	event.SpriteSetDraw(1, 1)
	event.ObjsSetPos(11, 256.0, 208.0, 10.0)
	event.ObjsSetColor(11, 128.0, 128.0, 128.0, 128.0, 15)
	helper_888ab2a3(15)
	event.SpriteSetDraw(0, 0)
	helper_e34416e2(2030060)
end

--- Helper function.
local function helper_1e5e4(arg0: any)
	event.SpriteSetPutsize(2, 512.0, 416.0)
	event.SpriteSetDraw(2, 1)
	event.ObjsSetPos(12, 256.0, 208.0, 10.0)
	event.ObjsSetColor(12, 128.0, 128.0, 128.0, 128.0, 15)
	helper_888ab2a3(15)
	event.SpriteSetDraw(1, 0)
	helper_e34416e2(2030070)
	helper_e34416e2(2030073)
end

--- Helper function.
local function helper_1e820(arg0: any)
	event.SpriteSetPutsize(3, 512.0, 416.0)
	event.SpriteSetDraw(3, 1)
	event.ObjsSetPos(13, 256.0, 208.0, 0.0)
	event.ObjsSetColor(13, 128.0, 128.0, 128.0, 128.0, 15)
	helper_888ab2a3(15)
	event.SpriteSetDraw(2, 0)
	helper_e34416e2(2030080)
	helper_e34416e2(2030083)
end

--- Helper function.
local function helper_1ec34(arg0: s32)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "無表情")
	event.ObjsTexAnime(0, 1, "目パチ")
	event.ObjsSetMotion(0, "上見立ち", 4, -1.0, 1)
	event.ObjsSetColor(13, 0.0, 0.0, 0.0, 15)
	helper_888ab2a3(15)
	event.SpriteSetDraw(3, 0)
	event.CmrsMove2(10.91, 58.61, 33.87, 1.64, 58.99, 18.19, 300, 2, 0.4)
	helper_e34416e2(2030090)
	event.ObjsTexAnime(0, 1, "眉真剣")
	helper_e34416e2(2030100)
	event.StopBgm(0)
	event.SndSePlay(arg0, 5)
	event.CmrsQuake(0.0, 0.8, 0.0, 45)
	helper_888ab2a3(45)
end

--- Helper function.
local function helper_1f028(arg0: s32)
	event.CharaActive(0, 11)
	event.CharaActive(1, 35)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おどろき顔")
	event.ObjsTexAnime(0, 1, "おどろき目パチ")
	event.SndSePlay(arg0, 6)
	event.ObjsSetMotion(0, "振り返る", 6)
	event.ObjsResetDaPosition(0)
	event.ObjsNextMotion(0, "振り返るL", 0)
	event.ObjsSetMotion(1, "立ち", 4)
	event.ObjsSetMotion(3, "立ち", 4)
	helper_888ab2a3(23)
end

--- Helper function.
local function helper_1f34c(arg0: s32)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おこり顔")
	event.ObjsTexAnime(0, 1, "おこり目パチ")
	event.ObjsSetMotion(0, "上見立ち", 4)
	event.ObjsResetDaPosition(0)
	event.SndSePlay(arg0, 7)
	event.ObjsSetMotion(1, "驚く", 6)
	event.ObjsNextMotion(1, "驚くL", 0)
	event.ObjsSetMotion(2, "驚く", 6)
	event.ObjsNextMotion(2, "驚くL", 0)
	event.ObjsSetMotion(3, "驚く", 6)
	event.ObjsNextMotion(3, "驚くL", 0)
	helper_888ab2a3(20)
	event.SndSePlay(arg0, 8)
	event.SetPakuAnim(1, "大口パク")
	helper_e34416e2(2030110)
	event.ResetPakuAnim()
	event.SetPakuAnim(2, "口パク")
	helper_e34416e2(2030120)
	event.ResetPakuAnim()
	event.CmrsSetPos(23.44, 65.11, 70.77)
	event.CmrsSetRef(-17.65, 56.75, -37.19)
	event.CharaActive(0, 34)
	event.CharaActive(0, 35)
	event.ObjsSetMotion(1, "会話2", 6)
	event.ObjsNextMotion(1, "立ち", 0)
	event.SetPakuAnim(1, "大口パク")
	helper_e34416e2(2030130)
	event.ResetPakuAnim()
	event.SetPakuAnim(1, "大口パク")
	helper_e34416e2(2030135)
	event.ResetPakuAnim()
	event.ObjsSetMotion(0, "うなづく", 2)
	event.ObjsResetDaPosition(0)
	event.ObjsNextMotion(0, "立ち", 4)
	helper_8e5b8087(0, vm.f32(0.267), -1.0, 30)
	event.SetPakuAnim(0, "通常口パク")
	helper_e34416e2(2030140)
	event.ResetPakuAnim()
end

--- Helper function.
local function helper_211d4()
	local var0: s32 = 0
	vm.section(function()
		event.SetFlag(203, 1)
		event.Initialize()
		var0 = event.SndLoadSound_2(2200) or var0
		helper_1fed8()
		event.EohSetSoundId(3, var0)
		event.StopBgm(0)
		helper_888ab2a3(6)
		event.LoadBgm(105)
		event.ObjsTexAnime(0, 0)
		event.ObjsTexAnime(0, 1, "デフォルト顔")
		event.ObjsTexAnime(0, 1, "目パチ")
		event.ObjsTexAnime(1, 0)
		event.ObjsTexAnime(1, 1, "デフォルト顔")
		event.ObjsTexAnime(1, 1, "目パチ")
		event.ObjsTexAnime(2, 0)
		event.ObjsTexAnime(2, 1, "目パチ")
		event.ObjsTexAnime(3, 0)
		event.ObjsTexAnime(3, 1, "目パチ")
		event.CharaActive(0, 9)
		event.CharaActive(0, 10)
		event.SetStatus(1, 0, 256, 1)
		event.InitDramaScene()
		event.CharaActive(1, 0)
		event.CharaActive(1, 33)
		event.CharaActive(1, 34)
		event.CmrsSetPos(41.03, 65.52, -72.49)
		event.CmrsSetRef(1.22, 121.98, 25.12)
		event.ObjsSetPos(0, 2.3, 36.08, 14.12)
		event.ObjsSetRot(0, 0.0, 0.0, 0.0)
		event.ObjsSetPos(1, 5.62, 36.1, 39.9)
		event.ObjsSetRot(1, 0.0, 3.04, 0.0)
		event.ObjsSetPos(2, -38.37, 36.08, 32.88)
		event.ObjsSetRot(2, 0.0, 1.48, 0.0)
		event.ObjsSetPos(3, -1.81, 36.1, 72.51)
		event.ObjsSetRot(3, 0.0, -0.48, 0.0)
		event.ObjsResetDaPosition(0)
		event.SndSePlay(var0, 2)
		helper_1da38(var0)
		event.CmrsSetPos(54.99, 53.17, 1.95)
		event.CmrsSetRef(-1.12, 50.66, 35.36)
		event.CmrsMoveAhd2(2.64, 2.9, 55.5, 140, 0, 1.0)
		event.ObjsSetPos(0, 2.3, 36.08, 14.12)
		event.ObjsSetRot(0, 0.0, 0.0, 0.0)
		event.ObjsResetDaPosition(0)
		helper_1dcec(var0)
		helper_c624bc16()
		event.CmrsSetPos(11.36, 60.35, 36.83)
		event.CmrsSetRef(-1.48, 59.0, 7.39)
		helper_bc7aeb92(var0)
		helper_a3d45606(var0)
		helper_1e36c(var0)
		helper_1e5e4(var0)
		helper_1e820(var0)
		event.CharaActive(1, 0)
		event.CmrsInit()
		event.CmrsSetPos(12.55, 58.61, 36.64)
		event.CmrsSetRef(3.28, 58.99, 20.96)
		helper_1ec34(var0)
		event.CmrsInit()
		event.CmrsSetPos(3.0, 69.45, -14.12)
		event.CmrsSetRef(-5.47, 39.58, 58.5)
		helper_1f028(var0)
		event.CmrsSetPos(29.29, 88.68, -13.52)
		event.CmrsSetRef(-6.48, 65.74, 32.61)
		event.ObjsSetPos(0, 6.15, 36.08, -1.68)
		event.ObjsSetRot(0, 0.0, -3.12, 0.0)
		event.ObjsSetPos(2, -18.35, 36.08, 35.6)
		event.ObjsSetRot(2, 0.0, 1.48, 0.0)
		event.ObjsResetDaPosition(0)
		helper_1f34c(var0)
	end)
	event.CancelDramaScene()
	event.StopBgm(0)
	event.SetStatus(1, 0, 256, 0)
	helper_ee4287cb()
	event.CharaActive(1, 9)
	event.CharaActive(1, 10)
	event.CharaActive(1, 11)
	event.SndSeStop(var0, 2)
	event.SndSeStop(var0, 8)
	event.CmrsSetPos(29.29, 88.68, -13.52)
	event.CmrsSetRef(-6.48, 65.74, 32.61)
	event.ResetCamera(0)
end

--- Helper function.
local function helper_224a8()
	event.SetMesWindowMode(0, 7)
	event.AssignStack(5)
	event.ClearStack(5)
	event.LoadChara(5, "event/e200/e205/e205_starbre.gltf", "info", 32)
	event.EohSyncChara(0, 32)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.CharaActive(0, 32)
	event.LoadChara(5, "event/e200/e205/e205_vorneo.gltf", "info", 33)
	event.EohSyncChara(1, 33)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.CharaActive(0, 33)
	event.LoadChara(5, "event/e200/e205/e205_tom.gltf", "info", 34)
	event.EohSyncChara(2, 34)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.CharaActive(0, 34)
	event.LoadMes(0, 5, "event/e200/e205/e205.txt")
	event.CharaActive(0, 0)
end

--- Helper function.
local function helper_2297c()
	local var0: s32 = 0
	vm.section(function()
		event.SetFlag(205, 1)
		event.Initialize()
		event.LoadSound(2206)
		var0 = event.SndLoadSound_2(2206) or var0
		helper_224a8()
		event.StopBgm(0)
		event.SetFadeIn(30)
		event.CharaActive(1, 32)
		event.CharaActive(1, 33)
		event.CharaActive(1, 34)
		event.CmrsSetPos(26.2, 66.14, -50.83)
		event.CmrsSetRef(13.28, 59.7, -9.45)
		event.ObjsSetPos(0, 24.27, 36.08, -15.66)
		event.ObjsSetRot(0, 0.0, -3.12, 0.0)
		event.ObjsSetPos(1, -25.76, 36.08, 14.84)
		event.ObjsSetRot(1, 0.0, 1.6, 0.0)
		event.ObjsSetPos(2, -5.4, 36.08, 70.48)
		event.ObjsSetRot(2, 0.0, -2.64, 0.0)
		event.ObjsSetMotion(0, "だめじゃ", 4)
		event.ObjsSetMotion(1, "気絶", 4)
		event.ObjsSetMotion(2, "錯乱", 4)
		event.ObjsTexAnime(0, 0)
		event.ObjsTexAnime(0, 1, "おこり顔")
		event.ObjsTexAnime(0, 1, "通常目パチ")
		event.ObjsTexAnime(2, 0)
		event.ObjsTexAnime(2, 1, "目パチ")
		event.SndSePlay(var0, 0)
		event.CmrsQuake(0.0, 0.5, 0.1, -1)
		event.SetPakuAnim(0, "大口パク")
		helper_e34416e2(2050010)
		event.ResetPakuAnim()
		event.SetPakuAnim(0, "口パク")
		helper_e34416e2(2050020)
		event.ResetPakuAnim()
		event.SetFadeOut(30)
		helper_888ab2a3(30)
	end)
	event.CancelDramaScene()
	event.SndSeStop(var0, 0)
	event.CmrsInit()
	helper_669c752b()
	event.SetFadeIn(30)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	local flag: s32 = 0
	local flag_2: s32 = 0
	local mc_load: s32 = 0
	helper_19b130fb()
	helper_8b00b423()
	flag = event.GetFlag(203) or flag
	flag_2 = event.GetFlag(204) or flag_2
	if flag == 1 and flag_2 == 0 then
		helper_7f754b8f(1)
		event.SetBitCtrl(1, 1)
	else
		helper_7f754b8f(0)
	end
	mc_load = event.CheckMcLoad() or mc_load
	if mc_load == 1 then
		event.SetCharaPos(0, 38.0, 36.1, -100.0)
		event.SetCharaRot(0, 0.0, 0.0, 0.0)
		event.SetMotion(0, "立ち", 4)
		event.CharaNormalDrive(0)
		event.CharaResetDa(0)
	end
	if flag == 1 and flag_2 == 0 then
		helper_23558()
	end
	event.SetFadeIn(30)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
function script.key_open()
	vm.wait(1)
	helper_c956b4a2(32)
	helper_a3cc6850(0, 1002, 8, 450, 100)
	event.Test(0)
end

--- Event 200, which map data, a script or the engine runs by number.
function script.event_200()
	local var0: s32 = 0
	print("-------event_200----------------------\n")
	var0 = helper_df4094fb(1)
	if var0 ~= 0 then
		event.SetBitCtrl(1, 0)
		event.SetCnt(15, 1)
		event.SetFadeOut(0)
		event.StopBgm(0)
		helper_5be5f988()
	end
end

--- Event 201, which map data, a script or the engine runs by number.
function script.event_201()
	local var0: s32 = 0
	print("-------event_201----------------------\n")
	var0 = helper_df4094fb(0)
	if var0 ~= 0 then
		event.SetBitCtrl(1, 0)
		event.SetCnt(15, 0)
		event.SetFadeOut(0)
		event.StopBgm(0)
		helper_5be5f988()
	end
end

--- Event 203, which map data, a script or the engine runs by number.
function script.event_203()
	local flag: s32 = 0
	local flag_2: s32 = 0
	flag = event.GetFlag(203) or flag
	flag_2 = event.GetFlag(204) or flag_2
	if flag ~= 0 and flag_2 == 0 then
	else
		event.SetBitCtrl(1, 0)
		event.Initialize()
		event.SetMesWindowMode(0, 7)
		event.SetCnt(0, 1)
		event.SetFadeOut(30)
		helper_888ab2a3(30)
		event.SetCharaPos(0, 0.0, 36.0, 235.0)
		event.SetCharaRot(0, 0.0, 3.14, 0.0)
		event.MapJump_2(-1, "s07")
	end
end

--- Event 204, which map data, a script or the engine runs by number.
function script.event_204()
	local flag: s32 = 0
	local flag_2: s32 = 0
	flag = event.GetFlag(203) or flag
	flag_2 = event.GetFlag(204) or flag_2
	if flag ~= 0 and flag_2 == 0 then
		event.SetBitCtrl(1, 0)
		event.SetFadeIn(30)
		event.SndSeStop(global0, 2)
		event.SndSeStop(global0, 8)
		event.MapJump_3(-1, "s03", 501)
		vm.wait(1)
	end
end

--- Event 205, which map data, a script or the engine runs by number.
function script.event_205()
	local var0: s32 = 0
	print("--------------------------event205-------------------------\n")
	var0 = helper_df4094fb(1)
	if var0 == 0 then
		event.SetFuncEtc(0)
		vm.wait(1)
	end
end

--- Event 206, which map data, a script or the engine runs by number.
function script.event_206()
	local var0: s32 = 0
	print("--------------------------event206-------------------------\n")
	var0 = helper_df4094fb(0)
	if var0 == 0 then
		event.SetFuncEtc(0)
		vm.wait(1)
	end
end

--- Event 208, which map data, a script or the engine runs by number.
function script.event_208()
	local flag: s32 = 0
	local flag_2: s32 = 0
	print("--------------------------event208-------------------------\n")
	flag = event.GetFlag(203) or flag
	flag_2 = event.GetFlag(204) or flag_2
	if flag ~= 0 and flag_2 == 0 then
		event.SetFuncEtc(0)
		vm.wait(1)
	end
end

--- Event 209, which map data, a script or the engine runs by number.
function script.event_209()
	local flag: s32 = 0
	local flag_2: s32 = 0
	print("--------------------------event209-------------------------\n")
	flag = event.GetFlag(203) or flag
	flag_2 = event.GetFlag(204) or flag_2
	if flag ~= 0 and flag_2 == 0 then
	else
		event.SetFuncEtc(0)
		vm.wait(1)
	end
end

--- Event 400, which map data, a script or the engine runs by number.
function script.event_400()
	event.SetSavedataEtc(3, 1)
	helper_93cb8168()
	event.SetSavedataEtc(3, 0)
end

--- Event 501, which map data, a script or the engine runs by number.
function script.event_501()
	helper_8b00b423()
	helper_7f754b8f(1)
	helper_23558()
	helper_211d4()
	event.SetBitCtrl(1, 1)
	helper_2349c()
	event.SetFadeIn(30)
end

--- Event 502, which map data, a script or the engine runs by number.
function script.event_502()
	helper_2297c()
	event.BgmLoadCancel()
	event.MapJump_3(-1, "s03", 512)
	vm.wait(2)
end

--- Event 1000, which map data, a script or the engine runs by number.
function script.event_1000()
	local var0: s32 = 0
	var0 = event.GetEventData_2(13) or var0
	helper_125385ee(0, 1)
	if var0 == 9 then
		event.MesMake_2(0, "なにをもたもたしとる！\nはやくはしごをのぼるんじゃ。")
	end
	if var0 == 10 then
		event.MesMake_2(
			0,
			"今は世界がどうしたとか言ってる場合じゃないな。\nユリス、急いで外の様子を見てきてくれ。"
		)
	end
	if var0 == 11 then
		event.MesMake_2(
			0,
			"さっきのゆれ方からすると、\nわりと小さい爆弾と思うっす。<page>でも、当たり所が悪いとヤバいっすよ。"
		)
	end
	helper_907fd9a8(var0, -1, 0, 0)
end

--- Event 12030, which map data, a script or the engine runs by number.
function script.event_12030()
	helper_23558()
	helper_211d4()
	helper_2349c()
	event.SetFadeIn(30)
end

--- Event 12050, which map data, a script or the engine runs by number.
function script.event_12050()
	helper_2297c()
	event.BgmLoadCancel()
	event.MapJump_3(-1, "s03", 512)
	vm.wait(2)
end

return script
