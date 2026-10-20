--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_100ac525 = require("@lib/event/helper_100ac525")
local helper_384c5eb1 = require("@lib/event/helper_384c5eb1")
local helper_99d125b7 = require("@lib/event/helper_99d125b7")

--- Helper function.
local function helper_bfb21e10()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 9 then
			if at <= 1 then
				helper_99d125b7(6120390, 60)
			end
			if at <= 2 then
				helper_100ac525(60)
			end
			if at <= 3 then
				helper_99d125b7(6120400, 75)
			end
			if at <= 4 then
				helper_100ac525(30)
			end
			if at <= 5 then
				helper_99d125b7(6120410, -1)
			end
			if at <= 6 then
				helper_384c5eb1(2)
			end
			if at <= 7 then
				helper_100ac525(30)
			end
			if at <= 8 then
				helper_100ac525(30)
			end
			if vm.skip_end() then
				return skip(10)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.DelExtMotion(0)
		event.DeleteChara(8)
		event.DeleteChara(9)
		event.DeleteChara(10)
		event.LoadMes(0, -1)
		event.SetCharaShow(1, 1)
		event.SetCharaShow(2, 1)
		event.SetStatusbarShow(1, 1.0)
	end
	event.SetFlag(612, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.LoadSound(7814)
	var0 = event.SndLoadSound(7814) or var0
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
	event.SetCharaShow(1, 0)
	event.SetCharaShow(2, 0)
	event.EohSetPos(0, 10.61, 0.2, 323.16)
	event.EohSetRot(0, 0.0, -2.93, 0.0)
	event.EohSetMotion(0, "立ち", 4)
	event.EohSetFootSoundId(0, 21)
	event.EohSetPos(1, -10.07, 0.2, 324.55)
	event.EohSetRot(1, 0.0, 3.11, 0.0)
	event.EohSetMotion(1, "立ち", 4)
	event.EohSetFootSoundId(1, 21)
	event.EohSetPos(2, -0.95, 0.2, 164.64)
	event.EohSetRot(2, 0.0, 0.0, 0.0)
	event.EohSetMotion(2, "両手上げＬ", 4)
	event.EohSetFootSoundId(2, 21)
	event.InitDramaScene()
	event.CmrsInit()
	event.CmrsSetPos(0.19, 19.21, 277.15)
	event.CmrsSetRef(-0.04, 20.06, 325.14)
	event.CharaActive(0)
	event.CharaActive(8)
	event.CharaActive(9)
	event.CharaActive(10)
	event.SetFadeIn(30)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おこり顔")
	event.ObjsTexAnime(0, 1, "おこり目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "おこり顔")
	event.ObjsTexAnime(1, 1, "おこり目～おどろき目")
	event.ObjsTexAnime(1, 1, "半口")
	helper_100ac525(30)
	if vm.skipping() then
		return skip(1)
	end
	event.SetPakuAnim(0, "通常口パク")
	helper_99d125b7(6120390, 60)
	if vm.skipping() then
		return skip(2)
	end
	helper_100ac525(60)
	if vm.skipping() then
		return skip(3)
	end
	event.CmrsSetPos(-0.94, 45.01, 219.98)
	event.CmrsSetRef(-0.16, 52.54, 162.81)
	event.SndSePlay(var0, 0)
	event.ObjsSetMotion(2, "両手下ろす", 6)
	event.ObjsNextMotion(2, "立ち", 4)
	helper_99d125b7(6120400, 75)
	if vm.skipping() then
		return skip(4)
	end
	helper_100ac525(30)
	if vm.skipping() then
		return skip(5)
	end
	event.ObjsSetMotion(2, "ククク", 6)
	event.ObjsNextMotion(2, "ククク会話", 4)
	event.ObjsMotionDelay(2, 120)
	event.ObjsNextMotion(2, "クククＬ", 4)
	helper_99d125b7(6120410, -1)
	if vm.skipping() then
		return skip(6)
	end
	helper_384c5eb1(2)
	if vm.skipping() then
		return skip(7)
	end
	event.ObjsSetRot(0, 0.0, 0.0, 0.0)
	event.ObjsSetRot(1, 0.0, 0.0, 0.0)
	event.CmrsSetPos(1.81, 6.92, 260.18)
	event.CmrsSetRef(1.38, 17.89, 324.46)
	event.ObjsSetMotion(0, "走り", 4)
	event.ObjsMove(0, 12.18, 0.2, 569.18, 60, 1)
	event.ObjsSetMotion(1, "走り", 4)
	event.ObjsMove(1, -11.66, 0.2, 564.61, 60, 1)
	helper_100ac525(30)
	if vm.skipping() then
		return skip(8)
	end
	event.SetFadeOut(30)
	helper_100ac525(30)
	if vm.skipping() then
		return skip(9)
	end
	return part2()
end

return helper_bfb21e10
