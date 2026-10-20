--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_41c448af = require("@lib/event/helper_41c448af")
local helper_474c5bc8 = require("@lib/event/helper_474c5bc8")
local helper_6e062c19 = require("@lib/event/helper_6e062c19")

--- Helper function.
local function helper_6c885b04()
	local var0: s32 = 0
	local rot_x: f32 = 0
	local rot_y: f32 = 0
	local var3: f32 = 0
	local vector_x: f32 = 0
	local vector_y: f32 = 0
	local vector_z: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 7 then
			if at <= 1 then
				var3 = vm.f32(vector_z - vm.f32(3.1415927))
				helper_41c448af(1)
			end
			if at <= 2 then
				helper_474c5bc8(20)
			end
			if at <= 3 then
				helper_41c448af(3)
			end
			if at <= 4 then
				helper_41c448af(0)
			end
			if at <= 5 then
				helper_41c448af(3)
			end
			if at <= 6 then
				helper_41c448af(1)
			end
			if vm.skip_end() then
				return skip(8)
			end
			return part2()
		end
		helper_6e062c19(-75.0, -10.0, 950.0, vm.f32(3.1415927))
	end
	function part2()
		event.CancelDramaScene()
		event.SndSeStop(var0, 1)
		if vm.wait() then
			return skip(9)
		end
		event.EohSetRot(1, vector_x, vector_y, vector_z)
		event.EohSetPos(3, pos_x, pos_y, pos_z)
		event.EohSetShow(4, 1)
		event.EohSetShow(5, 1)
		helper_6e062c19(-75.0, -10.0, 950.0, vm.f32(3.1415927))
		event.SetCameraPos(-75.0, 50.0, 1030.0)
		event.SetCameraRef(-75.0, 20.0, 950.0)
		event.ResetCamera(0)
		event.SetCrossfade(30)
		event.Finish()
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	var0 = event.SndLoadSound(8, "snd2/sp/sp_033.sound.json") or var0
	event.CharaActive(0)
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.EohSyncObj(1, "p06_s19", "s19_09-m1")
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.EohSyncObj(3, "p06_s19", "s19_10-m1")
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.EohSyncChara(4, 1)
	event.EohSyncChara(5, 2)
	event.EohSetShow(4, 0)
	event.EohSetShow(5, 0)
	event.EohSetPos(0, -75.0, -35.0, 1200.0)
	event.EohSetRot(0, 0.0, 3.1415927, 0.0)
	event.EohSetMotion(0, "立ち", 4)
	event.EohResetDaPosition(0)
	event.EohSetFootSoundId(0, 7)
	event.CmrsInit()
	event.CmrsSetPos(-127.01131, -7.1499996, 911.04)
	event.CmrsSetRef(-62.911304, 39.29, 1129.9199)
	event.CmrsFadeInit()
	event.InitDramaScene()
	event.SetFadeIn(30)
	event.SndSePlay(var0, 1)
	do
		local out1, out2, out3 = event.EohGetRot(1)
		rot_x = out1 or rot_x
		rot_y = out2 or rot_y
		var3 = out3 or var3
	end
	do
		local out1, out2, out3 = event.CopyVector(rot_x, rot_y, var3)
		vector_x = out1 or vector_x
		vector_y = out2 or vector_y
		vector_z = out3 or vector_z
	end
	do
		local out1, out2, out3 = event.EohGetPos(3)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	var3 = vm.f32(vector_z - vm.f32(3.1415927))
	var3 = event.AngleLimit(var3) or var3
	event.ObjsRotation2(1, rot_x, rot_y, var3, 40, 0, 0.5)
	helper_41c448af(1)
	if vm.skipping() then
		return skip(2)
	end
	event.ObjsMove2(3, pos_x, pos_y + 80.0, pos_z, 32, 1, 0.5)
	helper_474c5bc8(20)
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsSetMotion(0, "走り")
	event.ObjsMove(0, -75.0, -35.0, 1055.0, 30)
	event.EohSetFootSoundId(0, 16)
	helper_41c448af(3)
	if vm.skipping() then
		return skip(4)
	end
	event.ObjsMove2(3, pos_x, pos_y, pos_z, 32, 0, 0.5)
	helper_41c448af(0)
	if vm.skipping() then
		return skip(5)
	end
	event.ObjsSetMotion(0, "立ち")
	event.ObjsMotionDelay(0, 30)
	event.ObjsPosDelay(0, 30)
	event.ObjsSetMotion(0, "歩き")
	event.ObjsMove(0, -75.0, -25.0, 1015.0, 40)
	event.ObjsMotionDelay(0, 40)
	event.ObjsSetMotion(0, "立ち")
	helper_41c448af(3)
	if vm.skipping() then
		return skip(6)
	end
	event.EohSetFootSoundId(0, 0)
	event.ObjsRotation2(1, vector_x, vector_y, vector_z, 40, 0, 0.5)
	helper_41c448af(1)
	if vm.skipping() then
		return skip(7)
	end
	return part2()
end

return helper_6c885b04
