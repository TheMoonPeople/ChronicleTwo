--!strict
-- map/s/s03/s03.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_038a2e4d = require("@lib/event/helper_038a2e4d")
local helper_0958ca60 = require("@lib/event/helper_0958ca60")
local helper_1ef0d4b2 = require("@lib/event/helper_1ef0d4b2")
local helper_238b5abc = require("@lib/event/helper_238b5abc")
local helper_29101c9c = require("@lib/event/helper_29101c9c")
local helper_344d6cd8 = require("@lib/event/helper_344d6cd8")
local helper_34d64c6e = require("@lib/event/helper_34d64c6e")
local helper_479dc9e9 = require("@lib/event/helper_479dc9e9")
local helper_482d9cfc = require("@lib/event/helper_482d9cfc")
local helper_4a9b8bc5 = require("@lib/event/helper_4a9b8bc5")
local helper_53ffe901 = require("@lib/event/helper_53ffe901")
local helper_6992f518 = require("@lib/event/helper_6992f518")
local helper_7d54f41c = require("@lib/event/helper_7d54f41c")
local helper_82705ce2 = require("@lib/event/helper_82705ce2")
local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")
local helper_8cd371d7 = require("@lib/event/helper_8cd371d7")
local helper_972d1084 = require("@lib/event/helper_972d1084")
local helper_9cbdc640 = require("@lib/event/helper_9cbdc640")
local helper_a0450e0f = require("@lib/event/helper_a0450e0f")
local helper_aa5b3ebe = require("@lib/event/helper_aa5b3ebe")
local helper_c190f878 = require("@lib/event/helper_c190f878")
local helper_c624bc16 = require("@lib/event/helper_c624bc16")
local helper_c956b4a2 = require("@lib/event/helper_c956b4a2")
local helper_d16eef1e = require("@lib/event/helper_d16eef1e")
local helper_e34416e2 = require("@lib/event/helper_e34416e2")
local helper_f018b3c0 = require("@lib/event/helper_f018b3c0")
local helper_f2b0ffcb = require("@lib/event/helper_f2b0ffcb")

--- Helper function.
local function helper_df50()
	event.Initialize()
	event.CharaActive(0, 0)
	helper_888ab2a3(10)
	event.CmrsInitPas()
	event.CmrsSetPasFrm(300)
	event.CmrsAddPas(386.61, 91.3, 731.1, 156.48, 130.57, 372.4)
	event.CmrsAddPas(353.18, 76.38, 603.98, 123.05, 115.65, 245.28)
	event.CmrsAddPas(322.69, 63.43, 464.4, 92.55, 102.7, 105.69)
	event.CmrsAddPas(299.38, 56.75, 312.43, 69.25, 96.03, -46.28)
	event.CmrsAddPas(274.2, 47.43, 99.66, 44.07, 86.7, -259.05)
	event.CmrsAddPas(223.88, 41.06, -72.48, -6.26, 80.33, -431.18)
	event.CmrsAddPas(196.81, 37.0, -186.06, -33.32, 76.28, -544.77)
	event.CmrsStartPas()
	vm.wait(2)
	helper_c956b4a2(32)
	event.CharaActive(0)
end

--- Helper function.
local function helper_fe3c()
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
		helper_888ab2a3(4)
		event.LoadBgm(191)
		event.LoadSound(2203)
		var0 = event.SndLoadSound_2(2203) or var0
		event.AssignStack(5)
		event.ClearStack(5)
		event.ChangeDir("event/e200/e204/")
		event.LoadMes(0, 5, "e204.txt")
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
		block = event.LoadImg_4(5, "e204telop01.json", 0) or block
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
		helper_888ab2a3(65)
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
		helper_888ab2a3(10)
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
		helper_888ab2a3(40)
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
		helper_888ab2a3(30)
		event.SndSePlay(var0, 7)
		event.ObjsTexAnime(1, 0, "おこり顔")
		event.ObjsTexAnime(1, 1, "わらい顔")
		event.CharaActive(33)
		at = 21
		helper_888ab2a3(30)
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
		helper_888ab2a3(60)
		event.CharaActive(0, 37)
		event.CharaActive(0, 38)
		event.CmrsSetPos(251.7, 76.66, -1109.07)
		event.CmrsSetRef(237.17, 73.79, -1129.16)
		event.ObjsSetMotion(3, "ニヤリ2", 6, -1.0, 1)
		event.ObjsNextMotion(3, "ニヤリ2L", 4)
		event.ObjsSetMotion(4, "ニヤリ2", 6)
		event.ObjsNextMotion(4, "ニヤリ2L", 4)
		at = 31
		helper_888ab2a3(40)
		event.SndSeStop(var0, 2)
		event.CmrsSetPos(19.44, 139.93, -287.75)
		event.CmrsSetRef(-8.51, 144.37, -325.96)
		event.SndSePlay(var0, 5)
		event.SndSePlay(var0, 10)
		event.ObjsSetMotion(0, "顔を戻す", 6)
		event.ObjsNextMotion(0, "やってみる！", 6)
		event.ObjsNextMotion(0, "振り返るL", 4)
		at = 32
		helper_888ab2a3(10)
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
		helper_888ab2a3(10)
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
		helper_888ab2a3(vm.i32(70 - var3))
		event.SetFadeOut(10)
		at = 40
		helper_888ab2a3(10)
	end, function(received: { any }): boolean
		if at <= 1 then
			helper_238b5abc(1)
		end
		if at <= 2 then
			helper_344d6cd8()
		end
		if at <= 3 then
			helper_038a2e4d(65)
		end
		if at <= 4 then
			helper_238b5abc(0)
		end
		if at <= 5 then
			helper_038a2e4d(10)
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
			helper_038a2e4d(40)
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
			helper_038a2e4d(30)
		end
		if at <= 20 then
			helper_038a2e4d(30)
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
			helper_038a2e4d(60)
		end
		if at <= 30 then
			helper_038a2e4d(40)
		end
		if at <= 31 then
			helper_038a2e4d(10)
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
			helper_038a2e4d(10)
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
			helper_038a2e4d(70 - var3)
		end
		if at <= 39 then
			helper_038a2e4d(10)
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

