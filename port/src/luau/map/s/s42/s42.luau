--!strict
-- map/s/s42/s42.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_025d5797 = require("@lib/event/helper_025d5797")
local helper_09fd1f10 = require("@lib/event/helper_09fd1f10")
local helper_29a88422 = require("@lib/event/helper_29a88422")
local helper_2d88bb14 = require("@lib/event/helper_2d88bb14")
local helper_387dadc7 = require("@lib/event/helper_387dadc7")
local helper_56a731b3 = require("@lib/event/helper_56a731b3")
local helper_6dfa44e2 = require("@lib/event/helper_6dfa44e2")
local helper_71fa1d07 = require("@lib/event/helper_71fa1d07")
local helper_7a5e82c7 = require("@lib/event/helper_7a5e82c7")
local helper_91637685 = require("@lib/event/helper_91637685")
local helper_b681f72a = require("@lib/event/helper_b681f72a")
local helper_ce9f4b33 = require("@lib/event/helper_ce9f4b33")
local helper_d9c15850 = require("@lib/event/helper_d9c15850")

--- Helper function.
local function helper_84f8(arg0: s32, arg1: any, arg2: s32, arg3: s32, arg4: s32)
	local var6: s32 = 0
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		helper_09fd1f10(arg0)
	end
	local _ = helper_91637685(arg0, arg1, arg2, arg3, arg4)
	_, var6 = helper_56a731b3(arg0, 0, var6)
	if vm.skipping() then
		return skip(1)
	end
	helper_09fd1f10(arg0)
end

--- Helper function.
local function helper_db58()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			helper_6dfa44e2(10)
		end
	end
	event.Initialize()
	event.SetMotion(0, "立ち")
	event.SetFadeOut(10)
	helper_6dfa44e2(10)
	if vm.skipping() then
		return skip(1)
	end
	event.GotoMenu(7)
	if vm.wait() then
		return skip(2)
	end
	event.SetFadeIn(10)
	helper_6dfa44e2(10)
	if vm.skipping() then
		return skip(3)
	end
end

