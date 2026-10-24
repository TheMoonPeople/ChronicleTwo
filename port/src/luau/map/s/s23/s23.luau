--!strict
-- map/s/s23/s23.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_038a2e4d = require("@lib/event/helper_038a2e4d")
local helper_24f0f8dd = require("@lib/event/helper_24f0f8dd")
local helper_344d6cd8 = require("@lib/event/helper_344d6cd8")
local helper_479dc9e9 = require("@lib/event/helper_479dc9e9")
local helper_59f899fe = require("@lib/event/helper_59f899fe")
local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")
local helper_8cd371d7 = require("@lib/event/helper_8cd371d7")
local helper_94a172bf = require("@lib/event/helper_94a172bf")
local helper_9e7d1511 = require("@lib/event/helper_9e7d1511")
local helper_e34416e2 = require("@lib/event/helper_e34416e2")
local helper_ee1c51d0 = require("@lib/event/helper_ee1c51d0")

--- Event 99, which map data, a script or the engine runs by number.
local function event_99()
	local var0: s32 = 0
	local flag: s32 = 0
	event.StopBgm(0)
	event.LoadSound(7685)
	var0 = event.GetSavedataEtc(0) or var0
	if var0 < 10 then
		flag = event.GetFlag(58) or flag
		if flag == 1 then
			event.FuncPointShow("way200", "door01", 1)
			event.FuncPointShow("way200", "door02", 1)
		end
	else
		event.FuncPointShow("", "e712", 0)
	end
	event.DngPause(8192, 1)
	event.SetCharaChangeMask(2, 0)
	event.SetCharaChangeMask(3, 0)
	event.SetCharaShow(1, 0)
	event.SetCharaShow(2, 0)
	event.SetBitCtrl(1, 1)
end

--- Helper function.
local function helper_10b98()
	event.SetFlag(712, 1)
	event.SetMotion(0, "立ち")
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.AssignStack(5)
	event.ClearStack(5)
	event.ChangeDir("event/e700/e712/")
	event.SetLoadbgFile_1("e712.txt")
	vm.wait(1)
	helper_479dc9e9()
	event.LoadMes(0, 5, "e712.txt")
	event.ChangeDir("")
	helper_e34416e2(7120010)
	helper_e34416e2(7120015)
	event.LoadMes(0, -1)
	event.Finish()
end

--- Helper function.
local function helper_10e7c()
	local var0: s32 = 0
	local var1: s32 = 0
	local result_x: s32 = 0
	local var3: f32 = 0
	local var4: s32 = 0
	local at: number = 0
	return vm.guard(function()
		event.SetFlag(712, 1)
		event.SetMotion(0, "立ち")
		event.Initialize()
		event.SetMesWindowMode(0, 7)
		event.AssignStack(5)
		event.ClearStack(5)
		event.SetLoadbgFile_2("event/e700/e712/e712.txt", "snd2/event/ev_130_125.sound.json")
		at = 1
		vm.wait(1)
		at = 2
		helper_479dc9e9()
		event.LoadMes(0, 5, "event/e700/e712/e712.txt")
		var0 = event.SndLoadSound_3(4, "snd2/event/ev_130_125.sound.json") or var0
		var1 = 0
		at = 3
		helper_e34416e2(7120020)
		event.SetFadeOut(10)
		at = 4
		helper_888ab2a3(10)
		event.SetMenuEtc(0, "わが主の真の名を告げよ。", "サン", 0)
		event.GotoMenu(5)
		at = 5
		vm.wait(5)
		event.SetFadeIn(10)
		at = 6
		helper_888ab2a3(10)
		result_x = event.GetMenuParam_1() or result_x
		if result_x == 1 then
			event.SetFlag(58, 1)
			at = 7
			helper_e34416e2(7120040)
			event.FuncPointShow("way200", "door01", 1)
			event.FuncPointShow("way200", "door02", 1)
			event.SndSePlay(var0, 0)
			var3 = vm.bits_float(event.GetEventData_2(11)) or var3
			var3 = vm.f32(var3 - vm.f32(3.1415927))
			var3 = event.AngleLimit(var3) or var3
			var4 = 0
			while var4 < 30 do
				event.CtrlcRotBack(var3)
				event.CtrlcMoveCamera(0)
				event.CtrlcStep()
				var4 = var4 + 1
				at = 8
				vm.wait(8)
			end
			event.ResetCamera(0)
			at = 9
			helper_888ab2a3(60)
			var1 = 1
		else
			at = 10
			helper_e34416e2(7120030)
			var1 = 0
			event.SetFadeOut(30, 255, 255, 255)
			at = 11
			helper_888ab2a3(30)
		end
		event.LoadMes(0, -1)
		event.Finish()
		return var1
	end, function(received: { any })
		if at <= 11 then
			if at <= 1 then
				helper_344d6cd8()
			end
			if at <= 2 then
				var1 = 0
				helper_8cd371d7(7120020)
			end
			if at <= 3 then
				helper_038a2e4d(10)
			end
			if at <= 5 then
				helper_038a2e4d(10)
			end
			if at <= 6 then
				helper_8cd371d7(7120040)
			end
			if at <= 7 then
				var3 = vm.f32(var3 - vm.f32(3.1415927))
				var4 = 0
				local _ = var4 < 30
				var4 = var4 + 1
			end
			if at <= 8 then
				helper_038a2e4d(60)
			end
			if at <= 9 then
				var1 = 1
				helper_8cd371d7(7120030)
			end
			if at <= 10 then
				var1 = 0
				helper_038a2e4d(30)
			end
			return var1
		end
		return nil
	end)
