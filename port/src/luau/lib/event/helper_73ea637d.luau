--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_100ac525 = require("@lib/event/helper_100ac525")
local helper_384c5eb1 = require("@lib/event/helper_384c5eb1")
local helper_99d125b7 = require("@lib/event/helper_99d125b7")

--- Helper function.
local function helper_73ea637d()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 17 then
			if at <= 1 then
				helper_100ac525(60)
			end
			if at <= 2 then
				helper_99d125b7(6120340, -1)
			end
			if at <= 3 then
				helper_384c5eb1(2)
			end
			if at <= 4 then
				helper_100ac525(30)
			end
			if at <= 5 then
				helper_99d125b7(6120350, -1)
			end
			if at <= 6 then
				helper_100ac525(30)
			end
			if at <= 7 then
				helper_99d125b7(6120360, -1)
			end
			if at <= 8 then
				helper_384c5eb1(2)
			end
			if at <= 9 then
				helper_99d125b7(6120365, -1)
			end
			if at <= 10 then
				helper_384c5eb1(2)
			end
			if at <= 11 then
				helper_100ac525(90)
			end
			if at <= 12 then
				helper_100ac525(90)
			end
			if at <= 13 then
				helper_99d125b7(6120370, 45)
			end
			if at <= 14 then
				helper_99d125b7(6120380, -1)
			end
			if at <= 15 then
				helper_100ac525(90)
			end
			if at <= 16 then
				helper_100ac525(30)
			end
			if vm.skip_end() then
				return skip(18)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.CmrsInit()
		event.BgmLoadCancel()
		event.SndSeStop(var0, 2)
		event.SndSeStop(var0, 3)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.DelExtMotion(0)
		event.DeleteChara(8)
		event.DeleteChara(9)
		event.DeleteChara(10)
		event.DeleteChara(13)
		event.LoadMes(0, -1)
		event.SetCharaShow(1, 1)
		event.SetCharaShow(2, 1)
		event.CharaActive(0)
		event.SetCharaPos(0, -1.02, 0.2, 111.04)
		event.SetCharaRot(0, 0.0, 3.11, 0.0)
		event.SetMotion(0, "立ち", 4)
		event.CharaNormalDrive(0)
		event.CharaResetDa(0)
		event.ResetCamera(1, 3.1415927, 10.0)
	end
	event.SetFlag(612, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.LoadSound(7812)
	var0 = event.SndLoadSound(7812) or var0
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.ChangeDir("event/e600/e612/")
	event.LoadMes(0, 5, "e612_1.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e612_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e612_monica.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.ChangeDir("")
	if active_chr_no == 1 then
		event.LoadChara(5, "chara/c01_base.gltf", "info", 8)
		event.LoadEquip(5, 0, 4, "info", 8)
		event.LoadEquip(5, 0, 3, "info", 8)
		event.LoadEquip(5, 0, 2, "info", 8, 9)
		event.LoadMotion(5, "event/e600/e608/e608_mints.gltf", "info", 8)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 8)
		event.EohSyncChara(0, 8)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 0)
	else
		event.LoadChara(5, "chara/c02_base.gltf", "info", 8)
		event.LoadEquip(5, 1, 4, "info", 8)
		event.LoadEquip(5, 1, 3, "info", 8)
		event.LoadEquip(5, 1, 2, "info", 8, 9)
		event.LoadMotion(5, "event/e600/e612/e612_monica.gltf", "info", 8)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 8)
		event.EohSyncChara(1, 8)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 0)
	end
	event.CharaActive(8)
	event.CharaActive(9)
	event.LoadChara(5, "event/e600/e612/e612_griffon.gltf", "info", 10)
	event.CharaActive(10)
	event.EohSyncChara(2, 10)
	event.ObjsInit(2, 10)
	event.ObjsSyncObj(2, 2)
	event.LoadChara(5, "event/e600/e612/e612_ghikari.gltf", "info", 13)
	event.CharaActive(13)
	event.EohSyncChara(5, 13)
	event.ObjsInit(5, 13)
	event.ObjsSyncObj(5, 5)
	event.SetCharaShow(1, 0)
	event.SetCharaShow(2, 0)
	event.EohSetPos(0, 16.61, 0.2, 323.16)
	event.EohSetRot(0, 0.0, 3.11, 0.0)
	event.EohSetMotion(0, "かまえるL", 4)
	event.EohSetFootSoundId(0, 4)
	event.EohSetPos(1, -19.07, 0.2, 324.55)
	event.EohSetRot(1, 0.0, 2.99, 0.0)
	event.EohSetMotion(1, "身構えL", 4)
	event.EohSetFootSoundId(1, 4)
	event.EohSetPos(2, -0.95, 0.2, 164.64)
	event.EohSetRot(2, 0.0, 0.0, 0.0)
	event.EohSetMotion(2, "両手上げＬ", 4)
	event.EohSetFootSoundId(2, 4)
	event.InitDramaScene()
	event.CmrsInit()
	event.CmrsSetPos(290.66, 22.4, 159.89)
	event.CmrsSetRef(-25.29, 32.09, 238.0)
	event.CharaActive(0)
	event.CharaActive(8)
	event.CharaActive(9)
	event.CharaActive(10)
	event.CharaActive(0, 13)
	event.SetFadeIn(30)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おこり顔")
	event.ObjsTexAnime(0, 1, "おこり目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "おこり顔")
	event.ObjsTexAnime(1, 1, "おこり目パチ")
	helper_100ac525(30)
	if vm.skipping() then
		return skip(1)
	end
	event.SndSePlay(var0, 0)
	event.ObjsSetMotion(2, "両手下ろす", 6)
	event.ObjsNextMotion(2, "立ち", 4)
	helper_100ac525(60)
	if vm.skipping() then
		return skip(2)
	end
	event.CmrsSetPos(27.47, 43.98, 229.92)
	event.CmrsSetRef(-0.83, 51.54, 164.19)
	event.ObjsSetMotion(2, "すばらしい", 4)
	event.ObjsMotionDelay(2, 120)
	event.ObjsNextMotion(2, "すばらしいＬ", 4)
	helper_99d125b7(6120340, -1)
	if vm.skipping() then
		return skip(3)
	end
	helper_384c5eb1(2)
	if vm.skipping() then
		return skip(4)
	end
	helper_100ac525(30)
	if vm.skipping() then
		return skip(5)
	end
	event.CmrsSetPos(75.01, 95.44, 105.8)
	event.CmrsSetRef(-40.9, 14.77, 261.94)
	event.ObjsSetMotion(2, "立ち2", 4)
	event.SndSePlay(var0, 1)
	event.ObjsSetMotion(1, "何をした？", 6)
	event.ObjsNextMotion(1, "身構えL", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_99d125b7(6120350, -1)
	if vm.skipping() then
		return skip(6)
	end
	helper_100ac525(30)
	if vm.skipping() then
		return skip(7)
	end
	event.ObjsSetMotion(2, "会話２", 6)
	event.ObjsMotionDelay(2, 60)
	event.ObjsNextMotion(2, "立ち2", 4)
	helper_99d125b7(6120360, -1)
	if vm.skipping() then
		return skip(8)
	end
	helper_384c5eb1(2)
	if vm.skipping() then
		return skip(9)
	end
	event.CmrsSetPos(-0.97, 16.6, 262.08)
	event.CmrsSetRef(-1.15, 60.73, 165.4)
	event.ObjsSetMotion(2, "会話２")
	event.ObjsMotionDelay(2, 240)
	event.ObjsNextMotion(2, "立ち2", 4)
	helper_99d125b7(6120365, -1)
	if vm.skipping() then
		return skip(10)
	end
	helper_384c5eb1(2)
	if vm.skipping() then
		return skip(11)
	end
	event.CmrsSetPos(17.77, 47.61, 211.35)
	event.CmrsSetRef(-1.62, 53.0, 164.21)
	event.CharaActive(13)
	event.SetCharaShow(13, 1, 1, 0.033333335)
	event.ObjsSetPos(5, -0.95, 0.2, 164.64)
	event.SndSePlay(var0, 2)
	event.ObjsSetMotion(2, "両手上げ", 6)
	event.ObjsNextMotion(2, "両手上げＬ", 4)
	helper_100ac525(90)
	if vm.skipping() then
		return skip(12)
	end
	event.CmrsSetPos(-10.24, 9.39, 285.55)
	event.CmrsSetRef(3.63, 24.57, 346.84)
	event.ObjsSetPos(0, 10.93, 0.2, 329.45)
	event.ObjsSetRot(0, 0.0, -3.05, 0.0)
	event.ObjsResetDaPosition(0)
	event.ObjsSetPos(1, -10.84, 0.2, 327.13)
	event.ObjsSetRot(1, 0.0, 2.99, 0.0)
	event.ObjsResetDaPosition(1)
	event.CmrsQuake2(0.0, 0.2, 0.2, -1)
	event.SndSePlay(var0, 3)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おどろき顔")
	event.ObjsTexAnime(0, 1, "おどろき目パチ")
	event.ObjsTexAnime(0, 1, "大口")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "おどろき顔")
	event.ObjsTexAnime(1, 1, "おどろき目パチ")
	event.ObjsTexAnime(1, 1, "大口")
	event.ObjsSetMotion(0, "びっくり", 6)
	event.ObjsNextMotion(0, "びっくりL", 4)
	event.ObjsMotionDelay(1, 5)
	event.ObjsSetMotion(1, "ぐらり", 6)
	event.ObjsNextMotion(1, "ぐらりL", 4)
	helper_100ac525(90)
	if vm.skipping() then
		return skip(13)
	end
	event.CmrsSetPos(30.72, 20.08, 266.27)
	event.CmrsSetRef(-3.69, 16.93, 344.36)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おこり顔")
	event.ObjsTexAnime(0, 1, "おこり目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "おこり顔")
	event.ObjsTexAnime(1, 1, "おこり目パチ")
	event.ObjsSetMotion(0, "びっくりキョロキョロ", 6)
	event.ObjsNextMotion(0, "びっくりL", 4)
	event.ObjsMotionDelay(1, 30)
	event.ObjsSetMotion(1, "きょろきょろ", 6)
	event.ObjsNextMotion(1, "ぐらりL", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_99d125b7(6120370, 45)
	if vm.skipping() then
		return skip(14)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_99d125b7(6120380, -1)
	if vm.skipping() then
		return skip(15)
	end
	event.CmrsSetPos(30.39, 12.88, 208.54)
	event.CmrsSetRef(-1.44, 44.98, 166.69)
	helper_100ac525(90)
	if vm.skipping() then
		return skip(16)
	end
	event.SetFadeOut(30)
	helper_100ac525(30)
	if vm.skipping() then
		return skip(17)
	end
	return part2()
end

return helper_73ea637d
