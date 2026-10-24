--!strict
-- map/d/d05/b01/d05b01_2.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_00eed993 = require("@lib/event/helper_00eed993")
local helper_33122428 = require("@lib/event/helper_33122428")
local helper_3d4d193d = require("@lib/event/helper_3d4d193d")
local helper_405042f0 = require("@lib/event/helper_405042f0")
local helper_435eb125 = require("@lib/event/helper_435eb125")
local helper_4484af04 = require("@lib/event/helper_4484af04")
local helper_472a898f = require("@lib/event/helper_472a898f")
local helper_4c3a889a = require("@lib/event/helper_4c3a889a")
local helper_53843df7 = require("@lib/event/helper_53843df7")
local helper_56b42349 = require("@lib/event/helper_56b42349")
local helper_58fba236 = require("@lib/event/helper_58fba236")
local helper_b5372207 = require("@lib/event/helper_b5372207")
local helper_bc4bfd47 = require("@lib/event/helper_bc4bfd47")
local helper_c85a55f2 = require("@lib/event/helper_c85a55f2")
local helper_d8ef09af = require("@lib/event/helper_d8ef09af")

--- Program 99.
local function program_99()
	local flag: s32 = 0
	local flag_2: s32 = 0
	event.StopBgm(0)
	event.LoadSound(5683)
	flag = event.GetFlag(526) or flag
	if flag == 1 then
		event.FuncPointShow("d05", "func", 0)
		event.EohSyncObj(0, "d05", "d05ba02-a")
		event.EohSetShow(0, 0)
		event.EohSyncObj(0, "d05", "d05b01_1", "takil")
		event.EohSetScale(0, 0.43, 1.0, 1.0)
		event.EohSyncObj(0, "d05", "d05b01_1", "takir")
		event.EohSetScale(0, 0.43, 1.0, 1.0)
		event.FuncPointShow("p01", "invent_2023-1", 1)
	end
	flag_2 = event.GetFlag(528) or flag_2
	if flag_2 == 0 then
		event.EohSyncObj(0, "d05", "d05ba03-a")
		event.EohSetShow(0, 1)
	else
		event.FuncPointShow("", "e528", 0)
	end
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

script[99] = program_99

--- Program 100.
script[100] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		helper_4484af04(0.0, -30.0, 1600.0, vm.f32(3.14))
	end
	event.Initialize()
	event.SetFadeOut(0)
	program_99()
	event.CheckMcLoad()
	if vm.wait() then
		return skip(1)
	end
	helper_4484af04(0.0, -30.0, 1600.0, vm.f32(3.14))
	event.SetCameraRef(0.0, 0.0, 1600.0)
	event.SetCameraPos(0.0, 10.0, 1700.0)
	event.ResetCamera(0)
	event.SetFadeIn(15)
	event.Finish()
end

--- Program 150.
script[150] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_472a898f()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 200.
script[200] = function()
	local active_chr_no: s32 = 0
	local var1: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_bc4bfd47(0, 21, 5, 256, 208)
			end
			return
		end
		if at <= 3 then
			helper_c85a55f2(15)
		end
	end
	event.Initialize()
	event.ActchrSetDefMotion(0)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 2 or active_chr_no == 3 then
		event.SetMesWindowMode(0, 1)
		event.SetMesDrawspeed(0, 1)
		if active_chr_no == 2 then
			helper_bc4bfd47(0, 20, 5, 256, 208)
			if vm.skipping() then
				return skip(1)
			end
		else
			helper_bc4bfd47(0, 21, 5, 256, 208)
			if vm.skipping() then
				return skip(2)
			end
		end
		event.Finish()
		return
	end
	var1 = helper_58fba236(2, -1)
	if vm.skipping() then
		return skip(3)
	end
	if var1 == 0 then
		event.SetFadeOut(15)
		helper_c85a55f2(15)
		if vm.skipping() then
			return skip(4)
		end
		event.LoadScript("d05/d05.stb", 1000)
	end
	event.Finish()
end

--- Program 400.
script[400] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_3d4d193d()
	if vm.skipping() then
		return skip(1)
	end
	event.Finish()
end

