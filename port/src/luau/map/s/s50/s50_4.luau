--!strict
-- map/s/s50/s50_4.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_22b209a0 = require("@lib/event/helper_22b209a0")
local helper_3824b98c = require("@lib/event/helper_3824b98c")
local helper_3e77b5b1 = require("@lib/event/helper_3e77b5b1")
local helper_3e9a1b70 = require("@lib/event/helper_3e9a1b70")
local helper_a8b5d854 = require("@lib/event/helper_a8b5d854")
local helper_b5303866 = require("@lib/event/helper_b5303866")
local helper_c0b038f8 = require("@lib/event/helper_c0b038f8")
local helper_e1d7eb5a = require("@lib/event/helper_e1d7eb5a")
local helper_e5cc9544 = require("@lib/event/helper_e5cc9544")

--- Program 99.
local function program_99()
	local flag: s32 = 0
	event.StopBgm(0)
	event.LoadSound(7686)
	flag = event.GetFlag(708) or flag
	if flag == 1 then
		event.FuncPointShow("", "e708", 0)
		event.EohSyncObj(0, "p06s50")
		event.EohSetShow(0, 1)
		event.EohSyncObj(0, "p04s50")
		event.EohSetRot(0, 0.0, -1.22, 0.0)
		event.EohSyncObj(1, "p05s50")
		event.EohSetRot(1, 0.0, 1.22, 0.0)
	end
	event.DngPause(8192, 1)
	event.SetCharaChangeMask(2, 0)
	event.SetCharaChangeMask(3, 0)
	event.SetBitCtrl(1, 1)
	event.SetCharaShow(1, 0)
	event.SetCharaShow(2, 0)
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 0.
script[0] = function()
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMotion(0, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.SetMesDrawspeed(0, 1)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		event.MesMake_2(
			0,
			"-- Max a caccia di Idee --\nDa ci[UNI00f2] che legge, Max intuisce che\npotrebbe inventare qualcosa con: \n  ●un'arma\n  ●una Colonna lunare\n  ●corna di daino"
		)
	else
		event.MesMake_2(
			0,
			"-- Monica a caccia di Mostri --\nDa quanto scritto,\nMonica scopre che i Quadri\nha un debole per i diamanti"
		)
	end
	helper_3e77b5b1(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

script[99] = program_99

--- Program 100.
script[100] = function()
	program_99()
	helper_e1d7eb5a(0.0, 0.0, 200.0, vm.f32(3.14))
	event.SetCameraRef(0.0, 30.0, 200.0)
	event.SetCameraPos(0.0, 40.0, 320.0)
	event.ResetCamera(0)
	event.SetFadeIn(30)
	event.Finish()
end

--- Program 150.
script[150] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	event.CmrsInit()
	event.CmrsQuake(0.0, 1.0, 0.0, 16)
	helper_3824b98c()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 200.
script[200] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	local t0 = helper_c0b038f8(2)
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

--- Program 210.
script[210] = function()
	local flag: s32 = 0
	local stage_id: s32 = 0
	local var2: s32 = 0
	local argc: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_3e77b5b1(0, -1, 5, 0, 0)
		end
	end
	flag = event.GetFlag(708) or flag
	if flag == 1 then
		local t0 = helper_c0b038f8(1)
		if vm.skipping() then
			return skip(1)
		end
		if t0 ~= 0 then
			stage_id = event.DngGetStageId() or stage_id
			var2 = event.DngGetFloorId() or var2
			argc = event.GetNextFloor(var2, 0) or argc
			event.DngSetFloorId(argc)
			event.SetFloorInfo(stage_id, var2, 5, 2)
			event.SetFloorInfo(stage_id, argc, 5, 1)
			event.SetCharaShow(1, 1)
			event.SetCharaShow(2, 1)
			event.DngPause(8192, 0)
			event.ActchrSetDefMotion(0)
			event.SetCharaChangeMask(2, 1)
			event.SetCharaChangeMask(3, 1)
			event.SetBitCtrl(1, 0)
			event.LoadScript("d06/d06.stb", 1000)
		end
	else
		event.SetMesWindowMode(0, 1)
		event.SetMesShippo(0, 0)
		event.SetMotion(0, "立ち")
		event.MesMake_2(
			0,
			"La porta [UNI00e8] chiusa ermeticamente.\nChe si nasconda qualche segreto\nin questa stanza?"
		)
		helper_3e77b5b1(0, -1, 5, 0, 0)
		if vm.skipping() then
			return skip(2)
		end
	end
end

--- Program 500.
script[500] = function()
	local active_chr_no: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	local landing1: () -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_3e77b5b1(0, 23, 5, 256, 208)
			end
			return
		end
		if at <= 10 then
			if at <= 3 then
				var1 = 2
			end
			if at <= 4 then
				helper_a8b5d854(3)
			end
			if at <= 5 then
				helper_a8b5d854(10)
			end
			if at <= 6 then
				helper_a8b5d854(3)
			end
			if at <= 7 then
				helper_a8b5d854(20)
			end
			if at <= 8 then
				helper_a8b5d854(30)
			end
			if at <= 9 then
				helper_22b209a0()
				if not vm.skipping() then
					return landing1()
				end
			end
			helper_e1d7eb5a(30.0, vm.f32(-2.8), -80.0, vm.f32(3.14))
			return
		end
	end
	function part2() end
	function landing1()
		helper_e1d7eb5a(30.0, vm.f32(-2.8), -80.0, vm.f32(3.14))
		event.SetCameraRef(30.0, 27.2, -80.0)
		event.SetCameraPos(30.0, 37.2, 40.0)
		event.ResetCamera(0)
		event.SetFadeIn(10)
		event.Finish()
	end
	event.Initialize()
	event.SetMotion(0, "立ち")
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 2 or active_chr_no == 3 then
		event.SetMesWindowMode(0, 1)
		event.SetMesDrawspeed(0, 1)
		if active_chr_no == 2 then
			helper_3e77b5b1(0, 22, 5, 256, 208)
			if vm.skipping() then
				return skip(1)
			end
		else
			helper_3e77b5b1(0, 23, 5, 256, 208)
			if vm.skipping() then
				return skip(2)
			end
		end
		event.Finish()
		return
	end
	var1 = event.GetEventData_2(6) or var1
	if var1 == 1 then
		event.SetMesWindowMode(0, 1)
		event.SetMesShippo(0, 0)
		event.MesMake_2(0, "C'[UNI00e8] uno strano vaso di fiori.\n(Premi (#) per accedere al Menu)")
		var3 = helper_3e9a1b70(0, -1, 5, 256, 208, var3)
		if vm.skipping() then
			return skip(3)
		end
		if var3 == 1 then
			var1 = 2
		end
	end
	if var1 == 2 then
		event.GotoUseItem(374)
		do
			local skipped = vm.wait()
			var2 = event.DeferredOutput() or var2
			if skipped then
				return skip(4)
			end
		end
		if var2 > 0 then
			if var2 == 374 then
				event.SetStatusbarShow(0, 1.0)
				event.EohSyncObj(0, "p06s50")
				event.EohSetShow(0, 1)
				event.FuncPointShow("", "e708", 0)
				event.FuncPointShow("", "next_floor", 1)
				event.SetFadeOut(3, 255, 255, 255)
				helper_a8b5d854(3)
				if vm.skipping() then
					return skip(5)
				end
				event.SetFadeIn(8)
				helper_a8b5d854(10)
				if vm.skipping() then
					return skip(6)
				end
				event.SetFadeOut(3, 255, 255, 255)
				helper_a8b5d854(3)
				if vm.skipping() then
					return skip(7)
				end
				event.SetFadeIn(8)
				helper_a8b5d854(20)
				if vm.skipping() then
					return skip(8)
				end
				event.SetFadeOut(30, 255, 255, 255)
				helper_a8b5d854(30)
				if vm.skipping() then
					return skip(9)
				end
				helper_22b209a0()
				if vm.skipping() then
					return skip(10)
				end
				helper_e1d7eb5a(30.0, vm.f32(-2.8), -80.0, vm.f32(3.14))
				event.SetCameraRef(30.0, 27.2, -80.0)
				event.SetCameraPos(30.0, 37.2, 40.0)
				event.ResetCamera(0)
				event.SetFadeIn(10)
				event.Finish()
				return
			else
				helper_e5cc9544()
				if vm.skipping() then
					return skip(11)
				end
			end
		end
	end
	return part2()
end

--- Program 1200.
script[1200] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_b5303866(0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 17080.
script[17080] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetCharaShow(1, 0)
	event.SetCharaShow(2, 0)
	event.SetStatusbarShow(0, 1.0)
	helper_22b209a0()
	if vm.skipping() then
		return skip(1)
	end
end

return script
