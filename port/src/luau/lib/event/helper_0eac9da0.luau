--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_126faf7c = require("@lib/event/helper_126faf7c")
local helper_92829c19 = require("@lib/event/helper_92829c19")
local helper_b0211f82 = require("@lib/event/helper_b0211f82")
local helper_e20fd550 = require("@lib/event/helper_e20fd550")

--- Helper function.
local function helper_0eac9da0()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 21 then
			if at <= 1 then
				var2 = vm.f32(vm.f32(vm.sin(vm.f32(-2.52)) * 30000.0) + 1400.0)
				var3 = 2000.0
				var4 = vm.f32(vm.f32(vm.cos(vm.f32(-2.52)) * 30000.0) + 900.0)
				helper_b0211f82(10)
			end
			if at <= 2 then
				helper_126faf7c(0)
			end
			if at <= 3 then
				helper_126faf7c(1)
			end
			if at <= 4 then
				helper_e20fd550(4380100, 50)
			end
			if at <= 5 then
				helper_92829c19(4380110)
			end
			if at <= 6 then
				helper_92829c19(4380120)
			end
			if at <= 7 then
				helper_126faf7c(1)
			end
			if at <= 8 then
				helper_126faf7c(0)
			end
			if at <= 9 then
				helper_126faf7c(0)
			end
			if at <= 10 then
				helper_92829c19(4380130)
			end
			if at <= 11 then
				helper_126faf7c(3)
			end
			if at <= 12 then
				helper_92829c19(4380140)
			end
			if at <= 13 then
				helper_92829c19(4380150)
			end
			if at <= 14 then
				helper_126faf7c(2)
			end
			if at <= 15 then
				helper_92829c19(4380160)
			end
			if at <= 16 then
				helper_126faf7c(1)
			end
			if at <= 17 then
				helper_92829c19(4380170)
			end
			if at <= 18 then
				helper_92829c19(4380180)
			end
			if at <= 19 then
				helper_92829c19(4380190)
			end
			if at <= 20 then
				helper_b0211f82(30)
			end
			if vm.skip_end() then
				return skip(22)
			end
			return part2()
		end
	end
	function part2()
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
	event.SetCameraPos(846.73, 268.48, 883.94)
	event.SetCameraRef(1289.42, 146.71, 951.29)
	event.SetFlag(438, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.StopBgm(0)
	helper_b0211f82(4)
	if vm.skipping() then
		return skip(1)
	end
	event.LoadBgm(32)
	event.LoadSound(4217)
	var0 = event.SndLoadSound(4217) or var0
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
	event.EohSyncObj(4, "p01_battleship")
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
	helper_b0211f82(10)
	if vm.skipping() then
		return skip(2)
	end
	event.SndSePlay(var0, 12)
	helper_126faf7c(0)
	if vm.skipping() then
		return skip(3)
	end
	helper_126faf7c(1)
	if vm.skipping() then
		return skip(4)
	end
	event.CmrsSetPos(1446.78, 902.12, 1000.12)
	event.CmrsSetRef(1342.3, 1004.84, 851.59)
	event.PlayBgm(0)
	event.ObjsMove(4, var2, var3, var4, 300)
	event.ObjsSeDelay(4, 260)
	event.Ext(492, 4, var0, 11) -- retail: command 492 is not registered
	event.SetPakuAnim(1, "大口パク")
	helper_e20fd550(4380100, 50)
	if vm.skipping() then
		return skip(5)
	end
	event.CmrsSetPos(1478.85, 26.8, 1037.73)
	event.CmrsSetRef(1389.49, 33.55, 913.48)
	event.ObjsSetScale(4, 0.0, 0.0, 0.0, 250)
	event.SetPakuAnim(0, "通常口パク")
	helper_92829c19(4380110)
	if vm.skipping() then
		return skip(6)
	end
	event.ObjsSetMotion(1, "右向く", 6)
	event.ObjsNextMotion(1, "右向くL", 4)
	event.ObjsMotionDelay(0, 10)
	event.ObjsSetMotion(0, "左向く", 6)
	event.ObjsNextMotion(0, "左向くL", 4)
	event.SetPakuAnim(1, "大口パク")
	helper_92829c19(4380120)
	if vm.skipping() then
		return skip(7)
	end
	helper_126faf7c(1)
	if vm.skipping() then
		return skip(8)
	end
	helper_126faf7c(0)
	if vm.skipping() then
		return skip(9)
	end
	event.ObjsSetMotion(0, "左向くうなづき", 6)
	event.ObjsNextMotion(0, "左向くL", 4)
	helper_126faf7c(0)
	if vm.skipping() then
		return skip(10)
	end
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
	helper_92829c19(4380130)
	if vm.skipping() then
		return skip(11)
	end
	helper_126faf7c(3)
	if vm.skipping() then
		return skip(12)
	end
	event.CmrsSetPos(1358.73, 17.36, 907.69)
	event.CmrsSetRef(1478.91, 37.71, 1028.52)
	event.SetPakuAnim(1, "大口パク")
	helper_92829c19(4380140)
	if vm.skipping() then
		return skip(13)
	end
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "こまり目パチ")
	event.ObjsSetMotion(2, "ちょっとまって", 2)
	event.ObjsNextMotion(2, "ちょっとまってL", 4)
	helper_92829c19(4380150)
	if vm.skipping() then
		return skip(14)
	end
	helper_126faf7c(2)
	if vm.skipping() then
		return skip(15)
	end
	event.CmrsSetPos(1416.31, 11.25, 988.08)
	event.CmrsSetRef(1408.14, 20.76, 940.82)
	event.SndSePlay(var0, 13)
	event.ObjsSetMotion(1, "振り返り静止", 6)
	event.ObjsNextMotion(1, "振り返り静止L", 4)
	event.ObjsMotionDelay(0, 10)
	event.ObjsSetMotion(0, "左向く", 6)
	event.ObjsNextMotion(0, "左向くL", 4)
	event.SetPakuAnim(1, "大口パク")
	helper_92829c19(4380160)
	if vm.skipping() then
		return skip(16)
	end
	helper_126faf7c(1)
	if vm.skipping() then
		return skip(17)
	end
	event.CmrsSetPos(1358.73, 17.36, 907.69)
	event.CmrsSetRef(1478.91, 37.71, 1028.52)
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "通常目パチ")
	event.ObjsSetMotion(2, "ちょっとまって戻り", 6)
	event.ObjsNextMotion(2, "立ち", 4)
	helper_92829c19(4380170)
	if vm.skipping() then
		return skip(18)
	end
	event.CmrsSetPos(1416.31, 11.25, 988.08)
	event.CmrsSetRef(1408.14, 20.76, 940.82)
	event.SetPakuAnim(0, "通常口パク")
	helper_92829c19(4380180)
	if vm.skipping() then
		return skip(19)
	end
	event.SndSePlay(var0, 14)
	event.ObjsSetMotion(1, "戻り", 2)
	event.ObjsNextMotion(1, "立ち", 4)
	event.ObjsMotionDelay(0, 20)
	event.ObjsSetMotion(0, "左向く戻り", 6)
	event.ObjsNextMotion(0, "立ち", 4)
	event.SetPakuAnim(1, "大口パク")
	helper_92829c19(4380190)
	if vm.skipping() then
		return skip(20)
	end
	event.SetFadeOut(30)
	helper_b0211f82(30)
	if vm.skipping() then
		return skip(21)
	end
	return part2()
end

return helper_0eac9da0
