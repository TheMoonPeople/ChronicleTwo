--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_338a95d5 = require("@lib/event/helper_338a95d5")
local helper_690ecd8a = require("@lib/event/helper_690ecd8a")
local helper_af3fca28 = require("@lib/event/helper_af3fca28")
local helper_c2e04add = require("@lib/event/helper_c2e04add")
local helper_ce122344 = require("@lib/event/helper_ce122344")
local helper_d4b8f712 = require("@lib/event/helper_d4b8f712")
local helper_e9042a30 = require("@lib/event/helper_e9042a30")
local helper_e912abf8 = require("@lib/event/helper_e912abf8")
local helper_f9ade7b9 = require("@lib/event/helper_f9ade7b9")

--- Helper function.
local function helper_2cab80e5()
	local var2: s32 = 0
	local var3: s32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local block: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 55 then
			if at <= 1 then
				helper_af3fca28(4)
			end
			if at <= 2 then
				helper_af3fca28(0)
			end
			if at <= 3 then
				helper_690ecd8a(40)
			end
			if at <= 4 then
				helper_ce122344(1030010, 30)
			end
			if at <= 5 then
				helper_338a95d5(1)
			end
			if at <= 6 then
				helper_af3fca28(0)
			end
			if at <= 7 then
				helper_d4b8f712()
			end
			if at <= 8 then
				helper_690ecd8a(60)
			end
			if at <= 9 then
				helper_e912abf8(0, vm.f32(0.45), -1.0, 30)
			end
			if at <= 10 then
				helper_690ecd8a(10)
			end
			if at <= 11 then
				helper_e9042a30(1030020)
			end
			if at <= 12 then
				helper_af3fca28(0)
			end
			if at <= 13 then
				helper_e9042a30(1030030)
			end
			if at <= 14 then
				helper_e9042a30(1030031)
			end
			if at <= 15 then
				helper_e9042a30(1030040)
			end
			if at <= 16 then
				helper_e912abf8(0, vm.f32(0.275), -1.0, 30)
			end
			if at <= 17 then
				helper_e912abf8(0, vm.f32(0.6), -1.0, 30)
			end
			if at <= 18 then
				helper_af3fca28(0)
			end
			if at <= 20 then
				var2 = 0
			end
			if at <= 21 then
				var2 = var2 + 1
				var2 = 0
			end
			if at <= 22 then
				var2 = var2 + 1
				helper_690ecd8a(15)
			end
			if at <= 23 then
				helper_690ecd8a(36)
			end
			if at <= 24 then
				helper_690ecd8a(14)
			end
			if at <= 25 then
				helper_690ecd8a(6)
			end
			if at <= 26 then
				helper_690ecd8a(48)
			end
			if at <= 27 then
				helper_e9042a30(1030050)
			end
			if at <= 28 then
				helper_690ecd8a(15)
			end
			if at <= 29 then
				helper_690ecd8a(37)
			end
			if at <= 30 then
				helper_690ecd8a(42)
			end
			if at <= 31 then
				helper_af3fca28(2)
			end
			if at <= 32 then
				helper_e9042a30(1030060)
			end
			if at <= 33 then
				helper_e9042a30(1030070)
			end
			if at <= 34 then
				helper_690ecd8a(15)
			end
			if at <= 35 then
				helper_e9042a30(1030080)
			end
			if at <= 36 then
				helper_e9042a30(1030081)
			end
			if at <= 37 then
				helper_e9042a30(1030090)
			end
			if at <= 38 then
				helper_e9042a30(1030100)
			end
			if at <= 39 then
				helper_e9042a30(1030101)
			end
			if at <= 40 then
				helper_690ecd8a(9)
			end
			if at <= 41 then
				helper_e9042a30(1030110)
			end
			if at <= 42 then
				helper_690ecd8a(10)
			end
			if at <= 43 then
				helper_e9042a30(1030120)
			end
			if at <= 44 then
				helper_e9042a30(1030130)
			end
			if at <= 45 then
				helper_e9042a30(1030140)
			end
			if at <= 46 then
				helper_690ecd8a(15)
			end
			if at <= 47 then
				helper_e9042a30(1030150)
			end
			if at <= 48 then
				helper_e9042a30(1030160)
			end
			if at <= 49 then
				helper_e9042a30(1030170)
			end
			if at <= 50 then
				helper_e9042a30(1030180)
			end
			if at <= 51 then
				helper_e9042a30(1030190)
			end
			if at <= 52 then
				helper_f9ade7b9(var3)
			end
			if at <= 53 then
				helper_c2e04add(var3)
			end
			if at <= 54 then
				helper_690ecd8a(30)
			end
			if vm.skip_end() then
				return skip(56)
			end
			return part2()
		end
		if at <= 57 then
			helper_690ecd8a(4)
		end
	end
	function part2()
		event.CancelDramaScene()
		event.DngResetTimer()
		event.EohSetFootSoundId(0, 0)
		event.EohSyncObj(4, "p08_s06", "s06_08-m1")
		event.ObjsInit(4)
		event.ObjsSyncObj(4, 4)
		event.ObjsSetPos(4, pos_x, pos_y, pos_z)
		if vm.wait() then
			return skip(57)
		end
		event.EohSyncChara(5, 1)
		event.EohSetShow(5, 1)
		event.EohSyncChara(6, 2)
		event.EohSetShow(6, 1)
		event.DelExtMotion(0)
		event.DeleteChara(9)
		event.DeleteChara(8)
		event.DeleteChara(10)
		event.StopBgm(0)
		helper_690ecd8a(4)
		if vm.skipping() then
			return skip(58)
		end
		event.LoadBgm(195)
		event.PlayBgm(0)
		event.SetFadeIn(15)
		event.SetCameraPos(-1.66, 76.3, 205.77)
		event.SetCameraRef(-0.37, 74.98, 151.36)
		event.SetCharaPos(0, 0.0, 50.0, 138.0)
		event.SetCharaRot(0, 0.0, 3.02, 0.0)
		event.ResetCamera(0)
		event.SpriteSetDraw(0, 0)
		event.DelImg(0)
		event.SetStatusbarShow(1)
		event.AutoSetMonster(614, 0.0, 50.0, 0.0, 0.0, 0.0, 0.0)
		event.Finish()
	end
	event.SetFlag(103, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.SetStatusbarShow(0, 1.0)
	event.LoadSound(1810)
	var3 = event.SndLoadSound(1810) or var3
	event.AssignStack(5)
	event.ClearStack(5)
	event.CmrsInit()
	event.LoadMes(0, 5, "event/e100/e103/e103.txt")
	event.LoadMotion(5, "event/e100/e103/e103_mints.gltf", "info", 0)
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetPos(0, 0.0, 50.0, 0.0)
	event.ObjsSetRot(0, 0.0, 50.0, 0.0)
	event.EohSyncChara(5, 1)
	event.EohSetShow(5, 0)
	event.EohSyncChara(6, 2)
	event.EohSetShow(6, 0)
	event.LoadChara(5, "event/e100/e103/e103_polcurse.gltf", "info", 9)
	event.SetCharaPos(9, -4.99, 134.6, -43.13)
	event.CharaActive(0, 9)
	event.EohSyncChara(2, 9)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.ObjsSetPos(2, 0.0, 50.0, 0.0)
	event.ObjsSetRot(2, 0.0, 50.0, 0.0)
	event.LoadChara(5, "event/e100/e103/e103_erephant.gltf", "info", 8)
	event.SetCharaPos(8, 0.0, 50.0, 0.0)
	event.CharaActive(0, 8)
	event.EohSyncChara(1, 8)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.ObjsSetPos(1, 0.0, 50.0, 0.0)
	event.ObjsSetRot(1, 0.0, 50.0, 0.0)
	event.LoadChara(5, "event/helpreceiver/helpreceiver.gltf", "info", 10)
	event.CharaActive(0, 10)
	event.SetReference(0, "ef00", 10)
	event.EohSyncObj(4, "p08_s06", "s06_08-m1")
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	do
		local out1, out2, out3 = event.EohGetPos(4)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	event.SetFadeOut(0)
	event.StopBgm(0)
	helper_690ecd8a(4)
	if vm.skipping() then
		return skip(1)
	end
	event.LoadBgm(107)
	event.EohSetFootSoundId(0, 3)
	block = event.LoadImg_4(5, "textures/event/e100/e107/e107telop01.json", 0) or block
	event.SpriteInit(0)
	event.SpriteSetType(0, 0)
	event.SpriteSetTexture(0, "e107telop01", block)
	event.SpriteSetUvsize(0, 0, 0, 512, 128)
	event.SpriteSetPutsize(0, 512, 128)
	event.SpriteSetPos(0, 320, 334)
	event.SpriteSetColor(0, 128, 128, 128, 0)
	event.SpriteSetScale(0, 1.0, 1.0)
	event.SpriteSetDraw(0, 0)
	event.EohSyncSprite(10, 0)
	event.ObjsInit(10)
	event.ObjsSyncObj(10, 10)
	event.InitDramaScene()
	event.CharaActive(1, 0)
	event.CmrsSetPos(150.75, 339.49, 988.43)
	event.CmrsSetRef(14.77, 282.74, 1151.7)
	event.ObjsSetPos(0, 9.04, 262.0, 1196.55)
	event.ObjsSetRot(0, 0.0, 3.14, 0.0)
	event.SetFadeIn(30)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "ポカーン顔")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "下見顔")
	event.ObjsTexAnime(2, 1, "目パチ")
	event.ObjsSetMotion(0, "立ち", 4, -1.0, 1)
	event.ObjsMove(4, 2.90684, 412.375, 1188.04, 30)
	helper_af3fca28(4)
	if vm.skipping() then
		return skip(2)
	end
	event.ObjsSetMotion(0, "歩き")
	event.ObjsMotionDelay(0, 50)
	event.ObjsSetMotion(0, "立ち")
	event.ObjsMove(0, 13.2, 262.0, 1143.62, 50)
	helper_af3fca28(0)
	if vm.skipping() then
		return skip(3)
	end
	event.SndSePlay(var3, 27)
	event.ObjsJump(4, 2.90684, 312.375, 1188.04, -0.2, 10)
	event.ObjsJump(4, 2.90684, 312.375, 1188.04, -0.2, 8)
	event.ObjsJump(4, 2.90684, 312.375, 1188.04, -0.2, 5)
	helper_690ecd8a(40)
	if vm.skipping() then
		return skip(4)
	end
	event.CmrsSetPos(-23.49, 275.36, 1099.63)
	event.CmrsSetRef(-3.07, 281.91, 1122.03)
	event.ObjsSetPos(0, -2.57, 262.0, 1128.46)
	event.ObjsSetRot(0, 0.0, 3.14, 0.0)
	event.SetPakuAnim(0, "通常口パク")
	helper_ce122344(1030010, 30)
	if vm.skipping() then
		return skip(5)
	end
	event.ResetPakuAnim()
	event.StreamOpen3(1, 1030015)
	helper_338a95d5(1)
	if vm.skipping() then
		return skip(6)
	end
	event.StreamPlay(1)
	event.ObjsSetMotion(0, "上を見る", 6, 0.07, 1)
	event.ObjsMotionDelay(0, 42)
	event.ObjsResetMotion(0)
	event.ObjsSetMotion(0, "上を見るL", 0, -1.0)
	event.CmrsMove2(-104.82, 278.13, 1040.91, -24.27, 291.72, 1075.2, 90, 2, 0.4)
	helper_af3fca28(0)
	if vm.skipping() then
		return skip(7)
	end
	event.StreamClose(1)
	helper_d4b8f712()
	if vm.skipping() then
		return skip(8)
	end
	event.CmrsSetPos(-2.2, 288.45, 1166.72)
	event.CmrsSetRef(-2.58, 285.44, 1130.54)
	event.ObjsSetMotion(0, "歩き", 4, -1.0, 1)
	event.ObjsMove(0, -2.98, 262.0, 1102.83, 60)
	event.CmrsMove2(-1.51, 288.45, 1196.6, -2.58, 285.44, 1130.54, 60, 2, 0.4)
	helper_690ecd8a(60)
	if vm.skipping() then
		return skip(9)
	end
	event.CharaActive(1, 10)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "無表情")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsMove(0, -25.96, 262.0, 1001.65, 90)
	event.CmrsSyncObj(0, 0.0, 20.0, 0.0, 1.67, 0.85, 38.91)
	event.ObjsSetMotion(0, "レシーバーを取り出す(歩き中)", 6, -1.0, 1)
	event.ObjsNextMotion(0, "レシーバー歩き", 4)
	event.SndSePlay(var3, 0)
	helper_e912abf8(0, vm.f32(0.45), -1.0, 30)
	if vm.skipping() then
		return skip(10)
	end
	event.SndSePlay(var3, 1)
	helper_690ecd8a(10)
	if vm.skipping() then
		return skip(11)
	end
	event.ObjsMotionDelay(0, 50)
	event.ObjsSetMotion(0, "レシーバー立ち", 0, -1.0, 1)
	event.SetPakuAnim(0, "通常口パク")
	helper_e9042a30(1030020)
	if vm.skipping() then
		return skip(12)
	end
	event.ResetPakuAnim()
	helper_af3fca28(0)
	if vm.skipping() then
		return skip(13)
	end
	event.CmrsReleaseObj()
	event.CmrsSetPos(-25.76, 295.42, 1049.41)
	event.CmrsSetRef(-24.18, 286.8, 1002.8)
	helper_e9042a30(1030030)
	if vm.skipping() then
		return skip(14)
	end
	event.SetPakuAnim(0, "通常口パク")
	helper_e9042a30(1030031)
	if vm.skipping() then
		return skip(15)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(0, "通常口パク")
	helper_e9042a30(1030040)
	if vm.skipping() then
		return skip(16)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(0, "レシーバーをなおす", 2)
	event.ObjsMotionWait(0)
	helper_e912abf8(0, vm.f32(0.275), -1.0, 30)
	if vm.skipping() then
		return skip(17)
	end
	event.SndSePlay(var3, 2)
	helper_e912abf8(0, vm.f32(0.6), -1.0, 30)
	if vm.skipping() then
		return skip(18)
	end
	event.SndSePlay(var3, 3)
	helper_af3fca28(0)
	if vm.skipping() then
		return skip(19)
	end
	event.DelReference(10)
	event.CmrsSetPos(-8.24, 302.09, 593.73)
	event.CmrsSetRef(18.03, 282.04, 991.15)
	event.ObjsSetPos(0, 18.03, 262.04, 991.15)
	event.ObjsSetMotion(0, "走り", 4, -1.0, 1)
	event.ObjsInitPas(0)
	event.ObjsSetPasFrm(0, 180)
	event.ObjsAddPas(0, 18.03, 262.04, 991.15)
	event.ObjsAddPas(0, 35.05, 262.04, 991.16)
	event.ObjsAddPas(0, 63.63, 262.04, 998.35)
	event.ObjsAddPas(0, 106.4, 262.04, 1000.0)
	event.ObjsAddPas(0, 141.73, 262.04, 990.16)
	event.ObjsAddPas(0, 155.42, 262.04, 953.13)
	event.ObjsAddPas(0, 152.72, 262.04, 922.35)
	event.ObjsAddPas(0, 131.69, 262.04, 909.25)
	event.ObjsAddPas(0, 116.83, 262.04, 907.18)
	event.ObjsAddPas(0, 65.0, 247.21, 908.16)
	event.ObjsAddPas(0, -16.98, 216.58, 908.0)
	event.ObjsAddPas(0, -72.6, 197.65, 908.51)
	event.ObjsAddPas(0, -145.02, 171.37, 906.89)
	event.ObjsStartPas(0)
	event.CmrsFadeInit()
	event.CmrsFadeDelay(150)
	event.CmrsFadeOut(30, 0.0, 0.0, 0.0)
	if vm.wait() then
		return skip(20)
	end
	var2 = 0
	while var2 < 180 do
		if var2 == 50 then
			event.EohSetFootSoundId(0, 6)
		end
		do
			local out1, out2, out3 = event.GetCharaPos(0)
			var4 = out1 or var4
			var5 = out2 or var5
			var6 = out3 or var6
		end
		event.CmrsSetRef(var4, var5 + 20.0, var6)
		if vm.wait() then
			return skip(21)
		end
		var2 = var2 + 1
	end
	event.EohSetFootSoundId(0, 2)
	event.SetFadeIn(30)
	event.CmrsSetPos(-12.28, 87.78, 633.3)
	event.CmrsSetRef(-12.36, 76.05, 565.41)
	event.ObjsSetPos(0, -12.17, 50.0, 540.63)
	event.ObjsSetRot(0, 0.0, 3.14, 0.0)
	event.ObjsSetMotion(0, "キョロキョロ歩き", 4, -1.0, 1)
	event.ObjsMove(0, -12.27, 50.0, 462.63, 60)
	var2 = 0
	while var2 < 60 do
		do
			local out1, out2, out3 = event.GetCharaPos(0)
			var4 = out1 or var4
			var5 = out2 or var5
			var6 = out3 or var6
		end
		event.CmrsSetRef(var4, var5 + 20, var6)
		if var2 == 40 then
			event.SndSePlay(var3, 4)
		end
		if vm.wait() then
			return skip(22)
		end
		var2 = var2 + 1
	end
	event.CmrsSetPos(10.57, 80.17, 211.98)
	event.CmrsSetRef(-4.39, 74.32, 228.85)
	event.ObjsSetPos(0, -5.05, 50.0, 232.5)
	event.ObjsSetRot(0, 0.0, 3.14, 0.0)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "ポカーン顔")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsSetMotion(0, "上を見る", 4, 0.07, 1)
	helper_690ecd8a(15)
	if vm.skipping() then
		return skip(23)
	end
	event.CmrsSetPos(-3.08, 61.16, 277.13)
	event.CmrsSetRef(-4.35, 72.53, 230.25)
	event.ObjsSetPos(0, -5.05, 50.0, 232.5)
	event.ObjsSetRot(0, 0.0, 3.14, 0.0)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "ポカーン顔")
	event.ObjsTexAnime(0, 1, "おこり目パチ")
	event.CmrsMove2(-3.08, 61.16, 277.13, -4.35, 103.53, 230.25, 30, 0, 0.2)
	helper_690ecd8a(36)
	if vm.skipping() then
		return skip(24)
	end
	event.CharaActive(1, 8)
	event.CmrsSetPos(-4.16, 185.18, 12.13)
	event.CmrsSetRef(-2.93, 793.4, -5.89)
	event.ObjsSetPos(1, 0.0, 704.73, 0.0)
	event.ObjsSetRot(1, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(1, "落下中", 4)
	event.ObjsMove(1, 0.0, 30.0, 0.0, 20)
	event.CmrsMove(-4.82, 50.61, 21.76, -2.93, 793.4, -5.89, 20)
	helper_690ecd8a(14)
	if vm.skipping() then
		return skip(25)
	end
	event.CmrsSetPos(28.38, 59.5, 119.0)
	event.CmrsSetRef(15.11, 66.61, 96.74)
	event.ObjsSetPos(0, -3.97, 50.0, 82.73)
	event.ObjsSetRot(0, 0.0, -3.14, 0.0)
	event.ObjsSetPos(1, 0.0, 95.0, 0.0)
	event.ObjsSetRot(1, 0.0, 0.0, 0.0)
	event.ObjsMove(1, 0.0, 50.0, 0.0, 6)
	event.ObjsSetMotion(0, "象着地", 6, -1.0, 1)
	event.ObjsNextMotion(0, "象着地L")
	event.ObjsSetMotion(1, "着地", 6)
	event.CmrsQuakeDelay(6)
	event.CmrsQuake(0.0, 1.5, 0.0, 24)
	helper_690ecd8a(6)
	if vm.skipping() then
		return skip(26)
	end
	event.PlayBgm(0)
	helper_690ecd8a(48)
	if vm.skipping() then
		return skip(27)
	end
	event.CmrsSetPos(8.34, 76.37, 68.31)
	event.CmrsSetRef(-3.92, 73.89, 83.97)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "びっくり顔")
	event.ObjsTexAnime(0, 1, "おこり目パチ")
	event.SetPakuAnim(0, "通常口パク")
	helper_e9042a30(1030050)
	if vm.skipping() then
		return skip(28)
	end
	event.ResetPakuAnim()
	event.CmrsSetPos(8.61, 67.77, 124.88)
	event.CmrsSetRef(1.17, 71.56, 84.8)
	event.ObjsSetRot(0, 0.0, 2.9, 0.0)
	event.CmrsMove2(8.61, 67.77, 124.88, 1.17, 77.23, 84.8, 44, 2, 0.4)
	event.ObjsSetMotion(1, "パオーン", 6)
	event.ObjsNextMotion(1, "立ち", 0)
	helper_690ecd8a(15)
	if vm.skipping() then
		return skip(29)
	end
	event.SndSePlay(var3, 5)
	helper_690ecd8a(37)
	if vm.skipping() then
		return skip(30)
	end
	event.CmrsQuake(0.0, 1.3, 0.0, 24)
	helper_690ecd8a(42)
	if vm.skipping() then
		return skip(31)
	end
	event.CharaActive(1, 9)
	event.CmrsSetPos(91.06, 185.9, -66.26)
	event.CmrsSetRef(-6.23, 91.91, 17.07)
	event.ObjsSetPos(0, -6.67, 50.0, 84.81)
	event.ObjsSetRot(0, 0.0, 2.9, 0.0)
	event.ObjsSetPos(2, -4.73, 162.38, -24.57)
	event.ObjsSetRot(2, 0.0, -0.12, 0.0)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おこり顔")
	event.ObjsTexAnime(0, 1, "おこり目パチ")
	event.ObjsSetMotion(2, "浮遊", 4)
	event.ObjsMove2(2, -4.73, 106.52, -24.57, 60, 2, 0.3)
	event.SndSePlay(var3, 6)
	helper_af3fca28(2)
	if vm.skipping() then
		return skip(32)
	end
	event.ObjsSetRot(0, 0.0, 3.02, 0.0)
	event.CmrsSetPos(19.38, 59.94, 120.28)
	event.CmrsSetRef(1.66, 79.89, 71.18)
	event.ObjsSetPos(2, 11.92, 134.55, -43.71)
	event.ObjsSetRot(2, 0.0, -0.24, 0.0)
	event.ObjsSetMotion(0, "上を見るL", 6, -1.0, 1)
	event.SetPakuAnim(2, "口パク1")
	helper_e9042a30(1030060)
	if vm.skipping() then
		return skip(33)
	end
	event.ResetPakuAnim()
	event.CmrsSetPos(-5.96, 89.53, 73.98)
	event.CmrsSetRef(-6.81, 73.86, 87.67)
	event.ObjsSetMotion(0, "ポルカスを見る", 6, -1.0, 1)
	event.ObjsNextMotion(0, "ポルカスを見るL")
	event.SndSePlay(var3, 7)
	event.SetPakuAnim(0, "通常口パク")
	helper_e9042a30(1030070)
	if vm.skipping() then
		return skip(34)
	end
	event.ResetPakuAnim()
	event.CmrsSetPos(8.07, 126.01, 28.15)
	event.CmrsSetRef(8.5, 154.76, -34.87)
	helper_690ecd8a(15)
	if vm.skipping() then
		return skip(35)
	end
	event.SetPakuAnim(2, "口パク1")
	helper_e9042a30(1030080)
	if vm.skipping() then
		return skip(36)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(2, "口パク1")
	helper_e9042a30(1030081)
	if vm.skipping() then
		return skip(37)
	end
	event.ResetPakuAnim()
	event.CmrsSetPos(16.03, 156.16, -10.64)
	event.CmrsSetRef(10.22, 165.33, -37.84)
	event.SetPakuAnim(2, "口パク1")
	helper_e9042a30(1030090)
	if vm.skipping() then
		return skip(38)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(2, "口パク1")
	helper_e9042a30(1030100)
	if vm.skipping() then
		return skip(39)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(2, "口パク1")
	helper_e9042a30(1030101)
	if vm.skipping() then
		return skip(40)
	end
	event.ResetPakuAnim()
	event.ObjsTexAnime(2, 1, "目とじ")
	event.ObjsSetMotion(2, "うつむく", 6)
	event.ObjsNextMotion(2, "うつむくL", 0)
	helper_690ecd8a(9)
	if vm.skipping() then
		return skip(41)
	end
	event.SetPakuAnim(2, "口パク1")
	helper_e9042a30(1030110)
	if vm.skipping() then
		return skip(42)
	end
	event.ResetPakuAnim()
	event.CmrsSetPos(-5.1, 89.1, 58.36)
	event.CmrsSetRef(-6.56, 75.02, 78.7)
	event.SndSePlay(var3, 8)
	event.ObjsSetMotion(0, "なんだって！", 6, -1.0, 1)
	event.ObjsNextMotion(0, "なんだって！L", 0)
	helper_690ecd8a(10)
	if vm.skipping() then
		return skip(43)
	end
	event.SetPakuAnim(0, "通常口パク")
	helper_e9042a30(1030120)
	if vm.skipping() then
		return skip(44)
	end
	event.ResetPakuAnim()
	event.CmrsSetPos(4.77, 158.81, -12.71)
	event.CmrsSetRef(14.01, 169.3, -54.18)
	event.ObjsTexAnime(2, 1, "目こらし")
	event.ObjsSetMotion(2, "ウフフフ", 4)
	event.SetPakuAnim(2, "口パク1")
	helper_e9042a30(1030130)
	if vm.skipping() then
		return skip(45)
	end
	event.ResetPakuAnim()
	event.CmrsSetPos(30.18, 182.63, -12.61)
	event.CmrsSetRef(-15.36, 101.5, 68.2)
	event.ObjsSetPos(0, -6.39, 50.0, 102.82)
	event.ObjsSetRot(0, 0.0, 3.14, 0.0)
	event.ObjsSetPos(2, -1.72, 117.17, 22.1)
	event.ObjsSetRot(2, 0.0, 0.12, 0.0)
	event.ObjsSetMotion(2, "浮遊", 4)
	event.SndSePlay(var3, 9)
	event.SetPakuAnim(2, "口パク1")
	helper_e9042a30(1030140)
	if vm.skipping() then
		return skip(46)
	end
	event.ResetPakuAnim()
	event.ObjsSetRot(0, 0.0, 3.02, 0.0)
	event.ObjsSetPos(2, 3.77, 134.08, 27.37)
	event.ObjsSetRot(2, 0.0, -0.12, 0.0)
	event.CmrsSetPos(9.35, 66.39, 80.83)
	event.CmrsSetRef(-6.04, 71.48, 99.69)
	event.ObjsSetMotion(0, "考える", 6)
	event.ObjsNextMotion(0, "考えるL", 0)
	helper_690ecd8a(15)
	if vm.skipping() then
		return skip(47)
	end
	helper_e9042a30(1030150)
	if vm.skipping() then
		return skip(48)
	end
	event.CmrsSetPos(1.44, 167.15, 61.09)
	event.CmrsSetRef(3.34, 165.04, 30.8)
	event.ObjsSetMotion(2, "腹を突き出す", 4)
	event.ObjsMotionDelay(2, 40)
	event.ObjsSetMotion(2, "浮遊", 4)
	event.SetPakuAnim(2, "口パク1")
	helper_e9042a30(1030160)
	if vm.skipping() then
		return skip(49)
	end
	event.ResetPakuAnim()
	event.CmrsSetPos(-21.79, 178.71, -1.18)
	event.CmrsSetRef(0.55, 132.61, 42.24)
	event.ObjsSetPos(2, 2.65, 122.38, 24.68)
	event.ObjsSetRot(2, 0.0, -0.36, 0.0)
	event.SndSePlay(var3, 10)
	event.ObjsSetMotion(0, "おことわりだよ", 6, -1.0, 1)
	event.ObjsNextMotion(0, "おことわりだよL", 0)
	event.SetPakuAnim(0, "通常口パク")
	helper_e9042a30(1030170)
	if vm.skipping() then
		return skip(50)
	end
	event.ResetPakuAnim()
	event.ObjsSetPos(2, 3.77, 134.08, 27.37)
	event.ObjsSetRot(2, 0.0, -0.12, 0.0)
	event.CmrsSetPos(-13.53, 78.7, 80.84)
	event.CmrsSetRef(-6.17, 72.32, 101.95)
	event.SetPakuAnim(0, "通常口パク")
	helper_e9042a30(1030180)
	if vm.skipping() then
		return skip(51)
	end
	event.ResetPakuAnim()
	event.CmrsSetPos(1.35, 150.19, 59.87)
	event.CmrsSetRef(3.64, 164.72, 27.05)
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "おこり顔")
	event.ObjsTexAnime(2, 1, "おこり目パチ")
	event.ObjsSetMotion(2, "プルプル", 4)
	event.SetPakuAnim(2, "おこり口パク")
	helper_e9042a30(1030190)
	if vm.skipping() then
		return skip(52)
	end
	event.ResetPakuAnim()
	event.EohSetShow(5, 1)
	event.EohSetShow(6, 1)
	helper_f9ade7b9(var3)
	if vm.skipping() then
		return skip(53)
	end
	helper_c2e04add(var3)
	if vm.skipping() then
		return skip(54)
	end
	event.ObjsSetColor(10, 128.0, 128.0, 128.0, 0.0, 15)
	event.SetFadeOut(30)
	helper_690ecd8a(30)
	if vm.skipping() then
		return skip(55)
	end
	return part2()
end

return helper_2cab80e5
