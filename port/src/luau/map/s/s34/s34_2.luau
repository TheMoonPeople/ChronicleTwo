--!strict
-- map/s/s34/s34_2.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1844fc9c = require("@lib/event/helper_1844fc9c")
local helper_1b64c7aa = require("@lib/event/helper_1b64c7aa")
local helper_470f8a56 = require("@lib/event/helper_470f8a56")
local helper_5186795e = require("@lib/event/helper_5186795e")
local helper_52c8e591 = require("@lib/event/helper_52c8e591")
local helper_9dafbc83 = require("@lib/event/helper_9dafbc83")
local helper_9f562a0d = require("@lib/event/helper_9f562a0d")
local helper_a1c34b66 = require("@lib/event/helper_a1c34b66")
local helper_a2404daa = require("@lib/event/helper_a2404daa")
local helper_efef775f = require("@lib/event/helper_efef775f")
local helper_efffcfbb = require("@lib/event/helper_efffcfbb")

--- Program 99.
local function program_99()
	print("map_init-------------------------\n")
end

--- Helper function.
local function helper_299fc()
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.AssignStack(4)
	event.ClearStack(4)
	event.LoadChara(4, "chara/p00_31a.gltf", "info", 8)
	event.CharaActive(8)
	event.SetCharaPos(8, -300.0, 0.0, 4360.0)
	event.SetCharaRot(8, 0.0, 3.1415927, 0.0)
	event.SetCharaNo(8, 301)
end

