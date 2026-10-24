--!strict
-- map/m/m01/m01_4.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_03ef7038 = require("@lib/event/helper_03ef7038")
local helper_125385ee = require("@lib/event/helper_125385ee")
local helper_25abe6d2 = require("@lib/event/helper_25abe6d2")
local helper_598da305 = require("@lib/event/helper_598da305")
local helper_6082cadd = require("@lib/event/helper_6082cadd")
local helper_899661d6 = require("@lib/event/helper_899661d6")
local helper_8f5252f6 = require("@lib/event/helper_8f5252f6")
local helper_9dafbc83 = require("@lib/event/helper_9dafbc83")
local helper_a3a848ae = require("@lib/event/helper_a3a848ae")
local helper_a3cc6850 = require("@lib/event/helper_a3cc6850")
local helper_a4226c93 = require("@lib/event/helper_a4226c93")
local helper_a981053a = require("@lib/event/helper_a981053a")
local helper_b8d9d9d0 = require("@lib/event/helper_b8d9d9d0")
local helper_be79d02f = require("@lib/event/helper_be79d02f")
local helper_d3f20302 = require("@lib/event/helper_d3f20302")
local helper_d4692479 = require("@lib/event/helper_d4692479")
local helper_e6998a9e = require("@lib/event/helper_e6998a9e")
local helper_f57795f8 = require("@lib/event/helper_f57795f8")
local helper_f9b4fb5f = require("@lib/event/helper_f9b4fb5f")

