--!strict
-- map/g/g01/i07/g01i07_2.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_2386f745 = require("@lib/event/helper_2386f745")
local helper_3142cade = require("@lib/event/helper_3142cade")
local helper_42c67f56 = require("@lib/event/helper_42c67f56")
local helper_43cef388 = require("@lib/event/helper_43cef388")
local helper_512cb090 = require("@lib/event/helper_512cb090")
local helper_6e56b9f0 = require("@lib/event/helper_6e56b9f0")
local helper_6f70f976 = require("@lib/event/helper_6f70f976")
local helper_78d27051 = require("@lib/event/helper_78d27051")
local helper_99a9b842 = require("@lib/event/helper_99a9b842")
local helper_a160afdb = require("@lib/event/helper_a160afdb")
local helper_c1c32f84 = require("@lib/event/helper_c1c32f84")
local helper_daa89e49 = require("@lib/event/helper_daa89e49")
local helper_e5dca676 = require("@lib/event/helper_e5dca676")

local global0: s32 = 0
local global1: s32 = 0

--- Helper function.
local function helper_181c0()
	local active_chr_no: s32 = 0
	event.SetMesWindowMode(0, 7)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		global0 = 0
		global1 = 32
		event.EohSyncChara(0, global0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global0)
		event.LoadChara(5, "chara/c02_base.gltf", "info", global1)
		event.LoadEquip(5, 1, 4, "info", global1)
		event.LoadEquip(5, 1, 3, "info", global1)
		event.LoadEquip(5, 1, 2, "info", global1, 37)
		event.LoadMotion(5, "event/e200/e250/e250_monica.gltf", "info", global1)
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
		event.LoadMotion(5, "event/e200/e250/e250_mints.gltf", "info", global0)
		event.EohSyncChara(0, global0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global0)
		event.CharaActive(1, 37)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.LoadMotion(5, "event/e200/e250/e250_monica.gltf", "info", global1)
		event.EohSyncChara(1, global1)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global1)
	end
	event.LoadChara(5, "event/e200/e250/e250_conda.gltf", "info", 39)
	event.EohSyncChara(5, 39)
	event.ObjsInit(5)
	event.ObjsSyncObj(5, 5)
	event.CharaActive(0, 39)
	event.LoadChara(5, "event/e200/e250/e250_noam.gltf", "info", 34)
	event.EohSyncChara(2, 34)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.CharaActive(0, 34)
	event.LoadChara(5, "event/e200/e250/e250_rococo.gltf", "info", 41)
	event.EohSyncChara(8, 41)
	event.ObjsInit(8)
	event.ObjsSyncObj(8, 8)
	event.CharaActive(0, 41)
	event.LoadChara(5, "event/e200/e250/e250_zak.gltf", "info", 35)
	event.EohSyncChara(3, 35)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.CharaActive(0, 35)
	event.LoadChara(5, "event/e200/e250/e250_wicky.gltf", "info", 36)
	event.EohSyncChara(4, 36)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.CharaActive(0, 36)
	event.LoadChara(5, "event/e200/e250/e250_tobo.gltf", "info", 40)
	event.EohSyncChara(7, 40)
	event.ObjsInit(7)
	event.ObjsSyncObj(7, 7)
	event.CharaActive(0, 40)
	event.LoadChara(5, "event/e200/e250/e250_mogri.gltf", "info", 38)
	event.EohSyncChara(6, 38)
	event.ObjsInit(6)
	event.ObjsSyncObj(6, 6)
	event.CharaActive(0, 38)
	event.LoadMes(0, 5, "event/e200/e250/e250_1.txt")
end

--- Helper function.
local function helper_17dec()
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
	event.DeleteChara(39)
	event.DeleteChara(34)
	event.DeleteChara(41)
	event.DeleteChara(36)
	event.DeleteChara(35)
	event.DeleteChara(38)
	event.DeleteChara(40)
end

