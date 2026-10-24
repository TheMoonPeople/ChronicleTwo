--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_184013af = require("@lib/event/helper_184013af")
local helper_6c719c99 = require("@lib/event/helper_6c719c99")
local helper_8f31f334 = require("@lib/event/helper_8f31f334")
local helper_aafd6a80 = require("@lib/event/helper_aafd6a80")

--- Helper function.
local function helper_b94a98b1()
	local active_chr_no: s32 = 0
	local var1: s32 = 0
	local block: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 29 then
			if at <= 1 then
				helper_aafd6a80(130)
			end
			if at <= 2 then
				helper_aafd6a80(10)
			end
			if at <= 4 then
				helper_8f31f334(0)
			end
			if at <= 5 then
				helper_aafd6a80(6)
			end
			if at <= 6 then
				helper_6c719c99(7000020)
			end
			if at <= 7 then
				helper_6c719c99(7000030)
			end
			if at <= 8 then
				helper_8f31f334(1)
			end
			if at <= 9 then
				helper_aafd6a80(110)
			end
			if at <= 10 then
				helper_8f31f334(2)
			end
			if at <= 11 then
				helper_aafd6a80(90)
			end
			if at <= 12 then
				helper_8f31f334(2)
			end
			if at <= 13 then
				helper_aafd6a80(40)
			end
			if at <= 14 then
				helper_184013af()
			end
			if at <= 15 then
				helper_6c719c99(7000040)
			end
			if at <= 16 then
				helper_6c719c99(7000050)
			end
			if at <= 17 then
				helper_6c719c99(7000060)
			end
			if at <= 18 then
				helper_6c719c99(7000070)
			end
			if at <= 19 then
				helper_6c719c99(7000080)
			end
			if at <= 20 then
				helper_6c719c99(7000090)
			end
			if at <= 21 then
				helper_6c719c99(7000095)
			end
			if at <= 22 then
				helper_6c719c99(7000100)
			end
			if at <= 23 then
				helper_6c719c99(7000110)
			end
			if at <= 24 then
				helper_6c719c99(7000120)
			end
			if at <= 25 then
				helper_6c719c99(7000125)
			end
			if at <= 26 then
				helper_6c719c99(7000130)
			end
			if at <= 27 then
				helper_8f31f334(2)
			end
			if at <= 28 then
				helper_aafd6a80(4)
			end
			if vm.skip_end() then
				return skip(30)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SetCrossfade(60)
		event.FuncPointShow("", "e700_light", 0)
		event.SetStatus(1, 0, 256, 0)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.SpriteSetDraw(0, 0)
		event.DelExtMotion(0)
		event.DeleteChara(32)
		event.DeleteChara(33)
		event.DeleteChara(34)
		event.DeleteChara(35)
		event.DelImg(0)
		event.LoadMes(0, -1)
	end
	event.SetFlag(700, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.StopBgm(0)
	event.LoadSound(7203)
	var1 = event.SndLoadSound(7203) or var1
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
	event.CharaActive(0, 34)
	event.EohSyncChara(2, 34)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.LoadChara(5, "e700_a_hikari.gltf", "info", 35)
	event.CharaActive(0, 35)
	event.EohSyncChara(3, 35)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	block = event.LoadImg_4(5, "e700.json", 0) or block
	event.SpriteInit(0)
	event.SpriteSetType(0, 0)
	event.SpriteSetTexture(0, "e70001", block)
	event.SpriteSetColor(0, 128, 128, 128, 128)
	event.SpriteSetUvsize(0, 0, 0, 512, 448)
	event.SpriteSetPutsize(0, 512, 448)
	event.SpriteSetPos(0, 256, 224)
	event.SpriteSetAlphab(0, 0)
	event.SpriteSetDraw(0, 0)
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
	event.EohSyncFuncp(4, "", "e700_light")
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.EohSetPos(0, 8.0, 0.0, 2200.0)
	event.EohSetRot(0, 0.0, 3.14, 0.0)
	event.EohSetMotion(0, "歩き", 4)
	event.EohSetFootSoundId(0, 16)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "おこり顔")
	event.EohSetTexAnim(0, 1, "おこり目パチ")
	event.EohSetPos(1, -8.0, 0.0, 2200.0)
	event.EohSetRot(1, 0.0, 3.14, 0.0)
	event.EohSetMotion(1, "歩き", 4)
	event.EohSetFootSoundId(1, 16)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "おこり顔")
	event.EohSetTexAnim(1, 1, "おこり目パチ")
	event.EohSetPos(2, 0.0, 150.0, 960.0)
	event.EohSetRot(2, 0.0, 0.0, 0.0)
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "デフォルト顔")
	event.EohSetTexAnim(2, 1, "目とじ")
	event.EohSetPos(3, 0.0, 170.0, 960.0)
	event.EohSetRot(3, 0.0, 0.0, 0.0)
	event.EohSetPos(4, 0.0, 170.0, 960.0)
	event.ObjsMove(0, 8.0, 0.0, 2120, 80)
	event.ObjsMove(1, -8.0, 0.0, 2120, 80)
	event.CmrsInit()
	event.CmrsSetPos(0.0, 20.0, 2100.0)
	event.CmrsSetRef(0.0, 20.0, 2200.0)
	event.SetFadeIn(30)
	helper_8f31f334(0)
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsSetPos(0.0, 87.46, 2196.95)
	event.CmrsSetRef(0.0, 32.09, 2006.78)
	event.CmrsMove2(0.0, 9.53, 2097.37, 0.0, 32.09, 2006.78, 120, 2, 0.2)
	event.ObjsMove(0, 7.0, 0.0, 2000.0, 140)
	event.ObjsMotionDelay(0, 140)
	event.ObjsSetMotion(0, "立ち", 4)
	event.ObjsMove(1, -7.0, 0.0, 2000.0, 140)
	event.ObjsMotionDelay(1, 140)
	event.ObjsSetMotion(1, "立ち", 4)
	helper_aafd6a80(130)
	if vm.skipping() then
		return skip(2)
	end
	event.SetFadeOut(10)
	helper_aafd6a80(10)
	if vm.skipping() then
		return skip(3)
	end
	event.SoundAllStop()
	event.SndInReverb(0)
	event.GotoDrawChapter(7)
	if vm.wait() then
		return skip(4)
	end
	event.SndInReverb(1)
	event.CmrsSetPos(22.7, 24.08, 957.3)
	event.CmrsSetRef(-2.24, 21.49, 1005.71)
	event.LoadBgm(6)
	event.PlayBgm(0)
	event.InitDramaScene()
	event.SetFadeIn(20)
	event.ObjsSetPos(0, 7.0, 0.0, 1016.0)
	event.ObjsMove(0, 7.0, 0.0, 1000.0, 20)
	event.ObjsSetMotion(0, "歩き", 4, -1.0, 1)
	event.ObjsMotionDelay(0, 20)
	event.ObjsSetMotion(0, "立ち")
	event.ObjsSetPos(1, -7.0, 0.0, 1018.0)
	event.ObjsMove(1, -7.0, 0.0, 998.0, 26)
	event.ObjsSetMotion(1, "歩き", 4, -1.0, 1)
	event.ObjsMotionDelay(1, 26)
	event.ObjsSetMotion(1, "立ち")
	helper_8f31f334(0)
	if vm.skipping() then
		return skip(5)
	end
	helper_aafd6a80(6)
	if vm.skipping() then
		return skip(6)
	end
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "おこり顔")
	event.EohSetTexAnim(0, 1, "まばたき目パチ")
	event.ObjsSetMotion(0, "上向く", 6)
	event.ObjsNextMotion(0, "上向くL", 4)
	event.ObjsMotionDelay(1, 10)
	event.ObjsSetMotion(1, "上向く", 6)
	event.ObjsNextMotion(1, "上向くL", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_6c719c99(7000020)
	if vm.skipping() then
		return skip(7)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_6c719c99(7000030)
	if vm.skipping() then
		return skip(8)
	end
	helper_8f31f334(1)
	if vm.skipping() then
		return skip(9)
	end
	event.CmrsSetPos(0.0, 72.76, 1200.51)
	event.CmrsSetRef(0.0, 22.72, 1005.7)
	event.CmrsMove2(0.0, 72.76, 1200.51, 0.0, 55.04, 1005.7, 60, 2, 1.0)
	event.CharaActive(1, 34)
	event.CharaActive(1, 35)
	event.ObjsSetMotion(3, "登場", 4)
	event.FuncPointShow("", "e700_light", 1)
	event.ObjsMove(2, 0.0, 70.0, 960.0, 120)
	event.ObjsMove(3, 0.0, 90.0, 960.0, 120)
	event.ObjsMove(4, 0.0, 90.0, 960.0, 120)
	event.ObjsSeDelay(2, 50)
	event.ObjsSePlay(2, var1, 0)
	helper_aafd6a80(110)
	if vm.skipping() then
		return skip(10)
	end
	helper_8f31f334(2)
	if vm.skipping() then
		return skip(11)
	end
	event.CmrsSetPos(39.56, 22.59, 956.15)
	event.CmrsSetRef(-2.02, 13.89, 997.54)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "おこり顔")
	event.EohSetTexAnim(0, 1, "おこり目パチ")
	event.EohSetTexAnim(0, 1, "半口")
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "おこり顔")
	event.EohSetTexAnim(1, 1, "おこり目パチ")
	event.EohSetTexAnim(1, 1, "半口")
	event.ObjsMove2(2, 0.0, 20.0, 960.0, 90, 2, 0.5)
	event.ObjsMove2(3, 0.0, 40.0, 960.0, 90, 2, 0.5)
	event.ObjsMove2(4, 0.0, 40.0, 960.0, 90, 2, 0.5)
	helper_aafd6a80(90)
	if vm.skipping() then
		return skip(12)
	end
	event.CmrsSetPos(0.0, 22.59, 1078.28)
	event.CmrsSetRef(0.0, 24.19, 997.19)
	helper_8f31f334(2)
	if vm.skipping() then
		return skip(13)
	end
	event.ObjsSetMotion(3, "出現", 2)
	event.ObjsNextMotion(3, "後光", 4)
	helper_aafd6a80(40)
	if vm.skipping() then
		return skip(14)
	end
	event.CmrsSetPos(0.0, 41.57, 992.39)
	event.CmrsSetRef(0.0, 24.71, 935.78)
	event.CmrsMove2(0.0, 48.71, 992.39, 0.0, 48.68, 935.78, 90, 2, 0.6)
	helper_184013af()
	if vm.skipping() then
		return skip(15)
	end
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "デフォルト顔")
	event.EohSetTexAnim(2, 1, "目とじ～目あけ")
	event.SetPakuAnim(2, "通常口パク")
	helper_6c719c99(7000040)
	if vm.skipping() then
		return skip(16)
	end
	event.CmrsSetPos(14.56, 51.58, 960.44)
	event.CmrsSetRef(-1.24, 13.9, 1001.7)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "無表情")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "無表情")
	event.EohSetTexAnim(1, 1, "通常目パチ")
	event.CharaActive(0, 35)
	event.SetPakuAnim(1, "通常口パク")
	helper_6c719c99(7000050)
	if vm.skipping() then
		return skip(17)
	end
	event.CmrsSetPos(0.0, 17.98, 1052.41)
	event.CmrsSetRef(0.0, 26.48, 1001.7)
	event.CharaActive(1, 35)
	event.SetPakuAnim(2, "しんけん口パク")
	helper_6c719c99(7000060)
	if vm.skipping() then
		return skip(18)
	end
	event.CmrsSetPos(14.56, 51.58, 960.44)
	event.CmrsSetRef(-1.24, 13.9, 1001.7)
	event.CharaActive(0, 35)
	event.SetPakuAnim(1, "通常口パク")
	helper_6c719c99(7000070)
	if vm.skipping() then
		return skip(19)
	end
	event.SetPakuAnim(0, "通常口パク")
	helper_6c719c99(7000080)
	if vm.skipping() then
		return skip(20)
	end
	event.CmrsSetPos(0.0, 48.71, 992.39)
	event.CmrsSetRef(0.0, 48.68, 935.78)
	event.CharaActive(1, 35)
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "しんけん顔")
	event.EohSetTexAnim(2, 1, "目あき～目とじ")
	event.ObjsSetMotion(2, "うつむく", 2)
	event.ObjsNextMotion(2, "うつむくＬ", 4)
	event.SetPakuAnim(2, "しんけん口パク")
	helper_6c719c99(7000090)
	if vm.skipping() then
		return skip(21)
	end
	event.SetPakuAnim(2, "しんけん口パク")
	helper_6c719c99(7000095)
	if vm.skipping() then
		return skip(22)
	end
	event.CmrsSetPos(14.56, 51.58, 960.44)
	event.CmrsSetRef(-1.24, 13.9, 1001.7)
	event.CharaActive(0, 35)
	event.SetPakuAnim(1, "通常口パク")
	helper_6c719c99(7000100)
	if vm.skipping() then
		return skip(23)
	end
	event.CmrsSetPos(0.0, 17.98, 1052.41)
	event.CmrsSetRef(0.0, 26.48, 1001.7)
	event.CharaActive(1, 35)
	event.SetPakuAnim(2, "しんけん口パク")
	helper_6c719c99(7000110)
	if vm.skipping() then
		return skip(24)
	end
	event.SetPakuAnim(2, "しんけん口パク")
	helper_6c719c99(7000120)
	if vm.skipping() then
		return skip(25)
	end
	event.SetPakuAnim(2, "しんけん口パク")
	helper_6c719c99(7000125)
	if vm.skipping() then
		return skip(26)
	end
	event.CmrsSetPos(0.0, 48.71, 992.39)
	event.CmrsSetRef(0.0, 48.68, 935.78)
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "しんけん顔")
	event.EohSetTexAnim(2, 1, "目とじ～目あけ２")
	event.ObjsSetMotion(2, "うつむく戻り", 6)
	event.ObjsNextMotion(2, "浮遊立ち", 4)
	event.SetPakuAnim(2, "しんけん口パク")
	helper_6c719c99(7000130)
	if vm.skipping() then
		return skip(27)
	end
	event.CmrsSetPos(31.07, 49.02, 853.79)
	event.CmrsSetRef(-33.5, 41.8, 1000.7)
	event.ObjsSetPos(2, 0.0, 20.0, 900.0)
	event.ObjsSetPos(3, 0.0, 40.0, 896.0)
	event.ObjsSetPos(4, 0.0, 40.0, 896.0)
	event.ObjsSetMotion(2, "両手開く", 6)
	event.ObjsNextMotion(2, "両手開くＬ", 4)
	helper_8f31f334(2)
	if vm.skipping() then
		return skip(28)
	end
	event.SndSePlay(var1, 1)
	event.SpriteSetDraw(0, 1)
	event.SetCrossfade(4)
	helper_aafd6a80(4)
	if vm.skipping() then
		return skip(29)
	end
	return part2()
end

return helper_b94a98b1
