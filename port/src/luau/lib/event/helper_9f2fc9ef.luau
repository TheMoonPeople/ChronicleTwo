--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_184013af = require("@lib/event/helper_184013af")
local helper_57ae27b6 = require("@lib/event/helper_57ae27b6")
local helper_6c719c99 = require("@lib/event/helper_6c719c99")
local helper_8f31f334 = require("@lib/event/helper_8f31f334")
local helper_aafd6a80 = require("@lib/event/helper_aafd6a80")
local helper_f37e8af2 = require("@lib/event/helper_f37e8af2")

--- Helper function.
local function helper_9f2fc9ef()
	local active_chr_no: s32 = 0
	local var1: s32 = 0
	local block: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 24 then
			if at <= 1 then
				helper_aafd6a80(70)
			end
			if at <= 2 then
				helper_6c719c99(8080010)
			end
			if at <= 3 then
				helper_6c719c99(8080020)
			end
			if at <= 4 then
				helper_6c719c99(8080030)
			end
			if at <= 5 then
				helper_8f31f334(0)
			end
			if at <= 6 then
				helper_8f31f334(1)
			end
			if at <= 7 then
				helper_184013af()
			end
			if at <= 8 then
				helper_8f31f334(2)
			end
			if at <= 9 then
				helper_6c719c99(8080040)
			end
			if at <= 10 then
				helper_6c719c99(8080045)
			end
			if at <= 11 then
				helper_6c719c99(8080050)
			end
			if at <= 12 then
				helper_6c719c99(8080060)
			end
			if at <= 13 then
				helper_6c719c99(8080070)
			end
			if at <= 14 then
				helper_6c719c99(8080075)
			end
			if at <= 15 then
				helper_8f31f334(2)
			end
			if at <= 16 then
				helper_6c719c99(8080080)
			end
			if at <= 17 then
				helper_6c719c99(8080090)
			end
			if at <= 18 then
				helper_57ae27b6(1)
			end
			if at <= 19 then
				helper_f37e8af2(0, 180)
			end
			if at <= 20 then
				helper_aafd6a80(10)
			end
			if at <= 21 then
				helper_aafd6a80(50)
			end
			if at <= 22 then
				helper_aafd6a80(21)
			end
			if at <= 23 then
				helper_aafd6a80(3)
			end
			if vm.skip_end() then
				return skip(25)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SndSeStop(var1, 0)
		event.SndSeStop(var1, 1)
		event.SndSeStop(var1, 2)
		event.SndSeStop(var1, 3)
		event.SpriteSetDraw(0, 0)
		event.SetMotionBlur(0)
		event.SetStatus(1, 0, 256, 0)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.DelExtMotion(0)
		event.DeleteChara(8)
		event.DeleteChara(9)
		event.DeleteChara(10)
		event.DeleteChara(11)
		event.DeleteChara(12)
		event.DelImg(0)
		event.LoadMes(0, -1)
		event.PlayBgm(0)
		event.SetStatusbarShow(1, 1.0)
		event.SetCharaShow(1, 1)
		event.SetCharaShow(2, 1)
		event.Finish()
	end
	event.SetFlag(808, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.SetStatusbarShow(0, 1.0)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.StopBgm(0)
	helper_aafd6a80(6)
	if vm.skipping() then
		return skip(1)
	end
	event.LoadBgm(107)
	event.LoadSound(8803)
	var1 = event.SndLoadSound(8803) or var1
	event.SetStatus(1, 0, 256, 1)
	event.ChangeDir("event/e800/e808/")
	event.LoadMes(0, 5, "e808_1.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e808_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e808_monica.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.LoadChara(5, "e808_m_polcurse.gltf", "info", 10)
	event.CharaActive(10)
	event.EohSyncChara(2, 10)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.LoadChara(5, "e808_mp_jet.gltf", "info", 11)
	event.CharaActive(11)
	event.SetReference(10, "jet_l", 11)
	event.CopyChara(5, 11, 12)
	event.CharaActive(12)
	event.SetReference(10, "jet_r", 12)
	block = event.LoadImg_4(5, "e808telop01_1.json", 0) or block
	event.SpriteInit(0)
	event.SpriteSetType(0, 0)
	event.SpriteSetTexture(0, "e808telop01", block)
	event.SpriteSetColor(0, 128, 128, 128, 0)
	event.SpriteSetUvsize(0, 0, 0, 512, 128)
	event.SpriteSetPutsize(0, 512, 128)
	event.SpriteSetPos(0, 256, 312)
	event.SpriteSetAlphab(0, 0)
	event.SpriteSetDraw(0, 0)
	event.EohSyncSprite(3, 0)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.ChangeDir("")
	if active_chr_no == 1 then
		event.LoadChara(5, "chara/c01_base.gltf", "info", 8)
		event.LoadEquip(5, 0, 4, "info", 8)
		event.LoadEquip(5, 0, 3, "info", 8)
		event.LoadEquip(5, 0, 2, "info", 8, 9)
		event.LoadMotion(5, "event/e800/e808/e808_mints.gltf", "info", 8)
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
		event.LoadMotion(5, "event/e800/e808/e808_monica.gltf", "info", 8)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 8)
		event.EohSyncChara(1, 8)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 0)
	end
	event.CharaActive(8)
	event.CharaActive(9)
	event.SetCharaShow(1, 0)
	event.SetCharaShow(2, 0)
	event.EohSetPos(0, -10.0, 0.0, 0.0)
	event.EohSetRot(0, 0.0, 0.0, 0.0)
	event.EohSetMotion(0, "立ち", 4)
	event.EohSetFootSoundId(0, 16)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "無表情")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	event.EohSetPos(1, 10.0, 0.0, 0.0)
	event.EohSetRot(1, 0.0, 0.0, 0.0)
	event.EohSetMotion(1, "立ち", 4)
	event.EohSetFootSoundId(1, 16)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "無表情")
	event.EohSetTexAnim(1, 1, "通常目パチ")
	event.EohSetPos(2, 0.0, 1200.0, 1200.0)
	event.EohSetRot(2, 0.0, 3.14, 0.0)
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "デフォルト顔")
	event.EohSetTexAnim(2, 1, "通常目パチ")
	event.SetStatus(1, 10, 8)
	event.InitDramaScene()
	event.ObjsMove(0, -10.0, 0.0, 100.0, 100)
	event.ObjsSetMotion(0, "歩き", 4)
	event.ObjsMotionDelay(0, 100)
	event.ObjsSetMotion(0, "立ち")
	event.ObjsMove(1, 10.0, 0.0, 100.0, 100)
	event.ObjsSetMotion(1, "歩き", 4)
	event.ObjsMotionDelay(1, 100)
	event.ObjsSetMotion(1, "立ち")
	event.CmrsInit()
	event.CmrsSetPos(-144.53, 162.53, 269.71)
	event.CmrsSetRef(9.57, 6.12, 32.98)
	event.SetFadeIn(30)
	helper_aafd6a80(70)
	if vm.skipping() then
		return skip(2)
	end
	event.CmrsSetPos(0.0, 20.0, 60.0)
	event.CmrsSetRef(0.0, 20.0, 100.0)
	event.SetPakuAnim(2, "通常口パク")
	helper_6c719c99(8080010)
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsSetMotion(0, "上向く", 6)
	event.ObjsNextMotion(0, "上向くL", 4)
	event.ObjsMotionDelay(1, 10)
	event.ObjsSetMotion(1, "上向く", 6)
	event.ObjsNextMotion(1, "上向くL", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_6c719c99(8080020)
	if vm.skipping() then
		return skip(4)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_6c719c99(8080030)
	if vm.skipping() then
		return skip(5)
	end
	helper_8f31f334(0)
	if vm.skipping() then
		return skip(6)
	end
	helper_8f31f334(1)
	if vm.skipping() then
		return skip(7)
	end
	event.SndSePlay(var1, 0)
	event.PlayBgm(0)
	event.CmrsMove2(0.0, 55.07, 16.58, 0.0, 132.31, 102.11, 60, 0, 0.4)
	event.ObjsSetRot(2, 0.8, 3.14, 0.0)
	event.ObjsMove2(2, 0.0, 70.0, 80.0, 100, 2, 0.1)
	event.ObjsSetMotion(2, "飛びループ", 4)
	event.ObjsMotionDelay(2, 86)
	event.ObjsSetMotion(2, "体返す", 2)
	event.ObjsNextMotion(2, "体返すＬ", 4)
	helper_184013af()
	if vm.skipping() then
		return skip(8)
	end
	helper_8f31f334(2)
	if vm.skipping() then
		return skip(9)
	end
	event.SndSeStop(var1, 0)
	event.ObjsSetRot(0, 0.0, 0.12, 0.0)
	event.ObjsSetRot(1, 0.0, -0.12, 0.0)
	event.SetPakuMotion(2, "体返す会話", 4, "体返すＬ", 0)
	event.SetPakuAnim(2, "通常口パク")
	helper_6c719c99(8080040)
	if vm.skipping() then
		return skip(10)
	end
	event.SetPakuMotion(2, "体返す会話", 0, "体返すＬ", 0)
	event.SetPakuAnim(2, "通常口パク")
	helper_6c719c99(8080045)
	if vm.skipping() then
		return skip(11)
	end
	event.CmrsSetPos(-2.41, 61.81, 165.8)
	event.CmrsSetRef(0.11, 17.53, 101.88)
	event.SetPakuAnim(0, "通常口パク")
	helper_6c719c99(8080050)
	if vm.skipping() then
		return skip(12)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_6c719c99(8080060)
	if vm.skipping() then
		return skip(13)
	end
	event.CmrsSetPos(0.0, 104.52, 45.06)
	event.CmrsSetRef(0.0, 124.09, 102.11)
	event.ObjsSetRot(2, 0.0, 3.14, 0.0)
	event.ObjsSetMotion(2, "浮遊立ち会話", 4)
	event.SetPakuMotion(2, "浮遊立ち会話", 4, "浮遊立ち", 0)
	event.SetPakuAnim(2, "わらい口パク")
	helper_6c719c99(8080070)
	if vm.skipping() then
		return skip(14)
	end
	event.SetPakuMotion(2, "浮遊立ち会話", 0, "浮遊立ち", 0)
	event.SetPakuAnim(2, "わらい口パク")
	helper_6c719c99(8080075)
	if vm.skipping() then
		return skip(15)
	end
	helper_8f31f334(2)
	if vm.skipping() then
		return skip(16)
	end
	event.SndSePlay(var1, 1)
	event.ObjsSetMotion(2, "オーホホホ", 2)
	event.ObjsNextMotion(2, "オーホホホＬ", 4)
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "通常目～高笑い")
	event.SetPakuAnim(2, "わらい口パク")
	helper_6c719c99(8080080)
	if vm.skipping() then
		return skip(17)
	end
	event.CmrsSetPos(-29.09, 25.94, 131.55)
	event.CmrsSetRef(5.81, 19.33, 91.49)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "いぶかしげ顔")
	event.EohSetTexAnim(0, 1, "いぶかしげ目パチ")
	event.SetPakuAnim(0, "通常口パク")
	helper_6c719c99(8080090)
	if vm.skipping() then
		return skip(18)
	end
	event.CmrsSetPos(0.5, 125.0, 60.0)
	event.CmrsSetRef(0.5, 125.0, 92.0)
	event.CmrsMove2(0.5, 115.0, 20.0, 0.5, 115.0, 92.0, 40, 2, 0.2)
	event.SndSePlay(var1, 2)
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "おこり顔")
	event.EohSetTexAnim(2, 1, "おこり目パチ")
	event.ObjsSetMotion(2, "ポーズ", 6)
	event.ObjsNextMotion(2, "ポーズＬ", 4)
	event.SpriteSetDraw(0, 1)
	event.ObjsSetColor(3, 128, 128, 128, 128, 30)
	event.SetPakuAnim(2, "通常口パク")
	event.StreamOpen3(1, 8080100)
	helper_57ae27b6(1)
	if vm.skipping() then
		return skip(19)
	end
	event.StreamPlay(1)
	helper_f37e8af2(0, 180)
	if vm.skipping() then
		return skip(20)
	end
	event.StreamClose(1)
	event.SndSePlay(var1, 3)
	event.ObjsSetColor(3, 128, 128, 128, 0, 10)
	event.ObjsSetMotion(2, "ゴゴゴゴ", 6)
	event.ObjsNextMotion(2, "ゴゴゴゴＬ", 6)
	event.ObjsNextMotion(2, "カメラに向かう", 6)
	event.ObjsNextMotion(2, "飛びループ", 4)
	event.ObjsRotDelay(2, 30)
	event.ObjsRotation(2, 0.2, 3.14, 0.0, 40)
	event.ObjsPosDelay(2, 64)
	event.ObjsMove(2, 0.0, 66.0, 0.0, 20)
	event.CmrsMove2(0.0, 90.93, -24.95, 0.0, 108.12, 88.77, 40, 0, 0.4)
	helper_aafd6a80(10)
	if vm.skipping() then
		return skip(21)
	end
	event.SpriteSetDraw(0, 0)
	helper_aafd6a80(50)
	if vm.skipping() then
		return skip(22)
	end
	event.EohSetTexAnim(2, 1, "歯くいしばり")
	event.SetMotionBlur(64)
	helper_aafd6a80(21)
	if vm.skipping() then
		return skip(23)
	end
	event.SetFadeOut(3)
	helper_aafd6a80(3)
	if vm.skipping() then
		return skip(24)
	end
	return part2()
end

return helper_9f2fc9ef