--- Helper function.
local function helper_e854()
	local var0: s32 = 0
	local var1: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 47 then
			if at <= 1 then
				helper_71fa1d07()
			end
			if at <= 2 then
				helper_d9c15850(0)
			end
			if at <= 3 then
				helper_6dfa44e2(4)
			end
			if at <= 4 then
				helper_6dfa44e2(120)
			end
			if at <= 6 then
				helper_025d5797(10050, 120)
			end
			if at <= 7 then
				helper_d9c15850(0)
			end
			if at <= 8 then
				helper_71fa1d07()
			end
			if at <= 9 then
				helper_025d5797(10060, 80)
			end
			if at <= 10 then
				helper_d9c15850(0)
			end
			if at <= 11 then
				helper_d9c15850(1)
			end
			if at <= 12 then
				helper_71fa1d07()
			end
			if at <= 13 then
				helper_025d5797(10070, 40)
			end
			if at <= 14 then
				helper_025d5797(10075, 34)
			end
			if at <= 15 then
				helper_71fa1d07()
			end
			if at <= 16 then
				helper_d9c15850(0)
			end
			if at <= 17 then
				helper_6dfa44e2(30)
			end
			if at <= 18 then
				helper_025d5797(10080, 30)
			end
			if at <= 19 then
				helper_d9c15850(0)
			end
			if at <= 20 then
				helper_d9c15850(2)
			end
			if at <= 21 then
				helper_025d5797(10090, 34)
			end
			if at <= 22 then
				helper_025d5797(10093, 80)
			end
			if at <= 23 then
				helper_025d5797(10096, 60)
			end
			if at <= 24 then
				helper_d9c15850(0)
			end
			if at <= 25 then
				helper_d9c15850(2)
			end
			if at <= 26 then
				helper_6dfa44e2(10)
			end
			if at <= 27 then
				helper_6dfa44e2(10)
			end
			if at <= 28 then
				helper_025d5797(10100, 70)
			end
			if at <= 29 then
				helper_025d5797(10105, 100)
			end
			if at <= 30 then
				helper_025d5797(10110, 40)
			end
			if at <= 31 then
				helper_025d5797(10120, 130)
			end
			if at <= 32 then
				helper_025d5797(10130, 30)
			end
			if at <= 33 then
				helper_025d5797(10140, 180)
			end
			if at <= 34 then
				helper_d9c15850(1)
			end
			if at <= 35 then
				helper_025d5797(10150, 60)
			end
			if at <= 36 then
				helper_025d5797(10153, 120)
			end
			if at <= 37 then
				helper_025d5797(10156, 100)
			end
			if at <= 38 then
				helper_025d5797(10160, 100)
			end
			if at <= 39 then
				helper_71fa1d07()
			end
			if at <= 40 then
				helper_025d5797(10170, 40)
			end
			if at <= 41 then
				helper_025d5797(10180, 70)
			end
			if at <= 42 then
				helper_025d5797(10190, 120)
			end
			if at <= 43 then
				helper_d9c15850(1)
			end
			if at <= 44 then
				helper_025d5797(10200, 60)
			end
			if at <= 45 then
				helper_d9c15850(0)
			end
			if at <= 46 then
				helper_6dfa44e2(30)
			end
			if vm.skip_end() then
				return skip(48)
			end
			return part2()
		end
		if at <= 48 then
			helper_6dfa44e2(6)
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
		helper_6dfa44e2(6)
		if vm.skipping() then
			return skip(49)
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
	event.LoadMes(0, 5, "event/opening/p1/op1ch2.txt")
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
	helper_6dfa44e2(5)
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
	helper_71fa1d07()
	if vm.skipping() then
		return skip(2)
	end
	helper_d9c15850(0)
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsSetMotion(0, "旧・立ち")
	helper_6dfa44e2(4)
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
	helper_6dfa44e2(120)
	if vm.skipping() then
		return skip(5)
	end
	if vm.wait() then
		return skip(6)
	end
	event.SetPakuAnim(0, "通常口パク", "うひゃ～口")
	helper_025d5797(10050, 120)
	if vm.skipping() then
		return skip(7)
	end
	event.ResetPakuAnim()
	helper_d9c15850(0)
	if vm.skipping() then
		return skip(8)
	end
	helper_71fa1d07()
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
	helper_025d5797(10060, 80)
	if vm.skipping() then
		return skip(10)
	end
	event.ResetPakuAnim()
	helper_d9c15850(0)
	if vm.skipping() then
		return skip(11)
	end
	helper_d9c15850(1)
	if vm.skipping() then
		return skip(12)
	end
	helper_71fa1d07()
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
	helper_025d5797(10070, 40)
	if vm.skipping() then
		return skip(14)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(0, "通常口パク")
	helper_025d5797(10075, 34)
	if vm.skipping() then
		return skip(15)
	end
	event.ResetPakuAnim()
	helper_71fa1d07()
	if vm.skipping() then
		return skip(16)
	end
	helper_d9c15850(0)
	if vm.skipping() then
		return skip(17)
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
	helper_6dfa44e2(30)
	if vm.skipping() then
		return skip(18)
	end
	event.CmrsSetPos(46.78, 79.2, 81.62)
	event.CmrsSetRef(70.26, 79.2, 63.68)
	event.SetPakuAnim(0, "通常口パク")
	helper_025d5797(10080, 30)
	if vm.skipping() then
		return skip(19)
	end
	event.ResetPakuAnim()
	helper_d9c15850(0)
	if vm.skipping() then
		return skip(20)
	end
	helper_d9c15850(2)
	if vm.skipping() then
		return skip(21)
	end
	event.ObjsChengeStep(1)
	event.SetPakuAnim(0, "通常口パク")
	helper_025d5797(10090, 34)
	if vm.skipping() then
		return skip(22)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(0, "通常口パク")
	helper_025d5797(10093, 80)
	if vm.skipping() then
		return skip(23)
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
	event.SetPakuAnim(0, "笑い口パク", "うれし口")
	helper_025d5797(10096, 60)
	if vm.skipping() then
		return skip(24)
	end
	event.ResetPakuAnim()
	helper_d9c15850(0)
	if vm.skipping() then
		return skip(25)
	end
	helper_d9c15850(2)
	if vm.skipping() then
		return skip(26)
	end
	helper_6dfa44e2(10)
	if vm.skipping() then
		return skip(27)
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
	helper_6dfa44e2(10)
	if vm.skipping() then
		return skip(28)
	end
	event.CharaActive(0, 10)
	event.SetPakuAnim(1, "口パク")
	helper_025d5797(10100, 70)
	if vm.skipping() then
		return skip(29)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(1, "座り会話", 2)
	event.ObjsNextMotion(1, "座りL", 4)
	event.SetPakuAnim(1, "口パク")
	helper_025d5797(10105, 100)
	if vm.skipping() then
		return skip(30)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(0, "会話", 2)
	event.ObjsNextMotion(0, "立ち", 4)
	helper_025d5797(10110, 40)
	if vm.skipping() then
		return skip(31)
	end
	event.ObjsMotionDelay(1, 30)
	event.ObjsSetMotion(1, "座り会話", 2)
	event.ObjsNextMotion(1, "座りL", 4)
	event.SetPakuAnim(1, "口パク")
	helper_025d5797(10120, 130)
	if vm.skipping() then
		return skip(32)
	end
	event.ResetPakuAnim()
	helper_025d5797(10130, 30)
	if vm.skipping() then
		return skip(33)
	end
	event.CmrsSetPos(48.26, 82.5, 80.04)
	event.CmrsSetRef(4.98, 82.5, 112.14)
	event.ObjsSetMotion(1, "気づく", 6)
	event.ObjsNextMotion(1, "気づくL", 4)
	event.SetPakuAnim(1, "口パク")
	helper_025d5797(10140, 180)
	if vm.skipping() then
		return skip(34)
	end
	event.ResetPakuAnim()
	helper_d9c15850(1)
	if vm.skipping() then
		return skip(35)
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
	helper_025d5797(10150, 60)
	if vm.skipping() then
		return skip(36)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(0, "通常口パク")
	helper_025d5797(10153, 120)
	if vm.skipping() then
		return skip(37)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(0, "通常口パク")
	helper_025d5797(10156, 100)
	if vm.skipping() then
		return skip(38)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(0, "立ち", 4)
	event.CharaDaEnable(0, 1)
	event.CmrsSetPos(40.2, 84.58, 86.02)
	event.CmrsSetRef(4.98, 83.75, 112.14)
	event.CmrsMove2(33.73, 84.71, 90.82, 4.98, 83.75, 112.14, 60, 2, 1.0)
	event.SetPakuAnim(1, "口パク")
	helper_025d5797(10160, 100)
	if vm.skipping() then
		return skip(39)
	end
	event.ResetPakuAnim()
	helper_71fa1d07()
	if vm.skipping() then
		return skip(40)
	end
	event.CmrsSetPos(80.37, 85.61, 4.61)
	event.CmrsSetRef(43.5, 68.19, 91.7)
	event.ObjsSetMotion(1, "座りL", 4)
	event.ObjsSetMotion(0, "旧・立ち", 4)
	helper_025d5797(10170, 40)
	if vm.skipping() then
		return skip(41)
	end
	event.ObjsSetMotion(1, "座り会話", 2)
	event.ObjsNextMotion(1, "座りL", 4)
	event.SetPakuAnim(1, "口パク")
	helper_025d5797(10180, 70)
	if vm.skipping() then
		return skip(42)
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
	helper_025d5797(10190, 120)
	if vm.skipping() then
		return skip(43)
	end
	event.ResetPakuAnim()
	helper_d9c15850(1)
	if vm.skipping() then
		return skip(44)
	end
	event.ObjsSetMotion(0, "うなづく", 2)
	event.ObjsNextMotion(0, "旧・立ち", 4)
	event.ObjsSeDelay(0, 16)
	event.ObjsSePlay(0, var0, 17)
	helper_025d5797(10200, 60)
	if vm.skipping() then
		return skip(45)
	end
	helper_d9c15850(0)
	if vm.skipping() then
		return skip(46)
	end
	event.FadeOutBgm(30)
	event.SetFadeOut(30)
	helper_6dfa44e2(30)
	if vm.skipping() then
		return skip(47)
	end
	return part2()
