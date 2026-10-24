--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_c758eb34 = require("@lib/event/helper_c758eb34")
local helper_e2d04ed9 = require("@lib/event/helper_e2d04ed9")
local helper_ed0a80b8 = require("@lib/event/helper_ed0a80b8")
local helper_f9fe2856 = require("@lib/event/helper_f9fe2856")

--- Helper function.
local function helper_06417ab7()
	local var0: s32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 27 then
			if at <= 1 then
				helper_e2d04ed9(0)
			end
			if at <= 2 then
				helper_ed0a80b8(10)
			end
			if at <= 3 then
				helper_ed0a80b8(12)
			end
			if at <= 4 then
				helper_e2d04ed9(0)
			end
			if at <= 5 then
				helper_ed0a80b8(10)
			end
			if at <= 6 then
				helper_ed0a80b8(40)
			end
			if at <= 7 then
				helper_ed0a80b8(30)
			end
			if at <= 8 then
				helper_ed0a80b8(40)
			end
			if at <= 9 then
				helper_f9fe2856()
			end
			if at <= 10 then
				helper_e2d04ed9(2)
			end
			if at <= 11 then
				helper_ed0a80b8(30)
			end
			if at <= 12 then
				helper_c758eb34(1)
			end
			if at <= 13 then
				helper_f9fe2856()
			end
			if at <= 14 then
				helper_e2d04ed9(2)
			end
			if at <= 15 then
				helper_ed0a80b8(10)
			end
			if at <= 16 then
				helper_ed0a80b8(30)
			end
			if at <= 17 then
				helper_ed0a80b8(30)
			end
			if at <= 18 then
				helper_ed0a80b8(30)
			end
			if at <= 19 then
				var1 = 1.0
				var2 = vm.f32(0.01)
				var3 = vm.f32(-0.002)
				var4 = 0
				var1 = vm.f32(var1 + var2)
				var2 = vm.f32(var2 + var3)
				var4 = var4 + 1
			end
			if at <= 20 then
				helper_ed0a80b8(30)
			end
			if at <= 21 then
				helper_f9fe2856()
			end
			if at <= 22 then
				helper_ed0a80b8(20)
			end
			if at <= 23 then
				helper_e2d04ed9(1)
			end
			if at <= 24 then
				helper_ed0a80b8(40)
			end
			if at <= 25 then
				helper_ed0a80b8(90)
			end
			if at <= 26 then
				helper_ed0a80b8(30)
			end
			if vm.skip_end() then
				return skip(28)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SetStatus(1, 0, 256, 0)
		event.EohSetTexAnim(0, 0)
		event.EohSetTexAnim(0, 1, "通常目パチ")
		event.EohSetFootSoundId(0, 0)
		event.EohSetShow(5, 1)
		event.EohSetShow(6, 1)
		event.SndSeStop(var0, 14)
		event.SndSeStop(var0, 15)
		event.SndSeStop(var0, 16)
		event.SndSeStop(var0, 17)
		event.SndSeStop(var0, 18)
		event.SndSeStop(var0, 19)
		event.SndSeStop(var0, 20)
		event.DelExtMotion(0)
		event.DeleteChara(18)
		event.DeleteChara(9)
		event.DeleteChara(11)
		event.DeleteChara(12)
		event.DeleteChara(13)
		event.LoadMes(0, -1)
		event.SetStatusbarShow(1, 1.0)
		event.Finish()
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.SetStatusbarShow(0, 1.0)
	event.StopBgm(0)
	var0 = event.SndLoadSound(802) or var0
	event.SetStatus(1, 0, 256, 1)
	event.AssignStack(5)
	event.ClearStack(5)
	event.ChangeDir("event/e00/e50/")
	event.LoadMes(0, 5, "e50_1.txt")
	event.LoadMotion(5, "e50_monica.gltf", "info", 0)
	event.LoadMotion(5, "e50_monica2.gltf", "info", 0)
	event.CharaActive(0)
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.LoadChara(5, "e50_guiltoni.gltf", "info", 18)
	event.CharaActive(18)
	event.EohSyncChara(2, 18)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.LoadChara(5, "e50_timegate_f.gltf", "info", 11)
	event.CharaActive(0, 11)
	event.LoadChara(5, "e50_ou.gltf", "info", 13)
	event.CharaActive(1, 13)
	event.ChangeDir("")
	event.LoadChara(5, "event/time_gate/blue/tg_maru_blue.gltf", "info", 9)
	event.CharaActive(0, 9)
	event.EohSyncChara(7, 9)
	event.ObjsInit(5)
	event.ObjsSyncObj(5, 7)
	event.LoadEquip(5, 1, 0, "info", 0, 12)
	event.CharaActive(12)
	event.EohSyncChara(1, 12)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.EohSyncChara(5, 1)
	event.EohSyncChara(6, 2)
	event.EohSyncObj(3, "p10_s5102-0")
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.EohSyncObj(4, "p10_s5102-1")
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.EohSetShow(5, 0)
	event.EohSetShow(6, 0)
	event.EohSetPos(0, -494.38, -0.17, 247.95)
	event.EohSetRot(0, 0.0, 2.01, 0.0)
	event.EohSetMotion(0, "走り", 4)
	event.EohSetFootSoundId(0, 21)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おこり顔")
	event.ObjsTexAnime(0, 1, "おこり目パチ")
	event.EohSetPos(2, 0.0, 0.0, -250.0)
	event.EohSetRot(2, 0.0, 3.14, 0.0)
	event.EohSetSoundId(2, var0)
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "わらい顔")
	event.ObjsTexAnime(2, 1, "通常目パチ")
	event.EohSetRot(3, 0.0, -0.2, 0.0)
	event.EohSetRot(4, 0.0, 0.2, 0.0)
	event.EohSetPos(7, 0.0, 30.0, -300.0)
	event.SetCharaPos(11, 0.0, 30.0, -300.0)
	event.SetCharaPos(13, 18.0, 0.0, -220.0)
	event.SetCharaRot(13, 0.0, -1.57, 0.0)
	event.SetMotion(13, "倒れ", 4)
	event.InitDramaScene()
	event.ObjsMove(0, -368.53, -0.17, 185.7, 50)
	event.CmrsInit()
	event.CmrsSetPos(-467.79, 15.29, 271.35)
	event.CmrsSetRef(-445.52, 25.45, 209.11)
	event.SetFadeIn(30)
	helper_e2d04ed9(0)
	if vm.skipping() then
		return skip(2)
	end
	event.CmrsSetPos(-134.51, 100.78, 136.35)
	event.CmrsSetRef(-54.64, 52.81, 37.61)
	event.ObjsSetPos(0, -117.35, -0.17, 66.54)
	event.ObjsMove(0, -9.29, -0.17, 0.77, 30)
	event.ObjsRotDelay(0, 22)
	event.ObjsRotation(0, 0.0, 0.12, 0.0, 8)
	event.ObjsMotionDelay(0, 28)
	event.ObjsSetMotion(0, "壁立ち")
	helper_ed0a80b8(10)
	if vm.skipping() then
		return skip(3)
	end
	event.EohSetFootSoundId(0, 2)
	helper_ed0a80b8(12)
	if vm.skipping() then
		return skip(4)
	end
	event.SndSePlay(var0, 14)
	helper_e2d04ed9(0)
	if vm.skipping() then
		return skip(5)
	end
	helper_ed0a80b8(10)
	if vm.skipping() then
		return skip(6)
	end
	event.ObjsSetMotion(0, "像見る", 2)
	event.ObjsNextMotion(0, "像見るL", 4)
	helper_ed0a80b8(40)
	if vm.skipping() then
		return skip(7)
	end
	event.EohSetFootSoundId(0, 21)
	event.CmrsSetPos(-95.58, 18.43, -157.01)
	event.CmrsSetRef(0.23, 35.57, -22.29)
	event.SndSePlay(var0, 15)
	event.ObjsRotation(3, 0.0, -1.8, 0.0, 16)
	event.ObjsRotation2(3, 0.0, -1.7, 0.0, 20, 2, 1.0)
	event.ObjsRotation(4, 0.0, 1.8, 0.0, 16)
	event.ObjsRotation2(4, 0.0, 1.7, 0.0, 20, 2, 1.0)
	event.ObjsSetPos(0, 0.0, -0.17, 0.0)
	event.ObjsSetRot(0, 0.0, 3.14, 0.0)
	event.ObjsSetMotion(0, "あたりドア開け", 6)
	event.ObjsNextMotion(0, "構え", 4)
	helper_ed0a80b8(30)
	if vm.skipping() then
		return skip(8)
	end
	event.CmrsSetPos(-12.11, 17.82, -20.43)
	event.CmrsSetRef(1.71, 21.68, 0.96)
	event.SndSePlay(var0, 16)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おこり顔")
	event.ObjsTexAnime(0, 1, "おこり目～おどろき目")
	event.ObjsTexAnime(0, 1, "口とじ～大口")
	event.ObjsSetMotion(0, "ショック", 6)
	event.ObjsNextMotion(0, "ショックL", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_ed0a80b8(40)
	if vm.skipping() then
		return skip(9)
	end
	event.CmrsSetPos(0.0, 20.0, -80.0)
	event.CmrsSetRef(0.0, 20.0, -160.0)
	event.CmrsMove(0.0, 20.0, -120.0, 0.0, 20.0, -200.0, 120.0)
	helper_f9fe2856()
	if vm.skipping() then
		return skip(10)
	end
	event.SetCrossfade(40)
	event.CmrsSetPos(0.0, 30.0, -210.0)
	event.CmrsSetRef(0.0, 30.0, -245.0)
	event.CmrsMoveAhd2(-1.2, 0.0, 35.0, 90, 0, 1.0)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "ショック顔")
	event.ObjsTexAnime(0, 1, "ショック目パチ")
	event.ObjsSetMotion(0, "立ちN", 4, -1.0, 1)
	event.SndSePlay(var0, 17)
	event.ObjsSetMotion(2, "振り返り", 6)
	event.ObjsNextMotion(2, "振り返りL", 4)
	helper_e2d04ed9(2)
	if vm.skipping() then
		return skip(11)
	end
	event.StreamOpen3(1, 500050)
	helper_ed0a80b8(30)
	if vm.skipping() then
		return skip(12)
	end
	helper_c758eb34(1)
	if vm.skipping() then
		return skip(13)
	end
	event.StreamPlay(1)
	helper_f9fe2856()
	if vm.skipping() then
		return skip(14)
	end
	event.CmrsSetPos(0.0, 30.0, -210.0)
	event.CmrsSetRef(0.0, 30.0, -290.0)
	event.CmrsMove2(0.0, 20.0, -160.0, 0.0, 20.0, -280.0, 120, 0, 0.4)
	event.SndSePlay(var0, 18)
	event.ObjsSetMotion(2, "振り返り戻り", 6)
	event.ObjsNextMotion(2, "立ち", 4)
	helper_e2d04ed9(2)
	if vm.skipping() then
		return skip(15)
	end
	event.SndSePlay(var0, 19)
	event.CharaActive(1, 11)
	event.SetMotion(11, "発生", 6)
	helper_ed0a80b8(10)
	if vm.skipping() then
		return skip(16)
	end
	event.CharaActive(1, 9)
	event.SetCharaShow(9, 1, 1, 0.1)
	helper_ed0a80b8(30)
	if vm.skipping() then
		return skip(17)
	end
	event.ObjsSetMotion(2, "歩き")
	event.ObjsMove(2, 0.0, 0.0, -300.0, 60)
	helper_ed0a80b8(30)
	if vm.skipping() then
		return skip(18)
	end
	event.SetCharaShow(18, 0, 1, 0.033333335)
	helper_ed0a80b8(30)
	if vm.skipping() then
		return skip(19)
	end
	event.SetCharaShow(9, 0, 1, 0.05)
	var1 = 1.0
	var2 = vm.f32(0.01)
	var3 = vm.f32(-0.002)
	var4 = 0
	while var4 < 20 do
		var1 = vm.f32(var1 + var2)
		var2 = vm.f32(var2 + var3)
		event.SetScale(9, var1, var1, var1)
		var4 = var4 + 1
		if vm.wait() then
			return skip(20)
		end
	end
	helper_ed0a80b8(30)
	if vm.skipping() then
		return skip(21)
	end
	event.StreamClose(1)
	event.CmrsSetPos(0.0, 23.0, -34.0)
	event.CmrsSetRef(0.0, 23.0, 0.0)
	event.CmrsMove2(0.0, 23.0, -24.0, 0.0, 23.0, 0.0, 60, 2, 1.0)
	helper_f9fe2856()
	if vm.skipping() then
		return skip(22)
	end
	helper_ed0a80b8(20)
	if vm.skipping() then
		return skip(23)
	end
	event.CmrsSetPos(0.0, 23.0, -297.58)
	event.CmrsSetRef(0.0, 23.0, -273.58)
	event.SndSePlay(var0, 20)
	event.DelReference(12)
	event.ObjsSetPos(1, 10.0, 8.0, 0.0)
	event.ObjsSetRot(1, 0.4, 2.88, 0.0)
	event.ObjsMove(1, 10.0, 1.0, 0.0, 10)
	event.ObjsRotation(1, 0.0, 2.88, 0.0, 8)
	event.ObjsRotation(1, 0.0, 2.88, 0.3, 6)
	event.ObjsRotation(1, 0.0, 2.88, -0.2, 4)
	event.ObjsRotation(1, 0.0, 2.88, 0.1, 3)
	event.ObjsRotation(1, 0.0, 2.88, -0.05, 2)
	event.ObjsRotation(1, 0.0, 2.88, 0.0, 2)
	helper_e2d04ed9(1)
	if vm.skipping() then
		return skip(24)
	end
	helper_ed0a80b8(40)
	if vm.skipping() then
		return skip(25)
	end
	event.ObjsSetMotion(0, "ヨロあるき")
	event.ObjsChengeStep(0, 0.05)
	event.ObjsMove(0, 0.0, -0.17, -80.0, 120)
	helper_ed0a80b8(90)
	if vm.skipping() then
		return skip(26)
	end
	event.SetFadeOut(30)
	helper_ed0a80b8(30)
	if vm.skipping() then
		return skip(27)
	end
	return part2()
end

return helper_06417ab7
