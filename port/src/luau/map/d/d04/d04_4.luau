--!strict
-- map/d/d04/d04_4.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0093af00 = require("@lib/event/helper_0093af00")
local helper_0d8ef33e = require("@lib/event/helper_0d8ef33e")
local helper_1bfbe759 = require("@lib/event/helper_1bfbe759")
local helper_1c1f308e = require("@lib/event/helper_1c1f308e")
local helper_1c8c39a1 = require("@lib/event/helper_1c8c39a1")
local helper_22454407 = require("@lib/event/helper_22454407")
local helper_262fced1 = require("@lib/event/helper_262fced1")
local helper_2f209e9f = require("@lib/event/helper_2f209e9f")
local helper_47343ad6 = require("@lib/event/helper_47343ad6")
local helper_51999b4f = require("@lib/event/helper_51999b4f")
local helper_522670ce = require("@lib/event/helper_522670ce")
local helper_5307b95a = require("@lib/event/helper_5307b95a")
local helper_540be551 = require("@lib/event/helper_540be551")
local helper_5495c7dc = require("@lib/event/helper_5495c7dc")
local helper_55bc1429 = require("@lib/event/helper_55bc1429")
local helper_5716569e = require("@lib/event/helper_5716569e")
local helper_574f31f8 = require("@lib/event/helper_574f31f8")
local helper_66b705b3 = require("@lib/event/helper_66b705b3")
local helper_6c8c62a4 = require("@lib/event/helper_6c8c62a4")
local helper_6efad7f4 = require("@lib/event/helper_6efad7f4")
local helper_79d90c82 = require("@lib/event/helper_79d90c82")
local helper_7ec0dfb1 = require("@lib/event/helper_7ec0dfb1")
local helper_7f54aec4 = require("@lib/event/helper_7f54aec4")
local helper_91542603 = require("@lib/event/helper_91542603")
local helper_9857347b = require("@lib/event/helper_9857347b")
local helper_a52ca524 = require("@lib/event/helper_a52ca524")
local helper_adbe36db = require("@lib/event/helper_adbe36db")
local helper_b302ce65 = require("@lib/event/helper_b302ce65")
local helper_b514f6a8 = require("@lib/event/helper_b514f6a8")
local helper_c07d0298 = require("@lib/event/helper_c07d0298")
local helper_c3c7815d = require("@lib/event/helper_c3c7815d")
local helper_d0ba87d6 = require("@lib/event/helper_d0ba87d6")
local helper_d8a5c79b = require("@lib/event/helper_d8a5c79b")
local helper_db44a722 = require("@lib/event/helper_db44a722")
local helper_dff48a5c = require("@lib/event/helper_dff48a5c")
local helper_e4b041e2 = require("@lib/event/helper_e4b041e2")
local helper_f25e5b69 = require("@lib/event/helper_f25e5b69")
local helper_feb439af = require("@lib/event/helper_feb439af")