end

--- Helper function.
local function helper_78c0(arg0: s32, arg1: any, arg2: s32, arg3: s32, arg4: s32, arg5: s32, arg6: s32)
	local var8: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			local _ = helper_91637685(arg0, arg1, arg2, arg3, arg4)
			var8 = helper_ce9f4b33(arg0, arg5, arg6, 0)
		end
		return var8
	end
	if vm.skipping() then
		return skip(1)
	end
	local _ = helper_91637685(arg0, arg1, arg2, arg3, arg4)
	var8 = helper_ce9f4b33(arg0, arg5, arg6, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.SetMesPos(arg0, 0)
	return var8
end

--- Helper function.
local function helper_12ec0()
	local var0: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 14 then
			if at <= 1 then
				helper_71fa1d07()
			end
			if at <= 2 then
				helper_6dfa44e2(4)
			end
			if at <= 3 then
				helper_71fa1d07()
			end
			if at <= 4 then
				helper_025d5797(10210, 40)
			end
			if at <= 5 then
				helper_025d5797(10220, 140)
			end
			if at <= 6 then
				helper_d9c15850(0)
			end
			if at <= 7 then
				helper_025d5797(10230, 106)
			end
			if at <= 8 then
				helper_d9c15850(0)
			end
			if at <= 9 then
				helper_6dfa44e2(30)
			end
			if at <= 10 then
				helper_025d5797(10233, 160)
			end
			if at <= 11 then
				helper_6dfa44e2(30)
			end
			if at <= 12 then
				helper_025d5797(10236, 60)
			end
			if at <= 13 then
				helper_71fa1d07()
			end
			if vm.skip_end() then
				return skip(15)
			end
			return part2()
		end
		if at <= 15 then
			helper_6dfa44e2(6)
		end
	end
	function part2()
		event.CancelDramaScene()
		event.StreamClose(1)
		event.EohSetFootSoundId(0, -1)
		event.DelExtMotion(0)
		event.DeleteChara(9)
		event.LoadMes(0, -1)
		event.EohSetShow(7, 0)
		event.EohSetShow(8, 1)
		event.EohSetShow(9, 0)
		event.EohSetShow(10, 1)
		event.StopEnvBgm()
		event.StopBgm(0)
		helper_6dfa44e2(6)
		if vm.skipping() then
			return skip(16)
		end
		event.BgmLoadCancel()
		event.SoundLoadCancel()
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	event.InitDramaScene()
	event.SetMesWindowMode(0, 7)
	event.SetMotion(0, "立ち")
	event.CmrsInit()
	event.CmrsFadeInit()
	event.CmrsFadeOut(30)
	helper_71fa1d07()
	if vm.skipping() then
		return skip(2)
	end
	event.StopBgm(0)
	helper_6dfa44e2(4)
	if vm.skipping() then
		return skip(3)
	end
	event.LoadBgm(101)
	event.PlayBgm(0, -1)
	event.LoadSound(1203)
	event.AssignStack(5)
	event.ClearStack(5)
	event.LoadMes(0, 5, "event/opening/p1/op1ch3.txt")
	var0 = event.SndLoadSound(1203) or var0
	event.LoadMotion(5, "event/opening/p1/p1_mints2.gltf", "info", 0)
	event.CharaActive(0)
	event.EohSyncChara(0, 0)
	event.EohSetFootSoundId(0, 3)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetPos(0, 114.59, -0.02, -150.64)
	event.ObjsSetRot(0, 0.0, 1.57, 0.0)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "真剣な目")
	event.ObjsTexAnime(0, 1, "真剣な口")
	event.LoadChara(5, "event/opening/p1/kougu.gltf", "info", 9)
	event.CharaActive(0, 9)
	event.EohSyncChara(1, 9)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.ObjsSetPos(1, 114.59, -0.02, -150.64)
	event.ObjsSetRot(1, 0.0, 1.57, 0.0)
	event.ObjsSetMotion(1, "工具をかまえる", 5)
	event.EohSyncObj(2, "p10_i01h01")
	event.EohSetShow(2, 0)
	event.EohSyncObj(3, "p11_i01h01")
	event.EohSetShow(3, 0)
	event.EohSyncObj(4, "p12_i01h01")
	event.EohSetShow(4, 0)
	event.EohSyncObj(5, "p16_i01h01")
	event.EohSetShow(5, 0)
	event.EohSyncObj(6, "p17_i01h01")
	event.EohSetShow(6, 1)
	event.EohSyncObj(7, "p09_i01h01", "i01h01_19-m0")
	event.EohSetShow(7, 1)
	event.EohSyncObj(8, "p09_i01h01", "i01h01_20-m0")
	event.EohSetShow(8, 0)
	event.EohSyncObj(9, "p09_i01h01", "i01h01_19-m1")
	event.EohSetShow(9, 0)
	event.EohSyncObj(10, "p09_i01h01", "i01h01_20-m1")
	event.EohSetShow(10, 1)
	event.SetActiveLight(4)
	event.ObjsSetMotion(0, "いすに座る_s", 4)
	event.ObjsSePlay(0, var0, 18)
	event.CmrsSetPos(154.48, 32.42, -164.94)
	event.CmrsSetRef(118.46, 17.85, -145.84)
	event.CmrsFadeInit()
	event.CmrsFadeIn(30)
	helper_71fa1d07()
	if vm.skipping() then
		return skip(4)
	end
	event.SetPakuAnim(0, "通常口パク", "真剣な口")
	helper_025d5797(10210, 40)
	if vm.skipping() then
		return skip(5)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(0, "かばんをさぐる", 6)
	event.ObjsNextMotion(0, "かばんをさぐるL", 4)
	event.SetPakuAnim(0, "通常口パク", "真剣な口")
	helper_025d5797(10220, 140)
	if vm.skipping() then
		return skip(6)
	end
	event.ResetPakuAnim()
	helper_d9c15850(0)
	if vm.skipping() then
		return skip(7)
	end
	event.ObjsSetMotion(0, "工具をかまえる", 6)
	event.ObjsNextMotion(0, "工具をかまえるL", 4)
	event.ObjsSePlay(0, var0, 19)
	event.ObjsSeDelay(0, 10)
	event.ObjsSePlay(0, var0, 19)
	event.ObjsSeDelay(0, 10)
	event.ObjsSePlay(0, var0, 20)
	event.ObjsSeDelay(0, 20)
	event.ObjsSePlay(0, var0, 21)
	event.CharaActive(9)
	event.ObjsSetMotion(1, "工具をかまえる", 6)
	event.ObjsNextMotion(1, "工具をかまえるL", 4)
	event.SetPakuAnim(0, "通常口パク", "真剣な口")
	helper_025d5797(10230, 106)
	if vm.skipping() then
		return skip(8)
	end
	event.ResetPakuAnim()
	helper_d9c15850(0)
	if vm.skipping() then
		return skip(9)
	end
	event.ObjsSetMotion(0, "作業中", 6)
	event.ObjsSetMotion(1, "作業中", 6)
	event.ObjsNextMotion(0, "作業中2", 6)
	event.ObjsNextMotion(1, "作業中2", 6)
	event.ObjsNextMotion(0, "作業中", 6)
	event.ObjsNextMotion(1, "作業中", 6)
	event.ObjsNextMotion(0, "作業中2", 6)
	event.ObjsNextMotion(1, "作業中2", 6)
	event.ObjsNextMotion(0, "作業中", 6)
	event.ObjsNextMotion(1, "作業中", 6)
	event.ObjsSePlay(0, var0, 22)
	event.ObjsSeDelay(0, 20)
	event.ObjsSePlay(0, var0, 23)
	event.ObjsSeDelay(0, 20)
	event.ObjsSePlay(0, var0, 24)
	event.ObjsSeDelay(0, 20)
	event.ObjsSePlay(0, var0, 25)
	event.ObjsSeDelay(0, 80)
	event.ObjsSePlay(0, var0, 23)
	event.ObjsSeDelay(0, 40)
	event.ObjsSePlay(0, var0, 22)
	event.ObjsSeDelay(0, 20)
	event.ObjsSePlay(0, var0, 24)
	event.ObjsSeDelay(0, 20)
	event.ObjsSePlay(0, var0, 24)
	event.ObjsSeDelay(0, 20)
	event.ObjsSePlay(0, var0, 23)
	event.ObjsSeDelay(0, 40)
	event.CmrsSetPos(63.4, 45.38, -118.3)
	event.CmrsSetRef(118.98, 17.85, -149.19)
	event.CmrsMove(34.75, 60.8, -102.39, 118.98, 17.85, -149.19, 400)
	event.CmrsFadeDelay(340)
	event.CmrsFadeInit()
	event.CmrsFadeOut(60)
	helper_6dfa44e2(30)
	if vm.skipping() then
		return skip(10)
	end
	helper_025d5797(10233, 160)
	if vm.skipping() then
		return skip(11)
	end
	helper_6dfa44e2(30)
	if vm.skipping() then
		return skip(12)
	end
	helper_025d5797(10236, 60)
	if vm.skipping() then
		return skip(13)
	end
	event.FadeOutBgm(60)
	helper_71fa1d07()
	if vm.skipping() then
		return skip(14)
	end
	return part2()
