--!strict
-- Shared event helper used by 20 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_25abe6d2 = require("@lib/event/helper_25abe6d2")
local helper_d3f20302 = require("@lib/event/helper_d3f20302")

--- Helper function.
local function helper_fdad3d3b()
	local now_map_no: s32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: s32 = 0
	local var8: f32 = 0
	local var9: s32 = 0
	local var10: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var14: f32 = 0
	local var15: f32 = 0
	local var16: s32 = 0
	local at: number = 0
	return vm.guard(function()
		now_map_no = event.GetNowMapNo() or now_map_no
		event.Initialize()
		event.GetSndId(1)
		var5 = event.GetEventData_2(3) or var5
		event.GetEventData_2(4)
		event.Ext(1035, 8, var1, var2, var3, var4) -- retail: the handler rejects 5 arguments
		print("train_id=", var5, "----------------\n")
		print("fpos[0]=", var1, "---------------\n")
		print("fpos[1]=", var2, "---------------\n")
		print("fpos[2]=", var3, "---------------\n")
		if var3 < 4500.0 then
			var8 = vm.f32(1.5707964)
		else
			var8 = vm.f32(-1.5707964)
		end
		if now_map_no == 76 then
			if var3 < 3600.0 then
				var8 = vm.f32(1.5707964)
			else
				var8 = vm.f32(-1.5707964)
			end
		end
		if now_map_no == 72 then
			if var3 < 4500.0 then
				var8 = vm.f32(1.5707964)
			else
				var8 = vm.f32(-1.5707964)
			end
		end
		if now_map_no == 34 or now_map_no == 16 or now_map_no == 54 then
			var8 = vm.f32(3.1415927)
		end
		if now_map_no == 87 then
			var8 = vm.f32(2.3561945)
		end
		if now_map_no == 83 or now_map_no == 103 then
			var8 = vm.f32(1.5707964)
		end
		event.SetWorldCoord(var1, var2, var3, var8)
		var9 = 0
		if now_map_no == 34 or now_map_no == 54 or now_map_no == 87 or now_map_no == 103 or now_map_no == 76 then
			var9 = 1
		end
		if var5 == 4 then
			event.EohSyncObj_3(2, "p01_train01", "s3601_12-m1")
			if var9 == 0 then
				event.EohSyncObj_3(3, "p01_train01", "s3601_14-m1")
			else
				event.EohSyncObj_3(3, "p01_train01", "s3601_14-m6")
			end
			event.EohSyncObj_3(4, "p01_train01", "s3601_16-m1")
			event.EohSyncObj_3(5, "p01_train01", "s3601_17-m")
			event.SetCnt(0, 1)
		end
		if var5 == 5 then
			event.EohSyncObj_3(2, "p01_train01", "s3601_12-m")
			if var9 == 0 then
				event.EohSyncObj_3(3, "p01_train01", "s3601_14-m")
			else
				event.EohSyncObj_3(3, "p01_train01", "s3601_14-m7")
			end
			event.EohSyncObj_3(4, "p01_train01", "s3601_16-m")
			event.EohSyncObj_3(5, "p01_train01", "s3601_17-m1")
			event.SetCnt(0, 1)
		end
		if var5 == 2 then
			event.EohSyncObj_3(2, "p01_train01", "s3601_12-m5")
			if var9 == 0 then
				event.EohSyncObj_3(3, "p01_train01", "s3601_14-m3")
			else
				event.EohSyncObj_3(3, "p01_train01", "s3601_14-m10")
			end
			event.EohSyncObj_3(4, "p01_train01", "s3601_16-m4")
			event.EohSyncObj_3(5, "p01_train01", "s3601_17-m2")
			event.SetCnt(0, 2)
		end
		if var5 == 3 then
			event.EohSyncObj_3(2, "p01_train01", "s3601_12-m4")
			if var9 == 0 then
				event.EohSyncObj_3(3, "p01_train01", "s3601_14-m2")
			else
				event.EohSyncObj_3(3, "p01_train01", "s3601_14-m11")
			end
			event.EohSyncObj_3(4, "p01_train01", "s3601_16-m2")
			event.EohSyncObj_3(5, "p01_train01", "s3601_17-m3")
			event.SetCnt(0, 2)
		end
		if var5 == 6 then
			event.EohSyncObj_3(2, "p01_train01", "s3601_12-m3")
			if var9 == 0 then
				event.EohSyncObj_3(3, "p01_train01", "s3601_14-m5")
			else
				event.EohSyncObj_3(3, "p01_train01", "s3601_14-m8")
			end
			event.EohSyncObj_3(4, "p01_train01", "s3601_16-m5")
			event.EohSyncObj_3(5, "p01_train01", "s3601_17-m4")
			event.SetCnt(0, 3)
		end
		if var5 == 7 then
			event.EohSyncObj_3(2, "p01_train01", "s3601_12-m2")
			if var9 == 0 then
				event.EohSyncObj_3(3, "p01_train01", "s3601_14-m4")
			else
				event.EohSyncObj_3(3, "p01_train01", "s3601_14-m9")
			end
			event.EohSyncObj_3(4, "p01_train01", "s3601_16-m3")
			event.EohSyncObj_3(5, "p01_train01", "s3601_17-m5")
			event.SetCnt(0, 3)
		end
		var10 = event.GetSndId(2) or var10
		event.SndSePlay(var10, 92)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.ObjsSyncObj(2, 2)
		event.ObjsSetRot(2, 0.0, 0.0, 0.0)
		event.ObjsSyncObj(3, 3)
		event.ObjsSetRot(3, 0.0, 0.0, 0.0)
		event.ObjsSyncObj(4, 4)
		event.ObjsSetRot(4, 0.0, 0.0, 0.0)
		do
			local out1, out2, out3 = event.EohGetPos(5)
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		event.ObjsSyncObj(5, 5)
		event.ObjsSetRot(5, 0.0, 0.0, 0.0)
		event.CmrsInit()
		var14 = 0.0
		var15 = 46.0
		if now_map_no == 34 then
			var14 = vm.f32(35.8)
		end
		if now_map_no == 16 then
			var14 = vm.f32(-7.86)
		end
		if now_map_no == 54 then
			var14 = 36.0
		end
		if now_map_no == 83 then
			var14 = vm.f32(29.22)
		end
		if now_map_no == 87 then
			var14 = -6.0
		end
		if now_map_no == 103 then
			var14 = vm.f32(-13.87)
		end
		if now_map_no == 72 then
			var15 = 30.0
			var14 = vm.f32(0.09)
		end
		if now_map_no == 76 then
			var15 = 30.0
			var14 = vm.f32(0.09)
		end
		if now_map_no == 155 then
			var15 = 30.0
			var14 = vm.f32(0.09)
		end
		event.ObjsSetPos(0, var15, var14, 0.0)
		event.ObjsSetRot(0, 0.0, -1.5707964, 0.0)
		event.ObjsSetMotion(0, "立ち", 4)
		event.ObjsResetDaPosition(0)
		event.CmrsSetPos(148.0, 23.45, -118.4)
		event.CmrsSetRef(5.11, 26.65, 8.6)
		if now_map_no == 34 or now_map_no == 54 then
			event.CmrsSetPos(106.46, 47.9, -133.32)
			event.CmrsSetRef(5.11, 77.95, 8.6)
		end
		if now_map_no == 83 then
			event.CmrsSetPos(148.0, 35.52, -118.4)
			event.CmrsSetRef(5.11, 77.95, 8.6)
		end
		at = 1
		helper_25abe6d2(10)
		if vm.imod(var5, 2) ~= 1 then
			event.ObjsRotation(2, 0.0, 0.0, 1.5707964, 30)
			event.ObjsRotation(3, 0.0, 0.0, 1.5707964, 30)
			if now_map_no == 83 or now_map_no == 54 or now_map_no == 34 then
				at = 2
				helper_25abe6d2(20)
			else
				event.ObjsRotation(4, 0.0, 0.0, -0.3926991, 30)
				event.ObjsRotation(5, 0.0, 0.0, -0.3926991, 30)
				at = 3
				helper_25abe6d2(30)
				if now_map_no == 103 then
					event.ObjsMove(5, pos_x + 45.0, pos_y - 19.0, pos_z, 30)
					at = 4
					helper_25abe6d2(20)
				else
					event.ObjsMove(5, pos_x + 20.0, pos_y - 8.0, pos_z, 20)
					at = 5
					helper_25abe6d2(10)
				end
			end
		else
			event.ObjsRotation(2, 0.0, 0.0, -1.5707964, 30)
			event.ObjsRotation(3, 0.0, 0.0, -1.5707964, 30)
			if now_map_no == 83 or now_map_no == 54 or now_map_no == 34 then
				at = 6
				helper_25abe6d2(20)
			else
				event.ObjsRotation(4, 0.0, 0.0, 0.3926991, 30)
				event.ObjsRotation(5, 0.0, 0.0, 0.3926991, 30)
				at = 7
				helper_25abe6d2(30)
				if now_map_no == 103 then
					event.ObjsMove(5, pos_x - 45.0, pos_y - 19.0, pos_z, 30)
					at = 8
					helper_25abe6d2(20)
				else
					event.ObjsMove(5, pos_x - 20.0, pos_y - 8.0, pos_z, 20)
					at = 9
					helper_25abe6d2(10)
				end
			end
		end
		event.ObjsSetMotion(0, "走り")
		event.ObjsMove(0, -50.0, 30.0, 0.0, 45)
		var16 = 0
		if
			now_map_no == 16
			or now_map_no == 83
			or now_map_no == 87
			or now_map_no == 103
			or now_map_no == 72
			or now_map_no == 76
			or now_map_no == 155
		then
			print("てつのあしおと\n")
			var16 = 6
		end
		if now_map_no == 34 or now_map_no == 54 then
			print("いしのあしおと\n")
			var16 = 2
		end
		event.EohSetFootSoundId(0, var16)
		at = 10
		helper_25abe6d2(30)
		event.SetFadeOut(30)
		at = 11
		helper_25abe6d2(30)
		event.EohSetFootSoundId(0, 0)
		event.EohSetMotion(0, "立ち", 4)
		if vm.imod(var5, 2) ~= 1 then
			event.SetCharaPos(0, 50.0, -14.0, 0.0)
			event.SetCharaRot(0, 0.0, -1.57, 0.0)
		else
			event.SetCharaPos(0, -50.0, -14.0, 0.0)
			event.SetCharaRot(0, 0.0, 1.57, 0.0)
		end
		return
	end, function(received: { any })
		if at <= 11 then
			if at <= 1 then
				helper_d3f20302(20)
			end
			if at <= 2 then
				helper_d3f20302(30)
			end
			if at <= 3 then
				helper_d3f20302(20)
			end
			if at <= 4 then
				helper_d3f20302(10)
			end
			if at <= 5 then
				helper_d3f20302(20)
			end
			if at <= 6 then
				helper_d3f20302(30)
			end
			if at <= 7 then
				helper_d3f20302(20)
			end
			if at <= 8 then
				helper_d3f20302(10)
			end
			if at <= 9 then
				var16 = 0
				print("てつのあしおと\n")
				var16 = 6
				print("いしのあしおと\n")
				var16 = 2
				helper_d3f20302(30)
			end
			if at <= 10 then
				helper_d3f20302(30)
			end
			return 0
		end
		return nil
	end)
end

return helper_fdad3d3b