--- Program 500.
script[500] = function()
	local active_chr_no: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_bc4bfd47(0, 23, 8, 0, 0)
			end
			return
		end
		if at <= 6 then
			if at <= 3 then
				var1 = 2
				helper_c85a55f2(6)
			end
			if at <= 5 then
				helper_33122428()
			end
			return
		end
		if at <= 7 then
			helper_c85a55f2(6)
		end
	end
	event.Initialize()
	event.ActchrSetDefMotion(0)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 2 or active_chr_no == 3 then
		event.SetMesPreset(0, 4)
		event.SetMesWindowMode(0, 4)
		event.SetMesDrawspeed(0, 1)
		if active_chr_no == 2 then
			helper_bc4bfd47(0, 22, 8, 0, 0)
			if vm.skipping() then
				return skip(1)
			end
		else
			helper_bc4bfd47(0, 23, 8, 0, 0)
			if vm.skipping() then
				return skip(2)
			end
		end
		event.SetMesWindowMode(0, 1)
		event.SetMesDrawspeed(0, 0)
		event.Finish()
		return
	end
	var1 = event.GetEventData_2(6) or var1
	if var1 == 1 then
		event.Initialize()
		event.SetMesWindowMode(0, 1)
		event.SetMesDrawspeed(0, 1)
		var2 = helper_53843df7(0, 2507, 5, 256, 208, var2)
		if vm.skipping() then
			return skip(3)
		end
		event.SetMesWindowMode(0, 7)
		event.SetMesDrawspeed(0, 0)
		if var2 == 1 then
			var1 = 2
		end
	end
	if var1 == 2 then
		event.SetStatusbarShow(0, 0.16666667)
		helper_c85a55f2(6)
		if vm.skipping() then
			return skip(4)
		end
		event.GotoUseItem(354)
		do
			local skipped = vm.wait()
			var3 = event.DeferredOutput() or var3
			if skipped then
				return skip(5)
			end
		end
		if var3 == 354 then
			event.FuncPointShow("d05", "func", 0)
			event.EohSyncObj(0, "d05", "d05ba02-a")
			event.EohSetShow(0, 0)
			event.FuncPointShow("p01", "invent_2023-1", 1)
			helper_33122428()
			if vm.skipping() then
				return skip(6)
			end
			return
		elseif var3 <= 0 then
			event.Finish()
		else
			helper_b5372207()
			if vm.skipping() then
				return skip(7)
			end
		end
		event.SetStatusbarShow(1, 0.16666667)
		helper_c85a55f2(6)
		if vm.skipping() then
			return skip(8)
		end
	end
	event.Finish()
end

