--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_a8b5d854 = require("@lib/event/helper_a8b5d854")

--- Helper function.
local function helper_b90e1607()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var6: f32 = 0
	local var7: s32 = 0
	local var8: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var6 = vm.f32(-3.1415927)
			helper_a8b5d854(10)
		end
		if at <= 2 then
			helper_a8b5d854(20)
		end
		if at <= 3 then
			helper_a8b5d854(18)
		end
		if at <= 4 then
			helper_a8b5d854(12)
		end
		if at <= 5 then
			helper_a8b5d854(30)
		end
		if at <= 6 then
			helper_a8b5d854(10)
		end
		if at <= 7 then
			helper_a8b5d854(20)
		end
		if at <= 8 then
			helper_a8b5d854(18)
		end
		if at <= 9 then
			helper_a8b5d854(12)
		end
		if at <= 10 then
			helper_a8b5d854(30)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	var8 = event.GetSndId(1) or var8
	var7 = event.GetEventData_2(3) or var7
	event.GetEventData_2(4)
	event.Ext(1035, 8, var0, var1, var2, var6) -- retail: the handler rejects 5 arguments
	event.SetWorldCoord(var0, var1, var2, var6)
	if vm.imod(var7, 2) ~= 1 then
		var6 = vm.f32(-3.1415927)
	end
	if var7 == 0 then
		event.EohSyncObj(1, "p01_train01", "train11-m0")
		event.EohSyncObj(2, "p01_train01", "train12-m0")
		event.EohSyncObj(3, "p01_train01", "train12-m2")
		event.SetCnt(0, 0)
	end
	if var7 == 1 then
		event.EohSyncObj(1, "p01_train01", "train11-m1")
		event.EohSyncObj(2, "p01_train01", "train12-m1")
		event.EohSyncObj(3, "p01_train01", "train12-m3")
		event.SetCnt(0, 0)
	end
	var8 = event.GetSndId(2) or var8
	event.SndSePlay(var8, 66)
	if vm.imod(var7, 2) ~= 1 then
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.ObjsSetPos(0, -14.25, 1.38, 0.55)
		event.ObjsSetRot(0, 0.0, -1.5, 0.0)
		event.ObjsSetMotion(0, "立ち", 4)
		event.ObjsResetDaPosition(0)
		event.ObjsSyncObj(1, 1)
		event.ObjsSetRot(1, 0.0, 0.0, 0.0)
		event.ObjsSyncObj(2, 2)
		event.ObjsSetRot(2, 0.0, 0.0, 0.0)
		event.ObjsSyncObj(3, 3)
		event.ObjsSetRot(3, 0.0, 0.0, 0.0)
		event.CmrsInit()
		event.CmrsSetPos(124.87, 22.53, -74.18)
		event.CmrsSetRef(-3.0, 27.21, 0.18)
		helper_a8b5d854(10)
		if vm.skipping() then
			return skip(2)
		end
		event.ObjsRotation(1, 0.0, -4.9415927, 0.0, 30)
		event.ObjsRotation(2, 0.0, -4.9415927, 0.0, 30)
		event.ObjsRotation(3, 0.0, -4.9415927, 0.0, 30)
		helper_a8b5d854(20)
		if vm.skipping() then
			return skip(3)
		end
		event.ObjsSetMotion(0, "歩き")
		event.ObjsMove(0, -29.1, 1.38, -0.82, 30)
		event.ObjsMove(0, -50.41, 1.38, 0.05, 30)
		event.EohSetFootSoundId(0, 6)
		helper_a8b5d854(18)
		if vm.skipping() then
			return skip(4)
		end
		event.EohSetFootSoundId(0, 3)
		helper_a8b5d854(12)
		if vm.skipping() then
			return skip(5)
		end
		event.SetFadeOut(30)
		helper_a8b5d854(30)
		if vm.skipping() then
			return skip(6)
		end
		event.EohSetMotion(0, "歩き", 4)
	else
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.ObjsSetPos(0, 14.25, 1.38, -0.55)
		event.ObjsSetRot(0, 0.0, -4.641593, 0.0)
		event.ObjsSetMotion(0, "立ち", 4)
		event.ObjsResetDaPosition(0)
		event.ObjsSyncObj(1, 1)
		event.ObjsSetRot(1, 0.0, 0.0, 0.0)
		event.ObjsSyncObj(2, 2)
		event.ObjsSetRot(2, 0.0, 0.0, 0.0)
		event.ObjsSyncObj(3, 3)
		event.ObjsSetRot(3, 0.0, 0.0, 0.0)
		event.CmrsInit()
		event.CmrsSetPos(-124.87, 22.53, 74.18)
		event.CmrsSetRef(3.0, 27.21, -0.18)
		helper_a8b5d854(10)
		if vm.skipping() then
			return skip(7)
		end
		event.ObjsRotation(1, 0.0, -1.8, 0.0, 30)
		event.ObjsRotation(2, 0.0, -1.8, 0.0, 30)
		event.ObjsRotation(3, 0.0, -1.8, 0.0, 30)
		helper_a8b5d854(20)
		if vm.skipping() then
			return skip(8)
		end
		event.ObjsSetMotion(0, "歩き")
		event.ObjsMove(0, 29.1, 1.38, 0.82, 30)
		event.ObjsMove(0, 50.41, 1.38, -0.05, 30)
		event.EohSetFootSoundId(0, 6)
		helper_a8b5d854(18)
		if vm.skipping() then
			return skip(9)
		end
		event.EohSetFootSoundId(0, 3)
		helper_a8b5d854(12)
		if vm.skipping() then
			return skip(10)
		end
		event.SetFadeOut(30)
		helper_a8b5d854(30)
		if vm.skipping() then
			return skip(11)
		end
		event.EohSetMotion(0, "歩き", 4)
	end
	event.SetMotion(0, "立ち", 4)
	if vm.imod(var7, 2) ~= 1 then
		event.SetCharaPos(0, 47.2, 25.3, -65.0)
		event.SetCharaRot(0, 0.0, -1.57, 0.0)
	else
		event.SetCharaPos(0, -47.2, 25.3, -65.0)
		event.SetCharaRot(0, 0.0, 1.57, 0.0)
	end
	event.EohSetFootSoundId(0, 0)
	event.SetFadeIn(15)
end

return helper_b90e1607