end

--- Helper function.
local function helper_4f74(arg0: s32, arg1: any)
	local var2: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var3 = 0
			var2 = helper_2d88bb14(arg0, 0)
			var3 = var3 + 1
		end
		var3 = vm.i32(var3 + 1)
		helper_09fd1f10(arg0)
		return var3
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesOkuri(arg0, 0)
	event.TrgPakuAnim(1)
	event.TrgPakuMotion(0)
	var3 = 0
	while var3 < arg1 do
		var2 = helper_2d88bb14(arg0, 0)
		if var2 ~= 0 then
			var3 = vm.i32(var3 + 1)
			break
		else
			if vm.wait() then
				return skip(2)
			end
			var3 = vm.i32(var3 + 1)
		end
	end
	event.ResetPakuMotion()
	event.TrgPakuAnim(0)
	event.ResetPakuAnim()
	event.SetMesOkuri(arg0, 1)
	helper_09fd1f10(arg0)
	return var3
end

--- Helper function.
local function helper_80d8(arg0: s32, arg1: s32, arg2: s32, arg3: s32, arg4: s32, arg5: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			local _ = helper_91637685(arg0, arg1, arg2, arg3, arg4)
			local _ = helper_4f74(arg0, arg5)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	local _ = helper_91637685(arg0, arg1, arg2, arg3, arg4)
	local _ = helper_4f74(arg0, arg5)
	if vm.skipping() then
		return skip(2)
	end
	event.SetMesPos(arg0, 0)
end

--- Helper function.
local function helper_14e1c()
	local var0: s32 = 0
	local var1: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 16 then
			if at <= 1 then
				helper_6dfa44e2(240)
			end
			if at <= 2 then
				helper_71fa1d07()
			end
			if at <= 3 then
				helper_d9c15850(0)
			end
			if at <= 4 then
				helper_025d5797(10280, 140)
			end
			if at <= 5 then
				helper_025d5797(10285, 46)
			end
			if at <= 6 then
				helper_29a88422(1)
			end
			if at <= 7 then
				helper_d9c15850(0)
			end
			if at <= 8 then
				helper_d9c15850(0)
			end
			if at <= 9 then
				helper_80d8(0, -1, 8, 0, 0, 100)
			end
			if at <= 10 then
				helper_d9c15850(0)
			end
			if at <= 11 then
				helper_025d5797(10295, 60)
			end
			if at <= 12 then
				helper_d9c15850(0)
			end
			if at <= 13 then
				helper_6dfa44e2(10)
			end
			if at <= 14 then
				helper_6dfa44e2(30)
			end
			if at <= 15 then
				helper_71fa1d07()
			end
			if vm.skip_end() then
				return skip(17)
			end
			return part2()
		end
		if at <= 17 then
			helper_6dfa44e2(6)
		end
	end
	function part2()
		event.CancelDramaScene()
		event.EohSetTexAnim(0, 0)
		event.EohSetTexAnim(0, 1, "目パチ")
		event.EohSetTexAnim(1, 0)
		event.EohSetTexAnim(1, 1, "目パチ")
		event.StreamClose(1)
		event.LoadMes(0, -1)
		event.EohSetFootSoundId(0, -1)
		event.DelExtMotion(0)
		event.DeleteChara(9)
		event.EohSetPos(4, 0.0, 0.0, 0.0)
		event.EohSetPos(5, 0.0, 0.0, 0.0)
		event.EohSetShow(5, 1)
		event.EohSetShow(11, 0)
		event.EohSetShow(12, 1)
		event.EohSetShow(13, 0)
		event.EohSetShow(14, 1)
		event.StopBgm(0)
		event.StopEnvBgm()
		helper_6dfa44e2(6)
		if vm.skipping() then
			return skip(18)
		end
	end
	event.Initialize()
	event.InitDramaScene()
	event.SetMesWindowMode(0, 7)
	event.SetTime(24.0)
	event.SetTimeStepEnable(0)
	event.SetActiveLight(2)
	event.LoadBgm(46)
	event.PlayBgm(0, -1)
	event.LoadSound(1205)
	event.PlayEnvBgm(2)
	event.AssignStack(5)
	event.ClearStack(5)
	event.LoadMes(0, 5, "event/opening/p1/op1ch5.txt")
	var0 = event.SndLoadSound(1205) or var0
	event.LoadMotion(5, "event/opening/p1/p1_mints3.gltf", "info", 0)
	event.CharaActive(0)
	event.EohSyncChara(0, 0)
	event.EohSetFootSoundId(0, 3)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetPos(0, 117.75, -0.02, -149.55)
	event.ObjsSetRot(0, 0.0, 1.57, 0.0)
	event.ObjsSetMotion(0, "眠りL", 4)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "眠り目")
	event.ObjsTexAnime(0, 1, "眠り口")
	event.LoadChara(5, "event/opening/p1/clock.gltf", "info", 9)
	event.CharaActive(9)
	event.EohSyncChara(1, 9)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.ObjsSetPos(1, 117.75, -0.02, -149.55)
	event.ObjsSetRot(1, 0.0, 1.57, 0.0)
	event.ObjsSetMotion(1, "眠りL", 4)
	event.EohSyncObj(4, "p14_i01h01")
	event.EohSetShow(4, 1)
	event.EohSetPos(4, 6.0, 0.0, -6.0)
	event.EohSyncObj(5, "p15_i01h01")
	event.EohSetShow(5, 0)
	event.EohSyncObj(6, "p10_i01h01")
	event.EohSetShow(6, 0)
	event.EohSyncObj(7, "p11_i01h01")
	event.EohSetShow(7, 0)
	event.EohSyncObj(8, "p12_i01h01")
	event.EohSetShow(8, 1)
	event.EohSyncObj(9, "p16_i01h01")
	event.EohSetShow(9, 0)
	event.EohSyncObj(10, "p17_i01h01")
	event.EohSetShow(10, 0)
	event.EohSyncObj(11, "p09_i01h01", "i01h01_19-m0")
	event.EohSetShow(11, 1)
	event.EohSyncObj(12, "p09_i01h01", "i01h01_20-m0")
	event.EohSetShow(12, 0)
	event.EohSyncObj(13, "p09_i01h01", "i01h01_19-m1")
	event.EohSetShow(13, 0)
	event.EohSyncObj(14, "p09_i01h01", "i01h01_20-m1")
	event.EohSetShow(14, 1)
	event.StreamOpen3(1, 10275)
	helper_29a88422(1)
	if vm.skipping() then
		return skip(1)
	end
	event.StreamPlay(1)
	event.ObjsSeDelay(0, 40)
	event.ObjsSePlay(0, var0, 33)
	event.ObjsSeDelay(0, 80)
	event.ObjsSePlay(0, var0, 33)
	event.ObjsSeDelay(0, 70)
	event.ObjsSePlay(0, var0, 33)
	event.CmrsInit()
	event.CmrsSetPos(65.26, 55.35, -105.97)
	event.CmrsSetRef(122.66, 18.15, -147.06)
	event.CmrsMove(83.15, 42.11, -118.77, 122.66, 18.15, -147.06, 300)
	event.CmrsFadeInit()
	event.CmrsFadeIn(120)
	helper_6dfa44e2(240)
	if vm.skipping() then
		return skip(2)
	end
	event.ObjsSetMotion(0, "起きる", 6)
	event.ObjsNextMotion(0, "起きるL", 4)
	event.ObjsSePlay(0, var0, 34)
	event.ObjsSeDelay(0, 58)
	event.ObjsSePlay(0, var0, 35)
	event.ObjsSetMotion(1, "起きる", 6)
	event.ObjsNextMotion(1, "起きるL", 4)
	helper_71fa1d07()
	if vm.skipping() then
		return skip(3)
	end
	helper_d9c15850(0)
	if vm.skipping() then
		return skip(4)
	end
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "しまった目1")
	event.StreamClose(1)
	event.SetPakuAnim(0, "通常口パク", "しまった口")
	helper_025d5797(10280, 140)
	if vm.skipping() then
		return skip(5)
	end
	event.ResetPakuAnim()
	event.CmrsSetPos(140.85, 35.61, -112.8)
	event.CmrsSetRef(124.35, 18.15, -148.12)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "しまった目2")
	event.ObjsSetMotion(0, "時計を見る", 6)
	event.ObjsNextMotion(0, "時計を見るL", 4)
	event.ObjsSetMotion(1, "時計を見る", 6)
	event.ObjsNextMotion(1, "時計を見るL", 4)
	event.ObjsSeDelay(0, 10)
	event.ObjsSePlay(0, var0, 36)
	event.SetPakuAnim(0, "通常口パク", "しまった口")
	helper_025d5797(10285, 46)
	if vm.skipping() then
		return skip(6)
	end
	event.ResetPakuAnim()
	event.StreamOpen3(1, 10290)
	helper_29a88422(1)
	if vm.skipping() then
		return skip(7)
	end
	helper_d9c15850(0)
	if vm.skipping() then
		return skip(8)
	end
	event.StreamPlay(1)
	event.ObjsSetMotion(0, "立ち上がる", 6)
	event.ObjsMotionWait(0)
	event.ObjsSetMotion(1, "立ち上がる", 6)
	event.ObjsSePlay(0, var0, 37)
	helper_d9c15850(0)
	if vm.skipping() then
		return skip(9)
	end
	event.EohSetFootSoundId(0, 10)
	event.ObjsSetMotion(0, "走り", 4)
	event.ObjsInitPas(0)
	event.ObjsSetPasFrm(0, 100)
	event.ObjsAddPas(0, 134.46, -1.98, -103.03)
	event.ObjsAddPas(0, 123.03, -1.98, -87.26)
	event.ObjsAddPas(0, 101.92, 11.36, -89.62)
	event.ObjsAddPas(0, 82.14, 19.76, -87.16)
	event.ObjsAddPas(0, 73.3, 23.58, -87.13)
	event.ObjsAddPas(0, 50.27, 23.58, -84.67)
	event.ObjsAddPas(0, 46.6, 23.58, -75.68)
	event.ObjsAddPas(0, 52.24, 23.58, -61.6)
	event.ObjsAddPas(0, 65.4, 31.9, -58.93)
	event.ObjsAddPas(0, 75.19, 34.77, -60.48)
	event.ObjsAddPas(0, 90.17, 44.07, -59.42)
	event.ObjsAddPas(0, 103.03, 49.87, -58.95)
	event.ObjsAddPas(0, 114.25, 49.87, -45.23)
	event.ObjsAddPas(0, 115.21, 49.87, -24.8)
	event.ObjsStartPas(0)
	event.CmrsSetPos(84.39, 41.53, -180.36)
	event.CmrsSetRef(100.27, 28.67, -69.26)
	event.CmrsMove(25.83, 93.33, -175.38, 84.03, 62.87, -63.53, 100)
	event.ObjsTexAnime(0, 0, "しまった口")
	event.SetPakuAnim(0, "通常口パク")
	event.MesMake_2(0, 10290)
	helper_80d8(0, -1, 8, 0, 0, 100)
	if vm.skipping() then
		return skip(10)
	end
	event.ResetPakuAnim()
	event.StreamClose(1)
	helper_d9c15850(0)
	if vm.skipping() then
		return skip(11)
	end
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "怒り目")
	event.CmrsSetPos(107.28, 133.46, -74.73)
	event.CmrsSetRef(67.71, 60.83, 92.76)
	event.EohSetFootSoundId(0, 3)
	event.ObjsSetMotion(0, "右向き走り", 4)
	event.ObjsMotionDelay(0, 60)
	event.ObjsSetMotion(0, "走り", 4)
	event.ObjsInitPas(0)
	event.ObjsSetPasFrm(0, 80)
	event.ObjsAddPas(0, 113.58, 51.83, -23.73)
	event.ObjsAddPas(0, 99.94, 56.88, 2.25)
	event.ObjsAddPas(0, 92.02, 56.87, 52.46)
	event.ObjsAddPas(0, 93.75, 56.87, 104.26)
	event.ObjsAddPas(0, 96.64, 51.0, 131.42)
	event.ObjsStartPas(0)
	event.CmrsAhddelay(20)
	event.CmrsSyncObj(0, 0.0, 23.0, 0.0, -1.0, 0.0, 40.0)
	event.CmrsAhddelay(40)
	event.CmrsReleaseObj()
	event.CmrsPrdelay(60)
	event.CmrsSetPos(45.96, 119.76, 60.89)
	event.CmrsSetRef(100.02, 63.83, 140.46)
	event.SetPakuAnim(0, "通常口パク", "怒り口")
	helper_025d5797(10295, 60)
	if vm.skipping() then
		return skip(12)
	end
	event.ResetPakuAnim()
	helper_d9c15850(0)
	if vm.skipping() then
		return skip(13)
	end
	event.ObjsSetMotion(0, "立ち")
	helper_6dfa44e2(10)
	if vm.skipping() then
		return skip(14)
	end
	event.ObjsSetMotion(0, "ドア開け", 6)
	event.ObjsSeDelay(0, 20)
	var1 = event.GetSndId(2) or var1
	event.ObjsSePlay(0, var1, 66)
	helper_6dfa44e2(30)
	if vm.skipping() then
		return skip(15)
	end
	event.FadeOutBgm(30)
	event.CmrsFadeInit()
	event.CmrsFadeOut(30)
	helper_71fa1d07()
	if vm.skipping() then
		return skip(16)
	end
	return part2()
