--!strict
-- map/g/g05/g05.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_038a2e4d = require("@lib/event/helper_038a2e4d")
local helper_0958ca60 = require("@lib/event/helper_0958ca60")
local helper_2b32f1e8 = require("@lib/event/helper_2b32f1e8")
local helper_38a7fa45 = require("@lib/event/helper_38a7fa45")
local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")
local helper_93cb8168 = require("@lib/event/helper_93cb8168")
local helper_94a172bf = require("@lib/event/helper_94a172bf")
local helper_9dafbc83 = require("@lib/event/helper_9dafbc83")
local helper_c624bc16 = require("@lib/event/helper_c624bc16")
local helper_c956b4a2 = require("@lib/event/helper_c956b4a2")
local helper_d61bc810 = require("@lib/event/helper_d61bc810")
local helper_e34416e2 = require("@lib/event/helper_e34416e2")
local helper_e8257c69 = require("@lib/event/helper_e8257c69")

--- Event 99, which map data, a script or the engine runs by number.
local function event_99() end

--- Helper function.
local function helper_dcbc(arg0: s32)
	local var1: any = 0
	local at: number = 0
	return vm.guard(function()
		event.Initialize()
		event.SetMotion(0, "立ち")
		at = 1
		var1 = helper_94a172bf(5, arg0)
		if var1 == 0 then
			event.SetFadeOut(20)
			at = 2
			helper_888ab2a3(20)
			return 1
		end
		return 0
	end, function(received: { any })
		if at <= 2 then
			if at == 1 then
				var1 = received[1] :: number
			end
			if at <= 1 then
				helper_038a2e4d(20)
			end
			return 1
		end
		return nil
	end)
end

