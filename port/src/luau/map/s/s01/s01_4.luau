--!strict
-- map/s/s01/s01_4.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0c718064 = require("@lib/event/helper_0c718064")
local helper_1f378ea6 = require("@lib/event/helper_1f378ea6")
local helper_4597bc67 = require("@lib/event/helper_4597bc67")
local helper_48c23086 = require("@lib/event/helper_48c23086")
local helper_7d9e902a = require("@lib/event/helper_7d9e902a")
local helper_951d9474 = require("@lib/event/helper_951d9474")
local helper_a26e53e3 = require("@lib/event/helper_a26e53e3")
local helper_c1c32f84 = require("@lib/event/helper_c1c32f84")
local helper_d2316041 = require("@lib/event/helper_d2316041")
local helper_fc987dac = require("@lib/event/helper_fc987dac")

--- Program 99.
local function program_99()
	local flag: s32 = 0
	flag = event.GetFlag(202) or flag
	if flag == 0 then
		event.Initialize()
		event.EohSyncObj(0, "p01_train01")
		event.EohSetPos(0, 0.0, 0.0, -2000.0)
	end
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

script[99] = program_99

--- Program 100.
script[100] = function()
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_7d9e902a()
		end
		helper_4597bc67()
	end
	program_99()
	flag = event.GetFlag(201) or flag
	if flag == 0 then
		event.SetFloorInfo(0, 8, 7, 1)
		event.SetFloorInfo(0, 8, 5, 2)
		helper_fc987dac()
		if vm.skipping() then
			return skip(1)
		end
	else
		helper_7d9e902a()
		if vm.skipping() then
			return skip(2)
		end
	end
	helper_4597bc67()
end

--- Program 150.
script[150] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_d2316041()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 160.
script[160] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetFadeOut(30, 255.0, 255.0, 255.0)
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(1)
	end
	event.MapJump(-1, "g02")
end

--- Program 501.
script[501] = function()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_1f378ea6()
			if not vm.skipping() then
				return part2()
			end
		end
	end
	function part2()
		event.BgmLoadCancel()
		event.MapJump(-1, "s08", 501)
		if vm.wait() then
			return skip(3)
		end
	end
	event.Initialize()
	event.SetMotion(0, "立ち", 4)
	event.SetFadeOut(30)
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(1)
	end
	helper_1f378ea6()
	if vm.skipping() then
		return skip(2)
	end
	return part2()
end

--- Program 502.
script[502] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		helper_4597bc67()
	end
	helper_0c718064(2)
	helper_fc987dac()
	if vm.skipping() then
		return skip(1)
	end
	helper_4597bc67()
end

--- Program 600.
script[600] = function()
	local var1: any = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 4 then
			if at <= 1 then
				helper_c1c32f84(15)
			end
			if at <= 2 then
				helper_c1c32f84(30)
			end
			if at <= 3 then
				helper_48c23086()
			end
			return 1
		end
		var5 = var5 + 1
		return 0
	end
	event.Initialize()
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.SetMotion(0, "立ち", 4)
	var1 = helper_a26e53e3(5, 55)
	if vm.skipping() then
		return skip(1)
	end
	if var1 == 0 then
		event.CmrsSetPos(-637.75, 234.47, 94.15)
		event.CmrsSetRef(-573.29, 154.14, -234.77)
		event.ObjsSetPos(0, -571.45, 132.37, -243.31)
		event.ObjsSetRot(0, 0.0, -3.14, 0.0)
		event.ObjsSetMotion(0, "走り", 4)
		event.CmrsMove(-637.75, 234.47, 94.15, -561.56, 145.42, -381.61, 45)
		event.ObjsMove(0, -570.49, 132.37, -362.93, 45)
		helper_c1c32f84(15)
		if vm.skipping() then
			return skip(2)
		end
		event.SetFadeOut(30)
		helper_c1c32f84(30)
		if vm.skipping() then
			return skip(3)
		end
		helper_48c23086()
		if vm.skipping() then
			return skip(4)
		end
		return 1
	end
	do
		local out1, out2, out3 = event.GetCharaPos(0)
		var2 = out1 or var2
		var3 = out2 or var3
		var4 = out3 or var4
	end
	var2 = vm.f32(var2 + vm.f32(30.0 * vm.sin(0.0)))
	var4 = vm.f32(var4 + vm.f32(30.0 * vm.cos(0.0)))
	event.ObjsSetMotion(0, "歩き", 4, -1.0, 1)
	event.ObjsRotation(0, 0.0, 0.0, 0.0, 15)
	event.ObjsMove(0, var2, var3, var4, 45)
	var5 = 0
	while var5 < 45 do
		do
			local out1, out2, out3 = event.GetCharaPos(0)
			var2 = out1 or var2
			var3 = out2 or var3
			var4 = out3 or var4
		end
		event.CmrsSetRef(var2, var3 + 30.0, var4)
		if vm.wait() then
			return skip(5)
		end
		var5 = var5 + 1
	end
	event.ObjsSetMotion(0, "立ち", 4, -1.0, 1)
	return 0
