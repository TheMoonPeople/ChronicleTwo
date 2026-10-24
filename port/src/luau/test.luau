--!strict
-- test.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_2484(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Ext(800, 0, arg0, arg1) -- retail: command 800 is not registered
	event.MesMake_2(0, arg1)
	if vm.wait() then
		return skip(1)
	end
end

--- Helper function.
local function helper_1614(arg0: f32, arg1: f32, arg2: f32, arg3: f32)
	local skip: (number) -> ...any
	function skip(at: number)
		return vm.f32(vm.f32(vm.fdiv(vm.f32(vm.f32(arg1 - arg0) * arg2), arg3)) + arg0)
	end
	if vm.skipping() then
		return skip(1)
	end
	return vm.f32(vm.f32(vm.fdiv(vm.f32(vm.f32(arg1 - arg0) * arg2), arg3)) + arg0)
end

--- Helper function.
local function helper_7e8(arg0: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			arg0 = vm.wrap(arg0 - 1)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	while arg0 >= 0 do
		arg0 = arg0 - 1
		if vm.wait() then
			return skip(2)
		end
	end
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 0.
script[0] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_2484(2, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 1.
script[1] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_2484(3, 1)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 2.
script[2] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_2484(4, 2)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 3.
script[3] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_2484(5, 3)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 4.
script[4] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_2484(6, 4)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 5.
script[5] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_2484(7, 5)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 100.
script[100] = function()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var10: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var0 = 0.0
			var1 = 300.0
			var0 = vm.f32(var0 + 1.0)
		end
		if at <= 2 then
			var2 = vm.f32(203.3)
			var5 = vm.f32(71.9)
			var3 = vm.f32(97.4)
			var6 = vm.f32(146.2)
			var4 = -51.0
			var7 = vm.f32(58.4)
			var0 = 0.0
			var1 = 300.0
			var8 = helper_1614(var2, var5, var0, var1)
			local _ = helper_1614(var3, var6, var0, var1)
			var10 = helper_1614(var4, var7, var0, var1)
			var0 = vm.f32(var0 + 1.0)
		end
	end
	event.Initialize()
	if vm.wait() then
		return skip(1)
	end
	var0 = 0.0
	var1 = 300.0
	while var0 <= var1 do
		event.SetCameraPos(168.64, 58.93, -170.8)
		event.SetCameraRef(134.38, 0.0, 16.4)
		var0 = vm.f32(var0 + 1.0)
		if vm.wait() then
			return skip(2)
		end
	end
	event.AsqInit(0)
	event.AsqSyncChara(0, 3)
	event.AsqSetPos(0, 203.3, 0, -51.0)
	event.AsqSetRot(0, 0.0)
	event.AsqMotionPlay(0, "歩き")
	event.AsqMotionTrg(0)
	event.AsqRotRef(0, 71.9, 0, 58.4, 0.1)
	event.AsqMove(0, 71.9, 0, 58.4, 100)
	event.AsqMotionPlay(0, "立ち")
	event.AsqMotionTrg(0)
	var2 = vm.f32(203.3)
	var5 = vm.f32(71.9)
	var3 = vm.f32(97.4)
	var6 = vm.f32(146.2)
	var4 = -51.0
	var7 = vm.f32(58.4)
	var0 = 0.0
	var1 = 300.0
	while var0 <= var1 do
		var8 = helper_1614(var2, var5, var0, var1)
		local _ = helper_1614(var3, var6, var0, var1)
		var10 = helper_1614(var4, var7, var0, var1)
		event.SetCameraRef(var8, 0, var10)
		var0 = vm.f32(var0 + 1.0)
		if vm.wait() then
			return skip(3)
		end
	end
end

--- Program 200.
script[200] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_7e8(10)
	if vm.skipping() then
		return skip(1)
	end
	event.GotoInterior(-1, "i01h01", 123)
end

--- Program 201.
script[201] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_7e8(10)
	if vm.skipping() then
		return skip(1)
	end
	event.GotoInterior(-1, "i02h01", 123)
end

return script