--- Helper function.
local function helper_194b8()
	local var1: s32 = 0
	local var2: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 27 then
			if at <= 1 then
				helper_c1c32f84(30)
			end
			if at <= 2 then
				helper_c1c32f84(30)
			end
			if at <= 3 then
				helper_c1c32f84(60)
			end
			if at <= 4 then
				helper_c1c32f84(56)
			end
			if at <= 5 then
				helper_42c67f56(2500010)
			end
			if at <= 6 then
				helper_c1c32f84(60)
			end
			if at <= 7 then
				helper_78d27051(2500020, 90)
			end
			if at <= 8 then
				helper_42c67f56(2500040)
			end
			if at <= 9 then
				helper_42c67f56(2500050)
			end
			if at <= 10 then
				helper_42c67f56(2500060)
			end
			if at <= 11 then
				helper_42c67f56(2500070)
			end
			if at <= 12 then
				helper_42c67f56(2500080)
			end
			if at <= 13 then
				helper_2386f745(5)
			end
			if at <= 14 then
				helper_c1c32f84(120)
			end
			if at <= 15 then
				helper_42c67f56(2500090)
			end
			if at <= 16 then
				helper_42c67f56(2500100)
			end
			if at <= 17 then
				helper_42c67f56(2500110)
			end
			if at <= 18 then
				helper_42c67f56(2500115)
			end
			if at <= 19 then
				helper_42c67f56(2500120)
			end
			if at <= 20 then
				helper_42c67f56(2500130)
			end
			if at <= 21 then
				helper_42c67f56(2500140)
			end
			if at <= 22 then
				helper_42c67f56(2500150)
			end
			if at <= 23 then
				helper_78d27051(2500160, 130)
			end
			if at <= 24 then
				helper_2386f745(5)
			end
			if at <= 25 then
				helper_6e56b9f0(2500170, 240, 30)
			end
			if at <= 26 then
				helper_c1c32f84(30)
			end
			if vm.skip_end() then
				return skip(28)
			end
			return part2()
		end
		helper_17dec()
	end
	function part2()
		event.CancelDramaScene()
		event.StopBgm(1)
		event.StopBgm(0)
		helper_17dec()
		event.ResetCamera(0)
	end
	event.SetFlag(250, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	var1 = event.SndLoadSound(2226) or var1
	helper_181c0()
	event.EohSetFootSoundId(5, 3)
	event.EohSetFootSoundId(7, 3)
	event.EohSetFootSoundId(8, 3)
	event.EohSetFootSoundId(2, 3)
	event.EohSetFootSoundId(4, 3)
	event.EohSetFootSoundId(3, 3)
	event.EohSetFootSoundId(6, 3)
	var2 = event.GetBgmNo() or var2
	if var2 ~= 57 then
		event.StopBgm(0)
		helper_c1c32f84(4)
		if vm.skipping() then
			return skip(1)
		end
		event.LoadBgm(57)
		event.PlayBgm(0)
	end
	event.SetCameraPos(61.02, 50.01, -21.23)
	event.SetCameraRef(38.72, 33.02, 92.47)
	event.SetCharaPos(0, 36.74, 11.68, 80.62)
	event.SetCharaRot(0, 0.0, 3.08, 0.0)
	event.SetMotion(0, "立ち", 4)
	event.SetCharaPos(global0, 36.74, 11.68, 80.62)
	event.SetCharaRot(global0, 0.0, 3.08, 0.0)
	event.SetCharaPos(global1, 36.74, 11.68, 80.62)
	event.SetCharaRot(global1, 0.0, 3.08, 0.0)
	event.SetCharaPos(39, 36.74, 11.68, 80.62)
	event.SetCharaRot(39, 0.0, 3.08, 0.0)
	event.SetCharaPos(34, 36.74, 11.68, 80.62)
	event.SetCharaRot(34, 0.0, 3.08, 0.0)
	event.SetCharaPos(35, 36.74, 11.68, 80.62)
	event.SetCharaRot(35, 0.0, 3.08, 0.0)
	event.SetCharaPos(40, 36.74, 11.68, 80.62)
	event.SetCharaRot(40, 0.0, 3.08, 0.0)
	event.SetCharaPos(36, 36.74, 11.68, 80.62)
	event.SetCharaRot(36, 0.0, 3.08, 0.0)
	event.SetCharaPos(41, 36.74, 11.68, 80.62)
	event.SetCharaRot(41, 0.0, 3.08, 0.0)
	event.SetCharaPos(38, 36.74, 11.68, 80.62)
	event.SetCharaRot(38, 0.0, 3.08, 0.0)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "デフォルト顔")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.InitDramaScene()
	event.CharaActive(1, 39)
	event.CmrsSetPos(91.91, 40.58, -22.22)
	event.CmrsSetRef(60.35, 28.33, -88.23)
	event.ObjsSetPos(5, 61.73, 0.0, -98.0)
	event.ObjsSetRot(5, 0.0, -0.16, 0.0)
	event.SetFadeIn(30)
	event.SndSePlay(var1, 8)
	event.ObjsSetMotion(5, "うたたね", 4)
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(2)
	end
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(3)
	end
	helper_c1c32f84(60)
	if vm.skipping() then
		return skip(4)
	end
	event.SndSePlay(var1, 9)
	event.SndSePlay(var1, 10)
	event.ObjsSetMotion(5, "目を覚ます", 2)
	event.ObjsNextMotion(5, "立ち", 0)
	helper_c1c32f84(56)
	if vm.skipping() then
		return skip(5)
	end
	event.ObjsSetMotion(5, "会話", 6)
	event.ObjsNextMotion(5, "立ち", 0)
	helper_42c67f56(2500010)
	if vm.skipping() then
		return skip(6)
	end
	event.ObjsSetMotion(5, "歩き", 0)
	event.ObjsMove(5, 14.66, 0.0, -93.65, 90)
	event.ObjsRotation(5, 0.0, -1.36, 0.0, 15)
	helper_c1c32f84(60)
	if vm.skipping() then
		return skip(7)
	end
	event.ObjsInit(5)
	event.ObjsSyncObj(5, 5)
	event.ObjsSetMotion(5, "立ち", 4)
	event.CharaActive(1, global0)
	event.CharaActive(1, global1)
	event.CharaActive(1, 41)
	event.CharaActive(1, 34)
	event.CharaActive(1, 40)
	event.CharaActive(1, 35)
	event.CharaActive(1, 36)
	event.CharaActive(1, 38)
	event.CmrsSetPos(114.27, 52.14, 5.16)
	event.CmrsSetRef(75.96, 38.4, 31.19)
	event.ObjsSetPos(0, 41.21, 12.34, 89.84)
	event.ObjsSetRot(0, 0.0, 3.08, 0.0)
	event.ObjsSetPos(1, 59.24, 12.34, 90.02)
	event.ObjsSetRot(1, 0.0, 3.08, 0.0)
	event.ObjsSetPos(2, 50.17, 12.34, 41.54)
	event.ObjsSetRot(2, 0.0, 3.08, 0.0)
	event.ObjsSetPos(7, -47.75, 0.0, -33.99)
	event.ObjsSetRot(7, 0.0, 1.28, 0.0)
	event.ObjsSetPos(3, 65.47, 12.34, 70.09)
	event.ObjsSetRot(3, 0.0, 3.08, 0.0)
	event.ObjsSetPos(4, 48.11, 12.34, 62.89)
	event.ObjsSetRot(4, 0.0, 3.08, 0.0)
	event.ObjsSetPos(8, -40.99, 0.0, -53.0)
	event.ObjsSetRot(8, 0.0, 0.68, 0.0)
	event.ObjsSetPos(6, 26.04, 12.34, 58.13)
	event.ObjsSetRot(6, 0.0, 3.08, 0.0)
	event.ObjsSetPos(5, -3.45, 0.0, -90.22)
	event.ObjsSetRot(5, 0.0, -0.16, 0.0)
	event.CmrsMove2(71.46, 34.6, 10.91, -11.65, 23.24, -37.81, 48, 2, 0.4)
	event.ObjsInitPas(2)
	event.ObjsSetPasFrm(2, 75)
	event.ObjsAddPas(2, 50.17, 12.34, 41.54)
	event.ObjsAddPas(2, 34.93, 4.87, 15.29)
	event.ObjsAddPas(2, 8.97, 0.0, -10.99)
	event.ObjsAddPas(2, -11.35, 0.0, -43.14)
	event.ObjsAddPas(2, -20.73, 0.0, -44.48)
	event.ObjsAddPas(2, -25.84, 0.0, -41.54)
	event.ObjsStartPas(2)
	event.ObjsRotation(2, 0.0, -1.06, 0.0, 60)
	event.ObjsPosDelay(4, 5)
	event.ObjsInitPas(4)
	event.ObjsSetPasFrm(4, 60)
	event.ObjsAddPas(4, 47.83, 12.34, 60.96)
	event.ObjsAddPas(4, 35.91, 12.34, 38.26)
	event.ObjsAddPas(4, 26.63, 1.97, 7.16)
	event.ObjsAddPas(4, -3.9, 0.0, -27.19)
	event.ObjsAddPas(4, -17.06, 0.0, -28.08)
	event.ObjsAddPas(4, -22.59, 0.0, -27.4)
	event.ObjsStartPas(4)
	event.ObjsRotation(4, 0.0, -1.87, 0.0, 65)
	event.ObjsPosDelay(3, 15)
	event.ObjsInitPas(3)
	event.ObjsSetPasFrm(3, 60)
	event.ObjsAddPas(3, 65.47, 12.34, 70.09)
	event.ObjsAddPas(3, 48.07, 12.34, 41.25)
	event.ObjsAddPas(3, 17.35, 0.0, 4.4)
	event.ObjsAddPas(3, -6.48, 0.0, -13.51)
	event.ObjsAddPas(3, -21.65, 0.0, -14.06)
	event.ObjsStartPas(3)
	event.ObjsRotation(3, 0.0, -2.12, 0.0, 75)
	event.ObjsPosDelay(6, 10)
	event.ObjsInitPas(6)
	event.ObjsSetPasFrm(6, 60)
	event.ObjsAddPas(6, 26.04, 12.34, 58.13)
	event.ObjsAddPas(6, 16.54, 12.34, 39.83)
	event.ObjsAddPas(6, 15.0, 1.75, 6.54)
	event.ObjsAddPas(6, -18.95, 0.07, -5.53)
	event.ObjsAddPas(6, -36.21, 0.07, -6.68)
	event.ObjsStartPas(6)
	event.ObjsRotation(6, 0.0, -2.94, 0.0, 70)
	event.ObjsMove(7, -48.33, 0.0, -19.5, 15)
	event.ObjsRotation(7, 0.0, 1.76, 0.0, 15)
	event.ObjsMove(8, -47.4, 0.0, -39.83, 15)
	event.ObjsRotation(8, 0.0, 1.04, 0.0, 15)
	event.ObjsMove(5, -41.32, 0.0, -54.14, 15)
	event.ObjsRotation(5, 0.0, 0.68, 0.0, 15)
	event.ObjsSetMotion(2, "走り", 0)
	event.ObjsMotionDelay(2, 75)
	event.ObjsSetMotion(2, "立ち", 0)
	event.ObjsSetMotion(4, "立ち", 0)
	event.ObjsMotionDelay(5)
	event.ObjsSetMotion(4, "走り2", 0)
	event.ObjsMotionDelay(4, 60)
	event.ObjsSetMotion(4, "立ち", 0)
	event.ObjsSetMotion(3, "立ち", 0)
	event.ObjsMotionDelay(3, 15)
	event.ObjsSetMotion(3, "走り", 0)
	event.ObjsMotionDelay(3, 60)
	event.ObjsSetMotion(3, "立ち", 0)
	event.ObjsSetMotion(6, "立ち", 0)
	event.ObjsMotionDelay(6, 10)
	event.ObjsSetMotion(6, "走り", 0)
	event.ObjsMotionDelay(6, 60)
	event.ObjsSetMotion(6, "立ち", 0)
	event.ObjsSetMotion(7, "走り", 0)
	event.ObjsMotionDelay(7, 15)
	event.ObjsSetMotion(7, "立ち", 0)
	event.ObjsSetMotion(8, "走り", 0)
	event.ObjsMotionDelay(8, 15)
	event.ObjsSetMotion(8, "立ち", 0)
	event.ObjsSetMotion(5, "走り", 0)
	event.ObjsMotionDelay(5, 15)
	event.ObjsSetMotion(5, "立ち", 0)
	helper_78d27051(2500020, 90)
	if vm.skipping() then
		return skip(8)
	end
	event.ObjsSetMotion(7, "会話", 0)
	event.ObjsMotionDelay(3, 15)
	event.ObjsSetMotion(3, "会話", 0)
	event.ObjsMotionDelay(2, 20)
	event.ObjsSetMotion(2, "会話", 0)
	event.ObjsMotionDelay(8, 30)
	event.ObjsSetMotion(8, "会話", 0)
	event.ObjsMotionDelay(4, 20)
	event.ObjsSetMotion(4, "会話", 0)
	event.ObjsMotionDelay(6, 30)
	event.ObjsSetMotion(6, "会話", 0)
	event.SetPakuAnim(7, "口パク")
	helper_42c67f56(2500040)
	if vm.skipping() then
		return skip(9)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(3, "口パク")
	helper_42c67f56(2500050)
	if vm.skipping() then
		return skip(10)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(8, "口パク")
	helper_42c67f56(2500060)
	if vm.skipping() then
		return skip(11)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(6, "口パク")
	helper_42c67f56(2500070)
	if vm.skipping() then
		return skip(12)
	end
	event.ResetPakuAnim()
	event.ObjsInit(5)
	event.ObjsSyncObj(5, 5)
	event.ObjsSetMotion(5, "会話2", 6)
	event.ObjsNextMotion(5, "立ち", 0)
	event.ObjsMotionDelay(2, 68)
	event.ObjsSetMotion(2, "立ち", 0)
	event.ObjsMotionDelay(3, 73)
	event.ObjsSetMotion(3, "立ち", 0)
	event.ObjsMotionDelay(4, 68)
	event.ObjsSetMotion(4, "立ち", 0)
	event.ObjsMotionDelay(6, 78)
	event.ObjsSetMotion(6, "立ち", 0)
	event.ObjsMotionDelay(7, 68)
	event.ObjsSetMotion(7, "立ち", 0)
	event.ObjsMotionDelay(8, 73)
	event.ObjsSetMotion(8, "立ち", 0)
	helper_42c67f56(2500080)
	if vm.skipping() then
		return skip(13)
	end
	helper_2386f745(5)
	if vm.skipping() then
		return skip(14)
	end
	event.ObjsSetMotion(5, "歩き", 0)
	event.ObjsInitPas(5)
	event.ObjsSetPasFrm(5, 120)
	event.ObjsAddPas(5, -40.55, 0.0, -53.27)
	event.ObjsAddPas(5, -21.22, 0.0, -65.68)
	event.ObjsAddPas(5, -5.35, 0.0, -60.71)
	event.ObjsAddPas(5, -3.11, 0.0, -43.59)
	event.ObjsAddPas(5, 5.06, 0.0, -14.63)
	event.ObjsAddPas(5, 20.49, 0.0, 8.1)
	event.ObjsStartPas(5)
	helper_c1c32f84(120)
	if vm.skipping() then
		return skip(15)
	end
	event.CmrsSetPos(7.29, 16.04, -33.96)
	event.CmrsSetRef(10.55, 19.12, 1.79)
	event.ObjsSetPos(0, 41.21, 12.34, 89.84)
	event.ObjsSetRot(0, 0.0, -2.72, 0.0)
	event.ObjsSetPos(1, 59.24, 12.34, 90.02)
	event.ObjsSetRot(1, 0.0, -2.6, 0.0)
	event.ObjsSetPos(5, 9.1, 0.0, 9.43)
	event.ObjsSetRot(5, 0.0, 0.45, 0.0)
	event.ObjsSetMotion(5, "会話2", 6)
	event.ObjsNextMotion(5, "立ち", 0)
	helper_42c67f56(2500090)
	if vm.skipping() then
		return skip(16)
	end
	event.ObjsSetMotion(5, "会話2", 6)
	event.ObjsNextMotion(5, "立ち", 0)
	helper_42c67f56(2500100)
	if vm.skipping() then
		return skip(17)
	end
	event.ObjsSetMotion(5, "会話2", 2)
	event.ObjsNextMotion(5, "立ち", 0)
	helper_42c67f56(2500110)
	if vm.skipping() then
		return skip(18)
	end
	helper_42c67f56(2500115)
	if vm.skipping() then
		return skip(19)
	end
	helper_42c67f56(2500120)
	if vm.skipping() then
		return skip(20)
	end
	event.ObjsSetMotion(1, "会話", 2)
	event.ObjsNextMotion(1, "立ち", 0)
	event.SetPakuAnim(1, "通常口パク")
	helper_42c67f56(2500130)
	if vm.skipping() then
		return skip(21)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(5, "会話2", 2)
	event.ObjsNextMotion(5, "立ち", 0)
	helper_42c67f56(2500140)
	if vm.skipping() then
		return skip(22)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_42c67f56(2500150)
	if vm.skipping() then
		return skip(23)
	end
	event.ResetPakuAnim()
	event.CmrsSetPos(70.03, 70.11, 56.44)
	event.CmrsSetRef(5.23, 27.72, -0.73)
	event.ObjsSetPos(5, 4.81, 0.0, 5.51)
	event.ObjsSetRot(5, 0.0, 0.93, 0.0)
	event.ObjsSetRot(2, 0.0, 0.74, 0.0)
	event.ObjsSetRot(3, 0.0, 1.04, 0.0)
	event.ObjsSetRot(4, 0.0, 0.69, 0.0)
	event.ObjsSetRot(6, 0.0, 1.42, 0.0)
	event.ObjsSetRot(7, 0.0, 1.16, 0.0)
	event.ObjsSetRot(8, 0.0, 0.92, 0.0)
	event.SndSePlay(var1, 11)
	event.ObjsSetMotion(5, "振り返り", 6)
	event.ObjsNextMotion(5, "振り返り会話", 0)
	helper_78d27051(2500160, 130)
	if vm.skipping() then
		return skip(24)
	end
	helper_2386f745(5)
	if vm.skipping() then
		return skip(25)
	end
	event.SndSePlay(var1, 12)
	event.ObjsSetMotion(2, "おー", 6)
	event.ObjsSetMotion(3, "おー", 6)
	event.ObjsSetMotion(4, "おー", 6)
	event.ObjsSetMotion(6, "おー", 6)
	event.ObjsSetMotion(7, "おー", 6)
	event.ObjsSetMotion(8, "おー", 6)
	event.SndSePlay(var1, 13)
	event.ObjsSetMotion(5, "振り返り2", 6)
	event.ObjsMotionDelay(5, 52)
	event.ObjsSetMotion(5, "走り", 0)
	event.ObjsMotionDelay(2, 62)
	event.ObjsSetMotion(2, "走り2", 0)
	event.ObjsMotionDelay(3, 72)
	event.ObjsSetMotion(3, "走り", 0)
	event.ObjsMotionDelay(4, 82)
	event.ObjsSetMotion(4, "走り", 0)
	event.ObjsMotionDelay(6, 92)
	event.ObjsSetMotion(6, "走り", 0)
	event.ObjsMotionDelay(7, 102)
	event.ObjsSetMotion(7, "走り", 0)
	event.ObjsMotionDelay(8, 92)
	event.ObjsSetMotion(8, "走り", 0)
	event.ObjsPosDelay(5, 52)
	event.ObjsInitPas(5)
	event.ObjsSetPasFrm(5, 45)
	event.ObjsAddPas(5, 4.81, 0.0, 5.51)
	event.ObjsAddPas(5, 15.09, 7.98, 24.0)
	event.ObjsAddPas(5, 25.36, 12.34, 52.49)
	event.ObjsAddPas(5, 39.32, 12.34, 82.98)
	event.ObjsStartPas(5)
	event.ObjsPosDelay(2, 62)
	event.ObjsInitPas(2)
	event.ObjsSetPasFrm(2, 45)
	event.ObjsAddPas(2, -25.84, 0.0, -41.54)
	event.ObjsAddPas(2, -20.06, 0.0, -45.69)
	event.ObjsAddPas(2, 3.7, 0.0, -10.84)
	event.ObjsAddPas(2, 39.39, 12.34, 77.06)
	event.ObjsStartPas(2)
	event.ObjsPosDelay(3, 72)
	event.ObjsInitPas(3)
	event.ObjsSetPasFrm(3, 45)
	event.ObjsAddPas(3, -21.96, 0.0, -12.25)
	event.ObjsAddPas(3, 14.28, 0.0, -4.5)
	event.ObjsAddPas(3, 71.46, 12.34, 38.42)
	event.ObjsStartPas(3)
	event.ObjsPosDelay(4, 82)
	event.ObjsInitPas(4)
	event.ObjsSetPasFrm(4, 45)
	event.ObjsAddPas(4, -22.59, 0.0, -27.4)
	event.ObjsAddPas(4, -17.06, 0.0, -28.08)
	event.ObjsAddPas(4, 15.38, 0.0, -0.94)
	event.ObjsAddPas(4, 46.35, 12.34, 60.68)
	event.ObjsStartPas(4)
	event.ObjsPosDelay(6, 92)
	event.ObjsInitPas(6)
	event.ObjsSetPasFrm(6, 45)
	event.ObjsAddPas(6, -36.21, 0.0, -6.68)
	event.ObjsAddPas(6, 11.35, 0.0, -7.15)
	event.ObjsAddPas(6, 56.62, 12.34, 55.65)
	event.ObjsStartPas(6)
	event.ObjsPosDelay(7, 102)
	event.ObjsInitPas(7)
	event.ObjsSetPasFrm(7, 45)
	event.ObjsAddPas(7, -47.74, 0.0, -19.5)
	event.ObjsAddPas(7, 8.7, 0.0, -6.82)
	event.ObjsAddPas(7, 34.63, 12.34, 67.71)
	event.ObjsStartPas(7)
	event.ObjsPosDelay(8, 92)
	event.ObjsInitPas(8)
	event.ObjsSetPasFrm(8, 45)
	event.ObjsAddPas(8, -47.4, 0.0, -39.83)
	event.ObjsAddPas(8, 15.0, 0.0, 5.12)
	event.ObjsAddPas(8, 16.13, 21.34, 75.28)
	event.ObjsStartPas(8)
	event.ObjsSeDelay(5, 150)
	event.ObjsSePlay(5, var1, 14)
	event.ObjsMotionDelay(5, 88)
	event.ObjsSetMotion(5, "立ち", 4)
	event.ObjsMotionDelay(2, 93)
	event.ObjsSetMotion(2, "立ち", 4)
	event.ObjsMotionDelay(3, 98)
	event.ObjsSetMotion(3, "立ち", 4)
	event.ObjsMotionDelay(4, 103)
	event.ObjsSetMotion(4, "立ち", 4)
	event.ObjsMotionDelay(6, 108)
	event.ObjsSetMotion(6, "立ち", 4)
	event.ObjsMotionDelay(7, 113)
	event.ObjsSetMotion(7, "立ち", 4)
	event.ObjsMotionDelay(8, 118)
	event.ObjsSetMotion(8, "立ち", 4)
	helper_6e56b9f0(2500170, 240, 30)
	if vm.skipping() then
		return skip(26)
	end
	event.ResetPakuAnim()
	event.FadeOutBgm(30)
	event.SetFadeOut(30)
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(27)
	end
	return part2()
