--!strict
-- map/s/s43/s43b.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1ce6fe56 = require("@lib/event/helper_1ce6fe56")
local helper_572c09a2 = require("@lib/event/helper_572c09a2")
local helper_69b77b82 = require("@lib/event/helper_69b77b82")
local helper_75322a53 = require("@lib/event/helper_75322a53")
local helper_781c97dd = require("@lib/event/helper_781c97dd")
local helper_9a391372 = require("@lib/event/helper_9a391372")
local helper_aa9a834f = require("@lib/event/helper_aa9a834f")
local helper_d76d5fd4 = require("@lib/event/helper_d76d5fd4")
local helper_f3577a67 = require("@lib/event/helper_f3577a67")
local helper_f4a2e06c = require("@lib/event/helper_f4a2e06c")

--- Helper function.
local function helper_19534(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_f4a2e06c(1)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.StreamOpen3(1, arg0)
	helper_f4a2e06c(1)
	if vm.skipping() then
		return skip(2)
	end
	event.StreamPlay(1)
end

--- Helper function.
local function helper_19608()
	local var0: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 138 then
			if at <= 2 then
				helper_9a391372()
			end
			if at <= 3 then
				helper_f4a2e06c(1)
			end
			if at <= 4 then
				helper_f3577a67(50)
			end
			if at <= 5 then
				helper_d76d5fd4(0, -1, 8, 0, 0)
				helper_69b77b82(0, 30)
			end
			if at <= 6 then
				helper_781c97dd(0)
				helper_75322a53(0)
			end
			if at <= 7 then
				helper_f4a2e06c(1)
			end
			if at <= 8 then
				helper_75322a53(0)
			end
			if at <= 9 then
				helper_75322a53(3)
			end
			if at <= 10 then
				helper_75322a53(4)
			end
			if at <= 11 then
				helper_75322a53(5)
			end
			if at <= 12 then
				helper_f3577a67(10)
			end
			if at <= 13 then
				helper_19534(40012)
			end
			if at <= 14 then
				helper_75322a53(0)
			end
			if at <= 15 then
				helper_f3577a67(4)
			end
			if at <= 16 then
				helper_75322a53(0)
			end
			if at <= 17 then
				helper_f3577a67(30)
			end
			if at <= 18 then
				helper_f3577a67(15)
			end
			if at <= 19 then
				helper_75322a53(0)
			end
			if at <= 20 then
				helper_75322a53(3)
			end
			if at <= 21 then
				helper_75322a53(4)
			end
			if at <= 22 then
				helper_f3577a67(8)
			end
			if at <= 23 then
				helper_f3577a67(20)
			end
			if at <= 24 then
				var0 = helper_1ce6fe56(1)
			end
			if at <= 25 then
				helper_f3577a67(vm.i32(15 - var0))
			end
			if at <= 26 then
				helper_75322a53(0)
			end
			if at <= 27 then
				helper_75322a53(3)
			end
			if at <= 28 then
				helper_75322a53(4)
			end
			if at <= 29 then
				helper_f3577a67(20)
			end
			if at <= 30 then
				helper_19534(40014)
			end
			if at <= 31 then
				helper_75322a53(0)
			end
			if at <= 32 then
				helper_19534(40015)
			end
			if at <= 33 then
				helper_f3577a67(30)
			end
			if at <= 34 then
				helper_572c09a2()
			end
			if at <= 35 then
				helper_f3577a67(15)
			end
			if at <= 36 then
				helper_19534(40016)
			end
			if at <= 37 then
				helper_f3577a67(45)
			end
			if at <= 38 then
				helper_f3577a67(30)
			end
			if at <= 39 then
				helper_f3577a67(20)
			end
			if at <= 40 then
				helper_572c09a2()
			end
			if at <= 41 then
				helper_f3577a67(30)
			end
			if at <= 42 then
				helper_75322a53(0)
			end
			if at <= 43 then
				helper_572c09a2()
			end
			if at <= 44 then
				helper_75322a53(0)
			end
			if at <= 45 then
				helper_9a391372()
			end
			if at <= 46 then
				helper_19534(40017)
			end
			if at <= 47 then
				helper_f3577a67(30)
			end
			if at <= 48 then
				var0 = helper_1ce6fe56(1)
			end
			if at <= 49 then
				helper_f3577a67(vm.i32(20 - var0))
			end
			if at <= 50 then
				helper_75322a53(0)
			end
			if at <= 51 then
				var0 = helper_1ce6fe56(1)
			end
			if at <= 52 then
				helper_f3577a67(vm.i32(24 - var0))
			end
			if at <= 53 then
				helper_f4a2e06c(1)
			end
			if at <= 54 then
				helper_572c09a2()
			end
			if at <= 55 then
				helper_d76d5fd4(0, -1, 8, 0, 0)
				helper_f3577a67(40)
			end
			if at <= 56 then
				helper_781c97dd(0)
				helper_572c09a2()
			end
			if at <= 57 then
				helper_f3577a67(30)
			end
			if at <= 58 then
				helper_f3577a67(30)
			end
			if at <= 59 then
				helper_f3577a67(30)
			end
			if at <= 60 then
				var0 = helper_1ce6fe56(1)
			end
			if at <= 61 then
				helper_f3577a67(vm.i32(30 - var0))
			end
			if at <= 62 then
				helper_f3577a67(30)
			end
			if at <= 63 then
				helper_f3577a67(26)
			end
			if at <= 64 then
				helper_f3577a67(70)
			end
			if at <= 65 then
				helper_19534(40032)
			end
			if at <= 66 then
				helper_f3577a67(42)
			end
			if at <= 67 then
				helper_19534(40033)
			end
			if at <= 68 then
				helper_f3577a67(40)
			end
			if at <= 69 then
				helper_19534(40034)
			end
			if at <= 70 then
				helper_75322a53(0)
			end
			if at <= 71 then
				helper_19534(40035)
			end
			if at <= 72 then
				helper_75322a53(0)
			end
			if at <= 73 then
				helper_f3577a67(40)
			end
			if at <= 74 then
				helper_9a391372()
			end
			if at <= 75 then
				helper_19534(40036)
			end
			if at <= 76 then
				helper_f3577a67(10)
			end
			if at <= 77 then
				helper_75322a53(0)
			end
			if at <= 78 then
				helper_f3577a67(10)
			end
			if at <= 79 then
				helper_19534(40037)
			end
			if at <= 80 then
				helper_75322a53(0)
			end
			if at <= 81 then
				helper_f3577a67(10)
			end
			if at <= 82 then
				helper_572c09a2()
			end
			if at <= 83 then
				helper_75322a53(0)
			end
			if at <= 84 then
				helper_19534(40038)
			end
			if at <= 85 then
				helper_f3577a67(40)
			end
			if at <= 86 then
				helper_75322a53(0)
			end
			if at <= 87 then
				helper_f3577a67(20)
			end
			if at <= 88 then
				helper_9a391372()
			end
			if at <= 89 then
				helper_f3577a67(60)
			end
			if at <= 90 then
				helper_75322a53(0)
			end
			if at <= 91 then
				helper_75322a53(3)
			end
			if at <= 92 then
				helper_75322a53(0)
			end
			if at <= 93 then
				helper_19534(40039)
			end
			if at <= 94 then
				helper_75322a53(3)
			end
			if at <= 95 then
				helper_75322a53(0)
			end
			if at <= 96 then
				helper_f3577a67(22)
			end
			if at <= 97 then
				var0 = helper_1ce6fe56(1)
			end
			if at <= 98 then
				helper_f3577a67(vm.i32(80 - var0))
			end
			if at <= 99 then
				helper_d76d5fd4(0, -1, 8, 0, 0)
				helper_69b77b82(0, 60)
			end
			if at <= 100 then
				helper_781c97dd(0)
				helper_75322a53(4)
			end
			if at <= 101 then
				helper_75322a53(5)
			end
			if at <= 102 then
				helper_75322a53(3)
			end
			if at <= 103 then
				helper_f4a2e06c(1)
			end
			if at <= 104 then
				helper_f3577a67(30)
			end
			if at <= 105 then
				helper_f3577a67(60)
			end
			if at <= 106 then
				var0 = helper_1ce6fe56(1)
			end
			if at <= 107 then
				helper_d76d5fd4(0, -1, 8, 0, 0)
				helper_69b77b82(0, vm.i32(60 - var0))
			end
			if at <= 108 then
				helper_781c97dd(0)
				helper_75322a53(0)
			end
			if at <= 109 then
				helper_f3577a67(10)
			end
			if at <= 110 then
				helper_f3577a67(58)
			end
			if at <= 111 then
				helper_f4a2e06c(1)
			end
			if at <= 112 then
				helper_d76d5fd4(0, -1, 8, 0, 0)
				helper_69b77b82(0, 30)
			end
			if at <= 113 then
				helper_781c97dd(0)
				helper_75322a53(6)
			end
			if at <= 114 then
				helper_f3577a67(14)
			end
			if at <= 115 then
				helper_f3577a67(10)
			end
			if at <= 116 then
				helper_f3577a67(5)
			end
			if at <= 117 then
				helper_19534(40062)
			end
			if at <= 118 then
				helper_75322a53(2)
			end
			if at <= 119 then
				helper_75322a53(0)
			end
			if at <= 120 then
				helper_19534(40064)
			end
			if at <= 121 then
				helper_75322a53(0)
			end
			if at <= 122 then
				helper_572c09a2()
			end
			if at <= 123 then
				helper_f3577a67(6)
			end
			if at <= 124 then
				helper_f3577a67(4)
			end
			if at <= 125 then
				helper_f3577a67(3)
			end
			if at <= 126 then
				helper_f3577a67(20)
			end
			if at <= 127 then
				helper_aa9a834f(40080, 30)
			end
			if at <= 128 then
				helper_f3577a67(10)
			end
			if at <= 129 then
				var0 = helper_1ce6fe56(1)
			end
			if at <= 130 then
				helper_f3577a67(vm.i32(40 - var0))
			end
			if at <= 131 then
				helper_f3577a67(46)
			end
			if at <= 132 then
				helper_75322a53(0)
			end
			if at <= 133 then
				helper_f3577a67(30)
			end
			if at <= 134 then
				helper_19534(40083)
			end
			if at <= 135 then
				helper_75322a53(0)
			end
			if at <= 136 then
				helper_f3577a67(30)
			end
			if at <= 137 then
				helper_572c09a2()
			end
			if vm.skip_end() then
				return skip(139)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.StopBgm(0)
		event.SndSeStop(var1, 33)
		event.SndSeStop(var1, 27)
		event.SndSeStop(var1, 28)
		event.StreamClose(1)
		event.LoadMes(0, -1)
		event.EohSyncChara(0, 0)
		event.EohSetShadow(0, 1)
		event.SetCharaPos(0, 0.0, 8.8, 6.0)
		event.SetCharaRot(0, 0.0, 3.14, 0.0)
		event.SetMotion(0, "バトル立ち", 4)
		event.CharaResetDa(0)
		event.EohSyncChara(21, 1)
		event.EohSetShow(21, 1)
		event.SetCameraRef(0.0, 33.8, 6.0)
		event.SetCameraPos(0.0, 38.8, 86.0)
		event.ResetCamera(0)
		event.DelReference(0)
		event.DelExtMotion(0)
		event.DeleteChara(9)
		event.DeleteChara(10)
		event.DeleteChara(11)
		event.DeleteChara(12)
		event.DeleteChara(13)
		event.DeleteChara(14)
		event.DeleteChara(15)
		event.DeleteChara(18)
		event.DeleteChara(19)
		event.DeleteChara(20)
		event.DeleteChara(8)
		event.CharaActive(1, 0)
		event.LoadSound(1217)
		var2 = event.GetSndId(4) or var2
		event.SetCharaExSoundid(0, var2)
		event.ActchrSoundInfoCopy(0)
		event.LoadScript("s43/s43.stb", 152)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	event.DeleteChara(9)
	event.DeleteChara(10)
	event.DeleteChara(11)
	event.DeleteChara(12)
	event.DeleteChara(13)
	event.DeleteChara(14)
	event.DeleteChara(15)
	event.DeleteChara(16)
	event.DeleteChara(17)
	event.DeleteChara(18)
	event.DeleteChara(19)
	event.DeleteChara(20)
	event.DeleteChara(8)
	event.SetMesWindowMode(0, 7)
	event.LoadBgm(106)
	event.PlayBgm(0)
	event.LoadSound(1216)
	event.AssignStack(4)
	event.ClearStack(4)
	event.AssignStack(5)
	event.ClearStack(5)
	event.LoadMes(0, 5, "event/opening/p4/op4ch1.txt")
	var1 = event.SndLoadSound(1216) or var1
	event.CharaActive(0)
	event.EohSyncChara(0, 0)
	event.EohSetFootSoundId(0, 3)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetPos(0, 548.18, 133.45, -204.55)
	event.ObjsSetRot(0, 0.0, -2.64, 0.0)
	event.ObjsTexAnime(0, 0)
	event.EohSyncChara(21, 1)
	event.EohSetShow(21, 0)
	event.EohSyncChara(21, 2)
	event.EohSetShow(21, 0)
	event.LoadChara(5, "event/opening/p4/buranko.gltf", "info", 9)
	event.CharaActive(9)
	event.EohSyncChara(1, 9)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.ObjsSetPos(1, 0.0, 0.0, 0.0)
	event.ObjsSetRot(1, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(1, "待機", 4)
	event.LoadChara(5, "event/opening/p4/light.gltf", "info", 10)
	event.CharaActive(10)
	event.EohSyncChara(2, 10)
	event.EohSetFrameShow(2, "kusari", 0)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.ObjsSetPos(2, 0.0, 0.0, 0.0)
	event.ObjsSetRot(2, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(2, "待機", 4)
	event.LoadChara(5, "event/opening/p4/p4_pierrot_kihon.gltf", "info", 11)
	event.CharaActive(11)
	event.EohSyncChara(3, 11)
	event.EohSetSoundId(3, var1)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.ObjsSetPos(3, 728.98, 133.45, 91.56)
	event.ObjsSetRot(3, 0.0, -2.52, 0.0)
	event.CopyChara(5, 11, 12)
	event.CharaActive(12)
	event.EohSyncChara(4, 12)
	event.EohSetSoundId(4, var1)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.ObjsSetPos(4, 772.23, 133.45, 85.26)
	event.ObjsSetRot(4, 0.0, -2.52, 0.0)
	event.CopyChara(5, 11, 13)
	event.CharaActive(13)
	event.EohSyncChara(5, 13)
	event.EohSetSoundId(5, var1)
	event.ObjsInit(5)
	event.ObjsSyncObj(5, 5)
	event.ObjsSetPos(5, 737.7, 133.45, 178.69)
	event.ObjsSetRot(5, 0.0, -2.52, 0.0)
	event.CopyChara(5, 11, 14)
	event.CharaActive(0, 14)
	event.EohSyncChrobj(7, 10, "light_rot")
	event.ObjsInit(7)
	event.ObjsSyncObj(7, 7)
	event.ObjsRotation(7, 0.01, 0.0, 0.0, -1)
	event.LoadChara(5, "event/opening/p4/p4_people.gltf", "info", 15)
	event.CharaActive(15)
	event.SetCharaPos(15, 0.0, 0.0, -405.0)
	event.SetStatus(1, 15, 8, 1)
	event.LoadChara(5, "event/opening/p4/up_kusari.gltf", "info", 18)
	event.CharaActive(18)
	event.SetReference(10, "up_kusari", 18)
	event.LoadChara(5, "event/opening/p4/shuchusen.gltf", "info", 8)
	event.CharaActive(0, 8)
	event.EohSyncChara(6, 8)
	event.ObjsInit(6)
	event.ObjsSyncObj(6, 6)
	event.EohSyncObj(30, "p21_i03h02")
	event.EohSetShow(30, 0)
	event.AssignStack(6)
	event.ClearStack(6)
	event.LoadMotion(6, "event/opening/p4/p4_mints1.gltf", "info", 0)
	event.SetLoadbgFile("event/opening/p4/p4_pierrot1.gltf")
	if vm.wait() then
		return skip(2)
	end
	helper_9a391372()
	if vm.skipping() then
		return skip(3)
	end
	event.LoadMotion(6, "event/opening/p4/p4_pierrot1.gltf", "info", 11)
	event.LoadMotion(6, "event/opening/p4/p4_pierrot1.gltf", "info", 12)
	event.LoadMotion(6, "event/opening/p4/p4_pierrot1.gltf", "info", 13)
	event.StreamOpen3(1, 40010)
	helper_f4a2e06c(1)
	if vm.skipping() then
		return skip(4)
	end
	event.ObjsSetMotion(0, "走り", 6)
	event.ObjsMotionWait(0)
	event.ObjsResetMotion(0)
	event.ObjsSetMotion(0, "走り", 6)
	event.ObjsNextMotion(0, "おっとっと", 6)
	event.ObjsMotionWait(0)
	event.ObjsMove(0, 452.01, 133.45, -365.64, 50)
	event.ObjsSetMotion(3, "走り", 4)
	event.ObjsMove(3, 464.87, 133.45, -344.58, 125)
	event.ObjsSetMotion(4, "走り", 4)
	event.ObjsSetMotionNowTime(4, 6.0)
	event.ObjsMove(4, 486.28, 133.45, -397.17, 160)
	event.ObjsSetMotion(5, "走り", 4)
	event.ObjsSetMotionNowTime(5, 12.0)
	event.ObjsMove(5, 428.16, 133.45, -335.04, 180)
	event.InitDramaScene()
	event.CmrsInit()
	event.CmrsSetPos(547.06, 213.33, -103.4)
	event.CmrsSetRef(534.68, 170.7, -203.08)
	event.CmrsMove(537.57, 209.13, -119.23, 500.76, 170.7, -269.77, 45)
	event.CmrsFadeInit()
	event.CmrsFadeIn(30)
	helper_f3577a67(50)
	if vm.skipping() then
		return skip(5)
	end
	event.CmrsSetPos(426.81, 155.31, -411.47)
	event.CmrsSetRef(456.18, 150.65, -363.99)
	event.ObjsTexAnime(0, 1, "驚き（１）")
	event.ObjsTexAnime(0, 1, "大きな口（１）")
	event.StreamPlay(1)
	event.MesMake_2(0, 40010)
	helper_d76d5fd4(0, -1, 8, 0, 0)
	helper_69b77b82(0, 30)
	if vm.skipping() then
		return skip(6)
	end
	helper_781c97dd(0)
	helper_75322a53(0)
	if vm.skipping() then
		return skip(7)
	end
	event.StreamClose(1)
	event.ObjsSetMotion(0, "振り返る", 6)
	event.ObjsMotionWait(0)
	event.ObjsTexaDelay(0, 20)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "だっしゅ！！（１）")
	event.ObjsTexAnime(0, 1, "怒り口（１）")
	event.StreamOpen3(1, 40011)
	helper_f4a2e06c(1)
	if vm.skipping() then
		return skip(8)
	end
	helper_75322a53(0)
	if vm.skipping() then
		return skip(9)
	end
	event.CmrsSetPos(283.78, 126.6, -281.55)
	event.CmrsSetRef(445.98, 163.55, -447.12)
	event.ObjsSetPos(0, 34.0, 0.0, -42.0)
	event.ObjsSetRot(0, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(0, "飛ぶ", 6)
	event.ObjsNextMotion(0, "ぶらさがりL", 4)
	event.ObjsSePlay(0, var1, 8)
	event.ObjsSeDelay(0, 30)
	event.ObjsSePlay(0, var1, 9)
	event.StreamPlay(1)
	helper_75322a53(3)
	if vm.skipping() then
		return skip(10)
	end
	event.ObjsSetMotion(3, "落ちる", 6)
	event.ObjsSeDelay(3, 10)
	event.ObjsSePlay(3, var1, 10)
	helper_75322a53(4)
	if vm.skipping() then
		return skip(11)
	end
	event.ObjsSetMotion(4, "立ち")
	helper_75322a53(5)
	if vm.skipping() then
		return skip(12)
	end
	event.ObjsSetMotion(5, "立ち")
	helper_f3577a67(10)
	if vm.skipping() then
		return skip(13)
	end
	event.StreamClose(1)
	event.CmrsSetPos(312.69, 142.84, -492.3)
	event.CmrsSetRef(387.96, 148.13, -434.53)
	event.ObjsSetPos(0, 373.67, 133.45, -445.03)
	event.ObjsSetRot(0, 0.0, -2.28, 0.0)
	event.ObjsSetMotion(0, "よじのぼり", 6)
	event.ObjsNextMotion(0, "旧・立ち", 4)
	event.ObjsSePlay(0, var1, 11)
	helper_19534(40012)
	if vm.skipping() then
		return skip(14)
	end
	helper_75322a53(0)
	if vm.skipping() then
		return skip(15)
	end
	helper_f3577a67(4)
	if vm.skipping() then
		return skip(16)
	end
	event.ObjsSetMotion(0, "走り")
	event.ObjsMove(0, 342.75, 133.45, -468.75, 15)
	helper_75322a53(0)
	if vm.skipping() then
		return skip(17)
	end
	event.StreamClose(1)
	event.CmrsSetPos(0.0, 164.0, -140.0)
	event.CmrsSetRef(10.0, 164.0, -352.47)
	event.CmrsMove(0.0, 164.0, -140.0, -10.0, 164.0, -352.47, 155)
	event.ObjsSetMotion(0, "走り", 4)
	event.ObjsInitPas(0)
	event.ObjsSetPasFrm(0, 110)
	event.ObjsAddPas(0, 216.54, 133.45, -548.56)
	event.ObjsAddPas(0, 182.72, 133.45, -564.69)
	event.ObjsAddPas(0, -0.73, 133.45, -590.33)
	event.ObjsAddPas(0, -190.24, 133.45, -560.44)
	event.ObjsAddPas(0, -232.51, 133.45, -532.93)
	event.ObjsStartPas(0)
	helper_f3577a67(30)
	if vm.skipping() then
		return skip(18)
	end
	event.ObjsSetMotion(3, "走り", 4)
	event.ObjsInitPas(3)
	event.ObjsSetPasFrm(3, 110)
	event.ObjsAddPas(3, 235.84, 133.45, -501.84)
	event.ObjsAddPas(3, 174.96, 133.45, -531.08)
	event.ObjsAddPas(3, 10.05, 133.45, -560.78)
	event.ObjsAddPas(3, -179.09, 133.45, -536.68)
	event.ObjsAddPas(3, -227.25, 133.45, -513.05)
	event.ObjsStartPas(3)
	helper_f3577a67(15)
	if vm.skipping() then
		return skip(19)
	end
	event.ObjsSetMotion(4, "走り", 4)
	event.ObjsSetMotionNowTime(4, 12.0)
	event.ObjsInitPas(4)
	event.ObjsSetPasFrm(4, 110)
	event.ObjsAddPas(4, 248.7, 135.36, -572.26)
	event.ObjsAddPas(4, 200.97, 135.36, -594.75)
	event.ObjsAddPas(4, 19.57, 135.36, -627.45)
	event.ObjsAddPas(4, -183.63, 135.36, -599.12)
	event.ObjsAddPas(4, -243.31, 135.36, -569.25)
	event.ObjsStartPas(4)
	helper_75322a53(0)
	if vm.skipping() then
		return skip(20)
	end
	helper_75322a53(3)
	if vm.skipping() then
		return skip(21)
	end
	helper_75322a53(4)
	if vm.skipping() then
		return skip(22)
	end
	event.CmrsSetPos(-76.14, 200.79, -552.98)
	event.CmrsSetRef(-244.03, 164.0, -536.48)
	event.CmrsMove(-86.73, 200.79, -548.01, -281.45, 164.0, -521.18, 43)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.ObjsSetPos(3, -77.37, 133.45, -569.47)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.ObjsSetPos(4, -108.56, 133.45, -613.85)
	event.ObjsInitPas(0)
	event.ObjsSetPasFrm(0, 80)
	event.ObjsAddPas(0, -207.41, 133.45, -545.84)
	event.ObjsAddPas(0, -362.81, 133.45, -457.15)
	event.ObjsAddPas(0, -455.6, 133.45, -366.11)
	event.ObjsAddPas(0, -496.87, 133.45, -294.54)
	event.ObjsStartPas(0)
	event.ObjsSetMotion(0, "走り", 6)
	event.ObjsMotionWait(0)
	event.ObjsResetMotion(0)
	event.ObjsSetMotion(0, "飛ぶ2", 6)
	event.ObjsNextMotion(0, "走り", 4)
	event.ObjsSeDelay(0, 40)
	event.ObjsSePlay(0, var1, 12)
	event.ObjsInitPas(3)
	event.ObjsSetPasFrm(3, 120)
	event.ObjsAddPas(3, -77.37, 133.45, -569.47)
	event.ObjsAddPas(3, -204.83, 133.45, -519.56)
	event.ObjsAddPas(3, -351.11, 133.45, -436.61)
	event.ObjsAddPas(3, -436.92, 133.45, -351.79)
	event.ObjsAddPas(3, -474.71, 133.45, -285.13)
	event.ObjsStartPas(3)
	event.ObjsSetMotion(3, "走り", 6)
	event.ObjsMotionWait(3)
	event.ObjsResetMotion(3)
	event.ObjsSetMotion(3, "走り", 6)
	event.ObjsMotionWait(3)
	event.ObjsResetMotion(3)
	event.ObjsSetMotion(3, "走り", 6)
	event.ObjsNextMotion(3, "飛ぶ", 6)
	event.ObjsNextMotion(3, "走り", 4)
	event.ObjsSeDelay(3, 72)
	event.ObjsSePlay(3, var1, 12)
	helper_f3577a67(8)
	if vm.skipping() then
		return skip(23)
	end
	event.ObjsInitPas(4)
	event.ObjsSetPasFrm(4, 120)
	event.ObjsAddPas(4, -108.56, 133.45, -613.85)
	event.ObjsAddPas(4, -245.28, 133.45, -564.91)
	event.ObjsAddPas(4, -378.72, 133.45, -485.4)
	event.ObjsAddPas(4, -481.13, 133.45, -385.99)
	event.ObjsAddPas(4, -521.02, 133.45, -316.93)
	event.ObjsStartPas(4)
	event.ObjsSetMotion(4, "走り", 6)
	event.ObjsMotionWait(4)
	event.ObjsResetMotion(4)
	event.ObjsSetMotion(4, "走り", 6)
	event.ObjsMotionWait(4)
	event.ObjsResetMotion(4)
	event.ObjsSetMotion(4, "走り", 6)
	event.ObjsNextMotion(4, "飛ぶ", 6)
	event.ObjsNextMotion(4, "走り", 4)
	event.ObjsSeDelay(4, 72)
	event.ObjsSePlay(4, var1, 12)
	helper_f3577a67(20)
	if vm.skipping() then
		return skip(24)
	end
	event.StreamOpen3(1, 40013)
	var0 = helper_1ce6fe56(1)
	if vm.skipping() then
		return skip(25)
	end
	event.StreamPlay(1)
	helper_f3577a67(vm.i32(15 - var0))
	if vm.skipping() then
		return skip(26)
	end
	event.CmrsSetPos(-253.07, 137.49, -256.64)
	event.CmrsSetRef(-383.77, 149.38, -384.26)
	helper_75322a53(0)
	if vm.skipping() then
		return skip(27)
	end
	helper_75322a53(3)
	if vm.skipping() then
		return skip(28)
	end
	helper_75322a53(4)
	if vm.skipping() then
		return skip(29)
	end
	event.ObjsSetMotion(3, "立ち", 4)
	event.ObjsSetMotion(4, "立ち", 4)
	event.CmrsSetPos(-624.63, 203.17, -154.88)
	event.CmrsSetRef(-576.54, 149.38, 113.64)
	event.ObjsSetPos(0, -583.25, 133.45, -101.95)
	event.ObjsSetRot(0, 0.0, 0.07, 0.0)
	event.ObjsMove(0, -577.83, 133.45, 14.04, 30)
	event.ObjsSetMotion(0, "走り", 6)
	event.ObjsSetMotionNowTime(0, 10.0)
	event.ObjsMotionWait(0)
	event.ObjsResetMotion(0)
	event.ObjsSetMotion(0, "走り", 6)
	event.ObjsNextMotion(0, "ストップ", 6)
	event.ObjsNextMotion(0, "ストップL", 6)
	event.ObjsSetPos(5, 0.0, 0.0, 0.0)
	event.ObjsSetRot(5, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(5, "出現", 6)
	event.ObjsNextMotion(5, "出現L", 4)
	event.ObjsSePlay(5, var1, 13)
	event.ObjsSeDelay(5, 50)
	event.ObjsSePlay(5, var1, 14)
	helper_f3577a67(20)
	if vm.skipping() then
		return skip(30)
	end
	event.StreamClose(1)
	helper_19534(40014)
	if vm.skipping() then
		return skip(31)
	end
	helper_75322a53(0)
	if vm.skipping() then
		return skip(32)
	end
	event.CmrsSetPos(-564.24, 148.01, 41.12)
	event.CmrsSetRef(-579.7, 154.29, 16.45)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "怒り目")
	event.ObjsTexAnime(0, 1, "口パク小")
	event.StreamClose(1)
	helper_19534(40015)
	if vm.skipping() then
		return skip(33)
	end
	helper_f3577a67(30)
	if vm.skipping() then
		return skip(34)
	end
	event.StreamClose(1)
	event.CmrsSetPos(-567.19, 160.39, 76.35)
	event.CmrsSetRef(-562.84, 160.91, 93.75)
	event.CmrsMove(-570.96, 160.39, 77.29, -566.61, 160.91, 94.69, 45)
	event.ObjsSetMotion(5, "かまえ立ち", 4, 0.05)
	event.ObjsSetPos(5, -570.67, 133.45, 93.71)
	event.ObjsSetRot(5, 0.0, -2.88, 0.0)
	helper_572c09a2()
	if vm.skipping() then
		return skip(35)
	end
	helper_f3577a67(15)
	if vm.skipping() then
		return skip(36)
	end
	event.CmrsSetPos(-476.38, 153.26, 55.85)
	event.CmrsSetRef(-580.21, 159.97, 82.18)
	event.ObjsSetPos(0, 0.0, 0.0, 0.0)
	event.ObjsSetRot(0, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(0, "vsピエロ", 6)
	event.ObjsMotionWait(0)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "vsピエロ（１）")
	event.ObjsTexAnime(0, 1, "怒り口（１）")
	event.ObjsSeDelay(0, 20)
	event.ObjsSePlay(0, var1, 15)
	event.ObjsSeDelay(0, 20)
	event.ObjsSePlay(0, var1, 16)
	event.ObjsSetPos(5, 0.0, 0.0, 0.0)
	event.ObjsSetRot(5, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(5, "vsピエロ", 6)
	event.StreamClose(1)
	helper_19534(40016)
	if vm.skipping() then
		return skip(37)
	end
	helper_f3577a67(45)
	if vm.skipping() then
		return skip(38)
	end
	event.CmrsSetPos(-552.26, 154.78, 179.33)
	event.CmrsSetRef(-572.64, 133.7, 67.83)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "あ！！（１）")
	event.ObjsTexAnime(0, 1, "怒り口（１）")
	event.ObjsSetMotion(3, "走り", 4)
	event.ObjsInitPas(3)
	event.ObjsSetPasFrm(3, 130)
	event.ObjsAddPas(3, -505.19, 133.45, -266.75)
	event.ObjsAddPas(3, -525.23, 133.45, -172.98)
	event.ObjsAddPas(3, -544.18, 133.45, -7.69)
	event.ObjsAddPas(3, -510.83, 133.45, 98.05)
	event.ObjsStartPas(3)
	event.ObjsSetMotion(4, "走り", 4)
	event.ObjsSetMotionNowTime(4, 12.0)
	event.ObjsInitPas(4)
	event.ObjsSetPasFrm(4, 150)
	event.ObjsAddPas(4, -521.02, 133.45, -316.93)
	event.ObjsAddPas(4, -550.86, 133.45, -178.43)
	event.ObjsAddPas(4, -548.36, 133.45, -1.85)
	event.ObjsAddPas(4, -527.93, 133.45, 69.26)
	event.ObjsStartPas(4)
	helper_f3577a67(30)
	if vm.skipping() then
		return skip(39)
	end
	event.CmrsMove(-574.0, 156.97, 179.02, -487.34, 166.42, 108.67, 60)
	helper_f3577a67(20)
	if vm.skipping() then
		return skip(40)
	end
	helper_572c09a2()
	if vm.skipping() then
		return skip(41)
	end
	helper_f3577a67(30)
	if vm.skipping() then
		return skip(42)
	end
	event.ObjsSetMotion(3, "立ち")
	event.ObjsSetMotion(4, "立ち")
	event.CmrsSetPos(-524.03, 172.04, -43.4)
	event.CmrsSetRef(-445.68, 174.18, 59.09)
	event.CmrsMove(-524.03, 172.04, -43.4, -415.83, 184.9, 28.66, 60)
	helper_75322a53(0)
	if vm.skipping() then
		return skip(43)
	end
	helper_572c09a2()
	if vm.skipping() then
		return skip(44)
	end
	event.CmrsSetPos(-403.56, 235.67, 109.42)
	event.CmrsSetRef(-352.18, 211.03, 18.75)
	event.StreamClose(1)
	event.SetLoadbgFile("event/opening/p4/p4_mints2.gltf", "event/opening/p4/p4_pierrot2.gltf")
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "ブランコ前（１）")
	event.ObjsTexAnime(0, 1, "口パク横大（１）")
	event.ObjsSetPos(0, -374.25, 184.32, 26.34)
	event.ObjsSetRot(0, 0.0, 2.0, 0.0)
	event.ObjsMove(0, -328.72, 184.32, 6.44, 18)
	event.ObjsSetMotion(0, "走り2", 6)
	event.ObjsNextMotion(0, "後ろを見る", 2)
	event.ObjsNextMotion(0, "後ろを見るL", 4)
	helper_75322a53(0)
	if vm.skipping() then
		return skip(45)
	end
	helper_9a391372()
	if vm.skipping() then
		return skip(46)
	end
	helper_19534(40017)
	if vm.skipping() then
		return skip(47)
	end
	event.DelExtMotion(0)
	event.ClearStack(6)
	event.LoadMotion(6, "event/opening/p4/p4_mints2.gltf", "info", 0)
	event.DelExtMotion(11)
	event.DelExtMotion(12)
	event.DelExtMotion(13)
	event.LoadMotion(6, "event/opening/p4/p4_pierrot2.gltf", "info", 11)
	event.LoadMotion(6, "event/opening/p4/p4_pierrot2.gltf", "info", 12)
	event.LoadMotion(6, "event/opening/p4/p4_pierrot2.gltf", "info", 13)
	event.CmrsSetPos(-341.49, 223.49, -20.69)
	event.CmrsSetRef(-385.73, 190.51, 33.94)
	event.ObjsSetPos(3, -402.0, 159.7, 49.66)
	event.ObjsSetRot(3, 0.0, 2.14, 0.0)
	event.ObjsSetMotion(3, "立ち上がり", 6)
	event.ObjsSetPos(4, -482.22, 134.65, 113.65)
	event.ObjsSetRot(4, 0.0, 2.14, 0.0)
	event.ObjsMove(4, -445.32, 147.11, 83.57, 30)
	event.ObjsSetMotion(4, "綱渡り", 4)
	helper_f3577a67(30)
	if vm.skipping() then
		return skip(48)
	end
	event.StreamClose(1)
	event.CmrsSetPos(-403.56, 235.67, 109.42)
	event.CmrsSetRef(-352.18, 211.03, 18.75)
	event.ObjsSetPos(0, 0.0, 0.0, 0.0)
	event.ObjsSetRot(0, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(0, "ブランコを取る", 6)
	event.ObjsMotionWait(0)
	event.ObjsSetMotion(1, "ブランコを取る", 6)
	event.StreamOpen3(1, 40018)
	var0 = helper_1ce6fe56(1)
	if vm.skipping() then
		return skip(49)
	end
	helper_f3577a67(vm.i32(20 - var0))
	if vm.skipping() then
		return skip(50)
	end
	event.StreamPlay(1)
	helper_75322a53(0)
	if vm.skipping() then
		return skip(51)
	end
	event.StreamClose(1)
	event.CmrsSetPos(-267.74, 231.08, 97.99)
	event.CmrsSetRef(-305.0, 211.03, 3.73)
	event.ObjsSePlay(0, var1, 17)
	event.ObjsSetMotion(0, "空中ブランコ", 6)
	event.ObjsSetMotion(1, "空中ブランコ", 6)
	event.CmrsMove(-86.05, 232.08, 330.06, -180.81, 158.06, -26.95, 60)
	event.StreamOpen3(1, 40019)
	var0 = helper_1ce6fe56(1)
	if vm.skipping() then
		return skip(52)
	end
	event.StreamPlay(1)
	helper_f3577a67(vm.i32(24 - var0))
	if vm.skipping() then
		return skip(53)
	end
	event.StreamClose(1)
	event.StreamOpen3(1, 40030)
	helper_f4a2e06c(1)
	if vm.skipping() then
		return skip(54)
	end
	helper_572c09a2()
	if vm.skipping() then
		return skip(55)
	end
	event.ObjsSePlay(0, var1, 28)
	event.ObjsSetPos(3, 0.0, -1000.0, 0.0)
	event.ObjsSetRot(3, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(3, "かまえ立ち", 4)
	event.ObjsSetPos(4, 0.0, -1000.0, 0.0)
	event.ObjsSetRot(4, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(4, "かまえ立ち", 4)
	event.ObjsSetMotionNowTime(0, 16.0)
	event.ObjsSetMotionNowTime(1, 16.0)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "空中（２）")
	event.ObjsTexAnime(0, 1, "大口（２）")
	event.CmrsSyncObj(0, 0.0, 0.0, 0.0, 0.0, 0.0, 40.0, "bcol00", 2)
	event.CmrsAhddelay(40)
	event.CmrsReleaseObj()
	event.StreamPlay(1)
	event.MesMake_2(0, 40030)
	helper_d76d5fd4(0, -1, 8, 0, 0)
	helper_f3577a67(40)
	if vm.skipping() then
		return skip(56)
	end
	helper_781c97dd(0)
	event.SetMesPos(0, 0)
	helper_572c09a2()
	if vm.skipping() then
		return skip(57)
	end
	event.CmrsSetPos(-105.65, 209.67, 213.11)
	event.CmrsSetRef(-5.77, 249.52, 4.26)
	helper_f3577a67(30)
	if vm.skipping() then
		return skip(58)
	end
	event.ObjsSetPos(3, -309.76, 184.62, 0.22)
	event.ObjsSetRot(3, 0.0, 0.96, 0.0)
	event.ObjsSetPos(4, -321.11, 184.32, -16.48)
	event.ObjsSetRot(4, 0.0, 0.54, 0.0)
	event.ObjsSetMotionNowTime(0, 68.0)
	event.ObjsSetMotionNowTime(1, 68.0)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "空中２（２）")
	event.ObjsTexAnime(0, 1, "大口（２）")
	event.CmrsSyncObj(0, 0.0, 0.0, 0.0, 0.0, 0.0, 40.0, "bcol00", 2)
	helper_f3577a67(30)
	if vm.skipping() then
		return skip(59)
	end
	event.CmrsReleaseObj()
	event.ObjsSetMotionNowTime(0, 64.0)
	event.ObjsSetMotionNowTime(1, 64.0)
	event.CmrsSetPos(-105.65, 209.67, 213.11)
	event.CmrsSetRef(-5.77, 249.52, 4.26)
	helper_f3577a67(30)
	if vm.skipping() then
		return skip(60)
	end
	event.StreamClose(1)
	event.ObjsSetMotionNowTime(0, 78.4)
	event.ObjsSetMotionNowTime(1, 78.4)
	event.CmrsSetPos(-341.79, 268.45, 142.52)
	event.CmrsSetRef(-275.52, 194.52, 6.09)
	event.StreamOpen3(1, 40031)
	var0 = helper_1ce6fe56(1)
	if vm.skipping() then
		return skip(61)
	end
	helper_f3577a67(vm.i32(30 - var0))
	if vm.skipping() then
		return skip(62)
	end
	event.ObjsSetMotionNowTime(0, 80.0)
	event.ObjsSetMotionNowTime(1, 80.0)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "戻るー！！（２）")
	event.ObjsTexAnime(0, 1, "大口（２）")
	event.CmrsSyncObj(0, 0.0, 0.0, 5.0, 1.5, 0.0, 30.0, "bcol00", 1)
	event.StreamPlay(1)
	helper_f3577a67(30)
	if vm.skipping() then
		return skip(63)
	end
	event.CmrsReleaseObj()
	event.ObjsSetMotionNowTime(0, 102.4)
	event.ObjsSetMotionNowTime(1, 102.4)
	event.CmrsSetPos(-220.35, 212.87, 157.52)
	event.CmrsSetRef(-306.54, 193.56, -8.65)
	event.ObjsSetPos(3, 0.0, 0.0, 0.0)
	event.ObjsSetRot(3, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(3, "蹴飛ばされる", 6)
	event.ObjsSeDelay(3, 10)
	event.ObjsSePlay(3, var1, 18)
	helper_f3577a67(26)
	if vm.skipping() then
		return skip(64)
	end
	event.ObjsSetPos(4, 0.0, 0.0, 0.0)
	event.ObjsSetRot(4, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(4, "捕まえ失敗", 6)
	helper_f3577a67(70)
	if vm.skipping() then
		return skip(65)
	end
	event.StreamClose(1)
	event.CharaActive(0, 11)
	event.CharaActive(0, 12)
	event.CharaActive(0, 13)
	event.CmrsSetPos(-105.65, 209.67, 213.11)
	event.CmrsSetRef(-5.77, 249.52, 4.26)
	event.StreamClose(1)
	helper_19534(40032)
	if vm.skipping() then
		return skip(66)
	end
	event.ObjsSeDelay(0, 4)
	event.ObjsSePlay(0, var1, 19)
	event.ObjsSeDelay(0, 20)
	event.ObjsSePlay(0, var1, 20)
	event.ObjsSePlay(0, var1, 28)
	helper_f3577a67(42)
	if vm.skipping() then
		return skip(67)
	end
	event.StreamClose(1)
	event.ObjsSetMotionNowTime(0, 208.0)
	event.ObjsSetMotionNowTime(1, 208.0)
	event.ObjsMotionWait(1)
	event.ObjsSetMotion(1, "たれさがり")
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "空中（２）")
	event.ObjsTexAnime(0, 1, "怒り口（２）")
	event.ObjsTexaDelay(0, 20)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "よし！！次（２）")
	event.ObjsTexAnime(0, 1, "怒り口（２）")
	event.CmrsSyncObj(0, 0.0, 0.0, 0.0, 0.0, 0.0, 40.0, "bcol00", 2)
	helper_19534(40033)
	if vm.skipping() then
		return skip(68)
	end
	helper_f3577a67(40)
	if vm.skipping() then
		return skip(69)
	end
	event.CmrsReleaseObj()
	event.StreamClose(1)
	event.CmrsSetPos(163.49, 140.77, 131.57)
	event.CmrsSetRef(270.66, 194.2, -19.59)
	event.CharaDaEnable(0, 0)
	event.ObjsMotionWait(0)
	event.ObjsSeDelay(0, 4)
	event.ObjsSePlay(0, var1, 21)
	helper_19534(40034)
	if vm.skipping() then
		return skip(70)
	end
	helper_75322a53(0)
	if vm.skipping() then
		return skip(71)
	end
	event.StreamClose(1)
	event.CharaDaEnable(0, 1)
	event.CmrsSetPos(447.58, 266.17, -85.27)
	event.CmrsSetRef(357.43, 185.48, 3.08)
	event.ObjsSetPos(0, 349.03, 184.32, 4.08)
	event.ObjsSetRot(0, 0.0, 1.57, 0.0)
	event.ObjsSetMotion(0, "立ち上がる", 6)
	event.ObjsNextMotion(0, "キョロキョロ立ち", 6)
	event.ObjsMotionWait(0)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "よし！！次（２）")
	event.ObjsTexAnime(0, 1, "口パク小")
	helper_19534(40035)
	if vm.skipping() then
		return skip(72)
	end
	helper_75322a53(0)
	if vm.skipping() then
		return skip(73)
	end
	event.StreamClose(1)
	event.CmrsSetPos(452.54, 255.33, -129.4)
	event.CmrsSetRef(388.48, 192.54, 28.93)
	event.SetLoadbgFile("event/opening/p4/p4_mints3.gltf", "event/opening/p4/p4_pierrot3.gltf")
	event.ObjsRotation(0, 0.0, 0.85, 0.0, 6)
	event.ObjsSetMotion(0, "かまえ立ち", 4)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "気づく（２）")
	event.ObjsTexAnime(0, 1, "大口（２）")
	event.CharaActive(11)
	event.CharaActive(12)
	event.ObjsSetPos(3, 442.04, 148.45, 80.27)
	event.ObjsSetRot(3, 0.0, -2.28, 0.0)
	event.ObjsMove(3, 422.02, 155.31, 63.91, 40)
	event.ObjsSetMotion(3, "綱渡り", 4)
	event.ObjsSetMotionNowTime(3, 3.5)
	event.ObjsSetPos(4, 472.84, 137.68, 106.72)
	event.ObjsSetRot(4, 0.0, -2.28, 0.0)
	event.ObjsMove(4, 454.19, 144.23, 90.87, 40)
	event.ObjsSetMotion(4, "綱渡り", 4)
	helper_f3577a67(40)
	if vm.skipping() then
		return skip(74)
	end
	helper_9a391372()
	if vm.skipping() then
		return skip(75)
	end
	event.DelExtMotion(0)
	event.ClearStack(6)
	event.LoadMotion(6, "event/opening/p4/p4_mints3.gltf", "info", 0)
	event.ObjsSetMotion(0, "キョロキョロ立ち", 5)
	event.CmrsSetPos(373.64, 213.67, 15.39)
	event.CmrsSetRef(347.99, 207.28, 2.45)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "よし！！次（２）")
	event.ObjsTexAnime(0, 1, "怒り口（３）")
	event.ObjsTexaDelay(0, 57)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "見上げる（２）")
	event.ObjsTexAnime(0, 1, "怒り口（３）")
	helper_19534(40036)
	if vm.skipping() then
		return skip(76)
	end
	helper_f3577a67(10)
	if vm.skipping() then
		return skip(77)
	end
	event.ObjsResetMotion(0)
	event.ObjsSetMotion(0, "キョロキョロ立ち", 6)
	event.ObjsNextMotion(0, "上を見る", 6)
	event.ObjsNextMotion(0, "上を見るL", 4)
	event.DelExtMotion(11)
	event.DelExtMotion(12)
	event.DelExtMotion(13)
	event.LoadMotion(6, "event/opening/p4/p4_pierrot3.gltf", "info", 11)
	event.LoadMotion(6, "event/opening/p4/p4_pierrot3.gltf", "info", 12)
	event.LoadMotion(6, "event/opening/p4/p4_pierrot3.gltf", "info", 13)
	event.LoadMotion(6, "event/opening/p4/p4_pierrot3.gltf", "info", 14)
	helper_75322a53(0)
	if vm.skipping() then
		return skip(78)
	end
	helper_f3577a67(10)
	if vm.skipping() then
		return skip(79)
	end
	event.StreamClose(1)
	event.CmrsSetPos(452.33, 233.67, -60.78)
	event.CmrsSetRef(343.67, 205.51, -9.42)
	event.EohSetShadow(0, 0)
	event.ObjsSetPos(0, 358.46, 184.32, -6.15)
	event.ObjsSetRot(0, 0.0, -2.87, 0.0)
	event.ObjsSetMotion(0, "柱･しがみつき", 6)
	event.ObjsMotionWait(0)
	event.ObjsSePlay(0, var1, 22)
	helper_19534(40037)
	if vm.skipping() then
		return skip(80)
	end
	helper_75322a53(0)
	if vm.skipping() then
		return skip(81)
	end
	event.ObjsSetPos(3, 397.41, 184.32, 30.99)
	event.ObjsSetRot(3, 0.0, -2.52, 0.0)
	event.ObjsMove(3, 370.41, 184.32, -8.43, 35)
	event.ObjsSetMotion(3, "歩き", 6)
	event.ObjsNextMotion(3, "上を見る", 6)
	event.ObjsNextMotion(3, "上を見るL", 4)
	helper_f3577a67(10)
	if vm.skipping() then
		return skip(82)
	end
	event.ObjsMove(0, 358.46, 380.32, -6.15, 200)
	event.ObjsSetMotion(0, "柱･登り", 4)
	event.CmrsMove(452.33, 233.67, -60.78, 343.67, 351.26, -9.42, 160)
	event.ObjsSePlay(0, var1, 23)
	event.ObjsSeDelay(0, 12)
	event.ObjsSePlay(0, var1, 23)
	event.ObjsSeDelay(0, 12)
	event.ObjsSePlay(0, var1, 23)
	event.ObjsSeDelay(0, 12)
	event.ObjsSePlay(0, var1, 23)
	event.ObjsSeDelay(0, 12)
	event.ObjsSePlay(0, var1, 23)
	event.ObjsSeDelay(0, 12)
	event.ObjsSePlay(0, var1, 23)
	event.ObjsSeDelay(0, 12)
	event.ObjsSePlay(0, var1, 23)
	event.ObjsSeDelay(0, 12)
	event.ObjsSePlay(0, var1, 23)
	event.ObjsSeDelay(0, 12)
	event.ObjsSePlay(0, var1, 23)
	event.ObjsSeDelay(0, 12)
	event.ObjsSePlay(0, var1, 23)
	event.ObjsSeDelay(0, 12)
	event.ObjsSePlay(0, var1, 23)
	event.ObjsSeDelay(0, 12)
	event.ObjsSePlay(0, var1, 23)
	event.ObjsSeDelay(0, 12)
	event.ObjsSePlay(0, var1, 23)
	event.ObjsSeDelay(0, 12)
	event.ObjsSePlay(0, var1, 23)
	event.ObjsSeDelay(0, 12)
	event.ObjsSePlay(0, var1, 23)
	event.ObjsSeDelay(0, 12)
	event.ObjsSePlay(0, var1, 23)
	event.ObjsSeDelay(0, 12)
	event.ObjsSePlay(0, var1, 23)
	event.ObjsSeDelay(0, 12)
	event.ObjsSePlay(0, var1, 23)
	helper_572c09a2()
	if vm.skipping() then
		return skip(83)
	end
	event.StreamClose(1)
	event.CmrsSetPos(436.58, 475.72, -3.59)
	event.CmrsSetRef(343.67, 410.45, -9.42)
	helper_75322a53(0)
	if vm.skipping() then
		return skip(84)
	end
	event.ObjsSetPos(0, 358.46, 370.64, -6.15)
	event.ObjsSetMotion(0, "柱･棒に立つ", 6)
	event.ObjsMotionWait(0)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "怒り目")
	event.ObjsTexAnime(0, 1, "怒り口")
	helper_19534(40038)
	if vm.skipping() then
		return skip(85)
	end
	helper_f3577a67(40)
	if vm.skipping() then
		return skip(86)
	end
	event.StreamClose(1)
	event.CmrsSetPos(367.47, 421.1, 17.39)
	event.CmrsSetRef(340.3, 420.48, -31.37)
	event.SetLoadbgFile("event/opening/p4/p4_kusari.gltf", "event/opening/p4/p4_kemuri.gltf")
	helper_75322a53(0)
	if vm.skipping() then
		return skip(87)
	end
	event.ObjsSetMotion(0, "下見立ち", 6)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "真剣下見")
	event.ObjsTexAnime(0, 1, "怒り口")
	helper_f3577a67(20)
	if vm.skipping() then
		return skip(88)
	end
	helper_9a391372()
	if vm.skipping() then
		return skip(89)
	end
	event.AssignStack(7)
	event.ClearStack(7)
	event.LoadChara(7, "event/opening/p4/p4_kusari.gltf", "info", 19)
	event.CharaActive(0, 19)
	event.EohSyncChara(10, 19)
	event.ObjsInit(10)
	event.ObjsSyncObj(10, 10)
	event.ObjsSetPos(10, 0.0, 448.0, 105.0)
	event.ObjsSetRot(10, 0.0, 0.0, 0.0)
	event.LoadChara(7, "event/opening/p4/p4_kemuri.gltf", "info", 20)
	event.CharaActive(0, 20)
	event.SetCharaPos(20, 0.0, 10.0, 0.0)
	event.CmrsSetPos(439.18, 421.1, 162.79)
	event.CmrsSetRef(340.3, 366.23, -31.37)
	event.ObjsSetPos(3, 354.39, 291.6, -24.56)
	event.ObjsSetRot(3, 0.0, -2.76, 0.0)
	event.ObjsSetMotion(3, "柱･登り", 4)
	event.ObjsMove(3, 354.39, 321.6, -24.56, 60)
	event.ObjsSetPos(4, 360.04, 254.11, -32.06)
	event.ObjsSetRot(4, 0.0, -1.49, 0.0)
	event.ObjsSetMotion(4, "柱･登り", 4)
	event.ObjsMove(4, 360.04, 284.11, -32.06, 60)
	helper_f3577a67(60)
	if vm.skipping() then
		return skip(90)
	end
	event.CmrsSetPos(367.47, 421.1, 17.39)
	event.CmrsSetRef(340.3, 420.48, -31.37)
	event.ObjsSetMotion(0, "棒の先を見る", 6)
	event.ObjsNextMotion(0, "踏み出す", 6, 0.1)
	event.ObjsMotionWait(0)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "○７（３）")
	event.ObjsTexAnime(0, 1, "怒り口（３）")
	helper_75322a53(0)
	if vm.skipping() then
		return skip(91)
	end
	event.CmrsSetPos(132.73, 389.48, 276.32)
	event.CmrsSetRef(306.5, 389.69, -17.39)
	event.CmrsMove(132.73, 389.48, 276.32, -0.73, 353.3, -17.15, 210)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "拍手喝采（３）")
	event.ObjsTexAnime(0, 1, "怒り口")
	event.ObjsSetPos(0, 309.1, 392.52, -23.46)
	event.ObjsSetRot(0, 0.0, -1.43, 0.0)
	event.ObjsSetMotion(0, "綱渡り", 6)
	event.ObjsMotionWait(0)
	event.ObjsResetMotion(0)
	event.ObjsSetMotion(0, "綱渡り", 6)
	event.ObjsNextMotion(0, "綱走り")
	event.ObjsMove(0, 274.31, 373.41, -16.87, 80)
	event.ObjsMove(0, 183.47, 333.23, 0.0, 50)
	event.ObjsMove(0, 9.21, 327.28, 0.0, 80)
	event.ObjsRotDelay(0, 140)
	event.ObjsRotation(0, 0.0, -1.57, 0.0, 6)
	event.ObjsSetPos(3, 354.39, 373.19, -24.56)
	event.ObjsSetRot(3, 0.0, -2.52, 0.0)
	event.ObjsSetMotion(3, "柱･登り", 4)
	event.ObjsMove(3, 354.39, 403.19, -24.56, 60)
	event.ObjsSetPos(4, 360.04, 327.61, -32.06)
	event.ObjsSetRot(4, 0.0, -1.49, 0.0)
	event.ObjsSetMotion(4, "柱･登り", 4)
	event.ObjsMove(4, 360.04, 387.61, -32.06, 90)
	event.CharaActive(13)
	event.ObjsSetPos(5, 347.62, 292.91, -38.69)
	event.ObjsSetRot(5, 0.0, 0.65, 0.0)
	event.ObjsSetMotion(5, "柱･登り", 4)
	event.ObjsMove(5, 347.62, 352.91, -38.69, 90)
	helper_75322a53(3)
	if vm.skipping() then
		return skip(92)
	end
	event.ObjsSetMotion(3, "柱･棒に立つ", 6)
	helper_75322a53(0)
	if vm.skipping() then
		return skip(93)
	end
	event.CmrsSetPos(-215.21, 383.68, 0.36)
	event.CmrsSetRef(4.09, 338.95, -1.2)
	event.ObjsSetPos(0, 0.0, 0.0, 0.0)
	event.ObjsSetRot(0, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(0, "ぐらぐら", 6)
	event.ObjsNextMotion(0, "ぐらぐらL", 6)
	event.ObjsMotionWait(0)
	event.ObjsResetMotion(0)
	event.ObjsSetMotion(0, "ぐらぐらL", 6)
	event.ObjsMotionWait(0)
	event.ObjsSetPos(3, 142.97, 331.31, 0.0)
	event.ObjsSetRot(3, 0.0, -1.57, 0.0)
	event.ObjsSetMotion(3, "綱渡り", 4, 0.35)
	event.ObjsSetMotionNowTime(5, 3.5)
	event.ObjsMove(3, 60.0, 328.26, 0.0, 80)
	event.ObjsMove(3, 40.0, 328.26, 0.0, 20)
	event.ObjsSetPos(4, 212.27, 343.23, -5.15)
	event.ObjsSetRot(4, 0.0, -1.45, 0.0)
	event.ObjsSetMotion(4, "綱渡り", 6, 0.35)
	event.ObjsSetMotionNowTime(4, 7.0)
	event.ObjsMotionWait(4)
	event.ObjsResetMotion(4)
	event.ObjsSetMotion(4, "綱渡り", 6)
	event.ObjsMotionWait(4)
	event.ObjsResetMotion(4)
	event.ObjsSetMotion(4, "綱渡り", 6)
	event.ObjsMotionWait(4)
	event.ObjsResetMotion(4)
	event.ObjsSetMotion(4, "綱渡り", 6)
	event.ObjsNextMotion(4, "棒の上立ち", 6)
	event.ObjsNextMotion(4, "棒の上立ちL", 4)
	event.ObjsMove(4, 183.0, 332.22, 0.0, 30)
	event.ObjsMove(4, -23.0, 328.47, 0.0, 134)
	event.ObjsRotDelay(4, 30)
	event.ObjsRotation(4, 0.0, -1.57, 0.0, 6)
	event.ObjsSetPos(5, 260.46, 368.14, -15.47)
	event.ObjsSetRot(5, 0.0, -1.45, 0.0)
	event.ObjsSetMotion(5, "綱渡り", 6)
	event.ObjsMotionWait(5)
	event.ObjsResetMotion(5)
	event.ObjsSetMotion(5, "綱渡り", 6)
	event.ObjsMotionWait(5)
	event.ObjsResetMotion(5)
	event.ObjsSetMotion(5, "綱渡り", 6)
	event.ObjsMotionWait(5)
	event.ObjsResetMotion(5)
	event.ObjsSetMotion(5, "綱渡り", 6)
	event.ObjsNextMotion(5, "棒の上立ち", 6)
	event.ObjsNextMotion(5, "棒の上立ちL", 4)
	event.ObjsMove(5, 183.0, 332.22, 0.0, 84)
	event.ObjsMove(5, 0.0, 328.22, 0.0, 100)
	helper_19534(40039)
	if vm.skipping() then
		return skip(94)
	end
	helper_75322a53(3)
	if vm.skipping() then
		return skip(95)
	end
	event.ObjsSetMotion(3, "飛びつき", 6)
	helper_75322a53(0)
	if vm.skipping() then
		return skip(96)
	end
	event.ObjsSetMotion(0, "ライトに飛ぶ", 6)
	event.ObjsSePlay(0, var1, 24)
	event.ObjsSetMotion(2, "ライトに飛ぶ", 6)
	event.ObjsNextMotion(2, "まわる", 4)
	helper_f3577a67(22)
	if vm.skipping() then
		return skip(97)
	end
	event.EohSetMotion(0, "ライトに飛ぶL", 4)
	event.SetReference(10, "mints", 0)
	event.ObjsSePlay(2, var1, 25)
	event.ObjsSeDelay(2, 134)
	event.ObjsSePlay(2, var1, 25)
	event.StreamClose(1)
	event.StreamOpen3(1, 40040)
	var0 = helper_1ce6fe56(1)
	if vm.skipping() then
		return skip(98)
	end
	helper_f3577a67(vm.i32(80 - var0))
	if vm.skipping() then
		return skip(99)
	end
	event.CmrsSetPos(-189.64, 319.88, 278.88)
	event.CmrsSetRef(23.52, 338.95, 28.18)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.ObjsSetPos(3, -23.05, 328.26, 0.0)
	event.ObjsSetRot(3, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(3, "棒の上立ち(正面）L", 4, 0.02)
	event.ObjsSetMotionNowTime(3, 1.4)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.ObjsSetPos(4, 7.4, 327.14, 0.0)
	event.ObjsSetRot(4, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(4, "棒の上立ち(正面）L", 4, 0.02)
	event.ObjsSetMotionNowTime(4, 2.6000001)
	event.ObjsInit(5)
	event.ObjsSyncObj(5, 5)
	event.ObjsSetPos(5, 38.44, 327.39, 0.0)
	event.ObjsSetRot(5, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(5, "棒の上立ち(正面）L", 4)
	event.ObjsPosDelay(4, 100)
	event.ObjsMotionDelay(4, 100)
	event.ObjsSetMotion(4, "ライトに飛ぶ", 6)
	event.ObjsPosDelay(4, 10)
	event.ObjsJump(4, 13.2, 315.39, 40.3, -0.4, 14)
	event.ObjsPosDelay(5, 105)
	event.ObjsMotionDelay(5, 105)
	event.ObjsRotDelay(5, 105)
	event.ObjsSetMotion(5, "ライトに飛ぶ", 6)
	event.ObjsPosDelay(5, 10)
	event.ObjsRotDelay(5, 10)
	event.ObjsJump(5, 28.98, 312.19, 49.95, -0.4, 14)
	event.ObjsRotation(5, 0.0, -0.84, 0.0, 14)
	event.ObjsPosDelay(3, 109)
	event.ObjsMotionDelay(3, 109)
	event.ObjsRotDelay(3, 109)
	event.ObjsSetMotion(3, "ライトに飛ぶ", 6)
	event.ObjsPosDelay(3, 10)
	event.ObjsRotDelay(3, 10)
	event.ObjsJump(3, -25.86, 311.84, 49.12, -0.4, 14)
	event.ObjsRotation(3, 0.0, 0.84, 0.0, 14)
	event.StreamPlay(1)
	event.MesMake_2(0, 40040)
	helper_d76d5fd4(0, -1, 8, 0, 0)
	helper_69b77b82(0, 60)
	if vm.skipping() then
		return skip(100)
	end
	helper_781c97dd(0)
	event.SetMesPos(0, 0)
	event.StreamClose(1)
	event.StreamOpen3(1, 40045)
	event.CmrsPrdelay(30)
	event.CmrsSetPos(-208.72, 388.6, 84.96)
	event.CmrsSetRef(2.62, 320.22, 24.49)
	event.CmrsPrdelay(30)
	event.CmrsSetPos(1.55, 445.57, 288.5)
	event.CmrsSetRef(-0.46, 280.6, 24.97)
	helper_75322a53(4)
	if vm.skipping() then
		return skip(101)
	end
	event.ObjsSetPos(4, 0.0, 0.0, 0.0)
	event.ObjsSetRot(4, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(4, "つかまりL", 4)
	event.SetReference(10, "pierrot2", 12)
	helper_75322a53(5)
	if vm.skipping() then
		return skip(102)
	end
	event.ObjsSetPos(5, 0.0, 0.0, 0.0)
	event.ObjsSetRot(5, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(5, "つかまりL", 4)
	event.SetReference(10, "pierrot3", 13)
	helper_75322a53(3)
	if vm.skipping() then
		return skip(103)
	end
	event.ObjsSetPos(3, 0.0, 0.0, 0.0)
	event.ObjsSetRot(3, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(3, "つかまりL", 4)
	event.SetReference(10, "pierrot1", 11)
	helper_f4a2e06c(1)
	if vm.skipping() then
		return skip(104)
	end
	event.StreamPlay(1)
	helper_f3577a67(30)
	if vm.skipping() then
		return skip(105)
	end
	event.StreamClose(1)
	event.CmrsSetPos(16.78, 341.72, 53.54)
	event.CmrsSetRef(0.31, 383.37, 104.98)
	event.CharaActive(0, 11)
	event.CharaActive(0, 12)
	event.CharaActive(0, 13)
	event.CharaActive(19)
	event.CharaActive(0, 18)
	event.ObjsSetPos(2, 0.0, -1000.0, 0.0)
	event.ObjsSetMotion(10, "ちぎれそう", 6)
	event.ObjsSetMotionNowTime(10, 3.0)
	event.SndSePlay(var1, 32)
	helper_f3577a67(60)
	if vm.skipping() then
		return skip(106)
	end
	event.CharaActive(18)
	event.CharaActive(0, 19)
	event.ObjsSetPos(2, 0.0, 0.0, 0.0)
	event.CmrsSyncObj(0, 0.0, 0.0, 0.0, -0.4, 20.0, 20.0, "bcol00", 2)
	event.ObjsSetMotion(0, "見上げる", 2)
	event.ObjsNextMotion(0, "見上げるL", 4)
	event.ObjsTexaDelay(0, 15)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "落ちるー（３）")
	event.ObjsTexAnime(0, 1, "大口")
	event.StreamOpen3(1, 40050)
	var0 = helper_1ce6fe56(1)
	if vm.skipping() then
		return skip(107)
	end
	event.StreamPlay(1)
	event.MesMake_2(0, 40050)
	helper_d76d5fd4(0, -1, 8, 0, 0)
	helper_69b77b82(0, vm.i32(60 - var0))
	if vm.skipping() then
		return skip(108)
	end
	helper_781c97dd(0)
	event.SetMesPos(0, 0)
	helper_75322a53(0)
	if vm.skipping() then
		return skip(109)
	end
	event.StreamClose(1)
	event.CmrsReleaseObj()
	event.CmrsSetPos(16.78, 341.72, 53.54)
	event.CmrsSetRef(0.31, 383.37, 104.98)
	event.ObjsSetPos(2, 0.0, -1000.0, 0.0)
	event.CharaActive(0, 18)
	event.CharaActive(19)
	event.ObjsSetMotion(10, "ちぎれそう待機", 6)
	event.StreamOpen3(1, 40060)
	helper_f3577a67(10)
	if vm.skipping() then
		return skip(110)
	end
	event.ObjsSetMotion(10, "ちぎれる", 6)
	event.ObjsSeDelay(10, 4)
	event.ObjsSePlay(10, var1, 26)
	helper_f3577a67(58)
	if vm.skipping() then
		return skip(111)
	end
	helper_f4a2e06c(1)
	if vm.skipping() then
		return skip(112)
	end
	event.CharaActive(0, 19)
	event.ObjsSetPos(2, 0.0, 0.0, 0.0)
	event.CmrsSyncObj(0, 0.0, 0.0, 8.0, -0.16, 15.0, 20.0, "bcol00", 2)
	event.ObjsMotionDelay(6, 30)
	event.SndSePlay(var1, 33)
	event.CmrsCharaAttach(8, 60.0, 30)
	event.CharaActive(8)
	event.CharaActive(18)
	event.SetMotion(10, "落下", 6, 0.3)
	event.ObjsResetDaPosition(0)
	event.ObjsSeDelay(0, 1)
	event.ObjsResetDaPosition(0)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "落ちるー（３）")
	event.ObjsTexAnime(0, 1, "大口")
	event.StreamPlay(1)
	event.MesMake_2(0, 40060)
	helper_d76d5fd4(0, -1, 8, 0, 0)
	helper_69b77b82(0, 30)
	if vm.skipping() then
		return skip(113)
	end
	helper_781c97dd(0)
	event.SetMesPos(0, 0)
	helper_75322a53(6)
	if vm.skipping() then
		return skip(114)
	end
	event.StreamClose(1)
	event.CmrsReleaseObj()
	event.CharaActive(0, 8)
	event.CharaActive(11)
	event.CharaActive(12)
	event.CharaActive(13)
	event.CmrsSetPos(0.0, 18.46, -95.54)
	event.CmrsSetRef(0.0, 194.33, 107.78)
	event.CmrsMove(0.0, 18.46, -95.54, 0.0, 66.62, 107.78, 30)
	event.CharaActive(0, 18)
	event.ObjsResetMotion(2)
	event.ObjsSetMotion(2, "落下", 6, 0.3)
	event.ObjsNextMotion(2, "停止", 4)
	event.ObjsSePlay(2, var1, 27)
	event.EohSetShadow(0, 1)
	helper_f3577a67(14)
	if vm.skipping() then
		return skip(115)
	end
	event.ObjsSetMotion(0, "飛び降りる", 2)
	event.ObjsNextMotion(0, "飛び降りるL", 6, 0.2)
	event.ObjsNextMotion(0, "ライトから着地", 6)
	event.ObjsMotionWait(0)
	event.ObjsMotionDelay(0, 10)
	helper_f3577a67(10)
	if vm.skipping() then
		return skip(116)
	end
	event.DelReference(0)
	event.ObjsSetPos(0, 0.0, 65.81, 94.16)
	event.ObjsSetRot(0, 0.0, 3.14, 0.0)
	event.ObjsJump(0, 0.0, 10.6, 6.0, -0.2, 30)
	helper_f3577a67(5)
	if vm.skipping() then
		return skip(117)
	end
	event.CharaActive(20)
	event.SetMotion(20, "けむり", 6)
	helper_19534(40062)
	if vm.skipping() then
		return skip(118)
	end
	helper_75322a53(2)
	if vm.skipping() then
		return skip(119)
	end
	event.StopBgm(0)
	event.ObjsInit(7)
	event.DelReference(11)
	event.ObjsSetPos(3, -46.01, 150.0, 50.48)
	event.ObjsSetRot(3, 0.0, 2.42, 0.0)
	event.DelReference(12)
	event.ObjsSetPos(4, -48.62, 150.0, 60.52)
	event.ObjsSetRot(4, 0.0, -2.42, 0.0)
	event.DelReference(13)
	event.ObjsSetPos(5, -35.87, 150.0, -54.34)
	event.ObjsSetRot(5, 0.0, 0.38, 0.0)
	event.CharaActive(14)
	event.EohSyncChara(20, 14)
	event.ObjsInit(20)
	event.ObjsSyncObj(20, 20)
	event.ObjsSetPos(20, 30.12, 150.0, -61.93)
	event.ObjsSetRot(20, 0.0, -0.6, 0.0)
	helper_75322a53(0)
	if vm.skipping() then
		return skip(120)
	end
	event.CmrsSetPos(1.17, 26.95, -26.03)
	event.CmrsSetRef(1.17, 33.68, 4.49)
	event.ObjsSetPos(0, 0.0, 10.0, 6.0)
	event.ObjsSetRot(0, 0.0, 3.14, 0.0)
	event.ObjsSetMotion(0, "舞台上キョロキョロ", 6)
	event.ObjsMotionWait(0)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "拍手喝采（３）")
	event.ObjsTexAnime(0, 1, "開きからにこり")
	event.ObjsSePlay(0, var1, 28)
	event.StreamClose(1)
	helper_19534(40064)
	if vm.skipping() then
		return skip(121)
	end
	helper_75322a53(0)
	if vm.skipping() then
		return skip(122)
	end
	event.CmrsSetRef(0.0, 33.68, 4.49)
	event.CmrsSetAhd(0.9, 9.0, 50.0)
	event.CmrsMoveAhd(-0.9, 9.0, 50.0, 180)
	event.ObjsSetMotion(0, "手を振る", 4)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "感動（３）")
	event.ObjsTexAnime(0, 1, "うれし口（３）")
	helper_572c09a2()
	if vm.skipping() then
		return skip(123)
	end
	event.CmrsSetPos(0.61, 45.86, -150.28)
	event.CmrsSetRef(0.57, 21.14, 5.95)
	event.CharaActive(0, 10)
	event.ObjsSetMotion(20, "落下中", 6, 0.15)
	event.ObjsNextMotion(20, "着地", 6)
	event.ObjsNextMotion(20, "立ち", 4)
	event.ObjsJump(20, 30.12, 8.8, -61.93, -0.2, 30)
	event.ObjsSeDelay(20, 30)
	event.ObjsSePlay(20, var1, 34)
	helper_f3577a67(6)
	if vm.skipping() then
		return skip(124)
	end
	event.ObjsSetMotion(3, "落下中", 6, 0.15)
	event.ObjsNextMotion(3, "着地", 6)
	event.ObjsNextMotion(3, "立ち", 4)
	event.ObjsJump(3, -46.01, 8.8, 50.48, -0.2, 30)
	event.ObjsSeDelay(3, 30)
	event.ObjsSePlay(3, var1, 34)
	helper_f3577a67(4)
	if vm.skipping() then
		return skip(125)
	end
	event.ObjsSetMotion(5, "落下中", 6, 0.15)
	event.ObjsNextMotion(5, "着地", 6)
	event.ObjsNextMotion(5, "立ち", 4)
	event.ObjsJump(5, -35.87, 8.8, -54.34, -0.2, 30)
	event.ObjsSeDelay(5, 30)
	event.ObjsSePlay(5, var1, 34)
	helper_f3577a67(3)
	if vm.skipping() then
		return skip(126)
	end
	event.ObjsSetMotion(4, "落下中", 6, 0.15)
	event.ObjsNextMotion(4, "着地", 6)
	event.ObjsNextMotion(4, "立ち", 4)
	event.ObjsJump(4, 48.62, 8.8, 60.52, -0.2, 30)
	event.ObjsSeDelay(4, 30)
	event.ObjsSePlay(4, var1, 34)
	helper_f3577a67(20)
	if vm.skipping() then
		return skip(127)
	end
	event.ObjsSetMotion(0, "キョロキョロ立ち")
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "怒り目")
	event.ObjsTexAnime(0, 1, "怒り口")
	event.StreamClose(1)
	helper_aa9a834f(40080, 30)
	if vm.skipping() then
		return skip(128)
	end
	helper_f3577a67(10)
	if vm.skipping() then
		return skip(129)
	end
	event.CmrsSetPos(-20.61, 33.01, -18.61)
	event.CmrsSetRef(1.45, 30.1, 6.28)
	event.CharaActive(0, 11)
	event.CharaActive(0, 12)
	event.ObjsSetMotion(0, "レンチを取り出す", 6)
	event.ObjsNextMotion(0, "レンチを取り出すL", 4)
	event.StreamClose(1)
	event.StreamOpen3(1, 40082)
	var0 = helper_1ce6fe56(1)
	if vm.skipping() then
		return skip(130)
	end
	event.StreamPlay(1)
	helper_f3577a67(vm.i32(40 - var0))
	if vm.skipping() then
		return skip(131)
	end
	event.EohSyncChara(21, 1)
	event.EohSetShow(21, 1)
	helper_f3577a67(46)
	if vm.skipping() then
		return skip(132)
	end
	event.ObjsSePlay(0, var1, 35)
	helper_75322a53(0)
	if vm.skipping() then
		return skip(133)
	end
	helper_f3577a67(30)
	if vm.skipping() then
		return skip(134)
	end
	event.StreamClose(1)
	event.CmrsSetPos(-4.51, 25.29, -32.6)
	event.CmrsSetRef(1.45, 30.1, 6.28)
	event.ObjsSetMotion(0, "かまえる", 6)
	event.ObjsNextMotion(0, "かまえるL", 4)
	event.ObjsSeDelay(0, 4)
	event.ObjsSePlay(0, var1, 36)
	helper_19534(40083)
	if vm.skipping() then
		return skip(135)
	end
	helper_75322a53(0)
	if vm.skipping() then
		return skip(136)
	end
	helper_f3577a67(30)
	if vm.skipping() then
		return skip(137)
	end
	event.StreamClose(1)
	event.CmrsFadeInit()
	event.CmrsFadeOut(30)
	helper_572c09a2()
	if vm.skipping() then
		return skip(138)
	end
	return part2()
end

--- Helper function.
local function helper_b8bc()
	local var0: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 118 then
			if at <= 1 then
				helper_9a391372()
			end
			if at <= 2 then
				helper_572c09a2()
			end
			if at <= 3 then
				helper_aa9a834f(30010, 160)
			end
			if at <= 4 then
				helper_aa9a834f(30020, 190)
			end
			if at <= 5 then
				helper_aa9a834f(30025, 60)
			end
			if at <= 6 then
				helper_aa9a834f(30030, 20)
			end
			if at <= 7 then
				helper_75322a53(0)
			end
			if at <= 8 then
				helper_aa9a834f(30040, 30)
			end
			if at <= 9 then
				helper_75322a53(0)
			end
			if at <= 10 then
				helper_aa9a834f(30050, 150)
			end
			if at <= 11 then
				helper_75322a53(0)
			end
			if at <= 12 then
				helper_f4a2e06c(1)
			end
			if at <= 13 then
				helper_d76d5fd4(0, -1, 8, 0, 0)
				helper_75322a53(0)
			end
			if at <= 14 then
				helper_75322a53(0)
			end
			if at <= 15 then
				helper_f3577a67(90)
			end
			if at <= 16 then
				helper_781c97dd(0)
				helper_572c09a2()
			end
			if at <= 17 then
				helper_f3577a67(30)
			end
			if at <= 18 then
				helper_75322a53(0)
			end
			if at <= 19 then
				helper_75322a53(0)
			end
			if at <= 20 then
				helper_f3577a67(30)
			end
			if at <= 21 then
				helper_aa9a834f(30060, 100)
			end
			if at <= 22 then
				helper_75322a53(0)
			end
			if at <= 23 then
				helper_f3577a67(30)
			end
			if at <= 24 then
				helper_aa9a834f(30070, 120)
			end
			if at <= 25 then
				helper_aa9a834f(30080, 90)
			end
			if at <= 26 then
				helper_572c09a2()
			end
			if at <= 27 then
				helper_aa9a834f(30090, 180)
			end
			if at <= 28 then
				helper_75322a53(1)
			end
			if at <= 29 then
				helper_aa9a834f(30100, 190)
			end
			if at <= 30 then
				helper_75322a53(1)
			end
			if at <= 31 then
				helper_75322a53(1)
			end
			if at <= 32 then
				helper_aa9a834f(30110, 86)
			end
			if at <= 33 then
				helper_aa9a834f(30115, 60)
			end
			if at <= 34 then
				helper_aa9a834f(30120, 220)
			end
			if at <= 35 then
				helper_aa9a834f(30130, 100)
			end
			if at <= 36 then
				helper_aa9a834f(30140, 40)
			end
			if at <= 37 then
				helper_75322a53(1)
			end
			if at <= 38 then
				helper_aa9a834f(30143, 200)
			end
			if at <= 39 then
				helper_aa9a834f(30146, 160)
			end
			if at <= 40 then
				helper_75322a53(1)
			end
			if at <= 41 then
				helper_aa9a834f(30150, 140)
			end
			if at <= 42 then
				helper_f3577a67(4)
			end
			if at <= 43 then
				helper_f3577a67(10)
			end
			if at <= 45 then
				helper_aa9a834f(30160, 120)
			end
			if at <= 46 then
				helper_75322a53(1)
			end
			if at <= 47 then
				helper_aa9a834f(30170, 94)
			end
			if at <= 48 then
				helper_aa9a834f(30175, 140)
			end
			if at <= 49 then
				helper_f3577a67(60)
			end
			if at <= 50 then
				helper_f3577a67(14)
			end
			if at <= 51 then
				helper_aa9a834f(30180, 90)
			end
			if at <= 52 then
				helper_f3577a67(30)
			end
			if at <= 53 then
				helper_aa9a834f(30190, 200)
			end
			if at <= 54 then
				helper_75322a53(1)
			end
			if at <= 55 then
				helper_aa9a834f(30195, 200)
			end
			if at <= 56 then
				helper_aa9a834f(30200, 230)
			end
			if at <= 57 then
				helper_75322a53(1)
			end
			if at <= 58 then
				helper_aa9a834f(30205, 100)
			end
			if at <= 59 then
				helper_75322a53(1)
			end
			if at <= 60 then
				helper_aa9a834f(30210, 80)
			end
			if at <= 61 then
				helper_aa9a834f(30215, 180)
			end
			if at <= 62 then
				helper_75322a53(0)
			end
			if at <= 63 then
				helper_75322a53(1)
			end
			if at <= 64 then
				helper_aa9a834f(30220, 340)
			end
			if at <= 65 then
				helper_75322a53(1)
			end
			if at <= 66 then
				helper_aa9a834f(30225, 90)
			end
			if at <= 67 then
				helper_75322a53(1)
			end
			if at <= 68 then
				helper_f3577a67(30)
			end
			if at <= 69 then
				helper_aa9a834f(30230, 30)
			end
			if at <= 70 then
				helper_75322a53(1)
			end
			if at <= 71 then
				helper_75322a53(2)
			end
			if at <= 72 then
				helper_75322a53(1)
			end
			if at <= 73 then
				helper_f3577a67(15)
			end
			if at <= 74 then
				helper_572c09a2()
			end
			if at <= 75 then
				helper_aa9a834f(30240, 40)
			end
			if at <= 76 then
				helper_aa9a834f(30250, 60)
			end
			if at <= 77 then
				helper_aa9a834f(30260, 80)
			end
			if at <= 78 then
				helper_75322a53(2)
			end
			if at <= 79 then
				helper_f4a2e06c(1)
			end
			if at <= 80 then
				helper_f3577a67(20)
			end
			if at <= 81 then
				helper_75322a53(0)
			end
			if at <= 82 then
				helper_75322a53(0)
			end
			if at <= 83 then
				helper_f3577a67(30)
			end
			if at <= 84 then
				helper_aa9a834f(30270, 120)
			end
			if at <= 85 then
				helper_75322a53(1)
			end
			if at <= 86 then
				helper_f3577a67(3)
			end
			if at <= 87 then
				helper_f3577a67(4)
			end
			if at <= 88 then
				helper_f3577a67(5)
			end
			if at <= 89 then
				helper_f3577a67(5)
			end
			if at <= 90 then
				helper_f3577a67(20)
			end
			if at <= 91 then
				helper_f3577a67(6)
			end
			if at <= 92 then
				helper_f3577a67(3)
			end
			if at <= 93 then
				helper_f3577a67(2)
			end
			if at <= 94 then
				helper_75322a53(4)
			end
			if at <= 95 then
				helper_75322a53(5)
			end
			if at <= 96 then
				helper_75322a53(6)
			end
			if at <= 97 then
				helper_f3577a67(30)
			end
			if at <= 98 then
				helper_aa9a834f(30280, 160)
			end
			if at <= 99 then
				helper_aa9a834f(30285, 180)
			end
			if at <= 100 then
				helper_572c09a2()
			end
			if at <= 101 then
				helper_aa9a834f(30290, 90)
			end
			if at <= 102 then
				helper_75322a53(1)
			end
			if at <= 103 then
				helper_f3577a67(5)
			end
			if at <= 104 then
				helper_f3577a67(3)
			end
			if at <= 105 then
				helper_f3577a67(1)
			end
			if at <= 106 then
				helper_75322a53(1)
			end
			if at <= 107 then
				helper_75322a53(3)
			end
			if at <= 108 then
				helper_75322a53(4)
			end
			if at <= 109 then
				helper_75322a53(5)
			end
			if at <= 110 then
				helper_75322a53(6)
			end
			if at <= 111 then
				helper_f3577a67(20)
			end
			if at <= 112 then
				helper_f3577a67(26)
			end
			if at <= 113 then
				helper_f3577a67(20)
			end
			if at <= 114 then
				helper_f3577a67(43)
			end
			if at <= 115 then
				helper_f3577a67(32)
			end
			if at <= 116 then
				helper_f3577a67(70)
			end
			if at <= 117 then
				helper_572c09a2()
			end
			if vm.skip_end() then
				return skip(119)
			end
			return part2()
		end
		var3 = 0
		var3 = var3 + 1
	end
	function part2()
		event.CancelDramaScene()
		event.StreamClose(1)
		event.LoadMes(0, -1)
		event.EohSetShow(29, 1)
		event.EohSetShow(30, 1)
		event.EohSetShow(31, 1)
		event.DelExtMotion(0)
		var3 = 0
		while var3 < 30 do
			event.ObjsInit(var3)
			var3 = var3 + 1
		end
		event.DeleteChara(9)
		event.DeleteChara(10)
		event.DeleteChara(11)
		event.DeleteChara(12)
		event.DeleteChara(13)
		event.DeleteChara(14)
		event.CharaActive(0)
		event.StopBgm(0)
		event.StopEnvBgm()
	end
	event.Initialize()
	event.InitDramaScene()
	event.SetMesWindowMode(0, 7)
	event.LoadSound(1215)
	event.AssignStack(5)
	event.ClearStack(5)
	var0 = event.SndLoadSound(1215) or var0
	event.LoadMes(0, 5, "event/opening/p3/op3.txt")
	event.LoadMotion(5, "event/opening/p3/p3_mints.gltf", "info", 0)
	event.CharaActive(0)
	event.EohSyncChara(0, 0)
	event.EohSetFootSoundId(0, 3)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetPos(0, 515.79, 133.45, -51.32)
	event.ObjsSetRot(0, 0.0, 0.12, 0.0)
	event.ObjsSetMotion(0, "右向き立ち", 4)
	event.ObjsNormalDrive(0)
	event.ObjsResetDaPosition(0)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "キラキラ目")
	event.ObjsTexAnime(0, 1, "感激口")
	event.LoadChara(5, "event/opening/p3/p3_polcurse.gltf", "info", 9)
	event.CharaActive(9)
	event.EohSyncChara(1, 9)
	event.EohSetSoundId(1, var0)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.ObjsSetPos(1, 403.49, 0.0, 348.3)
	event.ObjsSetRot(1, 0.0, 1.5, 0.0)
	event.ObjsSetMotion(1, "立ち", 4)
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "目パチ")
	event.LoadChara(5, "event/opening/p3/p3_need.gltf", "info", 10)
	event.CharaActive(10)
	event.EohSyncChara(2, 10)
	event.EohSetSoundId(2, var0)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.ObjsSetPos(2, 403.49, 0.0, 348.3)
	event.ObjsSetRot(2, 0.0, 1.5, 0.0)
	event.ObjsSetMotion(2, "立ち", 4)
	event.ObjsTexAnime(2, 0)
	var1 = event.EohGetFrameStatus(2, "hand1") or var1
	var2 = 3
	event.EohSetFrameStatus(2, "hand2", 0)
	event.SetLoadbgFile("event/opening/p3/p3_pierrot.gltf")
	if vm.wait() then
		return skip(1)
	end
	helper_9a391372()
	if vm.skipping() then
		return skip(2)
	end
	event.LoadChara(5, "event/opening/p3/p3_pierrot.gltf", "info", 11)
	event.CharaActive(0, 11)
	event.EohSyncChara(3, 11)
	event.EohSetSoundId(3, var0)
	event.EohSetFrameShow(3, "obj10", 0)
	event.EohSetFrameShow(3, "obj11", 0)
	event.EohSetFrameShow(3, "obj6", 0)
	event.EohSetFrameShow(3, "obj4", 0)
	event.EohSetShadow(3, 0)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.ObjsSetPos(3, 308.7, -100.0, 243.42)
	event.ObjsSetRot(3, 0.0, -2.64, 0.0)
	event.ObjsSetMotion(3, "立ち", 4)
	event.CopyChara(5, 11, 12)
	event.CharaActive(0, 12)
	event.EohSyncChara(4, 12)
	event.EohSetSoundId(4, var0)
	event.EohSetFrameShow(4, "obj10", 0)
	event.EohSetFrameShow(4, "obj11", 0)
	event.EohSetFrameShow(4, "obj6", 0)
	event.EohSetFrameShow(4, "obj4", 0)
	event.EohSetShadow(4, 0)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.ObjsSetPos(4, 308.7, -100.0, 243.42)
	event.ObjsSetRot(4, 0.0, -2.64, 0.0)
	event.ObjsSetMotion(4, "立ち", 4)
	event.CopyChara(5, 11, 13)
	event.CharaActive(0, 13)
	event.EohSyncChara(5, 13)
	event.EohSetSoundId(5, var0)
	event.EohSetFrameShow(5, "obj10", 0)
	event.EohSetFrameShow(5, "obj11", 0)
	event.EohSetFrameShow(5, "obj6", 0)
	event.EohSetFrameShow(5, "obj4", 0)
	event.EohSetShadow(5, 0)
	event.ObjsInit(5)
	event.ObjsSyncObj(5, 5)
	event.ObjsSetPos(5, 308.7, -100.0, 243.42)
	event.ObjsSetRot(5, 0.0, -2.64, 0.0)
	event.ObjsSetMotion(5, "立ち", 4)
	event.CopyChara(5, 11, 14)
	event.CharaActive(0, 14)
	event.EohSyncChara(6, 14)
	event.EohSetSoundId(6, var0)
	event.EohSetFrameShow(6, "obj10", 0)
	event.EohSetFrameShow(6, "obj11", 0)
	event.EohSetFrameShow(6, "obj6", 0)
	event.EohSetFrameShow(6, "obj4", 0)
	event.EohSetShadow(6, 0)
	event.ObjsInit(6)
	event.ObjsSyncObj(6, 6)
	event.ObjsSetPos(6, 308.7, -100.0, 243.42)
	event.ObjsSetRot(6, 0.0, -2.64, 0.0)
	event.ObjsSetMotion(6, "立ち", 4)
	event.EohSyncObj(8, "p04_i03h02a-3", "i03h02a_09-m")
	event.ObjsInit(8)
	event.ObjsSyncObj(8, 8)
	event.EohSyncObj(9, "p04_i03h02a-3", "i03h02a_09-m1")
	event.ObjsInit(9)
	event.ObjsSyncObj(9, 9)
	event.EohSyncObj(11, "p04_i03h02a-1", "i03h02a_09-m")
	event.ObjsInit(11)
	event.ObjsSyncObj(11, 11)
	event.EohSyncObj(12, "p04_i03h02a-1", "i03h02a_09-m1")
	event.ObjsInit(12)
	event.ObjsSyncObj(12, 12)
	event.EohSyncObj(14, "p04_i03h02a-4", "i03h02a_09-m")
	event.ObjsInit(14)
	event.ObjsSyncObj(14, 14)
	event.EohSyncObj(15, "p04_i03h02a-4", "i03h02a_09-m1")
	event.ObjsInit(15)
	event.ObjsSyncObj(15, 15)
	event.EohSyncObj(17, "p04_i03h02a-7", "i03h02a_09-m")
	event.ObjsInit(17)
	event.ObjsSyncObj(17, 17)
	event.EohSyncObj(18, "p04_i03h02a-7", "i03h02a_09-m1")
	event.ObjsInit(18)
	event.ObjsSyncObj(18, 18)
	event.EohSyncObj(20, "p04_i03h02a-5", "i03h02a_09-m")
	event.ObjsInit(20)
	event.ObjsSyncObj(20, 20)
	event.EohSyncObj(21, "p04_i03h02a-5", "i03h02a_09-m1")
	event.ObjsInit(21)
	event.ObjsSyncObj(21, 21)
	event.EohSyncObj(23, "p04_i03h02a-6", "i03h02a_09-m")
	event.ObjsInit(23)
	event.ObjsSyncObj(23, 23)
	event.EohSyncObj(24, "p04_i03h02a-6", "i03h02a_09-m1")
	event.ObjsInit(24)
	event.ObjsSyncObj(24, 24)
	event.EohSyncObj(26, "p04_i03h02a-2", "i03h02a_09-m")
	event.ObjsInit(26)
	event.ObjsSyncObj(26, 26)
	event.EohSyncObj(27, "p04_i03h02a-2", "i03h02a_09-m1")
	event.ObjsInit(27)
	event.ObjsSyncObj(27, 27)
	event.EohSyncObj(28, "p10_i03h02a-3")
	event.EohSetShow(28, 1)
	event.ObjsInit(28)
	event.ObjsSyncObj(28, 28)
	event.ObjsSetPos(28, 522.4, 133.457, 264.31)
	event.ObjsSetRot(28, 0.0, 2.07, 0.0)
	event.EohSyncObj(29, "p05_i03h02")
	event.EohSetShow(29, 1)
	event.EohSyncObj(30, "p12_i03h02")
	event.EohSetShow(30, 1)
	event.EohSyncObj(31, "p11_i03h02a")
	event.EohSetShow(31, 1)
	event.PlayEnvBgm(0, -1)
	event.CmrsInit()
	event.CmrsSetPos(490.95, 150.85, -36.92)
	event.CmrsSetRef(516.0, 155.52, -52.16)
	event.CmrsFadeInit()
	event.CmrsFadeIn(120)
	helper_572c09a2()
	if vm.skipping() then
		return skip(3)
	end
	helper_aa9a834f(30010, 160)
	if vm.skipping() then
		return skip(4)
	end
	helper_aa9a834f(30020, 190)
	if vm.skipping() then
		return skip(5)
	end
	helper_aa9a834f(30025, 60)
	if vm.skipping() then
		return skip(6)
	end
	event.ObjsSetMotion(0, "左を見る", 6)
	event.ObjsNextMotion(0, "左を見るL", 4)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "気づく目")
	event.ObjsTexAnime(0, 1, "気づく口")
	helper_aa9a834f(30030, 20)
	if vm.skipping() then
		return skip(7)
	end
	helper_75322a53(0)
	if vm.skipping() then
		return skip(8)
	end
	event.SndSePlay(var0, 2)
	event.ObjsSetMotion(0, "左を向く", 6)
	event.ObjsMotionWait(0)
	event.SetPakuAnim(0, "口パク", "気づく口")
	helper_aa9a834f(30040, 30)
	if vm.skipping() then
		return skip(9)
	end
	event.ResetPakuAnim()
	helper_75322a53(0)
	if vm.skipping() then
		return skip(10)
	end
	event.CmrsSetPos(464.32, 205.65, -101.4)
	event.CmrsSetRef(530.94, 172.86, -6.08)
	event.ObjsTexAnime(0, 0)
	event.ObjsSetMotion(0, "歩き", 4)
	event.ObjsInitPas(0)
	event.ObjsSetPasFrm(0, 160)
	event.ObjsAddPas(0, 515.79, 133.45, -51.32)
	event.ObjsAddPas(0, 541.57, 133.45, -26.11)
	event.ObjsAddPas(0, 567.71, 133.45, 15.9)
	event.ObjsAddPas(0, 579.59, 133.45, 67.16)
	event.ObjsAddPas(0, 575.7, 133.45, 112.7)
	event.ObjsStartPas(0)
	helper_aa9a834f(30050, 150)
	if vm.skipping() then
		return skip(11)
	end
	helper_75322a53(0)
	if vm.skipping() then
		return skip(12)
	end
	event.CmrsSetPos(600.01, 181.57, 350.2)
	event.CmrsSetRef(572.65, 156.22, 246.87)
	event.SetBgmVolFloat(0.4)
	event.SndSetEnvVol(0.3)
	event.ObjsSetPos(0, 576.02, 133.45, 143.2)
	event.ObjsSetRot(0, 0.0, -0.29, 0.0)
	event.ObjsMove(0, 559.81, 133.45, 206.55, 90)
	event.ObjsSetMotion(0, "きょろきょろ歩き", 4)
	event.ObjsTexAnime(0, 1, "キョロキョロ")
	event.ObjsTexAnime(0, 1, "半開き口")
	event.StreamOpen3(1, 30053)
	helper_f4a2e06c(1)
	if vm.skipping() then
		return skip(13)
	end
	event.StreamPlay(1)
	event.SetMesOkuri(0, 0)
	event.MesMake_2(0, 30053)
	helper_d76d5fd4(0, -1, 8, 0, 0)
	helper_75322a53(0)
	if vm.skipping() then
		return skip(14)
	end
	event.CmrsSetPos(574.34, 203.79, 190.06)
	event.CmrsSetRef(543.29, 142.99, 227.79)
	event.CmrsMove2(557.65, 203.79, 250.72, 526.69, 142.99, 288.12, 180, 2, 0.4)
	event.ObjsSetMotion(0, "歩き", 4)
	event.ObjsTexAnime(0, 0)
	event.ObjsSetPos(0, 547.89, 133.45, 215.23)
	event.ObjsSetRot(0, 0.0, -0.29, 0.0)
	event.ObjsMove(0, 534.64, 133.45, 265.0, 90)
	helper_75322a53(0)
	if vm.skipping() then
		return skip(15)
	end
	event.ObjsSetMotion(0, "旧・立ち", 2)
	event.ObjsMotionWait(0)
	helper_f3577a67(90)
	if vm.skipping() then
		return skip(16)
	end
	event.FadeOutBgm(90)
	helper_781c97dd(0)
	event.SetMesOkuri(0, 1)
	event.StreamClose(1)
	helper_572c09a2()
	if vm.skipping() then
		return skip(17)
	end
	helper_f3577a67(30)
	if vm.skipping() then
		return skip(18)
	end
	helper_75322a53(0)
	if vm.skipping() then
		return skip(19)
	end
	event.ObjsSetMotion(0, "手をかける", 6)
	event.ObjsMotionWait(0)
	helper_75322a53(0)
	if vm.skipping() then
		return skip(20)
	end
	event.CmrsSetPos(526.24, 130.39, 294.97)
	event.CmrsSetRef(532.61, 159.94, 272.03)
	event.SndSePlay(var0, 3)
	event.ObjsSetMotion(0, "身を乗りだす", 6)
	event.ObjsNextMotion(0, "身を乗りだすL", 4)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "怒り口")
	event.ObjsTexaDelay(0, 25)
	event.ObjsTexAnime(0, 1, "目パチ×2")
	event.ObjsTexaDelay(0, 30)
	event.ObjsTexAnime(0, 0, "目パチ×2")
	event.ObjsTexAnime(0, 1, "目パチ×2")
	helper_f3577a67(30)
	if vm.skipping() then
		return skip(21)
	end
	event.StopBgm(0)
	event.SetPakuAnim(0, "口パク", "怒り口")
	helper_aa9a834f(30060, 100)
	if vm.skipping() then
		return skip(22)
	end
	event.ResetPakuAnim()
	helper_75322a53(0)
	if vm.skipping() then
		return skip(23)
	end
	event.LoadBgm(105)
	event.PlayBgm(0, -1)
	event.ObjsTexAnime(0, 0)
	event.EohSetShadow(0, 0)
	event.CmrsSetPos(318.23, 129.69, 487.51)
	event.CmrsSetRef(414.66, 124.25, 406.31)
	event.CmrsMove(318.23, 37.87, 487.51, 414.66, 32.43, 406.31, 260)
	event.EohSetShow(29, 0)
	event.EohSetShow(30, 0)
	helper_f3577a67(30)
	if vm.skipping() then
		return skip(24)
	end
	helper_aa9a834f(30070, 120)
	if vm.skipping() then
		return skip(25)
	end
	helper_aa9a834f(30080, 90)
	if vm.skipping() then
		return skip(26)
	end
	helper_572c09a2()
	if vm.skipping() then
		return skip(27)
	end
	event.CmrsSetPos(443.82, 30.29, 368.2)
	event.CmrsSetRef(405.19, 24.85, 336.85)
	event.ObjsSetMotion(1, "つつく", 2)
	event.ObjsNextMotion(1, "つつくL", 4)
	event.ObjsSetMotion(2, "つつく", 2)
	event.ObjsNextMotion(2, "つつくL", 4)
	event.ObjsSeDelay(1, 4)
	event.ObjsSePlay(1, var0, 4)
	event.SetPakuAnim(1, "口パク")
	helper_aa9a834f(30090, 180)
	if vm.skipping() then
		return skip(28)
	end
	event.ResetPakuAnim()
	helper_75322a53(1)
	if vm.skipping() then
		return skip(29)
	end
	event.ObjsSetMotion(1, "頭をたたく", 2)
	event.ObjsNextMotion(1, "頭をたたくL", 6)
	event.ObjsMotionWait(1)
	event.ObjsResetMotion(1)
	event.ObjsSetMotion(1, "頭をたたくL", 6)
	event.ObjsNextMotion(1, "頭をたたくL2", 4)
	event.ObjsSetMotion(2, "頭をたたく", 2)
	event.ObjsNextMotion(2, "頭をたたくL", 6)
	event.ObjsMotionWait(2)
	event.ObjsResetMotion(2)
	event.ObjsSetMotion(2, "頭をたたくL", 6)
	event.ObjsNextMotion(2, "頭をたたくL2", 4)
	event.SetPakuAnim(1, "口パク", "怒り口")
	helper_aa9a834f(30100, 190)
	if vm.skipping() then
		return skip(30)
	end
	event.ResetPakuAnim()
	helper_75322a53(1)
	if vm.skipping() then
		return skip(31)
	end
	event.ObjsSetMotion(1, "頭をたたく戻り", 6)
	event.ObjsNextMotion(1, "腰に手L", 4)
	event.ObjsSetMotion(2, "頭をたたく戻り", 6)
	event.ObjsNextMotion(2, "立ち")
	helper_75322a53(1)
	if vm.skipping() then
		return skip(32)
	end
	event.CmrsSetPos(408.45, 24.17, 357.28)
	event.CmrsSetRef(431.13, 26.09, 350.29)
	event.ObjsTexAnime(2, 1, "困り瞬き")
	event.ObjsSetMotion(2, "会話", 2)
	event.ObjsNextMotion(2, "立ち", 4)
	event.SetPakuAnim(2, "口パク", "困り口")
	helper_aa9a834f(30110, 86)
	if vm.skipping() then
		return skip(33)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(2, "口パク", "困り口")
	helper_aa9a834f(30115, 60)
	if vm.skipping() then
		return skip(34)
	end
	event.ResetPakuAnim()
	event.CmrsSetPos(382.77, 29.94, 373.27)
	event.CmrsSetRef(425.01, 23.0, 337.65)
	event.SetPakuAnim(1, "口パク", "怒り口")
	helper_aa9a834f(30120, 220)
	if vm.skipping() then
		return skip(35)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(2, "会話", 2)
	event.ObjsNextMotion(2, "立ち", 4)
	event.SetPakuAnim(2, "口パク", "困り口")
	helper_aa9a834f(30130, 100)
	if vm.skipping() then
		return skip(36)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(1, "うなづく", 6)
	event.ObjsMotionWait(1)
	event.ObjsSeDelay(1, 6)
	event.ObjsSePlay(1, var0, 7)
	event.SetPakuAnim(1, "口パク", "怒り口")
	helper_aa9a834f(30140, 40)
	if vm.skipping() then
		return skip(37)
	end
	event.ResetPakuAnim()
	helper_75322a53(1)
	if vm.skipping() then
		return skip(38)
	end
	event.CmrsSetPos(432.14, 25.02, 368.63)
	event.CmrsSetRef(402.39, 25.98, 348.56)
	event.ObjsSetMotion(1, "鼻ぴくぴく", 6)
	event.ObjsMotionWait(1)
	event.ObjsResetMotion(1)
	event.ObjsSetMotion(1, "鼻ぴくぴく", 4)
	event.ObjsTexAnime(1, 1, "クンクン目")
	event.SetPakuAnim(1, "口パク", "怒り口")
	helper_aa9a834f(30143, 200)
	if vm.skipping() then
		return skip(39)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(1, "口パク", "怒り口")
	helper_aa9a834f(30146, 160)
	if vm.skipping() then
		return skip(40)
	end
	event.ResetPakuAnim()
	helper_75322a53(1)
	if vm.skipping() then
		return skip(41)
	end
	event.CmrsSetPos(408.45, 24.17, 357.28)
	event.CmrsSetRef(431.13, 26.09, 350.29)
	event.ObjsSetMotion(1, "立ち")
	event.ObjsSetMotion(2, "会話", 2)
	event.ObjsNextMotion(2, "立ち", 4)
	event.SetPakuAnim(2, "口パク", "困り口")
	helper_aa9a834f(30150, 140)
	if vm.skipping() then
		return skip(42)
	end
	event.ResetPakuAnim()
	event.CmrsSetPos(382.77, 29.94, 373.27)
	event.CmrsSetRef(425.01, 23.0, 337.65)
	helper_f3577a67(4)
	if vm.skipping() then
		return skip(43)
	end
	event.ObjsTexAnime(1, 0, "クンクン目")
	event.ObjsTexAnime(1, 1, "怒り目")
	event.ObjsTexAnime(1, 1, "怒り口")
	event.ObjsSetMotion(1, "シメル", 6)
	event.ObjsNextMotion(1, "シメルL", 4)
	event.ObjsMotionDelay(1, 30)
	event.ObjsSetMotion(2, "シメル", 6)
	event.ObjsNextMotion(2, "シメルL", 4)
	helper_f3577a67(10)
	if vm.skipping() then
		return skip(44)
	end
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "痛がり目")
	event.ObjsTexAnime(2, 1, "痛がり口")
	if vm.wait() then
		return skip(45)
	end
	event.SetPakuAnim(2, "口パク", "痛がり口")
	helper_aa9a834f(30160, 120)
	if vm.skipping() then
		return skip(46)
	end
	event.ResetPakuAnim()
	event.CmrsSetPos(455.51, 42.59, 306.46)
	event.CmrsSetRef(415.88, 17.86, 345.25)
	event.EohSetFrameStatus(2, "hand1", 0)
	event.EohSetFrameStatus(2, "hand2", var2)
	helper_75322a53(1)
	if vm.skipping() then
		return skip(47)
	end
	event.SetPakuAnim(1, "口パク", "怒り口")
	helper_aa9a834f(30170, 94)
	if vm.skipping() then
		return skip(48)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(1, "口パク", "怒り口")
	helper_aa9a834f(30175, 140)
	if vm.skipping() then
		return skip(49)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(1, "蹴る", 6)
	event.ObjsNextMotion(1, "踏みつけL", 6)
	event.ObjsMotionWait(1)
	event.ObjsResetMotion(1)
	event.ObjsSetMotion(1, "踏みつけL", 6)
	event.ObjsNextMotion(1, "踏みつけL2", 4)
	event.ObjsSetMotion(2, "蹴る", 6)
	event.ObjsNextMotion(2, "踏みつけL", 6)
	event.ObjsMotionWait(2)
	event.ObjsResetMotion(2)
	event.ObjsSetMotion(2, "踏みつけL", 6)
	event.ObjsNextMotion(2, "踏みつけL2", 4)
	helper_f3577a67(60)
	if vm.skipping() then
		return skip(50)
	end
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "苦しがり目")
	event.ObjsTexAnime(2, 1, "苦しがり口")
	event.CmrsSetPos(504.32, 2.39, 361.02)
	event.CmrsSetRef(456.2, 16.46, 340.74)
	event.EohSetFrameStatus(2, "hand1", var1)
	event.EohSetFrameStatus(2, "hand2", 0)
	helper_f3577a67(14)
	if vm.skipping() then
		return skip(51)
	end
	event.SetPakuAnim(2, "口パク", "苦しがり口")
	helper_aa9a834f(30180, 90)
	if vm.skipping() then
		return skip(52)
	end
	event.ResetPakuAnim()
	helper_f3577a67(30)
	if vm.skipping() then
		return skip(53)
	end
	event.SetPakuAnim(1, "口パク", "怒り口")
	helper_aa9a834f(30190, 200)
	if vm.skipping() then
		return skip(54)
	end
	event.ResetPakuAnim()
	helper_75322a53(1)
	if vm.skipping() then
		return skip(55)
	end
	event.SetPakuAnim(1, "口パク", "怒り口")
	helper_aa9a834f(30195, 200)
	if vm.skipping() then
		return skip(56)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(1, "口パク", "怒り口")
	helper_aa9a834f(30200, 230)
	if vm.skipping() then
		return skip(57)
	end
	event.ResetPakuAnim()
	helper_75322a53(1)
	if vm.skipping() then
		return skip(58)
	end
	event.ObjsSetMotion(1, "笑い", 2)
	event.ObjsNextMotion(1, "笑いL", 4)
	event.ObjsTexAnime(1, 0, "怒り目")
	event.ObjsTexAnime(1, 1, "笑い口")
	helper_aa9a834f(30205, 100)
	if vm.skipping() then
		return skip(59)
	end
	event.ObjsTexAnime(1, 0, "笑い口")
	helper_75322a53(1)
	if vm.skipping() then
		return skip(60)
	end
	event.CmrsSetPos(412.51, 94.68, 448.16)
	event.CmrsSetRef(457.77, 16.14, 335.83)
	event.ObjsSetMotion(2, "相手を見る", 2)
	event.ObjsNextMotion(2, "相手を見るL", 4)
	event.ObjsTexAnime(2, 0)
	event.ObjsMotionDelay(1, 30)
	event.ObjsSetMotion(1, "相手を見る", 2)
	event.ObjsNextMotion(1, "相手を見るL", 4)
	helper_aa9a834f(30210, 80)
	if vm.skipping() then
		return skip(61)
	end
	helper_aa9a834f(30215, 180)
	if vm.skipping() then
		return skip(62)
	end
	helper_75322a53(0)
	if vm.skipping() then
		return skip(63)
	end
	helper_75322a53(1)
	if vm.skipping() then
		return skip(64)
	end
	event.SetPakuAnim(1, "口パク")
	helper_aa9a834f(30220, 340)
	if vm.skipping() then
		return skip(65)
	end
	event.ResetPakuAnim()
	helper_75322a53(1)
	if vm.skipping() then
		return skip(66)
	end
	event.ObjsSetMotion(1, "相手を見る→笑い", 2)
	event.ObjsNextMotion(1, "笑いL", 4)
	event.ObjsTexAnime(1, 1, "笑い口")
	helper_aa9a834f(30225, 90)
	if vm.skipping() then
		return skip(67)
	end
	event.ObjsTexAnime(1, 0, "笑い口")
	helper_75322a53(1)
	if vm.skipping() then
		return skip(68)
	end
	event.ObjsSetPos(28, 491.85, 57.59, 280.68)
	event.ObjsJump(28, 491.85, 1.02, 280.68, -0.4, 30)
	event.ObjsRotation(28, 1.5, 3.12, 0.35, 30)
	event.ObjsJump(28, 486.47, 3.02, 258.4, -0.3, 20)
	event.ObjsRotation(28, 0.0, 0.0, 0.0, 20)
	event.ObjsJump(28, 491.86, 3.14, 242.12, -0.25, 15)
	event.ObjsRotation(28, -1.57, 0.0, 0.0, 15)
	event.ObjsJump(28, 500.58, 3.2, 235.17, -0.15, 10)
	event.ObjsMove(28, 524.68, 3.2, 222.45, 24)
	event.ObjsRotation(28, -1.57, 0.0, -1.57, 5)
	event.ObjsRotation(28, -1.57, 0.0, 3.14, 5)
	event.ObjsRotation(28, -1.57, 0.0, 0.0, 12)
	event.ObjsRotation(28, -1.57, 0.0, -1.57, 6)
	event.ObjsRotation(28, -1.57, 0.0, 3.14, 6)
	event.ObjsSePlay(28, var0, 17)
	event.ObjsSeDelay(28, 30)
	event.ObjsSePlay(28, var0, 18)
	event.ObjsSeDelay(28, 20)
	event.ObjsSePlay(28, var0, 19)
	event.ObjsSeDelay(28, 15)
	event.ObjsSePlay(28, var0, 20)
	helper_f3577a67(30)
	if vm.skipping() then
		return skip(69)
	end
	event.StopBgm(0)
	event.ObjsSetMotion(1, "破片を見る", 2)
	event.ObjsNextMotion(1, "破片を見るL", 4)
	event.ObjsSetMotion(2, "破片を見る", 2)
	event.ObjsNextMotion(2, "破片を見るL", 4)
	event.SetPakuAnim(1, "口パク")
	helper_aa9a834f(30230, 30)
	if vm.skipping() then
		return skip(70)
	end
	event.ResetPakuAnim()
	helper_75322a53(1)
	if vm.skipping() then
		return skip(71)
	end
	helper_75322a53(2)
	if vm.skipping() then
		return skip(72)
	end
	event.ObjsSetMotion(1, "上を見る", 6)
	event.ObjsNextMotion(1, "上を見るL", 4)
	helper_75322a53(1)
	if vm.skipping() then
		return skip(73)
	end
	helper_f3577a67(15)
	if vm.skipping() then
		return skip(74)
	end
	event.ObjsSetMotion(0, "かんけり", 4)
	event.CmrsSetPos(459.14, 28.95, 319.9)
	event.CmrsSetRef(523.37, 3.23, 222.23)
	event.CmrsPrdelay(15)
	event.CmrsMove(459.14, 28.95, 319.9, 518.73, 134.52, 282.38, 30)
	event.CmrsPrdelay(30)
	event.ObjsSetPos(0, 534.3, 133.8, 266.81)
	event.ObjsSetRot(0, 0.0, -0.27, 0.0)
	helper_572c09a2()
	if vm.skipping() then
		return skip(75)
	end
	event.CmrsSetPos(526.24, 130.39, 294.97)
	event.CmrsSetRef(532.61, 163.09, 272.03)
	event.ObjsTexAnime(0, 1, "ピクピク目")
	event.ObjsTexAnime(0, 1, "あわあわ口")
	event.ObjsTexAnime(1, 0)
	helper_aa9a834f(30240, 40)
	if vm.skipping() then
		return skip(76)
	end
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "怒り目")
	event.ObjsTexAnime(0, 1, "半開き口")
	event.ObjsTexAnime(2, 0)
	event.CmrsSetPos(469.26, 78.46, 302.58)
	event.CmrsSetRef(454.3, 19.03, 336.32)
	event.ObjsSetPos(1, 448.41, 0.0, 334.3)
	event.ObjsSetRot(1, 0.0, 2.65, 0.0)
	event.ObjsSetMotion(1, "上見立ち", 4)
	event.SetPakuAnim(1, "口パク", "気づく口")
	helper_aa9a834f(30250, 60)
	if vm.skipping() then
		return skip(77)
	end
	event.ResetPakuAnim()
	event.SndSePlay(var0, 21)
	event.ObjsSetMotion(2, "驚く", 6)
	event.ObjsNextMotion(2, "驚くL", 4)
	event.SetPakuAnim(2, "口パク")
	helper_aa9a834f(30260, 80)
	if vm.skipping() then
		return skip(78)
	end
	event.ResetPakuAnim()
	helper_75322a53(2)
	if vm.skipping() then
		return skip(79)
	end
	event.EohSetShadow(0, 1)
	event.CmrsSetPos(510.2, 146.32, 276.25)
	event.CmrsSetRef(534.03, 155.11, 258.68)
	event.EohSetShow(31, 0)
	event.ObjsSetPos(0, 534.64, 133.45, 265.0)
	event.ObjsSetRot(0, 0.0, -0.29, 0.0)
	event.ObjsSetMotion(0, "振り返る", 6)
	event.ObjsNormalDrive(0)
	event.ObjsMotionWait(0)
	event.ObjsResetDaPosition(0)
	event.StreamOpen3(1, 30265)
	helper_f4a2e06c(1)
	if vm.skipping() then
		return skip(80)
	end
	event.StreamPlay(1)
	helper_f3577a67(20)
	if vm.skipping() then
		return skip(81)
	end
	event.SndSePlay(var0, 22)
	helper_75322a53(0)
	if vm.skipping() then
		return skip(82)
	end
	event.EohSetShow(31, 1)
	event.CmrsSetPos(584.86, 197.48, 305.84)
	event.CmrsSetRef(544.65, 150.54, 250.94)
	event.ObjsSetMotion(0, "走り", 4)
	event.ObjsSetRot(0, 0.0, 2.8, 0.0)
	event.ObjsMove(0, 570.34, 133.45, 120.98, 50)
	helper_75322a53(0)
	if vm.skipping() then
		return skip(83)
	end
	event.StreamClose(1)
	event.CmrsSetPos(461.98, 29.1, 307.38)
	event.CmrsSetRef(447.72, 27.8, 336.09)
	event.ObjsSetMotion(0, "立ち", 4)
	event.CharaActive(0, 0)
	event.CharaActive(0, 10)
	helper_f3577a67(30)
	if vm.skipping() then
		return skip(84)
	end
	event.SndSePlay(var0, 23)
	event.ObjsSetMotion(1, "ニヤリ", 6)
	event.ObjsNextMotion(1, "ニヤリL", 4)
	event.ObjsTexAnime(1, 0, "気づく口")
	event.ObjsTexAnime(1, 1, "見回し")
	event.SetPakuAnim(1, "口パク", "にやり口")
	helper_aa9a834f(30270, 120)
	if vm.skipping() then
		return skip(85)
	end
	event.ResetPakuAnim()
	helper_75322a53(1)
	if vm.skipping() then
		return skip(86)
	end
	event.CharaActive(11)
	event.CharaActive(12)
	event.CharaActive(13)
	event.CharaActive(14)
	event.CmrsSetPos(425.56, 60.68, 401.69)
	event.CmrsSetRef(540.96, 27.8, 343.52)
	helper_f3577a67(3)
	if vm.skipping() then
		return skip(87)
	end
	event.SndSePlay(var0, 24)
	event.ObjsRotation(8, 0.0, 0.0, 2.35, 10)
	event.ObjsRotation(9, 0.0, 0.0, -2.35, 10)
	event.ObjsSetPos(3, 595.28, -100.0, 301.83)
	event.ObjsSetRot(3, 0.0, -1.74, 0.0)
	event.ObjsPosDelay(3, 10)
	event.ObjsSetPos(3, 595.28, 0.0, 301.83)
	event.ObjsPosDelay(3, 4)
	event.ObjsJump(3, 552.31, 0.0, 299.96, -0.6, 30)
	event.ObjsSetMotion(3, "ジャンプ", 6)
	event.ObjsNextMotion(3, "ジャンプL", 4)
	event.ObjsMotionDelay(3, 20)
	event.ObjsSetMotion(3, "着地", 6)
	event.ObjsSeDelay(3, 15)
	event.ObjsSePlay(3, var0, 25)
	event.ObjsSeDelay(3, 30)
	event.ObjsSePlay(3, var0, 26)
	helper_f3577a67(4)
	if vm.skipping() then
		return skip(88)
	end
	event.SndSePlay(var0, 24)
	event.ObjsRotation(14, 0.0, 0.0, 2.35, 10)
	event.ObjsRotation(15, 0.0, 0.0, -2.35, 10)
	event.ObjsSetPos(5, 530.7, -100.0, 408.01)
	event.ObjsSetRot(5, 0.0, -2.58, 0.0)
	event.ObjsPosDelay(5, 10)
	event.ObjsSetPos(5, 530.7, 0.0, 408.01)
	event.ObjsPosDelay(5, 4)
	event.ObjsJump(5, 508.68, 0.0, 377.01, -0.6, 30)
	event.ObjsSetMotion(5, "ジャンプ", 6)
	event.ObjsNextMotion(5, "ジャンプL", 4)
	event.ObjsMotionDelay(5, 20)
	event.ObjsSetMotion(5, "着地", 6)
	event.ObjsSeDelay(5, 15)
	event.ObjsSePlay(5, var0, 32)
	event.ObjsSeDelay(5, 30)
	event.ObjsSePlay(5, var0, 35)
	helper_f3577a67(5)
	if vm.skipping() then
		return skip(89)
	end
	event.SndSePlay(var0, 24)
	event.ObjsRotation(11, 0.0, 0.0, 2.35, 10)
	event.ObjsRotation(12, 0.0, 0.0, -2.35, 10)
	event.ObjsSetPos(4, 576.1, -100.0, 360.47)
	event.ObjsSetRot(4, 0.0, -2.22, 0.0)
	event.ObjsPosDelay(4, 10)
	event.ObjsSetPos(4, 576.1, 0.0, 360.47)
	event.ObjsPosDelay(4, 4)
	event.ObjsJump(4, 545.68, 0.0, 340.87, -0.6, 30)
	event.ObjsSetMotion(4, "ジャンプ", 6)
	event.ObjsNextMotion(4, "ジャンプL", 4)
	event.ObjsMotionDelay(4, 20)
	event.ObjsSetMotion(4, "着地", 6)
	event.ObjsSeDelay(4, 15)
	event.ObjsSePlay(4, var0, 33)
	event.ObjsSeDelay(4, 30)
	event.ObjsSePlay(4, var0, 36)
	helper_f3577a67(5)
	if vm.skipping() then
		return skip(90)
	end
	event.SndSePlay(var0, 24)
	event.ObjsRotation(17, 0.0, 0.0, 2.35, 10)
	event.ObjsRotation(18, 0.0, 0.0, -2.35, 10)
	event.ObjsSetPos(6, 526.55, -100.0, 296.48)
	event.ObjsSetRot(6, 0.0, -2.7, 0.0)
	event.ObjsPosDelay(6, 10)
	event.ObjsSetPos(6, 526.55, 0.0, 296.48)
	event.ObjsPosDelay(6, 4)
	event.ObjsJump(6, 513.97, 0.0, 263.38, -0.6, 30)
	event.ObjsSetMotion(6, "ジャンプ", 6)
	event.ObjsNextMotion(6, "ジャンプL", 4)
	event.ObjsMotionDelay(6, 20)
	event.ObjsSetMotion(6, "着地", 6)
	event.ObjsSeDelay(6, 15)
	event.ObjsSePlay(6, var0, 34)
	event.ObjsSeDelay(6, 30)
	event.ObjsSePlay(6, var0, 35)
	helper_f3577a67(20)
	if vm.skipping() then
		return skip(91)
	end
	event.CmrsSetPos(368.19, 67.07, 517.9)
	event.CmrsSetRef(338.11, 27.8, 359.17)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.ObjsSetPos(3, 0.0, -100.0, 0.0)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.ObjsInit(5)
	event.ObjsSyncObj(5, 5)
	event.ObjsInit(6)
	event.ObjsSyncObj(6, 6)
	helper_f3577a67(6)
	if vm.skipping() then
		return skip(92)
	end
	event.SndSePlay(var0, 24)
	event.ObjsRotation(26, 0.0, 0.0, 2.35, 10)
	event.ObjsRotation(27, 0.0, 0.0, -2.35, 10)
	event.ObjsSetPos(6, 295.21, -100.0, 424.99)
	event.ObjsSetRot(6, 0.0, 1.72, 0.0)
	event.ObjsPosDelay(6, 10)
	event.ObjsSetPos(6, 295.21, 0.0, 424.99)
	event.ObjsPosDelay(6, 4)
	event.ObjsJump(6, 335.17, 0.0, 418.75, -0.6, 30)
	event.ObjsResetMotion(6)
	event.ObjsSetMotion(6, "ジャンプ", 6)
	event.ObjsNextMotion(6, "ジャンプL", 4)
	event.ObjsMotionDelay(6, 20)
	event.ObjsSetMotion(6, "着地", 6)
	event.ObjsSeDelay(6, 15)
	event.ObjsSePlay(6, var0, 33)
	event.ObjsSeDelay(6, 30)
	event.ObjsSePlay(6, var0, 36)
	helper_f3577a67(3)
	if vm.skipping() then
		return skip(93)
	end
	event.SndSePlay(var0, 24)
	event.ObjsRotation(20, 0.0, 0.0, 2.35, 10)
	event.ObjsRotation(21, 0.0, 0.0, -2.35, 10)
	event.ObjsSetPos(4, 415.0, -100.0, 295.84)
	event.ObjsSetRot(4, 0.0, 1.0, 0.0)
	event.ObjsPosDelay(4, 10)
	event.ObjsSetPos(4, 415.0, 0.0, 295.84)
	event.ObjsPosDelay(4, 4)
	event.ObjsJump(4, 438.03, 0.0, 320.39, -0.6, 30)
	event.ObjsResetMotion(4)
	event.ObjsSetMotion(4, "ジャンプ", 6)
	event.ObjsNextMotion(4, "ジャンプL", 4)
	event.ObjsMotionDelay(4, 20)
	event.ObjsSetMotion(4, "着地", 6)
	event.ObjsSeDelay(4, 15)
	event.ObjsSePlay(4, var0, 25)
	event.ObjsSeDelay(4, 30)
	event.ObjsSePlay(4, var0, 26)
	helper_f3577a67(2)
	if vm.skipping() then
		return skip(94)
	end
	event.SndSePlay(var0, 24)
	event.ObjsRotation(23, 0.0, 0.0, 2.35, 10)
	event.ObjsRotation(24, 0.0, 0.0, -2.35, 10)
	event.ObjsSetPos(5, 310.01, -100.0, 385.25)
	event.ObjsSetRot(5, 0.0, 1.36, 0.0)
	event.ObjsPosDelay(5, 10)
	event.ObjsSetPos(5, 310.01, 0.0, 385.25)
	event.ObjsPosDelay(5, 4)
	event.ObjsJump(5, 353.06, 0.0, 395.44, -0.6, 30)
	event.ObjsResetMotion(5)
	event.ObjsSetMotion(5, "ジャンプ", 6)
	event.ObjsNextMotion(5, "ジャンプL", 4)
	event.ObjsMotionDelay(5, 20)
	event.ObjsSetMotion(5, "着地", 6)
	event.ObjsSeDelay(5, 15)
	event.ObjsSePlay(5, var0, 32)
	event.ObjsSeDelay(5, 30)
	event.ObjsSePlay(5, var0, 35)
	helper_75322a53(4)
	if vm.skipping() then
		return skip(95)
	end
	helper_75322a53(5)
	if vm.skipping() then
		return skip(96)
	end
	helper_75322a53(6)
	if vm.skipping() then
		return skip(97)
	end
	helper_f3577a67(30)
	if vm.skipping() then
		return skip(98)
	end
	event.CmrsSetPos(457.86, 29.1, 315.67)
	event.CmrsSetRef(447.72, 27.8, 336.09)
	event.CmrsMove(461.98, 29.1, 307.38, 447.72, 27.8, 336.09, 280)
	event.ObjsSetPos(3, 411.67, 0.0, 337.3)
	event.ObjsSetRot(3, 0.0, 2.65, 0.0)
	event.ObjsMove(3, 427.17, 0.0, 345.0, 150)
	event.ObjsSetMotion(3, "立ち", 4)
	event.ObjsSetPos(4, 468.94, 0.0, 362.61)
	event.ObjsSetRot(4, 0.0, 2.65, 0.0)
	event.ObjsMove(4, 453.19, 0.0, 354.78, 150)
	event.ObjsSetMotion(4, "立ち", 4)
	event.ObjsSetPos(5, 397.62, 0.0, 340.14)
	event.ObjsSetRot(5, 0.0, 2.65, 0.0)
	event.ObjsPosDelay(5, 60)
	event.ObjsMove(5, 414.56, 0.0, 347.41, 100)
	event.ObjsSetMotion(5, "立ち", 4)
	event.ObjsSetPos(6, 475.17, 0.0, 377.94)
	event.ObjsSetRot(6, 0.0, 2.65, 0.0)
	event.ObjsPosDelay(6, 60)
	event.ObjsMove(6, 458.94, 0.0, 369.88, 100)
	event.ObjsSetMotion(6, "立ち", 4)
	event.ObjsTexAnime(1, 0, "見回し")
	event.ObjsTexAnime(1, 1, "怒り瞬き")
	event.SetPakuAnim(1, "口パク", "にやり口")
	helper_aa9a834f(30280, 160)
	if vm.skipping() then
		return skip(99)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(1, "口パク", "にやり口")
	helper_aa9a834f(30285, 180)
	if vm.skipping() then
		return skip(100)
	end
	event.ResetPakuAnim()
	helper_572c09a2()
	if vm.skipping() then
		return skip(101)
	end
	event.SndSePlay(var0, 27)
	event.ObjsSetMotion(1, "命令する", 6)
	event.ObjsNextMotion(1, "命令するL", 6)
	event.ObjsTexAnime(1, 0, "怒り瞬き")
	event.ObjsTexAnime(1, 1, "右向き目")
	event.SetPakuAnim(1, "口パク", "にやり口")
	helper_aa9a834f(30290, 90)
	if vm.skipping() then
		return skip(102)
	end
	event.ResetPakuAnim()
	helper_75322a53(1)
	if vm.skipping() then
		return skip(103)
	end
	event.ObjsSetMotion(1, "命令する戻り", 6)
	event.ObjsTexAnime(1, 0, "右向き目")
	event.ObjsTexAnime(1, 1, "にやり目")
	event.ObjsSetMotion(3, "ジャンプ", 2)
	event.ObjsPosDelay(3, 15)
	event.ObjsMove(3, 427.17, 48.0, 345.0, 10)
	event.ObjsSeDelay(3, 5)
	event.ObjsSePlay(3, var0, 28)
	helper_f3577a67(5)
	if vm.skipping() then
		return skip(104)
	end
	event.ObjsSetMotion(6, "ジャンプ", 2)
	event.ObjsPosDelay(6, 15)
	event.ObjsMove(6, 458.94, 48.0, 369.88, 10)
	event.ObjsSeDelay(6, 5)
	event.ObjsSePlay(6, var0, 28)
	helper_f3577a67(3)
	if vm.skipping() then
		return skip(105)
	end
	event.SndSePlay(var0, 28)
	event.ObjsSetMotion(4, "ジャンプ", 2)
	event.ObjsPosDelay(4, 15)
	event.ObjsMove(4, 453.19, 48.0, 354.78, 10)
	event.ObjsSeDelay(4, 5)
	event.ObjsSePlay(4, var0, 28)
	helper_f3577a67(1)
	if vm.skipping() then
		return skip(106)
	end
	event.SndSePlay(var0, 28)
	event.ObjsSetMotion(5, "ジャンプ", 2)
	event.ObjsPosDelay(5, 15)
	event.ObjsMove(5, 414.56, 48.0, 347.41, 10)
	event.ObjsSeDelay(5, 5)
	event.ObjsSePlay(5, var0, 28)
	helper_75322a53(1)
	if vm.skipping() then
		return skip(107)
	end
	helper_75322a53(3)
	if vm.skipping() then
		return skip(108)
	end
	helper_75322a53(4)
	if vm.skipping() then
		return skip(109)
	end
	helper_75322a53(5)
	if vm.skipping() then
		return skip(110)
	end
	helper_75322a53(6)
	if vm.skipping() then
		return skip(111)
	end
	event.ObjsSetPos(1, 483.34, 0.0, 472.15)
	event.ObjsSetPos(3, 0.0, -100.0, 0.0)
	event.ObjsSetPos(4, 0.0, -100.0, 0.0)
	event.ObjsSetPos(5, 0.0, -100.0, 0.0)
	event.ObjsSetPos(6, 0.0, -100.0, 0.0)
	event.CmrsSetPos(374.25, 90.25, 474.87)
	event.CmrsSetRef(429.51, 90.03, 420.03)
	event.CmrsMove(384.94, 132.84, 483.9, 429.51, 132.62, 420.03, 270)
	event.ObjsSetRot(5, 0.0, 2.77, 0.0)
	event.ObjsSetPos(5, 461.73, 0.8, 410.06)
	event.ObjsJump(5, 558.2, 133.44, 226.12, -0.8, 30)
	event.ObjsSetMotion(5, "ジャンプL", 4)
	event.ObjsMotionDelay(5, 25)
	event.ObjsSetMotion(5, "着地", 6)
	event.ObjsMotionDelay(5, 20)
	event.ObjsNextMotion(5, "歩き")
	event.ObjsPosDelay(5, 20)
	event.ObjsMove(5, 616.14, 133.44, -54.21, 60)
	event.ObjsSetPos(5, 0.0, -100.0, 0.0)
	event.ObjsSePlay(5, var0, 29)
	event.ObjsSeDelay(5, 30)
	event.ObjsSePlay(5, var0, 30)
	helper_f3577a67(20)
	if vm.skipping() then
		return skip(112)
	end
	event.ObjsSetRot(4, 0.0, 2.29, 0.0)
	event.ObjsSetPos(4, 399.95, -7.44, 419.55)
	event.ObjsJump(4, 558.2, 133.44, 226.12, -0.8, 30)
	event.Ext(462, 4, 0.0, 2.89, 0.0) -- retail: the handler rejects 4 arguments
	event.ObjsSetMotion(4, "ジャンプL", 4)
	event.ObjsMotionDelay(4, 25)
	event.ObjsSetMotion(4, "着地", 6)
	event.ObjsMotionDelay(4, 20)
	event.ObjsNextMotion(4, "歩き")
	event.ObjsPosDelay(4, 20)
	event.ObjsMove(4, 616.14, 133.44, -54.21, 60)
	event.ObjsSetPos(4, 0.0, -100.0, 0.0)
	event.ObjsSePlay(3, var0, 29)
	event.ObjsSeDelay(3, 30)
	event.ObjsSePlay(3, var0, 30)
	helper_f3577a67(26)
	if vm.skipping() then
		return skip(113)
	end
	event.ObjsSetRot(3, 0.0, 1.57, 0.0)
	event.ObjsSetPos(3, 507.93, 0.0, 385.84)
	event.ObjsRotDelay(3, 10)
	event.ObjsRotation(3, 0.0, 2.77, 0.0, 20)
	event.ObjsJump(3, 561.55, 99.23, 382.0, -0.4, 30)
	event.ObjsSetMotion(3, "ジャンプL")
	event.ObjsMotionDelay(3, 25)
	event.ObjsSetMotion(3, "着地", 6)
	event.ObjsMotionDelay(3, 20)
	event.ObjsSetMotion(3, "ジャンプ", 2)
	event.ObjsNextMotion(3, "ジャンプL")
	event.ObjsPosDelay(3, 32)
	event.ObjsJump(3, 558.2, 133.44, 226.12, -0.6, 30)
	event.ObjsMotionDelay(3, 18)
	event.ObjsSetMotion(3, "着地", 6)
	event.ObjsMotionDelay(3, 20)
	event.ObjsNextMotion(3, "歩き")
	event.ObjsPosDelay(3, 20)
	event.ObjsMove(3, 616.14, 133.44, -54.21, 60)
	event.ObjsSetPos(3, 0.0, -100.0, 0.0)
	event.ObjsSePlay(3, var0, 29)
	event.ObjsSeDelay(3, 30)
	event.ObjsSePlay(3, var0, 31)
	event.ObjsSeDelay(3, 62)
	event.ObjsSePlay(3, var0, 30)
	helper_f3577a67(20)
	if vm.skipping() then
		return skip(114)
	end
	event.ObjsSetRot(6, 0.0, 2.77, 0.0)
	event.ObjsRotation(6, 0.0, 2.77, 0.0, 30)
	event.ObjsSetPos(6, 490.07, 0.0, 354.49)
	event.ObjsJump(6, 558.2, 133.44, 226.12, -0.8, 30)
	event.ObjsSetMotion(6, "ジャンプL", 4)
	event.ObjsMotionDelay(6, 25)
	event.ObjsSetMotion(6, "着地", 6)
	event.ObjsMotionDelay(6, 20)
	event.ObjsNextMotion(6, "歩き")
	event.ObjsPosDelay(6, 20)
	event.ObjsMove(6, 616.14, 133.44, -54.21, 60)
	event.ObjsSetPos(6, 0.0, -100.0, 0.0)
	event.ObjsSePlay(6, var0, 29)
	event.ObjsSeDelay(6, 30)
	event.ObjsSePlay(6, var0, 30)
	helper_f3577a67(43)
	if vm.skipping() then
		return skip(115)
	end
	event.ObjsSetRot(5, 0.0, 2.65, 0.0)
	event.ObjsSetPos(5, 412.89, 25.69, 457.94)
	event.ObjsRotDelay(5, 10)
	event.ObjsRotation(5, 0.0, 2.77, 0.0, 20)
	event.ObjsJump(5, 486.54, 130.52, 361.4, -0.4, 30)
	event.ObjsSetMotion(5, "ジャンプL")
	event.ObjsMotionDelay(5, 23)
	event.ObjsSetMotion(5, "着地", 6)
	event.ObjsMotionDelay(5, 24)
	event.ObjsSetMotion(5, "ジャンプ", 2)
	event.ObjsNextMotion(5, "ジャンプL")
	event.ObjsPosDelay(5, 36)
	event.ObjsJump(5, 558.2, 133.44, 226.12, -0.4, 30)
	event.ObjsMotionDelay(5, 18)
	event.ObjsSetMotion(5, "着地", 6)
	event.ObjsMotionDelay(5, 20)
	event.ObjsNextMotion(5, "歩き")
	event.ObjsPosDelay(5, 20)
	event.ObjsMove(5, 616.14, 133.44, -54.21, 60)
	event.ObjsSetPos(5, 0.0, -100.0, 0.0)
	event.ObjsSePlay(5, var0, 29)
	event.ObjsSeDelay(5, 30)
	event.ObjsSePlay(5, var0, 31)
	event.ObjsSeDelay(5, 66)
	event.ObjsSePlay(5, var0, 30)
	event.ObjsSetMotion(1, "走り")
	event.ObjsInitPas(1)
	event.ObjsSetPasFrm(1, 140)
	event.ObjsAddPas(1, 483.34, 0.0, 472.15)
	event.ObjsAddPas(1, 515.13, 18.89, 455.65)
	event.ObjsAddPas(1, 554.52, 44.98, 429.55)
	event.ObjsAddPas(1, 588.83, 78.8, 393.51)
	event.ObjsAddPas(1, 621.79, 116.64, 341.23)
	event.ObjsAddPas(1, 627.58, 134.46, 326.87)
	event.ObjsStartPas(1)
	helper_f3577a67(32)
	if vm.skipping() then
		return skip(116)
	end
	event.ObjsSetRot(4, 0.0, 1.57, 0.0)
	event.ObjsSetPos(4, 416.4, 75.5, 204.13)
	event.ObjsJump(4, 462.7, 152.9, 245.99, -0.3, 30)
	event.ObjsSetMotion(4, "ジャンプL", 4)
	event.ObjsMotionDelay(4, 25)
	event.ObjsSetMotion(4, "着地", 6)
	event.ObjsMotionDelay(4, 20)
	event.ObjsSetMotion(4, "ジャンプ", 2)
	event.ObjsNextMotion(4, "ジャンプL")
	event.ObjsPosDelay(4, 32)
	event.ObjsJump(4, 558.2, 133.44, 226.12, -0.2, 30)
	event.ObjsRotDelay(4, 72)
	event.ObjsRotation(4, 0.0, 2.77, 0.0, 20)
	event.ObjsMotionDelay(4, 18)
	event.ObjsSetMotion(4, "着地", 6)
	event.ObjsMotionDelay(4, 20)
	event.ObjsNextMotion(4, "歩き")
	event.ObjsPosDelay(4, 20)
	event.ObjsMove(4, 616.14, 133.44, -54.21, 60)
	event.ObjsSetPos(4, 0.0, -100.0, 0.0)
	event.ObjsSePlay(4, var0, 29)
	event.ObjsSeDelay(4, 30)
	event.ObjsSePlay(4, var0, 31)
	event.ObjsSeDelay(4, 62)
	event.ObjsSePlay(4, var0, 30)
	helper_f3577a67(70)
	if vm.skipping() then
		return skip(117)
	end
	event.CmrsFadeInit()
	event.CmrsFadeOut(60)
	helper_572c09a2()
	if vm.skipping() then
		return skip(118)
	end
	return part2()
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 100.
script[100] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_19608()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 151.
script[151] = function()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_19608()
			if not vm.skipping() then
				return part2()
			end
		end
	end
	function part2() end
	helper_b8bc()
	if vm.skipping() then
		return skip(1)
	end
	helper_19608()
	if vm.skipping() then
		return skip(2)
	end
	return part2()
end

--- Program 152.
script[152] = function()
	event.GotoEdit(17, 153)
end

--- Program 8000.
script[8000] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_19608()
	if vm.skipping() then
		return skip(1)
	end
end

return script
