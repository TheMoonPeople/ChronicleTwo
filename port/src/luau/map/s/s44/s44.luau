--!strict
-- map/s/s44/s44.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_31919a1e = require("@lib/event/helper_31919a1e")
local helper_690ecd8a = require("@lib/event/helper_690ecd8a")
local helper_af3fca28 = require("@lib/event/helper_af3fca28")
local helper_ce122344 = require("@lib/event/helper_ce122344")
local helper_d4b8f712 = require("@lib/event/helper_d4b8f712")
local helper_e9042a30 = require("@lib/event/helper_e9042a30")

--- Helper function.
local function helper_ee8(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			local _ = helper_31919a1e(arg0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	while true do
		if helper_31919a1e(arg0) ~= 0 then
			break
		else
			if vm.wait() then
				return skip(2)
			end
		end
	end
end

--- Helper function.
local function helper_12138()
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesWindowMode(0, 7)
	event.SetStatusbarShow(0, 1.0)
	event.AssignStack(5)
	event.ClearStack(5)
	event.LoadChara(5, "event/e700/e732/e732_sun.gltf", "info", 35)
	event.CharaActive(0, 35)
	event.EohSyncChara(4, 35)
	event.ObjsInit(2, 35)
	event.ObjsSyncObj(2, 4)
	event.LoadChara(5, "event/e700/e732/e732_andrea.gltf", "info", 33)
	event.CharaActive(0, 33)
	event.EohSyncChara(5, 33)
	event.ObjsInit(3, 33)
	event.ObjsSyncObj(3, 5)
	event.LoadChara(5, "event/e700/e728/kaisou_waku.gltf", "info", 34)
	event.CharaActive(0, 34)
	event.SetCharaType(34, 4)
	event.LoadMes(0, 5, "event/e700/e732/e732.txt")
end

--- Helper function.
local function helper_11ff8()
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.CharaActive(1, 0)
	event.DeleteChara(35)
	event.DeleteChara(33)
	event.DeleteChara(34)
	event.SetStatusbarShow(1, 1.0)
	event.Finish()
end

--- Helper function.
local function helper_125d0()
	local projection: f32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 7 then
			if at <= 1 then
				helper_12138()
				helper_690ecd8a(60)
			end
			if at <= 2 then
				helper_af3fca28(2)
			end
			if at <= 3 then
				helper_af3fca28(2)
			end
			if at <= 4 then
				helper_690ecd8a(30)
			end
			if at <= 5 then
				helper_d4b8f712()
			end
			if at <= 6 then
				helper_690ecd8a(60)
			end
			if vm.skip_end() then
				return skip(8)
			end
			return part2()
		end
		helper_11ff8()
	end
	function part2()
		event.CancelDramaScene()
		event.SetProjection(projection)
		event.BgmLoadCancel()
		helper_11ff8()
	end
	event.CharaActive(0, 0)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.StopBgm(0)
	if vm.wait() then
		return skip(1)
	end
	event.LoadSound(7840)
	helper_12138()
	projection = event.GetProjection() or projection
	event.InitDramaScene()
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "泣き目")
	event.CharaActive(1, 35)
	event.CharaActive(1, 33)
	event.ObjsSetMotion(2, "走り", 4)
	event.ObjsSetMotion(3, "立ち", 4)
	event.CmrsCharaAttach(34, 760.0, -1)
	event.CmrsSetPos(-152.72, 63.59, 450.23)
	event.CmrsSetRef(0.0, 8.4, 400.0)
	event.ObjsSetPos(2, 0.0, 0.0, 400.0)
	event.ObjsSetRot(2, 0.0, 3.12, 0.0)
	event.ObjsSetPos(3, 0.0, 0.0, 220.0)
	event.ObjsSetRot(3, 0.0, 3.12, 0.0)
	event.CmrsFadeIn(60, 255.0, 255.0, 255.0)
	event.CmrsMoveRef(0.0, 8.4, 200.0, 150)
	event.ObjsMove(2, 0.0, 0.0, 220.0, 120, 1)
	helper_690ecd8a(60)
	if vm.skipping() then
		return skip(2)
	end
	event.ObjsSetMotion(3, "しゃがむ", 2)
	event.ObjsNextMotion(3, "しゃがむL", 4)
	helper_af3fca28(2)
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "泣き目とじ")
	event.ObjsSetMotion(2, "抱きつく", 2)
	event.ObjsNextMotion(2, "抱きつくL", 4)
	event.ObjsSetMotion(3, "抱きつく", 2)
	event.ObjsNextMotion(3, "抱きつくL", 4)
	helper_af3fca28(2)
	if vm.skipping() then
		return skip(4)
	end
	helper_690ecd8a(30)
	if vm.skipping() then
		return skip(5)
	end
	event.CmrsInit()
	event.CmrsCharaAttach(34, 760.0, 480.0)
	event.CmrsMoveRef(0.0, 389.25, 200.0, 480)
	helper_d4b8f712()
	if vm.skipping() then
		return skip(6)
	end
	event.CmrsFadeOut(60, 255.0, 255.0, 255.0)
	helper_690ecd8a(60)
	if vm.skipping() then
		return skip(7)
	end
	return part2()
end

--- Helper function.
local function helper_e040()
	local block: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesWindowMode(0, 7)
	event.SetStatusbarShow(0, 1.0)
	event.AssignStack(5)
	event.ClearStack(5)
	event.LoadChara(5, "event/e700/e728/e728_fb_sun.gltf", "info", 11)
	event.CharaActive(0, 11)
	event.EohSyncChara(4, 11)
	event.ObjsInit(2, 11)
	event.ObjsSyncObj(2, 4)
	event.LoadChara(5, "event/e700/e728/e728_andrea.gltf", "info", 9)
	event.CharaActive(0, 9)
	event.EohSyncChara(5, 9)
	event.ObjsInit(3, 9)
	event.ObjsSyncObj(3, 5)
	event.LoadChara(5, "event/e700/e728/kaisou_waku.gltf", "info", 10)
	event.CharaActive(0, 10)
	event.SetCharaType(10, 4)
	block = event.LoadImg_4(5, "textures/event/e700/e728/e728.json", 0) or block
	event.SpriteInit(0)
	event.SpriteSetType(0, 0)
	event.SpriteSetTexture(0, "e72801", block)
	event.SpriteSetColor(0, 128, 128, 128, 0)
	event.SpriteSetUvsize(0, 0, 0, 512, 416)
	event.SpriteSetPutsize(0, 512, 416)
	event.SpriteSetPos(0, 256, 208)
	event.SpriteSetDraw(0, 0)
	event.EohSyncSprite(20, 0)
	event.ObjsInit(20)
	event.ObjsSyncObj(20, 20)
	event.SpriteInit(1)
	event.SpriteSetType(1, 0)
	event.SpriteSetTexture(1, "e72802", block)
	event.SpriteSetColor(1, 128, 128, 128, 0)
	event.SpriteSetUvsize(1, 0, 0, 512, 416)
	event.SpriteSetPutsize(1, 512, 416)
	event.SpriteSetPos(1, 256, 208)
	event.SpriteSetDraw(1, 0)
	event.EohSyncSprite(21, 1)
	event.ObjsInit(21)
	event.ObjsSyncObj(21, 21)
	event.SpriteInit(2)
	event.SpriteSetType(2, 0)
	event.SpriteSetTexture(2, "e72803", block)
	event.SpriteSetColor(2, 128, 128, 128, 0)
	event.SpriteSetUvsize(2, 0, 0, 512, 416)
	event.SpriteSetPutsize(2, 512, 416)
	event.SpriteSetPos(2, 256, 208)
	event.SpriteSetDraw(2, 0)
	event.EohSyncSprite(22, 2)
	event.ObjsInit(22)
	event.ObjsSyncObj(22, 22)
	event.SpriteInit(3)
	event.SpriteSetType(3, 0)
	event.SpriteSetTexture(3, "e72804", block)
	event.SpriteSetColor(3, 128, 128, 128, 0)
	event.SpriteSetUvsize(3, 0, 0, 512.0, 416.0)
	event.SpriteSetPutsize(3, 512, 416)
	event.SpriteSetPos(3, 256, 208)
	event.SpriteSetDraw(3, 0)
	event.EohSyncSprite(23, 3)
	event.ObjsInit(23)
	event.ObjsSyncObj(23, 23)
	event.LoadMes(0, 5, "event/e700/e728/e728.txt")
end