end

--- Program 601.
script[601] = function()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var3 = var3 + 1
			helper_951d9474(0, -1, 5, 0, 0)
		end
	end
	event.Initialize()
	event.SetMesWindowMode(0, 1)
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.SetMotion(0, "立ち", 4)
	do
		local out1, out2, out3 = event.GetCharaPos(0)
		var0 = out1 or var0
		var1 = out2 or var1
		var2 = out3 or var2
	end
	var0 = vm.f32(var0 + vm.f32(30.0 * vm.sin(vm.f32(3.1415927))))
	var2 = vm.f32(var2 + vm.f32(30.0 * vm.cos(vm.f32(3.1415927))))
	event.ObjsSetMotion(0, "歩き", 4, -1.0, 1)
	event.ObjsRotation(0, 0.0, 3.1415927, 0.0, 15)
	event.ObjsMove(0, var0, var1, var2, 45)
	var3 = 0
	while var3 < 45 do
		do
			local out1, out2, out3 = event.GetCharaPos(0)
			var0 = out1 or var0
			var1 = out2 or var1
			var2 = out3 or var2
		end
		event.CmrsSetRef(var0, var1 + 30.0, var2)
		if vm.wait() then
			return skip(1)
		end
		var3 = var3 + 1
	end
	event.ObjsSetMotion(0, "立ち", 4, -1.0, 1)
	event.SetMesShippo(0, 0)
	event.MesMake_2(0, "[UNI00c8] pericoloso andare oltre.\nPrendiamo il treno.")
	helper_951d9474(0, -1, 5, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.SetMesShippo(0, 1)
end

--- Program 610.
script[610] = function()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_1f378ea6()
			if not vm.skipping() then
				return part2()
			end
		end
	end
	function part2() end
	event.Initialize()
	event.SetMotion(0, "立ち", 4)
	event.SetFadeOut(30)
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(1)
	end
	helper_1f378ea6()
	if vm.skipping() then
		return skip(2)
	end
	return part2()
end

--- Program 12010.
script[12010] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_fc987dac()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 12020.
script[12020] = function()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_1f378ea6()
			if not vm.skipping() then
				return part2()
			end
		end
		if at <= 2 then
			helper_c1c32f84(30)
		end
	end
	function part2()
		event.SetFadeOut(30)
		helper_c1c32f84(30)
		if vm.skipping() then
			return skip(3)
		end
		event.BgmLoadCancel()
		event.MapJump(-1, "s08", 501)
		if vm.wait() then
			return skip(4)
		end
	end
	event.Initialize()
	event.SetMotion(0, "立ち", 4)
	event.SetFadeOut(30)
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(1)
	end
	helper_1f378ea6()
	if vm.skipping() then
		return skip(2)
	end
	return part2()
end

return script
