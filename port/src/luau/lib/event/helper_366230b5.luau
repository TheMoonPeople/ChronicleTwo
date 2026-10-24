--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_e2203e72 = require("@lib/event/helper_e2203e72")
local helper_e83cea40 = require("@lib/event/helper_e83cea40")

--- Helper function.
local function helper_366230b5()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 6 then
			if at <= 1 then
				helper_e83cea40(3)
			end
			if at <= 2 then
				helper_e2203e72(60)
			end
			if at <= 3 then
				helper_e2203e72(60)
			end
			if at <= 4 then
				helper_e2203e72(60)
			end
			if at <= 5 then
				helper_e2203e72(30)
			end
			if vm.skip_end() then
				return skip(7)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SndSeStop(var0, 0)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.BgmLoadCancel()
		event.DelExtMotion(0)
		event.DeleteChara(9)
		event.DeleteChara(10)
		event.DeleteChara(11)
		event.DeleteChara(12)
		event.LoadMes(0, -1)
		event.CharaActive(0)
		event.SetCharaPos(0, -1.02, 0.2, 111.04)
		event.SetCharaRot(0, 0.0, 3.11, 0.0)
		event.SetMotion(0, "立ち", 4)
		event.CharaNormalDrive(0)
		event.CharaResetDa(0)
		event.ResetCamera(1, 3.1415927, 10.0)
		event.SetFadeIn(30)
	end
	event.SetFlag(612, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.LoadSound(7813)
	var0 = event.SndLoadSound(7813) or var0
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.ChangeDir("event/e600/e612/")
	event.LoadMes(0, 5, "e612.txt")
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
		event.LoadChara(5, "chara/c01_base.gltf", "info", 9)
		event.LoadEquip(5, 0, 4, "info", 9)
		event.LoadEquip(5, 0, 3, "info", 9)
		event.LoadEquip(5, 0, 2, "info", 9, 10)
		event.LoadMotion(5, "event/e600/e608/e608_mints.gltf", "info", 9)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 9)
		event.EohSyncChara(0, 9)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 0)
	else
		event.LoadChara(5, "chara/c02_base.gltf", "info", 9)
		event.LoadEquip(5, 1, 4, "info", 9)
		event.LoadEquip(5, 1, 3, "info", 9)
		event.LoadEquip(5, 1, 2, "info", 9, 10)
		event.LoadMotion(5, "event/e600/e612/e612_monica.gltf", "info", 9)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 9)
		event.EohSyncChara(1, 9)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 0)
	end
	event.CharaActive(9)
	event.CharaActive(10)
	event.LoadChara(5, "event/e600/e612/e612_ring.gltf", "info", 11)
	event.CharaActive(11)
	event.EohSyncChara(2, 11)
	event.ObjsInit(2, 11)
	event.ObjsSyncObj(2, 2)
	event.LoadChara(5, "event/e600/e612/e612_warp.gltf", "info", 12)
	event.CharaActive(12)
	event.EohSyncChara(3, 12)
	event.ObjsInit(3, 12)
	event.ObjsSyncObj(3, 3)
	event.EohSyncObj(4, "p04_s3501-0")
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.EohSyncObj(5, "p04_s3501-0", "s350208-m0")
	event.ObjsInit(5)
	event.ObjsSyncObj(5, 5)
	event.EohSyncObj(6, "p01_futa-0")
	event.ObjsInit(6)
	event.ObjsSyncObj(6, 6)
	event.EohSetPos(0, 10.61, 0.2, 323.16)
	event.EohSetRot(0, 0.0, -2.93, 0.0)
	event.EohSetMotion(0, "立ち", 4)
	event.EohSetFootSoundId(0, 4)
	event.EohSetPos(1, -10.07, 0.2, 324.55)
	event.EohSetRot(1, 0.0, 3.11, 0.0)
	event.EohSetMotion(1, "立ち", 4)
	event.EohSetFootSoundId(1, 4)
	event.EohSetPos(4, 0.0, 2500.0, 0.0)
	event.EohSetRot(4, 0.0, 0.0, 0.0)
	event.EohSetPos(3, 238.94, 4575.76, 4158.02)
	event.InitDramaScene()
	event.CmrsInit()
	event.CmrsSetPos(247.83, 4647.83, 4298.21)
	event.CmrsSetRef(241.49, 4554.49, 4121.41)
	event.CharaActive(0, 0)
	event.CharaActive(0, 9)
	event.CharaActive(0, 10)
	event.CharaActive(0, 11)
	event.CharaActive(12)
	event.EohSetShow(4, 1)
	event.EohSetShow(5, 1)
	event.EohSetShow(6, 0)
	event.EohSetShow(3, 0)
	event.SetFadeIn(30)
	helper_e2203e72(60)
	if vm.skipping() then
		return skip(1)
	end
	event.SndSePlay(var0, 0)
	event.EohSetShow(3, 1)
	event.ObjsSetMotion(3, "出現", 6)
	event.ObjsNextMotion(3, "ループ", 4)
	event.ObjsMotionWait(3)
	helper_e83cea40(3)
	if vm.skipping() then
		return skip(2)
	end
	helper_e2203e72(60)
	if vm.skipping() then
		return skip(3)
	end
	event.SetCrossfade(30)
	event.EohSetShow(4, 0)
	helper_e2203e72(60)
	if vm.skipping() then
		return skip(4)
	end
	event.SndSeStop(var0, 0)
	event.SetCharaShow(12, 0, 1, 0.033333335)
	helper_e2203e72(60)
	if vm.skipping() then
		return skip(5)
	end
	event.SetFadeOut(30)
	helper_e2203e72(30)
	if vm.skipping() then
		return skip(6)
	end
	return part2()
end

return helper_366230b5
