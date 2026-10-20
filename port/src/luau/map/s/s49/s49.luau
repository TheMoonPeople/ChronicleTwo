--!strict
-- map/s/s49/s49.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_572c09a2 = require("@lib/event/helper_572c09a2")
local helper_75322a53 = require("@lib/event/helper_75322a53")
local helper_781c97dd = require("@lib/event/helper_781c97dd")
local helper_d76d5fd4 = require("@lib/event/helper_d76d5fd4")
local helper_f2cfa5bf = require("@lib/event/helper_f2cfa5bf")
local helper_f3577a67 = require("@lib/event/helper_f3577a67")
local helper_f4a2e06c = require("@lib/event/helper_f4a2e06c")

--- Helper function.
local function helper_b8bc()
	local time: f32 = 0
	local var1: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 31 then
			if at <= 1 then
				helper_f3577a67(30)
			end
			if at <= 2 then
				helper_f2cfa5bf(5320280)
			end
			if at <= 3 then
				helper_f2cfa5bf(5320290)
			end
			if at <= 4 then
				helper_75322a53(0)
			end
			if at <= 5 then
				helper_f2cfa5bf(5320295)
			end
			if at <= 6 then
				helper_75322a53(0)
			end
			if at <= 7 then
				helper_f2cfa5bf(5320300)
			end
			if at <= 8 then
				helper_f2cfa5bf(5320305)
			end
			if at <= 9 then
				helper_f2cfa5bf(5320310)
			end
			if at <= 10 then
				helper_75322a53(1)
			end
			if at <= 11 then
				helper_f2cfa5bf(5320315)
			end
			if at <= 12 then
				helper_75322a53(1)
			end
			if at <= 13 then
				helper_f2cfa5bf(5320320)
			end
			if at <= 14 then
				helper_75322a53(1)
			end
			if at <= 15 then
				helper_f2cfa5bf(5320323)
			end
			if at <= 16 then
				helper_f2cfa5bf(5320325)
			end
			if at <= 17 then
				helper_75322a53(1)
			end
			if at <= 18 then
				helper_f2cfa5bf(5320330)
			end
			if at <= 19 then
				helper_f2cfa5bf(5320335)
			end
			if at <= 20 then
				helper_f2cfa5bf(5320340)
			end
			if at <= 21 then
				helper_f2cfa5bf(5320345)
			end
			if at <= 22 then
				helper_75322a53(0)
			end
			if at <= 23 then
				helper_f2cfa5bf(5320350)
			end
			if at <= 24 then
				helper_f2cfa5bf(5320360)
			end
			if at <= 25 then
				helper_75322a53(1)
			end
			if at <= 26 then
				helper_f2cfa5bf(5320370)
			end
			if at <= 27 then
				helper_75322a53(0)
			end
			if at <= 28 then
				helper_f2cfa5bf(5320375)
			end
			if vm.skip_end() then
				return skip(32)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SetCrossfade(60)
		event.SetTime(time)
		event.SetTimeStepEnable(1)
		event.DeleteChara(8)
		event.DeleteChara(9)
		event.DeleteChara(10)
		event.LoadMes(0, -1)
		event.CmrsInit()
		event.SetStatusbarShow(1, 1.0)
		event.CharaActive(0)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFlag(532, 1)
	time = event.GetTime() or time
	event.SetTime(12.0)
	event.SetTimeStepEnable(0)
	event.LoadSound(5821)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.SetStatusbarShow(0, 1.0)
	event.AssignStack(5)
	event.ClearStack(5)
	event.LoadSound(5821)
	var1 = event.SndLoadSound(5821) or var1
	event.CharaActive(0, 0)
	event.ChangeDir("event/e500/e532/")
	event.LoadMes(0, 5, "e532.txt")
	event.LoadChara(5, "e532_y_guil.gltf", "info", 8)
	event.CharaActive(8)
	event.EohSyncChara(0, 8)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.LoadChara(5, "e532_haha.gltf", "info", 9)
	event.CharaActive(9)
	event.EohSyncChara(1, 9)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.LoadChara(5, "e532_bed.gltf", "info", 10)
	event.CharaActive(10)
	event.EohSyncChara(2, 10)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.SetReference(10, "haha", 9)
	event.ChangeDir("")
	event.EohSetPos(0, 70.0, 0.0, 10.0)
	event.EohSetRot(0, 0.0, 0.0, 0.0)
	event.EohSetMotion(0, "寝てる", 4)
	event.EohNormalDrive(0)
	event.EohResetDaPosition(0)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "泣き顔")
	event.EohSetTexAnim(0, 1, "泣き目パチ")
	event.EohSetPos(1, 0.0, 0.0, 0.0)
	event.EohSetRot(1, 0.0, 0.0, 0.0)
	event.EohSetMotion(1, "寝てる", 4)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "わらい顔")
	event.EohSetTexAnim(1, 1, "くるし目パチ")
	event.EohSetPos(2, 70.0, 0.0, 10.0)
	event.EohSetRot(2, 0.0, 0.0, 0.0)
	event.EohSetMotion(2, "寝てる", 4)
	event.InitDramaScene()
	event.CmrsInit()
	event.CmrsSetPos(39.84, 60.52, -60.15)
	event.CmrsSetRef(66.03, 22.1, 15.31)
	helper_f3577a67(30)
	if vm.skipping() then
		return skip(2)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_f2cfa5bf(5320280)
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsSetMotion(0, "寝てる会話", 2)
	event.ObjsNextMotion(0, "寝てる", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_f2cfa5bf(5320290)
	if vm.skipping() then
		return skip(4)
	end
	helper_75322a53(0)
	if vm.skipping() then
		return skip(5)
	end
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "泣き顔")
	event.EohSetTexAnim(0, 1, "目あき～目とじ")
	event.ObjsSetMotion(0, "首ふる", 2)
	event.ObjsNextMotion(0, "寝てる", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_f2cfa5bf(5320295)
	if vm.skipping() then
		return skip(6)
	end
	helper_75322a53(0)
	if vm.skipping() then
		return skip(7)
	end
	event.CmrsSetPos(44.6, 20.65, 33.29)
	event.CmrsSetRef(64.25, 16.57, 22.61)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "泣き顔")
	event.EohSetTexAnim(0, 1, "泣き目パチ")
	event.ObjsMotionDelay(1, 60)
	event.ObjsSetMotion(1, "苦しい", 2)
	event.ObjsNextMotion(1, "寝てる", 4)
	event.ObjsTexaDelay(1, 60)
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "わらい顔")
	event.ObjsTexAnime(1, 1, "くるし目パチ２")
	event.ObjsTexaDelay(1, 60)
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "わらい顔")
	event.ObjsTexAnime(1, 1, "くるし目パチ")
	event.ObjsMotionDelay(2, 60)
	event.ObjsSetMotion(2, "苦しい", 2)
	event.ObjsNextMotion(2, "寝てる", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_f2cfa5bf(5320300)
	if vm.skipping() then
		return skip(8)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_f2cfa5bf(5320305)
	if vm.skipping() then
		return skip(9)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_f2cfa5bf(5320310)
	if vm.skipping() then
		return skip(10)
	end
	helper_75322a53(1)
	if vm.skipping() then
		return skip(11)
	end
	event.ObjsMotionDelay(1, 40)
	event.ObjsSetMotion(1, "苦しい", 2)
	event.ObjsNextMotion(1, "寝てる", 4)
	event.ObjsTexaDelay(1, 60)
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "わらい顔")
	event.ObjsTexAnime(1, 1, "くるし目パチ２")
	event.ObjsTexaDelay(1, 60)
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "わらい顔")
	event.ObjsTexAnime(1, 1, "くるし目パチ")
	event.ObjsMotionDelay(2, 40)
	event.ObjsSetMotion(2, "苦しい", 2)
	event.ObjsNextMotion(2, "寝てる", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_f2cfa5bf(5320315)
	if vm.skipping() then
		return skip(12)
	end
	helper_75322a53(1)
	if vm.skipping() then
		return skip(13)
	end
	event.ObjsSetMotion(1, "上向く", 2)
	event.ObjsNextMotion(1, "上向くL", 4)
	event.ObjsSetMotion(2, "上向く", 2)
	event.ObjsNextMotion(2, "上向くL", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_f2cfa5bf(5320320)
	if vm.skipping() then
		return skip(14)
	end
	helper_75322a53(1)
	if vm.skipping() then
		return skip(15)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_f2cfa5bf(5320323)
	if vm.skipping() then
		return skip(16)
	end
	event.ObjsMotionDelay(1, 60)
	event.ObjsSetMotion(1, "上向く戻り", 2)
	event.ObjsNextMotion(1, "寝てる", 4)
	event.ObjsTexaDelay(1, 60)
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "わらい顔")
	event.ObjsTexAnime(1, 1, "前向き～左向き")
	event.ObjsTexAnime(1, 1, "前向き～左向き")
	event.ObjsMotionDelay(2, 60)
	event.ObjsSetMotion(2, "上向く戻り", 2)
	event.ObjsNextMotion(2, "寝てる", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_f2cfa5bf(5320325)
	if vm.skipping() then
		return skip(17)
	end
	helper_75322a53(1)
	if vm.skipping() then
		return skip(18)
	end
	event.CmrsSetPos(93.32, 20.1, 22.37)
	event.CmrsSetRef(63.34, 19.1, 24.49)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "わらい顔")
	event.EohSetTexAnim(1, 1, "くるし目パチ")
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "泣き顔")
	event.EohSetTexAnim(0, 1, "泣き目パチ")
	event.EohSetTexAnim(0, 1, "半口")
	event.SetPakuAnim(1, "通常口パク")
	helper_f2cfa5bf(5320330)
	if vm.skipping() then
		return skip(19)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_f2cfa5bf(5320335)
	if vm.skipping() then
		return skip(20)
	end
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "泣き顔")
	event.EohSetTexAnim(0, 1, "泣き目パチ")
	event.SetPakuAnim(0, "通常口パク")
	helper_f2cfa5bf(5320340)
	if vm.skipping() then
		return skip(21)
	end
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "泣き顔")
	event.EohSetTexAnim(0, 1, "目あき～目とじ")
	event.ObjsSetMotion(0, "首ふる", 2)
	event.ObjsNextMotion(0, "寝てる", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_f2cfa5bf(5320345)
	if vm.skipping() then
		return skip(22)
	end
	helper_75322a53(0)
	if vm.skipping() then
		return skip(23)
	end
	event.CmrsSetPos(44.6, 20.65, 33.29)
	event.CmrsSetRef(64.25, 16.57, 22.61)
	event.SetPakuAnim(1, "通常口パク")
	helper_f2cfa5bf(5320350)
	if vm.skipping() then
		return skip(24)
	end
	event.ObjsSetMotion(1, "死", 2)
	event.ObjsNextMotion(1, "死L", 4)
	event.ObjsTexaDelay(1, 60)
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "わらい顔")
	event.ObjsTexAnime(1, 1, "ゆっくり目とじ")
	event.ObjsSetMotion(2, "死", 2)
	event.ObjsNextMotion(2, "死L", 4)
	event.SetPakuAnim(1, "わらい口パク２")
	helper_f2cfa5bf(5320360)
	if vm.skipping() then
		return skip(25)
	end
	helper_75322a53(1)
	if vm.skipping() then
		return skip(26)
	end
	event.CmrsSetPos(93.32, 20.1, 22.37)
	event.CmrsSetRef(63.34, 19.1, 24.49)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "死に")
	event.SndSePlay(var1, 11)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "泣き顔")
	event.EohSetTexAnim(0, 1, "泣き目～おどろき目")
	event.ObjsSetMotion(0, "母さん！！", 6)
	event.ObjsNextMotion(0, "母さん！！L", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_f2cfa5bf(5320370)
	if vm.skipping() then
		return skip(27)
	end
	helper_75322a53(0)
	if vm.skipping() then
		return skip(28)
	end
	event.SndSePlay(var1, 12)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "泣き顔")
	event.EohSetTexAnim(0, 1, "おどろき目パチ")
	event.ObjsSetMotion(0, "目を開けて", 2)
	event.ObjsNextMotion(0, "目を開けてL", 4)
	event.ObjsSetMotion(1, "目を開けて", 2)
	event.ObjsNextMotion(1, "目を開けてL", 4)
	event.ObjsSetMotion(2, "目を開けて", 2)
	event.ObjsNextMotion(2, "目を開けてL", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_f2cfa5bf(5320375)
	if vm.skipping() then
		return skip(29)
	end
	if vm.wait() then
		return skip(30)
	end
	if vm.wait() then
		return skip(31)
	end
	return part2()
end

--- Helper function.
local function helper_e6dc()
	local var0: s32 = 0
	local var1: s32 = 0
	local var2: f32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 24 then
			if at <= 1 then
				helper_f3577a67(20)
			end
			if at <= 2 then
				helper_75322a53(0)
			end
			if at <= 3 then
				helper_f3577a67(12)
			end
			if at <= 4 then
				helper_f2cfa5bf(5360060)
			end
			if at <= 5 then
				helper_572c09a2()
			end
			if at <= 6 then
				helper_75322a53(0)
			end
			if at <= 7 then
				helper_f2cfa5bf(5360070)
			end
			if at <= 8 then
				helper_f2cfa5bf(5360075)
			end
			if at <= 9 then
				helper_f2cfa5bf(5360080)
			end
			if at <= 10 then
				helper_f4a2e06c(1)
			end
			if at <= 11 then
				helper_d76d5fd4(0, -1, 8, 0, 0)
				helper_f3577a67(30)
			end
			if at <= 12 then
				helper_f3577a67(80)
			end
			if at <= 13 then
				helper_781c97dd(0)
				helper_d76d5fd4(0, -1, 5, 0, 0)
				var1 = 0
				var2 = 0.0
				var2 = vm.f32(var2 + vm.f32(3.2))
				var1 = var1 + 1
			end
			if at <= 14 then
				helper_f3577a67(30)
			end
			if at <= 15 then
				var1 = 0
				var2 = 0.0
				var2 = vm.f32(var2 + vm.f32(4.266667))
				var1 = var1 + 1
			end
			if at <= 16 then
				helper_f3577a67(30)
			end
			if at <= 17 then
				var1 = 0
				var2 = 0.0
				var2 = vm.f32(var2 + vm.f32(4.266667))
				var1 = var1 + 1
			end
			if at <= 18 then
				helper_f3577a67(60)
			end
			if at <= 19 then
				helper_781c97dd(0)
				helper_f3577a67(30)
			end
			if at <= 20 then
				helper_f4a2e06c(1)
			end
			if at <= 21 then
				helper_d76d5fd4(0, -1, 5, 0, 0)
				var1 = 0
				var2 = 0.0
				var2 = vm.f32(var2 + vm.f32(1.4222223))
				var1 = var1 + 1
			end
			if at <= 22 then
				helper_f3577a67(60)
			end
			if at <= 23 then
				helper_f3577a67(30)
			end
			helper_781c97dd(0)
			if vm.skip_end() then
				return skip(25)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.StopBgm(0)
		event.SpriteSetDraw(0, 0)
		event.DeleteChara(8)
		event.DeleteChara(9)
		event.DeleteChara(10)
		event.DeleteChara(11)
		event.LoadMes(0, -1)
		event.CmrsInit()
		event.SetStatusbarShow(1, 1.0)
		event.CharaActive(0)
	end
	event.SetFlag(536, 1)
	event.LoadSound(5824)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.SetStatusbarShow(0, 1.0)
	event.AssignStack(5)
	event.ClearStack(5)
	event.StopBgm(0)
	helper_f3577a67(4)
	if vm.skipping() then
		return skip(1)
	end
	event.LoadBgm(112)
	event.PlayBgm(0)
	event.LoadSound(5824)
	var0 = event.SndLoadSound(5824) or var0
	event.CharaActive(0, 0)
	event.ChangeDir("event/e500/e536/")
	event.LoadMes(0, 5, "e536.txt")
	event.LoadChara(5, "e536_y_guil.gltf", "info", 8)
	event.CharaActive(8)
	event.EohSyncChara(0, 8)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.LoadChara(5, "e536_haha.gltf", "info", 9)
	event.CharaActive(9)
	event.EohSyncChara(1, 9)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.LoadChara(5, "e536_door.gltf", "info", 10)
	event.CharaActive(10)
	event.EohSyncChara(2, 10)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.LoadChara(5, "e536_chair.gltf", "info", 11)
	event.CharaActive(11)
	event.EohSyncChara(3, 11)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.ChangeDir("")
	event.SpriteInit(0)
	event.SpriteSetType(0, 0)
	event.SpriteSetPos(0, 256, 208)
	event.SpriteSetPutsize(0, 512, 416)
	event.SpriteSetColor(0, 255, 255, 255, 255)
	event.SpriteSetDraw(0, 0)
	event.EohSyncObj(4, "p01_s4901")
	event.EohSetShow(4, 0)
	event.EohSyncObj(5, "p08_ai02a")
	event.EohSetPos(5, 0.0, 0.0, 10.0)
	event.EohSyncObj(5, "p08_ai02a", "ai020801-m")
	event.EohSetShow(5, 0)
	event.SetStatus(1, 10, 64, 1)
	event.SetStatus(1, 11, 64, 1)
	event.EohSetPos(0, -33.0, 0.0, 71.0)
	event.EohSetRot(0, 0.0, 3.14, 0.0)
	event.EohSetMotion(0, "立ち", 4)
	event.EohNormalDrive(0)
	event.EohResetDaPosition(0)
	event.EohSetSoundId(0, var0)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "わらい顔")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	event.EohSetPos(1, 15.0, 0.0, -24.400002)
	event.EohSetRot(1, 0.0, -1.57, 0.0)
	event.EohSetMotion(1, "座り", 4)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "デフォルト顔")
	event.EohSetTexAnim(1, 1, "通常目パチ")
	event.EohSetPos(2, -33.0, 0.0, 71.0)
	event.EohSetRot(2, 0.0, 3.14, 0.0)
	event.EohSetPos(3, 10.0, 0.0, 4.0)
	event.EohSetRot(3, 0.0, -2.41, 0.0)
	event.InitDramaScene()
	event.SndSePlay(var0, 7)
	event.ObjsSetMotion(0, "ドア開け", 6)
	event.ObjsNextMotion(0, "ドア開けL", 4)
	event.ObjsSetMotion(2, "ドア開け", 6)
	event.ObjsNextMotion(2, "待機", 4)
	event.CmrsInit()
	event.CmrsSetPos(61.97, 46.56, -61.97)
	event.CmrsSetRef(15.12, 25.71, 12.05)
	event.CmrsMove2(61.97, 46.56, -61.97, -5.06, 25.71, -5.5, 60, 2, 1.0)
	event.SetFadeIn(30)
	helper_f3577a67(20)
	if vm.skipping() then
		return skip(2)
	end
	event.ObjsSetMotion(1, "左見る", 2)
	event.ObjsNextMotion(1, "左見るL", 4)
	helper_75322a53(0)
	if vm.skipping() then
		return skip(3)
	end
	helper_f3577a67(12)
	if vm.skipping() then
		return skip(4)
	end
	event.SndSePlay(var0, 8)
	event.SetPakuAnim(0, "わらい口パク")
	helper_f2cfa5bf(5360060)
	if vm.skipping() then
		return skip(5)
	end
	helper_572c09a2()
	if vm.skipping() then
		return skip(6)
	end
	event.CmrsSetPos(-34.76, 39.67, -42.6)
	event.CmrsSetRef(21.19, 24.21, -4.58)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "わらい顔")
	event.EohSetTexAnim(0, 1, "目あき～目とじ")
	event.SndSePlay(var0, 9)
	event.ObjsSetPos(0, 10.0, 0.0, 4.0)
	event.ObjsSetRot(0, 0.0, -2.41, 0.0)
	event.ObjsSetMotion(0, "座る", 6)
	event.ObjsNextMotion(0, "座るL", 4)
	helper_75322a53(0)
	if vm.skipping() then
		return skip(7)
	end
	event.ObjsSetMotion(0, "下向く", 2)
	event.ObjsNextMotion(0, "下向くL", 4)
	event.SetPakuAnim(0, "わらい口パク")
	helper_f2cfa5bf(5360070)
	if vm.skipping() then
		return skip(8)
	end
	event.SetPakuAnim(0, "わらい口パク")
	helper_f2cfa5bf(5360075)
	if vm.skipping() then
		return skip(9)
	end
	event.CmrsSetPos(34.3, 21.14, 15.6)
	event.CmrsSetRef(11.3, 24.63, -18.3)
	event.CmrsMove2(34.3, 21.14, 15.6, 3.12, 20.97, -11.09, 120, 2, 1.0)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "わらい顔")
	event.EohSetTexAnim(0, 1, "目とじ～目あき")
	event.ObjsSetMotion(0, "座り会話入り", 2)
	event.ObjsNextMotion(0, "座り会話", 4)
	event.ObjsTexaDelay(0, 20)
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.SetPakuAnim(0, "わらい口パク")
	helper_f2cfa5bf(5360080)
	if vm.skipping() then
		return skip(10)
	end
	event.StreamOpen3(1, 5360093)
	helper_f4a2e06c(1)
	if vm.skipping() then
		return skip(11)
	end
	event.StreamPlay(1)
	event.EohSetTexAnim(0, 1, "わらい口パク")
	event.MesMake_2(0, 5360085)
	helper_d76d5fd4(0, -1, 8, 0, 0)
	helper_f3577a67(30)
	if vm.skipping() then
		return skip(12)
	end
	event.SetFadeOut(80, 255, 255, 255)
	helper_f3577a67(80)
	if vm.skipping() then
		return skip(13)
	end
	helper_781c97dd(0)
	event.SetMesWindowMode(0, 11)
	event.SetMesOkuri(0, 0)
	event.SetFadeIn(0)
	event.SpriteSetDraw(0, 1)
	event.MesMake_2(0, 5360090)
	event.SetMesDrawspeed(0, 0)
	helper_d76d5fd4(0, -1, 5, 0, 0)
	var1 = 0
	var2 = 0.0
	while var1 < 40 do
		event.SetMesEtc(0, 6, 0, var2)
		event.SetMesEtc(0, 6, 1, 0)
		event.SetMesEtc(0, 6, 2, 0)
		var2 = vm.f32(var2 + vm.f32(3.2))
		var1 = var1 + 1
		if vm.wait() then
			return skip(14)
		end
	end
	helper_f3577a67(30)
	if vm.skipping() then
		return skip(15)
	end
	var1 = 0
	var2 = 0.0
	while var1 < 30 do
		event.SetMesEtc(0, 6, 0, 128)
		event.SetMesEtc(0, 6, 1, var2)
		event.SetMesEtc(0, 6, 2, 0)
		var2 = vm.f32(var2 + vm.f32(4.266667))
		var1 = var1 + 1
		if vm.wait() then
			return skip(16)
		end
	end
	helper_f3577a67(30)
	if vm.skipping() then
		return skip(17)
	end
	var1 = 0
	var2 = 0.0
	while var1 < 30 do
		event.SetMesEtc(0, 6, 0, 128)
		event.SetMesEtc(0, 6, 1, 128)
		event.SetMesEtc(0, 6, 2, var2)
		var2 = vm.f32(var2 + vm.f32(4.266667))
		var1 = var1 + 1
		if vm.wait() then
			return skip(18)
		end
	end
	helper_f3577a67(60)
	if vm.skipping() then
		return skip(19)
	end
	helper_781c97dd(0)
	event.StreamClose(1)
	helper_f3577a67(30)
	if vm.skipping() then
		return skip(20)
	end
	event.StreamOpen3(1, 5360095)
	helper_f4a2e06c(1)
	if vm.skipping() then
		return skip(21)
	end
	event.MesMake_2(0, 5360095)
	event.SetMesDrawspeed(0, 0)
	helper_d76d5fd4(0, -1, 5, 0, 0)
	var1 = 0
	var2 = 0.0
	while var1 < 90 do
		if var1 == 30 then
			event.StreamPlay(1)
		end
		event.SetMesEtc(0, 6, 0, var2)
		var2 = vm.f32(var2 + vm.f32(1.4222223))
		var1 = var1 + 1
		if vm.wait() then
			return skip(22)
		end
	end
	event.SetMesEtc(0, 6, 0, 128)
	helper_f3577a67(60)
	if vm.skipping() then
		return skip(23)
	end
	event.FadeOutBgm(30)
	event.SetFadeOut(30, 255, 255, 255)
	helper_f3577a67(30)
	if vm.skipping() then
		return skip(24)
	end
	helper_781c97dd(0)
	event.SetMesOkuri(0, 1)
	event.StreamClose(1)
	return part2()
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 100.
script[100] = function()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_b8bc()
			if not vm.skipping() then
				return part2()
			end
		end
	end
	function part2() end
	helper_f3577a67(30)
	if vm.skipping() then
		return skip(1)
	end
	helper_b8bc()
	if vm.skipping() then
		return skip(2)
	end
	return part2()
end

--- Program 150.
script[150] = function()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_b8bc()
			if not vm.skipping() then
				return part2()
			end
		end
	end
	function part2() end
	helper_f3577a67(30)
	if vm.skipping() then
		return skip(1)
	end
	helper_b8bc()
	if vm.skipping() then
		return skip(2)
	end
	return part2()
end

--- Program 500.
script[500] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_b8bc()
	if vm.skipping() then
		return skip(1)
	end
	event.BgmLoadCancel()
	event.LoadDungeonMapFile("d05b01")
	event.LoadScript("d05b01/d05b01.stb", 561)
end

--- Program 510.
script[510] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_e6dc()
	if vm.skipping() then
		return skip(1)
	end
	event.BgmLoadCancel()
	event.LoadDungeonMapFile("d05b01")
	event.LoadScript("d05b01/d05b01.stb", 571)
end

return script