end

--- Helper function.
local function helper_102bc()
	local active_chr_no: s32 = 0
	local var1: any = 0
	local at: number = 0
	return vm.guard(function()
		event.Initialize()
		event.SetMotion(0, "立ち")
		active_chr_no = event.GetActiveChrNo() or active_chr_no
		if active_chr_no == 2 or active_chr_no == 3 then
			event.SetMesWindowMode(0, 1)
			event.SetMesDrawspeed(0, 1)
			if active_chr_no == 2 then
				at = 1
				helper_9e7d1511(0, 20, 5, 256, 208)
			else
				at = 2
				helper_9e7d1511(0, 21, 5, 256, 208)
			end
			event.Finish()
			return 0
		end
		at = 3
		var1 = helper_94a172bf(5, 124)
		if var1 == 0 then
			event.SetFadeOut(30)
			at = 4
			helper_888ab2a3(30)
			event.Finish()
			return 1
		end
		event.Finish()
		return 0
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				helper_ee1c51d0(0, 21, 5, 256, 208)
			end
			return 0
		end
		if at <= 4 then
			if at == 3 then
				var1 = received[1] :: number
			end
			if at <= 3 then
				helper_038a2e4d(30)
			end
			return 1
		end
		return nil
	end)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

script.event_99 = event_99

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	event_99()
	event.SetCharaPos(0, 0.0, 0.0, 170.0)
	event.SetCharaRot(0, 0.0, 3.14, 0.0)
	event.SetCameraRef(0.0, 30.0, 170.0)
	event.SetCameraPos(0.0, 40.0, 270.0)
	event.ResetCamera(0)
	event.SetFadeIn(30)
	vm.wait(1)
	event.Finish()
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
-- Defined empty, so the engine runs this instead of its default.
function script.key_open() end

--- Event 200, which map data, a script or the engine runs by number.
function script.event_200()
	if helper_24f0f8dd() ~= 0 then
		event.SetCharaShow(1, 1)
		event.SetCharaShow(2, 1)
		event.DngPause(8192, 0)
		event.ActchrSetDefMotion(0)
		event.SetCharaChangeMask(2, 1)
		event.SetCharaChangeMask(3, 1)
		event.SetBitCtrl(1, 0)
		event.LoadScript("d06/d06.stb", 1000)
	end
end

--- Event 500, which map data, a script or the engine runs by number.
function script.event_500()
	local flag: s32 = 0
	local flag_2: s32 = 0
	flag = event.GetFlag(58) or flag
	if flag == 0 then
		flag_2 = event.GetFlag(748) or flag_2
		if flag_2 == 0 then
			helper_10b98()
		elseif helper_10e7c() == 0 then
			event.GotoEdit(109, 100)
			return
		end
	elseif helper_102bc() ~= 0 then
		event.SetCharaShow(1, 1)
		event.SetCharaShow(2, 1)
		event.DngPause(8192, 0)
		event.ActchrSetDefMotion(0)
		event.SetCharaChangeMask(2, 1)
		event.SetCharaChangeMask(3, 1)
		event.SetBitCtrl(1, 0)
		event.LoadDungeonMapFile("d06b01")
		event.LoadScript("d06b01/d06b01.stb", 100)
	end
end

--- Event 1200, which map data, a script or the engine runs by number.
function script.event_1200()
	helper_59f899fe(0)
end

return script
