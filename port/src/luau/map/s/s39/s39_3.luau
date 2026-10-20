--!strict
-- map/s/s39/s39_3.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_10d80545 = require("@lib/event/helper_10d80545")
local helper_36061c78 = require("@lib/event/helper_36061c78")
local helper_470f8a56 = require("@lib/event/helper_470f8a56")
local helper_4afc5435 = require("@lib/event/helper_4afc5435")
local helper_560bd8b6 = require("@lib/event/helper_560bd8b6")
local helper_6c89029a = require("@lib/event/helper_6c89029a")
local helper_93d5f4e9 = require("@lib/event/helper_93d5f4e9")
local helper_9d79a7c9 = require("@lib/event/helper_9d79a7c9")
local helper_a1c34b66 = require("@lib/event/helper_a1c34b66")
local helper_a348cd1a = require("@lib/event/helper_a348cd1a")
local helper_dd5d7f5f = require("@lib/event/helper_dd5d7f5f")
local helper_e84a97e1 = require("@lib/event/helper_e84a97e1")
local helper_efffcfbb = require("@lib/event/helper_efffcfbb")

--- Helper function.
local function helper_122c0(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local argc: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_470f8a56(1, 4)
			var2 = -1
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(1, 4)
	helper_470f8a56(1, 4)
	var2 = -1
	if arg1 <= 0 then
		return
	end
	if arg1 == 1 then
		var2 = 10
		event.SetMesItem(1, 1, arg0)
	end
	if 1 < arg1 then
		var2 = 11
		event.SetMesItem(1, 1, arg0)
		event.SetMesValue(1, 2, arg1)
	end
	if var2 == -1 then
		return
	end
	argc = event.GetSysSndId() or argc
	event.SndSePlay(argc, 18)
	helper_4afc5435(1, var2, 8, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_13674()
	local var0: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local active_chr_no: s32 = 0
	local block: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 48 then
			if at <= 1 then
				helper_efffcfbb(60)
			end
			if at <= 2 then
				helper_a1c34b66(0)
			end
			if at <= 3 then
				helper_a1c34b66(2)
			end
			if at <= 4 then
				helper_10d80545()
			end
			if at <= 5 then
				helper_93d5f4e9(5240010)
			end
			if at <= 6 then
				helper_93d5f4e9(5240020)
			end
			if at <= 7 then
				helper_a1c34b66(0)
			end
			if at <= 8 then
				helper_93d5f4e9(5240030)
			end
			if at <= 9 then
				helper_a1c34b66(2)
			end
			if at <= 10 then
				helper_a1c34b66(0)
			end
			if at <= 11 then
				helper_93d5f4e9(5240040)
			end
			if at <= 12 then
				helper_93d5f4e9(5240050)
			end
			if at <= 13 then
				helper_a1c34b66(2)
			end
			if at <= 14 then
				helper_93d5f4e9(5240060)
			end
			if at <= 15 then
				helper_a348cd1a(5240070, 60)
			end
			if at <= 16 then
				helper_a348cd1a(5240075, 240)
			end
			if at <= 17 then
				helper_10d80545()
			end
			if at <= 18 then
				helper_efffcfbb(1)
			end
			if at <= 19 then
				helper_93d5f4e9(5240080)
			end
			if at <= 20 then
				helper_a1c34b66(2)
			end
			if at <= 21 then
				helper_93d5f4e9(5240090)
			end
			if at <= 22 then
				helper_93d5f4e9(5240095)
			end
			if at <= 23 then
				helper_a348cd1a(5240100, -1)
			end
			if at <= 24 then
				helper_a1c34b66(2)
			end
			if at <= 25 then
				helper_122c0(354, 1)
			end
			if at <= 26 then
				helper_a1c34b66(5)
			end
			if at <= 27 then
				helper_93d5f4e9(5240110)
			end
			if at <= 28 then
				helper_93d5f4e9(5240115)
			end
			if at <= 29 then
				helper_93d5f4e9(5240120)
			end
			if at <= 30 then
				helper_93d5f4e9(5240130)
			end
			if at <= 31 then
				helper_10d80545()
			end
			if at <= 32 then
				helper_93d5f4e9(5240140)
			end
			if at <= 33 then
				helper_93d5f4e9(5240150)
			end
			if at <= 34 then
				helper_a1c34b66(0)
			end
			if at <= 35 then
				helper_efffcfbb(30)
			end
			if at <= 36 then
				helper_93d5f4e9(5240160)
			end
			if at <= 37 then
				helper_a1c34b66(2)
			end
			if at <= 38 then
				helper_efffcfbb(60)
			end
			if at <= 39 then
				helper_93d5f4e9(5240170)
			end
			if at <= 40 then
				helper_a1c34b66(2)
			end
			if at <= 41 then
				helper_93d5f4e9(5240180)
			end
			if at <= 42 then
				helper_93d5f4e9(5240190)
			end
			if at <= 43 then
				helper_93d5f4e9(5240200)
			end
			if at <= 44 then
				helper_93d5f4e9(5240210)
			end
			if at <= 45 then
				helper_93d5f4e9(5240220)
			end
			if at <= 46 then
				helper_93d5f4e9(5240230)
			end
			if at <= 47 then
				helper_efffcfbb(30)
			end
			if vm.skip_end() then
				return skip(49)
			end
			return part2()
		end
		if at <= 49 then
			helper_6c89029a(0)
		end
	end
	function part2()
		event.CancelDramaScene()
		event.PlayBgm(0)
		event.FuncPointShow("p01_s39", "kaiten-1", 1)
		event.FuncPointShow("p01_s39", "kaiten-0", 1)
		event.DelReference(36)
		event.CharaActive(1, var0)
		event.EohSetFootSoundId(0, 0)
		event.SpriteSetDraw(0, 0)
		event.DelExtMotion(0)
		event.DeleteChara(35)
		event.DeleteChara(36)
		event.DeleteChara(37)
		event.DelImg(0)
		event.LoadMes(0, -1)
		helper_6c89029a(0)
		if vm.skipping() then
			return skip(50)
		end
		event.CharaActive(0)
		event.SetCharaPos(0, -2.21, 0.0, 25.73)
		event.SetCharaRot(0, 0.0, 0.03, 0.0)
		event.SetMotion(0, "立ち", 4)
		event.CharaNormalDrive(0)
		event.CharaResetDa(0)
		event.ResetCamera(1, 3.1415927, 10.0)
		event.SetFadeIn(30)
	end
	event.SetFlag(524, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.LoadSound(5509)
	var0 = event.SearchCharaNo(400) or var0
	event.CharaActive(0, var0)
	var1 = event.SndLoadSound(5509) or var1
	var2 = event.SndLoadSound(8, "snd2/sp/sp_006.sound.json") or var2
	event.SndSePlay(var1, 0)
	event.SndSeStop(var1, 0)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.ChangeDir("event/e500/e524/")
	event.LoadMes(0, 5, "e524_1.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e524_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	event.LoadChara(5, "e524_phorn.gltf", "info", 35)
	event.CharaActive(35)
	event.EohSyncChara(2, 35)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.LoadChara(5, "phorn.gltf", "info", 36)
	event.CharaActive(36)
	event.EohSyncChara(3, 36)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	block = event.LoadImg_4(5, "e524.json", 0) or block
	event.SpriteInit(0)
	event.SpriteSetType(0, 0)
	event.SpriteSetTexture(0, "e52401", block)
	event.SpriteSetColor(0, 128, 128, 128, 0)
	event.SpriteSetUvsize(0, 0, 0, 512, 448)
	event.SpriteSetPutsize(0, 512, 448)
	event.SpriteSetPos(0, 256, 224)
	event.SpriteSetDraw(0, 1)
	event.EohSyncSprite(4, 0)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.ChangeDir("")
	event.LoadChara(5, "event/itemget_ev/itemget_ev.gltf", "info", 37)
	event.CharaActive(37)
	event.EohSyncChara(5, 37)
	event.ObjsInit(5)
	event.ObjsSyncObj(5, 5)
	event.EohSetPos(0, 1.18, 30.0, -155.65)
	event.EohSetRot(0, 0.0, 0.03, 0.0)
	event.EohSetMotion(0, "立ち", 4)
	event.EohSetFootSoundId(0, 6)
	event.EohSetPos(2, -0.27, 0.0, 103.22)
	event.EohSetRot(2, 0.0, 0.03, 0.0)
	event.EohSetMotion(2, "楽器付き立ち", 4)
	event.EohSetFootSoundId(2, 6)
	event.EohSetShow(3, 0)
	event.EohSetPos(5, 0.36, 17.84, 110.91)
	event.EohSetRot(5, 0.0, 0.0, 0.0)
	event.EohSetShow(5, 0)
	event.InitDramaScene()
	event.CmrsInit()
	event.CmrsSetPos(2.0, 95.67, -163.59)
	event.CmrsSetRef(-0.56, 198.28, 13.09)
	event.CharaActive(0)
	event.CmrsMove2(2.0, 95.67, -163.59, -0.56, 42.44, 13.09, 120, 2, 1.0)
	event.SetFadeIn(30)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "目パチ")
	helper_efffcfbb(90)
	if vm.skipping() then
		return skip(1)
	end
	event.SndSePlay(var1, 2)
	helper_efffcfbb(60)
	if vm.skipping() then
		return skip(2)
	end
	event.ObjsSetMotion(0, "歩き")
	event.ObjsMove(0, -2.21, 0.0, 25.73, 120, 1)
	event.ObjsMotionDelay(0, 120)
	event.ObjsSetMotion(0, "立ち")
	helper_a1c34b66(0)
	if vm.skipping() then
		return skip(3)
	end
	event.SndSePlay(var1, 3)
	event.ObjsSetMotion(2, "振り返り", 6)
	event.ObjsNextMotion(2, "振り返りループ", 4)
	helper_a1c34b66(2)
	if vm.skipping() then
		return skip(4)
	end
	helper_10d80545()
	if vm.skipping() then
		return skip(5)
	end
	event.CmrsSetPos(59.97, 21.62, 151.86)
	event.CmrsSetRef(-6.76, 14.47, 67.23)
	event.SetPakuAnim(2, "口パク")
	helper_93d5f4e9(5240010)
	if vm.skipping() then
		return skip(6)
	end
	event.ObjsMotionDelay(0, 30)
	event.ObjsSetMotion(0, "おじぎ", 6)
	event.ObjsNextMotion(0, "立ち", 4)
	event.ObjsSeDelay(0, 30)
	event.ObjsSePlay(0, var1, 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_93d5f4e9(5240020)
	if vm.skipping() then
		return skip(7)
	end
	helper_a1c34b66(0)
	if vm.skipping() then
		return skip(8)
	end
	event.CmrsSetPos(80.24, 22.18, 57.8)
	event.CmrsSetRef(-9.02, 19.78, 80.07)
	event.ObjsSetPos(2, -0.47, 0.0, 96.17)
	event.ObjsSetRot(2, 0.0, 2.95, 0.0)
	event.ObjsSetMotion(2, "楽器付き立ち", 4)
	event.ObjsResetMotion(2)
	event.ObjsSetMotion(0, "歩き")
	event.ObjsMove(0, 5.68, 0.0, 55.77, 60)
	event.ObjsMotionDelay(0, 60)
	event.ObjsSetMotion(0, "立ち")
	event.ObjsMotionDelay(0, 90)
	event.ObjsSetMotion(2, "楽器付き会話", 6)
	event.ObjsNextMotion(2, "楽器付き立ち", 4)
	event.SetPakuAnim(2, "口パク")
	helper_93d5f4e9(5240030)
	if vm.skipping() then
		return skip(9)
	end
	helper_a1c34b66(2)
	if vm.skipping() then
		return skip(10)
	end
	helper_a1c34b66(0)
	if vm.skipping() then
		return skip(11)
	end
	event.SetPakuAnim(0, "通常口パク")
	helper_93d5f4e9(5240040)
	if vm.skipping() then
		return skip(12)
	end
	event.CmrsSetPos(-31.44, 34.79, 139.67)
	event.CmrsSetRef(7.06, 24.98, 108.55)
	event.ObjsSetPos(2, -1.39, 0.0, 125.9)
	event.ObjsSetPos(0, 0.19, 0.0, 97.47)
	event.ObjsSetRot(0, 0.0, -0.09, 0.0)
	event.ObjsSetMotion(0, "ホーン王見立ち", 4)
	event.ObjsSetMotion(2, "楽器付き会話", 6)
	event.ObjsNextMotion(2, "楽器付き立ち", 4)
	event.SetPakuAnim(2, "口パク")
	helper_93d5f4e9(5240050)
	if vm.skipping() then
		return skip(13)
	end
	helper_a1c34b66(2)
	if vm.skipping() then
		return skip(14)
	end
	event.SetPakuAnim(0, "通常口パク")
	helper_93d5f4e9(5240060)
	if vm.skipping() then
		return skip(15)
	end
	event.ObjsSetPos(0, 0.19, -50.0, 97.47)
	event.CmrsSetPos(-16.65, 9.36, 92.0)
	event.CmrsSetRef(1.34, 9.65, 122.71)
	event.CmrsMove2(-13.12, 13.95, 102.03, -0.1, 26.37, 123.93, 280, 2, 0.7)
	event.SetPakuAnim(2, "口パク")
	helper_a348cd1a(5240070, 60)
	if vm.skipping() then
		return skip(16)
	end
	event.SetPakuAnim(2, "口パク")
	helper_a348cd1a(5240075, 240)
	if vm.skipping() then
		return skip(17)
	end
	helper_10d80545()
	if vm.skipping() then
		return skip(18)
	end
	helper_efffcfbb(1)
	if vm.skipping() then
		return skip(19)
	end
	event.CmrsSetPos(92.26, 21.72, 112.97)
	event.CmrsSetRef(4.0, 19.3, 111.97)
	event.ObjsSetPos(0, 0.19, 0.0, 97.47)
	event.ObjsMotionDelay(2, 30)
	event.ObjsSetMotion(2, "キョロキョロ", 6)
	event.ObjsNextMotion(2, "楽器付き立ち")
	event.SetPakuAnim(2, "口パク")
	helper_93d5f4e9(5240080)
	if vm.skipping() then
		return skip(20)
	end
	helper_a1c34b66(2)
	if vm.skipping() then
		return skip(21)
	end
	event.ObjsSetMotion(0, "うつむく", 6)
	event.ObjsNextMotion(0, "うつむくL", 4)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "通常目～かなし目")
	event.SetPakuAnim(0, "通常口パク")
	helper_93d5f4e9(5240090)
	if vm.skipping() then
		return skip(22)
	end
	event.CmrsSetPos(-31.44, 34.79, 139.67)
	event.CmrsSetRef(7.06, 24.98, 108.55)
	event.ObjsSetMotion(0, "うつむく戻り", 6)
	event.ObjsNextMotion(0, "ホーン王見立ち", 4)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "かなし顔")
	event.ObjsTexAnime(0, 1, "かなし目～おこり目")
	event.SetPakuAnim(0, "通常口パク")
	helper_93d5f4e9(5240095)
	if vm.skipping() then
		return skip(23)
	end
	event.CmrsSetPos(-50.46, 14.31, 66.61)
	event.CmrsSetRef(5.51, 17.98, 117.78)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おこり顔")
	event.ObjsTexAnime(0, 1, "おこり目パチ")
	event.SetPakuAnim(2, "口パク")
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "目あき～目とじ")
	event.SetPakuAnim(2, "口パク")
	event.ObjsSetRot(2, 0.0, -2.97, 0.0)
	event.ObjsSetRot(0, 0.0, 0.27, 0.0)
	event.ObjsSetMotion(2, "そうか", 6)
	event.ObjsNextMotion(2, "そうかループ", 4)
	event.ObjsMotionDelay(2, 30)
	event.ObjsNextMotion(2, "ならば", 4)
	event.ObjsNextMotion(2, "ならば（会話）", 4)
	event.ObjsNextMotion(2, "ならばループ", 4)
	event.ObjsSeDelay(2, 90)
	event.ObjsSePlay(2, var1, 5)
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "目とじ～目あき")
	event.SetPakuAnim(2, "口パク")
	helper_a348cd1a(5240100, -1)
	if vm.skipping() then
		return skip(24)
	end
	helper_a1c34b66(2)
	if vm.skipping() then
		return skip(25)
	end
	event.EohSetShow(3, 1)
	event.CmrsSetPos(6.67, 11.76, 162.66)
	event.CmrsSetRef(1.15, 11.01, 99.02)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.DelReference(36)
	event.SetReference(0, "item", 36)
	event.ObjsSetPos(2, -1.39, -50.0, 125.9)
	event.ObjsSetMotion(2, "立ち")
	event.ObjsSetMotion(0, "ホーンゲット", 4)
	event.SndPauseBgm()
	event.FuncPointShow("p01_s39", "kaiten-1", 0)
	event.FuncPointShow("p01_s39", "kaiten-0", 0)
	event.CharaActive(37)
	event.EohSetShow(5, 1)
	event.ObjsSetMotion(5, "発動", 6)
	event.SndSePlay(var2, 0)
	event.SndSePlay(var1, 6)
	helper_122c0(354, 1)
	if vm.skipping() then
		return skip(26)
	end
	event.ObjsMotionWait(5)
	helper_a1c34b66(5)
	if vm.skipping() then
		return skip(27)
	end
	event.PlayBgm(0)
	event.FuncPointShow("p01_s39", "kaiten-1", 1)
	event.FuncPointShow("p01_s39", "kaiten-0", 1)
	event.EohSetShow(5, 0)
	event.ObjsSetColor(4, 128, 128, 128, 128, 30)
	event.SetPakuAnim(2, "口パク")
	helper_93d5f4e9(5240110)
	if vm.skipping() then
		return skip(28)
	end
	event.SetPakuAnim(2, "口パク")
	helper_93d5f4e9(5240115)
	if vm.skipping() then
		return skip(29)
	end
	event.ObjsSetPos(2, -1.39, 0.0, 125.9)
	event.ObjsSetMotion(0, "ホーン持ち立ち", 4)
	event.SetCrossfade(30)
	event.SpriteSetTexture(0, "e52402", block)
	event.SetPakuAnim(2, "口パク")
	helper_93d5f4e9(5240120)
	if vm.skipping() then
		return skip(30)
	end
	event.ObjsSetColor(4, 128, 128, 128, 0, 30)
	event.CmrsSetPos(-24.71, 24.69, 98.27)
	event.CmrsSetRef(17.15, 30.09, 147.85)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "目パチ")
	event.CmrsMove2(-37.04, 28.22, 128.56, 21.86, 5.87, 77.55, 300, 2, 1.0)
	event.SetPakuAnim(2, "口パク")
	helper_93d5f4e9(5240130)
	if vm.skipping() then
		return skip(31)
	end
	helper_10d80545()
	if vm.skipping() then
		return skip(32)
	end
	event.ObjsSetPos(2, -1.39, -50.0, 125.9)
	event.SetPakuAnim(2, "口パク")
	helper_93d5f4e9(5240140)
	if vm.skipping() then
		return skip(33)
	end
	event.SndSePlay(var1, 7)
	event.ObjsSetMotion(0, "ホーン持ちうなづき", 6)
	event.ObjsNextMotion(0, "ホーン持ち立ち", 4)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.SetPakuAnim(0, "通常口パク")
	helper_93d5f4e9(5240150)
	if vm.skipping() then
		return skip(34)
	end
	helper_a1c34b66(0)
	if vm.skipping() then
		return skip(35)
	end
	event.ObjsSetPos(2, -2.47, 0.0, 124.48)
	event.ObjsSetRot(2, 0.0, -0.05, 0.0)
	event.CmrsSetPos(-32.29, 37.48, 18.17)
	event.CmrsSetRef(3.98, 18.01, 136.44)
	event.ObjsSetMotion(2, "歩き")
	event.ObjsMove(2, -8.17, 0.0, 159.31, 60)
	event.ObjsMotionDelay(2, 60)
	event.ObjsSetMotion(2, "立ち")
	helper_efffcfbb(30)
	if vm.skipping() then
		return skip(36)
	end
	event.SetPakuAnim(2, "口パク")
	helper_93d5f4e9(5240160)
	if vm.skipping() then
		return skip(37)
	end
	helper_a1c34b66(2)
	if vm.skipping() then
		return skip(38)
	end
	event.CmrsSetPos(16.45, 27.42, 169.09)
	event.CmrsSetRef(-17.29, 30.53, 156.25)
	event.ObjsSetMotion(2, "上向く", 6)
	event.ObjsNextMotion(2, "上向くループ", 4)
	event.ObjsMotionDelay(2, 60)
	event.ObjsNextMotion(2, "上向く（会話）", 4)
	event.ObjsNextMotion(2, "上向くループ", 4)
	helper_efffcfbb(60)
	if vm.skipping() then
		return skip(39)
	end
	event.SetPakuAnim(2, "口パク")
	helper_93d5f4e9(5240170)
	if vm.skipping() then
		return skip(40)
	end
	helper_a1c34b66(2)
	if vm.skipping() then
		return skip(41)
	end
	event.CmrsSetPos(-32.29, 37.48, 18.17)
	event.CmrsSetRef(3.98, 18.01, 136.44)
	event.SndSePlay(var1, 8)
	event.ObjsSetMotion(2, "振り返る3", 6)
	event.ObjsNextMotion(2, "立ち", 4)
	event.ObjsRotation(2, 0.0, 2.95, 0.0, 30)
	event.SetPakuAnim(2, "口パク")
	helper_93d5f4e9(5240180)
	if vm.skipping() then
		return skip(42)
	end
	event.ObjsSetMotion(2, "歩き")
	event.ObjsMove(2, -2.47, 0.0, 124.48, 60)
	event.ObjsMotionDelay(2, 60)
	event.ObjsSetMotion(2, "立ち")
	event.SetPakuAnim(0, "通常口パク")
	helper_93d5f4e9(5240190)
	if vm.skipping() then
		return skip(43)
	end
	event.SetPakuAnim(2, "口パク")
	helper_93d5f4e9(5240200)
	if vm.skipping() then
		return skip(44)
	end
	event.CmrsSetPos(14.67, 18.36, 119.11)
	event.CmrsSetRef(-20.65, 26.93, 75.58)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おこり顔")
	event.ObjsTexAnime(0, 1, "おこり目パチ")
	event.SetPakuAnim(0, "通常口パク")
	helper_93d5f4e9(5240210)
	if vm.skipping() then
		return skip(45)
	end
	event.CmrsSetPos(-30.7, 28.17, 78.96)
	event.CmrsSetRef(2.07, 23.76, 121.82)
	event.ObjsSetPos(0, 0.97, 0.0, 110.67)
	event.ObjsSetRot(0, 0.0, -0.21, 0.0)
	event.ObjsResetDaPosition(0)
	event.SetPakuAnim(2, "口パク")
	helper_93d5f4e9(5240220)
	if vm.skipping() then
		return skip(46)
	end
	event.SndSePlay(var1, 9)
	event.ObjsSetMotion(2, "ポン", 6)
	event.ObjsNextMotion(2, "ポンループ", 4)
	event.SetPakuAnim(2, "口パク")
	helper_93d5f4e9(5240230)
	if vm.skipping() then
		return skip(47)
	end
	event.SetFadeOut(30)
	helper_efffcfbb(30)
	if vm.skipping() then
		return skip(48)
	end
	return part2()
