--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_23bda4ba = require("@lib/event/helper_23bda4ba")
local helper_261c70db = require("@lib/event/helper_261c70db")
local helper_3ea45d11 = require("@lib/event/helper_3ea45d11")
local helper_adea7ba0 = require("@lib/event/helper_adea7ba0")
local helper_c97937b6 = require("@lib/event/helper_c97937b6")
local helper_f5462b63 = require("@lib/event/helper_f5462b63")

--- Helper function.
local function helper_f10dcb85()
	local var5: f32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 42 then
			if at <= 1 then
				helper_f5462b63()
				var5 = vm.f32(524.9)
				helper_adea7ba0(60)
			end
			if at <= 2 then
				helper_3ea45d11(7280020, -1)
			end
			if at <= 3 then
				helper_adea7ba0(15)
			end
			if at <= 4 then
				helper_23bda4ba(2)
			end
			if at <= 5 then
				helper_3ea45d11(7280030, -1)
			end
			if at <= 6 then
				helper_adea7ba0(15)
			end
			if at <= 7 then
				helper_3ea45d11(7280040, -1)
			end
			if at <= 8 then
				helper_adea7ba0(9)
			end
			if at <= 9 then
				helper_3ea45d11(7280050, -1)
			end
			if at <= 10 then
				helper_adea7ba0(15)
			end
			if at <= 11 then
				helper_3ea45d11(7280060, -1)
			end
			if at <= 12 then
				helper_adea7ba0(15)
			end
			if at <= 13 then
				helper_3ea45d11(7280065, -1)
			end
			if at <= 14 then
				helper_adea7ba0(15)
			end
			if at <= 15 then
				helper_261c70db()
			end
			if at <= 16 then
				helper_23bda4ba(3)
			end
			if at <= 17 then
				helper_3ea45d11(7280070, -1)
			end
			if at <= 18 then
				helper_adea7ba0(15)
			end
			if at <= 19 then
				helper_3ea45d11(7280080, -1)
			end
			if at <= 20 then
				helper_adea7ba0(15)
			end
			if at <= 21 then
				helper_3ea45d11(7280085, -1)
			end
			if at <= 22 then
				helper_adea7ba0(15)
			end
			if at <= 23 then
				helper_3ea45d11(7280090, -1)
			end
			if at <= 24 then
				helper_adea7ba0(15)
			end
			if at <= 25 then
				helper_3ea45d11(7280095, -1)
			end
			if at <= 26 then
				helper_adea7ba0(15)
			end
			if at <= 27 then
				helper_3ea45d11(7280100, -1)
			end
			if at <= 28 then
				helper_adea7ba0(15)
			end
			if at <= 29 then
				helper_3ea45d11(7280105, -1)
			end
			if at <= 30 then
				helper_adea7ba0(15)
			end
			if at <= 31 then
				helper_3ea45d11(7280110, -1)
			end
			if at <= 32 then
				helper_adea7ba0(15)
			end
			if at <= 33 then
				helper_3ea45d11(7280115, -1)
			end
			if at <= 34 then
				helper_adea7ba0(15)
			end
			if at <= 35 then
				helper_3ea45d11(7280120, -1)
			end
			if at <= 36 then
				helper_adea7ba0(15)
			end
			if at <= 37 then
				helper_23bda4ba(2)
			end
			if at <= 38 then
				helper_23bda4ba(3)
			end
			if at <= 39 then
				helper_adea7ba0(15)
			end
			if at <= 40 then
				helper_adea7ba0(60)
			end
			if at <= 41 then
				helper_23bda4ba(2)
			end
			if vm.skip_end() then
				return skip(43)
			end
			return part2()
		end
		if at <= 43 then
			helper_adea7ba0(60)
		end
		helper_c97937b6()
	end
	function part2()
		event.CancelDramaScene()
		event.FadeOutBgm(60)
		event.CmrsFadeOut(60, 255.0, 255.0, 255.0)
		helper_adea7ba0(60)
		if vm.skipping() then
			return skip(44)
		end
		event.StopBgm(0)
		event.SetProjection(var5)
		if vm.wait() then
			return skip(45)
		end
		helper_c97937b6()
	end
	event.CharaActive(0, 0)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.StopBgm(0)
	helper_adea7ba0(4)
	if vm.skipping() then
		return skip(1)
	end
	event.LoadBgm(112)
	event.PlayBgm(0)
	event.LoadSound(7832)
	helper_f5462b63()
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
	helper_adea7ba0(60)
	if vm.skipping() then
		return skip(2)
	end
	event.CmrsSetPos(70.66, 29.39, -134.52)
	event.CmrsSetRef(-24.24, 26.07, 48.97)
	event.ObjsTexaDelay(2, 30)
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "こまり目あき～目とじ")
	event.ObjsSetMotion(2, "上向き会話２", 6)
	event.ObjsNextMotion(2, "うつむく", 2)
	event.ObjsNextMotion(2, "うつむき会話", 2)
	event.ObjsNextMotion(2, "うつむくＬ", 4)
	helper_3ea45d11(7280020, -1)
	if vm.skipping() then
		return skip(3)
	end
	helper_adea7ba0(15)
	if vm.skipping() then
		return skip(4)
	end
	helper_23bda4ba(2)
	if vm.skipping() then
		return skip(5)
	end
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
	helper_3ea45d11(7280030, -1)
	if vm.skipping() then
		return skip(6)
	end
	helper_adea7ba0(15)
	if vm.skipping() then
		return skip(7)
	end
	event.ObjsSetMotion(2, "上向き会話", 6)
	event.ObjsNextMotion(2, "上向き会話２", 4)
	helper_3ea45d11(7280040, -1)
	if vm.skipping() then
		return skip(8)
	end
	helper_adea7ba0(9)
	if vm.skipping() then
		return skip(9)
	end
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
	helper_3ea45d11(7280050, -1)
	if vm.skipping() then
		return skip(10)
	end
	helper_adea7ba0(15)
	if vm.skipping() then
		return skip(11)
	end
	helper_3ea45d11(7280060, -1)
	if vm.skipping() then
		return skip(12)
	end
	helper_adea7ba0(15)
	if vm.skipping() then
		return skip(13)
	end
	helper_3ea45d11(7280065, -1)
	if vm.skipping() then
		return skip(14)
	end
	helper_adea7ba0(15)
	if vm.skipping() then
		return skip(15)
	end
	helper_261c70db()
	if vm.skipping() then
		return skip(16)
	end
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
	helper_23bda4ba(3)
	if vm.skipping() then
		return skip(17)
	end
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "おこり目パチ２")
	event.ObjsSetMotion(3, "うつむく", 2)
	event.ObjsNextMotion(3, "うつむき会話", 2)
	event.ObjsNextMotion(3, "うつむくＬ", 4)
	event.SetPakuAnim(5, "しんけん口パク")
	helper_3ea45d11(7280070, -1)
	if vm.skipping() then
		return skip(18)
	end
	event.ResetPakuAnim()
	helper_adea7ba0(15)
	if vm.skipping() then
		return skip(19)
	end
	event.ObjsTexAnime(3, 0)
	event.ObjsTexAnime(3, 1, "しんけん顔")
	event.ObjsTexAnime(3, 1, "目とじ～目あき")
	event.ObjsSetMotion(3, "うつむく戻り", 2)
	event.ObjsNextMotion(3, "しゃがむ会話", 2)
	event.ObjsNextMotion(3, "しゃがむＬ", 4)
	event.SetPakuAnim(5, "通常口パク")
	helper_3ea45d11(7280080, -1)
	if vm.skipping() then
		return skip(20)
	end
	event.ResetPakuAnim()
	helper_adea7ba0(15)
	if vm.skipping() then
		return skip(21)
	end
	event.ObjsSetMotion(3, "しゃがむ会話", 2)
	event.ObjsNextMotion(3, "しゃがむＬ", 4)
	event.SetPakuAnim(5, "通常口パク")
	helper_3ea45d11(7280085, -1)
	if vm.skipping() then
		return skip(22)
	end
	event.ResetPakuAnim()
	helper_adea7ba0(15)
	if vm.skipping() then
		return skip(23)
	end
	event.ObjsSetMotion(3, "しゃがむ会話", 2)
	event.ObjsNextMotion(3, "しゃがむＬ", 4)
	event.SpriteSetDraw(0, 1)
	event.ObjsSetColor(20, 128, 128, 128, 128, 30)
	event.SetPakuAnim(5, "通常口パク")
	helper_3ea45d11(7280090, -1)
	if vm.skipping() then
		return skip(24)
	end
	event.ResetPakuAnim()
	helper_adea7ba0(15)
	if vm.skipping() then
		return skip(25)
	end
	event.ObjsSetMotion(3, "しゃがむ会話", 2)
	event.ObjsNextMotion(3, "しゃがむＬ", 4)
	event.SpriteSetDraw(1, 1)
	event.ObjsSetColor(21, 128, 128, 128, 128, 30)
	event.SetPakuAnim(5, "通常口パク")
	helper_3ea45d11(7280095, -1)
	if vm.skipping() then
		return skip(26)
	end
	event.ResetPakuAnim()
	helper_adea7ba0(15)
	if vm.skipping() then
		return skip(27)
	end
	event.ObjsSetMotion(3, "しゃがむ会話", 2)
	event.ObjsNextMotion(3, "しゃがむＬ", 4)
	event.SpriteSetDraw(2, 1)
	event.ObjsSetColor(22, 128, 128, 128, 128, 30)
	event.SetPakuAnim(5, "通常口パク")
	helper_3ea45d11(7280100, -1)
	if vm.skipping() then
		return skip(28)
	end
	event.ResetPakuAnim()
	helper_adea7ba0(15)
	if vm.skipping() then
		return skip(29)
	end
	event.ObjsSetMotion(3, "しゃがむ会話", 2)
	event.ObjsNextMotion(3, "しゃがむＬ", 4)
	event.SpriteSetDraw(3, 1)
	event.ObjsSetColor(23, 128, 128, 128, 128, 30)
	event.SetPakuAnim(5, "通常口パク")
	helper_3ea45d11(7280105, -1)
	if vm.skipping() then
		return skip(30)
	end
	event.ResetPakuAnim()
	helper_adea7ba0(15)
	if vm.skipping() then
		return skip(31)
	end
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
	helper_3ea45d11(7280110, -1)
	if vm.skipping() then
		return skip(32)
	end
	event.ResetPakuAnim()
	helper_adea7ba0(15)
	if vm.skipping() then
		return skip(33)
	end
	event.ObjsSetMotion(3, "肩に手会話", 2)
	event.ObjsNextMotion(3, "肩に手Ｌ", 4)
	event.SetPakuAnim(5, "通常口パク")
	helper_3ea45d11(7280115, -1)
	if vm.skipping() then
		return skip(34)
	end
	event.ResetPakuAnim()
	helper_adea7ba0(15)
	if vm.skipping() then
		return skip(35)
	end
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "おこり目あき～目とじ")
	event.ObjsSetMotion(2, "顔ふる", 2)
	event.ObjsNextMotion(2, "顔ふるＬ", 4)
	helper_3ea45d11(7280120, -1)
	if vm.skipping() then
		return skip(36)
	end
	helper_adea7ba0(15)
	if vm.skipping() then
		return skip(37)
	end
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
	helper_23bda4ba(2)
	if vm.skipping() then
		return skip(38)
	end
	helper_23bda4ba(3)
	if vm.skipping() then
		return skip(39)
	end
	event.ObjsSetMotion(2, "つかもうとする", 2)
	event.ObjsNextMotion(2, "つかもうとするＬ", 4)
	helper_adea7ba0(15)
	if vm.skipping() then
		return skip(40)
	end
	event.SetCharaShow(9, 0, 1, 0.025)
	helper_adea7ba0(60)
	if vm.skipping() then
		return skip(41)
	end
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "おこり目あき～こまり目とじ")
	event.ObjsSetMotion(2, "手をおろす", 2)
	event.ObjsNextMotion(2, "手をおろすＬ", 4)
	helper_23bda4ba(2)
	if vm.skipping() then
		return skip(42)
	end
	return part2()
end

return helper_f10dcb85
