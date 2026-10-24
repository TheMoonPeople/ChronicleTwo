--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_100ac525 = require("@lib/event/helper_100ac525")
local helper_278fcd8e = require("@lib/event/helper_278fcd8e")
local helper_384c5eb1 = require("@lib/event/helper_384c5eb1")
local helper_99d125b7 = require("@lib/event/helper_99d125b7")

--- Helper function.
local function helper_079d3d9b()
	local var0: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 23 then
			if at <= 1 then
				helper_278fcd8e(6100010)
			end
			if at <= 2 then
				helper_384c5eb1(0)
			end
			if at <= 3 then
				helper_100ac525(30)
			end
			if at <= 4 then
				helper_99d125b7(6100020, 45)
			end
			if at <= 5 then
				helper_384c5eb1(1)
			end
			if at <= 6 then
				helper_100ac525(30)
			end
			if at <= 7 then
				helper_100ac525(30)
			end
			if at <= 8 then
				helper_100ac525(60)
			end
			if at <= 9 then
				helper_100ac525(30)
			end
			if at <= 10 then
				helper_100ac525(15)
			end
			if at <= 11 then
				helper_384c5eb1(3)
			end
			if at <= 12 then
				helper_100ac525(60)
			end
			if at <= 13 then
				helper_100ac525(30)
			end
			if at <= 14 then
				helper_99d125b7(6100030, 145)
			end
			if at <= 15 then
				helper_99d125b7(6100040, 60)
			end
			if at <= 16 then
				helper_99d125b7(6100050, 240)
			end
			if at <= 17 then
				helper_99d125b7(6100060, 120)
			end
			if at <= 18 then
				helper_100ac525(60)
			end
			if at <= 19 then
				helper_278fcd8e(6100070)
			end
			if at <= 20 then
				helper_100ac525(30)
			end
			if at <= 21 then
				helper_278fcd8e(6100080)
			end
			if at <= 22 then
				helper_100ac525(30)
			end
			if vm.skip_end() then
				return skip(24)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.LoadBgm(36)
		event.PlayBgm(0)
		event.SndSeStop(var0, 2)
		event.SndSeStop(var0, 4)
		event.DngPause(128, 0)
		event.SpriteSetDraw(0, 0)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.DngPause(128, 0)
		event.DeleteChara(8)
		event.DeleteChara(9)
		event.DeleteChara(10)
		event.DeleteChara(11)
		event.DeleteChara(12)
		event.DeleteChara(13)
		event.DeleteChara(14)
		event.LoadMes(0, -1)
		event.CharaActive(1, 0)
		event.SetStatusbarShow(1, 1.0)
		event.SetCharaShow(1, 1)
		event.SetCharaShow(2, 1)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFlag(610, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.StopBgm(0)
	event.LoadSound(7809)
	var0 = event.SndLoadSound(7809) or var0
	event.SndSePlay(var0, 0)
	event.SndSeStop(var0, 0)
	event.SetStatusbarShow(0, 1.0)
	event.CharaActive(0, 0)
	event.AssignStack(5)
	event.ClearStack(5)
	event.ChangeDir("event/e600/e610/")
	event.LoadMes(0, 5, "e610_1.txt")
	event.ChangeDir("")
	event.SpriteInit(0)
	event.SpriteSetType(0, 0)
	event.SpriteSetColor(0, 128, 128, 128, 0)
	event.SpriteSetUvsize(0, 0, 0, 512, 448)
	event.SpriteSetPutsize(0, 512, 448)
	event.SpriteSetPos(0, 256, 224)
	event.SpriteSetDraw(0, 1)
	event.EohSyncSprite(5, 0)
	event.ObjsInit(5)
	event.ObjsSyncObj(5, 5)
	event.LoadChara(5, "chara/c01_base.gltf", "info", 8)
	event.LoadEquip(5, 0, 4, "info", 8)
	event.LoadEquip(5, 0, 3, "info", 8)
	event.LoadEquip(5, 0, 2, "info", 8, 9)
	event.LoadMotion(5, "event/e600/e610/e610_mints.gltf", "info", 8)
	event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 8)
	event.EohSyncChara(0, 8)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.LoadChara(5, "chara/c02_base.gltf", "info", 10)
	event.LoadEquip(5, 1, 4, "info", 10)
	event.LoadEquip(5, 1, 3, "info", 10)
	event.LoadEquip(5, 1, 2, "info", 10, 11)
	event.LoadMotion(5, "event/e600/e610/e610_monica.gltf", "info", 10)
	event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 10)
	event.EohSyncChara(1, 10)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.LoadChara(5, "event/e600/e610/e610_hana_sun_ex.gltf", "info", 12)
	event.CharaActive(12)
	event.EohSyncChara(2, 12)
	event.ObjsInit(2, 12)
	event.ObjsSyncObj(2, 2)
	event.LoadChara(5, "event/e600/e610/e610_kiran.gltf", "info", 13)
	event.CharaActive(13)
	event.EohSyncChara(3, 13)
	event.ObjsInit(3, 13)
	event.ObjsSyncObj(3, 3)
	event.LoadChara(5, "event/e600/e610/e610_hanakudake.gltf", "info", 14)
	event.CharaActive(14)
	event.EohSyncChara(4, 14)
	event.ObjsInit(4, 14)
	event.ObjsSyncObj(4, 4)
	event.SetCharaShow(1, 0)
	event.SetCharaShow(2, 0)
	event.EohSetPos(0, -36.85, 0.2, 211.1)
	event.EohSetRot(0, 0.0, -1.13, 0.0)
	event.EohSetMotion(0, "立ち", 4)
	event.EohSetFootSoundId(0, 4)
	event.EohSetPos(1, 32.44, 0.2, 194.73)
	event.EohSetRot(1, 0.0, 0.95, 0.0)
	event.EohSetMotion(1, "立ち", 4)
	event.EohSetFootSoundId(1, 4)
	event.InitDramaScene()
	event.CmrsInit()
	event.CmrsSetPos(-25.8, 19.87, 265.72)
	event.CmrsSetRef(-34.35, 19.8, 232.21)
	event.CharaActive(8)
	event.CharaActive(9)
	event.CharaActive(10)
	event.CharaActive(11)
	event.CharaActive(0, 12)
	event.CharaActive(0, 13)
	event.CharaActive(0, 14)
	event.SetFadeIn(30)
	event.ObjsSetColor(5, 0, 0, 0, 128, 0)
	helper_278fcd8e(6100010)
	if vm.skipping() then
		return skip(2)
	end
	event.ObjsSetColor(5, 0, 0, 0, 0, 1)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おこり顔")
	event.ObjsTexAnime(0, 1, "左向き目パチ")
	event.ObjsTexAnime(0, 1, "半口")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "おこり顔")
	event.ObjsTexAnime(1, 1, "右向き目パチ")
	event.ObjsTexAnime(1, 1, "半口")
	event.ObjsSetMotion(0, "はっとする", 6)
	event.ObjsNextMotion(0, "はっとするL", 4)
	helper_384c5eb1(0)
	if vm.skipping() then
		return skip(3)
	end
	event.SndSePlay(var0, 0)
	event.SetFadeOut(30, 255, 255, 255)
	helper_100ac525(30)
	if vm.skipping() then
		return skip(4)
	end
	event.SetFadeIn(15, 255, 255, 255)
	event.CmrsSetPos(24.23, 19.45, 233.89)
	event.CmrsSetRef(37.75, 19.84, 179.82)
	event.ObjsSetMotion(1, "ふりかえり", 6)
	event.ObjsNextMotion(1, "ふりかえりL", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_99d125b7(6100020, 45)
	if vm.skipping() then
		return skip(5)
	end
	event.ResetPakuAnim()
	helper_384c5eb1(1)
	if vm.skipping() then
		return skip(6)
	end
	event.SndSePlay(var0, 1)
	event.SetFadeOut(30, 255, 255, 255)
	helper_100ac525(30)
	if vm.skipping() then
		return skip(7)
	end
	event.SndSePlay(var0, 2)
	event.SetFadeIn(30)
	event.ObjsSetColor(5, 0, 0, 0, 128, 0)
	helper_100ac525(30)
	if vm.skipping() then
		return skip(8)
	end
	event.CmrsFadeOut(0)
	event.ObjsSetColor(5, 0, 0, 0, 0, 0)
	helper_100ac525(60)
	if vm.skipping() then
		return skip(9)
	end
	event.SetFadeIn(30)
	event.DngPause(128, 1)
	event.CmrsSetPos(1.98, 6.53, 181.87)
	event.CmrsSetRef(1.06, 23.97, 120.97)
	event.ObjsSetPos(1, 12.41, 0.2, 137.08)
	event.ObjsSetRot(1, 0.0, -0.72, 0.0)
	event.ObjsSetMotion(1, "立ち", 4)
	event.ObjsResetDaPosition(1)
	event.ObjsSetPos(0, -9.58, 0.2, 135.04)
	event.ObjsSetRot(0, 0.0, 0.71, 0.0)
	event.ObjsSetMotion(0, "立ち", 4)
	event.ObjsResetDaPosition(0)
	event.DngPause(128, 1)
	event.SpriteSetDraw(0, 0)
	helper_100ac525(30)
	if vm.skipping() then
		return skip(10)
	end
	event.CharaActive(13)
	event.ObjsSetPos(3, 1.8, 10.3, 168.28)
	event.ObjsSetRot(3, 0.0, 0.48, 0.35)
	event.ObjsSetMotion(3, "キラン", 4)
	event.CharaActive(14)
	event.ObjsSetPos(4, 1.24, 13.3, 134.88)
	event.ObjsSetMotion(4, "現れる", 6)
	event.ObjsNextMotion(4, "ループ", 4)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おこり顔")
	event.ObjsTexAnime(0, 1, "目あき～目とじ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "おこり顔")
	event.ObjsTexAnime(1, 1, "目あき～目とじ")
	event.SndSePlay(var0, 3)
	event.ObjsSetMotion(0, "光る", 6)
	event.ObjsNextMotion(0, "下向き立ち", 4)
	event.ObjsSetMotion(1, "まぶしい", 6)
	event.ObjsNextMotion(1, "下見立ち", 4)
	helper_100ac525(15)
	if vm.skipping() then
		return skip(11)
	end
	event.CharaActive(12)
	event.ObjsSetPos(2, 1.24, 13.3, 134.88)
	helper_384c5eb1(3)
	if vm.skipping() then
		return skip(12)
	end
	event.CharaActive(0, 13)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "目とじ～おこり目")
	event.ObjsTexAnime(0, 1, "半口")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "おこり顔")
	event.ObjsTexAnime(1, 1, "目とじ～目あき")
	helper_100ac525(60)
	if vm.skipping() then
		return skip(13)
	end
	event.ObjsSetMotion(0, "さわろうとする", 6)
	event.ObjsNextMotion(0, "下向き立ち", 4)
	event.ObjsMotionDelay(1, 20)
	event.ObjsSetMotion(1, "はじける", 6)
	event.ObjsNextMotion(1, "下見立ち", 4)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おこり顔")
	event.ObjsTexAnime(0, 1, "まばたき目パチ")
	event.ObjsTexAnime(0, 1, "半口～大口")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "おこり顔")
	event.ObjsTexAnime(1, 1, "まばたき目パチ")
	event.ObjsTexAnime(1, 1, "半口")
	event.ObjsMotionDelay(4, 15)
	event.ObjsSetMotion(4, "花くだけ", 4)
	event.ObjsSetStep(4, 0.05)
	helper_100ac525(30)
	if vm.skipping() then
		return skip(14)
	end
	event.SetCharaShow(12, 0, 1, 0.1)
	event.SndSePlay(var0, 4)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おこり顔")
	event.ObjsTexAnime(0, 1, "おこり目パチ")
	event.ObjsTexAnime(0, 1, "大口～口とじ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "おこり顔")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	helper_99d125b7(6100030, 145)
	if vm.skipping() then
		return skip(15)
	end
	helper_99d125b7(6100040, 60)
	if vm.skipping() then
		return skip(16)
	end
	event.SetFadeOut(420, 0, 0, 0)
	helper_99d125b7(6100050, 240)
	if vm.skipping() then
		return skip(17)
	end
	event.CharaActive(0, 14)
	event.ObjsSetMotion(0, "下→上", 6)
	event.ObjsNextMotion(0, "上向くL", 4)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おこり顔")
	event.ObjsTexAnime(0, 1, "おこり目パチ")
	event.SetPakuAnim(0, "通常口パク")
	helper_99d125b7(6100060, 120)
	if vm.skipping() then
		return skip(18)
	end
	helper_100ac525(60)
	if vm.skipping() then
		return skip(19)
	end
	event.SetFadeIn(15, 0, 0, 0)
	event.ObjsSetColor(5, 0, 0, 0, 128, 0)
	event.SpriteSetDraw(0, 1)
	helper_278fcd8e(6100070)
	if vm.skipping() then
		return skip(20)
	end
	event.SetFadeOut(30, 255, 255, 255)
	helper_100ac525(30)
	if vm.skipping() then
		return skip(21)
	end
	event.SetFadeIn(15, 255, 255, 255)
	event.ObjsSetColor(5, 255, 255, 255, 128, 0)
	helper_278fcd8e(6100080)
	if vm.skipping() then
		return skip(22)
	end
	event.SetFadeOut(30)
	helper_100ac525(30)
	if vm.skipping() then
		return skip(23)
	end
	return part2()
end

return helper_079d3d9b
