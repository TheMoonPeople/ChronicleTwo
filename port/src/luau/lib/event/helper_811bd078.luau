--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_19c9cbe6 = require("@lib/event/helper_19c9cbe6")
local helper_40ca6466 = require("@lib/event/helper_40ca6466")
local helper_a8b5d854 = require("@lib/event/helper_a8b5d854")

--- Helper function.
local function helper_811bd078()
	local var0: s32 = 0
	local var1: s32 = 0
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 9 then
			if at <= 1 then
				helper_a8b5d854(210)
			end
			if at <= 2 then
				helper_a8b5d854(30)
			end
			if at <= 3 then
				helper_40ca6466(2)
			end
			if at <= 4 then
				helper_19c9cbe6(6480100)
			end
			if at <= 5 then
				helper_40ca6466(2)
			end
			if at <= 6 then
				helper_19c9cbe6(6480110)
			end
			if at <= 7 then
				helper_40ca6466(1)
			end
			if at <= 8 then
				helper_a8b5d854(30)
			end
			if vm.skip_end() then
				return skip(10)
			end
			return part2()
		end
		if at <= 10 then
			helper_a8b5d854(4)
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SndSeStop(var0, 4)
		event.StopBgm(0)
		helper_a8b5d854(4)
		if vm.skipping() then
			return skip(11)
		end
		var3 = event.GetDefBgmNo(72) or var3
		event.LoadBgm(var3)
		event.PlayBgm(0)
		event.CharaActive(1, var1)
		event.EohSetPos(3, -790, 0.0, 4500)
		event.EohSetRot(3, 0.0, -1.57, 0.0)
		event.EohSetRot(4, 0.0, 0.0, 0.0)
		event.EohSetRot(5, 0.0, 0.0, 0.0)
		event.EohSetRot(6, 0.0, 0.0, 0.0)
		event.EohSetRot(7, 0.0, 0.0, 0.0)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.EohSetFootSoundId(2, 0)
		event.SpriteSetDraw(0, 0)
		event.DelExtMotion(0)
		event.DeleteChara(33)
		event.DeleteChara(34)
		event.DeleteChara(35)
		event.LoadMes(0, -1)
	end
	event.SetFlag(648, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.LoadSound(7815)
	var0 = event.SndLoadSound(7815) or var0
	event.SndSePlay(var0, 0)
	event.SndSeStop(var0, 0)
	var1 = event.SearchCharaNo(301) or var1
	event.CharaActive(0, var1)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.ChangeDir("event/e600/e648/")
	event.LoadMes(0, 5, "e648_1.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e648_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e648_monica.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.LoadChara(5, "e648_osmond.gltf", "info", 35)
	event.CharaActive(35)
	event.EohSyncChara(2, 35)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.EohSyncObj(3, "p01_train01")
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.EohSyncObj(4, "p01_train01", "s3601_12-m")
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.EohSyncObj(5, "p01_train01", "s3601_14-m")
	event.ObjsSyncObj(5, 5)
	event.ObjsSetRot(5, 0.0, 0.0, 0.0)
	event.EohSyncObj(6, "p01_train01", "s3601_16-m")
	event.ObjsSyncObj(6, 6)
	event.ObjsSetRot(6, 0.0, 0.0, 0.0)
	event.EohSyncObj(7, "p01_train01", "s3601_17-m1")
	event.ObjsSyncObj(7, 7)
	event.ObjsSetRot(7, 0.0, 0.0, 0.0)
	event.ChangeDir("")
	if active_chr_no == 1 then
		event.LoadChara(5, "chara/c01_base.gltf", "info", 33)
		event.LoadEquip(5, 0, 4, "info", 33)
		event.LoadEquip(5, 0, 3, "info", 33)
		event.LoadEquip(5, 0, 2, "info", 33, 34)
		event.LoadMotion(5, "event/e600/e648/e648_mints.gltf", "info", 33)
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
		event.LoadMotion(5, "event/e600/e648/e648_monica.gltf", "info", 33)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 33)
		event.EohSyncChara(1, 33)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 0)
	end
	event.CharaActive(33)
	event.CharaActive(34)
	event.EohSetPos(0, 3.38, -9.6, -127.86)
	event.EohSetRot(0, 0.0, 0.03, 0.0)
	event.EohSetMotion(0, "立ち", 4)
	event.EohSetFootSoundId(0, 1)
	event.EohSetPos(1, 19.72, -9.6, -146.14)
	event.EohSetRot(1, 0.0, -0.81, 0.0)
	event.EohSetMotion(1, "立ち", 4)
	event.EohSetFootSoundId(1, 1)
	event.EohSetPos(2, 0.11, -2.82, -96.44)
	event.EohSetRot(2, 0.0, 0.0, 0.0)
	event.EohSetMotion(2, "立ち", 4)
	event.EohSetFootSoundId(2, 1)
	event.EohSetPos(3, 10497.4, 4263.4, 16022.1)
	event.EohSetRot(3, 0.17453292, -2.268928, 0.0)
	event.EohSetRot(4, 0.0, 0.0, 0.0)
	event.EohSetRot(5, 0.0, 0.0, 0.0)
	event.EohSetRot(6, 0.0, 0.0, 0.0)
	event.InitDramaScene()
	event.CmrsInit()
	event.CmrsSetPos(8906.16, 4062.09, 15480.96)
	event.CmrsSetRef(9213.43, 4103.76, 15508.46)
	event.CharaActive(0)
	event.CharaActive(33)
	event.CharaActive(34)
	event.CharaActive(35)
	event.SetFadeIn(30)
	event.ObjsMove(3, -738.8, 0.0, 4490.7, 300)
	event.ObjsRotation(3, 0.0, -2.286, 0.3, 300)
	event.SndSePlay(var0, 4)
	event.CmrsMove(8070.99, 3228.35, 15847.63, 7999.18, 3244.28, 15637.48, 90)
	helper_a8b5d854(120)
	if vm.skipping() then
		return skip(1)
	end
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.CmrsSetPos(-1639.57, 7.86, 5016.61)
	event.CmrsSetRef(-1218.91, 101.0, 4719.94)
	event.ObjsSetPos(3, 1200.0, 237.6, 4500)
	event.ObjsSetRot(3, 0.0, -1.57, 0.0)
	event.ObjsMove(3, -400, 0.0, 4500, 60)
	event.ObjsMove2(3, -990, 0.0, 4500, 90, 2, 0.8)
	helper_a8b5d854(210)
	if vm.skipping() then
		return skip(2)
	end
	event.SetFadeOut(30)
	helper_a8b5d854(30)
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsSetPos(3, -790, 0.0, 4500)
	event.SetFadeIn(30)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おこり顔")
	event.ObjsTexAnime(0, 1, "おこり目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "おこり顔")
	event.ObjsTexAnime(1, 1, "おこり目パチ")
	event.ObjsSetPos(0, -266.3, 0.0, 4342.88)
	event.ObjsSetRot(0, 0.0, -3.13, 0.0)
	event.ObjsSetPos(1, -263.45, 0.0, 4372.15)
	event.ObjsSetRot(1, 0.0, -3.13, 0.0)
	event.ObjsSetPos(2, -241.85, 11.82, 4430.23)
	event.ObjsSetRot(2, 0.0, 3.03, 0.0)
	event.CmrsSetPos(-336.6, 39.36, 4198.84)
	event.CmrsSetRef(-239.26, 60.64, 4423.35)
	event.ObjsSetRot(4, 0.0, 0.0, -1.5707964)
	event.ObjsSetRot(5, 0.0, 0.0, -1.5707964)
	event.ObjsSetRot(6, 0.0, 0.0, 0.3926991)
	event.ObjsSetRot(7, 0.0, 0.0, 0.3926991)
	event.ObjsSetMotion(0, "歩き")
	event.ObjsMove(0, -249.34, 0.0, 4318.43, 60)
	event.ObjsMotionDelay(0, 60)
	event.ObjsSetMotion(0, "立ち")
	event.ObjsSetMotion(1, "歩き")
	event.ObjsMove(1, -277.96, 0.0, 4332.42, 60)
	event.ObjsMotionDelay(1, 60)
	event.ObjsSetMotion(1, "立ち")
	event.ObjsSetMotion(2, "歩き")
	event.ObjsMove(2, -253.46, 0.0, 4397.34, 30)
	event.ObjsMove(2, -252.88, 0.0, 4367.79, 30)
	event.ObjsMotionDelay(2, 60)
	event.ObjsSetMotion(2, "立ち")
	helper_40ca6466(2)
	if vm.skipping() then
		return skip(4)
	end
	event.CmrsSetPos(-130.69, 136.99, 4468.57)
	event.CmrsSetRef(-261.31, 3.53, 4336.64)
	event.ObjsSetPos(0, -235.2, 0.0, 4329.41)
	event.ObjsSetRot(0, 0.0, -0.09, 0.0)
	event.ObjsSetPos(1, -276.84, 0.0, 4326.87)
	event.ObjsSetRot(1, 0.0, 0.39, 0.0)
	event.ObjsSetPos(2, -254.29, 0.0, 4359.67)
	event.ObjsSetRot(2, 0.0, 3.03, 0.0)
	event.ObjsSetMotion(0, "オズ見立ち", 4)
	event.ObjsSetMotion(1, "オズ見", 4)
	event.ObjsSetMotion(2, "立ち（上見）", 6)
	event.ObjsNextMotion(2, "会話（上見）", 6)
	event.ObjsNextMotion(2, "立ち（上見）", 4)
	helper_19c9cbe6(6480100)
	if vm.skipping() then
		return skip(5)
	end
	helper_40ca6466(2)
	if vm.skipping() then
		return skip(6)
	end
	event.ObjsSetMotion(0, "オズ見うなづき", 6)
	event.ObjsNextMotion(0, "オズ見立ち", 6)
	event.ObjsSetMotion(1, "オズ見うなずき", 6)
	event.ObjsNextMotion(1, "オズ見", 6)
	helper_19c9cbe6(6480110)
	if vm.skipping() then
		return skip(7)
	end
	helper_40ca6466(1)
	if vm.skipping() then
		return skip(8)
	end
	event.SetFadeOut(30)
	helper_a8b5d854(30)
	if vm.skipping() then
		return skip(9)
	end
	return part2()
end

return helper_811bd078