--- Helper function.
local function helper_275d8()
	local var0: s32 = 0
	local var1: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var5: f32 = 0
	local var6: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_efffcfbb(20)
		end
		if at <= 2 then
			helper_a1c34b66(0)
		end
		if at <= 3 then
			helper_efffcfbb(10)
		end
		helper_9f562a0d()
	end
	var0 = event.GetCnt(0) or var0
	if var0 == 0 then
		helper_9f562a0d()
		event.CharaNormalDrive(0)
		event.CharaResetDa(0)
		event.ResetCamera(1, 0.0)
		event.SetFadeIn(30)
		return
	end
	var1 = event.GetCnt(15) or var1
	event.Initialize()
	event.EohSyncObj(1, "p01_train01")
	event.EohSetPos(1, -790.0, 0.0, 4500.0)
	event.EohSetRot(1, 0.0, -1.57, 0.0)
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	if var1 == 0 then
		event.EohSyncObj(2, "p01_train01", "s3601_12-m1")
		event.EohSyncObj(3, "p01_train01", "s3601_14-m1")
		event.EohSyncObj(4, "p01_train01", "s3601_16-m1")
		event.EohSyncObj(5, "p01_train01", "s3601_17-m")
		if var0 == 2 then
			event.EohSyncObj(2, "p01_train01", "s3601_12-m5")
			event.EohSyncObj(3, "p01_train01", "s3601_14-m3")
			event.EohSyncObj(4, "p01_train01", "s3601_16-m4")
			event.EohSyncObj(5, "p01_train01", "s3601_17-m2")
		end
		if var0 == 3 then
			event.EohSyncObj(2, "p01_train01", "s3601_12-m3")
			event.EohSyncObj(3, "p01_train01", "s3601_14-m5")
			event.EohSyncObj(4, "p01_train01", "s3601_16-m5")
			event.EohSyncObj(5, "p01_train01", "s3601_17-m4")
		end
	else
		event.EohSyncObj(2, "p01_train01", "s3601_12-m")
		event.EohSyncObj(3, "p01_train01", "s3601_14-m")
		event.EohSyncObj(4, "p01_train01", "s3601_16-m")
		event.EohSyncObj(5, "p01_train01", "s3601_17-m1")
		if var0 == 2 then
			event.EohSyncObj(2, "p01_train01", "s3601_12-m4")
			event.EohSyncObj(3, "p01_train01", "s3601_14-m2")
			event.EohSyncObj(4, "p01_train01", "s3601_16-m2")
			event.EohSyncObj(5, "p01_train01", "s3601_17-m3")
		end
		if var0 == 3 then
			event.EohSyncObj(2, "p01_train01", "s3601_12-m2")
			event.EohSyncObj(3, "p01_train01", "s3601_14-m4")
			event.EohSyncObj(4, "p01_train01", "s3601_16-m3")
			event.EohSyncObj(5, "p01_train01", "s3601_17-m5")
		end
	end
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
	var5 = -240.0
	if var0 == 2 then
		var5 = 270.0
	end
	if var0 == 3 then
		var5 = 790.0
	end
	event.CmrsInit()
	if var1 == 0 then
		event.CmrsSetPos(var5 + vm.f32(135.23), 32.86, 4778.39)
		event.CmrsSetRef(var5, 31.8, 4650.0)
	else
		event.CmrsSetPos(var5 - vm.f32(135.23), 32.86, 4221.61)
		event.CmrsSetRef(var5, 31.8, 4350.0)
	end
	event.SetFadeIn(30)
	if var1 == 0 then
		event.ObjsSetPos(0, var5, 25.9, 4550.0)
		event.ObjsSetRot(0, 0.0, 0.0, 0.0)
	else
		event.ObjsSetPos(0, var5, 30.0, 4480.0)
		event.ObjsSetRot(0, 0.0, 3.1415927, 0.0)
	end
	if var1 == 0 then
		event.ObjsRotation(2, 0.0, 0.0, 1.5707964, 30)
		event.ObjsRotation(3, 0.0, 0.0, 1.5707964, 30)
		event.ObjsRotation(4, 0.0, 0.0, -0.3926991, 30)
		event.ObjsRotation(5, 0.0, 0.0, -0.3926991, 30)
	else
		event.ObjsRotation(2, 0.0, 0.0, -1.5707964, 30)
		event.ObjsRotation(3, 0.0, 0.0, -1.5707964, 30)
		event.ObjsRotation(4, 0.0, 0.0, 0.3926991, 30)
		event.ObjsRotation(5, 0.0, 0.0, 0.3926991, 30)
	end
	var6 = event.GetSndId(2) or var6
	event.SndSePlay(var6, 92)
	helper_efffcfbb(30)
	if vm.skipping() then
		return skip(1)
	end
	event.ObjsMove(5, pos_x - 22.5, pos_y - 9.5, pos_z, 30)
	helper_efffcfbb(20)
	if vm.skipping() then
		return skip(2)
	end
	if var1 == 0 then
		event.ObjsMove(0, var5, 0.0, 4600.0, 30)
	else
		event.ObjsMove(0, var5, 0.0, 4400.0, 30)
	end
	event.ObjsSetMotion(0, "走り", 4)
	event.EohSetFootSoundId(0, 6)
	helper_a1c34b66(0)
	if vm.skipping() then
		return skip(3)
	end
	event.EohSetFootSoundId(0, 0)
	event.ObjsSetMotion(0, "立ち")
	helper_efffcfbb(10)
	if vm.skipping() then
		return skip(4)
	end
	event.SetFadeIn(1)
	event.EohSetRot(2, 0.0, 0.0, 0.0)
	event.EohSetRot(3, 0.0, 0.0, 0.0)
	event.EohSetRot(4, 0.0, 0.0, 0.0)
	event.EohSetPos(5, pos_x, pos_y, pos_z)
	event.EohSetRot(5, 0.0, 0.0, 0.0)
	helper_9f562a0d()
	event.CharaNormalDrive(0)
	event.CharaResetDa(0)
	event.ResetCamera(1, 0.0)
end

