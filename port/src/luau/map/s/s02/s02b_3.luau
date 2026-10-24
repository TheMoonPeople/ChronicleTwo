--!strict
-- map/s/s02/s02b_3.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_07899991 = require("@lib/event/helper_07899991")
local helper_126faf7c = require("@lib/event/helper_126faf7c")
local helper_21731d04 = require("@lib/event/helper_21731d04")
local helper_23c9fcd1 = require("@lib/event/helper_23c9fcd1")
local helper_5fe8f3bb = require("@lib/event/helper_5fe8f3bb")
local helper_7545b4dd = require("@lib/event/helper_7545b4dd")
local helper_8333218b = require("@lib/event/helper_8333218b")
local helper_92829c19 = require("@lib/event/helper_92829c19")
local helper_9adff316 = require("@lib/event/helper_9adff316")
local helper_b0211f82 = require("@lib/event/helper_b0211f82")
local helper_b7f75ad1 = require("@lib/event/helper_b7f75ad1")
local helper_d1353c5b = require("@lib/event/helper_d1353c5b")
local helper_d9487860 = require("@lib/event/helper_d9487860")
local helper_e20fd550 = require("@lib/event/helper_e20fd550")
local helper_e3a22687 = require("@lib/event/helper_e3a22687")

local global0: s32 = 0
local global1: s32 = 0

--- Helper function.
local function helper_27ec0()
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		global0 = 0
		global1 = 33
		global0 = 32
		global1 = 0
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesWindowMode(0, 7)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		global0 = 0
		global1 = 33
		event.LoadMotion(5, "event/e200/e207/e207_mints.gltf", "info", global0)
		event.EohSyncChara(0, global0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global0)
		event.LoadChara(5, "chara/c02_base.gltf", "info", global1)
		event.LoadEquip(5, 1, 4, "info", global1)
		event.LoadEquip(5, 1, 3, "info", global1)
		event.LoadEquip(5, 1, 2, "info", global1, 37)
		event.LoadMotion(5, "event/e200/e207/e207_monica.gltf", "info", global1)
		event.EohSyncChara(1, global1)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global1)
		event.CharaActive(1, 37)
	end
	if active_chr_no == 1 then
		global0 = 32
		global1 = 0
		event.LoadChara(5, "chara/c01_base.gltf", "info", global0)
		event.LoadEquip(5, 0, 4, "info", global0)
		event.LoadEquip(5, 0, 3, "info", global0)
		event.LoadEquip(5, 0, 2, "info", global0, 37)
		event.LoadMotion(5, "event/e200/e207/e207_mints.gltf", "info", global0)
		event.EohSyncChara(0, global0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global0)
		event.CharaActive(1, 37)
		event.LoadMotion(5, "event/e200/e207/e207_monica.gltf", "info", global1)
		event.EohSyncChara(1, global1)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global1)
	end
	event.ChangeDir("event/e200/e207/")
	event.LoadChara(5, "e207_starbre.gltf", "info", 34)
	event.EohSyncChara(2, 34)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.CharaActive(0, 34)
	event.LoadChara(5, "e207_vorneo.gltf", "info", 35)
	event.EohSyncChara(3, 35)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.CharaActive(0, 35)
	event.LoadChara(5, "e207_tom.gltf", "info", 36)
	event.EohSyncChara(4, 36)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.CharaActive(0, 36)
	event.EohSyncObj(5, "p01_train01")
	event.ObjsInit(5)
	event.ObjsSyncObj(5, 5)
	event.ChangeDir("")
	event.LoadMes(0, 5, "event/e200/e207/e207_1.txt")
	event.SetStatus(1, global0, 256, 1)
	event.SetStatus(1, global1, 256, 1)
end

--- Helper function.
local function helper_26e74()
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		event.CharaActive(1, global0)
		event.CharaActive(0, global1)
		event.DelExtMotion(global0)
		event.DelExtMotion(global1)
		event.DeleteChara(global1)
		event.DeleteChara(37)
	end
	if active_chr_no == 1 then
		event.CharaActive(1, global1)
		event.CharaActive(0, global0)
		event.DelExtMotion(global1)
		event.DelExtMotion(global0)
		event.DeleteChara(global0)
		event.DeleteChara(37)
	end
	event.DeleteChara(34)
	event.DeleteChara(36)
	event.DeleteChara(35)
	event.DeleteChara(39)
	event.DeleteChara(40)
	event.DeleteChara(41)
	event.DeleteChara(42)
	event.SpriteSetDraw(0, 0)
	event.SpriteSetDraw(1, 0)
	event.SpriteSetDraw(2, 0)
	event.SpriteSetDraw(3, 0)
	event.SpriteSetDraw(4, 0)
	event.SpriteSetDraw(5, 0)
	event.DelImg(0)
end

