--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_09b9430e = require("@lib/event/helper_09b9430e")
local helper_7eebaa1d = require("@lib/event/helper_7eebaa1d")
local helper_bdbefa67 = require("@lib/event/helper_bdbefa67")
local helper_c14e497f = require("@lib/event/helper_c14e497f")
local helper_dabc0c0a = require("@lib/event/helper_dabc0c0a")

--- Helper function.
local function helper_7168a501()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 16 then
			if at <= 1 then
				helper_bdbefa67(60)
			end
			if at <= 2 then
				helper_09b9430e(6040010, 150)
			end
			if at <= 3 then
				helper_09b9430e(6040020, 240)
			end
			if at <= 4 then
				helper_09b9430e(6040030, 240)
			end
			if at <= 5 then
				helper_bdbefa67(20)
			end
			if at <= 6 then
				helper_7eebaa1d(1)
			end
			if at <= 7 then
				helper_09b9430e(6040040, -1)
			end
			if at <= 8 then
				helper_bdbefa67(15)
			end
			if at <= 9 then
				helper_c14e497f(6040050)
			end
			if at <= 10 then
				helper_7eebaa1d(1)
			end
			if at <= 11 then
				helper_bdbefa67(30)
			end
			if at <= 12 then
				helper_bdbefa67(120)
			end
			if at <= 13 then
				helper_c14e497f(6040060)
			end
			if at <= 14 then
				helper_c14e497f(6040070)
			end
			if at <= 15 then
				helper_bdbefa67(30)
			end
			if vm.skip_end() then
				return skip(17)
			end
			return part2()
		end
		helper_dabc0c0a(0.0, vm.f32(140.7), -770.0, vm.f32(3.14))
	end
	function part2()
		event.CancelDramaScene()
		event.SndSeStop(var0, 0)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.EohSetRot(2, 0.0, 0.61, 0.0)
		event.EohSetRot(3, 0.0, -0.61, 0.0)
		event.DelExtMotion(0)
		event.DeleteChara(33)
		event.DeleteChara(34)
		event.LoadMes(0, -1)
		helper_dabc0c0a(0.0, vm.f32(140.7), -770.0, vm.f32(3.14))
		event.ResetCamera(1, 3.1415927, 10.0)
		event.SetFadeIn(30)
	end
	event.SetFlag(604, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.StopBgm(0)
	helper_bdbefa67(4)
	if vm.skipping() then
		return skip(1)
	end
	event.LoadBgm(51)
	event.PlayBgm(0)
	event.LoadSound(7803)
	var0 = event.SndLoadSound(7803) or var0
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.ChangeDir("event/e600/e604/")
	event.LoadMes(0, 5, "e604_1.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e604_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e604_monica.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.ChangeDir("")
	if active_chr_no == 1 then
		event.LoadChara(5, "chara/c01_base.gltf", "info", 33)
		event.LoadEquip(5, 0, 4, "info", 33)
		event.LoadEquip(5, 0, 3, "info", 33)
		event.LoadEquip(5, 0, 2, "info", 33, 34)
		event.LoadMotion(5, "event/e600/e604/e604_mints.gltf", "info", 33)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 33)
		event.EohSyncChara(0, 33)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 0)
	else
		event.LoadChara(5, "chara/c02_base.gltf", "info", 33)
		event.LoadEquip(5, 1, 4, "info", 33)
		event.LoadEquip(5, 1, 3, "info", 33)
		event.LoadEquip(5, 1, 2, "info", 33, 34)
		event.LoadMotion(5, "event/e600/e604/e604_monica.gltf", "info", 33)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 33)
		event.EohSyncChara(1, 33)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 0)
	end
	event.CharaActive(33)
	event.CharaActive(34)
	event.EohSyncObj(2, "p01_s3302-0", "s330208-m0")
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.EohSyncObj(3, "p01_s3302-0", "s330208-m1")
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.EohSetPos(0, 14.06, 0.0, -283.76)
	event.EohSetRot(0, 0.0, -3.09, 0.0)
	event.EohSetMotion(0, "立ち", 4)
	event.EohSetFootSoundId(0, 2)
	event.EohSetPos(1, -22.57, 0.0, -283.73)
	event.EohSetRot(1, 0.0, -3.09, 0.0)
	event.EohSetMotion(1, "立ち", 4)
	event.EohSetFootSoundId(1, 2)
	event.EohSetRot(2, 0.0, 0.0, 0.0)
	event.EohSetRot(3, 0.0, 0.0, 0.0)
	event.InitDramaScene()
	event.CmrsInit()
	event.CmrsSetPos(-1409.3, 33.17, 699.45)
	event.CmrsSetRef(-1317.3, 207.26, 35.03)
	event.CharaActive(0)
	event.CharaActive(33)
	event.CharaActive(34)
	event.ObjsSetMotion(0, "歩き")
	event.ObjsMove(0, 14.06, 0.0, -588.5, 540, 1)
	event.ObjsSetMotion(1, "歩き")
	event.ObjsMove(1, -22.57, 0.0, -588.26, 540, 1)
	event.SetFadeIn(30)
	event.CmrsMove(1340.45, 33.17, 781.09, 1266.94, 207.26, 116.17, 450)
	helper_bdbefa67(60)
	if vm.skipping() then
		return skip(2)
	end
	helper_09b9430e(6040010, 150)
	if vm.skipping() then
		return skip(3)
	end
	helper_09b9430e(6040020, 240)
	if vm.skipping() then
		return skip(4)
	end
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetPos(1, -13.05, 82.65, -581.69)
	event.ObjsSetRot(1, 0.0, -3.09, 0.0)
	event.ObjsResetDaPosition(1)
	event.ObjsSetPos(0, 10.82, 82.79, -581.79)
	event.ObjsSetRot(0, 0.0, -3.09, 0.0)
	event.ObjsResetDaPosition(0)
	event.SetCrossfade(30)
	event.CmrsSetPos(-1.05, 107.16, -512.55)
	event.CmrsSetRef(-0.34, 115.06, -632.94)
	event.ObjsMove(1, -11.66, 140.66, -709.98, 260, 1)
	event.ObjsMove(0, 11.57, 140.66, -707.0, 260, 1)
	helper_09b9430e(6040030, 240)
	if vm.skipping() then
		return skip(5)
	end
	helper_bdbefa67(20)
	if vm.skipping() then
		return skip(6)
	end
	helper_7eebaa1d(1)
	if vm.skipping() then
		return skip(7)
	end
	event.CmrsSetPos(1.24, 142.22, -872.19)
	event.CmrsSetRef(1.67, 177.22, -765.97)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おこり顔")
	event.ObjsTexAnime(0, 1, "おこり目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "おこり顔")
	event.ObjsTexAnime(1, 1, "おこり目パチ")
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetPos(1, -8.87, 140.66, -739.81)
	event.ObjsSetRot(1, 0.0, 3.07, 0.0)
	event.ObjsResetDaPosition(1)
	event.ObjsSetPos(0, 12.17, 140.66, -739.07)
	event.ObjsSetRot(0, 0.0, -3.09, 0.0)
	event.ObjsResetDaPosition(0)
	event.ObjsMove(1, -9.09, 140.66, -794.9, 120, 1)
	event.ObjsMove(0, 11.95, 140.66, -793.78, 120, 1)
	event.ObjsMotionDelay(0, 120)
	event.ObjsSetMotion(0, "立ち")
	event.ObjsMotionDelay(1, 120)
	event.ObjsSetMotion(1, "立ち")
	event.SetPakuAnim(0, "通常口パク")
	helper_09b9430e(6040040, -1)
	if vm.skipping() then
		return skip(8)
	end
	helper_bdbefa67(15)
	if vm.skipping() then
		return skip(9)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_c14e497f(6040050)
	if vm.skipping() then
		return skip(10)
	end
	helper_7eebaa1d(1)
	if vm.skipping() then
		return skip(11)
	end
	event.CmrsSetPos(-0.36, 446.02, 122.03)
	event.CmrsSetRef(3.18, 151.42, -826.58)
	event.ObjsSetPos(1, -22.1, 140.66, -908.82)
	event.ObjsSetRot(1, 0.0, 2.95, 0.0)
	event.ObjsResetDaPosition(1)
	event.ObjsSetPos(0, 13.59, 140.66, -906.11)
	event.ObjsSetRot(0, 0.0, -2.97, 0.0)
	event.ObjsResetDaPosition(0)
	helper_bdbefa67(30)
	if vm.skipping() then
		return skip(12)
	end
	event.SndSePlay(var0, 0)
	event.ObjsRotation(2, 0.0, 0.61, 0.0, 60)
	event.ObjsRotation(3, 0.0, -0.61, 0.0, 60)
	helper_bdbefa67(120)
	if vm.skipping() then
		return skip(13)
	end
	event.ObjsSetMotion(1, "右向く", 6)
	event.ObjsNextMotion(1, "右向く会話", 4)
	event.ObjsNextMotion(1, "右向くL", 4)
	event.ObjsMotionDelay(0, 60)
	event.ObjsSetMotion(0, "左向く", 6)
	event.ObjsNextMotion(0, "左向くL", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_c14e497f(6040060)
	if vm.skipping() then
		return skip(14)
	end
	event.ObjsMotionDelay(1, 30)
	event.ObjsSetMotion(1, "右向くうなづき", 6)
	event.ObjsNextMotion(1, "右向くL", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_c14e497f(6040070)
	if vm.skipping() then
		return skip(15)
	end
	event.SetFadeOut(30)
	helper_bdbefa67(30)
	if vm.skipping() then
		return skip(16)
	end
	return part2()
end

return helper_7168a501
