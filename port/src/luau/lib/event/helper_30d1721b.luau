--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_bc115506 = require("@lib/event/helper_bc115506")
local helper_c85a55f2 = require("@lib/event/helper_c85a55f2")

--- Helper function.
local function helper_30d1721b()
	local active_chr_no: s32 = 0
	local var1: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 4 then
			if at <= 1 then
				helper_bc115506(5360100)
			end
			if at <= 2 then
				helper_bc115506(5360110)
			end
			if at <= 3 then
				helper_c85a55f2(30)
			end
			if vm.skip_end() then
				return skip(5)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SndSeStop(var1, 2)
		event.SetStatus(1, 0, 256, 0)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.DelExtMotion(0)
		event.DeleteChara(8)
		event.DeleteChara(9)
		event.DelImg(0)
		event.LoadMes(0, -1)
		event.SetStatusbarShow(1, 1.0)
		event.EohSetShow(4, 1)
		event.EohSetShow(5, 1)
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
	event.LoadSound(5825)
	var1 = event.SndLoadSound(5825) or var1
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
		event.EohSyncChara(1, 8)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 0)
	end
	event.CharaActive(8)
	event.CharaActive(9)
	event.EohSyncChara(4, 1)
	event.EohSyncChara(5, 2)
	event.EohSetShow(4, 0)
	event.EohSetShow(5, 0)
	event.EohSetPos(0, -9.0, 0.0, 100.0)
	event.EohSetRot(0, 0.0, 3.02, 0.0)
	event.EohSetMotion(0, "立ち", 4)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "無表情")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	event.EohSetPos(1, 9.0, 0.0, 100.0)
	event.EohSetRot(1, 0.0, -3.02, 0.0)
	event.EohSetMotion(1, "立ち", 4)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "おこり顔")
	event.EohSetTexAnim(1, 1, "おこり目パチ")
	event.InitDramaScene()
	event.CmrsInit()
	event.CmrsSetPos(0.0, 18.65, 43.37)
	event.CmrsSetRef(0.0, 15.13, 108.54)
	event.SetFadeIn(30)
	helper_c85a55f2(30)
	if vm.skipping() then
		return skip(1)
	end
	event.ObjsSetMotion(1, "許せない", 6)
	event.ObjsNextMotion(1, "許せないL", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_bc115506(5360100)
	if vm.skipping() then
		return skip(2)
	end
	event.ObjsSetMotion(0, "右向く", 6)
	event.ObjsNextMotion(0, "右向くL", 4)
	event.ObjsSeDelay(0, 10)
	event.ObjsSePlay(0, var1, 10)
	event.SetPakuAnim(0, "通常口パク")
	helper_bc115506(5360110)
	if vm.skipping() then
		return skip(3)
	end
	event.SetFadeOut(30)
	helper_c85a55f2(30)
	if vm.skipping() then
		return skip(4)
	end
	return part2()
end

return helper_30d1721b
