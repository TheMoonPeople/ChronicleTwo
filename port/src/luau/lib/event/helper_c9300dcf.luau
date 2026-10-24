--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_40ca6466 = require("@lib/event/helper_40ca6466")
local helper_6018bc39 = require("@lib/event/helper_6018bc39")
local helper_a8b5d854 = require("@lib/event/helper_a8b5d854")

--- Helper function.
local function helper_c9300dcf()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 10 then
			if at <= 1 then
				helper_a8b5d854(60)
			end
			if at <= 2 then
				helper_6018bc39()
			end
			if at <= 3 then
				helper_a8b5d854(10)
			end
			if at <= 4 then
				helper_a8b5d854(30)
			end
			if at <= 5 then
				helper_a8b5d854(30)
			end
			if at <= 6 then
				helper_40ca6466(7)
			end
			if at <= 7 then
				helper_40ca6466(6)
			end
			if at <= 8 then
				helper_a8b5d854(90)
			end
			if at <= 9 then
				helper_a8b5d854(30)
			end
			if vm.skip_end() then
				return skip(11)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SndSeStop(var0, 1)
		event.SndSeStop(var0, 2)
		event.SndSeStop(var0, 3)
		event.BgmLoadCancel()
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
		event.DeleteChara(37)
		event.DeleteChara(38)
		event.DeleteChara(39)
		event.LoadMes(0, -1)
	end
	event.SetFlag(640, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.LoadSound(6214)
	var0 = event.SndLoadSound(6214) or var0
	event.SndSePlay(var0, 0)
	event.SndSeStop(var0, 0)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.SetStatus(1, 0, 256, 1)
	event.ChangeDir("event/e600/e640/")
	event.LoadMes(0, 5, "e640_1.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e640_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e640_monica.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.LoadChara(5, "e640_paz.gltf", "info", 34)
	event.CharaActive(34)
	event.EohSyncChara(2, 34)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.LoadChara(5, "e640_canon_tame.gltf", "info", 35)
	event.CharaActive(35)
	event.EohSyncChara(4, 35)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.LoadChara(5, "e640_canon_f.gltf", "info", 36)
	event.CharaActive(36)
	event.EohSyncChara(5, 36)
	event.ObjsInit(5)
	event.ObjsSyncObj(5, 5)
	event.LoadChara(5, "e640_canon_l.gltf", "info", 37)
	event.CharaActive(37)
	event.EohSyncChara(6, 37)
	event.ObjsInit(6)
	event.ObjsSyncObj(6, 6)
	event.LoadChara(5, "e640_bakuha.gltf", "info", 38)
	event.CharaActive(38)
	event.EohSyncChara(7, 38)
	event.ObjsInit(7)
	event.ObjsSyncObj(7, 7)
	event.LoadChara(5, "e520_dsmoke.gltf", "info", 39)
	event.CharaActive(39)
	event.EohSyncChara(8, 39)
	event.ObjsInit(8)
	event.ObjsSyncObj(8, 8)
	event.LoadChara(5, "e640_canon_hit.gltf", "info", 40)
	event.CharaActive(40)
	event.EohSyncChara(9, 40)
	event.ObjsInit(9)
	event.ObjsSyncObj(9, 9)
	event.ChangeDir("")
	if active_chr_no == 1 then
		event.LoadChara(5, "chara/c01_base.gltf", "info", 32)
		event.LoadEquip(5, 0, 4, "info", 32)
		event.LoadEquip(5, 0, 3, "info", 32)
		event.LoadEquip(5, 0, 2, "info", 32, 33)
		event.LoadMotion(5, "event/e600/e640/e640_mints.gltf", "info", 32)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 32)
		event.EohSyncChara(0, 32)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 0)
	else
		event.LoadChara(5, "chara/c02_base.gltf", "info", 32)
		event.LoadEquip(5, 1, 4, "info", 32)
		event.LoadEquip(5, 1, 3, "info", 32)
		event.LoadEquip(5, 1, 2, "info", 32, 33)
		event.LoadMotion(5, "event/e600/e640/e640_monica.gltf", "info", 32)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 32)
		event.EohSyncChara(1, 32)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 0)
	end
	event.CharaActive(32)
	event.CharaActive(33)
	event.EohSyncObj(3, "p01_s3202-0")
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.EohSetPos(0, 0.0, 0.0, 0.0)
	event.EohSetRot(0, 0.0, 3.14, 0.0)
	event.EohSetPos(1, 0.0, 0.0, 0.0)
	event.EohSetRot(1, 0.0, 3.14, 0.0)
	event.EohSetPos(2, -2358.27, 1170.91, -1391.1)
	event.EohSetRot(2, 0.0, 1.56, 0.0)
	event.EohSetFootSoundId(2, 2)
	event.EohSetPos(3, 0.0, 1370, -1300)
	event.EohSetRot(3, 0.0, -1.57, 0.0)
	event.EohSetPos(4, -2189.43, 1149.66, -1389.39)
	event.EohSetRot(4, 0.0, -1.44, 0.0)
	event.EohSetShow(4, 1)
	event.EohSetPos(6, -2189.43, 1149.66, -1389.39)
	event.EohSetRot(6, 0.0, 1.32, 0.0)
	event.EohSetPos(5, -2189.43, 1149.66, -1389.39)
	event.EohSetRot(5, 0.0, 1.32, 0.0)
	event.EohSetPos(7, -325.09, 1202.56, -892.41)
	event.EohSetRot(7, 0.0, 0.0, 0.0)
	event.EohSetPos(9, -314.09, 1223.48, -967.31)
	event.EohSetRot(9, 0.0, -3.0, 0.0)
	event.EohSetPos(8, -45.9, 1026.5, -828.85)
	event.EohSetRot(8, 0.0, 0.52, 0.0)
	event.EohSetShow(6, 0)
	event.EohSetShow(5, 0)
	event.EohSetShow(7, 0)
	event.EohSetShow(9, 0)
	event.EohSetShow(8, 0)
	event.EohSetShow(4, 1)
	event.EohSetShow(2, 1)
	event.ObjsSetScale(4, 0.5, 0.5, 0.5)
	event.InitDramaScene()
	event.CharaActive(35)
	event.CharaActive(36)
	event.SetProjection(300.9)
	event.CmrsInit()
	event.CmrsSetPos(-1677.05, 1017.96, -1557.33)
	event.CmrsSetRef(-1863.01, 1063.39, -1486.17)
	event.ObjsSetMotion(2, "停止", 4)
	event.SetFadeIn(30)
	event.SndSePlay(var0, 0)
	helper_a8b5d854(60)
	if vm.skipping() then
		return skip(1)
	end
	event.ObjsSetMotion(4, "溜めループ", 4)
	event.SetCharaShow(35, 0, 1, 0.033333335)
	event.EohSetShow(6, 1)
	event.ObjsSetScale(6, 0.25, 0.25, 0.25)
	event.ObjsSetMotion(6, "入り", 6)
	event.ObjsNextMotion(6, "ループ", 4)
	event.EohSetShow(5, 1)
	event.ObjsSetScale(5, 0.25, 0.25, 0.25)
	event.ObjsSetMotion(5, "ループ", 6)
	event.ObjsMove2(2, -2463.39, 1170.91, -1448.84, 30, 1, 1.0)
	event.ObjsMove2(6, -2296.79, 1152.74, -1475.26, 30, 1, 1.0)
	event.ObjsMove2(5, -2463.39, 1170.91, -1448.84, 30, 1, 1.0)
	helper_a8b5d854(60)
	if vm.skipping() then
		return skip(2)
	end
	event.CmrsSetPos(-3044.87, 1164.83, -2170.89)
	event.CmrsSetRef(-3170.32, 1170.41, -2119.82)
	event.ObjsSetScale(6, 0.5, 0.5, 0.5)
	event.EohSetShow(2, 0)
	event.ObjsSetMotion(6, "入り", 6)
	event.ObjsNextMotion(6, "ループ", 4)
	event.ObjsSetPos(6, -6304.6, 1300.32, -2393.76)
	event.CmrsMove(-3421.59, 997.54, -2490.81, -2784.35, 1176.71, -2019.57, 30)
	helper_6018bc39()
	if vm.skipping() then
		return skip(3)
	end
	helper_a8b5d854(10)
	if vm.skipping() then
		return skip(4)
	end
	event.EohSetShow(9, 1)
	event.ObjsSetMotion(9, "ヒット", 6)
	event.SndSePlay(var0, 5)
	helper_a8b5d854(30)
	if vm.skipping() then
		return skip(5)
	end
	event.SndSePlay(var0, 1)
	event.CmrsQuake(8.5, 10.0, 0.0, 30)
	event.EohSetShow(7, 1)
	event.ObjsSetMotion(7, "月花宮殿左爆破", 6)
	helper_a8b5d854(30)
	if vm.skipping() then
		return skip(6)
	end
	event.ObjsSetScale(8, 0.5, 0.5, 0.5)
	event.SetCharaShow(39, 1, 1, 0.033333335)
	event.ObjsSetMotion(8, "ｴﾌｪｸﾄ_ﾃﾞｽｱｰｸ煙")
	event.ObjsMotionDelay(6, 60)
	event.ObjsSetMotion(6, "戻り", 6)
	event.ObjsMove2(3, 0.0, 500, -1800, 300, 1, 1.0)
	event.ObjsRotation2(3, -0.19198622, -2.1991148, -0.21816616, 300, 2, 1.0)
	event.SndSePlay(var0, 2)
	event.ObjsMove2(8, 0.0, 500, -1800, 300, 1, 1.0)
	event.SetCrossfade(30)
	event.CmrsSetPos(-27.77, 739.23, -2227.49)
	event.CmrsSetRef(84.65, 1080.59, -1657.97)
	event.ObjsMotionWait(7)
	helper_40ca6466(7)
	if vm.skipping() then
		return skip(7)
	end
	event.EohSetShow(7, 0)
	event.ObjsMotionWait(6)
	helper_40ca6466(6)
	if vm.skipping() then
		return skip(8)
	end
	event.EohSetShow(6, 0)
	helper_a8b5d854(90)
	if vm.skipping() then
		return skip(9)
	end
	event.SetFadeOut(30)
	helper_a8b5d854(30)
	if vm.skipping() then
		return skip(10)
	end
	return part2()
end

return helper_c9300dcf
