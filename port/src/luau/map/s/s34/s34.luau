--!strict
-- map/s/s34/s34.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_038a2e4d = require("@lib/event/helper_038a2e4d")
local helper_0e547894 = require("@lib/event/helper_0e547894")
local helper_1ef0d4b2 = require("@lib/event/helper_1ef0d4b2")
local helper_35e14f02 = require("@lib/event/helper_35e14f02")
local helper_7511c466 = require("@lib/event/helper_7511c466")
local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")
local helper_93cb8168 = require("@lib/event/helper_93cb8168")
local helper_946c0402 = require("@lib/event/helper_946c0402")
local helper_9dafbc83 = require("@lib/event/helper_9dafbc83")
local helper_bdaf51ab = require("@lib/event/helper_bdaf51ab")
local helper_c8870924 = require("@lib/event/helper_c8870924")
local helper_cf15df04 = require("@lib/event/helper_cf15df04")
local helper_d7295df9 = require("@lib/event/helper_d7295df9")
local helper_dfad229b = require("@lib/event/helper_dfad229b")
local helper_e9ab25fd = require("@lib/event/helper_e9ab25fd")

--- Event 99, which map data, a script or the engine runs by number.
local function event_99()
	print("map_init-------------------------\n")
end

--- Helper function.
local function helper_17000()
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
		helper_888ab2a3(10)
		if vm.imod(var5, 2) ~= 1 then
			event.ObjsRotation(2, 0.0, 0.0, 1.5707964, 30)
			event.ObjsRotation(3, 0.0, 0.0, 1.5707964, 30)
			if now_map_no == 83 or now_map_no == 54 or now_map_no == 34 then
				at = 2
				helper_888ab2a3(20)
			else
				event.ObjsRotation(4, 0.0, 0.0, -0.3926991, 30)
				event.ObjsRotation(5, 0.0, 0.0, -0.3926991, 30)
				at = 3
				helper_888ab2a3(30)
				if now_map_no == 103 then
					event.ObjsMove(5, pos_x + 45.0, pos_y - 19.0, pos_z, 30)
					at = 4
					helper_888ab2a3(20)
				else
					event.ObjsMove(5, pos_x + 20.0, pos_y - 8.0, pos_z, 20)
					at = 5
					helper_888ab2a3(10)
				end
			end
		else
			event.ObjsRotation(2, 0.0, 0.0, -1.5707964, 30)
			event.ObjsRotation(3, 0.0, 0.0, -1.5707964, 30)
			if now_map_no == 83 or now_map_no == 54 or now_map_no == 34 then
				at = 6
				helper_888ab2a3(20)
			else
				event.ObjsRotation(4, 0.0, 0.0, 0.3926991, 30)
				event.ObjsRotation(5, 0.0, 0.0, 0.3926991, 30)
				at = 7
				helper_888ab2a3(30)
				if now_map_no == 103 then
					event.ObjsMove(5, pos_x - 45.0, pos_y - 19.0, pos_z, 30)
					at = 8
					helper_888ab2a3(20)
				else
					event.ObjsMove(5, pos_x - 20.0, pos_y - 8.0, pos_z, 20)
					at = 9
					helper_888ab2a3(10)
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
		helper_888ab2a3(30)
		event.SetFadeOut(30)
		at = 11
		helper_888ab2a3(30)
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
				helper_038a2e4d(20)
			end
			if at <= 2 then
				helper_038a2e4d(30)
			end
			if at <= 3 then
				helper_038a2e4d(20)
			end
			if at <= 4 then
				helper_038a2e4d(10)
			end
			if at <= 5 then
				helper_038a2e4d(20)
			end
			if at <= 6 then
				helper_038a2e4d(30)
			end
			if at <= 7 then
				helper_038a2e4d(20)
			end
			if at <= 8 then
				helper_038a2e4d(10)
			end
			if at <= 9 then
				var16 = 0
				print("てつのあしおと\n")
				var16 = 6
				print("いしのあしおと\n")
				var16 = 2
				helper_038a2e4d(30)
			end
			if at <= 10 then
				helper_038a2e4d(30)
			end
			return 0
		end
		return nil
	end)
