--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_4984e1c6 = require("@lib/event/helper_4984e1c6")
local helper_b5a6794c = require("@lib/event/helper_b5a6794c")
local helper_e2203e72 = require("@lib/event/helper_e2203e72")
local helper_e83cea40 = require("@lib/event/helper_e83cea40")

--- Helper function.
local function helper_6d9fdd0b()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local time: f32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 34 then
			if at <= 1 then
				helper_b5a6794c()
			end
			if at <= 2 then
				helper_e83cea40(2)
			end
			if at <= 3 then
				helper_4984e1c6(5400230)
			end
			if at <= 4 then
				helper_e83cea40(0)
			end
			if at <= 5 then
				helper_4984e1c6(5400240)
			end
			if at <= 6 then
				helper_4984e1c6(5400245)
			end
			if at <= 7 then
				helper_4984e1c6(5400250)
			end
			if at <= 8 then
				helper_e83cea40(2)
			end
			if at <= 9 then
				helper_4984e1c6(5400260)
			end
			if at <= 10 then
				helper_e83cea40(0)
			end
			if at <= 11 then
				helper_4984e1c6(5400270)
			end
			if at <= 12 then
				helper_e83cea40(2)
			end
			if at <= 13 then
				helper_4984e1c6(5400280)
			end
			if at <= 14 then
				helper_e83cea40(2)
			end
			if at <= 15 then
				helper_4984e1c6(5400290)
			end
			if at <= 16 then
				helper_4984e1c6(5400295)
			end
			if at <= 17 then
				helper_4984e1c6(5400300)
			end
			if at <= 18 then
				helper_4984e1c6(5400310)
			end
			if at <= 19 then
				helper_e83cea40(0)
			end
			if at <= 20 then
				helper_4984e1c6(5400315)
			end
			if at <= 21 then
				helper_4984e1c6(5400320)
			end
			if at <= 22 then
				helper_4984e1c6(5400330)
			end
			if at <= 23 then
				helper_4984e1c6(5400335)
			end
			if at <= 24 then
				helper_e83cea40(0)
			end
			if at <= 25 then
				helper_e83cea40(0)
			end
			if at <= 26 then
				helper_e2203e72(6)
			end
			if at <= 27 then
				helper_e2203e72(60)
			end
			if at <= 28 then
				helper_e2203e72(20)
			end
			if at <= 29 then
				helper_e2203e72(80)
			end
			if at <= 30 then
				helper_4984e1c6(5400340)
			end
			if at <= 31 then
				helper_4984e1c6(5400345)
			end
			if at <= 32 then
				helper_b5a6794c()
			end
			if at <= 33 then
				helper_e2203e72(30)
			end
			if vm.skip_end() then
				return skip(35)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.CharaActive(0)
		event.CharaActive(32)
		event.CharaActive(33)
		event.StopBgm(0)
		event.SetStatus(1, 0, 256, 0)
		event.EohSetFootSoundId(0, 0)
		event.DelExtMotion(0)
		event.DeleteChara(32)
		event.DeleteChara(33)
		event.DeleteChara(34)
		event.LoadMes(0, -1)
		event.SetTime(time)
		event.SetTimeStepEnable(1)
	end
	event.SetFlag(540, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.StopBgm(0)
	helper_e2203e72(4)
	if vm.skipping() then
		return skip(1)
	end
	event.LoadBgm(53)
	event.PlayBgm(0)
	event.LoadSound(5516)
	var0 = event.SndLoadSound(5516) or var0
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.SetStatus(1, 0, 256, 1)
	event.ChangeDir("event/e500/e540/")
	event.LoadMes(0, 5, "e540_1.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e540_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	else
		event.CharaActive(0, 0)
	end
	event.LoadChara(5, "e540_eina.gltf", "info", 34)
	event.CharaActive(34)
	event.EohSyncChara(2, 34)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.ChangeDir("")
	if active_chr_no == 1 then
		event.LoadChara(5, "chara/c01_base.gltf", "info", 32)
		event.LoadEquip(5, 0, 4, "info", 32)
		event.LoadEquip(5, 0, 3, "info", 32)
		event.LoadEquip(5, 0, 2, "info", 32, 33)
		event.LoadMotion(5, "event/e500/e540/e540_mints.gltf", "info", 32)
		event.EohSyncChara(0, 32)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(32)
		event.CharaActive(33)
	end
	event.EohSetPos(0, 8.0, 2721.0, -500.0)
	event.EohSetRot(0, 0.0, 3.14, 0.0)
	event.EohSetMotion(0, "立ち", 4)
	event.EohSetFootSoundId(0, 2)
	event.EohSetPos(2, -8.0, 2721.0, -500.0)
	event.EohSetRot(2, 0.0, 3.14, 0.0)
	event.EohSetMotion(2, "立ち", 4)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "うれし顔")
	event.EohSetTexAnim(0, 1, "うれし目パチ")
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "デフォルト顔")
	event.EohSetTexAnim(2, 1, "通常目パチ")
	time = event.GetTime() or time
	event.SetTime(21.5)
	event.SetTimeStepEnable(0)
	event.CmrsInit()
	event.CmrsSetPos(0.0, 2776.18, -303.79)
	event.CmrsSetRef(0.0, 2833.8, -501.13)
	event.CmrsMove2(0.0, 2734.28, -303.79, 0.0, 2760.06, -501.13, 120, 0, 1.0)
	event.InitDramaScene()
	event.SetFadeIn(30)
	helper_b5a6794c()
	if vm.skipping() then
		return skip(2)
	end
	event.ObjsSetMotion(2, "ユリス見る", 6)
	event.ObjsNextMotion(2, "ユリス見るL", 4)
	helper_e83cea40(2)
	if vm.skipping() then
		return skip(3)
	end
	helper_4984e1c6(5400230)
	if vm.skipping() then
		return skip(4)
	end
	event.ObjsSetMotion(0, "エイナ見る", 6)
	event.ObjsNextMotion(0, "エイナ見るL", 4)
	helper_e83cea40(0)
	if vm.skipping() then
		return skip(5)
	end
	helper_4984e1c6(5400240)
	if vm.skipping() then
		return skip(6)
	end
	helper_4984e1c6(5400245)
	if vm.skipping() then
		return skip(7)
	end
	event.ObjsSetMotion(2, "うつむく", 6)
	event.ObjsNextMotion(2, "うつむくL", 4)
	helper_4984e1c6(5400250)
	if vm.skipping() then
		return skip(8)
	end
	helper_e83cea40(2)
	if vm.skipping() then
		return skip(9)
	end
	event.ObjsSetMotion(0, "体ごと", 6)
	event.ObjsNextMotion(0, "体ごとL", 4)
	event.SetPakuAnim(0, "わらい口パク")
	helper_4984e1c6(5400260)
	if vm.skipping() then
		return skip(10)
	end
	helper_e83cea40(0)
	if vm.skipping() then
		return skip(11)
	end
	event.ObjsSetMotion(2, "ユリス見る2", 6)
	event.ObjsNextMotion(2, "ユリス見るL", 4)
	event.SetPakuAnim(2, "わらい口パク")
	helper_4984e1c6(5400270)
	if vm.skipping() then
		return skip(12)
	end
	helper_e83cea40(2)
	if vm.skipping() then
		return skip(13)
	end
	event.CmrsSetPos(-18.7, 2755.32, -500.47)
	event.CmrsSetRef(8.99, 2742.51, -500.09)
	event.CharaActive(0, 34)
	event.ObjsSetRot(0, 0.0, -1.57, 0.0)
	event.ObjsSetMotion(0, "エイナ見立ち2", 4, -1.0, 1)
	event.SetPakuAnim(0, "わらい口パク")
	helper_4984e1c6(5400280)
	if vm.skipping() then
		return skip(14)
	end
	event.CmrsSetPos(27.43, 2727.2, -460.74)
	event.CmrsSetRef(4.32, 2740.45, -499.18)
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "かなし顔")
	event.EohSetTexAnim(2, 1, "かなし目パチ")
	event.ObjsSetPos(0, 10.0, 2721.0, -500.0)
	event.ObjsSetMotion(0, "エイナ見立ち", 4, -1.0, 1)
	event.CharaActive(34)
	event.ObjsSetPos(2, 8.0, 2721.0, -500.0)
	event.ObjsSetRot(2, 0.0, -1.57, 0.0)
	event.ObjsSetMotion(2, "天を仰ぐ", 6)
	event.ObjsNextMotion(2, "天を仰ぐL", 4)
	event.ObjsMotionWait(2)
	helper_e83cea40(2)
	if vm.skipping() then
		return skip(15)
	end
	event.ObjsSetMotion(0, "わかって、ユリス", 6)
	event.ObjsNextMotion(0, "立ち", 4)
	event.ObjsSetMotion(2, "わかって、ユリス", 6)
	event.ObjsNextMotion(2, "わかって、ユリスL", 4)
	event.SetPakuAnim(2, "通常口パク")
	helper_4984e1c6(5400290)
	if vm.skipping() then
		return skip(16)
	end
	event.SetPakuAnim(2, "通常口パク")
	helper_4984e1c6(5400295)
	if vm.skipping() then
		return skip(17)
	end
	event.ObjsSetMotion(2, "うつむく2", 6)
	event.ObjsNextMotion(2, "うつむく2L", 4)
	event.SetPakuAnim(2, "通常口パク")
	helper_4984e1c6(5400300)
	if vm.skipping() then
		return skip(18)
	end
	event.CmrsSetPos(-72.3, 2778.58, -418.63)
	event.CmrsSetRef(3.04, 2732.45, -500.46)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "こまり顔")
	event.EohSetTexAnim(0, 1, "こまり目パチ")
	event.ObjsSetMotion(0, "勝手だよ！！", 6)
	event.ObjsNextMotion(0, "勝手だよ！！L", 4)
	event.ObjsSetMotion(2, "うつむく2戻り", 6)
	event.ObjsNextMotion(2, "立ち3", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_4984e1c6(5400310)
	if vm.skipping() then
		return skip(19)
	end
	helper_e83cea40(0)
	if vm.skipping() then
		return skip(20)
	end
	event.SetPakuAnim(0, "通常口パク")
	helper_4984e1c6(5400315)
	if vm.skipping() then
		return skip(21)
	end
	event.SetPakuAnim(2, "通常口パク")
	helper_4984e1c6(5400320)
	if vm.skipping() then
		return skip(22)
	end
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "こまり顔")
	event.EohSetTexAnim(0, 1, "こまり目～泣き目")
	event.ObjsTexaDelay(0, 30)
	event.ObjsTexAnime(0, 1, "泣き目パチ")
	event.ObjsSetMotion(0, "うつむく", 6)
	event.ObjsNextMotion(0, "うつむくL", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_4984e1c6(5400330)
	if vm.skipping() then
		return skip(23)
	end
	event.SetPakuAnim(0, "通常口パク")
	helper_4984e1c6(5400335)
	if vm.skipping() then
		return skip(24)
	end
	helper_e83cea40(0)
	if vm.skipping() then
		return skip(25)
	end
	event.ObjsMotionWait(0)
	helper_e83cea40(0)
	if vm.skipping() then
		return skip(26)
	end
	helper_e2203e72(6)
	if vm.skipping() then
		return skip(27)
	end
	event.SndSePlay(var0, 8)
	event.ObjsSetMotion(0, "走り")
	event.ObjsMotionDelay(0, 60)
	event.ObjsSetMotion(0, "立ち")
	event.ObjsMove(0, -15.0, 2721.0, -423.71, 30)
	event.ObjsMove(0, -15.0, 2200.0, -423.71, 30)
	event.ObjsRotation(0, 0.0, -0.25, 0, 8)
	event.ObjsSetMotion(2, "右向く", 6)
	event.ObjsNextMotion(2, "右向くL", 4)
	helper_e2203e72(60)
	if vm.skipping() then
		return skip(28)
	end
	event.SndSePlay(var0, 9)
	helper_e2203e72(20)
	if vm.skipping() then
		return skip(29)
	end
	event.ObjsSetMotion(0, "走り")
	event.ObjsMotionDelay(0, 40)
	event.ObjsSetMotion(0, "立ち")
	event.ObjsMove(0, -15.0, 1700.0, -423.71, 40)
	helper_e2203e72(80)
	if vm.skipping() then
		return skip(30)
	end
	event.CmrsSetPos(0.0, 2745.96, -460.49)
	event.CmrsSetRef(0.0, 2745.96, -498.07)
	event.CmrsMove2(0.0, 2745.96, -471.49, 0.0, 2745.96, -498.07, 160, 2, 1.0)
	event.ObjsSetPos(2, 0.0, 2721.0, -500.0)
	event.ObjsSetRot(2, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(2, "うつむく3", 6)
	event.ObjsNextMotion(2, "うつむくL", 4)
	event.SetPakuAnim(2, "通常口パク")
	helper_4984e1c6(5400340)
	if vm.skipping() then
		return skip(31)
	end
	event.ObjsSetMotion(2, "うつむく会話", 2)
	event.ObjsNextMotion(2, "うつむくL", 4)
	event.SetPakuAnim(2, "通常口パク")
	helper_4984e1c6(5400345)
	if vm.skipping() then
		return skip(32)
	end
	helper_b5a6794c()
	if vm.skipping() then
		return skip(33)
	end
	event.FadeOutBgm(30)
	event.SetFadeOut(30)
	helper_e2203e72(30)
	if vm.skipping() then
		return skip(34)
	end
	return part2()
end

return helper_6d9fdd0b
