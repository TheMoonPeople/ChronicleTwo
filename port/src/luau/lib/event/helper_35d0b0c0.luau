--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_40ca6466 = require("@lib/event/helper_40ca6466")
local helper_6018bc39 = require("@lib/event/helper_6018bc39")
local helper_a8b5d854 = require("@lib/event/helper_a8b5d854")

--- Helper function.
local function helper_35d0b0c0()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 9 then
			if at <= 1 then
				helper_a8b5d854(60)
			end
			if at <= 2 then
				helper_6018bc39()
			end
			if at <= 3 then
				helper_a8b5d854(30)
			end
			if at <= 4 then
				helper_a8b5d854(40)
			end
			if at <= 5 then
				helper_40ca6466(4)
			end
			if at <= 6 then
				helper_6018bc39()
			end
			if at <= 7 then
				helper_a8b5d854(90)
			end
			if at <= 8 then
				helper_a8b5d854(32)
			end
			if vm.skip_end() then
				return skip(10)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SetMotionBlur(0)
		event.SndSeStop(var0, 0)
		event.SndSeStop(var0, 1)
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
		event.LoadMes(0, -1)
	end
	event.SetFlag(640, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.StopBgm(0)
	helper_a8b5d854(4)
	if vm.skipping() then
		return skip(1)
	end
	event.LoadBgm(116)
	event.PlayBgm(0)
	event.LoadSound(6211)
	var0 = event.SndLoadSound(6211) or var0
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
	event.EohSetPos(3, 0.0, 1000, -1300)
	event.EohSetRot(3, 0.0, -1.57, 0.0)
	event.EohSetPos(4, -2232.61, 1234.98, -1416.46)
	event.EohSetRot(4, 0.0, -1.44, 0.0)
	event.EohSetShow(4, 0)
	event.InitDramaScene()
	event.SndSePlay(var0, 0)
	event.CharaActive(35)
	event.CharaActive(36)
	event.SetProjection(300.9)
	event.CmrsInit()
	event.CmrsSetPos(-2291.89, 1284.15, -1406.93)
	event.CmrsSetRef(-2337.14, 1275.49, -1390.53)
	event.ObjsSetMotion(2, "停止", 4)
	event.SetFadeIn(30)
	event.CmrsMove(-2285.0, 1284.15, -1409.43, -2337.14, 1275.49, -1390.53, 60)
	helper_a8b5d854(60)
	if vm.skipping() then
		return skip(2)
	end
	helper_6018bc39()
	if vm.skipping() then
		return skip(3)
	end
	event.SetMotionBlur(80)
	event.CmrsMove2(-1614.03, 1599.88, -1752.72, -2376.45, 1138.55, -1294.4, 60, 0, 1.0)
	helper_a8b5d854(30)
	if vm.skipping() then
		return skip(4)
	end
	event.EohSetShow(4, 1)
	event.SndSePlay(var0, 1)
	event.ObjsSetScale(4, 0.5, 0.5, 0.5)
	event.SetCharaShow(35, 1, 1, 0.033333335)
	event.ObjsSetMotion(4, "溜めループ", 4)
	helper_a8b5d854(40)
	if vm.skipping() then
		return skip(5)
	end
	helper_40ca6466(4)
	if vm.skipping() then
		return skip(6)
	end
	helper_6018bc39()
	if vm.skipping() then
		return skip(7)
	end
	helper_a8b5d854(90)
	if vm.skipping() then
		return skip(8)
	end
	event.SetFadeOut(30)
	helper_a8b5d854(32)
	if vm.skipping() then
		return skip(9)
	end
	return part2()
end

return helper_35d0b0c0
