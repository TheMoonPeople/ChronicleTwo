--!strict
-- map/s/s23/s23.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_02bfaf68 = require("@lib/event/helper_02bfaf68")
local helper_0eb5b2c8 = require("@lib/event/helper_0eb5b2c8")
local helper_774ccd87 = require("@lib/event/helper_774ccd87")
local helper_79cab23e = require("@lib/event/helper_79cab23e")
local helper_e42033a8 = require("@lib/event/helper_e42033a8")
local helper_e64ec5fa = require("@lib/event/helper_e64ec5fa")

--- Program 99.
local function program_99()
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
local function helper_10724()
	local active_chr_no: s32 = 0
	local var1: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_e64ec5fa(0, 21, 5, 256, 208)
			end
			return 0
		end
		if at <= 3 then
			helper_774ccd87(30)
		end
		return 1
	end
	event.Initialize()
	event.SetMotion(0, "立ち")
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 2 or active_chr_no == 3 then
		event.SetMesWindowMode(0, 1)
		event.SetMesDrawspeed(0, 1)
		if active_chr_no == 2 then
			helper_e64ec5fa(0, 20, 5, 256, 208)
			if vm.skipping() then
				return skip(1)
			end
		else
			helper_e64ec5fa(0, 21, 5, 256, 208)
			if vm.skipping() then
				return skip(2)
			end
		end
		event.Finish()
		return 0
	end
	var1 = helper_02bfaf68(2, -1)
	if vm.skipping() then
		return skip(3)
	end
	if var1 == 0 then
		event.SetFadeOut(30)
		helper_774ccd87(30)
		if vm.skipping() then
			return skip(4)
		end
		event.Finish()
		return 1
	end
	event.Finish()
	return 0
end

--- Helper function.
local function helper_10b98()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_0eb5b2c8()
		end
		if at <= 2 then
			helper_e42033a8(7120010)
		end
		if at <= 3 then
			helper_e42033a8(7120015)
		end
	end
	event.SetFlag(712, 1)
	event.SetMotion(0, "立ち")
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.AssignStack(5)
	event.ClearStack(5)
	event.ChangeDir("event/e700/e712/")
	event.SetLoadbgFile("e712.txt")
	if vm.wait() then
		return skip(1)
	end
	helper_0eb5b2c8()
	if vm.skipping() then
		return skip(2)
	end
	event.LoadMes(0, 5, "e712.txt")
	event.ChangeDir("")
	helper_e42033a8(7120010)
	if vm.skipping() then
		return skip(3)
	end
	helper_e42033a8(7120015)
	if vm.skipping() then
		return skip(4)
	end
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
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			helper_0eb5b2c8()
		end
		if at <= 3 then
			var1 = 0
			helper_e42033a8(7120020)
		end
		if at <= 4 then
			helper_774ccd87(10)
		end
		if at <= 6 then
			helper_774ccd87(10)
		end
		if at <= 7 then
			helper_e42033a8(7120040)
		end
		if at <= 8 then
			var3 = vm.f32(var3 - vm.f32(3.1415927))
			var4 = 0
			var4 = var4 + 1
		end
		if at <= 9 then
			helper_774ccd87(60)
		end
		if at <= 10 then
			var1 = 1
			helper_e42033a8(7120030)
		end
		if at <= 11 then
			var1 = 0
			helper_774ccd87(30)
		end
		return var1
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFlag(712, 1)
	event.SetMotion(0, "立ち")
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.AssignStack(5)
	event.ClearStack(5)
	event.SetLoadbgFile("event/e700/e712/e712.txt", "snd2/event/ev_130_125.sound.json")
	if vm.wait() then
		return skip(2)
	end
	helper_0eb5b2c8()
	if vm.skipping() then
		return skip(3)
	end
	event.LoadMes(0, 5, "event/e700/e712/e712.txt")
	var0 = event.SndLoadSound(4, "snd2/event/ev_130_125.sound.json") or var0
	var1 = 0
	helper_e42033a8(7120020)
	if vm.skipping() then
		return skip(4)
	end
	event.SetFadeOut(10)
	helper_774ccd87(10)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMenuEtc(0, "わが主の真の名を告げよ。", "サン", 0)
	event.GotoMenu(5)
	if vm.wait() then
		return skip(6)
	end
	event.SetFadeIn(10)
	helper_774ccd87(10)
	if vm.skipping() then
		return skip(7)
	end
	result_x = event.GetMenuParam_1() or result_x
	if result_x == 1 then
		event.SetFlag(58, 1)
		helper_e42033a8(7120040)
		if vm.skipping() then
			return skip(8)
		end
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
			if vm.wait() then
				return skip(9)
			end
		end
		event.ResetCamera(0)
		helper_774ccd87(60)
		if vm.skipping() then
			return skip(10)
		end
		var1 = 1
	else
		helper_e42033a8(7120030)
		if vm.skipping() then
			return skip(11)
		end
		var1 = 0
		event.SetFadeOut(30, 255, 255, 255)
		helper_774ccd87(30)
		if vm.skipping() then
			return skip(12)
		end
	end
	event.LoadMes(0, -1)
	event.Finish()
	return var1