--- Helper function.
local function helper_28e0c()
	local var0: s32 = 0
	local var2: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	local part3: () -> ...any
	function skip(at: number)
		if at <= 66 then
			if at <= 1 then
				helper_27ec0()
				helper_b0211f82(4)
			end
			if at <= 2 then
				helper_7545b4dd(var0)
			end
			if at <= 3 then
				helper_b0211f82(30)
			end
			if at <= 4 then
				helper_b0211f82(90)
			end
			if at <= 5 then
				helper_b0211f82(16)
			end
			if at <= 6 then
				helper_126faf7c(2)
			end
			if at <= 7 then
				helper_b0211f82(16)
			end
			if at <= 8 then
				helper_e3a22687()
				helper_b0211f82(120)
			end
			if at <= 9 then
				helper_92829c19(2070010)
			end
			if at <= 10 then
				helper_92829c19(2070020)
			end
			if at <= 11 then
				helper_e20fd550(2070030, 90)
			end
			if at <= 12 then
				helper_b0211f82(3)
			end
			if at <= 13 then
				helper_e20fd550(2070035, 75)
			end
			if at <= 14 then
				helper_b0211f82(30)
			end
			if at <= 15 then
				helper_e20fd550(2070040, 120)
			end
			if at <= 16 then
				helper_b0211f82(30)
			end
			if at <= 17 then
				helper_b0211f82(45)
			end
			if at <= 18 then
				helper_e20fd550(2070045, 240)
			end
			if at <= 19 then
				helper_b0211f82(30)
			end
			if at <= 20 then
				helper_e20fd550(2070050, 120)
			end
			if at <= 21 then
				helper_e20fd550(2070055, 210)
			end
			if at <= 22 then
				helper_e20fd550(2070060, 180)
			end
			if at <= 23 then
				helper_92829c19(2070070)
			end
			if at <= 24 then
				helper_92829c19(2070075)
			end
			if at <= 25 then
				helper_92829c19(2070080)
			end
			if at <= 26 then
				helper_126faf7c(0)
			end
			if at <= 27 then
				helper_b0211f82(45)
			end
			if at <= 28 then
				helper_b0211f82(15)
			end
			if at <= 29 then
				helper_92829c19(2070090)
			end
			if at <= 30 then
				helper_92829c19(2070100)
			end
			if at <= 31 then
				helper_92829c19(2070110)
			end
			if at <= 32 then
				helper_b0211f82(15)
			end
			if at <= 33 then
				helper_92829c19(2070120)
			end
			if at <= 34 then
				helper_126faf7c(21)
			end
			if at <= 35 then
				helper_92829c19(2070130)
			end
			if at <= 36 then
				helper_92829c19(2070140)
			end
			if at <= 37 then
				helper_92829c19(2070145)
			end
			if at <= 38 then
				helper_92829c19(2070150)
			end
			if at <= 39 then
				helper_92829c19(2070160)
			end
			if at <= 40 then
				helper_b0211f82(15)
			end
			if at <= 41 then
				helper_92829c19(2070170)
			end
			if at <= 42 then
				helper_92829c19(2070175)
			end
			if at <= 43 then
				helper_92829c19(2070180)
			end
			if at <= 44 then
				helper_92829c19(2070190)
			end
			if at <= 45 then
				helper_92829c19(2070200)
			end
			if at <= 46 then
				helper_92829c19(2070210)
			end
			if at <= 47 then
				helper_92829c19(2070220)
			end
			if at <= 48 then
				helper_92829c19(2070230)
			end
			if at <= 49 then
				helper_92829c19(2070240)
			end
			if at <= 50 then
				helper_92829c19(2070250)
			end
			if at <= 51 then
				helper_92829c19(2070260)
			end
			if at <= 52 then
				helper_92829c19(2070270)
			end
			if at <= 53 then
				helper_b0211f82(45)
			end
			if at <= 54 then
				helper_b0211f82(37)
			end
			if at <= 55 then
				helper_92829c19(2070280)
			end
			if at <= 56 then
				helper_92829c19(2070290)
			end
			if at <= 57 then
				helper_126faf7c(1)
			end
			if at <= 58 then
				helper_b0211f82(30)
			end
			if at <= 59 then
				helper_b0211f82(30)
			end
			if at <= 60 then
				helper_5fe8f3bb()
			end
			if at <= 61 then
				helper_b0211f82(75)
			end
			if at <= 62 then
				helper_b0211f82(30)
			end
			if at <= 63 then
				helper_b0211f82(30)
			end
			if at <= 64 then
				helper_e20fd550(2070300, 330)
			end
			if at <= 65 then
				helper_b0211f82(15)
			end
			if vm.skip_end() then
				return skip(67)
			end
			return part2()
		end
		if at <= 92 then
			if at <= 68 then
				helper_b0211f82(4)
			end
			if at <= 70 then
				helper_d1353c5b(0, -1, 8, 0, 0)
			end
			if at <= 71 then
				helper_8333218b(352, 5)
			end
			if at <= 72 then
				helper_b0211f82(4)
			end
			if at <= 73 then
				helper_b0211f82(30)
			end
			if at <= 74 then
				helper_e20fd550(2070320, 75)
			end
			if at <= 75 then
				helper_92829c19(2070330)
			end
			if at <= 76 then
				helper_b0211f82(33)
			end
			if at <= 77 then
				helper_92829c19(2070340)
			end
			if at <= 78 then
				helper_92829c19(2070345)
			end
			if at <= 79 then
				helper_92829c19(2070350)
			end
			if at <= 80 then
				helper_92829c19(2070360)
			end
			if at <= 81 then
				helper_92829c19(2070370)
			end
			if at <= 82 then
				helper_126faf7c(3)
			end
			if at <= 83 then
				helper_92829c19(2070380)
			end
			if at <= 84 then
				helper_126faf7c(4)
			end
			if at <= 85 then
				helper_b0211f82(10)
			end
			if at <= 86 then
				helper_b0211f82(60)
			end
			if at <= 87 then
				helper_92829c19(2070390)
			end
			if at <= 88 then
				helper_126faf7c(1)
			end
			if at <= 89 then
				helper_92829c19(2070400)
			end
			if at <= 90 then
				helper_b0211f82(38)
			end
			if at <= 91 then
				helper_b0211f82(15)
			end
			if vm.skip_end() then
				return skip(93)
			end
			return part3()
		end
		if at <= 93 then
			helper_b0211f82(30)
		end
		if at <= 94 then
			helper_26e74()
			helper_b0211f82(30)
		end
		if at <= 95 then
			helper_d1353c5b(0, -1, 8, 0, 0)
		end
		if at <= 96 then
			helper_d1353c5b(0, -1, 8, 0, 0)
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SetMpcharaMotion("p01_train01", "kikan-m0", "停止")
		event.EohSetShadow(2, 1)
		event.SpriteSetDraw(0, 0)
		event.SpriteSetDraw(1, 0)
		event.SpriteSetDraw(2, 0)
		event.SpriteSetDraw(3, 0)
		event.SpriteSetDraw(4, 0)
		event.SpriteInit(4)
		event.SpriteSetType(4, 0)
		event.SpriteSetPos(4, 256, 208)
		event.SpriteSetPutsize(4, 512, 416)
		event.SpriteSetColor(4, 0, 0, 0, 128)
		event.SpriteSetDraw(4, 0)
		event.EohSyncSprite(14, 4)
		event.ObjsInit(14)
		event.ObjsSyncObj(14, 14)
		event.CmrsInit()
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.ObjsInit(2)
		event.ObjsSyncObj(2, 2)
		event.ObjsInit(7)
		event.ObjsSyncObj(7, 7)
		event.ObjsSetMotion(0, "立ち", 4)
		event.ObjsSetMotion(1, "立ち", 4)
		event.ObjsSetMotion(2, "立ち", 4)
		event.CharaActive(1, global0)
		event.CharaActive(1, global1)
		event.CharaActive(0, 34)
		event.CharaActive(0, 36)
		event.CharaActive(0, 35)
		event.CharaActive(0, 39)
		event.CharaActive(0, 40)
		event.CharaActive(0, 41)
		event.CharaActive(0, 42)
		event.ObjsSetPos(0, -162.09, 0.0, 562.18)
		event.ObjsSetPos(1, -158.87, 0.0, 543.98)
		event.ObjsSetPos(5, 1.3, 8.0, 700.0)
		event.SoundAllStop()
		event.StopBgm(0)
		event.GotoDrawChapter(2)
		if vm.wait() then
			return skip(68)
		end
		helper_b0211f82(4)
		if vm.skipping() then
			return skip(69)
		end
		event.CmrsSetPos(-189.24, 15.33, 545.99)
		event.CmrsSetRef(-167.18, -44.79, 516.47)
		event.SpriteSetDraw(4, 1)
		event.ObjsSetColor(14, 0, 0, 0, 128, 0)
		event.SetFadeIn(0)
		if vm.wait() then
			return skip(70)
		end
		event.SetMesWindowMode(0, 8)
		event.MesMake_2(
			0,
			'[(!)]Monica reist jetzt mit. W[UNI00e4]hle im\n   Hauptmen[UNI00fc] "Charakter", um den Charakter\n   zu wechseln (oder dr[UNI00fc]cke die L3-Taste).'
		)
		helper_d1353c5b(0, -1, 8, 0, 0)
		if vm.skipping() then
			return skip(71)
		end
		helper_8333218b(352, 5)
		if vm.skipping() then
			return skip(72)
		end
		event.SetMesWindowMode(0, 7)
		event.CmrsSetPos(-114.91, 26.7, 585.59)
		event.CmrsSetRef(-547.13, 5.01, 284.33)
		event.ObjsSetPos(0, -154.04, 0.0, 565.84)
		event.ObjsSetRot(0, 0.0, -2.44, 0.0)
		event.ObjsSetRot(1, 0.0, 0.48, 0.0)
		event.ObjsSetMotion(0, "モニカ見立ち", 4, -1.0, 1)
		event.ObjsSetMotion(1, "指差し立ち", 4, -1.0, 1)
		event.StopBgm(0)
		helper_b0211f82(4)
		if vm.skipping() then
			return skip(73)
		end
		event.LoadBgm(1)
		event.PlayBgm(0)
		event.InitDramaScene()
		event.ObjsSetColor(14, 0, 0, 0, 0, 30)
		helper_b0211f82(30)
		if vm.skipping() then
			return skip(74)
		end
		event.SpriteSetDraw(4, 0)
		event.ObjsSetMotion(1, "指差し会話", 0)
		event.SetPakuAnim(1, "わらい口パク")
		helper_e20fd550(2070320, 75)
		if vm.skipping() then
			return skip(75)
		end
		event.ResetPakuAnim()
		event.CharaActive(1, 34)
		event.CmrsSetPos(-201.47, 17.91, 568.45)
		event.CmrsSetRef(-154.0, 21.06, 552.83)
		event.ObjsSetPos(0, -162.09, 0.0, 562.18)
		event.ObjsSetRot(0, 0.0, -1.96, 0.0)
		event.ObjsSetRot(1, 0.0, -1.68, 0.0)
		event.ObjsSetPos(2, -72.39, 9.71, 707.79)
		event.ObjsSetRot(2, 0.0, -2.64, 0.0)
		event.ObjsSetMotion(0, "立ち", 4, -1.0, 1)
		event.ObjsSetMotion(1, "立ち", 4, -1.0, 1)
		event.ObjsTexAnime(1, 0)
		event.ObjsTexAnime(1, 1, "おこり顔")
		event.ObjsTexAnime(1, 1, "おこり目パチ")
		event.SetPakuAnim(0, "通常口パク")
		helper_92829c19(2070330)
		if vm.skipping() then
			return skip(76)
		end
		event.ResetPakuAnim()
		event.ObjsSetMotion(0, "振り返る2", 6, -1.0, 1)
		event.ObjsNextMotion(0, "振り返る2L", 0)
		event.ObjsSetMotion(1, "振り返る3", 6, -1.0, 1)
		event.ObjsNextMotion(1, "振り返る3L", 0)
		event.ObjsSetMotion(2, "立ち", 0)
		event.ObjsTexAnime(2, 0)
		event.ObjsTexAnime(2, 1, "わらい顔")
		event.ObjsTexAnime(2, 1, "通常目パチ")
		event.CmrsMove(-217.49, 21.55, 521.2, -180.22, 20.7, 546.04, 33)
		helper_b0211f82(33)
		if vm.skipping() then
			return skip(77)
		end
		event.ObjsSetMotion(2, "会話", 6)
		event.ObjsNextMotion(2, "立ち", 0)
		event.SetPakuAnim(2, "わらい口パク")
		helper_92829c19(2070340)
		if vm.skipping() then
			return skip(78)
		end
		event.ResetPakuAnim()
		event.SetPakuAnim(2, "わらい口パク")
		helper_92829c19(2070345)
		if vm.skipping() then
			return skip(79)
		end
		event.ResetPakuAnim()
		event.CharaActive(1, 35)
		event.CharaActive(1, 36)
		event.CmrsSetPos(-171.0, 27.48, 601.08)
		event.CmrsSetRef(-147.93, 29.07, 706.46)
		event.ObjsSetPos(3, -154.92, 0.0, 741.22)
		event.ObjsSetRot(3, 0.0, 3.04, 0.0)
		event.ObjsSetPos(4, -183.74, 0.0, 742.29)
		event.ObjsSetRot(4, 0.0, 2.92, 0.0)
		event.ObjsTexAnime(3, 0)
		event.ObjsTexAnime(3, 1, "目パチ")
		event.ObjsTexAnime(4, 0)
		event.ObjsTexAnime(4, 1, "目パチ")
		event.ObjsSetMotion(3, "会話2", 6)
		event.ObjsNextMotion(3, "立ち", 0)
		event.ObjsSetMotion(4, "立ち", 0)
		event.SetPakuAnim(3, "口パク")
		helper_92829c19(2070350)
		if vm.skipping() then
			return skip(80)
		end
		event.ResetPakuAnim()
		event.SetPakuAnim(3, "口パク")
		helper_92829c19(2070360)
		if vm.skipping() then
			return skip(81)
		end
		event.ResetPakuAnim()
		event.SetPakuAnim(3, "口パク")
		helper_92829c19(2070370)
		if vm.skipping() then
			return skip(82)
		end
		event.ResetPakuAnim()
		helper_126faf7c(3)
		if vm.skipping() then
			return skip(83)
		end
		event.ObjsSetMotion(4, "スコップ会話2", 6)
		event.ObjsNextMotion(4, "立ち", 0)
		event.SetPakuAnim(4, "口パク")
		helper_92829c19(2070380)
		if vm.skipping() then
			return skip(84)
		end
		event.ResetPakuAnim()
		helper_126faf7c(4)
		if vm.skipping() then
			return skip(85)
		end
		event.EohSetFootSoundId(3, 1)
		event.EohSetFootSoundId(4, 1)
		event.ObjsSetMotion(3, "歩き", 0)
		event.ObjsRotation(3, 0.0, 0.16, 0.0, 20)
		helper_b0211f82(10)
		if vm.skipping() then
			return skip(86)
		end
		event.ObjsSetMotion(4, "スコップ歩き", 0)
		event.ObjsRotation(4, 0.0, 0.04, 0.0, 20)
		event.ObjsPosDelay(3, 10)
		event.ObjsSetMotion(3, "走り", 0)
		event.ObjsMove(3, -107.08, 0.0, 959.69, 45, 1)
		event.ObjsPosDelay(4, 10)
		event.ObjsSetMotion(4, "スコップ走り", 0)
		event.ObjsMove(4, -137.0, 0.0, 955.7, 60, 1)
		helper_b0211f82(60)
		if vm.skipping() then
			return skip(87)
		end
		event.CmrsSetPos(-182.22, 15.16, 581.8)
		event.CmrsSetRef(-151.21, 22.1, 543.01)
		event.ObjsSetPos(0, -141.55, 0.0, 545.23)
		event.ObjsSetRot(0, 0.0, -0.4, 0.0)
		event.ObjsSetRot(1, 0.0, 0.12, 0.0)
		event.ObjsTexAnime(1, 0)
		event.ObjsTexAnime(1, 1, "デフォルト顔")
		event.ObjsTexAnime(1, 1, "通常目パチ")
		event.ObjsSetMotion(0, "立ち", 4, -1.0, 1)
		event.ObjsSetMotion(1, "手をふる", 6, -1.0, 1)
		event.ObjsNextMotion(1, "立ち", 4)
		event.ObjsSetMotion(3, "立ち", 4)
		event.ObjsSetMotion(4, "スコップ立ち", 4)
		event.SetPakuAnim(1, "通常口パク")
		helper_92829c19(2070390)
		if vm.skipping() then
			return skip(88)
		end
		event.ResetPakuAnim()
		helper_126faf7c(1)
		if vm.skipping() then
			return skip(89)
		end
		event.SetPakuAnim(1, "通常口パク")
		helper_92829c19(2070400)
		if vm.skipping() then
			return skip(90)
		end
		event.ResetPakuAnim()
		event.ObjsSetMotion(0, "うなづく（モニカ見）", 6, -1.0, 1)
		helper_b0211f82(38)
		if vm.skipping() then
			return skip(91)
		end
		event.CmrsSetPos(-105.67, 24.06, 557.69)
		event.CmrsSetRef(-158.84, 23.49, 525.23)
		event.ObjsSetPos(0, -173.5, 0.0, 515.39)
		event.ObjsSetRot(0, 0.0, -2.0, 0.0)
		event.ObjsSetPos(1, -158.87, 0.0, 543.98)
		event.ObjsSetRot(1, 0.0, -2.88, 0.0)
		event.ObjsSetMotion(0, "立ち", 4, -1.0, 1)
		event.ObjsSetMotion(1, "歩き", 4, -1.0, 1)
		event.ObjsMove(1, -170.41, 0.0, 526.61, 45)
		helper_b0211f82(15)
		if vm.skipping() then
			return skip(92)
		end
		return part3()
	end
	function part3()
		event.CancelDramaScene()
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.EsmClear()
		event.SetFadeOut(30)
		helper_b0211f82(30)
		if vm.skipping() then
			return skip(94)
		end
		event.SetCharaPos(0, -245.13, 0.0, -21.46)
		event.SetCharaRot(0, 0.0, -1.52, 0.0)
		helper_26e74()
		event.ResetCamera(1, 0.0, 20.0)
		event.SetCameraPos(-300.47, 19.23, -22.1)
		event.SetCameraRef(-236.15, 23.49, -21.6)
		event.SetFadeIn(30)
		helper_b0211f82(30)
		if vm.skipping() then
			return skip(95)
		end
		var2 = event.GetMesWindowMode() or var2
		event.SetMesWindowMode(0, 8)
		event.MesMake_2(
			0,
			'[(!)]Jetzt kannst du mit dem Zug fahren.\n   W[UNI00e4]hle im Zugt[UNI00fc]r-Men[UNI00fc] "Verlassen",\n   um in Palm Brinks einkaufen zu gehen.'
		)
		helper_d1353c5b(0, -1, 8, 0, 0)
		if vm.skipping() then
			return skip(96)
		end
		event.MesMake_2(
			0,
			"[(!)]Wenn sich dir Gef[UNI00e4]hrten anschlie[UNI00df]en,\n   setze sie in den Zug. Damit\n   kannst du sie in Georama-Gebiete<page>schicken oder sie zur Unterst[UNI00fc]tzung\nmit in Verliese\nnehmen."
		)
		helper_d1353c5b(0, -1, 8, 0, 0)
		if vm.skipping() then
			return skip(97)
		end
		event.SetMesWindowMode(0, var2)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFlag(207, 1)
	event.Initialize()
	var0 = event.SndLoadSound(2211) or var0
	helper_27ec0()
	event.StopBgm(0)
	helper_b0211f82(4)
	if vm.skipping() then
		return skip(2)
	end
	event.LoadBgm(59)
	event.EohSetSoundId(0, var0)
	event.EohSetSoundId(3, var0)
	event.EohSetSoundId(4, var0)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "デフォルト顔")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "デフォルト顔")
	event.ObjsTexAnime(2, 1, "通常目パチ")
	event.InitDramaScene()
	event.SetMpcharaMotion("p01_train01", "kikan-m0", "機関")
	event.SetFadeIn(30)
	event.CmrsSetPos(-434.98, 136.35, -416.59)
	event.CmrsSetRef(-204.96, 128.86, -33.25)
	helper_7545b4dd(var0)
	if vm.skipping() then
		return skip(3)
	end
	event.EohSetShadow(2, 0)
	event.CharaActive(1, 34)
	event.CmrsSetPos(-186.23, 38.08, 632.43)
	event.CmrsSetRef(-133.81, 42.89, 555.58)
	event.ObjsSetPos(5, 1.3, 8.0, 707.604)
	event.ObjsSetPos(2, -7.85, 43.32, 488.75)
	event.ObjsSetRot(2, 0.0, -1.2, 0.0)
	event.SndSePlay(var0, 9)
	event.EohSyncObj(10, "p01_train01", "train11-m1")
	event.EohSyncObj(11, "p01_train01", "train12-m1")
	event.EohSyncObj(12, "p01_train01", "train12-m3")
	event.ObjsInit(10)
	event.ObjsInit(11)
	event.ObjsInit(12)
	event.ObjsSyncObj(10, 10)
	event.ObjsSyncObj(11, 11)
	event.ObjsSyncObj(12, 12)
	event.ObjsSetRot(10, 0.0, 0.0, 0.0)
	event.ObjsSetRot(11, 0.0, 0.0, 0.0)
	event.ObjsSetRot(12, 0.0, 0.0, 0.0)
	event.ObjsRotation(10, 0.0, -1.8, 0.0, 30)
	event.ObjsRotation(11, 0.0, -1.8, 0.0, 30)
	event.ObjsRotation(12, 0.0, -1.8, 0.0, 30)
	helper_b0211f82(30)
	if vm.skipping() then
		return skip(4)
	end
	event.EohSetFootSoundId(2, 6)
	event.ObjsSetMotion(2, "歩き", 4)
	event.ObjsMove(2, -60.41, 43.32, 482.53, 90)
	helper_b0211f82(90)
	if vm.skipping() then
		return skip(5)
	end
	event.EohSetFootSoundId(2, -1)
	event.SndSePlay(var0, 10)
	event.ObjsSetMotion(2, "降りL", 4)
	event.ObjsJump(2, -121.4, 0.0, 519.8, -0.3, 16)
	helper_b0211f82(16)
	if vm.skipping() then
		return skip(6)
	end
	helper_126faf7c(2)
	if vm.skipping() then
		return skip(7)
	end
	event.ObjsSetMotion(2, "着地", 6)
	event.ObjsSetMotion(2, "立ち", 0)
	helper_b0211f82(16)
	if vm.skipping() then
		return skip(8)
	end
	event.ObjsSetRot(10, 0.0, 0.0, 0.0)
	event.ObjsSetRot(11, 0.0, 0.0, 0.0)
	event.ObjsSetRot(12, 0.0, 0.0, 0.0)
	event.EohSetShadow(2, 1)
	event.EsmClear()
	helper_e3a22687()
	event.SetMpcharaMotion("p01_train01", "kikan-m0", "停止")
	event.CharaActive(1, global0)
	event.CmrsSetPos(-173.15, 24.27, 496.1)
	event.CmrsSetRef(-105.11, 33.85, 689.64)
	event.ObjsSetPos(0, -115.15, 2.18, 481.7)
	event.ObjsSetRot(0, 0.0, 0.0, 0.0)
	event.ObjsSetPos(2, -137.2, 0.0, 503.69)
	event.ObjsSetRot(2, 0.0, 0.0, 0.0)
	event.EohSetFootSoundId(2, 0)
	event.EohSetFootSoundId(0, 1)
	event.EohSetFootSoundId(2, 1)
	event.EohSetFootSoundId(1, 1)
	event.ObjsSetMotion(0, "歩き", 4, -1.0, 1)
	event.ObjsSetMotion(2, "歩き", 4, -1.0, 1)
	event.ObjsMove(0, -116.24, 1.91, 584.2, 120)
	event.ObjsMove(2, -136.14, 0.0, 621.84, 120)
	helper_b0211f82(120)
	if vm.skipping() then
		return skip(9)
	end
	event.CharaActive(1, global1)
	event.CmrsSetPos(-148.61, 19.95, 659.05)
	event.CmrsSetRef(-138.99, 22.93, 629.2)
	event.ObjsSetPos(0, -141.01, 0.0, 578.41)
	event.ObjsSetRot(0, 0.0, 0.36, 0.0)
	event.ObjsSetPos(1, -158.87, 0.0, 543.98)
	event.ObjsSetRot(1, 0.0, 0.48, 0.0)
	event.ObjsSetRot(2, 0.0, 0.24, 0.0)
	event.ObjsSetMotion(0, "立ち", 4, -1.0, 1)
	event.ObjsSetMotion(2, "頭をかく", 4)
	event.SetPakuAnim(2, "通常口パク")
	helper_92829c19(2070010)
	if vm.skipping() then
		return skip(10)
	end
	event.ResetPakuAnim()
	event.EsmSetValue(1, 0)
	event.CmrsSetPos(-157.72, 20.49, 508.51)
	event.CmrsSetRef(-155.0, 20.82, 540.27)
	event.ObjsSetMotion(1, "会話", 6, -1.0, 1)
	event.ObjsMotionDelay(0, 15)
	event.ObjsSetMotion(0, "振り返る", 6, -1.0, 1)
	event.ObjsNextMotion(0, "振り返るL", 0)
	event.ObjsSetMotion(2, "立ち", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_92829c19(2070020)
	if vm.skipping() then
		return skip(11)
	end
	event.ResetPakuAnim()
	event.CmrsSetPos(-204.87, 17.59, 518.8)
	event.CmrsSetRef(-167.74, 18.98, 537.69)
	event.ObjsSetPos(0, -141.01, 0.0, 578.41)
	event.ObjsSetRot(0, 0.0, 0.72, 0.0)
	event.ObjsResetDaPosition(0)
	event.ObjsSetRot(1, 0.0, -0.48, 0.0)
	event.ObjsSetMotion(1, "振り返る", 6, -1.0, 1)
	event.ObjsNextMotion(1, "振り返るL", 0)
	event.SndSePlay(var0, 11)
	event.SetPakuAnim(1, "通常口パク")
	helper_e20fd550(2070030, 90)
	if vm.skipping() then
		return skip(12)
	end
	event.ResetPakuAnim()
	event.PlayBgm(0)
	helper_b0211f82(3)
	if vm.skipping() then
		return skip(13)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_e20fd550(2070035, 75)
	if vm.skipping() then
		return skip(14)
	end
	event.ResetPakuAnim()
	event.CharaActive(0, 34)
	event.ObjsSetRot(1, 0.0, -2.16, 0.0)
	event.ObjsSetMotion(1, "立ち", 4)
	event.CmrsSetPos(-145.56, 14.05, 606.56)
	event.CmrsSetRef(-171.06, 25.18, 536.36)
	event.CmrsMoveAhd2(1.58, -11.13, 75.72, 180, 2, 0.4)
	helper_b0211f82(30)
	if vm.skipping() then
		return skip(15)
	end
	helper_e20fd550(2070040, 120)
	if vm.skipping() then
		return skip(16)
	end
	helper_b0211f82(30)
	if vm.skipping() then
		return skip(17)
	end
	event.SetCrossfade(30)
	event.ObjsSetMotion(0, "立ち", 4, -1.0, 1)
	event.CmrsInit()
	event.ObjsSetRot(0, 0.0, -2.44, 0.0)
	event.ObjsSetMotion(0, "立ち", 4)
	event.CmrsSetPos(-172.35, 21.82, 561.72)
	event.CmrsSetRef(-139.13, 21.22, 572.94)
	event.CmrsMove2(-195.67, 21.82, 534.13, -163.38, 21.22, 544.2, 300, 2, 0.4)
	helper_b0211f82(45)
	if vm.skipping() then
		return skip(18)
	end
	helper_e20fd550(2070045, 240)
	if vm.skipping() then
		return skip(19)
	end
	helper_b0211f82(30)
	if vm.skipping() then
		return skip(20)
	end
	event.CmrsInit()
	event.CmrsSetPos(-98.17, 22.89, 602.25)
	event.CmrsSetRef(-133.12, 23.35, 577.23)
	event.ObjsSetRot(1, 0.0, 0.48, 0.0)
	event.ObjsSetRot(0, 0.0, -2.68, 0.0)
	event.CmrsMove2(-115.83, 22.89, 589.95, -133.03, 23.35, 577.11, 510, 2, 0.4)
	event.ObjsSetMotion(0, "モニカ見立ち", 4, -1.0, 1)
	event.ObjsSetMotion(1, "振り返る2", 6, -1.0, 1)
	event.ObjsNextMotion(1, "指差し会話", 2)
	event.ObjsNextMotion(1, "振り返る2戻り", 2)
	event.ObjsNextMotion(1, "会話", 6)
	event.ObjsNextMotion(1, "立ち", 2)
	event.ObjsNextMotion(1, "会話", 2)
	event.ObjsNextMotion(1, "会話", 2)
	event.ObjsNextMotion(1, "立ち", 0)
	event.ObjsTexAnime(1, 1, "通常口パク")
	helper_e20fd550(2070050, 120)
	if vm.skipping() then
		return skip(21)
	end
	helper_e20fd550(2070055, 210)
	if vm.skipping() then
		return skip(22)
	end
	helper_e20fd550(2070060, 180)
	if vm.skipping() then
		return skip(23)
	end
	event.ObjsSetMotion(1, "会話", 6)
	event.ObjsNextMotion(1, "立ち", 0)
	event.SetPakuAnim(1, "通常口パク")
	helper_92829c19(2070070)
	if vm.skipping() then
		return skip(24)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(1, "通常口パク")
	helper_92829c19(2070075)
	if vm.skipping() then
		return skip(25)
	end
	event.ResetPakuAnim()
	event.CmrsInit()
	event.CmrsSetPos(-185.14, 25.41, 532.33)
	event.CmrsSetRef(-163.43, 22.64, 546.85)
	event.ObjsSetRot(0, 0.0, -2.68, 0.0)
	event.ObjsSetMotion(0, "会話", 6)
	event.ObjsNextMotion(0, "立ち", 0)
	event.SetPakuAnim(0, "通常口パク")
	helper_92829c19(2070080)
	if vm.skipping() then
		return skip(26)
	end
	event.ResetPakuAnim()
	helper_126faf7c(0)
	if vm.skipping() then
		return skip(27)
	end
	event.SpriteSetDraw(0, 1)
	event.ObjsSetColor(20, 128.0, 128.0, 128.0, 128.0, 15)
	helper_b0211f82(45)
	if vm.skipping() then
		return skip(28)
	end
	event.CharaActive(0, global0)
	event.CmrsSetPos(-143.73, 21.02, 571.76)
	event.CmrsSetRef(-159.34, 21.71, 544.14)
	event.ObjsSetMotion(1, "説明", 4, -1.0, 1)
	event.ObjsSetColor(20, 128.0, 128.0, 128.0, 0.0, 15)
	helper_b0211f82(15)
	if vm.skipping() then
		return skip(29)
	end
	event.SpriteSetDraw(0, 0)
	event.SetPakuAnim(1, "わらい口パク")
	helper_92829c19(2070090)
	if vm.skipping() then
		return skip(30)
	end
	event.ResetPakuAnim()
	event.SpriteSetDraw(1, 1)
	event.ObjsSetColor(21, 128.0, 128.0, 128.0, 128.0, 30)
	helper_92829c19(2070100)
	if vm.skipping() then
		return skip(31)
	end
	helper_92829c19(2070110)
	if vm.skipping() then
		return skip(32)
	end
	event.SpriteSetDraw(2, 1)
	event.ObjsSetColor(22, 128.0, 128.0, 128.0, 128.0, 15)
	helper_b0211f82(15)
	if vm.skipping() then
		return skip(33)
	end
	event.SpriteSetDraw(1, 0)
	helper_92829c19(2070120)
	if vm.skipping() then
		return skip(34)
	end
	helper_126faf7c(21)
	if vm.skipping() then
		return skip(35)
	end
	event.CharaActive(1, global0)
	event.CmrsSetPos(-147.89, 29.16, 595.33)
	event.CmrsSetRef(-145.3, 19.8, 562.12)
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "無表情")
	event.ObjsTexAnime(1, 1, "通常口パク")
	event.ObjsSetMotion(0, "立ち", 4, -1.0, 1)
	event.ObjsSetMotion(1, "会話", 6, -1.0, 1)
	event.ObjsNextMotion(1, "立ち", 0)
	event.ObjsSetColor(22, 128.0, 128.0, 128.0, 0.0, 15)
	event.SetPakuAnim(1, "通常口パク")
	helper_92829c19(2070130)
	if vm.skipping() then
		return skip(36)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(1, "通常口パク")
	helper_92829c19(2070140)
	if vm.skipping() then
		return skip(37)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(1, "通常口パク")
	helper_92829c19(2070145)
	if vm.skipping() then
		return skip(38)
	end
	event.ResetPakuAnim()
	event.SpriteSetDraw(2, 0)
	event.SpriteSetDraw(3, 1)
	event.ObjsSetColor(23, 128.0, 128.0, 128.0, 128.0, 30)
	helper_92829c19(2070150)
	if vm.skipping() then
		return skip(39)
	end
	helper_92829c19(2070160)
	if vm.skipping() then
		return skip(40)
	end
	event.CmrsSetPos(-62.39, 11.55, 592.64)
	event.CmrsSetRef(-144.81, 34.83, 558.99)
	event.ObjsSetPos(0, -162.09, 0.0, 562.18)
	event.ObjsSetRot(0, 0.0, -1.84, 0.0)
	event.ObjsSetRot(1, 0.0, -2.04, 0.0)
	event.ObjsSetMotion(1, "立ち", 4)
	event.CmrsMove2(-93.73, 11.55, 579.85, -176.14, 34.83, 546.2, 300, 2, 0.4)
	event.ObjsSetColor(23, 128.0, 128.0, 128.0, 0.0, 15)
	helper_b0211f82(15)
	if vm.skipping() then
		return skip(41)
	end
	event.SpriteSetDraw(3, 0)
	event.SetPakuAnim(1, "通常口パク")
	helper_92829c19(2070170)
	if vm.skipping() then
		return skip(42)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(1, "通常口パク")
	helper_92829c19(2070175)
	if vm.skipping() then
		return skip(43)
	end
	event.ResetPakuAnim()
	event.CmrsInit()
	event.CmrsSetPos(-199.01, 15.5, 557.14)
	event.CmrsSetRef(-160.33, 20.46, 548.43)
	event.ObjsSetMotion(0, "右・モニカ見", 6, -1.0, 1)
	event.ObjsNextMotion(0, "右・モニカ見L", 0)
	event.SetPakuAnim(1, "通常口パク")
	helper_92829c19(2070180)
	if vm.skipping() then
		return skip(44)
	end
	event.ResetPakuAnim()
	event.ObjsTexAnime(1, 1, "目あき～目とじ")
	event.ObjsSetMotion(1, "下を向く", 6, -1.0, 1)
	event.ObjsNextMotion(1, "下を向くL", 0)
	event.SetPakuAnim(1, "通常口パク")
	helper_92829c19(2070190)
	if vm.skipping() then
		return skip(45)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(1, "通常口パク")
	helper_92829c19(2070200)
	if vm.skipping() then
		return skip(46)
	end
	event.ResetPakuAnim()
	event.CharaActive(0, global0)
	event.CmrsSetPos(-189.08, 26.03, 532.05)
	event.CmrsSetRef(-156.88, 20.88, 545.17)
	event.ObjsSetPos(1, -158.87, 0.0, 543.98)
	event.ObjsSetRot(1, 0.0, -2.04, 0.0)
	event.CmrsMove2(-186.83, 24.76, 532.98, -156.88, 20.88, 545.17, 90, 0, 0.4)
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "おこり顔")
	event.ObjsTexAnime(1, 1, "目とじ～目あき")
	event.SetPakuAnim(1, "通常口パク")
	helper_92829c19(2070210)
	if vm.skipping() then
		return skip(47)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(1, "通常口パク")
	helper_92829c19(2070220)
	if vm.skipping() then
		return skip(48)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(1, "通常口パク")
	helper_92829c19(2070230)
	if vm.skipping() then
		return skip(49)
	end
	event.ResetPakuAnim()
	event.CmrsInit()
	event.CharaActive(1, global0)
	event.CmrsSetPos(-184.15, 26.9, 520.44)
	event.CmrsSetRef(-163.12, 22.81, 547.31)
	event.ObjsSetRot(0, 0.0, 3.0, 0.0)
	event.ObjsSetRot(1, 0.0, -0.12, 0.0)
	event.SndSePlay(var0, 12)
	event.ObjsSetMotion(0, "モニカ見立ち", 4, -1.0, 1)
	event.ObjsSetMotion(1, "にぎりこぶし", 6, -1.0, 1)
	event.ObjsNextMotion(1, "にぎりこぶしL", 0)
	event.SetPakuAnim(1, "通常口パク")
	helper_92829c19(2070240)
	if vm.skipping() then
		return skip(50)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(0, "通常口パク")
	helper_92829c19(2070250)
	if vm.skipping() then
		return skip(51)
	end
	event.ResetPakuAnim()
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "デフォルト顔")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.CmrsSetPos(-192.2, 14.16, 580.57)
	event.CmrsSetRef(-164.89, 19.98, 558.98)
	event.SetPakuAnim(1, "わらい口パク")
	helper_92829c19(2070260)
	if vm.skipping() then
		return skip(52)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(0, "通常口パク")
	helper_92829c19(2070270)
	if vm.skipping() then
		return skip(53)
	end
	event.ResetPakuAnim()
	helper_b0211f82(45)
	if vm.skipping() then
		return skip(54)
	end
	event.ObjsSetMotion(0, "うなづく（モニカ見）", 6, -1.0, 1)
	event.ObjsNextMotion(0, "モニカ見立ち", 0)
	helper_b0211f82(37)
	if vm.skipping() then
		return skip(55)
	end
	event.SetPakuAnim(0, "通常口パク")
	helper_92829c19(2070280)
	if vm.skipping() then
		return skip(56)
	end
	event.ResetPakuAnim()
	event.SndSePlay(var0, 14)
	event.ObjsSetMotion(1, "喜ぶ", 6)
	event.ObjsNextMotion(1, "喜ぶL", 0)
	event.SetPakuAnim(1, "わらい口パク")
	helper_92829c19(2070290)
	if vm.skipping() then
		return skip(57)
	end
	event.ResetPakuAnim()
	helper_126faf7c(1)
	if vm.skipping() then
		return skip(58)
	end
	event.CharaActive(0, global0)
	event.CmrsSetPos(-161.91, 19.72, 571.63)
	event.CmrsSetRef(-157.59, 24.08, 543.43)
	event.SndSePlay(var0, 19)
	event.ObjsSetMotion(1, "握手", 6, -1.0, 1)
	event.ObjsNextMotion(1, "握手L", 0)
	helper_b0211f82(30)
	if vm.skipping() then
		return skip(59)
	end
	helper_b0211f82(30)
	if vm.skipping() then
		return skip(60)
	end
	event.FadeOutBgm(30)
	event.CharaActive(1, global0)
	event.CharaActive(0, global1)
	if global0 == 0 then
		event.CharaActive(0, 37)
	end
	event.CmrsSetPos(-158.1, 29.71, 533.72)
	event.CmrsSetRef(-162.0, 22.25, 561.36)
	event.ObjsTexAnime(0, 1, "半口")
	event.CmrsMove2(-158.94, 29.71, 539.69, -162.85, 22.25, 567.33, 48, 2, 0.4)
	helper_5fe8f3bb()
	if vm.skipping() then
		return skip(61)
	end
	helper_b0211f82(75)
	if vm.skipping() then
		return skip(62)
	end
	event.CharaActive(1, global1)
	event.CharaActive(1, 37)
	event.CmrsSetPos(-189.24, 15.33, 545.99)
	event.CmrsSetRef(-154.0, 23.32, 554.62)
	event.ObjsSetRot(0, 0.0, 2.88, 0.0)
	event.ObjsSetMotion(0, "握手", 6, -1.0, 1)
	event.ObjsNextMotion(0, "握手L", 0)
	helper_b0211f82(30)
	if vm.skipping() then
		return skip(63)
	end
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.InitSepia(-1, 0)
	event.SetCrossfade(30)
	event.StartSepia()
	helper_b0211f82(30)
	if vm.skipping() then
		return skip(64)
	end
	helper_e20fd550(2070300, 330)
	if vm.skipping() then
		return skip(65)
	end
	event.SetFadeOut(15)
	helper_b0211f82(15)
	if vm.skipping() then
		return skip(66)
	end
	event.EndSepia()
	return part2()