--- Helper function.
local function helper_e73c()
	local active_chr_no: s32 = 0
	local var1: s32 = 0
	local time: f32 = 0
	vm.section(function()
		event.SetFlag(700, 1)
		event.Initialize()
		event.SetMesWindowMode(0, 7)
		event.AssignStack(5)
		event.ClearStack(5)
		active_chr_no = event.GetActiveChrNo() or active_chr_no
		event.LoadSound(7204)
		var1 = event.SndLoadSound_2(7204) or var1
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
		event.CharaActive(34)
		event.EohSyncChara(2, 34)
		event.ObjsInit(2)
		event.ObjsSyncObj(2, 2)
		event.LoadChara(5, "e700_a_hikari.gltf", "info", 35)
		event.SetCharaType(35, 4)
		event.CharaActive(35)
		event.EohSyncChara(3, 35)
		event.ObjsInit(3)
		event.ObjsSyncObj(3, 3)
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
		event.EohSetPos(0, 7.0, 0.0, 200.0)
		event.EohSetRot(0, 0.0, 3.14, 0.0)
		event.EohSetMotion(0, "上向くL", 4)
		event.EohSetFootSoundId(0, 7)
		event.EohSetTexAnim(0, 0)
		event.EohSetTexAnim(0, 1, "無表情")
		event.EohSetTexAnim(0, 1, "通常目パチ")
		event.EohSetPos(1, -7.0, 0.0, 198.0)
		event.EohSetRot(1, 0.0, 3.14, 0.0)
		event.EohSetMotion(1, "上向くL", 4)
		event.EohSetFootSoundId(1, 7)
		event.EohSetTexAnim(1, 0)
		event.EohSetTexAnim(1, 1, "無表情")
		event.EohSetTexAnim(1, 1, "通常目パチ")
		event.EohSetPos(2, 0.0, 20.0, 160.0)
		event.EohSetRot(2, 0.0, 0.0, 0.0)
		event.EohSetTexAnim(2, 0)
		event.EohSetTexAnim(2, 1, "デフォルト顔")
		event.EohSetMotion(2, "両手開くＬ", 4)
		event.EohSetPos(3, 11.0, 40.0, 160.0)
		event.EohSetRot(3, 0.0, 0.0, 0.0)
		event.EohSetMotion(3, "後光", 4)
		event.InitDramaScene()
		time = event.GetTime() or time
		event.SetTime(12.0)
		event.CmrsInit()
		event.CmrsSetPos(24.65, 49.97, 163.5)
		event.CmrsSetRef(-24.72, 49.99, 159.92)
		helper_888ab2a3(30)
		event.EohSetTexAnim(2, 0)
		event.EohSetTexAnim(2, 1, "デフォルト顔")
		event.EohSetTexAnim(2, 1, "目あけ～目とじ２")
		event.ObjsSetMotion(2, "両手開いて深呼吸", 2)
		event.ObjsNextMotion(2, "両手開いて深呼吸Ｌ", 4)
		event.SetPakuAnim(2, "通常口パク")
		helper_e34416e2(7000140)
		event.CmrsSetPos(0.0, 17.98, 252.41)
		event.CmrsSetRef(0.0, 26.48, 201.7)
		event.EohSetTexAnim(2, 0)
		event.EohSetTexAnim(2, 1, "デフォルト顔")
		event.EohSetTexAnim(2, 1, "目とじ～目あけ３")
		event.ObjsSetPos(3, 0.0, 40.0, 160.0)
		event.ObjsSetMotion(2, "両手開く戻り", 6)
		event.ObjsNextMotion(2, "浮遊立ち", 4)
		event.SetPakuAnim(2, "しんけん口パク")
		helper_e34416e2(7000150)
		event.SetPakuAnim(2, "しんけん口パク")
		helper_e34416e2(7000155)
		helper_0958ca60(2)
		event.CmrsSetPos(0.0, 48.71, 192.39)
		event.CmrsSetRef(0.0, 48.68, 135.78)
		event.EohSetTexAnim(2, 0)
		event.EohSetTexAnim(2, 1, "デフォルト顔")
		event.EohSetTexAnim(2, 1, "通常目パチ")
		event.SetPakuAnim(2, "しんけん口パク")
		helper_e34416e2(7000160)
		event.SetPakuAnim(2, "しんけん口パク")
		helper_e34416e2(7000165)
		event.EohSetTexAnim(2, 0)
		event.EohSetTexAnim(2, 1, "デフォルト顔")
		event.EohSetTexAnim(2, 1, "目あき～さみし目とじ")
		event.SetPakuAnim(2, "しんけん口パク")
		helper_e34416e2(7000170)
		event.CmrsSetPos(0.0, 39.02, 371.19)
		event.CmrsSetRef(0.0, 38.99, 314.58)
		event.SndSePlay(var1, 2)
		event.SetCharaShow(34, 0, 1, 0.033333335)
		event.ObjsSetMotion(3, "消失", 2)
		helper_888ab2a3(30)
		event.CmrsMove2(0.0, 39.02, 371.19, 0.0, 61.67, 314.58, 60, 0, 0.2)
		helper_c624bc16()
		helper_888ab2a3(20)
		event.SetTime(time)
		event.SetCrossfade(60)
		helper_888ab2a3(90)
		event.CmrsSetPos(23.26, 26.93, 164.88)
		event.CmrsSetRef(-0.0, 18.34, 203.74)
		helper_888ab2a3(40)
		event.ObjsSetMotion(0, "上→左", 6)
		event.ObjsNextMotion(0, "左向くL", 4)
		event.ObjsSeDelay(0, 10)
		event.ObjsSePlay(0, var1, 3)
		event.ObjsMotionDelay(1, 20)
		event.ObjsSetMotion(1, "上から右", 6)
		event.ObjsNextMotion(1, "右向くL", 4)
		event.ObjsSeDelay(1, 30)
		event.ObjsSePlay(1, var1, 4)
		event.SetPakuAnim(0, "通常口パク")
		helper_e34416e2(7000180)
		helper_0958ca60(1)
		event.SetPakuAnim(1, "通常口パク")
		helper_e34416e2(7000190)
		event.ObjsSetMotion(1, "右向く戻り", 6)
		event.ObjsNextMotion(1, "立ち", 4)
		event.ObjsSeDelay(1, 10)
		event.ObjsSePlay(1, var1, 6)
		event.ObjsMotionDelay(0, 10)
		event.ObjsSetMotion(0, "左向く戻り", 6)
		event.ObjsNextMotion(0, "立ち", 4)
		event.ObjsSeDelay(0, 20)
		event.ObjsSePlay(0, var1, 5)
		helper_888ab2a3(10)
		event.EohSetTexAnim(1, 0)
		event.EohSetTexAnim(1, 1, "無表情")
		event.EohSetTexAnim(1, 1, "通常目～おこり目")
		helper_888ab2a3(10)
		event.EohSetTexAnim(0, 0)
		event.EohSetTexAnim(0, 1, "無表情")
		event.EohSetTexAnim(0, 1, "通常目～おこり目")
		helper_888ab2a3(30)
		event.SetFadeOut(30)
		helper_888ab2a3(30)
	end)
	event.CancelDramaScene()
	event.SetStatus(1, 0, 256, 0)
	event.EohSetFootSoundId(0, 0)
	event.EohSetFootSoundId(1, 0)
	event.DelExtMotion(0)
	event.DeleteChara(32)
	event.DeleteChara(33)
	event.DeleteChara(34)
	event.DeleteChara(35)
	event.LoadMes(0, -1)
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
	event_99()
	mc_load = event.CheckMcLoad() or mc_load
	if mc_load == 1 then
		helper_9dafbc83(40.0, 0.0, 1400.0, vm.f32(3.14))
		event.ResetCamera(1, 3.14, 10.0)
		event.SetFadeIn(30)
	else
		old_map_no = event.GetOldMapNo() or old_map_no
		var2 = event.GetMapType(old_map_no) or var2
		if var2 ~= -1 and old_map_no ~= 4 then
			if old_map_no == 109 then
				helper_9dafbc83(0.0, vm.f32(140.7), -1750.0, 0.0)
				event.ResetCamera(1, 3.14, 10.0)
				event.SetFadeIn(30)
			else
				helper_9dafbc83(0.0, 0.0, 1400.0, vm.f32(3.14))
				event.ResetCamera(1, 3.14, 10.0)
				event.SetFadeIn(30)
			end
		end
	end
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
function script.key_open()
	vm.wait(1)
	helper_c956b4a2(32)