end

--- Helper function.
local function helper_102bc()
	local active_chr_no: s32 = 0
	local var1: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_e64ec5fa(0, 21, 5, 256, 208)
			end
			return 0
		end
		if at <= 3 then
			helper_774ccd87(30)
		end
		return 1
	end
	event.Initialize()
	event.SetMotion(0, "立ち")
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 2 or active_chr_no == 3 then
		event.SetMesWindowMode(0, 1)
		event.SetMesDrawspeed(0, 1)
		if active_chr_no == 2 then
			helper_e64ec5fa(0, 20, 5, 256, 208)
			if vm.skipping() then
				return skip(1)
			end
		else
			helper_e64ec5fa(0, 21, 5, 256, 208)
			if vm.skipping() then
				return skip(2)
			end
		end
		event.Finish()
		return 0
	end
	var1 = helper_02bfaf68(5, 124)
	if vm.skipping() then
		return skip(3)
	end
	if var1 == 0 then
		event.SetFadeOut(30)
		helper_774ccd87(30)
		if vm.skipping() then
			return skip(4)
		end
		event.Finish()
		return 1
	end
	event.Finish()
	return 0
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

script[99] = program_99

--- Program 100.
script[100] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	program_99()
	event.SetCharaPos(0, 0.0, 0.0, 170.0)
	event.SetCharaRot(0, 0.0, 3.14, 0.0)
	event.SetCameraRef(0.0, 30.0, 170.0)
	event.SetCameraPos(0.0, 40.0, 270.0)
	event.ResetCamera(0)
	event.SetFadeIn(30)
	if vm.wait() then
		return skip(1)
	end
	event.Finish()
end

--- Program 150.
-- Defined empty, so the engine runs this instead of its default.
script[150] = function() end

--- Program 200.
script[200] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	local t0 = helper_10724()
	if vm.skipping() then
		return skip(1)
	end
	if t0 ~= 0 then
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

--- Program 500.
script[500] = function()
	local flag: s32 = 0
	local flag_2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				local _ = if helper_10e7c() == 0 then 1 else 0
			end
			return
		end
	end
	flag = event.GetFlag(58) or flag
	if flag == 0 then
		flag_2 = event.GetFlag(748) or flag_2
		if flag_2 == 0 then
			helper_10b98()
			if vm.skipping() then
				return skip(1)
			end
		else
			local t0 = if helper_10e7c() == 0 then 1 else 0
			if vm.skipping() then
				return skip(2)
			end
			if t0 ~= 0 then
				event.GotoEdit(109, 100)
				return
			end
		end
	else
		local t1 = helper_102bc()
		if vm.skipping() then
			return skip(3)
		end
		if t1 ~= 0 then
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
end

--- Program 1200.
script[1200] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_79cab23e(0)
	if vm.skipping() then
		return skip(1)
	end
end

return script
