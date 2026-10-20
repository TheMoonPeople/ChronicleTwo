--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_a8b5d854 = require("@lib/event/helper_a8b5d854")

--- Helper function.
local function helper_e4774d08(arg0: s32)
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var11: s32 = 0
	local var14: s32 = 0
	local now_map_no: s32 = 0
	local var16: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			print("train_id=", var11, "----------------\n")
			print("fpos[0]=", string.format("%f", var1), "---------------\n")
			print("fpos[1]=", string.format("%f", var2), "---------------\n")
			print("fpos[2]=", string.format("%f", var3), "---------------\n")
			print("train_id=", var11, "---------------\n")
			var4 = vm.f32(5.51)
			var5 = vm.f32(19.05)
			var6 = vm.f32(19.05)
			var14 = 6
			var4 = 19.75
			var5 = 19.75
			var6 = 19.75
			var14 = 2
			var4 = vm.f32(14.049999)
			var5 = vm.f32(17.05)
			var6 = vm.f32(22.05)
			var14 = 3
			var4 = vm.f32(20.55)
			var5 = vm.f32(20.55)
			var6 = vm.f32(22.05)
			var14 = 2
			var7 = vm.f32(-3.1415927)
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
	event.GetSndId(1)
	var11 = event.GetEventData_2(3) or var11
	event.GetEventData_2(4)
	event.Ext(1035, 8, var1, var2, var3, var7) -- retail: the handler rejects 5 arguments
	print("train_id=", var11, "----------------\n")
	print("fpos[0]=", string.format("%f", var1), "---------------\n")
	print("fpos[1]=", string.format("%f", var2), "---------------\n")
	print("fpos[2]=", string.format("%f", var3), "---------------\n")
	print("train_id=", var11, "---------------\n")
	event.SetWorldCoord(var1, var2, var3, var7)
	event.EohSyncObj(0, "p01_train01")
	do
		local out1, out2, out3 = event.EohGetPos(0)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	if arg0 ~= 0 then
		var4 = vm.f32(5.51)
		var5 = vm.f32(19.05)
		var6 = vm.f32(19.05)
		var14 = 6
	else
		var4 = 19.75
		var5 = 19.75
		var6 = 19.75
		var14 = 2
		now_map_no = event.GetNowMapNo() or now_map_no
		if now_map_no == 83 then
			var4 = vm.f32(14.049999)
			var5 = vm.f32(17.05)
			var6 = vm.f32(22.05)
			event.EohSetPos(0, pos_x, pos_y - 2.0, pos_z)
			var14 = 3
		end
		if now_map_no == 54 then
			var4 = vm.f32(20.55)
			var5 = vm.f32(20.55)
			var6 = vm.f32(22.05)
			var14 = 2
		end
	end
	if vm.imod(var11, 2) ~= 1 then
		var7 = vm.f32(-3.1415927)
	end
	if var11 == 2 then
		event.EohSyncObj(1, "p01_train01", "train08-m0")
		event.EohSyncObj(2, "p01_train01", "train08-m1")
		event.EohSyncObj(3, "p01_train01", "train10-m0")
		event.EohSyncObj(4, "p01_train01", "train10-m1")
		event.EohSyncObj(5, "p01_train01", "train10-m12")
		event.EohSyncObj(6, "p01_train01", "train10-m13")
		event.SetCnt(0, 1)
	end
	if var11 == 3 then
		event.EohSyncObj(1, "p01_train01", "train08-m2")
		event.EohSyncObj(2, "p01_train01", "train08-m3")
		event.EohSyncObj(3, "p01_train01", "train10-m3")
		event.EohSyncObj(4, "p01_train01", "train10-m2")
		event.EohSyncObj(5, "p01_train01", "train10-m15")
		event.EohSyncObj(6, "p01_train01", "train10-m14")
		event.SetCnt(0, 1)
	end
	if var11 == 4 then
		event.EohSyncObj(1, "p01_train01", "train08-m4")
		event.EohSyncObj(2, "p01_train01", "train08-m5")
		event.EohSyncObj(3, "p01_train01", "train10-m4")
		event.EohSyncObj(4, "p01_train01", "train10-m5")
		event.EohSyncObj(5, "p01_train01", "train10-m16")
		event.EohSyncObj(6, "p01_train01", "train10-m17")
		event.SetCnt(0, 2)
	end
	if var11 == 5 then
		event.EohSyncObj(1, "p01_train01", "train08-m6")
		event.EohSyncObj(2, "p01_train01", "train08-m7")
		event.EohSyncObj(3, "p01_train01", "train10-m6")
		event.EohSyncObj(4, "p01_train01", "train10-m7")
		event.EohSyncObj(5, "p01_train01", "train10-m18")
		event.EohSyncObj(6, "p01_train01", "train10-m19")
		event.SetCnt(0, 2)
	end
	if var11 == 6 then
		event.EohSyncObj(1, "p01_train01", "train08-m8")
		event.EohSyncObj(2, "p01_train01", "train08-m9")
		event.EohSyncObj(3, "p01_train01", "train10-m8")
		event.EohSyncObj(4, "p01_train01", "train10-m9")
		event.EohSyncObj(5, "p01_train01", "train10-m20")
		event.EohSyncObj(6, "p01_train01", "train10-m21")
		event.SetCnt(0, 3)
	end
	if var11 == 7 then
		event.EohSyncObj(1, "p01_train01", "train08-m10")
		event.EohSyncObj(2, "p01_train01", "train08-m11")
		event.EohSyncObj(3, "p01_train01", "train10-m10")
		event.EohSyncObj(4, "p01_train01", "train10-m11")
		event.EohSyncObj(5, "p01_train01", "train10-m22")
		event.EohSyncObj(6, "p01_train01", "train10-m23")
		event.SetCnt(0, 3)
	end
	var16 = event.GetSndId(2) or var16
	event.SndSePlay(var16, 66)
	if vm.imod(var11, 2) ~= 1 then
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.ObjsSetPos(0, 12.08, var4, 0.42)
		event.ObjsSetRot(0, 0.0, -1.5015928, 0.0)
		event.ObjsSetMotion(0, "立ち", 4)
		event.ObjsResetDaPosition(0)
		event.ObjsSyncObj(1, 1)
		event.ObjsSetRot(1, 0.0, 0.0, 0.0)
		event.ObjsSyncObj(2, 2)
		event.ObjsSetRot(2, 0.0, 0.0, 0.0)
		event.ObjsSyncObj(3, 3)
		event.ObjsSetRot(3, 0.0, 0.0, 0.0)
		event.ObjsSyncObj(4, 4)
		event.ObjsSetRot(4, 0.0, 0.0, 0.0)
		event.ObjsSyncObj(5, 5)
		event.ObjsSetRot(5, 0.0, 0.0, 0.0)
		event.ObjsSyncObj(6, 6)
		event.ObjsSetRot(6, 0.0, 0.0, 0.0)
		event.CmrsInit()
		event.CmrsSetPos(124.87, 46.06, -74.18)
		event.CmrsSetRef(-3.0, 50.74, 0.18)
		helper_a8b5d854(10)
		if vm.skipping() then
			return skip(2)
		end
		event.ObjsRotation(1, 0.0, 1.5, 0.0, 30)
		event.ObjsRotation(2, 0.0, -1.5, 0.0, 30)
		event.ObjsRotation(3, 0.0, 1.5, 0.0, 30)
		event.ObjsRotation(4, 0.0, -1.5, 0.0, 30)
		event.ObjsRotation(5, 0.0, 1.5, 0.0, 30)
		event.ObjsRotation(6, 0.0, -1.5, 0.0, 30)
		helper_a8b5d854(20)
		if vm.skipping() then
			return skip(3)
		end
		event.ObjsSetMotion(0, "歩き")
		event.ObjsMove(0, -5.04, var5, 0.84, 30)
		event.ObjsMove(0, -33.49, var6, -0.56, 30)
		event.EohSetFootSoundId(0, var14)
		helper_a8b5d854(18)
		if vm.skipping() then
			return skip(4)
		end
		event.EohSetFootSoundId(0, 4)
		helper_a8b5d854(12)
		if vm.skipping() then
			return skip(5)
		end
		event.SetFadeOut(30)
		helper_a8b5d854(30)
		if vm.skipping() then
			return skip(6)
		end
		event.EohSetMotion(0, "立ち", 4)
	else
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.ObjsSetPos(0, -12.08, var4, -0.42)
		event.ObjsSetRot(0, 0.0, 1.64, 0.0)
		event.ObjsSetMotion(0, "立ち", 4)
		event.ObjsResetDaPosition(0)
		event.ObjsSyncObj(1, 1)
		event.ObjsSetRot(1, 0.0, 0.0, 0.0)
		event.ObjsSyncObj(2, 2)
		event.ObjsSetRot(2, 0.0, 0.0, 0.0)
		event.ObjsSyncObj(3, 3)
		event.ObjsSetRot(3, 0.0, 0.0, 0.0)
		event.ObjsSyncObj(4, 4)
		event.ObjsSetRot(4, 0.0, 0.0, 0.0)
		event.ObjsSyncObj(5, 5)
		event.ObjsSetRot(5, 0.0, 0.0, 0.0)
		event.ObjsSyncObj(6, 6)
		event.ObjsSetRot(6, 0.0, 0.0, 0.0)
		event.CmrsInit()
		event.CmrsSetPos(-124.87, 46.06, 74.18)
		event.CmrsSetRef(3.0, 50.74, -0.18)
		helper_a8b5d854(10)
		if vm.skipping() then
			return skip(7)
		end
		event.ObjsRotation(1, 0.0, -1.5, 0.0, 30)
		event.ObjsRotation(2, 0.0, 1.5, 0.0, 30)
		event.ObjsRotation(3, 0.0, -1.5, 0.0, 30)
		event.ObjsRotation(4, 0.0, 1.5, 0.0, 30)
		event.ObjsRotation(5, 0.0, -1.5, 0.0, 30)
		event.ObjsRotation(6, 0.0, 1.5, 0.0, 30)
		helper_a8b5d854(20)
		if vm.skipping() then
			return skip(8)
		end
		event.ObjsSetMotion(0, "歩き")
		event.ObjsMove(0, 5.04, var5, -0.84, 30)
		event.ObjsMove(0, 33.49, var6, 0.56, 30)
		event.EohSetFootSoundId(0, var14)
		helper_a8b5d854(18)
		if vm.skipping() then
			return skip(9)
		end
		event.EohSetFootSoundId(0, 4)
		helper_a8b5d854(12)
		if vm.skipping() then
			return skip(10)
		end
		event.SetFadeOut(30)
		helper_a8b5d854(30)
		if vm.skipping() then
			return skip(11)
		end
		event.EohSetMotion(0, "立ち", 4)
	end
	if vm.imod(var11, 2) ~= 1 then
		event.SetCharaPos(0, 65.0, 36.0, 0.0)
		event.SetCharaRot(0, 0.0, -1.57, 0.0)
	else
		event.SetCharaPos(0, -65.0, 36.0, 0.0)
		event.SetCharaRot(0, 0.0, 1.57, 0.0)
	end
	event.EohSetFootSoundId(0, 0)
	event.EohSyncObj(0, "p01_train01")
	event.EohSetPos(0, pos_x, pos_y, pos_z)
end

return helper_e4774d08
