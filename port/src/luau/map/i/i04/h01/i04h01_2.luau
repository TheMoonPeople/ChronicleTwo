--!strict
-- map/i/i04/h01/i04h01_2.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_136a94b8 = require("@lib/event/helper_136a94b8")
local helper_184013af = require("@lib/event/helper_184013af")
local helper_1f9a3afd = require("@lib/event/helper_1f9a3afd")
local helper_27ff0b8f = require("@lib/event/helper_27ff0b8f")
local helper_364319f4 = require("@lib/event/helper_364319f4")
local helper_57ae27b6 = require("@lib/event/helper_57ae27b6")
local helper_696c0345 = require("@lib/event/helper_696c0345")
local helper_8668c8fd = require("@lib/event/helper_8668c8fd")
local helper_8f31f334 = require("@lib/event/helper_8f31f334")
local helper_998ed0ac = require("@lib/event/helper_998ed0ac")
local helper_aafd6a80 = require("@lib/event/helper_aafd6a80")
local helper_acccbf55 = require("@lib/event/helper_acccbf55")
local helper_c049c42a = require("@lib/event/helper_c049c42a")
local helper_dd7a6f53 = require("@lib/event/helper_dd7a6f53")
local helper_f37e8af2 = require("@lib/event/helper_f37e8af2")
local helper_fe376309 = require("@lib/event/helper_fe376309")