end

--- Helper function.
local function helper_e8dc()
	local active_chr_no: s32 = 0
	local block: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		global0 = 0
		global1 = 32
		global0 = 32
		global1 = 0
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesWindowMode(0, 7)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		global0 = 0
		global1 = 32
		event.LoadMotion(5, "event/e200/e209/e209_mints.gltf", "info", global0)
		event.EohSyncChara(0, global0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global0)
		event.LoadChara(5, "chara/c02_base.gltf", "info", global1)
		event.LoadEquip(5, 1, 4, "info", global1)
		event.LoadEquip(5, 1, 3, "info", global1)
		event.LoadEquip(5, 1, 2, "info", global1, 37)
		event.LoadMotion(5, "event/e200/e209/e209_monica.gltf", "info", global1)
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
		event.LoadMotion(5, "event/e200/e209/e209_mints.gltf", "info", global0)
		event.EohSyncChara(0, global0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global0)
		event.CharaActive(1, 37)
		event.LoadMotion(5, "event/e200/e209/e209_monica.gltf", "info", global1)
		event.EohSyncChara(1, global1)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global1)
	end
	event.LoadChara(5, "event/e200/e209/e209_rococo.gltf", "info", 34)
	event.EohSyncChara(2, 34)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.CharaActive(0, 34)
	event.LoadChara(5, "event/e200/e209/e209_tobo.gltf", "info", 35)
	event.EohSyncChara(3, 35)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.CharaActive(0, 35)
	event.LoadChara(5, "event/e200/e209/e209_conda.gltf", "info", 36)
	event.EohSyncChara(4, 36)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.CharaActive(0, 36)
	block = event.LoadImg_4(5, "textures/event/e200/e209/cap_e209.json", 0) or block
	event.SpriteInit(0)
	event.SpriteSetType(0, 0)
	event.SpriteSetTexture(0, "森の美女", block)
	event.SpriteSetColor(0, 128, 128, 128, 0)
	event.SpriteSetUvsize(0, 0, 0, 512, 448)
	event.SpriteSetPutsize(0, 512, 448)
	event.SpriteSetPos(0, 256, 208)
	event.SpriteSetDraw(0, 0)
	event.EohSyncSprite(10, 0)
	event.ObjsInit(10)
	event.ObjsSyncObj(10, 10)
	event.SpriteInit(1)
	event.SpriteSetType(1, 0)
	event.SpriteSetTexture(1, "美女と七人", block)
	event.SpriteSetColor(1, 128, 128, 128, 0)
	event.SpriteSetUvsize(1, 0, 0, 512, 448)
	event.SpriteSetPutsize(1, 512, 448)
	event.SpriteSetPos(1, 256, 208)
	event.SpriteSetDraw(1, 0)
	event.EohSyncSprite(11, 1)
	event.ObjsInit(11)
	event.ObjsSyncObj(11, 11)
	event.SpriteInit(2)
	event.SpriteSetType(2, 0)
	event.SpriteSetTexture(2, "森に入っていく美女", block)
	event.SpriteSetColor(2, 128, 128, 128, 0)
	event.SpriteSetUvsize(2, 0, 0, 512, 448)
	event.SpriteSetPutsize(2, 512, 448)
	event.SpriteSetPos(2, 256, 208)
	event.SpriteSetDraw(2, 0)
	event.EohSyncSprite(12, 2)
	event.ObjsInit(12)
	event.ObjsSyncObj(12, 12)
	event.SpriteInit(3)
	event.SpriteSetType(3, 0)
	event.SpriteSetTexture(3, "悲しむ七人", block)
	event.SpriteSetColor(3, 128, 128, 128, 0)
	event.SpriteSetUvsize(3, 0, 0, 512.0, 448.0)
	event.SpriteSetPutsize(3, 512, 448)
	event.SpriteSetPos(3, 256, 208)
	event.SpriteSetDraw(3, 0)
	event.EohSyncSprite(13, 3)
	event.ObjsInit(13)
	event.ObjsSyncObj(13, 13)
	event.SpriteInit(4)
	event.SpriteSetType(4, 0)
	event.SpriteSetTexture(4, "捜索隊結成！", block)
	event.SpriteSetColor(4, 128, 128, 128, 0)
	event.SpriteSetUvsize(4, 0, 0, 512.0, 448.0)
	event.SpriteSetPutsize(4, 512, 448)
	event.SpriteSetPos(4, 256, 208)
	event.SpriteSetDraw(4, 0)
	event.EohSyncSprite(14, 4)
	event.ObjsInit(14)
	event.ObjsSyncObj(14, 14)
	event.LoadArg(5, "event/e200/e209/e209_arg.stb")
	event.LoadMes(0, 5, "event/e200/e209/e209_1.txt")
	event.EohSetFrameShow(4, "tue", 0)
	event.SetStatus(1, global0, 256, 1)
	event.SetStatus(1, global1, 256, 1)
