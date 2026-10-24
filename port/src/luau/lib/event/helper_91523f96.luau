--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0958ca60 = require("@lib/event/helper_0958ca60")
local helper_238b5abc = require("@lib/event/helper_238b5abc")
local helper_25abe6d2 = require("@lib/event/helper_25abe6d2")
local helper_52aadc70 = require("@lib/event/helper_52aadc70")
local helper_8cd371d7 = require("@lib/event/helper_8cd371d7")
local helper_c28d4a31 = require("@lib/event/helper_c28d4a31")
local helper_d3f20302 = require("@lib/event/helper_d3f20302")
local helper_e34416e2 = require("@lib/event/helper_e34416e2")

--- Helper function.
local function helper_91523f96()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local at: number = 0
	vm.section(function()
		event.SetCameraPos(846.73, 268.48, 883.94)
		event.SetCameraRef(1289.42, 146.71, 951.29)
		event.SetFlag(438, 1)
		event.Initialize()
		event.SetMesWindowMode(0, 7)
		event.StopBgm(0)
		at = 1
		helper_25abe6d2(4)
		event.LoadBgm(32)
		event.LoadSound(4217)
		var0 = event.SndLoadSound_2(4217) or var0
		event.AssignStack(5)
		event.ClearStack(5)
		active_chr_no = event.GetActiveChrNo() or active_chr_no
		event.SetStatus(1, 0, 256, 1)
		event.ChangeDir("event/e400/e438/")
		event.LoadMes(0, 5, "e438_1.txt")
		if active_chr_no == 0 then
			event.LoadMotion(5, "e438_mints.gltf", "info", 0)
			event.CharaActive(0)
			event.EohSyncChara(0, 0)
			event.ObjsInit(0)
			event.ObjsSyncObj(0, 0)
		end
		if active_chr_no == 1 then
			event.LoadMotion(5, "e438_monica.gltf", "info", 0)
			event.CharaActive(0)
			event.EohSyncChara(1, 0)
			event.ObjsInit(1)
			event.ObjsSyncObj(1, 1)
		end
		event.LoadChara(5, "e438_paw.gltf", "info", 34)
		event.CharaActive(0, 34)
		event.EohSyncChara(2, 34)
		event.ObjsInit(2)
		event.ObjsSyncObj(2, 2)
		event.LoadChara(5, "e438_shigu.gltf", "info", 35)
		event.CharaActive(0, 35)
		event.EohSyncChara(3, 35)
		event.ObjsInit(3)
		event.ObjsSyncObj(3, 3)
		event.EohSyncObj_2(4, "p01_battleship")
		event.ObjsInit(4)
		event.ObjsSyncObj(4, 4)
		event.ChangeDir("")
		if active_chr_no == 1 then
			event.LoadChara(5, "chara/c01_base.gltf", "info", 32)
			event.LoadEquip(5, 0, 4, "info", 32)
			event.LoadEquip(5, 0, 3, "info", 32)
			event.LoadEquip(5, 0, 2, "info", 32, 33)
			event.LoadMotion(5, "event/e400/e438/e438_mints.gltf", "info", 32)
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
			event.LoadMotion(5, "event/e400/e438/e438_monica.gltf", "info", 32)
			event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 32)
			event.EohSyncChara(1, 32)
			event.ObjsInit(1)
			event.ObjsSyncObj(1, 1)
			event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 0)
		end
		event.CharaActive(32)
		event.CharaActive(33)
		event.EohSetPos(0, 1580.54, 0.0, 1092.15)
		event.EohSetRot(0, 0.0, -2.52, 0.0)
		event.EohSetMotion(0, "立ち", 4)
		event.EohSetFootSoundId(0, 14)
		event.EohSetTexAnim(0, 0)
		event.EohSetTexAnim(0, 1, "おこり顔")
		event.EohSetTexAnim(0, 1, "おこり目パチ")
		event.EohSetPos(1, 1501.84, 0.0, 1069.09)
		event.EohSetRot(1, 0.0, -2.52, 0.0)
		event.EohSetMotion(1, "立ち", 4)
		event.EohSetFootSoundId(1, 14)
		event.EohSetTexAnim(1, 0)
		event.EohSetTexAnim(1, 1, "おこり顔")
		event.EohSetTexAnim(1, 1, "おこり目パチ")
		event.EohSetPos(2, 1577.67, 0.0, 1206.39)
		event.EohSetRot(2, 0.0, -2.52, 0.0)
		event.EohSetFootSoundId(2, 14)
		event.EohSetTexAnim(2, 0)
		event.EohSetTexAnim(2, 1, "通常目パチ")
		event.EohSetPos(3, 1651.38, 0.0, 1262.95)
		event.EohSetRot(3, 0.0, -2.52, 0.0)
		event.EohSetSoundId(3, var0)
		event.EohSetTexAnim(3, 0)
		event.EohSetTexAnim(3, 1, "通常目パチ")
		event.EohSetPos(4, 1400.0, 2000.0, 900.0)
		event.EohSetRot(4, 0.0, -2.52, 0.0)
		event.EohSetScale(4, 1.0, 1.0, 1.0)
		event.ObjsMove(0, 1416.17, 0.0, 936.56, 46)
		event.ObjsSetMotion(0, "走り", 4, -1.0, 1)
		event.ObjsMotionDelay(0, 46)
		event.ObjsSetMotion(0, "立ち")
		event.ObjsMove(1, 1401.25, 0.0, 947.01, 36)
		event.ObjsSetMotion(1, "走り", 4, -1.0, 1)
		event.ObjsMotionDelay(1, 36)
		event.ObjsSetMotion(1, "立ち")
		var2 = vm.f32(vm.f32(vm.sin(vm.f32(-2.52)) * 30000.0) + 1400.0)
		var3 = 2000.0
		var4 = vm.f32(vm.f32(vm.cos(vm.f32(-2.52)) * 30000.0) + 900.0)
		event.InitDramaScene()
		event.SndSePlay(var0, 11)
		event.CmrsInit()
		event.CmrsSetPos(846.73, 268.48, 883.94)
		event.CmrsSetRef(1289.42, 146.71, 951.29)
		event.SetFadeIn(30)
		at = 2
		helper_25abe6d2(10)
		event.SndSePlay(var0, 12)
		at = 3
		helper_0958ca60(0)
		at = 4
		helper_0958ca60(1)
		event.CmrsSetPos(1446.78, 902.12, 1000.12)
		event.CmrsSetRef(1342.3, 1004.84, 851.59)
		event.PlayBgm(0)
		event.ObjsMove(4, var2, var3, var4, 300)
		event.ObjsSeDelay(4, 260)
		event.Ext(492, 4, var0, 11) -- retail: command 492 is not registered
		event.SetPakuAnim(1, "大口パク")
		at = 5
		helper_c28d4a31(4380100, 50)
		event.CmrsSetPos(1478.85, 26.8, 1037.73)
		event.CmrsSetRef(1389.49, 33.55, 913.48)
		event.ObjsSetScale(4, 0.0, 0.0, 0.0, 250)
		event.SetPakuAnim(0, "通常口パク")
		at = 6
		helper_e34416e2(4380110)
		event.ObjsSetMotion(1, "右向く", 6)
		event.ObjsNextMotion(1, "右向くL", 4)
		event.ObjsMotionDelay(0, 10)
		event.ObjsSetMotion(0, "左向く", 6)
		event.ObjsNextMotion(0, "左向くL", 4)
		event.SetPakuAnim(1, "大口パク")
		at = 7
		helper_e34416e2(4380120)
		at = 8
		helper_0958ca60(1)
		at = 9
		helper_0958ca60(0)
		event.ObjsSetMotion(0, "左向くうなづき", 6)
		event.ObjsNextMotion(0, "左向くL", 4)
		at = 10
		helper_0958ca60(0)
		event.CmrsSetPos(1395.3, 38.89, 921.11)
		event.CmrsSetRef(1525.4, 51.33, 1091.97)
		event.CharaActive(34)
		event.CharaActive(35)
		event.ObjsMove(2, 1478.76, 0.0, 1074.97, 50)
		event.ObjsSetMotion(2, "走り", 4)
		event.ObjsMotionDelay(2, 50)
		event.ObjsSetMotion(2, "立ち")
		event.ObjsMove(3, 1556.2, 0.0, 1136.48, 80)
		event.ObjsSetMotion(3, "歩き", 4)
		event.ObjsMotionDelay(3, 80)
		event.ObjsSetMotion(3, "立ち")
		event.ObjsSetMotion(0, "立ち", 6)
		event.ObjsSetMotion(1, "立ち", 6)
		at = 11
		helper_e34416e2(4380130)
		at = 12
		helper_0958ca60(3)
		event.CmrsSetPos(1358.73, 17.36, 907.69)
		event.CmrsSetRef(1478.91, 37.71, 1028.52)
		event.SetPakuAnim(1, "大口パク")
		at = 13
		helper_e34416e2(4380140)
		event.EohSetTexAnim(2, 0)
		event.EohSetTexAnim(2, 1, "こまり目パチ")
		event.ObjsSetMotion(2, "ちょっとまって", 2)
		event.ObjsNextMotion(2, "ちょっとまってL", 4)
		at = 14
		helper_e34416e2(4380150)
		at = 15
		helper_0958ca60(2)
		event.CmrsSetPos(1416.31, 11.25, 988.08)
		event.CmrsSetRef(1408.14, 20.76, 940.82)
		event.SndSePlay(var0, 13)
		event.ObjsSetMotion(1, "振り返り静止", 6)
		event.ObjsNextMotion(1, "振り返り静止L", 4)
		event.ObjsMotionDelay(0, 10)
		event.ObjsSetMotion(0, "左向く", 6)
		event.ObjsNextMotion(0, "左向くL", 4)
		event.SetPakuAnim(1, "大口パク")
		at = 16
		helper_e34416e2(4380160)
		at = 17
		helper_0958ca60(1)
		event.CmrsSetPos(1358.73, 17.36, 907.69)
		event.CmrsSetRef(1478.91, 37.71, 1028.52)
		event.EohSetTexAnim(2, 0)
		event.EohSetTexAnim(2, 1, "通常目パチ")
		event.ObjsSetMotion(2, "ちょっとまって戻り", 6)
		event.ObjsNextMotion(2, "立ち", 4)
		at = 18
		helper_e34416e2(4380170)
		event.CmrsSetPos(1416.31, 11.25, 988.08)
		event.CmrsSetRef(1408.14, 20.76, 940.82)
		event.SetPakuAnim(0, "通常口パク")
		at = 19
		helper_e34416e2(4380180)
		event.SndSePlay(var0, 14)
		event.ObjsSetMotion(1, "戻り", 2)
		event.ObjsNextMotion(1, "立ち", 4)
		event.ObjsMotionDelay(0, 20)
		event.ObjsSetMotion(0, "左向く戻り", 6)
		event.ObjsNextMotion(0, "立ち", 4)
		event.SetPakuAnim(1, "大口パク")
		at = 20
		helper_e34416e2(4380190)
		event.SetFadeOut(30)
		at = 21
		helper_25abe6d2(30)
	end, function(received: { any }): boolean
		if at <= 1 then
			var2 = vm.f32(vm.f32(vm.sin(vm.f32(-2.52)) * 30000.0) + 1400.0)
			var3 = 2000.0
			var4 = vm.f32(vm.f32(vm.cos(vm.f32(-2.52)) * 30000.0) + 900.0)
			helper_d3f20302(10)
		end
		if at <= 2 then
			helper_238b5abc(0)
		end
		if at <= 3 then
			helper_238b5abc(1)
		end
		if at <= 4 then
			helper_52aadc70(4380100, 50)
		end
		if at <= 5 then
			helper_8cd371d7(4380110)
		end
		if at <= 6 then
			helper_8cd371d7(4380120)
		end
		if at <= 7 then
			helper_238b5abc(1)
		end
		if at <= 8 then
			helper_238b5abc(0)
		end
		if at <= 9 then
			helper_238b5abc(0)
		end
		if at <= 10 then
			helper_8cd371d7(4380130)
		end
		if at <= 11 then
			helper_238b5abc(3)
		end
		if at <= 12 then
			helper_8cd371d7(4380140)
		end
		if at <= 13 then
			helper_8cd371d7(4380150)
		end
		if at <= 14 then
			helper_238b5abc(2)
		end
		if at <= 15 then
			helper_8cd371d7(4380160)
		end
		if at <= 16 then
			helper_238b5abc(1)
		end
		if at <= 17 then
			helper_8cd371d7(4380170)
		end
		if at <= 18 then
			helper_8cd371d7(4380180)
		end
		if at <= 19 then
			helper_8cd371d7(4380190)
		end
		if at <= 20 then
			helper_d3f20302(30)
		end
		return true
	end)
	event.CancelDramaScene()
	event.SndSeStop(var0, 11)
	event.PlayBgm(0)
	event.SetStatus(1, 0, 256, 0)
	event.EohSetFootSoundId(0, 0)
	event.EohSetFootSoundId(1, 0)
	event.EohSetMotion(0, "立ち", 4)
	event.EohSetMotion(1, "立ち", 4)
	event.DelExtMotion(0)
	event.DeleteChara(32)
	event.DeleteChara(33)
	event.DeleteChara(34)
	event.DeleteChara(35)
	event.LoadMes(0, -1)
end

return helper_91523f96