end

--- Helper function.
local function helper_109d0()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		return 0
	end
	if vm.skipping() then
		return skip(1)
	end
	var0 = event.GetDioramaPercent(3) or var0
	if var0 < 100 then
		return 0
	end
	return 1
end

--- Helper function.
local function helper_10e40()
	local flag: s32 = 0
	local var1: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		local _ = if helper_109d0() == 0 then 1 else 0
		return 0
	end
	if vm.skipping() then
		return skip(1)
	end
	if helper_109d0() == 0 then
		return 0
	end
	flag = event.GetFlag(560) or flag
	if flag ~= 0 then
		return 0
	end
	var1 = event.CheckEnableCharaChange(1) or var1
	if var1 == 0 then
		return 0
	end
	return 1
end

--- Helper function.
local function helper_182d0()
	local var0: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 32 then
			if at <= 1 then
				helper_efffcfbb(60)
			end
			if at <= 2 then
				helper_93d5f4e9(5600010)
			end
			if at <= 3 then
				helper_a1c34b66(2)
			end
			if at <= 4 then
				helper_a1c34b66(0)
			end
			if at <= 5 then
				helper_93d5f4e9(5600015)
			end
			if at <= 6 then
				helper_a1c34b66(2)
			end
			if at <= 7 then
				helper_93d5f4e9(5600020)
			end
			if at <= 8 then
				helper_a1c34b66(1)
			end
			if at <= 9 then
				helper_93d5f4e9(5600030)
			end
			if at <= 10 then
				helper_93d5f4e9(5600040)
			end
			if at <= 11 then
				helper_93d5f4e9(5600050)
			end
			if at <= 12 then
				helper_a1c34b66(2)
			end
			if at <= 13 then
				helper_93d5f4e9(5600060)
			end
			if at <= 14 then
				helper_93d5f4e9(5600070)
			end
			if at <= 15 then
				helper_efffcfbb(15)
			end
			if at <= 16 then
				helper_93d5f4e9(5600080)
			end
			if at <= 17 then
				helper_a1c34b66(2)
			end
			if at <= 18 then
				helper_93d5f4e9(5600090)
			end
			if at <= 19 then
				helper_93d5f4e9(5600100)
			end
			if at <= 20 then
				helper_93d5f4e9(5600105)
			end
			if at <= 21 then
				helper_93d5f4e9(5600110)
			end
			if at <= 22 then
				helper_93d5f4e9(5600120)
			end
			if at <= 23 then
				helper_93d5f4e9(5600130)
			end
			if at <= 24 then
				helper_93d5f4e9(5600140)
			end
			if at <= 25 then
				helper_a1c34b66(1)
			end
			if at <= 26 then
				helper_efffcfbb(30)
			end
			if at <= 27 then
				helper_93d5f4e9(5600150)
			end
			if at <= 28 then
				helper_122c0(82, 1)
			end
			if at <= 29 then
				helper_a1c34b66(4)
			end
			if at <= 30 then
				helper_efffcfbb(30)
			end
			if at <= 31 then
				helper_efffcfbb(30)
			end
			if vm.skip_end() then
				return skip(33)
			end
			return part2()
		end
		if at <= 33 then
			helper_6c89029a(1)
		end
	end
	function part2()
		event.CancelDramaScene()
		event.PlayBgm(0)
		event.FuncPointShow("p01_s39", "kaiten-1", 1)
		event.FuncPointShow("p01_s39", "kaiten-0", 1)
		event.DelReference(36)
		event.CharaActive(1, var0)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.SpriteSetDraw(0, 0)
		event.DelExtMotion(0)
		event.DeleteChara(33)
		event.DeleteChara(34)
		event.DeleteChara(35)
		event.DeleteChara(36)
		event.DeleteChara(37)
		event.LoadMes(0, -1)
		event.CharaActive(0)
		event.SetCharaPos(0, -2.21, 0.0, 25.73)
		event.SetCharaRot(0, 0.0, 0.03, 0.0)
		event.SetMotion(0, "立ち", 4)
		event.CharaNormalDrive(0)
		event.CharaResetDa(0)
		event.ResetCamera(1, 3.1415927, 10.0)
		helper_6c89029a(1)
		if vm.skipping() then
			return skip(34)
		end
		event.SetFadeIn(30)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFlag(560, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.LoadSound(5527)
	var0 = event.SearchCharaNo(400) or var0
	event.CharaActive(0, var0)
	var1 = event.SndLoadSound(5527) or var1
	var2 = event.SndLoadSound(8, "snd2/sp/sp_006.sound.json") or var2
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.ChangeDir("event/e500/e560/")
	event.LoadMes(0, 5, "e560_1.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e560_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e560_monica.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.LoadChara(5, "e560_phorn.gltf", "info", 35)
	event.CharaActive(35)
	event.EohSyncChara(2, 35)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.ChangeDir("")
	event.LoadItem(5, 82, "info", 36)
	event.CharaActive(0, 36)
	if active_chr_no == 1 then
		event.LoadChara(5, "chara/c01_base.gltf", "info", 33)
		event.LoadEquip(5, 0, 4, "info", 33)
		event.LoadEquip(5, 0, 3, "info", 33)
		event.LoadEquip(5, 0, 2, "info", 33, 34)
		event.LoadMotion(5, "event/e500/e560/e560_mints.gltf", "info", 33)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 33)
		event.EohSyncChara(0, 33)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 0)
	else
		event.LoadChara(5, "chara/c02_base.gltf", "info", 33)
		event.LoadEquip(5, 1, 4, "info", 33)
		event.LoadEquip(5, 1, 3, "info", 33)
		event.LoadEquip(5, 1, 2, "info", 33, 34)
		event.LoadMotion(5, "event/e500/e560/e560_monica.gltf", "info", 33)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 33)
		event.EohSyncChara(1, 33)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 0)
	end
	event.CharaActive(33)
	event.CharaActive(34)
	event.LoadChara(5, "event/itemget_ev/itemget_ev.gltf", "info", 37)
	event.CharaActive(37)
	event.EohSyncChara(4, 37)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.EohSetPos(0, -17.2, 0.0, 30.01)
	event.EohSetRot(0, 0.0, 0.27, 0.0)
	event.EohSetMotion(0, "立ち", 4)
	event.EohSetFootSoundId(0, 6)
	event.EohSetPos(1, 4.65, 0.0, 27.74)
	event.EohSetRot(1, 0.0, -0.09, 0.0)
	event.EohSetMotion(1, "立ち", 4)
	event.EohSetFootSoundId(1, 6)
	event.EohSetPos(2, -3.17, 0.0, 155.11)
	event.EohSetRot(2, 0.0, -3.09, 0.0)
	event.EohSetMotion(2, "立ち", 4)
	event.EohSetFootSoundId(2, 6)
	event.EohSetPos(4, 0.08, 38.72, 122.65)
	event.EohSetRot(4, 0.0, 0.0, 0.0)
	event.EohSetShow(4, 0)
	event.CharaActive(0, 36)
	event.InitDramaScene()
	event.CmrsInit()
	event.CmrsSetPos(96.73, 77.83, 209.19)
	event.CmrsSetRef(-9.73, 8.3, 118.99)
	event.CharaActive(0)
	event.CharaActive(33)
	event.CharaActive(34)
	event.ObjsSetMotion(1, "歩き")
	event.ObjsMove(1, 0.58, 0.0, 112.67, 120, 1)
	event.ObjsMotionDelay(1, 120)
	event.ObjsSetMotion(1, "立ち")
	event.ObjsSetMotion(0, "歩き")
	event.ObjsMove(0, -22.79, 0.0, 111.6, 120, 1)
	event.ObjsMotionDelay(0, 120)
	event.ObjsSetMotion(0, "立ち")
	event.SetFadeIn(30)
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "目パチ")
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "デフォルト顔")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	helper_efffcfbb(60)
	if vm.skipping() then
		return skip(2)
	end
	event.ObjsMotionDelay(2, 30)
	event.ObjsSetMotion(2, "腕組（後）", 6)
	event.ObjsNextMotion(2, "会話（腕組後）", 4)
	event.ObjsNextMotion(2, "腕組（後）ループ", 4)
	event.SetPakuAnim(2, "口パク")
	helper_93d5f4e9(5600010)
	if vm.skipping() then
		return skip(3)
	end
	helper_a1c34b66(2)
	if vm.skipping() then
		return skip(4)
	end
	helper_a1c34b66(0)
	if vm.skipping() then
		return skip(5)
	end
	event.CmrsSetPos(-73.52, 52.31, 61.09)
	event.CmrsSetRef(5.88, 8.34, 145.01)
	event.SetPakuAnim(2, "口パク")
	helper_93d5f4e9(5600015)
	if vm.skipping() then
		return skip(6)
	end
	helper_a1c34b66(2)
	if vm.skipping() then
		return skip(7)
	end
	event.ObjsSetMotion(1, "謙遜", 6)
	event.ObjsNextMotion(1, "立ち", 4)
	event.ObjsTexAnime(1, 0)
	event.SetPakuAnim(1, "通常口パク")
	helper_93d5f4e9(5600020)
	if vm.skipping() then
		return skip(8)
	end
	helper_a1c34b66(1)
	if vm.skipping() then
		return skip(9)
	end
	event.SetPakuAnim(2, "口パク")
	helper_93d5f4e9(5600030)
	if vm.skipping() then
		return skip(10)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_93d5f4e9(5600040)
	if vm.skipping() then
		return skip(11)
	end
	event.CmrsSetPos(-4.66, 6.27, 110.23)
	event.CmrsSetRef(-3.33, 22.89, 155.78)
	event.ObjsSetPos(1, 0.58, -80.0, 112.67)
	event.ObjsResetDaPosition(1)
	event.ObjsSetPos(0, -22.79, -80.0, 111.6)
	event.ObjsResetDaPosition(0)
	event.ObjsSetMotion(2, "会話（腕組後）", 6)
	event.ObjsNextMotion(2, "腕組（後）ループ", 4)
	event.SetPakuAnim(2, "口パク")
	helper_93d5f4e9(5600050)
	if vm.skipping() then
		return skip(12)
	end
	helper_a1c34b66(2)
	if vm.skipping() then
		return skip(13)
	end
	event.CmrsSetPos(16.87, 21.89, 141.08)
	event.CmrsSetRef(-7.49, 23.51, 108.73)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "半口")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "無表情")
	event.ObjsSetPos(1, 0.58, 0.0, 112.67)
	event.ObjsResetDaPosition(1)
	event.ObjsSetPos(0, -22.79, 0.0, 111.6)
	event.ObjsResetDaPosition(0)
	event.SetPakuAnim(1, "通常口パク")
	helper_93d5f4e9(5600060)
	if vm.skipping() then
		return skip(14)
	end
	helper_93d5f4e9(5600070)
	if vm.skipping() then
		return skip(15)
	end
	event.CmrsSetPos(-4.66, 6.27, 110.23)
	event.CmrsSetRef(-3.33, 22.89, 155.78)
	event.ObjsSetPos(1, 0.58, -80.0, 112.67)
	event.ObjsResetDaPosition(1)
	event.SndSePlay(var1, 2)
	event.ObjsSetMotion(2, "渡す", 6)
	event.ObjsNextMotion(2, "渡すループ", 4)
	helper_efffcfbb(15)
	if vm.skipping() then
		return skip(16)
	end
	event.CharaActive(1, 36)
	event.SetReference(35, "ken", 36)
	event.SetPakuAnim(2, "口パク")
	helper_93d5f4e9(5600080)
	if vm.skipping() then
		return skip(17)
	end
	helper_a1c34b66(2)
	if vm.skipping() then
		return skip(18)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_93d5f4e9(5600090)
	if vm.skipping() then
		return skip(19)
	end
	event.DelReference(36)
	event.CharaActive(1, 36)
	if active_chr_no == 0 then
		event.SetReference(33, "sword_hand", 36)
	else
		event.SetReference(0, "sword_hand", 36)
	end
	event.CmrsSetPos(-4.6, 25.94, 147.91)
	event.CmrsSetRef(1.19, 22.66, 113.9)
	event.SndSePlay(var1, 3)
	event.ObjsSetPos(1, 0.58, 0.0, 112.67)
	event.ObjsResetDaPosition(1)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsSetMotion(1, "剣見L", 4)
	event.ObjsSetMotion(2, "腕組（後）ループ")
	event.SetPakuAnim(2, "口パク")
	helper_93d5f4e9(5600100)
	if vm.skipping() then
		return skip(20)
	end
	event.CmrsSetPos(27.69, 28.67, 125.37)
	event.CmrsSetRef(-3.33, 24.8, 155.78)
	event.ObjsMotionDelay(2, 30)
	event.ObjsSetMotion(2, "会話（腕組後）", 6)
	event.ObjsNextMotion(2, "腕組（後）ループ", 4)
	event.SetPakuAnim(2, "口パク")
	helper_93d5f4e9(5600105)
	if vm.skipping() then
		return skip(21)
	end
	event.CmrsSetPos(-4.6, 25.94, 147.91)
	event.CmrsSetRef(1.19, 22.66, 113.9)
	event.ObjsSetMotion(2, "立ち（下見）", 4)
	event.ObjsResetDaPosition(2)
	event.ObjsTexAnime(1, 0)
	event.SetPakuAnim(1, "通常口パク")
	helper_93d5f4e9(5600110)
	if vm.skipping() then
		return skip(22)
	end
	event.CmrsSetPos(-58.26, 83.79, 44.66)
	event.CmrsSetRef(4.69, 3.13, 142.29)
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.ObjsSetPos(0, -27.18, 0.0, 117.43)
	event.ObjsSetRot(0, 0.0, 0.39, 0.0)
	event.ObjsResetDaPosition(0)
	event.ObjsSetMotion(2, "会話（下見）", 6)
	event.ObjsNextMotion(2, "立ち（下見）", 4)
	event.ObjsMotionDelay(0, 60)
	event.ObjsSetMotion(0, "左向く", 6)
	event.ObjsNextMotion(0, "左向くL", 4)
	event.SetPakuAnim(2, "口パク")
	helper_93d5f4e9(5600120)
	if vm.skipping() then
		return skip(23)
	end
	event.SetPakuAnim(2, "口パク")
	helper_93d5f4e9(5600130)
	if vm.skipping() then
		return skip(24)
	end
	event.CmrsSetPos(-21.07, 17.46, 128.16)
	event.CmrsSetRef(-0.65, 29.21, 161.09)
	event.ObjsSetPos(0, -23.77, -80.0, 118.08)
	event.SetPakuAnim(2, "口パク")
	helper_93d5f4e9(5600140)
	if vm.skipping() then
		return skip(25)
	end
	event.CmrsSetPos(26.33, 25.58, 130.87)
	event.CmrsSetRef(-0.68, 23.67, 116.18)
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "目あき～目とじ")
	event.ObjsSetPos(0, -27.18, 0.0, 117.43)
	event.ObjsResetDaPosition(0)
	event.SndSePlay(var1, 4)
	event.ObjsSetMotion(1, "父上", 6)
	event.ObjsNextMotion(1, "父上L", 4)
	helper_a1c34b66(1)
	if vm.skipping() then
		return skip(26)
	end
	helper_efffcfbb(30)
	if vm.skipping() then
		return skip(27)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_93d5f4e9(5600150)
	if vm.skipping() then
		return skip(28)
	end
	event.CmrsSetPos(5.24, 63.17, 148.86)
	event.CmrsSetRef(2.09, 25.1, 111.24)
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "デフォルト顔")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.ObjsSetPos(0, -23.77, -80.0, 118.08)
	event.ObjsSetMotion(1, "げっとL", 4)
	event.ObjsResetDaPosition(1)
	event.SndPauseBgm()
	event.CharaActive(37)
	event.EohSetShow(4, 1)
	event.ObjsSetMotion(4, "発動", 6)
	event.SndSePlay(var2, 0)
	event.SndSePlay(var1, 5)
	helper_122c0(82, 1)
	if vm.skipping() then
		return skip(29)
	end
	event.SndSeStop(var1, 5)
	event.ObjsMotionWait(4)
	helper_a1c34b66(4)
	if vm.skipping() then
		return skip(30)
	end
	helper_efffcfbb(30)
	if vm.skipping() then
		return skip(31)
	end
	event.SetFadeOut(30)
	helper_efffcfbb(30)
	if vm.skipping() then
		return skip(32)
	end
	return part2()