end

--- Helper function.
local function helper_e3f4()
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.SetStatus(1, global0, 256, 0)
	event.SetStatus(1, global1, 256, 0)
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
	event.DeleteChara(34)
	event.DeleteChara(35)
	event.DeleteChara(36)
	event.SpriteSetDraw(0, 0)
	event.SpriteSetDraw(1, 0)
	event.SpriteSetDraw(2, 0)
	event.SpriteSetDraw(3, 0)
	event.SpriteSetDraw(4, 0)
	event.DelImg(0)
end

--- Helper function.
local function helper_105ec()
	local var1: s32 = 0
	local var2: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 102 then
			if at <= 1 then
				helper_e8dc()
				helper_c1c32f84(90)
			end
			if at <= 2 then
				helper_c1c32f84(60)
			end
			if at <= 3 then
				helper_42c67f56(2090070)
			end
			if at <= 4 then
				helper_c1c32f84(45)
			end
			if at <= 5 then
				helper_c1c32f84(30)
			end
			if at <= 6 then
				helper_c1c32f84(20)
			end
			if at <= 7 then
				helper_c1c32f84(15)
			end
			if at <= 8 then
				helper_42c67f56(2090080)
			end
			if at <= 9 then
				helper_c1c32f84(53)
			end
			if at <= 10 then
				helper_c1c32f84(15)
			end
			if at <= 11 then
				helper_42c67f56(2090090)
			end
			if at <= 12 then
				helper_2386f745(1)
			end
			if at <= 13 then
				helper_c1c32f84(37)
			end
			if at <= 14 then
				helper_42c67f56(2090100)
			end
			if at <= 15 then
				helper_c1c32f84(20)
			end
			if at <= 16 then
				helper_42c67f56(2090110)
			end
			if at <= 17 then
				helper_c1c32f84(36)
			end
			if at <= 18 then
				helper_c1c32f84(15)
			end
			if at <= 19 then
				helper_42c67f56(2090120)
			end
			if at <= 20 then
				helper_42c67f56(2090125)
			end
			if at <= 21 then
				helper_2386f745(1)
			end
			if at <= 22 then
				helper_c1c32f84(15)
			end
			if at <= 23 then
				helper_c1c32f84(13)
			end
			if at <= 24 then
				helper_42c67f56(2090130)
			end
			if at <= 25 then
				helper_42c67f56(2090140)
			end
			if at <= 26 then
				helper_42c67f56(2090150)
			end
			if at <= 27 then
				helper_42c67f56(2090160)
			end
			if at <= 28 then
				helper_42c67f56(2090170)
			end
			if at <= 29 then
				helper_42c67f56(2090180)
			end
			if at <= 30 then
				helper_42c67f56(2090190)
			end
			if at <= 31 then
				helper_2386f745(1)
			end
			if at <= 32 then
				helper_42c67f56(2090200)
			end
			if at <= 33 then
				helper_2386f745(2)
			end
			if at <= 34 then
				helper_42c67f56(2090210)
			end
			if at <= 35 then
				helper_c1c32f84(13)
			end
			if at <= 36 then
				helper_42c67f56(2090220)
			end
			if at <= 37 then
				helper_42c67f56(2090230)
			end
			if at <= 38 then
				helper_42c67f56(2090235)
			end
			if at <= 39 then
				helper_42c67f56(2090240)
			end
			if at <= 40 then
				helper_42c67f56(2090245)
			end
			if at <= 41 then
				helper_2386f745(4)
			end
			if at <= 42 then
				helper_c1c32f84(30)
			end
			if at <= 43 then
				helper_c1c32f84(4)
			end
			if at <= 44 then
				helper_e5dca676()
			end
			if at <= 45 then
				helper_42c67f56(2090250)
			end
			if at <= 46 then
				helper_42c67f56(2090253)
			end
			if at <= 47 then
				helper_42c67f56(2090255)
			end
			if at <= 48 then
				helper_42c67f56(2090257)
			end
			if at <= 49 then
				helper_42c67f56(2090260)
			end
			if at <= 50 then
				helper_42c67f56(2090270)
			end
			if at <= 51 then
				helper_42c67f56(2090280)
			end
			if at <= 52 then
				helper_2386f745(1)
			end
			if at <= 53 then
				helper_42c67f56(2090290)
			end
			if at <= 54 then
				helper_42c67f56(2090300)
			end
			if at <= 55 then
				helper_42c67f56(2090305)
			end
			if at <= 56 then
				helper_2386f745(4)
			end
			if at <= 57 then
				helper_42c67f56(2090310)
			end
			if at <= 58 then
				helper_42c67f56(2090320)
			end
			if at <= 59 then
				helper_42c67f56(2090330)
			end
			if at <= 60 then
				helper_42c67f56(2090335)
			end
			if at <= 61 then
				helper_2386f745(4)
			end
			if at <= 62 then
				helper_42c67f56(2090340)
			end
			if at <= 63 then
				helper_42c67f56(2090345)
			end
			if at <= 64 then
				helper_42c67f56(2090350)
			end
			if at <= 65 then
				helper_c1c32f84(15)
			end
			if at <= 66 then
				helper_42c67f56(2090360)
			end
			if at <= 67 then
				helper_42c67f56(2090370)
			end
			if at <= 68 then
				helper_42c67f56(2090375)
			end
			if at <= 69 then
				helper_42c67f56(2090380)
			end
			if at <= 70 then
				helper_c1c32f84(15)
			end
			if at <= 71 then
				helper_42c67f56(2090390)
			end
			if at <= 72 then
				helper_c1c32f84(15)
			end
			if at <= 73 then
				helper_42c67f56(2090400)
			end
			if at <= 74 then
				helper_42c67f56(2090410)
			end
			if at <= 75 then
				helper_c1c32f84(15)
			end
			if at <= 76 then
				helper_42c67f56(2090420)
			end
			if at <= 77 then
				helper_42c67f56(2090430)
			end
			if at <= 78 then
				helper_c1c32f84(15)
			end
			if at <= 79 then
				helper_42c67f56(2090440)
			end
			if at <= 80 then
				helper_42c67f56(2090445)
			end
			if at <= 81 then
				helper_42c67f56(2090450)
			end
			if at <= 82 then
				helper_42c67f56(2090460)
			end
			if at <= 83 then
				helper_42c67f56(2090470)
			end
			if at <= 84 then
				helper_42c67f56(2090480)
			end
			if at <= 85 then
				helper_42c67f56(2090490)
			end
			if at <= 86 then
				helper_42c67f56(2090500)
			end
			if at <= 87 then
				helper_42c67f56(2090505)
			end
			if at <= 88 then
				helper_2386f745(1)
			end
			if at <= 89 then
				helper_42c67f56(2090510)
			end
			if at <= 90 then
				helper_42c67f56(2090520)
			end
			if at <= 91 then
				helper_42c67f56(2090525)
			end
			if at <= 92 then
				helper_2386f745(1)
			end
			if at <= 93 then
				helper_42c67f56(2090530)
			end
			if at <= 94 then
				helper_42c67f56(2090535)
			end
			if at <= 95 then
				helper_c1c32f84(60)
			end
			if at <= 96 then
				helper_42c67f56(2090540)
			end
			if at <= 97 then
				helper_42c67f56(2090550)
			end
			if at <= 98 then
				helper_42c67f56(2090560)
			end
			if at <= 99 then
				helper_42c67f56(2090570)
			end
			if at <= 100 then
				helper_42c67f56(2090580)
			end
			if at <= 101 then
				helper_c1c32f84(30)
			end
			if vm.skip_end() then
				return skip(103)
			end
			return part2()
		end
		helper_e3f4()
	end
	function part2()
		event.CancelDramaScene()
		event.StopBgm(0)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		helper_e3f4()
	end
	event.SetFlag(209, 1)
	event.Initialize()
	event.LoadSound(2220)
	var1 = event.SndLoadSound(2220) or var1
	var2 = event.GetBgmNo() or var2
	if var2 ~= 57 then
		event.StopBgm(0)
		helper_c1c32f84(4)
		if vm.skipping() then
			return skip(1)
		end
		event.LoadBgm(57)
		event.PlayBgm(0)
	end
	helper_e8dc()
	event.EohSetSoundId(2, var1)
	event.EohSetFrameShow(4, "tue", 0)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "デフォルト顔")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.EohSetSoundId(2, var1)
	event.InitDramaScene()
	event.CharaActive(1, global0)
	event.CharaActive(1, global1)
	event.CmrsSetPos(47.0, 34.37, -20.4)
	event.CmrsSetRef(48.77, 33.02, 92.31)
	event.ObjsSetPos(0, 37.73, 12.34, 48.71)
	event.ObjsSetRot(0, 0.0, -3.13, 0.0)
	event.ObjsSetPos(1, 59.47, 12.34, 50.85)
	event.ObjsSetRot(1, 0.0, -3.09, 0.0)
	event.EohSetFootSoundId(0, 3)
	event.EohSetFootSoundId(1, 3)
	event.SetFadeIn(30)
	event.ObjsSetMotion(0, "歩き", 4, -1.0, 1)
	event.ObjsSetMotion(1, "歩き", 4, -1.0, 1)
	event.ObjsInitPas(0)
	event.ObjsSetPasFrm(0, 90)
	event.ObjsAddPas(0, 14.08, 22.46, 76.1)
	event.ObjsAddPas(0, 29.1, 16.19, 75.87)
	event.ObjsAddPas(0, 38.77, 12.34, 66.82)
	event.ObjsAddPas(0, 40.57, 12.24, 54.03)
	event.ObjsStartPas(0)
	event.ObjsInitPas(1)
	event.ObjsSetPasFrm(1, 90)
	event.ObjsAddPas(1, 15.0, 21.86, 97.09)
	event.ObjsAddPas(1, 34.81, 12.34, 96.25)
	event.ObjsAddPas(1, 56.96, 12.34, 86.7)
	event.ObjsAddPas(1, 59.47, 12.34, 50.85)
	event.ObjsStartPas(1)
	helper_c1c32f84(90)
	if vm.skipping() then
		return skip(2)
	end
	event.ObjsSetMotion(0, "立ち", 4)
	event.ObjsSetMotion(1, "立ち", 4)
	event.EohSetFootSoundId(0, 0)
	event.EohSetFootSoundId(1, 0)
	event.CharaActive(0, global0)
	event.CharaActive(0, global1)
	event.CharaActive(1, 34)
	event.CharaActive(1, 35)
	event.CharaActive(1, 36)
	event.EohSetFrameShow(4, "cube37", 0)
	event.EohSetFrameShow(4, "cube38", 0)
	event.CmrsSetPos(61.85, 30.75, 55.74)
	event.CmrsSetRef(57.45, 21.42, -9.43)
	event.ObjsSetPos(2, 58.4, 0.0, 1.06)
	event.ObjsSetRot(2, 0.0, 0.0, 0.0)
	event.ObjsSetPos(3, 28.34, 0.57, -39.22)
	event.ObjsSetRot(3, 0.0, 1.96, 0.0)
	event.ObjsSetPos(4, 68.15, 0.0, -98.49)
	event.ObjsSetRot(4, 0.0, -0.36, 0.0)
	event.ObjsSetMotion(2, "立ち", 4)
	event.ObjsSetMotion(3, "右向き座り", 4)
	event.ObjsSetMotion(4, "座り", 4)
	helper_c1c32f84(60)
	if vm.skipping() then
		return skip(3)
	end
	event.CharaActive(1, global0)
	event.CharaActive(1, global1)
	event.CmrsSetPos(55.75, 34.46, -7.05)
	event.CmrsSetRef(57.08, 35.01, 47.34)
	event.ObjsSetPos(0, 47.38, 12.34, 47.12)
	event.ObjsSetRot(0, 0.0, 3.02, 0.0)
	event.ObjsSetPos(1, 66.48, 12.34, 44.88)
	event.ObjsSetRot(1, 0.0, -3.05, 0.0)
	event.ObjsSetMotion(0, "小人見立ち", 4, -1.0, 1)
	event.ObjsSetMotion(1, "小人見立ち", 4, -1.0, 1)
	event.SetPakuAnim(1, "通常口パク")
	helper_42c67f56(2090070)
	if vm.skipping() then
		return skip(4)
	end
	event.ResetPakuAnim()
	event.CmrsSetPos(101.12, 31.73, 32.84)
	event.CmrsSetRef(86.47, 31.09, 33.6)
	event.ObjsSetPos(0, 32.8, 12.34, 47.06)
	event.ObjsSetRot(0, 0.0, 2.54, 0.0)
	event.ObjsSetPos(1, 54.18, 12.34, 45.41)
	event.ObjsSetRot(1, 0.0, -3.05, 0.0)
	event.ObjsSetPos(2, 58.74, 0.0, -1.86)
	event.ObjsSetRot(2, 0.0, 0.12, 0.0)
	event.ObjsResetDaPosition(0)
	event.ObjsResetDaPosition(1)
	event.ObjsSetMotion(2, "歩き", 4)
	event.ObjsMove(2, 48.3, 7.12, 21.59, 45)
	helper_c1c32f84(45)
	if vm.skipping() then
		return skip(5)
	end
	event.ObjsSetMotion(2, "立ち", 0)
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(6)
	end
	event.SndSePlay(var1, 8)
	event.ObjsSetMotion(2, "手を出す", 6)
	event.ObjsNextMotion(2, "手を出すL", 0)
	helper_c1c32f84(20)
	if vm.skipping() then
		return skip(7)
	end
	helper_c1c32f84(15)
	if vm.skipping() then
		return skip(8)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_42c67f56(2090080)
	if vm.skipping() then
		return skip(9)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(2, "よこせ", 6)
	event.ObjsNextMotion(2, "よこせ戻り", 2)
	event.ObjsNextMotion(2, "立ち", 0)
	helper_c1c32f84(53)
	if vm.skipping() then
		return skip(10)
	end
	helper_c1c32f84(15)
	if vm.skipping() then
		return skip(11)
	end
	event.ObjsSetMotion(1, "腕組み", 6, -1.0, 1)
	event.ObjsNextMotion(1, "腕組みL", 0)
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "デフォルト顔")
	event.ObjsTexAnime(1, 1, "前向き～左向き")
	event.SetPakuAnim(1, "通常口パク")
	helper_42c67f56(2090090)
	if vm.skipping() then
		return skip(12)
	end
	event.ResetPakuAnim()
	helper_2386f745(1)
	if vm.skipping() then
		return skip(13)
	end
	event.ObjsSetMotion(2, "うなづく", 6)
	event.ObjsNextMotion(2, "立ち", 0)
	helper_c1c32f84(37)
	if vm.skipping() then
		return skip(14)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_42c67f56(2090100)
	if vm.skipping() then
		return skip(15)
	end
	event.ResetPakuAnim()
	event.SndSePlay(var1, 10)
	event.ObjsSetMotion(2, "うぬぬぬ", 6)
	event.ObjsNextMotion(2, "うぬぬぬL", 0)
	helper_c1c32f84(20)
	if vm.skipping() then
		return skip(16)
	end
	event.SetPakuAnim(2, "口くいしばり")
	helper_42c67f56(2090110)
	if vm.skipping() then
		return skip(17)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(1, "腕組み戻り", 6, -1.0, 1)
	event.ObjsNextMotion(1, "小人見立ち", 0)
	helper_c1c32f84(36)
	if vm.skipping() then
		return skip(18)
	end
	helper_c1c32f84(15)
	if vm.skipping() then
		return skip(19)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_42c67f56(2090120)
	if vm.skipping() then
		return skip(20)
	end
	event.ResetPakuAnim()
	event.ObjsTexAnime(1, 1, "左向き～前向き")
	event.ObjsSetMotion(1, "小人見会話", 6, -1.0, 1)
	event.ObjsNextMotion(1, "小人見立ち", 0)
	event.SetPakuAnim(1, "通常口パク")
	helper_42c67f56(2090125)
	if vm.skipping() then
		return skip(21)
	end
	event.ResetPakuAnim()
	helper_2386f745(1)
	if vm.skipping() then
		return skip(22)
	end
	helper_c1c32f84(15)
	if vm.skipping() then
		return skip(23)
	end
	event.SndSePlay(var1, 11)
	event.ObjsSetMotion(2, "うぬぬぬ戻り", 6)
	event.ObjsNextMotion(2, "立ち", 0)
	helper_c1c32f84(13)
	if vm.skipping() then
		return skip(24)
	end
	event.SetPakuAnim(2, "口パク")
	helper_42c67f56(2090130)
	if vm.skipping() then
		return skip(25)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(1, "通常口パク")
	helper_42c67f56(2090140)
	if vm.skipping() then
		return skip(26)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(2, "口パク")
	helper_42c67f56(2090150)
	if vm.skipping() then
		return skip(27)
	end
	event.ResetPakuAnim()
	event.CharaActive(0, 34)
	event.CmrsSetPos(47.37, 32.06, 15.25)
	event.CmrsSetRef(54.66, 33.2, 46.95)
	event.ObjsSetRot(1, 0.0, -2.93, 0.0)
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "無表情")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.SetPakuAnim(1, "通常口パク")
	helper_42c67f56(2090160)
	if vm.skipping() then
		return skip(28)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(1, "通常口パク")
	helper_42c67f56(2090170)
	if vm.skipping() then
		return skip(29)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(1, "通常口パク")
	helper_42c67f56(2090180)
	if vm.skipping() then
		return skip(30)
	end
	event.ResetPakuAnim()
	if global0 ~= 0 then
		event.CharaActive(0, 37)
	end
	event.CharaActive(0, global0)
	event.CharaActive(1, 34)
	event.CmrsSetPos(23.05, 41.22, 65.24)
	event.CmrsSetRef(38.44, 35.55, 49.41)
	event.ObjsSetMotion(1, "小人見会話", 6, -1.0, 1)
	event.ObjsNextMotion(1, "小人見立ち", 0)
	event.SetPakuAnim(1, "通常口パク")
	helper_42c67f56(2090190)
	if vm.skipping() then
		return skip(31)
	end
	event.ResetPakuAnim()
	helper_2386f745(1)
	if vm.skipping() then
		return skip(32)
	end
	event.ObjsSetMotion(2, "やだよ", 6)
	event.ObjsNextMotion(2, "立ち", 0)
	event.SetPakuAnim(2, "口パク")
	helper_42c67f56(2090200)
	if vm.skipping() then
		return skip(33)
	end
	event.ResetPakuAnim()
	helper_2386f745(2)
	if vm.skipping() then
		return skip(34)
	end
	if global0 ~= 0 then
		event.CharaActive(1, 37)
	end
	event.CharaActive(1, global0)
	event.CharaActive(0, 34)
	event.CmrsSetPos(73.08, 33.52, 20.51)
	event.CmrsSetRef(34.32, 34.8, 47.0)
	event.ObjsSetRot(0, 0.0, 2.54, 0.0)
	event.ObjsSetMotion(0, "小人見会話", 6, -1.0, 1)
	event.ObjsNextMotion(0, "小人見立ち", 0)
	event.SetPakuAnim(0, "通常口パク")
	helper_42c67f56(2090210)
	if vm.skipping() then
		return skip(35)
	end
	event.ResetPakuAnim()
	event.CharaActive(1, 34)
	event.CmrsSetPos(88.63, 47.47, 55.5)
	event.CmrsSetRef(45.2, 27.56, 32.66)
	event.ObjsSetPos(2, 49.44, 6.02, 28.31)
	event.ObjsSetRot(2, 0.0, 0.12, 0.0)
	event.SndSePlay(var1, 12)
	event.ObjsSetMotion(2, "腕組み", 6)
	event.ObjsNextMotion(2, "腕組みL", 0)
	helper_c1c32f84(13)
	if vm.skipping() then
		return skip(36)
	end
	event.SetPakuAnim(2, "口パク")
	helper_42c67f56(2090220)
	if vm.skipping() then
		return skip(37)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(2, "腕組み戻り", 2)
	event.ObjsNextMotion(2, "立ち", 0)
	event.ObjsMotionDelay(0, 45)
	event.ObjsSetMotion(0, "前を見る", 6)
	event.ObjsMotionDelay(1, 40)
	event.ObjsSetMotion(1, "前を見る", 6)
	event.ObjsMotionDelay(2, 30)
	event.ObjsSetMotion(2, "振り向く", 6)
	event.ObjsNextMotion(2, "振り向くL", 0)
	helper_42c67f56(2090230)
	if vm.skipping() then
		return skip(38)
	end
	helper_42c67f56(2090235)
	if vm.skipping() then
		return skip(39)
	end
	event.CmrsSetPos(33.22, 50.72, 90.25)
	event.CmrsSetRef(67.33, 16.97, -92.82)
	event.ObjsSetPos(4, 65.22, 0.0, -99.04)
	event.ObjsSetRot(4, 0.0, -0.12, 0.0)
	event.ObjsSetMotion(0, "立ち", 4, -1.0, 1)
	event.ObjsSetMotion(1, "立ち", 4, -1.0, 1)
	event.ObjsSetMotion(4, "座り", 4)
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "デフォルト顔")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	helper_42c67f56(2090240)
	if vm.skipping() then
		return skip(40)
	end
	event.ObjsMotionDelay(4, 30)
	event.ObjsSetMotion(4, "手まねき", 6)
	event.ObjsNextMotion(4, "座り", 0)
	helper_42c67f56(2090245)
	if vm.skipping() then
		return skip(41)
	end
	helper_2386f745(4)
	if vm.skipping() then
		return skip(42)
	end
	event.CmrsFadeInit()
	event.FadeOutBgm(30)
	event.CmrsFadeOut(30, 0.0, 0.0, 0.0)
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(43)
	end
	event.CharaActive(1, global0)
	event.CharaActive(1, global1)
	event.CharaActive(1, 34)
	event.CharaActive(1, 35)
	event.CharaActive(1, 36)
	event.CmrsSetPos(-44.56, 40.35, -82.32)
	event.CmrsSetRef(30.18, 23.34, -95.14)
	event.ObjsSetPos(0, 90.21, 0.0, -36.12)
	event.ObjsSetRot(0, 0.0, -2.18, 0.0)
	event.ObjsSetPos(1, 98.27, 0.0, -52.72)
	event.ObjsSetRot(1, 0.0, -1.61, 0.0)
	event.ObjsSetPos(2, 29.51, 0.0, -37.25)
	event.ObjsSetRot(2, 0.0, 2.32, 0.0)
	event.ObjsSetPos(3, 21.3, 0.0, -61.73)
	event.ObjsSetRot(3, 0.0, 1.32, 0.0)
	event.ObjsSetPos(4, 59.82, 0.0, -98.58)
	event.ObjsSetRot(4, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(0, "座り", 4)
	event.ObjsSetMotion(1, "座り", 4, -1.0, 1)
	event.ObjsSetMotion(2, "座り", 4)
	event.ObjsSetMotion(3, "座り", 4)
	event.ObjsSetMotion(4, "座り2", 4)
	event.StopBgm(0)
	helper_c1c32f84(4)
	if vm.skipping() then
		return skip(44)
	end
	event.LoadBgm(101)
	event.PlayBgm(0)
	event.CmrsFadeInit()
	event.CmrsFadeIn(30, 0.0, 0.0, 0.0)
	event.CmrsMove2(-38.67, 40.35, -48.0, 36.07, 23.34, -60.82, 60, 2, 0.4)
	helper_e5dca676()
	if vm.skipping() then
		return skip(45)
	end
	event.ObjsSetMotion(4, "座り会話", 6)
	event.ObjsNextMotion(4, "座り2", 0)
	helper_42c67f56(2090250)
	if vm.skipping() then
		return skip(46)
	end
	event.ObjsSetMotion(4, "トボを指す", 6)
	event.ObjsNextMotion(4, "トボを指すL", 0)
	helper_42c67f56(2090253)
	if vm.skipping() then
		return skip(47)
	end
	event.ObjsSetMotion(4, "ロココを指す", 6)
	event.ObjsNextMotion(4, "ロココを差すL", 0)
	helper_42c67f56(2090255)
	if vm.skipping() then
		return skip(48)
	end
	event.ObjsNextMotion(4, "ロココを指す戻り", 2)
	event.ObjsNextMotion(4, "座り2", 0)
	helper_42c67f56(2090257)
	if vm.skipping() then
		return skip(49)
	end
	event.ObjsSetMotion(1, "座り会話", 2)
	event.ObjsNextMotion(1, "座り", 0)
	event.SetPakuAnim(1, "通常口パク")
	helper_42c67f56(2090260)
	if vm.skipping() then
		return skip(50)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(0, "通常口パク")
	helper_42c67f56(2090270)
	if vm.skipping() then
		return skip(51)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(1, "座り会話", 2)
	event.ObjsNextMotion(1, "座り", 0)
	event.SetPakuAnim(1, "通常口パク")
	helper_42c67f56(2090280)
	if vm.skipping() then
		return skip(52)
	end
	event.ResetPakuAnim()
	helper_2386f745(1)
	if vm.skipping() then
		return skip(53)
	end
	helper_42c67f56(2090290)
	if vm.skipping() then
		return skip(54)
	end
	event.ObjsSetMotion(4, "座り会話", 2)
	event.ObjsNextMotion(4, "座り2", 0)
	helper_42c67f56(2090300)
	if vm.skipping() then
		return skip(55)
	end
	helper_42c67f56(2090305)
	if vm.skipping() then
		return skip(56)
	end
	helper_2386f745(4)
	if vm.skipping() then
		return skip(57)
	end
	event.CmrsSetPos(78.46, 25.97, -62.11)
	event.CmrsSetRef(60.62, 21.41, -99.2)
	event.ObjsSetMotion(4, "座り2", 4)
	helper_42c67f56(2090310)
	if vm.skipping() then
		return skip(58)
	end
	event.CmrsSetPos(71.99, 24.65, -75.78)
	event.CmrsSetRef(95.96, 21.41, -49.6)
	event.SetPakuAnim(1, "通常口パク")
	helper_42c67f56(2090320)
	if vm.skipping() then
		return skip(59)
	end
	event.ResetPakuAnim()
	event.CmrsSetPos(78.46, 25.97, -62.11)
	event.CmrsSetRef(60.62, 21.41, -99.2)
	event.ObjsSetMotion(4, "座り会話", 6)
	event.ObjsNextMotion(4, "座り2", 0)
	helper_42c67f56(2090330)
	if vm.skipping() then
		return skip(60)
	end
	helper_42c67f56(2090335)
	if vm.skipping() then
		return skip(61)
	end
	helper_2386f745(4)
	if vm.skipping() then
		return skip(62)
	end
	event.SpriteSetDraw(0, 1)
	event.ObjsSetColor(10, 128.0, 128.0, 128.0, 128.0, 30)
	helper_42c67f56(2090340)
	if vm.skipping() then
		return skip(63)
	end
	helper_42c67f56(2090345)
	if vm.skipping() then
		return skip(64)
	end
	helper_42c67f56(2090350)
	if vm.skipping() then
		return skip(65)
	end
	event.SpriteSetDraw(1, 1)
	event.ObjsSetColor(11, 128.0, 128.0, 128.0, 128.0, 15)
	helper_c1c32f84(15)
	if vm.skipping() then
		return skip(66)
	end
	event.SpriteSetDraw(0, 0)
	helper_42c67f56(2090360)
	if vm.skipping() then
		return skip(67)
	end
	helper_42c67f56(2090370)
	if vm.skipping() then
		return skip(68)
	end
	helper_42c67f56(2090375)
	if vm.skipping() then
		return skip(69)
	end
	helper_42c67f56(2090380)
	if vm.skipping() then
		return skip(70)
	end
	event.SpriteSetDraw(2, 1)
	event.ObjsSetColor(12, 128.0, 128.0, 128.0, 128.0, 15)
	helper_c1c32f84(15)
	if vm.skipping() then
		return skip(71)
	end
	event.SpriteSetDraw(1, 0)
	helper_42c67f56(2090390)
	if vm.skipping() then
		return skip(72)
	end
	event.SpriteSetDraw(3, 1)
	event.ObjsSetColor(13, 128.0, 128.0, 128.0, 128.0, 15)
	helper_c1c32f84(15)
	if vm.skipping() then
		return skip(73)
	end
	event.SpriteSetDraw(2, 0)
	helper_42c67f56(2090400)
	if vm.skipping() then
		return skip(74)
	end
	helper_42c67f56(2090410)
	if vm.skipping() then
		return skip(75)
	end
	event.SpriteSetDraw(4, 1)
	event.ObjsSetColor(14, 128.0, 128.0, 128.0, 128.0, 15)
	helper_c1c32f84(15)
	if vm.skipping() then
		return skip(76)
	end
	event.SpriteSetDraw(3, 0)
	helper_42c67f56(2090420)
	if vm.skipping() then
		return skip(77)
	end
	helper_42c67f56(2090430)
	if vm.skipping() then
		return skip(78)
	end
	event.CmrsSetPos(90.58, 30.29, -39.36)
	event.CmrsSetRef(66.74, 28.6, -43.56)
	event.ObjsSetMotion(4, "ぽりぽり", 4)
	event.CmrsMove2(90.58, 30.29, -39.36, 78.8, 28.6, -60.82, 120, 2, 0.4)
	event.ObjsSetColor(14, 128.0, 128.0, 128.0, 0.0, 15)
	helper_c1c32f84(15)
	if vm.skipping() then
		return skip(79)
	end
	event.SpriteSetDraw(4, 0)
	helper_42c67f56(2090440)
	if vm.skipping() then
		return skip(80)
	end
	helper_42c67f56(2090445)
	if vm.skipping() then
		return skip(81)
	end
	helper_42c67f56(2090450)
	if vm.skipping() then
		return skip(82)
	end
	event.CmrsInit()
	event.CmrsSetPos(83.43, 24.94, -81.73)
	event.CmrsSetRef(100.36, 18.47, -43.72)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "無表情")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "無表情")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	helper_42c67f56(2090460)
	if vm.skipping() then
		return skip(83)
	end
	helper_42c67f56(2090470)
	if vm.skipping() then
		return skip(84)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_42c67f56(2090480)
	if vm.skipping() then
		return skip(85)
	end
	event.ResetPakuAnim()
	event.CmrsSetPos(82.07, 24.94, -61.63)
	event.CmrsSetRef(61.24, 20.49, -98.09)
	event.ObjsSetMotion(4, "座り2", 4)
	helper_42c67f56(2090490)
	if vm.skipping() then
		return skip(86)
	end
	event.CmrsSetPos(83.43, 24.94, -81.73)
	event.CmrsSetRef(100.36, 18.47, -43.72)
	event.ObjsTexAnime(0, 1, "半口")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "デフォルト顔")
	event.ObjsTexAnime(1, 1, "目あき～目とじ")
	event.ObjsTexaDelay(1, 45)
	event.ObjsTexAnime(1, 1, "目とじ～目あき")
	event.ObjsMotionDelay(0, 20)
	event.ObjsSetMotion(0, "右を見る", 6)
	event.ObjsNextMotion(0, "右を見るL", 0)
	event.ObjsSetMotion(1, "座り会話", 6)
	event.ObjsNextMotion(1, "座り", 0)
	event.SetPakuAnim(1, "わらい口パク")
	helper_42c67f56(2090500)
	if vm.skipping() then
		return skip(87)
	end
	event.ResetPakuAnim()
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.SetPakuAnim(1, "わらい口パク")
	helper_42c67f56(2090505)
	if vm.skipping() then
		return skip(88)
	end
	event.ResetPakuAnim()
	helper_2386f745(1)
	if vm.skipping() then
		return skip(89)
	end
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.CmrsSetPos(117.78, 25.28, -19.32)
	event.CmrsSetRef(91.26, 22.12, -49.27)
	event.ObjsSetMotion(0, "座り", 4, -1.0, 1)
	event.ObjsSetMotion(4, "座り会話2", 6, -1.0, 1)
	event.ObjsNextMotion(4, "座り2", 0)
	helper_42c67f56(2090510)
	if vm.skipping() then
		return skip(90)
	end
	event.CmrsSetPos(83.43, 24.94, -81.73)
	event.CmrsSetRef(100.36, 18.47, -43.72)
	event.ObjsSetMotion(1, "うなづく", 6)
	event.ObjsNextMotion(1, "座り", 0)
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.SetPakuAnim(1, "わらい口パク")
	helper_42c67f56(2090520)
	if vm.skipping() then
		return skip(91)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(1, "わらい口パク")
	helper_42c67f56(2090525)
	if vm.skipping() then
		return skip(92)
	end
	event.ResetPakuAnim()
	helper_2386f745(1)
	if vm.skipping() then
		return skip(93)
	end
	event.CmrsSetPos(84.67, 30.18, -70.24)
	event.CmrsSetRef(51.19, 19.0, -102.93)
	event.ObjsSetMotion(4, "ぽりぽり", 4)
	helper_42c67f56(2090530)
	if vm.skipping() then
		return skip(94)
	end
	helper_42c67f56(2090535)
	if vm.skipping() then
		return skip(95)
	end
	helper_c1c32f84(60)
	if vm.skipping() then
		return skip(96)
	end
	event.ObjsMotionDelay(4, 30)
	event.ObjsSetMotion(4, "そうじゃ", 6)
	event.ObjsNextMotion(4, "そうじゃL", 0)
	helper_42c67f56(2090540)
	if vm.skipping() then
		return skip(97)
	end
	event.CmrsSetPos(76.8, 23.38, -37.04)
	event.CmrsSetRef(35.31, 22.33, -45.08)
	event.ObjsSetPos(3, 22.62, 0.0, -61.38)
	event.SetPakuAnim(2, "口パク")
	helper_42c67f56(2090550)
	if vm.skipping() then
		return skip(98)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(3, "口パク")
	helper_42c67f56(2090560)
	if vm.skipping() then
		return skip(99)
	end
	event.ResetPakuAnim()
	event.CmrsSetPos(81.93, 21.24, -74.02)
	event.CmrsSetRef(90.52, 21.61, -60.68)
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "デフォルト顔")
	event.ObjsTexAnime(1, 1, "目あき～目あきれ")
	event.SndSePlay(var1, 13)
	event.ObjsSetMotion(1, "あきれる", 6)
	event.ObjsNextMotion(1, "座り", 0)
	event.SetPakuAnim(1, "通常口パク")
	helper_42c67f56(2090570)
	if vm.skipping() then
		return skip(100)
	end
	event.ResetPakuAnim()
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "まばたき目パチ")
	event.SndSePlay(var1, 14)
	event.ObjsSetMotion(0, "衝撃", 6)
	event.ObjsSetMotion(0, "衝撃L", 0)
	event.SetPakuAnim(0, "通常口パク")
	helper_42c67f56(2090580)
	if vm.skipping() then
		return skip(101)
	end
	event.ResetPakuAnim()
	event.FadeOutBgm(30)
	event.SetFadeOut(30)
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(102)
	end
	return part2()