--- Helper function.
local function helper_2631c()
	local var0: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var4: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_a1c34b66(1)
		end
		if at <= 2 then
			helper_efffcfbb(10)
		end
		if at <= 3 then
			helper_efffcfbb(30)
		end
		if at <= 4 then
			helper_efffcfbb(20)
		end
		if at <= 5 then
			helper_a1c34b66(0)
		end
		if at <= 6 then
			helper_efffcfbb(10)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	var0 = event.SndLoadSound(8, "snd2/sp/sp_019.sound.json") or var0
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.CharaActive(0, 0)
	event.EohSyncObj(1, "p01_train01")
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.ObjsSetPos(1, -190.0, 0.0, 4500.0)
	event.ObjsSetRot(1, 0.0, -1.57, 0.0)
	event.EohSyncObj(2, "p01_train01", "s3601_12-m")
	event.ObjsSyncObj(2, 2)
	event.ObjsSetRot(2, 0.0, 0.0, 0.0)
	event.EohSyncObj(3, "p01_train01", "s3601_14-m")
	event.ObjsSyncObj(3, 3)
	event.ObjsSetRot(3, 0.0, 0.0, 0.0)
	event.EohSyncObj(4, "p01_train01", "s3601_16-m")
	event.ObjsSyncObj(4, 4)
	event.ObjsSetRot(4, 0.0, 0.0, 0.0)
	event.EohSyncObj(5, "p01_train01", "s3601_17-m1")
	do
		local out1, out2, out3 = event.EohGetPos(5)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	event.ObjsSyncObj(5, 5)
	event.ObjsSetRot(5, 0.0, 0.0, 0.0)
	event.CmrsInit()
	event.CmrsSetPos(-1323.57, 7.45, 4810.3)
	event.CmrsSetRef(-994.3, 130.62, 4578.42)
	event.SetFadeIn(30)
	event.ObjsMove2(1, -790.0, 0.0, 4500.0, 40, 2, 1.0)
	event.SndSePlay(var0, 0)
	helper_a1c34b66(1)
	if vm.skipping() then
		return skip(2)
	end
	helper_efffcfbb(10)
	if vm.skipping() then
		return skip(3)
	end
	event.SetCrossfade(30)
	event.CmrsSetPos(-375.22998, 32.86, 4221.61)
	event.CmrsSetRef(-240.0, 31.8, 4350.0)
	event.EohSetPos(1, -790.0, 0.0, 4500.0)
	event.CharaActive(0)
	event.ObjsSetPos(0, -240.0, 30.0, 4480.0)
	event.ObjsSetRot(0, 0.0, 3.1415927, 0.0)
	event.ObjsRotation(2, 0.0, 0.0, -1.5707964, 30)
	event.ObjsRotation(3, 0.0, 0.0, -1.5707964, 30)
	event.ObjsRotation(4, 0.0, 0.0, 0.3926991, 30)
	event.ObjsRotation(5, 0.0, 0.0, 0.3926991, 30)
	var4 = event.GetSndId(2) or var4
	event.SndSePlay(var4, 92)
	helper_efffcfbb(30)
	if vm.skipping() then
		return skip(4)
	end
	event.ObjsMove(5, pos_x - 22.5, pos_y - 9.5, pos_z, 30)
	helper_efffcfbb(20)
	if vm.skipping() then
		return skip(5)
	end
	event.ObjsMove(0, -240.0, 0.0, 4405.0, 30)
	event.ObjsSetMotion(0, "走り", 4)
	event.EohSetFootSoundId(0, 6)
	helper_a1c34b66(0)
	if vm.skipping() then
		return skip(6)
	end
	event.EohSetFootSoundId(0, 0)
	event.ObjsSetMotion(0, "立ち")
	helper_efffcfbb(10)
	if vm.skipping() then
		return skip(7)
	end
	event.SetFadeIn(1)
	event.EohSetPos(1, -790.0, 0.0, 4500.0)
	event.EohSetRot(1, 0.0, -1.57, 0.0)
	event.EohSetRot(2, 0.0, 0.0, 0.0)
	event.EohSetRot(3, 0.0, 0.0, 0.0)
	event.EohSetRot(4, 0.0, 0.0, 0.0)
	event.EohSetPos(5, pos_x, pos_y, pos_z)
	event.EohSetRot(5, 0.0, 0.0, 0.0)
	event.CmrsInit()
	event.CharaActive(0)
	event.SetCharaPos(0, -240.0, 0.0, 4350.0)
	event.SetCharaRot(0, 0.0, 3.1415927, 0.0)
	event.CharaNormalDrive(0)
	event.CharaResetDa(0)
	event.ResetCamera(1, 0.0, 10.0)
end

--- Helper function.
local function helper_29760()
	local var0: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_efffcfbb(20)
		end
		return 1
	end
	event.Initialize()
	event.SetMotion(0, "立ち")
	event.SetMesQuestionGyou(0, 0)
	event.SetMesWindowMode(0, 5)
	event.SetMesDrawspeed(0, 1)
	var0 = helper_5186795e(5, 4)
	if vm.skipping() then
		return skip(1)
	end
	if var0 == 0 then
		event.SetFadeOut(20)
		helper_efffcfbb(20)
		if vm.skipping() then
			return skip(2)
		end
		return 1
	end
	return 0
end

