--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_40ca6466 = require("@lib/event/helper_40ca6466")
local helper_6018bc39 = require("@lib/event/helper_6018bc39")
local helper_a8b5d854 = require("@lib/event/helper_a8b5d854")

--- Helper function.
local function helper_4be5b965()
	local var0: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 8 then
			if at <= 1 then
				helper_6018bc39()
			end
			if at <= 2 then
				helper_a8b5d854(4)
			end
			if at <= 3 then
				helper_40ca6466(2)
			end
			if at <= 4 then
				helper_40ca6466(0)
			end
			if at <= 5 then
				helper_a8b5d854(20)
			end
			if at <= 6 then
				helper_40ca6466(0)
			end
			if at <= 7 then
				helper_a8b5d854(4)
			end
			if vm.skip_end() then
				return skip(9)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SndSeStop(var0, 0)
		event.SetStatusbarShow(1, 1.0)
		event.SetCharaPos(0, 840.81, -49.72, -161.41)
		event.SetCharaRot(0, 0.0, -1.32, 0.0)
		event.SetMotion(0, "立ち", 4)
		event.CharaNormalDrive(0)
		event.EohResetDaPosition(0)
		event.EohSyncObj(2, "p02_d01b01", "d01b01_9-m0")
		event.EohSetPos(2, 0.0, 0.0, 0.0)
		event.SetCameraPos(969.7, -14.72, -202.32)
		event.SetCameraRef(817.46, -19.72, -153.11)
		event.ResetCamera(0)
		event.SetFadeIn(0)
		event.Finish()
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	event.SetStatusbarShow(0, 1.0)
	var0 = event.SndLoadSound(8, "snd2/sp/sp_030.sound.json") or var0
	event.AssignStack(5)
	event.ClearStack(5)
	event.CharaActive(0)
	event.EohSyncChara(0, 0)
	event.EohSetFootSoundId(0, 2)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetPos(0, 1006.26, -27.71, -200.0)
	event.ObjsSetRot(0, 0.0, -1.32, 0.0)
	event.ObjsSetMotion(0, "立ち", 4)
	event.EohSyncObj(2, "p02_d01b01", "d01b01_9-m0")
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.ObjsSetPos(2, 0.0, 0.0, 0.0)
	event.EohSyncObj(3, "p01_d01b01", "d01b01_2-a")
	event.EohSetShow(3, 0)
	event.ObjsMove(2, 0.0, 80.0, 0.0, 60)
	event.ObjsJump(2, 0.0, 0.0, 0.0, -0.2, 10)
	event.ObjsJump(2, 0.0, 0.0, 0.0, -0.8, 8)
	event.ObjsJump(2, 0.0, 0.0, 0.0, -0.4, 5)
	event.SndSePlay(var0, 1)
	event.InitDramaScene()
	event.CmrsInit()
	event.CmrsSetPos(800.55, 83.98, -20.2)
	event.CmrsSetRef(868.65, 40.42, -105.22)
	event.CmrsFadeInit()
	event.CmrsFadeIn(30)
	helper_6018bc39()
	if vm.skipping() then
		return skip(2)
	end
	helper_a8b5d854(4)
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsSetMotion(0, "走り")
	event.ObjsMotionDelay(0, 40)
	event.ObjsSetMotion(0, "立ち")
	event.ObjsMove(0, 962.88, -27.71, -191.57, 15)
	event.ObjsMove(0, 928.6, -49.72, -185.79, 15)
	event.ObjsMove(0, 904.87, -49.72, -180.71, 10)
	helper_40ca6466(2)
	if vm.skipping() then
		return skip(4)
	end
	helper_40ca6466(0)
	if vm.skipping() then
		return skip(5)
	end
	event.SetStatusbarShow(1)
	helper_a8b5d854(20)
	if vm.skipping() then
		return skip(6)
	end
	event.CmrsSetPos(969.7, -14.72, -202.32)
	event.CmrsSetRef(817.46, -19.72, -153.11)
	event.ObjsSetPos(0, 880.95, -49.72, -173.03)
	event.ObjsSetRot(0, 0.0, -1.32, 0.0)
	event.ObjsResetDaPosition(0)
	event.ObjsSetMotion(0, "歩き")
	event.ObjsMove(0, 840.81, -49.72, -161.41, 30)
	helper_40ca6466(0)
	if vm.skipping() then
		return skip(7)
	end
	event.ObjsSetMotion(0, "立ち")
	helper_a8b5d854(4)
	if vm.skipping() then
		return skip(8)
	end
	return part2()
end

return helper_4be5b965
