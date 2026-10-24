--!strict
-- map/s/s42/s42_3.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0b78fea7 = require("@lib/event/helper_0b78fea7")
local helper_0cbe7543 = require("@lib/event/helper_0cbe7543")
local helper_387dadc7 = require("@lib/event/helper_387dadc7")
local helper_3d97589d = require("@lib/event/helper_3d97589d")
local helper_447ed33f = require("@lib/event/helper_447ed33f")
local helper_560b882f = require("@lib/event/helper_560b882f")
local helper_5a5f085f = require("@lib/event/helper_5a5f085f")
local helper_8a3120fd = require("@lib/event/helper_8a3120fd")
local helper_a0e17f3c = require("@lib/event/helper_a0e17f3c")
local helper_f503d904 = require("@lib/event/helper_f503d904")

--- Helper function.
local function helper_e93c()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var4: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local yaw: f32 = 0
	local var14: s32 = 0
	local var15: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_0cbe7543(0, -1, 9, 0, 0)
		end
	end
	event.Initialize()
	event.SetMesWindowMode(0, 1)
	event.SetMesShippo(0, 1)
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.EohSyncChara(1, 9)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	do
		local out1, out2, out3 = event.GetCharaPos(0)
		var0 = out1 or var0
		var1 = out2 or var1
		var2 = out3 or var2
	end
	do
		local _, out2, _ = event.GetCharaRot(0)
		var4 = out2 or var4
	end
	do
		local out1, out2, out3 = event.GetCharaPos(9)
		var6 = out1 or var6
		var7 = out2 or var7
		var8 = out3 or var8
	end
	event.GetCharaRot(9)
	yaw = event.GetRefAngle(var0, var1, var2, var6, var7, var8) or yaw
	event.GetRefAngle(var6, var7, var8, var0, var1, var2)
	var14 = 0
	var15 = event.AngleCmp(var4, yaw, 0.1) or var15
	if var15 ~= 0 then
		event.ObjsRotation(0, 0.0, yaw, 0.0, 10)
		event.ObjsSetMotion(0, "歩き")
		event.ObjsMotionDelay(0, 10)
		var14 = 20
	end
	event.ObjsSetMotion(0, "立ち")
	helper_a0e17f3c(var14)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, "Sieh auf dem Schreibtisch unten\nnach. Mach dich ran!")
	helper_0cbe7543(0, -1, 9, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 99.
-- Defined empty, so the engine runs this instead of its default.
script[99] = function() end

--- Program 100.
script[100] = function()
	helper_387dadc7()
	event.CheckMcLoad()
	event.SetTimeStepEnable(0)
	event.SetCharaPos(0, 49.9, 24.7, -68.2)
	event.SetCharaRot(0, 0.0, 0.0, 0.0)
	event.SetMotion(0, "立ち", 4)
	event.CharaNormalDrive(0)
	event.CharaResetDa(0)
end

--- Program 150.
-- Defined empty, so the engine runs this instead of its default.
script[150] = function() end

--- Program 200.
script[200] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	event.SetMotion(0, "立ち")
	event.SetMesWindowMode(0, 1)
	event.SetMesShippo(0, 0)
	event.MesMake_2(0, "Du hast Cedrics Auftrag\nnoch nicht erf[UNI00fc]llt.")
	helper_560b882f(0, -1, 5, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 400.
script[400] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_5a5f085f()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 500.
script[500] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetCnt(5, 0)
	helper_447ed33f()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 501.
script[501] = function()
	local var0: s32 = 0
	local argc: s32 = 0
	local var2: any = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	local landing1: () -> ...any
	function skip(at: number)
		if at <= 1 then
			var2 = helper_3d97589d(0, -1, 5, 256, 208, 2, 1)
		end
		if at <= 2 then
			var0 = 1
			var2 = helper_3d97589d(0, -1, 5, 256, 208, 2, 1)
		end
		if at <= 3 then
			var0 = 1
			helper_0b78fea7()
			if not vm.skipping() then
				return landing1()
			end
		end
	end
	function part2() end
	function landing1()
		event.MapJump(-1, "m06", 151)
		return part2()
	end
	event.Initialize()
	event.SetMotion(0, "立ち")
	var0 = 0
	event.SetMesWindowMode(0, 1)
	event.SetMesShippo(0, 0)
	event.SetMesQuestionGyou(0, 0)
	argc = event.GetItemHaveNum(382) or argc
	if argc <= 0 then
		event.MesMake_2(0, "Ich glaube, das Werkzeug\nwar in dem Schrank dort hinten...")
		helper_560b882f(0, -1, 5, 0, 0)
		if vm.skipping() then
			return skip(1)
		end
	else
		event.SetMesQuestionGyou(0, 1)
		event.SetMesEtc(0, 0, 1)
		event.SetMesEtc(0, 1, 1)
		argc = event.GetItemHaveNum(386) or argc
		if argc <= 0 then
			event.MesMake_2(0, "Das ist wohl Gables Staubsauger.\nEr sieht unfertig aus.\nNa dann mal los!")
			var2 = helper_3d97589d(0, -1, 5, 256, 208, 2, 1)
			if vm.skipping() then
				return skip(2)
			end
			if var2 == 2 then
				var0 = 1
			end
		else
			event.MesMake_2(
				0,
				"Das ist wohl Gables Staubsauger.\nNa gut! Dann reparieren wir ihn mal!\nAch nein, ich mach's sp[UNI00e4]ter."
			)
			var2 = helper_3d97589d(0, -1, 5, 256, 208, 2, 1)
			if vm.skipping() then
				return skip(3)
			end
			if var2 == 1 then
				var0 = 1
			end
		end
		event.SetMesEtc(0, 0, 0)
		event.SetMesEtc(0, 1, 0)
		event.SetMesQuestionGyou(0, 0)
	end
	event.SetMesShippo(0, 1)
	if var0 == 1 then
		helper_0b78fea7()
		if vm.skipping() then
			return skip(4)
		end
		event.MapJump(-1, "m06", 151)
	end
	return part2()
end

--- Program 502.
script[502] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_f503d904()
	if vm.skipping() then
		return skip(1)
	end
	event.MapJump(-1, "m08", 151)
end

--- Program 510.
script[510] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_e93c()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 520.
script[520] = function()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_8a3120fd(382, 1)
		end
	end
	event.Initialize()
	do
		local out1, out2, out3 = event.GetEventData_4(10)
		var0 = out1 or var0
		var1 = out2 or var1
		var2 = out3 or var2
	end
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetMotion(0, "歩き")
	event.ObjsMotionDelay(0, 10)
	event.ObjsSetMotion(0, "立ち")
	event.ObjsReference(0, var0, var1, var2, 10)
	helper_a0e17f3c(10)
	if vm.skipping() then
		return skip(1)
	end
	helper_8a3120fd(382, 1)
	if vm.skipping() then
		return skip(2)
	end
	event.AddItem(382)
	event.FuncPointShow("", "item1", 0)
end

--- Program 521.
script[521] = function()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_8a3120fd(386, 1)
		end
	end
	event.Initialize()
	do
		local out1, out2, out3 = event.GetEventData_4(10)
		var0 = out1 or var0
		var1 = out2 or var1
		var2 = out3 or var2
	end
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetMotion(0, "歩き")
	event.ObjsMotionDelay(0, 10)
	event.ObjsSetMotion(0, "立ち")
	event.ObjsReference(0, var0, var1, var2, 10)
	helper_a0e17f3c(10)
	if vm.skipping() then
		return skip(1)
	end
	event.EohSyncObj(1, "memo")
	event.EohSetShow(1, 0)
	helper_8a3120fd(386, 1)
	if vm.skipping() then
		return skip(2)
	end
	event.AddItem(386)
	event.FuncPointShow("", "item2", 0)
end

--- Program 550.
script[550] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	event.SetMotion(0, "立ち")
	event.SetMesWindowMode(0, 1)
	event.SetMesShippo(0, 0)
	event.MesMake_2(
		0,
		"Sieht aus, als g[UNI00e4]be es da ein\nrecht wichtiges Buch, aber du wei[UNI00df]t noch\nnicht genug dar[UNI00fc]ber."
	)
	helper_560b882f(0, -1, 5, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

return script