end

--- Event 200, which map data, a script or the engine runs by number.
function script.event_200()
	if helper_dcbc(155) ~= 0 then
		event.MapJump_2(-1, "s34")
	end
end

--- Event 210, which map data, a script or the engine runs by number.
function script.event_210()
	local flag: s32 = 0
	if helper_dcbc(109) ~= 0 then
		flag = event.GetFlag(702) or flag
		if flag == 0 then
			event.BgmLoadCancel()
		end
		event.MapJump_2(-1, "d06e01")
	end
end

--- The event run when the edit analysis found changes after a house door step or a Georama mode change.
function script.edit_analyze_changed()
	if (if helper_38a7fa45() ~= 0 then helper_2b32f1e8() else 0) ~= 0 then
		event.SetMotion(0, "立ち")
		event.SetFadeOut(30)
		helper_888ab2a3(30)
		event.SetFlag(744, 1)
		event.SetFlag(748, 1)
		event.MapJump_3(-1, "s44", 570)
		vm.wait(2)
	end
	if helper_38a7fa45() ~= 0 then
		event.SetMotion(0, "立ち")
		event.SetFadeOut(30)
		helper_888ab2a3(30)
		event.SetFlag(744, 1)
		event.MapJump_3(-1, "s44", 550)
		vm.wait(4)
	end
	if helper_2b32f1e8() ~= 0 then
		event.SetMotion(0, "立ち")
		event.SetFadeOut(30)
		helper_888ab2a3(30)
		event.SetFlag(748, 1)
		event.MapJump_3(-1, "s44", 560)
		vm.wait(6)
	end
end

--- Event 400, which map data, a script or the engine runs by number.
script.event_400 = helper_93cb8168

--- Event 500, which map data, a script or the engine runs by number.
function script.event_500()
	helper_e73c()
	event.SetSavedataEtc(0, 9)
	event.LoadSound(7000)
	helper_9dafbc83(0.0, 0.0, -1000.0, vm.f32(3.14))
	event.SetCameraRef(0.0, 30.0, -1000.0)
	event.SetCameraPos(0.0, 50.0, -880.0)
	event.ResetCamera(0)
	event.SetFadeIn(30)
end

--- Event 550, which map data, a script or the engine runs by number.
function script.event_550()
	helper_9dafbc83(0.0, 0.0, -1100.0, 0.0)
	event.SetCameraRef(0.0, 30.0, -1100.0)
	event.SetCameraPos(0.0, 50.0, -1220.0)
	event.ResetCamera(0)
	event.SetFadeIn(30)
end

--- Event 560, which map data, a script or the engine runs by number.
function script.event_560()
	helper_9dafbc83(0.0, 0.0, -1100.0, 0.0)
	event.SetCameraRef(0.0, 30.0, -1100.0)
	event.SetCameraPos(0.0, 50.0, -1220.0)
	event.ResetCamera(0)
	event.SetFadeIn(30)
	helper_888ab2a3(30)
	event.AddItem(198, 1)
	event.AddItem(199, 1)
	helper_e8257c69(198, 1)
	helper_e8257c69(199, 1)
	helper_d61bc810(1)
end

return script