--- Helper function.
local function helper_3eb18(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.EohSyncObj(0, "p03_i04h01")
	event.EohSetShow(0, arg0)
	event.FuncPointShow("", "func", arg0)
end

--- Helper function.
local function helper_3ec30()
	local flag: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	flag = event.GetFlag(38) or flag
	helper_3eb18(if flag == 0 then 1 else 0)
	var1 = event.GetQuestEtc(0, 18) or var1
	if var1 == 1 then
		var2 = event.GetCnt(11) or var2
		if var2 == 1 then
			helper_364319f4()
		end
	end
end

--- Helper function.
local function helper_3d30c()
	local var0: s32 = 0
	local time: f32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 15 then
			if at <= 1 then
				helper_184013af()
			end
			if at <= 2 then
				helper_aafd6a80(30)
			end
			if at <= 3 then
				helper_1f9a3afd(7360280, -1)
			end
			if at <= 4 then
				helper_aafd6a80(15)
			end
			if at <= 5 then
				helper_1f9a3afd(7360290, -1)
			end
			if at <= 6 then
				helper_aafd6a80(15)
			end
			if at <= 7 then
				helper_1f9a3afd(7360300, -1)
			end
			if at <= 8 then
				helper_aafd6a80(15)
			end
			if at <= 9 then
				helper_1f9a3afd(7360310, -1)
			end
			if at <= 10 then
				helper_1f9a3afd(7360320, -1)
			end
			if at <= 11 then
				helper_aafd6a80(15)
			end
			if at <= 12 then
				helper_8f31f334(0)
			end
			if at <= 13 then
				helper_aafd6a80(120)
			end
			if at <= 14 then
				helper_aafd6a80(120)
			end
			if vm.skip_end() then
				return skip(16)
			end
			return part2()
		end
		if at <= 16 then
			helper_aafd6a80(60)
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SetFadeOut(60)
		helper_aafd6a80(60)
		if vm.skipping() then
			return skip(17)
		end
		event.SetTime(time)
		event.SoundAllStop()
		event.DeleteChara(8)
		event.EohSetShow(1, 1)
		event.EohSetShow(6, 1)
		event.LoadMes(0, -1)
		event.CharaActive(0)
		if vm.wait() then
			return skip(18)
		end
	end
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.SoundAllStop()
	event.LoadSound(0)
	var0 = event.SndLoadSound(6244) or var0
	event.AssignStack(5)
	event.ClearStack(5)
	event.CharaActive(0, 0)
	event.ChangeDir("event/e700/e736/")
	event.LoadMes(0, 5, "e736_1.txt")
	event.LoadChara(5, "e736_mints2.gltf", "info", 8)
	event.CharaActive(8)
	event.EohSyncChara(0, 8)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ChangeDir("")
	event.EohSyncObj(1, "p01_i04h01", "i04h01_06-m0")
	event.EohSyncObj(6, "p01_i04h01", "i04h01_07-m0")
	event.ObjsSetPos(0, 70.93, 0.0, -135.77)
	event.ObjsSetRot(0, 0.0, 3.12, 0.0)
	event.ObjsSetMotion(0, "手紙書く", 4)
	time = event.GetTime() or time
	event.SetTime(24.0)
	event.InitDramaScene()
	event.CmrsSetRef(68.06, 28.91, 95.45)
	event.SetFadeIn(30)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "下目パチ")
	event.EohSetShow(1, 1)
	event.EohSetShow(6, 1)
	event.CmrsInitPas()
	event.CmrsSetPasFrm(200)
	event.CmrsAddPas(-58.83, 74.1, -57.22, 65.76, 32.77, -130.49)
	event.CmrsAddPas(-17.1, 74.1, -81.76, 65.76, 32.77, -130.49)
	event.CmrsStartPas()
	helper_1f9a3afd(7360270, -1)
	if vm.skipping() then
		return skip(1)
	end
	helper_184013af()
	if vm.skipping() then
		return skip(2)
	end
	helper_aafd6a80(30)
	if vm.skipping() then
		return skip(3)
	end
	event.CmrsSetPos(96.22, 35.83, -174.85)
	event.CmrsSetRef(67.95, 23.82, -123.84)
	event.SndSePlay(var0, 0)
	event.ObjsSetMotion(0, "手紙書く", 4)
	event.EohSetShow(1, 0)
	event.EohSetShow(6, 0)
	helper_1f9a3afd(7360280, -1)
	if vm.skipping() then
		return skip(4)
	end
	helper_aafd6a80(15)
	if vm.skipping() then
		return skip(5)
	end
	helper_1f9a3afd(7360290, -1)
	if vm.skipping() then
		return skip(6)
	end
	helper_aafd6a80(15)
	if vm.skipping() then
		return skip(7)
	end
	event.EohSetShow(1, 1)
	event.EohSetShow(6, 1)
	event.CmrsSetPos(-58.83, 74.1, -57.22)
	event.CmrsSetRef(65.76, 32.77, -130.49)
	helper_1f9a3afd(7360300, -1)
	if vm.skipping() then
		return skip(8)
	end
	helper_aafd6a80(15)
	if vm.skipping() then
		return skip(9)
	end
	event.EohSetShow(1, 0)
	event.EohSetShow(6, 0)
	event.CmrsSetPos(70.85, 28.26, -161.24)
	event.CmrsSetRef(70.53, 23.82, -123.26)
	event.ObjsSetMotion(0, "手紙書く", 4)
	event.SndSePlay(var0, 1)
	helper_1f9a3afd(7360310, -1)
	if vm.skipping() then
		return skip(10)
	end
	event.ObjsMotionWait(0)
	event.ObjsSetMotion(0, "ひとやすみ", 2)
	event.ObjsNextMotion(0, "ひとやすみL", 4)
	event.ObjsTexaDelay(0, 200)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "前向き～上向き")
	event.ObjsSeDelay(0, 165)
	event.ObjsSePlay(0, var0, 2)
	event.ObjsSeDelay(0, 210)
	event.ObjsSePlay(0, var0, 3)
	helper_1f9a3afd(7360320, -1)
	if vm.skipping() then
		return skip(11)
	end
	helper_aafd6a80(15)
	if vm.skipping() then
		return skip(12)
	end
	helper_8f31f334(0)
	if vm.skipping() then
		return skip(13)
	end
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "上向き～目とじ")
	event.ObjsTexAnime(0, 1, "口ためいき")
	event.ObjsSetMotion(0, "ため息", 6)
	event.ObjsNextMotion(0, "ひとやすみL", 4)
	helper_aafd6a80(120)
	if vm.skipping() then
		return skip(14)
	end
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "上向き～目とじ")
	event.ObjsTexAnime(0, 1, "口あけ～ほほえみ")
	helper_aafd6a80(120)
	if vm.skipping() then
		return skip(15)
	end
	return part2()