--- Helper function.
local function helper_dedc()
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.CharaActive(1, 0)
	event.DeleteChara(11)
	event.DeleteChara(9)
	event.DeleteChara(10)
	event.DelImg(0)
	event.SetStatusbarShow(1, 1.0)
	event.Finish()
end

--- Helper function.
local function helper_efa0()
	local var5: f32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 42 then
			if at <= 1 then
				helper_e040()
				var5 = vm.f32(524.9)
				helper_690ecd8a(60)
			end
			if at <= 2 then
				helper_ce122344(7280020, -1)
			end
			if at <= 3 then
				helper_690ecd8a(15)
			end
			if at <= 4 then
				helper_af3fca28(2)
			end
			if at <= 5 then
				helper_ce122344(7280030, -1)
			end
			if at <= 6 then
				helper_690ecd8a(15)
			end
			if at <= 7 then
				helper_ce122344(7280040, -1)
			end
			if at <= 8 then
				helper_690ecd8a(9)
			end
			if at <= 9 then
				helper_ce122344(7280050, -1)
			end
			if at <= 10 then
				helper_690ecd8a(15)
			end
			if at <= 11 then
				helper_ce122344(7280060, -1)
			end
			if at <= 12 then
				helper_690ecd8a(15)
			end
			if at <= 13 then
				helper_ce122344(7280065, -1)
			end
			if at <= 14 then
				helper_690ecd8a(15)
			end
			if at <= 15 then
				helper_d4b8f712()
			end
			if at <= 16 then
				helper_af3fca28(3)
			end
			if at <= 17 then
				helper_ce122344(7280070, -1)
			end
			if at <= 18 then
				helper_690ecd8a(15)
			end
			if at <= 19 then
				helper_ce122344(7280080, -1)
			end
			if at <= 20 then
				helper_690ecd8a(15)
			end
			if at <= 21 then
				helper_ce122344(7280085, -1)
			end
			if at <= 22 then
				helper_690ecd8a(15)
			end
			if at <= 23 then
				helper_ce122344(7280090, -1)
			end
			if at <= 24 then
				helper_690ecd8a(15)
			end
			if at <= 25 then
				helper_ce122344(7280095, -1)
			end
			if at <= 26 then
				helper_690ecd8a(15)
			end
			if at <= 27 then
				helper_ce122344(7280100, -1)
			end
			if at <= 28 then
				helper_690ecd8a(15)
			end
			if at <= 29 then
				helper_ce122344(7280105, -1)
			end
			if at <= 30 then
				helper_690ecd8a(15)
			end
			if at <= 31 then
				helper_ce122344(7280110, -1)
			end
			if at <= 32 then
				helper_690ecd8a(15)
			end
			if at <= 33 then
				helper_ce122344(7280115, -1)
			end
			if at <= 34 then
				helper_690ecd8a(15)
			end
			if at <= 35 then
				helper_ce122344(7280120, -1)
			end
			if at <= 36 then
				helper_690ecd8a(15)
			end
			if at <= 37 then
				helper_af3fca28(2)
			end
			if at <= 38 then
				helper_af3fca28(3)
			end
			if at <= 39 then
				helper_690ecd8a(15)
			end
			if at <= 40 then
				helper_690ecd8a(60)
			end
			if at <= 41 then
				helper_af3fca28(2)
			end
			if vm.skip_end() then
				return skip(43)
			end
			return part2()
		end
		if at <= 43 then
			helper_690ecd8a(60)
		end
		helper_dedc()
	end
	function part2()
		event.CancelDramaScene()
		event.FadeOutBgm(60)
		event.CmrsFadeOut(60, 255.0, 255.0, 255.0)
		helper_690ecd8a(60)
		if vm.skipping() then
			return skip(44)
		end
		event.StopBgm(0)
		event.SetProjection(var5)
		if vm.wait() then
			return skip(45)
		end
		helper_dedc()
	end
	event.CharaActive(0, 0)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.StopBgm(0)
	helper_690ecd8a(4)
	if vm.skipping() then
		return skip(1)
	end
	event.LoadBgm(112)
	event.PlayBgm(0)
	event.LoadSound(7832)
	helper_e040()
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
	helper_690ecd8a(60)
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
	helper_ce122344(7280020, -1)
	if vm.skipping() then
		return skip(3)
	end
	helper_690ecd8a(15)
	if vm.skipping() then
		return skip(4)
	end
	helper_af3fca28(2)
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
	helper_ce122344(7280030, -1)
	if vm.skipping() then
		return skip(6)
	end
	helper_690ecd8a(15)
	if vm.skipping() then
		return skip(7)
	end
	event.ObjsSetMotion(2, "上向き会話", 6)
	event.ObjsNextMotion(2, "上向き会話２", 4)
	helper_ce122344(7280040, -1)
	if vm.skipping() then
		return skip(8)
	end
	helper_690ecd8a(9)
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
	helper_ce122344(7280050, -1)
	if vm.skipping() then
		return skip(10)
	end
	helper_690ecd8a(15)
	if vm.skipping() then
		return skip(11)
	end
	helper_ce122344(7280060, -1)
	if vm.skipping() then
		return skip(12)
	end
	helper_690ecd8a(15)
	if vm.skipping() then
		return skip(13)
	end
	helper_ce122344(7280065, -1)
	if vm.skipping() then
		return skip(14)
	end
	helper_690ecd8a(15)
	if vm.skipping() then
		return skip(15)
	end
	helper_d4b8f712()
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
	helper_af3fca28(3)
	if vm.skipping() then
		return skip(17)
	end
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "おこり目パチ２")
	event.ObjsSetMotion(3, "うつむく", 2)
	event.ObjsNextMotion(3, "うつむき会話", 2)
	event.ObjsNextMotion(3, "うつむくＬ", 4)
	event.SetPakuAnim(5, "しんけん口パク")
	helper_ce122344(7280070, -1)
	if vm.skipping() then
		return skip(18)
	end
	event.ResetPakuAnim()
	helper_690ecd8a(15)
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
	helper_ce122344(7280080, -1)
	if vm.skipping() then
		return skip(20)
	end
	event.ResetPakuAnim()
	helper_690ecd8a(15)
	if vm.skipping() then
		return skip(21)
	end
	event.ObjsSetMotion(3, "しゃがむ会話", 2)
	event.ObjsNextMotion(3, "しゃがむＬ", 4)
	event.SetPakuAnim(5, "通常口パク")
	helper_ce122344(7280085, -1)
	if vm.skipping() then
		return skip(22)
	end
	event.ResetPakuAnim()
	helper_690ecd8a(15)
	if vm.skipping() then
		return skip(23)
	end
	event.ObjsSetMotion(3, "しゃがむ会話", 2)
	event.ObjsNextMotion(3, "しゃがむＬ", 4)
	event.SpriteSetDraw(0, 1)
	event.ObjsSetColor(20, 128, 128, 128, 128, 30)
	event.SetPakuAnim(5, "通常口パク")
	helper_ce122344(7280090, -1)
	if vm.skipping() then
		return skip(24)
	end
	event.ResetPakuAnim()
	helper_690ecd8a(15)
	if vm.skipping() then
		return skip(25)
	end
	event.ObjsSetMotion(3, "しゃがむ会話", 2)
	event.ObjsNextMotion(3, "しゃがむＬ", 4)
	event.SpriteSetDraw(1, 1)
	event.ObjsSetColor(21, 128, 128, 128, 128, 30)
	event.SetPakuAnim(5, "通常口パク")
	helper_ce122344(7280095, -1)
	if vm.skipping() then
		return skip(26)
	end
	event.ResetPakuAnim()
	helper_690ecd8a(15)
	if vm.skipping() then
		return skip(27)
	end
	event.ObjsSetMotion(3, "しゃがむ会話", 2)
	event.ObjsNextMotion(3, "しゃがむＬ", 4)
	event.SpriteSetDraw(2, 1)
	event.ObjsSetColor(22, 128, 128, 128, 128, 30)
	event.SetPakuAnim(5, "通常口パク")
	helper_ce122344(7280100, -1)
	if vm.skipping() then
		return skip(28)
	end
	event.ResetPakuAnim()
	helper_690ecd8a(15)
	if vm.skipping() then
		return skip(29)
	end
	event.ObjsSetMotion(3, "しゃがむ会話", 2)
	event.ObjsNextMotion(3, "しゃがむＬ", 4)
	event.SpriteSetDraw(3, 1)
	event.ObjsSetColor(23, 128, 128, 128, 128, 30)
	event.SetPakuAnim(5, "通常口パク")
	helper_ce122344(7280105, -1)
	if vm.skipping() then
		return skip(30)
	end
	event.ResetPakuAnim()
	helper_690ecd8a(15)
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
	helper_ce122344(7280110, -1)
	if vm.skipping() then
		return skip(32)
	end
	event.ResetPakuAnim()
	helper_690ecd8a(15)
	if vm.skipping() then
		return skip(33)
	end
	event.ObjsSetMotion(3, "肩に手会話", 2)
	event.ObjsNextMotion(3, "肩に手Ｌ", 4)
	event.SetPakuAnim(5, "通常口パク")
	helper_ce122344(7280115, -1)
	if vm.skipping() then
		return skip(34)
	end
	event.ResetPakuAnim()
	helper_690ecd8a(15)
	if vm.skipping() then
		return skip(35)
	end
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "おこり目あき～目とじ")
	event.ObjsSetMotion(2, "顔ふる", 2)
	event.ObjsNextMotion(2, "顔ふるＬ", 4)
	helper_ce122344(7280120, -1)
	if vm.skipping() then
		return skip(36)
	end
	helper_690ecd8a(15)
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
	helper_af3fca28(2)
	if vm.skipping() then
		return skip(38)
	end
	helper_af3fca28(3)
	if vm.skipping() then
		return skip(39)
	end
	event.ObjsSetMotion(2, "つかもうとする", 2)
	event.ObjsNextMotion(2, "つかもうとするＬ", 4)
	helper_690ecd8a(15)
	if vm.skipping() then
		return skip(40)
	end
	event.SetCharaShow(9, 0, 1, 0.025)
	helper_690ecd8a(60)
	if vm.skipping() then
		return skip(41)
	end
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "おこり目あき～こまり目とじ")
	event.ObjsSetMotion(2, "手をおろす", 2)
	event.ObjsNextMotion(2, "手をおろすＬ", 4)
	helper_af3fca28(2)
	if vm.skipping() then
		return skip(42)
	end
	return part2()