end

--- Helper function.
local function helper_31b20()
	local active_chr_no: s32 = 0
	event.SetMesWindowMode(0, 7)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		global0 = 0
		global1 = 32
		event.LoadMotion(5, "event/e200/e209/e209_mints.gltf", "info", global0)
		event.EohSyncChara(0, global0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global0)
		event.LoadChara(5, "chara/c02_base.gltf", "info", global1)
		event.LoadEquip(5, 1, 4, "info", global1)
		event.LoadEquip(5, 1, 3, "info", global1)
		event.LoadEquip(5, 1, 2, "info", global1, 33)
		event.LoadMotion(5, "event/e200/e209/e209_monica.gltf", "info", global1)
		event.EohSyncChara(1, global1)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global1)
		event.CharaActive(1, 33)
	end
	if active_chr_no == 1 then
		global0 = 32
		global1 = 0
		event.LoadChara(5, "chara/c01_base.gltf", "info", global0)
		event.LoadEquip(5, 0, 4, "info", global0)
		event.LoadEquip(5, 0, 3, "info", global0)
		event.LoadEquip(5, 0, 2, "info", global0, 33)
		event.LoadMotion(5, "event/e200/e209/e209_mints.gltf", "info", global0)
		event.EohSyncChara(0, global0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global0)
		event.CharaActive(1, 33)
		event.LoadMotion(5, "event/e200/e209/e209_monica.gltf", "info", global1)
		event.EohSyncChara(1, global1)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global1)
	end
	event.LoadChara(5, "event/e200/e209/e209_conda.gltf", "info", 36)
	event.EohSyncChara(4, 36)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.CharaActive(0, 36)
	event.LoadChara(5, "event/e200/e209/wine.gltf", "info", 37)
	event.EohSyncChara(5, 37)
	event.ObjsInit(5)
	event.ObjsSyncObj(5, 5)
	event.CharaActive(0, 37)
	event.LoadChara(5, "event/itemget_ev/itemget_ev.gltf", "info", 38)
	event.EohSyncChara(6, 38)
	event.ObjsInit(6)
	event.ObjsSyncObj(6, 6)
	event.CharaActive(0, 38)
	for var1 = 0, 4 do
		event.LoadChara(5, "event/e200/e209/e209_magic1.gltf", "info", 41 + var1)
		event.EohSyncChara(10 + var1, 41 + var1)
		event.ObjsInit(10 + var1)
		event.ObjsSyncObj(10 + var1, 10 + var1)
		event.CharaActive(0, 41 + var1)
	end
	event.LoadChara(5, "event/e200/e209/e209_magic2.gltf", "info", 42)
	event.EohSyncChara(8, 42)
	event.ObjsInit(8)
	event.ObjsSyncObj(8, 8)
	event.CharaActive(0, 42)
	event.LoadChara(5, "event/e200/e209/e209_flower.gltf", "info", 40)
	event.CharaActive(1, 40)
	event.EohSyncChara(9, 40)
	event.ObjsInit(9, 9)
	event.ObjsSyncObj(9, 9)
	event.ObjsSetPos(9, -885.352, 134.434, -841.894)
	event.ObjsSetRot(9, 2.340434, -0.9010716, 1.0717125)
	print("sync obj------------------------------------------\n")
	event.EohSyncObj(11, "p09_s0201")
	event.EohSetShow(11, 0)
	event.EsmInitialize(5)
	event.EsmLoadBase("e209魔法")
	event.EsmInitFix(5)
	event.LoadMes(0, 5, "event/e200/e209/e209_1.txt")
