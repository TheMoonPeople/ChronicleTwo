--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_a0e17f3c = require("@lib/event/helper_a0e17f3c")
local helper_a19c5ee3 = require("@lib/event/helper_a19c5ee3")
local helper_fa57afea = require("@lib/event/helper_fa57afea")

--- Helper function.
local function helper_a217b2b5()
	local active_chr_no: s32 = 0
	local var1: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 12 then
			if at <= 1 then
				helper_fa57afea(8200010)
			end
			if at <= 2 then
				helper_a19c5ee3(2)
			end
			if at <= 3 then
				helper_a0e17f3c(30)
			end
			if at <= 4 then
				helper_fa57afea(8200020)
			end
			if at <= 5 then
				helper_fa57afea(8200030)
			end
			if at <= 6 then
				helper_fa57afea(8200040)
			end
			if at <= 7 then
				helper_fa57afea(8200045)
			end
			if at <= 8 then
				helper_a19c5ee3(0)
			end
			if at <= 9 then
				helper_fa57afea(8200050)
			end
			if at <= 10 then
				helper_a19c5ee3(1)
			end
			if at <= 11 then
				helper_a0e17f3c(30)
			end
			if vm.skip_end() then
				return skip(13)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SndSeStop(var1, 0)
		event.SpriteSetDraw(0, 0)
		event.SetMotionBlur(0)
		event.SetStatus(1, 0, 256, 0)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.DelExtMotion(0)
		event.DeleteChara(8)
		event.DeleteChara(9)
		event.DeleteChara(10)
		event.LoadMes(0, -1)
		event.CharaActive(1, 0)
		event.SetStatusbarShow(1, 1.0)
		event.SetCharaShow(1, 1)
		event.SetCharaShow(2, 1)
		event.Finish()
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFlag(820, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.SetStatusbarShow(0, 1.0)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.StopBgm(0)
	event.LoadSound(8811)
	var1 = event.SndLoadSound(8811) or var1
	event.SetStatus(1, 0, 256, 1)
	event.ChangeDir("event/e800/e820/")
	event.LoadMes(0, 5, "e820_1.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e820_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e820_monica.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.LoadChara(5, "e820_majin.gltf", "info", 10)
	event.CharaActive(10)
	event.EohSyncChara(2, 10)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.ChangeDir("")
	if active_chr_no == 1 then
		event.LoadChara(5, "chara/c01_base.gltf", "info", 8)
		event.LoadEquip(5, 0, 4, "info", 8)
		event.LoadEquip(5, 0, 3, "info", 8)
		event.LoadEquip(5, 0, 2, "info", 8, 9)
		event.LoadMotion(5, "event/e800/e816/e816_mints.gltf", "info", 8)
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
		event.LoadMotion(5, "event/e800/e816/e816_monica.gltf", "info", 8)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 8)
		event.EohSyncChara(1, 8)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 0)
	end
	event.CharaActive(8)
	event.CharaActive(9)
	event.SetCharaShow(1, 0)
	event.SetCharaShow(2, 0)
	event.EohSetPos(0, -125.17, 0.0, -85.85)
	event.EohSetRot(0, 0.0, -1.68, 0.0)
	event.EohSetMotion(0, "立ち", 4)
	event.EohSetFootSoundId(0, 2)
	event.EohSetPos(1, -128.34, 0.0, -68.5)
	event.EohSetRot(1, 0.0, -1.92, 0.0)
	event.EohSetMotion(1, "立ち", 4)
	event.EohSetFootSoundId(1, 2)
	event.EohSetPos(2, -352.78, 0.0, -122.42)
	event.EohSetRot(2, 0.0, 0.72, 0.0)
	event.EohSetScale(2, 8.0, 8.0, 8.0)
	event.InitDramaScene()
	event.ObjsSetMotion(2, "縮む", 6)
	event.ObjsMotionWait(2)
	event.CmrsInit()
	event.CmrsSetPos(-95.35, 412.01, -39.79)
	event.CmrsSetRef(-253.9, 198.62, -86.06)
	event.SndSePlay(var1, 0)
	event.SetFadeIn(30)
	helper_fa57afea(8200010)
	if vm.skipping() then
		return skip(2)
	end
	helper_a19c5ee3(2)
	if vm.skipping() then
		return skip(3)
	end
	helper_a0e17f3c(30)
	if vm.skipping() then
		return skip(4)
	end
	event.CmrsSetPos(-57.24, 82.46, -60.42)
	event.CmrsSetRef(-126.19, 22.03, -77.1)
	event.CmrsMove2(-57.24, 4.84, -60.42, -126.19, 22.03, -77.1, 90, 0, 1.0)
	helper_fa57afea(8200020)
	if vm.skipping() then
		return skip(5)
	end
	helper_fa57afea(8200030)
	if vm.skipping() then
		return skip(6)
	end
	helper_fa57afea(8200040)
	if vm.skipping() then
		return skip(7)
	end
	event.ObjsSetMotion(0, "左向く", 6)
	event.ObjsNextMotion(0, "左向く会話", 6)
	event.ObjsNextMotion(0, "左向くL", 4)
	helper_fa57afea(8200045)
	if vm.skipping() then
		return skip(8)
	end
	helper_a19c5ee3(0)
	if vm.skipping() then
		return skip(9)
	end
	event.ObjsSetMotion(1, "右向く", 6)
	event.ObjsNextMotion(1, "右向くL", 4)
	helper_fa57afea(8200050)
	if vm.skipping() then
		return skip(10)
	end
	helper_a19c5ee3(1)
	if vm.skipping() then
		return skip(11)
	end
	event.SetFadeOut(30)
	helper_a0e17f3c(30)
	if vm.skipping() then
		return skip(12)
	end
	return part2()
end

return helper_a217b2b5