end

--- Helper function.
local function helper_39a5c(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_57ae27b6(1)
		end
		if at <= 2 then
			helper_27ff0b8f(0, -1, 5, 0, 0)
			helper_f37e8af2(0, arg1)
		end
		helper_dd7a6f53(0)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.StreamOpen3(1, arg0)
	helper_57ae27b6(1)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, arg0)
	helper_27ff0b8f(0, -1, 5, 0, 0)
	event.StreamPlay(1)
	helper_f37e8af2(0, arg1)
	if vm.skipping() then
		return skip(3)
	end
	helper_dd7a6f53(0)
	event.StreamClose(1)
end

--- Helper function.
local function helper_39c38()
	local time: f32 = 0
	local block: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 10 then
			if at <= 1 then
				helper_39a5c(1020020, 210)
			end
			if at <= 2 then
				helper_aafd6a80(4)
			end
			if at <= 3 then
				helper_aafd6a80(30)
			end
			if at <= 4 then
				helper_57ae27b6(1)
			end
			if at <= 5 then
				helper_fe376309(0, -1, 8, 0, 0, 45)
			end
			if at <= 6 then
				helper_aafd6a80(30)
			end
			if at <= 7 then
				helper_fe376309(0, -1, 5, 0, 0, 210)
			end
			if at <= 9 then
				helper_aafd6a80(30)
			end
			if vm.skip_end() then
				return skip(11)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SetBgColor(255.0, 255.0, 255.0, 255.0)
		if vm.wait() then
			return skip(12)
		end
		event.SetFadeIn(0, 255, 255, 255)
		block = event.LoadImg_4(5, "textures/event/e100/e102/e102_load02_1.json", 0) or block
		event.SpriteInit(0)
		event.SpriteSetType(0, 0)
		event.SpriteSetTexture(0, "e102_load02", block)
		event.SpriteSetColor(0, 128, 128, 128, 0)
		event.SpriteSetUvsize(0, 0, 0, 512, 416)
		event.SpriteSetPutsize(0, 512, 416)
		event.SpriteSetPos(0, 256, 208)
		event.SpriteSetDraw(0, 0)
		event.EohSyncSprite(10, 0)
		event.ObjsInit(10)
		event.ObjsSyncObj(10, 10)
		event.SpriteSetDraw(0, 1)
		event.ObjsSetColor(10, 128.0, 128.0, 128.0, 128.0, 0)
		if vm.wait() then
			return skip(13)
		end
		event.StopBgm(0)
		event.SetMesWindowMode(0, 1)
		event.CharaActive(0)
		event.SetActiveLight(0)
		event.SetTime(time)
		event.DeleteChara(32)
		event.DeleteChara(33)
	end
	event.SetFlag(102, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 0)
	event.BgmPlayEnable()
	event.BgmLoadEnable()
	event.AssignStack(5)
	event.ClearStack(5)
	event.ChangeDir("event/e100/e102/")
	event.LoadMes(0, 5, "e102_1.txt")
	event.LoadChara(5, "e102_minchu.gltf", "info", 32)
	event.CharaActive(32)
	event.EohSyncChara(0, 32)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.LoadChara(5, "e102_eina.gltf", "info", 33)
	event.CharaActive(33)
	event.EohSyncChara(1, 33)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.ChangeDir("")
	event.SpriteInit(0)
	event.SpriteSetType(0, 0)
	event.SpriteSetColor(0, 0, 0, 0, 128)
	event.SpriteSetUvsize(0, 0, 0, 512, 416)
	event.SpriteSetPutsize(0, 512, 416)
	event.SpriteSetPos(0, 256, 208)
	event.SpriteSetDraw(0, 0)
	event.EohSyncSprite(2, 0)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "泣き目")
	event.ObjsTexAnime(0, 1, "泣き口")
	event.CharaActive(0, 0)
	event.EohSetPos(0, 40.0, 0.0, 0.0)
	event.EohSetRot(0, 0.0, 1.57, 0.0)
	event.EohSetMotion(0, "泣く", 4)
	event.EohSetPos(1, 40.0, 0.0, 0.0)
	event.EohSetRot(1, 0.0, 1.57, 0.0)
	event.EohSetMotion(1, "泣く", 4)
	event.InitDramaScene()
	event.SetSkipFcol(255.0, 255.0, 255.0)
	time = event.GetTime() or time
	event.SetTime(12.0)
	event.SetActiveLight(0)
	event.CmrsInit()
	event.CmrsSetPos(83.479996, 26.18, -32.23)
	event.CmrsSetRef(46.18, 11.82, 0.13)
	event.SpriteSetDraw(0, 1)
	event.SetFadeIn(0)
	event.SetMesWindowMode(0, 0)
	helper_39a5c(1020010, 120)
	if vm.skipping() then
		return skip(1)
	end
	helper_39a5c(1020020, 210)
	if vm.skipping() then
		return skip(2)
	end
	event.SetMesWindowMode(0, 7)
	event.SetMesOkuri(0, 1)
	event.SpriteSetColor(0, 255, 255, 255, 32)
	event.SetFadeOut(0)
	event.StopBgm(0)
	helper_aafd6a80(4)
	if vm.skipping() then
		return skip(3)
	end
	event.LoadBgm(58)
	event.PlayBgm(0)
	event.SetFadeIn(30)
	helper_aafd6a80(30)
	if vm.skipping() then
		return skip(4)
	end
	event.StreamOpen3(1, 1020030)
	helper_57ae27b6(1)
	if vm.skipping() then
		return skip(5)
	end
	event.StreamPlay(1)
	event.MesMake_2(0, 1020030)
	helper_fe376309(0, -1, 8, 0, 0, 45)
	if vm.skipping() then
		return skip(6)
	end
	event.SetFadeOut(30, 255, 255, 255)
	helper_aafd6a80(30)
	if vm.skipping() then
		return skip(7)
	end
	event.SpriteSetDraw(0, 1)
	event.SpriteSetColor(0, 255, 255, 255, 128)
	event.SetFadeIn(0, 255, 255, 255)
	event.SetMesWindowMode(0, 12)
	event.SetMesOkuri(0, 0)
	event.MesMake_2(0, 1020040)
	helper_fe376309(0, -1, 5, 0, 0, 210)
	if vm.skipping() then
		return skip(8)
	end
	event.StreamClose(1)
	event.SetMesOkuri(0, 1)
	if vm.wait() then
		return skip(9)
	end
	event.SetFadeOut(30, 255, 255, 255)
	event.FadeOutBgm(30)
	helper_aafd6a80(30)
	if vm.skipping() then
		return skip(10)
	end
	return part2()