end

--- Helper function.
local function helper_3168c()
	local active_chr_no: s32 = 0
	local var1: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		var1 = 0
		var1 = var1 + 1
	end
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		event.CharaActive(1, global0)
		event.CharaActive(0, global1)
		event.DelExtMotion(global0)
		event.DelExtMotion(global1)
		event.DeleteChara(global1)
		event.DeleteChara(33)
	end
	if active_chr_no == 1 then
		event.CharaActive(1, global1)
		event.CharaActive(0, global0)
		event.DelExtMotion(global0)
		event.DelExtMotion(global1)
		event.DeleteChara(global0)
		event.DeleteChara(33)
	end
	event.DeleteChara(36)
	event.DeleteChara(37)
	event.DeleteChara(38)
	event.DeleteChara(40)
	var1 = 0
	while var1 < 5 do
		event.DeleteChara(41 + var1)
		var1 = var1 + 1
	end
	event.DeleteChara(42)
end

--- Helper function.
local function helper_3306c()
	local var0: s32 = 0
	local var1: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: s32 = 0
	local value: f32 = 0
	local value_2: f32 = 0
	local var12: f32 = 0
	local var13: f32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 32 then
			if at <= 1 then
				helper_5fe8f3bb()
			end
			if at <= 2 then
				helper_92829c19(2090620)
			end
			if at <= 3 then
				helper_b0211f82(45)
			end
			if at <= 4 then
				var9 = 0
				value_2 = 0.0
				value = 0.0
				pos_x = vm.f32(-694.77)
				pos_z = vm.f32(-857.66)
				value = vm.f32(value + 15.0)
				pos_x = vm.f32(pos_x + vm.f32(vm.sin(value_2) * value))
				pos_z = vm.f32(pos_z + vm.f32(vm.cos(value_2) * value))
			end
			if at <= 5 then
				var9 = var9 + 1
				helper_92829c19(2090630)
			end
			if at <= 6 then
				helper_b0211f82(30)
			end
			if at <= 7 then
				var13 = 128.0
				var12 = 1.0
				var13 = 0.0
				var13 = vm.f32(var13 - vm.f32(2.1333334))
				var12 = vm.f32(var12 - vm.f32(0.01))
			end
			if at <= 8 then
				var9 = var9 + 1
				helper_126faf7c(8)
			end
			if at <= 9 then
				helper_b0211f82(23)
			end
			if at <= 10 then
				helper_b0211f82(36)
			end
			if at <= 11 then
				helper_92829c19(2090640)
			end
			if at <= 12 then
				helper_92829c19(2090650)
			end
			if at <= 13 then
				helper_92829c19(2090660)
			end
			if at <= 14 then
				helper_92829c19(2090670)
			end
			if at <= 15 then
				helper_92829c19(2090680)
			end
			if at <= 16 then
				helper_126faf7c(1)
			end
			if at <= 17 then
				helper_92829c19(2090690)
			end
			if at <= 18 then
				helper_92829c19(2090700)
			end
			if at <= 19 then
				helper_92829c19(2090710)
			end
			if at <= 20 then
				helper_92829c19(2090720)
			end
			if at <= 21 then
				helper_92829c19(2090730)
			end
			if at <= 22 then
				helper_92829c19(2090740)
			end
			if at <= 23 then
				helper_b0211f82(27)
			end
			if at <= 24 then
				helper_92829c19(2090750)
			end
			if at <= 25 then
				helper_126faf7c(0)
			end
			if at <= 26 then
				helper_92829c19(2090760)
			end
			if at <= 27 then
				helper_92829c19(2090765)
			end
			if at <= 28 then
				helper_8333218b(370, 1)
			end
			if at <= 29 then
				helper_92829c19(2090770)
			end
			if at <= 30 then
				helper_92829c19(2090780)
			end
			if at <= 31 then
				helper_b0211f82(30)
			end
			if vm.skip_end() then
				return skip(33)
			end
			return part2()
		end
		if at <= 33 then
			helper_3168c()
			helper_b0211f82(4)
		end
	end
	function part2()
		event.CancelDramaScene()
		event.EsmClear()
		helper_3168c()
		event.StopBgm(0)
		helper_b0211f82(4)
		if vm.skipping() then
			return skip(34)
		end
		event.LoadBgm(1)
		event.PlayBgm(0)
		event.ResetCamera(1, 0.0, 20.0)
		event.SetFadeIn(30)
	end
	event.SetFlag(209, 1)
	event.Initialize()
	var0 = event.SndLoadSound(2223) or var0
	var1 = event.SndLoadSound(8, "snd2/sp/sp_006.sound.json") or var1
	helper_31b20()
	event.StopBgm(0)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "デフォルト顔")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.SetStatus(1, global0, 256, 1)
	event.SetStatus(1, global1, 256, 1)
	event.StopBgm(0)
	helper_b0211f82(4)
	if vm.skipping() then
		return skip(1)
	end
	event.LoadBgm(50)
	event.PlayBgm(0)
	event.InitDramaScene()
	event.CharaActive(1, global0)
	event.CharaActive(1, global1)
	event.CharaActive(1, 36)
	event.CharaActive(1, 33)
	event.CmrsSetPos(-511.68, 40.04, -655.39)
	event.CmrsSetRef(-435.03, 32.29, -719.93)
	event.ObjsSetPos(0, -633.03, 0.0, -833.81)
	event.ObjsSetRot(0, 0.0, -1.44, 0.0)
	event.ObjsSetPos(1, -635.79, 0.0, -814.6)
	event.ObjsSetRot(1, 0.0, -1.92, 0.0)
	event.ObjsSetPos(4, -661.7, 0.0, -828.21)
	event.ObjsSetRot(4, 0.0, 1.48, 0.0)
	event.ObjsSetMotion(0, "小人見立ち", 4, -1.0, 1)
	event.ObjsSetMotion(1, "小人見立ち", 4, -1.0, 1)
	event.ObjsSetMotion(4, "立ち", 4)
	event.CmrsFadeInit()
	event.CmrsFadeIn(60, 0.0, 0.0, 0.0)
	event.CmrsSetPos(-531.23, 25.72, -753.68)
	event.CmrsSetRef(-442.13, 24.48, -788.67)
	event.CmrsMove2(-531.23, 25.72, -753.68, -619.77, 24.48, -800.56, 120, 2, 0.4)
	helper_5fe8f3bb()
	if vm.skipping() then
		return skip(2)
	end
	event.CmrsSetPos(-587.85, 29.47, -818.63)
	event.CmrsSetRef(-648.63, 21.46, -826.79)
	event.CmrsSetPos(-587.85, 29.47, -818.63)
	event.CmrsSetRef(-648.63, 21.46, -826.79)
	helper_92829c19(2090620)
	if vm.skipping() then
		return skip(3)
	end
	event.SndSePlay(var0, 15)
	event.ObjsSetMotion(4, "振り返る", 6)
	event.ObjsNextMotion(4, "振り返るL", 0)
	helper_b0211f82(45)
	if vm.skipping() then
		return skip(4)
	end
	if global0 ~= 0 then
		event.CharaActive(0, 33)
	end
	event.CharaActive(0, global0)
	event.CmrsSetPos(-695.85, 6.37, -803.15)
	event.CmrsSetRef(-677.57, 12.04, -825.79)
	event.SndSePlay(var0, 16)
	event.ObjsSetMotion(4, "杖を振る", 6)
	event.ObjsSetMotion(4, "杖を振るL", 0)
	do
		local out1, out2, out3 = event.GetCharaPos(40)
		var6 = out1 or var6
		var7 = out2 or var7
		var8 = out3 or var8
	end
	var9 = 0
	while var9 < 10 do
		value_2 = 0.0
		value = 0.0
		do
			local out1, out2, out3 = event.EohGetFramePos(4, "tue_saki")
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		pos_x = vm.f32(-694.77)
		pos_z = vm.f32(-857.66)
		value_2 = event.GetRand(1.5707964) or value_2
		value = event.GetRand(20.0) or value
		value = vm.f32(value + 15.0)
		pos_x = vm.f32(pos_x + vm.f32(vm.sin(value_2) * value))
		pos_z = vm.f32(pos_z + vm.f32(vm.cos(value_2) * value))
		event.EsmCreate("e209魔法")
		event.EsmSetVect1(pos_x, pos_y, pos_z)
		event.EsmSetVect2(var6, var7, var8)
		if vm.wait() then
			return skip(5)
		end
		var9 = var9 + 1
	end
	helper_92829c19(2090630)
	if vm.skipping() then
		return skip(6)
	end
	event.CharaActive(0, 41)
	event.CharaActive(1, 42)
	event.CmrsSetPos(-620.39, 17.91, -830.69)
	event.CmrsSetRef(-657.47, 26.12, -833.22)
	event.ObjsSetPos(8, -763.76, -38.88, -840.29)
	event.ObjsSetRot(8, 0.0, 1.68, 0.0)
	event.SndSePlay(var0, 17)
	event.ObjsSetMotion(8, "キラキラ", 4)
	helper_b0211f82(30)
	if vm.skipping() then
		return skip(7)
	end
	event.ObjsSetMotion(8, "消える", 6)
	event.ObjsMotionWait(8)
	event.SetModelLightSwitch(40, 0)
	event.SetMotionBlur(1)
	var13 = 128.0
	var12 = 1.0
	while var9 < 82 do
		if var13 < vm.f32(2.1333334) then
			var13 = 0.0
		else
			var13 = vm.f32(var13 - vm.f32(2.1333334))
		end
		event.SetModelLightColor(40, 128.0, 128.0, 128.0, var13)
		event.SetScale(40, var12, var12, var12)
		var12 = vm.f32(var12 - vm.f32(0.01))
		if vm.wait() then
			return skip(8)
		end
		var9 = var9 + 1
	end
	helper_126faf7c(8)
	if vm.skipping() then
		return skip(9)
	end
	if global0 ~= 0 then
		event.CharaActive(1, 33)
	end
	event.CharaActive(1, global0)
	event.CharaActive(0, 36)
	event.CmrsSetPos(-671.41, 16.73, -811.28)
	event.CmrsSetRef(-644.75, 19.15, -824.0)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "無表情")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsTexAnime(0, 1, "半口")
	event.ObjsSetMotion(0, "驚く", 6, -1.0, 1)
	helper_b0211f82(23)
	if vm.skipping() then
		return skip(10)
	end
	event.CharaActive(1, 36)
	event.CmrsSetPos(-607.66, 36.8, -768.32)
	event.CmrsSetRef(-624.43, 27.66, -792.8)
	event.CmrsSetPos(-620.75, 27.66, -778.33)
	event.CmrsSetRef(-631.0, 24.74, -796.76)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsSetMotion(0, "小人見立ち", 4, -1.0, 1)
	event.SndSePlay(var0, 18)
	event.ObjsSetMotion(4, "振り返る2", 6)
	event.ObjsNextMotion(4, "立ち", 0)
	helper_b0211f82(36)
	if vm.skipping() then
		return skip(11)
	end
	event.ObjsSetMotion(4, "会話", 6)
	event.ObjsNextMotion(4, "立ち", 0)
	helper_92829c19(2090640)
	if vm.skipping() then
		return skip(12)
	end
	helper_92829c19(2090650)
	if vm.skipping() then
		return skip(13)
	end
	helper_92829c19(2090660)
	if vm.skipping() then
		return skip(14)
	end
	event.ObjsSetMotion(4, "会話", 6)
	event.ObjsNextMotion(4, "立ち", 0)
	helper_92829c19(2090670)
	if vm.skipping() then
		return skip(15)
	end
	event.CmrsSetPos(-686.13, 14.37, -802.47)
	event.CmrsSetRef(-665.83, 15.3, -815.79)
	event.CmrsSetPos(-683.22, 14.18, -807.51)
	event.CmrsSetRef(-662.33, 17.31, -817.61)
	event.ObjsSetRot(0, 0.0, -1.32, 0.0)
	event.ObjsSetRot(1, 0.0, -2.04, 0.0)
	event.ObjsSetMotion(0, "小人見立ち", 4, -1.0, 1)
	event.ObjsSetMotion(1, "小人見会話", 6, -1.0, 1)
	event.ObjsNextMotion(1, "小人見立ち", 0)
	event.ObjsSetMotion(0, "もっともだ", 6)
	event.ObjsNextMotion(0, "小人見立ち", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_92829c19(2090680)
	if vm.skipping() then
		return skip(16)
	end
	event.ResetPakuAnim()
	helper_126faf7c(1)
	if vm.skipping() then
		return skip(17)
	end
	helper_92829c19(2090690)
	if vm.skipping() then
		return skip(18)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_92829c19(2090700)
	if vm.skipping() then
		return skip(19)
	end
	event.ResetPakuAnim()
	event.CmrsSetPos(-618.98, 20.59, -766.84)
	event.CmrsSetRef(-645.79, 21.42, -821.23)
	event.CmrsSetPos(-620.75, 27.66, -778.33)
	event.CmrsSetRef(-631.0, 24.74, -796.76)
	event.ObjsResetDaPosition(0)
	helper_92829c19(2090710)
	if vm.skipping() then
		return skip(20)
	end
	event.ObjsTexAnime(1, 1, "目あき～目あきれ")
	event.SndSePlay(var0, 19)
	event.ObjsSetMotion(1, "はぁ？", 6)
	event.ObjsNextMotion(1, "はぁ？L", 4)
	helper_92829c19(2090720)
	if vm.skipping() then
		return skip(21)
	end
	event.ObjsSetMotion(1, "う・・・", 2)
	event.ObjsNextMotion(1, "う・・・L", 0)
	helper_92829c19(2090730)
	if vm.skipping() then
		return skip(22)
	end
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "デフォルト顔")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.ObjsSetMotion(4, "会話", 6)
	event.ObjsNextMotion(4, "立ち", 0)
	helper_92829c19(2090740)
	if vm.skipping() then
		return skip(23)
	end
	event.CharaActive(1, 37)
	event.SetReference(36, "wine", 37)
	event.ObjsSetMotion(4, "ぶどう酒を渡す", 6)
	event.ObjsNextMotion(4, "ぶどう酒を渡すL", 0)
	helper_b0211f82(27)
	if vm.skipping() then
		return skip(24)
	end
	event.ObjsSetMotion(0, "小人見会話", 6)
	event.ObjsNextMotion(0, "小人見立ち")
	event.SetPakuAnim(0, "通常口パク")
	helper_92829c19(2090750)
	if vm.skipping() then
		return skip(25)
	end
	event.ResetPakuAnim()
	helper_126faf7c(0)
	if vm.skipping() then
		return skip(26)
	end
	helper_92829c19(2090760)
	if vm.skipping() then
		return skip(27)
	end
	helper_92829c19(2090765)
	if vm.skipping() then
		return skip(28)
	end
	event.CharaActive(1, 38)
	event.DelReference(37)
	event.SetReference(global0, "item", 37)
	event.CmrsSetPos(-665.1, 35.16, -841.27)
	event.CmrsSetRef(-637.33, 29.85, -838.63)
	event.ObjsSetPos(6, -644.57, 33.56, -840.23)
	event.ObjsSetRot(6, 0.0, -1.08, 0.0)
	event.StopBgm(0)
	event.SndSePlay(var0, 20)
	event.SndSePlay(var1, 0)
	event.ObjsSetMotion(6, "発動", 6)
	event.ObjsSetMotion(0, "ぶどう酒ゲット", 4, -1.0, 1)
	helper_8333218b(370, 1)
	if vm.skipping() then
		return skip(29)
	end
	event.CharaActive(0, 37)
	event.CharaActive(0, 38)
	event.PlayBgm(0)
	event.ObjsSetMotion(1, "小人見立ち", 4, -1.0, 1)
	event.CmrsSetPos(-609.41, 36.37, -779.33)
	event.CmrsSetRef(-630.67, 25.71, -807.05)
	event.ObjsSetMotion(0, "立ち", 4, -1.0, 1)
	event.ObjsSetMotion(4, "立ち", 4, -1.0, 1)
	event.ObjsSetMotion(0, "小人見会話", 6)
	event.ObjsNextMotion(0, "小人見立ち")
	event.SetPakuAnim(0, "通常口パク")
	helper_92829c19(2090770)
	if vm.skipping() then
		return skip(30)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(4, "会話", 6)
	event.ObjsNextMotion(4, "立ち")
	helper_92829c19(2090780)
	if vm.skipping() then
		return skip(31)
	end
	event.FadeOutBgm(30)
	event.SetFadeOut(30)
	helper_b0211f82(30)
	if vm.skipping() then
		return skip(32)
	end
	return part2()