--- Program 550.
script[550] = function()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_405042f0()
			if not vm.skipping() then
				return part2()
			end
		end
		helper_4484af04(0.0, 0.0, 300.0, vm.f32(3.14))
	end
	function part2()
		if vm.wait() then
			return skip(3)
		end
		event.LoadMonsterFile(512, 1)
		event.AutoSetMonster(512, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
		helper_4484af04(0.0, 0.0, 300.0, vm.f32(3.14))
		event.SetCameraRef(0.0, 30.0, 300.0)
		event.SetCameraPos(0.0, 40.0, 400.0)
		event.ResetCamera(0)
		event.SetFadeIn(15)
		event.Finish()
	end
	event.Initialize()
	event.ActchrSetDefMotion(0)
	event.SetBitCtrl(1, 1)
	event.SetFadeOut(15)
	helper_c85a55f2(15)
	if vm.skipping() then
		return skip(1)
	end
	event.FuncPointShow("", "e528", 0)
	helper_405042f0()
	if vm.skipping() then
		return skip(2)
	end
	return part2()
end

--- Program 560.
script[560] = function()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_435eb125()
			if not vm.skipping() then
				return part2()
			end
		end
	end
	function part2()
		event.BgmLoadCancel()
		event.LoadDungeonMapFile("s49")
		event.LoadScript("s49/s49.stb", 500)
	end
	event.Initialize()
	event.ActchrSetDefMotion(0)
	event.SetFadeOut(15)
	helper_c85a55f2(15)
	if vm.skipping() then
		return skip(1)
	end
	event.DelMonster(-1)
	event.ExtTyped(1078, "ii", 1, 1)
	event.SetCharaChangeFlag(1, 1)
	event.SetCharaChangeMask(1, 1)
	event.ExtTyped(1078, "ii", 3, 1)
	event.SetCharaChangeFlag(3, 1)
	event.SetCharaChangeMask(3, 1)
	helper_435eb125()
	if vm.skipping() then
		return skip(2)
	end
	return part2()
end

--- Program 561.
script[561] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.ResetEventTrg()
	helper_56b42349()
	if vm.skipping() then
		return skip(1)
	end
	event.FuncPointShow("", "e528", 0)
	event.FuncPointShow("d05", "func", 0)
	event.FuncPointShow("p01", "invent_2023-1", 1)
	event.EohSyncObj(0, "d05", "d05ba03-a")
	event.EohSetShow(0, 1)
	event.EohSyncObj(0, "d05", "d05b01_1", "takil")
	event.EohSetTranslate(0, -330.0, 0.0, 200.0)
	event.EohSyncObj(0, "d05", "d05b01_1", "takir")
	event.EohSetTranslate(0, 330.0, 0.0, 200.0)
	event.LoadMonsterFile(511, 1)
	event.AutoSetMonster(511, 0.0, 0.0, -200.0, 0.0, 0.0, 0.0)
	event.SetCharaPos(0, 0.0, 0.0, 300.0)
	event.SetCharaRot(0, 0.0, 3.14, 0.0)
	event.SetMotion(0, "立ち", 4)
	event.SetCameraPos(0.0, 40.0, 420.0)
	event.SetCameraRef(0.0, 30.0, 300.0)
	event.ResetCamera(0)
	event.SetFadeIn(15)
	event.Finish()
end

--- Program 570.
script[570] = function()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_d8ef09af()
			if not vm.skipping() then
				return part2()
			end
		end
	end
	function part2()
		event.SetFloorInfo(4, 22, 5, 2)
		event.BgmLoadCancel()
		event.LoadDungeonMapFile("s49")
		event.LoadScript("s49/s49.stb", 510)
	end
	event.Initialize()
	event.ActchrSetDefMotion(0)
	event.FadeOutBgm(0)
	event.SetFadeOut(15)
	helper_c85a55f2(15)
	if vm.skipping() then
		return skip(1)
	end
	event.StopBgm(0)
	event.DelMonster(-1)
	helper_d8ef09af()
	if vm.skipping() then
		return skip(2)
	end
	return part2()
end

--- Program 571.
script[571] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetBitCtrl(1, 0)
	event.ResetEventTrg()
	helper_472a898f()
	if vm.skipping() then
		return skip(1)
	end
	event.GotoEdit(3, 500)
end

--- Program 600.
script[600] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_c85a55f2(4)
		end
	end
	event.Initialize()
	if vm.wait() then
		return skip(1)
	end
	event.StopBgm(0)
	helper_c85a55f2(4)
	if vm.skipping() then
		return skip(2)
	end
	event.LoadBgm(35)
	event.PlayBgm(0)
	event.FuncPointShow("d05", "func", 0)
	event.FuncPointShow("", "e528", 0)
	event.LoadMonsterFile(511, 1)
	event.AutoSetMonster(511, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
	event.Finish()
end

--- Program 1200.
script[1200] = function()
	local value: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_4c3a889a(0, 8540070)
			end
			return
		end
		if at <= 4 then
			if at <= 3 then
				helper_4c3a889a(0, 8530110)
			end
			return
		end
	end
	flag = event.GetFlag(532) or flag
	flag_2 = event.GetFlag(536) or flag_2
	if flag ~= 0 and flag_2 == 0 then
		value = 0
		value = event.GetRandInt(100) or value
		if value < 50 then
			helper_4c3a889a(0, 8540060)
			if vm.skipping() then
				return skip(1)
			end
		else
			helper_4c3a889a(0, 8540070)
			if vm.skipping() then
				return skip(2)
			end
		end
		return
	end
	flag_3 = event.GetFlag(528) or flag_3
	if flag_3 ~= 0 and flag == 0 then
		value = 0
		value = event.GetRandInt(100) or value
		if value < 50 then
			helper_4c3a889a(0, 8530100)
			if vm.skipping() then
				return skip(3)
			end
		else
			helper_4c3a889a(0, 8530110)
			if vm.skipping() then
				return skip(4)
			end
		end
		return
	end
	helper_00eed993(0)
	if vm.skipping() then
		return skip(5)
	end
end

--- Program 15260.
script[15260] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.StopBgm(0)
	helper_33122428()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 15280.
script[15280] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_405042f0()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 15320.
script[15320] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_435eb125()
	if vm.skipping() then
		return skip(1)
	end
	event.BgmLoadCancel()
	event.LoadDungeonMapFile("s49")
	event.LoadScript("s49/s49.stb", 500)
end

--- Program 15360.
script[15360] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_d8ef09af()
	if vm.skipping() then
		return skip(1)
	end
	event.BgmLoadCancel()
	event.LoadDungeonMapFile("s49")
	event.LoadScript("s49/s49.stb", 510)
end

--- Program 25020.
script[25020] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_c85a55f2(4)
		end
	end
	event.Initialize()
	if vm.wait() then
		return skip(1)
	end
	event.StopBgm(0)
	helper_c85a55f2(4)
	if vm.skipping() then
		return skip(2)
	end
	event.LoadBgm(190)
	event.PlayBgm(0)
	event.FuncPointShow("", "e528", 0)
	event.LoadMonsterFile(512, 1)
	event.AutoSetMonster(512, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
	event.Finish()
end

return script
