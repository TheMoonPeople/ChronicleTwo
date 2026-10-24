--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0958ca60 = require("@lib/event/helper_0958ca60")
local helper_238b5abc = require("@lib/event/helper_238b5abc")
local helper_25abe6d2 = require("@lib/event/helper_25abe6d2")
local helper_344d6cd8 = require("@lib/event/helper_344d6cd8")
local helper_50c65522 = require("@lib/event/helper_50c65522")
local helper_52aadc70 = require("@lib/event/helper_52aadc70")
local helper_5f5e8d9a = require("@lib/event/helper_5f5e8d9a")
local helper_c28d4a31 = require("@lib/event/helper_c28d4a31")
local helper_c624bc16 = require("@lib/event/helper_c624bc16")
local helper_d3f20302 = require("@lib/event/helper_d3f20302")

--- Helper function.
local function helper_8d7534ab()
	local var5: f32 = 0
	local at: number = 0
	vm.section(function()
		event.CharaActive(0, 0)
		event.Initialize()
		event.SetMesWindowMode(0, 7)
		event.StopBgm(0)
		at = 1
		helper_25abe6d2(4)
		event.LoadBgm(112)
		event.PlayBgm(0)
		event.LoadSound(7832)
		helper_5f5e8d9a()
		var5 = vm.f32(524.9)
		event.InitDramaScene()
		event.ObjsTexAnime(3, 0)
		event.ObjsTexAnime(3, 1, "しんけん顔")
		event.ObjsTexAnime(3, 1, "通常目パチ")
		event.ObjsTexAnime(2, 0)
		event.ObjsTexAnime(2, 1, "こまり目パチ")
		event.CharaActive(1, 11)
		event.CharaActive(1, 9)
		event.ObjsSetMotion(2, "上向き立ち", 4)
		event.ObjsSetMotion(3, "下向きち", 4)
		event.CharaActive(1, 10)
		event.CmrsCharaAttach(10, 608.0, -1)
		event.CmrsSetPos(84.11, 22.18, -160.51)
		event.CmrsSetRef(-24.24, 37.13, 48.97)
		event.ObjsSetPos(2, 36.32, 6.0, -94.75)
		event.ObjsSetRot(2, 0.0, 1.08, 0.0)
		event.ObjsSetPos(3, 56.83, 6.0, -85.35)
		event.ObjsSetRot(3, 0.0, -2.08, 0.0)
		event.CmrsFadeIn(60, 255.0, 255.0, 255.0)
		at = 2
		helper_25abe6d2(60)
		event.CmrsSetPos(70.66, 29.39, -134.52)
		event.CmrsSetRef(-24.24, 26.07, 48.97)
		event.ObjsTexaDelay(2, 30)
		event.ObjsTexAnime(2, 0)
		event.ObjsTexAnime(2, 1, "こまり目あき～目とじ")
		event.ObjsSetMotion(2, "上向き会話２", 6)
		event.ObjsNextMotion(2, "うつむく", 2)
		event.ObjsNextMotion(2, "うつむき会話", 2)
		event.ObjsNextMotion(2, "うつむくＬ", 4)
		at = 3
		helper_c28d4a31(7280020, -1)
		at = 4
		helper_25abe6d2(15)
		at = 5
		helper_0958ca60(2)
		event.ObjsTexAnime(2, 0)
		event.ObjsTexAnime(2, 1, "こまり目パチ")
		event.CmrsInit()
		event.CmrsCharaAttach(10, 340.3, 600)
		event.SetProjection(300.0)
		event.CmrsInitPas()
		event.CmrsSetPasFrm(480)
		event.CmrsAddPas(19.51, 27.36, -116.8, 62.31, 24.5, -97.55)
		event.CmrsAddPas(9.32, 27.36, -94.14, 52.12, 24.5, -74.89)
		event.CmrsStartPas()
		event.ObjsSetMotion(2, "上向き会話", 6)
		event.ObjsNextMotion(2, "上向き会話２", 4)
		at = 6
		helper_c28d4a31(7280030, -1)
		at = 7
		helper_25abe6d2(15)
		event.ObjsSetMotion(2, "上向き会話", 6)
		event.ObjsNextMotion(2, "上向き会話２", 4)
		at = 8
		helper_c28d4a31(7280040, -1)
		at = 9
		helper_25abe6d2(9)
		event.CmrsInit()
		event.CmrsSetPos(75.76, 49.76, -58.86)
		event.CmrsSetRef(28.36, 14.4, -78.25)
		event.CmrsInit()
		event.CmrsCharaAttach(10, 340.3, 660)
		event.CmrsInitPas()
		event.CmrsSetPasFrm(570)
		event.CmrsAddPas(75.76, 49.76, -58.86, 28.36, 14.4, -78.25)
		event.CmrsAddPas(89.13, 49.76, -91.53, 41.72, 14.4, -110.92)
		event.CmrsStartPas()
		event.ObjsTexAnime(2, 0)
		event.ObjsTexAnime(2, 1, "こまり目あき～目とじ")
		event.ObjsSetMotion(2, "うつむく", 6)
		event.ObjsNextMotion(2, "うつむき会話", 4)
		at = 10
		helper_c28d4a31(7280050, -1)
		at = 11
		helper_25abe6d2(15)
		at = 12
		helper_c28d4a31(7280060, -1)
		at = 13
		helper_25abe6d2(15)
		at = 14
		helper_c28d4a31(7280065, -1)
		at = 15
		helper_25abe6d2(15)
		at = 16
		helper_c624bc16()
		event.ObjsTexAnime(2, 0)
		event.ObjsTexAnime(2, 1, "目とじ～おこり目あき")
		event.ObjsTexAnime(3, 0)
		event.ObjsTexAnime(3, 1, "しんけん顔")
		event.ObjsTexAnime(3, 1, "目あき～目とじ")
		event.SetProjection(var5)
		event.ObjsSetPos(2, 41.5, 6.0, -92.07)
		event.ObjsSetPos(3, 52.45, 6.0, -87.62)
		event.CmrsInit()
		event.CmrsCharaAttach(10, 608.0, -1)
		event.CmrsSetPos(65.12, 25.03, -120.36)
		event.CmrsSetRef(-24.24, 26.07, 48.97)
		event.SetCrossfade(30)
		event.ObjsSetMotion(2, "普通立ち", 4)
		event.ObjsSetMotion(3, "しゃがむ", 2)
		event.ObjsNextMotion(3, "しゃがむＬ", 4)
		at = 17
		helper_0958ca60(3)
		event.ObjsTexAnime(2, 0)
		event.ObjsTexAnime(2, 1, "おこり目パチ２")
		event.ObjsSetMotion(3, "うつむく", 2)
		event.ObjsNextMotion(3, "うつむき会話", 2)
		event.ObjsNextMotion(3, "うつむくＬ", 4)
		event.SetPakuAnim(5, "しんけん口パク")
		at = 18
		helper_c28d4a31(7280070, -1)
		event.ResetPakuAnim()
		at = 19
		helper_25abe6d2(15)
		event.ObjsTexAnime(3, 0)
		event.ObjsTexAnime(3, 1, "しんけん顔")
		event.ObjsTexAnime(3, 1, "目とじ～目あき")
		event.ObjsSetMotion(3, "うつむく戻り", 2)
		event.ObjsNextMotion(3, "しゃがむ会話", 2)
		event.ObjsNextMotion(3, "しゃがむＬ", 4)
		event.SetPakuAnim(5, "通常口パク")
		at = 20
		helper_c28d4a31(7280080, -1)
		event.ResetPakuAnim()
		at = 21
		helper_25abe6d2(15)
		event.ObjsSetMotion(3, "しゃがむ会話", 2)
		event.ObjsNextMotion(3, "しゃがむＬ", 4)
		event.SetPakuAnim(5, "通常口パク")
		at = 22
		helper_c28d4a31(7280085, -1)
		event.ResetPakuAnim()
		at = 23
		helper_25abe6d2(15)
		event.ObjsSetMotion(3, "しゃがむ会話", 2)
		event.ObjsNextMotion(3, "しゃがむＬ", 4)
		event.SpriteSetDraw(0, 1)
		event.ObjsSetColor(20, 128, 128, 128, 128, 30)
		event.SetPakuAnim(5, "通常口パク")
		at = 24
		helper_c28d4a31(7280090, -1)
		event.ResetPakuAnim()
		at = 25
		helper_25abe6d2(15)
		event.ObjsSetMotion(3, "しゃがむ会話", 2)
		event.ObjsNextMotion(3, "しゃがむＬ", 4)
		event.SpriteSetDraw(1, 1)
		event.ObjsSetColor(21, 128, 128, 128, 128, 30)
		event.SetPakuAnim(5, "通常口パク")
		at = 26
		helper_c28d4a31(7280095, -1)
		event.ResetPakuAnim()
		at = 27
		helper_25abe6d2(15)
		event.ObjsSetMotion(3, "しゃがむ会話", 2)
		event.ObjsNextMotion(3, "しゃがむＬ", 4)
		event.SpriteSetDraw(2, 1)
		event.ObjsSetColor(22, 128, 128, 128, 128, 30)
		event.SetPakuAnim(5, "通常口パク")
		at = 28
		helper_c28d4a31(7280100, -1)
		event.ResetPakuAnim()
		at = 29
		helper_25abe6d2(15)
		event.ObjsSetMotion(3, "しゃがむ会話", 2)
		event.ObjsNextMotion(3, "しゃがむＬ", 4)
		event.SpriteSetDraw(3, 1)
		event.ObjsSetColor(23, 128, 128, 128, 128, 30)
		event.SetPakuAnim(5, "通常口パク")
		at = 30
		helper_c28d4a31(7280105, -1)
		event.ResetPakuAnim()
		at = 31
		helper_25abe6d2(15)
		event.SpriteSetDraw(0, 0)
		event.SpriteSetDraw(1, 0)
		event.SpriteSetDraw(2, 0)
		event.ObjsSetColor(23, 128, 128, 128, 0, 30)
		event.ObjsTexAnime(3, 0)
		event.ObjsTexAnime(3, 1, "しんけん顔")
		event.ObjsTexAnime(3, 1, "通常目パチ")
		event.ObjsSetMotion(3, "肩に手", 2)
		event.ObjsNextMotion(3, "肩に手会話", 2)
		event.ObjsNextMotion(3, "肩に手Ｌ", 4)
		event.SetPakuAnim(5, "通常口パク")
		at = 32
		helper_c28d4a31(7280110, -1)
		event.ResetPakuAnim()
		at = 33
		helper_25abe6d2(15)
		event.ObjsSetMotion(3, "肩に手会話", 2)
		event.ObjsNextMotion(3, "肩に手Ｌ", 4)
		event.SetPakuAnim(5, "通常口パク")
		at = 34
		helper_c28d4a31(7280115, -1)
		event.ResetPakuAnim()
		at = 35
		helper_25abe6d2(15)
		event.ObjsTexAnime(2, 0)
		event.ObjsTexAnime(2, 1, "おこり目あき～目とじ")
		event.ObjsSetMotion(2, "顔ふる", 2)
		event.ObjsNextMotion(2, "顔ふるＬ", 4)
		at = 36
		helper_c28d4a31(7280120, -1)
		at = 37
		helper_25abe6d2(15)
		event.ObjsTexAnime(2, 0)
		event.ObjsTexAnime(2, 1, "おこり目とじ～おこり目あき")
		event.ObjsSetMotion(2, "顔ふる戻る", 2)
		event.ObjsNextMotion(2, "普通立ち", 4)
		event.ObjsTexAnime(3, 0)
		event.ObjsTexAnime(3, 1, "しんけん顔")
		event.ObjsTexAnime(3, 1, "目あき～かなし目とじ")
		event.ObjsTexAnime(3, 1, "口とじ")
		event.ObjsSetMotion(3, "肩に手からうつむく", 2)
		event.ObjsNextMotion(3, "うつむくＬ", 4)
		at = 38
		helper_0958ca60(2)
		at = 39
		helper_0958ca60(3)
		event.ObjsSetMotion(2, "つかもうとする", 2)
		event.ObjsNextMotion(2, "つかもうとするＬ", 4)
		at = 40
		helper_25abe6d2(15)
		event.SetCharaShow(9, 0, 1, 0.025)
		at = 41
		helper_25abe6d2(60)
		event.ObjsTexAnime(2, 0)
		event.ObjsTexAnime(2, 1, "おこり目あき～こまり目とじ")
		event.ObjsSetMotion(2, "手をおろす", 2)
		event.ObjsNextMotion(2, "手をおろすＬ", 4)
		at = 42
		helper_0958ca60(2)
	end, function(received: { any }): boolean
		if at <= 1 then
			helper_344d6cd8()
			var5 = vm.f32(524.9)
			helper_d3f20302(60)
		end
		if at <= 2 then
			helper_52aadc70(7280020, -1)
		end
		if at <= 3 then
			helper_d3f20302(15)
		end
		if at <= 4 then
			helper_238b5abc(2)
		end
		if at <= 5 then
			helper_52aadc70(7280030, -1)
		end
		if at <= 6 then
			helper_d3f20302(15)
		end
		if at <= 7 then
			helper_52aadc70(7280040, -1)
		end
		if at <= 8 then
			helper_d3f20302(9)
		end
		if at <= 9 then
			helper_52aadc70(7280050, -1)
		end
		if at <= 10 then
			helper_d3f20302(15)
		end
		if at <= 11 then
			helper_52aadc70(7280060, -1)
		end
		if at <= 12 then
			helper_d3f20302(15)
		end
		if at <= 13 then
			helper_52aadc70(7280065, -1)
		end
		if at <= 14 then
			helper_d3f20302(15)
		end
		if at <= 15 then
			helper_344d6cd8()
		end
		if at <= 16 then
			helper_238b5abc(3)
		end
		if at <= 17 then
			helper_52aadc70(7280070, -1)
		end
		if at <= 18 then
			helper_d3f20302(15)
		end
		if at <= 19 then
			helper_52aadc70(7280080, -1)
		end
		if at <= 20 then
			helper_d3f20302(15)
		end
		if at <= 21 then
			helper_52aadc70(7280085, -1)
		end
		if at <= 22 then
			helper_d3f20302(15)
		end
		if at <= 23 then
			helper_52aadc70(7280090, -1)
		end
		if at <= 24 then
			helper_d3f20302(15)
		end
		if at <= 25 then
			helper_52aadc70(7280095, -1)
		end
		if at <= 26 then
			helper_d3f20302(15)
		end
		if at <= 27 then
			helper_52aadc70(7280100, -1)
		end
		if at <= 28 then
			helper_d3f20302(15)
		end
		if at <= 29 then
			helper_52aadc70(7280105, -1)
		end
		if at <= 30 then
			helper_d3f20302(15)
		end
		if at <= 31 then
			helper_52aadc70(7280110, -1)
		end
		if at <= 32 then
			helper_d3f20302(15)
		end
		if at <= 33 then
			helper_52aadc70(7280115, -1)
		end
		if at <= 34 then
			helper_d3f20302(15)
		end
		if at <= 35 then
			helper_52aadc70(7280120, -1)
		end
		if at <= 36 then
			helper_d3f20302(15)
		end
		if at <= 37 then
			helper_238b5abc(2)
		end
		if at <= 38 then
			helper_238b5abc(3)
		end
		if at <= 39 then
			helper_d3f20302(15)
		end
		if at <= 40 then
			helper_d3f20302(60)
		end
		if at <= 41 then
			helper_238b5abc(2)
		end
		return true
	end)
	event.CancelDramaScene()
	event.FadeOutBgm(60)
	event.CmrsFadeOut(60, 255.0, 255.0, 255.0)
	at = 43
	helper_25abe6d2(60)
	event.StopBgm(0)
	event.SetProjection(var5)
	at = 44
	vm.wait(44)
	helper_50c65522()
end

return helper_8d7534ab