end

--- Helper function.
local function helper_36cd4()
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesWindowMode(0, 7)
	event.AssignStack(5)
	event.ClearStack(5)
	event.ChangeDir("event/e200/e207/")
	event.LoadChara(5, "e207_starbre.gltf", "info", 34)
	event.EohSyncChara(2, 34)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.CharaActive(1, 34)
	event.LoadChara(5, "e207_vorneo.gltf", "info", 35)
	event.EohSyncChara(3, 35)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.CharaActive(1, 35)
	event.EohSyncObj(5, "p01_train01")
	event.ObjsInit(5)
	event.ObjsSyncObj(5, 5)
	event.ChangeDir("")
	event.LoadChara(5, "event/e200/e280/e280_tom.gltf", "info", 36)
	event.EohSyncChara(4, 36)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.CharaActive(1, 36)
	event.EohSyncObj(6, "p01_s0201", "s0208-m0")
	event.EohSetShow(6, 0)
	event.EohSyncObj(7, "p01_s0201", "s0208-m1")
	event.EohSetShow(7, 0)
	event.EohSyncObj(8, "p01_s0201", "s0208-m2")
	event.EohSetShow(8, 0)
	event.EohSyncObj(9, "p01_s0201", "s0208-m3")
	event.EohSetShow(9, 0)
	event.EohSyncObj(10, "p01_s0201", "s0213-m0")
	event.EohSetShow(10, 0)
	event.CharaActive(0, 8)
	event.CharaActive(0, 9)
	event.CharaActive(0, 10)
	event.LoadMes(0, 5, "event/e200/e280/e280c_1.txt")
