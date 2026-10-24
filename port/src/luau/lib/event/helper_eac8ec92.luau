--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_401221ed = require("@lib/event/helper_401221ed")
local helper_4d6fefb8 = require("@lib/event/helper_4d6fefb8")
local helper_5c88e2f9 = require("@lib/event/helper_5c88e2f9")
local helper_bc115506 = require("@lib/event/helper_bc115506")
local helper_c85a55f2 = require("@lib/event/helper_c85a55f2")
local helper_e5871cb4 = require("@lib/event/helper_e5871cb4")

--- Helper function.
local function helper_eac8ec92()
	local active_chr_no: s32 = 0
	local var1: s32 = 0
	local block: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 60 then
			if at <= 1 then
				active_chr_no = 0
				helper_c85a55f2(4)
			end
			if at <= 2 then
				helper_bc115506(5320010)
			end
			if at <= 3 then
				helper_c85a55f2(40)
			end
			if at <= 4 then
				helper_5c88e2f9(2)
			end
			if at <= 5 then
				helper_bc115506(5320020)
			end
			if at <= 6 then
				helper_bc115506(5320030)
			end
			if at <= 7 then
				helper_bc115506(5320040)
			end
			if at <= 8 then
				helper_bc115506(5320045)
			end
			if at <= 9 then
				helper_bc115506(5320050)
			end
			if at <= 10 then
				helper_4d6fefb8()
			end
			if at <= 11 then
				helper_bc115506(5320060)
			end
			if at <= 12 then
				helper_bc115506(5320065)
			end
			if at <= 13 then
				helper_bc115506(5320070)
			end
			if at <= 14 then
				helper_bc115506(5320080)
			end
			if at <= 15 then
				helper_c85a55f2(30)
			end
			if at <= 16 then
				helper_c85a55f2(15)
			end
			if at <= 17 then
				helper_5c88e2f9(1)
			end
			if at <= 18 then
				helper_c85a55f2(20)
			end
			if at <= 19 then
				helper_bc115506(5320090)
			end
			if at <= 20 then
				helper_e5871cb4(5320100, 40)
			end
			if at <= 21 then
				helper_c85a55f2(5)
			end
			if at <= 22 then
				helper_e5871cb4(5320110, 20)
			end
			if at <= 23 then
				helper_c85a55f2(5)
			end
			if at <= 24 then
				helper_e5871cb4(5320120, 40)
			end
			if at <= 25 then
				helper_5c88e2f9(1)
			end
			if at <= 26 then
				helper_bc115506(5320130)
			end
			if at <= 27 then
				helper_5c88e2f9(0)
			end
			if at <= 28 then
				helper_5c88e2f9(1)
			end
			if at <= 29 then
				helper_c85a55f2(20)
			end
			if at <= 30 then
				helper_bc115506(5320140)
			end
			if at <= 31 then
				helper_5c88e2f9(2)
			end
			if at <= 32 then
				helper_401221ed(5320150, -1, 10)
			end
			if at <= 33 then
				helper_bc115506(5320155)
			end
			if at <= 34 then
				helper_5c88e2f9(2)
			end
			if at <= 35 then
				helper_bc115506(5320160)
			end
			if at <= 36 then
				helper_5c88e2f9(1)
			end
			if at <= 37 then
				helper_c85a55f2(40)
			end
			if at <= 38 then
				helper_bc115506(5320170)
			end
			if at <= 39 then
				helper_4d6fefb8()
			end
			if at <= 40 then
				helper_bc115506(5320180)
			end
			if at <= 41 then
				helper_bc115506(5320190)
			end
			if at <= 42 then
				helper_bc115506(5320200)
			end
			if at <= 43 then
				helper_5c88e2f9(3)
			end
			if at <= 44 then
				helper_bc115506(5320210)
			end
			if at <= 45 then
				helper_bc115506(5320220)
			end
			if at <= 46 then
				helper_5c88e2f9(4)
			end
			if at <= 47 then
				helper_bc115506(5320225)
			end
			if at <= 48 then
				helper_5c88e2f9(5)
			end
			if at <= 49 then
				helper_bc115506(5320230)
			end
			if at <= 50 then
				helper_bc115506(5320240)
			end
			if at <= 51 then
				helper_5c88e2f9(6)
			end
			if at <= 52 then
				helper_bc115506(5320250)
			end
			if at <= 53 then
				helper_bc115506(5320260)
			end
			if at <= 54 then
				helper_5c88e2f9(7)
			end
			if at <= 55 then
				helper_bc115506(5320270)
			end
			if at <= 56 then
				helper_5c88e2f9(7)
			end
			if at <= 57 then
				helper_bc115506(5320275)
			end
			if vm.skip_end() then
				return skip(61)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SetCrossfade(60)
		event.PlayBgm(0)
		event.SetStatus(1, 0, 256, 0)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.SpriteSetDraw(0, 0)
		event.SpriteSetDraw(1, 0)
		event.SpriteSetDraw(2, 0)
		event.SpriteSetDraw(3, 0)
		event.SpriteSetDraw(4, 0)
		event.DelExtMotion(0)
		event.DeleteChara(8)
		event.DeleteChara(9)
		event.DeleteChara(10)
		event.DeleteChara(11)
		event.DeleteChara(12)
		event.DeleteChara(14)
		event.DelImg(0)
		event.LoadMes(0, -1)
		event.CmrsInit()
		event.SetStatusbarShow(1, 1.0)
		event.EohSetShow(3, 1)
		event.EohSetShow(4, 1)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFlag(532, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.SetStatusbarShow(0, 1.0)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no ~= 0 then
		event.DngSetupMainUnit(0)
		active_chr_no = 0
	end
	event.StopBgm(0)
	helper_c85a55f2(4)
	if vm.skipping() then
		return skip(2)
	end
	event.LoadBgm(113)
	event.LoadSound(5820)
	var1 = event.SndLoadSound(5820) or var1
	event.SetStatus(1, 0, 256, 1)
	event.ChangeDir("event/e500/e532/")
	event.LoadMes(0, 5, "e532_1.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e532_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e532_monica.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.LoadChara(5, "e532_guiltoni.gltf", "info", 11)
	event.CharaActive(11)
	event.EohSyncChara(2, 11)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.LoadChara(5, "shuchusen.gltf", "info", 12)
	event.CharaActive(0, 12)
	event.LoadChara(5, "e532_syougeki.gltf", "info", 14)
	event.CharaActive(0, 14)
	event.EohSyncChara(11, 14)
	event.ObjsInit(9)
	event.ObjsSyncObj(9, 11)
	block = event.LoadImg_4(5, "e532.json", 0) or block
	event.SpriteInit(0)
	event.SpriteSetType(0, 0)
	event.SpriteSetTexture(0, "e53201", block)
	event.SpriteSetColor(0, 128, 128, 128, 0)
	event.SpriteSetUvsize(0, 0, 0, 512, 448)
	event.SpriteSetPutsize(0, 512, 448)
	event.SpriteSetPos(0, 256, 224)
	event.SpriteSetDraw(0, 1)
	event.EohSyncSprite(5, 0)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 5)
	event.SpriteInit(1)
	event.SpriteSetType(1, 0)
	event.SpriteSetTexture(1, "e53202", block)
	event.SpriteSetColor(1, 128, 128, 128, 0)
	event.SpriteSetUvsize(1, 0, 0, 512, 448)
	event.SpriteSetPutsize(1, 512, 448)
	event.SpriteSetPos(1, 256, 224)
	event.SpriteSetDraw(1, 1)
	event.EohSyncSprite(6, 1)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 6)
	event.SpriteInit(2)
	event.SpriteSetType(2, 0)
	event.SpriteSetTexture(2, "e53203", block)
	event.SpriteSetColor(2, 128, 128, 128, 0)
	event.SpriteSetUvsize(2, 0, 0, 512, 448)
	event.SpriteSetPutsize(2, 512, 448)
	event.SpriteSetPos(2, 256, 224)
	event.SpriteSetDraw(2, 1)
	event.EohSyncSprite(7, 2)
	event.ObjsInit(5)
	event.ObjsSyncObj(5, 7)
	event.SpriteInit(3)
	event.SpriteSetType(3, 0)
	event.SpriteSetTexture(3, "e53204", block)
	event.SpriteSetColor(3, 128, 128, 128, 0)
	event.SpriteSetUvsize(3, 0, 0, 512, 448)
	event.SpriteSetPutsize(3, 512, 448)
	event.SpriteSetPos(3, 256, 224)
	event.SpriteSetDraw(3, 1)
	event.EohSyncSprite(8, 3)
	event.ObjsInit(6)
	event.ObjsSyncObj(6, 8)
	event.SpriteInit(4)
	event.SpriteSetType(4, 0)
	event.SpriteSetTexture(4, "e53205", block)
	event.SpriteSetColor(4, 128, 128, 128, 0)
	event.SpriteSetUvsize(4, 0, 0, 512, 448)
	event.SpriteSetPutsize(4, 512, 448)
	event.SpriteSetPos(4, 256, 224)
	event.SpriteSetDraw(4, 1)
	event.EohSyncSprite(9, 4)
	event.ObjsInit(7)
	event.ObjsSyncObj(7, 9)
	event.ChangeDir("")
	if active_chr_no == 1 then
	else
		event.LoadChara(5, "chara/c02_base.gltf", "info", 8)
		event.LoadEquip(5, 1, 4, "info", 8)
		event.LoadEquip(5, 1, 3, "info", 8)
		event.LoadEquip(5, 1, 2, "info", 8, 9)
		event.LoadEquip(5, 1, 0, "info", 8, 10)
		event.LoadMotion(5, "event/e500/e532/e532_monica.gltf", "info", 8)
		event.EohSyncChara(1, 8)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.CharaActive(8)
	event.CharaActive(9)
	event.CharaActive(0, 10)
	event.EohSyncChara(3, 1)
	event.EohSyncChara(4, 2)
	event.EohSetPos(0, 0.0, 0.0, 100.0)
	event.EohSetRot(0, 0.0, 3.14, 0.0)
	event.EohSetMotion(0, "バトル立ち2", 4)
	event.EohSetFootSoundId(0, 2)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "おこり顔")
	event.EohSetTexAnim(0, 1, "おこり目パチ")
	event.EohSetPos(1, -100.0, 0.0, -200.0)
	event.EohSetRot(1, 0.0, 2.54, 0.0)
	event.EohSetMotion(1, "起きあがり待ち", 4)
	event.EohNormalDrive(1)
	event.EohResetDaPosition(1)
	event.EohSetFootSoundId(1, 2)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "死に")
	event.EohSetPos(2, 0.0, 0.0, 0.0)
	event.EohSetRot(2, 0.0, 0.0, 0.0)
	event.EohSetMotion(2, "はぁはぁ", 4)
	event.EohNormalDrive(2)
	event.EohResetDaPosition(2)
	event.EohSetSoundId(2, var1)
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "苦し顔")
	event.EohSetTexAnim(2, 1, "苦し目パチ")
	event.SetCharaPos(12, 0.0, -1000.0, 0.0)
	event.InitDramaScene()
	event.CmrsInit()
	event.CmrsSetPos(38.02, 17.95, 16.08)
	event.CmrsSetRef(5.45, 17.89, 15.92)
	event.SetFadeIn(30)
	event.SetPakuAnim(2, "苦し口パク")
	helper_bc115506(5320010)
	if vm.skipping() then
		return skip(3)
	end
	event.CmrsSetPos(24.94, 8.23, 72.51)
	event.CmrsSetRef(1.57, 16.42, 98.07)
	helper_c85a55f2(40)
	if vm.skipping() then
		return skip(4)
	end
	event.CmrsSetPos(-3.92, 12.48, 46.35)
	event.CmrsSetRef(0.46, 18.98, 16.47)
	event.ObjsSetMotion(2, "顔上げ", 6)
	event.ObjsNextMotion(2, "顔上げL", 4)
	helper_5c88e2f9(2)
	if vm.skipping() then
		return skip(5)
	end
	event.SetPakuAnim(2, "苦し口パク")
	helper_bc115506(5320020)
	if vm.skipping() then
		return skip(6)
	end
	event.CmrsSetPos(24.94, 8.23, 72.51)
	event.CmrsSetRef(1.57, 16.42, 98.07)
	event.SetPakuAnim(0, "通常口パク")
	helper_bc115506(5320030)
	if vm.skipping() then
		return skip(7)
	end
	event.CmrsSetRef(0.0, 20.0, 50.0)
	event.CmrsSetAhd(-0.36, 0.0, 100.0)
	event.CmrsMoveAhd2(2.64, 0.0, 100.0, 280, 2, 1.0)
	event.SetPakuAnim(2, "苦し口パク")
	helper_bc115506(5320040)
	if vm.skipping() then
		return skip(8)
	end
	event.SetPakuAnim(2, "苦し口パク")
	helper_bc115506(5320045)
	if vm.skipping() then
		return skip(9)
	end
	event.SetPakuAnim(0, "通常口パク")
	helper_bc115506(5320050)
	if vm.skipping() then
		return skip(10)
	end
	helper_4d6fefb8()
	if vm.skipping() then
		return skip(11)
	end
	event.CmrsSetPos(16.36, 17.95, 32.78)
	event.CmrsSetRef(0.93, 19.2, 17.0)
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "苦し顔")
	event.EohSetTexAnim(2, 1, "苦し目あき～目とじ")
	event.SetPakuAnim(2, "わらい口パク")
	helper_bc115506(5320060)
	if vm.skipping() then
		return skip(12)
	end
	event.SetPakuAnim(2, "わらい口パク")
	helper_bc115506(5320065)
	if vm.skipping() then
		return skip(13)
	end
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "苦し顔")
	event.EohSetTexAnim(2, 1, "目とじ～苦し目あき")
	event.SetPakuAnim(2, "わらい口パク")
	helper_bc115506(5320070)
	if vm.skipping() then
		return skip(14)
	end
	event.CmrsSetPos(16.15, 37.27, 153.71)
	event.CmrsSetRef(3.58, 24.38, 96.09)
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "おこり顔")
	event.EohSetTexAnim(2, 1, "苦し目パチ")
	event.SetPakuAnim(0, "通常口パク")
	helper_bc115506(5320080)
	if vm.skipping() then
		return skip(15)
	end
	event.SndSePlay(var1, 2)
	event.ObjsSetMotion(2, "起きあがり", 6)
	event.ObjsNextMotion(2, "起きあがりL", 4)
	helper_c85a55f2(30)
	if vm.skipping() then
		return skip(16)
	end
	event.ObjsSetMotion(1, "起きあがり", 6)
	event.ObjsNextMotion(1, "起きあがりL", 4)
	helper_c85a55f2(15)
	if vm.skipping() then
		return skip(17)
	end
	event.CmrsSetPos(-84.02, 9.18, -188.66)
	event.CmrsSetRef(-99.08, 9.86, -193.29)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "死に")
	event.EohSetTexAnim(1, 1, "目とじ～目あき")
	event.SndSePlay(var1, 3)
	helper_5c88e2f9(1)
	if vm.skipping() then
		return skip(18)
	end
	helper_c85a55f2(20)
	if vm.skipping() then
		return skip(19)
	end
	event.CmrsSetPos(-23.98, 12.62, 43.97)
	event.CmrsSetRef(-1.29, 22.54, 7.67)
	event.SetPakuAnim(2, "通常口パク")
	helper_bc115506(5320090)
	if vm.skipping() then
		return skip(20)
	end
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "おこり顔")
	event.EohSetTexAnim(1, 1, "おこり目パチ")
	event.EohSetTexAnim(1, 1, "口とじ～大口")
	event.CharaActive(12)
	event.CmrsSyncObj(1, 0.0, 20.0, 7.0, -1.0, 0.0, 40.0)
	event.CmrsAhddelay(19)
	event.CmrsReleaseObj()
	event.CmrsPrdelay(20)
	event.CmrsSetPos(-26.37, 17.77, -50.44)
	event.CmrsSetRef(-51.96, 20.0, -102.44)
	event.CmrsCharaDelay(20)
	event.CmrsCharaAttach(12, 60.0, 20)
	event.CharaActive(1, 10)
	event.ObjsSetRot(1, 0.0, 0.46, 0.0)
	event.ObjsSetMotion(1, "剣走り", 4, -1.0, 1)
	event.ObjsMove(1, -11.76, 0.0, -20.14, 60)
	event.ObjsTexaDelay(1, 20)
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "おこり顔")
	event.ObjsTexAnime(1, 1, "おこり目パチ")
	event.ObjsTexAnime(1, 1, "歯くいしばり")
	helper_e5871cb4(5320100, 40)
	if vm.skipping() then
		return skip(21)
	end
	event.CharaActive(0, 12)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "おこり顔")
	event.EohSetTexAnim(1, 1, "おこり目パチ")
	event.EohSetTexAnim(1, 1, "半口")
	event.CmrsSetPos(-69.98, 14.49, -24.99)
	event.CmrsSetRef(-2.25, 17.76, -8.93)
	event.CmrsPrdelay(45)
	event.CmrsSetPos(-52.69, 22.4, 13.43)
	event.CmrsSetRef(-30.89, 6.61, -41.34)
	event.ObjsSetRot(2, 0.0, -2.4, 0.0)
	event.ObjsMotionDelay(2, 10)
	event.ObjsSetMotion(2, "よけ", 6)
	event.ObjsNextMotion(2, "ふっとばし", 6)
	event.ObjsTexaDelay(2, 40)
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "おこり顔")
	event.ObjsTexAnime(2, 1, "おこり目パチ")
	event.ObjsTexAnime(2, 1, "口ふっ")
	event.ObjsSetMotion(1, "斬り", 6)
	event.ObjsNextMotion(1, "吹っ飛び", 6)
	event.ObjsPosDelay(1, 20)
	event.ObjsMove2(1, -34.13, 0.0, -72.15, 26, 2, 1.0)
	event.ObjsSePlay(1, var1, 4)
	event.ObjsSeDelay(1, 50)
	event.ObjsSePlay(1, var1, 6)
	event.ObjsTexaDelay(1, 20)
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "おこり顔")
	event.ObjsTexAnime(1, 1, "目あき～目とじ")
	event.ObjsTexAnime(1, 1, "半口")
	event.CharaActive(1, 14)
	event.ObjsSetPos(2, 0.0, 0.0, 0.0)
	event.ObjsSetRot(9, 0.0, -2.4, 0.0)
	event.ObjsSetMotion(9, "ふっとばし", 5)
	event.ObjsMotionDelay(9, 26)
	event.ObjsSetMotion(9, "ふっとばし", 6)
	event.ObjsSeDelay(9, 34)
	event.ObjsSePlay(9, var1, 5)
	helper_c85a55f2(5)
	if vm.skipping() then
		return skip(22)
	end
	helper_e5871cb4(5320110, 20)
	if vm.skipping() then
		return skip(23)
	end
	helper_c85a55f2(5)
	if vm.skipping() then
		return skip(24)
	end
	helper_e5871cb4(5320120, 40)
	if vm.skipping() then
		return skip(25)
	end
	helper_5c88e2f9(1)
	if vm.skipping() then
		return skip(26)
	end
	event.CharaActive(0, 14)
	event.CmrsSetPos(24.94, 8.23, 72.51)
	event.CmrsSetRef(1.57, 16.42, 98.07)
	event.ObjsSetMotion(0, "モニカ！！", 6)
	event.ObjsNextMotion(0, "モニカ！！L", 4)
	event.SetPakuAnim(0, "大口パク")
	helper_bc115506(5320130)
	if vm.skipping() then
		return skip(27)
	end
	helper_5c88e2f9(0)
	if vm.skipping() then
		return skip(28)
	end
	event.CmrsSetPos(-18.95, 19.99, -37.66)
	event.CmrsSetRef(-30.66, 14.75, -65.72)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "おこり顔")
	event.EohSetTexAnim(1, 1, "おこり目パチ")
	event.SndSePlay(var1, 7)
	event.ObjsSetMotion(1, "しゃがみにらみ", 6, -1.0, 1)
	event.ObjsNextMotion(1, "しゃがみにらみL", 4)
	helper_5c88e2f9(1)
	if vm.skipping() then
		return skip(29)
	end
	helper_c85a55f2(20)
	if vm.skipping() then
		return skip(30)
	end
	event.CmrsSetPos(-57.1, 14.78, -90.75)
	event.CmrsSetRef(-21.25, 17.36, -33.53)
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "わらい顔")
	event.EohSetTexAnim(2, 1, "おこり目パチ")
	event.SndSePlay(var1, 8)
	event.ObjsSetRot(2, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(2, "後ろ見", 6)
	event.ObjsNextMotion(2, "後ろ見L", 4)
	event.SetPakuAnim(2, "通常口パク")
	helper_bc115506(5320140)
	if vm.skipping() then
		return skip(31)
	end
	helper_5c88e2f9(2)
	if vm.skipping() then
		return skip(32)
	end
	event.CmrsSetPos(0.0, 27.09, 35.56)
	event.CmrsSetRef(0.0, 29.67, -20.86)
	event.PlayBgm(0)
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "わらい顔")
	event.EohSetTexAnim(2, 1, "おこり目パチ")
	event.ObjsSetMotion(2, "笑う", 4)
	event.ObjsMotionDelay(2, 100)
	event.ObjsSetMotion(2, "笑う2")
	event.ObjsTexaDelay(2, 100)
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "わらい顔")
	event.ObjsTexAnime(2, 1, "おこり目～大わらい目")
	event.ObjsTexAnime(2, 1, "大わらい口パク")
	helper_401221ed(5320150, -1, 10)
	if vm.skipping() then
		return skip(33)
	end
	event.SetMesOkuri(0, 1)
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "わらい顔")
	event.EohSetTexAnim(2, 1, "大わらい目～通常目")
	event.SndSePlay(var1, 9)
	event.ObjsSetMotion(2, "戻り", 2)
	event.ObjsNextMotion(2, "立ち", 4)
	event.SetPakuAnim(2, "わらい口パク")
	helper_bc115506(5320155)
	if vm.skipping() then
		return skip(34)
	end
	helper_5c88e2f9(2)
	if vm.skipping() then
		return skip(35)
	end
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "わらい顔")
	event.EohSetTexAnim(2, 1, "前向き～右向き")
	event.ObjsSetMotion(1, "立つ", 2)
	event.ObjsNextMotion(1, "立つL", 4)
	event.ObjsSeDelay(1, 4)
	event.ObjsSePlay(1, var1, 10)
	event.SetPakuAnim(1, "通常口パク")
	helper_bc115506(5320160)
	if vm.skipping() then
		return skip(36)
	end
	helper_5c88e2f9(1)
	if vm.skipping() then
		return skip(37)
	end
	event.CmrsSetPos(24.94, 8.23, 72.51)
	event.CmrsSetRef(1.57, 16.42, 98.07)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "おこり顔")
	event.EohSetTexAnim(0, 1, "おこり目パチ")
	event.EohSetTexAnim(0, 1, "歯くいしばり")
	event.ObjsSetMotion(0, "バトル立ち2", 4)
	helper_c85a55f2(40)
	if vm.skipping() then
		return skip(38)
	end
	event.CmrsSetPos(1.0, 31.0, 29.43)
	event.CmrsSetRef(1.0, 31.0, 1.39)
	event.CmrsMove2(1.0, 31.0, 23.46, 1.0, 31.0, 1.39, 90, 2, 1.0)
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "デフォルト顔")
	event.EohSetTexAnim(2, 1, "通常目パチ")
	event.ObjsTexaDelay(2, 120)
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "デフォルト顔")
	event.ObjsTexAnime(2, 1, "目あき～目とじ")
	event.SetPakuAnim(2, "通常口パク")
	helper_bc115506(5320170)
	if vm.skipping() then
		return skip(39)
	end
	helper_4d6fefb8()
	if vm.skipping() then
		return skip(40)
	end
	event.SndSetEnvVol(0.0)
	event.ObjsSetColor(3, 128, 128, 128, 128, 10)
	event.SetPakuAnim(2, "通常口パク")
	helper_bc115506(5320180)
	if vm.skipping() then
		return skip(41)
	end
	event.SetPakuAnim(2, "通常口パク")
	helper_bc115506(5320190)
	if vm.skipping() then
		return skip(42)
	end
	event.SetPakuAnim(2, "通常口パク")
	helper_bc115506(5320200)
	if vm.skipping() then
		return skip(43)
	end
	helper_5c88e2f9(3)
	if vm.skipping() then
		return skip(44)
	end
	event.ObjsSetColor(4, 128, 128, 128, 128, 10)
	event.SetPakuAnim(2, "通常口パク")
	helper_bc115506(5320210)
	if vm.skipping() then
		return skip(45)
	end
	event.SetPakuAnim(2, "通常口パク")
	helper_bc115506(5320220)
	if vm.skipping() then
		return skip(46)
	end
	helper_5c88e2f9(4)
	if vm.skipping() then
		return skip(47)
	end
	event.ObjsSetColor(3, 128, 128, 128, 0)
	event.ObjsSetColor(5, 128, 128, 128, 128, 10)
	event.SetPakuAnim(2, "通常口パク")
	helper_bc115506(5320225)
	if vm.skipping() then
		return skip(48)
	end
	helper_5c88e2f9(5)
	if vm.skipping() then
		return skip(49)
	end
	event.ObjsSetColor(4, 128, 128, 128, 0)
	event.ObjsSetColor(6, 128, 128, 128, 128, 10)
	event.SetPakuAnim(2, "通常口パク")
	helper_bc115506(5320230)
	if vm.skipping() then
		return skip(50)
	end
	event.SetPakuAnim(2, "通常口パク")
	helper_bc115506(5320240)
	if vm.skipping() then
		return skip(51)
	end
	helper_5c88e2f9(6)
	if vm.skipping() then
		return skip(52)
	end
	event.ObjsSetColor(5, 128, 128, 128, 0)
	event.ObjsSetColor(7, 128, 128, 128, 128, 10)
	event.SetPakuAnim(2, "通常口パク")
	helper_bc115506(5320250)
	if vm.skipping() then
		return skip(53)
	end
	event.SetPakuAnim(2, "通常口パク")
	helper_bc115506(5320260)
	if vm.skipping() then
		return skip(54)
	end
	helper_5c88e2f9(7)
	if vm.skipping() then
		return skip(55)
	end
	event.ObjsSetColor(6, 128, 128, 128, 0)
	event.ObjsSetColor(7, 128, 128, 128, 0, 30)
	event.SndSetEnvVol(1.0)
	event.SetPakuAnim(2, "通常口パク")
	helper_bc115506(5320270)
	if vm.skipping() then
		return skip(56)
	end
	helper_5c88e2f9(7)
	if vm.skipping() then
		return skip(57)
	end
	event.SetPakuAnim(2, "通常口パク")
	helper_bc115506(5320275)
	if vm.skipping() then
		return skip(58)
	end
	if vm.wait() then
		return skip(59)
	end
	if vm.wait() then
		return skip(60)
	end
	return part2()
end

return helper_eac8ec92