--- Helper function.
local function helper_41a80()
	local var0: s32 = 0
	local var1: s32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: s32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			helper_d0ba87d6()
		end
		if at <= 3 then
			local _ = helper_55bc1429(var2, 0.0, 1.0) == 0
			local _ = helper_55bc1429(var2, vm.f32(3.14), 1.0) == 0
			var4 = 0
			var4 = var4 + 1
		end
		if at <= 4 then
			local _ = helper_55bc1429(var2, 0.0, 1.0) == 0
			var7 = vm.f32(var7 + vm.f32(3.1415927))
			local _ = helper_55bc1429(var2, vm.f32(3.14), 1.0) == 0
			var7 = vm.f32(var7 - vm.f32(3.1415927))
			local _ = helper_55bc1429(var2, vm.f32(1.57), 1.0) == 0
			var5 = vm.f32(var5 + vm.f32(3.1415927))
			local _ = helper_55bc1429(var2, vm.f32(-1.57), 1.0) == 0
			var5 = vm.f32(var5 - vm.f32(3.1415927))
			helper_c07d0298(1)
		end
		if at <= 5 then
			helper_c07d0298(0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	event.SetLoadbgFile("snd2/sp/sp_033.sound.json")
	if vm.wait() then
		return skip(2)
	end
	helper_d0ba87d6()
	if vm.skipping() then
		return skip(3)
	end
	var0 = event.SndLoadSound(8, "snd2/sp/sp_033.sound.json") or var0
	event.AssignStack(5)
	event.ClearStack(5)
	var1 = event.GetEventData_2(9) or var1
	var2 = vm.bits_float(event.GetEventData_2(11)) or var2
	event.EohSyncObj(0, var1, "d04w10_3-m")
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	if helper_55bc1429(var2, 0.0, 1.0) == 0 or helper_55bc1429(var2, vm.f32(3.14), 1.0) == 0 then
		event.EohSyncObj(1, var1, "d04w10_2-m")
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.EohSyncObj(2, var1, "d04w10_4-m")
		event.EohSetShow(2, 1)
		event.ObjsInit(2)
		event.ObjsSyncObj(2, 2)
	else
		event.EohSyncObj(1, var1, "d04w10_5-m")
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.EohSyncObj(2, var1, "d04w10_6-m")
		event.EohSetShow(2, 1)
		event.ObjsInit(2)
		event.ObjsSyncObj(2, 2)
	end
	event.SndSePlay(var0, 2)
	var3 = vm.bits_float(event.GetEventData_2(11)) or var3
	var4 = 0
	while var4 < 30 do
		event.CtrlcRotBack(var3)
		event.CtrlcMoveCamera(0)
		event.CtrlcStep()
		var4 = var4 + 1
		if vm.wait() then
			return skip(4)
		end
	end
	event.SndSePlay(var0, 0)
	do
		local out1, out2, out3 = event.EohGetRot(1)
		var5 = out1 or var5
		var6 = out2 or var6
		var7 = out3 or var7
	end
	if helper_55bc1429(var2, 0.0, 1.0) == 0 then
		var7 = vm.f32(var7 + vm.f32(3.1415927))
		var7 = event.AngleLimit(var7) or var7
	end
	if helper_55bc1429(var2, vm.f32(3.14), 1.0) == 0 then
		var7 = vm.f32(var7 - vm.f32(3.1415927))
		var7 = event.AngleLimit(var7) or var7
	end
	if helper_55bc1429(var2, vm.f32(1.57), 1.0) == 0 then
		var5 = vm.f32(var5 + vm.f32(3.1415927))
		var5 = event.AngleLimit(var5) or var5
	end
	if helper_55bc1429(var2, vm.f32(-1.57), 1.0) == 0 then
		var5 = vm.f32(var5 - vm.f32(3.1415927))
		var5 = event.AngleLimit(var5) or var5
	end
	event.ObjsRotation2(1, var5, var6, var7, 40, 0, 0.5)
	event.ObjsRotation2(2, var5, var6, var7, 40, 0, 0.5)
	helper_c07d0298(1)
	if vm.skipping() then
		return skip(5)
	end
	do
		local out1, out2, out3 = event.EohGetPos(0)
		var5 = out1 or var5
		var6 = out2 or var6
		var7 = out3 or var7
	end
	event.ObjsMove2(0, var5, var6 + 80.0, var7, 32, 1, 0.5)
	helper_c07d0298(0)
	if vm.skipping() then
		return skip(6)
	end
	event.Finish()
end

--- Helper function.
local function helper_42808()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local angle: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var0, var1, var2, angle = helper_22454407(var0, var1, var2, angle)
			angle = vm.f32(angle + vm.f32(3.1415927))
			helper_1c8c39a1(10)
		end
		if at <= 2 then
			helper_1c8c39a1(30)
		end
		if at <= 3 then
			helper_1c8c39a1(60)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	var0, var1, var2, angle = helper_22454407(var0, var1, var2, angle)
	angle = vm.f32(angle + vm.f32(3.1415927))
	angle = event.AngleLimit(angle) or angle
	event.SetWorldCoord(var0, var1, var2, angle)
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetPos(0, 0.0, 0.0, 0.0)
	event.ObjsSetRot(0, 0.0, 0.0, 0.0)
	event.ObjsResetDaPosition(0)
	event.EohSetFootSoundId(0, 18)
	event.CmrsInit()
	event.CmrsSetPos(56.71, 54.78, -129.16)
	event.CmrsSetRef(-1.53, 22.52, 48.82)
	event.ObjsMove(0, 0.0, 0.0, 155.0, 40)
	event.ObjsSetMotion(0, "走り", 4)
	event.ObjsMotionDelay(0, 40)
	event.ObjsSetMotion(0, "立ち")
	helper_1c8c39a1(10)
	if vm.skipping() then
		return skip(2)
	end
	event.SetFadeOut(30)
	helper_1c8c39a1(30)
	if vm.skipping() then
		return skip(3)
	end
	helper_1c8c39a1(60)
	if vm.skipping() then
		return skip(4)
	end
	event.Finish()
end

--- Helper function.
local function helper_123ec(arg0: s32, arg1: s32, arg2: s32)
	local argc: s32 = 0
	local argc_2: s32 = 0
	local argc_3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_7ec0dfb1(0, 2750, 8, 0, 0)
		end
		if at <= 2 then
			helper_7ec0dfb1(0, 2760, 8, 0, 0)
		end
		if at <= 3 then
			helper_7ec0dfb1(0, vm.i32(2700 + arg2), 8, 0, 0)
		end
		if at <= 4 then
			helper_7ec0dfb1(0, -1, 8, 0, 0)
		end
		if at <= 5 then
			helper_7ec0dfb1(0, 2760, 8, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesWindowMode(0, 4)
	event.SetMesDrawspeed(0, 1)
	if arg0 == 1 or arg0 == 2 then
		helper_7ec0dfb1(0, 2750, 8, 0, 0)
		if vm.skipping() then
			return skip(2)
		end
	end
	if arg0 == 1 and arg1 ~= 2 then
		argc = event.GetSysSndId() or argc
		event.SndSePlay(argc, 18)
		helper_7ec0dfb1(0, 2760, 8, 0, 0)
		if vm.skipping() then
			return skip(3)
		end
	end
	if arg1 == 2 or arg1 == 3 then
		helper_7ec0dfb1(0, vm.i32(2700 + arg2), 8, 0, 0)
		if vm.skipping() then
			return skip(4)
		end
	end
	if arg0 == 1 and arg1 == 2 then
		argc_2 = event.GetSysSndId() or argc_2
		event.SndSePlay(argc_2, 18)
		event.MesMake_2(0, "Hai ottenuto 2 Medaglie!")
		helper_7ec0dfb1(0, -1, 8, 0, 0)
		if vm.skipping() then
			return skip(5)
		end
	elseif arg1 == 2 then
		argc_3 = event.GetSysSndId() or argc_3
		event.SndSePlay(argc_3, 18)
		helper_7ec0dfb1(0, 2760, 8, 0, 0)
		if vm.skipping() then
			return skip(6)
		end
	end
end

--- Helper function.
local function helper_3f54c(arg0: s32)
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: s32 = 0
	local var6: s32 = 0
	local language_code: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 5 then
			if at <= 1 then
				var1 = vm.f32(var1 + 80.0)
				helper_1c8c39a1(40)
			end
			if at <= 2 then
				helper_1c8c39a1(30)
			end
			if at <= 3 then
				helper_c07d0298(0)
			end
			if at <= 4 then
				helper_1c8c39a1(4)
			end
			if vm.skip_end() then
				return skip(6)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SetStatusbarShow(1, 1.0)
		if arg0 ~= 0 then
			event.DngmapOnoff(0)
			event.DngmapDelete()
		else
			event.DelImg(0)
		end
		event.EohSetFootSoundId(0, 0)
		event.EohSetPos(0, 0.0, 3200.0, 120.0)
		if vm.wait() then
			return skip(7)
		end
		event.EohResetDaPosition(0)
		event.SetActiveCmrid(1)
		event.SetBeforeCmrid(0)
		event.SetFadeIn(0)
		event.ResetCamera(0)
		event.DngPause(1, 0)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	event.InitDramaScene()
	event.DngPause(1, 1)
	event.StopEnvBgm()
	event.LoadSound(4682)
	event.AssignStack(5)
	event.ClearStack(5)
	do
		local out1, out2, out3, out4 = event.GetDunWorldCoord(2)
		var1 = out1 or var1
		var2 = out2 or var2
		var3 = out3 or var3
		var4 = out4 or var4
	end
	var1 = vm.f32(var1 + 80.0)
	event.SetWorldCoord(var1, var2, var3, var4)
	event.EohSyncChara(0, 0)
	event.EohSetFootSoundId(0, 18)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetPos(0, 0.0, 3200.0, 0.0)
	event.ObjsSetRot(0, 0.0, 0.0, 0.0)
	if arg0 ~= 0 then
		var5 = event.DngGetFloorId() or var5
		var6 = event.DngGetPrevFloor() or var6
		event.DngmapLoad(5, 0, 3, var5, var6)
		event.DngmapSetFade(1, 30)
		event.DngmapMovePiece(1)
	else
		language_code = event.GetLanguage() or language_code
		if language_code == 0 then
			event.LoadImg_3(5, "textures/dungeon/image/s_title/logo_d03.json", 0)
		else
			event.LoadImg_3(5, "textures/dungeon/image/s_title/logo_d03_1.json", 0)
		end
		event.ImgSetName(0, "logo_d03")
		event.ImgSetGet(0, 0, 0, 384, 128)
		event.ImgSetPut(0, -24, 300, 384, 128)
		event.ImgSetColor(0, 128, 128, 128, 0)
		event.ImgSetDraw(1, 0)
		event.ImgSetFade(0, 1, 30)
	end
	event.CmrsSetRef(0.0, 3230.0, 120.0)
	event.CmrsSetPos(0.0, 3250.0, 0.0)
	event.SetStatusbarShow(0, 1.0)
	event.InitDramaScene()
	event.ObjsSetMotion(0, "歩き", 4)
	event.ObjsMove(0, 0.0, 3200.0, 120.0, 90)
	event.SetFadeIn(30)
	helper_1c8c39a1(40)
	if vm.skipping() then
		return skip(2)
	end
	event.SetStatusbarShow(1)
	helper_1c8c39a1(30)
	if vm.skipping() then
		return skip(3)
	end
	if arg0 ~= 0 then
		event.DngmapSetFade(0, 20)
	else
		event.ImgSetFade(0, 0, 20)
	end
	helper_c07d0298(0)
	if vm.skipping() then
		return skip(4)
	end
	event.ObjsSetMotion(0, "立ち")
	helper_1c8c39a1(4)
	if vm.skipping() then
		return skip(5)
	end
	return part2()
end

--- Helper function.
local function helper_3ae7c()
	local var0: s32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: s32 = 0
	local var6: f32 = 0
	local rot_y: f32 = 0
	local var8: f32 = 0
	local vector_x: f32 = 0
	local vector_y: f32 = 0
	local vector_z: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 10 then
			if at <= 1 then
				local _ = helper_55bc1429(var4, 0.0, 1.0) == 0
				local _ = helper_55bc1429(var4, vm.f32(3.14), 1.0) == 0
				local _ = helper_55bc1429(var4, 0.0, 0.5) == 0
				var8 = vm.f32(vector_z + vm.f32(3.1415927))
				local _ = helper_55bc1429(var4, vm.f32(3.14), 0.5) == 0
				var8 = vm.f32(vector_z - vm.f32(3.1415927))
				local _ = helper_55bc1429(var4, vm.f32(1.57), 0.5) == 0
				var6 = vm.f32(vector_x + vm.f32(3.1415927))
				local _ = helper_55bc1429(var4, vm.f32(-1.57), 0.5) == 0
				var6 = vm.f32(vector_x - vm.f32(3.1415927))
				helper_c07d0298(2)
			end
			if at <= 2 then
				helper_1c8c39a1(20)
			end
			if at <= 3 then
				helper_c07d0298(1)
			end
			if at <= 4 then
				helper_c07d0298(0)
			end
			if at <= 5 then
				helper_c07d0298(1)
			end
			if at <= 6 then
				helper_f25e5b69(4060010, 400)
			end
			if at <= 7 then
				helper_9857347b()
			end
			if at <= 8 then
				helper_1c8c39a1(60)
			end
			if at <= 9 then
				helper_1c8c39a1(30)
			end
			if vm.skip_end() then
				return skip(11)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SndSeStop(var0, 1)
		event.SndInReverb(1)
		event.LoadMes(0, -1)
		event.Finish()
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFlag(406, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.DngSetupMainUnit(0)
	event.SetActiveChrNo(0)
	event.AssignStack(5)
	event.ClearStack(5)
	event.StopBgm(0)
	var0 = event.SndLoadSound(8, "snd2/sp/sp_033.sound.json") or var0
	do
		local out1, out2, out3, out4 = event.GetDunWorldCoord(2)
		var1 = out1 or var1
		var2 = out2 or var2
		var3 = out3 or var3
		var4 = out4 or var4
	end
	event.SetWorldCoord(var1, var2, var3, var4)
	event.ChangeDir("event/e400/e406/")
	event.LoadMes(0, 5, "e406_1.txt")
	event.ChangeDir("")
	event.CharaActive(0)
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	var5 = event.GetEventData_2(9) or var5
	if helper_55bc1429(var4, 0.0, 1.0) == 0 or helper_55bc1429(var4, vm.f32(3.14), 1.0) == 0 then
		event.EohSyncObj(2, var5, "d04w10_2-m")
		event.ObjsInit(2)
		event.ObjsSyncObj(2, 2)
		event.EohSyncObj(3, var5, "d04w10_4-m")
		event.ObjsInit(3)
		event.ObjsSyncObj(3, 3)
	else
		event.EohSyncObj(2, var5, "d04w10_5-m")
		event.ObjsInit(2)
		event.ObjsSyncObj(2, 2)
		event.EohSyncObj(3, var5, "d04w10_6-m")
		event.ObjsInit(3)
		event.ObjsSyncObj(3, 3)
	end
	event.EohSyncObj(1, var5, "d04w10_3-m")
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.EohSetPos(0, 0.0, 0.0, -145.0)
	event.EohSetRot(0, 0.0, 0.0, 0.0)
	event.EohSetMotion(0, "立ち", 4)
	event.EohSetFootSoundId(0, 18)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "無表情")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	event.SndInReverb(0)
	event.InitDramaScene()
	event.SetStatusbarShow(0, 1.0)
	event.CmrsInit()
	event.CmrsSetPos(51.16, 17.85, 158.67)
	event.CmrsSetRef(-12.94, 64.29, -60.21)
	event.SetFadeIn(30)
	event.SndSePlay(var0, 1)
	do
		local out1, out2, out3 = event.EohGetRot(2)
		var6 = out1 or var6
		rot_y = out2 or rot_y
		var8 = out3 or var8
	end
	do
		local out1, out2, out3 = event.CopyVector(var6, rot_y, var8)
		vector_x = out1 or vector_x
		vector_y = out2 or vector_y
		vector_z = out3 or vector_z
	end
	do
		local out1, out2, out3 = event.EohGetPos(1)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	if helper_55bc1429(var4, 0.0, 0.5) == 0 then
		var8 = vm.f32(vector_z + vm.f32(3.1415927))
		var8 = event.AngleLimit(var8) or var8
	end
	if helper_55bc1429(var4, vm.f32(3.14), 0.5) == 0 then
		var8 = vm.f32(vector_z - vm.f32(3.1415927))
		var8 = event.AngleLimit(var8) or var8
	end
	if helper_55bc1429(var4, vm.f32(1.57), 0.5) == 0 then
		var6 = vm.f32(vector_x + vm.f32(3.1415927))
		var6 = event.AngleLimit(var6) or var6
	end
	if helper_55bc1429(var4, vm.f32(-1.57), 0.5) == 0 then
		var6 = vm.f32(vector_x - vm.f32(3.1415927))
		var6 = event.AngleLimit(var6) or var6
	end
	event.ObjsRotation2(2, var6, rot_y, var8, 40, 0, 0.5)
	event.ObjsRotation2(3, var6, rot_y, var8, 40, 0, 0.5)
	helper_c07d0298(2)
	if vm.skipping() then
		return skip(2)
	end
	event.ObjsMove2(1, pos_x, pos_y + 80.0, pos_z, 32, 1, 0.5)
	helper_1c8c39a1(20)
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsSetMotion(0, "走り")
	event.ObjsMotionDelay(0, 30)
	event.ObjsSetMotion(0, "立ち")
	event.ObjsMove(0, 0.0, 0.0, 0.0, 30)
	helper_c07d0298(1)
	if vm.skipping() then
		return skip(4)
	end
	event.ObjsMove2(1, pos_x, pos_y, pos_z, 32, 0, 0.5)
	helper_c07d0298(0)
	if vm.skipping() then
		return skip(5)
	end
	event.ObjsMotionDelay(0, 30)
	event.ObjsSetMotion(0, "歩き")
	event.ObjsMotionDelay(0, 60)
	event.ObjsSetMotion(0, "立ち")
	event.ObjsPosDelay(0, 30)
	event.ObjsMove(0, 0.0, 0.0, 60.0, 60)
	event.CmrsAhddelay(30)
	event.CmrsSyncObj(0, 0.0, 22.0, 0.0, 0.37, 0.0, 33.0)
	event.CmrsMoveAhd2(3.14, 0.0, 33.0, 200, 0, 1.0)
	helper_c07d0298(1)
	if vm.skipping() then
		return skip(6)
	end
	event.ObjsRotation2(2, vector_x, vector_y, vector_z, 40, 0, 0.5)
	event.ObjsRotation2(3, vector_x, vector_y, vector_z, 40, 0, 0.5)
	helper_f25e5b69(4060010, 400)
	if vm.skipping() then
		return skip(7)
	end
	helper_9857347b()
	if vm.skipping() then
		return skip(8)
	end
	event.CmrsReleaseObj()
	event.CmrsMove2(0.06, 29.36, 27.0, 0.0, 51.38, 60.0, 60, 1, 1.0)
	helper_1c8c39a1(60)
	if vm.skipping() then
		return skip(9)
	end
	event.SetFadeOut(30)
	helper_1c8c39a1(30)
	if vm.skipping() then
		return skip(10)
	end
	return part2()
end

--- Helper function.
local function helper_3c6a8(arg0: s32)
	local var1: s32 = 0
	local block: s32 = 0
	local var3: s32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: s32 = 0
	local var9: s32 = 0
	local var10: s32 = 0
	local var11: f32 = 0
	local rot_y: f32 = 0
	local var13: f32 = 0
	local vector_x: f32 = 0
	local vector_y: f32 = 0
	local vector_z: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var20: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 7 then
			if at <= 1 then
				local _ = helper_55bc1429(var7, 0.0, 1.0) == 0
				local _ = helper_55bc1429(var7, vm.f32(3.14), 1.0) == 0
				local _ = helper_55bc1429(var7, 0.0, 0.5) == 0
				var13 = vm.f32(vector_z + vm.f32(3.1415927))
				local _ = helper_55bc1429(var7, vm.f32(3.14), 0.5) == 0
				var13 = vm.f32(vector_z - vm.f32(3.1415927))
				local _ = helper_55bc1429(var7, vm.f32(1.57), 0.5) == 0
				var11 = vm.f32(vector_x + vm.f32(3.1415927))
				local _ = helper_55bc1429(var7, vm.f32(-1.57), 0.5) == 0
				var11 = vm.f32(vector_x - vm.f32(3.1415927))
				helper_c07d0298(1)
			end
			if at <= 2 then
				helper_1c8c39a1(20)
			end
			if at <= 3 then
				helper_c07d0298(3)
			end
			if at <= 4 then
				helper_c07d0298(0)
			end
			if at <= 5 then
				helper_c07d0298(3)
			end
			if at <= 6 then
				helper_c07d0298(1)
			end
			if vm.skip_end() then
				return skip(8)
			end
			return part2()
		end
		if at <= 8 then
			local _ = helper_55bc1429(var7, 0.0, 1.0) == 0
			local _ = helper_55bc1429(var7, vm.f32(3.14), 1.0) == 0
		end
		if at <= 10 then
			helper_d0ba87d6()
		end
		if at <= 12 then
			helper_d0ba87d6()
		end
		if at <= 14 then
			helper_d0ba87d6()
		end
		if at <= 15 then
			helper_7ec0dfb1(0, -1, 8, 0, 0)
		end
		if at <= 16 then
			helper_7ec0dfb1(0, -1, 8, 0, 0)
		end
		if at <= 17 then
			helper_7ec0dfb1(0, -1, 8, 0, 0)
		end
		if at <= 18 then
			helper_7ec0dfb1(0, -1, 8, 0, 0)
		end
		if at <= 19 then
			helper_7ec0dfb1(0, -1, 8, 0, 0)
		end
		if at <= 20 then
			helper_7ec0dfb1(0, -1, 8, 0, 0)
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SndSeStop(var3, 1)
		event.SetStatusbarShow(1, 1.0)
		if arg0 ~= 0 then
			event.DngmapOnoff(0)
			event.DngmapDelete()
		else
			event.DelImg(0)
		end
		event.CmrsSetRef(0.0, 30.0, 60.0)
		event.CmrsSetPos(0.0, 35.0, -40.0)
		if helper_55bc1429(var7, 0.0, 1.0) == 0 or helper_55bc1429(var7, vm.f32(3.14), 1.0) == 0 then
			event.EohSyncObj(1, var10, "d04w10_2-m")
			event.ObjsInit(1)
			event.ObjsSyncObj(1, 1)
			event.EohSyncObj(2, var10, "d04w10_4-m")
			event.EohSetShow(2, 1)
			event.ObjsInit(2)
			event.ObjsSyncObj(2, 2)
		else
			event.EohSyncObj(1, var10, "d04w10_5-m")
			event.ObjsInit(1)
			event.ObjsSyncObj(1, 1)
			event.EohSyncObj(2, var10, "d04w10_6-m")
			event.EohSetShow(2, 1)
			event.ObjsInit(2)
			event.ObjsSyncObj(2, 2)
		end
		event.EohSyncObj(3, var10, "d04w10_3-m")
		event.ObjsInit(3)
		event.ObjsSyncObj(3, 3)
		event.ObjsSetRot(1, vector_x, vector_y, vector_z)
		event.ObjsSetRot(2, vector_x, vector_y, vector_z)
		event.ObjsSetPos(3, pos_x, pos_y, pos_z)
		if vm.wait() then
			return skip(9)
		end
		event.EohSetPos(0, 0.0, 0.0, 60.0)
		event.EohSetMotion(0, "立ち", 4)
		event.EohSetFootSoundId(0, 0)
		event.EohResetDaPosition(0)
		event.SetActiveCmrid(1)
		event.SetBeforeCmrid(0)
		event.ResetCamera(0)
		event.SetFadeIn(0)
		event.Initialize()
		if var1 ~= 0 then
			event.SpriteInit(0)
			event.SpriteSetType(0, 0)
			if bit32.band(var1, 1) ~= 0 then
				event.SetLoadbgFile("textures/dungeon/image/seal/aka_fuuin_1.json", "snd2/sp/sp_050.sound.json")
				if vm.wait() then
					return skip(10)
				end
				helper_d0ba87d6()
				if vm.skipping() then
					return skip(11)
				end
				block = event.LoadImg_4(5, "textures/dungeon/image/seal/aka_fuuin_1.json", 0) or block
				event.SpriteSetTexture(0, "aka_fuuin", block)
			end
			if bit32.band(var1, 2) ~= 0 then
				event.SetLoadbgFile("textures/dungeon/image/seal/ao_fuuin_1.json", "snd2/sp/sp_050.sound.json")
				if vm.wait() then
					return skip(12)
				end
				helper_d0ba87d6()
				if vm.skipping() then
					return skip(13)
				end
				block = event.LoadImg_4(5, "textures/dungeon/image/seal/ao_fuuin_1.json", 0) or block
				event.SpriteSetTexture(0, "ao_fuuin", block)
			end
			if bit32.band(var1, 4) ~= 0 then
				event.SetLoadbgFile("textures/dungeon/image/seal/shiro_fuuin_1.json", "snd2/sp/sp_050.sound.json")
				if vm.wait() then
					return skip(14)
				end
				helper_d0ba87d6()
				if vm.skipping() then
					return skip(15)
				end
				block = event.LoadImg_4(5, "textures/dungeon/image/seal/shiro_fuuin_1.json", 0) or block
				event.SpriteSetTexture(0, "shiro_fuuin", block)
			end
			event.SpriteSetColor(0, 128, 128, 128, 0)
			event.SpriteSetUvsize(0, 0, 0, 512, 128)
			event.SpriteSetPutsize(0, 512, 128)
			event.SpriteSetPos(0, 256, 156)
			event.SpriteSetDraw(0, 1)
			event.EohSyncSprite(0, 0)
			event.ObjsInit(0)
			event.ObjsSyncObj(0, 0)
			event.ObjsSetColor(0, 128, 128, 128, 128, 30)
			var20 = event.SndLoadSound(8, "snd2/sp/sp_050.sound.json") or var20
			event.SndSePlay(var20, 0)
			event.SetMesWindowMode(0, 4)
			if bit32.band(var1, 1) ~= 0 then
				event.MesMake_2(0, "Pare ci sia un Sigillo rosso sul piano.")
				helper_7ec0dfb1(0, -1, 8, 0, 0)
				if vm.skipping() then
					return skip(16)
				end
				event.MesMake_2(0, "Max ha l'Atlamillia rossa.\nNon puoi passare a lui!")
				helper_7ec0dfb1(0, -1, 8, 0, 0)
				if vm.skipping() then
					return skip(17)
				end
			end
			if bit32.band(var1, 2) ~= 0 then
				event.MesMake_2(0, "Pare ci sia un Sigillo blu sul piano.")
				helper_7ec0dfb1(0, -1, 8, 0, 0)
				if vm.skipping() then
					return skip(18)
				end
				event.MesMake_2(0, "Monica ha l'Atlamillia blu.\nNon puoi passare a lei!")
				helper_7ec0dfb1(0, -1, 8, 0, 0)
				if vm.skipping() then
					return skip(19)
				end
			end
			if bit32.band(var1, 4) ~= 0 then
				event.MesMake_2(0, "Pare ci sia un Sigillo bianco sul piano.")
				helper_7ec0dfb1(0, -1, 8, 0, 0)
				if vm.skipping() then
					return skip(20)
				end
				event.MesMake_2(
					0,
					"Non [UNI00e8] pi[UNI00f9] possibile ripristinare\nla salute o curare stati alterati."
				)
				helper_7ec0dfb1(0, -1, 8, 0, 0)
				if vm.skipping() then
					return skip(21)
				end
			end
			event.SpriteSetDraw(0, 0)
			event.DelImg(0)
		end
		event.DngPause(1, 0)
		event.Finish()
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	event.InitDramaScene()
	event.DngPause(1, 1)
	event.AssignStack(5)
	event.ClearStack(5)
	var1 = event.GetFloorStatus() or var1
	if var1 ~= 0 then
		if bit32.band(var1, 1) ~= 0 then
			event.DngSetupMainUnit(1)
		end
		if bit32.band(var1, 2) ~= 0 then
			event.DngSetupMainUnit(0)
		end
	end
	var3 = event.SndLoadSound(8, "snd2/sp/sp_033.sound.json") or var3
	do
		local out1, out2, out3, out4 = event.GetDunWorldCoord(2)
		var4 = out1 or var4
		var5 = out2 or var5
		var6 = out3 or var6
		var7 = out4 or var7
	end
	event.SetWorldCoord(var4, var5, var6, var7)
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetPos(0, 0.0, 0.0, -145.0)
	event.ObjsSetRot(0, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(0, "立ち", 4)
	event.ObjsResetDaPosition(0)
	event.EohSetFootSoundId(0, 18)
	if arg0 ~= 0 then
		var8 = event.DngGetFloorId() or var8
		var9 = event.DngGetPrevFloor() or var9
		event.DngmapLoad(5, 0, 3, var8, var9)
		event.DngmapSetFade(1, 30)
	else
		event.LoadImg_3(5, "textures/dungeon/image/s_title/logo_d03_1.json", 0)
		event.ImgSetName(0, "logo_d03")
		event.ImgSetGet(0, 0, 0, 384, 128)
		event.ImgSetPut(0, -24, 300, 384, 128)
		event.ImgSetColor(0, 128, 128, 128, 0)
		event.ImgSetDraw(1, 0)
		event.ImgSetFade(0, 1, 30)
	end
	var10 = event.GetEventData_2(9) or var10
	if helper_55bc1429(var7, 0.0, 1.0) == 0 or helper_55bc1429(var7, vm.f32(3.14), 1.0) == 0 then
		event.EohSyncObj(1, var10, "d04w10_2-m")
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.EohSyncObj(2, var10, "d04w10_4-m")
		event.EohSetShow(2, 1)
		event.ObjsInit(2)
		event.ObjsSyncObj(2, 2)
	else
		event.EohSyncObj(1, var10, "d04w10_5-m")
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.EohSyncObj(2, var10, "d04w10_6-m")
		event.EohSetShow(2, 1)
		event.ObjsInit(2)
		event.ObjsSyncObj(2, 2)
	end
	event.EohSyncObj(3, var10, "d04w10_3-m")
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.SetStatusbarShow(0, 1.0)
	event.CmrsInit()
	event.CmrsSetPos(51.16, 17.85, 158.67)
	event.CmrsSetRef(-12.94, 64.29, -60.21)
	event.SetFadeIn(30)
	event.SndSePlay(var3, 1)
	do
		local out1, out2, out3 = event.EohGetRot(1)
		var11 = out1 or var11
		rot_y = out2 or rot_y
		var13 = out3 or var13
	end
	do
		local out1, out2, out3 = event.CopyVector(var11, rot_y, var13)
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
	if helper_55bc1429(var7, 0.0, 0.5) == 0 then
		var13 = vm.f32(vector_z + vm.f32(3.1415927))
		var13 = event.AngleLimit(var13) or var13
	end
	if helper_55bc1429(var7, vm.f32(3.14), 0.5) == 0 then
		var13 = vm.f32(vector_z - vm.f32(3.1415927))
		var13 = event.AngleLimit(var13) or var13
	end
	if helper_55bc1429(var7, vm.f32(1.57), 0.5) == 0 then
		var11 = vm.f32(vector_x + vm.f32(3.1415927))
		var11 = event.AngleLimit(var11) or var11
	end
	if helper_55bc1429(var7, vm.f32(-1.57), 0.5) == 0 then
		var11 = vm.f32(vector_x - vm.f32(3.1415927))
		var11 = event.AngleLimit(var11) or var11
	end
	event.ObjsRotation2(1, var11, rot_y, var13, 40, 0, 0.5)
	event.ObjsRotation2(2, var11, rot_y, var13, 40, 0, 0.5)
	helper_c07d0298(1)
	if vm.skipping() then
		return skip(2)
	end
	event.ObjsMove2(3, pos_x, pos_y + 80.0, pos_z, 32, 1, 0.5)
	if arg0 ~= 0 then
		event.DngmapMovePiece(1)
	end
	helper_1c8c39a1(20)
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsSetMotion(0, "走り")
	event.ObjsMove(0, 0.0, 0.0, 0.0, 30)
	helper_c07d0298(3)
	if vm.skipping() then
		return skip(4)
	end
	event.ObjsMove2(3, pos_x, pos_y, pos_z, 32, 0, 0.5)
	helper_c07d0298(0)
	if vm.skipping() then
		return skip(5)
	end
	event.ObjsSetMotion(0, "立ち")
	event.ObjsMotionDelay(0, 30)
	event.ObjsPosDelay(0, 30)
	event.ObjsSetMotion(0, "歩き")
	event.ObjsMove(0, 0.0, 0.0, 60.0, 40)
	event.ObjsMotionDelay(0, 40)
	event.ObjsSetMotion(0, "立ち")
	helper_c07d0298(3)
	if vm.skipping() then
		return skip(6)
	end
	event.ObjsRotation2(1, vector_x, vector_y, vector_z, 40, 0, 0.5)
	event.ObjsRotation2(2, vector_x, vector_y, vector_z, 40, 0, 0.5)
	if arg0 ~= 0 then
		event.DngmapSetFade(0, 60)
	else
		event.ImgSetFade(0, 0, 60)
	end
	event.SetStatusbarShow(1)
	helper_c07d0298(1)
	if vm.skipping() then
		return skip(7)
	end
	return part2()
end

--- Program 1010.
local function program_1010()
	local stage_id: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local var6: s32 = 0
	local value: s32 = 0
	local flag_4: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	local landing1: () -> ...any
	local landing2: () -> ...any
	local landing3: () -> ...any
	local landing4: () -> ...any
	local landing5: () -> ...any
	local landing6: () -> ...any
	local landing7: () -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_66b705b3()
			end
			helper_6c8c62a4(stage_id, var1)
			return
		end
		if at <= 4 then
			helper_3f54c(0)
			if not vm.skipping() then
				return landing1()
			end
		end
		if at <= 5 then
			helper_3f54c(1)
			if not vm.skipping() then
				return landing2()
			end
		end
		if at <= 6 then
			helper_3ae7c()
			if not vm.skipping() then
				return landing3()
			end
		end
		if at <= 7 then
			helper_1c8c39a1(6)
		end
		if at <= 8 then
			helper_3c6a8(0)
			if not vm.skipping() then
				return landing4()
			end
		end
		if at <= 9 then
			helper_3c6a8(1)
			if not vm.skipping() then
				return landing5()
			end
		end
		if at <= 10 then
			helper_3c6a8(0)
			if not vm.skipping() then
				return landing6()
			end
		end
		if at <= 11 then
			helper_3c6a8(1)
			if not vm.skipping() then
				return landing7()
			end
		end
		helper_a52ca524()
		helper_7f54aec4()
	end
	function part2()
		helper_a52ca524()
		helper_7f54aec4()
	end
	function landing1()
		return part2()
	end
	function landing2()
		return part2()
	end
	function landing3()
		event.DngPause(2048, 1)
		event.BgmLoadCancel()
		event.LoadDungeonMapFile("s46")
		event.LoadScript("s46/s46.stb", 520)
		return part2()
	end
	function landing4()
		return part2()
	end
	function landing5()
		return part2()
	end
	function landing6()
		return part2()
	end
	function landing7()
		return part2()
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	helper_66b705b3()
	event.SetFadeOut(0)
	if vm.wait() then
		return skip(2)
	end
	if vm.wait() then
		return skip(3)
	end
	event.ActchrSetDefMotion(0)
	event.SetLocalFlag(0, 0)
	event.SetLocalFlag(1, 0)
	event.SetLocalFlag(2, 0)
	event.SetLocalFlag(3, 0)
	event.SetLocalFlag(4, 0)
	event.SetProjection(524.9)
	stage_id = event.DngGetStageId() or stage_id
	var1 = event.DngGetFloorId() or var1
	var2 = event.GetFloorInfo(stage_id, var1, 7) or var2
	helper_6c8c62a4(stage_id, var1)
	event.DngFloorInit()
	if var1 == 0 then
		event.GotoEdit(2, 100)
		return
	end
	if var1 == 9 then
		event.BgmLoadCancel()
		event.LoadDungeonMapFile("s19")
		event.LoadScript("s19/s19.stb", 100)
		return
	end
	if var1 == 14 then
		event.BgmLoadCancel()
		event.LoadDungeonMapFile("s15")
		event.LoadScript("s15/s15.stb", 100)
		return
	end
	if var1 == 20 then
		flag = event.GetFlag(438) or flag
		flag_2 = event.GetFlag(444) or flag_2
		if flag == 1 and flag_2 == 0 then
			event.BgmLoadCancel()
			event.LoadDungeonMapFile("d04b01")
			event.LoadScript("d04b01/d04b01.stb", 100)
		else
			event.BgmLoadCancel()
			event.GotoEdit(90, 100)
		end
		return
	end
	flag_3 = event.GetFlag(424) or flag_3
	if var1 == 17 and flag_3 == 0 then
		event.DngPause(2048, 1)
		event.BgmLoadCancel()
		event.LoadDungeonMapFile("s45")
		event.LoadScript("s45/s45.stb", 520)
		return
	end
	var6 = event.DngGetPrevFloor() or var6
	if var1 == 1 then
		event.LoadDungeonMapFile("d04f00", "d04f00", 56)
		event.LoadMonsterFile(0)
		event.AutoSetTreasureBox(-1)
		event.AutoSetMonster(-1)
		event.SetLocalFlag(5, 1)
		event.DngPause(32, 0)
		event.SetActiveLight(0)
		if var2 <= 0 then
			helper_3f54c(0)
			if vm.skipping() then
				return skip(4)
			end
		else
			if var1 == var6 then
				helper_3f54c(0)
				if vm.skipping() then
					return skip(5)
				end
			else
				helper_3f54c(1)
				if vm.skipping() then
					return skip(6)
				end
			end
		end
	elseif var1 <= 5 or var1 >= 17 then
		value = event.GetRandInt(100) or value
		flag_4 = event.GetFlag(406) or flag_4
		if var1 == 2 and flag_4 == 0 then
			event.BgmLoadCancel()
			event.LoadDungeonMapFile("d04f02", "d04f02", 40)
			event.SetLocalFlag(5, 0)
			event.DngPause(32, 1)
			helper_3ae7c()
			if vm.skipping() then
				return skip(7)
			end
			event.DngPause(2048, 1)
			event.BgmLoadCancel()
			event.LoadDungeonMapFile("s46")
			event.LoadScript("s46/s46.stb", 520)
		else
			if var1 == 19 then
				event.BgmLoadEnable()
				event.StopBgm(0)
				helper_1c8c39a1(6)
				if vm.skipping() then
					return skip(8)
				end
				event.LoadBgm(37)
				event.BgmLoadCancel()
			end
			if vm.imod(value, 8) == 0 then
				event.LoadDungeonMapFile("d04f02r", "d04f02", 40)
				event.DngSetWeather(1)
			else
				event.LoadDungeonMapFile("d04f02", "d04f02", 40)
			end
			event.PlayBgm(0)
			event.SetLocalFlag(5, 0)
			event.DngPause(32, 1)
			event.LoadMonsterFile(0)
			event.AutoSetTreasureBox(-1)
			event.AutoSetMonster(-1)
			if var1 == var6 then
				helper_3c6a8(0)
				if vm.skipping() then
					return skip(9)
				end
			else
				helper_3c6a8(1)
				if vm.skipping() then
					return skip(10)
				end
			end
		end
	else
		if var1 >= 11 and var1 <= 13 then
			event.LoadDungeonMapFile("d04f01s", "d01f01")
		else
			event.LoadDungeonMapFile("d04f01", "d01f01")
		end
		event.LoadMonsterFile(0)
		event.AutoSetTreasureBox(-1)
		event.AutoSetMonster(-1)
		event.SetLocalFlag(5, 0)
		event.DngPause(32, 1)
		if var1 == var6 then
			helper_3c6a8(0)
			if vm.skipping() then
				return skip(11)
			end
		else
			helper_3c6a8(1)
			if vm.skipping() then
				return skip(12)
			end
		end
	end
	return part2()
end

--- Program 1000.
local function program_1000()
	local var0: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			program_1010()
		end
	end
	event.Initialize()
	event.SphidaInit()
	helper_66b705b3()
	event.SetFadeOut(0)
	var0 = event.GetBgmNo() or var0
	if var0 ~= 18 then
		event.StopBgm(0)
		helper_1c8c39a1(6)
		if vm.skipping() then
			return skip(1)
		end
		event.LoadBgm(18)
	end
	event.PlayBgm(0)
	event.LoadSound(4601)
	event.GotoDngMap(3)
	if vm.wait() then
		return skip(2)
	end
	event.SetProjection(524.9)
	do
		local _, out2, out3, _ = event.GetMenuParam_4()
		var2 = out2 or var2
		var3 = out3 or var3
	end
	event.DngSetFloorId(var3)
	event.DngSetPrevFloor(var2)
	program_1010()
	if vm.skipping() then
		return skip(3)
	end
end

--- Helper function.
local function helper_42d30(arg0: s32)
	local argc: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local active_chr_no: s32 = 0
	local var6: any = 0
	local cleared: s32 = 0
	local bonus: s32 = 0
	local stage_id: s32 = 0
	local var10: s32 = 0
	local argc_2: s32 = 0
	local var13: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 8 then
			if at <= 1 then
				var2 = 2
				helper_1c8c39a1(6)
			end
			if at <= 3 then
				helper_41a80()
			end
			if at <= 4 then
				helper_db44a722()
			end
			if at <= 5 then
				helper_1c8c39a1(6)
			end
			if at <= 6 then
				helper_1c1f308e()
				helper_7ec0dfb1(0, 20, 5, 256, 208)
			end
			if at <= 7 then
				helper_7ec0dfb1(0, 21, 5, 256, 208)
			end
			return
		end
		if at <= 12 then
			if at <= 9 then
				helper_5307b95a()
				helper_42808()
			end
			if at <= 10 then
				helper_123ec(-1, cleared, bonus)
			end
			return
		end
	end
	event.Initialize()
	event.ActchrSetDefMotion(0)
	argc = event.GetLocalFlag(arg0) or argc
	event.DngPause(1, 1)
	if argc == 0 then
		var2 = event.GetEventData_2(6) or var2
		if var2 == 1 then
			event.Initialize()
			event.SetMesWindowMode(0, 1)
			event.SetMesDrawspeed(0, 1)
			event.MesMake_2(
				0,
				"Si pu[UNI00f2] mettere un oggetto in questa cavit[UNI00e0].\n(Usa (#) per accedere al Menu.)"
			)
			var3 = helper_51999b4f(0, -1, 5, 256, 208, var3)
			if vm.skipping() then
				return skip(1)
			end
			event.SetMesWindowMode(0, 7)
			event.SetMesDrawspeed(0, 0)
			if var3 == 1 then
				var2 = 2
			end
			event.Finish()
		end
		if var2 == 2 then
			event.SetStatusbarShow(0, 0.16666667)
			helper_1c8c39a1(6)
			if vm.skipping() then
				return skip(2)
			end
			event.GotoUseItem(342)
			do
				local skipped = vm.wait()
				var4 = event.DeferredOutput() or var4
				if skipped then
					return skip(3)
				end
			end
			if var4 == 342 then
				event.SetLocalFlag(arg0, 1)
				helper_41a80()
				if vm.skipping() then
					return skip(4)
				end
			elseif var4 <= 0 then
				event.Finish()
			else
				helper_db44a722()
				if vm.skipping() then
					return skip(5)
				end
			end
			event.SetStatusbarShow(1, 0.16666667)
			helper_1c8c39a1(6)
			if vm.skipping() then
				return skip(6)
			end
		end
	else
		active_chr_no = event.GetActiveChrNo() or active_chr_no
		if active_chr_no == 2 or active_chr_no == 3 then
			event.Initialize()
			helper_1c1f308e()
			event.SetMesWindowMode(0, 1)
			event.SetMesDrawspeed(0, 1)
			if active_chr_no == 2 then
				helper_7ec0dfb1(0, 20, 5, 256, 208)
				if vm.skipping() then
					return skip(7)
				end
			else
				helper_7ec0dfb1(0, 21, 5, 256, 208)
				if vm.skipping() then
					return skip(8)
				end
			end
			event.SetMesWindowMode(0, 1)
			event.SetMesDrawspeed(0, 0)
			event.DngPause(1, 0)
			event.Finish()
			return
		end
		event.SetMesQuestionGyou(0, 0)
		event.SetMesWindowMode(0, 5)
		event.SetMesDrawspeed(0, 1)
		var6 = helper_6efad7f4(0, 10, 8, 256, 208, 2, 1)
		if vm.skipping() then
			return skip(9)
		end
		event.SetMesWindowMode(0, 1)
		event.SetMesDrawspeed(0, 0)
		if var6 == 0 then
			event.DelMonster(-1)
			helper_5307b95a()
			helper_42808()
			if vm.skipping() then
				return skip(10)
			end
			do
				local out1, out2 = event.IsClearPractice(1)
				cleared = out1 or cleared
				bonus = out2 or bonus
			end
			if cleared == 2 or cleared == 3 then
				event.SpriteInit(0)
				event.SpriteSetType(0, 0)
				event.SpriteSetPos(0, 256, 208)
				event.SpriteSetPutsize(0, 512, 416)
				event.SpriteSetColor(0, 0, 0, 0, 128)
				event.SpriteSetDraw(0, 1)
				event.SetFadeIn(0)
				helper_123ec(-1, cleared, bonus)
				if vm.skipping() then
					return skip(11)
				end
				if vm.wait() then
					return skip(12)
				end
				event.SetFadeOut(0)
				event.SpriteSetDraw(0, 0)
			end
			stage_id = event.DngGetStageId() or stage_id
			var10 = event.DngGetFloorId() or var10
			argc_2 = event.GetNextFloor(var10, arg0) or argc_2
			event.DngSetFloorId(argc_2)
			event.SetFloorInfo(stage_id, var10, 5, 2)
			event.SetFloorInfo(stage_id, argc_2, 5, 1)
			event.DngFloorFinish()
			var13 = event.GetE3Version() or var13
			if var13 == 1 then
				event.SetExitFlag(1)
				return
			else
				event.Finish()
				program_1000()
				if vm.skipping() then
					return skip(13)
				end
			end
		else
			event.Finish()
		end
	end
	event.DngPause(1, 0)
end

--- Helper function.
local function helper_43efc()
	local flag: s32 = 0
	local argc: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local var5: s32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local var10: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
		if at <= 2 then
			var2 = 2
			helper_1c8c39a1(6)
		end
		if at <= 4 then
			var6, var7, var8, var9 = helper_22454407(var6, var7, var8, var9)
			helper_1c8c39a1(60)
		end
		if at <= 5 then
			helper_db44a722()
		end
		if at <= 6 then
			helper_1c8c39a1(6)
		end
	end
	event.Initialize()
	helper_1c1f308e()
	event.DngPause(1, 1)
	flag = event.GetFlag(616) or flag
	if flag == 0 then
		event.SetMesWindowMode(0, 4)
		event.SetMesShippo(0, 0)
		helper_7ec0dfb1(0, 9, 8, 0, 0)
		if vm.skipping() then
			return skip(1)
		end
		event.DngPause(1, 0)
		event.Finish()
		return
	end
	argc = event.GetLocalFlag(4) or argc
	if argc == 0 then
		var2 = event.GetEventData_2(6) or var2
		if var2 == 1 then
			event.SetMesWindowMode(0, 1)
			event.SetMesShippo(0, 0)
			var3 = helper_51999b4f(0, 8, 5, 256, 208, var3)
			if vm.skipping() then
				return skip(2)
			end
			event.SetMesWindowMode(0, 1)
			event.SetMesShippo(0, 1)
			if var3 == 1 then
				var2 = 2
			end
		end
		if var2 == 2 then
			event.SetStatusbarShow(0, 0.16666667)
			helper_1c8c39a1(6)
			if vm.skipping() then
				return skip(3)
			end
			event.GotoUseItem2(0, 362)
			do
				local skipped = vm.wait()
				var4 = event.DeferredOutput() or var4
				if skipped then
					return skip(4)
				end
			end
			if var4 == 362 then
				event.SetLocalFlag(4, 1)
				var5 = event.GetEventData_2(9) or var5
				event.EohSyncObj(0, var5, "star-m0")
				event.EohSetShow(0, 0)
				event.EohSyncObj(0, var5, "d04wa10_2-a")
				event.EohSetShow(0, 0)
				event.FuncPointShow(var5, "star", 0)
				var6, var7, var8, var9 = helper_22454407(var6, var7, var8, var9)
				event.SetWorldCoord(var6, var7, var8, var9)
				event.AssignStack(5)
				event.ClearStack(5)
				event.EohSyncChara(0, 0)
				event.ObjsInit(0)
				event.ObjsSyncObj(0, 0)
				event.ObjsReference(0, 0.0, 0.0, 0.0, 0)
				event.LoadChara(5, "event/dng/key_star.gltf", "star", 12)
				event.CharaActive(12)
				event.EohSyncChara(1, 12)
				event.ObjsSyncObj(1, 1)
				event.EohSetPos(1, 0.0, 0.0, -48.0)
				event.EohSetRot(1, 0.0, 0.0, 0.0)
				event.EohSetScale(1, 20.0, 20.0, 20.0)
				var10 = event.SndLoadSound(8, "snd2/sp/sp_014.sound.json") or var10
				event.SndSePlay(var10, 0)
				event.ObjsSetScale(1, 20.0, 0.0, 20.0, 60)
				event.CmrsSetPos(-84.12, 64.7, 158.88)
				event.CmrsSetRef(23.95, 31.72, -13.93)
				event.SetCharaShow(12, 0, 1, 0.02)
				helper_1c8c39a1(60)
				if vm.skipping() then
					return skip(5)
				end
				event.DeleteChara(12)
			elseif var4 <= 0 then
				event.Finish()
			else
				helper_db44a722()
				if vm.skipping() then
					return skip(6)
				end
			end
		end
		event.SetStatusbarShow(1, 0.16666667)
		helper_1c8c39a1(6)
		if vm.skipping() then
			return skip(7)
		end
	end
	event.DngPause(1, 0)
	event.Finish()
end

--- Helper function.
local function helper_46d80(arg0: s32)
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local battle_bgm_vol: f32 = 0
	local var6: s32 = 0
	local battle_bgm_vol_2: f32 = 0
	local var8: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var1, var2, var3, var4 = helper_22454407(var1, var2, var3, var4)
			helper_1c8c39a1(15)
		end
		if at <= 2 then
			helper_1c8c39a1(15)
		end
		if at <= 3 then
			helper_c07d0298(0)
		end
		if at <= 4 then
			helper_a52ca524()
			helper_c07d0298(0)
		end
		if at <= 5 then
			helper_1c8c39a1(15)
		end
		if at <= 6 then
			helper_1c8c39a1(15)
		end
		if at <= 7 then
			helper_c07d0298(0)
		end
		if at <= 8 then
			helper_a52ca524()
			helper_c07d0298(0)
		end
	end
	event.SetCrossfade(10)
	if vm.wait() then
		return skip(1)
	end
	var1, var2, var3, var4 = helper_22454407(var1, var2, var3, var4)
	event.SetWorldCoord(var1, var2, var3, var4)
	event.EohSyncChara(0, 0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetMotion(0, "走り", 4)
	if arg0 == 0 then
		event.EohSetFootSoundId(0, 16)
		event.CmrsSetPos(71.85, 16.72, -238.11)
		event.CmrsSetRef(10.53, 73.66, -36.93)
		event.ObjsSetPos(0, 0.0, 30.68, -72.59)
		event.ObjsSetRot(0, 0.0, 0.0, 0.0)
		event.ObjsResetDaPosition(0)
		event.ObjsMove(0, 0.0, 82.86, -9.67, 30)
		helper_1c8c39a1(15)
		if vm.skipping() then
			return skip(2)
		end
		event.SetFadeOut(15)
		helper_1c8c39a1(15)
		if vm.skipping() then
			return skip(3)
		end
		helper_c07d0298(0)
		if vm.skipping() then
			return skip(4)
		end
		event.EohSetFootSoundId(0, 14)
		event.SeAllStop()
		event.LoadSound(4682)
		helper_a52ca524()
		battle_bgm_vol = vm.bits_float(event.GetBtlBgmVol()) or battle_bgm_vol
		var6 = event.GetEventInfoSndid(4) or var6
		if battle_bgm_vol <= 0.0 then
			event.SndSeStop(var6, 0)
		else
			event.SndSePlay(var6, 0)
			event.SndSetSeVolFloat(var6, 0, battle_bgm_vol)
		end
		event.SetFadeIn(15)
		event.CmrsSetPos(0.0, 3253.14, -28.11)
		event.CmrsSetRef(0.0, 3230.0, 130.0)
		event.SetActiveLight(0)
		event.ObjsSetPos(0, 0.0, 3157.0, 45.0)
		event.ObjsResetDaPosition(0)
		event.ObjsMove(0, 0.0, 3200.0, 95.0, 20)
		event.ObjsMove(0, 0.0, 3200.0, 130.0, 10)
		helper_c07d0298(0)
		if vm.skipping() then
			return skip(5)
		end
	else
		event.EohSetFootSoundId(0, 14)
		event.CmrsSetPos(0.0, 3239.0, 220.74)
		event.CmrsSetRef(0.0, 3234.0, 130.0)
		event.ObjsSetPos(0, 0.0, 3200.0, 94.0)
		event.ObjsSetRot(0, 0.0, 3.14, 0.0)
		event.ObjsResetDaPosition(0)
		event.ObjsMove(0, 0.0, 3147.0, 53.0, 30)
		helper_1c8c39a1(15)
		if vm.skipping() then
			return skip(6)
		end
		event.SetFadeOut(15)
		helper_1c8c39a1(15)
		if vm.skipping() then
			return skip(7)
		end
		helper_c07d0298(0)
		if vm.skipping() then
			return skip(8)
		end
		event.EohSetFootSoundId(0, 16)
		event.SeAllStop()
		event.LoadSound(4600)
		helper_a52ca524()
		battle_bgm_vol_2 = vm.bits_float(event.GetBtlBgmVol()) or battle_bgm_vol_2
		var8 = event.GetEventInfoSndid(4) or var8
		if battle_bgm_vol_2 <= 0.0 then
			event.SndSeStop(var8, 0)
		else
			event.SndSePlay(var8, 0)
			event.SndSetSeVolFloat(var8, 0, battle_bgm_vol_2)
		end
		event.SetFadeIn(15)
		event.CmrsSetPos(-56.2, 52.61, -305.55)
		event.CmrsSetRef(1.04, 57.84, -87.81)
		event.SetActiveLight(8)
		event.ObjsSetPos(0, 0.0, 50.06, -39.81)
		event.ObjsResetDaPosition(0)
		event.ObjsMove(0, 0.0, 20.0, -73.92, 16)
		event.ObjsMove(0, 0.0, 5.0, -130.0, 16)
		helper_c07d0298(0)
		if vm.skipping() then
			return skip(9)
		end
	end
	event.EohSetFootSoundId(0, 0)
	event.ObjsSetMotion(0, "立ち")
	event.ResetCamera(0)
	event.Finish()
end

--- Helper function.
local function helper_44fc0()
	local var0: f32 = 0
	local var1: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local rot_x: f32 = 0
	local rot_y: f32 = 0
	local rot_z: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local var11: s32 = 0
	local var12: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			local _ = helper_55bc1429(var0, 0.0, 1.0) == 0
			local _ = helper_55bc1429(var0, vm.f32(3.14), 1.0) == 0
			var8 = 1.0
			var9 = 1.0
			var10 = 0.0
			var8 = 0.0
			var9 = 1.0
			var10 = 1.0
			var0 = vm.f32(var0 - vm.f32(3.1415927))
			var11 = 0
			var11 = var11 + 1
		end
		if at <= 2 then
			helper_d0ba87d6()
		end
		if at <= 3 then
			helper_1c8c39a1(10)
		end
		if at <= 4 then
			helper_1c8c39a1(30)
		end
		if at <= 5 then
			helper_1c8c39a1(60)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var1 = event.GetEventData_2(9) or var1
	var0 = vm.bits_float(event.GetEventData_2(11)) or var0
	event.EohSyncObj(0, var1)
	do
		local out1, out2, out3 = event.EohGetPos(0)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	event.MinimapDoorEnable(pos_x, pos_y, pos_z)
	event.EohSyncObj(0, var1, "d04d00_101-m1")
	do
		local out1, out2, out3 = event.EohGetRot(0)
		rot_x = out1 or rot_x
		rot_y = out2 or rot_y
		rot_z = out3 or rot_z
	end
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	if helper_55bc1429(var0, 0.0, 1.0) == 0 or helper_55bc1429(var0, vm.f32(3.14), 1.0) == 0 then
		event.EohSyncObj(1, var1, "d04d00_11-m")
		event.EohSyncObj(2, var1, "d04d00_12-m")
		event.EohSyncObj(3, var1, "d04d00_13-m")
		event.EohSyncObj(4, var1, "d04d00_14-m")
		event.EohSyncObj(5, var1, "d04d00_15-m")
		event.EohSyncObj(6, var1, "d04d00_16-m")
		event.EohSyncObj(7, var1, "d04d00_17-m")
		event.EohSyncObj(8, var1, "d04d00_18-m")
		var8 = 1.0
		var9 = 1.0
		var10 = 0.0
	else
		event.EohSyncObj(1, var1, "d04d00_21-m")
		event.EohSyncObj(2, var1, "d04d00_22-m")
		event.EohSyncObj(3, var1, "d04d00_23-m")
		event.EohSyncObj(4, var1, "d04d00_24-m")
		event.EohSyncObj(5, var1, "d04d00_25-m")
		event.EohSyncObj(6, var1, "d04d00_26-m")
		event.EohSyncObj(7, var1, "d04d00_27-m")
		event.EohSyncObj(8, var1, "d04d00_28-m")
		var8 = 0.0
		var9 = 1.0
		var10 = 1.0
	end
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.ObjsInit(5)
	event.ObjsSyncObj(5, 5)
	event.ObjsInit(6)
	event.ObjsSyncObj(6, 6)
	event.ObjsInit(7)
	event.ObjsSyncObj(7, 7)
	event.ObjsInit(8)
	event.ObjsSyncObj(8, 8)
	event.EohSyncObj(9, var1, "d04da05_2-a")
	event.EohSetShow(9, 0)
	event.EohSyncObj(10, var1, "d04da99-a0")
	event.EohSetShow(10, 1)
	event.FuncPointShow(var1, "dkey", 0)
	event.SetLoadbgFile("snd2/sp/sp_034.sound.json")
	var0 = vm.f32(var0 - vm.f32(3.1415927))
	var0 = event.AngleLimit(var0) or var0
	var11 = 0
	while var11 < 30 do
		event.CtrlcRotBack(var0)
		event.CtrlcMoveCamera(0)
		event.CtrlcStep()
		var11 = var11 + 1
		if vm.wait() then
			return skip(2)
		end
	end
	helper_d0ba87d6()
	if vm.skipping() then
		return skip(3)
	end
	var12 = event.SndLoadSound(8, "snd2/sp/sp_034.sound.json") or var12
	event.SndSePlay(var12, 0)
	helper_1c8c39a1(10)
	if vm.skipping() then
		return skip(4)
	end
	event.SndSePlay(var12, 1)
	event.ObjsRotation(0, rot_x - vm.f32(0.52), rot_y, rot_z, 30)
	helper_1c8c39a1(30)
	if vm.skipping() then
		return skip(5)
	end
	event.SndSePlay(var12, 2)
	event.FuncPointShow(var1, "eff_d04f01-50", 0)
	event.FuncPointShow(var1, "eff_d04f01-51", 0)
	event.ObjsSetScale(1, 1.0, 1.0, 1.0, 60)
	event.ObjsSetScale(2, 1.0, 1.0, 1.0, 60)
	event.ObjsSetScale(3, 1.0, 1.0, 1.0, 60)
	event.ObjsSetScale(4, 1.0, 1.0, 1.0, 60)
	event.ObjsSetScale(5, 1.0, 1.0, 1.0, 60)
	event.ObjsSetScale(6, 1.0, 1.0, 1.0, 60)
	event.ObjsSetScale(7, var8, var9, var10, 60)
	event.ObjsSetScale(8, var8, var9, var10, 60)
	helper_1c8c39a1(60)
	if vm.skipping() then
		return skip(6)
	end
	event.EohSetShow(7, 0)
	event.EohSetShow(8, 0)
	event.FuncPointShow(var1, "func", 0)
	event.ResetCamera(0)
end

--- Helper function.
local function helper_1c12c(arg0: s32, arg1: s32)
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_1c8c39a1(36)
		end
	end
	event.Initialize()
	event.DngPause(513, 1)
	event.SetCrossfade(15)
	event.SetTbStatus(0)
	event.CharaActive(0, 0)
	event.AssignStack(5)
	event.ClearStack(5)
	do
		local out1, out2, out3, out4 = event.GetDunWorldCoord(1)
		var2 = out1 or var2
		var3 = out2 or var3
		var4 = out3 or var4
		var5 = out4 or var5
	end
	event.SetWorldCoord(var2, var3, var4, var5)
	event.CopyMons2scnchr(5, arg0, 12)
	event.CharaActive(12)
	event.SetCharaPos(12, var2, var3, var4)
	event.SetCharaRot(12, 0.0, var5, 0.0)
	event.SetMotion(12, "閉め", 4)
	event.CmrsInit()
	event.CmrsSetPos(0.0, 29.0, 57.0)
	event.CmrsSetRef(0.0, 10.0, 0.0)
	event.CmrsMove(0.0, 22.27, 41.0, 0.0, 14.27, 0.0, 80)
	helper_1c8c39a1(15)
	if vm.skipping() then
		return skip(1)
	end
	event.SetMotion(12, "出現", 6)
	helper_1c8c39a1(36)
	if vm.skipping() then
		return skip(2)
	end
	event.DeleteChara(12, 0)
	event.CharaActive(0, 12)
	event.AutoSetMonster(arg0, var2, var3, var4, 0.0, var5, 0.0, arg1)
	event.CharaActive(1, 0)
	event.DngPause(513, 0)
	event.Finish()
end

--- Helper function.
local function helper_1a464(arg0: s32)
	local var1: any = 0
	local var2: s32 = 0
	local now_party_chara_id: s32 = 0
	local var4: s32 = 0
	local active_chr_no: s32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var10: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_7ec0dfb1(0, -1, 5, 0, 0)
		end
		if at <= 2 then
			arg0 = helper_adbe36db(arg0, 2)
			var2 = 0
			helper_1c8c39a1(6)
		end
		if at <= 4 then
			arg0 = helper_adbe36db(arg0, 2)
			var2 = 0
			var2 = 1
			helper_db44a722()
		end
		if at <= 5 then
			var2 = 1
			helper_7ec0dfb1(0, 2215, 5, 0, 0)
		end
		if at <= 6 then
			helper_7ec0dfb1(0, 2216, 5, 0, 0)
		end
		if at <= 7 then
			var2 = 0
			helper_7ec0dfb1(0, 2211, 5, 0, 0)
		end
		if at <= 8 then
			var2 = 1
			helper_7ec0dfb1(0, 2212, 5, 0, 0)
		end
		var2 = 0
		arg0 = helper_adbe36db(arg0, 2)
		var2 = 1
		return var2, arg0
	end
	now_party_chara_id = event.GetNowPartyChara() or now_party_chara_id
	if now_party_chara_id == 4 then
		event.MesMake_2(0, "Lo scrigno sembra chiuso a chiave.\nFallo aprire a Donny.\nForzalo.\nLascia perdere.")
		helper_522670ce(0, -1, 5, 0, 0)
	else
		helper_522670ce(0, 2220, 5, 0, 0)
	end
	var1 = helper_b514f6a8(0, 3, 3, 0)
	if vm.skipping() then
		return skip(1)
	end
	if var1 == 1 then
		if now_party_chara_id == 4 then
			event.MesMake_2(0, "Va bene! Ci penso io!")
			helper_7ec0dfb1(0, -1, 5, 0, 0)
			if vm.skipping() then
				return skip(2)
			end
			arg0 = helper_adbe36db(arg0, 2)
			var2 = 0
		else
			event.SetStatusbarShow(0, 0.16666667)
			helper_1c8c39a1(6)
			if vm.skipping() then
				return skip(3)
			end
			event.GotoUseItem(297)
			do
				local skipped = vm.wait()
				var4 = event.DeferredOutput() or var4
				if skipped then
					return skip(4)
				end
			end
			if var4 == 297 then
				arg0 = helper_adbe36db(arg0, 2)
				var2 = 0
			elseif var4 <= 0 then
				var2 = 1
			else
				helper_db44a722()
				if vm.skipping() then
					return skip(5)
				end
				var2 = 1
			end
			event.SetStatusbarShow(1, 0.16666667)
		end
	end
	if var1 == 2 then
		event.SysSePlay(24)
		event.SetMesQuestionGyou(0, 0)
		if bit32.band(arg0, 8) ~= 0 then
			active_chr_no = event.GetActiveChrNo() or active_chr_no
			if active_chr_no == 0 or active_chr_no == 2 then
				helper_7ec0dfb1(0, 2215, 5, 0, 0)
				if vm.skipping() then
					return skip(6)
				end
				event.SetCharaCondition(0, 1, 0)
				event.AddHpRate2(0, -0.7)
			else
				helper_7ec0dfb1(0, 2216, 5, 0, 0)
				if vm.skipping() then
					return skip(7)
				end
				event.SetCharaCondition(1, 1, 0)
				event.AddHpRate2(1, -0.7)
			end
			var2 = 0
		end
		if bit32.band(arg0, 16) ~= 0 then
			helper_7ec0dfb1(0, 2211, 5, 0, 0)
			if vm.skipping() then
				return skip(8)
			end
			event.SetTbStatus(0)
			do
				local out1, out2, out3, _ = event.GetDunWorldCoord(1)
				var6 = out1 or var6
				var7 = out2 or var7
				var8 = out3 or var8
			end
			var10 = event.GetSndId(4) or var10
			event.SndSePlay(var10, 11)
			event.DngCreateEffect("爆発", var6, var7 + 4.0, var8, 5)
			var2 = 1
		end
		if bit32.band(arg0, 32) ~= 0 then
			helper_7ec0dfb1(0, 2212, 5, 0, 0)
			if vm.skipping() then
				return skip(9)
			end
			event.AddWhp(0, -999)
			event.AddWhp(1, -999)
			var2 = 0
		end
		arg0 = helper_adbe36db(arg0, 2)
	end
	if var1 == -1 or var1 == 3 then
		var2 = 1
	end
	return var2, arg0
end

--- Helper function.
local function helper_1b2ec(arg0: s32)
	local var1: any = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local active_chr_no: s32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var10: s32 = 0
	local active_chr_no_2: s32 = 0
	local max: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var2 = 0
			var2 = 0
			var2 = 0
			var2 = 1
			var3 = 8
			var4 = 1
			var3 = var3 * 2
			var4 = var4 + 1
			helper_7ec0dfb1(0, 2213, 5, 0, 0)
		end
		if at <= 2 then
			var2 = 0
			helper_7ec0dfb1(0, 2215, 5, 0, 0)
		end
		if at <= 3 then
			helper_7ec0dfb1(0, 2216, 5, 0, 0)
		end
		if at <= 4 then
			var2 = 1
			helper_7ec0dfb1(0, 2211, 5, 0, 0)
		end
		if at <= 5 then
			var2 = 1
			active_chr_no_2 = 1
			helper_7ec0dfb1(0, 2212, 5, 0, 0)
		end
		var2 = 1
		return var2, arg0
	end
	helper_522670ce(0, 2200, 5, 0, 0)
	var1 = helper_b514f6a8(0, 4, 4, 0)
	if vm.skipping() then
		return skip(1)
	end
	if var1 == 1 then
		var2 = 0
	end
	if var1 == 2 then
		var2 = 0
	end
	if var1 == 3 then
		var2 = 0
	end
	if var1 == -1 or var1 == 4 then
		var2 = 1
	end
	if var2 ~= 1 then
		var3 = 8
		var4 = 1
		while var4 < var1 do
			var3 = vm.i32(var3 * 2)
			var4 = vm.i32(var4 + 1)
		end
		event.SetMesQuestionGyou(0, 0)
		if vm.i32(bit32.band(arg0, var3)) ~= 0 then
			helper_7ec0dfb1(0, 2213, 5, 0, 0)
			if vm.skipping() then
				return skip(2)
			end
			var2 = 0
		else
			event.SysSePlay(24)
			if bit32.band(arg0, 8) ~= 0 then
				active_chr_no = event.GetActiveChrNo() or active_chr_no
				if active_chr_no == 0 or active_chr_no == 2 then
					helper_7ec0dfb1(0, 2215, 5, 0, 0)
					if vm.skipping() then
						return skip(3)
					end
					event.SetCharaCondition(0, 1, 0)
					event.AddHpRate2(0, -0.7)
				else
					helper_7ec0dfb1(0, 2216, 5, 0, 0)
					if vm.skipping() then
						return skip(4)
					end
					event.SetCharaCondition(1, 1, 0)
					event.AddHpRate2(1, -0.7)
				end
				var2 = 1
			end
			if bit32.band(arg0, 16) ~= 0 then
				helper_7ec0dfb1(0, 2211, 5, 0, 0)
				if vm.skipping() then
					return skip(5)
				end
				event.SetTbStatus(0)
				do
					local out1, out2, out3, _ = event.GetDunWorldCoord(1)
					var6 = out1 or var6
					var7 = out2 or var7
					var8 = out3 or var8
				end
				var10 = event.GetSndId(4) or var10
				event.SndSePlay(var10, 11)
				event.DngCreateEffect("爆発", var6, var7 + 4.0, var8, 5)
				var2 = 1
			end
			if bit32.band(arg0, 32) ~= 0 then
				active_chr_no_2 = event.GetActiveChrNo() or active_chr_no_2
				if active_chr_no_2 == 3 then
					active_chr_no_2 = 1
				end
				event.UdataAddWhp(active_chr_no_2, 0, -999)
				event.UdataAddWhp(active_chr_no_2, 1, -999)
				do
					local _, out2 = event.UdataGetAbs(active_chr_no_2, 0)
					max = out2 or max
				end
				event.UdataAddAbs(active_chr_no_2, 0, vm.idiv(vm.i32(-max), 10))
				do
					local _, out2 = event.UdataGetAbs(active_chr_no_2, 1)
					max = out2 or max
				end
				event.UdataAddAbs(active_chr_no_2, 1, vm.idiv(vm.i32(-max), 10))
				helper_7ec0dfb1(0, 2212, 5, 0, 0)
				if vm.skipping() then
					return skip(6)
				end
				var2 = 1
			end
		end
	end
	return var2, arg0
end

--- Helper function.
local function helper_16560(arg0: s32, arg1: s32)
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local argc: s32 = 0
	local argc_2: s32 = 0
	local count_2: s32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local var14: s32 = 0
	local stage_id: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			helper_1c8c39a1(15)
		end
		if at <= 3 then
			helper_91542603(0)
		end
		if at <= 4 then
			helper_1c8c39a1(5)
		end
		if at <= 5 then
			helper_d0ba87d6()
		end
		if at <= 6 then
			helper_1c8c39a1(5)
		end
		if at <= 7 then
			var6 = helper_0d8ef33e(var6)
		end
		if at <= 8 then
			var7 = helper_540be551(13, arg0, var7)
			var6 = helper_5495c7dc(var6)
		end
		if at <= 9 then
			helper_9857347b()
		end
		if at <= 10 then
			argc = 0
			argc_2 = 0
			helper_1bfbe759(arg0, count_2)
		end
		if at <= 11 then
			helper_7ec0dfb1(0, -1, 8, 0, 0)
		end
		if at <= 12 then
			print("CHECK_GET_ITEM_LIMIT = ", argc, "\n")
			print("CHECK_ITEM_OVER      = ", argc_2, "\n")
			helper_1c8c39a1(10)
		end
		if at <= 14 then
			helper_7ec0dfb1(0, 2240, 8, 0, 0)
		end
		if at <= 15 then
			helper_7ec0dfb1(0, 2250, 8, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.DngPause(535, 1)
	event.AssignStack(5)
	event.ClearStack(5)
	do
		local out1, out2, out3, out4 = event.GetDunWorldCoord(1)
		var2 = out1 or var2
		var3 = out2 or var3
		var4 = out3 or var4
		var5 = out4 or var5
	end
	event.SetWorldCoord(var2, var3, var4, var5)
	if vm.wait() then
		return skip(2)
	end
	if arg0 >= 0 then
		event.SetLoadbgFile(arg0, 1, "effect/itemget.gltf")
	else
		event.SetLoadbgFile("effect/itemget.gltf")
	end
	event.SetTbAngle(0.0)
	event.SetTbStatus(2)
	event.CmrsInit()
	event.CmrsSetPos(0.0, 29.0, 57.0)
	event.CmrsSetRef(0.0, 10.0, 0.0)
	event.CmrsMove(0.0, 22.27, 41.0, 0.0, 14.27, 0.0, 80)
	helper_1c8c39a1(15)
	if vm.skipping() then
		return skip(3)
	end
	helper_91542603(0)
	if vm.skipping() then
		return skip(4)
	end
	helper_1c8c39a1(5)
	if vm.skipping() then
		return skip(5)
	end
	helper_d0ba87d6()
	if vm.skipping() then
		return skip(6)
	end
	event.LoadChara(5, "effect/itemget.gltf", "info", 12)
	event.CharaActive(12)
	event.EohSyncChara(1, 12)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.ObjsSetPos(1, 0.0, 0.0, 0.0)
	event.ObjsSetRot(1, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(1, "ゲット", 6)
	helper_1c8c39a1(5)
	if vm.skipping() then
		return skip(7)
	end
	var6 = helper_0d8ef33e(var6)
	if vm.skipping() then
		return skip(8)
	end
	if arg0 >= 0 then
		event.LoadItem(5, arg0, "info", 13, 1)
		event.CharaActive(1, 13)
		event.EohSyncChara(0, 13)
		var7 = helper_540be551(13, arg0, var7)
		event.EohSetScale(0, var7, var7, var7)
		event.SetCharaShow(13, 1, 1, 0.1)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.ObjsSetPos(0, 0.0, -2.5, 0.0)
		event.ObjsSetRot(0, 0.0, 0.0, 0.0)
		event.ObjsPosDelay(0, 4)
		event.ObjsJump(0, 0.0, 17.0, 0.0, -0.3, 20)
		event.ObjsJump(0, 0.0, 17.0, 0.0, -0.4, 8)
		event.ObjsJump(0, 0.0, 17.0, 0.0, -0.2, 5)
	end
	var6 = helper_5495c7dc(var6)
	if vm.skipping() then
		return skip(9)
	end
	helper_9857347b()
	if vm.skipping() then
		return skip(10)
	end
	if arg0 >= 0 then
		argc = 0
		argc_2 = 0
		count_2 = event.CheckGetItemLimit(arg0, arg1) or count_2
		if count_2 >= 1 then
			event.AddItem(arg0, count_2)
			helper_1bfbe759(arg0, count_2)
			if vm.skipping() then
				return skip(11)
			end
		else
			event.SetMesWindowMode(0, 4)
			event.SetMesDrawspeed(0, 1)
			event.SetMesItem(0, 1, arg0)
			event.MesMake_2(0, "Hai trovato [アイテム１],\nma non hai spazio sufficiente.")
			helper_7ec0dfb1(0, -1, 8, 0, 0)
			if vm.skipping() then
				return skip(12)
			end
			event.SetMesDrawspeed(0, 0)
		end
		argc = event.CheckGetItemLimit() or argc
		argc_2 = event.CheckItemOver() or argc_2
		print("CHECK_GET_ITEM_LIMIT = ", argc, "\n")
		print("CHECK_ITEM_OVER      = ", argc_2, "\n")
		if argc_2 >= 1 then
			event.SetFadeOut(10)
			helper_1c8c39a1(10)
			if vm.skipping() then
				return skip(13)
			end
			event.GotoMenu(17)
			if vm.wait() then
				return skip(14)
			end
		end
	else
		event.SetMesWindowMode(0, 4)
		event.SetMesDrawspeed(0, 1)
		helper_7ec0dfb1(0, 2240, 8, 0, 0)
		if vm.skipping() then
			return skip(15)
		end
		event.SetMesDrawspeed(0, 0)
	end
	event.CharaActive(1, 0)
	event.DeleteChara(12)
	event.DeleteChara(13)
	event.SetTbAngle(1.0)
	event.SetCrossfade(10)
	event.SetWorldCoord(0.0, 0.0, 0.0, 0.0)
	do
		local out1, out2, out3 = event.GetBeforeCameraNextPos()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	event.SetCameraPos(position_x, position_y, position_z)
	do
		local out1, out2, out3 = event.GetBeforeCameraNextRef()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	event.SetCameraRef(position_x, position_y, position_z)
	event.ResetCamera(0)
	var14 = event.GetTrialVersion() or var14
	stage_id = event.DngGetStageId() or stage_id
	if arg0 == 306 and (stage_id == 0 or var14 == 1) then
		event.SetMesWindowMode(0, 4)
		helper_7ec0dfb1(0, 2250, 8, 0, 0)
		if vm.skipping() then
			return skip(16)
		end
	end
	event.DngPause(535, 0)
	event.Finish()
end

--- Helper function.
local function helper_17a8c(arg0: s32, arg1: s32, arg2: any, arg3: any)
	local var4: s32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: s32 = 0
	local var10: f32 = 0
	local var11: any = 0
	local value: s32 = 0
	local var14: any = 0
	local var15: f32 = 0
	local var17: any = 0
	local argc: s32 = 0
	local count_2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			helper_1c8c39a1(15)
		end
		if at <= 3 then
			helper_91542603(0)
		end
		if at <= 4 then
			helper_1c8c39a1(5)
		end
		if at <= 5 then
			helper_d0ba87d6()
		end
		if at <= 6 then
			var10 = helper_0d8ef33e(var10)
		end
		if at <= 7 then
			var10 = helper_5495c7dc(var10)
		end
		if at <= 8 then
			helper_1c8c39a1(10)
		end
		if at <= 9 then
			helper_1c8c39a1(8)
		end
		if at <= 10 then
			helper_1c8c39a1(10)
		end
		if at <= 11 then
			helper_7ec0dfb1(0, 2230, 8, 256, 208)
		end
		if at <= 12 then
			helper_7ec0dfb1(0, 2231, 8, 256, 208)
		end
		if at <= 13 then
			local _ = helper_522670ce(0, 2232, 8, 0, 0)
			var11 = helper_b514f6a8(0, 2, 0, 1)
		end
		if at <= 14 then
			var14 = arg0
			arg0 = arg2
			arg2 = var14
			var14 = arg1
			arg1 = arg3
			arg3 = var14
			var15 = helper_2f209e9f(16, arg0, var15)
			var15 = helper_2f209e9f(17, arg2, var15)
			helper_1c8c39a1(10)
		end
		if at <= 15 then
			helper_1c8c39a1(60)
		end
		if at <= 16 then
			helper_1c8c39a1(6)
		end
		if at <= 17 then
			helper_c07d0298(1)
		end
		if at <= 18 then
			helper_1bfbe759(arg2, count_2)
		end
		if at <= 19 then
			helper_7ec0dfb1(0, -1, 8, 0, 0)
		end
		if at <= 20 then
			var17 = arg2
			helper_1bfbe759(arg0, count_2)
		end
		if at <= 21 then
			helper_7ec0dfb1(0, -1, 8, 0, 0)
		end
		if at <= 22 then
			var17 = arg0
			helper_1c8c39a1(10)
		end
		var9 = 0
		var9 = var9 + 1
	end
	if vm.skipping() then
		return skip(1)
	end
	event.DngPause(529, 1)
	var4 = event.SndLoadSound(8, "snd2/sp/sp_010.sound.json") or var4
	event.AssignStack(5)
	event.ClearStack(5)
	event.SetLoadbgFile(
		arg0,
		1,
		arg2,
		1,
		"event/tbox/p00_27a_ex.gltf",
		"event/tbox/l_box.gltf",
		"event/tbox/r_box.gltf",
		"event/tbox/p00_41a.gltf",
		"event/tbox/p00_27a_ex_l.gltf",
		"event/tbox/p00_27a_ex_r.gltf"
	)
	do
		local out1, out2, out3, out4 = event.GetDunWorldCoord(1)
		var5 = out1 or var5
		var6 = out2 or var6
		var7 = out3 or var7
		var8 = out4 or var8
	end
	event.SetWorldCoord(var5, var6, var7, var8)
	if vm.wait() then
		return skip(2)
	end
	event.SetTbAngle(0.0)
	event.SetTbStatus(2)
	event.CmrsInit()
	event.CmrsSetPos(0.0, 29.0, 57.0)
	event.CmrsSetRef(0.0, 10.0, 0.0)
	event.CmrsMove(0.0, 22.27, 41.0, 0.0, 14.27, 0.0, 80)
	helper_1c8c39a1(15)
	if vm.skipping() then
		return skip(3)
	end
	helper_91542603(0)
	if vm.skipping() then
		return skip(4)
	end
	helper_1c8c39a1(5)
	if vm.skipping() then
		return skip(5)
	end
	helper_d0ba87d6()
	if vm.skipping() then
		return skip(6)
	end
	event.LoadChara(5, "event/tbox/p00_27a_ex.gltf", "info", 12)
	event.CharaActive(0, 12)
	event.EohSyncChara(0, 12)
	event.EohSetPos(0, 0.0, 0.0, 0.0)
	event.EohSetRot(0, 0.0, 0.0, 0.0)
	event.EohSetMotion(0, "宝箱ピエロ出現", 5)
	event.LoadChara(5, "event/tbox/p00_41a.gltf", "info", 13)
	event.CharaActive(0, 13)
	event.EohSyncChara(1, 13)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.ObjsSetPos(1, 0.0, 0.0, 0.0)
	event.ObjsSetRot(1, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(1, "出現", 5)
	var10 = helper_0d8ef33e(var10)
	if vm.skipping() then
		return skip(7)
	end
	event.SndSePlay(var4, 0)
	event.SndSePlay(var4, 1)
	event.CharaActive(12)
	event.EohSetMotion(0, "宝箱ピエロ出現", 6)
	event.CharaActive(13)
	event.ObjsSetMotion(1, "出現", 6)
	event.ObjsNextMotion(1, "立ち", 4)
	event.CmrsInit()
	event.CmrsPrdelay(4)
	event.CmrsMove2(0.14, 22.84, 83.75, 0.0, 60.0, 0.0, 16, 2, 1.0)
	event.CmrsMove2(0.21, 18.87, 93.0, 0.0, 36.0, 0.0, 20, 0, 1.0)
	var10 = helper_5495c7dc(var10)
	if vm.skipping() then
		return skip(8)
	end
	helper_1c8c39a1(10)
	if vm.skipping() then
		return skip(9)
	end
	event.CharaActive(0, 12)
	event.LoadChara(5, "event/tbox/p00_27a_ex_r.gltf", "info", 14)
	event.CharaActive(14)
	event.SetCharaPos(14, 0.0, 0.0, 0.0)
	event.SetCharaRot(14, 0.0, 0.0, 0.0)
	event.SetMotion(14, "宝箱発生（右手）", 6)
	event.SetReference(13, "s_pre", 14)
	event.LoadChara(5, "event/tbox/p00_27a_ex_l.gltf", "info", 15)
	event.CharaActive(15)
	event.SetCharaPos(15, 0.0, 0.0, 0.0)
	event.SetCharaRot(15, 0.0, 0.0, 0.0)
	event.SetMotion(15, "宝箱出現（左手）", 6)
	event.SetReference(13, "b_pre", 15)
	event.LoadChara(5, "event/tbox/r_box.gltf", "info", 18)
	event.CharaActive(18)
	event.SetCharaPos(18, 0.0, 0.0, 0.0)
	event.SetCharaRot(18, 0.0, 0.0, 0.0)
	event.SetReference(13, "s_pre", 18)
	event.SetCharaType(18, 4)
	event.LoadChara(5, "event/tbox/l_box.gltf", "info", 19)
	event.CharaActive(19)
	event.SetCharaPos(19, 0.0, 0.0, 0.0)
	event.SetCharaRot(19, 0.0, 0.0, 0.0)
	event.SetReference(13, "b_pre", 19)
	event.SetCharaType(19, 4)
	event.SndSePlay(var4, 2)
	event.SetCharaShow(18, 0)
	event.SetCharaShow(19, 0)
	helper_1c8c39a1(8)
	if vm.skipping() then
		return skip(10)
	end
	event.SetCharaShow(18, 1, 1, 0.08)
	event.SetCharaShow(19, 1, 1, 0.08)
	helper_1c8c39a1(10)
	if vm.skipping() then
		return skip(11)
	end
	event.CharaActive(0, 14)
	event.CharaActive(0, 15)
	event.SetMesWindowMode(0, 1)
	event.SetMesDrawspeed(0, 0)
	helper_7ec0dfb1(0, 2230, 8, 256, 208)
	if vm.skipping() then
		return skip(12)
	end
	helper_7ec0dfb1(0, 2231, 8, 256, 208)
	if vm.skipping() then
		return skip(13)
	end
	event.SetMesShippo(0, 0)
	event.SetMesQuestionGyou(0, 0)
	event.SndSePlay(var4, 3)
	local _ = helper_522670ce(0, 2232, 8, 0, 0)
	var11 = helper_b514f6a8(0, 2, 0, 1)
	if vm.skipping() then
		return skip(14)
	end
	event.SetMesPos(0, 0)
	value = event.GetRandInt(100) or value
	if vm.imod(value, 2) == 0 then
		var14 = arg0
		arg0 = arg2
		arg2 = var14
		var14 = arg1
		arg1 = arg3
		arg3 = var14
	end
	event.LoadItem(5, arg0, "info", 16, 1)
	event.CharaActive(0, 16)
	event.SetCharaPos(16, 0.0, 0.0, 0.0)
	event.SetCharaRot(16, 0.0, 0.0, 0.0)
	event.EohSyncChara(6, 16)
	var15 = helper_2f209e9f(16, arg0, var15)
	event.EohSetScale(6, var15, var15, var15)
	event.LoadItem(5, arg2, "info", 17, 1)
	event.CharaActive(0, 17)
	event.SetCharaPos(17, 0.0, 0.0, 0.0)
	event.SetCharaRot(17, 0.0, 0.0, 0.0)
	event.EohSyncChara(6, 17)
	var15 = helper_2f209e9f(17, arg2, var15)
	event.EohSetScale(6, var15, var15, var15)
	event.CharaActive(1, 16)
	event.SetReference(13, "s_pre", 16)
	event.CharaActive(1, 17)
	event.SetReference(13, "b_pre", 17)
	event.ObjsSetMotion(1, "中身公開", 2)
	if var11 == 0 then
		event.ObjsNextMotion(1, "大きい宝箱", 2)
		event.ObjsNextMotion(1, "大きい宝箱L", 4)
	else
		event.ObjsNextMotion(1, "小さい宝箱", 2)
		event.ObjsNextMotion(1, "小さい宝箱L", 4)
	end
	helper_1c8c39a1(10)
	if vm.skipping() then
		return skip(15)
	end
	event.SetCharaShow(18, 0, 1, 0.04)
	event.SetCharaShow(19, 0, 1, 0.04)
	event.SndSePlay(var4, 4)
	event.SndSePlay(var4, 5)
	helper_1c8c39a1(60)
	if vm.skipping() then
		return skip(16)
	end
	event.SndSePlay(var4, 7)
	helper_1c8c39a1(6)
	if vm.skipping() then
		return skip(17)
	end
	event.SndSePlay(var4, 6)
	helper_c07d0298(1)
	if vm.skipping() then
		return skip(18)
	end
	if var11 == 0 then
		count_2 = event.CheckGetItemLimit(arg2, arg3) or count_2
		if count_2 >= 1 then
			helper_1bfbe759(arg2, count_2)
			if vm.skipping() then
				return skip(19)
			end
		else
			event.SetMesWindowMode(0, 4)
			event.SetMesDrawspeed(0, 1)
			event.SetMesItem(0, 1, arg2)
			event.MesMake_2(0, "Hai ricevuto [アイテム１],\nma non hai spazio sufficiente.")
			helper_7ec0dfb1(0, -1, 8, 0, 0)
			if vm.skipping() then
				return skip(20)
			end
		end
		var17 = arg2
	else
		count_2 = event.CheckGetItemLimit(arg0, arg1) or count_2
		if count_2 >= 1 then
			helper_1bfbe759(arg0, count_2)
			if vm.skipping() then
				return skip(21)
			end
		else
			event.SetMesWindowMode(0, 4)
			event.SetMesDrawspeed(0, 1)
			event.SetMesItem(0, 1, arg0)
			event.MesMake_2(0, "Hai ricevuto [アイテム１],\nma non hai spazio sufficiente.")
			helper_7ec0dfb1(0, -1, 8, 0, 0)
			if vm.skipping() then
				return skip(22)
			end
		end
		var17 = arg0
	end
	event.SetMesDrawspeed(0, 0)
	event.AddItem(var17, count_2)
	argc = event.CheckItemOver() or argc
	if argc >= 1 then
		event.SetFadeOut(10)
		helper_1c8c39a1(10)
		if vm.skipping() then
			return skip(23)
		end
		event.GotoMenu(17)
		if vm.wait() then
			return skip(24)
		end
	end
	event.CharaActive(0)
	event.DngPause(529, 0)
	var9 = 0
	while var9 <= 7 do
		event.DeleteChara(12 + var9)
		var9 = var9 + 1
	end
	event.SetTbAngle(1.0)
	event.SetCrossfade(10)
	event.Finish()
end

--- Helper function.
local function helper_1c780()
	local flags: s32 = 0
	local item_x: s32 = 0
	local item_y: s32 = 0
	local num_x: s32 = 0
	local num_y: s32 = 0
	local now_party_chara_id: s32 = 0
	local var6: any = 0
	local var8: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_522670ce(0, -1, 5, 0, 0)
				var6 = helper_b514f6a8(0, 2, 2, 0)
			end
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			return
		end
		if at <= 5 then
			return
		end
		if at <= 6 then
			var8 = 1
			helper_17a8c(item_x, num_x, item_y, num_y)
		end
		if at <= 7 then
			var8 = 1
			helper_16560(item_x, num_x)
		end
		var8 = 1
	end
	event.Initialize()
	do
		local out1, out2, out3, out4, out5 = event.GetTboxParam()
		flags = out1 or flags
		item_x = out2 or item_x
		item_y = out3 or item_y
		num_x = out4 or num_x
		num_y = out5 or num_y
	end
	print("-----------------------------------------------------------------------------------------\n")
	print("tbox type = ", flags, "\n")
	print("item1 = ", item_x, ", ", num_x, "\n")
	print("item2 = ", item_y, ", ", num_y, "\n")
	print("-----------------------------------------------------------------------------------------\n")
	if bit32.band(flags, 256) ~= 0 then
		now_party_chara_id = event.GetNowPartyChara() or now_party_chara_id
		if now_party_chara_id == 9 then
			event.DngPause(513, 1)
			helper_1c1f308e()
			event.SetMesWindowMode(0, 1)
			event.SetMesShippo(0, 0)
			event.MesMake_2(0, "Eh? Aspetta! C'[UNI00e8] uno strano odore!\n      Occhio! Credo sia un Mimetico.")
			helper_7ec0dfb1(0, -1, 5, 0, 0)
			if vm.skipping() then
				return skip(1)
			end
			event.SetMesQuestionGyou(0, 1)
			event.SetMesShippo(0, 0)
			event.SetMesEtc(0, 0, 1)
			event.SetMesEtc(0, 1, 1)
			event.MesMake_2(0, "Vuoi ancora aprirlo?\nS[UNI00ec].\nNo.")
			helper_522670ce(0, -1, 5, 0, 0)
			var6 = helper_b514f6a8(0, 2, 2, 0)
			if vm.skipping() then
				return skip(2)
			end
			event.SetMesQuestionGyou(0, 0)
			event.SetMesShippo(0, 1)
			event.SetMesEtc(0, 0, 0)
			event.SetMesEtc(0, 1, 0)
			event.DngPause(513, 0)
			if var6 == 1 then
			else
				return
			end
		end
		helper_1c12c(item_x, num_x)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	event.DngPause(513, 1)
	helper_1c1f308e()
	event.SetMesWindowMode(0, 1)
	event.SetMesQuestionGyou(0, 1)
	event.SetMesShippo(0, 0)
	event.SetMesEtc(0, 0, 1)
	event.SetMesEtc(0, 1, 1)
	if bit32.band(flags, 2) ~= 0 then
		local t0: s32
		t0, flags = helper_1a464(flags)
		local t1 = t0
		if vm.skipping() then
			return skip(4)
		end
		if t1 ~= 0 then
			event.DngPause(513, 0)
			event.Finish()
			return
		end
	end
	if bit32.band(flags, 4) ~= 0 then
		local t2: s32
		t2, flags = helper_1b2ec(flags)
		local t3 = t2
		if vm.skipping() then
			return skip(5)
		end
		if t3 ~= 0 then
			event.DngPause(513, 0)
			event.Finish()
			return
		end
	end
	event.SetMesQuestionGyou(0, 0)
	event.SetMesShippo(0, 1)
	event.SetMesEtc(0, 0, 0)
	event.SetMesEtc(0, 1, 0)
	event.DngPause(513, 0)
	event.SetCrossfade(30)
	event.SetStatusbarShow(0, 0.16666667)
	event.CharaActive(0, 0)
	var8 = 0
	if bit32.band(flags, 512) ~= 0 then
		helper_16560(-1, -1)
		if vm.skipping() then
			return skip(6)
		end
		var8 = 1
	end
	if bit32.band(flags, 128) ~= 0 then
		helper_17a8c(item_x, num_x, item_y, num_y)
		if vm.skipping() then
			return skip(7)
		end
		var8 = 1
	end
	if var8 == 0 then
		helper_16560(item_x, num_x)
		if vm.skipping() then
			return skip(8)
		end
		var8 = 1
	end
	event.SetStatusbarShow(1, 0.16666667)
end

--- Helper function.
local function helper_cde4()
	local skip: (number) -> ...any
	function skip(at: number)
		helper_feb439af(1, 7)
		helper_522670ce(1, -1, 15, 0, 0)
	end
	if vm.skipping() then
		return skip(1)
	end
	helper_feb439af(1, 7)
	event.SetMesPreset(1, 2)
	event.MesMake_2(1, "Si ferma con il pulsante (O).")
	helper_522670ce(1, -1, 15, 0, 0)
end

--- Helper function.
local function helper_29734()
	local var0: s32 = 0
	local var1: s32 = 0
	local argc: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
		if at <= 2 then
			helper_d8a5c79b(var0, -1, 0, 1)
		end
	end
	event.SetMesWindowMode(0, 1)
	event.SetMesShippo(0, 1)
	do
		local out1, out2 = event.GetMonsterTalkData_2()
		var0 = out1 or var0
		var1 = out2 or var1
	end
	if var1 < 0 then
		if vm.wait() then
			return skip(1)
		end
		return
	end
	event.DngPause(4096, 1)
	event.AssignStack(5)
	event.ClearStack(5)
	event.SetLoadbgFileMonsTalk()
	while true do
		argc = event.CheckLoadbgFile() or argc
		if argc == 0 then
			break
		else
			if vm.wait() then
				return skip(2)
			end
		end
	end
	event.LoadMesMonsTalk(0, 5)
	event.MesMake_2(0, var1)
	helper_d8a5c79b(var0, -1, 0, 1)
	if vm.skipping() then
		return skip(3)
	end
	event.LoadMes(0, -1)
	event.DngPause(4096, 0)
end

--- Helper function.
local function helper_1d7a0(arg0: s32)
	local language_code: s32 = 0
	local block: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var11: f32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 6 then
			if at <= 2 then
				helper_d0ba87d6()
			end
			if at <= 3 then
				var11 = vm.f32(var11 + vm.f32(0.4))
				helper_1c8c39a1(90)
			end
			if at <= 4 then
				helper_b302ce65(8500160, -1)
			end
			if at <= 5 then
				helper_1c8c39a1(20)
			end
			if vm.skip_end() then
				return skip(7)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		if arg0 == 0 then
			event.SetStatusbarShow(1, 1.0)
		end
		event.SetCameraCtrl(1)
		event.SndSeAllStop(7)
		event.SndSeStop(var3, 0)
		event.LoadBgm(193)
		event.PlayBgm(0)
		event.DelExtMotion(0)
		event.DelImg(0)
		event.SetCrossfade(10)
		event.Finish()
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	if arg0 == 0 then
		event.SetStatusbarShow(0, 1.0)
	end
	language_code = event.GetLanguage() or language_code
	if language_code == 0 then
		event.SetLoadbgFile(
			"dungeon/chara/c01b_win.gltf",
			"textures/dungeon/image/senmetsu/finish.json",
			"snd2/sp/sp_000.sound.json"
		)
	else
		event.SetLoadbgFile(
			"dungeon/chara/c01b_win.gltf",
			"textures/dungeon/image/senmetsu/finish_1.json",
			"snd2/sp/sp_000.sound.json"
		)
	end
	if vm.wait() then
		return skip(2)
	end
	helper_d0ba87d6()
	if vm.skipping() then
		return skip(3)
	end
	event.AssignStack(5)
	event.ClearStack(5)
	event.LoadMotion(5, "dungeon/chara/c01b_win.gltf", "info", 0)
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	if language_code == 0 then
		block = event.LoadImg_4(5, "textures/dungeon/image/senmetsu/finish.json", 0) or block
		event.SpriteInit(0)
		event.SpriteSetType(0, 0)
		event.SpriteSetTexture(0, "senmetu", block)
		event.SpriteSetPos(0, 256, 206)
		event.SpriteSetPutsize(0, 228, 64)
		event.SpriteSetUvsize(0, 0, 0, 255, 64)
		event.SpriteSetColor(0, 128, 128, 128, 0)
		event.SpriteSetScale(0, 5.0, 5.0)
		event.SpriteSetDraw(0, arg0)
	else
		block = event.LoadImg_4(5, "textures/dungeon/image/senmetsu/finish_1.json", 0) or block
		event.SpriteInit(0)
		event.SpriteSetType(0, 0)
		event.SpriteSetTexture(0, "senmetu", block)
		event.SpriteSetPos(0, 256, 206)
		event.SpriteSetPutsize(0, 512, 64)
		event.SpriteSetUvsize(0, 0, 0, 512, 64)
		event.SpriteSetColor(0, 128, 128, 128, 0)
		event.SpriteSetScale(0, 5.0, 5.0)
		event.SpriteSetDraw(0, arg0)
	end
	event.EohSyncSprite(1, 0)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	var3 = event.SndLoadSound(8, "snd2/sp/sp_000.sound.json") or var3
	var4 = event.GetEventInfoSndid(4) or var4
	event.SndSeStop(var4, 0)
	do
		local out1, out2, out3 = event.GetCharaPos(0)
		var5 = out1 or var5
		var6 = out2 or var6
		var7 = out3 or var7
	end
	do
		local out1, out2, out3 = event.GetCameraPos()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	var11 = event.GetRefAngle(var5, var6, var7, pos_x, pos_y, pos_z) or var11
	var11 = vm.f32(var11 + vm.f32(0.4))
	var11 = event.AngleLimit(var11) or var11
	event.SetCameraCtrl(0)
	event.SetFcameraFollowFlag(1)
	event.SetFcameraFollowA(var5, var6 + 16.0, var7)
	event.SetCameraSpeed(14.0)
	event.SetFcameraFollowOfs(0.0, 0.0, 0.0)
	event.SetFcameraHeight(-4.0)
	event.SetFcameraDist(48.0)
	event.EohSyncChara(0, 0)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "目パチ")
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetRot(0, 0.0, var11, 0.0)
	event.ObjsResetDaPosition(0)
	event.SetCrossfade(30)
	event.StopBgm(0)
	event.SndSePlay(var3, 0)
	event.InitDramaScene()
	event.ObjsSetMotion(0, "勝利のポーズ", 6)
	event.ObjsNextMotion(0, "勝利のポーズL", 4)
	event.ObjsSetScale(1, 1.0, 1.0, 0, 60)
	event.ObjsSetColor(1, 128, 128, 128, 128, 60)
	helper_1c8c39a1(90)
	if vm.skipping() then
		return skip(4)
	end
	if language_code == 0 then
		event.ObjsMove(1, 134.0, 370.0, 0, 20)
	else
		event.ObjsMove(1, 214.0, 370.0, 0, 20)
	end
	event.SetPakuAnim(0, "わらい口パク")
	helper_b302ce65(8500160, -1)
	if vm.skipping() then
		return skip(5)
	end
	helper_1c8c39a1(20)
	if vm.skipping() then
		return skip(6)
	end
	return part2()
end

--- Helper function.
local function helper_1eda8(arg0: s32)
	local language_code: s32 = 0
	local block: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var11: f32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 6 then
			if at <= 2 then
				helper_d0ba87d6()
			end
			if at <= 3 then
				var11 = vm.f32(var11 + vm.f32(0.4))
				helper_1c8c39a1(90)
			end
			if at <= 4 then
				helper_b302ce65(8510170, -1)
			end
			if at <= 5 then
				helper_1c8c39a1(20)
			end
			if vm.skip_end() then
				return skip(7)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		if arg0 == 0 then
			event.SetStatusbarShow(1, 1.0)
		end
		event.SetCameraCtrl(1)
		event.SndSeAllStop(7)
		event.SndSeStop(var3, 0)
		event.LoadBgm(193)
		event.PlayBgm(0)
		event.DelExtMotion(0)
		event.DelImg(0)
		event.SetCrossfade(10)
		event.Finish()
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	if arg0 == 0 then
		event.SetStatusbarShow(0, 1.0)
	end
	language_code = event.GetLanguage() or language_code
	if language_code == 0 then
		event.SetLoadbgFile(
			"dungeon/chara/c02a_win.gltf",
			"textures/dungeon/image/senmetsu/finish.json",
			"snd2/sp/sp_000.sound.json"
		)
	else
		event.SetLoadbgFile(
			"dungeon/chara/c02a_win.gltf",
			"textures/dungeon/image/senmetsu/finish_1.json",
			"snd2/sp/sp_000.sound.json"
		)
	end
	if vm.wait() then
		return skip(2)
	end
	helper_d0ba87d6()
	if vm.skipping() then
		return skip(3)
	end
	event.AssignStack(5)
	event.ClearStack(5)
	event.LoadMotion(5, "dungeon/chara/c02a_win.gltf", "info", 0)
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	if language_code == 0 then
		block = event.LoadImg_4(5, "textures/dungeon/image/senmetsu/finish.json", 0) or block
		event.SpriteInit(0)
		event.SpriteSetType(0, 0)
		event.SpriteSetTexture(0, "senmetu", block)
		event.SpriteSetPos(0, 256, 206)
		event.SpriteSetPutsize(0, 228, 64)
		event.SpriteSetUvsize(0, 0, 0, 255, 64)
		event.SpriteSetColor(0, 128, 128, 128, 0)
		event.SpriteSetScale(0, 5.0, 5.0)
		event.SpriteSetDraw(0, arg0)
	else
		block = event.LoadImg_4(5, "textures/dungeon/image/senmetsu/finish_1.json", 0) or block
		event.SpriteInit(0)
		event.SpriteSetType(0, 0)
		event.SpriteSetTexture(0, "senmetu", block)
		event.SpriteSetPos(0, 256, 206)
		event.SpriteSetPutsize(0, 512, 64)
		event.SpriteSetUvsize(0, 0, 0, 512, 64)
		event.SpriteSetColor(0, 128, 128, 128, 0)
		event.SpriteSetScale(0, 5.0, 5.0)
		event.SpriteSetDraw(0, arg0)
	end
	event.EohSyncSprite(1, 0)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	var3 = event.SndLoadSound(8, "snd2/sp/sp_000.sound.json") or var3
	var4 = event.GetEventInfoSndid(4) or var4
	event.SndSeStop(var4, 0)
	do
		local out1, out2, out3 = event.GetCharaPos(0)
		var5 = out1 or var5
		var6 = out2 or var6
		var7 = out3 or var7
	end
	do
		local out1, out2, out3 = event.GetCameraPos()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	var11 = event.GetRefAngle(var5, var6, var7, pos_x, pos_y, pos_z) or var11
	var11 = vm.f32(var11 + vm.f32(0.4))
	var11 = event.AngleLimit(var11) or var11
	event.SetCameraCtrl(0)
	event.SetFcameraFollowFlag(1)
	event.SetFcameraFollowA(var5, var6 + 16.0, var7)
	event.SetCameraSpeed(14.0)
	event.SetFcameraFollowOfs(0.0, 0.0, 0.0)
	event.SetFcameraHeight(-4.0)
	event.SetFcameraDist(48.0)
	event.EohSyncChara(0, 0)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "目パチ")
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetRot(0, 0.0, var11, 0.0)
	event.ObjsResetDaPosition(0)
	event.SetCrossfade(30)
	event.StopBgm(0)
	event.SndSePlay(var3, 0)
	event.InitDramaScene()
	event.ObjsSetMotion(0, "勝利のポーズ", 6)
	event.ObjsNextMotion(0, "勝利のポーズL", 6, 0.04)
	event.ObjsNextMotion(0, "余韻", 6)
	event.ObjsNextMotion(0, "余韻L", 4)
	event.ObjsSetScale(1, 1.0, 1.0, 0, 60)
	event.ObjsSetColor(1, 128, 128, 128, 128, 60)
	helper_1c8c39a1(90)
	if vm.skipping() then
		return skip(4)
	end
	if language_code == 0 then
		event.ObjsMove(1, 134.0, 370.0, 0, 20)
	else
		event.ObjsMove(1, 214.0, 370.0, 0, 20)
	end
	event.SetPakuAnim(0, "わらい口パク")
	helper_b302ce65(8510170, -1)
	if vm.skipping() then
		return skip(5)
	end
	helper_1c8c39a1(20)
	if vm.skipping() then
		return skip(6)
	end
	return part2()
end

--- Helper function.
local function helper_20474(arg0: s32)
	local block: s32 = 0
	local language_code: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local language_code_2: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_1c1f308e()
				helper_1c8c39a1(90)
			end
			if at <= 2 then
				helper_1c8c39a1(70)
			end
			if vm.skip_end() then
				return skip(4)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SetCameraCtrl(1)
		event.SetFadeIn(1)
		event.SndSeStop(var3, 0)
		event.LoadBgm(193)
		event.PlayBgm(0)
		event.DelImg(0)
		event.SetCrossfade(10)
		event.Finish()
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	event.InitDramaScene()
	helper_1c1f308e()
	event.AssignStack(5)
	event.ClearStack(5)
	language_code = event.GetLanguage() or language_code
	if language_code == 0 then
		block = event.LoadImg_4(5, "textures/dungeon/image/senmetsu/finish.json", 0) or block
		event.SpriteInit(0)
		event.SpriteSetType(0, 0)
		event.SpriteSetTexture(0, "senmetu", block)
		event.SpriteSetPos(0, 256, 206)
		event.SpriteSetPutsize(0, 228, 64)
		event.SpriteSetUvsize(0, 0, 0, 255, 64)
		event.SpriteSetColor(0, 128, 128, 128, 0)
		event.SpriteSetScale(0, 5.0, 5.0)
		event.SpriteSetDraw(0, 1)
	else
		block = event.LoadImg_4(5, "textures/dungeon/image/senmetsu/finish_1.json", 0) or block
		event.SpriteInit(0)
		event.SpriteSetType(0, 0)
		event.SpriteSetTexture(0, "senmetu", block)
		event.SpriteSetPos(0, 256, 206)
		event.SpriteSetPutsize(0, 512, 64)
		event.SpriteSetUvsize(0, 0, 0, 512, 64)
		event.SpriteSetColor(0, 128, 128, 128, 0)
		event.SpriteSetScale(0, 5.0, 5.0)
		event.SpriteSetDraw(0, 1)
	end
	var3 = event.SndLoadSound(8, "snd2/sp/sp_000.sound.json") or var3
	var4 = event.GetEventInfoSndid(4) or var4
	event.SndSeStop(var4, 0)
	event.StopBgm(0)
	event.SndSePlay(var3, 0)
	do
		local out1, out2, out3 = event.GetCharaPos(0)
		var5 = out1 or var5
		var6 = out2 or var6
		var7 = out3 or var7
	end
	do
		local out1, out2, out3 = event.GetCameraPos()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	event.SetCameraCtrl(0)
	event.SetFcameraFollowFlag(1)
	if arg0 == 2 then
		event.SetFcameraFollowA(var5, var6 + 40.0, var7)
	else
		event.SetFcameraFollowA(var5, var6 + 20.0, var7)
	end
	event.SetCameraSpeed(16.0)
	event.SetFcameraFollowOfs(0.0, 0.0, 0.0)
	event.SetFcameraHeight(10.0)
	event.SetFcameraDist(64.0)
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsReference(0, pos_x, pos_y, pos_z, 10)
	event.EohSyncSprite(1, 0)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.ObjsSetScale(1, 1.0, 1.0, 0, 60)
	event.ObjsSetColor(1, 128, 128, 128, 128, 60)
	helper_1c8c39a1(90)
	if vm.skipping() then
		return skip(2)
	end
	language_code_2 = event.GetLanguage() or language_code_2
	if language_code_2 == 0 then
		event.ObjsMove(1, 134.0, 370.0, 0, 20)
	else
		event.ObjsMove(1, 214.0, 370.0, 0, 20)
	end
	helper_1c8c39a1(70)
	if vm.skipping() then
		return skip(3)
	end
	return part2()
end

--- Helper function.
local function helper_13df8()
	local var0: any = 0
	local active_chr_no: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local var12: f32 = 0
	local box_pos_x: f32 = 0
	local box_pos_y: f32 = 0
	local box_pos_z: f32 = 0
	local var17: f32 = 0
	local var18: f32 = 0
	local var19: f32 = 0
	local var20: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var0 = helper_6efad7f4(0, 2002, 8, 256, 208, 2, 1)
		end
		if at <= 2 then
			var0 = helper_6efad7f4(0, -1, 8, 256, 208, 2, 1)
		end
		var3 = 0
		var17 = vm.f32(var17 + 1.0)
		var19 = vm.f32(var19 + 1.0)
		var3 = var3 + 1
		var20 = vm.f32(var20 - vm.f32(3.1415927))
		var10 = vm.f32(vm.f32(vm.sin(var20) * 100.0) + var10)
		var11 = vm.f32(var11 + 30.0)
		var12 = vm.f32(vm.f32(vm.cos(var20) * 100.0) + var12)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesWindowMode(0, 5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		event.SetMesQuestionGyou(0, 0)
		var0 = helper_6efad7f4(0, 2002, 8, 256, 208, 2, 1)
		if vm.skipping() then
			return skip(2)
		end
	else
		event.SetMesQuestionGyou(0, 0)
		event.MesMake_2(0, "Muovere Max verso la Sphera?")
		var0 = helper_6efad7f4(0, -1, 8, 256, 208, 2, 1)
		if vm.skipping() then
			return skip(3)
		end
	end
	if vm.wait() then
		return skip(4)
	end
	if var0 == 0 then
		do
			local out1, out2, out3 = event.SphidaGetBallPos()
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		event.SphidaGetPinPos()
		do
			local out1, out2, out3, out4 = event.GetPartsFuncPos(pos_x, pos_y, pos_z, 100.0, "point")
			var2 = out1 or var2
			var10 = out2 or var10
			var11 = out3 or var11
			var12 = out4 or var12
		end
		if var2 == 0 then
			do
				local out1, out2, out3 = event.GetPartsOrigin(pos_x, pos_y, pos_z, 100.0)
				var10 = out1 or var10
				var11 = out2 or var11
				var12 = out3 or var12
			end
		end
		var3 = 0
		do
			local out1, out2, out3, out4 = event.GetNearTboxPos(var10, var11, var12)
			box_pos_x = out1 or box_pos_x
			box_pos_y = out2 or box_pos_y
			box_pos_z = out3 or box_pos_z
			var2 = out4 or var2
		end
		while var2 >= 0 do
			do
				local out1, out2, out3 = event.CopyVector(var10, var11, var12)
				var17 = out1 or var17
				var18 = out2 or var18
				var19 = out3 or var19
			end
			do
				local out1, out2, out3 = event.SubVector(var17, var18, var19, box_pos_x, box_pos_y, box_pos_z)
				var17 = out1 or var17
				var18 = out2 or var18
				var19 = out3 or var19
			end
			var17 = vm.f32(var17 + 1.0)
			var19 = vm.f32(var19 + 1.0)
			do
				local out1, out2, out3 = event.NormalVector(var17, var18, var19)
				var17 = out1 or var17
				var18 = out2 or var18
				var19 = out3 or var19
			end
			do
				local out1, out2, out3 = event.ScaleVector(var17, var18, var19, 30.1)
				var17 = out1 or var17
				var18 = out2 or var18
				var19 = out3 or var19
			end
			do
				local out1, out2, out3 = event.CopyVector(box_pos_x, box_pos_y, box_pos_z)
				var10 = out1 or var10
				var11 = out2 or var11
				var12 = out3 or var12
			end
			do
				local out1, out2, out3 = event.AddVector(var10, var11, var12, var17, var18, var19)
				var10 = out1 or var10
				var11 = out2 or var11
				var12 = out3 or var12
			end
			var3 = var3 + 1
			if var3 > 6 then
				break
			else
				do
					local out1, out2, out3, out4 = event.GetNearTboxPos(var10, var11, var12)
					box_pos_x = out1 or box_pos_x
					box_pos_y = out2 or box_pos_y
					box_pos_z = out3 or box_pos_z
					var2 = out4 or var2
				end
			end
		end
		var20 = event.GetRefAngle(var10, var11, var12, pos_x, pos_y, pos_z) or var20
		event.SetCharaPos(0, var10, var11, var12)
		event.SetCharaRot(0, 0.0, var20, 0.0)
		event.SetCameraRef(var10, var11 + 30.0, var12)
		var20 = vm.f32(var20 - vm.f32(3.1415927))
		var20 = event.AngleLimit(var20) or var20
		var10 = vm.f32(vm.f32(vm.sin(var20) * 100.0) + var10)
		var11 = vm.f32(var11 + 30.0)
		var12 = vm.f32(vm.f32(vm.cos(var20) * 100.0) + var12)
		event.SetCameraPos(var10, var11, var12)
		event.SetFcameraFollowOfs(0.0, 30.0, 0.0)
		event.SetFcameraHeight(5.0)
		event.SetFcameraDist(160.0)
		event.SetCameraSpeed(6.0)
		event.CtrlcSetRotCancel(1)
		event.CtrlcMoveRange(18.0, 10.0, 100.0, 160.0)
		event.ResetCamera(0)
	end
end

--- Helper function.
local function helper_21530()
	local active_chr_no: s32 = 0
	local stage_id: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local flag: s32 = 0
	local is_play_sub_game: s32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local is_clear_most_fast_destroy: s32 = 0
	local cleared: s32 = 0
	local bonus: s32 = 0
	local var12: s32 = 0
	local var13: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	local part3: () -> ...any
	local part4: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_1d7a0(1)
			if not vm.skipping() then
				return part2()
			end
		end
		if at <= 2 then
			helper_1eda8(1)
			if not vm.skipping() then
				return part3()
			end
		end
		if at <= 3 then
			helper_20474(active_chr_no)
			if not vm.skipping() then
				return part4()
			end
		end
		if at <= 4 then
			helper_574f31f8()
			helper_c3c7815d(0, -1)
			helper_123ec(is_clear_most_fast_destroy, cleared, bonus)
		end
		if at <= 5 then
			helper_7ec0dfb1(0, -1, 8, 0, 0)
		end
		if at <= 6 then
			helper_7ec0dfb1(0, 2130, 8, 0, 0)
		end
		if at <= 7 then
			helper_7ec0dfb1(0, 2120, 8, 0, 0)
		end
		if at <= 8 then
			helper_13df8()
		end
		if at <= 9 then
			helper_7ec0dfb1(0, 2110, 8, 0, 0)
		end
		if at <= 10 then
			helper_7ec0dfb1(0, 2100, 8, 0, 0)
		end
		if at <= 11 then
			helper_13df8()
		end
	end
	function part2()
		if active_chr_no == 1 then
			helper_1eda8(1)
			if vm.skipping() then
				return skip(3)
			end
		end
		return part3()
	end
	function part3()
		if active_chr_no == 2 or active_chr_no == 3 then
			helper_20474(active_chr_no)
			if vm.skipping() then
				return skip(4)
			end
		end
		return part4()
	end
	function part4()
		event.DngPause(16384, 0)
		helper_574f31f8()
		event.ActchrSetDefMotion(0, 4)
		event.CharaNormalDrive(0)
		event.CharaResetDa(0)
		event.SetStatusbarShow(1, 0.16666667)
		stage_id = event.DngGetStageId() or stage_id
		var2 = event.DngGetFloorId() or var2
		event.SetFloorInfo(stage_id, var2, 5, 2)
		event.SetFloorInfo(stage_id, var2, 5, 1024)
		flag = event.GetFlag(220) or flag
		flag = event.GetFlag(317) or flag
		is_play_sub_game = event.IsPlaySubGame() or is_play_sub_game
		if (if flag == 1 then bit32.band(is_play_sub_game, 1) else 0) ~= 0 then
			event.ClearRndStone()
			helper_c3c7815d(0, -1)
		end
		do
			local out1, out2, out3 = event.GetBeforeCameraNextPos()
			position_x = out1 or position_x
			position_y = out2 or position_y
			position_z = out3 or position_z
		end
		event.SetCameraPos(position_x, position_y, position_z)
		do
			local out1, out2, out3 = event.GetBeforeCameraNextRef()
			position_x = out1 or position_x
			position_y = out2 or position_y
			position_z = out3 or position_z
		end
		event.SetCameraRef(position_x, position_y, position_z)
		is_clear_most_fast_destroy = event.IsClearDestroy() or is_clear_most_fast_destroy
		do
			local out1, out2 = event.IsClearPractice(0)
			cleared = out1 or cleared
			bonus = out2 or bonus
		end
		helper_123ec(is_clear_most_fast_destroy, cleared, bonus)
		if vm.skipping() then
			return skip(5)
		end
		event.SetMesWindowMode(0, 4)
		event.SetMesDrawspeed(0, 1)
		var12 = event.GetTrialVersion() or var12
		var13 = event.GetFloorStatus() or var13
		if
			(if (if bit32.band(var13, 1) ~= 0 then 1 else bit32.band(var13, 2)) ~= 0 then 1 else bit32.band(var13, 4))
			~= 0
		then
			event.SetFloorStatus(7, 0)
			if bit32.band(var13, 1) ~= 0 then
				event.MesMake_2(0, "Il Sigillo rosso [UNI00e8] stato infranto.")
			end
			if bit32.band(var13, 2) ~= 0 then
				event.MesMake_2(0, "Il Sigillo blu [UNI00e8] stato infranto.")
			end
			if bit32.band(var13, 4) ~= 0 then
				event.MesMake_2(0, "Il Sigillo bianco [UNI00e8] stato infranto.")
			end
			helper_7ec0dfb1(0, -1, 8, 0, 0)
			if vm.skipping() then
				return skip(6)
			end
		end
		helper_7ec0dfb1(0, 2130, 8, 0, 0)
		if vm.skipping() then
			return skip(7)
		end
		if var12 ~= 1 then
			if var3 == 1 and flag == 1 and bit32.band(is_play_sub_game, 3) == 3 then
				helper_7ec0dfb1(0, 2120, 8, 0, 0)
				if vm.skipping() then
					return skip(8)
				end
				helper_13df8()
				if vm.skipping() then
					return skip(9)
				end
			else
				if (if var3 == 1 then bit32.band(is_play_sub_game, 1) else 0) ~= 0 then
					helper_7ec0dfb1(0, 2110, 8, 0, 0)
					if vm.skipping() then
						return skip(10)
					end
				end
				if (if flag == 1 then bit32.band(is_play_sub_game, 1) else 0) ~= 0 then
					helper_7ec0dfb1(0, 2100, 8, 0, 0)
					if vm.skipping() then
						return skip(11)
					end
					helper_13df8()
					if vm.skipping() then
						return skip(12)
					end
				end
			end
		end
		event.SetMesWindowMode(0, 1)
		event.SetMesDrawspeed(0, 0)
		event.DngPause(512, 0)
		event.Finish()
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	helper_1c1f308e()
	event.DngPause(512, 1)
	event.SetStatusbarShow(0, 0.16666667)
	helper_1c8c39a1(10)
	if vm.skipping() then
		return skip(1)
	end
	event.DngPause(16384, 1)
	event.DelMonster(-1)
	if active_chr_no == 0 then
		helper_1d7a0(1)
		if vm.skipping() then
			return skip(2)
		end
	end
	return part2()
end

--- Helper function.
local function helper_2efd0()
	local active_chr_no: s32 = 0
	local var1: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_7ec0dfb1(0, 2000, 8, 0, 0)
			end
			return 1
		end
		return 1
	end
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no ~= 0 then
		event.SetMesWindowMode(0, 4)
		helper_7ec0dfb1(0, 2000, 8, 0, 0)
		if vm.skipping() then
			return skip(2)
		end
		return 1
	end
	var1 = event.GetEquipItemno(0, 0) or var1
	if var1 ~= 9 and var1 ~= 10 and var1 ~= 11 and var1 ~= 12 and var1 ~= 13 and var1 ~= 14 then
		event.SetMesWindowMode(0, 4)
		helper_7ec0dfb1(0, 2001, 8, 0, 0)
		if vm.skipping() then
			return skip(3)
		end
		return 1
	end
	event.SetMesWindowMode(0, 1)
	event.SphidaSetCulbNo(var1)
	event.PadAutoRepeatOff()
	return 0
end

--- Helper function.
local function helper_2b8f8(arg0: f32, arg1: f32, arg2: f32, arg3: f32, arg4: f32)
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local x_2: f32 = 0
	local y_2: f32 = 0
	local z_2: f32 = 0
	local angle: f32 = 0
	local var12: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		x = vm.f32(vm.sin(arg3) * 16.0)
		y = 8.0
		z = vm.f32(vm.cos(arg3) * 16.0)
		angle = vm.f32(arg4 - arg3)
		arg4 = vm.f32(arg3 + 0.5)
		arg3 = vm.f32(arg3 + vm.f32(0.2))
		arg4 = vm.f32(arg3 - 0.5)
		x_2 = vm.f32(vm.sin(arg4) * 16.0)
		y_2 = 8.0
		z_2 = vm.f32(vm.cos(arg4) * 16.0)
		return -1
	end
	if vm.skipping() then
		return skip(1)
	end
	arg3 = event.AngleLimit(arg3) or arg3
	arg3 = event.AngleLimit(arg3) or arg3
	arg4 = event.AngleLimit(arg4) or arg4
	arg4 = event.AngleLimit(arg4) or arg4
	x = vm.f32(vm.sin(arg3) * 16.0)
	y = 8.0
	z = vm.f32(vm.cos(arg3) * 16.0)
	if arg4 ~= arg3 then
		angle = vm.f32(arg4 - arg3)
		angle = event.AngleLimit(angle) or angle
		if angle > 0.0 then
			arg4 = vm.f32(arg3 + 0.5)
		else
			arg3 = vm.f32(arg3 + vm.f32(0.2))
			arg4 = vm.f32(arg3 - 0.5)
		end
	end
	arg4 = event.AngleLimit(arg4) or arg4
	x_2 = vm.f32(vm.sin(arg4) * 16.0)
	y_2 = 8.0
	z_2 = vm.f32(vm.cos(arg4) * 16.0)
	do
		local out1, out2, out3 = event.AddVector(x, y, z, arg0, arg1, arg2)
		x = out1 or x
		y = out2 or y
		z = out3 or z
	end
	do
		local out1, out2, out3 = event.AddVector(x_2, y_2, z_2, arg0, arg1, arg2)
		x_2 = out1 or x_2
		y_2 = out2 or y_2
		z_2 = out3 or z_2
	end
	var12 = event.ChkIntersectionPoint_9(12, x, y, z, arg0, arg1 + 8.0, arg2, 1) or var12
	if var12 >= 0 then
		return -1
	end
	var12 = event.ChkIntersectionPoint_9(12, x_2, y_2, z_2, arg0, arg1 + 8.0, arg2, 1) or var12
	if var12 >= 0 then
		return -1
	end
	var12 = event.ChkIntersectionPoint_9(12, x, y, z, x_2, y_2, z_2, 1) or var12
	if var12 >= 0 then
		return 0
	end
	var12 = event.ChkIntersectionPoint_9(12, x, y, z, x, y - 16.0, z, 1) or var12
	if var12 < 0 then
		return 0
	end
	var12 = event.ChkIntersectionPoint_9(12, x_2, y_2, z_2, x_2, y_2 - 16.0, z_2, 1) or var12
	if var12 < 0 then
		return 0
	end
	return 1
end

--- Helper function.
local function helper_2f3ec(arg0: f32, arg1: f32, arg2: f32, arg3: f32)
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		arg1 = vm.f32(arg1 + 3.0)
		var7 = 0.0
		var8 = 0.0
		var9 = helper_2b8f8(
			arg0,
			arg1,
			arg2,
			vm.f32(vm.f32(arg3 + var8) + vm.f32(1.5707964)),
			vm.f32(vm.f32(arg3 + var7) + vm.f32(1.5707964))
		)
		arg3 = vm.f32(arg3 + var7)
		var9 = helper_2b8f8(
			arg0,
			arg1,
			arg2,
			vm.f32(vm.f32(arg3 - var8) + vm.f32(1.5707964)),
			vm.f32(vm.f32(arg3 - var7) + vm.f32(1.5707964))
		)
		arg3 = vm.f32(arg3 - var7)
		var8 = var7
		var7 = vm.f32(var7 + vm.f32(0.3926991))
		return arg0, arg1, arg2, arg3
	end
	if vm.skipping() then
		return skip(1)
	end
	do
		local out1, out2, out3 = event.GetCharaPos(0)
		arg0 = out1 or arg0
		arg1 = out2 or arg1
		arg2 = out3 or arg2
	end
	event.SphidaSetBallPos(arg0, arg1 + 3.0, arg2)
	event.SetCharaPos(8, arg0, arg1 + 3.0, arg2)
	event.SetCharaPos(9, arg0, arg1 + 3.0, arg2)
	arg1 = vm.f32(arg1 + 3.0)
	do
		local out1, out2, out3 = event.SphidaGetPinPos()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	arg3 = event.GetRefAngle(arg0, arg1, arg2, pos_x, pos_y, pos_z) or arg3
	var7 = 0.0
	var8 = 0.0
	while var7 <= vm.f32(3.1415927) do
		var9 = helper_2b8f8(
			arg0,
			arg1,
			arg2,
			vm.f32(vm.f32(arg3 + var8) + vm.f32(1.5707964)),
			vm.f32(vm.f32(arg3 + var7) + vm.f32(1.5707964))
		)
		if var9 == 1 then
			arg3 = vm.f32(arg3 + var7)
			break
		else
			var9 = helper_2b8f8(
				arg0,
				arg1,
				arg2,
				vm.f32(vm.f32(arg3 - var8) + vm.f32(1.5707964)),
				vm.f32(vm.f32(arg3 - var7) + vm.f32(1.5707964))
			)
			if var9 == 1 then
				arg3 = vm.f32(arg3 - var7)
				break
			else
				var8 = var7
				var7 = vm.f32(var7 + vm.f32(0.3926991))
			end
		end
	end
	event.SetCharaRot(0, 0.0, arg3, 0.0)
	event.SetMotion(0, "かまえ", 4)
	event.CharaNormalDrive(0)
	event.CharaResetDa(0)
	return arg0, arg1, arg2, arg3
end

--- Helper function.
local function helper_2fd58(arg0: f32)
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		var2 = vm.f32(var2 + 25.0)
		arg0 = vm.f32(arg0 - vm.f32(3.1415927))
		var1 = vm.f32(vm.f32(vm.sin(arg0) * 100.0) + var1)
		var2 = vm.f32(var2 + 0.0)
		var3 = vm.f32(vm.f32(vm.cos(arg0) * 100.0) + var3)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetCameraCtrl(0)
	do
		local out1, out2, out3 = event.GetCharaPos(0)
		var1 = out1 or var1
		var2 = out2 or var2
		var3 = out3 or var3
	end
	var2 = vm.f32(var2 + 25.0)
	event.SetCameraRef(var1, var2, var3)
	arg0 = vm.f32(arg0 - vm.f32(3.1415927))
	arg0 = event.AngleLimit(arg0) or arg0
	var1 = vm.f32(vm.f32(vm.sin(arg0) * 100.0) + var1)
	var2 = vm.f32(var2 + 0.0)
	var3 = vm.f32(vm.f32(vm.cos(arg0) * 100.0) + var3)
	event.SetCameraPos(var1, var2, var3)
	event.SetCameraCtrl(1)
	event.CtrlcMoveRange(10.0, 40.0, 60.0, 160.0)
end

--- Helper function.
local function helper_30f94(arg0: f32, arg1: f32, arg2: s32)
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		return arg0, arg1, arg2
	end
	if vm.skipping() then
		return skip(1)
	end
	var3 = event.GetEquipItemno(0, 0) or var3
	do
		local out1, out2, out3 = event.SphidaGetCulbDef(var3)
		arg0 = out1 or arg0
		arg1 = out2 or arg1
		arg2 = out3 or arg2
	end
	return arg0, arg1, arg2
end

--- Helper function.
local function helper_29ad8(arg0: f32, arg1: f32, arg2: s32, sp: number)
	local language_code: s32 = 0
	local mini_level: s32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local var12: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	local var15: f32 = 0
	local var16: f32 = 0
	local var18: f32 = 0
	local var19: s32 = 0
	local var20: f32 = 0
	local var21: f32 = 0
	local var22: f32 = 0
	local var23: f32 = 0
	local var24: f32 = 0
	local var25: f32 = 0
	local var26: f32 = 0
	local var27: f32 = 0
	local var28: f32 = 0
	local var29: f32 = 0
	local var30: s32 = 0
	local var31: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		language_code = 0
		language_code = language_code + 1
		mini_level = 0
		var6 = vm.f32(var6 + 3.0)
		var15 = vm.f32(var15 + 3.0)
		var18 = 100.0
		var11 = vm.f32(vm.sin(arg0) * vm.f32(20.0 * vm.cos(vm.f32(vm.f32(arg1 * vm.f32(3.1415927)) / 180.0))))
		var12 = vm.f32(20.0 * vm.sin(vm.f32(vm.f32(arg1 * vm.f32(3.1415927)) / 180.0)))
		var13 = vm.f32(vm.cos(arg0) * vm.f32(20.0 * vm.cos(vm.f32(vm.f32(arg1 * vm.f32(3.1415927)) / 180.0))))
		var19 = 0
		language_code = 0
		var18 = 100.0
		vm.stack(sp + 52)
		var18 = vm.f32(var18 - var29)
		vm.stack(sp + 47)
		var31 = vm.f32(20.0 - var29)
		vm.stack(sp + 43)
		var18 = vm.f32(var18 - var31)
		vm.stack(sp + 47)
		language_code = language_code + 1
		vm.stack(sp + 46)
		mini_level = mini_level + 1
		vm.stack(sp + 51)
		language_code = language_code + 1
		vm.stack(sp + 50)
		mini_level = mini_level + 1
		vm.stack(sp + 55)
		language_code = language_code + 1
		vm.stack(sp + 54)
		mini_level = mini_level + 1
		vm.stack(sp + 57)
		var19 = var19 + 1
		vm.stack(sp + 51)
	end
	if vm.skipping() then
		return skip(1)
	end
	language_code = 0
	while language_code < 48 do
		event.SpriteInit(language_code)
		event.SpriteSetType(language_code, 1)
		event.SpriteSetTexture(language_code, "sphida_bar", arg2)
		event.SpriteSetUvsize(language_code, 64, 0, 32, 32)
		event.SpriteSetPutsize(language_code, 2, 2)
		event.SpriteSetColor(language_code, 128, 128, 128, 128)
		event.SpriteSetDraw(language_code, 0)
		language_code = language_code + 1
	end
	mini_level = event.SphidaGetMiniLevel() or mini_level
	if mini_level == 0 then
		language_code = event.GetLanguage() or language_code
		event.SpriteSetType(31, 0)
		event.SpriteSetDraw(31, 1)
		if language_code == 0 then
			event.SpriteSetUvsize(31, 308, 146, 204, 30)
			event.SpriteSetPutsize(31, 204, 30)
			event.SpriteSetPos(31, 120, 30)
		else
			event.SpriteSetUvsize(31, 286, 146, 226, 30)
			event.SpriteSetPutsize(31, 226, 30)
			event.SpriteSetPos(31, 140, 30)
		end
	end
	mini_level = 0
	do
		local out1, out2, out3 = event.GetCharaPos(0)
		var5 = out1 or var5
		var6 = out2 or var6
		var7 = out3 or var7
	end
	do
		local out1, out2, out3 = event.GetCharaPos(0)
		var14 = out1 or var14
		var15 = out2 or var15
		var16 = out3 or var16
	end
	var6 = vm.f32(var6 + 3.0)
	var15 = vm.f32(var15 + 3.0)
	var18 = 100.0
	var11 = vm.f32(vm.sin(arg0) * vm.f32(20.0 * vm.cos(vm.f32(vm.f32(arg1 * vm.f32(3.1415927)) / 180.0))))
	var12 = vm.f32(20.0 * vm.sin(vm.f32(vm.f32(arg1 * vm.f32(3.1415927)) / 180.0)))
	var13 = vm.f32(vm.cos(arg0) * vm.f32(20.0 * vm.cos(vm.f32(vm.f32(arg1 * vm.f32(3.1415927)) / 180.0))))
	do
		local out1, out2, out3 = event.CopyVector(var11, var12, var13)
		var8 = out1 or var8
		var9 = out2 or var9
		var10 = out3 or var10
	end
	do
		local out1, out2, out3 = event.ScaleVector(var8, var9, var10, 5.0)
		var8 = out1 or var8
		var9 = out2 or var9
		var10 = out3 or var10
	end
	var19 = 0
	language_code = 0
	while var19 < 6 do
		var18 = 100.0
		do
			local out1, out2, out3 = event.CopyVector(var11, var12, var13)
			var8 = out1 or var8
			var9 = out2 or var9
			var10 = out3 or var10
		end
		do
			local out1, out2, out3 = event.ScaleVector(var8, var9, var10, 5.0)
			var8 = out1 or var8
			var9 = out2 or var9
			var10 = out3 or var10
		end
		while true do
			do
				local out1, out2, out3 = event.AddVector(var5, var6, var7, var8, var9, var10)
				var5 = out1 or var5
				var6 = out2 or var6
				var7 = out3 or var7
			end
			vm.stack(sp + 47)
			do
				local out1, out2, out3, out4, out5, out6, out7 =
					event.ChkIntersectionPoint_15(12, var14, var15, var16, var5, var6, var7, 1)
				var20 = out1 or var20
				var21 = out2 or var21
				var22 = out3 or var22
				var23 = out4 or var23
				var24 = out5 or var24
				var25 = out6 or var25
				var30 = out7 or var30
			end
			if var30 >= 0 then
				do
					local out1, out2, out3 = event.CopyVector(-var11, -var12, -var13)
					var26 = out1 or var26
					var27 = out2 or var27
					var28 = out3 or var28
				end
				do
					local out1, out2, out3 = event.NormalVector(var26, var27, var28)
					var26 = out1 or var26
					var27 = out2 or var27
					var28 = out3 or var28
				end
				do
					local out1, out2, out3 = event.ScaleVector(var26, var27, var28, 3.0)
					var26 = out1 or var26
					var27 = out2 or var27
					var28 = out3 or var28
				end
				do
					local out1, out2, out3 = event.AddVector(var20, var21, var22, var26, var27, var28)
					var20 = out1 or var20
					var21 = out2 or var21
					var22 = out3 or var22
				end
				var29 = event.DistVector2(var14, var15, var16, var20, var21, var22) or var29
				var18 = vm.f32(var18 - var29)
				if var18 <= 0.0 then
					break
				end
				while true do
					var29 = event.DistVector2(var14, var15, var16, var20, var21, var22) or var29
					if var29 <= 20.0 then
						var31 = vm.f32(20.0 - var29)
						var18 = vm.f32(var18 - var31)
						do
							local out1, out2, out3 = event.CopyVector(var20, var21, var22)
							var14 = out1 or var14
							var15 = out2 or var15
							var16 = out3 or var16
						end
						break
					end
					do
						local out1, out2, out3 = event.AddVector(var14, var15, var16, var11, var12, var13)
						var14 = out1 or var14
						var15 = out2 or var15
						var16 = out3 or var16
					end
					event.SpriteSetPos(language_code, var14, var15, var16)
					event.SpriteSetDraw(language_code, 1)
					language_code = vm.i32(language_code + 1)
					if vm.imod(language_code, 6) == 0 then
						event.SphidaSetMmLinePos(mini_level, var14, var15, var16)
						mini_level = vm.i32(mini_level + 1)
					end
					if vm.imod(language_code, 5) == 0 then
						break
					end
					if language_code >= 31 then
						break
					end
				end
				if language_code >= 31 then
					break
				end
				do
					local out1, out2, out3 = event.CopyVector(var23, var24, var25)
					var11 = out1 or var11
					var12 = out2 or var12
					var13 = out3 or var13
				end
				do
					local out1, out2, out3 = event.ScaleVector(var11, var12, var13, var31)
					var11 = out1 or var11
					var12 = out2 or var12
					var13 = out3 or var13
				end
				do
					local out1, out2, out3 = event.AddVector(var14, var15, var16, var11, var12, var13)
					var14 = out1 or var14
					var15 = out2 or var15
					var16 = out3 or var16
				end
				event.SpriteSetPos(language_code, var14, var15, var16)
				event.SpriteSetDraw(language_code, 1)
				language_code = language_code + 1
				if vm.imod(language_code, 6) == 0 then
					event.SphidaSetMmLinePos(mini_level, var14, var15, var16)
					mini_level = vm.i32(mini_level + 1)
				end
				if language_code >= 31 then
					break
				end
				do
					local out1, out2, out3 = event.CopyVector(var23, var24, var25)
					var11 = out1 or var11
					var12 = out2 or var12
					var13 = out3 or var13
				end
				do
					local out1, out2, out3 = event.ScaleVector(var11, var12, var13, 20.0)
					var11 = out1 or var11
					var12 = out2 or var12
					var13 = out3 or var13
				end
				do
					local out1, out2, out3 = event.CopyVector(var23, var24, var25)
					var8 = out1 or var8
					var9 = out2 or var9
					var10 = out3 or var10
				end
				do
					local out1, out2, out3 = event.ScaleVector(var8, var9, var10, var18)
					var8 = out1 or var8
					var9 = out2 or var9
					var10 = out3 or var10
				end
				do
					local out1, out2, out3 = event.CopyVector(var14, var15, var16)
					var5 = out1 or var5
					var6 = out2 or var6
					var7 = out3 or var7
				end
				if vm.imod(language_code, 5) == 0 then
					break
				end
			else
				while language_code < 31 do
					do
						local out1, out2, out3 = event.AddVector(var14, var15, var16, var11, var12, var13)
						var14 = out1 or var14
						var15 = out2 or var15
						var16 = out3 or var16
					end
					event.SpriteSetPos(language_code, var14, var15, var16)
					event.SpriteSetDraw(language_code, 1)
					language_code = language_code + 1
					if vm.imod(language_code, 6) == 0 then
						event.SphidaSetMmLinePos(mini_level, var14, var15, var16)
						mini_level = vm.i32(mini_level + 1)
					end
					if vm.imod(language_code, 5) == 0 then
						break
					end
				end
				do
					local out1, out2, out3 = event.CopyVector(var14, var15, var16)
					var5 = out1 or var5
					var6 = out2 or var6
					var7 = out3 or var7
				end
				break
			end
		end
		var19 = var19 + 1
	end
end

--- Helper function.
local function helper_2b7a0()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		var0 = 0
		var0 = var0 + 1
	end
	if vm.skipping() then
		return skip(1)
	end
	var0 = 0
	while var0 < 48 do
		event.SpriteSetDraw(var0, 0)
		var0 = var0 + 1
	end
end

--- Helper function.
local function helper_2c4f4(arg0: f32, arg1: f32, arg2: s32, sp: number)
	local junk = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local var5: s32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local angle: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local var12: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	local var15: f32 = 0
	local var16: f32 = 0
	local var17: f32 = 0
	local var18: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var4 = 60
			var5 = 76
			local _ = helper_2b8f8(
				var16,
				var17,
				var18,
				vm.f32(var11 + vm.f32(1.5707964)),
				vm.f32(vm.f32(var11 - vm.f32(var14 / 32.0)) + vm.f32(1.5707964))
			) == 1
			var11 = vm.f32(var11 - vm.f32(var14 / 32.0))
			var14 = 0.0
			var5 = 76
			var4 = 400
			var4 = 200
			var5 = 0
			var5 = var5 - 1
			var4 = var4 - 1
			var13 = arg1
			var13 = vm.f32(var13 + var15)
			var13 = 5.0
			var13 = 30.0
			arg0 = var11
			arg1 = var13
			angle = vm.f32(arg0 - vm.f32(3.1415927))
			helper_29ad8(arg0, arg1, arg2, sp + junk + 27)
			local _ = helper_0093af00(0)
			var3 = 0
			local _ = helper_0093af00(1)
			var3 = 1
			junk += 10
		end
		if at <= 2 then
			helper_2b7a0()
		end
		return var3, arg0, arg1
	end
	if vm.skipping() then
		return skip(1)
	end
	var4 = 60
	var5 = 76
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	do
		local out1, out2, out3 = event.GetCharaPos(0)
		var6 = out1 or var6
		var7 = out2 or var7
		var8 = out3 or var8
	end
	event.SetFcameraFollowFlag(1)
	event.SetCameraCtrl(1)
	event.CtrlcSetRotCancel(43)
	event.SetCameraSpeed(6.0)
	event.SetFcameraFollowOfs(0.0, 0.0, 0.0)
	event.SetFcameraFollow(var6, var7 + 20.0, var8)
	event.SetFcameraHeight(0.0)
	event.SetFcameraDist(100.0)
	event.CtrlcMoveRange(10.0, 30.0, 80.0, 120.0)
	while true do
		do
			local out1, out2 = event.GetApad_2()
			var14 = out1 or var14
			var15 = out2 or var15
		end
		do
			local out1, out2, out3 = event.GetCharaPos(0)
			var16 = out1 or var16
			var17 = out2 or var17
			var18 = out3 or var18
		end
		do
			local out1, out2, out3 = event.GetCharaRot(0)
			var10 = out1 or var10
			var11 = out2 or var11
			var12 = out3 or var12
		end
		if var14 ~= 0.0 then
			if
				helper_2b8f8(
					var16,
					var17,
					var18,
					vm.f32(var11 + vm.f32(1.5707964)),
					vm.f32(vm.f32(var11 - vm.f32(var14 / 32.0)) + vm.f32(1.5707964))
				) == 1
			then
				var11 = vm.f32(var11 - vm.f32(var14 / 32.0))
			else
				var14 = 0.0
			end
		end
		event.SetCharaRot(0, var10, var11, var12)
		if var4 <= 0 then
			event.SetMotion(0, "待機")
			var5 = 76
			var4 = 400
		else
			if var14 ~= 0.0 then
				event.SetMotion(0, "かまえバタバタ")
				var4 = 200
				var5 = 0
			elseif var5 <= 0 then
				event.SetMotion(0, "かまえ")
			else
				var5 = var5 - 1
			end
			var4 = var4 - 1
		end
		var13 = arg1
		var13 = vm.f32(var13 + var15)
		if var13 <= 5.0 then
			var13 = 5.0
		end
		if var13 >= 30.0 then
			var13 = 30.0
		end
		arg0 = var11
		arg1 = var13
		event.SphidaCalcCarry(vm.f32(arg1 * vm.f32(3.1415927)) / 180.0)
		angle = vm.f32(arg0 - vm.f32(3.1415927))
		angle = event.AngleLimit(angle) or angle
		event.CtrlcSetRotate(angle)
		event.CtrlcMoveCamera(0)
		event.CtrlcStep()
		helper_29ad8(arg0, arg1, arg2, sp + junk + 19)
		if helper_0093af00(0) ~= 0 then
			event.SetMotion(0, "かまえ")
			var3 = 0
			break
		elseif helper_0093af00(1) ~= 0 then
			var3 = 1
			break
		else
			if vm.wait() then
				return skip(2)
			end
		end
	end
	helper_2b7a0()
	if vm.wait() then
		return skip(3)
	end
	return var3, arg0, arg1
end

--- Helper function.
local function helper_30610(arg0: s32)
	local stage_id: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local count: s32 = 0
	local position_x_2: f32 = 0
	local position_y_2: f32 = 0
	local position_z_2: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_7ec0dfb1(0, 2010, 8, 0, 0)
		end
		if at <= 2 then
			helper_7ec0dfb1(0, 2003, 8, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SphidaSetStatusFlag(0)
	event.DeleteChara(12)
	event.EsmClear()
	event.DelExtMotion(0)
	event.SetMotion(0, "立ち", 4)
	event.CharaNormalDrive(0)
	event.CharaResetDa(0)
	event.EohSyncChara(0, 2)
	event.EohSetShow(0, 1)
	event.SetCameraCtrl(1)
	event.DeleteSwordEffect()
	event.SetStatusbarShow(1, 0.1)
	event.SetCrossfade(15)
	if arg0 == 1 then
		stage_id = event.DngGetStageId() or stage_id
		var2 = event.DngGetFloorId() or var2
		var3 = event.GetFloorInfo(stage_id, var2, 4) or var3
		if var3 == 1 then
			var3 = event.GetSysSndId() or var3
			event.SndSePlay(var3, 18)
			event.SetFloorInfo(stage_id, var2, 5, 128)
			event.AddYarikomiMedal(1)
			do
				local out1, out2, out3 = event.GetBeforeCameraNextPos()
				position_x = out1 or position_x
				position_y = out2 or position_y
				position_z = out3 or position_z
			end
			event.SetCameraPos(position_x, position_y, position_z)
			do
				local out1, out2, out3 = event.GetBeforeCameraNextRef()
				position_x = out1 or position_x
				position_y = out2 or position_y
				position_z = out3 or position_z
			end
			event.SetCameraRef(position_x, position_y, position_z)
			event.SetMesWindowMode(0, 4)
			helper_7ec0dfb1(0, 2010, 8, 0, 0)
			if vm.skipping() then
				return skip(2)
			end
			event.SetActiveCmrid(1)
			event.SetBeforeCmrid(0)
			event.SetFcameraFollowOfs(0.0, 30.0, 0.0)
			event.SetFcameraHeight(5.0)
			event.SetFcameraDist(160.0)
			event.SetCameraSpeed(6.0)
			event.CtrlcSetRotCancel(1)
			event.CtrlcMoveRange(18.0, 10.0, 100.0, 160.0)
			event.ResetCamera(0)
		end
	end
	count = event.SphidaGetParCount() or count
	if arg0 == 0 and count <= 0 then
		do
			local out1, out2, out3 = event.GetBeforeCameraNextPos()
			position_x_2 = out1 or position_x_2
			position_y_2 = out2 or position_y_2
			position_z_2 = out3 or position_z_2
		end
		event.SetCameraPos(position_x_2, position_y_2, position_z_2)
		do
			local out1, out2, out3 = event.GetBeforeCameraNextRef()
			position_x_2 = out1 or position_x_2
			position_y_2 = out2 or position_y_2
			position_z_2 = out3 or position_z_2
		end
		event.SetCameraRef(position_x_2, position_y_2, position_z_2)
		event.SetMesWindowMode(0, 4)
		helper_7ec0dfb1(0, 2003, 8, 0, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.ResetCamera(0)
	end
	event.Finish()
end

--- Helper function.
local function helper_2d348(arg0: f32, arg1: any, arg2: f32, arg3: f32, arg4: f32, arg5: s32, arg6: s32)
	local angle: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local code: s32 = 0
	local var12: s32 = 0
	local x: f32 = 0
	local y: f32 = 0
	local var15: s32 = 0
	local value: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				var12 = 1
			end
			return 1, arg0, arg2, arg3, arg4, arg6
		end
		return 0, arg0, arg2, arg3, arg4, arg6
	end
	angle = vm.f32(arg2 - vm.f32(3.1415927))
	angle = event.AngleLimit(angle) or angle
	var12 = 0
	code = -10
	event.SphidaResetPowgage()
	event.SphidaStartPowgage()
	while code == -10 do
		event.CtrlcSetRotate(angle)
		event.CtrlcMoveCamera(0)
		event.CtrlcStep()
		do
			local out1, out2 = event.GetApad_2()
			var8 = out1 or var8
			var9 = out2 or var9
		end
		event.SphidaSetSpinMarkPos(var8, var9)
		if (if var12 == 0 then helper_0093af00(1) else 0) ~= 0 then
			event.SphidaSetSpinMarkPos(0.0, 0.0)
			event.SphidaResetPowgage()
			return 1, arg0, arg2, arg3, arg4, arg6
		end
		if helper_0093af00(0) ~= 0 then
			event.SphidaTriggerPowgage()
			if vm.wait() then
				return skip(1)
			end
			code = event.SphidaGetPowgageCode() or code
			if var12 == 0 or code ~= -10 then
				event.SndSePlay(arg5, 0)
				do
					local out1, out2 = event.SphidaGetPgCursorPos()
					x = out1 or x
					y = out2 or y
				end
				event.SpriteSetType(10 + var12, 0)
				event.SpriteSetAlphab(10 + var12, 2)
				event.SpriteSetUvsize(10 + var12, 0, 224, 32, 32)
				event.SpriteSetDraw(10 + var12, 1)
				event.SpriteSetPutsize(10 + var12, 32, 32)
				event.SpriteSetPos(10 + var12, x, y)
				event.SpriteSetScale(10 + var12, 0.2, 0.2, 0.2)
				event.EohSyncSprite(20 + var12, 10 + var12)
				event.ObjsInit(20 + var12)
				event.ObjsSyncObj(20 + var12, 20 + var12)
				event.ObjsSetScale(20 + var12, 2, 2, 2, 10)
				event.ObjsSetColor(20 + var12, 128, 128, 128, 128, 2)
				event.ObjsSetColor(20 + var12, 128, 128, 128, 0, 8)
				var12 = 1
			end
		else
			if vm.wait() then
				return skip(2)
			end
		end
		code = event.SphidaGetPowgageCode() or code
	end
	if code == 5 then
		event.SphidaSetSpinMarkPos(0.0, 0.0)
		event.SphidaResetPowgage()
		return 1, arg0, arg2, arg3, arg4, arg6
	end
	arg0 = event.SphidaGetShotPow() or arg0
	var15 = event.GetDebugFlag() or var15
	if var15 == 1 then
		var15 = event.GetPadon() or var15
		if bit32.band(var15, 16) ~= 0 then
			arg0 = 1.0
			code = 0
		end
	end
	if code == 4 then
		arg0 = vm.f32(arg0 * 0.0)
	end
	if code == -3 then
		arg0 = vm.f32(arg0 * vm.f32(0.4))
		value = event.GetRand(0.2) or value
		value = vm.f32(value - vm.f32(0.1))
		arg2 = vm.f32(vm.f32(arg2 - vm.f32(0.4)) + value)
		var8 = vm.f32(vm.f32(var8 * vm.f32(0.2)) * arg0)
		var9 = vm.f32(vm.f32(var9 * vm.f32(0.2)) * arg0)
	end
	if code == 3 then
		arg0 = vm.f32(arg0 * vm.f32(0.4))
		value = event.GetRand(0.2) or value
		value = vm.f32(value - vm.f32(0.1))
		arg2 = vm.f32(vm.f32(arg2 + vm.f32(0.4)) + value)
		var8 = vm.f32(vm.f32(var8 * vm.f32(0.2)) * arg0)
		var9 = vm.f32(vm.f32(var9 * vm.f32(0.2)) * arg0)
	end
	if code == -2 then
		arg0 = vm.f32(arg0 * vm.f32(0.8))
		value = event.GetRand(0.05) or value
		value = vm.f32(value - vm.f32(0.025))
		arg2 = vm.f32(vm.f32(arg2 - vm.f32(0.1)) + value)
		var8 = vm.f32(vm.f32(var8 * vm.f32(0.4)) * arg0)
		var9 = vm.f32(vm.f32(var9 * vm.f32(0.4)) * arg0)
	end
	if code == 2 then
		arg0 = vm.f32(arg0 * vm.f32(0.8))
		value = event.GetRand(0.05) or value
		value = vm.f32(value - vm.f32(0.025))
		arg2 = vm.f32(vm.f32(arg2 + vm.f32(0.1)) + value)
		var8 = vm.f32(vm.f32(var8 * vm.f32(0.4)) * arg0)
		var9 = vm.f32(vm.f32(var9 * vm.f32(0.4)) * arg0)
	end
	if code == -1 then
		arg0 = vm.f32(arg0 * 1.0)
		value = event.GetRand(0.01) or value
		arg2 = vm.f32(arg2 - value)
		var8 = vm.f32(vm.f32(var8 * vm.f32(0.6)) * arg0)
		var9 = vm.f32(vm.f32(var9 * vm.f32(0.6)) * arg0)
	end
	if code == 1 then
		arg0 = vm.f32(arg0 * 1.0)
		value = event.GetRand(0.01) or value
		arg2 = vm.f32(arg2 + value)
		var8 = vm.f32(vm.f32(var8 * vm.f32(0.6)) * arg0)
		var9 = vm.f32(vm.f32(var9 * vm.f32(0.6)) * arg0)
	end
	if code == 0 then
		arg0 = vm.f32(arg0 * vm.f32(1.1))
		var8 = vm.f32(var8 * arg0)
		var9 = vm.f32(var9 * arg0)
	end
	arg6 = code
	arg2 = event.AngleLimit(arg2) or arg2
	arg3 = var8
	arg4 = var9
	helper_1c8c39a1(10)
	if vm.skipping() then
		return skip(3)
	end
	return 0, arg0, arg2, arg3, arg4, arg6
end

--- Helper function.
local function helper_301a4(arg0: s32)
	local count: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		count = count - 1
	end
	if vm.skipping() then
		return skip(1)
	end
	count = event.SphidaGetParCount() or count
	count = vm.i32(count - 1)
	event.SphidaSetParCount(count)
	if count <= 0 then
		event.DeleteChara(8)
		event.DeleteChara(9)
		event.DeleteChara(10)
		event.DeleteChara(11)
		event.SphidaSetPlayFlag(0)
		if arg0 ~= -1 then
			event.SndSePlay(arg0, 19)
		end
	end
end

--- Helper function.
local function helper_48790()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	helper_66b705b3()
	event.SetFadeOut(0)
	if vm.wait() then
		return skip(1)
	end
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 100.
-- Defined empty, so the engine runs this instead of its default.
script[100] = function() end

--- Program 200.
script[200] = function()
	local argc: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	if vm.wait() then
		return skip(1)
	end
	event.AddItem(305, 1)
	event.AddItem(306, 1)
	argc = event.GetItemHaveNum(10) or argc
	if argc <= 0 then
		event.AddItem(10, 1)
	end
	argc = event.GetItemHaveNum(302) or argc
	if argc <= 0 then
		event.AddItem(302, 1)
	end
	event.SetFlag(220, 1)
	event.SetFlag(317, 1)
	event.DelMonster(-1)
	event.Finish()
end

--- Program 300.
script[300] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_42d30(0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 310.
script[310] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_42d30(1)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 320.
script[320] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_42d30(2)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 330.
script[330] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_42d30(3)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 340.
script[340] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_43efc()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 345.
script[345] = function()
	local argc: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	argc = event.GetLocalFlag(5) or argc
	if argc == 0 then
		event.SetLocalFlag(5, 1)
		event.DngPause(32, 0)
	else
		event.SetLocalFlag(5, 0)
		event.DngPause(32, 1)
	end
	helper_46d80(argc)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 348.
script[348] = function()
	local now_party_chara_id: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_44fc0()
			end
			if at <= 2 then
				helper_1c8c39a1(6)
			end
			return
		end
		if at <= 4 then
			var1 = 2
			helper_1c8c39a1(6)
		end
		if at <= 6 then
			helper_44fc0()
		end
		if at <= 7 then
			helper_db44a722()
		end
		if at <= 8 then
			helper_1c8c39a1(6)
		end
	end
	event.Initialize()
	event.DngPause(1, 1)
	helper_1c1f308e()
	now_party_chara_id = event.GetNowPartyChara() or now_party_chara_id
	if now_party_chara_id == 4 then
		event.SetMesWindowMode(0, 1)
		event.SetMesShippo(0, 0)
		event.MesMake_2(0, "Dovete passare da qui, giusto?")
		helper_7ec0dfb1(0, -1, 5, 0, 0)
		if vm.skipping() then
			return skip(1)
		end
		event.SetStatusbarShow(0, 0.16666667)
		helper_44fc0()
		if vm.skipping() then
			return skip(2)
		end
		event.SetStatusbarShow(1, 0.16666667)
		helper_1c8c39a1(6)
		if vm.skipping() then
			return skip(3)
		end
		event.DngPause(1, 0)
		event.Finish()
		return
	end
	var1 = event.GetEventData_2(6) or var1
	if var1 == 1 then
		event.SetMesWindowMode(0, 1)
		event.SetMesShippo(0, 0)
		event.SetMesDrawspeed(0, 1)
		var2 = helper_51999b4f(0, 2503, 5, 256, 208, var2)
		if vm.skipping() then
			return skip(4)
		end
		event.SetMesShippo(0, 1)
		event.SetMesDrawspeed(0, 0)
		if var2 == 1 then
			var1 = 2
		end
	end
	if var1 == 2 then
		event.SetStatusbarShow(0, 0.16666667)
		helper_1c8c39a1(6)
		if vm.skipping() then
			return skip(5)
		end
		event.GotoUseItem(343)
		do
			local skipped = vm.wait()
			var3 = event.DeferredOutput() or var3
			if skipped then
				return skip(6)
			end
		end
		if var3 == 343 then
			helper_44fc0()
			if vm.skipping() then
				return skip(7)
			end
		elseif var3 <= 0 then
		else
			helper_db44a722()
			if vm.skipping() then
				return skip(8)
			end
		end
		event.SetStatusbarShow(1, 0.16666667)
		helper_1c8c39a1(6)
		if vm.skipping() then
			return skip(9)
		end
	end
	event.DngPause(1, 0)
	event.Finish()
end

--- Program 500.
script[500] = function()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		helper_7f54aec4()
	end
	event.Initialize()
	do
		local out1, out2, out3, out4 = event.GetDunWorldCoord(2)
		var0 = out1 or var0
		var1 = out2 or var1
		var2 = out3 or var2
		var3 = out4 or var3
	end
	event.SetWorldCoord(var0, var1, var2, var3)
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.EohSetPos(0, 0.0, -1.0, 100.0)
	event.EohSetRot(0, 0.0, 0.0, 0.0)
	event.EohSetMotion(0, "立ち", 4)
	event.EohNormalDrive(0)
	event.EohResetDaPosition(0)
	event.SetCameraRef(0.0, 29.0, 100.0)
	event.SetCameraPos(0.0, 41.0, -20.0)
	event.ResetCamera(0)
	event.DngPause(1, 0)
	event.LoadMonsterFile(0)
	event.AutoSetTreasureBox(-1)
	event.AutoSetMonster(-1)
	event.SetStatusbarShow(1, 1.0)
	event.SetLocalFlag(5, 0)
	event.DngPause(32, 1)
	helper_a52ca524()
	event.SetFadeIn(30)
	if vm.wait() then
		return skip(1)
	end
	helper_7f54aec4()
	event.Finish()
end

script[1000] = program_1000

script[1010] = program_1010

--- Program 1100.
script[1100] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_1c780()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 1120.
script[1120] = function()
	local active_chr_no: s32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local yaw: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	local var11: s32 = 0
	local weight: f32 = 0
	local var14: f32 = 0
	local now_party_chara_id: s32 = 0
	local var17: s32 = 0
	local var18: s32 = 0
	local var19: f32 = 0
	local pos_x_3: f32 = 0
	local pos_y_3: f32 = 0
	local pos_z_3: f32 = 0
	local pos_x_4: f32 = 0
	local pos_y_4: f32 = 0
	local pos_z_4: f32 = 0
	local var26: f32 = 0
	local value: s32 = 0
	local angle: f32 = 0
	local value_2: s32 = 0
	local var30: s32 = 0
	local var31: f32 = 0
	local var32: s32 = 0
	local result: f32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_7ec0dfb1(0, 23, 8, 0, 0)
			end
			var1 = vm.f32(vm.f32(vm.sin(yaw) * 25.0) + pos_x)
			var2 = pos_y
			var3 = vm.f32(vm.f32(vm.cos(yaw) * 25.0) + pos_z)
			return
		end
		if at <= 3 then
			helper_1c1f308e()
			helper_d0ba87d6()
		end
		if at <= 5 then
			helper_d0ba87d6()
		end
		if at <= 6 then
			var14 = vm.f32(var14 - vm.f32(3.1415927))
			var18 = 0
			var19 = vm.f32(0.6)
			var14 = vm.f32(var14 + var19)
			helper_cde4()
			local _ = helper_0093af00(0)
		end
		if at <= 7 then
			var18 = var18 + 1
		end
		if at <= 8 then
			helper_262fced1()
			value = 0
			value = value + 4
			var18 = 0
			var14 = vm.f32(var14 + var19)
		end
		if at <= 9 then
			var19 = vm.f32(var19 * vm.f32(0.9))
			angle = var26
			local _ = helper_55bc1429(var14, angle, vm.f32(0.08)) == 0
			var17 = 0
			angle = vm.f32(var26 - vm.f32(3.1415927))
			local _ = helper_55bc1429(var14, angle, vm.f32(0.08)) == 0
			var17 = 1
			var18 = vm.i32(var18 + 1)
			local _ = helper_55bc1429(var14, var26, 1.0) == 0
			var17 = 0
			var17 = 1
			var26 = var14
			helper_1c8c39a1(20)
		end
		if at <= 10 then
			var30 = 100
			var30 = 6
			var30 = 0
			var30 = 2
			var30 = 100
			var30 = 4
			var26 = vm.f32(var26 + vm.f32(3.14))
			var17 = 1
			var17 = 0
			helper_1c8c39a1(10)
		end
		if at <= 11 then
			var26 = vm.f32(var26 + vm.f32(3.14))
			var26 = vm.f32(var26 + vm.f32(1.57))
			var26 = vm.f32(var26 + vm.f32(1.57))
			helper_1c8c39a1(20)
		end
		if at <= 12 then
			local _ = helper_55bc1429(var14, var26, 1.0) == 0
			var17 = 0
			var17 = 1
			var31 = 1.0
			var18 = 0
			var31 = vm.f32(var31 + vm.f32(0.03))
			var18 = var18 + 1
		end
		if at <= 13 then
			helper_7ec0dfb1(0, 2310, 8, 0, 0)
		end
		if at <= 14 then
			helper_7ec0dfb1(0, 2311, 8, 0, 0)
		end
		if at <= 15 then
			helper_7ec0dfb1(0, 2312, 8, 0, 0)
		end
		if at <= 16 then
			helper_7ec0dfb1(0, 2313, 8, 0, 0)
		end
		if at <= 17 then
			helper_7ec0dfb1(0, 2314, 8, 0, 0)
		end
		if at <= 18 then
			var31 = vm.f32(var31 - vm.f32(0.03))
			var18 = var18 + 1
		end
		if at <= 19 then
			helper_7ec0dfb1(0, 2320, 8, 0, 0)
		end
		if at <= 20 then
			helper_7ec0dfb1(0, 2321, 8, 0, 0)
		end
		if at <= 21 then
			helper_7ec0dfb1(0, 2322, 8, 0, 0)
		end
		if at <= 22 then
			helper_7ec0dfb1(0, 2323, 8, 0, 0)
		end
		if at <= 23 then
			helper_7ec0dfb1(0, 2324, 8, 0, 0)
		end
		if at <= 24 then
			helper_7ec0dfb1(0, 2325, 8, 0, 0)
		end
		if at <= 25 then
			helper_7ec0dfb1(0, 2328, 8, 0, 0)
		end
		if at <= 26 then
			helper_7ec0dfb1(0, 2326, 8, 0, 0)
		end
		if at <= 27 then
			helper_7ec0dfb1(0, 2329, 8, 0, 0)
		end
		if at <= 28 then
			helper_7ec0dfb1(0, 2327, 8, 0, 0)
		end
		if at <= 29 then
			helper_7ec0dfb1(0, 2330, 8, 0, 0)
		end
	end
	event.Initialize()
	event.DngPause(513, 1)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 2 or active_chr_no == 3 then
		event.SetMesPreset(0, 4)
		event.SetMesWindowMode(0, 4)
		event.SetMesDrawspeed(0, 1)
		helper_1c1f308e()
		if active_chr_no == 2 then
			helper_7ec0dfb1(0, 22, 8, 0, 0)
			if vm.skipping() then
				return skip(1)
			end
		else
			helper_7ec0dfb1(0, 23, 8, 0, 0)
			if vm.skipping() then
				return skip(2)
			end
		end
		event.SetMesWindowMode(0, 1)
		event.SetMesDrawspeed(0, 0)
		do
			local out1, out2, out3 = event.GetCharaPos(0)
			var1 = out1 or var1
			var2 = out2 or var2
			var3 = out3 or var3
		end
		do
			local out1, out2, out3 = event.RandomCircleGetPos(-1)
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		yaw = event.GetRefAngle(pos_x, pos_y, pos_z, var1, var2, var3) or yaw
		var1 = vm.f32(vm.f32(vm.sin(yaw) * 25.0) + pos_x)
		var2 = pos_y
		var3 = vm.f32(vm.f32(vm.cos(yaw) * 25.0) + pos_z)
		event.SetCharaPos(0, var1, var2, var3)
		event.DngPause(513, 0)
		event.Finish()
		return
	end
	event.SetLoadbgFile("snd2/sp/sp_011.sound.json")
	if vm.wait() then
		return skip(3)
	end
	helper_1c1f308e()
	do
		local out1, out2, out3 = event.RandomCircleGetPos(-1)
		pos_x_2 = out1 or pos_x_2
		pos_y_2 = out2 or pos_y_2
		pos_z_2 = out3 or pos_z_2
	end
	event.SetCameraCtrl(0)
	event.SetFcameraFollowFlag(1)
	event.SetFcameraFollowA(pos_x_2, pos_y_2 + 30.0, pos_z_2)
	event.SetCameraSpeed(8.0)
	event.SetFcameraFollowOfs(0.0, 0.0, 0.0)
	event.SetFcameraHeight(0.0)
	event.SetFcameraDist(80.0)
	event.AssignStack(5)
	event.ClearStack(5)
	helper_d0ba87d6()
	if vm.skipping() then
		return skip(4)
	end
	var11 = event.SndLoadSound(8, "snd2/sp/sp_011.sound.json") or var11
	event.ChangeDir("event/dng/")
	event.SetLoadbgFile("ring.gltf", "randomcoin.gltf")
	if vm.wait() then
		return skip(5)
	end
	helper_d0ba87d6()
	if vm.skipping() then
		return skip(6)
	end
	weight = event.GetRndcMotNowt() or weight
	event.RandomCircleOff(-1)
	event.LoadChara(5, "ring.gltf", "info", 12)
	event.CharaActive(1, 12)
	event.SetCharaPos(12, pos_x_2, pos_y_2, pos_z_2)
	event.SetMotion(12, "ループ", 6)
	event.CharaNormalDrive(12)
	event.SetCharaMotNowt(12, weight)
	event.EohSyncChara(4, 12)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.ObjsNextMotion(4, "消滅", 6)
	event.LoadChara(5, "randomcoin.gltf", "info", 13)
	event.CharaActive(1, 13)
	event.SetCharaPos(13, pos_x_2, pos_y_2 - 30.0, pos_z_2)
	var14 = event.GetRand(6.2831855) or var14
	var14 = vm.f32(var14 - vm.f32(3.1415927))
	var14 = event.AngleLimit(var14) or var14
	event.SetCharaRot(13, 0.0, var14, 0.0)
	event.ChangeDir("")
	now_party_chara_id = event.GetNowPartyChara() or now_party_chara_id
	event.EohSyncChara(5, 13)
	event.ObjsInit(5)
	event.ObjsSyncObj(5, 5)
	event.ObjsSetScale(5, 0.0, 0.0, 0.0)
	event.ObjsSetScale(5, 1.0, 1.0, 1.0, 40)
	event.ObjsMove2(5, pos_x_2, pos_y_2 + 40.0, pos_z_2, 30, 2, 0.5)
	var18 = 0
	var19 = vm.f32(0.6)
	while true do
		do
			local _, out2, _ = event.GetCharaRot(13)
			var14 = out2 or var14
		end
		var14 = vm.f32(var14 + var19)
		var14 = event.AngleLimit(var14) or var14
		event.SetCharaRot(13, 0.0, var14, 0.0)
		if var18 == 10 then
			event.SndSePlay(var11, 0)
		end
		if var18 == 30 then
			helper_cde4()
		end
		if (if var18 >= 30 then helper_0093af00(0) else 0) ~= 0 or var18 > 300 then
			event.SndSeStop(var11, 0)
			event.SndSePlay(var11, 3)
			if vm.wait() then
				return skip(7)
			end
			break
		else
			var18 = var18 + 1
			if vm.wait() then
				return skip(8)
			end
		end
	end
	helper_262fced1()
	event.EohSyncChara(5, 13)
	event.ObjsInit(5)
	event.ObjsSyncObj(5, 5)
	do
		local out1, out2, out3 = event.GetCameraPos()
		pos_x_3 = out1 or pos_x_3
		pos_y_3 = out2 or pos_y_3
		pos_z_3 = out3 or pos_z_3
	end
	do
		local out1, out2, out3 = event.GetCameraRef()
		pos_x_4 = out1 or pos_x_4
		pos_y_4 = out2 or pos_y_4
		pos_z_4 = out3 or pos_z_4
	end
	var26 = event.GetRefAngle(pos_x_4, pos_y_4, pos_z_4, pos_x_3, pos_y_3, pos_z_3) or var26
	value = 0
	value = event.GetRandInt(10) or value
	value = vm.i32(value + 4)
	var18 = 0
	while true do
		do
			local _, out2, _ = event.GetCharaRot(13)
			var14 = out2 or var14
		end
		var14 = vm.f32(var14 + var19)
		var14 = event.AngleLimit(var14) or var14
		event.SetCharaRot(13, 0.0, var14, 0.0)
		if vm.wait() then
			return skip(9)
		end
		if var18 >= value then
			if var19 > vm.f32(0.08) then
				var19 = vm.f32(var19 * vm.f32(0.9))
			end
			angle = var26
			angle = event.AngleLimit(angle) or angle
			if var14 < angle and helper_55bc1429(var14, angle, vm.f32(0.08)) == 0 then
				event.SetCharaRot(13, 0.0, angle, 0.0)
				var17 = 0
				break
			end
			angle = vm.f32(var26 - vm.f32(3.1415927))
			angle = event.AngleLimit(angle) or angle
			if var14 < angle and helper_55bc1429(var14, angle, vm.f32(0.08)) == 0 then
				event.SetCharaRot(13, 0.0, angle, 0.0)
				var17 = 1
				break
			end
		end
		var18 = vm.i32(var18 + 1)
	end
	var26 = event.GetRefAngle(pos_x_4, pos_y_4, pos_z_4, pos_x_3, pos_y_3, pos_z_3) or var26
	do
		local _, out2, _ = event.GetCharaRot(13)
		var14 = out2 or var14
	end
	if helper_55bc1429(var14, var26, 1.0) == 0 then
		var17 = 0
	else
		var17 = 1
	end
	var26 = var14
	helper_1c8c39a1(20)
	if vm.skipping() then
		return skip(10)
	end
	value_2 = event.GetRandInt(10) or value_2
	if now_party_chara_id == 24 then
		var30 = 100
	else
		var30 = 6
	end
	if value_2 < var30 then
		value_2 = event.GetRandInt(10) or value_2
		if var17 == 0 then
			if now_party_chara_id == 24 then
				var30 = 0
			else
				var30 = 2
			end
		elseif now_party_chara_id == 24 then
			var30 = 100
		else
			var30 = 4
		end
		if value_2 < var30 then
			var26 = vm.f32(var26 + vm.f32(3.14))
			var26 = event.AngleLimit(var26) or var26
			event.ObjsRotation(5, 0.0, var26, 0.0, 8)
			if var17 == 0 then
				var17 = 1
			else
				var17 = 0
			end
			helper_1c8c39a1(10)
			if vm.skipping() then
				return skip(11)
			end
		else
			value_2 = event.GetRandInt(10) or value_2
			if value_2 < 1 then
				var26 = vm.f32(var26 + vm.f32(3.14))
				var26 = event.AngleLimit(var26) or var26
				event.ObjsRotation(5, 0.0, var26, 0.0, 6)
				var26 = vm.f32(var26 + vm.f32(1.57))
				var26 = event.AngleLimit(var26) or var26
				event.ObjsRotation(5, 0.0, var26, 0.0, 3)
				var26 = vm.f32(var26 + vm.f32(1.57))
				var26 = event.AngleLimit(var26) or var26
				event.ObjsRotation(5, 0.0, var26, 0.0, 3)
				helper_1c8c39a1(20)
				if vm.skipping() then
					return skip(12)
				end
			end
		end
	end
	var26 = event.GetRefAngle(pos_x_4, pos_y_4, pos_z_4, pos_x_3, pos_y_3, pos_z_3) or var26
	do
		local _, out2, _ = event.GetCharaRot(13)
		var14 = out2 or var14
	end
	if helper_55bc1429(var14, var26, 1.0) == 0 then
		var17 = 0
	else
		var17 = 1
	end
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.SetMesDrawspeed(0, 1)
	var31 = 1.0
	var18 = 0
	var32 = event.GetRndCircleTrapid(var17) or var32
	if var17 == 0 then
		event.SndSePlay(var11, 1)
		while var18 < 30 do
			event.BscnSetBlightRate(var31)
			var31 = vm.f32(var31 + vm.f32(0.03))
			var18 = var18 + 1
			if vm.wait() then
				return skip(13)
			end
		end
		helper_7ec0dfb1(0, 2310, 8, 0, 0)
		if vm.skipping() then
			return skip(14)
		end
		result = event.SetRndCircleStatus(var32) or result
		if var32 == 1 then
			helper_7ec0dfb1(0, 2311, 8, 0, 0)
			if vm.skipping() then
				return skip(15)
			end
		end
		if var32 == 2 then
			helper_7ec0dfb1(0, 2312, 8, 0, 0)
			if vm.skipping() then
				return skip(16)
			end
		end
		if var32 == 3 then
			helper_7ec0dfb1(0, 2313, 8, 0, 0)
			if vm.skipping() then
				return skip(17)
			end
		end
		if var32 == 4 then
			event.PostTreasureBox(pos_x_2, pos_y_2, pos_z_2, var26, 294)
			helper_7ec0dfb1(0, 2314, 8, 0, 0)
			if vm.skipping() then
				return skip(18)
			end
		end
	else
		event.SndSePlay(var11, 2)
		while var18 < 30 do
			event.BscnSetBlightRate(var31)
			var31 = vm.f32(var31 - vm.f32(0.03))
			var18 = var18 + 1
			if vm.wait() then
				return skip(19)
			end
		end
		helper_7ec0dfb1(0, 2320, 8, 0, 0)
		if vm.skipping() then
			return skip(20)
		end
		result = event.SetRndCircleStatus(var32) or result
		if var32 == 5 then
			if active_chr_no == 0 or active_chr_no == 2 then
				helper_7ec0dfb1(0, 2321, 8, 0, 0)
				if vm.skipping() then
					return skip(21)
				end
			end
			if active_chr_no == 1 or active_chr_no == 3 then
				helper_7ec0dfb1(0, 2322, 8, 0, 0)
				if vm.skipping() then
					return skip(22)
				end
			end
		end
		if var32 == 6 then
			if active_chr_no == 0 then
				helper_7ec0dfb1(0, 2323, 8, 0, 0)
				if vm.skipping() then
					return skip(23)
				end
			end
			if active_chr_no == 1 or active_chr_no == 3 then
				helper_7ec0dfb1(0, 2324, 8, 0, 0)
				if vm.skipping() then
					return skip(24)
				end
			end
			if active_chr_no == 2 then
				helper_7ec0dfb1(0, 2325, 8, 0, 0)
				if vm.skipping() then
					return skip(25)
				end
			end
		end
		if var32 == 8 then
			helper_7ec0dfb1(0, 2328, 8, 0, 0)
			if vm.skipping() then
				return skip(26)
			end
		end
		if var32 == 9 then
			helper_7ec0dfb1(0, 2326, 8, 0, 0)
			if vm.skipping() then
				return skip(27)
			end
		end
		if var32 == 10 then
			helper_7ec0dfb1(0, 2329, 8, 0, 0)
			if vm.skipping() then
				return skip(28)
			end
		end
		if var32 == 11 then
			helper_7ec0dfb1(0, 2327, 8, 0, 0)
			if vm.skipping() then
				return skip(29)
			end
		end
		if var32 == 12 then
			helper_7ec0dfb1(0, 2330, 8, 0, 0)
			if vm.skipping() then
				return skip(30)
			end
		end
	end
	event.SetMesWindowMode(0, 1)
	event.SetMesDrawspeed(0, 0)
	event.BscnSetBlightRate(1.0)
	if var32 == 1 then
		event.SetPullItem(pos_x_2, pos_y_2, pos_z_2, 1, 10, result / 10.0)
	end
	event.DngPause(513, 0)
	event.SetCameraCtrl(1)
	do
		local out1, out2, out3 = event.GetBeforeCameraNextPos()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	event.SetCameraPos(position_x, position_y, position_z)
	do
		local out1, out2, out3 = event.GetBeforeCameraNextRef()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	event.SetCameraRef(position_x, position_y, position_z)
	event.DeleteChara(12)
	event.DeleteChara(13)
	event.SetCrossfade(15)
	event.Finish()
end

--- Program 1130.
script[1130] = function()
	local active_chr_no: s32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	local var17: f32 = 0
	local var18: f32 = 0
	local var19: f32 = 0
	local var20: f32 = 0
	local argc: s32 = 0
	local stage_id: s32 = 0
	local var23: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_7ec0dfb1(0, 23, 8, 0, 0)
			end
			return
		end
		if at <= 3 then
			helper_d0ba87d6()
		end
		if at <= 5 then
			helper_d0ba87d6()
		end
		if at <= 6 then
			pos_y_2 = vm.f32(var9 + 18.0)
			var17 = vm.f32(var17 + vm.f32(2.9))
			var17 = vm.f32(var17 + vm.f32(2.4))
			var8 = vm.f32(vm.f32(vm.sin(var17) * 14.0) + pos_x_2)
			var10 = vm.f32(vm.f32(vm.cos(var17) * 14.0) + pos_z_2)
			var17 = vm.f32(var17 - vm.f32(3.1415927))
			var18 = vm.f32(vm.f32(vm.sin(var17) * 8.0) + var8)
			var19 = vm.f32(var9 + 18.0)
			var20 = vm.f32(vm.f32(vm.cos(var17) * 8.0) + var10)
			helper_1c8c39a1(16)
		end
		if at <= 7 then
			helper_1c8c39a1(2)
		end
		if at <= 8 then
			helper_1c8c39a1(10)
		end
		if at <= 9 then
			helper_1c8c39a1(20)
		end
		if at <= 10 then
			helper_c07d0298(0)
		end
		if at <= 11 then
			helper_7ec0dfb1(0, 2400, 8, 0, 0)
		end
	end
	event.Initialize()
	event.DngPause(513, 1)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 2 or active_chr_no == 3 then
		event.SetMesPreset(0, 4)
		event.SetMesWindowMode(0, 4)
		event.SetMesDrawspeed(0, 1)
		helper_1c1f308e()
		if active_chr_no == 2 then
			helper_7ec0dfb1(0, 22, 8, 0, 0)
			if vm.skipping() then
				return skip(1)
			end
		else
			helper_7ec0dfb1(0, 23, 8, 0, 0)
			if vm.skipping() then
				return skip(2)
			end
		end
		event.SetMesWindowMode(0, 1)
		event.SetMesDrawspeed(0, 0)
		event.DngPause(513, 0)
		event.Finish()
		return
	end
	event.DngPause(16, 1)
	event.AssignStack(5)
	event.ClearStack(5)
	event.SetFlag(31, 1)
	event.SetMotion(0, "立ち")
	do
		local out1, out2, out3 = event.GetCharaPos(0)
		var1 = out1 or var1
		var2 = out2 or var2
		var3 = out3 or var3
	end
	if active_chr_no == 0 then
		event.SetLoadbgFile(
			"dungeon/chara/c01_gio.gltf",
			"event/itemget_ev/itemget_ev.gltf",
			"snd2/sp/sp_012.sound.json"
		)
		if vm.wait() then
			return skip(3)
		end
		helper_d0ba87d6()
		if vm.skipping() then
			return skip(4)
		end
		event.LoadMotion(5, "dungeon/chara/c01_gio.gltf", "info", 0)
	end
	if active_chr_no == 1 then
		event.SetLoadbgFile(
			"dungeon/chara/c02_gio.gltf",
			"event/itemget_ev/itemget_ev.gltf",
			"snd2/sp/sp_012.sound.json"
		)
		if vm.wait() then
			return skip(5)
		end
		helper_d0ba87d6()
		if vm.skipping() then
			return skip(6)
		end
		event.LoadMotion(5, "dungeon/chara/c02_gio.gltf", "info", 0)
	end
	var4 = event.SndLoadSound(8, "snd2/sp/sp_012.sound.json") or var4
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	do
		local out1, out2, out3 = event.GetCameraPos()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local out1, out2, out3 = event.GetCharaPos(0)
		var8 = out1 or var8
		var9 = out2 or var9
		var10 = out3 or var10
	end
	event.CopyVector(var8, var9, var10)
	event.GeostoneAnimeOff()
	event.EohSyncGeostone(1)
	do
		local out1, out2, out3 = event.EohGetPos(1)
		pos_x_2 = out1 or pos_x_2
		pos_y_2 = out2 or pos_y_2
		pos_z_2 = out3 or pos_z_2
	end
	pos_y_2 = vm.f32(var9 + 18.0)
	event.EohSetPos(1, pos_x_2, pos_y_2, pos_z_2)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	var17 = event.GetRefAngle(pos_x_2, pos_y_2, pos_z_2, pos_x, pos_y, pos_z) or var17
	var17 = event.AngleLimit(var17) or var17
	if active_chr_no == 0 then
		var17 = vm.f32(var17 + vm.f32(2.9))
	end
	if active_chr_no == 1 then
		var17 = vm.f32(var17 + vm.f32(2.4))
	end
	var17 = event.AngleLimit(var17) or var17
	var8 = vm.f32(vm.f32(vm.sin(var17) * 14.0) + pos_x_2)
	var10 = vm.f32(vm.f32(vm.cos(var17) * 14.0) + pos_z_2)
	event.SetCharaPos(0, var8, var9, var10)
	var17 = vm.f32(var17 - vm.f32(3.1415927))
	var17 = event.AngleLimit(var17) or var17
	event.SetCharaRot(0, 0.0, var17, 0.0)
	event.EohResetDaPosition(0)
	event.LoadChara(5, "event/itemget_ev/itemget_ev.gltf", "info", 12)
	event.CharaActive(0, 12)
	if active_chr_no == 0 then
		event.SetCameraCtrl(0)
		event.SetFcameraFollowFlag(1)
		event.SetFcameraFollowA(var8, var9 + 18.0, var10)
		event.SetCameraSpeed(16.0)
		event.SetFcameraFollowOfs(0.0, 6.0, 0.0)
		event.SetFcameraHeight(-14.0)
		event.SetFcameraDist(54.0)
		event.SetCharaPos(12, var8, var9 + 36.0, var10)
	end
	if active_chr_no == 1 then
		event.SetCameraCtrl(0)
		event.SetFcameraFollowFlag(1)
		event.SetFcameraFollowA(var8, var9 + 18.0, var10)
		event.SetCameraSpeed(16.0)
		event.SetFcameraFollowOfs(0.0, 0.0, 0.0)
		event.SetFcameraHeight(-5.0)
		event.SetFcameraDist(34.0)
		var18 = vm.f32(vm.f32(vm.sin(var17) * 8.0) + var8)
		var19 = vm.f32(var9 + 18.0)
		var20 = vm.f32(vm.f32(vm.cos(var17) * 8.0) + var10)
		event.SetCharaPos(12, var18, var19, var20)
	end
	event.EohSyncChara(2, 1)
	event.EohSetShow(2, 0)
	event.EohSyncChara(3, 2)
	event.EohSetShow(3, 0)
	event.SetCrossfade(30)
	event.ObjsSetMotion(0, "取る", 6)
	event.ObjsNextMotion(0, "取るL", 4)
	helper_1c8c39a1(16)
	if vm.skipping() then
		return skip(7)
	end
	event.SndSePlay(var4, 0)
	helper_1c8c39a1(2)
	if vm.skipping() then
		return skip(8)
	end
	event.EohSetPos(1, 0.0, 0.0, 0.0)
	event.GeostoneSetReference(0, "item")
	helper_1c8c39a1(10)
	if vm.skipping() then
		return skip(9)
	end
	do
		local out1, out2, out3 = event.GetCameraPos()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	var17 = event.GetRefAngle(var8, var9, var10, pos_x, pos_y, pos_z) or var17
	event.SetCharaRot(12, 0.0, var17, 0.0)
	event.CharaActive(1, 12)
	event.EohSyncChara(4, 12)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.ObjsSetMotion(4, "発動", 6, 1.2)
	event.ObjsMotionWait(4)
	event.ObjsResetMotion(4)
	event.ObjsSetMotion(4, "発動", 5)
	helper_1c8c39a1(20)
	if vm.skipping() then
		return skip(10)
	end
	event.SndSePlay(var4, 1)
	helper_c07d0298(0)
	if vm.skipping() then
		return skip(11)
	end
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.SetMesDrawspeed(0, 1)
	argc = event.GetSysSndId() or argc
	event.SndSePlay(argc, 18)
	helper_7ec0dfb1(0, 2400, 8, 0, 0)
	if vm.skipping() then
		return skip(12)
	end
	event.SetMesWindowMode(0, 1)
	event.SetMesDrawspeed(0, 0)
	stage_id = event.DngGetStageId() or stage_id
	var23 = event.DngGetFloorId() or var23
	event.SetFloorInfo(stage_id, var23, 5, 256)
	event.SetCrossfade(10)
	if active_chr_no == 1 then
		event.SetMotion(0, "取る戻り", 6)
		if vm.wait() then
			return skip(13)
		end
	end
	event.DngPause(529, 0)
	event.SetMotion(0, "立ち", 4)
	event.SetCharaPos(0, var1, var2, var3)
	event.EohResetDaPosition(0)
	event.EohSyncChara(2, 1)
	event.EohSetShow(2, 1)
	event.EohSyncChara(3, 2)
	event.EohSetShow(3, 1)
	event.GeostoneDelReference()
	event.GeostoneSetFlag(0)
	event.EohSetScale(1, 1.0, 1.0, 1.0)
	event.DelExtMotion(0)
	event.DeleteChara(12)
	event.SetCameraCtrl(1)
	event.Finish()
end

--- Program 1150.
script[1150] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_29734()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 1200.
script[1200] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_e4b041e2(0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 1500.
script[1500] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_21530()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 2500.
script[2500] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	event.ActchrSetDefMotion(0)
	event.DngPause(513, 1)
	event.SetFlag(50, 1)
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.SetMesDrawspeed(0, 1)
	helper_7ec0dfb1(0, 2600, 8, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	if vm.wait() then
		return skip(2)
	end
	event.SetMesWindowMode(0, 1)
	event.SetMesDrawspeed(0, 0)
	event.DngPause(513, 0)
	event.Finish()
end

--- Program 2510.
script[2510] = function()
	local var0: s32 = 0
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			_, var0 = helper_47343ad6(0, 0, var0)
		end
		helper_5716569e(0)
	end
	event.Initialize()
	event.DngPause(515, 1)
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.SetMesDrawspeed(0, 1)
	helper_522670ce(0, 2610, 8, 0, 0)
	helper_1c8c39a1(30)
	if vm.skipping() then
		return skip(1)
	end
	_, var0 = helper_47343ad6(0, 0, var0)
	if vm.skipping() then
		return skip(2)
	end
	helper_5716569e(0)
	event.SetMesWindowMode(0, 1)
	event.SetMesDrawspeed(0, 0)
	event.DngPause(515, 0)
	event.Finish()
end

--- Program 2520.
script[2520] = function()
	local var0: s32 = 0
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			_, var0 = helper_47343ad6(0, 0, var0)
		end
		if at <= 2 then
			helper_5716569e(0)
			helper_7ec0dfb1(0, 2621, 8, 0, 0)
		end
		if at <= 3 then
			helper_7ec0dfb1(0, 2622, 8, 0, 0)
		end
		if at <= 4 then
			helper_7ec0dfb1(0, 2623, 8, 0, 0)
		end
		if at <= 5 then
			helper_7ec0dfb1(0, -1, 8, 0, 0)
		end
	end
	event.Initialize()
	event.DngPause(515, 1)
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.SetMesDrawspeed(0, 1)
	helper_522670ce(0, 2620, 8, 0, 0)
	helper_1c8c39a1(30)
	if vm.skipping() then
		return skip(1)
	end
	_, var0 = helper_47343ad6(0, 0, var0)
	if vm.skipping() then
		return skip(2)
	end
	helper_5716569e(0)
	helper_7ec0dfb1(0, 2621, 8, 0, 0)
	if vm.skipping() then
		return skip(3)
	end
	helper_7ec0dfb1(0, 2622, 8, 0, 0)
	if vm.skipping() then
		return skip(4)
	end
	helper_7ec0dfb1(0, 2623, 8, 0, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(0, "Sei hai dubbi, vedi Guida da Menu principale.")
	helper_7ec0dfb1(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(6)
	end
	if vm.wait() then
		return skip(7)
	end
	event.SetMesWindowMode(0, 1)
	event.SetMesDrawspeed(0, 0)
	event.DngPause(515, 0)
	event.Finish()
end

--- Program 2530.
script[2530] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	event.ActchrSetDefMotion(0)
	event.DngPause(513, 1)
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.SetMesDrawspeed(0, 1)
	event.MesMake_2(
		0,
		"[(!)]Guida del Fuoristrada\n   Accelera con (L)↑; Rallenta con (L)↓.\n   Sterza con (L) ← oppure →.\n   Per le curve strette, [l1] + (L) ← o →."
	)
	helper_7ec0dfb1(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	if vm.wait() then
		return skip(2)
	end
	event.SetMesWindowMode(0, 1)
	event.SetMesDrawspeed(0, 0)
	event.DngPause(513, 0)
	event.Finish()
end

--- Program 2540.
script[2540] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_7ec0dfb1(0, -1, 8, 0, 0)
		end
		if at <= 2 then
			helper_7ec0dfb1(0, -1, 8, 0, 0)
		end
		if at <= 3 then
			helper_7ec0dfb1(0, -1, 8, 0, 0)
		end
		if at <= 4 then
			helper_7ec0dfb1(0, -1, 8, 0, 0)
		end
	end
	event.Initialize()
	event.DngPause(515, 1)
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.SetMesDrawspeed(0, 1)
	event.MesMake_2(0, "[(!)]Ora sai usare la Spada Assorbi-magia.")
	helper_7ec0dfb1(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(
		0,
		"In guardia, la Spada Assorbi-magia\nassorbe l'energia degli attacchi\nelementali, come Fuoco. In attacco,\nrilascer[UNI00e0] poi l'energia assorbita."
	)
	helper_7ec0dfb1(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"[UNI00c8] possibile caricare continuamente\nenergia dello stesso elemento.\nPer[UNI00f2], assorbendo un elemento\ndiverso, si perde l'intera carica."
	)
	helper_7ec0dfb1(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "L'energia elementale assorbibile\ndipende dalla robustezza dell'arma.")
	helper_7ec0dfb1(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(
		0,
		"Per usare l'energia elementale\nassorbita come magia, premi\n[l1] mentre sei in guardia con [r1]."
	)
	helper_7ec0dfb1(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(5)
	end
	if vm.wait() then
		return skip(6)
	end
	event.SetMesWindowMode(0, 1)
	event.SetMesDrawspeed(0, 0)
	event.DngPause(515, 0)
	event.Finish()
end

--- Program 3000.
script[3000] = function()
	local sp: number = 0
	local junk = 0
	local tex_bank: s32 = 0
	local var1: s32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local var12: f32 = 0
	local var13: f32 = 0
	local var14: s32 = 0
	local var15: f32 = 0
	local var16: f32 = 0
	local var17: f32 = 0
	local var18: f32 = 0
	local var19: f32 = 0
	local var20: f32 = 0
	local var21: s32 = 0
	local var22: f32 = 0
	local var23: f32 = 0
	local var24: f32 = 0
	local var25: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var29: s32 = 0
	local var30: f32 = 0
	local var31: f32 = 0
	local var32: f32 = 0
	local var33: f32 = 0
	local var34: f32 = 0
	local var35: f32 = 0
	local var36: f32 = 0
	local var37: f32 = 0
	local var38: f32 = 0
	local var39: f32 = 0
	local var40: f32 = 0
	local var41: s32 = 0
	local var42: s32 = 0
	local var43: s32 = 0
	local var44: s32 = 0
	local var45: s32 = 0
	local var46: s32 = 0
	local var47: f32 = 0
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local var51: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	local yaw: f32 = 0
	local count: s32 = 0
	local var57: any = 0
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_1c1f308e()
				local _ = helper_2efd0()
				junk += 1
			end
			return
		end
		if at <= 6 then
			if at <= 3 then
				helper_d0ba87d6()
			end
			if at <= 4 then
				var2, var3, var4, var6 = helper_2f3ec(var2, var3, var4, var6)
				helper_2fd58(var6)
				var11 = 12.5
				var12, var13, var14 = helper_30f94(var12, var13, var14)
				_, var6, var11 = helper_2c4f4(var6, var11, tex_bank, sp + junk + 59)
				junk += 2
			end
			if at <= 5 then
				helper_30610(0)
			end
			return
		end
		if at <= 14 then
			if at <= 8 then
				var21 = 0
				helper_1c8c39a1(10)
				junk += 8
			end
			if at <= 9 then
				helper_1c8c39a1(25)
				junk += 1
			end
			if at <= 10 then
				helper_1c8c39a1(34)
				junk += 2
			end
			if at <= 11 then
				helper_1c8c39a1(39)
			end
			if at <= 12 then
				helper_1c8c39a1(50)
				junk += 2
			end
			if at <= 13 then
				helper_301a4(var1)
				helper_30610(0)
			end
			return
		end
		if at <= 15 then
			var42 = var42 - 1
			var46 = var46 + 1
			var46 = 0
			var46 = var46 + 1
			junk += 4
		end
		if at <= 16 then
			var46 = 0
			var46 = var46 + 1
			junk += 1
		end
		if at <= 17 then
			var41 = vm.i32(var41 + 1)
			helper_1c8c39a1(54)
		end
		if at <= 18 then
			helper_1c8c39a1(30)
		end
		if at <= 19 then
			helper_c07d0298(0)
			junk += 1
		end
		if at <= 20 then
			helper_1c8c39a1(90)
		end
		if at <= 22 then
			var57 = helper_6efad7f4(0, 2002, 8, 256, 208, 2, 0)
			junk += 1
		end
		if at <= 24 then
			var11 = vm.f32(var11 - vm.f32(3.1415927))
			var8 = vm.f32(var8 + vm.f32(vm.sin(var11) * 50.0))
			var10 = vm.f32(var10 + vm.f32(vm.cos(var11) * 50.0))
			var46 = 0
			var18 = vm.f32(var18 + 1.0)
			var20 = vm.f32(var20 + 1.0)
			var46 = var46 + 1
			var6 = vm.f32(var6 - vm.f32(3.1415927))
			var8 = vm.f32(vm.f32(vm.sin(var6) * 100.0) + var8)
			var9 = vm.f32(var9 + 30.0)
			var10 = vm.f32(vm.f32(vm.cos(var6) * 100.0) + var10)
			helper_c07d0298(0)
			junk += 5
		end
		if at <= 25 then
			helper_1c8c39a1(20)
		end
		if at <= 26 then
			helper_301a4(-1)
			helper_301a4(var1)
			helper_30610(var21)
			junk += 1
		end
	end
	if vm.wait() then
		return skip(1)
	end
	event.Initialize()
	helper_1c1f308e()
	event.SetMotion(0, "立ち")
	local t0 = helper_2efd0()
	if vm.skipping() then
		junk += 1
		return skip(2)
	end
	if t0 ~= 0 then
		event.Finish()
		return
	end
	event.SetStatusbarShow(0, 0.1)
	event.AssignStack(5)
	event.ClearStack(5)
	event.SetLoadbgFile(
		"dungeon/sphida/c01_golf.gltf",
		"dungeon/chara/c01b_miss.gltf",
		"dungeon/sphida/gool_end.gltf",
		"dungeon/sphida/mizu_eff.gltf"
	)
	if vm.wait() then
		return skip(3)
	end
	helper_d0ba87d6()
	if vm.skipping() then
		return skip(4)
	end
	event.LoadMotion(5, "dungeon/sphida/c01_golf.gltf", "info", 0)
	event.LoadMotion(5, "dungeon/chara/c01b_miss.gltf", "info", 0)
	tex_bank = event.SphidaGetTexb() or tex_bank
	event.LoadChara(5, "dungeon/sphida/gool_end.gltf", "info", 12)
	event.CharaActive(0, 12)
	var1 = event.SndLoadSound(5, "snd2/mon/en_900.sound.json") or var1
	event.CreateSwordEffect(5, 64, 16)
	event.SwordEffectColor(128, 128, 128, 80, 128, 128, 128, 80)
	event.EsmInitialize(5, 1)
	event.EsmLoadBasePack("足水パシャ", "dungeon/sphida/mizu_eff.gltf")
	event.EsmInitFix(5)
	event.EohSyncChara(0, 2)
	event.EohSetShow(0, 0)
	event.SetCrossfade(15)
	event.SphidaResetPowgage()
	do
		local out1, out2, out3 = event.SphidaGetBallPos()
		var8 = out1 or var8
		var9 = out2 or var9
		var10 = out3 or var10
	end
	var2, var3, var4, var6 = helper_2f3ec(var2, var3, var4, var6)
	helper_2fd58(var6)
	event.SphidaSetStatusFlag(1)
	var11 = 12.5
	event.SphidaCalcCarry(vm.f32(var11 * vm.f32(3.1415927)) / 180.0)
	var12, var13, var14 = helper_30f94(var12, var13, var14)
	event.SphidaSetPowgageSafeLevel(var14)
	do
		local out1, out2, out3 = event.ZeroVector()
		var15 = out1 or var15
		var16 = out2 or var16
		var17 = out3 or var17
	end
	while true do
		event.SphidaSetMinimapFlag(1)
		event.SphidaSetMmLineFlag(1)
		local t1: s32
		t1, var6, var11 = helper_2c4f4(var6, var11, tex_bank, sp + junk + 58)
		local t2 = t1
		if vm.skipping() then
			junk += 1
			return skip(5)
		end
		if t2 ~= 0 then
			event.SphidaSetMinimapFlag(0)
			event.SphidaSetMmLineFlag(0)
			event.SphidaSetBallPos(var8, var9, var10)
			event.SetCharaPos(8, var8, var9, var10)
			event.SetCharaPos(9, var8, var9, var10)
			helper_30610(0)
			if vm.skipping() then
				return skip(6)
			end
			return
		end
		event.SphidaSetMinimapFlag(0)
		event.SphidaSetMmLineFlag(0)
		local t3: s32
		t3, var12, var6, var16, var15, var14 = helper_2d348(var12, tex_bank, var6, var16, var15, var1, var14)
		local t4 = if t3 == 0 then 1 else 0
		if vm.skipping() then
			junk += 1
			return skip(7)
		end
		if t4 ~= 0 then
			break
		else
			if vm.wait() then
				return skip(8)
			end
		end
	end
	do
		local out1, out2, out3 = event.CopyVector(var2, var3, var4)
		var18 = out1 or var18
		var19 = out2 or var19
		var20 = out3 or var20
	end
	var21 = 0
	if var14 ~= 1 and var14 ~= -1 and var14 ~= 4 then
		event.SpriteSetType(0, 1)
		event.SpriteSetDraw(0, 1)
		event.SpriteSetPutsize(0, 10.8, 11.6)
		event.SpriteSetPos(0, var2, var3 + 30.0, var4)
		event.SpriteSetColor(0, 128, 128, 128, 0)
		if var14 == 0 then
			event.SpriteSetUvsize(0, 78, 198, 54, 58)
		end
		if var14 == 2 or var14 == -2 then
			event.SpriteSetUvsize(0, 186, 190, 70, 66)
		end
		if var14 == 3 or var14 == -3 then
			event.SpriteSetUvsize(0, 132, 198, 54, 58)
		end
		event.EohSyncSprite(18, 0)
		event.ObjsInit(18)
		event.ObjsSyncObj(18, 18)
		event.ObjsSetColor(18, 128, 128, 128, 128, 4)
		event.ObjsColorDelay(18, 20)
		event.ObjsSetColor(18, 128, 128, 128, 0, 6)
		helper_1c8c39a1(10)
		if vm.skipping() then
			return skip(9)
		end
	end
	if var12 <= vm.f32(0.3) then
		event.SetMotion(0, "小ショット", 2)
		helper_1c8c39a1(25)
		if vm.skipping() then
			return skip(10)
		end
		if var14 ~= 4 then
			event.SndSePlay(var1, 3)
		end
	elseif var12 <= vm.f32(0.6) then
		event.SetMotion(0, "中ショット", 2)
		helper_1c8c39a1(34)
		if vm.skipping() then
			return skip(11)
		end
		event.SndSePlay(var1, 2)
	else
		event.SetMotion(0, "大ショット", 2)
		helper_1c8c39a1(39)
		if vm.skipping() then
			return skip(12)
		end
		if var14 == 0 then
			event.SndSePlay(var1, 12)
		else
			event.SndSePlay(var1, 1)
		end
	end
	if var14 == 4 then
		helper_1c8c39a1(50)
		if vm.skipping() then
			return skip(13)
		end
		helper_301a4(var1)
		event.SphidaSetBallPos(var8, var9, var10)
		event.SetCharaPos(8, var8, var9, var10)
		event.SetCharaPos(9, var8, var9, var10)
		helper_30610(0)
		if vm.skipping() then
			return skip(14)
		end
		return
	end
	if var14 == 0 then
		event.SpriteSetType(1, 0)
		event.SpriteSetDraw(1, 1)
		event.SpriteSetPos(1, 256, 278)
		event.SpriteSetUvsize(1, 246, 104, 266, 42)
		event.SpriteSetPutsize(1, 266, 42)
		event.SpriteSetColor(1, 128, 128, 128, 0)
		event.SpriteSetScale(1, 10, 10, 10)
		event.EohSyncSprite(19, 1)
		event.ObjsInit(19)
		event.ObjsSyncObj(19, 19)
		event.ObjsJump(19, 256, 138, 0, 3.6, 20)
		event.ObjsSetScale(19, 1, 1, 1, 18)
		event.ObjsSetColor(19, 128, 128, 128, 128, 12)
		event.ObjsColorDelay(19, 30)
		event.ObjsSetColor(19, 128, 128, 128, 0, 6)
	end
	var12 = helper_dff48a5c(var12)
	var11 = vm.f32(vm.f32(var11 * vm.f32(3.1415927)) / 180.0)
	var12 = vm.f32(var12 - vm.f32(var12 * var11))
	var22 = vm.f32(vm.sin(var6) * vm.f32(var12 * vm.cos(var11)))
	var23 = vm.f32(var12 * vm.sin(var11))
	var24 = vm.f32(vm.cos(var6) * vm.f32(var12 * vm.cos(var11)))
	var16 = vm.f32(vm.f32(var16 * vm.f32(3.1415927)) / 2.0)
	var17 = vm.f32(vm.f32(vm.f32(-var24 * var13) * var15) * vm.f32(0.4))
	var15 = vm.f32(vm.f32(vm.f32(-var22 * var13) * var15) * vm.f32(0.4))
	do
		local out1, out2, out3 = event.SphidaGetPinPos()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	var29 = 0
	var14 = 0
	var42 = 0
	do
		local out1, out2, out3, out4, out5 =
			event.ChkIntersectionPoint_13(0, var2, var3 + 5.0, var4, var2, var3, var4, 0)
		var30 = out1 or var30
		var31 = out2 or var31
		var32 = out3 or var32
		var41 = out4 or var41
		var43 = out5 or var43
	end
	if var41 >= 0 and (var43 == 1 or var43 == 7) then
		print("----------------START_MIZU-------------------\n")
		var12 = 1.0
	else
		print("----------------START_SOTO-------------------\n")
		var12 = 0.0
	end
	var46 = 0
	while true do
		if var3 >= 180.0 then
			var22 = vm.f32(var22 * vm.f32(0.999))
			var23 = vm.f32(var23 + vm.f32(vm.f32(-0.0098) * (var46 + 1)))
			var24 = vm.f32(var24 * vm.f32(0.999))
		else
			var41 = event.ChkIntersectionPoint_9(12, var2, var3, var4, var2, vm.f32(var3 - 3.0) - vm.f32(0.01), var4, 0)
				or var41
			if var14 == 1 and var41 >= 0 then
				var22 = vm.f32(var22 * vm.f32(0.94))
				var23 = vm.f32(var23 + vm.f32(vm.f32(-0.00045) * (var46 + 1)))
				var24 = vm.f32(var24 * vm.f32(0.94))
				var22 = vm.f32(var22 + var15)
				var24 = vm.f32(var24 + var17)
				var15 = vm.f32(var15 * vm.f32(0.8))
				var17 = vm.f32(var17 * vm.f32(0.8))
			else
				var22 = vm.f32(var22 * vm.f32(0.999))
				var23 = vm.f32(var23 + vm.f32(vm.f32(-0.0045) * (var46 + 1)))
				var24 = vm.f32(var24 * vm.f32(0.999))
			end
		end
		do
			local out1, out2, out3 = event.AddVector(var2, var3, var4, var22, var23, var24)
			var2 = out1 or var2
			var3 = out2 or var3
			var4 = out3 or var4
		end
		if var16 ~= 0.0 then
			var11 = event.GetRefAngle(var18, var19, var20, var2, var3, var4) or var11
			var11 = vm.f32(var11 + var16)
			var11 = event.AngleLimit(var11) or var11
			var22 = vm.f32(var22 + vm.f32(vm.f32(vm.sin(var11) / 10.0) * var13))
			var24 = vm.f32(var24 + vm.f32(vm.f32(vm.cos(var11) / 10.0) * var13))
		end
		var40 = event.DistVector(var15, 0.0, var17) or var40
		if var40 > vm.f32(0.01) then
			var25 = event.DistVector(var15, 0.0, var17) or var25
			var11 = event.GetRefAngle(var18, var19, var20, var18 + var15, var19, var20 + var17) or var11
			do
				local out1, out2, out3 = event.GetCharaRot(8)
				var5 = out1 or var5
				var6 = out2 or var6
				var7 = out3 or var7
			end
			event.SetCharaRot(8, var5, var11, var7)
			event.AddCharaRot(8, var25 * 12.0, 0.0, 0.0)
			event.SetCharaRot(9, var5, var11, var7)
			event.AddCharaRot(9, var25 * 12.0, 0.0, 0.0)
		else
			var25 = event.DistVector(var22, 0.0, var24) or var25
			var11 = event.GetRefAngle(var18, var19, var20, var2, var3, var4) or var11
			do
				local out1, out2, out3 = event.GetCharaRot(8)
				var5 = out1 or var5
				var6 = out2 or var6
				var7 = out3 or var7
			end
			event.SetCharaRot(8, var5, var11, var7)
			event.AddCharaRot(8, var25 / 10.0, 0.0, 0.0)
			event.SetCharaRot(9, var5, var11, var7)
			event.AddCharaRot(9, var25 / 10.0, 0.0, 0.0)
		end
		var25 = event.DistVector(var22, var23, var24) or var25
		var39 = var25
		var11 = event.GetRefAngle(var18, var19, var20, var2, var3, var4) or var11
		var36 = vm.f32(vm.sin(vm.f32(var11 - vm.f32(1.5707964))) * 3.0)
		var38 = vm.f32(vm.cos(vm.f32(var11 - vm.f32(1.5707964))) * 3.0)
		event.SwordEffectAddPoint(
			var2 - var36,
			var3,
			var4 - var38,
			vm.f32(var2 + var36) + var36,
			var3,
			vm.f32(var4 + var38) + var38
		)
		do
			local out1, out2, out3 = event.CopyVector(var22, var23, var24)
			var36 = out1 or var36
			var37 = out2 or var37
			var38 = out3 or var38
		end
		do
			local out1, out2, out3 = event.NormalVector(var36, var37, var38)
			var36 = out1 or var36
			var37 = out2 or var37
			var38 = out3 or var38
		end
		do
			local out1, out2, out3 = event.ScaleVector(var36, var37, var38, 3.0)
			var36 = out1 or var36
			var37 = out2 or var37
			var38 = out3 or var38
		end
		do
			local out1, out2, out3, out4, out5 =
				event.ChkIntersectionPoint_13(0, var18, var19, var20, var2 + var36, var3 + var37, var4 + var38, 0)
			var30 = out1 or var30
			var31 = out2 or var31
			var32 = out3 or var32
			var41 = out4 or var41
			var43 = out5 or var43
		end
		if var41 >= 0 and (var43 == 1 or var43 == 7) then
			event.EsmCreate("足水パシャ")
			event.EsmSetVect1(var30, var31, var32)
			if var42 <= 0 then
				event.SndSePlay(var1, 11)
				var42 = 10
			end
			if var12 == 0.0 then
				var12 = 1.0
				var22 = vm.f32(var22 * vm.f32(0.4))
				var23 = vm.f32(var23 * vm.f32(0.4))
				var24 = vm.f32(var24 * vm.f32(0.4))
				var15 = 0.0
				var17 = 0.0
				event.DeleteSwordEffect()
				print("----------------SE OFF-------------------\n")
			else
				var12 = 0.0
				print("----------------SE ON-------------------\n")
			end
		end
		do
			local out1, out2, out3, out4, out5, out6, out7 =
				event.ChkIntersectionPoint_15(12, var18, var19, var20, var2 + var36, var3 + var37, var4 + var38, 1)
			var30 = out1 or var30
			var31 = out2 or var31
			var32 = out3 or var32
			var33 = out4 or var33
			var34 = out5 or var34
			var35 = out6 or var35
			var41 = out7 or var41
		end
		if var41 < 0 then
			if var3 >= 380.0 and var23 > 0.0 then
				do
					local out1, out2, out3 = event.CopyVector(var2, var3, var4)
					var30 = out1 or var30
					var31 = out2 or var31
					var32 = out3 or var32
				end
				do
					local out1, out2, out3 = event.CopyVector(var22, -var23, var24)
					var33 = out1 or var33
					var34 = out2 or var34
					var35 = out3 or var35
				end
				do
					local out1, out2, out3 = event.NormalVector(var33, var34, var35)
					var33 = out1 or var33
					var34 = out2 or var34
					var35 = out3 or var35
				end
				var41 = 1
			end
		end
		while var41 >= 0 do
			var16 = 0.0
			if var25 > 8.0 then
				helper_79d90c82()
			end
			if var12 ~= 1.0 and var42 <= 0 then
				event.SndSePlay(var1, 6)
				var42 = 10
			end
			do
				local out1, out2, out3 = event.CopyVector(-var22, -var23, -var24)
				var22 = out1 or var22
				var23 = out2 or var23
				var24 = out3 or var24
			end
			do
				local out1, out2, out3 = event.NormalVector(var22, var23, var24)
				var22 = out1 or var22
				var23 = out2 or var23
				var24 = out3 or var24
			end
			do
				local out1, out2, out3 = event.ScaleVector(var22, var23, var24, 3.0)
				var22 = out1 or var22
				var23 = out2 or var23
				var24 = out3 or var24
			end
			do
				local out1, out2, out3 = event.AddVector(var30, var31, var32, var22, var23, var24)
				var30 = out1 or var30
				var31 = out2 or var31
				var32 = out3 or var32
			end
			do
				local out1, out2, out3 = event.SubVector(var18, var19, var20, var30, var31, var32)
				var18 = out1 or var18
				var19 = out2 or var19
				var20 = out3 or var20
			end
			var40 = event.DistVector(var18, var19, var20) or var40
			var40 = vm.f32(var39 - var40)
			if var40 <= 0.0 then
				break
			else
				var39 = var40
				do
					local out1, out2, out3 = event.CopyVector(-var22, -var23, -var24)
					var22 = out1 or var22
					var23 = out2 or var23
					var24 = out3 or var24
				end
				if var23 < 0.0 and var34 > 0.0 then
					var22 = vm.f32(var15 * 2.0)
					var23 = 0.0
					var24 = vm.f32(var17 * 2.0)
					var15 = vm.f32(var15 * vm.f32(0.2))
					var17 = vm.f32(var17 * vm.f32(0.2))
				else
					if
						var22 < 0.0 and var33 > 0.0
						or var22 > 0.0 and var33 < 0.0
						or var24 < 0.0 and var35 > 0.0
						or var24 > 0.0 and var35 < 0.0
					then
						var15 = 0.0
						var17 = 0.0
					end
					var22 = 0.0
					var23 = 0.0
					var24 = 0.0
				end
				if var12 == 0.0 then
					var22 = vm.f32(vm.f32(vm.f32(var33 * var25) * vm.f32(0.9)) + var22)
					var23 = vm.f32(vm.f32(vm.f32(var34 * var25) * vm.f32(0.58)) + var23)
					var24 = vm.f32(vm.f32(vm.f32(var35 * var25) * vm.f32(0.9)) + var24)
				else
					print("MIZU______1--------------------------------------------------------------------\n")
					var22 = vm.f32(vm.f32(vm.f32(var33 * var25) * vm.f32(0.8)) + var22)
					var23 = vm.f32(vm.f32(vm.f32(var34 * var25) * vm.f32(0.4)) + var23)
					var24 = vm.f32(vm.f32(vm.f32(var35 * var25) * vm.f32(0.8)) + var24)
				end
				do
					local out1, out2, out3 = event.CopyVector(var30, var31, var32)
					var18 = out1 or var18
					var19 = out2 or var19
					var20 = out3 or var20
				end
				do
					local out1, out2, out3 = event.CopyVector(var22, var23, var24)
					var36 = out1 or var36
					var37 = out2 or var37
					var38 = out3 or var38
				end
				do
					local out1, out2, out3 = event.NormalVector(var36, var37, var38)
					var36 = out1 or var36
					var37 = out2 or var37
					var38 = out3 or var38
				end
				do
					local out1, out2, out3 = event.ScaleVector(var36, var37, var38, 3.0)
					var36 = out1 or var36
					var37 = out2 or var37
					var38 = out3 or var38
				end
				do
					local out1, out2, out3 = event.ScaleVector(var33, var34, var35, var40)
					var33 = out1 or var33
					var34 = out2 or var34
					var35 = out3 or var35
				end
				do
					local out1, out2, out3 = event.CopyVector(var30, var31, var32)
					var2 = out1 or var2
					var3 = out2 or var3
					var4 = out3 or var4
				end
				do
					local out1, out2, out3 = event.AddVector(var2, var3, var4, var33, var34, var35)
					var2 = out1 or var2
					var3 = out2 or var3
					var4 = out3 or var4
				end
				do
					local out1, out2, out3, out4, out5, out6, out7, out8 = event.ChkIntersectionPoint_16(
						12,
						var18,
						var19,
						var20,
						var2 + var36,
						var3 + var37,
						var4 + var38,
						1
					)
					var30 = out1 or var30
					var31 = out2 or var31
					var32 = out3 or var32
					var33 = out4 or var33
					var34 = out5 or var34
					var35 = out6 or var35
					var41 = out7 or var41
					var43 = out8 or var43
				end
			end
		end
		do
			local out1, out2, out3, out4, out5, out6, out7, out8 =
				event.ChkIntersectionPoint_16(12, var2, var3, var4, var2, var3 - 3.0, var4, 1)
			var30 = out1 or var30
			var31 = out2 or var31
			var32 = out3 or var32
			var33 = out4 or var33
			var34 = out5 or var34
			var35 = out6 or var35
			var41 = out7 or var41
			var43 = out8 or var43
		end
		if var41 >= 0 then
			var16 = 0.0
			var3 = vm.f32(var31 + 3.0)
			var40 = event.DistVector(var22, 0.0, var24) or var40
			if var40 < vm.f32(2.6) or var23 >= -1.0 and var23 <= 0.0 then
				var23 = 0.0
				var14 = 1
			else
				if var12 == 0.0 then
					var22 = vm.f32(var22 * vm.f32(0.9))
					var23 = -vm.f32(var23 * vm.f32(0.58))
					var24 = vm.f32(var24 * vm.f32(0.9))
					var22 = vm.f32(var22 + vm.f32(var15 * 2.0))
					var24 = vm.f32(var24 + vm.f32(var17 * 2.0))
					var15 = vm.f32(var15 * vm.f32(0.2))
					var17 = vm.f32(var17 * vm.f32(0.2))
				else
					print("MIZU______2--------------------------------------------------------------------\n")
					var22 = vm.f32(var22 * vm.f32(0.8))
					var23 = -vm.f32(var23 * vm.f32(0.4))
					var24 = vm.f32(var24 * vm.f32(0.8))
					var15 = 0.0
					var17 = 0.0
				end
				if var25 > 8.0 then
					helper_79d90c82()
				end
				if var12 ~= 1.0 and var42 <= 0 then
					event.SndSePlay(var1, 5)
					var42 = 10
				end
			end
			var40 = event.DistVector(var15, 0.0, var17) or var40
			if var23 == 0.0 and var25 < vm.f32(1.6) and var40 < vm.f32(0.4) then
				if var43 == 6 then
					var29 = 1
					break
				end
				var43 = event.AmgGetAttrStatus(var2, var3, var4) or var43
				if not (var43 == 1) then
					break
				end
				var29 = 1
				break
			end
		end
		if var3 < -500.0 then
			var29 = 1
			break
		elseif var46 >= 480 then
			var29 = 1
			break
		else
			var44 = event.SphidaGetPinCol() or var44
			var45 = event.SphidaGetBallCol() or var45
			x = vm.f32(pos_x - var2)
			y = vm.f32(pos_y - var3)
			z = vm.f32(pos_z - var4)
			var47 = event.DistVector(x, y, z) or var47
			if var45 ~= var44 then
				var51 = event.LinePointDist(var18, var19, var20, var2, var3, var4, pos_x, pos_y, pos_z) or var51
				if var51 >= 0.0 and var51 <= 30.0 then
					var21 = 1
					break
				end
				if var47 ~= 0.0 then
					if var47 <= 120.0 then
						do
							local out1, out2, out3 = event.ScaleVector(x, y, z, vm.fdiv(vm.f32(0.6), var47))
							x = out1 or x
							y = out2 or y
							z = out3 or z
						end
						do
							local out1, out2, out3 = event.AddVector(var2, var3, var4, x, y, z)
							var2 = out1 or var2
							var3 = out2 or var3
							var4 = out3 or var4
						end
						do
							local out1, out2, out3 = event.AddVector(var22, var23, var24, x, y, z)
							var22 = out1 or var22
							var23 = out2 or var23
							var24 = out3 or var24
						end
					end
				else
					var21 = 1
					break
				end
			elseif var47 ~= 0.0 then
				if var47 <= 60.0 then
					do
						local out1, out2, out3 = event.ScaleVector(x, y, z, vm.fdiv(1.0, var47))
						x = out1 or x
						y = out2 or y
						z = out3 or z
					end
					do
						local out1, out2, out3 = event.SubVector(var2, var3, var4, x, y, z)
						var2 = out1 or var2
						var3 = out2 or var3
						var4 = out3 or var4
					end
					do
						local out1, out2, out3 = event.SubVector(var22, var23, var24, x, y, z)
						var22 = out1 or var22
						var23 = out2 or var23
						var24 = out3 or var24
					end
				end
			end
			event.SetCharaPos(8, var2, var3, var4)
			event.SetCharaPos(9, var2, var3, var4)
			do
				local out1, out2, out3 = event.CopyVector(var2, var3, var4)
				var18 = out1 or var18
				var19 = out2 or var19
				var20 = out3 or var20
			end
			if var3 <= -50.0 then
				event.SetFcameraFollowFlag(0)
				if var29 >= 30 then
					if var29 >= 50 then
						break
					end
				else
					event.SetCameraRef(var2, var3, var4)
				end
				var29 = var29 + 1
			elseif var46 >= 20 then
				event.CtrlcMoveRange(20.0, 30.0, 60.0, 200.0)
				event.SetCameraSpeed(8.0)
				event.SetFcameraFollowOfs(0.0, 0.0, 0.0)
				event.SetFcameraFollow(
					vm.f32(var2 + var22) + var22,
					vm.f32(var3 + var23) + var23,
					vm.f32(var4 + var24) + var24
				)
				do
					local out1, out2, out3 = event.GetCameraPos()
					pos_x_2 = out1 or pos_x_2
					pos_y_2 = out2 or pos_y_2
					pos_z_2 = out3 or pos_z_2
				end
				yaw = event.GetRefAngle(
					vm.f32(var2 + var22) + var22,
					vm.f32(var3 + var23) + var23,
					vm.f32(var4 + var24) + var24,
					pos_x_2,
					pos_y_2,
					pos_z_2
				) or yaw
				event.CtrlcSetRotate(yaw)
				event.CtrlcMoveCamera(8)
				event.CtrlcStep()
			end
			event.SphidaSetBallPos(var2, var3, var4)
			if vm.wait() then
				return skip(15)
			end
			if var42 > 0 then
				var42 = var42 - 1
			end
			var46 = var46 + 1
		end
	end
	event.SetCharaPos(8, var2, var3, var4)
	event.SetCharaPos(9, var2, var3, var4)
	event.SphidaSetStatusFlag(0)
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	if var29 == 0 then
		event.SphidaSetBallPos(var2, var3, var4)
		count = event.SphidaGetParCount() or count
		if var21 == 1 then
			event.CharaActive(0, 0)
			event.CharaActive(0, 8)
			event.CharaActive(0, 9)
			event.CharaActive(1, 12)
			event.SetCharaPos(12, pos_x, pos_y, pos_z)
			event.SetMotion(12, "発動", 6)
			event.SndSePlay(var1, 17)
			var46 = 0
			while var46 < 2 do
				event.SetCameraCtrl(0)
				event.SetFcameraFollowFlag(1)
				event.SetFcameraFollowA(pos_x, pos_y, pos_z)
				event.SetCameraSpeed(12.0)
				event.SetFcameraFollowOfs(0.0, 0.0, 0.0)
				event.SetFcameraHeight(0.0)
				event.SetFcameraDist(100.0)
				event.FcameraStep(1)
				var46 = var46 + 1
				if vm.wait() then
					return skip(16)
				end
			end
			event.CharaActive(0, 10)
			do
				local out1, out2, out3 = event.SphidaGetPinPos()
				pos_x = out1 or pos_x
				pos_y = out2 or pos_y
				pos_z = out3 or pos_z
			end
			var46 = 0
			while var46 < 100 do
				event.SetCameraCtrl(0)
				event.SetFcameraFollowFlag(1)
				event.SetFcameraFollowA(pos_x, pos_y, pos_z)
				event.SetCameraSpeed(12.0)
				event.SetFcameraFollowOfs(0.0, 0.0, 0.0)
				event.SetFcameraHeight(0.0)
				event.SetFcameraDist(100.0)
				event.FcameraStep(1)
				var46 = var46 + 1
				if vm.wait() then
					return skip(17)
				end
			end
			event.CharaActive(0, 11)
			var44 = event.DngGetStageId() or var44
			var45 = event.DngGetFloorId() or var45
			var41 = event.GetFloorInfo(var44, var45, 4) or var41
			do
				local out1, out2 = event.SphidaGetPrize(var41)
				var42 = out1 or var42
				var43 = out2 or var43
			end
			var41 = vm.i32(var41 + 1)
			event.SetFloorInfo(var44, var45, 4, var41)
			event.PostTreasureBox(pos_x, pos_y - 30.0, pos_z, var11, var42, var43)
			helper_1c8c39a1(54)
			if vm.skipping() then
				return skip(18)
			end
			helper_1c8c39a1(30)
			if vm.skipping() then
				return skip(19)
			end
			event.DeleteChara(8)
			event.DeleteChara(9)
			event.DeleteChara(10)
			event.DeleteChara(11)
			event.SphidaSetPlayFlag(0)
			var1 = event.SndLoadSound(8, "snd2/sp/sp_000.sound.json") or var1
			event.StopBgm(0)
			event.SndSePlay(var1, 0)
			event.CharaActive(1, 0)
			event.SetFcameraFollowFlag(0)
			event.SetCameraCtrl(0)
			event.CmrsInit()
			event.CmrsSyncObj(0, 0.0, 15.0, 0.0, 0.0, 0.0, 80.0, "", 1)
			event.ObjsSetMotion(0, "カップインポーズ", 6)
			event.ObjsNormalDrive(0)
			event.ObjsNextMotion(0, "カップインポーズL", 4)
			event.ObjsResetDaPosition(0)
			var42 = event.GetLanguage() or var42
			if var42 == 0 then
				event.SpriteInit(0)
				event.SpriteSetType(0, 0)
				event.SpriteSetTexture(0, "sphida_bar", tex_bank)
				event.SpriteSetUvsize(0, 258, 0, 254, 54)
				event.SpriteSetPos(0, 256, 208)
				event.SpriteSetPutsize(0, 254, 54)
				event.SpriteSetColor(0, 128, 128, 128, 0)
				event.SpriteSetScale(0, 5.0, 5.0)
				event.SpriteSetDraw(0, 1)
			else
				event.SpriteInit(0)
				event.SpriteSetType(0, 0)
				event.SpriteSetTexture(0, "sphida_bar", tex_bank)
				event.SpriteSetUvsize(0, 206, 0, 306, 54)
				event.SpriteSetPos(0, 256, 208)
				event.SpriteSetPutsize(0, 254, 54)
				event.SpriteSetColor(0, 128, 128, 128, 0)
				event.SpriteSetScale(0, 5.0, 5.0)
				event.SpriteSetDraw(0, 1)
			end
			event.EohSyncSprite(1, 0)
			event.ObjsInit(1)
			event.ObjsSyncObj(1, 1)
			event.ObjsSetScale(1, 1.0, 1.0, 0.0, 60)
			event.ObjsSetColor(1, 128, 128, 128, 128, 60)
			helper_c07d0298(0)
			if vm.skipping() then
				return skip(20)
			end
			helper_1c8c39a1(90)
			if vm.skipping() then
				return skip(21)
			end
			if vm.wait() then
				return skip(22)
			end
			event.PlayBgm(0)
			event.CmrsReleaseObj()
			event.SpriteSetDraw(0, 0)
		elseif count >= 2 then
			event.SetMesWindowMode(0, 5)
			event.SetMesQuestionGyou(0, 0)
			var57 = helper_6efad7f4(0, 2002, 8, 256, 208, 2, 0)
			if vm.skipping() then
				return skip(23)
			end
			if vm.wait() then
				return skip(24)
			end
			if var57 == 0 then
				do
					local out1, out2, out3, out4 = event.GetPartsFuncPos(var2, var3, var4, 100.0, "point")
					var41 = out1 or var41
					var8 = out2 or var8
					var9 = out3 or var9
					var10 = out4 or var10
				end
				if var41 == 0 then
					do
						local out1, out2, out3 = event.GetPartsOrigin(var2, var3, var4, 100.0)
						var8 = out1 or var8
						var9 = out2 or var9
						var10 = out3 or var10
					end
				end
				do
					local out1, out2, out3 = event.SphidaGetPinPos()
					pos_x = out1 or pos_x
					pos_y = out2 or pos_y
					pos_z = out3 or pos_z
				end
				var25 = event.DistVector2(var8, var9, var10, pos_x, pos_y, pos_z) or var25
				if var25 < 40.0 then
					var11 = event.GetRand(6.2831855) or var11
					var11 = vm.f32(var11 - vm.f32(3.1415927))
					var8 = vm.f32(var8 + vm.f32(vm.sin(var11) * 50.0))
					var10 = vm.f32(var10 + vm.f32(vm.cos(var11) * 50.0))
				else
					do
						local out1, out2, out3, out4 = event.GetNearTboxPos(var8, var9, var10)
						var30 = out1 or var30
						var31 = out2 or var31
						var32 = out3 or var32
						var41 = out4 or var41
					end
					var46 = 0
					while var41 >= 0 do
						do
							local out1, out2, out3 = event.CopyVector(var8, var9, var10)
							var18 = out1 or var18
							var19 = out2 or var19
							var20 = out3 or var20
						end
						do
							local out1, out2, out3 = event.SubVector(var18, var19, var20, var30, var31, var32)
							var18 = out1 or var18
							var19 = out2 or var19
							var20 = out3 or var20
						end
						var18 = vm.f32(var18 + 1.0)
						var20 = vm.f32(var20 + 1.0)
						do
							local out1, out2, out3 = event.NormalVector(var18, var19, var20)
							var18 = out1 or var18
							var19 = out2 or var19
							var20 = out3 or var20
						end
						do
							local out1, out2, out3 = event.ScaleVector(var18, var19, var20, 30.1)
							var18 = out1 or var18
							var19 = out2 or var19
							var20 = out3 or var20
						end
						do
							local out1, out2, out3 = event.CopyVector(var30, var31, var32)
							var8 = out1 or var8
							var9 = out2 or var9
							var10 = out3 or var10
						end
						do
							local out1, out2, out3 = event.AddVector(var8, var9, var10, var18, var19, var20)
							var8 = out1 or var8
							var9 = out2 or var9
							var10 = out3 or var10
						end
						var46 = var46 + 1
						if var46 > 6 then
							break
						end
						do
							local out1, out2, out3, out4 = event.GetNearTboxPos(var8, var9, var10)
							var30 = out1 or var30
							var31 = out2 or var31
							var32 = out3 or var32
							var41 = out4 or var41
						end
					end
				end
				var6 = event.GetRefAngle(var8, var9, var10, var2, var3, var4) or var6
				event.SetCharaPos(0, var8, var9, var10)
				event.SetCharaRot(0, 0.0, var6, 0.0)
				event.SetCameraRef(var8, var9 + 30.0, var10)
				var6 = vm.f32(var6 - vm.f32(3.1415927))
				var6 = event.AngleLimit(var6) or var6
				var8 = vm.f32(vm.f32(vm.sin(var6) * 100.0) + var8)
				var9 = vm.f32(var9 + 30.0)
				var10 = vm.f32(vm.f32(vm.cos(var6) * 100.0) + var10)
				event.SetCameraPos(var8, var9, var10)
				event.ResetCamera(0)
			end
		end
	else
		event.SndSePlay(var1, 18)
		event.SetFcameraFollowFlag(0)
		event.SetCameraCtrl(0)
		event.CmrsInit()
		event.CmrsSyncObj(0, 0.0, 15.0, 0.0, 0.0, 0.0, 80.0, "", 1)
		event.ObjsSetMotion(0, "だめだめ", 6)
		event.ObjsNormalDrive(0)
		event.ObjsNextMotion(0, "立ち", 4)
		event.ObjsResetDaPosition(0)
		event.SpriteInit(0)
		event.SpriteSetType(0, 0)
		event.SpriteSetTexture(0, "sphida_bar", tex_bank)
		event.SpriteSetUvsize(0, 334, 54, 178, 34)
		event.SpriteSetPos(0, 256, -25)
		event.SpriteSetPutsize(0, 160, 50)
		event.SpriteSetColor(0, 128, 128, 128, 128)
		event.SpriteSetDraw(0, 1)
		event.EohSyncSprite(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.ObjsJump(1, 256.0, 208.0, 0.0, 1.2, 16)
		event.ObjsJump(1, 256.0, 208.0, 0.0, 2.0, 12)
		event.ObjsJump(1, 256.0, 208.0, 0.0, 1.5, 8)
		helper_c07d0298(0)
		if vm.skipping() then
			return skip(25)
		end
		helper_1c8c39a1(20)
		if vm.skipping() then
			return skip(26)
		end
		event.SpriteSetDraw(0, 0)
		event.SphidaSetBallPos(var8, var9, var10)
		event.SetCharaPos(8, var8, var9, var10)
		event.SetCharaPos(9, var8, var9, var10)
		event.CmrsReleaseObj()
	end
	if var21 == 1 then
		helper_301a4(-1)
	else
		helper_301a4(var1)
	end
	helper_30610(var21)
	if vm.skipping() then
		return skip(27)
	end
end

--- Program 3001.
script[3001] = function()
	local var0: any = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_301a4(-1)
		end
	end
	event.Initialize()
	helper_1c1f308e()
	event.SetMesWindowMode(0, 5)
	event.SetMesQuestionGyou(0, 0)
	var0 = helper_6efad7f4(0, 2004, 8, 0, 0, 2, 1)
	if vm.skipping() then
		return skip(1)
	end
	if var0 == 0 then
		do
			local out1, out2, out3 = event.GetCharaPos(0)
			var1 = out1 or var1
			var2 = out2 or var2
			var3 = out3 or var3
		end
		event.SphidaSetBallPos(var1, var2 + 3.0, var3)
		event.SetCharaPos(8, var1, var2 + 3.0, var3)
		event.SetCharaPos(9, var1, var2 + 3.0, var3)
		helper_301a4(-1)
		event.SetCrossfade(15)
	end
	if vm.wait() then
		return skip(2)
	end
	event.Finish()
end

--- Program 3002.
script[3002] = function()
	local var0: any = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var0 = helper_6efad7f4(0, -1, 8, 0, 0, 2, 1)
		end
	end
	event.Initialize()
	helper_1c1f308e()
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(0, "Questa [UNI00e8] l'ultima volta che potrai\navvicinare la Sphera.")
	helper_7ec0dfb1(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesWindowMode(0, 5)
	event.SetMesQuestionGyou(0, 0)
	event.MesMake_2(0, "Avvicinare la Sphera?")
	var0 = helper_6efad7f4(0, -1, 8, 0, 0, 2, 1)
	if vm.skipping() then
		return skip(2)
	end
	if var0 == 0 then
		do
			local out1, out2, out3 = event.GetCharaPos(0)
			var1 = out1 or var1
			var2 = out2 or var2
			var3 = out3 or var3
		end
		event.SphidaSetBallPos(var1, var2 + 3.0, var3)
		event.SetCharaPos(8, var1, var2 + 3.0, var3)
		event.SetCharaPos(9, var1, var2 + 3.0, var3)
		event.SphidaSetLastChallenge(1)
		event.SetCrossfade(15)
	end
	if vm.wait() then
		return skip(3)
	end
	event.Finish()
end

--- Program 4000.
script[4000] = function()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_3c6a8(0)
			if not vm.skipping() then
				return part2()
			end
		end
		helper_c3c7815d(0, -1)
	end
	function part2()
		helper_c3c7815d(0, -1)
	end
	event.Initialize()
	helper_66b705b3()
	event.SetFadeOut(0)
	if vm.wait() then
		return skip(1)
	end
	event.LoadDungeonMapFile("d04f02", "d04f02", 8)
	helper_3c6a8(0)
	if vm.skipping() then
		return skip(2)
	end
	return part2()
end

--- Program 14060.
script[14060] = function()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_3ae7c()
			if not vm.skipping() then
				return part2()
			end
		end
	end
	function part2()
		event.BgmLoadCancel()
		event.LoadDungeonMapFile("s46")
		event.LoadScript("s46/s46.stb", 520)
	end
	helper_48790()
	if vm.skipping() then
		return skip(1)
	end
	event.LoadDungeonMapFile("d04f02", "d04f02", 40)
	helper_3ae7c()
	if vm.skipping() then
		return skip(2)
	end
	return part2()
end

--- Program 14080.
script[14080] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_48790()
	if vm.skipping() then
		return skip(1)
	end
	event.LoadDungeonMapFile("s19")
	event.LoadScript("s19/s19.stb", 14080)
end

--- Program 14100.
script[14100] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_48790()
	if vm.skipping() then
		return skip(1)
	end
	event.LoadDungeonMapFile("s19")
	event.LoadScript("s19/s19.stb", 14100)
end

--- Program 14160.
script[14160] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_48790()
	if vm.skipping() then
		return skip(1)
	end
	event.LoadDungeonMapFile("s19")
	event.LoadScript("s19/s19.stb", 14160)
end

--- Program 14200.
script[14200] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_48790()
	if vm.skipping() then
		return skip(1)
	end
	event.LoadDungeonMapFile("s19")
	event.LoadScript("s19/s19.stb", 14200)
end

--- Program 14320.
script[14320] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_48790()
	if vm.skipping() then
		return skip(1)
	end
	event.SetFlag(400, 1)
	event.SetFlag(432, 0)
	event.SetFlag(434, 0)
	event.SetFlag(436, 0)
	event.SetFlag(438, 0)
	event.AddItem(373)
	event.GotoEdit(90, 100)
end

--- Program 14360.
script[14360] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_48790()
	if vm.skipping() then
		return skip(1)
	end
	event.SetFlag(400, 1)
	event.SetFlag(432, 0)
	event.SetFlag(436, 0)
	event.SetFlag(438, 0)
	event.SubItem(373, 900)
	event.GotoEdit(90, 100)
end

--- Program 14400.
script[14400] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_48790()
	if vm.skipping() then
		return skip(1)
	end
	event.LoadDungeonMapFile("d04b01")
	event.LoadScript("d04b01/d04b01.stb", 14400)
end

--- Program 14440.
script[14440] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_48790()
	if vm.skipping() then
		return skip(1)
	end
	event.LoadDungeonMapFile("d04b01")
	event.LoadScript("d04b01/d04b01.stb", 14440)
end

--- Program 24010.
script[24010] = function()
	local argc: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetCharaMaxhp(0, 80)
	event.SetCharaMaxhp(1, 80)
	event.SetCharaDefence(0, 22)
	event.SetCharaDefence(1, 22)
	argc = event.GetItemNum(270) or argc
	if argc < 20 then
		event.AddItem(270, vm.i32(20 - argc))
	end
	event.AddItem(17)
	event.SetCharaEquip(0, 17)
	event.AddItem(26)
	event.SetCharaEquip(0, 26)
	event.AddItem(54)
	event.SetCharaEquip(1, 54)
	event.AddItem(94)
	event.SetCharaEquip(1, 94)
	event.LoadDungeonMapFile("s19")
	if vm.wait() then
		return skip(1)
	end
	event.LoadScript("s19/s19.stb", 151)
end

--- Program 24020.
script[24020] = function()
	local argc: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetCharaMaxhp(0, 80)
	event.SetCharaMaxhp(1, 80)
	event.SetCharaDefence(0, 22)
	event.SetCharaDefence(1, 22)
	argc = event.GetItemNum(270) or argc
	if argc < 20 then
		event.AddItem(270, vm.i32(20 - argc))
	end
	event.AddItem(17)
	event.SetCharaEquip(0, 17)
	event.AddItem(26)
	event.SetCharaEquip(0, 26)
	event.AddItem(54)
	event.SetCharaEquip(1, 54)
	event.AddItem(94)
	event.SetCharaEquip(1, 94)
	event.LoadDungeonMapFile("d04b01")
	if vm.wait() then
		return skip(1)
	end
	event.LoadScript("d04b01/d04b01.stb", 24020)
end

--- Program 26030.
script[26030] = function()
	local argc: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetCharaMaxhp(0, 160)
	event.SetCharaMaxhp(1, 160)
	event.SetCharaDefence(0, 50)
	event.SetCharaDefence(1, 50)
	argc = event.GetItemNum(270) or argc
	if argc < 20 then
		event.AddItem(270, vm.i32(20 - argc))
	end
	event.AddItem(16)
	event.SetCharaEquip(0, 16)
	event.AddItem(27)
	event.SetCharaEquip(0, 27)
	event.AddItem(71)
	event.SetCharaEquip(1, 71)
	event.AddItem(100)
	event.SetCharaEquip(1, 100)
	event.LoadDungeonMapFile("s15")
	if vm.wait() then
		return skip(1)
	end
	event.LoadScript("s15/s15.stb", 26030)
end

return script