end

--- Helper function.
local function helper_369b4()
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.CharaActive(1, 0)
	event.SetCharaPos(0, -687.4, 0.0, -77.8)
	event.SetCharaRot(0, 0.0, 1.62, 0.0)
	event.DeleteChara(34)
	event.DeleteChara(36)
	event.DeleteChara(35)
	event.EohSetShow(6, 1)
	event.EohSetShow(7, 1)
	event.EohSetShow(8, 1)
	event.EohSetShow(9, 1)
	event.EohSetShow(10, 1)
	event.CharaActive(1, 8)
	event.CharaActive(1, 9)
	event.CharaActive(1, 10)
end

--- Helper function.
local function helper_37550()
	local time: f32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 7 then
			if at <= 1 then
				helper_36cd4()
				helper_e20fd550(2800410, 210)
			end
			if at <= 2 then
				helper_126faf7c(2)
			end
			if at <= 3 then
				helper_e20fd550(2800420, -1)
			end
			if at <= 4 then
				helper_5fe8f3bb()
			end
			if at <= 5 then
				helper_b0211f82(60)
			end
			if at <= 6 then
				helper_b0211f82(30)
			end
			if vm.skip_end() then
				return skip(8)
			end
			return part2()
		end
		helper_369b4()
	end
	function part2()
		event.CancelDramaScene()
		event.StopBgm(0)
		helper_369b4()
		event.SetTime(time)
		event.ResetCamera(0)
		event.SetFadeIn(30)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFlag(280, 1)
	event.Initialize()
	helper_36cd4()
	event.InitDramaScene()
	time = event.GetTime() or time
	if time > 23.0 or time < 3.0 then
		event.SetTime(23.5)
	end
	event.CharaActive(0, 0)
	event.CmrsSetPos(-345.15, 101.35, 500.91)
	event.CmrsSetRef(-187.77, 66.45, 754.48)
	event.ObjsSetPos(5, 1.3, 8.0, 700.0)
	event.ObjsSetPos(2, -211.51, 0.0, 580.92)
	event.ObjsSetRot(2, 0.0, 0.12, 0.0)
	event.ObjsSetPos(3, -179.62, 0.0, 849.1)
	event.ObjsSetRot(3, 0.0, -3.04, 0.0)
	event.ObjsSetPos(4, -127.36, 0.0, 848.26)
	event.ObjsSetRot(4, 0.0, -2.88, 0.0)
	event.ObjsSetMotion(2, "歩き", 0)
	event.ObjsSetMotion(3, "会話2", 0)
	event.ObjsSetMotion(4, "喜び", 0)
	event.SetCrossfade(30)
	event.ObjsMove(2, -178.31, 0.0, 745.86, 240, 1)
	helper_e20fd550(2800410, 210)
	if vm.skipping() then
		return skip(2)
	end
	helper_126faf7c(2)
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsSetMotion(2, "立ち")
	event.SetCameraSpeed(0)
	event.CmrsMove2(-345.15, 101.35, 500.91, -393.5, 319.63, 632.81, 240, 0, 0.4)
	helper_e20fd550(2800420, -1)
	if vm.skipping() then
		return skip(4)
	end
	helper_5fe8f3bb()
	if vm.skipping() then
		return skip(5)
	end
	helper_b0211f82(60)
	if vm.skipping() then
		return skip(6)
	end
	event.FadeOutBgm(30)
	event.SetFadeOut(30)
	helper_b0211f82(30)
	if vm.skipping() then
		return skip(7)
	end
	return part2()
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 100.
-- Defined empty, so the engine runs this instead of its default.
script[100] = function() end