end

--- Helper function.
local function helper_12fc8()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local time: f32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 27 then
			if at <= 1 then
				helper_690ecd8a(60)
			end
			if at <= 2 then
				helper_690ecd8a(60)
			end
			if at <= 3 then
				helper_690ecd8a(30)
			end
			if at <= 4 then
				helper_690ecd8a(30)
			end
			if at <= 5 then
				helper_ce122344(7440010, -1)
			end
			if at <= 6 then
				helper_690ecd8a(30)
			end
			if at <= 7 then
				helper_ce122344(7440020, -1)
			end
			if at <= 8 then
				helper_af3fca28(2)
			end
			if at <= 9 then
				helper_af3fca28(2)
			end
			if at <= 10 then
				helper_690ecd8a(90)
			end
			if at <= 11 then
				helper_ce122344(7440030, -1)
			end
			if at <= 12 then
				helper_af3fca28(2)
			end
			if at <= 13 then
				helper_690ecd8a(60)
			end
			if at <= 14 then
				helper_d4b8f712()
			end
			if at <= 15 then
				helper_ce122344(7440040, -1)
			end
			if at <= 16 then
				helper_af3fca28(3)
			end
			if at <= 17 then
				helper_690ecd8a(110)
			end
			if at <= 18 then
				helper_af3fca28(3)
			end
			if at <= 19 then
				helper_ce122344(7440050, -1)
			end
			if at <= 20 then
				helper_690ecd8a(20)
			end
			if at <= 21 then
				helper_ce122344(7440060, -1)
			end
			if at <= 22 then
				helper_690ecd8a(20)
			end
			if at <= 23 then
				helper_ce122344(7440070, -1)
			end
			if at <= 24 then
				helper_ce122344(7440080, -1)
			end
			if at <= 25 then
				helper_ce122344(7440090, 210)
			end
			if at <= 26 then
				helper_690ecd8a(30)
			end
			if vm.skip_end() then
				return skip(28)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.CharaActive(0, 36)
		event.SetTime(time)
		event.SetTimeStepEnable(1)
		event.StopBgm(0)
		event.CharaActive(0)
		event.CharaActive(32)
		event.CharaActive(33)
		event.SetStatus(1, 0, 256, 0)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.DelExtMotion(0)
		event.DeleteChara(32)
		event.DeleteChara(33)
		event.DeleteChara(34)
		event.DeleteChara(35)
		event.DeleteChara(36)
		event.LoadMes(0, -1)
	end
	event.SetFlag(744, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.StopBgm(0)
	helper_690ecd8a(4)
	if vm.skipping() then
		return skip(1)
	end
	event.LoadBgm(113)
	event.PlayBgm(0)
	event.LoadSound(7209)
	var0 = event.SndLoadSound(7209) or var0
	event.SndSePlay(var0, 0)
	event.SndSeStop(var0, 0)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.SetStatus(1, 0, 256, 1)
	time = event.GetTime() or time
	event.SetTime(12.0)
	event.SetTimeStepEnable(0)
	event.ChangeDir("event/e700/e744/")
	event.LoadMes(0, 5, "e744.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e744_mints.chr", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e744_monica.chr", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.LoadChara(5, "e744_andrea.gltf", "info", 34)
	event.CharaActive(34)
	event.EohSyncChara(2, 34)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.LoadChara(5, "e744_sun.gltf", "info", 35)
	event.CharaActive(35)
	event.EohSyncChara(3, 35)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.LoadChara(5, "kaisou_waku.gltf", "info", 36)
	event.CharaActive(0, 36)
	event.EohSyncChara(4, 36)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.ChangeDir("")
	event.EohSetPos(0, 9.54, -1000.8, 502.98)
	event.EohSetRot(0, 0.0, 3.14, 0.0)
	event.EohSetFootSoundId(0, 2)
	event.EohSetPos(1, -11.6, -1000.8, 505.27)
	event.EohSetRot(1, 0.0, 3.02, 0.0)
	event.EohSetFootSoundId(1, 2)
	event.EohSetPos(2, 483.77, 0.0, 620.09)
	event.EohSetRot(2, 0.0, 2.78, 0.0)
	event.EohSetFootSoundId(2, 1)
	event.EohSetPos(3, 452.27, 8.92, 254.12)
	event.EohSetRot(3, 0.0, -0.1, 0.0)
	event.EohSetFootSoundId(3, 1)
	event.SetStatus(1, 34, 8, 0)
	event.SetStatus(1, 35, 8, 0)
	event.InitDramaScene()
	event.ObjsSetMotion(1, "立ち", 4)
	event.ObjsSetMotion(0, "立ち", 4)
	event.ObjsSetMotion(2, "立ち", 4)
	event.ObjsSetMotion(3, "立ち", 4)
	event.ObjsResetDaPosition(3)
	event.CharaActive(34)
	event.CharaActive(35)
	event.CmrsInit()
	event.CmrsSetPos(529.2, 15.86, 621.45)
	event.CmrsSetRef(470.06, 19.21, 467.79)
	event.CharaActive(36)
	event.SetCharaType(36, 4)
	event.CmrsCharaAttach(36, 600.7, -1)
	event.SetFadeIn(30)
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "デフォルト顔")
	event.ObjsTexAnime(2, 1, "通常目パチ")
	event.ObjsTexAnime(3, 0)
	event.ObjsTexAnime(3, 1, "通常目パチ")
	helper_690ecd8a(60)
	if vm.skipping() then
		return skip(2)
	end
	event.ObjsSetMotion(3, "出る", 6)
	event.ObjsNextMotion(3, "出るL", 4)
	helper_690ecd8a(60)
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsSetMotion(3, "ひっこむ", 6)
	event.ObjsMotionDelay(3, 30)
	event.ObjsMove(3, 462.73, 8.92, 250.09, 30)
	event.ObjsNextMotion(3, "立ち")
	helper_690ecd8a(30)
	if vm.skipping() then
		return skip(4)
	end
	event.ObjsSetMotion(2, "歩き", 4)
	event.ObjsMove(2, 498.94, 0.0, 565.66, 120)
	event.ObjsMotionDelay(2, 120)
	event.ObjsNextMotion(2, "立ち")
	helper_690ecd8a(30)
	if vm.skipping() then
		return skip(5)
	end
	event.SetPakuAnim(2, "通常口パク")
	helper_ce122344(7440010, -1)
	if vm.skipping() then
		return skip(6)
	end
	helper_690ecd8a(30)
	if vm.skipping() then
		return skip(7)
	end
	helper_ce122344(7440020, -1)
	if vm.skipping() then
		return skip(8)
	end
	helper_af3fca28(2)
	if vm.skipping() then
		return skip(9)
	end
	event.ObjsSetMotion(2, "キョロキョロ", 6)
	event.ObjsNextMotion(2, "立ち", 4)
	helper_af3fca28(2)
	if vm.skipping() then
		return skip(10)
	end
	event.CmrsSetPos(466.1, 158.85, 121.59)
	event.CmrsSetRef(475.42, 37.86, 284.58)
	event.ObjsSetPos(2, 475.4, 0.0, 426.67)
	event.ObjsSetRot(2, 0.0, 2.3, 0.0)
	event.ObjsResetDaPosition(2)
	event.ObjsSetPos(3, 472.9, 0.0, 264.53)
	event.ObjsSetMotion(3, "出るL", 4)
	event.ObjsResetDaPosition(3)
	event.ObjsSetMotion(2, "キョロキョロ", 6)
	event.ObjsNextMotion(2, "立ち", 4)
	helper_690ecd8a(90)
	if vm.skipping() then
		return skip(11)
	end
	event.CmrsSetPos(511.33, 19.62, 407.04)
	event.CmrsSetRef(472.31, 26.12, 428.23)
	event.ObjsSetMotion(2, "どこだぁ？", 4)
	event.ObjsResetDaPosition(2)
	event.ObjsTexAnime(2, 1, "通常口パク")
	event.ObjsTexaDelay(2, 60)
	event.ObjsTexAnime(2, 0, "通常口パク")
	helper_ce122344(7440030, -1)
	if vm.skipping() then
		return skip(12)
	end
	helper_af3fca28(2)
	if vm.skipping() then
		return skip(13)
	end
	helper_690ecd8a(60)
	if vm.skipping() then
		return skip(14)
	end
	event.CmrsSetPos(501.79, 21.5, 191.98)
	event.CmrsSetRef(467.04, 20.16, 252.42)
	event.ObjsSetMotion(3, "出るL", 4)
	event.CmrsMove(523.78, 21.5, 187.7, 532.68, 20.16, 258.41, 120)
	helper_d4b8f712()
	if vm.skipping() then
		return skip(15)
	end
	event.CmrsSetPos(442.63, 29.0, 218.62)
	event.CmrsSetRef(500.49, 18.14, 279.12)
	event.ObjsSetPos(2, 541.31, 0.0, 320.72)
	event.ObjsSetRot(2, 0.0, -2.54, 0.0)
	event.ObjsSetMotion(2, "立ち", 4)
	event.ObjsResetDaPosition(2)
	event.ObjsSetPos(3, 471.38, 0.0, 264.17)
	event.ObjsSetRot(3, 0.0, -0.46, 0.0)
	event.ObjsSetMotion(3, "立ち", 4)
	event.ObjsResetDaPosition(3)
	event.ObjsSetMotion(2, "見つけた", 6)
	event.ObjsMove(2, 550.19, 0.0, 312.22, 20)
	event.ObjsMotionDelay(2, 20)
	event.ObjsNextMotion(2, "見つけたL", 4)
	event.ObjsSeDelay(3, 30)
	event.ObjsSePlay(3, var0, 0)
	event.ObjsMotionDelay(3, 30)
	event.ObjsSetMotion(3, "見つかった", 6)
	event.ObjsNextMotion(3, "見つかったL", 4)
	event.ObjsTexAnime(3, 0)
	event.ObjsTexAnime(3, 1, "通常目～おどろき目")
	event.ObjsTexAnime(2, 1, "通常口パク")
	event.ObjsTexaDelay(2, 50)
	event.ObjsTexAnime(2, 0, "通常口パク")
	helper_ce122344(7440040, -1)
	if vm.skipping() then
		return skip(16)
	end
	helper_af3fca28(3)
	if vm.skipping() then
		return skip(17)
	end
	event.CmrsSetPos(652.2, 112.32, 271.77)
	event.CmrsSetRef(539.58, 20.16, 257.49)
	event.ObjsTexAnime(3, 0)
	event.ObjsTexAnime(3, 1, "通常目パチ")
	event.ObjsSetPos(2, 585.25, 0.0, 305.81)
	event.ObjsSetRot(2, 0.0, -2.42, 0.0)
	event.ObjsSetMotion(2, "立ち", 4)
	event.ObjsResetDaPosition(2)
	event.ObjsSetPos(3, 501.07, 0.0, 220.88)
	event.ObjsSetRot(3, 0.0, 0.98, 0.0)
	event.ObjsSetMotion(3, "立ち", 4)
	event.ObjsResetDaPosition(3)
	event.SndSePlay(var0, 1)
	event.ObjsSetMotion(3, "こける", 6)
	event.ObjsNextMotion(3, "こけるL", 4)
	event.ObjsSetMotion(2, "走り", 4)
	event.ObjsMove(2, 524.9, 0.0, 246.8, 120)
	helper_690ecd8a(110)
	if vm.skipping() then
		return skip(18)
	end
	helper_af3fca28(3)
	if vm.skipping() then
		return skip(19)
	end
	event.CmrsSetPos(559.34, 15.83, 234.54)
	event.CmrsSetRef(513.18, 15.07, 227.78)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.ObjsSetPos(2, 501.07, 0.0, 220.88)
	event.ObjsSetRot(2, 0.0, 0.98, 0.0)
	event.ObjsSetMotion(2, "立ち", 4)
	event.ObjsResetDaPosition(2)
	event.SndSePlay(var0, 2)
	event.ObjsSetMotion(2, "ヘッドロック", 6)
	event.ObjsNextMotion(2, "ヘッドロックL", 4)
	event.ObjsSetMotion(3, "ヘッドロック", 6)
	event.ObjsNextMotion(3, "ヘッドロックL", 4)
	helper_ce122344(7440050, -1)
	if vm.skipping() then
		return skip(20)
	end
	helper_690ecd8a(20)
	if vm.skipping() then
		return skip(21)
	end
	event.ObjsTexAnime(2, 1, "通常口パク")
	event.ObjsTexaDelay(2, 60)
	event.ObjsTexAnime(2, 0, "通常口パク")
	helper_ce122344(7440060, -1)
	if vm.skipping() then
		return skip(22)
	end
	helper_690ecd8a(20)
	if vm.skipping() then
		return skip(23)
	end
	event.ObjsTexAnime(3, 0)
	event.ObjsTexAnime(3, 1, "通常目～わらい目とじ")
	helper_ce122344(7440070, -1)
	if vm.skipping() then
		return skip(24)
	end
	event.CmrsSetPos(521.72, 138.67, 207.16)
	event.CmrsSetRef(496.65, 2.26, 199.32)
	event.SetStatus(1, 34, 8, 1)
	event.SetStatus(1, 35, 8, 1)
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "デフォルト顔")
	event.ObjsTexAnime(2, 1, "わらい目")
	event.ObjsSetPos(2, 505.54, 0.0, 184.96)
	event.ObjsSetRot(2, 0.0, 1.46, 0.0)
	event.ObjsResetDaPosition(2)
	event.ObjsSetMotion(2, "ねころがり", 4)
	event.ObjsSetMotion(3, "ねころがり", 4)
	event.ObjsResetDaPosition(3)
	helper_ce122344(7440080, -1)
	if vm.skipping() then
		return skip(25)
	end
	event.CmrsMove2(1153.69, 563.36, 485.97, 496.65, 2.26, 199.32, 240, 1, 1.0)
	event.SetPakuAnim(2, "わらい口パク")
	helper_ce122344(7440090, 210)
	if vm.skipping() then
		return skip(26)
	end
	event.FadeOutBgm(30)
	event.SetFadeOut(30, 255, 255, 255)
	helper_690ecd8a(30)
	if vm.skipping() then
		return skip(27)
	end
	return part2()
