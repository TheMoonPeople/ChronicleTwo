--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_2f481f12 = require("@lib/event/helper_2f481f12")
local helper_93bb7fa4 = require("@lib/event/helper_93bb7fa4")
local helper_b027b809 = require("@lib/event/helper_b027b809")
local helper_e8f4b85c = require("@lib/event/helper_e8f4b85c")

--- Helper function.
local function helper_51116d28()
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 10 then
			if at <= 1 then
				helper_e8f4b85c(1)
			end
			if at <= 2 then
				helper_2f481f12(10)
			end
			if at <= 3 then
				helper_93bb7fa4(4040350)
			end
			if at <= 4 then
				helper_b027b809()
			end
			if at <= 5 then
				helper_93bb7fa4(4040360)
			end
			if at <= 6 then
				helper_93bb7fa4(4040370)
			end
			if at <= 7 then
				helper_2f481f12(10)
			end
			if at <= 8 then
				helper_2f481f12(20)
			end
			if at <= 9 then
				helper_2f481f12(30)
			end
			if vm.skip_end() then
				return skip(11)
			end
			return part2()
		end
		if at <= 11 then
			helper_2f481f12(4)
		end
	end
	function part2()
		event.CancelDramaScene()
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.DelExtMotion(0)
		event.DeleteChara(32)
		event.DeleteChara(33)
		event.DeleteChara(34)
		event.LoadMes(0, -1)
		event.LoadSound(4000)
		event.StopBgm(0)
		helper_2f481f12(4)
		if vm.skipping() then
			return skip(12)
		end
		event.LoadBgm(3)
		event.PlayBgm(0)
		event.CharaActive(0)
		event.SetMotion(0, "立ち")
		event.SetCharaPos(0, 1733.3, 0.0, -301.5)
		event.SetCharaRot(0, 0.0, 2.76, 0.0)
		event.CharaNormalDrive(0)
		event.CharaResetDa(0)
		event.ResetCamera(1, 3.1415927, 10.0)
		event.SetFadeIn(30)
	end
	event.SetFlag(404, 1)
	event.Initialize()
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.ChangeDir("event/e400/e404/")
	event.LoadMes(0, 5, "e404_1.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e404_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e404_monica.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.LoadChara(5, "e404_shigu.gltf", "info", 34)
	event.CharaActive(34)
	event.EohSyncChara(2, 34)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.ChangeDir("")
	if active_chr_no == 1 then
		event.LoadChara(5, "chara/c01_base.gltf", "info", 32)
		event.LoadEquip(5, 0, 4, "info", 32)
		event.LoadEquip(5, 0, 3, "info", 32)
		event.LoadEquip(5, 0, 2, "info", 32, 33)
		event.LoadMotion(5, "event/e400/e404/e404_mints.gltf", "info", 32)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 32)
		event.EohSyncChara(0, 32)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	else
		event.LoadChara(5, "chara/c02_base.gltf", "info", 32)
		event.LoadEquip(5, 1, 4, "info", 32)
		event.LoadEquip(5, 1, 3, "info", 32)
		event.LoadEquip(5, 1, 2, "info", 32, 33)
		event.LoadMotion(5, "event/e400/e404/e404_monica.gltf", "info", 32)
		event.EohSyncChara(1, 32)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 0)
	end
	event.CharaActive(32)
	event.CharaActive(33)
	event.EohSetPos(0, 1580.54, 0.0, 1092.15)
	event.EohSetRot(0, 0.0, -2.4, 0.0)
	event.EohSetMotion(0, "立ち", 4)
	event.EohSetFootSoundId(0, 14)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "おこり顔")
	event.EohSetTexAnim(0, 1, "おこり目パチ")
	event.EohSetPos(1, 1501.84, 0.0, 1069.09)
	event.EohSetRot(1, 0.0, -2.64, 0.0)
	event.EohSetMotion(1, "立ち", 4)
	event.EohSetFootSoundId(1, 14)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "おこり顔")
	event.EohSetTexAnim(1, 1, "おこり目パチ")
	event.EohSetPos(2, 1891.0, -14.0, -716.0)
	event.EohSetRot(2, 0.0, 2.16, 0.0)
	event.ObjsMove(0, 1424.62, 0.0, 938.48, 46)
	event.ObjsSetMotion(0, "走り", 4, -1.0, 1)
	event.ObjsMotionDelay(0, 46)
	event.ObjsSetMotion(0, "立ち")
	event.ObjsMove(1, 1401.25, 0.0, 947.01, 36)
	event.ObjsSetMotion(1, "走り", 4, -1.0, 1)
	event.ObjsMotionDelay(1, 36)
	event.ObjsSetMotion(1, "立ち")
	event.ObjsRotDelay(1, 30)
	event.ObjsRotation(1, 0.0, -0.96, 0.0, 8)
	event.InitDramaScene()
	event.CmrsInit()
	event.CmrsSetPos(846.73, 268.48, 883.94)
	event.CmrsSetRef(1289.42, 146.71, 951.29)
	event.SetFadeIn(30)
	helper_e8f4b85c(0)
	if vm.skipping() then
		return skip(1)
	end
	helper_e8f4b85c(1)
	if vm.skipping() then
		return skip(2)
	end
	helper_2f481f12(10)
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsSetMotion(0, "指さす", 2)
	event.ObjsNextMotion(0, "指さすL", 6)
	event.ObjsRotDelay(1, 4)
	event.ObjsRotation(1, 0.0, 2.2, 0.0, 10)
	event.CmrsMove2(1059.22, 268.48, 1339.51, 1289.42, 146.71, 951.29, 30, 0, 1.0)
	event.ObjsSetMotion(2, "歩き", 4)
	event.ObjsMotionDelay(2, 90)
	event.ObjsSetMotion(2, "立ち")
	event.ObjsInitPas(2)
	event.ObjsSetPasFrm(2, 90)
	event.ObjsAddPas(2, 1787.63, -14.0, -561.29)
	event.ObjsAddPas(2, 1891.0, -14.0, -716.0)
	event.ObjsAddPas(2, 2049.12, -14.0, -873.59)
	event.ObjsAddPas(2, 2149.2, -14.0, -954.9)
	event.ObjsAddPas(2, 2250.94, -14.0, -1018.67)
	event.ObjsStartPas(2)
	event.SetPakuAnim(0, "通常口パク")
	helper_93bb7fa4(4040350)
	if vm.skipping() then
		return skip(4)
	end
	helper_b027b809()
	if vm.skipping() then
		return skip(5)
	end
	event.CmrsSetPos(1404.09, 22.36, 896.46)
	event.CmrsSetRef(1422.53, 17.33, 974.51)
	event.ObjsSetRot(0, 0.0, 2.8, 0.0)
	event.ObjsSetMotion(0, "立ち", 4, -1.0, 1)
	event.SetPakuAnim(1, "通常口パク")
	helper_93bb7fa4(4040360)
	if vm.skipping() then
		return skip(6)
	end
	event.SetPakuAnim(0, "通常口パク")
	helper_93bb7fa4(4040370)
	if vm.skipping() then
		return skip(7)
	end
	event.ObjsMove(0, 1530.85, 0.0, 826.72, 60)
	event.ObjsSetMotion(0, "走り")
	helper_2f481f12(10)
	if vm.skipping() then
		return skip(8)
	end
	event.ObjsMove(1, 1507.06, 0.0, 850.62, 70)
	event.ObjsSetMotion(1, "走り")
	helper_2f481f12(20)
	if vm.skipping() then
		return skip(9)
	end
	event.FadeOutBgm(30)
	event.SetFadeOut(30)
	helper_2f481f12(30)
	if vm.skipping() then
		return skip(10)
	end
	return part2()
end

return helper_51116d28
