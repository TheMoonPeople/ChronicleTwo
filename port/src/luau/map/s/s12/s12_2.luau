--!strict
-- map/s/s12/s12_2.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0958ca60 = require("@lib/event/helper_0958ca60")
local helper_17957835 = require("@lib/event/helper_17957835")
local helper_1cbe46f3 = require("@lib/event/helper_1cbe46f3")
local helper_1ef0d4b2 = require("@lib/event/helper_1ef0d4b2")
local helper_201eec5c = require("@lib/event/helper_201eec5c")
local helper_235ae843 = require("@lib/event/helper_235ae843")
local helper_238b5abc = require("@lib/event/helper_238b5abc")
local helper_25abe6d2 = require("@lib/event/helper_25abe6d2")
local helper_344d6cd8 = require("@lib/event/helper_344d6cd8")
local helper_35e14f02 = require("@lib/event/helper_35e14f02")
local helper_946c0402 = require("@lib/event/helper_946c0402")
local helper_9b12ab0c = require("@lib/event/helper_9b12ab0c")
local helper_9dafbc83 = require("@lib/event/helper_9dafbc83")
local helper_9f88d853 = require("@lib/event/helper_9f88d853")
local helper_bf11c779 = require("@lib/event/helper_bf11c779")
local helper_c624bc16 = require("@lib/event/helper_c624bc16")
local helper_c99744f1 = require("@lib/event/helper_c99744f1")
local helper_d3f20302 = require("@lib/event/helper_d3f20302")
local helper_d7295df9 = require("@lib/event/helper_d7295df9")
local helper_f4ec8310 = require("@lib/event/helper_f4ec8310")
local helper_f57795f8 = require("@lib/event/helper_f57795f8")
local helper_fdad3d3b = require("@lib/event/helper_fdad3d3b")

local global0: s32 = 0
local global1: s32 = 0

--- Event 99, which map data, a script or the engine runs by number.
local function event_99()
	print("map_init-------------------------\n")
end

--- Helper function.
local function helper_e7dc()
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
	event.LoadChara(5, "event/e600/e616/e616_toryon.gltf", "info", 39)
	event.CharaActive(0, 39)
	event.EohSyncChara(3, 39)
	event.ObjsInit(3, 39)
	event.ObjsSyncObj(3, 3)
	event.LoadChara(5, "event/e600/e616/e616_beam_f.gltf", "info", 40)
	event.CharaActive(0, 40)
	event.EohSyncChara(8, 40)
	event.ObjsInit(8, 40)
	event.ObjsSyncObj(8, 8)
	event.LoadChara(5, "event/e600/e616/e616_beam_h.gltf", "info", 41)
	event.CharaActive(0, 41)
	event.EohSyncChara(9, 41)
	event.ObjsInit(9, 41)
	event.ObjsSyncObj(9, 9)
	event.LoadChara(5, "event/e600/e616/e616_tama1.gltf", "info", 42)
	event.CharaActive(0, 42)
	event.EohSyncChara(10, 42)
	event.ObjsInit(10, 42)
	event.ObjsSyncObj(10, 10)
	event.EsmInitialize(5)
	event.EsmLoadBase("Ｅ６１６月花ビームＢ")
	event.EsmInitFix(5)
	event.LoadChara(5, "event/e600/e616/e616_iwa.gltf", "info", 43)
	event.CharaActive(0, 43)
	event.EohSyncChara(11, 43)
	event.ObjsInit(11, 43)
	event.ObjsSyncObj(11, 11)
	event.CopyChara(5, 43, 44)
	event.CharaActive(0, 44)
	event.EohSyncChara(12, 44)
	event.ObjsInit(12, 44)
	event.ObjsSyncObj(12, 12)
	event.EohSyncObj_2(4, "p01_train01")
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.EohSyncObj_2(14, "p01_shadow-0")
	event.EohSyncObj_3(5, "p01_train01", "s3601_12-m1")
	event.ObjsInit(5)
	event.ObjsSyncObj(5, 5)
	event.EohSyncObj_3(6, "p01_train01", "s3601_14-m1")
	event.ObjsSyncObj(6, 6)
	event.ObjsSetRot(6, 0.0, 0.0, 0.0)
	event.EohSyncObj_3(7, "p01_train01", "s3601_16-m1")
	event.ObjsSyncObj(7, 7)
	event.ObjsSetRot(7, 0.0, 0.0, 0.0)
	event.EohSyncObj_3(13, "p01_train01", "s3601_17-m")
	event.ObjsSyncObj(13, 13)
	event.ObjsSetRot(13, 0.0, 0.0, 0.0)
	event.LoadMes(0, 5, "event/e600/e616/e616.txt")