end

--- Helper function.
local function helper_16480()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local time: f32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 61 then
			if at <= 1 then
				helper_690ecd8a(4)
			end
			if at <= 2 then
				helper_690ecd8a(30)
			end
			if at <= 3 then
				helper_d4b8f712()
			end
			if at <= 4 then
				helper_690ecd8a(30)
			end
			if at <= 5 then
				helper_ce122344(7480010, 180)
			end
			if at <= 6 then
				helper_ce122344(7480020, 120)
			end
			if at <= 7 then
				helper_690ecd8a(30)
			end
			if at <= 8 then
				helper_ce122344(7480030, 90)
			end
			if at <= 9 then
				helper_ce122344(7480040, 120)
			end
			if at <= 10 then
				helper_ce122344(7480050, 150)
			end
			if at <= 11 then
				helper_ce122344(7480060, 180)
			end
			if at <= 12 then
				helper_ce122344(7480070, 80)
			end
			if at <= 13 then
				helper_ce122344(7480080, 60)
			end
			if at <= 14 then
				helper_ce122344(7480090, 60)
			end
			if at <= 15 then
				helper_ce122344(7480100, 90)
			end
			if at <= 16 then
				helper_e9042a30(7480110)
			end
			if at <= 17 then
				helper_af3fca28(2)
			end
			if at <= 18 then
				helper_ce122344(7480120, -1)
			end
			if at <= 19 then
				helper_690ecd8a(20)
			end
			if at <= 20 then
				helper_e9042a30(7480125)
			end
			if at <= 21 then
				helper_ce122344(7480130, -1)
			end
			if at <= 22 then
				helper_690ecd8a(20)
			end
			if at <= 23 then
				helper_e9042a30(7480135)
			end
			if at <= 24 then
				helper_e9042a30(7480140)
			end
			if at <= 25 then
				helper_e9042a30(7480150)
			end
			if at <= 26 then
				helper_ce122344(7480160, -1)
			end
			if at <= 27 then
				helper_af3fca28(3)
			end
			if at <= 28 then
				helper_690ecd8a(10)
			end
			if at <= 29 then
				helper_e9042a30(7480170)
			end
			if at <= 30 then
				helper_af3fca28(3)
			end
			if at <= 31 then
				helper_ce122344(7480180, -1)
			end
			if at <= 32 then
				helper_690ecd8a(15)
			end
			if at <= 33 then
				helper_e9042a30(7480185)
			end
			if at <= 34 then
				helper_e9042a30(7480190)
			end
			if at <= 35 then
				helper_e9042a30(7480200)
			end
			if at <= 36 then
				helper_e9042a30(7480210)
			end
			if at <= 37 then
				helper_e9042a30(7480220)
			end
			if at <= 38 then
				helper_e9042a30(7480230)
			end
			if at <= 39 then
				helper_e9042a30(7480240)
			end
			if at <= 40 then
				helper_e9042a30(7480250)
			end
			if at <= 41 then
				helper_ce122344(7480260, -1)
			end
			if at <= 42 then
				helper_690ecd8a(15)
			end
			if at <= 43 then
				helper_ce122344(7480270, -1)
			end
			if at <= 44 then
				helper_af3fca28(3)
			end
			if at <= 45 then
				helper_690ecd8a(15)
			end
			if at <= 46 then
				helper_ce122344(7480275, 210)
			end
			if at <= 47 then
				helper_ce122344(7480280, 120)
			end
			if at <= 48 then
				helper_ce122344(7480290, -1)
			end
			if at <= 49 then
				helper_690ecd8a(30)
			end
			if at <= 50 then
				helper_e9042a30(7480295)
			end
			if at <= 51 then
				helper_ce122344(7480300, -1)
			end
			if at <= 52 then
				helper_690ecd8a(30)
			end
			if at <= 53 then
				helper_e9042a30(7480305)
			end
			if at <= 54 then
				helper_e9042a30(7480310)
			end
			if at <= 55 then
				helper_af3fca28(2)
			end
			if at <= 56 then
				helper_ce122344(7480320, -1)
			end
			if at <= 57 then
				helper_d4b8f712()
			end
			if at <= 58 then
				helper_d4b8f712()
			end
			if at <= 59 then
				helper_690ecd8a(30)
			end
			if at <= 60 then
				helper_690ecd8a(30)
			end
			if vm.skip_end() then
				return skip(62)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SetTime(time)
		event.SetTimeStepEnable(1)
		event.CharaActive(0, 37)
		event.CharaActive(0)
		event.CharaActive(32)
		event.CharaActive(33)
		event.SetStatus(1, 0, 256, 0)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.DelExtMotion(0)
		event.DeleteChara(32)
		event.DeleteChara(33)
		event.DeleteChara(34)
		event.DeleteChara(35)
		event.DeleteChara(36)
		event.DeleteChara(37)
		event.LoadMes(0, -1)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFlag(748, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.StopBgm(0)
	helper_690ecd8a(4)
	if vm.skipping() then
		return skip(2)
	end
	event.LoadBgm(113)
	event.PlayBgm(0)
	event.LoadSound(7211)
	var0 = event.SndLoadSound(7211) or var0
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.SetStatus(1, 0, 256, 1)
	time = event.GetTime() or time
	event.SetTime(12.0)
	event.SetTimeStepEnable(0)
	event.ChangeDir("event/e700/e748/")
	event.LoadMes(0, 5, "e748.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e748_mints.chr", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e748_monica.chr", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.LoadChara(5, "e748_andrea.gltf", "info", 34)
	event.CharaActive(34)
	event.EohSyncChara(2, 34)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.LoadChara(5, "e748_sun.gltf", "info", 35)
	event.CharaActive(35)
	event.EohSyncChara(3, 35)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.LoadChara(5, "e748_heishi.gltf", "info", 36)
	event.CharaActive(36)
	event.EohSyncChara(4, 36)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.LoadChara(5, "kaisou_waku.gltf", "info", 37)
	event.CharaActive(0, 37)
	event.EohSyncChara(5, 37)
	event.ObjsInit(5)
	event.ObjsSyncObj(5, 5)
	event.ChangeDir("")
	event.EohSetPos(0, 9.54, -1000.8, 502.98)
	event.EohSetRot(0, 0.0, 3.14, 0.0)
	event.EohSetFootSoundId(0, 2)
	event.EohSetPos(1, -11.6, -1000.8, 505.27)
	event.EohSetRot(1, 0.0, 3.02, 0.0)
	event.EohSetFootSoundId(1, 2)
	event.EohSetPos(2, -65.28, 3.0, 570.89)
	event.EohSetRot(2, 0.0, -1.58, 0.0)
	event.EohSetFootSoundId(2, 2)
	event.EohSetPos(3, -100.12, 6.02, 97.85)
	event.EohSetRot(3, 0.0, 0.86, 0.0)
	event.EohSetFootSoundId(3, 2)
	event.EohSetPos(4, -114.49, 6.02, 85.4)
	event.EohSetRot(4, 0.0, 0.86, 0.0)
	event.InitDramaScene()
	event.ObjsSetMotion(1, "立ち", 4)
	event.ObjsSetMotion(0, "立ち", 4)
	event.ObjsSetMotion(2, "立ち", 4)
	event.CharaActive(34)
	event.CharaActive(35)
	event.CmrsInit()
	event.CmrsSetPos(-36.83, 30.31, 792.49)
	event.CmrsSetRef(-41.22, 273.64, 621.04)
	event.CharaActive(37)
	event.SetCharaType(37, 4)
	event.CmrsCharaAttach(37, 600.7, -1)
	event.SetFadeIn(30)
	event.ObjsTexAnime(4, 0)
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "デフォルト顔")
	event.ObjsTexAnime(2, 1, "通常目パチ")
	event.ObjsTexAnime(3, 0)
	event.ObjsTexAnime(3, 1, "左向き目パチ")
	helper_690ecd8a(30)
	if vm.skipping() then
		return skip(3)
	end
	event.CmrsMove2(-36.83, 28.06, 792.49, -41.22, 32.05, 621.04, 120, 1, 1.0)
	helper_d4b8f712()
	if vm.skipping() then
		return skip(4)
	end
	helper_690ecd8a(30)
	if vm.skipping() then
		return skip(5)
	end
	event.ObjsSetMotion(3, "連行中", 4)
	event.ObjsResetDaPosition(3)
	event.ObjsSetMotion(4, "連行中", 4)
	event.ObjsMove(3, -3.01, 3.0, 243.61, 300)
	event.ObjsRotation(3, 0.0, 0.5, 0.0, 300)
	event.ObjsMove(4, -12.42, 3.0, 226.06, 300)
	event.ObjsRotation(4, 0.0, 0.5, 0.0, 300)
	event.ObjsMove(3, -9.47, 3.0, 310.45, 330)
	event.ObjsRotation(3, 0.0, -0.1, 0.0, 12)
	event.ObjsMove(4, -9.08, 3.0, 290.82, 330)
	event.ObjsRotation(4, 0.0, -0.1, 0.0, 12)
	event.ObjsSePlay(4, var0, 0)
	event.ObjsSeDelay(4, 20)
	event.ObjsSePlay(4, var0, 1)
	event.ObjsSeDelay(4, 20)
	event.ObjsSePlay(4, var0, 0)
	event.ObjsSeDelay(4, 20)
	event.ObjsSePlay(4, var0, 1)
	event.ObjsSeDelay(4, 20)
	event.ObjsSePlay(4, var0, 0)
	event.ObjsSeDelay(4, 20)
	event.ObjsSePlay(4, var0, 1)
	event.ObjsSeDelay(4, 20)
	event.ObjsSePlay(4, var0, 0)
	event.ObjsSeDelay(4, 20)
	event.ObjsSePlay(4, var0, 1)
	event.ObjsSeDelay(4, 20)
	event.ObjsSePlay(4, var0, 0)
	event.ObjsSeDelay(4, 20)
	event.ObjsSePlay(4, var0, 1)
	event.ObjsSeDelay(4, 20)
	event.ObjsSePlay(4, var0, 0)
	event.ObjsSeDelay(4, 20)
	event.ObjsSePlay(4, var0, 1)
	event.ObjsSeDelay(4, 20)
	event.ObjsSePlay(4, var0, 0)
	event.ObjsSeDelay(4, 20)
	event.ObjsSePlay(4, var0, 1)
	event.ObjsSeDelay(4, 20)
	event.ObjsSePlay(4, var0, 0)
	event.ObjsSeDelay(4, 20)
	event.ObjsSePlay(4, var0, 1)
	event.ObjsSeDelay(4, 20)
	event.ObjsSePlay(4, var0, 0)
	event.ObjsSeDelay(4, 20)
	event.ObjsSePlay(4, var0, 1)
	event.ObjsSeDelay(4, 20)
	event.ObjsSePlay(4, var0, 0)
	event.ObjsSeDelay(4, 20)
	event.ObjsSePlay(4, var0, 1)
	event.ObjsSeDelay(4, 20)
	event.ObjsSePlay(4, var0, 0)
	event.ObjsSeDelay(4, 20)
	event.ObjsSePlay(4, var0, 1)
	event.ObjsTexAnime(4, 1, "口パク")
	helper_ce122344(7480010, 180)
	if vm.skipping() then
		return skip(6)
	end
	helper_ce122344(7480020, 120)
	if vm.skipping() then
		return skip(7)
	end
	event.ObjsSetMotion(2, "歩き", 4)
	event.ObjsRotation(2, 0.0, 2.78, 0.0, 12)
	event.ObjsMotionDelay(2, 30)
	event.ObjsNextMotion(2, "立ち")
	helper_690ecd8a(30)
	if vm.skipping() then
		return skip(8)
	end
	event.SetPakuAnim(2, "通常口パク")
	helper_ce122344(7480030, 90)
	if vm.skipping() then
		return skip(9)
	end
	event.CmrsSetPos(24.11, 19.86, 616.87)
	event.CmrsSetRef(-14.37, 18.99, 524.13)
	event.ObjsSetPos(2, -19.05, 3.0, 550.34)
	event.ObjsSetRot(2, 0.0, 2.66, 0.0)
	event.ObjsResetDaPosition(2)
	event.ObjsMove(3, -8.65, 3.0, 450.26, 300)
	event.ObjsMove(4, -7.2, 3.0, 430.56, 300)
	event.ObjsSePlay(4, var0, 0)
	event.ObjsSeDelay(4, 20)
	event.ObjsSePlay(4, var0, 1)
	event.ObjsSeDelay(4, 20)
	event.ObjsSePlay(4, var0, 0)
	event.ObjsSeDelay(4, 20)
	event.ObjsSePlay(4, var0, 1)
	event.ObjsSeDelay(4, 20)
	event.ObjsSePlay(4, var0, 0)
	event.ObjsSeDelay(4, 20)
	event.ObjsSePlay(4, var0, 1)
	event.ObjsSeDelay(4, 20)
	event.ObjsSePlay(4, var0, 0)
	event.ObjsSeDelay(4, 20)
	event.ObjsSePlay(4, var0, 1)
	event.ObjsSeDelay(4, 20)
	event.ObjsSePlay(4, var0, 0)
	event.ObjsSeDelay(4, 20)
	event.ObjsSePlay(4, var0, 1)
	event.ObjsSeDelay(4, 20)
	event.ObjsSePlay(4, var0, 0)
	event.ObjsSeDelay(4, 20)
	event.ObjsSePlay(4, var0, 1)
	event.ObjsSeDelay(4, 20)
	event.ObjsSePlay(4, var0, 0)
	event.ObjsSeDelay(4, 20)
	event.ObjsSePlay(4, var0, 1)
	event.ObjsSeDelay(4, 20)
	event.ObjsSePlay(4, var0, 0)
	event.ObjsSeDelay(4, 20)
	event.ObjsSePlay(4, var0, 1)
	event.ObjsSeDelay(4, 20)
	event.ObjsSePlay(4, var0, 0)
	event.ObjsSeDelay(4, 20)
	event.ObjsSePlay(4, var0, 1)
	event.ObjsSeDelay(4, 20)
	event.ObjsSePlay(4, var0, 0)
	event.ObjsSeDelay(4, 20)
	event.ObjsSePlay(4, var0, 1)
	event.ObjsSeDelay(4, 20)
	event.ObjsSePlay(4, var0, 0)
	event.ObjsSeDelay(4, 20)
	event.ObjsSePlay(4, var0, 1)
	event.ObjsSeDelay(4, 20)
	event.ObjsSePlay(4, var0, 0)
	event.ObjsSeDelay(4, 20)
	event.ObjsSePlay(4, var0, 1)
	event.ObjsSeDelay(4, 20)
	event.ObjsSePlay(4, var0, 0)
	event.ObjsSeDelay(4, 20)
	event.ObjsSePlay(4, var0, 1)
	event.ObjsSeDelay(4, 20)
	event.ObjsSePlay(4, var0, 0)
	event.ObjsSeDelay(4, 20)
	event.ObjsSePlay(4, var0, 1)
	event.ObjsTexAnime(4, 1, "口パク")
	helper_ce122344(7480040, 120)
	if vm.skipping() then
		return skip(10)
	end
	event.ObjsTexAnime(4, 1, "口パク")
	helper_ce122344(7480050, 150)
	if vm.skipping() then
		return skip(11)
	end
	helper_ce122344(7480060, 180)
	if vm.skipping() then
		return skip(12)
	end
	event.CmrsSetPos(65.31, 13.43, 458.75)
	event.CmrsSetRef(-32.25, 19.69, 525.13)
	event.SetPakuAnim(2, "通常口パク")
	helper_ce122344(7480070, 80)
	if vm.skipping() then
		return skip(13)
	end
	event.ObjsMove(3, -6.26, 3.0, 505.48, 150)
	event.ObjsMove(4, -4.33, 3.0, 486.12, 150)
	event.ObjsSeDelay(4, 20)
	event.ObjsSePlay(4, var0, 0)
	event.ObjsSeDelay(4, 20)
	event.ObjsSePlay(4, var0, 1)
	event.ObjsSeDelay(4, 20)
	event.ObjsSePlay(4, var0, 0)
	event.ObjsSeDelay(4, 20)
	event.ObjsSePlay(4, var0, 1)
	event.ObjsSeDelay(4, 20)
	event.ObjsSePlay(4, var0, 0)
	event.ObjsSeDelay(4, 20)
	event.ObjsSePlay(4, var0, 1)
	event.ObjsSeDelay(4, 20)
	event.ObjsSePlay(4, var0, 0)
	event.ObjsSeDelay(4, 20)
	event.ObjsSePlay(4, var0, 1)
	event.ObjsTexAnime(4, 1, "口パク")
	helper_ce122344(7480080, 60)
	if vm.skipping() then
		return skip(14)
	end
	event.SetPakuAnim(2, "通常口パク")
	helper_ce122344(7480090, 60)
	if vm.skipping() then
		return skip(15)
	end
	event.ObjsSeDelay(3, 30)
	event.ObjsSePlay(3, var0, 2)
	event.ObjsMotionDelay(3, 30)
	event.ObjsSetMotion(3, "連行解除", 6)
	event.ObjsNextMotion(3, "立ち")
	event.ObjsMotionDelay(4, 30)
	event.ObjsSetMotion(4, "連行解除", 6)
	event.ObjsNextMotion(4, "立ち")
	event.ObjsTexAnime(4, 1, "口パク")
	helper_ce122344(7480100, 90)
	if vm.skipping() then
		return skip(16)
	end
	event.CmrsSetPos(50.08, 20.77, 547.75)
	event.CmrsSetRef(-22.42, 18.57, 549.89)
	event.ObjsTexAnime(3, 0)
	event.ObjsTexAnime(3, 1, "上目パチ")
	event.ObjsSetPos(3, -8.76, 3.0, 533.31)
	event.ObjsSetRot(3, 0.0, -0.1, 0.0)
	event.ObjsSetMotion(3, "上目立ち", 4)
	event.ObjsSetPos(2, -10.6, 3.0, 558.53)
	event.ObjsSetRot(2, 0.0, -2.9, 0.0)
	event.ObjsResetDaPosition(2)
	event.SndSePlay(var0, 3)
	event.ObjsSetMotion(2, "しゃがむ", 6)
	event.ObjsNextMotion(2, "しゃがむＬ", 4)
	event.SetPakuAnim(2, "通常口パク")
	helper_e9042a30(7480110)
	if vm.skipping() then
		return skip(17)
	end
	helper_af3fca28(2)
	if vm.skipping() then
		return skip(18)
	end
	event.ObjsSetMotion(3, "上目立ち会話", 4)
	event.ObjsMotionDelay(3, 180)
	event.ObjsNextMotion(3, "上目立ち", 4)
	helper_ce122344(7480120, -1)
	if vm.skipping() then
		return skip(19)
	end
	helper_690ecd8a(20)
	if vm.skipping() then
		return skip(20)
	end
	helper_e9042a30(7480125)
	if vm.skipping() then
		return skip(21)
	end
	event.ObjsSetMotion(3, "上目立ち")
	event.ObjsSetMotion(2, "しゃがみ会話", 6)
	event.ObjsNextMotion(2, "しゃがむＬ", 4)
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "デフォルト顔")
	event.ObjsTexAnime(2, 1, "目あき～目とじ")
	event.SetPakuAnim(2, "通常口パク")
	helper_ce122344(7480130, -1)
	if vm.skipping() then
		return skip(22)
	end
	helper_690ecd8a(20)
	if vm.skipping() then
		return skip(23)
	end
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "デフォルト顔")
	event.ObjsTexAnime(2, 1, "目とじ～目あき")
	event.SetPakuAnim(2, "通常口パク")
	helper_e9042a30(7480135)
	if vm.skipping() then
		return skip(24)
	end
	event.ObjsSetMotion(3, "えっ！", 6)
	event.ObjsNextMotion(3, "口だけ会話")
	event.ObjsMotionDelay(3, 60)
	event.ObjsNextMotion(3, "立ち")
	event.ObjsTexAnime(3, 0)
	event.ObjsTexAnime(3, 1, "上目～通常目")
	helper_e9042a30(7480140)
	if vm.skipping() then
		return skip(25)
	end
	event.ObjsSetMotion(3, "立ち")
	event.ObjsSetMotion(2, "しゃがみ会話", 6)
	event.ObjsNextMotion(2, "しゃがむＬ", 4)
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "デフォルト顔")
	event.ObjsTexAnime(2, 1, "通常目パチ")
	event.SetPakuAnim(2, "通常口パク")
	helper_e9042a30(7480150)
	if vm.skipping() then
		return skip(26)
	end
	event.ObjsSetMotion(3, "ぶるぶる", 6)
	event.ObjsNextMotion(3, "ぶるぶるＬ", 4)
	event.ObjsMotionDelay(3, 60)
	event.ObjsNextMotion(3, "ぶるぶる戻り", 6)
	event.ObjsNextMotion(3, "立ち", 4)
	event.ObjsTexAnime(3, 0)
	event.ObjsTexAnime(3, 1, "目あき～目とじ")
	helper_ce122344(7480160, -1)
	if vm.skipping() then
		return skip(27)
	end
	event.ObjsTexAnime(3, 0)
	event.ObjsTexAnime(3, 1, "通常目パチ")
	helper_af3fca28(3)
	if vm.skipping() then
		return skip(28)
	end
	helper_690ecd8a(10)
	if vm.skipping() then
		return skip(29)
	end
	event.ObjsSetMotion(2, "しゃがみ会話", 6)
	event.ObjsNextMotion(2, "しゃがむＬ", 4)
	event.SetPakuAnim(2, "通常口パク")
	helper_e9042a30(7480170)
	if vm.skipping() then
		return skip(30)
	end
	helper_af3fca28(3)
	if vm.skipping() then
		return skip(31)
	end
	event.ObjsSetMotion(3, "目をそらす", 6)
	event.ObjsMotionDelay(3, 30)
	event.ObjsNextMotion(3, "目をそらす会話", 4)
	event.ObjsMotionDelay(3, 120)
	event.ObjsNextMotion(3, "目をそらすＬ", 4)
	event.ObjsTexAnime(3, 0)
	event.ObjsTexAnime(3, 1, "前向き～左向き")
	helper_ce122344(7480180, -1)
	if vm.skipping() then
		return skip(32)
	end
	helper_690ecd8a(15)
	if vm.skipping() then
		return skip(33)
	end
	helper_e9042a30(7480185)
	if vm.skipping() then
		return skip(34)
	end
	event.ObjsSetMotion(3, "目をそらすＬ")
	event.SetPakuAnim(2, "通常口パク")
	helper_e9042a30(7480190)
	if vm.skipping() then
		return skip(35)
	end
	event.ObjsSetMotion(2, "しゃがみ会話", 6)
	event.ObjsNextMotion(2, "しゃがむＬ", 4)
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "デフォルト顔")
	event.ObjsTexAnime(2, 1, "目あき～目とじ")
	event.SetPakuAnim(2, "通常口パク")
	helper_e9042a30(7480200)
	if vm.skipping() then
		return skip(36)
	end
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "デフォルト顔")
	event.ObjsTexAnime(2, 1, "通常目パチ")
	event.ObjsSetMotion(3, "目をそらす戻り", 6)
	event.ObjsNextMotion(3, "立ち", 4)
	event.ObjsTexAnime(3, 0)
	event.ObjsTexAnime(3, 1, "左向き～前向き")
	helper_e9042a30(7480210)
	if vm.skipping() then
		return skip(37)
	end
	event.CmrsSetPos(35.94, 7.97, 601.38)
	event.CmrsSetRef(-12.68, 20.72, 534.58)
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "デフォルト顔")
	event.ObjsTexAnime(2, 1, "通常目パチ")
	event.ObjsTexAnime(3, 0)
	event.ObjsTexAnime(3, 1, "通常目パチ")
	event.ObjsSetMotion(4, "会話", 6)
	event.ObjsNextMotion(4, "立ち", 4)
	event.SetPakuAnim(4, "口パク")
	helper_e9042a30(7480220)
	if vm.skipping() then
		return skip(38)
	end
	event.ObjsSetMotion(3, "嫌だ", 6)
	event.ObjsNextMotion(3, "嫌だ会話", 4)
	event.ObjsMotionDelay(3, 120)
	event.ObjsNextMotion(3, "嫌だＬ", 4)
	event.ObjsTexAnime(3, 0)
	event.ObjsTexAnime(3, 1, "通常目～おこり目")
	helper_e9042a30(7480230)
	if vm.skipping() then
		return skip(39)
	end
	event.ObjsSetMotion(3, "嫌だＬ")
	event.SetPakuAnim(2, "通常口パク")
	helper_e9042a30(7480240)
	if vm.skipping() then
		return skip(40)
	end
	event.ObjsSetMotion(3, "でも", 6)
	event.ObjsNextMotion(3, "でもＬ", 4)
	helper_e9042a30(7480250)
	if vm.skipping() then
		return skip(41)
	end
	event.CmrsSetPos(27.14, 19.14, 544.75)
	event.CmrsSetRef(-10.12, 20.72, 543.67)
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "デフォルト顔")
	event.ObjsTexAnime(2, 1, "おこり目パチ")
	event.ObjsSetPos(2, -9.41, 3.0, 551.78)
	event.ObjsResetDaPosition(2)
	event.ObjsSetMotion(2, "せまる", 6)
	event.ObjsNextMotion(2, "せまるＬ", 4)
	event.ObjsMotionDelay(3, 30)
	event.ObjsSetMotion(3, "わかった", 6)
	event.ObjsNextMotion(3, "わかったＬ", 4)
	event.ObjsMotionDelay(3, 60)
	event.ObjsNextMotion(3, "わかった会話", 4)
	event.ObjsMotionDelay(3, 90)
	event.ObjsNextMotion(3, "わかったＬ", 4)
	event.SetPakuAnim(2, "通常口パク")
	helper_ce122344(7480260, -1)
	if vm.skipping() then
		return skip(42)
	end
	helper_690ecd8a(15)
	if vm.skipping() then
		return skip(43)
	end
	event.ObjsTexAnime(3, 0)
	event.ObjsTexAnime(3, 1, "おこり目～通常目")
	helper_ce122344(7480270, -1)
	if vm.skipping() then
		return skip(44)
	end
	helper_af3fca28(3)
	if vm.skipping() then
		return skip(45)
	end
	helper_690ecd8a(15)
	if vm.skipping() then
		return skip(46)
	end
	event.CmrsSetPos(-54.72, 17.36, 484.64)
	event.CmrsSetRef(10.21, 20.7, 547.81)
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "デフォルト顔")
	event.ObjsTexAnime(2, 1, "通常目パチ")
	event.ObjsTexAnime(3, 0)
	event.ObjsTexAnime(3, 1, "上目パチ")
	event.ObjsSetPos(4, -114.49, 6.02, 85.4)
	event.ObjsSeDelay(3, 120)
	event.ObjsSePlay(3, var0, 4)
	event.ObjsMotionDelay(3, 120)
	event.ObjsSetMotion(3, "回転１", 6)
	event.ObjsRotDelay(3, 130)
	event.ObjsRotation(3, 0.0, -3.06, 0.0, 15)
	event.ObjsNextMotion(3, "手を頭に歩き")
	event.ObjsPosDelay(3, 150)
	event.ObjsMove(3, -4.25, 3.0, 515.84, 180)
	event.ObjsSeDelay(3, 210)
	event.ObjsSePlay(3, var0, 5)
	event.ObjsMotionDelay(3, 150)
	event.ObjsNextMotion(3, "回転２", 6)
	event.ObjsRotDelay(3, 180)
	event.ObjsRotation(3, 0.0, -0.1, 0.0, 30)
	event.ObjsMotionDelay(3, 60)
	event.ObjsNextMotion(3, "立ち", 4)
	helper_ce122344(7480275, 210)
	if vm.skipping() then
		return skip(47)
	end
	event.SetPakuAnim(2, "通常口パク")
	helper_ce122344(7480280, 120)
	if vm.skipping() then
		return skip(48)
	end
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "デフォルト顔")
	event.ObjsTexAnime(2, 1, "通常目パチ")
	event.ObjsTexAnime(2, 1, "口とじ")
	helper_ce122344(7480290, -1)
	if vm.skipping() then
		return skip(49)
	end
	helper_690ecd8a(30)
	if vm.skipping() then
		return skip(50)
	end
	event.ObjsTexAnime(3, 0)
	event.ObjsTexAnime(3, 1, "通常目パチ")
	helper_e9042a30(7480295)
	if vm.skipping() then
		return skip(51)
	end
	event.ObjsSetMotion(2, "ため息", 6)
	event.ObjsNextMotion(2, "ため息Ｌ", 4)
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "デフォルト顔")
	event.ObjsTexAnime(2, 1, "目あき～目とじ")
	event.ObjsTexAnime(2, 1, "ため息")
	helper_ce122344(7480300, -1)
	if vm.skipping() then
		return skip(52)
	end
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "デフォルト顔")
	event.ObjsTexAnime(2, 1, "目とじ～目あき")
	event.SetPakuAnim(2, "通常口パク")
	helper_690ecd8a(30)
	if vm.skipping() then
		return skip(53)
	end
	event.SndSePlay(var0, 6)
	event.ObjsSetMotion(2, "立ち上がる", 6)
	event.ObjsNextMotion(2, "立ち", 4)
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "デフォルト顔")
	event.ObjsTexAnime(2, 1, "通常目パチ")
	event.SetPakuAnim(2, "通常口パク")
	helper_e9042a30(7480305)
	if vm.skipping() then
		return skip(54)
	end
	helper_e9042a30(7480310)
	if vm.skipping() then
		return skip(55)
	end
	helper_af3fca28(2)
	if vm.skipping() then
		return skip(56)
	end
	event.CmrsSetPos(-65.08, 22.44, 574.54)
	event.CmrsSetRef(-13.97, 25.0, 522.35)
	event.ObjsSetPos(3, -25.95, 3.0, 505.44)
	event.ObjsSetRot(3, 0.0, 0.47, 0.0)
	event.ObjsResetDaPosition(3)
	event.ObjsSetPos(2, -6.29, 3.0, 528.64)
	event.ObjsSetRot(2, 0.0, -2.42, 0.0)
	event.ObjsResetDaPosition(2)
	event.ObjsSetMotion(2, "眩しいＬ", 4)
	event.ObjsMotionDelay(3, 60)
	event.ObjsSetMotion(3, "見上げる", 6)
	event.ObjsNextMotion(3, "見上げるＬ", 4)
	event.CmrsPrdelay(120)
	event.CmrsMove2(-65.08, 22.44, 574.54, -24.39, 113.93, 513.67, 90, 1, 1.0)
	event.SetPakuAnim(2, "通常口パク")
	helper_ce122344(7480320, -1)
	if vm.skipping() then
		return skip(57)
	end
	helper_d4b8f712()
	if vm.skipping() then
		return skip(58)
	end
	event.CmrsSetPos(-11.49, 83.41, 532.92)
	event.CmrsSetRef(-28.34, 16.36, 500.29)
	event.ObjsSetMotion(3, "眩しい", 4)
	event.CmrsMove(-15.48, 54.13, 525.19, -27.67, 20.34, 500.29, 90)
	helper_d4b8f712()
	if vm.skipping() then
		return skip(59)
	end
	helper_690ecd8a(30)
	if vm.skipping() then
		return skip(60)
	end
	event.FadeOutBgm(30)
	event.SetFadeOut(30)
	helper_690ecd8a(30)
	if vm.skipping() then
		return skip(61)
	end
	return part2()
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 150.
script[150] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			helper_ee8(32)
		end
	end
	event.Initialize()
	if vm.wait() then
		return skip(1)
	end
	event.CmrsSetPos(31.07, 49.02, 53.789978)
	event.CmrsSetRef(-33.5, 41.8, 200.70001)
	if vm.wait() then
		return skip(2)
	end
	helper_ee8(32)
	if vm.skipping() then
		return skip(3)
	end
	event.EsmClear()
	event.Finish()
