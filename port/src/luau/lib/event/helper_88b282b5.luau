--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_097407fc = require("@lib/event/helper_097407fc")
local helper_126faf7c = require("@lib/event/helper_126faf7c")
local helper_5fe8f3bb = require("@lib/event/helper_5fe8f3bb")
local helper_92829c19 = require("@lib/event/helper_92829c19")
local helper_b0211f82 = require("@lib/event/helper_b0211f82")
local helper_f62bfce3 = require("@lib/event/helper_f62bfce3")

--- Helper function.
local function helper_88b282b5()
	local time: f32 = 0
	local var1: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 43 then
			if at <= 1 then
				helper_b0211f82(20)
			end
			if at <= 2 then
				helper_f62bfce3(1010007)
			end
			if at <= 5 then
				helper_b0211f82(30)
			end
			if at <= 6 then
				helper_5fe8f3bb()
			end
			if at <= 7 then
				helper_b0211f82(30)
			end
			if at <= 8 then
				helper_126faf7c(2)
			end
			if at <= 9 then
				helper_126faf7c(3)
			end
			if at <= 10 then
				helper_92829c19(1010010)
			end
			if at <= 11 then
				helper_b0211f82(16)
			end
			if at <= 12 then
				helper_097407fc(1)
			end
			if at <= 13 then
				helper_b0211f82(30)
			end
			if at <= 14 then
				helper_126faf7c(0)
			end
			if at <= 15 then
				helper_b0211f82(30)
			end
			if at <= 16 then
				helper_92829c19(1010020)
			end
			if at <= 17 then
				helper_b0211f82(30)
			end
			if at <= 18 then
				helper_92829c19(1010030)
			end
			if at <= 19 then
				helper_126faf7c(0)
			end
			if at <= 20 then
				helper_92829c19(1010040)
			end
			if at <= 21 then
				helper_92829c19(1010050)
			end
			if at <= 22 then
				helper_126faf7c(0)
			end
			if at <= 23 then
				helper_5fe8f3bb()
			end
			if at <= 24 then
				helper_92829c19(1010060)
			end
			if at <= 25 then
				helper_92829c19(1010070)
			end
			if at <= 26 then
				helper_126faf7c(0)
			end
			if at <= 27 then
				helper_92829c19(1010080)
			end
			if at <= 28 then
				helper_92829c19(1010090)
			end
			if at <= 29 then
				helper_126faf7c(0)
			end
			if at <= 30 then
				helper_097407fc(1)
			end
			if at <= 31 then
				helper_126faf7c(0)
			end
			if at <= 32 then
				helper_126faf7c(0)
			end
			if at <= 33 then
				helper_b0211f82(24)
			end
			if at <= 34 then
				helper_b0211f82(40)
			end
			if at <= 35 then
				helper_126faf7c(0)
			end
			if at <= 36 then
				helper_92829c19(1010100)
			end
			if at <= 37 then
				helper_097407fc(1)
			end
			if at <= 38 then
				helper_b0211f82(30)
			end
			if at <= 39 then
				helper_92829c19(1010110)
			end
			if at <= 40 then
				helper_92829c19(1010120)
			end
			if at <= 41 then
				helper_b0211f82(190)
			end
			if at <= 42 then
				helper_5fe8f3bb()
			end
			if vm.skip_end() then
				return skip(44)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SndInReverb(1)
		event.SpriteSetDraw(0, 0)
		event.SetTime(time)
		event.SndSeAllStop(4)
		event.DeleteChara(8)
		event.DeleteChara(9)
		event.DeleteChara(10)
		event.DeleteChara(11)
		event.DeleteChara(12)
		event.DeleteChara(13)
		event.DeleteChara(14)
		event.ObjsInit(0)
		event.ObjsInit(1)
		event.ObjsInit(2)
		event.ObjsInit(3)
		event.ObjsInit(4)
		event.ObjsInit(5)
		event.ObjsInit(6)
		event.LoadMes(0, -1)
		event.CharaActive(0)
	end
	event.SetFlag(101, 1)
	time = event.GetTime() or time
	event.SetTime(12.0)
	event.Initialize()
	event.InitDramaScene()
	event.SetMesWindowMode(0, 0)
	event.StopEnvBgm()
	event.StopBgm(0)
	event.CharaActive(0, 0)
	event.AssignStack(5)
	event.ClearStack(5)
	event.LoadMes(0, 5, "event/e100/e101/e101_1.txt")
	event.SetFadeIn(0)
	event.SpriteInit(0)
	event.SpriteSetType(0, 0)
	event.SpriteSetPos(0, 256, 208)
	event.SpriteSetPutsize(0, 512, 416)
	event.SpriteSetColor(0, 0, 0, 0, 128)
	event.SpriteSetDraw(0, 1)
	event.SndInReverb(0)
	helper_f62bfce3(1010005)
	if vm.skipping() then
		return skip(1)
	end
	helper_b0211f82(20)
	if vm.skipping() then
		return skip(2)
	end
	helper_f62bfce3(1010007)
	if vm.skipping() then
		return skip(3)
	end
	if vm.wait() then
		return skip(4)
	end
	if vm.wait() then
		return skip(5)
	end
	event.SndInReverb(1)
	event.SpriteSetDraw(0, 0)
	event.SetFadeOut(0)
	event.LoadSound(1804)
	var1 = event.SndLoadSound(1804) or var1
	event.ChangeDir("event/e100/e101/")
	event.SetMesWindowMode(0, 7)
	event.LoadChara(5, "e101_mints.gltf", "info", 8)
	event.CharaActive(8)
	event.EohSyncChara(0, 8)
	event.EohSetFootSoundId(0, 2)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetPos(0, 82.0, 0.0, 0.0)
	event.ObjsSetRot(0, 0.0, -1.57, 0.0)
	event.ObjsSetMotion(0, "たてひじ座り", 4)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "けだる目")
	event.ObjsTexAnime(0, 1, "怒り口")
	event.LoadChara(5, "e101_girard.gltf", "info", 9)
	event.CharaActive(9)
	event.EohSyncChara(1, 9)
	event.EohSetSoundId(1, var1)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.ObjsSetPos(1, -148.0, 0.0, 0.0)
	event.ObjsSetRot(1, 0.0, 1.57, 0.0)
	event.ObjsSetMotion(1, "食べループ", 4)
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "目をつぶる")
	event.ObjsTexAnime(1, 1, "食べる")
	event.LoadChara(5, "e101_pork.gltf", "info", 10)
	event.CharaActive(10)
	event.EohSyncChara(2, 10)
	event.EohSetSoundId(2, var1)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.ObjsSetPos(2, 87.42, 0.0, -62.0)
	event.ObjsSetRot(2, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(2, "立ち", 4)
	event.ObjsTexAnime(2, 0)
	event.LoadChara(5, "e101_rene.gltf", "info", 11)
	event.CharaActive(11)
	event.EohSyncChara(3, 11)
	event.EohSetSoundId(3, var1)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.ObjsSetPos(3, 92.0, 0.0, 21.66)
	event.ObjsSetRot(3, 0.0, -2.04, 0.0)
	event.ObjsSetMotion(3, "立ち", 4)
	event.ObjsTexAnime(3, 0)
	event.LoadChara(5, "e101_chair.gltf", "info", 13)
	event.CharaActive(13)
	event.EohSyncChara(5, 13)
	event.ObjsInit(5)
	event.ObjsSyncObj(5, 5)
	event.ObjsSetPos(5, -5.0, 0.0, 0.0)
	event.ObjsSetRot(5, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(5, "待機", 4)
	event.LoadChara(5, "e101_door.gltf", "info", 14)
	event.CharaActive(14)
	event.SetStatus(14, 64)
	event.EohSyncChara(6, 14)
	event.ObjsInit(6)
	event.ObjsSyncObj(6, 6)
	event.ObjsSetPos(6, 0.0, 0.0, 0.0)
	event.ObjsSetRot(6, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(6, "待機", 4)
	event.LoadChara(5, "e101_stuart.gltf", "info", 12)
	event.CharaActive(12)
	event.EohSyncChara(4, 12)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.ObjsSetPos(4, -155.82, 0.0, 30.0)
	event.ObjsSetRot(4, 0.0, 2.28, 0.0)
	event.ObjsSetMotion(4, "立ち", 4)
	event.ObjsTexAnime(4, 0)
	event.ChangeDir("")
	event.EohSyncObj(11, "p01_i04h01b", "i04h01b_11-m0")
	event.EohSetShow(11, 0)
	event.EohSyncObj(31, "p06_i04h01b")
	event.EohSetShow(31, 0)
	event.EohSyncObj(31, "p04_i04h01b")
	event.EohSetShow(31, 0)
	event.EohSyncObj(31, "p01_i04h01b", "i04h01b_04-m0")
	event.EohSetShow(31, 0)
	event.EohSyncObj(31, "p01_i04h01b", "i04h01b_04-m1")
	event.EohSetShow(31, 0)
	event.EohSyncObj(31, "p01_i04h01b", "i04h01b_10-m0")
	event.EohSetShow(31, 1)
	helper_b0211f82(30)
	if vm.skipping() then
		return skip(6)
	end
	event.CmrsInit()
	event.CmrsSetPos(-214.86, 63.21, -58.86)
	event.CmrsSetRef(-141.84, 19.73, 0.0)
	event.CmrsMove(-46.95, 63.21, -58.86, 26.07, 19.73, 0.0, 160)
	event.CmrsPrSlowing(0.96, 40)
	event.CmrsFadeInit()
	event.CmrsFadeIn(30)
	helper_5fe8f3bb()
	if vm.skipping() then
		return skip(7)
	end
	helper_b0211f82(30)
	if vm.skipping() then
		return skip(8)
	end
	event.CmrsSetPos(17.64, 49.88, 36.05)
	event.CmrsSetRef(83.43, 20.0, -4.7)
	event.ObjsSetMotion(2, "料理持ち歩き", 6)
	event.ObjsNextMotion(2, "料理置き", 6)
	event.ObjsNextMotion(2, "皿置きループ", 4)
	event.ObjsMove(2, 87.42, 0.0, -49.0, 34)
	event.ObjsSetMotion(3, "皿置き", 6)
	event.ObjsNextMotion(3, "皿置き立ち", 4)
	event.ObjsTexAnime(3, 1, "閉じた目")
	event.ObjsTexAnime(3, 1, "閉じた口")
	helper_126faf7c(2)
	if vm.skipping() then
		return skip(9)
	end
	helper_126faf7c(3)
	if vm.skipping() then
		return skip(10)
	end
	event.SetPakuAnim(2, "口パク")
	helper_92829c19(1010010)
	if vm.skipping() then
		return skip(11)
	end
	event.ResetPakuAnim()
	event.ObjsTexAnime(3, 0)
	event.CmrsSetPos(60.47, 24.78, 0.0)
	event.CmrsSetRef(85.9, 24.2, 0.0)
	event.EohSetShow(11, 1)
	event.CharaActive(0, 10)
	event.ObjsSetPos(3, 139.0, 0.0, 39.86)
	event.ObjsSetRot(3, 0.0, -2.04, 0.0)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "ため息目")
	event.ObjsTexAnime(0, 1, "ため息口")
	event.ObjsSetMotion(0, "ため息", 6)
	event.ObjsNextMotion(0, "たてひじ座り", 4)
	helper_b0211f82(16)
	if vm.skipping() then
		return skip(12)
	end
	event.StreamOpen3(1, 1010015)
	helper_097407fc(1)
	if vm.skipping() then
		return skip(13)
	end
	event.StreamPlay(1)
	helper_b0211f82(30)
	if vm.skipping() then
		return skip(14)
	end
	event.StreamClose(1)
	helper_126faf7c(0)
	if vm.skipping() then
		return skip(15)
	end
	helper_b0211f82(30)
	if vm.skipping() then
		return skip(16)
	end
	event.CmrsSetPos(-80.78, 46.58, 17.69)
	event.CmrsSetRef(-146.75, 20.92, 1.93)
	event.SetPakuAnim(1, "通常口パク")
	helper_92829c19(1010020)
	if vm.skipping() then
		return skip(17)
	end
	event.CmrsSetPos(47.24, 39.28, 21.08)
	event.CmrsSetRef(89.08, 20.92, -0.6)
	helper_b0211f82(30)
	if vm.skipping() then
		return skip(18)
	end
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "真剣目")
	event.ObjsSetMotion(0, "姿勢を正す", 6)
	event.ObjsNextMotion(0, "姿勢を正すL", 4)
	event.SetPakuAnim(0, "通常口パク", "真剣口")
	helper_92829c19(1010030)
	if vm.skipping() then
		return skip(19)
	end
	event.ResetPakuAnim()
	helper_126faf7c(0)
	if vm.skipping() then
		return skip(20)
	end
	event.CmrsSetPos(87.41, 29.46, 0.0)
	event.CmrsSetRef(15.12, 20.92, 0.0)
	event.SetPakuAnim(1, "通常口パク")
	helper_92829c19(1010040)
	if vm.skipping() then
		return skip(21)
	end
	event.CmrsSetPos(79.19, 21.98, 37.21)
	event.CmrsSetRef(87.23, 22.33, 0.0)
	event.ObjsSetMotion(0, "身を乗りだす", 6)
	event.ObjsNextMotion(0, "身を乗りだすL", 4)
	event.SetPakuAnim(0, "通常口パク", "真剣口")
	helper_92829c19(1010050)
	if vm.skipping() then
		return skip(22)
	end
	event.ResetPakuAnim()
	helper_126faf7c(0)
	if vm.skipping() then
		return skip(23)
	end
	event.CmrsMove2(-134.51, 21.98, 37.21, -146.28, 22.33, 0.0, 120, 0, 0.4)
	helper_5fe8f3bb()
	if vm.skipping() then
		return skip(24)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_92829c19(1010060)
	if vm.skipping() then
		return skip(25)
	end
	event.CmrsSetPos(47.24, 39.28, 21.08)
	event.CmrsSetRef(89.08, 20.92, -0.6)
	event.ObjsSetMotion(0, "身を乗りだす戻り", 6)
	event.ObjsNextMotion(0, "姿勢を正すL", 4)
	event.SetPakuAnim(0, "通常口パク", "真剣口")
	helper_92829c19(1010070)
	if vm.skipping() then
		return skip(26)
	end
	event.ResetPakuAnim()
	helper_126faf7c(0)
	if vm.skipping() then
		return skip(27)
	end
	event.CmrsSetPos(-102.31, 28.59, 0.0)
	event.CmrsSetRef(-153.69, 24.83, 0.0)
	event.SetPakuAnim(1, "通常口パク")
	helper_92829c19(1010080)
	if vm.skipping() then
		return skip(28)
	end
	event.CmrsSetPos(-11.79, 43.33, 0.0)
	event.CmrsSetRef(85.09, 23.18, 0.0)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "怒り目")
	event.ObjsSetMotion(0, "立ち上がる", 6)
	event.ObjsNextMotion(0, "立ち上がるL", 4)
	event.ObjsSetMotion(5, "立ち上がる", 6)
	event.ObjsSetMotion(3, "驚く", 6)
	event.ObjsNextMotion(3, "驚くループ", 4)
	event.ObjsTexAnime(3, 1, "瞬き")
	event.ObjsTexAnime(3, 1, "開閉口")
	event.SndSePlay(var1, 6)
	event.SetPakuAnim(0, "通常口パク", "怒り口")
	helper_92829c19(1010090)
	if vm.skipping() then
		return skip(29)
	end
	event.ResetPakuAnim()
	helper_126faf7c(0)
	if vm.skipping() then
		return skip(30)
	end
	event.StreamOpen3(1, 1010095)
	helper_097407fc(1)
	if vm.skipping() then
		return skip(31)
	end
	event.StreamPlay(1)
	event.ObjsSetMotion(3, "待って", 6)
	event.ObjsNextMotion(3, "待ってループ", 6)
	event.ObjsTexAnime(3, 0)
	event.ObjsTexAnime(3, 1, "デフォルト目")
	event.ObjsTexAnime(3, 1, "開きっぱなし口")
	event.ObjsSetMotion(0, "→走り", 6)
	event.ObjsNextMotion(0, "走り", 4)
	event.ObjsRotation(0, 0.0, 1.56, 0.0, 10)
	event.ObjsMove(0, 111.88, 0.0, 16.89, 10)
	helper_126faf7c(0)
	if vm.skipping() then
		return skip(32)
	end
	event.ObjsInitPas(0)
	event.ObjsSetPasFrm(0, 40)
	event.ObjsAddPas(0, 111.88, 0.0, 16.89)
	event.ObjsAddPas(0, 138.16, 0.0, 18.14)
	event.ObjsAddPas(0, 199.13, 2.56, 10.02)
	event.ObjsAddPas(0, 246.27, 11.9, 0.0)
	event.ObjsStartPas(0)
	helper_126faf7c(0)
	if vm.skipping() then
		return skip(33)
	end
	event.ObjsSetMotion(0, "出て行く", 2)
	event.ObjsMotionWait(0)
	event.ObjsSetMotion(6, "出て行く", 2)
	helper_b0211f82(24)
	if vm.skipping() then
		return skip(34)
	end
	event.SndSePlay(var1, 7)
	helper_b0211f82(40)
	if vm.skipping() then
		return skip(35)
	end
	event.SndSePlay(var1, 8)
	helper_126faf7c(0)
	if vm.skipping() then
		return skip(36)
	end
	event.StreamClose(1)
	event.CmrsSetPos(-96.15, 33.86, -18.14)
	event.CmrsSetRef(-148.11, 23.87, 3.05)
	event.ObjsSetMotion(4, "驚き", 6)
	event.ObjsNextMotion(4, "驚きループ", 4)
	event.SetPakuAnim(4, "口パク")
	helper_92829c19(1010100)
	if vm.skipping() then
		return skip(37)
	end
	event.StreamOpen3(1, 1010105)
	helper_097407fc(1)
	if vm.skipping() then
		return skip(38)
	end
	event.StreamPlay(1)
	helper_b0211f82(30)
	if vm.skipping() then
		return skip(39)
	end
	event.StreamClose(1)
	event.ObjsSetMotion(4, "屈み", 6)
	event.ObjsNextMotion(4, "屈みループ", 4)
	event.SetPakuAnim(4, "口パク")
	helper_92829c19(1010110)
	if vm.skipping() then
		return skip(40)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_92829c19(1010120)
	if vm.skipping() then
		return skip(41)
	end
	event.ObjsSetMotion(4, "立ち", 4)
	event.CmrsSetPos(119.25, 51.22, 0.0)
	event.CmrsSetRef(19.04, 39.52, 0.0)
	event.CmrsMove(157.82, 52.56, 0.0, 19.04, 39.52, 0.0, 220)
	helper_b0211f82(190)
	if vm.skipping() then
		return skip(42)
	end
	event.CmrsFadeInit()
	event.CmrsFadeOut(30)
	helper_5fe8f3bb()
	if vm.skipping() then
		return skip(43)
	end
	return part2()
end

return helper_88b282b5
