--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_e2203e72 = require("@lib/event/helper_e2203e72")
local helper_e83cea40 = require("@lib/event/helper_e83cea40")

--- Helper function.
local function helper_6c2bab62()
	local var0: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 13 then
			if at <= 1 then
				helper_e2203e72(90)
			end
			if at <= 2 then
				helper_e2203e72(90)
			end
			if at <= 3 then
				helper_e2203e72(90)
			end
			if at <= 4 then
				helper_e2203e72(30)
			end
			if at <= 5 then
				helper_e83cea40(6)
			end
			if at <= 6 then
				helper_e2203e72(5)
			end
			if at <= 7 then
				helper_e2203e72(60)
			end
			if at <= 8 then
				helper_e2203e72(90)
			end
			if at <= 9 then
				helper_e83cea40(2)
			end
			if at <= 10 then
				helper_e2203e72(60)
			end
			if at <= 11 then
				helper_e2203e72(60)
			end
			if at <= 12 then
				helper_e2203e72(30)
			end
			if vm.skip_end() then
				return skip(14)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SndSeStop(var0, 2)
		event.SndSeStop(var0, 3)
		event.SndSeStop(var0, 4)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.BgmLoadCancel()
		event.DeleteChara(10)
		event.DeleteChara(12)
		event.DeleteChara(13)
		event.DelImg(0)
		event.EsmClear()
		event.CharaActive(0)
	end
	event.SetFlag(612, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.LoadSound(7811)
	var0 = event.SndLoadSound(7811) or var0
	event.AssignStack(5)
	event.ClearStack(5)
	event.GetActiveChrNo()
	event.CharaActive(0, 0)
	event.LoadChara(5, "event/e600/e612/e612_ring.gltf", "info", 10)
	event.CharaActive(10)
	event.EohSyncChara(2, 10)
	event.ObjsInit(2, 10)
	event.ObjsSyncObj(2, 2)
	event.LoadChara(5, "event/e600/e612/e612_gkemuri.gltf", "info", 12)
	event.CharaActive(12)
	event.EohSyncChara(4, 12)
	event.ObjsInit(4, 12)
	event.ObjsSyncObj(4, 4)
	event.LoadChara(5, "event/e600/e612/e612_kemuriloop.gltf", "info", 13)
	event.CharaActive(13)
	event.EohSyncChara(5, 13)
	event.ObjsInit(5, 13)
	event.ObjsSyncObj(5, 5)
	event.EohSyncObj(6, "p04_s3501-0")
	event.ObjsInit(6)
	event.ObjsSyncObj(6, 6)
	event.EohSyncObj(7, "p04_s3501-0", "s350208-m0")
	event.ObjsInit(7)
	event.ObjsSyncObj(7, 7)
	event.EohSyncObj(8, "p01_futa-0")
	event.ObjsInit(8)
	event.ObjsSyncObj(8, 8)
	event.EohSetPos(0, 10.61, 0.2, 323.16)
	event.EohSetRot(0, 0.0, -2.93, 0.0)
	event.EohSetMotion(0, "立ち", 4)
	event.EohSetFootSoundId(0, 4)
	event.EohSetPos(1, -10.07, 0.2, 324.55)
	event.EohSetRot(1, 0.0, 3.11, 0.0)
	event.EohSetMotion(1, "立ち", 4)
	event.EohSetFootSoundId(1, 4)
	event.EohSetPos(6, 0.0, 0.0, 0.0)
	event.EohSetRot(6, 0.0, 0.0, 0.0)
	event.EohSetPos(2, -52.79, 2920.04, -410.3)
	event.EohSetPos(4, 0.0, 0.0, -100.0)
	event.EohSetRot(4, 0.0, 0.0, 0.0)
	event.ObjsSetScale(4, 0.75, 0.75, 1.0)
	event.EohSetPos(5, 0.0, -200, 50.0)
	event.EohSetRot(5, 0.0, 0.0, 0.0)
	event.ObjsSetScale(5, 2.5, 2.5, 2.5)
	event.InitDramaScene()
	event.CmrsInit()
	event.CmrsSetPos(17.39, 578.98, 1943.68)
	event.CmrsSetRef(9.3, 341.68, 745.79)
	event.CharaActive(10)
	event.EohSetShow(6, 1)
	event.EohSetShow(7, 0)
	event.EohSetShow(8, 1)
	event.EohSetShow(2, 0)
	event.EohSetShow(4, 0)
	event.SetFadeIn(30)
	event.CmrsQuake(1.0, 2.0, 0.0, -1)
	event.SndSePlay(var0, 2)
	helper_e2203e72(90)
	if vm.skipping() then
		return skip(1)
	end
	event.EohSetShow(4, 1)
	event.ObjsSetMotion(4, "煙", 6)
	helper_e2203e72(90)
	if vm.skipping() then
		return skip(2)
	end
	event.EohSetShow(8, 0)
	helper_e2203e72(90)
	if vm.skipping() then
		return skip(3)
	end
	helper_e2203e72(90)
	if vm.skipping() then
		return skip(4)
	end
	helper_e2203e72(30)
	if vm.skipping() then
		return skip(5)
	end
	event.SndSePlay(var0, 3)
	event.ObjsMove2(6, 0.0, 500.0, 0.0, 250, 1, 0.7)
	event.ObjsMove2(6, 0.0, 2500.0, 0.0, 300, 0, 0.7)
	event.ObjsMove2(5, 0.0, 400.0, 80.0, 250, 1, 0.7)
	event.ObjsMove2(5, 0.0, 2400.0, 80.0, 300, 0, 0.7)
	event.CmrsMove2(19.32, 820.6, 2081.69, 10.34, 650.48, 751.26, 250, 1, 0.7)
	event.CmrsMove2(19.15, 1031.57, 2204.36, 9.37, 2011.74, 756.14, 300, 0, 0.7)
	helper_e83cea40(6)
	if vm.skipping() then
		return skip(6)
	end
	event.CmrsInit()
	event.CmrsSetPos(-375.96, 2538.91, 959.94)
	event.CmrsSetRef(-223.29, 2724.85, 329.08)
	event.SndSeStop(var0, 2)
	helper_e2203e72(5)
	if vm.skipping() then
		return skip(7)
	end
	event.SndSePlay(var0, 4)
	event.EohSetShow(2, 1)
	event.ObjsSetMotion(2, "出現", 6)
	event.ObjsSetStep(2, 0.1)
	event.ObjsNextMotion(2, "ループ", 6)
	event.ObjsSetStep(2, 0.2)
	event.ObjsNextMotion(2, "消える", 6)
	event.ObjsMotionWait(2)
	helper_e2203e72(60)
	if vm.skipping() then
		return skip(8)
	end
	event.EohSetShow(7, 1)
	helper_e2203e72(90)
	if vm.skipping() then
		return skip(9)
	end
	event.SndSeStop(var0, 4)
	helper_e83cea40(2)
	if vm.skipping() then
		return skip(10)
	end
	event.EohSetShow(2, 0)
	helper_e2203e72(60)
	if vm.skipping() then
		return skip(11)
	end
	event.CmrsSetPos(257.8, 2727.64, 4512.24)
	event.CmrsSetRef(248.05, 2708.02, 4303.95)
	helper_e2203e72(60)
	if vm.skipping() then
		return skip(12)
	end
	event.SetFadeOut(30)
	helper_e2203e72(30)
	if vm.skipping() then
		return skip(13)
	end
	return part2()
end

return helper_6c2bab62