end

--- Program 500.
script[500] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_125d0()
	if vm.skipping() then
		return skip(1)
	end
	event.MapJump(-1, "d06b03", 510)
end

--- Program 510.
script[510] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_efa0()
	if vm.skipping() then
		return skip(1)
	end
	event.BgmLoadCancel()
	event.SoundLoadCancel()
	if vm.wait() then
		return skip(2)
	end
	event.LoadDungeonMapFile("d06b01")
	event.LoadScript("d06b01/d06b01.stb", 512)
end

--- Program 550.
script[550] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_12fc8()
	if vm.skipping() then
		return skip(1)
	end
	event.MapJump(-1, "g05", 550)
	if vm.wait() then
		return skip(2)
	end
end

--- Program 560.
script[560] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_16480()
	if vm.skipping() then
		return skip(1)
	end
	event.MapJump(-1, "g05", 560)
	if vm.wait() then
		return skip(2)
	end
end

--- Program 570.
script[570] = function()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_16480()
			if not vm.skipping() then
				return part2()
			end
		end
	end
	function part2()
		event.MapJump(-1, "g05", 560)
		if vm.wait() then
			return skip(3)
		end
	end
	helper_12fc8()
	if vm.skipping() then
		return skip(1)
	end
	helper_16480()
	if vm.skipping() then
		return skip(2)
	end
	return part2()
end

--- Program 17440.
script[17440] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_12fc8()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 17480.
script[17480] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_16480()
	if vm.skipping() then
		return skip(1)
	end
	event.MapJump(-1, "g05", 560)
	if vm.wait() then
		return skip(2)
	end
end

return script