end

--- Helper function.
local function helper_e3e4()
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
	event.DeleteChara(39)
	event.DeleteChara(40)
	event.DeleteChara(41)
	event.DeleteChara(42)
	event.DeleteChara(43)
	event.DeleteChara(44)
	event.Finish()
	vm.wait(1)
end

--- Helper function.
local function helper_100a0()
	local var6: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var10: s32 = 0
	local var11: f32 = 0
	local var12: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	local var15: f32 = 0
	local var16: f32 = 0
	local var17: f32 = 0
	local var18: f32 = 0
	local var19: f32 = 0
	local var20: s32 = 0
	local at: number = 0
	vm.section(function()
		event.Initialize()
		event.SetMesWindowMode(0, 7)
		var6 = event.SndLoadSound_2(7202) or var6
		helper_e7dc()
		event.InitDramaScene()
		event.EohSetFootSoundId(0, 16)
		event.EohSetFootSoundId(1, 16)
		event.EohSetFootSoundId(2, 16)
		event.EohSyncChrobj(20, 39, "puropera")
		event.ObjsInit(20)
		event.ObjsSyncObj(20, 20)
		event.ObjsRotation(20, 0.0, -0.08, 0.0, -1)
		event.ObjsTexAnime(0, 0)
		event.ObjsTexAnime(0, 1, "デフォルト顔")
		event.ObjsTexAnime(0, 1, "通常目パチ")
		event.ObjsTexAnime(1, 0)
		event.ObjsTexAnime(1, 1, "デフォルト顔")
		event.ObjsTexAnime(1, 1, "通常目パチ")
		event.CharaActive(1, global0)
		event.CharaActive(1, global1)
		event.CharaActive(1, 38)
		event.CharaActive(1, 39)
		event.ObjsSetPos(4, 790.0, 0.0, 4500.0)
		event.ObjsSetRot(4, 0.0, 1.57, 0.0)
		event.EohSetRot(5, 0.0, 0.0, 0.0)
		event.ObjsSetPos(8, 913.78, 1815.71, -1455.71)
		event.ObjsSetPos(10, 913.78, 1815.71, -1455.71)
		event.ObjsSetRot(10, 0.0, -0.04, 0.0)
		event.ObjsSetPos(9, 347.12, 200.0, 1407.85)
		event.CharaActive(1, 40)
		event.ObjsSetMotion(8, "入り", 6)
		event.ObjsNextMotion(8, "溜めループ", 4)
		event.CmrsSetPos(740.39, 361.22, 3768.25)
		event.CmrsSetRef(58.72, 398.27, 1944.66)
		event.ObjsSetMotion(0, "走り", 4, -1.0, 1)
		event.ObjsSetMotion(1, "走り", 4, -1.0, 1)
		event.ObjsSetMotion(2, "走り")
		event.ObjsSetPos(3, 607.53, 453.56, -239.32)
		event.ObjsSetRot(3, 0.0, -2.56, 0.0)
		event.ObjsInitPas(2)
		event.ObjsSetPasFrm(2, 120)
		event.ObjsAddPas(2, 0.0, 173.54, 2717.0)
		event.ObjsAddPas(2, 0.0, 59.11, 3144.44)
		event.ObjsStartPas(2, 1)
		event.ObjsInitPas(1)
		event.ObjsSetPasFrm(1, 140)
		event.ObjsAddPas(1, 25.0, 189.22, 2617.0)
		event.ObjsAddPas(1, 25.0, 49.45, 3179.82)
		event.ObjsStartPas(1, 1)
		event.ObjsInitPas(0)
		event.ObjsSetPasFrm(0, 130)
		event.ObjsAddPas(0, -25.0, 184.27, 2667.0)
		event.ObjsAddPas(0, -25.75, 51.4, 3172.67)
		event.ObjsStartPas(0, 1)
		event.ObjsSetMotion(3, "岩を投げる", 4)
		event.CharaActive(1, 43)
		event.CharaActive(1, 44)
		event.SetFadeIn(30)
		event.ObjsSetPos(11, 395.57, 1007.08, -157.89)
		event.ObjsJump(11, -200.0, 700.0, -1000.0, -1.2, 60)
		at = 1
		helper_25abe6d2(30)
		event.ObjsSetPos(12, 395.57, 1007.08, -157.89)
		event.ObjsJump(12, 200.0, 700.0, -1000.0, -1.2, 60)
		at = 2
		helper_25abe6d2(30)
		event.CharaActive(1, 42)
		event.ObjsSetMotion(8, "発射", 6)
		event.ObjsSetMotion(10, "弾道", 6)
		event.EsmCreate("Ｅ６１６月花ビームＢ")
		event.EsmSetVect1(913.78, 1815.71, -1455.71)
		event.EsmSetVect2(0.0, -0.04, 0.0)
		event.ObjsSetPos(11, 395.57, 1007.08, -157.89)
		event.ObjsJump(11, -200.0, 700.0, -1000.0, -1.2, 60)
		at = 3
		helper_25abe6d2(10)
		event.ObjsMove(3, 395.57, 707.08, -157.89, 10)
		event.ObjsSetPos(12, 395.57, 1007.08, -157.89)
		event.ObjsJump(12, 200.0, 700.0, -1000.0, -1.2, 60)
		at = 4
		helper_25abe6d2(20)
		event.CharaActive(1, 41)
		event.SetMotion(41, "ヒット", 6, -1, 1)
		at = 5
		helper_25abe6d2(30)
		event.ObjsSetPos(11, 395.57, 1007.08, -157.89)
		event.ObjsJump(11, -200.0, 700.0, -1000.0, -1.2, 60)
		at = 6
		helper_25abe6d2(30)
		event.ObjsSetPos(12, 395.57, 1007.08, -157.89)
		event.ObjsJump(12, 200.0, 700.0, -1000.0, -1.2, 60)
		at = 7
		helper_25abe6d2(30)
		event.CmrsSetPos(368.47, 250.27, 3796.05)
		event.CmrsSetRef(296.74, 109.55, 4410.1)
		event.SndSePlay(var6, 7)
		do
			local out1, out2, out3 = event.EohGetPos(13)
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		event.ObjsRotation(5, 0.0, 0.0, 1.5707964, 30)
		event.ObjsRotation(6, 0.0, 0.0, 1.5707964, 30)
		event.ObjsRotation(7, 0.0, 0.0, -0.3926991, 30)
		event.ObjsRotation(13, 0.0, 0.0, -0.3926991, 30)
		at = 8
		helper_25abe6d2(30)
		event.ObjsMove(13, pos_x + 45.0, pos_y - 19.0, pos_z, 30)
		at = 9
		helper_25abe6d2(20)
		var10 = 2
		event.ObjsInitPas(var10)
		event.ObjsSetPasFrm(var10, 120)
		event.ObjsAddPas(var10, 272.66, 0.0, 4119.88)
		event.ObjsAddPas(var10, 249.45, 0.0, 4367.87)
		event.ObjsAddPas(var10, 241.61, 14.02, 4435.0)
		event.ObjsAddPas(var10, 234.87, 28.2, 4492.6)
		event.ObjsStartPas(var10)
		at = 10
		helper_25abe6d2(10)
		var10 = 0
		event.ObjsInitPas(var10)
		event.ObjsSetPasFrm(var10, 120)
		event.ObjsAddPas(var10, 272.66, 0.0, 4119.88)
		event.ObjsAddPas(var10, 249.45, 0.0, 4367.87)
		event.ObjsAddPas(var10, 241.61, 14.02, 4435.0)
		event.ObjsAddPas(var10, 234.87, 28.2, 4492.6)
		event.ObjsStartPas(var10)
		at = 11
		helper_25abe6d2(10)
		var10 = 1
		event.ObjsInitPas(var10)
		event.ObjsSetPasFrm(var10, 120)
		event.ObjsAddPas(var10, 272.66, 0.0, 4119.88)
		event.ObjsAddPas(var10, 249.45, 0.0, 4367.87)
		event.ObjsAddPas(var10, 241.61, 14.02, 4435.0)
		event.ObjsAddPas(var10, 234.87, 28.2, 4492.6)
		event.ObjsStartPas(var10)
		at = 12
		helper_0958ca60(1)
		event.CharaActive(0, global0)
		event.CharaActive(0, global1)
		event.CharaActive(0, 38)
		at = 13
		helper_25abe6d2(10)
		event.CmrsInitPas()
		event.CmrsSetPasFrm(200)
		event.CmrsAddPas(368.47, 250.27, 3796.05, 296.74, 109.55, 4410.1)
		event.CmrsAddPas(368.47, 250.27, 3796.05, 693.41, 109.55, 4324.2)
		event.CmrsStartPas()
		at = 14
		helper_c624bc16()
		at = 15
		helper_25abe6d2(30)
		event.EohSetShow(14, 0)
		event.CmrsSetPos(306.21, 234.45, 6861.67)
		event.CmrsSetRef(234.87, 296.89, 4492.6)
		event.SndSePlay(var6, 8)
		at = 16
		helper_25abe6d2(60)
		event.ObjsSetMotion(3, "浮遊", 4)
		event.ObjsRotation2(3, -0.209, 1.57, 0.0, 60, 0, 0.4)
		event.ObjsMove(3, 8374.23, 2944.08, 3500.0, 360)
		at = 17
		helper_25abe6d2(30)
		event.SndSePlay(var6, 9)
		event.ObjsMove2(4, 790.0, 50.0, 4500.0, 60, 0, 1.0)
		event.CmrsMoveRef(790.0, 100.0, 4500.0, 60)
		at = 18
		helper_0958ca60(4)
		event.ObjsRotation2(4, -0.209, 1.57, 0.0, 120, 0, 0.4)
		var11 = 790.0
		var12 = 0.0
		var13 = vm.f32(0.26666668)
		var14 = 50.0
		var15 = 0.0
		var16 = vm.f32(0.1)
		var17 = 4500.0
		var18 = 0.0
		var19 = 0.0
		var20 = 0
		while var20 < 240 do
			event.ObjsSetPos(4, var11, var14, var17)
			event.CmrsSetRef(var11, var14 + 50.0, var17)
			var11 = vm.f32(var11 + var12)
			var12 = vm.f32(var12 + var13)
			var14 = vm.f32(var14 + var15)
			var15 = vm.f32(var15 + var16)
			var17 = vm.f32(var17 + var18)
			var18 = vm.f32(var18 + var19)
			var20 = var20 + 1
			at = 19
			vm.wait(19)
		end
	end, function(received: { any }): boolean
		if at <= 1 then
			helper_d3f20302(30)
		end
		if at <= 2 then
			helper_d3f20302(10)
		end
		if at <= 3 then
			helper_d3f20302(20)
		end
		if at <= 4 then
			helper_d3f20302(30)
		end
		if at <= 5 then
			helper_d3f20302(30)
		end
		if at <= 6 then
			helper_d3f20302(30)
		end
		if at <= 7 then
			helper_d3f20302(30)
		end
		if at <= 8 then
			helper_d3f20302(20)
		end
		if at <= 9 then
			var10 = 2
			helper_d3f20302(10)
		end
		if at <= 10 then
			var10 = 0
			helper_d3f20302(10)
		end
		if at <= 11 then
			var10 = 1
			helper_238b5abc(1)
		end
		if at <= 12 then
			helper_d3f20302(10)
		end
		if at <= 13 then
			helper_344d6cd8()
		end
		if at <= 14 then
			helper_d3f20302(30)
		end
		if at <= 15 then
			helper_d3f20302(60)
		end
		if at <= 16 then
			helper_d3f20302(30)
		end
		if at <= 17 then
			helper_238b5abc(4)
		end
		if at <= 18 then
			var11 = 790.0
			var12 = 0.0
			var13 = vm.f32(0.26666668)
			var14 = 50.0
			var15 = 0.0
			var16 = vm.f32(0.1)
			var17 = 4500.0
			var18 = 0.0
			var19 = 0.0
			var20 = 0
			var11 = vm.f32(var11 + var12)
			var12 = vm.f32(var12 + var13)
			var14 = vm.f32(var14 + var15)
			var15 = vm.f32(var15 + var16)
			var17 = vm.f32(var17 + var18)
			var18 = vm.f32(var18 + var19)
			local _ = var20 < 240
			var20 = var20 + 1
		end
		return true
	end)
	event.CancelDramaScene()
	event.FadeOutBgm(30)
	event.SetFadeOut(30)
	at = 20
	helper_25abe6d2(35)
	event.StopBgm(0)
	event.EohSetFootSoundId(0, 0)
	event.EohSetFootSoundId(1, 0)
	event.SndSeAllStop(4)
	event.EsmClear()
	at = 21
	vm.wait(21)
	at = 22
	helper_e3e4()
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
	local old_map_no: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local at: number = 0
	return vm.guard(function()
		event.Initialize()
		event_99()
		print("start_event--------------------------------------------\n")
		mc_load = event.CheckMcLoad() or mc_load
		if mc_load == 1 then
			helper_35e14f02()
			helper_9dafbc83(70.0, vm.f32(0.6), 3440.0, vm.f32(3.14))
			event.ResetCamera(1, 3.14, 10.0)
			event.SetFadeIn(30)
		else
			print("000--------------------------------------------\n")
			old_map_no = event.GetOldMapNo() or old_map_no
			var2 = event.GetMapType(old_map_no) or var2
			if var2 ~= -1 then
				print("111--------------------------------------------\n")
				var3 = event.GetCnt(1) or var3
				if (old_map_no == 18 or old_map_no == 23 or old_map_no == 120 or old_map_no == 108) and var3 == 7 then
					print("222--------------------------------------------\n")
					helper_35e14f02()
					at = 1
					helper_201eec5c()
					helper_946c0402()
					event.SetFadeIn(15)
					event.ResetCamera(1, 0.0)
				else
					print("333--------------------------------------------\n")
					at = 2
					helper_235ae843()
					helper_35e14f02()
				end
				print("444--------------------------------------------\n")
			end
			print("555--------------------------------------------\n")
			event.SetMotion(0, "立ち")
		end
		print("999--------------------------------------------\n")
		return
	end, function(received: { any })
		if at <= 2 then
			if at == 1 then
			end
			if at <= 1 then
				helper_d7295df9()
				print("333--------------------------------------------\n")
				helper_17957835()
			end
			helper_1ef0d4b2()
			print("444--------------------------------------------\n")
			print("555--------------------------------------------\n")
			print("999--------------------------------------------\n")
			return 0
		end
		return nil
	end)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = helper_bf11c779