end

--- Helper function.
local function helper_17120()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 5 then
			if at <= 1 then
				helper_e5dca676()
			end
			if at <= 2 then
				helper_42c67f56(2090610)
			end
			if at <= 3 then
				helper_42c67f56(2090615)
			end
			if at <= 4 then
				helper_c1c32f84(30)
			end
			if vm.skip_end() then
				return skip(6)
			end
			return part2()
		end
		helper_e3f4()
	end
	function part2()
		event.CancelDramaScene()
		event.SetStatus(1, global0, 256, 0)
		event.SetStatus(1, global1, 256, 0)
		helper_e3f4()
	end
	event.Initialize()
	helper_e8dc()
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "無表情")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.InitDramaScene()
	event.CharaActive(1, global0)
	event.CharaActive(1, global1)
	event.CharaActive(1, 34)
	event.CharaActive(1, 35)
	event.CharaActive(1, 36)
	event.EohSetFrameShow(4, "cube37", 0)
	event.EohSetFrameShow(4, "cube38", 0)
	event.CmrsSetPos(48.97, 32.89, 40.91)
	event.CmrsSetRef(61.89, 18.47, -74.73)
	event.ObjsSetPos(0, 90.21, 0.0, -36.12)
	event.ObjsSetRot(0, 0.0, -2.18, 0.0)
	event.ObjsSetPos(1, 98.27, 0.0, -52.72)
	event.ObjsSetRot(1, 0.0, -1.61, 0.0)
	event.ObjsSetPos(0, 90.21, 0.0, -36.12)
	event.ObjsSetRot(0, 0.0, -2.18, 0.0)
	event.ObjsSetPos(1, 98.27, 0.0, -52.72)
	event.ObjsSetRot(1, 0.0, -1.61, 0.0)
	event.ObjsSetPos(2, 29.51, 0.0, -37.25)
	event.ObjsSetRot(2, 0.0, 2.32, 0.0)
	event.ObjsSetPos(3, 21.3, 0.0, -61.73)
	event.ObjsSetRot(3, 0.0, 1.32, 0.0)
	event.ObjsSetPos(4, 59.82, 0.0, -98.58)
	event.ObjsSetRot(4, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(0, "衝撃L", 4, -1.0, 1)
	event.ObjsSetMotion(1, "座り", 4, -1.0, 1)
	event.ObjsSetMotion(2, "座り", 4)
	event.ObjsSetMotion(3, "座り", 4)
	event.ObjsSetMotion(4, "座り会話2", 4)
	event.CmrsMove2(46.34, 32.89, 64.43, 61.89, 18.47, -74.73, 90, 2, 0.4)
	helper_42c67f56(2090600)
	if vm.skipping() then
		return skip(1)
	end
	helper_e5dca676()
	if vm.skipping() then
		return skip(2)
	end
	event.CmrsSetPos(82.72, 22.53, -61.3)
	event.CmrsSetRef(93.83, 21.33, -34.43)
	event.CmrsMove2(83.31, 22.53, -59.88, 92.29, 21.33, -38.16, 90, 2, 0.4)
	helper_42c67f56(2090610)
	if vm.skipping() then
		return skip(3)
	end
	helper_42c67f56(2090615)
	if vm.skipping() then
		return skip(4)
	end
	event.CmrsInit()
	event.SetFadeOut(30)
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(5)
	end
	return part2()
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 100.
script[100] = function()
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_43cef388()
	flag = event.GetFlag(247) or flag
	if flag == 1 then
		flag = event.GetFlag(250) or flag
		if flag == 0 then
			helper_194b8()
			if vm.skipping() then
				return skip(1)
			end
			event.BgmLoadCancel()
			event.MapJump(-1, "s47", 501)
			if vm.wait() then
				return skip(2)
			end
			return
		end
	end
	event.SetCharaPos(0, 20.0, 19.5, 89.5)
	event.SetCharaRot(0, 0.0, 1.8, 0.0)
	event.SetFadeIn(30)
	event.ResetCamera(1)
end

--- Program 150.
script[150] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_6f70f976(64)
		end
	end
	if vm.wait() then
		return skip(1)
	end
	helper_6f70f976(64)
	if vm.skipping() then
		return skip(2)
	end
end

--- Program 200.
script[200] = function()
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
	end
	print("-----event200--------------------------------------\n")
	flag = event.GetFlag(250) or flag
	if flag == 0 then
		event.MapJump(-1, "g01", 100)
		if vm.wait() then
			return skip(1)
		end
		return
	end
	if vm.wait() then
		return skip(2)
	end
	event.GotoOutside(-1, "g01", 100)
	if vm.wait() then
		return skip(3)
	end
end

--- Program 500.
script[500] = function()
	local var0: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_512cb090()
		end
	end
	helper_3142cade(0)
	var0 = helper_a160afdb(0)
	if vm.skipping() then
		return skip(1)
	end
	helper_512cb090()
	if var0 == 0 then
		event.GotoInterior(-1, "i01h01")
		if vm.wait() then
			return skip(2)
		end
	end
end

--- Program 501.
script[501] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_c1c32f84(30)
		end
	end
	helper_105ec()
	if vm.skipping() then
		return skip(1)
	end
	event.SetFadeOut(30)
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(2)
	end
	event.BgmPlayCancel()
	event.MapJump(-1, "s46", 501)
	if vm.wait() then
		return skip(3)
	end
end

--- Program 502.
script[502] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_17120()
	if vm.skipping() then
		return skip(1)
	end
	event.BgmLoadCancel()
	event.MapJump(-1, "s02", 502)
	if vm.wait() then
		return skip(2)
	end
end

--- Program 610.
script[610] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_105ec()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 611.
script[611] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_17120()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 620.
script[620] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_194b8()
	if vm.skipping() then
		return skip(1)
	end
	event.SetFadeIn(30)
end

--- Program 1000.
script[1000] = function()
	local var0: s32 = 0
	local player_chara: s32 = 0
	local var2: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_daa89e49(0, -1, var0, player_chara, 0)
		end
		if at <= 2 then
			helper_daa89e49(0, -1, var0, player_chara, 0)
		end
	end
	var0 = event.GetEventData_2(13) or var0
	player_chara = event.GetControlChrid() or player_chara
	do
		local out1, _, out3 = event.GetCharaPos(player_chara)
		var2 = out1 or var2
		var4 = out3 or var4
	end
	do
		local out1, _, out3 = event.GetCharaPos(var0)
		var5 = out1 or var5
		var7 = out3 or var7
	end
	var8 = event.GetRotLookPos(var5 - var2, var7 - var4) or var8
	helper_99a9b842(player_chara, var8)
	if vm.skipping() then
		return skip(1)
	end
	event.SetCharaRot(player_chara, 0.0, var8, 0.0)
	event.SetMotion(player_chara, "立ち")
	event.SetMesShippo(0, 1)
	event.SetMesPreset(0, 0)
	event.MesMake_2(0, "Bonjouuuur.\nBeau temps, non ?")
	if var0 == 8 then
		event.MesMake_2(
			0,
			"[UNI00c9]coutez. Veillez surtout [UNI00e0] ne pas\nvous trouver nez [UNI00e0] nez avec ce\nsatan[UNI00e9] Papillon arc-en-ciel OK ?<page>Et si [UNI00e7]a arrive, faites comme\nsi vous l'aviez pas vu, d'accord ?"
		)
		helper_daa89e49(0, -1, var0, player_chara, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.MesMake_2(
			0,
			"Si vous l'apercevez juste du coin\nde l'[UNI0153]il, [UNI00e7]a devrait aller si\nvous faites mine de n'avoir rien<page>vu. Enfin, peut-[UNI00ea]tre..."
		)
	end
	if var0 == 9 then
		event.MesMake_2(
			0,
			"Mmmhhh, je grignoterais bien une\ntarte aux pommes de Holly avec\nun verre de jus de raisin, [UNI00e7]a oui !"
		)
	end
	if var0 == 10 then
		event.MesMake_2(
			0,
			"Holly nous a abandonn[UNI00e9]s et nos\nquatre amis ne sont pas rentr[UNI00e9]s.<page>Je ne supporterais pas de perdre\nqui que ce soit d'autre."
		)
	end
	helper_daa89e49(0, -1, var0, player_chara, 0)
	if vm.skipping() then
		return skip(3)
	end
end

--- Program 12500.
script[12500] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_194b8()
	if vm.skipping() then
		return skip(1)
	end
	event.BgmLoadCancel()
	event.MapJump(-1, "s47", 501)
	if vm.wait() then
		return skip(2)
	end
end

return script
