--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_23bda4ba = require("@lib/event/helper_23bda4ba")
local helper_261c70db = require("@lib/event/helper_261c70db")
local helper_366d50dc = require("@lib/event/helper_366d50dc")
local helper_3ea45d11 = require("@lib/event/helper_3ea45d11")
local helper_adea7ba0 = require("@lib/event/helper_adea7ba0")

--- Helper function.
local function helper_89ef6e20()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local time: f32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 26 then
			if at <= 1 then
				helper_adea7ba0(60)
			end
			if at <= 2 then
				helper_adea7ba0(60)
			end
			if at <= 3 then
				helper_adea7ba0(30)
			end
			if at <= 4 then
				helper_adea7ba0(30)
			end
			if at <= 5 then
				helper_3ea45d11(7440010, -1)
			end
			if at <= 6 then
				helper_adea7ba0(30)
			end
			if at <= 7 then
				helper_3ea45d11(7440020, -1)
			end
			if at <= 8 then
				helper_23bda4ba(2)
			end
			if at <= 9 then
				helper_23bda4ba(2)
			end
			if at <= 10 then
				helper_adea7ba0(90)
			end
			if at <= 11 then
				helper_3ea45d11(7440030, -1)
			end
			if at <= 12 then
				helper_23bda4ba(2)
			end
			if at <= 13 then
				helper_adea7ba0(60)
			end
			if at <= 14 then
				helper_261c70db()
			end
			if at <= 15 then
				helper_3ea45d11(7440040, -1)
			end
			if at <= 16 then
				helper_23bda4ba(3)
			end
			if at <= 17 then
				helper_adea7ba0(110)
			end
			if at <= 18 then
				helper_23bda4ba(3)
			end
			if at <= 19 then
				helper_3ea45d11(7440050, -1)
			end
			if at <= 20 then
				helper_adea7ba0(20)
			end
			if at <= 21 then
				helper_366d50dc(7440060, -1, 30)
			end
			if at <= 22 then
				helper_adea7ba0(20)
			end
			if at <= 23 then
				helper_3ea45d11(7440070, -1)
			end
			if at <= 24 then
				helper_366d50dc(7440080, -1, 0)
			end
			if at <= 25 then
				helper_adea7ba0(30)
			end
			if vm.skip_end() then
				return skip(27)
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
	helper_adea7ba0(4)
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
	event.LoadMes(0, 5, "e744_1.txt")
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
	helper_adea7ba0(60)
	if vm.skipping() then
		return skip(2)
	end
	event.ObjsSetMotion(3, "出る", 6)
	event.ObjsNextMotion(3, "出るL", 4)
	helper_adea7ba0(60)
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsSetMotion(3, "ひっこむ", 6)
	event.ObjsMotionDelay(3, 30)
	event.ObjsMove(3, 462.73, 8.92, 250.09, 30)
	event.ObjsNextMotion(3, "立ち")
	helper_adea7ba0(30)
	if vm.skipping() then
		return skip(4)
	end
	event.ObjsSetMotion(2, "歩き", 4)
	event.ObjsMove(2, 498.94, 0.0, 565.66, 120)
	event.ObjsMotionDelay(2, 120)
	event.ObjsNextMotion(2, "立ち")
	helper_adea7ba0(30)
	if vm.skipping() then
		return skip(5)
	end
	event.SetPakuAnim(2, "通常口パク")
	helper_3ea45d11(7440010, -1)
	if vm.skipping() then
		return skip(6)
	end
	helper_adea7ba0(30)
	if vm.skipping() then
		return skip(7)
	end
	helper_3ea45d11(7440020, -1)
	if vm.skipping() then
		return skip(8)
	end
	helper_23bda4ba(2)
	if vm.skipping() then
		return skip(9)
	end
	event.ObjsSetMotion(2, "キョロキョロ", 6)
	event.ObjsNextMotion(2, "立ち", 4)
	helper_23bda4ba(2)
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
	helper_adea7ba0(90)
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
	helper_3ea45d11(7440030, -1)
	if vm.skipping() then
		return skip(12)
	end
	helper_23bda4ba(2)
	if vm.skipping() then
		return skip(13)
	end
	helper_adea7ba0(60)
	if vm.skipping() then
		return skip(14)
	end
	event.CmrsSetPos(501.79, 21.5, 191.98)
	event.CmrsSetRef(467.04, 20.16, 252.42)
	event.ObjsSetMotion(3, "出るL", 4)
	event.CmrsMove(523.78, 21.5, 187.7, 532.68, 20.16, 258.41, 120)
	helper_261c70db()
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
	helper_3ea45d11(7440040, -1)
	if vm.skipping() then
		return skip(16)
	end
	helper_23bda4ba(3)
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
	helper_adea7ba0(110)
	if vm.skipping() then
		return skip(18)
	end
	helper_23bda4ba(3)
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
	helper_3ea45d11(7440050, -1)
	if vm.skipping() then
		return skip(20)
	end
	helper_adea7ba0(20)
	if vm.skipping() then
		return skip(21)
	end
	event.ObjsTexAnime(2, 1, "通常口パク")
	event.ObjsTexaDelay(2, 60)
	event.ObjsTexAnime(2, 0, "通常口パク")
	helper_366d50dc(7440060, -1, 30)
	if vm.skipping() then
		return skip(22)
	end
	helper_adea7ba0(20)
	if vm.skipping() then
		return skip(23)
	end
	event.ObjsTexAnime(3, 0)
	event.ObjsTexAnime(3, 1, "通常目～わらい目とじ")
	helper_3ea45d11(7440070, -1)
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
	event.CmrsMove2(1153.69, 563.36, 485.97, 496.65, 2.26, 199.32, 240, 1, 1.0)
	event.SetPakuAnim(2, "わらい口パク")
	helper_366d50dc(7440080, -1, 0)
	if vm.skipping() then
		return skip(25)
	end
	event.ResetPakuAnim()
	event.FadeOutBgm(30)
	event.SetFadeOut(30, 255, 255, 255)
	helper_adea7ba0(30)
	if vm.skipping() then
		return skip(26)
	end
	return part2()
end

return helper_89ef6e20