--- Event 200, which map data, a script or the engine runs by number.
function script.event_200()
	local flag: s32 = 0
	if helper_9f88d853() ~= 0 then
		flag = event.GetFlag(700) or flag
		if flag == 0 then
			event.BgmLoadCancel()
			event.MapJump_3(-1, "s68", 550)
			vm.wait(2)
		else
			event.MapJump_2(-1, "g05")
			vm.wait(3)
		end
	end
end

--- Event 250, which map data, a script or the engine runs by number.
function script.event_250()
	local var0: s32 = 0
	local var1: s32 = 0
	local at: number = 0
	return vm.guard(function()
		at = 1
		var0 = helper_1cbe46f3()
		if var0 ~= 1 then
			return
		end
		event.SetCnt(1, 7)
		var1 = event.GetEventData_2(3) or var1
		if var1 <= 1 then
			at = 2
			helper_f4ec8310()
			event.StopBgm(0)
			at = 3
			vm.wait(3)
			event.MapJump_2(-1, "s37")
			at = 4
			vm.wait(4)
		else
			at = 5
			helper_fdad3d3b()
			event.StopBgm(0)
			event.MapJump_2(100, "s38")
		end
		return
	end, function(received: { any })
		if at <= 1 then
			if at == 1 then
				var0 = received[1] :: number
			end
			return 0
		end
		if at <= 5 then
			if at == 5 then
			end
			if at <= 4 then
				helper_c99744f1()
			end
			return 0
		end
		return nil
	end)
end

--- Event 400, which map data, a script or the engine runs by number.
script.event_400 = helper_f57795f8

--- Event 500, which map data, a script or the engine runs by number.
function script.event_500()
	helper_bf11c779()
	helper_35e14f02()
	event.CharaActive(0)
	helper_9dafbc83(vm.f32(-249.34), 0.0, vm.f32(4318.43), vm.f32(3.14))
	event.ResetCamera(1, 0.0, 10.0)
	event.SetFadeIn(30)
end

--- Event 590, which map data, a script or the engine runs by number.
function script.event_590()
	helper_100a0()
	event.MapJump_3(-1, "s11", 502)
	vm.wait(2)
end

--- Event 1000, which map data, a script or the engine runs by number.
function script.event_1000()
	local var0: s32 = 0
	var0 = event.GetEventData_2(13) or var0
	if var0 == 8 then
		helper_9b12ab0c()
	end
end

return script