--- Helper function.
local function helper_16efc()
	local var0: s32 = 0
	local result: s32 = 0
	local var2: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local at: number = 0
	vm.section(function()
		event.SetFlag(206, 1)
		event.Initialize()
		event.SetMesWindowMode(0, 7)
		event.SetProjection(524.9)
		event.StopBgm(0)
		at = 1
		helper_888ab2a3(4)
		event.LoadBgm(30)
		event.LoadSound(2209)
		var0 = event.SndLoadSound_2(2209) or var0
		event.AssignStack(5)
		event.ClearStack(5)
		event.ChangeDir("event/e200/e206/")
		event.LoadMes(0, 5, "e206.txt")
		event.LoadMotion(5, "e206_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.LoadChara(5, "p00_08a.gltf", "info", 33)
		event.CharaActive(0, 33)
		event.EohSyncChara(2, 33)
		event.ObjsInit(2)
		event.ObjsSyncObj(2, 2)
		event.LoadChara(5, "e206_starbre.gltf", "info", 34)
		event.CharaActive(34)
		event.EohSyncChara(3, 34)
		event.ObjsInit(3)
		event.ObjsSyncObj(3, 3)
		event.LoadChara(5, "e206_polcurse.gltf", "info", 35)
		event.CharaActive(0, 35)
		event.EohSyncChara(4, 35)
		event.ObjsInit(4)
		event.ObjsSyncObj(4, 4)
		event.LoadChara(5, "e206_h_polcurse.gltf", "info", 36)
		event.CharaActive(0, 36)
		event.EohSyncChara(5, 36)
		event.ObjsInit(5)
		event.ObjsSyncObj(5, 5)
		event.LoadChara(5, "b01a_buggy.gltf", "b01a_buggy", 37)
		event.CharaActive(37)
		event.EohSyncChara(6, 37)
		event.ObjsInit(6)
		event.ObjsSyncObj(6, 6)
		event.LoadChara(5, "b01a_macho.gltf", "b01a_macho", 38)
		event.CharaActive(38)
		event.SetReference(37, "macho_chair", 38)
		event.LoadChara(5, "e206_bbaku.gltf", "info", 42)
		event.LoadChara(5, "e206_bfire.gltf", "info", 43)
		event.LoadChara(5, "e206_cloth.gltf", "info", 44)
		event.LoadChara(5, "e206_dfire.gltf", "info", 45)
		event.LoadChara(5, "e206_dfire.gltf", "info", 46)
		event.LoadChara(5, "e206_dfire_f.gltf", "info", 47)
		event.LoadChara(5, "e206_dfire_f.gltf", "info", 48)
		event.LoadChara(5, "e206_hikari.gltf", "info", 49)
		event.LoadChara(5, "e206_dynagiri.gltf", "info", 50)
		event.EohSyncChara(7, 50)
		event.ObjsInit(7)
		event.ObjsSyncObj(7, 7)
		event.LoadChara(5, "e206_hyakugiri.gltf", "info", 51)
		event.LoadChara(5, "e206_pbaku.gltf", "info", 52)
		event.CharaActive(0, 52)
		event.LoadChara(5, "e206_polcurse00.gltf", "info", 53)
		event.CharaActive(1, 53)
		event.ChangeDir("")
		event.LoadChara(5, "chara/c02_base.gltf", "info", 32)
		event.LoadEquip(5, 1, 4, "info", 32)
		event.LoadEquip(5, 1, 3, "info", 32)
		event.LoadEquip(5, 1, 2, "info", 32, 39)
		event.LoadEquip(5, 1, 1, "info", 32, 40)
		event.LoadEquip(5, 1, 0, "info", 32, 41)
		event.LoadMotion(5, "event/e200/e206/e206_monica.gltf", "info", 32)
		event.CharaActive(0, 32)
		event.CharaActive(0, 39)
		event.CharaActive(0, 40)
		event.CharaActive(0, 41)
		event.EohSyncChara(1, 32)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.EsmInitialize(5)
		event.EsmLoadBase("EVモニカ魔法－火")
		event.EsmLoadBase("EVモニカ魔法－火ヒット")
		event.EsmLoadBase("モニカ魔法－溜め")
		event.EsmInitFix(5, 6000)
		event.ObjsSetPos(0, 8.0, 134.45, -334.0)
		event.ObjsSetRot(0, 0.0, 3.14, 0.0)
		event.ObjsSetMotion(0, "びびる", 6, -1.0, 1)
		event.EohSetTexAnim(0, 0)
		event.EohSetTexAnim(0, 1, "おこり顔")
		event.EohSetTexAnim(0, 1, "半口")
		event.ObjsSetPos(3, -8.0, 114.0, -303.0)
		event.ObjsSetRot(3, 0.0, 3.14, 0.0)
		event.ObjsSetMotion(3, "屋根つかまり立ち", 4)
		event.EohSetTexAnim(3, 0)
		event.EohSetTexAnim(3, 1, "デフォルト顔")
		event.EohSetTexAnim(3, 1, "通常目パチ")
		event.ObjsSetPos(4, 220.0, 0.0, -580.0)
		event.ObjsSetMotion(4, "じたばた", 4)
		event.EohSetTexAnim(4, 0)
		event.EohSetTexAnim(4, 1, "おこり顔")
		event.EohSetTexAnim(4, 1, "おこり目パチ")
		event.EohSetTexAnim(5, 0)
		event.EohSetTexAnim(5, 1, "激怒わらい顔2")
		event.EohSetTexAnim(5, 1, "激怒目パチ")
		event.EohSetSoundId(5, var0)
		event.ObjsTexAnime(2, 0)
		event.ObjsSetPos(6, 220.0, 0.0, -580.0)
		event.ObjsSetMotion(6, "走行", 4)
		event.CharaActive(0, 42)
		event.SetCharaPos(42, 225.0, 34.0, -486.0)
		event.CharaActive(43)
		event.SetCharaPos(43, 220.0, 0.0, -580.0)
		event.CharaActive(0, 44)
		event.SetCharaPos(44, 0.0, 139.18, -620.0)
		event.SetReference(36, "f1", 45)
		event.SetCharaPos(45, 0.0, 0.0, 0.0)
		event.SetReference(36, "f2", 46)
		event.SetCharaPos(46, 0.0, 0.0, 0.0)
		event.SetReference(36, "f1", 47)
		event.SetCharaPos(47, 0.0, 2.0, 0.0)
		event.SetReference(36, "f2", 48)
		event.SetCharaPos(48, 0.0, 2.0, 0.0)
		event.CharaActive(0, 49)
		event.SetCharaPos(49, 0.0, 139.18, -712.0)
		event.SetCharaPos(50, 0.0, 139.18, -460.0)
		event.SetCharaRot(50, 0.0, 3.14, 0.0)
		event.SetCharaPos(51, 0.0, 139.18, -490.0)
		event.SetCharaRot(51, 0.0, 0.0, 0.0)
		event.SetCharaPos(53, 220.0, 0.0, -580.0)
		event.SetCharaRot(53, 0.0, 0.0, 0.0)
		event.SetMotion(53, "じたばた", 4)
		event.InitDramaScene()
		event.SetWind(10, 0.0, 0.0, -1.0)
		event.CmrsInit()
		event.CmrsSetPos(361.41, 48.91, -580.59)
		event.CmrsSetRef(233.41, 52.06, -580.59)
		event.SndSePlay(var0, 2)
		event.SndSePlay(var0, 3)
		event.SetFadeIn(30)
		event.SetPakuAnim(4, "おこり顔口パク")
		at = 2
		helper_e34416e2(2060010)
		event.SetPakuAnim(4, "おこり顔口パク")
		at = 3
		helper_e34416e2(2060013)
		event.StreamOpen3(1, 2060015)
		at = 4
		helper_9cbdc640(1)
		event.CmrsSetPos(220.0, 60.0, -420.0)
		event.CmrsSetRef(220.0, 60.0, -580.0)
		event.SndSeStop(var0, 2)
		event.SndSeStop(var0, 3)
		event.SndSePlay(var0, 4)
		event.CharaActive(0, 53)
		event.CharaActive(1, 35)
		event.CmrsMove2(256.05, 60.0, -351.07, 160.79, 130.27, -549.21, 30, 2, 1.0)
		event.ObjsSetMotion(4, "ふっとび", 6)
		event.ObjsMove(4, 14.0, 0.0, -610.0, 50)
		event.ObjsSetMotion(6, "左側でダメージ", 6)
		event.ObjsNextMotion(6, "右側でダメージ", 6)
		event.ObjsMove2(6, 220.0, 0.0, -1000.0, 40, 1, 1.0)
		event.CharaActive(0, 43)
		event.CharaActive(42)
		event.SetMotion(42, "ｴﾌｪｸﾄ_バギー爆発", 6)
		event.StreamPlay(1)
		at = 5
		helper_888ab2a3(50)
		event.CharaActive(0, 38)
		event.CharaActive(0, 37)
		event.CmrsSetPos(0.0, 167.16, -367.46)
		event.CmrsSetRef(0.0, 129.42, -609.2)
		event.ObjsSetPos(4, 0.0, 139.18, -620.0)
		event.ObjsSetMotion(4, "どさっと落ちた", 6)
		at = 6
		helper_888ab2a3(8)
		event.SndSePlay(var0, 5)
		at = 7
		helper_888ab2a3(34)
		event.StreamClose(1)
		event.CmrsSetPos(19.88, 150.6, -361.7)
		event.CmrsSetRef(8.1, 156.22, -333.48)
		event.EohSetTexAnim(0, 1, "まばたき目パチ")
		event.StreamOpen3(1, 2060017)
		at = 8
		helper_888ab2a3(40)
		at = 9
		helper_9cbdc640(1)
		event.CmrsSetPos(60.03, 148.42, -606.42)
		event.CmrsSetRef(0.0, 151.12, -606.2)
		event.CmrsMove(60.03, 148.42, -614.42, 0.0, 151.12, -614.2, 48)
		event.StreamPlay(1)
		event.SndSePlay(var0, 7)
		event.ObjsSetMotion(4, "起きあがり", 6)
		at = 10
		helper_888ab2a3(48)
		event.StreamClose(1)
		event.CmrsSetPos(0.0, 161.43, -576.15)
		event.CmrsSetRef(0.0, 167.01, -624.67)
		event.SndSePlay(var0, 8)
		event.EohSetTexAnim(4, 0)
		event.EohSetTexAnim(4, 1, "激怒顔")
		event.EohSetTexAnim(4, 1, "激怒目パチ")
		event.ObjsSetMotion(4, "顔上げ", 6)
		event.ObjsNextMotion(4, "ワナワナ", 4)
		at = 11
		helper_e34416e2(2060020)
		event.CmrsSetPos(10.4, 144.62, -387.58)
		event.CmrsSetRef(8.88, 150.2, -322.21)
		event.EohSetTexAnim(0, 0)
		event.EohSetTexAnim(0, 1, "おこり目パチ")
		event.ObjsSetMotion(0, "びびる", 6, -1.0, 1)
		event.SetPakuAnim(0, "通常口パク", "半口")
		at = 12
		helper_e34416e2(2060030)
		event.CmrsSetPos(0.0, 156.37, -537.41)
		event.CmrsSetRef(0.0, 159.13, -624.67)
		event.EohSetTexAnim(4, 0)
		event.EohSetTexAnim(4, 1, "激怒わらい顔")
		event.EohSetTexAnim(4, 1, "激怒目パチ")
		event.ObjsSetMotion(4, "脱ぎ構え", 6)
		at = 13
		helper_888ab2a3(14)
		event.SndSePlay(var0, 9)
		at = 14
		helper_888ab2a3(20)
		event.CmrsSetPos(49.82, 158.45, -577.41)
		event.CmrsSetRef(28.49, 183.1, -641.57)
		event.SndSePlay(var0, 10)
		event.CharaActive(0, 35)
		event.CharaActive(36)
		event.ObjsSetPos(5, 0.0, 139.18, -620.0)
		event.ObjsSetMotion(5, "脱ぐ", 6)
		event.ObjsNextMotion(5, "脱ぐＬ", 4)
		event.CharaActive(44)
		event.SetMotion(44, "ｴﾌｪｸﾄ_脱衣", 6)
		at = 15
		helper_888ab2a3(16)
		event.CmrsMove2(49.82, 158.45, -577.41, 1.0, 162.91, -620.29, 20, 0, 0.4)
		at = 16
		helper_c624bc16()
		event.PlayBgm(0)
		at = 17
		helper_888ab2a3(4)
		event.CharaActive(0, 44)
		event.SetCrossfade(30)
		event.CmrsSetPos(0.0, 153.08, -533.86)
		event.CmrsSetRef(0.0, 158.5, -620.41)
		at = 18
		helper_888ab2a3(70)
		event.CmrsSetPos(-16.28, 155.87, -380.81)
		event.CmrsSetRef(12.48, 144.4, -292.95)
		event.EohSetTexAnim(0, 1, "前向き～左向き")
		event.ObjsSetMotion(3, "つかまり会話", 6)
		event.ObjsNextMotion(3, "屋根つかまり立ち", 4)
		event.ObjsSetMotion(0, "振り向く", 6)
		event.ObjsNextMotion(0, "振り向くL", 4)
		event.SetPakuAnim(3, "通常口パク", "大口")
		at = 19
		helper_e34416e2(2060040)
		event.EohSetTexAnim(0, 1, "左向き～前向き")
		event.EohSetTexAnim(0, 1, "半口～大口")
		event.ObjsSetMotion(0, "振り向く戻り", 6)
		event.ObjsNextMotion(0, "びびる", 4)
		at = 20
		helper_e34416e2(2060050)
		event.SetCrossfade(30)
		event.EohSetTexAnim(5, 0)
		event.EohSetTexAnim(5, 1, "激怒わらい顔")
		event.EohSetTexAnim(5, 1, "激怒目パチ")
		event.CmrsSyncObj(5, 0.0, 23.0, 0.0, 0.0, 9.8, 80.0)
		event.CmrsMoveAhd2(0.0, 9.8, 40.0, 160, 2, 1.0)
		event.ObjsSetPos(5, 0.0, 139.18, -800.0)
		event.ObjsSetMotion(5, "脱ぎ歩き", 4)
		event.ObjsMove(5, 0.0, 139.18, -570.0, 270)
		event.SetPakuAnim(5, "激怒わらい口パク")
		at = 21
		helper_29101c9c(2060060, 270)
		event.ObjsSetMotion(5, "さあさあＬ")
		event.ObjsChengeStep(5, 0.1)
		event.ObjsMotionDelay(5, 140)
		event.ObjsSetMotion(5, "ごらあ", 2)
		event.ObjsNextMotion(5, "ごらあＬ", 4)
		event.SetPakuAnim(5, "激怒わらい口パク")
		at = 22
		helper_29101c9c(2060070, 270)
		at = 23
		helper_0958ca60(5)
		event.CmrsReleaseObj()
		event.ObjsSetMotion(5, "後ろに気がつく", 5)
		event.CmrsSetPos(17.47, 148.06, -359.89)
		event.CmrsSetRef(7.59, 155.6, -333.8)
		event.SndSePlay(var0, 11)
		event.EohSetTexAnim(0, 0)
		event.EohSetTexAnim(0, 1, "おこり顔")
		event.EohSetTexAnim(0, 1, "おこり目～ひき目")
		event.ObjsSetMotion(0, "ひく", 6)
		event.ObjsNextMotion(0, "ひくL", 4)
		event.SetPakuAnim(0, "ひき口パク")
		at = 24
		helper_e34416e2(2060080)
		event.SetLoadbgFile_1("snd2/bgm/bg_104.sound.json")
		at = 25
		helper_479dc9e9()
		event.CmrsSyncObj(5, 0.0, 23.0, 0.0, 0.0, 9.8, 38.0)
		event.FadeOutBgm(30)
		event.SndSePlay(var0, 12)
		event.ObjsSetPos(5, 0.0, 139.18, -468.0)
		event.ObjsMove(5, 0.0, 139.18, -450.0, 30)
		event.ObjsSetMotion(5, "後ろに気がつく", 6)
		event.ObjsNextMotion(5, "後ろに気がつくＬ", 4)
		event.ObjsTexaDelay(5, 26)
		event.ObjsTexAnime(5, 0)
		event.ObjsTexAnime(5, 1, "きづく顔")
		at = 26
		helper_e34416e2(2060090)
		at = 27
		helper_0958ca60(5)
		event.StopBgm(0)
		at = 28
		helper_888ab2a3(4)
		event.LoadBgmPack(104)
		event.PlayBgm(0)
		event.CmrsReleaseObj()
		event.CharaActive(33)
		event.ObjsSetPos(2, 0.0, 139.18, -712.0)
		event.ObjsSetMotion(5, "振りかえり", 6)
		event.ObjsNextMotion(5, "振りかえりＬ", 4)
		event.CmrsMove2(0.0, 198.49, -396.69, 0.0, 175.46, -468.0, 20, 0, 0.4)
		at = 29
		helper_c624bc16()
		at = 30
		helper_888ab2a3(20)
		event.CmrsSetPos(-0.0, 161.25, -679.19)
		event.CmrsSetRef(-0.0, 158.97, -713.45)
		event.SetPakuAnim(2, "口パク")
		at = 31
		helper_e34416e2(2060100)
		event.CmrsSetPos(0.0, 166.31, -519.59)
		event.CmrsSetRef(0.0, 164.03, -473.3)
		event.EohSetTexAnim(5, 0)
		event.EohSetTexAnim(5, 1, "激怒顔")
		event.EohSetTexAnim(5, 1, "激怒目パチ")
		event.ObjsSetRot(5, 0.0, 3.14, 0.0)
		event.ObjsSetMotion(5, "会話", 6)
		event.ObjsNextMotion(5, "会話用立ち", 4)
		event.SetPakuAnim(5, "激怒口パク")
		at = 32
		helper_e34416e2(2060110)
		event.EohSetTexAnim(5, 0)
		event.EohSetTexAnim(5, 1, "激怒わらい顔2")
		event.EohSetTexAnim(5, 1, "激怒目パチ")
		event.SetPakuAnim(5, "激怒わらい口パク")
		at = 33
		helper_e34416e2(2060120)
		event.SetPakuAnim(5, "激怒口パク")
		at = 34
		helper_e34416e2(2060125)
		at = 35
		helper_0958ca60(5)
		event.SndSePlay(var0, 13)
		event.ObjsSetMotion(5, "爆弾取り出し", 6)
		event.ObjsNextMotion(5, "火付け", 6)
		event.ObjsMotionWait(5)
		at = 36
		helper_888ab2a3(24)
		event.SndSePlay(var0, 14)
		event.EohSetTexAnim(5, 1, "火ふき口")
		event.CharaActive(48)
		event.SetMotion(48, "ｴﾌｪｸﾄ_ﾀﾞｲﾅﾏｲﾄ着火", 6)
		at = 37
		helper_888ab2a3(8)
		event.CharaActive(46)
		event.SetMotion(46, "ｴﾌｪｸﾄ_ﾀﾞｲﾅﾏｲﾄ炎", 4)
		at = 38
		helper_888ab2a3(8)
		event.SndSePlay(var0, 14)
		event.EohSetTexAnim(5, 0, "火ふき口")
		event.EohSetTexAnim(5, 1, "火ふき口")
		event.CharaActive(47)
		event.SetMotion(47, "ｴﾌｪｸﾄ_ﾀﾞｲﾅﾏｲﾄ着火", 6)
		at = 39
		helper_888ab2a3(8)
		event.CharaActive(45)
		event.SetMotion(45, "ｴﾌｪｸﾄ_ﾀﾞｲﾅﾏｲﾄ炎", 4)
		at = 40
		helper_0958ca60(5)
		event.SndSePlay(var0, 15)
		event.CharaActive(0, 47)
		event.CharaActive(0, 48)
		event.ObjsSetMotion(5, "爆弾歩き")
		event.ObjsMove(5, 0.0, 139.18, -490.0, 220)
		event.EohSetTexAnim(5, 0, "火ふき口")
		event.SetPakuAnim(5, "激怒わらい口パク")
		at = 41
		helper_29101c9c(2060130, 210)
		event.SndSeStop(var0, 15)
		event.ObjsSetMotion(5, "構え2", 4)
		event.CmrsSetPos(23.2, 152.06, -685.78)
		event.CmrsSetRef(-0.59, 157.87, -710.51)
		at = 42
		helper_888ab2a3(40)
		event.CmrsSetPos(0.49, 160.57, -693.45)
		event.CmrsSetRef(-0.32, 160.57, -710.52)
		event.FadeOutBgm(30)
		at = 43
		helper_888ab2a3(10)
		event.SndSePlay(var0, 16)
		at = 44
		helper_888ab2a3(10)
		event.CharaActive(49)
		event.SetMotion(49, "光る", 6)
		event.ScrEffInitRaster(0.0, 0.0, 0.15707964)
		event.ScrEffStartRaster(60.0, 0.3926991, -1.0, 50)
		at = 45
		helper_888ab2a3(20)
		event.StopBgm(0)
		at = 46
		helper_888ab2a3(30)
		event.SetLoadbgFile_1("snd2/bgm/bg_190.sound.json")
		at = 47
		helper_479dc9e9()
		event.CmrsSetPos(0.0, 162.13, -550.88)
		event.CmrsSetRef(0.0, 160.57, -488.42)
		event.EohSetTexAnim(5, 0)
		event.EohSetTexAnim(5, 1, "おこり顔")
		event.EohSetTexAnim(5, 1, "おこり目パチ")
		event.ScrEffStopRaster(0.0, 0.0, 0.0, 0)
		event.LoadBgmPack(190)
		event.PlayBgm(0)
		event.SetPakuAnim(5, "おこり口パク")
		at = 48
		helper_e34416e2(2060140)
		event.CmrsSetPos(21.57, 145.5, -694.43)
		event.CmrsSetRef(0.0, 145.5, -710.52)
		event.CmrsMove(21.57, 150.5, -694.43, 0.0, 150.5, -710.52, 48)
		event.SndSePlay(var0, 17)
		event.SetMotion(49, "消える", 6)
		event.ScrEffInitRaster(60.0, 0.3926991, 0.15707964)
		event.ScrEffStartRaster(-1.0, -1.0, -1.0, 0)
		event.ScrEffStopRaster(0.0, -1.0, -1.0, 40)
		event.CharaActive(0, 33)
		event.CharaActive(32)
		event.CharaActive(39)
		event.CharaActive(40)
		event.CharaActive(41)
		event.ObjsSetPos(1, 0.0, 139.18, -712.0)
		event.ObjsSetMotion(1, "立ち", 4, -1.0, 1)
		event.EohSetTexAnim(1, 0)
		event.EohSetTexAnim(1, 1, "デフォルト顔")
		event.EohSetTexAnim(1, 1, "目とじ")
		at = 49
		helper_888ab2a3(48)
		event.CmrsSetPos(16.18, 155.0, -733.35)
		event.CmrsSetRef(0.0, 155.0, -714.81)
		event.CmrsMove(16.18, 160.0, -733.35, 0.0, 160.0, -714.81, 48)
		event.SndSePlay(var0, 18)
		event.ObjsSetMotion(1, "髪の毛バサッ", 6)
		event.ObjsNextMotion(1, "髪の毛バサッＬ", 4)
		at = 50
		helper_888ab2a3(48)
		event.CharaActive(0, 49)
		event.CmrsSetPos(0.0, 160.11, -684.49)
		event.CmrsSetRef(0.0, 160.11, -710.52)
		event.SndSePlay(var0, 19)
		event.ObjsSetMotion(1, "うつむき～構え", 6)
		event.ObjsNextMotion(1, "構えＬ", 4)
		event.ObjsTexaDelay(1, 20)
		event.ObjsTexAnime(1, 1, "目とじ～目あき")
		event.ObjsTexaDelay(1, 20)
		event.ObjsTexAnime(1, 1, "目にらみ目")
		event.ObjsTexAnime(1, 1, "口とじ～にらみ口")
		at = 51
		helper_888ab2a3(40)
		event.SndSePlay(var0, 22)
		event.SndSeStop(var0, 16)
		at = 52
		helper_888ab2a3(20)
		event.CmrsSetPos(22.15, 166.63, -756.1)
		event.CmrsSetRef(1.09, 150.66, -651.12)
		event.ObjsSetPos(5, 0.0, 139.18, -460.0)
		event.EohSetTexAnim(1, 0)
		event.EohSetTexAnim(1, 1, "おこり顔")
		event.EohSetTexAnim(1, 1, "おこり目パチ")
		event.EohSetTexAnim(5, 0)
		event.EohSetTexAnim(5, 1, "おどろき顔")
		event.EohSetTexAnim(5, 1, "おこり目パチ")
		event.SetPakuAnim(5, "おこり口パク")
		at = 53
		helper_e34416e2(2060150)
		event.ObjsSetMotion(1, "ジャンプ", 2)
		at = 54
		helper_888ab2a3(4)
		event.SndSePlay(var0, 23)
		at = 55
		helper_888ab2a3(8)
		event.CmrsSetPos(74.99, 148.72, -384.25)
		event.CmrsSetRef(-4.53, 162.4, -478.25)
		event.CmrsMove2(44.68, 149.84, -420.08, -4.53, 162.4, -478.25, 90, 2, 0.4)
		event.ObjsSetPos(1, 0.0, 139.18, -490.0)
		event.ObjsSetMotion(1, "斬り一連", 6, -1.0, 1)
		event.ObjsSeDelay(1, 13)
		event.ObjsSePlay(1, var0, 25)
		event.ObjsSeDelay(1, 14)
		event.ObjsSePlay(1, var0, 25)
		event.ObjsSeDelay(1, 7)
		event.ObjsSePlay(1, var0, 25)
		event.ObjsSeDelay(1, 13)
		event.ObjsSePlay(1, var0, 25)
		event.ObjsSeDelay(1, 11)
		event.ObjsSePlay(1, var0, 25)
		event.ObjsSeDelay(1, 19)
		event.ObjsSePlay(1, var0, 25)
		event.ObjsSeDelay(1, 12)
		event.ObjsSePlay(1, var0, 25)
		event.ObjsSeDelay(1, 7)
		event.ObjsSePlay(1, var0, 25)
		event.ObjsPosDelay(5, 13)
		event.ObjsMove(5, 0.0, 139.78, -460.0, 1)
		event.ObjsMove(5, 0.0, 139.18, -460.0, 1)
		event.ObjsMove(5, 0.0, 139.57999, -460.0, 1)
		event.ObjsMove(5, 0.0, 139.18, -460.0, 1)
		event.ObjsPosDelay(5, 10)
		event.ObjsMove(5, 0.0, 139.78, -460.0, 1)
		event.ObjsMove(5, 0.0, 139.18, -460.0, 1)
		event.ObjsMove(5, 0.0, 139.57999, -460.0, 1)
		event.ObjsMove(5, 0.0, 139.18, -460.0, 1)
		event.ObjsPosDelay(5, 3)
		event.ObjsMove(5, 0.0, 139.78, -460.0, 1)
		event.ObjsMove(5, 0.0, 139.18, -460.0, 1)
		event.ObjsMove(5, 0.0, 139.57999, -460.0, 1)
		event.ObjsMove(5, 0.0, 139.18, -460.0, 1)
		event.ObjsPosDelay(5, 9)
		event.ObjsMove(5, 0.0, 139.78, -460.0, 1)
		event.ObjsMove(5, 0.0, 139.18, -460.0, 1)
		event.ObjsMove(5, 0.0, 139.57999, -460.0, 1)
		event.ObjsMove(5, 0.0, 139.18, -460.0, 1)
		event.ObjsPosDelay(5, 7)
		event.ObjsMove(5, 0.0, 139.78, -460.0, 1)
		event.ObjsMove(5, 0.0, 139.18, -460.0, 1)
		event.ObjsMove(5, 0.0, 139.57999, -460.0, 1)
		event.ObjsMove(5, 0.0, 139.18, -460.0, 1)
		event.ObjsPosDelay(5, 15)
		event.ObjsMove(5, 0.0, 139.78, -460.0, 1)
		event.ObjsMove(5, 0.0, 139.18, -460.0, 1)
		event.ObjsMove(5, 0.0, 139.57999, -460.0, 1)
		event.ObjsMove(5, 0.0, 139.18, -460.0, 1)
		event.ObjsPosDelay(5, 8)
		event.ObjsMove(5, 0.0, 139.78, -460.0, 1)
		event.ObjsMove(5, 0.0, 139.18, -460.0, 1)
		event.ObjsMove(5, 0.0, 139.57999, -460.0, 1)
		event.ObjsMove(5, 0.0, 139.18, -460.0, 1)
		event.ObjsPosDelay(5, 3)
		event.ObjsMove(5, 0.0, 139.78, -460.0, 1)
		event.ObjsMove(5, 0.0, 139.18, -460.0, 1)
		event.ObjsMove(5, 0.0, 139.57999, -460.0, 1)
		event.ObjsMove(5, 0.0, 139.18, -460.0, 1)
		event.ObjsPosDelay(7, 13)
		event.ObjsMove(7, 0.0, 139.78, -460.0, 1)
		event.ObjsMove(7, 0.0, 139.18, -460.0, 1)
		event.ObjsMove(7, 0.0, 139.57999, -460.0, 1)
		event.ObjsMove(7, 0.0, 139.18, -460.0, 1)
		event.ObjsPosDelay(7, 10)
		event.ObjsMove(7, 0.0, 139.78, -460.0, 1)
		event.ObjsMove(7, 0.0, 139.18, -460.0, 1)
		event.ObjsMove(7, 0.0, 139.57999, -460.0, 1)
		event.ObjsMove(7, 0.0, 139.18, -460.0, 1)
		event.ObjsPosDelay(7, 3)
		event.ObjsMove(7, 0.0, 139.78, -460.0, 1)
		event.ObjsMove(7, 0.0, 139.18, -460.0, 1)
		event.ObjsMove(7, 0.0, 139.57999, -460.0, 1)
		event.ObjsMove(7, 0.0, 139.18, -460.0, 1)
		event.ObjsPosDelay(7, 9)
		event.ObjsMove(7, 0.0, 139.78, -460.0, 1)
		event.ObjsMove(7, 0.0, 139.18, -460.0, 1)
		event.ObjsMove(7, 0.0, 139.57999, -460.0, 1)
		event.ObjsMove(7, 0.0, 139.18, -460.0, 1)
		event.ObjsPosDelay(7, 7)
		event.ObjsMove(7, 0.0, 139.78, -460.0, 1)
		event.ObjsMove(7, 0.0, 139.18, -460.0, 1)
		event.ObjsMove(7, 0.0, 139.57999, -460.0, 1)
		event.ObjsMove(7, 0.0, 139.18, -460.0, 1)
		event.ObjsPosDelay(7, 15)
		event.ObjsMove(7, 0.0, 139.78, -460.0, 1)
		event.ObjsMove(7, 0.0, 139.18, -460.0, 1)
		event.ObjsMove(7, 0.0, 139.57999, -460.0, 1)
		event.ObjsMove(7, 0.0, 139.18, -460.0, 1)
		event.ObjsPosDelay(7, 8)
		event.ObjsMove(7, 0.0, 139.78, -460.0, 1)
		event.ObjsMove(7, 0.0, 139.18, -460.0, 1)
		event.ObjsMove(7, 0.0, 139.57999, -460.0, 1)
		event.ObjsMove(7, 0.0, 139.18, -460.0, 1)
		event.ObjsPosDelay(7, 3)
		event.ObjsMove(7, 0.0, 139.78, -460.0, 1)
		event.ObjsMove(7, 0.0, 139.18, -460.0, 1)
		event.ObjsMove(7, 0.0, 139.57999, -460.0, 1)
		event.ObjsMove(7, 0.0, 139.18, -460.0, 1)
		event.EohSetFrameStatus(5, "dm01", 0)
		event.EohSetFrameStatus(5, "dm02", 0)
		event.EohSetFrameStatus(5, "dm03", 0)
		event.EohSetFrameStatus(5, "dm04", 0)
		event.EohSetFrameStatus(5, "dm05", 0)
		event.EohSetFrameStatus(5, "dm06", 0)
		event.EohSetFrameStatus(5, "dm07", 0)
		event.EohSetFrameStatus(5, "dm08", 0)
		event.CharaActive(0, 45)
		event.CharaActive(0, 46)
		event.CharaActive(50)
		event.SetMotion(50, "構え2", 6)
		event.CharaActive(51)
		event.SetMotion(51, "百烈斬り", 6)
		at = 56
		helper_888ab2a3(108)
		event.SndSePlay(var0, 26)
		event.ObjsSetMotion(5, "構え2から上向く", 2)
		event.ObjsNextMotion(5, "構え2から上向くＬ", 4)
		at = 57
		helper_888ab2a3(20)
		event.CharaActive(0, 50)
		event.CharaActive(0, 51)
		event.CmrsSetPos(17.12, 167.45, -472.74)
		event.CmrsSetRef(2.04, 165.02, -453.77)
		event.ObjsSetPos(1, 0.0, 242.0, -432.79)
		event.ObjsSetRot(1, 0.0, 3.14, 0.0)
		event.ObjsSetMotion(1, "着地2", 1, -1.0, 1)
		event.ObjsPosDelay(1, 14)
		event.ObjsSetPos(1, 0.0, 142.0, -432.79)
		event.ObjsMotionDelay(1, 14)
		event.ObjsSetMotion(1, "着地2", 6)
		event.ObjsMotionWait(1)
		event.SetPakuAnim(5, "おこり口パク")
		at = 58
		helper_29101c9c(2060160, 30)
		at = 59
		helper_0958ca60(1)
		event.CmrsSetPos(37.04, 163.18, -414.0)
		event.CmrsSetRef(-0.44, 155.57, -479.81)
		event.ObjsSetPos(1, 0.0, 139.18, -466.39)
		event.ObjsSetPos(5, 0.0, 139.18, -482.06)
		event.ObjsSetMotion(1, "着地から蹴り", 6, -1.0, 1)
		at = 60
		helper_888ab2a3(10)
		event.SndSePlay(var0, 27)
		event.ObjsSetMotion(5, "蹴られ", 6)
		event.ObjsMove(5, 0.0, 139.18, -582.06, 20)
		at = 61
		helper_888ab2a3(20)
		event.CmrsSetPos(102.08, 207.93, -668.58)
		event.CmrsSetRef(0.9, 248.52, -781.38)
		event.ObjsSetMotion(5, "回転", 4)
		event.ObjsSetPos(5, 0.0, 170.0, -700.0)
		event.ObjsJump(5, 0.0, 270.0, -810.0, -0.2, 30)
		at = 62
		helper_888ab2a3(30)
		event.CmrsSetPos(31.63, 178.14, -506.91)
		event.CmrsSetRef(-4.76, 161.36, -465.13)
		event.ObjsSetMotion(1, "魔法構えＬ", 4, -1.0, 1)
		at = 63
		helper_888ab2a3(2)
		do
			local out1, out2, out3 = event.EohGetFramePos(1, "item")
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		var2 = 0
		while var2 < 2 do
			event.SndSePlay(var0, 28)
			event.ObjsResetMotion(1)
			event.ObjsSetMotion(1, "魔法発射", 6)
			result = event.EsmCreate_3("モニカ魔法－溜め", 32) or result
			event.EsmSetVect1(pos_x, pos_y, pos_z)
			event.EsmSetVect2(128, 64, 64)
			event.EsmCreate_2("EVモニカ魔法－火", 32)
			event.EsmSetVect1(pos_x, pos_y, pos_z)
			event.EsmSetTargetId(36)
			at = 64
			vm.wait(64)
			event.EsmFinish(32, result)
			at = 65
			helper_888ab2a3(12)
			var2 = var2 + 1
		end
		event.CmrsSetPos(2.63, 168.94, -402.89)
		event.CmrsSetRef(2.53, 174.18, -467.22)
		var2 = 0
		while var2 < 2 do
			event.SndSePlay(var0, 28)
			event.ObjsResetMotion(1)
			event.ObjsSetMotion(1, "魔法発射", 6)
			result = event.EsmCreate_3("モニカ魔法－溜め", 32) or result
			event.EsmSetVect1(pos_x, pos_y, pos_z)
			event.EsmSetVect2(128, 64, 64)
			event.EsmCreate_2("EVモニカ魔法－火", 32)
			event.EsmSetVect1(pos_x, pos_y, pos_z)
			event.EsmSetTargetId(36)
			at = 66
			vm.wait(66)
			event.EsmFinish(32, result)
			at = 67
			helper_888ab2a3(12)
			event.SndSePlay(var0, 29)
			var2 = var2 + 1
		end
		at = 68
		helper_888ab2a3(20)
		event.SndSePlay(var0, 29)
		event.CharaActive(1, 52)
		event.SetCharaPos(52, 0.0, 270.0, -810.0)
		event.SetCharaRot(52, 0.0, 0.0, 0.0)
		event.SetMotion(52, "ｴﾌｪｸﾄ_ポルカス爆発", 6)
		at = 69
		helper_888ab2a3(20)
		event.CmrsSetPos(384.95, 97.71, -2219.0)
		event.CmrsSetRef(49.63, 140.83, -1923.14)
		event.SndSePlay(var0, 30)
		event.CmrsMove(384.95, 97.71, -2219.0, -38.17, 25.4, -2159.44, 80)
		event.SetCharaPos(52, 0.0, 260.0, -1700.0)
		event.SetCharaRot(52, 0.0, 0.0, 0.0)
		event.ObjsSetPos(5, 0.0, 0.0, -1700.0)
		event.ObjsSetRot(5, 0.0, 1.57, 0.0)
		event.ObjsMove2(5, 0.0, 0.0, -2200.0, 40, 2, 1.0)
		event.ObjsSetMotion(5, "バウンド", 6)
		at = 70
		helper_888ab2a3(48)
		event.SndSePlay(var0, 31)
		at = 71
		helper_888ab2a3(32)
		event.CmrsSetPos(-63.62, 7.53, -2200.15)
		event.CmrsSetRef(-100.22, 4.78, -2200.62)
		event.ObjsSetPos(5, -100.0, 0.0, -2200.0)
		event.ObjsSetMotion(5, "落ちるアップ用", 6)
		event.EohSetTexAnim(5, 0)
		event.EohSetTexAnim(5, 1, "激怒顔")
		event.EohSetTexAnim(5, 1, "激怒目パチ")
		helper_34d64c6e(0)
		at = 72
		helper_888ab2a3(40)
		event.SetLoadbgFile_1("snd2/bgm/bg_112.sound.json")
		at = 73
		helper_479dc9e9()
		event.CmrsSetPos(0.0, 163.99, -340.4)
		event.CmrsSetRef(0.0, 161.92, -451.52)
		event.FadeOutBgm(40)
		helper_34d64c6e(1)
		event.SndSePlay(var0, 32)
		event.ObjsSetMotion(1, "魔法構え～立ち", 6)
		event.ObjsNextMotion(1, "振りかえり", 6)
		event.ObjsNextMotion(1, "振りかえりＬ", 4)
		at = 74
		helper_888ab2a3(30)
		event.SetCrossfade(60)
		event.SndSePlay(var0, 33)
		event.CmrsSetPos(-3.0, 160.0, -430.4)
		event.CmrsSetRef(-3.0, 160.0, -467.48)
		event.ObjsTexaDelay(1, 20)
		event.ObjsTexAnime(1, 0)
		event.ObjsTexAnime(1, 1, "おこり顔")
		event.ObjsTexAnime(1, 1, "おこり目～通常目")
		event.ObjsTexAnime(1, 1, "にらみ口～口とじ")
		at = 75
		helper_888ab2a3(10)
		event.StopBgm(0)
		at = 76
		helper_888ab2a3(10)
		event.LoadBgmPack(112)
		event.PlayBgm(0)
		at = 77
		helper_888ab2a3(40)
		event.CmrsSetPos(21.75, 147.46, -348.38)
		event.CmrsSetRef(-0.97, 155.45, -337.06)
		event.EohSetTexAnim(0, 0)
		event.EohSetTexAnim(0, 1, "おこり顔")
		event.EohSetTexAnim(0, 1, "おどろき目パチ")
		event.ObjsSetPos(0, 0.0, 134.45, -334.0)
		event.ObjsSetMotion(0, "立ち", 4, -1.0, 1)
		event.ObjsSetMotion(1, "立ち", 4, -1.0, 1)
		event.ObjsSetRot(1, 0.0, 0.0, 0.0)
		at = 78
		helper_888ab2a3(40)
		event.SetCrossfade(60)
		event.CmrsSetRef(0.0, 154.0, -400.0)
		event.CmrsSetAhd(1.11, 18.0, 175.0)
		event.CmrsMoveAhd(2.03, 18.0, 175.0, 160)
		at = 79
		helper_29101c9c(2060170, 120)
		event.StreamOpen3(1, 2060180)
		at = 80
		helper_9cbdc640(1)
		event.StreamPlay(1)
		event.MesMake_2(0, 2060180)
		helper_82705ce2(0, -1, 8, 0, 0)
		at = 81
		helper_c624bc16()
		event.SetCrossfade(30)
		event.CmrsSyncObj(1, 0.0, 23.0, 0.0, 0.57, 0.0, 30.0)
		event.CmrsMoveAhd2(1.57, 0.0, 30.0, 90, 2, 0.3)
		at = 82
		helper_a0450e0f(0, 120)
		helper_6992f518(0)
		event.StreamClose(1)
		at = 83
		helper_c624bc16()
		event.CmrsReleaseObj()
		event.SetCrossfade(30)
		event.CmrsSyncObj(0, 0.0, 20.0, 0.0, -2.0, 0.0, 30.0)
		event.CmrsMoveAhd2(3.14, 0.0, 30.0, 90, 2, 1.0)
		event.EohSetTexAnim(0, 0)
		event.EohSetTexAnim(0, 1, "デフォルト顔")
		event.EohSetTexAnim(0, 1, "通常目パチ")
		at = 84
		helper_29101c9c(2060190, 140)
		at = 85
		helper_c624bc16()
		event.CmrsReleaseObj()
		event.FadeOutBgm(30)
		event.SetFadeOut(30)
		at = 86
		helper_888ab2a3(30)
	end, function(received: { any }): boolean
		if at <= 1 then
			helper_8cd371d7(2060010)
		end
		if at <= 2 then
			helper_8cd371d7(2060013)
		end
		if at <= 3 then
			helper_238b5abc(1)
		end
		if at <= 4 then
			helper_038a2e4d(50)
		end
		if at <= 5 then
			helper_038a2e4d(8)
		end
		if at <= 6 then
			helper_038a2e4d(34)
		end
		if at <= 7 then
			helper_038a2e4d(40)
		end
		if at <= 8 then
			helper_238b5abc(1)
		end
		if at <= 9 then
			helper_038a2e4d(48)
		end
		if at <= 10 then
			helper_8cd371d7(2060020)
		end
		if at <= 11 then
			helper_8cd371d7(2060030)
		end
		if at <= 12 then
			helper_038a2e4d(14)
		end
		if at <= 13 then
			helper_038a2e4d(20)
		end
		if at <= 14 then
			helper_038a2e4d(16)
		end
		if at <= 15 then
			helper_344d6cd8()
		end
		if at <= 16 then
			helper_038a2e4d(4)
		end
		if at <= 17 then
			helper_038a2e4d(70)
		end
		if at <= 18 then
			helper_8cd371d7(2060040)
		end
		if at <= 19 then
			helper_8cd371d7(2060050)
		end
		if at <= 20 then
			helper_53ffe901(2060060, 270)
		end
		if at <= 21 then
			helper_53ffe901(2060070, 270)
		end
		if at <= 22 then
			helper_238b5abc(5)
		end
		if at <= 23 then
			helper_8cd371d7(2060080)
		end
		if at <= 24 then
			helper_344d6cd8()
		end
		if at <= 25 then
			helper_8cd371d7(2060090)
		end
		if at <= 26 then
			helper_238b5abc(5)
		end
		if at <= 27 then
			helper_038a2e4d(4)
		end
		if at <= 28 then
			helper_344d6cd8()
		end
		if at <= 29 then
			helper_038a2e4d(20)
		end
		if at <= 30 then
			helper_8cd371d7(2060100)
		end
		if at <= 31 then
			helper_8cd371d7(2060110)
		end
		if at <= 32 then
			helper_8cd371d7(2060120)
		end
		if at <= 33 then
			helper_8cd371d7(2060125)
		end
		if at <= 34 then
			helper_238b5abc(5)
		end
		if at <= 35 then
			helper_038a2e4d(24)
		end
		if at <= 36 then
			helper_038a2e4d(8)
		end
		if at <= 37 then
			helper_038a2e4d(8)
		end
		if at <= 38 then
			helper_038a2e4d(8)
		end
		if at <= 39 then
			helper_238b5abc(5)
		end
		if at <= 40 then
			helper_53ffe901(2060130, 210)
		end
		if at <= 41 then
			helper_038a2e4d(40)
		end
		if at <= 42 then
			helper_038a2e4d(10)
		end
		if at <= 43 then
			helper_038a2e4d(10)
		end
		if at <= 44 then
			helper_038a2e4d(20)
		end
		if at <= 45 then
			helper_038a2e4d(30)
		end
		if at <= 46 then
			helper_344d6cd8()
		end
		if at <= 47 then
			helper_8cd371d7(2060140)
		end
		if at <= 48 then
			helper_038a2e4d(48)
		end
		if at <= 49 then
			helper_038a2e4d(48)
		end
		if at <= 50 then
			helper_038a2e4d(40)
		end
		if at <= 51 then
			helper_038a2e4d(20)
		end
		if at <= 52 then
			helper_8cd371d7(2060150)
		end
		if at <= 53 then
			helper_038a2e4d(4)
		end
		if at <= 54 then
			helper_038a2e4d(8)
		end
		if at <= 55 then
			helper_038a2e4d(108)
		end
		if at <= 56 then
			helper_038a2e4d(20)
		end
		if at <= 57 then
			helper_53ffe901(2060160, 30)
		end
		if at <= 58 then
			helper_238b5abc(1)
		end
		if at <= 59 then
			helper_038a2e4d(10)
		end
		if at <= 60 then
			helper_038a2e4d(20)
		end
		if at <= 61 then
			helper_038a2e4d(30)
		end
		if at <= 62 then
			helper_038a2e4d(2)
		end
		if at <= 63 then
			var2 = 0
		end
		if at <= 64 then
			helper_038a2e4d(12)
		end
		if at <= 65 then
			local _ = var2 < 2
			var2 = var2 + 1
			var2 = 0
		end
		if at <= 66 then
			helper_038a2e4d(12)
		end
		if at <= 67 then
			local _ = var2 < 2
			var2 = var2 + 1
			helper_038a2e4d(20)
		end
		if at <= 68 then
			helper_038a2e4d(20)
		end
		if at <= 69 then
			helper_038a2e4d(48)
		end
		if at <= 70 then
			helper_038a2e4d(32)
		end
		if at <= 71 then
			helper_4a9b8bc5(0)
			helper_038a2e4d(40)
		end
		if at <= 72 then
			helper_344d6cd8()
		end
		if at <= 73 then
			helper_4a9b8bc5(1)
			helper_038a2e4d(30)
		end
		if at <= 74 then
			helper_038a2e4d(10)
		end
		if at <= 75 then
			helper_038a2e4d(10)
		end
		if at <= 76 then
			helper_038a2e4d(40)
		end
		if at <= 77 then
			helper_038a2e4d(40)
		end
		if at <= 78 then
			helper_53ffe901(2060170, 120)
		end
		if at <= 79 then
			helper_238b5abc(1)
		end
		if at <= 80 then
			helper_f018b3c0(0, -1, 8, 0, 0)
			helper_344d6cd8()
		end
		if at <= 81 then
			helper_972d1084(0, 120)
		end
		if at <= 82 then
			helper_d16eef1e(0)
			helper_344d6cd8()
		end
		if at <= 83 then
			helper_53ffe901(2060190, 140)
		end
		if at <= 84 then
			helper_344d6cd8()
		end
		if at <= 85 then
			helper_038a2e4d(30)
		end
		return true
	end)
	event.CancelDramaScene()
	event.SetWind(0)
	event.StopBgm(0)
	event.SndSeStop(var0, 2)
	event.SndSeStop(var0, 3)
	event.SndSeStop(var0, 15)
	event.SndSeStop(var0, 16)
	event.ScrEffStopRaster(0.0, 0.0, 0.0, 0)
	event.DelExtMotion(0)
	event.DeleteChara(32)
	event.DeleteChara(33)
	event.DeleteChara(34)
	event.DeleteChara(35)
	event.DeleteChara(36)
	event.DeleteChara(37)
	event.DeleteChara(38)
	event.DeleteChara(39)
	event.DeleteChara(40)
	event.DeleteChara(41)
	event.DeleteChara(42)
	event.DeleteChara(43)
	event.DeleteChara(44)
	event.DeleteChara(45)
	event.DeleteChara(46)
	event.DeleteChara(47)
	event.DeleteChara(48)
	event.DeleteChara(49)
	event.DeleteChara(50)
	event.DeleteChara(51)
	event.DeleteChara(52)
	event.DeleteChara(53)
	event.LoadMes(0, -1)
	event.EsmClear()
	event.CharaActive(0)
	helper_34d64c6e(1)
	event.StopBgm(0)
end

--- Helper function.
local function helper_15f44()
	local var0: s32 = 0
	local var1: any = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local at: number = 0
	return vm.guard(function()
		event.SetFlag(205, 1)
		event.Initialize()
		event.LoadSound(2206)
		var0 = event.SndLoadSound_2(2206) or var0
		helper_482d9cfc()
		event.StopBgm(0)
		at = 1
		vm.wait(1)
		event.CharaActive(0, 0)
		event.CharaActive(1, 32)
		event.CharaActive(1, 33)
		event.CharaActive(1, 34)
		event.CharaActive(1, 35)
		event.CharaActive(1, 36)
		event.SndSePlay(var0, 5)
		event.SetCharaPos(36, 102.27, 0.0, -305.63)
		event.SetCharaRot(36, 0.0, 0.0, 0.0)
		event.SetCharaPos(35, 44.05, 0.0, 60.82)
		event.SetScale(35, 2.0, 2.0, 2.0)
		event.SpriteInit(0)
		event.SpriteSetType(0, 0)
		event.SpriteSetPos(0, 256, 208)
		event.SpriteSetPutsize(0, 512, 416)
		event.SpriteSetColor(0, 0, 0, 0, 0)
		event.SpriteSetDraw(0, 1)
		event.EohSyncSprite(11, 0)
		event.ObjsInit(11)
		event.ObjsSyncObj(11, 11)
		event.SndSePlay(var0, 1)
		event.EohSyncObj_2(10, "p01_s03t")
		event.ObjsInit(10)
		event.ObjsSyncObj(10, 10)
		do
			local out1, out2, out3 = event.EohGetPos(10)
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		event.ObjsSetRot(10, 0.0, 0.0, 0.0)
		event.ObjsMove(10, 0.0, 51.92, 0.0, 60)
		event.ObjsRotation(10, 0.0, 0.0, -0.785, 60)
		event.CmrsSetPos(67.41, 107.89, 704.3)
		event.CmrsSetRef(59.64, 108.51, 271.98)
		event.CmrsMove2(58.28, 107.89, 196.59, 57.34, 108.51, 144.64, 50, 1, 0.4)
		at = 2
		helper_888ab2a3(45)
		event.ObjsSetColor(11, 0, 0, 0, 255, 30)
		at = 3
		helper_888ab2a3(30)
		event.SetMpcharaMotion("p01_s03t", "kikan-m", "停止")
		event.EsmClear()
		helper_f2b0ffcb()
		event.ObjsSetPos(10, pos_x, pos_y, pos_z)
		event.ObjsSetRot(10, 0.0, 0.0, 0.0)
		event.SoundAllStop()
		at = 4
		helper_888ab2a3(4)
		event.LoadBgm(60)
		event.PlayBgm(1)
		event.SetMesWindowMode(0, 8)
		event.MesMake_2(0, "もう一度戦う\nタイトルに戻る")
		at = 5
		var1 = helper_c190f878(0, -1, 8, 0, 0, 2, 0)
		event.CharaActive(1, 0)
		event.SetFadeOut(0)
		event.SpriteSetDraw(0, 0)
		return var1
	end, function(received: { any })
		if at <= 5 then
			if at == 5 then
				var1 = received[1] :: number
			end
			if at <= 1 then
				helper_038a2e4d(45)
			end
			if at <= 2 then
				helper_038a2e4d(30)
			end
			if at <= 3 then
				helper_1ef0d4b2()
				helper_038a2e4d(4)
			end
			if at <= 4 then
				var1 = helper_7d54f41c(0, -1, 8, 0, 0, 2, 0)
			end
			return var1
		end
		return nil
	end)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Event 99, which map data, a script or the engine runs by number.
script.event_99 = helper_1ef0d4b2

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	event.SetMpcharaMotion("p01_s03t", "kikan-m", "機関")
	event.SetCharaPos(0, 0.0, 140.0, -420.0)
	event.SetCharaRot(0, 0.0, 3.14, 0.0)
	event.SetCameraPos(0.0, 200.0, -260.0)
	event.SetCameraRef(0.0, 170.0, -420.0)
	event.ResetCamera(0)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
function script.key_open()
	helper_888ab2a3(30)
	helper_df50()
end

--- Event 501, which map data, a script or the engine runs by number.
function script.event_501()
	event.SetMpcharaMotion("p01_s03t", "kikan-m", "機関")
	helper_fe3c()
	event.SetFadeIn(15)
	event.GotoSubgame(3)
end

--- Event 502, which map data, a script or the engine runs by number.
function script.event_502()
	event.BgmLoadCancel()
	event.MapJump_3(-1, "s08", 502)
	vm.wait(1)
end

--- Event 503, which map data, a script or the engine runs by number.
function script.event_503()
	event.SetMpcharaMotion("p01_s03t", "kikan-m", "機関")
	helper_16efc()
	event.BgmPlayCancel()
	event.MapJump_2(-1, "s02")
	vm.wait(2)
end

--- Event 512, which map data, a script or the engine runs by number.
function script.event_512()
	local var0: any = 0
	var0 = helper_15f44()
	helper_aa5b3ebe(var0)
end

--- Event 12040, which map data, a script or the engine runs by number.
function script.event_12040()
	helper_fe3c()
	event.SetFadeIn(15)
	event.GotoSubgame(3)
end

--- Event 12050, which map data, a script or the engine runs by number.
function script.event_12050()
	local var0: any = 0
	var0 = helper_15f44()
	helper_aa5b3ebe(var0)
end

--- Event 12060, which map data, a script or the engine runs by number.
script.event_12060 = helper_16efc

--- Event 22010, which map data, a script or the engine runs by number.
function script.event_22010()
	vm.wait(1)
	event.SetCharaPos(0, 0.0, 140.0, -420.0)
	event.SetCharaRot(0, 0.0, 3.14, 0.0)
	event.GotoSubgame(3)
end

return script