--- Event 248, which map data, a script or the engine runs by number.
local function event_248()
	event.SetMotion(0, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	helper_a3cc6850(0, -1, 8, 0, 0)
	event.SetMesWindowMode(0, 1)
end

--- Helper function.
local function helper_4433c()
	local var0: s32 = 0
	local var1: any = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local at: number = 0
	return vm.guard(function()
		print("00000000000000000000000000\n")
		event.Initialize()
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.SetMotion(0, "立ち", 4)
		event.SetMesWindowMode(0, 5)
		var0 = event.GetMenuEtc_2(1) or var0
		if var0 == 1 then
			event.MesMake_2(0, "Vai al Torneo di Pesca?")
		else
			event.MesMake_2(0, "Vai al Pinna Sprint?")
		end
		print("11111111111111111111111111111111\n")
		at = 1
		var1 = helper_8f5252f6(0, -1, 8, 256, 208, 2, 1)
		if var1 == 0 then
			event.CmrsSetPos(1332.56, 67.86, 1494.1)
			event.CmrsSetRef(1508.0, 12.6, 1425.04)
			event.CmrsMove2(1332.56, 97.86, 1494.1, 1508.0, 42.6, 1425.04, 48, 2, 0.4)
			event.ObjsSetMotion(0, "走り", 4, -1.0, 1)
			do
				local out1, out2, _ = event.GetCharaPos(0)
				var2 = out1 or var2
				var3 = out2 or var3
			end
			event.ObjsSetPos(0, var2, var3, 1415.0)
			event.ObjsSetRot(0, 0.0, 1.57, 0.0)
			event.ObjsMove(0, 1800.0, var3, 1415.0, 90)
			at = 2
			helper_25abe6d2(15)
			event.SetFadeOut(30)
			at = 3
			helper_25abe6d2(30)
			return 1
		end
		event.ObjsSetMotion(0, "歩き", 4, -1.0, 1)
		event.ObjsRotation(0, 0.0, -1.57, 0.0, 15)
		at = 4
		helper_25abe6d2(15)
		do
			local _, out2, out3 = event.GetCharaPos(0)
			var6 = out2 or var6
			var7 = out3 or var7
		end
		event.ObjsMove(0, 1480.0, var6, var7, 45)
		at = 5
		helper_25abe6d2(45)
		event.ObjsSetMotion(0, "立ち", 4, -1.0, 1)
		return 0
	end, function(received: { any })
		if at <= 3 then
			if at == 1 then
				var1 = received[1] :: number
			end
			if at <= 1 then
				helper_d3f20302(15)
			end
			if at <= 2 then
				helper_d3f20302(30)
			end
			return 1
		end
		if at <= 5 then
			if at <= 4 then
				helper_d3f20302(45)
			end
			return 0
		end
		return nil
	end)
end

--- Helper function.
local function helper_22d90()
	local var0: s32 = 0
	local var1: s32 = 0
	var0 = event.GetQuestEtc(0, 8) or var0
	if var0 == 1 then
		var1 = event.GetCnt(12) or var1
		if 0 < var1 then
			if var1 == 1 then
				event.SetCnt(12, 2)
			end
			helper_a4226c93(0, vm.f32(-1.57))
			helper_125385ee(0, 1)
			event.MesMake_2(
				0,
				'C\'[UNI00e8] un biglietto:<page>"Il party di oggi [UNI00e8] annullato\nperch[UNI00e9] il formaggio non [UNI00e8] stagionato.\n                       Ferdinand"'
			)
			helper_a3cc6850(0, -1, 5, 256, 208)
			event.SetFuncEtc(1)
			vm.wait(3)
		end
	end
end

--- Event 530, which map data, a script or the engine runs by number.
local function event_530()
	event.FuncPointShow("p01_e01g01-0", "invent_36-0", 1)
	helper_a3a848ae()
	event.SetCameraPos(345.12, 84.74, -31.95)
	event.SetCameraRef(351.66, 70.52, 137.18)
	event.SetCharaPos(0, 350.13, 52.0, 148.02)
	event.SetCharaRot(0, 0.0, -3.12, 0.0)
	event.BgmPlayCancel()
	vm.wait(2)
	event.GotoInterior(-1, "i01h01", 500, 1)
	vm.wait(3)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Event 99, which map data, a script or the engine runs by number.
script.event_99 = helper_b8d9d9d0

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	local mc_load: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local flag_3: s32 = 0
	local flag_4: s32 = 0
	local flag_5: s32 = 0
	local var8: s32 = 0
	local old_map_no: s32 = 0
	local var11: s32 = 0
	local var12: s32 = 0
	local flag_6: s32 = 0
	local get_old_interior_map_no: s32 = 0
	helper_b8d9d9d0()
	mc_load = event.CheckMcLoad() or mc_load
	if mc_load == 1 then
		flag = event.GetFlag(736) or flag
		flag_2 = event.GetFlag(800) or flag_2
		if flag == 1 and flag_2 == 0 then
			event.SetFadeOut(0)
			helper_598da305()
			event.SetSavedataEtc(0, 10)
			event.SoundAllStop()
			event.SndInReverb(0)
			event.GotoDrawChapter(8)
			vm.wait(2)
			event.SndInReverb(1)
			event.LoadSound(1000)
			var3 = event.GetDefBgmNo(10) or var3
			event.LoadBgm(var3)
			event.PlayBgm(0)
			event.AutoChengeBgmVol(1)
			event.SetCharaPos(0, 1640.0, -48.8, -1700.0)
			event.SetCharaRot(0, 0.0, 0.0, 0.0)
			event.ResetCamera(1, 0.0, 10.0)
			event.SetFadeIn(30)
			return
		end
		var4 = event.GetCnt(4) or var4
		if var4 == 0 then
			event.SetCharaPos(0, 560.0, 4.1, 120.0)
			event.SetCharaRot(0, 0.0, 3.14, 0.0)
		end
		if var4 == 1 then
			event.SetCharaPos(0, 2095.0, 0.0, 2100.0)
			event.SetCharaRot(0, 0.0, 0.0, 0.0)
		end
		if var4 == 2 then
			event.SetCharaPos(0, -4260.0, 350.0, 2810.0)
			event.SetCharaRot(0, 0.0, 2.86, 0.0)
		end
		if var4 == 3 then
			event.SetCharaPos(0, -3770.0, 359.4, -1640.0)
			event.SetCharaRot(0, 0.0, 1.57, 0.0)
		end
		event.SetMotion(0, "立ち", 4)
		event.CharaNormalDrive(0)
		event.CharaResetDa(0)
		event.ResetCamera(1, 0.0, 20.0)
	else
		flag_3 = event.GetFlag(105) or flag_3
		flag_4 = event.GetFlag(109) or flag_4
		flag_5 = event.GetFlag(56) or flag_5
		if flag_3 ~= 0 and flag_4 == 0 and flag_5 == 0 then
			event.GetBgmNo() -- retail: argument 1 is a value where the handler writes an output; the output is discarded
			event.GetMasterVol()
			if var8 ~= 10 then
				event.SetFadeOut(0)
				event.LoadSound(1000)
				var8 = event.GetDefBgmNo(10) or var8
				event.StopBgm(0)
				helper_25abe6d2(4)
				event.LoadBgm(var8)
				event.PlayBgm(0)
				event.SetFlag(56, 1)
				event.AutoChengeBgmVol(1)
				event.SetFadeIn(30)
			end
		end
		old_map_no = event.GetOldMapNo() or old_map_no
		var11 = event.GetMapType(old_map_no) or var11
		if var11 ~= -1 then
			if var11 == 7 or var11 == 8 then
				helper_9dafbc83(vm.f32(-4197.9), 350.0, 2835.5, vm.f32(3.14))
				event.ResetCamera(1, 0.0, 10.0)
			else
				var12 = 1
				flag_6 = event.GetFlag(40) or flag_6
				if flag_6 == 1 then
					if old_map_no == 34 then
						var12 = 0
						event.SetCharaPos(0, 1645.1, -41.3, -1812.6)
						event.SetCharaRot(0, 0.0, -0.09, 0.0)
						event.ResetCamera(1)
					end
					if old_map_no == 22 then
						var12 = 0
						helper_6082cadd()
					end
				end
				get_old_interior_map_no = event.GetOldInteriorMapNo() or get_old_interior_map_no
				if 0 <= get_old_interior_map_no then
					var12 = 0
				elseif old_map_no == 121 then
					var12 = 0
					event.SetCharaPos(0, 1450.0, 0.0, 1420.0)
					event.SetCharaRot(0, 0.0, -1.57, 0.0)
					event.ResetCamera(1, 3.1415927)
				end
				if var12 ~= 0 then
					helper_e6998a9e()
				end
			end
		end
	end
	event.SetFlag(40, 0)
	event.SetFadeIn(30)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = helper_f9b4fb5f

--- Event 200, which map data, a script or the engine runs by number.
function script.event_200()
	local var0: s32 = 0
	var0 = event.GetSavedataEtc(0) or var0
	if var0 == 100 then
		event_248()
		event.SetFuncEtc(1)
		vm.wait(2)
		return
	end
	event.SetCharaRot(0, 0.0, 0.0, 0.0)
	vm.wait(3)
	event.GotoInterior(-1, "i01h01", 100, 1)
	vm.wait(4)
end

--- Event 201, which map data, a script or the engine runs by number.
function script.event_201()
	local at: number = 0
	return vm.guard(function()
		print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaa\n")
		at = 1
		if helper_4433c() ~= 0 then
			print("bbbbbbbbbbbbbbbbbbbbbbbbbbb\n")
			event.SetFadeOut(0)
			at = 2
			vm.wait(2)
			event.MapJump_2(-1, "s45")
			return
		end
		print("ccccccccccccccccccccccccccc\n")
		return
	end, function(received: { any })
		if at <= 2 then
			if at == 1 then
				local _ = received[1] :: number
			end
			if at <= 1 then
				print("bbbbbbbbbbbbbbbbbbbbbbbbbbb\n")
			end
			return 0
		end
		return nil
	end)
end

--- Event 204, which map data, a script or the engine runs by number.
function script.event_204()
	local var0: s32 = 0
	var0 = event.GetSavedataEtc(0) or var0
	if var0 == 100 then
		event_248()
		event.SetFuncEtc(1)
		vm.wait(2)
		return
	end
	event.MapJump_2(-1, "i02h01")
	vm.wait(3)
end

--- Event 210, which map data, a script or the engine runs by number.
function script.event_210()
	local var0: s32 = 0
	var0 = event.GetSavedataEtc(0) or var0
	if var0 == 100 then
		event_248()
		event.SetFuncEtc(1)
		vm.wait(2)
	end
end

--- Event 211, which map data, a script or the engine runs by number.
-- Defined empty, so the engine runs this instead of its default.
function script.event_211() end

--- Event 212, which map data, a script or the engine runs by number.
-- Defined empty, so the engine runs this instead of its default.
function script.event_212() end

--- Event 213, which map data, a script or the engine runs by number.
-- Defined empty, so the engine runs this instead of its default.
function script.event_213() end

--- Event 214, which map data, a script or the engine runs by number.
function script.event_214()
	local var0: s32 = 0
	var0 = event.GetSavedataEtc(0) or var0
	if var0 == 100 then
		event_248()
		event.SetFuncEtc(1)
		vm.wait(2)
	end
end

--- Event 215, which map data, a script or the engine runs by number.
function script.event_215()
	local var0: s32 = 0
	var0 = event.GetSavedataEtc(0) or var0
	if var0 == 100 then
		event_248()
		event.SetFuncEtc(1)
		vm.wait(2)
	end
end

--- Event 216, which map data, a script or the engine runs by number.
function script.event_216()
	local var0: s32 = 0
	var0 = event.GetSavedataEtc(0) or var0
	if var0 == 100 then
		event_248()
		event.SetFuncEtc(1)
		vm.wait(2)
	end
end

--- Event 217, which map data, a script or the engine runs by number.
-- Defined empty, so the engine runs this instead of its default.
function script.event_217() end

--- Event 218, which map data, a script or the engine runs by number.
function script.event_218()
	local var0: s32 = 0
	var0 = event.GetSavedataEtc(0) or var0
	if var0 == 100 then
		event_248()
		event.SetFuncEtc(1)
		vm.wait(2)
	end
end

--- Event 219, which map data, a script or the engine runs by number.
function script.event_219()
	local var0: s32 = 0
	var0 = event.GetSavedataEtc(0) or var0
	if var0 == 100 then
		event_248()
		event.SetFuncEtc(1)
		vm.wait(2)
	end
end

--- Event 220, which map data, a script or the engine runs by number.
function script.event_220()
	local var0: s32 = 0
	var0 = event.GetSavedataEtc(0) or var0
	if var0 == 100 then
		event_248()
		event.SetFuncEtc(1)
		vm.wait(2)
	end
end

--- Event 221, which map data, a script or the engine runs by number.
function script.event_221()
	local var0: s32 = 0
	var0 = event.GetSavedataEtc(0) or var0
	if var0 == 100 then
		event_248()
		event.SetFuncEtc(1)
		vm.wait(2)
	end
end

--- Event 222, which map data, a script or the engine runs by number.
function script.event_222()
	local var0: s32 = 0
	var0 = event.GetSavedataEtc(0) or var0
	if var0 == 100 then
		event_248()
		event.SetFuncEtc(1)
		vm.wait(2)
	else
		helper_22d90()
	end
end

--- Event 223, which map data, a script or the engine runs by number.
function script.event_223()
	local var0: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	var0 = event.GetSavedataEtc(0) or var0
	if var0 == 100 then
		event_248()
		event.SetFuncEtc(1)
		vm.wait(2)
	end
	flag = event.GetFlag(304) or flag
	flag_2 = event.GetFlag(305) or flag_2
	if flag == 1 and flag_2 == 0 then
		event.BgmLoadCancel()
	end
end

script.event_248 = event_248

--- Event 290, which map data, a script or the engine runs by number.
function script.event_290()
	local flag: s32 = 0
	local var3: s32 = 0
	flag = event.GetFlag(800) or flag
	if flag == 0 then
		return
	end
	if helper_d4692479() ~= 0 then
		event.DngSetStageId(6)
		event.GotoMenu(3, 6)
		vm.wait(2)
		do
			local _, _, out3, _ = event.GetMenuParam_4()
			var3 = out3 or var3
		end
		if var3 == 0 then
			event.SetFadeIn(30)
			return
		else
			if var3 == 37 then
				event.BgmLoadCancel()
			end
			event.GotoDng(6, var3, 1010)
		end
	end
end

--- Event 400, which map data, a script or the engine runs by number.
function script.event_400()
	local var0: s32 = 0
	var0 = event.GetEventData_2(15) or var0
	event.SetCnt(4, var0)
	helper_f57795f8()
end

--- Event 401, which map data, a script or the engine runs by number.
function script.event_401()
	local active_chr_no: s32 = 0
	local var1: s32 = 0
	event.SetMotion(0, "立ち")
	event.SetMesWindowMode(0, 1)
	event.SetMesShippo(0, 0)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	var1 = event.GetCnt(7) or var1
	if active_chr_no == 0 and var1 == 1 then
		event.SetCnt(7, 2)
		event.MesMake_2(0, "OK! Ora torna subito dallo\nSceriffo Blinkhorn.")
	else
		event.MesMake_2(0, "Se procedessi senza permesso,\nmi caccerei nei guai, vero?")
	end
	helper_a3cc6850(0, -1, 5, 256, 208)
	event.SetMesShippo(0, 1)
end

--- Event 510, which map data, a script or the engine runs by number.
function script.event_510()
	if helper_be79d02f() ~= 0 then
		event.MapJump_3(-1, "d01e01", 100)
	end
end

script.event_530 = event_530

--- Event 531, which map data, a script or the engine runs by number.
function script.event_531()
	local at: number = 0
	return vm.guard(function()
		event.SetFadeOut(0)
		event.SetCameraPos(345.12, 84.74, -31.95)
		event.SetCameraRef(351.66, 70.52, 137.18)
		event.SetCharaPos(0, 350.13, 52.0, 148.02)
		event.SetCharaRot(0, 0.0, -3.12, 0.0)
		print("ぞうにまけた---------------------\n")
		at = 1
		vm.wait(1)
		event.GotoInterior(-1, "i01h01", 510, 1)
		at = 2
		vm.wait(2)
		print("じゃんぷ------------------\n")
		return
	end, function(received: { any })
		if at <= 2 then
			print("じゃんぷ------------------\n")
			return 0
		end
		return nil
	end)
end

--- Event 540, which map data, a script or the engine runs by number.
function script.event_540()
	helper_a981053a()
	event.CancelLoadVillager()
	event.BgmLoadCancel()
	event.MapJump_3(-1, "i03h01a", 500)
	vm.wait(2)
end

--- Event 550, which map data, a script or the engine runs by number.
function script.event_550()
	local var0: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	var0 = event.GetSavedataEtc(0) or var0
	if var0 == 100 then
		return
	end
	event.SetCameraPos(1300.0, 50.0, 763.0)
	event.SetCameraRef(1300.0, 30.0, 968.18)
	event.SetMotion(0, "立ち")
	var1 = event.SearchCharaNo(50) or var1
	var2 = vm.i32(var1 + 1)
	event.SetAi(0, var2)
	event.SetAi(0, var1)
	event.MesMake_2(0, "Ehi! Non [UNI00e8] permesso\noltrepassare questo punto.")
	helper_899661d6(var1, -1, 0, 0)
	event.MesMake_2(0, "Per il tuo bene, faresti meglio\na tornartene indietro!")
	helper_899661d6(var2, -1, 0, 0)
	event.SetFadeOut(20)
	helper_25abe6d2(20)
	event.SetCharaPos(0, 1302, 0, 951)
	event.SetCharaRot(0, 0, 3.14, 0)
	event.SetAi(1, var2)
	event.SetAi(1, var1)
	event.SetFadeIn(20)
end

--- Event 560, which map data, a script or the engine runs by number.
script.event_560 = helper_b8d9d9d0

--- Event 1000, which map data, a script or the engine runs by number.
function script.event_1000()
	local var0: s32 = 0
	var0 = event.GetSavedataEtc(0) or var0
	if var0 == 100 then
		return
	end
	helper_03ef7038()
end

--- Event 11051, which map data, a script or the engine runs by number.
script.event_11051 = event_530

--- Event 11052, which map data, a script or the engine runs by number.
function script.event_11052()
	event.SetFlag(105, 0)
	event.SetSavedataEtc(0, 3)
	vm.wait(1)
	event.GotoInterior(-1, "i01h01", 11052, 1)
	vm.wait(2)
end

--- Event 11053, which map data, a script or the engine runs by number.
function script.event_11053()
	event.SetFlag(105, 0)
	event.SetSavedataEtc(0, 3)
	vm.wait(1)
	event.GotoInterior(-1, "i01h01", 11053, 1)
	vm.wait(2)
end

--- Event 11060, which map data, a script or the engine runs by number.
function script.event_11060()
	event.SetFlag(103, 1)
	event.SetFlag(106, 0)
	event.SetFlag(107, 0)
	event.SetSavedataEtc(0, 3)
	vm.wait(1)
	event.GotoInterior(-1, "i01h01", 11060, 1)
	vm.wait(2)
end

--- Event 11091, which map data, a script or the engine runs by number.
function script.event_11091()
	helper_a981053a()
	event.CancelLoadVillager()
	vm.wait(2)
	event.MapJump_3(-1, "i03h01a", 500)
	vm.wait(3)
end

--- Event 18000, which map data, a script or the engine runs by number.
function script.event_18000()
	helper_598da305()
	event.SetSavedataEtc(0, 10)
	event.SoundAllStop()
	event.SndInReverb(0)
	event.GotoDrawChapter(8)
	vm.wait(2)
	event.SndInReverb(1)
	event.LoadBgm(0)
	event.LoadSound(1000)
	event.PlayBgm(0)
	event.SetCharaPos(0, 1640.0, -48.8, -1700.0)
	event.SetCharaRot(0, 0.0, 0.0, 0.0)
	event.ResetCamera(1, 0.0, 10.0)
	event.SetFadeIn(30)
end

return script