--- Program 501.
script[501] = function()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_07899991()
			helper_28e0c()
			if not vm.skipping() then
				return part2()
			end
		end
		if at <= 2 then
			helper_23c9fcd1()
		end
		if at <= 3 then
			helper_9adff316()
			helper_21731d04()
		end
	end
	function part2()
		event.SetNpcStatus(1, 128)
		event.SetNpcStatus(2, 128)
		event.SetNpcStatus(13, 128)
		event.SetSavedataEtc(0, 4)
		event.ExtTyped(1078, "ii", 1, 1)
		event.SetCharaChangeFlag(1, 1)
		event.SetCharaChangeMask(1, 1)
		event.AddItem(352, 5)
		helper_23c9fcd1()
		if vm.skipping() then
			return skip(3)
		end
		event.SetFadeIn(30)
		event.Initialize()
		helper_9adff316()
		helper_21731d04()
		if vm.wait() then
			return skip(4)
		end
		event.LoadScript("s02/s02_1.stb", -1)
	end
	event.Initialize()
	helper_b7f75ad1()
	if vm.skipping() then
		return skip(1)
	end
	helper_07899991()
	helper_28e0c()
	if vm.skipping() then
		return skip(2)
	end
	return part2()
end

--- Program 502.
script[502] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_23c9fcd1()
		end
		if at <= 2 then
			helper_d9487860()
			helper_9adff316()
		end
	end
	helper_3306c()
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	event.AddItem(370, 1)
	helper_23c9fcd1()
	if vm.skipping() then
		return skip(2)
	end
	event.SetFadeIn(30)
	event.EohSyncObj(0, "p09_s0201")
	event.EohSetShow(0, 0)
	helper_d9487860()
	helper_9adff316()
	if vm.wait() then
		return skip(3)
	end
	event.LoadScript("s02/s02_1.stb", -1)
end

--- Program 503.
script[503] = function()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_07899991()
			helper_37550()
			if not vm.skipping() then
				return part2()
			end
		end
		if at <= 2 then
			helper_9adff316()
			helper_21731d04()
		end
	end
	function part2()
		event.Initialize()
		helper_9adff316()
		helper_21731d04()
		if vm.wait() then
			return skip(3)
		end
		event.LoadScript("s02/s02_1.stb", 504)
	end
	event.Initialize()
	helper_b7f75ad1()
	if vm.skipping() then
		return skip(1)
	end
	helper_07899991()
	helper_37550()
	if vm.skipping() then
		return skip(2)
	end
	return part2()
end

return script