end

--- Helper function.
local function helper_7e64(arg0: s32, arg1: any, arg2: any, arg3: s32, arg4: any)
	local var5: s32 = 0
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_b681f72a(arg0, arg1, arg2, arg3)
		end
		if at <= 2 then
			_, var5 = helper_56a731b3(arg0, 0, var5)
		end
		helper_09fd1f10(arg0)
	end
	if vm.skipping() then
		return skip(1)
	end
	helper_b681f72a(arg0, arg1, arg2, arg3)
	if vm.skipping() then
		return skip(2)
	end
	_, var5 = helper_56a731b3(arg0, 0, var5)
	if vm.skipping() then
		return skip(3)
	end
	helper_09fd1f10(arg0)
end

--- Helper function.
local function helper_e0a8()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var4: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local yaw: f32 = 0
	local var14: s32 = 0
	local var15: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_7e64(0, -1, 9, 0, 0)
		end
	end
	event.Initialize()
	event.SetMesWindowMode(0, 1)
	event.SetMesShippo(0, 1)
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.EohSyncChara(1, 9)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	do
		local out1, out2, out3 = event.GetCharaPos(0)
		var0 = out1 or var0
		var1 = out2 or var1
		var2 = out3 or var2
	end
	do
		local _, out2, _ = event.GetCharaRot(0)
		var4 = out2 or var4
	end
	do
		local out1, out2, out3 = event.GetCharaPos(9)
		var6 = out1 or var6
		var7 = out2 or var7
		var8 = out3 or var8
	end
	event.GetCharaRot(9)
	yaw = event.GetRefAngle(var0, var1, var2, var6, var7, var8) or yaw
	event.GetRefAngle(var6, var7, var8, var0, var1, var2)
	var14 = 0
	var15 = event.AngleCmp(var4, yaw, 0.1) or var15
	if var15 ~= 0 then
		event.ObjsRotation(0, 0.0, yaw, 0.0, 10)
		event.ObjsSetMotion(0, "歩き")
		event.ObjsMotionDelay(0, 10)
		var14 = 20
	end
	event.ObjsSetMotion(0, "立ち")
	helper_6dfa44e2(var14)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, "下の机の上に置いてある。頼んだぞ。")
	helper_7e64(0, -1, 9, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_c78c(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local argc: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_7a5e82c7(1, 4)
			var2 = -1
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(1, 4)
	helper_7a5e82c7(1, 4)
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
	helper_84f8(1, var2, 8, 0, 0)
	if vm.skipping() then
		return skip(2)
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
	helper_387dadc7()
	event.CheckMcLoad()
	event.SetTimeStepEnable(0)
	event.SetCharaPos(0, 49.9, 24.7, -68.2)
	event.SetCharaRot(0, 0.0, 0.0, 0.0)
	event.SetMotion(0, "立ち", 4)
	event.CharaNormalDrive(0)
	event.CharaResetDa(0)
end

--- Program 150.
-- Defined empty, so the engine runs this instead of its default.
script[150] = function() end

--- Program 200.
script[200] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	event.SetMotion(0, "立ち")
	event.SetMesWindowMode(0, 1)
	event.SetMesShippo(0, 0)
	event.MesMake_2(0, "スターブルから頼まれた\n仕事がまだ終わっていない。")
	helper_84f8(0, -1, 5, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 400.
script[400] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_db58()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 500.
script[500] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetCnt(5, 0)
	helper_e854()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 501.
script[501] = function()
	local var0: s32 = 0
	local argc: s32 = 0
	local var2: any = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	local landing1: () -> ...any
	function skip(at: number)
		if at <= 1 then
			var2 = helper_78c0(0, -1, 5, 256, 208, 2, 1)
		end
		if at <= 2 then
			var0 = 1
			var2 = helper_78c0(0, -1, 5, 256, 208, 2, 1)
		end
		if at <= 3 then
			var0 = 1
			helper_12ec0()
			if not vm.skipping() then
				return landing1()
			end
		end
	end
	function part2() end
	function landing1()
		event.MapJump(-1, "m06", 151)
		return part2()
	end
	event.Initialize()
	event.SetMotion(0, "立ち")
	var0 = 0
	event.SetMesWindowMode(0, 1)
	event.SetMesShippo(0, 0)
	event.SetMesQuestionGyou(0, 0)
	argc = event.GetItemHaveNum(382) or argc
	if argc <= 0 then
		event.MesMake_2(0, "えぇっと、確か修理工具は\n奥のタンスに入れてたっけ。")
		helper_84f8(0, -1, 5, 0, 0)
		if vm.skipping() then
			return skip(1)
		end
	else
		event.SetMesQuestionGyou(0, 1)
		event.SetMesEtc(0, 0, 1)
		event.SetMesEtc(0, 1, 1)
		argc = event.GetItemHaveNum(386) or argc
		if argc <= 0 then
			event.MesMake_2(
				0,
				"これが、ゲイブルさんとこの掃除機だな・・・\nまだやり残してる事があるような・・・\nさてと・・・、始めようかな。"
			)
			var2 = helper_78c0(0, -1, 5, 256, 208, 2, 1)
			if vm.skipping() then
				return skip(2)
			end
			if var2 == 2 then
				var0 = 1
			end
		else
			event.MesMake_2(
				0,
				"これが、ゲイブルさんとこの掃除機だな・・・\nよし、掃除機の修理だ！\nもうちょっと後にしようかな。"
			)
			var2 = helper_78c0(0, -1, 5, 256, 208, 2, 1)
			if vm.skipping() then
				return skip(3)
			end
			if var2 == 1 then
				var0 = 1
			end
		end
		event.SetMesEtc(0, 0, 0)
		event.SetMesEtc(0, 1, 0)
		event.SetMesQuestionGyou(0, 0)
	end
	event.SetMesShippo(0, 1)
	if var0 == 1 then
		helper_12ec0()
		if vm.skipping() then
			return skip(4)
		end
		event.MapJump(-1, "m06", 151)
	end
	return part2()
end

--- Program 502.
script[502] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_14e1c()
	if vm.skipping() then
		return skip(1)
	end
	event.MapJump(-1, "m08", 151)
end

--- Program 510.
script[510] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_e0a8()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 520.
script[520] = function()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_c78c(382, 1)
		end
	end
	event.Initialize()
	do
		local out1, out2, out3 = event.GetEventData_4(10)
		var0 = out1 or var0
		var1 = out2 or var1
		var2 = out3 or var2
	end
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetMotion(0, "歩き")
	event.ObjsMotionDelay(0, 10)
	event.ObjsSetMotion(0, "立ち")
	event.ObjsReference(0, var0, var1, var2, 10)
	helper_6dfa44e2(10)
	if vm.skipping() then
		return skip(1)
	end
	helper_c78c(382, 1)
	if vm.skipping() then
		return skip(2)
	end
	event.AddItem(382)
	event.FuncPointShow("", "item1", 0)
end

--- Program 521.
script[521] = function()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_c78c(386, 1)
		end
	end
	event.Initialize()
	do
		local out1, out2, out3 = event.GetEventData_4(10)
		var0 = out1 or var0
		var1 = out2 or var1
		var2 = out3 or var2
	end
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetMotion(0, "歩き")
	event.ObjsMotionDelay(0, 10)
	event.ObjsSetMotion(0, "立ち")
	event.ObjsReference(0, var0, var1, var2, 10)
	helper_6dfa44e2(10)
	if vm.skipping() then
		return skip(1)
	end
	event.EohSyncObj(1, "memo")
	event.EohSetShow(1, 0)
	helper_c78c(386, 1)
	if vm.skipping() then
		return skip(2)
	end
	event.AddItem(386)
	event.FuncPointShow("", "item2", 0)
end

--- Program 550.
script[550] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	event.SetMotion(0, "立ち")
	event.SetMesWindowMode(0, 1)
	event.SetMesShippo(0, 0)
	event.MesMake_2(0, "何か重要な本があるようだが\n今はまだわからない。")
	helper_84f8(0, -1, 5, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

return script