end

--- Helper function.
local function helper_23600000()
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var5: s32 = 0
	print("train_id=", var5, "----------------\n")
	print("fpos[0]=", var1, "---------------\n")
	print("fpos[1]=", var2, "---------------\n")
	print("fpos[2]=", var3, "---------------\n")
	helper_038a2e4d(10)
	helper_038a2e4d(20)
	helper_038a2e4d(30)
	helper_038a2e4d(20)
	helper_038a2e4d(10)
	helper_038a2e4d(20)
	helper_038a2e4d(30)
	helper_038a2e4d(20)
	helper_038a2e4d(10)
	print("てつのあしおと\n")
	print("いしのあしおと\n")
	helper_038a2e4d(30)
	helper_038a2e4d(30)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

script.event_99 = event_99

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	local mc_load: s32 = 0
	local old_map_no: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local at: number = 0
	return vm.guard(function()
		event.Initialize()
		event_99()
		print("start_event--------------------------------------------\n")
		mc_load = event.CheckMcLoad() or mc_load
		if mc_load == 1 then
			helper_35e14f02()
			helper_9dafbc83(vm.f32(94.2), vm.f32(140.4), vm.f32(2842.4), 0.0)
			event.ResetCamera(1, 0.0, 20.0)
			event.SetFadeIn(30)
		else
			old_map_no = event.GetOldMapNo() or old_map_no
			var2 = event.GetMapType(old_map_no) or var2
			if var2 ~= -1 then
				if old_map_no == 4 or old_map_no == 109 then
					helper_35e14f02()
					helper_9dafbc83(0.0, vm.f32(189.2), 2630.0, 0.0)
					event.ResetCamera(1, 3.14, 20.0)
					event.SetFadeIn(30)
				else
					var3 = event.GetCnt(1) or var3
					if
						(old_map_no == 18 or old_map_no == 23 or old_map_no == 120 or old_map_no == 108)
						and var3 == 9
					then
						helper_35e14f02()
						at = 1
						helper_c8870924()
						helper_946c0402()
						event.SetFadeIn(15)
						event.ResetCamera(1, 0.0)
					else
						at = 2
						helper_dfad229b()
						helper_35e14f02()
					end
				end
			end
			event.SetMotion(0, "立ち")
		end
		return
	end, function(received: { any })
		if at <= 2 then
			if at == 1 then
			end
			if at <= 1 then
				helper_d7295df9()
				helper_bdaf51ab()
			end
			helper_1ef0d4b2()
			return 0
		end
		return nil
	end)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = helper_dfad229b

--- Event 200, which map data, a script or the engine runs by number.
function script.event_200()
	if helper_7511c466() ~= 0 then
		event.MapJump_2(-1, "g05")
	end
end

--- Event 250, which map data, a script or the engine runs by number.
function script.event_250()
	local var0: s32 = 0
	local var1: s32 = 0
	local at: number = 0
	return vm.guard(function()
		at = 1
		var0 = helper_e9ab25fd()
		if var0 ~= 1 then
			return
		end
		event.SetCnt(1, 9)
		var1 = event.GetEventData_2(3) or var1
		if var1 <= 1 then
			at = 2
			helper_cf15df04()
			event.StopBgm(0)
			at = 3
			vm.wait(3)
			event.MapJump_2(-1, "s37")
			at = 4
			vm.wait(4)
		else
			at = 5
			helper_17000()
			event.StopBgm(0)
			event.MapJump_2(100, "s38")
		end
		return
	end, function(received: { any })
		if at <= 1 then
			if at == 1 then
				var0 = received[1] :: number
			end
			return 0
		end
		if at <= 5 then
			if at == 5 then
			end
			if at <= 4 then
				helper_23600000()
			end
			return 0
		end
		return nil
	end)
end

--- Event 400, which map data, a script or the engine runs by number.
script.event_400 = helper_93cb8168

--- Event 1000, which map data, a script or the engine runs by number.
function script.event_1000()
	local var0: s32 = 0
	var0 = event.GetEventData_2(13) or var0
	if var0 == 8 then
		helper_0e547894()
	end
end

return script
