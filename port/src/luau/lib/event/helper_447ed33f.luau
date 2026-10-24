--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_09b5edc9 = require("@lib/event/helper_09b5edc9")
local helper_387dadc7 = require("@lib/event/helper_387dadc7")
local helper_a0e17f3c = require("@lib/event/helper_a0e17f3c")
local helper_a19c5ee3 = require("@lib/event/helper_a19c5ee3")
local helper_b35e85eb = require("@lib/event/helper_b35e85eb")
local helper_f1cdfb4a = require("@lib/event/helper_f1cdfb4a")

--- Helper function.
local function helper_447ed33f()
	local var0: s32 = 0
	local var1: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 45 then
			if at <= 1 then
				helper_b35e85eb()
			end
			if at <= 2 then
				helper_a19c5ee3(0)
			end
			if at <= 3 then
				helper_a0e17f3c(4)
			end
			if at <= 4 then
				helper_a0e17f3c(120)
			end
			if at <= 6 then
				helper_09b5edc9(10050, 120)
			end
			if at <= 7 then
				helper_a19c5ee3(0)
			end
			if at <= 8 then
				helper_b35e85eb()
			end
			if at <= 9 then
				helper_f1cdfb4a(10060, -1, 10)
			end
			if at <= 10 then
				helper_a19c5ee3(0)
			end
			if at <= 11 then
				helper_a19c5ee3(1)
			end
			if at <= 12 then
				helper_b35e85eb()
			end
			if at <= 13 then
				helper_f1cdfb4a(10070, -1, 10)
			end
			if at <= 14 then
				helper_b35e85eb()
			end
			if at <= 15 then
				helper_a19c5ee3(0)
			end
			if at <= 16 then
				helper_a0e17f3c(30)
			end
			if at <= 17 then
				helper_f1cdfb4a(10080, -1, 10)
			end
			if at <= 18 then
				helper_a19c5ee3(0)
			end
			if at <= 19 then
				helper_a19c5ee3(2)
			end
			if at <= 20 then
				helper_f1cdfb4a(10090, -1, 10)
			end
			if at <= 21 then
				helper_f1cdfb4a(10093, -1, 10)
			end
			if at <= 22 then
				helper_a19c5ee3(0)
			end
			if at <= 23 then
				helper_a19c5ee3(2)
			end
			if at <= 24 then
				helper_a0e17f3c(10)
			end
			if at <= 25 then
				helper_a0e17f3c(10)
			end
			if at <= 26 then
				helper_f1cdfb4a(10100, -1, 10)
			end
			if at <= 27 then
				helper_f1cdfb4a(10105, -1, 10)
			end
			if at <= 28 then
				helper_f1cdfb4a(10110, -1, 10)
			end
			if at <= 29 then
				helper_f1cdfb4a(10120, -1, 10)
			end
			if at <= 30 then
				helper_f1cdfb4a(10130, -1, 10)
			end
			if at <= 31 then
				helper_f1cdfb4a(10140, -1, 10)
			end
			if at <= 32 then
				helper_a19c5ee3(1)
			end
			if at <= 33 then
				helper_f1cdfb4a(10150, -1, 10)
			end
			if at <= 34 then
				helper_f1cdfb4a(10153, -1, 10)
			end
			if at <= 35 then
				helper_f1cdfb4a(10156, -1, 10)
			end
			if at <= 36 then
				helper_f1cdfb4a(10160, -1, 10)
			end
			if at <= 37 then
				helper_b35e85eb()
			end
			if at <= 38 then
				helper_f1cdfb4a(10170, -1, 10)
			end
			if at <= 39 then
				helper_f1cdfb4a(10180, -1, 10)
			end
			if at <= 40 then
				helper_f1cdfb4a(10190, -1, 10)
			end
			if at <= 41 then
				helper_a19c5ee3(1)
			end
			if at <= 42 then
				helper_f1cdfb4a(10200, -1, 10)
			end
			if at <= 43 then
				helper_a19c5ee3(0)
			end
			if at <= 44 then
				helper_a0e17f3c(30)
			end
			if vm.skip_end() then
				return skip(46)
			end
			return part2()
		end
		if at <= 46 then
			helper_a0e17f3c(6)
		end
	end
	function part2()
		event.CancelDramaScene()
		event.EohSetShow(3, 1)
		event.StreamClose(1)
		event.ObjsInit(0)
		event.DelExtMotion(0)
		event.DeleteChara(10)
		event.DeleteChara(11)
		event.LoadMes(0, -1)
		event.EohSetFootSoundId(0, -1)
		event.SetCharaPos(0, 70.16, 57.1, 63.57)
		event.SetCharaRot(0, 0.0, -0.94, 0.0)
		event.SetMotion(0, "立ち", 4)
		event.CharaDaEnable(0, 1)
		event.CharaNormalDrive(0)
		event.CharaResetDa(0)
		event.SetMotion(9, "座りL", 4)
		event.SetTexAnim(9, 0)
		event.StopBgm(0)
		helper_a0e17f3c(6)
		if vm.skipping() then
			return skip(47)
		end
		event.LoadBgm(46)
		event.PlayBgm(0, -1)
		event.LoadSound(1202)
		event.SetCameraPos(40.0, 116.0, -116.68)
		event.SetCameraRef(70.16, 87.1, 63.57)
		event.ResetCamera(0)
		event.SetFadeIn(30)
	end
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.LoadBgm(101)
	event.PlayBgm(0, -1)
	event.LoadSound(1201)
	var0 = event.SndLoadSound(1201) or var0
	helper_387dadc7()
	event.AssignStack(5)
	event.ClearStack(5)
	event.LoadMes(0, 5, "event/opening/p1/op1ch2_1.txt")
	event.LoadMotion(5, "event/opening/p1/p1_mints1.gltf", "info", 0)
	event.CharaActive(0)
	event.EohSyncChara(0, 0)
	event.EohSetFootSoundId(0, 3)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetPos(0, 92.0, 50.98, 129.0)
	event.ObjsSetRot(0, 0.0, 3.14, 0.0)
	event.ObjsSetMotion(0, "旧・立ち")
	event.ObjsTexAnime(0, 0)
	event.ObjsResetDaPosition(0)
	event.CharaActive(9)
	event.EohSyncChara(1, 9)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.ObjsTexAnime(1, 0)
	event.LoadChara(5, "event/opening/p1/ticket.gltf", "info", 10)
	event.CharaActive(0, 10)
	event.EohSyncChara(2, 10)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.ObjsSetPos(2, 70.16, 56.87, 63.57)
	event.ObjsSetRot(2, 0.0, -0.94, 0.0)
	event.EohSyncObj(3, "p13_i01h01")
	event.EohSetShow(3, 1)
	event.EohSyncObj(4, "p10_i01h01")
	event.EohSetShow(4, 0)
	event.EohSyncObj(5, "p11_i01h01")
	event.EohSetShow(5, 0)
	event.EohSyncObj(6, "p12_i01h01")
	event.EohSetShow(6, 0)
	event.EohSyncObj(7, "p16_i01h01")
	event.EohSetShow(7, 0)
	event.EohSyncObj(8, "p17_i01h01")
	event.EohSetShow(8, 1)
	event.LoadChara(5, "event/opening/p1/e_op_mizu.gltf", "info", 11)
	event.CharaActive(0, 11)
	event.EohSyncChara(10, 11)
	event.ObjsInit(10)
	event.ObjsSyncObj(10, 10)
	event.EohSetPos(10, 92.0, 56.87, 104.92)
	event.EohSetRot(10, 0.0, 3.14, 0.0)
	event.SetActiveLight(4)
	var1 = event.GetSndId(2) or var1
	event.SndSePlay(var1, 65)
	helper_a0e17f3c(5)
	if vm.skipping() then
		return skip(1)
	end
	event.ObjsMove(0, 92.0, 56.87, 116.43, 15)
	event.ObjsMove(0, 92.0, 56.87, 104.92, 15)
	event.ObjsSetMotion(0, "歩き", 4)
	event.CmrsInit()
	event.CmrsSetPos(47.69, 102.32, 39.89)
	event.CmrsSetRef(92.73, 75.71, 133.2)
	event.CmrsFadeInit()
	event.CmrsFadeIn(30)
	helper_b35e85eb()
	if vm.skipping() then
		return skip(2)
	end
	helper_a19c5ee3(0)
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsSetMotion(0, "旧・立ち")
	helper_a0e17f3c(4)
	if vm.skipping() then
		return skip(4)
	end
	event.CmrsSetPos(91.9, 71.03, 69.15)
	event.CmrsSetRef(91.84, 76.05, 104.34)
	event.CharaActive(1, 11)
	event.ObjsSetMotion(10, "水をはらう", 6)
	event.ObjsNextMotion(10, "水をはらうL", 6)
	event.ObjsMotionWait(10)
	event.ObjsResetMotion(10)
	event.ObjsSetMotion(10, "水をはらうL", 6)
	event.ObjsNextMotion(10, "髪をなおす", 6)
	event.ObjsSetMotion(0, "水をはらう", 6)
	event.ObjsNextMotion(0, "水をはらうL", 6)
	event.ObjsMotionWait(0)
	event.ObjsResetMotion(0)
	event.ObjsSetMotion(0, "水をはらうL", 6)
	event.ObjsNextMotion(0, "髪をなおす", 6)
	event.ObjsMotionWait(0)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "目閉じ（ぶるぶる）")
	event.ObjsTexAnime(0, 1, "口半開き")
	event.ObjsTexaDelay(0, 117)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "下目")
	event.ObjsTexAnime(0, 1, "うひゃ～口")
	event.ObjsTexaDelay(0, 102)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "水を払う目")
	event.ObjsTexAnime(0, 1, "うひゃ～口")
	event.ObjsTexaDelay(0, 134)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "目パチ")
	event.ObjsTexAnime(0, 1, "うひゃ～口")
	event.ObjsSePlay(0, var0, 10)
	event.ObjsSeDelay(0, 60)
	event.ObjsSePlay(0, var0, 11)
	helper_a0e17f3c(120)
	if vm.skipping() then
		return skip(5)
	end
	if vm.wait() then
		return skip(6)
	end
	event.SetPakuAnim(0, "通常口パク", "うひゃ～口")
	helper_09b5edc9(10050, 120)
	if vm.skipping() then
		return skip(7)
	end
	event.ResetPakuAnim()
	helper_a19c5ee3(0)
	if vm.skipping() then
		return skip(8)
	end
	helper_b35e85eb()
	if vm.skipping() then
		return skip(9)
	end
	event.CharaActive(0, 11)
	event.InitDramaScene()
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "目パチ")
	event.CmrsSetPos(140.0, 105.42, 47.49)
	event.CmrsSetRef(42.32, 64.57, 123.63)
	event.EohSetShow(3, 0)
	event.ObjsMotionDelay(0, 10)
	event.ObjsSetMotion(0, "左を向く", 2)
	event.ObjsNextMotion(0, "左を向くL", 4)
	event.ObjsSetMotion(1, "右を向く", 2)
	event.ObjsNextMotion(1, "右を向くL", 4)
	event.SetPakuAnim(1, "口パク")
	helper_f1cdfb4a(10060, -1, 10)
	if vm.skipping() then
		return skip(10)
	end
	event.ResetPakuAnim()
	helper_a19c5ee3(0)
	if vm.skipping() then
		return skip(11)
	end
	helper_a19c5ee3(1)
	if vm.skipping() then
		return skip(12)
	end
	helper_b35e85eb()
	if vm.skipping() then
		return skip(13)
	end
	event.CmrsSetPos(-39.93, 115.82, 118.92)
	event.CmrsSetRef(63.32, 80.25, 77.89)
	event.EohSetShow(3, 1)
	event.ObjsPosDelay(0, 1)
	event.ObjsMove(0, 70.16, 56.87, 63.57, 50)
	event.ObjsRotation(0, 0.0, -2.9, 0.0, 10)
	event.ObjsRotDelay(0, 24)
	event.ObjsRotation(0, 0.0, -0.94, 0.0, 16)
	event.ObjsSetMotion(0, "立ち", 4)
	event.ObjsMotionDelay(0, 1)
	event.ObjsSetMotion(0, "歩き")
	event.ObjsMotionDelay(0, 50)
	event.ObjsSetMotion(0, "旧・立ち")
	event.ObjsMotionDelay(0, 4)
	event.ObjsSetMotion(1, "座りL")
	event.ObjsChengeStep(1, 0.02)
	event.SetPakuAnim(0, "通常口パク")
	helper_f1cdfb4a(10070, -1, 10)
	if vm.skipping() then
		return skip(14)
	end
	event.ResetPakuAnim()
	helper_b35e85eb()
	if vm.skipping() then
		return skip(15)
	end
	helper_a19c5ee3(0)
	if vm.skipping() then
		return skip(16)
	end
	event.ObjsSetMotion(0, "チケットを取り出す", 2)
	event.ObjsNextMotion(0, "チケットを取り出すL", 4)
	event.CharaActive(10)
	event.ObjsSetMotion(2, "チケットを取り出す", 2)
	event.ObjsNextMotion(2, "チケットを取り出すL", 4)
	event.ObjsSeDelay(0, 10)
	event.ObjsSePlay(0, var0, 12)
	event.ObjsSeDelay(0, 50)
	event.ObjsSePlay(0, var0, 13)
	helper_a0e17f3c(30)
	if vm.skipping() then
		return skip(17)
	end
	event.CmrsSetPos(46.78, 79.2, 81.62)
	event.CmrsSetRef(70.26, 79.2, 63.68)
	event.SetPakuAnim(0, "通常口パク")
	helper_f1cdfb4a(10080, -1, 10)
	if vm.skipping() then
		return skip(18)
	end
	event.ResetPakuAnim()
	helper_a19c5ee3(0)
	if vm.skipping() then
		return skip(19)
	end
	helper_a19c5ee3(2)
	if vm.skipping() then
		return skip(20)
	end
	event.ObjsChengeStep(1)
	event.SetPakuAnim(0, "通常口パク")
	helper_f1cdfb4a(10090, -1, 10)
	if vm.skipping() then
		return skip(21)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(0, "チケットを下げる", 6)
	event.ObjsNextMotion(0, "チケットを下げるL", 6)
	event.ObjsMotionWait(0)
	event.ObjsResetMotion(0)
	event.ObjsSetMotion(0, "チケットを下げるL", 6)
	event.ObjsMotionWait(0)
	event.ObjsResetMotion(0)
	event.ObjsSetMotion(0, "チケットを下げるL", 6)
	event.ObjsNextMotion(0, "チケット持ち立ち", 4)
	event.ObjsSeDelay(0, 29)
	event.ObjsSePlay(0, var0, 14)
	event.ObjsSeDelay(0, 20)
	event.ObjsSePlay(0, var0, 14)
	event.ObjsSeDelay(0, 20)
	event.ObjsSePlay(0, var0, 14)
	event.ObjsSetMotion(2, "チケットを下げる", 6)
	event.ObjsNextMotion(2, "チケットを下げるL", 6)
	event.ObjsMotionWait(2)
	event.ObjsResetMotion(2)
	event.ObjsSetMotion(2, "チケットを下げるL", 6)
	event.ObjsMotionWait(2)
	event.ObjsResetMotion(2)
	event.ObjsSetMotion(2, "チケットを下げるL", 6)
	event.ObjsNextMotion(2, "チケット持ち立ち", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_f1cdfb4a(10093, -1, 10)
	if vm.skipping() then
		return skip(22)
	end
	event.ResetPakuAnim()
	helper_a19c5ee3(0)
	if vm.skipping() then
		return skip(23)
	end
	helper_a19c5ee3(2)
	if vm.skipping() then
		return skip(24)
	end
	helper_a0e17f3c(10)
	if vm.skipping() then
		return skip(25)
	end
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "目パチ")
	event.CmrsSetPos(80.37, 85.61, 4.61)
	event.CmrsSetRef(43.5, 68.19, 91.7)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.ObjsSetMotion(0, "チケットをなおす", 6)
	event.ObjsMotionWait(0)
	event.ObjsSetMotion(2, "チケットをなおす", 6)
	event.ObjsNextMotion(0, "旧・立ち", 4)
	event.ObjsSeDelay(0, 10)
	event.ObjsSePlay(0, var0, 15)
	helper_a0e17f3c(10)
	if vm.skipping() then
		return skip(26)
	end
	event.CharaActive(0, 10)
	event.SetPakuAnim(1, "口パク")
	helper_f1cdfb4a(10100, -1, 10)
	if vm.skipping() then
		return skip(27)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(1, "座り会話", 2)
	event.ObjsNextMotion(1, "座りL", 4)
	event.SetPakuAnim(1, "口パク")
	helper_f1cdfb4a(10105, -1, 10)
	if vm.skipping() then
		return skip(28)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(0, "会話", 2)
	event.ObjsNextMotion(0, "立ち", 4)
	helper_f1cdfb4a(10110, -1, 10)
	if vm.skipping() then
		return skip(29)
	end
	event.ObjsMotionDelay(1, 30)
	event.ObjsSetMotion(1, "座り会話", 2)
	event.ObjsNextMotion(1, "座りL", 4)
	event.SetPakuAnim(1, "口パク")
	helper_f1cdfb4a(10120, -1, 10)
	if vm.skipping() then
		return skip(30)
	end
	event.ResetPakuAnim()
	helper_f1cdfb4a(10130, -1, 10)
	if vm.skipping() then
		return skip(31)
	end
	event.CmrsSetPos(48.26, 82.5, 80.04)
	event.CmrsSetRef(4.98, 82.5, 112.14)
	event.ObjsSetMotion(1, "気づく", 6)
	event.ObjsNextMotion(1, "気づくL", 4)
	event.SetPakuAnim(1, "口パク")
	helper_f1cdfb4a(10140, -1, 10)
	if vm.skipping() then
		return skip(32)
	end
	event.ResetPakuAnim()
	helper_a19c5ee3(1)
	if vm.skipping() then
		return skip(33)
	end
	event.CmrsSetPos(44.63, 77.24, 83.23)
	event.CmrsSetRef(70.09, 77.44, 63.46)
	event.CharaDaEnable(0, 0)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "目パチ")
	event.ObjsSetMotion(0, "アトラミリアを持つ", 6)
	event.ObjsNextMotion(0, "アトラミリアを持つL", 4)
	event.ObjsSeDelay(0, 30)
	event.ObjsSePlay(0, var0, 16)
	event.SetPakuAnim(0, "通常口パク")
	helper_f1cdfb4a(10150, -1, 10)
	if vm.skipping() then
		return skip(34)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(0, "通常口パク")
	helper_f1cdfb4a(10153, -1, 10)
	if vm.skipping() then
		return skip(35)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(0, "通常口パク")
	helper_f1cdfb4a(10156, -1, 10)
	if vm.skipping() then
		return skip(36)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(0, "立ち", 4)
	event.CharaDaEnable(0, 1)
	event.CmrsSetPos(40.2, 84.58, 86.02)
	event.CmrsSetRef(4.98, 83.75, 112.14)
	event.CmrsMove2(33.73, 84.71, 90.82, 4.98, 83.75, 112.14, 60, 2, 1.0)
	event.SetPakuAnim(1, "口パク")
	helper_f1cdfb4a(10160, -1, 10)
	if vm.skipping() then
		return skip(37)
	end
	event.ResetPakuAnim()
	helper_b35e85eb()
	if vm.skipping() then
		return skip(38)
	end
	event.CmrsSetPos(80.37, 85.61, 4.61)
	event.CmrsSetRef(43.5, 68.19, 91.7)
	event.ObjsSetMotion(1, "座りL", 4)
	event.ObjsSetMotion(0, "旧・立ち", 4)
	helper_f1cdfb4a(10170, -1, 10)
	if vm.skipping() then
		return skip(39)
	end
	event.ObjsSetMotion(1, "座り会話", 2)
	event.ObjsNextMotion(1, "座りL", 4)
	event.SetPakuAnim(1, "口パク")
	helper_f1cdfb4a(10180, -1, 10)
	if vm.skipping() then
		return skip(40)
	end
	event.ResetPakuAnim()
	event.ObjsMotionDelay(1, 40)
	event.ObjsSetMotion(1, "奥を指す", 2)
	event.ObjsNextMotion(1, "奥を指すL", 6)
	event.ObjsMotionWait(1)
	event.ObjsResetMotion(1)
	event.ObjsSetMotion(1, "奥を指すL", 6)
	event.ObjsNextMotion(1, "座りL")
	event.ObjsChengeStep(1, 0.1)
	event.SetPakuAnim(1, "口パク")
	helper_f1cdfb4a(10190, -1, 10)
	if vm.skipping() then
		return skip(41)
	end
	event.ResetPakuAnim()
	helper_a19c5ee3(1)
	if vm.skipping() then
		return skip(42)
	end
	event.ObjsSetMotion(0, "うなづく", 2)
	event.ObjsNextMotion(0, "旧・立ち", 4)
	event.ObjsSeDelay(0, 16)
	event.ObjsSePlay(0, var0, 17)
	helper_f1cdfb4a(10200, -1, 10)
	if vm.skipping() then
		return skip(43)
	end
	helper_a19c5ee3(0)
	if vm.skipping() then
		return skip(44)
	end
	event.FadeOutBgm(30)
	event.SetFadeOut(30)
	helper_a0e17f3c(30)
	if vm.skipping() then
		return skip(45)
	end
	return part2()
end

return helper_447ed33f
