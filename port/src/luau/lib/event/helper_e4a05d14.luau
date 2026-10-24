--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0958ca60 = require("@lib/event/helper_0958ca60")
local helper_238b5abc = require("@lib/event/helper_238b5abc")
local helper_25abe6d2 = require("@lib/event/helper_25abe6d2")
local helper_344d6cd8 = require("@lib/event/helper_344d6cd8")
local helper_8cd371d7 = require("@lib/event/helper_8cd371d7")
local helper_9cbdc640 = require("@lib/event/helper_9cbdc640")
local helper_c624bc16 = require("@lib/event/helper_c624bc16")
local helper_d3f20302 = require("@lib/event/helper_d3f20302")
local helper_e34416e2 = require("@lib/event/helper_e34416e2")

--- Helper function.
local function helper_e4a05d14()
	local var0: s32 = 0
	local block: s32 = 0
	local angle: f32 = 0
	local var3: s32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var12: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	local at: number = 0
	vm.section(function()
		event.SetFadeOut(0)
		event.SetFlag(204, 1)
		event.Initialize()
		event.SetMesWindowMode(0, 7)
		event.StopBgm(0)
		at = 1
		helper_25abe6d2(4)
		event.LoadBgm(191)
		event.LoadSound(2203)
		var0 = event.SndLoadSound_2(2203) or var0
		event.AssignStack(5)
		event.ClearStack(5)
		event.ChangeDir("event/e200/e204/")
		event.LoadMes(0, 5, "e204_1.txt")
		event.LoadMotion(5, "e204_mints.gltf", "info", 0)
		event.CharaActive(0, 0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.LoadChara(5, "e204_starbre.gltf", "info", 32)
		event.CharaActive(0, 32)
		event.EohSyncChara(1, 32)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.LoadChara(5, "bomb.gltf", "info", 33)
		event.CharaActive(0, 33)
		event.SetReference(32, "bomb", 33)
		event.LoadChara(5, "e204_buggy.gltf", "info", 34)
		event.CharaActive(0, 34)
		event.EohSyncChara(3, 34)
		event.ObjsInit(3)
		event.ObjsSyncObj(3, 3)
		event.LoadChara(5, "e204_polcurse.gltf", "info", 35)
		event.CharaActive(0, 35)
		event.EohSyncChara(4, 35)
		event.ObjsInit(4)
		event.ObjsSyncObj(4, 4)
		event.SetReference(34, "polcurse_chair", 35)
		event.LoadChara(5, "e204_macho.gltf", "info", 36)
		event.CharaActive(0, 36)
		event.SetReference(34, "macho_chair", 36)
		event.LoadChara(5, "gun_fire.gltf", "info", 37)
		event.CharaActive(0, 37)
		event.SetReference(34, "dcol00", 37)
		event.LoadChara(5, "gun_hit.gltf", "info", 38)
		event.CharaActive(0, 38)
		event.EohSyncChara(9, 38)
		event.ObjsInit(8)
		event.ObjsSyncObj(8, 9)
		block = event.LoadImg_4(5, "e204telop01_1.json", 0) or block
		event.SpriteInit(0)
		event.SpriteSetType(0, 0)
		event.SpriteSetTexture(0, "e204telop01", block)
		event.SpriteSetColor(0, 128, 128, 128, 0)
		event.SpriteSetUvsize(0, 0, 0, 512, 128)
		event.SpriteSetPutsize(0, 512, 128)
		event.SpriteSetPos(0, 256, 312)
		event.SpriteSetAlphab(0, 0)
		event.SpriteSetDraw(0, 0)
		event.EohSyncSprite(10, 0)
		event.ObjsInit(9)
		event.ObjsSyncObj(9, 10)
		event.ChangeDir("")
		event.EsmInitialize(5, 1)
		event.EsmLoadBase("バギー砂煙")
		event.EsmInitFix(5)
		event.EohSyncObj_4(5, "p01_s03t", "s03t01-m", "door01-")
		event.ObjsInit(5)
		event.ObjsSyncObj(5, 5)
		event.ObjsSetPos(0, 0.0, 133.53, -321.16)
		event.ObjsSetRot(0, 0.0, 3.14, 0.0)
		event.ObjsTexAnime(0, 0)
		event.ObjsTexAnime(0, 1, "おこり顔")
		event.ObjsTexAnime(0, 1, "おこり目パチ")
		event.EohSetFootSoundId(0, 6)
		event.ObjsSetPos(1, 0.0, 114.0, -303.0)
		event.ObjsSetRot(1, 0.0, 3.14, 0.0)
		event.ObjsSetMotion(1, "屋根つかまり立ち", 4)
		event.ObjsTexAnime(1, 0)
		event.ObjsTexAnime(1, 0)
		event.ObjsTexAnime(1, 1, "おこり顔")
		event.ObjsTexAnime(1, 1, "通常目パチ")
		event.ObjsSetPos(3, 240.0, 0.0, -1200.0)
		event.ObjsSetMotion(3, "走行", 4)
		event.ObjsSetMotion(4, "走行", 4)
		event.ObjsTexAnime(4, 0)
		event.ObjsTexAnime(4, 0, "ニヤリ口")
		event.ObjsTexAnime(4, 1, "わらい口パク")
		event.ObjsSetPos(8, 76.0, 68.0, -1100.0)
		event.ObjsSetRot(8, 0.0, 1.57, 0.0)
		event.EsmCreate_2("バギー砂煙", 34)
		event.StreamOpen3(1, 2040010)
		at = 2
		helper_9cbdc640(1)
		event.CmrsInit()
		event.InitDramaScene()
		event.SndSePlay(var0, 0)
		event.CmrsSetPos(380.6, 127.31, 601.72)
		event.CmrsSetRef(243.08, 107.4, 438.53)
		event.CmrsMove(325.48, 121.86, 412.81, 208.11, 101.95, 231.83, 90)
		event.SetFadeIn(30)
		at = 3
		helper_c624bc16()
		event.CmrsSetPos(-160.48, 189.72, -401.22)
		event.CmrsSetRef(-1.58, 128.85, -292.36)
		event.CharaActive(0)
		event.ObjsSetMotion(0, "屋根に登る", 6)
		event.ObjsNextMotion(0, "屋根に登るL", 4)
		event.SndSePlay(var0, 1)
		event.FuncPointShow("p01_s03t", "door", 1)
		at = 4
		helper_25abe6d2(65)
		event.FuncPointShow("p01_s03t", "door", 0)
		event.CmrsSetPos(0.0, 155.31, -427.57)
		event.CmrsSetRef(0.0, 151.56, -332.61)
		at = 5
		helper_0958ca60(0)
		event.CmrsSetPos(-9.82, 215.27, -230.06)
		event.CmrsSetRef(42.69, 136.67, -377.81)
		event.CharaActive(35)
		event.CharaActive(34)
		event.CharaActive(36)
		event.ObjsMove(3, 266.0, 0.0, -800.0, 40)
		at = 6
		helper_25abe6d2(10)
		event.ObjsSetMotion(0, "下を見る", 6)
		event.ObjsNextMotion(0, "下を見るL", 4)
		event.PlayBgm(0)
		at = 7
		helper_0958ca60(3)
		event.ObjsSetRot(5, 0.0, 0.0, 0.0)
		event.CmrsSetPos(240.0, 70.33, -441.97)
		event.CmrsSetRef(240.0, 35.77, -608.94)
		event.StreamPlay(1)
		event.SndSePlay(var0, 2)
		event.SndSePlay(var0, 3)
		event.ObjsAddPos(3, 0.0, 0.0, 5.0, 40)
		event.ObjsRotation2(3, 0.0, -0.46, 0.0, 6, 0, 1.0)
		event.ObjsRotation2(3, 0.0, 0.46, 0.0, 10, 0, 1.0)
		event.ObjsRotation2(3, 0.0, 0.0, 0.0, 10, 0, 1.0)
		angle = 0.0
		var3 = 0
		while var3 < 40 do
			do
				local out1, out2, out3 = event.GetCharaPos(34)
				var4 = out1 or var4
				var5 = out2 or var5
				var6 = out3 or var6
			end
			var4 = vm.f32(vm.f32(vm.sin(angle) * 30.0) + 240.0)
			event.SetCharaPos(34, var4, var5, var6)
			angle = vm.f32(angle + vm.f32(0.15707964))
			angle = event.AngleLimit(angle) or angle
			var3 = var3 + 1
			at = 8
			vm.wait(8)
		end
		event.CmrsSetPos(235.72, 76.51, -605.47)
		event.CmrsSetRef(235.07, 76.26, -631.38)
		event.ObjsSetMotion(4, "走行2", 4)
		event.ObjsSetMotion(3, "走行2", 4)
		at = 9
		helper_0958ca60(3)
		event.ObjsSetMotion(4, "ニヤリ", 2)
		event.ObjsNextMotion(4, "ニヤリL", 4)
		at = 10
		helper_25abe6d2(40)
		event.CmrsSetPos(210.48, 75.88, -1380.83)
		event.CmrsSetRef(212.75, 63.09, -1231.67)
		event.CmrsMove(210.48, 75.88, -1380.83, 168.48, 63.09, -1255.36, 60)
		event.CharaActive(1, 38)
		event.ObjsResetMotion(8)
		event.ObjsSetMotion(8, "連射", 4)
		var7 = -1000.0
		var8 = 0
		while var8 < 4 do
			var7 = vm.f32(var7 - 20.0)
			event.ObjsSetPos(8, 76.0, 60.0, var7)
			event.ObjsPosDelay(8, 5)
			var8 = var8 + 1
		end
		var8 = 0
		while var8 < 4 do
			var7 = vm.f32(var7 + 20.0)
			event.ObjsSetPos(8, 76.0, 60.0, var7)
			event.ObjsPosDelay(8, 5)
			var8 = var8 + 1
		end
		var8 = 0
		while var8 < 4 do
			var7 = vm.f32(var7 - 20.0)
			event.ObjsSetPos(8, 76.0, 60.0, var7)
			event.ObjsPosDelay(8, 5)
			var8 = var8 + 1
		end
		event.SndSePlay(var0, 4)
		event.CharaActive(1, 37)
		event.ObjsSetPos(3, 240.0, 0.0, -1100.0)
		event.ObjsSetRot(3, 0.0, 0.0, 0.0)
		event.ObjsSetMotion(3, "攻撃", 4, -1.0, 1)
		event.ObjsSetMotion(4, "攻撃", 4)
		at = 11
		helper_c624bc16()
		event.CharaActive(0, 38)
		event.CmrsSetPos(369.35, 68.75, -1068.56)
		event.CmrsSetRef(281.32, 69.68, -1068.4)
		event.CmrsMove(369.27, 68.75, -1111.17, 281.24, 69.68, -1111.0, 90)
		event.ObjsSetMotion(3, "ノリノリ", 4, -1.0, 1)
		event.ObjsSetMotion(4, "ノリノリ", 4)
		at = 12
		helper_c624bc16()
		event.SndSeStop(var0, 2)
		event.CharaActive(0, 37)
		event.StreamClose(1)
		event.ObjsTexAnime(4, 0, "わらい口パク")
		event.ObjsTexAnime(4, 1, "ニヤリ口")
		event.CmrsSetPos(3.09, 138.1, -353.16)
		event.CmrsSetRef(2.77, 152.0, -320.76)
		event.SndSePlay(var0, 5)
		event.SetPakuAnim(0, "通常口パク")
		at = 13
		helper_e34416e2(2040020)
		event.ObjsTexAnime(0, 0, "おこり顔")
		event.ObjsTexAnime(0, 1, "きづく顔")
		at = 14
		helper_e34416e2(2040030)
		event.ObjsTexAnime(0, 1, "おこり顔")
		event.ObjsTexAnime(0, 0, "きづく顔")
		event.CmrsSetPos(11.47, 169.65, -362.8)
		event.CmrsSetRef(-5.1, 143.73, -320.45)
		event.SndSePlay(var0, 6)
		event.CharaActive(32)
		event.ObjsSetPos(0, 0.0, 133.53, -348.54)
		event.ObjsSetMotion(0, "振り返る", 6, 1)
		event.ObjsNextMotion(0, "振り返るL", 4)
		at = 15
		helper_0958ca60(0)
		event.ObjsSetMotion(1, "つかまり会話", 2)
		event.ObjsNextMotion(1, "屋根つかまり立ち", 4)
		event.SetPakuAnim(1, "大口パク")
		at = 16
		helper_e34416e2(2040040)
		at = 17
		helper_0958ca60(1)
		event.ObjsSetMotion(0, "振り返る会話", 2)
		event.ObjsNextMotion(0, "振り返るL", 4)
		event.SetPakuAnim(0, "通常口パク")
		at = 18
		helper_e34416e2(2040050)
		at = 19
		helper_0958ca60(0)
		event.CmrsSetPos(0.0, 135.98, -348.92)
		event.CmrsSetRef(0.0, 139.71, -310.0)
		event.ObjsSetPos(0, 0.0, 0.0, -348.54)
		event.ObjsSetMotion(1, "爆弾を取る", 6)
		event.ObjsNextMotion(1, "屋根つかまり立ち", 4)
		at = 20
		helper_25abe6d2(30)
		event.SndSePlay(var0, 7)
		event.ObjsTexAnime(1, 0, "おこり顔")
		event.ObjsTexAnime(1, 1, "わらい顔")
		event.CharaActive(33)
		at = 21
		helper_25abe6d2(30)
		do
			local out1, out2, out3 = event.EohGetFramePos(1, "bomb")
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		event.DelReference(33)
		event.SetCharaPos(33, pos_x, pos_y, pos_z)
		event.SetCharaRot(33, 0.0, 3.14, 0.0)
		event.SndSePlay(var0, 8)
		at = 22
		helper_0958ca60(1)
		event.SetPakuAnim(1, "わらい口パク")
		at = 23
		helper_e34416e2(2040060)
		event.CmrsSetPos(60.12, 164.95, -266.6)
		event.CmrsSetRef(-4.48, 133.95, -322.74)
		event.ObjsSetPos(0, 0.0, 133.53, -348.54)
		event.ObjsResetDaPosition(0)
		event.ObjsSetMotion(0, "振り返る会話", 6, -1.0, 1)
		event.ObjsNextMotion(0, "振り返るL", 4)
		event.SetPakuAnim(0, "通常口パク")
		at = 24
		helper_e34416e2(2040070)
		at = 25
		helper_0958ca60(0)
		event.ObjsSetMotion(1, "つかまり会話", 2)
		event.ObjsNextMotion(1, "屋根つかまり立ち", 4)
		event.SetPakuAnim(1, "わらい口パク")
		at = 26
		helper_e34416e2(2040080)
		event.SetPakuAnim(1, "わらい口パク")
		at = 27
		helper_e34416e2(2040085)
		at = 28
		helper_0958ca60(1)
		event.SetPakuAnim(0, "通常口パク")
		at = 29
		helper_e34416e2(2040090)
		event.SndSeStop(var0, 5)
		event.CmrsSetPos(265.45, 83.77, -902.43)
		event.CmrsSetRef(166.76, 61.63, -1102.39)
		event.SndSePlay(var0, 2)
		event.SndSePlay(var0, 9)
		event.CharaActive(1, 38)
		var7 = -1000.0
		var8 = 0
		while var8 < 4 do
			var7 = vm.f32(var7 - 20.0)
			event.ObjsSetPos(8, 76.0, 60.0, var7)
			event.ObjsPosDelay(8, 5)
			var8 = var8 + 1
		end
		var8 = 0
		while var8 < 4 do
			var7 = vm.f32(var7 + 20.0)
			event.ObjsSetPos(8, 76.0, 60.0, var7)
			event.ObjsPosDelay(8, 5)
			var8 = var8 + 1
		end
		var8 = 0
		while var8 < 4 do
			var7 = vm.f32(var7 - 20.0)
			event.ObjsSetPos(8, 76.0, 60.0, var7)
			event.ObjsPosDelay(8, 5)
			var8 = var8 + 1
		end
		event.CharaActive(1, 37)
		event.ObjsSetMotion(3, "攻撃", 4, -1.0, 1)
		event.ObjsSetMotion(4, "攻撃", 4)
		at = 30
		helper_25abe6d2(60)
		event.CharaActive(0, 37)
		event.CharaActive(0, 38)
		event.CmrsSetPos(251.7, 76.66, -1109.07)
		event.CmrsSetRef(237.17, 73.79, -1129.16)
		event.ObjsSetMotion(3, "ニヤリ2", 6, -1.0, 1)
		event.ObjsNextMotion(3, "ニヤリ2L", 4)
		event.ObjsSetMotion(4, "ニヤリ2", 6)
		event.ObjsNextMotion(4, "ニヤリ2L", 4)
		at = 31
		helper_25abe6d2(40)
		event.SndSeStop(var0, 2)
		event.CmrsSetPos(19.44, 139.93, -287.75)
		event.CmrsSetRef(-8.51, 144.37, -325.96)
		event.SndSePlay(var0, 5)
		event.SndSePlay(var0, 10)
		event.ObjsSetMotion(0, "顔を戻す", 6)
		event.ObjsNextMotion(0, "やってみる！", 6)
		event.ObjsNextMotion(0, "振り返るL", 4)
		at = 32
		helper_25abe6d2(10)
		event.SetPakuAnim(0, "通常口パク")
		at = 33
		helper_e34416e2(2040100)
		at = 34
		helper_0958ca60(0)
		event.ObjsSetMotion(1, "つかまり会話", 2)
		event.ObjsNextMotion(1, "屋根つかまり立ち", 4)
		at = 35
		helper_e34416e2(2040110)
		at = 36
		helper_0958ca60(1)
		event.SndSeStop(var0, 5)
		event.SndSeStop(var0, 10)
		event.CmrsSetPos(240.0, 37.39, -800.0)
		event.CmrsSetRef(240.0, 42.12, -900.0)
		event.ObjsMove(3, 240.0, 0.0, -860.0, 90)
		event.CharaActive(1, 37)
		event.SndSePlay(var0, 2)
		event.SndSePlay(var0, 11)
		event.SndSePlay(var0, 12)
		event.ObjsSetMotion(3, "攻撃戻り", 6, -1.0, 1)
		event.ObjsNextMotion(3, "走行2", 4)
		event.ObjsSetMotion(4, "攻撃戻り", 6)
		event.ObjsNextMotion(4, "走行2", 4)
		at = 37
		helper_25abe6d2(10)
		event.CharaActive(0, 37)
		event.SpriteSetDraw(0, 1)
		event.ObjsSetColor(9, 128, 128, 128, 128, 30)
		var3 = 0
		var12 = 6.0
		var13 = 0.0
		var14 = vm.f32(0.01)
		while true do
			var12 = vm.f32(var12 - var13)
			var13 = vm.f32(var13 + var14)
			if var12 < 1.0 then
				event.ObjsSetScale(9, 1.0, 1.0, 1.0)
				break
			else
				event.ObjsSetScale(9, var12, var12, var12)
				var3 = vm.i32(var3 + 1)
				at = 38
				vm.wait(38)
			end
		end
		at = 39
		helper_25abe6d2(vm.i32(70 - var3))
		event.SetFadeOut(10)
		at = 40
		helper_25abe6d2(10)
	end, function(received: { any }): boolean
		if at <= 1 then
			helper_238b5abc(1)
		end
		if at <= 2 then
			helper_344d6cd8()
		end
		if at <= 3 then
			helper_d3f20302(65)
		end
		if at <= 4 then
			helper_238b5abc(0)
		end
		if at <= 5 then
			helper_d3f20302(10)
		end
		if at <= 6 then
			helper_238b5abc(3)
		end
		if at <= 7 then
			angle = 0.0
			var3 = 0
			var4 = vm.f32(vm.f32(vm.sin(angle) * 30.0) + 240.0)
			angle = vm.f32(angle + vm.f32(0.15707964))
			local _ = var3 < 40
			var3 = var3 + 1
		end
		if at <= 8 then
			helper_238b5abc(3)
		end
		if at <= 9 then
			helper_d3f20302(40)
		end
		if at <= 10 then
			var7 = -1000.0
			var8 = 0
			var7 = vm.f32(var7 - 20.0)
			local _ = var8 < 4
			var8 = var8 + 1
			var8 = 0
			var7 = vm.f32(var7 + 20.0)
			local _ = var8 < 4
			var8 = var8 + 1
			var8 = 0
			var7 = vm.f32(var7 - 20.0)
			local _ = var8 < 4
			var8 = var8 + 1
			helper_344d6cd8()
		end
		if at <= 11 then
			helper_344d6cd8()
		end
		if at <= 12 then
			helper_8cd371d7(2040020)
		end
		if at <= 13 then
			helper_8cd371d7(2040030)
		end
		if at <= 14 then
			helper_238b5abc(0)
		end
		if at <= 15 then
			helper_8cd371d7(2040040)
		end
		if at <= 16 then
			helper_238b5abc(1)
		end
		if at <= 17 then
			helper_8cd371d7(2040050)
		end
		if at <= 18 then
			helper_238b5abc(0)
		end
		if at <= 19 then
			helper_d3f20302(30)
		end
		if at <= 20 then
			helper_d3f20302(30)
		end
		if at <= 21 then
			helper_238b5abc(1)
		end
		if at <= 22 then
			helper_8cd371d7(2040060)
		end
		if at <= 23 then
			helper_8cd371d7(2040070)
		end
		if at <= 24 then
			helper_238b5abc(0)
		end
		if at <= 25 then
			helper_8cd371d7(2040080)
		end
		if at <= 26 then
			helper_8cd371d7(2040085)
		end
		if at <= 27 then
			helper_238b5abc(1)
		end
		if at <= 28 then
			helper_8cd371d7(2040090)
		end
		if at <= 29 then
			var7 = -1000.0
			var8 = 0
			var7 = vm.f32(var7 - 20.0)
			local _ = var8 < 4
			var8 = var8 + 1
			var8 = 0
			var7 = vm.f32(var7 + 20.0)
			local _ = var8 < 4
			var8 = var8 + 1
			var8 = 0
			var7 = vm.f32(var7 - 20.0)
			local _ = var8 < 4
			var8 = var8 + 1
			helper_d3f20302(60)
		end
		if at <= 30 then
			helper_d3f20302(40)
		end
		if at <= 31 then
			helper_d3f20302(10)
		end
		if at <= 32 then
			helper_8cd371d7(2040100)
		end
		if at <= 33 then
			helper_238b5abc(0)
		end
		if at <= 34 then
			helper_8cd371d7(2040110)
		end
		if at <= 35 then
			helper_238b5abc(1)
		end
		if at <= 36 then
			helper_d3f20302(10)
		end
		if at <= 37 then
			var3 = 0
			var12 = 6.0
			var13 = 0.0
			var14 = vm.f32(0.01)
			var12 = vm.f32(var12 - var13)
			var13 = vm.f32(var13 + var14)
			var3 = var3 + 1
		end
		if at <= 38 then
			helper_d3f20302(70 - var3)
		end
		if at <= 39 then
			helper_d3f20302(10)
		end
		return true
	end)
	event.CancelDramaScene()
	event.PlayBgm(0)
	event.SndSeStop(var0, 2)
	event.SndSeStop(var0, 4)
	event.SndSeStop(var0, 5)
	event.SndSeStop(var0, 9)
	event.SndSeStop(var0, 10)
	event.SpriteSetDraw(0, 0)
	event.FuncPointShow("p01_s03t", "door", 0)
	event.EohSetRot(5, 0.0, 0.0, 0.0)
	event.DelExtMotion(0)
	event.DeleteChara(32)
	event.DeleteChara(33)
	event.DeleteChara(34)
	event.DeleteChara(35)
	event.DeleteChara(36)
	event.DeleteChara(37)
	event.DeleteChara(38)
	event.DelImg(0)
	event.EsmClear()
	event.LoadMes(0, -1)
	event.CharaActive(0)
end

return helper_e4a05d14