--- Helper function.
local function helper_1cfc0()
	local var0: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_470f8a56(0, 1)
			return 0
		end
		if at <= 3 then
			helper_efffcfbb(15)
		end
		return 0
	end
	event.SetMotion(0, "立ち")
	event.Initialize()
	helper_470f8a56(0, 4)
	event.MesMake_2(0, "Entrer\nPartir")
	var0 = helper_1844fc9c(0, -1, 5, 256, 208, 2, 0)
	if vm.skipping() then
		return skip(1)
	end
	if var0 == -1 then
		helper_470f8a56(0, 1)
		return 0
	end
	if var0 == 1 then
		event.SetFadeOut(15)
		helper_efffcfbb(15)
		if vm.skipping() then
			return skip(2)
		end
		event.GotoMenu(19, 0)
		if vm.wait() then
			return skip(3)
		end
		event.SetFadeIn(15)
		helper_efffcfbb(15)
		if vm.skipping() then
			return skip(4)
		end
		return 0
	end
	return 1
end

--- Helper function.
local function helper_260c4()
	local var0: s32 = 0
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	var0 = event.GetEventData_2(13) or var0
	helper_470f8a56(0, 1)
	flag = event.GetFlag(648) or flag
	if flag == 0 then
		event.MesMake_2(0, "Je vous attendrai ici.\nJ'esp[UNI00e8]re que tout ira bien.")
	else
		event.MesMake_2(0, "Je vous attendrai ici.\nNe le ratez pas !")
	end
	helper_52c8e591(var0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

script[99] = program_99

--- Program 100.
script[100] = function()
	local mc_load: s32 = 0
	local old_map_no: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_9f562a0d()
			helper_2631c()
		end
		helper_299fc()
	end
	event.Initialize()
	program_99()
	print("start_event--------------------------------------------\n")
	mc_load = event.CheckMcLoad() or mc_load
	if mc_load == 1 then
		helper_299fc()
		helper_9dafbc83(vm.f32(94.2), vm.f32(140.4), vm.f32(2842.4), 0.0)
		event.ResetCamera(1, 0.0, 20.0)
		event.SetFadeIn(30)
	else
		old_map_no = event.GetOldMapNo() or old_map_no
		var2 = event.GetMapType(old_map_no) or var2
		if var2 ~= -1 then
			if old_map_no == 4 or old_map_no == 109 then
				helper_299fc()
				helper_9dafbc83(0.0, vm.f32(189.2), 2630.0, 0.0)
				event.ResetCamera(1, 3.14, 20.0)
				event.SetFadeIn(30)
			else
				var3 = event.GetCnt(1) or var3
				if (old_map_no == 18 or old_map_no == 23 or old_map_no == 120 or old_map_no == 108) and var3 == 9 then
					helper_299fc()
					helper_275d8()
					if vm.skipping() then
						return skip(1)
					end
					helper_9f562a0d()
					event.SetFadeIn(15)
					event.ResetCamera(1, 0.0)
				else
					helper_2631c()
					if vm.skipping() then
						return skip(2)
					end
					helper_299fc()
				end
			end
		end
		event.SetMotion(0, "立ち")
	end
end

--- Program 150.
script[150] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_2631c()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 200.
script[200] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	local t0 = helper_29760()
	if vm.skipping() then
		return skip(1)
	end
	if t0 ~= 0 then
		event.MapJump(-1, "g05")
	end
end

--- Program 250.
script[250] = function()
	local var0: s32 = 0
	local var1: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
		if at <= 4 then
			helper_1b64c7aa()
		end
	end
	var0 = helper_1cfc0()
	if vm.skipping() then
		return skip(1)
	end
	if var0 ~= 1 then
		return
	end
	event.SetCnt(1, 9)
	var1 = event.GetEventData_2(3) or var1
	if var1 <= 1 then
		helper_efef775f()
		if vm.skipping() then
			return skip(2)
		end
		event.StopBgm(0)
		if vm.wait() then
			return skip(3)
		end
		event.MapJump(-1, "s37")
		if vm.wait() then
			return skip(4)
		end
	else
		helper_1b64c7aa()
		if vm.skipping() then
			return skip(5)
		end
		event.StopBgm(0)
		event.MapJump(100, "s38")
	end
end

--- Program 400.
script[400] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_a2404daa()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 1000.
script[1000] = function()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	var0 = event.GetEventData_2(13) or var0
	if var0 == 8 then
		helper_260c4()
		if vm.skipping() then
			return skip(1)
		end
	end
end

return script