end

--- Helper function.
local function helper_3b2e8()
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.DeleteChara(32)
	event.DeleteChara(33)
	event.DeleteChara(34)
	event.DeleteChara(35)
	event.DeleteChara(36)
	event.CharaActive(1, 0)
end

--- Helper function.
local function helper_3bb44()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 6 then
			if at <= 1 then
				helper_aafd6a80(60)
			end
			if at <= 2 then
				helper_c049c42a(0, -1, 8, 0, 0)
			end
			if at <= 3 then
				helper_c049c42a(0, -1, 8, 0, 0)
			end
			if at <= 4 then
				helper_c049c42a(0, -1, 8, 0, 0)
			end
			if at <= 5 then
				helper_aafd6a80(30)
			end
			if vm.skip_end() then
				return skip(7)
			end
			return part2()
		end
		helper_3b2e8()
	end
	function part2()
		event.CancelDramaScene()
		helper_3b2e8()
		event.SetFadeIn(30)
	end
	event.Initialize()
	helper_696c0345()
	event.InitDramaScene()
	event.SetFadeIn(30)
	event.CharaActive(1, 32)
	event.CharaActive(1, 33)
	event.CharaActive(1, 34)
	event.CharaActive(1, 35)
	event.SetReference(33, "pie", 34)
	event.SetReference(33, "pie", 35)
	event.CmrsSetPos(-22.48, 31.6, -71.45)
	event.CmrsSetRef(74.99, 21.39, -133.6)
	event.ObjsSetPos(0, 71.93, 0.0, -137.17)
	event.ObjsSetRot(0, 0.0, -3.12, 0.0)
	event.ObjsSetPos(1, -32.7, 0.0, -81.53)
	event.ObjsSetRot(1, 0.0, 1.92, 0.0)
	event.ObjsSetMotion(0, "座り", 4)
	event.ObjsMotionDelay(0, 90)
	event.ObjsSetMotion(0, "左を見る", 6)
	event.ObjsNextMotion(0, "左を見るL", 0)
	event.ObjsSetMotion(1, "ポテトパイ歩き", 4)
	event.ObjsMove(1, 29.44, 0.0, -115.61, 120)
	helper_aafd6a80(120)
	if vm.skipping() then
		return skip(1)
	end
	event.DelReference(34)
	event.DelReference(35)
	event.CharaActive(0, 33)
	event.CharaActive(1, 36)
	event.SetReference(32, "pie", 36)
	event.CmrsSetPos(15.46, 33.35, -97.19)
	event.CmrsSetRef(39.19, 15.77, -110.22)
	event.ObjsSetPos(0, 45.12, 0.0, -113.39)
	event.ObjsSetRot(0, 0.0, -1.08, 0.0)
	event.ObjsSetMotion(0, "喜ぶ", 6)
	event.ObjsNextMotion(0, "喜ぶL", 0)
	helper_aafd6a80(60)
	if vm.skipping() then
		return skip(2)
	end
	event.CharaActive(1, 33)
	event.CmrsSetPos(73.92, 10.61, -94.01)
	event.CmrsSetRef(36.84, 20.8, -109.04)
	event.ObjsSetPos(0, 45.12, 0.0, -113.39)
	event.ObjsSetRot(0, 0.0, -1.08, 0.0)
	event.ObjsSetPos(1, 28.93, 0.0, -101.8)
	event.ObjsSetRot(1, 0.0, 2.04, 0.0)
	event.ObjsSetMotion(0, "食べる", 4)
	event.ObjsSetMotion(1, "ユリス見立ち", 4)
	event.MesMake_2(0, 2090590)
	helper_c049c42a(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, 2090591)
	helper_c049c42a(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(0, 2090592)
	helper_c049c42a(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.SetFadeOut(30)
	helper_aafd6a80(30)
	if vm.skipping() then
		return skip(6)
	end
	return part2()
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 100.
script[100] = function()
	helper_3ec30()
	event.ResetCamera(1, 0.0)
end

--- Program 150.
script[150] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_3d30c()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 400.
script[400] = function()
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_3eb18(0)
			helper_136a94b8(1)
		end
	end
	event.SetMotion(0, "立ち")
	flag = event.GetFlag(38) or flag
	if flag == 0 then
		event.SetFlag(38, 1)
		event.AddItem(357)
		helper_8668c8fd(357, 1)
		if vm.skipping() then
			return skip(1)
		end
		helper_3eb18(0)
		helper_136a94b8(1)
		if vm.skipping() then
			return skip(2)
		end
	end
end

--- Program 500.
script[500] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_39c38()
	if vm.skipping() then
		return skip(1)
	end
	event.CancelNowLoading()
	event.GotoDng(0, 3, 500)
	event.SetFadeOut(0, 255.0, 255.0, 255.0)
	if vm.wait() then
		return skip(2)
	end
end

--- Program 501.
script[501] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_3bb44()
	if vm.skipping() then
		return skip(1)
	end
	event.MapJump(-1, "g01i07", 502)
	if vm.wait() then
		return skip(2)
	end
end

--- Program 530.
script[530] = function()
	local block: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_aafd6a80(2)
		end
		if at <= 2 then
			helper_aafd6a80(90)
		end
		if at <= 3 then
			local _ = helper_acccbf55(0)
		end
		if at <= 4 then
			helper_aafd6a80(30)
		end
		if at <= 5 then
			helper_c049c42a(0, -1, 8, 0, 0)
		end
		if at <= 6 then
			helper_aafd6a80(2)
		end
	end
	helper_3d30c()
	if vm.skipping() then
		return skip(1)
	end
	event.PauseEnableFlag(0)
	event.Initialize()
	event.AssignStack(5)
	event.ClearStack(5)
	event.SetBgColor(0, 0, 0)
	event.SetFadeIn(0)
	event.LoadMovie(5, "movie/end1.mp4")
	event.SetFadeOut(0)
	event.SoundAllStop()
	event.SndInReverb(0)
	helper_aafd6a80(2)
	if vm.skipping() then
		return skip(2)
	end
	block = event.LoadImg_4(5, "textures/event/e700/e736/e73601_1.json", 0) or block
	event.SpriteInit(0)
	event.SpriteSetType(0, 0)
	event.SpriteSetColor(0, 0, 0, 0, 128)
	event.SpriteSetPutsize(0, 512, 448)
	event.SpriteSetPos(0, 256, 224)
	event.SpriteSetDraw(0, 1)
	event.SpriteInit(1)
	event.SpriteSetType(1, 0)
	event.SpriteSetTexture(1, "e73601", block)
	event.SpriteSetColor(1, 128, 128, 128, 128)
	event.SpriteSetUvsize(1, 0, 0, 512, 448)
	event.SpriteSetPutsize(1, 512, 448)
	event.SpriteSetPos(1, 256, 224)
	event.SpriteSetDraw(1, 1)
	event.SetFadeIn(60)
	helper_aafd6a80(90)
	if vm.skipping() then
		return skip(3)
	end
	while true do
		if helper_acccbf55(0) ~= 0 then
			break
		else
			if vm.wait() then
				return skip(4)
			end
		end
	end
	event.SetFadeOut(30)
	helper_aafd6a80(30)
	if vm.skipping() then
		return skip(5)
	end
	event.SpriteSetDraw(1, 0)
	event.SetFadeIn(0)
	event.SetMesWindowMode(0, 4)
	event.SetMesDrawspeed(0, 1)
	event.MesMake_2(0, "Sauvegarder - 1er fich. Chap. 8")
	helper_c049c42a(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.SetFadeOut(0)
	helper_aafd6a80(2)
	if vm.skipping() then
		return skip(7)
	end
	event.SpriteSetDraw(0, 0)
	event.SetFlag(799, 1)
	event.SetSavedataEtc(0, 10)
	event.SetFlag(736, 1)
	event.SetFlag(800, 0)
	event.SetBitCtrl(1, 0)
	event.SetBitCtrl(8, 0)
	event.SetActiveChrNo(0)
	event.LeaveMonicaItemCheck()
	event.ExtTyped(1078, "ii", 3, 0)
	event.SetCharaChangeFlag(3, 0)
	event.SetCharaChangeMask(3, 0)
	event.ExtTyped(1078, "ii", 1, 0)
	event.SetCharaChangeFlag(1, 0)
	event.SetCharaChangeMask(1, 0)
	event.SetSavedataEtc(3, 1)
	event.SetTime(6.0)
	event.GotoMenu(7)
	if vm.wait() then
		return skip(8)
	end
	event.SndInReverb(1)
	event.SetExitFlag(1)
end

--- Program 600.
script[600] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_3bb44()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 610.
script[610] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_39c38()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 1000.
script[1000] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_998ed0ac()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 11020.
script[11020] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.StopBgm(0)
	helper_39c38()
	if vm.skipping() then
		return skip(1)
	end
	event.CancelNowLoading()
	event.GotoDng(0, -1, 500)
	event.SetFadeOut(0, 255.0, 255.0, 255.0)
	if vm.wait() then
		return skip(2)
	end
end

return script