end

--- Helper function.
local function helper_e61c()
	local player_chara: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local flag_4: s32 = 0
	local flag_5: s32 = 0
	local flag_6: s32 = 0
	local flag_7: s32 = 0
	local flag_8: s32 = 0
	local flag_9: s32 = 0
	local player_chara_2: s32 = 0
	local var14: f32 = 0
	local var16: f32 = 0
	local var17: f32 = 0
	local var19: f32 = 0
	local var20: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_e84a97e1(0, -1, var1, player_chara, 0)
		end
		if at <= 2 then
			var3 = 1
			helper_9d79a7c9(var1, -1, 0, 0)
		end
		if at <= 3 then
			helper_e84a97e1(0, -1, var1, player_chara, 0)
		end
		if at <= 4 then
			helper_dd5d7f5f(player_chara_2, var20)
		end
		if at <= 5 then
			helper_e84a97e1(0, -1, var1, player_chara_2, 0)
		end
		if at <= 6 then
			helper_36061c78(30)
		end
		if at <= 7 then
			helper_36061c78(28)
		end
		if at <= 8 then
			helper_36061c78(29)
		end
	end
	player_chara = event.GetControlChrid() or player_chara
	var1 = event.GetEventData_2(13) or var1
	var2 = event.GetEventData_2(14) or var2
	print("talk_chara_id=", var1, "talk_chara=", var2, "\n")
	event.CtrlcStay()
	event.SetAi(0, var1)
	event.SetMesShippo(0, 1)
	event.SetMesPreset(0, 0)
	event.MesMake_2(0, "Tagchen.\nSch[UNI00f6]nes Wetter, nicht wahr?")
	var3 = 0
	if var2 == 400 then
		flag = event.GetFlag(640) or flag
		if flag == 0 then
			flag_2 = event.GetFlag(616) or flag_2
			if flag_2 == 0 then
				flag_3 = event.GetFlag(540) or flag_3
				if flag_3 == 0 then
					flag_4 = event.GetFlag(536) or flag_4
					if flag_4 == 0 then
						event.MesMake_2(
							0,
							"Gaspard ist ein m[UNI00e4]chtiger Gegner.\nDu musst immer wachsam\nbleiben, jeden Moment.<page>Du kannst ihn besiegen.\nDer Atlamillia hat dich\nnicht ohne Grund erw[UNI00e4]hlt ..."
						)
					else
						event.MesMake_2(
							0,
							"Tja, Gaspard war auch unzufrieden.<page>Was will Griffon nur -\nda legt er sich mit Leuten\naus zwei Zeitaltern an ..."
						)
					end
				else
					event.MesMake_2(
						0,
						"Wenn jemand Griffon besiegen\nkann, dann seid ihr das.<page>Wir z[UNI00e4]hlen auf euch."
					)
				end
			else
				event.MesMake_2(
					0,
					"Die Chrono-Verbindung ...\nDie Welt wird also durch das\nWissen der Alten gerettet ..."
				)
			end
		else
			event.MesMake_2(
				0,
				"So - das ist es also. Das Blut\nvieler Freunde wurde im Kampf\ngegen Griffon vergossen ...<page>Ihr seid unsere letzte Hoffnung!\nIch z[UNI00e4]hle auf euch, Max und Monica.\nIhr m[UNI00fc]sst Griffon besiegen!"
			)
		end
	end
	if var2 == 401 then
		flag_5 = event.GetFlag(640) or flag_5
		if flag_5 == 0 then
			flag_6 = event.GetFlag(616) or flag_6
			if flag_6 == 0 then
				flag_7 = event.GetFlag(540) or flag_7
				if flag_7 == 0 then
					flag_8 = event.GetFlag(536) or flag_8
					if flag_8 == 0 then
						flag_9 = event.GetFlag(520) or flag_9
						if flag_9 == 0 then
							event.MesMake_2(
								0,
								"Na gut. Zuerst m[UNI00fc]sst ihr die\nFeuer-B[UNI00f6]e vernichten.<page>Wenn wir nichts gegen diesen\nFeuerregen unternehmen, ist\nHeim Rada erledigt."
							)
						else
							event.MesMake_2(
								0,
								"Na gut, das ist also passiert.\nWir sollten wohl froh sein,\ndass die Feuer-B[UNI00f6]e weg ist."
							)
							helper_560bd8b6(player_chara, var1, 0)
							if vm.skipping() then
								return skip(1)
							end
							helper_e84a97e1(0, -1, var1, player_chara, 0)
							if vm.skipping() then
								return skip(2)
							end
							var3 = 1
							event.MesMake_2(
								0,
								"Aber ich mache mir Sorgen um\ndeine Freundin, die in den Krater\ngefallen ist.<page>Aber das einzige, was wir tun\nk[UNI00f6]nnen, ist wohl Heim Rada wieder\naufzubauen und die<page>Werkstatt noch besser zu\nmachen als vorher."
							)
						end
					else
						event.MesMake_2(
							0,
							"Ihr habt Gaspard besiegt!\nIhr seid echt unglaublich!<page>Jetzt geht's um seinen Chef,\nKaiser Griffon. Erledigt die\nSache ein f[UNI00fc]r alle Mal!"
						)
					end
				else
					event.MesMake_2(
						0,
						"Ich war so froh, Paznos in\nAktion zu sehen, dass ich\nweinen musste.<page>All unsere Arbeit\nhat sich endlich bezahlt\ngemacht."
					)
				end
			else
				event.MesMake_2(0, "Edelstein? Tut mir Leid,\nvon solchem Zeug hab\nich gar keine Ahnung.")
			end
		else
			event.MesMake_2(0, "Endlich stellt ihr Griffon, ja?\nViel Gl[UNI00fc]ck. Erledigt ihn!")
		end
	end
	if var2 == 402 then
		event.MesMake_2(0, "Hallo! Wir haben lauter\ntolle Sachen hier! Was\ndarf's denn sein?")
	end
	if var2 == 403 then
		event.MesMake_2(0, "Was immer du brauchst, ich\nhab's da. Ich bin dein\nMann!")
	end
	if var2 == 404 then
		event.MesMake_2(
			0,
			"K[UNI00e4]mpfe k[UNI00f6]nnen sehr schwierig\nsein. Man kann nicht immer\neinfach drauflosst[UNI00fc]rmen.<page>Wer cool ist, benutzt auch\nGegenst[UNI00e4]nde. Finde den\nSchwachpunkt deines Gegners<page>und nutze ihn aus."
		)
	end
	if var2 == 405 then
		event.MesMake_2(
			0,
			"Es gibt nichts, was wir hier in\nder Gundorada-Werkstatt nicht\nbauen k[UNI00f6]nnten.<page>Ob gro[UNI00df], ob klein -\nwir bauen's dir."
		)
	end
	if var2 == 406 then
		event.MesMake_2(
			0,
			"He, wie seid ihr hier rein-\ngekommen? Passt lieber\nauf hier.<page>Es kann hier recht\ngef[UNI00e4]hrlich werden."
		)
	end
	if var2 == 407 then
		event.MesMake_2(0, "Was war denn die ganze Zeit\nlos? Ich kann mich einfach\nan nichts erinnern.")
	end
	if var2 == 408 then
		event.MesMake_2(
			0,
			"Wir wurden also alle von\nGriffon ausgel[UNI00f6]scht, ja? Er\nmuss ein schreckliches Monster sein."
		)
	end
	if var2 == 409 then
		event.MesMake_2(0, "Ich bin gerade sehr besch[UNI00e4]ftigt.\nBitte geh aus dem Weg.")
	end
	if var2 == 410 then
		event.MesMake_2(0, "Wir stehen alle hinter euch.\nUnd zwar zu 100 Prozent.")
	end
	if var2 == 411 then
		event.MesMake_2(
			0,
			"Die Waffen in dieser Kiste\nsind wohl nicht zu verkaufen.<page>Aber es gibt schon komische,\nsonderbare Waffen,\nnicht wahr ...?"
		)
	end
	if var2 == 412 then
		event.MesMake_2(
			0,
			"Dieser Gaspard kann also die\nFeuer-B[UNI00f6]e entfesseln?<page>Er ist nicht nur hinterlistig,\ner ist wahrhaft b[UNI00f6]se."
		)
	end
	if var2 == 413 then
		event.MesMake_2(
			0,
			"Was soll das Herz auf diesem\nSchild ...?<page>Das ist ziemlich widerlich,\nwenn du mich fragst ..."
		)
	end
	if var3 == 0 then
		helper_9d79a7c9(var1, -1, 0, 0)
		if vm.skipping() then
			return skip(3)
		end
	end
	if var3 == 1 then
		helper_e84a97e1(0, -1, var1, player_chara, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.SetMotion(var1, "立ち")
		event.Finish()
	end
	if var3 == 2 then
		event.SetCameraPos(1.39, 51.09, 278.55)
		event.SetCameraRef(-54.8, 23.29, 223.57)
		player_chara_2 = event.GetControlChrid() or player_chara_2
		do
			local out1, _, out3 = event.GetCharaPos(player_chara_2)
			var14 = out1 or var14
			var16 = out3 or var16
		end
		do
			local out1, _, out3 = event.GetCharaPos(var1)
			var17 = out1 or var17
			var19 = out3 or var19
		end
		var20 = event.GetRotLookPos(var17 - var14, var19 - var16) or var20
		helper_dd5d7f5f(player_chara_2, var20)
		if vm.skipping() then
			return skip(5)
		end
		event.SetCharaRot(player_chara_2, 0.0, var20, 0.0)
		event.SetMotion(player_chara_2, "立ち")
		helper_e84a97e1(0, -1, var1, player_chara_2, 0)
		if vm.skipping() then
			return skip(6)
		end
		event.ResetCamera(1, 3.1415927)
	end
	event.SetAi(1, var1)
	if var2 == 402 then
		helper_36061c78(30)
		if vm.skipping() then
			return skip(7)
		end
	end
	if var2 == 403 then
		helper_36061c78(28)
		if vm.skipping() then
			return skip(8)
		end
	end
	if var2 == 404 then
		helper_36061c78(29)
		if vm.skipping() then
			return skip(9)
		end
	end
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 99.
-- Defined empty, so the engine runs this instead of its default.
script[99] = function() end

--- Program 100.
script[100] = function()
	local flag: s32 = 0
	local var1: s32 = 0
	local flag_2: s32 = 0
	local chara_id: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			local _ = helper_10e40()
			var1 = 1
			helper_182d0()
			if not vm.skipping() then
				return part2()
			end
		end
	end
	function part2()
		if var1 == 1 then
			return
		end
		flag_2 = event.GetFlag(536) or flag_2
		if flag_2 ~= 0 then
			chara_id = event.GetCharaId(400) or chara_id
			event.CharaActive(0, chara_id)
		end
		event.SetCharaPos(0, 0.0, 30.0, -180.0)
		event.SetCharaRot(0, 0.0, 0.0, 0.0)
		event.ResetCamera(1, 0.0, 10.0)
		event.SetFadeIn(15)
	end
	var1 = 0
	flag = event.GetFlag(524) or flag
	if flag == 0 then
		var1 = 1
		event.AddItem(354, 1)
		helper_13674()
		if vm.skipping() then
			return skip(1)
		end
	end
	if helper_10e40() ~= 0 then
		var1 = 1
		event.AddItem(82, 1)
		helper_182d0()
		if vm.skipping() then
			return skip(2)
		end
	end
	return part2()
end

--- Program 150.
-- Defined empty, so the engine runs this instead of its default.
script[150] = function() end

--- Program 551.
script[551] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetFadeOut(15)
	helper_efffcfbb(15)
	if vm.skipping() then
		return skip(1)
	end
	event.MapJump(-1, "f04")
	if vm.wait() then
		return skip(2)
	end
end

--- Program 1000.
script[1000] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_e61c()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 15240.
script[15240] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_13674()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 15600.
script[15600] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_182d0()
	if vm.skipping() then
		return skip(1)
	end
end

return script
