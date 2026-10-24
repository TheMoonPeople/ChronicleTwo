--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_4d6fefb8 = require("@lib/event/helper_4d6fefb8")
local helper_5c88e2f9 = require("@lib/event/helper_5c88e2f9")
local helper_7925c177 = require("@lib/event/helper_7925c177")
local helper_bc115506 = require("@lib/event/helper_bc115506")
local helper_c85a55f2 = require("@lib/event/helper_c85a55f2")

--- Helper function.
local function helper_d8ef09af()
	local active_chr_no: s32 = 0
	local var1: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 29 then
			if at <= 1 then
				active_chr_no = 0
				active_chr_no = 1
				helper_c85a55f2(4)
			end
			if at <= 2 then
				helper_c85a55f2(80)
			end
			if at <= 3 then
				helper_4d6fefb8()
			end
			if at <= 4 then
				helper_5c88e2f9(1)
			end
			if at <= 5 then
				helper_c85a55f2(20)
			end
			if at <= 6 then
				helper_c85a55f2(20)
			end
			if at <= 7 then
				helper_c85a55f2(20)
			end
			if at <= 8 then
				helper_5c88e2f9(1)
			end
			if at <= 9 then
				helper_c85a55f2(6)
			end
			if at <= 10 then
				helper_c85a55f2(10)
			end
			if at <= 11 then
				helper_c85a55f2(15)
			end
			if at <= 12 then
				helper_5c88e2f9(1)
			end
			if at <= 13 then
				helper_5c88e2f9(0)
			end
			if at <= 14 then
				helper_bc115506(5360010)
			end
			if at <= 15 then
				helper_bc115506(5360020)
			end
			if at <= 16 then
				helper_bc115506(5360025)
			end
			if at <= 17 then
				helper_7925c177(5360030, -1)
			end
			if at <= 18 then
				helper_4d6fefb8()
			end
			if at <= 19 then
				helper_bc115506(5360040)
			end
			if at <= 20 then
				helper_bc115506(5360045)
			end
			if at <= 21 then
				helper_4d6fefb8()
			end
			if at <= 22 then
				helper_5c88e2f9(2)
			end
			if at <= 23 then
				helper_c85a55f2(60)
			end
			if at <= 24 then
				helper_5c88e2f9(2)
			end
			if at <= 25 then
				helper_c85a55f2(60)
			end
			if at <= 26 then
				helper_bc115506(5360050)
			end
			if at <= 27 then
				helper_c85a55f2(30)
			end
			if at <= 28 then
				helper_c85a55f2(120)
			end
			if vm.skip_end() then
				return skip(30)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.StopBgm(0)
		event.SetStatus(1, 0, 256, 0)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.DelExtMotion(0)
		event.DeleteChara(8)
		event.DeleteChara(9)
		event.DeleteChara(10)
		event.DeleteChara(11)
		event.DeleteChara(12)
		event.DeleteChara(13)
		event.DeleteChara(14)
		event.DeleteChara(15)
		event.DeleteChara(16)
		event.DelImg(0)
		event.LoadMes(0, -1)
		event.SetStatusbarShow(1, 1.0)
		event.EohSetShow(4, 1)
		event.EohSetShow(5, 1)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFlag(536, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.SetStatusbarShow(0, 1.0)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 2 then
		event.DngSetupMainUnit(0)
		active_chr_no = 0
	end
	if active_chr_no == 3 then
		event.DngSetupMainUnit(1)
		active_chr_no = 1
	end
	event.StopBgm(0)
	helper_c85a55f2(4)
	if vm.skipping() then
		return skip(2)
	end
	event.LoadBgm(52)
	event.LoadSound(5823)
	var1 = event.SndLoadSound(5823) or var1
	event.SetStatus(1, 0, 256, 1)
	event.ChangeDir("event/e500/e536/")
	event.LoadMes(0, 5, "e536_1.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e536_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e536_monica.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.LoadChara(5, "e536_guiltoni.gltf", "info", 10)
	event.CharaActive(0, 10)
	event.EohSyncChara(2, 10)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.LoadChara(5, "e536_m_guil.gltf", "p00_23a", 11)
	event.CharaActive(11)
	event.EohSyncChara(3, 11)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.LoadChara(5, "e536_guilbaku.gltf", "info", 12)
	event.CharaActive(0, 12)
	event.LoadChara(5, "e536_guilbaku1.gltf", "info", 13)
	event.CharaActive(0, 13)
	event.LoadChara(5, "e536_hikari.gltf", "info", 14)
	event.CharaActive(0, 14)
	event.LoadChara(5, "e536_hikari1.gltf", "info", 15)
	event.CharaActive(0, 15)
	event.LoadChara(5, "e536_guil_hikari.gltf", "info", 16)
	event.CharaActive(0, 16)
	event.EohSyncChara(6, 16)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 6)
	event.ChangeDir("")
	if active_chr_no == 1 then
		event.LoadChara(5, "chara/c01_base.gltf", "info", 8)
		event.LoadEquip(5, 0, 4, "info", 8)
		event.LoadEquip(5, 0, 3, "info", 8)
		event.LoadEquip(5, 0, 2, "info", 8, 9)
		event.LoadMotion(5, "event/e500/e536/e536_mints.gltf", "info", 8)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 8)
		event.EohSyncChara(0, 8)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	else
		event.LoadChara(5, "chara/c02_base.gltf", "info", 8)
		event.LoadEquip(5, 1, 4, "info", 8)
		event.LoadEquip(5, 1, 3, "info", 8)
		event.LoadEquip(5, 1, 2, "info", 8, 9)
		event.LoadMotion(5, "event/e500/e536/e536_monica.gltf", "info", 8)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 8)
		event.EohSyncChara(1, 8)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.CharaActive(8)
	event.CharaActive(9)
	event.EohSyncChara(4, 1)
	event.EohSyncChara(5, 2)
	event.EohSetShow(4, 0)
	event.EohSetShow(5, 0)
	event.EohSetPos(0, -10.0, 0.0, 100.0)
	event.EohSetRot(0, 0.0, 3.14, 0.0)
	event.EohSetMotion(0, "立ち", 4)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "おこり顔")
	event.EohSetTexAnim(0, 1, "おこり目パチ")
	event.EohSetTexAnim(0, 1, "半口")
	event.EohSetFootSoundId(0, 2)
	event.EohSetPos(1, 10.0, 0.0, 100.0)
	event.EohSetRot(1, 0.0, 3.14, 0.0)
	event.EohSetMotion(1, "立ち", 4)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "おこり顔")
	event.EohSetTexAnim(1, 1, "おこり目パチ")
	event.EohSetTexAnim(1, 1, "半口")
	event.EohSetFootSoundId(1, 2)
	event.EohSetPos(2, 0.0, 0.0, -50.0)
	event.EohSetRot(2, 0.0, 1.57, 0.0)
	event.EohSetMotion(2, "倒れ", 4)
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "くるし顔")
	event.EohSetTexAnim(2, 1, "くるし目とじ")
	event.EohSetPos(3, 0.0, 0.0, -50.0)
	event.EohSetRot(3, 0.0, 0.0, 0.0)
	event.EohSetMotion(3, "グォオー", 4)
	event.SetCharaPos(12, 0.0, 50.0, -50.0)
	event.SetCharaRot(12, 0.0, 0.0, 0.0)
	event.SetCharaPos(13, 0.0, 50.0, -18.0)
	event.SetCharaRot(13, 0.0, 0.0, 0.0)
	event.InitDramaScene()
	event.CharaActive(1, 12)
	event.SetMotion(12, "グォオー", 6)
	event.CharaActive(1, 13)
	event.SetMotion(13, "グォオー", 6)
	event.SndSePlay(var1, 2)
	event.CmrsInit()
	event.CmrsSetPos(0.0, 150.0, 65.9)
	event.CmrsSetRef(0.0, 150.0, -23.0)
	event.CmrsMove2(0.0, 123.2, 330.45, 0.0, 123.57, -23.0, 90, 0, 0.3)
	event.SetFadeIn(30)
	helper_c85a55f2(80)
	if vm.skipping() then
		return skip(3)
	end
	event.SetCharaShow(11, 0, 1, 0.1)
	helper_4d6fefb8()
	if vm.skipping() then
		return skip(4)
	end
	event.CharaActive(0, 13)
	event.CharaActive(0, 12)
	event.CmrsSetPos(45.36, 6.79, 49.62)
	event.CmrsSetRef(-2.61, 16.71, 101.94)
	event.SetWind(10, 0.0, 0.0, 1.0)
	event.CharaActive(1, 14)
	event.SetCharaPos(14, 19.99, 0.0, 122.09)
	event.SetCharaRot(14, 0.0, 1.57, 0.0)
	event.ObjsSetMotion(0, "爆発", 6)
	event.ObjsNextMotion(0, "爆発L", 4)
	event.ObjsSetMotion(1, "爆発", 6)
	event.ObjsNextMotion(1, "爆発L", 4)
	helper_5c88e2f9(1)
	if vm.skipping() then
		return skip(5)
	end
	helper_c85a55f2(20)
	if vm.skipping() then
		return skip(6)
	end
	event.CharaActive(0, 14)
	event.CmrsSetPos(4.04, 16.09, 159.94)
	event.CmrsSetRef(4.04, 13.4, 71.43)
	event.CharaActive(0, 11)
	event.CharaActive(1, 10)
	event.CharaActive(1, 15)
	event.SetCharaPos(15, 0.0, 0.0, 15.0)
	event.SetCharaRot(15, 0.0, 0.0, 0.0)
	helper_c85a55f2(20)
	if vm.skipping() then
		return skip(7)
	end
	event.SetCharaShow(15, 0, 1, 0.033333335)
	event.SetWind(-1)
	helper_c85a55f2(20)
	if vm.skipping() then
		return skip(8)
	end
	event.ObjsSetMotion(0, "爆発戻り", 6)
	event.ObjsNextMotion(0, "立ち", 4)
	event.ObjsSetMotion(1, "もどり", 6)
	event.ObjsNextMotion(1, "立ち", 4)
	helper_5c88e2f9(1)
	if vm.skipping() then
		return skip(9)
	end
	helper_c85a55f2(6)
	if vm.skipping() then
		return skip(10)
	end
	event.ObjsSetMotion(1, "走り")
	event.ObjsMotionDelay(1, 46)
	event.ObjsSetMotion(1, "立ち")
	event.ObjsMove(1, 10.0, 0.0, -30.0, 50)
	event.ObjsRotDelay(1, 46)
	event.ObjsRotation(1, 0.0, -2.78, 0.0, 10)
	helper_c85a55f2(10)
	if vm.skipping() then
		return skip(11)
	end
	event.ObjsSetMotion(0, "走り")
	event.ObjsMotionDelay(0, 46)
	event.ObjsSetMotion(0, "立ち")
	event.ObjsMove(0, -10.0, 0.0, -30.0, 50)
	event.ObjsRotDelay(0, 46)
	event.ObjsRotation(0, 0.0, 2.9, 0.0, 10)
	helper_c85a55f2(15)
	if vm.skipping() then
		return skip(12)
	end
	event.CmrsSetPos(13.0, 9.86, -79.62)
	event.CmrsSetRef(13.0, 12.67, -39.5)
	event.CmrsMove2(0.0, 9.86, -79.62, 0.0, 12.67, -39.5, 60, 2, 1.0)
	event.PlayBgm(0)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "おこり顔")
	event.EohSetTexAnim(1, 1, "おこり目パチ")
	event.ObjsSetPos(2, 13.0, 0.0, -50.0)
	event.ObjsResetDaPosition(2)
	helper_5c88e2f9(1)
	if vm.skipping() then
		return skip(13)
	end
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "おこり顔")
	event.EohSetTexAnim(1, 1, "おこり目～こまり目下")
	event.SndSePlay(var1, 3)
	event.ObjsSetMotion(1, "しゃがみ", 6)
	event.ObjsNextMotion(1, "しゃがみL", 4)
	helper_5c88e2f9(0)
	if vm.skipping() then
		return skip(14)
	end
	event.ObjsSetMotion(0, "しゃがむ", 6)
	event.ObjsNextMotion(0, "しゃがむL", 4)
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "くるし顔")
	event.EohSetTexAnim(2, 1, "目とじ～目あけ")
	event.SetPakuAnim(1, "通常口パク")
	helper_bc115506(5360010)
	if vm.skipping() then
		return skip(15)
	end
	event.SetPakuAnim(2, "くるし口パク")
	helper_bc115506(5360020)
	if vm.skipping() then
		return skip(16)
	end
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "くるし顔")
	event.EohSetTexAnim(2, 1, "目あけ～目とじ")
	event.ObjsSetMotion(2, "ぐふっ", 2)
	event.ObjsNextMotion(2, "倒れ", 4)
	event.SetPakuAnim(2, "くるし口パク")
	helper_bc115506(5360025)
	if vm.skipping() then
		return skip(17)
	end
	helper_7925c177(5360030, -1)
	if vm.skipping() then
		return skip(18)
	end
	helper_4d6fefb8()
	if vm.skipping() then
		return skip(19)
	end
	event.CmrsSetPos(16.76, 57.33, -49.41)
	event.CmrsSetRef(4.01, 12.67, -49.87)
	event.CmrsMove2(11.95, 41.94, -49.58, 4.01, 12.67, -49.87, 150, 2, 1.0)
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "くるし顔")
	event.EohSetTexAnim(2, 1, "くるし目～くるし目２")
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "こまり顔")
	event.EohSetTexAnim(1, 1, "こまり目パチ")
	event.SetPakuAnim(2, "くるし口パク")
	helper_bc115506(5360040)
	if vm.skipping() then
		return skip(20)
	end
	event.SetPakuAnim(2, "くるし口パク")
	helper_bc115506(5360045)
	if vm.skipping() then
		return skip(21)
	end
	helper_4d6fefb8()
	if vm.skipping() then
		return skip(22)
	end
	event.SndSePlay(var1, 4)
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "くるし顔")
	event.EohSetTexAnim(2, 1, "くるし目２～通常目")
	event.EohSetTexAnim(2, 1, "わらい口")
	event.ObjsSetMotion(2, "モニカ見", 2)
	event.ObjsNextMotion(2, "モニカ見L", 4)
	helper_5c88e2f9(2)
	if vm.skipping() then
		return skip(23)
	end
	helper_c85a55f2(60)
	if vm.skipping() then
		return skip(24)
	end
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "こまり顔")
	event.EohSetTexAnim(1, 1, "こまり目パチ")
	event.EohSetTexAnim(1, 1, "口とじ～大口")
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "わらい顔")
	event.EohSetTexAnim(2, 1, "ゆっくり目とじ")
	event.SndSePlay(var1, 5)
	event.ObjsSetMotion(2, "死に", 2)
	event.ObjsMotionWait(2)
	helper_5c88e2f9(2)
	if vm.skipping() then
		return skip(25)
	end
	helper_c85a55f2(60)
	if vm.skipping() then
		return skip(26)
	end
	event.CmrsSetPos(-6.98, 9.03, -75.58)
	event.CmrsSetRef(0.96, 12.16, -49.21)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "こまり顔")
	event.EohSetTexAnim(1, 1, "目あき～目とじ")
	event.SetPakuAnim(1, "通常口パク")
	helper_bc115506(5360050)
	if vm.skipping() then
		return skip(27)
	end
	event.CmrsSetPos(-0.18, 28.97, 146.9)
	event.CmrsSetRef(9.44, 29.01, 60.59)
	event.CmrsMove(-2.36, 28.97, 166.44, 9.44, 29.01, 60.59, 150)
	event.SndSePlay(var1, 6)
	event.CharaActive(1, 16)
	event.SetCharaPos(16, 0.0, 0.0, -50.0)
	event.SetCharaRot(16, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(4, "発動・ギル光の粒", 6)
	event.ObjsNextMotion(4, "ループ・ギル光の粒", 4)
	event.FadeOutBgm(150)
	helper_c85a55f2(30)
	if vm.skipping() then
		return skip(28)
	end
	event.SetFadeOut(120, 255, 255, 255)
	helper_c85a55f2(120)
	if vm.skipping() then
		return skip(29)
	end
	return part2()
end

return helper_d8ef09af
