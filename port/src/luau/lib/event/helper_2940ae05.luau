--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_2f481f12 = require("@lib/event/helper_2f481f12")
local helper_3353221a = require("@lib/event/helper_3353221a")
local helper_93bb7fa4 = require("@lib/event/helper_93bb7fa4")
local helper_e8f4b85c = require("@lib/event/helper_e8f4b85c")

--- Helper function.
local function helper_2940ae05()
	local var0: s32 = 0
	local var1: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 15 then
			if at <= 1 then
				helper_2f481f12(4)
			end
			if at <= 2 then
				helper_2f481f12(30)
			end
			if at <= 3 then
				helper_93bb7fa4(3150010)
			end
			if at <= 4 then
				helper_e8f4b85c(1)
			end
			if at <= 5 then
				helper_2f481f12(30)
			end
			if at <= 6 then
				helper_2f481f12(30)
			end
			if at <= 7 then
				helper_93bb7fa4(3150020)
			end
			if at <= 8 then
				helper_e8f4b85c(1)
			end
			if at <= 9 then
				helper_2f481f12(24)
			end
			if at <= 10 then
				helper_3353221a(var1)
			end
			if at <= 11 then
				helper_93bb7fa4(3150030)
			end
			if at <= 12 then
				helper_93bb7fa4(3150040)
			end
			if at <= 13 then
				helper_e8f4b85c(0)
			end
			if at <= 14 then
				helper_2f481f12(30)
			end
			if vm.skip_end() then
				return skip(16)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.StopBgm(0)
		event.DelExtMotion(0)
		event.DelExtMotion(13)
		event.CharaActive(0, 8)
		event.CharaActive(0, 9)
		event.CharaActive(0, 10)
		event.CharaActive(0, 11)
		event.CharaActive(0, 12)
		event.DelReference(15)
		event.CharaActive(0, 15)
		event.DeleteChara(12)
		event.LoadMes(0, -1)
		event.Finish()
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFlag(315, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.StopBgm(0)
	helper_2f481f12(4)
	if vm.skipping() then
		return skip(2)
	end
	event.LoadBgm(57)
	event.PlayBgm(0)
	var0 = event.SndLoadSound(3811) or var0
	var1 = event.SndLoadSound(5, "snd2/mon/en_900.sound.json") or var1
	event.AssignStack(5)
	event.ClearStack(5)
	event.SetStatusbarShow(0, 1.0)
	event.GetActiveChrNo()
	event.ChangeDir("event/e300/e315/")
	event.LoadMes(0, 5, "e315_1.txt")
	event.LoadMotion(5, "e315_mints.gltf", "info", 0)
	event.CharaActive(0)
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ChangeDir("")
	event.LoadChara(5, "dungeon/sphida/gool_end.gltf", "info", 12)
	event.CharaActive(0, 12)
	event.DelExtMotion(13)
	event.LoadMotion(5, "event/e300/e312/e312_monica.gltf", "info", 13)
	event.LoadMotion(5, "event/e300/e315/e315_monica.gltf", "info", 13)
	event.EohSyncChara(1, 13)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.CreateSwordEffect(5, 64, 16)
	event.SwordEffectColor(128, 128, 128, 80, 128, 128, 128, 80)
	event.EohSetPos(0, -92.27, 48.63, 1283.9)
	event.EohSetRot(0, 0.0, 1.34, 0.0)
	event.EohSetMotion(0, "立ち", 4)
	event.CharaActive(0, 15)
	event.SetCharaPos(15, 0.0, 0.0, 0.0)
	event.SetCharaRot(15, 0.0, 0.0, 0.0)
	event.SetReference(13, "sword_hand", 15)
	event.EohSetPos(1, 68.04, 41.85, 1180.61)
	event.EohSetRot(1, 0.0, 3.14, 0.0)
	event.EohSetMotion(1, "立ち", 4)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "デフォルト顔")
	event.EohSetTexAnim(1, 1, "通常目パチ")
	event.CharaNormalDrive(13)
	event.CharaResetDa(13)
	event.SphidaSetBallPos(0.0, 65.57, 1305.04)
	event.SphidaSetBallCol(0)
	event.SetCharaPos(8, 0.0, 65.57, 1305.04)
	event.CharaActive(0, 8)
	event.SetCharaPos(9, 0.0, 65.57, 1305.04)
	event.CharaActive(1, 9)
	event.CharaActive(0, 0)
	event.InitDramaScene()
	event.CmrsInit()
	event.CmrsSetPos(67.57, 63.38, 1149.74)
	event.CmrsSetRef(67.85, 63.66, 1179.99)
	event.SetFadeIn(30)
	helper_2f481f12(30)
	if vm.skipping() then
		return skip(3)
	end
	event.SndSePlay(var0, 0)
	event.ObjsSetMotion(1, "貸しなさい", 2)
	event.ObjsNextMotion(1, "貸しなさいＬ", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_93bb7fa4(3150010)
	if vm.skipping() then
		return skip(4)
	end
	helper_e8f4b85c(1)
	if vm.skipping() then
		return skip(5)
	end
	event.SetFadeOut(30)
	helper_2f481f12(30)
	if vm.skipping() then
		return skip(6)
	end
	event.CmrsSetPos(65.27, 79.39, 1297.35)
	event.CmrsSetRef(6.16, 79.67, 1305.48)
	event.CharaActive(1, 0)
	event.EohSetPos(0, -92.27, 48.63, 1283.9)
	event.EohSetRot(0, 0.0, 1.34, 0.0)
	event.EohSetMotion(0, "立ち", 4)
	event.CharaNormalDrive(0)
	event.CharaResetDa(0)
	event.DelReference(15)
	event.CharaActive(1, 15)
	event.SetCharaPos(15, 0.0, 0.0, 0.0)
	event.SetCharaRot(15, 0.0, 0.0, 0.0)
	event.SetReference(13, "sword_hand", 15)
	event.EohSetPos(1, -11.1, 63.73, 1309.96)
	event.EohSetRot(1, 0.0, 1.8, 0.0)
	event.EohSetMotion(1, "かまえゴルフＬ", 4)
	event.CharaNormalDrive(13)
	event.CharaResetDa(13)
	event.SetFadeIn(30)
	helper_2f481f12(30)
	if vm.skipping() then
		return skip(7)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_93bb7fa4(3150020)
	if vm.skipping() then
		return skip(8)
	end
	event.ObjsSetMotion(1, "前方確認", 2)
	event.ObjsNextMotion(1, "ショット", 6)
	event.ObjsSeDelay(1, 10)
	event.ObjsSePlay(1, var0, 1)
	event.ObjsSeDelay(1, 44)
	event.ObjsSePlay(1, var0, 2)
	event.ObjsSeDelay(1, 42)
	event.ObjsSePlay(1, var0, 3)
	helper_e8f4b85c(1)
	if vm.skipping() then
		return skip(9)
	end
	helper_2f481f12(24)
	if vm.skipping() then
		return skip(10)
	end
	helper_3353221a(var1)
	if vm.skipping() then
		return skip(11)
	end
	event.CmrsSetPos(-88.57, 74.62, 1267.26)
	event.CmrsSetRef(20.74, 79.67, 1276.18)
	event.ObjsSetPos(0, -18.67, 62.68, 1288.34)
	event.ObjsSetRot(0, 0.0, -2.66, 0.0)
	event.ObjsResetDaPosition(0)
	event.ObjsSetPos(1, -1.4, 62.34, 1267.0)
	event.ObjsSetRot(1, 0.0, -2.68, 0.0)
	event.ObjsSetMotion(1, "立ち", 4, -1.0, 1)
	event.SetPakuAnim(1, "通常口パク")
	helper_93bb7fa4(3150030)
	if vm.skipping() then
		return skip(12)
	end
	event.SndSePlay(var0, 5)
	event.ObjsSetMotion(0, "すごいや", 6)
	event.ObjsNextMotion(0, "すごいやL", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_93bb7fa4(3150040)
	if vm.skipping() then
		return skip(13)
	end
	helper_e8f4b85c(0)
	if vm.skipping() then
		return skip(14)
	end
	event.FadeOutBgm(30)
	event.SetFadeOut(30)
	helper_2f481f12(30)
	if vm.skipping() then
		return skip(15)
	end
	return part2()
end

return helper_2940ae05
